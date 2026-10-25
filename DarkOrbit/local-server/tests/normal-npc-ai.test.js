'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),codec=require('../game/codec/codec');let n=0;
function fixture(){const a=players.createAccount(`normal-ai-${++n}`,'testpass'),id=players.createPlayer(a,'NPC AI QA',1,config.starter),world=new World(config),commands=[],session={world,send(){},close(){}};world.login(session,id);Object.assign(world.player,{x:6000,y:6000});const combat=new Combat(world,(s,c)=>{const d=codec.decode(codec.encode(c));assert.equal(d.rest,0);commands.push(d.obj);});combat.map=maps.getMap(1);return{world,session,combat,commands,id,p:world.player};}
function spawn(f,behavior={},extra={},position={x:6200,y:6000}){return f.combat.spawn({typeId:84,name:'Normal QA',hitpoints:100000,shield:10000,speed:200,damageMin:1,damageMax:1,reward:{},respawnMs:1000,behavior:{aggression:'passive',roam:false,...behavior},...extra},position);}
function finish(f){f.world.removeSession(f.session);}
function npcHits(f,npc){return f.commands.filter(c=>c._==='AttackHitCommand'&&c.attackerId===npc.id);}

test('passive normal NPC ignores passing player and selection but returns fire after a valid attack',()=>{
 const f=fixture(),npc=spawn(f);f.combat.tick();assert.equal(npc.aggro,null);assert.equal(npcHits(f,npc).length,0);f.combat.select(f.session,npc.id);f.combat.tick();assert.equal(npc.aggro,null);f.combat.attack(f.session,npc.id);f.combat.tick();assert.equal(npc.aggro,f.session);assert.ok(npcHits(f,npc).length>0);finish(f);
});

test('aggressive normal NPC contact radius, firing range and retention are independent metadata',()=>{
 const f=fixture(),npc=spawn(f,{aggression:'aggressive',acquisitionRadius:300,attackRange:150,retainRadius:500},{},{x:6400,y:6000});assert.equal(npc.aggro,null);f.combat.tick();assert.equal(npc.aggro,null);
 npc.x=6200;f.combat.tick();assert.equal(npc.aggro,f.session);assert.equal(npcHits(f,npc).length,0);npc.x=6100;f.combat.tick();assert.equal(npcHits(f,npc).length,1);
 f.p.x=9000;f.combat.tick();assert.equal(npc.aggro,null);assert.equal(npc.movement,undefined);finish(f);
});

test('normal pursuit stops at own station and cannot acquire dead, jumping or stale sessions',()=>{
 const f=fixture(),npc=spawn(f,{aggression:'aggressive'});f.combat.tick();f.combat.moveNpc(npc,8000,6000);assert.ok(npc.movement);Object.assign(f.p,{x:2000,y:2000});f.combat.tick();assert.equal(npc.aggro,null);assert.equal(npc.movement,null);assert.ok(f.commands.some(c=>c._==='MoveCommand'&&c.userId===npc.id&&c.timeToTarget===0));
 Object.assign(f.p,{x:6000,y:6000,dead:true});f.combat.tick();assert.equal(npc.aggro,null);f.p.dead=false;f.session.jumping=true;f.combat.tick();assert.equal(npc.aggro,null);f.session.jumping=false;npc.aggro={world:f.world,player:f.p};npc.x=9000;f.combat.tick();assert.equal(npc.aggro,null);finish(f);
});

test('normal range loss clears a chase movement, not just the target reference',()=>{
 const f=fixture(),npc=spawn(f,{aggression:'aggressive',retainRadius:1000});npc.aggro=f.session;f.combat.moveNpc(npc,6500,6000);f.p.x=12000;f.combat.tick();assert.equal(npc.aggro,null);assert.equal(npc.movement,null);finish(f);
});

test('opt-in low hull escape fixes a bounded nearest corner and keeps its movement without repeated restart',()=>{
 const f=fixture(),npc=spawn(f,{aggression:'aggressive',fleeAt:.1,fleeToCorner:true});const now=Date.now();npc.hp=9000;npc.lastHit=now;npc.aggro=f.session;f.combat.tick(now);assert.ok(npc.fleeing);assert.equal(npc.aggro,null);assert.deepEqual(npc.fleeing,{x:500,y:500});const movement=npc.movement,moves=f.commands.filter(c=>c._==='MoveCommand'&&c.userId===npc.id).length;
 npc.aggro=f.session;f.combat.tick(now+1000);assert.equal(npc.movement,movement);assert.equal(npc.aggro,null);assert.equal(f.commands.filter(c=>c._==='MoveCommand'&&c.userId===npc.id).length,moves);assert.equal(npcHits(f,npc).length,0);
 npc.shield=0;f.combat.updateNpc(npc,movement.start+movement.duration);f.combat.tick(movement.start+movement.duration);assert.equal(npc.movement,null);assert.equal(npc.fleeing.x,500);assert.equal(npc.fleeing.y,500);assert.ok(npc.shield>0);finish(f);
});

test('low HP does not invent flight for unclassified NPCs, stationary NPCs or gate NPCs',()=>{
 const f=fixture(),plain=spawn(f,{aggression:'aggressive'}),turret=spawn(f,{aggression:'aggressive',fleeAt:.1,fleeToCorner:true},{speed:0}),gate=spawn(f,{aggression:'passive',fleeAt:.1,fleeToCorner:true},{gateRunId:999,aggressive:true},{x:11000,y:6000});
 for(const npc of [plain,turret,gate]){npc.hp=9000;npc.lastHit=Date.now();}f.combat.tick();assert.equal(plain.fleeing,undefined);assert.equal(turret.fleeing,undefined);assert.ok(!turret.movement);assert.equal(gate.fleeing,undefined);assert.equal(gate.aggro,f.session);assert.ok(gate.movement);finish(f);
});

test('nonattacking nonchasing mothership metadata cannot create fake zero-damage lasers or chase',()=>{
 const f=fixture(),npc=spawn(f,{aggression:'retaliate',canAttack:false,chase:false,roam:false},{damageMin:0,damageMax:0},{x:7000,y:6000});npc.aggro=f.session;f.combat.tick();assert.equal(npc.movement,undefined);assert.equal(npcHits(f,npc).length,0);assert.ok(!f.commands.some(c=>c._==='AttackLaserRunCommand'&&c.attackerId===npc.id));finish(f);
});

test('spawn position is bounded before initial wire command and stable profile slots cannot overpopulate',()=>{
 const f=fixture(),npc=spawn(f,{}, {normalSpawnId:123,normalSpawnSlot:0},{x:-100,y:999999});assert.equal(npc.x,200);assert.equal(npc.y,f.combat.map.height-200);const packet=f.commands.find(c=>c._==='ShipCreateCommand');assert.equal(packet.x,npc.x);assert.equal(packet.y,npc.y);
 const again=f.combat.spawn({...npc.def},{x:6000,y:6000});assert.equal(again,npc);assert.equal(f.combat.npcs.size,1);f.combat.spawn({...npc.def,normalSpawnSlot:1});assert.equal(f.combat.npcs.size,2);finish(f);
});

test('successful death replenishes the same profile slot once and respawn preserves behavior',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});const f=fixture(),npc=spawn(f,{aggression:'aggressive'},{normalSpawnId:44,normalSpawnSlot:3});f.combat.start();npc.hp=0;f.combat.kill(f.session,npc);f.combat.kill(f.session,npc);assert.equal(f.combat.respawns.size,1);assert.equal(f.combat.npcs.size,0);t.mock.timers.tick(1000);assert.equal(f.combat.npcs.size,1);const next=[...f.combat.npcs.values()][0];assert.equal(next.def.normalSpawnId,44);assert.equal(next.def.normalSpawnSlot,3);assert.equal(next.def.behavior.aggression,'aggressive');assert.notEqual(next,npc);finish(f);
});

test('transient dependents never schedule respawn and map/epoch changes prevent old-map timers',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});const f=fixture(),dependent=spawn(f,{}, {transient:true});f.combat.start();dependent.hp=0;f.combat.kill(f.session,dependent);assert.equal(f.combat.respawns.size,0);const npc=spawn(f,{}, {normalSpawnId:44,normalSpawnSlot:0});npc.hp=0;f.combat.kill(f.session,npc);assert.equal(f.combat.respawns.size,1);f.p.mapId=2;f.combat.map=maps.getMap(2);f.world.cancelScheduled();t.mock.timers.tick(2000);assert.equal(f.combat.npcs.size,0);assert.equal(f.combat.respawns.size,0);finish(f);
});

test('normal behavior on an actual gate map does not override existing gate aggression and unlimited pursuit',()=>{
 const f=fixture();f.p.mapId=51;f.combat.map=maps.getMap(51);const npc=spawn(f,{aggression:'passive',retainRadius:20,chase:false,canAttack:false,fleeAt:.9,fleeToCorner:true},{aggressive:true},{x:11000,y:6000});npc.hp=9000;npc.lastHit=Date.now();assert.equal(f.combat.normalRules(npc),null);f.combat.tick();assert.equal(npc.aggro,f.session);assert.ok(npc.movement);assert.equal(npc.fleeing,undefined);finish(f);
});

