'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),warp=require('../game/ship-warp'),gameplay=require('../game/gameplay'),codec=require('../game/codec/codec');
let db,w,p,s,sent,target,initial;
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('warp-qa','testpass'),'Warp',1,{...require('../config').starter,uridium:1000});w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);p=w.player;Object.assign(p,{x:9000,y:7000,lastCombat:0});initial=p.shipId;const row=db.prepare("SELECT hitpoints FROM ship_types WHERE loot_id='ship_goliath'").get();target=Number(db.prepare("INSERT INTO ships(player_id,loot_id,hitpoints,shield,favorite)VALUES(?,'ship_goliath',?,0,1)").run(id,row.hitpoints).lastInsertRowid);sent=[];const send=(s,c)=>{assert.equal(codec.decode(codec.encode(c)).rest,0);sent.push(c);};w.combat={send,stop(){},start(){}};gameplay.register(()=>{},{sendCmd:send,buildInit:()=>[],combatFor:()=>w.combat});});
afterEach(()=>{w.combat=null;w.removeSession(s);database.close();});
test('native ship list uses real owned favourite hulls and a successful10s warp preserves location/equipment and charges once',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const position=[p.mapId,p.x,p.y],items=db.prepare('SELECT * FROM items ORDER BY id').all();
 assert.equal(warp.windowCommand(w).ships[0].shipId,target);assert.equal(warp.show(s),true);assert.equal(warp.begin(s,target),true);const job=s.shipWarp;
 t.mock.timers.tick(9999);assert.equal(p.shipId,initial);assert.equal(p.uridium,1000);t.mock.timers.tick(1);assert.equal(p.shipId,target);assert.equal(p.uridium,800);assert.deepEqual([p.mapId,p.x,p.y],position);
 assert.equal(s.player,p);assert.equal(warp.complete(s,job),false);assert.equal(p.uridium,800);assert.deepEqual(db.prepare('SELECT * FROM items ORDER BY id').all(),items);
 assert.ok(sent.some(c=>c._==='ShipWarpCompletedCommand'));assert.ok(sent.some(c=>c._==='VisualModifierCommand'&&c.modifier===72&&c.attribute===10));
});
test('movement cancels immediately and an attack during countdown cannot debit or activate another ship',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});assert.equal(warp.begin(s,target),true);
 w.move(s,{positionX:p.x,positionY:p.y,targetX:p.x+100,targetY:p.y});assert.equal(s.shipWarp,null);t.mock.timers.tick(10000);assert.equal(p.shipId,initial);assert.equal(p.uridium,1000);
 w.stopMovement();assert.equal(warp.begin(s,target),true);p.lastCombat=Date.now()+1;t.mock.timers.tick(10000);assert.equal(p.shipId,initial);assert.equal(p.uridium,1000);assert.ok(sent.some(c=>c._==='ShipWarpCanceledCommand'));
});
test('one voucher is preferred away from base, base warp is free, and gate/dead/unowned targets are denied',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(p.userId,require('../game/jump-cpu').VOUCHER);
 assert.equal(warp.begin(s,target),true);t.mock.timers.tick(10000);assert.equal(p.uridium,1000);assert.equal(require('../game/jump-cpu').voucherCount(p),0);
 Object.assign(p,{x:2000,y:2000});assert.equal(warp.begin(s,initial),true);t.mock.timers.tick(10000);assert.equal(p.shipId,initial);assert.equal(p.uridium,1000);
 p.mapId=51;assert.equal(warp.begin(s,target),false);p.mapId=1;p.dead=true;assert.equal(warp.begin(s,target),false);p.dead=false;assert.equal(warp.begin(s,99999),false);
});
test('target invalidation and SQL failure during completion preserve old ship, money and voucher',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});assert.equal(warp.begin(s,target),true);db.prepare('UPDATE ships SET favorite=0 WHERE id=?').run(target);t.mock.timers.tick(10000);assert.equal(p.shipId,initial);assert.equal(p.uridium,1000);
 db.prepare('UPDATE ships SET favorite=1 WHERE id=?').run(target);assert.equal(warp.begin(s,target),true);db.exec("CREATE TRIGGER reject_warp BEFORE UPDATE OF active_ship_id ON players BEGIN SELECT RAISE(ABORT,'warp failure'); END");t.mock.timers.tick(10000);
 assert.equal(p.shipId,initial);assert.equal(p.uridium,1000);assert.equal(db.prepare('SELECT active_ship_id FROM players WHERE id=?').get(p.userId).active_ship_id,initial);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(p.userId).uridium,1000);
});

