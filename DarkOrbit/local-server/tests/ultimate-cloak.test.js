'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),Collectables=require('../game/collectables').Collectables,maps=require('../game/maps'),abilities=require('../game/ship-abilities'),expanded=require('../game/ship-abilities-expanded'),cpu=require('../game/cpu'),codec=require('../game/codec/codec'),config=require('../config');
let db,fixtures;
beforeEach(()=>{database.close();db=database.open(':memory:');fixtures=[];});afterEach(()=>{for(const f of fixtures)f.w.removeSession(f.s);database.close();});
function fixture(ship='ship_spearhead'){
 const id=players.createPlayer(players.createAccount('ultimate-'+fixtures.length,'qa-pass'),'Ultimate QA',1,{...config.starter,ship}),w=new World(config),commands=[],s={world:w,send(){}};w.login(s,id);Object.assign(w.player,{x:6000,y:6000,lastCombat:0});const combat=new Combat(w,(s,c)=>{const d=codec.decode(codec.encode(c));assert.equal(d.rest,0);commands.push(d.obj);});combat.map=maps.getMap(1);w.collectables=new Collectables(w,combat.send);const f={id,w,s,p:w.player,combat,commands};fixtures.push(f);return f;
}
const use=(f,now=100000)=>abilities.action(f.s,{menuItemId:'ability_spearhead_ultimate-cloak',actionType:1},now);
function npc(f){return f.combat.spawn({key:'cloak-qa',typeId:84,name:'Cloak target',hitpoints:100000,shield:0,speed:0,damageMin:1,damageMax:1,reward:{},aggressive:true},{x:6200,y:6000});}
test('Ultimate Cloak uses own hull duration, native start-only effect and no CPU charge',()=>{
 for(const [ship,duration,cooldown]of [['ship_spearhead',30000,360000],['ship_s-elite',45000,360000],['ship_spearhead-plus',30000,360000],['ship_defcom-raven',20000,240000]]){
  const f=fixture(ship);assert.equal(use(f),true);assert.equal(cpu.isCloaked(f.p),true);const run=f.w.expandedAbilityRuns.get('ability_spearhead_ultimate-cloak');assert.equal(run.until,100000+duration);
  assert.equal(f.commands.filter(c=>c._==='AbilityStartCommand'&&c.selectedAbilityId===103).length,1);assert.equal(f.commands.filter(c=>c._==='AbilityEffectActivationCommand'&&c.selectedAbilityId===103).length,0,'native start handler already starts effect and sound');
  abilities.tick(f.w,f.combat,100000+duration);assert.equal(cpu.isCloaked(f.p),false);assert.equal(use(f,100000+cooldown-1),false);assert.equal(use(f,100000+cooldown),true);
 }
});
test('historical20s combat lock rejects attacking or recently hit ships without starting cooldown',()=>{
 const f=fixture();f.p.lastCombat=90000;assert.equal(use(f),false);assert.equal(f.w.expandedAbilityRuns.size,0);f.p.lastCombat=80000;f.s.attacking=42;assert.equal(use(f),false);f.s.attacking=null;assert.equal(use(f),true);
});
test('activation clears NPC aggro, suppresses new aggro and blocks delayed NPC damage while cloaked',()=>{
 const f=fixture(),n=npc(f);n.aggro=f.s;const hp=f.p.hitPoints;assert.equal(use(f),true);assert.equal(n.aggro,null);f.combat.normalAi(n,{aggression:'aggressive',acquisitionRadius:900,retainRadius:2500,attackRange:600,roam:false},101000);assert.equal(n.aggro,null);assert.equal(f.combat.damagePlayer(n,1000,{now:101000,evade:false}),0);assert.equal(f.p.hitPoints,hp);assert.equal(f.p.lastCombat,0);
});
test('player firing breaks ultimate and ordinary cloak; empty or invalid fire does not',()=>{
 const f=fixture(),n=npc(f);use(f);assert.equal(f.combat.rocket(f.s,{lootId:'not-a-rocket'}),false);assert.equal(f.p.ultimateCloaked,true);
 cpu.write(f.p,{...cpu.read(f.p),cloaked:true});cpu.breakCloak(f.w);assert.equal(f.p.ultimateCloaked,false);assert.equal(cpu.isCloaked(f.p),false);assert.equal(f.w.expandedAbilityRuns.size,0);
});
test('player harvest cancels ultimate cloak but PET collection retains it',()=>{
 const f=fixture();use(f);const box=f.w.collectables.add({x:6000,y:6000,oreType:0,amount:1},false);assert.equal(f.w.collectables.beginHarvest(f.s,{itemHash:box.hash},true),true);assert.equal(f.p.ultimateCloaked,false);f.w.collectables.cancelHarvest(f.s);
 const other=fixture();use(other);const pet={active:true,x:6000,y:6000,stats:{effects:{}}};other.w.petRuntime=pet;const ore=other.w.collectables.add({x:6000,y:6000,oreType:0,amount:1},false);assert.equal(other.w.collectables.collect(other.s,{itemHash:ore.hash},pet),true);assert.equal(other.p.ultimateCloaked,true);other.w.petRuntime=null;
});
test('ultimate cloak expiry restores existing ordinary cloak instead of erasing its persisted charge',()=>{
 const f=fixture();cpu.write(f.p,{cloaked:true});use(f);abilities.tick(f.w,f.combat,130000);assert.equal(f.p.ultimateCloaked,false);assert.equal(cpu.isCloaked(f.p),true);assert.equal(cpu.read(f.p).cloaked,true);assert.equal(f.commands.filter(c=>c._==='LegacyModule'&&c.message.startsWith('0|n|INV|')).at(-1).message,`0|n|INV|${f.id}|1`);
});
test('using normal cloak CPU ends ultimate without wasting or duplicating its own charge',()=>{
 const f=fixture(),item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index) VALUES(?,'equipment_extra_cpu_cl04k-m',1,?,'extra',0)").run(f.id,f.p.shipId).lastInsertRowid);use(f);assert.equal(cpu.cloak(f.w),true);assert.equal(f.p.ultimateCloaked,false);assert.equal(cpu.isCloaked(f.p),true);assert.equal(db.prepare('SELECT remaining FROM cpu_charges WHERE item_id=?').get(item).remaining,9);
});
test('pirate mist preserves ultimate, while map teardown ends it and keeps cooldown',()=>{
 const f=fixture();use(f);Object.assign(f.p,{mapId:93,x:20000,y:13000});require('../game/pirate-fields').apply(f.w,{x:17000,y:13000});assert.equal(f.p.ultimateCloaked,true);abilities.tick(f.w,f.combat,101000);assert.equal(f.p.ultimateCloaked,false);assert.equal(use(f,102000),false);
});
test('failed cooldown write cannot cloak or cancel NPC aggression',()=>{
 const f=fixture(),n=npc(f);n.aggro=f.s;db.exec("CREATE TRIGGER deny_ultimate BEFORE INSERT ON settings WHEN NEW.key='game.expandedShipCooldowns' BEGIN SELECT RAISE(ABORT,'ultimate-storage'); END");assert.throws(()=>use(f),/ultimate-storage/);assert.equal(cpu.isCloaked(f.p),false);assert.equal(n.aggro,f.s);assert.equal(f.commands.filter(c=>c._==='AbilityStartCommand').length,0);db.exec('DROP TRIGGER deny_ultimate');
});
test('Ultimate Cloak suppresses shield and regeneration without erasing the saved pool, then restores it',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});const f=fixture(),inv=require('../game/inventory');t.mock.method(World,'current',()=>f.w);const item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_generator_shield_sg3n-b02',1)").run(f.id).lastInsertRowid);inv.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item]},to:{target:'ship',slotset:'generators'}});f.p.shield=5000;use(f);assert.equal(f.p.shield,0);assert.equal(f.p.ultimateShield,5000);f.w.save();assert.equal(db.prepare('SELECT shield FROM ships WHERE id=?').get(f.p.shipId).shield,5000);
 f.combat.tick();assert.equal(f.p.shield,0);abilities.tick(f.w,f.combat,130000);assert.equal(f.p.shield,5000);assert.equal(f.p.ultimateShield,undefined);
});
test('configuration switch stores each real shield pool while ultimate keeps the displayed pool at zero',t=>{
 const f=fixture(),inv=require('../game/inventory');t.mock.method(World,'current',()=>f.w);const item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_generator_shield_sg3n-b02',1)").run(f.id).lastInsertRowid);
 for(const configId of [1,2])inv.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item],configId},to:{target:'ship',slotset:'generators',configId}});
 f.p.shield=5000;db.prepare('INSERT INTO ship_config_shields(ship_id,config_id,shield)VALUES(?,2,7000) ON CONFLICT(ship_id,config_id)DO UPDATE SET shield=7000').run(f.p.shipId);use(f);inv.switchConfig(f.id,f.p.shipId,2);assert.equal(f.p.shield,0);assert.equal(f.p.ultimateShield,7000);assert.equal(db.prepare('SELECT shield FROM ship_config_shields WHERE ship_id=? AND config_id=1').get(f.p.shipId).shield,5000);
 inv.switchConfig(f.id,f.p.shipId,2);assert.equal(f.p.ultimateShield,7000);f.w.save();assert.equal(db.prepare('SELECT shield FROM ships WHERE id=?').get(f.p.shipId).shield,7000);expanded.breakUltimate(f.w,110000);assert.equal(f.p.shield,7000);
});
