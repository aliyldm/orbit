'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),skills=require('../game/skills'),visuals=require('../game/shield-visuals'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let n=0;
function fixture(){
 const account=players.createAccount(`shield-qa-${++n}`,'testpass'),id=players.createPlayer(account,'Shield QA',1,{...config.starter,credits:100000000,uridium:10000000});
 const ship=db.prepare('SELECT active_ship_id FROM players WHERE id=?').get(id).active_ship_id;
 db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index)VALUES(?,'equipment_generator_shield_sg3n-b02',1,?,'generator',2)").run(id,ship);db.prepare('UPDATE ships SET shield=10000 WHERE id=?').run(ship);
 const world=World.instance(config),commands=[],session={world,send(buf){const d=codec.decode(buf.subarray(3));assert.equal(d.rest,0);commands.push(d.obj);},close(){}};world.login(session,id);Object.assign(world.player,{x:6000,y:6000});
 const combat=new Combat(world,(s,c)=>{const d=codec.decode(codec.encode(c));assert.equal(d.rest,0);commands.push(d.obj);});combat.map=maps.getMap(1);
 skills.state(id);db.prepare('UPDATE skill_accounts SET earned_points=50 WHERE player_id=?').run(id);return{world,commands,session,combat,p:world.player,id};
}
function set(f,id,level){db.prepare('INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,?,?) ON CONFLICT(player_id,skill_id) DO UPDATE SET level=excluded.level').run(f.id,id,level);}
function finish(f){f.world.removeSession(f.session);}
function attr(f){return f.commands.filter(c=>c._==='AttributeSkillShieldUpdateCommand').at(-1);}
function npc(f){const target=f.combat.spawn({typeId:84,name:'Shield QA NPC',hitpoints:50000,shield:10000,speed:200,damageMin:10,damageMax:10,reward:{},respawnMs:5000});Object.assign(target,{x:6200,y:6000});return target;}

test('engineering and mechanics visual qualifications are independent and require exact rank5',()=>{
 const f=fixture();set(f,'17',4);set(f,'8',4);assert.deepEqual(visuals.target(f.world,f.id),{bubble:false,impact:false});
 set(f,'17',5);assert.deepEqual(visuals.target(f.world,f.id),{bubble:true,impact:false});assert.equal(visuals.attribute(f.p).shieldSkillId,1);
 set(f,'17',2);set(f,'8',5);assert.deepEqual(visuals.target(f.world,f.id),{bubble:false,impact:true});assert.equal(visuals.attribute(f.p).shieldSkillId,0);finish(f);
});

test('hero initialization emits one owned bubble command after hero scene and preserves captured twinkle metadata',()=>{
 const f=fixture();set(f,'17',5);const commands=require('../game/init').buildInit(f.world),attributes=commands.filter(c=>c._==='AttributeSkillShieldUpdateCommand');assert.equal(attributes.length,1);
 assert.deepEqual(codec.decode(codec.encode(attributes[0])).obj,{_:'AttributeSkillShieldUpdateCommand',shieldSkillId:1,minSkinShieldTwinkle:10,maxSkinShieldTwinkle:100});assert.ok(commands.indexOf(attributes[0])>commands.findIndex(c=>c._==='ShipInitializationCommand'));
 db.prepare("DELETE FROM player_skills WHERE player_id=? AND skill_id='17'").run(f.id);assert.equal(skills.buildInit(f.p).find(c=>c._==='AttributeSkillShieldUpdateCommand').shieldSkillId,0);finish(f);
});

test('real final engineering upgrade sends bubble enable immediately and reset sends disable with no reconnect',()=>{
 const f=fixture();set(f,'13',1);set(f,'17',4);visuals.buildInit(f.p);f.commands.length=0;
 skills.upgrade(f.id,'17');assert.equal(attr(f).shieldSkillId,1);assert.equal(skills.state(f.id).levels['17'],5);assert.ok(f.commands.some(c=>c._==='AttributeShieldUpdateCommand'&&c.shieldMax===12500));
 skills.reset(f.id);assert.equal(attr(f).shieldSkillId,0);assert.equal(visuals.target(f.world,f.id).impact,false);finish(f);
});

test('mechanics final upgrade and reset change actual NPC-to-hero laser packets independently of attacker thick lasers',()=>{
 const f=fixture(),target=npc(f);set(f,'18b',3);set(f,'8',4);set(f,'22a',2);set(f,'22b',3);
 require('../game/skylab').state(f.id);db.prepare('INSERT INTO skylab_resources(player_id,ore_type,amount)VALUES(?,7,100000) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=100000').run(f.id);
 assert.equal(f.combat.laserRun(target.id,f.id).isDiminishedBySkillShield,false);skills.upgrade(f.id,'8');f.session.attacking=target.id;target.aggro=f.session;f.commands.length=0;f.combat.tick();
 const incoming=f.commands.find(c=>c._==='AttackLaserRunCommand'&&c.attackerId===target.id),outgoing=f.commands.find(c=>c._==='AttackLaserRunCommand'&&c.attackerId===f.id);
 assert.equal(incoming.isDiminishedBySkillShield,true);assert.equal(incoming.skilledLaser,false);assert.equal(outgoing.isDiminishedBySkillShield,false);assert.equal(outgoing.skilledLaser,true);assert.equal(visuals.attribute(f.p).shieldSkillId,0);
 skills.reset(f.id);assert.equal(f.combat.laserRun(target.id,f.id).isDiminishedBySkillShield,false);assert.equal(f.combat.laserRun(f.id,target.id).skilledLaser,false);finish(f);
});

test('NPC selection and PET targets never inherit hero maxed shield skills',()=>{
 const f=fixture(),target=npc(f);set(f,'17',5);set(f,'8',5);target.skillShield=true;f.combat.select(f.session,target.id);
 assert.equal(f.commands.find(c=>c._==='ShipSelectionCommand').shieldSkill,false);assert.equal(f.combat.laserRun(f.id,target.id).isDiminishedBySkillShield,false);assert.equal(f.combat.laserRun(target.id,require('../game/pet').petId(f.id)).isDiminishedBySkillShield,false);finish(f);
});

test('empty/dead shields disable both effects and combat shield regeneration re-enables the engineering bubble once',()=>{
 const f=fixture();set(f,'17',5);set(f,'8',5);visuals.buildInit(f.p);f.p.shield=0;f.p.lastCombat=Date.now();f.combat.tick();assert.equal(attr(f).shieldSkillId,0);assert.deepEqual(visuals.target(f.world,f.id),{bubble:false,impact:false});
 const before=f.commands.filter(c=>c._==='AttributeSkillShieldUpdateCommand').length;f.combat.tick();assert.equal(f.commands.filter(c=>c._==='AttributeSkillShieldUpdateCommand').length,before);
 f.p.lastCombat=Date.now()-20000;f.combat.tick();assert.ok(f.p.shield>0);assert.equal(attr(f).shieldSkillId,1);f.combat.killPlayer({def:{name:'QA'}});assert.equal(attr(f).shieldSkillId,0);finish(f);
});

test('live equipment/stat refresh disables depleted engineering bubble immediately',()=>{
 const f=fixture();set(f,'17',5);visuals.buildInit(f.p);db.prepare("UPDATE items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE ship_id=? AND loot_id='equipment_generator_shield_sg3n-b02'").run(f.p.shipId);f.world.refreshStats();assert.equal(f.p.shieldMax,0);assert.equal(f.p.shield,0);assert.equal(attr(f).shieldSkillId,0);finish(f);
});
