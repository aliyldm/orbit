'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),rings=require('../game/gate-rings'),gates=require('../game/galaxy-gates'),systems=require('../game/handlers/systems'),config=require('../config.json'),codec=require('../game/codec/codec');
let db,pid;
beforeEach(()=>{database.close();db=database.open(':memory:');pid=players.createPlayer(players.createAccount('gate-rings','test'),'Rings',1,config.starter);});
afterEach(()=>database.close());
function history(gate,state='won',owner=pid,claimed=false){
 const id=Number(db.prepare('INSERT INTO galaxy_gate_runs(player_id,gate_id,map_id,home_map,state,lives,wave,wave_count,rewards_json,created_at)VALUES(?,?,51,1,?,3,1,1,\'{}\',0)').run(owner,gate,state).lastInsertRowid);
 if(claimed)db.prepare('INSERT INTO galaxy_gate_completion_claims(run_id,reward_json,claimed_at)VALUES(?,\'{}\',0)').run(id);
 return id;
}
function finalKill(gateId){
 const p=players.loadPlayer(pid),sent=[],deferred=[],world={player:p,gatesDb:db,config:{galaxyGates:{waveCount:1,npcsPerWave:1,waveDelayMs:0}},npcs:new Map(),sessions:new Set(),schedule(fn){deferred.push(fn);}};
 world.combat={send(s,c){sent.push(c);},spawn(def){const npc={id:999,def};world.npcs.set(npc.id,npc);return npc;}};
 const session={world,player:p};world.sessions.add(session);systems.gateInfo(p,db);
 const parts=Array.from({length:gates.DEFINITIONS[gateId].parts},(_,i)=>i+1);db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=?').run(JSON.stringify(parts),pid,gateId);
 assert.equal(gates.setup(session,gateId,{db}).errorCode,0);const run=db.prepare("SELECT * FROM galaxy_gate_runs WHERE player_id=? AND gate_id=? AND state='active'").get(pid,gateId);
 p.mapId=run.map_id;gates.spawnWave(world,world.combat);return{p,world,session,run,npc:[...world.npcs.values()][0],sent,deferred};
}
test('real first/repeat/different gate final kills produce a set of rings instead of a completion count',()=>{
 for(const [gate,mask]of[[1,1],[1,1],[2,3],[6,35],[7,35]]){
  const f=finalKill(gate);assert.equal(gates.onNpcKilled(f.world,f.npc,f.session),true);assert.equal(f.p.galaxyGatesDone,mask);assert.equal(players.loadPlayer(pid).galaxyGatesDone,mask);
  const balance=db.prepare('SELECT credits,uridium,ep,honour FROM players WHERE id=?').get(pid);assert.equal(gates.onNpcKilled(f.world,f.npc,f.session),false);assert.deepEqual(db.prepare('SELECT credits,uridium,ep,honour FROM players WHERE id=?').get(pid),balance);
 }
 assert.equal(db.prepare("SELECT count(*) n FROM galaxy_gate_runs WHERE player_id=? AND state='won'").get(pid).n,5);
});
test('failed/active/unrelated gates and imported numeric totals cannot invent rings',()=>{
 db.prepare('UPDATE players SET galaxy_gates_done=127 WHERE id=?').run(pid);history(1,'failed');history(2,'active');history(7);history(8);history(13);history(19);
 assert.equal(players.loadPlayer(pid).galaxyGatesDone,0);assert.equal(db.prepare('SELECT galaxy_gates_done FROM players WHERE id=?').get(pid).galaxy_gates_done,0);
 history(3);history(5);history(12);assert.equal(rings.derive(db,pid),4|16|64);
 const p=players.loadPlayer(pid);p.galaxyGatesDone=127;players.savePlayer(p);assert.equal(p.galaxyGatesDone,84);assert.equal(players.loadPlayer(pid).galaxyGatesDone,84);
});
test('claims identify completed runs and all seven native icon bits derive independently',()=>{
 for(const [gate,bit]of Object.entries(rings.GATE_BITS)){
  const account=players.createAccount('ring-'+gate,'test'),owner=players.createPlayer(account,'Ring '+gate,1,config.starter);history(Number(gate),'active',owner,true);assert.equal(rings.derive(db,owner),bit);
 }
 assert.equal(rings.derive(db,pid),0,'another player completion never leaks');
 for(const gate of Object.keys(rings.GATE_BITS))history(Number(gate));assert.equal(rings.derive(db,pid),127);
});
test('startup backfills every player from persisted history while preserving wallets and all other player progress',()=>{
 database.close();const dir=fs.mkdtempSync(path.join(os.tmpdir(),'darkorbit-rings-')),file=path.join(dir,'rings.db');
 try{
  db=database.open(file);pid=players.createPlayer(players.createAccount('backfill-rings','test'),'Backfill',1,config.starter);const second=players.createPlayer(players.createAccount('no-history','test'),'NoHistory',1,config.starter);
  history(2);history(4);db.prepare('UPDATE players SET galaxy_gates_done=72,ep=12345,credits=987654,uridium=456789 WHERE id IN (?,?)').run(pid,second);
  const before=db.prepare('SELECT * FROM players ORDER BY id').all();database.close();db=database.open(file);const after=db.prepare('SELECT * FROM players ORDER BY id').all();
  for(let i=0;i<before.length;i++){assert.equal(after[i].galaxy_gates_done,after[i].id===pid?10:0);delete before[i].galaxy_gates_done;delete after[i].galaxy_gates_done;assert.deepEqual(after[i],before[i]);}
  assert.equal(db.prepare('SELECT count(*) n FROM galaxy_gate_runs').get().n,2);assert.equal(players.loadPlayer(pid).galaxyGatesDone,10);
 }finally{database.close();for(const suffix of['','-wal','-shm'])if(fs.existsSync(file+suffix))fs.unlinkSync(file+suffix);fs.rmdirSync(dir);}
});
test('relogin native hero initialization serializes the real history mask even if live cache was stale',t=>{
 history(1);history(4);history(6);const World=require('../game/world'),world=new World(config),session={world,close(){},send(){}};world.login(session,pid);t.after(()=>world.removeSession(session));world.player.galaxyGatesDone=127;
 const hero=require('../game/init').buildInit(world).find(c=>c._==='ShipInitializationCommand'),decoded=codec.decode(codec.encode(hero)).obj;
 assert.equal(decoded.galaxyGatesDone,41);assert.equal(world.player.galaxyGatesDone,41);
});
test('completion claim storage rollback grants no ring and a safe retry awards its correct bit once',()=>{
 const f=finalKill(4);db.exec("CREATE TRIGGER reject_ring_completion BEFORE INSERT ON galaxy_gate_completion_claims BEGIN SELECT RAISE(ABORT,'reject completion'); END");
 assert.throws(()=>gates.onNpcKilled(f.world,f.npc,f.session),/reject completion/);assert.equal(f.p.galaxyGatesDone,0);assert.equal(rings.derive(db,pid),0);
 db.exec('DROP TRIGGER reject_ring_completion');assert.equal(gates.onNpcKilled(f.world,f.npc,f.session),true);assert.equal(f.p.galaxyGatesDone,8);assert.equal(rings.derive(db,pid),8);
});
