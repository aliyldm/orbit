'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),abilities=require('../game/ship-abilities'),expanded=require('../game/ship-abilities-expanded'),speed=require('../game/player-speed'),codec=require('../game/codec/codec'),config=require('../config');
let db,fixtures;
beforeEach(()=>{database.close();db=database.open(':memory:');fixtures=[];});
afterEach(()=>{for(const f of fixtures)f.w.removeSession(f.s);database.close();});
function fixture(ship='ship_zephyr'){
 const id=players.createPlayer(players.createAccount('momentum-'+fixtures.length,'qa-pass'),'Momentum QA',1,{...config.starter,ship}),w=new World(config),out=[],s={world:w,send(){}};w.login(s,id);Object.assign(w.player,{x:6000,y:6000});
 const combat=new Combat(w,(s,c)=>{const d=codec.decode(codec.encode(c));assert.equal(d.rest,0);out.push(d.obj);});combat.map=maps.getMap(1);const f={id,w,s,p:w.player,combat,out};fixtures.push(f);return f;
}
const menu='ability_zephyr_mmt',use=(f,now=100000,id=menu)=>abilities.action(f.s,{menuItemId:id,actionType:1},now);
function npc(f,x=6200){return f.combat.spawn({key:'momentum-qa',typeId:84,name:'Momentum QA',hitpoints:100000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{},transient:true},{x,y:6000});}
function kill(f){const n=npc(f);n.hp=0;f.combat.kill(f.s,n);return n;}
const counter=f=>expanded.status(f.w,menu,{},100000).counterValue;
test('only successfully rewarded NPC kills add native Momentum charges, capped at20',()=>{
 const f=fixture();assert.equal(counter(f),0);assert.equal(use(f),false);const first=kill(f);assert.equal(counter(f),1);f.combat.kill(f.s,first);assert.equal(counter(f),1);
 for(let i=0;i<25;i++)kill(f);assert.equal(counter(f),20);assert.equal(expanded.laserRange(f.w),700);
 assert.ok(f.out.some(c=>c._==='MenuItemStatusCommand'&&c.menuItemId===menu&&c.counterValue===20&&c.activatable));
 const row=f.out.findLast(c=>c._==='MenuItemStatusCommand'&&c.menuItemId===menu);assert.ok(row.toolTipItemBar.commandList.length>0,'counter refresh retains the original tooltip');
});
test('a reward-storage failure cannot produce Momentum charges or a false destruction',()=>{
 const f=fixture(),n=npc(f);n.hp=0;db.exec("CREATE TRIGGER deny_reward BEFORE UPDATE OF ep ON players BEGIN SELECT RAISE(ABORT,'momentum-reward'); END");
 assert.throws(()=>f.combat.kill(f.s,n),/momentum-reward/);assert.equal(counter(f),0);assert.equal(f.combat.npcs.get(n.id),n);assert.equal(f.out.some(c=>c._==='ShipDestroyedCommand'),false);db.exec('DROP TRIGGER deny_reward');
});
test('Momentum adds1.5percent per charge for20s and consumes the charges immediately',()=>{
 const f=fixture(),base=f.p.speed;kill(f);kill(f);assert.equal(use(f),true);assert.equal(counter(f),0);assert.equal(f.p.speed,Math.round(base*1.03));assert.equal(expanded.laserRange(f.w,600,100001),600);
 const status=expanded.status(f.w,menu,{},100001);assert.equal(status.selected,true);assert.equal(status.activatable,false);assert.equal(use(f,100001),false);
 abilities.tick(f.w,f.combat,120000);assert.equal(f.p.speed,base);assert.equal(use(f,120001),false);kill(f);assert.equal(use(f,120001),true,'no cooldown once a new charge exists');
});
test('Momentum speed remains capped750 through equipment refresh and restores the uncapped base on stop',()=>{
 const f=fixture();for(let i=0;i<20;i++)kill(f);speed.refresh(f.w,100000,{baseSpeed:700});assert.equal(use(f),true);assert.equal(f.p.speed,750);
 speed.refresh(f.w,101000,{baseSpeed:900});assert.equal(f.p.speed,750);abilities.tick(f.w,f.combat,120000);assert.equal(f.p.speed,900);
});
test('the extra range is enforced in real laser targeting and firing, then removed on activation',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});const f=fixture();for(let i=0;i<20;i++)kill(f);const n=npc(f,6650);f.p.stats.laserCount=1;
 assert.equal(f.combat.attack(f.s,n.id),true);assert.equal(f.s.attacking,n.id);assert.equal(use(f),true);f.p.nextLaserAt=0;assert.equal(f.combat.firePlayerLaser(f.s,101000),false);assert.equal(f.s.attacking,null);
 assert.ok(f.out.some(c=>c._==='AttackRangeExceededCommand'&&c.maxRange===600));
});
test('kills during Momentum accumulate new charges without applying the passive range until expiry',()=>{
 const f=fixture();kill(f);use(f);kill(f);kill(f);assert.equal(counter(f),2);assert.equal(expanded.laserRange(f.w,600,100001),600);abilities.tick(f.w,f.combat,120000);assert.equal(expanded.laserRange(f.w,600,120001),610);
});
test('charges are runtime-only, owned by their player/hull and retained on map rebuild',()=>{
 const f=fixture();kill(f);abilities.stop(f.w);f.p.mapId=2;assert.equal(counter(f),1);assert.equal(expanded.laserRange(f.w),605);
 const g=fixture();assert.equal(counter(g),0);assert.equal(expanded.laserRange(g.w),600);assert.equal(players.loadPlayer(f.id).userId,f.id);
 assert.equal(db.prepare("SELECT count(*) n FROM settings WHERE key LIKE '%Charges%'").get().n,0);
 const freshWorld=new World(config),s={world:freshWorld,send(){}};freshWorld.login(s,f.id);assert.equal(expanded.status(freshWorld,menu,{},100000).counterValue,0);freshWorld.removeSession(s);
});
test('a failed activation write cannot consume charges or change speed',()=>{
 const f=fixture(),base=f.p.speed;kill(f);db.exec("CREATE TRIGGER deny_momentum BEFORE INSERT ON settings WHEN NEW.key='game.expandedShipCooldowns' BEGIN SELECT RAISE(ABORT,'momentum-store'); END");assert.throws(()=>use(f),/momentum-store/);assert.equal(counter(f),1);assert.equal(f.p.speed,base);assert.equal(f.w.expandedAbilityRuns.size,0);db.exec('DROP TRIGGER deny_momentum');
});
test('Retiarus Supercharge uses tenpercent speed, ten seconds and300s cooldown without inventing an effect',()=>{
 const f=fixture('ship_retiarus'),base=f.p.speed,hp=f.p.hitPoints,shield=f.p.shield,id='ability_retiarus_spc';assert.equal(use(f,100000,id),true);assert.equal(f.p.speed,Math.round(base*1.1));assert.equal(f.p.hitPoints,hp);assert.equal(f.p.shield,shield);
 assert.ok(f.out.some(c=>c._==='MenuItemStatusCommand'&&c.menuItemId===id&&c.selected));assert.equal(f.out.some(c=>c._==='VisualModifierCommand'),false);speed.refresh(f.w,101000,{baseSpeed:500});assert.equal(f.p.speed,550);abilities.tick(f.w,f.combat,110000);assert.equal(f.p.speed,500);
 assert.equal(use(f,399999,id),false);assert.equal(use(f,400000,id),true);
});
