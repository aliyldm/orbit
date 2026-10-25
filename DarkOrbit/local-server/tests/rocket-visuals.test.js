'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),skills=require('../game/skills'),visuals=require('../game/rocket-visuals'),codec=require('../game/codec/codec'),ammo=require('../game/ammo');
let sequence=0;
function fixture(){
 const account=players.createAccount(`rocket-visual-${++sequence}`,'testpass'),id=players.createPlayer(account,'Rocket QA',1,{...config.starter,credits:100000000,uridium:10000000});
 const world=World.instance(config);world.config=structuredClone(config);world.rendererMode=2;
 const commands=[],session={world,send(buffer){const decoded=codec.decode(buffer.subarray(3));assert.equal(decoded.rest,0);commands.push(decoded.obj);},close(){}};
 world.login(session,id);Object.assign(world.player,{x:6000,y:6000});
 const combat=new Combat(world,(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(decoded.obj);});combat.map=maps.getMap(1);
 const npc=combat.spawn({typeId:84,name:'Rocket QA NPC',hitpoints:10000,shield:0,speed:200,damageMin:1,damageMax:1,reward:{},respawnMs:5000});Object.assign(npc,{x:6400,y:6000});
 skills.state(id);db.prepare('UPDATE skill_accounts SET earned_points=50 WHERE player_id=?').run(id);
 return {world,commands,session,combat,npc,id,p:world.player};
}
function set(f,id,level){if(!level)return db.prepare('DELETE FROM player_skills WHERE player_id=? AND skill_id=?').run(f.id,id);db.prepare('INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,?,?) ON CONFLICT(player_id,skill_id)DO UPDATE SET level=excluded.level').run(f.id,id,level);}
function finish(f){f.world.removeSession(f.session);}
const launch=f=>f.commands.findLast(c=>c._==='LegacyModule'&&c.message.startsWith('0|v|'))?.message.split('|');

test('Rocket Fusion trail requires learned rank5, independently of heat seeking or total pilot points',()=>{
 const f=fixture();assert.equal(visuals.shot(f.id).smokeId,0);
 set(f,'6',4);set(f,'20',5);assert.equal(visuals.shot(f.id).smokeId,0);
 set(f,'6',5);set(f,'20',0);assert.deepEqual(visuals.shot(f.id),{hit:true,smokeId:1,isHeatSeeking:false});finish(f);
});

test('heat glow marks only an otherwise missed shot rescued by the learned accuracy bonus, even at rank1',()=>{
 const f=fixture();set(f,'20',1);
 assert.deepEqual(visuals.shot(f.id,.8,()=>.805),{hit:true,smokeId:0,isHeatSeeking:true});
 assert.equal(visuals.shot(f.id,.8,()=>.79).isHeatSeeking,false);
 assert.deepEqual(visuals.shot(f.id,.8,()=>.82),{hit:false,smokeId:0,isHeatSeeking:false});
 set(f,'20',0);assert.equal(visuals.shot(f.id,.8,()=>.805).hit,false);finish(f);
});

test('one shared roll retains total accuracy and separates ordinary, rescued and missed shots',()=>{
 const f=fixture();set(f,'20',5);const count={normal:0,rescued:0,miss:0};
 for(let i=0;i<1000;i++){let calls=0;const result=visuals.shot(f.id,.8,()=>{calls++;return (i+.5)/1000;});assert.equal(calls,1);count[!result.hit?'miss':result.isHeatSeeking?'rescued':'normal']++;}
 assert.deepEqual(count,{normal:800,rescued:100,miss:100});
 assert.deepEqual(visuals.shot(f.id,1,()=>{throw Error('guaranteed hit needs no RNG');}),{hit:true,smokeId:0,isHeatSeeking:false});
 finish(f);
});

test('actual rocket packet carries both effects and retains ammo, learned damage and delayed impact',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const f=fixture();set(f,'6',5);set(f,'20',5);f.world.refreshStats();
 f.combat.cfg.rocketHitChance=.8;t.mock.method(Math,'random',()=>.85);
 const before=ammo.count(f.p,'ammunition_rocket_r-310');assert.equal(f.combat.rocket(f.session,{targetId:f.npc.id}),true);
 assert.deepEqual(launch(f),['0','v',String(f.id),String(f.npc.id),'H','1','1','1']);
 assert.equal(ammo.count(f.p,'ammunition_rocket_r-310'),before-1);assert.equal(f.npc.hp,10000);
 t.mock.timers.tick(799);assert.equal(f.npc.hp,10000);t.mock.timers.tick(1);assert.equal(f.npc.hp,8850);
 assert.equal(f.commands.filter(c=>c._==='AttackHitCommand').length,1);finish(f);
});

test('a genuine miss preserves the fusion trail but has no heat glow or delayed damage',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const f=fixture();set(f,'6',5);set(f,'20',1);f.combat.cfg.rocketHitChance=.8;
 t.mock.method(Math,'random',()=>.99);f.combat.rocket(f.session,{targetId:f.npc.id});assert.deepEqual(launch(f).slice(4),['M','1','1','0']);
 t.mock.timers.tick(800);assert.equal(f.npc.hp,10000);assert.ok(f.commands.some(c=>c._==='AttackMissedCommand'));assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'));finish(f);
});

test('real final upgrade and reset update the next rocket without reconnecting or a cached visual flag',()=>{
 const f=fixture();set(f,'18b',2);set(f,'6',4);require('../game/skylab').state(f.id);
 db.prepare('INSERT INTO skylab_resources(player_id,ore_type,amount)VALUES(?,7,10000) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=10000').run(f.id);
 assert.equal(visuals.shot(f.id).smokeId,0);skills.upgrade(f.id,'6');assert.equal(visuals.shot(f.id).smokeId,1);
 assert.equal(f.p.stats.rocketMultiplier,1.15);skills.reset(f.id);assert.equal(visuals.shot(f.id).smokeId,0);assert.equal(f.p.stats.rocketMultiplier,1);finish(f);
});

test('chosen smoke ID resolves to native cached 2D and 3D assets rather than the red smoke alternative',()=>{
 const xml=fs.readFileSync(require('node:path').join(__dirname,'../decompiled/pet-patterns/game.xml'),'utf8');
 assert.match(xml,/<rocketSmoke id="1" resKey="rocketSmoke1"[^>]*fx3D="rocket_trail_2.zip"/);
 for(const path of ['graphics/smoke/rocketSmoke1.swf','3d/fx/rocket_trail_2.zip'])assert.ok(fs.statSync(require('node:path').join(__dirname,'../client/spacemap',path)).size>0);
});
