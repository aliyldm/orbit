'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const dbModule = require('../game/db'), players = require('../game/db/players'), systems = require('../game/handlers/systems');
const gates = require('../game/galaxy-gates'), content = require('../game/galaxy-gate-content'), catalog = require('../game/npc-catalog');
const codec = require('../game/codec/codec');
let db, w, s, sent, queue;
function world(player) {
  const w = { player, config: { galaxyGates: { waveDelayMs: 0 } }, gatesDb: db, npcs: new Map(), sessions: new Set(),
    schedule(fn) { queue.push(fn); }, updatePosition() { return this.player; }, gatesChangeMap(session, mapId, x, y) { Object.assign(player, { mapId, x, y }); } };
  let uid = 100000;
  w.combat = { spawn(def) { const npc = { id: uid++, def, hp: def.hitpoints, shield: def.shield }; w.npcs.set(npc.id, npc); return npc; }, send(s, c) {
    const result = codec.decode(codec.encode(c)); assert.equal(result.rest, 0); assert.deepEqual(result.obj, c); sent.push(c);
  } };
  return w;
}
beforeEach(() => {
  dbModule.close(); db = dbModule.open(':memory:'); queue = []; sent = [];
  const a = db.prepare('INSERT INTO accounts(username,password_hash,created_at) VALUES(?,?,0)').run('content-one', 'test');
  const id = players.createPlayer(Number(a.lastInsertRowid), 'content-one', 1, require('../config.json').starter);
  db.prepare('UPDATE players SET uridium=1000000 WHERE id=?').run(id);
  w = world(players.loadPlayer(id)); s = { world: w, player: w.player }; w.sessions.add(s); systems.gateInfo(w.player, db);
});
afterEach(() => dbModule.close());
const run = () => db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=? ORDER BY id DESC LIMIT 1').get(w.player.userId);
function setup(id = 1) {
  const parts = Array.from({ length: gates.DEFINITIONS[id].parts }, (_, i) => i + 1);
  db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=?').run(JSON.stringify(parts), w.player.userId, id);
  assert.equal(gates.setup(s, id, { db }).errorCode, 0);
}
function enter(id = 1, phase = 1) {
  if (phase > 1) db.prepare('UPDATE galaxy_gate_runs SET wave=?,released_wave=? WHERE id=?').run(phase, phase - 1, run().id);
  w.player.mapId = gates.DEFINITIONS[id].map; gates.spawnWave(w, w.combat);
}
function kill(npc) { const result = gates.onNpcKilled(w, npc, s); if (result) w.npcs.delete(npc.id); return result; }
function flush() { const jobs = queue; queue = []; for (const fn of jobs) fn(); }
function continueNextWave(){assert.equal(run().waiting_next_wave,1);const portal=gates.portalRows(w).find(row=>row.gateAction==='continue');assert.ok(portal);Object.assign(w.player,{x:portal.x,y:portal.y});assert.equal(gates.prepareTransition(w,portal),true);gates.spawnWave(w,w.combat);}

test('all ten gates have exact pinned major totals, source NPC keys and nonempty compatible phases', () => {
  const totals = { 1:446,2:446,3:446,4:177,5:152,6:154,7:154,8:121,13:165,19:222 };
  for (const [id, gate] of Object.entries(gates.DEFINITIONS)) {
    if(+id===12)continue; // Kronos has its own primary-source clone plan tests.
    const plan = content.build(+id);
    assert.equal(plan.phases.length, gate.waves); assert.ok(plan.phases.every(phase => phase.slots.length));
    assert.equal(plan.phases.flatMap(phase => phase.slots).length, totals[id]);
    for (const slot of plan.phases.flatMap(phase => phase.slots)) assert.ok(catalog.definitions[slot.key]);
  }
  const alpha = content.build(1).phases.flatMap(p => p.slots), beta = content.build(2).phases.flatMap(p => p.slots), gamma = content.build(3).phases.flatMap(p => p.slots);
  assert.equal(alpha.filter(s => s.key === 'protegit').length, 30);
  for (let i = 0; i < alpha.length; i++) for (const [list, factor] of [[beta,2],[gamma,3]]) {
    for (const field of ['hitpoints','shield','damageMin','damageMax']) assert.equal(list[i].def[field], alpha[i].def[field] * factor);
    assert.equal(list[i].def.speed, alpha[i].def.speed); assert.equal(list[i].def.reward.ep, alpha[i].def.reward.ep * factor);
  }
});

test('source variant and batch order survives composition rather than mixing every NPC at stage start', () => {
  const epsilon = content.build(5), kappa = content.build(7), kuiper = content.build(19), hades = content.build(13);
  assert.ok(epsilon.phases.flatMap(p => p.slots).every(s => s.key.startsWith('epsilon-')));
  assert.equal(kappa.phases.at(-1).slots[0].key, 'kappa-century-falcon');
  const kuc = kappa.phases.filter(p => p.major === 8);
  assert.deepEqual(kuc.map(p => p.slots.map(s => s.key)), [Array(3).fill('kappa-kucurbium'),Array(3).fill('kappa-kucurbium'),Array(8).fill('uber-saimon')]);
  const emperorPhase = kuiper.phases.findIndex(p => p.slots.some(s => s.key === 'streuner-emperor')) + 1;
  assert.equal(emperorPhase, 46);
  assert.ok(kuiper.phases.slice(39,45).flatMap(p => p.slots).every(s => s.key === 'streuner-rocketeer'));
  assert.deepEqual(hades.phases.slice(0,4).map(p => p.slots[0].key), ['sibelon','boss-sibelon','uber-sibelon','emperor-sibelon']);
});

test('protected Delta boss stays alive across escort phases and reconnect until every guard is cleared', () => {
  setup(4); enter(4, 4);
  const boss = [...w.npcs.values()].find(n => n.def.gateProtectedBy.length);
  assert.equal(gates.isProtected(w, boss), true); assert.equal(kill(boss), false);
  while (run().wave <= 6 && gates.isProtected(w, boss)) {
    for (const npc of [...w.npcs.values()].filter(n => n !== boss)) kill(npc);
    flush();
  }
  assert.equal(run().wave, 6); assert.ok(w.npcs.has(boss.id)); assert.equal(gates.isProtected(w, boss), false);
  assert.ok(sent.some(c => c._ === 'LegacyModule' && c.message === `0|n|ISH|${boss.id}`));
  assert.equal(kill(boss), true); assert.equal(run().wave, 7); flush();assert.equal(w.npcs.size,0);continueNextWave(); assert.ok(w.npcs.size);
});

test('NPC claim and death retry preserve original money exactly once per persistent slot', () => {
  setup(4); enter(4, 4);
  const npc = [...w.npcs.values()].find(n => !gates.isProtected(w, n)), before = w.player.uridium;
  const expected = catalog.get('streuner',2).reward.uridium;
  assert.equal(kill(npc), true); assert.equal(npc.gateKillRewardClaimed, true); assert.equal(w.player.uridium, before + expected);
  assert.equal(gates.onNpcKilled(w,npc,s), false); assert.equal(npc.gateKillRewardClaimed, false); assert.equal(w.player.uridium, before + expected);
  w.player.dead = true; assert.equal(gates.onPlayerDeath(w), true); assert.equal(run().wave, 4); assert.equal(run().lives, 2);
  w.npcs.clear(); w.player.dead = false; gates.spawnWave(w,w.combat);
  const retry = [...w.npcs.values()].find(n => n.def.gateSlot === npc.def.gateSlot);
  assert.ok(retry); assert.equal(kill(retry), true); assert.equal(retry.gateKillRewardClaimed, false); assert.equal(w.player.uridium, before + expected);
  assert.equal(db.prepare('SELECT count(*) n FROM galaxy_gate_kill_claims').get().n, 1);
});

test('claim storage failure rolls back NPC reward and progress without live success', () => {
  setup(); enter(); const npc = [...w.npcs.values()][0], before = w.player.uridium, remaining = run().remaining_json;
  db.exec("CREATE TRIGGER gate_claim_failure BEFORE INSERT ON galaxy_gate_kill_claims BEGIN SELECT RAISE(ABORT,'gate claim failure'); END");
  const packets = sent.length;
  assert.throws(() => kill(npc), /gate claim failure/); assert.equal(w.player.uridium,before); assert.equal(run().remaining_json,remaining);
  assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(w.player.userId).uridium,before); assert.equal(sent.length,packets);
});

test('run snapshots survive catalog edits and reconnect without changing original spawned stats', () => {
  setup(); const before = JSON.parse(run().plan_json).phases[0].slots[0].def.hitpoints;
  const original = catalog.definitions.streuner.hitpoints;
  try {
    catalog.definitions.streuner.hitpoints = original * 10;
    enter(); assert.equal([...w.npcs.values()][0].def.hitpoints,before);
    const p = w.player; w = world(p); s.world = w; w.sessions.add(s); gates.spawnWave(w,w.combat);
    assert.equal([...w.npcs.values()][0].def.hitpoints,before);
  } finally { catalog.definitions.streuner.hitpoints = original; }
});

test('untouched legacy ready gates adopt canonical content without losing lives, parts or charging again', () => {
  setup(); const id = run().id, before = w.player.uridium;
  db.prepare('UPDATE galaxy_gate_runs SET plan_json=NULL,lives=5,rewards_json=? WHERE id=?').run('{"uridium":100}',id);
  db.prepare('UPDATE galaxy_gate_progress SET lives=5 WHERE player_id=? AND gate_id=1').run(w.player.userId);
  enter(); const updated = run();
  assert.equal(JSON.parse(updated.plan_json).version,'official-classic-2026-10-20'); assert.equal(updated.lives,5);
  assert.equal(JSON.parse(updated.rewards_json).uridium,20000); assert.equal(w.player.uridium,before);
  assert.equal(db.prepare('SELECT parts_json FROM galaxy_gate_progress WHERE player_id=? AND gate_id=1').get(w.player.userId).parts_json,'[]');
});

test('started legacy runs freeze their old remaining types, wave counter and completion reward', () => {
  setup(); const id = run().id;
  db.prepare('UPDATE galaxy_gate_runs SET plan_json=NULL,wave=5,lives=2,remaining_json=?,rewards_json=? WHERE id=?')
    .run('[{"slot":0,"type":71}]','{"credits":1000,"uridium":100,"ep":1000,"honour":100,"ammunition":100}',id);
  w.player.mapId = 51; gates.spawnWave(w,w.combat);
  assert.equal(JSON.parse(run().plan_json).version,'legacy-local-snapshot'); assert.equal(run().wave,5); assert.equal(run().lives,2);
  assert.equal([...w.npcs.values()][0].def.typeId,71); assert.equal(JSON.parse(run().rewards_json).uridium,100);
});

test('Zeta major-wave checkpoint survives relogin and a home trip, reentry resumes the next wave and stale portals cannot skip it',()=>{
 setup(6);enter(6);const firstMajor=JSON.parse(run().plan_json).phases[0].major;
 let batches=0;
 while(!run().waiting_next_wave&&batches++<10){
  assert.equal(gates.portalRows(w).length,0,'no checkpoint while its sub-batches are in combat');
  for(const npc of [...w.npcs.values()])assert.equal(kill(npc),true);flush();
 }
 assert.equal(run().waiting_next_wave,1);assert.ok(batches>1,'Zeta first major has more than one sub-batch');const nextWave=run().wave;
 assert.notEqual(JSON.parse(run().plan_json).phases[nextWave-1].major,firstMajor);assert.equal(w.npcs.size,0);assert.equal(queue.length,0);
 const checkpoint=gates.portalRows(w),continued=checkpoint.find(x=>x.gateAction==='continue'),home=checkpoint.find(x=>x.gateAction==='home');assert.ok(continued.x<home.x);
 players.savePlayer(w.player);w=world(players.loadPlayer(w.player.userId));s.world=w;s.player=w.player;w.sessions.add(s);gates.spawnWave(w,w.combat);
 assert.equal(w.npcs.size,0,'relogin cannot automatically consume the checkpoint');assert.equal(gates.portalRows(w).length,2);assert.equal(run().wave,nextWave);
 assert.equal(gates.prepareTransition(w,{...continued,id:continued.id+99}),false);assert.equal(gates.prepareTransition(w,{...continued,target_map:1}),false);assert.equal(run().waiting_next_wave,1);
 assert.equal(gates.prepareTransition(w,home),true);assert.equal(run().waiting_next_wave,1,'going home preserves next-wave choice');
 const homeMap=db.prepare('SELECT * FROM maps WHERE id=?').get(home.target_map);Object.assign(w.player,{mapId:homeMap.id,x:homeMap.start_x,y:homeMap.start_y});players.savePlayer(w.player);
 w=world(players.loadPlayer(w.player.userId));s.world=w;s.player=w.player;w.sessions.add(s);assert.equal(run().wave,nextWave);assert.equal(run().waiting_next_wave,1);
 const entry=gates.portalRows(w).find(x=>x.gateAction==='enter');assert.ok(entry);assert.equal(gates.prepareTransition(w,continued),false,'stale checkpoint cannot operate from home');assert.equal(gates.prepareTransition(w,entry),true);
 Object.assign(w.player,{mapId:entry.target_map,x:entry.target_x,y:entry.target_y});gates.spawnWave(w,w.combat);assert.equal(run().wave,nextWave);assert.equal(run().waiting_next_wave,0);assert.ok(w.npcs.size>0);
 assert.equal(gates.prepareTransition(w,continued),false,'old continue portal cannot skip an active wave');assert.equal(gates.prepareTransition(w,home),false,'old home portal cannot leave an active wave');
});

test('all ten complete gate runs terminate, release every protected boss and grant exact total rewards once', () => {
  // Exercise Kappa's booster branch deterministically, then account for its
  // effect on later gate NPCs/completion instead of occasionally flaking.
  const completion = require('../game/gate-completion-rewards'), original = completion.resolve;
  completion.resolve = (db,run) => original(db,run,()=>.6);
  try {
  const p=w.player;
  for (const id of Object.keys(gates.DEFINITIONS).map(Number)) {
    if(id===12)continue;
    const plan=content.build(id), slots=plan.phases.flatMap(phase=>phase.slots);
    const before=db.prepare('SELECT ep,honour,credits,uridium,galaxy_gates_done FROM players WHERE id=?').get(p.userId);
    const expected=require('../game/boosters').applyReward(p.userId,plan.rewards,{db});
    for(const entry of slots) {
      const reward = require('../game/boosters').applyReward(p.userId,entry.def.reward,{db});
      for(const field of ['ep','honour','credits','uridium'])expected[field]=(expected[field]||0)+(reward[field]||0);
    }
    setup(id); enter(id);
    let count=0, iterations=0, last;
    while(run().state==='active'&&iterations++<plan.phases.length+5) {
      let cleared=0;
      for(const npc of [...w.npcs.values()])if(!gates.isProtected(w,npc)){
        assert.equal(kill(npc),true); cleared++; count++; last=npc;
      }
      flush();
      assert.ok(cleared>0,`gate ${id} must not deadlock at phase ${run().wave}`);
      if(run().state==='active'&&run().waiting_next_wave){assert.equal(w.npcs.size,0);assert.equal(gates.portalRows(w).length,2);continueNextWave();}
    }
    assert.equal(run().state,'won',`gate ${id} completes`); assert.equal(count,slots.length);
    assert.equal(p.mapId,1); assert.equal(w.npcs.size,0);
    const after=db.prepare('SELECT ep,honour,credits,uridium,galaxy_gates_done FROM players WHERE id=?').get(p.userId);
    for(const field of ['ep','honour','credits','uridium'])assert.equal(after[field]-before[field],expected[field],`${id}:${field}`);
    assert.equal(after.galaxy_gates_done,before.galaxy_gates_done|({1:1,2:2,3:4,4:8,5:16,6:32}[id]||0));
    assert.equal(db.prepare('SELECT count(*) n FROM galaxy_gate_kill_claims WHERE run_id=?').get(run().id).n,slots.length);
    assert.equal(gates.onNpcKilled(w,last,s),false);
    assert.deepEqual(db.prepare('SELECT ep,honour,credits,uridium,galaxy_gates_done FROM players WHERE id=?').get(p.userId),after);
  }
  } finally { completion.resolve = original; }
});
