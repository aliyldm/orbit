'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),crypto=require('node:crypto');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),abilities=require('../game/ship-abilities'),expanded=require('../game/ship-abilities-expanded'),codec=require('../game/codec/codec');
let db,fixtures=[];
beforeEach(()=>{database.close();db=database.open(':memory:');fixtures=[];});
afterEach(()=>{for(const f of fixtures)f.w.removeSession(f.s);database.close();});
function fixture(ship){const id=players.createPlayer(players.createAccount('expanded-'+fixtures.length,'testpass'),'QA',1,{...require('../config').starter,ship}),w=new World(require('../config')),commands=[],s={world:w,send(){}};w.login(s,id);const combat=new Combat(w,(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(decoded.obj);});combat.map=maps.getMap(1);Object.assign(w.player,{x:6000,y:6000});const f={id,w,s,p:w.player,combat,commands};fixtures.push(f);return f;}
const use=(f,menu,now=100000)=>abilities.action(f.s,{menuItemId:menu,actionType:1},now);
test('per-hull ability data is traceable and only actual equipped hull exposes implemented native buttons',()=>{
 const data=require('../game/data/ship-abilities.json');assert.equal(crypto.createHash('sha256').update(fs.readFileSync(data.source)).digest('hex'),data.sha256);assert.equal(Object.keys(data.ships).length,80);
 const f=fixture('ship_aegis'),menus=abilities.buildInit(f.w,100000).filter(c=>c.visible);assert.equal(menus.length,3);assert.ok(menus.every(c=>c.menuItemId.startsWith('ability_aegis_')));
 for(const c of abilities.buildInit(f.w,100000))codec.encode(c);
 assert.equal(use(f,'ability_solaris-plus_incinerate-plus'),false);
});
test('Aegis HP and shield beams run concurrently at exact source rate, interval and deadline',()=>{
 const f=fixture('ship_aegis');f.p.hitPoints=1000;f.p.shieldMax=200000;f.p.shield=0;
 assert.equal(use(f,'ability_aegis_hp-repair'),true);assert.equal(use(f,'ability_aegis_shield-repair'),true);
 abilities.tick(f.w,f.combat,100999);assert.equal(f.p.hitPoints,1000);assert.equal(f.p.shield,0);
 abilities.tick(f.w,f.combat,101000);assert.equal(f.p.hitPoints,21000);assert.equal(f.p.shield,15000);
 abilities.tick(f.w,f.combat,107000);assert.equal(f.p.hitPoints,141000);assert.equal(f.p.shield,75000);assert.equal(f.w.expandedAbilityRuns.size,0);
 assert.ok(f.commands.some(c=>c._==='AbilityEffectActivationCommand'&&c.selectedAbilityId===101&&c.targetIds.includes(f.id)));
 assert.equal(use(f,'ability_aegis_hp-repair',189999),false);assert.equal(use(f,'ability_aegis_hp-repair',190000),true);
});
test('Hammerclaw and Plus retain independent stronger values rather than copying Aegis',()=>{
 for(const [ship,hp,shield,duration]of [['ship_hammerclaw',25000,40000,7000],['ship_hammerclaw-plus',37500,50000,6000]]){
  const f=fixture(ship);f.p.hitPoints=1;f.p.shieldMax=200000;f.p.shield=0;
  assert.equal(use(f,'ability_aegis_hp-repair'),true);assert.equal(use(f,'ability_aegis_shield-repair'),true);abilities.tick(f.w,f.combat,101000);
  assert.equal(f.p.hitPoints,1+hp);assert.equal(f.p.shield,shield);assert.equal([...f.w.expandedAbilityRuns.values()].find(r=>r.def.kind==='hp').until,100000+duration);
 }
});
test('Aegis Elite uses embedded shorter beam and longer pod durations',()=>{
 const f=fixture('ship_a-elite');const defs=expanded.definitions(f.p);assert.equal(defs.find(d=>d.kind==='hp').duration,6000);assert.equal(defs.find(d=>d.kind==='shield').duration,4000);assert.equal(defs.find(d=>d.kind==='pod').duration,15000);assert.equal(defs.find(d=>d.kind==='hp').rate,20000);
});
test('healing pod is a stationary native asset: outside radius no heal, inside resumes and expiry removes it',()=>{
 const f=fixture('ship_aegis');f.p.hitPoints=1;assert.equal(use(f,'ability_aegis_repair-pod'),true);
 const created=f.commands.find(c=>c._==='AssetCreateCommand');assert.equal(created.type.typeValue,33);assert.equal(created.posX,6000);
 f.p.x=7000;abilities.tick(f.w,f.combat,101000);assert.equal(f.p.hitPoints,1);f.p.x=6000;abilities.tick(f.w,f.combat,102000);assert.equal(f.p.hitPoints,20001);
 abilities.tick(f.w,f.combat,110000);assert.ok(f.commands.some(c=>c._==='AssetRemoveCommand'&&c.uid===created.assetId));
});
test('Solace Plus heals50% of actual max HP, persists atomically and retains NanoHull',()=>{
 const f=fixture('ship_solace-plus');f.p.hitPoints=100;f.p.nanoHull=123;const expected=Math.min(f.p.hitMax,100+Math.round(f.p.hitMax*.5));
 assert.equal(use(f,'ability_solace-plus_nano-cluster-repairer-plus'),true);assert.equal(f.p.hitPoints,expected);assert.equal(f.p.nanoHull,123);assert.equal(players.loadPlayer(f.id).hitPoints,expected);
 assert.ok(f.commands.some(c=>c._==='AbilityEffectActivationCommand'&&c.selectedAbilityId===140));
});
test('failed instant healing persistence rolls back its cooldown and emits no fake activation',()=>{
 const f=fixture('ship_solace-plus');f.p.hitPoints=100;
 db.exec("CREATE TRIGGER plus_heal_fail BEFORE UPDATE OF hitpoints ON ships BEGIN SELECT RAISE(ABORT,'plus heal failed'); END");
 assert.throws(()=>use(f,'ability_solace-plus_nano-cluster-repairer-plus'),/plus heal failed/);assert.equal(f.p.hitPoints,100);assert.equal(f.commands.length,0);assert.equal(db.prepare("SELECT value FROM settings WHERE player_id=? AND key='game.expandedShipCooldowns'").get(f.id),undefined);db.exec('DROP TRIGGER plus_heal_fail');
});
test('Liberator Plus heals35k/sec for10seconds and cooldown survives session replacement',()=>{
 const f=fixture('ship_liberator-plus');f.p.hitPoints=1;assert.equal(use(f,'ability_liberator-plus_self-repair'),true);abilities.tick(f.w,f.combat,101000);assert.equal(f.p.hitPoints,35001);abilities.stop(f.w,{now:101000});
 assert.equal(use(f,'ability_liberator-plus_self-repair',199999),false);assert.equal(abilities.buildInit(f.w,199999).find(c=>c.menuItemId==='ability_liberator-plus_self-repair'&&c._==='MenuItemTimerCommand').time,1);
});
test('Solaris Plus area burn hits only live nearby unprotected NPCs; cooldown begins on toggle off',()=>{
 const f=fixture('ship_solaris-plus');const spawn=x=>f.combat.spawn({key:'local-test',typeId:84,name:'QA',hitpoints:100000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{}},{x,y:6000}),inside=spawn(6400),outside=spawn(6700);
 assert.equal(use(f,'ability_solaris-plus_incinerate-plus'),true);abilities.tick(f.w,f.combat,101000);assert.equal(inside.hp,85000);assert.equal(outside.hp,100000);
 assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===87&&c.activated));
 assert.equal(use(f,'ability_solaris-plus_incinerate-plus',102000),true);assert.equal(f.w.expandedAbilityRuns.size,0);assert.equal(use(f,'ability_solaris-plus_incinerate-plus',181999),false);assert.equal(use(f,'ability_solaris-plus_incinerate-plus',182000),true);
});
test('Citadel Plus reduces laser damage80% while rocket damage remains normal and map/death clear effects',()=>{
 const f=fixture('ship_citadel-plus');assert.equal(use(f,'ability_citadel-plus_prismatic-endurance'),true);
 let state={hp:10000,shield:10000};assert.equal(abilities.incoming(f.w,state,1000,.8,1),200);assert.deepEqual(state,{hp:9960,shield:9840});state={hp:10000,shield:10000};assert.equal(abilities.incoming(f.w,state,1000,.8,2),1000);
 f.s.jumping=true;abilities.tick(f.w,f.combat,101000);assert.equal(f.w.expandedAbilityRuns.size,0);assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===105&&!c.activated));
});
test('Solaris Plus module passive and Solace Plus shield passive affect actual stat pipeline',()=>{
 const passives=require('../game/ship-passives'),base={hitMax:1000,shieldMax:1000,laserDamage:100,rocketMultiplier:1,shipModules:{damage:.04}};
 assert.ok(Math.abs(passives.applyStats('ship_solaris-plus',{...base,shipModuleCount:2}).laserDamage-110)<1e-9);
 assert.ok(Math.abs(passives.applyStats('ship_solaris-plus',{...base,shipModuleCount:4}).laserDamage-116)<1e-9);
 assert.equal(passives.applyStats('ship_solace-plus',base).shieldMax,1150);
});

