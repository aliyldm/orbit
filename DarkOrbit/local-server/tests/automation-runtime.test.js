'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),auto=require('../game/automation'),ammo=require('../game/ammo'),codec=require('../game/codec/codec');
let db,w,p,s,sent;
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('automation-qa','testpass'),'Auto',1,require('../config').starter);w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);p=w.player;sent=[];w.combat={send(s,c){assert.equal(codec.decode(codec.encode(c)).rest,0);sent.push(c);}};});
afterEach(()=>{w.combat=null;w.removeSession(s);database.close();});
function flags(value){db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,'GameplaySettingsModule',JSON.stringify(value));}
function stock(id,n){db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,id,n);}
function ore(type,n){db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=excluded.amount').run(p.userId,type,n);}
test('exhausted ammo switches only when enabled, consumes a whole real salvo and never buys ammunition',()=>{
 p.stats.laserCount=3;p.ammo='ammunition_laser_ucb-100';db.prepare("DELETE FROM items WHERE player_id=? AND loot_id LIKE 'ammunition_laser_%'").run(p.userId);stock('ammunition_laser_ucb-100',2);stock(ammo.DEFAULT_AMMO,6);flags({autoChangeAmmo:false});
 assert.equal(ammo.consume(p),false);assert.equal(ammo.count(p,'ammunition_laser_ucb-100'),2);const wallet=[p.credits,p.uridium];
 flags({autoChangeAmmo:true});assert.equal(ammo.consume(p),true);assert.equal(p.ammo,ammo.DEFAULT_AMMO);assert.equal(ammo.count(p),3);assert.equal(ammo.count(p,'ammunition_laser_ucb-100'),2);assert.deepEqual([p.credits,p.uridium],wallet);
 stock('ammunition_rocket_plt-2026',2);p.rocket='ammunition_rocket_plt-3030';assert.equal(auto.rocketAmmo(p),'ammunition_rocket_r-310');
 stock('ammunition_rocketlauncher_eco-10',4);assert.equal(auto.launcherAmmo(p,'ammunition_rocketlauncher_hstrm-01'),'ammunition_rocketlauncher_eco-10');
});
test('premium refinement and weapon enrichment obey each independent flag and preserve existing coatings',()=>{
 flags({autoRefinement:true,autoBoost:false});ore(0,200);ore(1,200);ore(2,200);ore(3,1);
 p.premium=false;assert.equal(auto.tick(w,1000,true),false);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=0').get(p.userId).amount,200);
 p.premium=true;assert.equal(auto.tick(w,1000,true),true);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=6').get(p.userId).amount,1);assert.equal(db.prepare('SELECT COUNT(*) n FROM player_ore_buffs').get().n,0);
 flags({autoRefinement:false,autoBoost:true});ore(7,3);assert.equal(auto.tick(w,2000,true),true);const coatings=db.prepare('SELECT * FROM player_ore_buffs ORDER BY item_type').all();assert.deepEqual(coatings.map(r=>[r.item_type,r.ore_type,r.remaining]),[[0,7,10],[1,7,10]]);
 assert.equal(auto.tick(w,3000,true),false);assert.deepEqual(db.prepare('SELECT * FROM player_ore_buffs ORDER BY item_type').all(),coatings);assert.ok(sent.some(c=>c._==='LabUpdateItemCommand'));
});
test('automatic green keys buy one owned key only on demand and cannot buy blue/red or duplicate charges',()=>{
 p.uridium=100000;p.credits=90;flags({autoBuyGreenBootyKeys:false});const box={boxType:'PIRATE_BOOTY'},price=require('../game/economy').offers(p.userId)['resource_booty-key'].price;
 assert.equal(auto.ensureBootyKey(w,box),false);flags({autoBuyGreenBootyKeys:true});assert.equal(auto.ensureBootyKey(w,{boxType:'PIRATE_BOOTY_BLUE'}),false);
 assert.equal(auto.ensureBootyKey(w,box),true);assert.equal(p.uridium,100000-price);assert.equal(auto.ensureBootyKey(w,box),true);assert.equal(p.uridium,100000-price);assert.equal(require('../game/loot-rewards').count(db,p.userId,'resource_booty-key'),1);
 assert.equal(db.prepare('SELECT credits FROM players WHERE id=?').get(p.userId).credits,90);
});
test('refinement fails atomically without turning partial resources into free products',()=>{
 ore(0,200);ore(1,200);ore(2,200);ore(3,1);const before=db.prepare('SELECT * FROM player_resources ORDER BY ore_type').all();
 db.exec("CREATE TRIGGER reject_auto_refine BEFORE INSERT ON player_resources WHEN NEW.ore_type=5 BEGIN SELECT RAISE(ABORT,'refine failure'); END");
 assert.throws(()=>auto.refine(p),/refine failure/);assert.deepEqual(db.prepare('SELECT * FROM player_resources ORDER BY ore_type').all(),before);
});

