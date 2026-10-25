'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),abilities=require('../game/ship-abilities'),expanded=require('../game/ship-abilities-expanded'),launcher=require('../game/hellstorm'),inventory=require('../game/inventory'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let db,fixtures;
beforeEach(()=>{database.close();db=database.open(':memory:');fixtures=[];});
afterEach(()=>{for(const f of fixtures)f.w.removeSession(f.s);database.close();});
function fixture(ship='ship_tartarus'){
 const id=players.createPlayer(players.createAccount('tartarus-'+fixtures.length,'qa-pass'),'Tartarus QA',1,{...config.starter,ship}),w=new World(config),commands=[],s={world:w,send(){}};w.login(s,id);Object.assign(w.player,{x:6000,y:6000});const combat=new Combat(w,(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(decoded.obj);});combat.map=maps.getMap(1);const f={id,w,s,p:w.player,combat,commands};fixtures.push(f);return f;
}
const menu=(plus,kind)=>`ability_tartarus${plus?'-plus':''}_${kind}${plus?'-plus':''}`;
const use=(f,id,now=100000)=>abilities.action(f.s,{menuItemId:id,actionType:1},now);
function add(f,id,amount=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,amount).lastInsertRowid);}
function equip(f,id,slotset='heavy_guns',configId=1){inventory.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[id],configId},to:{target:'ship',slotset,configId}});}
function target(f){return f.combat.spawn({typeId:84,name:'Tartarus target',hitpoints:1000000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{}},{x:6200,y:6000});}
test('native Tartarus/Plus speed toggle changes movement and laser damage only, with ten-second switch lock',()=>{
 for(const [plus,speed,damage]of [[false,1.3,.95],[true,1.45,.75]]){
  const f=fixture(plus?'ship_tartarus-plus':'ship_tartarus'),id=menu(plus,'speed-boost'),base=f.p.speed;
  assert.equal(abilities.buildInit(f.w,100000).filter(c=>c._==='MenuItemStatusCommand'&&c.visible).length,2);
  f.w.movement={x:6000,y:6000,targetX:10000,targetY:6000,start:100000,duration:4000/base*1000};
  assert.equal(use(f,id),true);assert.equal(f.p.speed,Math.round(base*speed));assert.equal(abilities.outgoing(f.w,10000),10000*damage);assert.equal(f.p.stats.rocketMultiplier,1);
  assert.equal(f.w.movement.duration,4000/f.p.speed*1000);assert.equal(use(f,id,109999),false);assert.equal(expanded.status(f.w,id,{},109999).activatable,false);
  assert.equal(use(f,id,110000),true);assert.equal(f.p.speed,base);assert.equal(abilities.outgoing(f.w,10000),10000);assert.equal(use(f,id,119999),false);assert.equal(use(f,id,120000),true);
  assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===0&&c.activated));assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===0&&!c.activated));
 }
});
test('toggle replays after map teardown and login, retains cooldown, never compounds speed and clears on death',()=>{
 const f=fixture(),id=menu(false,'speed-boost'),base=f.p.speed;use(f,id);abilities.stop(f.w,{now:101000});assert.equal(f.p.speed,base);
 f.p.mapId=2;let init=abilities.buildInit(f.w,102000);assert.equal(f.p.speed,Math.round(base*1.3));assert.ok(init.some(c=>c._==='VisualModifierCommand'&&c.activated));assert.ok(init.some(c=>c._==='MenuItemStatusCommand'&&c.menuItemId===id&&c.selected&&!c.activatable));
 abilities.buildInit(f.w,103000);assert.equal(f.p.speed,Math.round(base*1.3));assert.equal(use(f,id,109999),false);
 f.w.removeSession(f.s);f.w.login(f.s,f.id);f.p=f.w.player;abilities.buildInit(f.w,104000);assert.equal(f.p.speed,Math.round(base*1.3));
 f.p.dead=true;abilities.stop(f.w,{now:105000});f.p.dead=false;abilities.buildInit(f.w,106000);assert.equal(f.p.speed,base);assert.equal(expanded.outgoing(f.w,100),100);
});
test('changing hull removes saved toggle, active config refresh keeps only one speed multiplier',()=>{
 const f=fixture(),id=menu(false,'speed-boost');use(f,id);f.w.refreshStats();const base=players.loadPlayer(f.id).speed;assert.equal(f.p.speed,Math.round(base*1.3));
 abilities.stop(f.w,{now:120000});db.prepare("UPDATE ships SET loot_id='ship_goliath' WHERE id=?").run(f.p.shipId);abilities.buildInit(f.w,120000);db.prepare("UPDATE ships SET loot_id='ship_tartarus' WHERE id=?").run(f.p.shipId);abilities.buildInit(f.w,130000);assert.equal(expanded.outgoing(f.w,100),100);
});
test('toggle storage failure rolls back cooldown and leaves movement/damage unchanged',()=>{
 const f=fixture(),id=menu(false,'speed-boost'),base=f.p.speed;
 db.exec("CREATE TRIGGER deny_toggle BEFORE INSERT ON settings WHEN NEW.key='game.shipAbilityToggles' BEGIN SELECT RAISE(ABORT,'toggle-storage'); END");
 assert.throws(()=>use(f,id),/toggle-storage/);assert.equal(f.p.speed,base);assert.equal(f.w.expandedAbilityRuns.size,0);assert.equal(db.prepare("SELECT value FROM settings WHERE player_id=? AND key='game.expandedShipCooldowns'").get(f.id),undefined);
});
test('rapid fire instantly fills partial reload and delivers three five-round salvos, no fourth at expiry',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-2'));add(f,'ammunition_rocketlauncher_eco-10',30);const n=target(f);f.combat.rollHit=()=>true;
 launcher.reload(f.w);const st=launcher.state(f.w);assert.ok(st.reloadAt);assert.equal(st.loaded,0);assert.equal(use(f,menu(false,'rapid-fire')),true);assert.equal(st.loaded,5);assert.equal(st.reloadAt,0);
 for(const now of [100000,101000,102000]){assert.equal(launcher.fire(f.s,n.id,now),true);assert.equal(st.nextFire,now+1000);assert.equal(launcher.fire(f.s,n.id,now+999),false);}
 assert.equal(launcher.count(f.p,st.ammo),15);assert.equal(launcher.fire(f.s,n.id,103000),false);assert.equal(launcher.count(f.p,st.ammo),15);
 t.mock.timers.tick(2000);assert.equal(n.hp,970000);assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,3);
 abilities.tick(f.w,f.combat,103000);assert.equal(expanded.launcher(f.w,103000),null);assert.equal(use(f,menu(false,'rapid-fire'),123999),false);assert.equal(use(f,menu(false,'rapid-fire'),124000),true);
});
test('Hecate official passive applies seven percent damage and ten percent shields without enabling its PvP beam against NPCs',()=>{
 const base={laserDamage:10000,shieldMax:10000,hitMax:10000,rocketMultiplier:1},stats=require('../game/ship-passives').applyStats('ship_hecate',base);
 assert.equal(stats.laserDamage,10700);assert.equal(stats.shieldMax,11000);assert.equal(stats.rocketMultiplier,1.07);assert.equal(stats.hitMax,10000);
 const f=fixture('ship_hecate');assert.equal(abilities.buildInit(f.w).filter(c=>c._==='MenuItemStatusCommand'&&c.visible).length,0);
});
test('Plus rapid damage and free extra rocket apply to the actual salvo, including the final inventory round',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});t.mock.method(Math,'random',()=>0);const f=fixture('ship_tartarus-plus');equip(f,add(f,'equipment_weapon_rocketlauncher_hst-2'));equip(f,add(f,'equipment_weapon_rocketlauncher_hst-2'));add(f,'ammunition_rocketlauncher_eco-10',11);const n=target(f);f.combat.rollHit=()=>true;
 assert.equal(use(f,menu(true,'rapid-fire')),true);assert.equal(launcher.state(f.w).loaded,10);assert.equal(launcher.fire(f.s,n.id,100000),true);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),1);
 assert.equal(launcher.fire(f.s,n.id,101000),true);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),0);assert.equal(launcher.fire(f.s,n.id,102000),false);
 assert.deepEqual(f.commands.filter(c=>c._==='HellstormAttackCommand').map(c=>c.currentLoad),[11,2]);t.mock.timers.tick(2000);assert.equal(n.hp,1000000-13*2000*1.2);
});
test('Plus passive uses a strict twenty percent boundary, applies outside Rapid Fire, and normal Tartarus never gets it',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});let roll=.2;t.mock.method(Math,'random',()=>roll);
 for(const [ship,draw,load]of [['ship_tartarus-plus',.2,3],['ship_tartarus-plus',.199999,4],['ship_tartarus',0,3]]){
  const f=fixture(ship);equip(f,add(f,'equipment_weapon_rocketlauncher_hst-1'));add(f,'ammunition_rocketlauncher_eco-10',3);const n=target(f);f.combat.rollHit=()=>true;launcher.state(f.w).loaded=3;roll=draw;
  assert.equal(launcher.fire(f.s,n.id,100000),true);assert.equal(f.commands.find(c=>c._==='HellstormAttackCommand').currentLoad,load);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),0);t.mock.timers.tick(2000);assert.equal(n.hp,1000000-load*2000);
 }
});
test('automatic Rapid Fire needs equipped enabled CPU and real attack; stale/dead/jumping sessions cannot use abilities',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-2'));add(f,'ammunition_rocketlauncher_eco-10',20);const n=target(f);f.combat.rollHit=()=>true;
 use(f,menu(false,'rapid-fire'));f.s.attacking=n.id;launcher.tick(f.w,f.combat,100000);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),20);
 equip(f,add(f,launcher.CPU),'extras');launcher.action(f.s,{menuItemId:launcher.CPU});launcher.tick(f.w,f.combat,100000);launcher.tick(f.w,f.combat,101000);launcher.tick(f.w,f.combat,102000);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),5);
 const id=menu(false,'speed-boost');f.s.jumping=true;assert.equal(use(f,id),false);f.s.jumping=false;f.p.dead=true;assert.equal(use(f,id),false);f.p.dead=false;assert.equal(abilities.action({world:f.w,player:f.p},{menuItemId:id,actionType:1}),false);
});
