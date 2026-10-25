'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),path=require('path');
const database=require('../game/db'),players=require('../game/db/players'),k=require('../game/kronos'),g=require('../game/galaxy-gates'),systems=require('../game/handlers/systems'),loot=require('../game/loot-rewards'),codec=require('../game/codec/codec');
let db,w,s,queue,sent;const run=()=>db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=? ORDER BY id DESC LIMIT 1').get(w.player.userId);
beforeEach(()=>{database.close();db=database.open(':memory:');queue=[];sent=[];const id=players.createPlayer(players.createAccount('kronos-qa','testpass'),'Kronos QA',1,require('../config').starter);w={player:players.loadPlayer(id),config:{galaxyGates:{waveDelayMs:0,kronosSaturnChance:0}},gatesDb:db,npcs:new Map(),sessions:new Set(),schedule(fn){queue.push(fn);},updatePosition(){return this.player;},gatesChangeMap(s,id,x,y){Object.assign(w.player,{mapId:id,x,y});}};s={world:w,player:w.player};w.sessions.add(s);let uid=100000;w.combat={spawn(def){const npc={id:uid++,def,hp:def.hitpoints,shield:def.shield};w.npcs.set(npc.id,npc);return npc;},send(s,c){assert.equal(codec.decode(codec.encode(c)).rest,0);sent.push(c);}};systems.gateInfo(w.player,db);});
afterEach(()=>database.close());
function grant(){for(const [name,n]of Object.entries(k.PARTS))loot.item(db,w.player.userId,k.loot(name),n);}
function flush(){const jobs=queue;queue=[];for(const fn of jobs)fn();}
function kill(npc){assert.equal(g.onNpcKilled(w,npc,s),true);w.npcs.delete(npc.id);}
test('Kronos uses21 owned per-source parts, rejects spins/forged progress and setup consumes once with SQL rollback',()=>{
 db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=12').run(JSON.stringify(Array.from({length:21},(_,i)=>i+1)),w.player.userId);
 assert.equal(g.setup(s,12,{db}).errorCode,1);grant();const before=w.player.uridium;
 assert.equal(systems.gateInfo(w.player,db).gates.find(x=>x.id===12).currPart,21);assert.equal(systems.spin(w.player,{gateId:12,spinAmount:100},db).errorCode,2);assert.equal(w.player.uridium,before);
 db.exec("CREATE TRIGGER reject_kronos BEFORE INSERT ON galaxy_gate_runs BEGIN SELECT RAISE(ABORT,'run failure'); END");assert.throws(()=>g.setup(s,12,{db}),/run failure/);assert.equal(k.progress(db,w.player.userId).reduce((n,p)=>n+p.current,0),21);db.exec('DROP TRIGGER reject_kronos');
 assert.equal(g.setup(s,12,{db}).errorCode,0);assert.equal(run().map_id,76);assert.equal(run().wave_count,50);assert.equal(g.setup(s,12,{db}).errorCode,1);assert.equal(k.progress(db,w.player.userId).reduce((n,p)=>n+p.current,0),0);
 assert.equal(g.portalRows(w)[0].design_id,72);
});
test('official wave ordering and all28 NPC stat rows match the pinned primary evidence; Evil You snapshots the current hull',()=>{
 const plan=k.build({...w.player,typeId:'ship_diminisher',speed:420}),phases=plan.phases;assert.equal(phases.length,50);assert.equal(phases.flatMap(p=>p.slots).length,377);assert.equal(new Set(phases.map(p=>p.major)).size,13);
 assert.deepEqual(phases.slice(0,3).map(p=>[p.slots[0].key,p.slots.length]),[['kronos-phoenix',10],['kronos-yamato',15],['kronos-yamato',15]]);
 assert.equal(phases[48].slots[0].def.typeId,'ship_diminisher');assert.equal(phases[48].slots[0].def.speed,420);assert.equal(phases[49].slots[0].def.typeId,'108');assert.equal(phases[49].slots.length,8);
 const evidence=fs.readFileSync(path.join(__dirname,'../docs/evidence/kronos-official-npc.txt'),'utf8'),number=s=>Number(s.replaceAll('.',''));
 for(const [key,stats]of Object.entries(k.STATS)){
  const name=key==='evil'?'Evil DESCRIPCIÓN':key==='evil-iris'?'Evil Iris DESCRIPCIÓN':'Saturn '+key[0].toUpperCase()+key.slice(1)+' DESCRIPCIÓN';
  const section=evidence.slice(evidence.indexOf(name));assert.ok(section.startsWith(name),key);
  const values=/Puntos de vida: ([\d.]+)\s*\. Escudo: ([\d.]+)\s*\. Daños: ([\d.]+)\s*\/\s*([\d.]+)\s*\. Velocidad: ([\d.]+|-)/.exec(section);assert.ok(values,key);
  assert.deepEqual(values.slice(1,5).map(number),stats.slice(0,4),key);if(stats[4]!==null)assert.equal(number(values[5]),stats[4],key);
 }
});
test('full Kronos run exposes12 major checkpoints, awards exact NPC/completion loot once, energy and native crown',()=>{
 grant();assert.equal(g.setup(s,12,{db}).errorCode,0);const policy=JSON.parse(run().plan_json),reward=policy.rewards,expected={credits:0,uridium:reward.uridium,ep:reward.ep,honour:reward.honour};
 for(const slot of policy.phases.flatMap(p=>p.slots))for(const key of Object.keys(expected))expected[key]+=slot.def.reward[key];
 const before=db.prepare('SELECT credits,uridium,ep,honour FROM players WHERE id=?').get(w.player.userId),energy=db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(w.player.userId).energy;
 w.player.mapId=76;g.spawnWave(w,w.combat);let kills=0,checkpoints=0,last;
 while(run().state==='active'&&kills<400){
  for(const npc of [...w.npcs.values()]){last=npc;kill(npc);kills++;}flush();
  if(run().waiting_next_wave){checkpoints++;const portal=g.portalRows(w).find(p=>p.gateAction==='continue');assert.ok(portal);assert.equal(g.portalRows(w).length,2);assert.equal(g.prepareTransition(w,portal),true);g.spawnWave(w,w.combat);}
 }
 assert.equal(kills,377);assert.equal(checkpoints,12);assert.equal(run().state,'won');assert.equal(db.prepare('SELECT COUNT(*) n FROM galaxy_gate_kill_claims WHERE run_id=?').get(run().id).n,377);
 const after=db.prepare('SELECT credits,uridium,ep,honour,galaxy_gates_done FROM players WHERE id=?').get(w.player.userId);for(const key of Object.keys(expected))assert.equal(after[key]-before[key],expected[key],key);
 assert.ok(after.galaxy_gates_done&64);assert.equal(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(w.player.userId).energy-energy,250);
 assert.equal(loot.count(db,w.player.userId,'ammunition_rocketlauncher_ubr-100'),500);assert.equal(g.onNpcKilled(w,last,s),false);assert.equal(db.prepare('SELECT COUNT(*) n FROM galaxy_gate_completion_claims').get().n,1);
});
test('Kronos death returns to start of the current major wave and keeps old kill receipts',()=>{
 grant();g.setup(s,12,{db});w.player.mapId=76;db.prepare('UPDATE galaxy_gate_runs SET wave=5,released_wave=4 WHERE id=?').run(run().id);g.spawnWave(w,w.combat);kill([...w.npcs.values()][0]);w.player.dead=true;assert.equal(g.onPlayerDeath(w),true);assert.equal(run().wave,4);assert.equal(run().lives,2);assert.equal(db.prepare('SELECT COUNT(*) n FROM galaxy_gate_kill_claims').get().n,1);
});
test('Saturn chance is explicit local policy; reward hull is owned once and carries its existing20percentHP passive',()=>{
 grant();g.setup(s,12,{db});const completion=require('../game/gate-completion-rewards'),row=run(),policy=JSON.parse(row.rewards_json);policy.rare.chance=1;row.rewards_json=JSON.stringify(policy);
 const reward=completion.resolve(db,row,()=>0);assert.equal(reward.ship,'ship_g-saturn');completion.deliverItems(db,w.player.userId,reward);assert.equal(db.prepare("SELECT COUNT(*) n FROM ships WHERE player_id=? AND loot_id='ship_g-saturn'").get(w.player.userId).n,1);
 const repeated=completion.resolve(db,row,()=>0);assert.equal(repeated.ship,undefined);assert.equal(repeated.outcome.alreadyOwned,true);assert.equal(require('../game/ship-passives').applyStats('ship_g-saturn',{hitMax:100,shieldMax:0,laserDamage:0}).hitMax,120);
});
