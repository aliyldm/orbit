'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),runtime=require('../game/normal-map-runtime');
let db,f;
function fixture(id){
 if(!id){const a=players.createAccount('persistent-npc','testpass');id=players.createPlayer(a,'Persistent NPC QA',1,config.starter);}
 const w=new World(config),commands=[],s={world:w,send(){},close(){}};w.login(s,id);Object.assign(w.player,{x:6000,y:6000});
 const c=new Combat(w,(session,command)=>commands.push(command));c.map=maps.getMap(w.player.mapId);
 return {w,s,c,id,p:w.player,commands};
}
beforeEach(()=>{database.close();db=database.open(':memory:');f=fixture();});
afterEach(()=>{f.w.removeSession(f.s);database.close();});
const state=npc=>db.prepare('SELECT * FROM normal_spawn_state WHERE player_id=? AND spawn_id=? AND slot=?').get(f.id,npc.def.normalSpawnId,npc.def.normalSpawnSlot);

test('normal damage and position survive map departure and return without repopulating dead or duplicate slots',()=>{
 f.c.spawnAll();const npc=[...f.c.npcs.values()][0],hit=Date.now();Object.assign(npc,{hp:321,shield:123,x:7000,y:6500,lastHit:hit});f.c.stop();
 f.p.mapId=2;f.c.spawnAll();f.c.stop();f.p.mapId=1;f.c.spawnAll();
 const restored=[...f.c.npcs.values()].find(n=>n.def.normalSpawnId===npc.def.normalSpawnId&&n.def.normalSpawnSlot===npc.def.normalSpawnSlot);
 assert.deepEqual([restored.hp,restored.shield,restored.x,restored.y],[321,123,7000,6500]);
 assert.equal(restored.lastHit,hit);
 f.c.spawnAll();assert.equal(f.c.npcs.size,20);
});

test('Boss death deadline survives map hopping and creates exactly one new generation after the remaining wait',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});f.p.mapId=2;f.c.spawnAll();f.c.timer={};
 const boss=[...f.c.npcs.values()].find(n=>n.def.key==='boss-streuner'),generation=boss.def.normalSpawnGeneration;boss.hp=0;f.c.kill(f.s,boss);
 const paid=f.p.uridium;assert.equal(state(boss).respawn_at,190000);f.c.stop();assert.equal(f.c.respawns.size,0);
 f.p.mapId=1;f.c.spawnAll();f.c.stop();f.p.mapId=2;f.c.spawnAll();f.c.timer={};
 const matching=()=>[...f.c.npcs.values()].filter(n=>n.def.normalSpawnId===boss.def.normalSpawnId&&n.def.normalSpawnSlot===boss.def.normalSpawnSlot);
 assert.equal(matching().length,0);f.c.spawnAll();assert.equal(f.c.normalRespawnTimers.size,1);
 t.mock.timers.tick(89999);assert.equal(matching().length,0);t.mock.timers.tick(1);assert.equal(matching().length,1);
 assert.equal(matching()[0].def.normalSpawnGeneration,generation+1);assert.equal(f.p.uridium,paid);
});

test('normal kill generation can claim a reward only once and failed reward storage rolls back deadline and wallet',()=>{
 f.c.spawnAll();const npc=[...f.c.npcs.values()][0];let claims=0;
 assert.equal(runtime.claim(f.c,npc,()=>claims++),true);assert.equal(runtime.claim(f.c,npc,()=>claims++),false);assert.equal(claims,1);
 const other=[...f.c.npcs.values()][1],prior=state(other),wallet=f.p.uridium;other.hp=0;f.commands.length=0;
 db.exec("CREATE TRIGGER npc_reward_fail BEFORE UPDATE ON players BEGIN SELECT RAISE(ABORT,'npc reward failure'); END");
 assert.throws(()=>f.c.kill(f.s,other),/npc reward failure/);assert.deepEqual(state(other),prior);assert.equal(f.p.uridium,wallet);
 assert.ok(!f.commands.some(c=>c._==='ShipDestroyedCommand'||c._==='LegacyModule'&&c.message.includes('|LM|ST|')));
 db.exec('DROP TRIGGER npc_reward_fail');
});

test('last socket removal still saves NPC damage and stops all population timers',()=>{
 f.c.spawnAll();const npc=[...f.c.npcs.values()][0];npc.hp=456;f.w.removeSession(f.s);
 assert.equal(state(npc).hp,456);assert.equal(f.c.respawns.size,0);assert.equal(f.w.player,null);
});

test('file database restart preserves damaged NPCs and real respawn deadlines',t=>{
 const fs=require('node:fs'),path=require('node:path'),os=require('node:os'),file=path.join(os.tmpdir(),`darkorbit-npc-${require('node:crypto').randomUUID()}.db`);
 f.w.removeSession(f.s);database.close();
 t.after(()=>{database.close();for(const suffix of ['','-wal','-shm'])if(fs.existsSync(file+suffix))fs.unlinkSync(file+suffix);});
 db=database.open(file);f=fixture();f.c.spawnAll();const npc=[...f.c.npcs.values()][0],other=[...f.c.npcs.values()][1];npc.hp=222;other.hp=0;f.c.kill(f.s,other);
 const deadline=state(other).respawn_at,id=f.id;f.w.removeSession(f.s);database.close();
 db=database.open(file);f=fixture(id);f.c.spawnAll();
 const restored=[...f.c.npcs.values()].find(n=>n.def.normalSpawnId===npc.def.normalSpawnId&&n.def.normalSpawnSlot===npc.def.normalSpawnSlot);
 assert.equal(restored.hp,222);assert.equal(state(other).respawn_at,deadline);assert.equal(f.c.npcs.size,19);
});

test('manual NPCs and transient escorts never create persistent population slots',()=>{
 const base=require('../game/normal-map-content').definition('streuner');f.c.spawn(base);f.c.spawn({...base,transient:true,normalSpawnId:1,normalSpawnSlot:0});runtime.save(f.c);
 assert.equal(db.prepare('SELECT count(*) n FROM normal_spawn_state').get().n,0);
});
