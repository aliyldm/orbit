'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db');
const players = require('../game/db/players');
const gates = require('../game/galaxy-gates');
const systems = require('../game/handlers/systems');
const codec = require('../game/codec/codec');
let db, world, session, other, sent, queue, returned;
function makeWorld(player) {
  const w = { player, config: { galaxyGates: { waveCount: 2, npcsPerWave: 2, waveDelayMs: 0 } }, sessions: new Set(), npcs: new Map(), gatesDb: db,
    updatePosition() { return this.player; }, schedule(fn) { queue.push(fn); }, gatesChangeMap(s, map, x, y) { Object.assign(s.player, { mapId: map, x, y }); returned++; } };
  let next = 100000;
  w.combat = { spawn(def) { const npc = { id: next++, def, hp: def.hitpoints, shield: def.shield, x: 5000, y: 5000 }; w.npcs.set(npc.id, npc); return npc; },
    send(s, command) {
      const decoded = codec.decode(codec.encode(command)); assert.equal(decoded.rest, 0); assert.deepEqual(decoded.obj, command); sent.push(command);
    } };
  return w;
}
beforeEach(() => {
  database.close(); db = database.open(':memory:'); sent = []; queue = []; returned = 0;
  const add = name => {
    const a = db.prepare('INSERT INTO accounts(username,password_hash,created_at) VALUES(?,?,0)').run(name, 'test');
    const id = players.createPlayer(Number(a.lastInsertRowid), name, 1, require('../config.json').starter);
    db.prepare('UPDATE players SET uridium=100000 WHERE id=?').run(id); return players.loadPlayer(id);
  };
  world = makeWorld(add('gate-one')); other = add('gate-two'); session = { world, player: world.player }; world.sessions.add(session);
  systems.gateInfo(world.player, db);
});
afterEach(() => database.close());
function completeParts(gateId = 1, player = world.player) {
  systems.gateInfo(player, db);
  const parts = Array.from({ length: gates.DEFINITIONS[gateId].parts }, (_, i) => i + 1);
  db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=?').run(JSON.stringify(parts), player.userId, gateId);
}
function setup(gateId = 1) { completeParts(gateId); const response = gates.setup(session, gateId, { db }); assert.equal(response.errorCode, 0); return response; }
function enter(gateId = 1) { world.player.mapId = gates.DEFINITIONS[gateId].map; gates.spawnWave(world, world.combat); }
function kill(npc) { const result = gates.onNpcKilled(world, npc, session); world.npcs.delete(npc.id); return result; }
function killWave() { for (const npc of [...world.npcs.values()]) kill(npc); }
function flush() { const work = queue; queue = []; for (const fn of work) fn(); }
function run() { return db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=? ORDER BY id DESC LIMIT 1').get(world.player.userId); }
function continueNextWave(){assert.equal(run().waiting_next_wave,1);const portal=gates.portalRows(world).find(row=>row.gateAction==='continue');assert.ok(portal);Object.assign(world.player,{x:portal.x,y:portal.y});assert.equal(gates.prepareTransition(world,portal),true);gates.spawnWave(world,world.combat);}

test('setup consumes complete owned parts once and creates only owner-visible real portals', () => {
  assert.equal(gates.setup(session, 1, { db }).errorCode, 1);
  setup(); assert.equal(run().wave_count, 2); assert.equal(run().lives, 3);
  assert.equal(gates.setup(session, 1, { db }).errorCode, 1);
  assert.equal(gates.portalRows(world).length, 1);
  assert.equal(gates.portalRows(makeWorld(other)).length, 0);
  for (const command of gates.portals(world)) world.combat.send(session, command);
  assert.equal(systems.gateInfo(world.player, db).gates.find(g => g.id === 1).currPart, 0);
  assert.equal(db.prepare('SELECT count(*) AS n FROM galaxy_gate_runs').get().n, 1);
});
test('gate map access requires owner and live run; portal interaction requires server distance', () => {
  setup(); assert.equal(gates.canEnter(world, 51), true); assert.equal(gates.canEnter(makeWorld(other), 51), false);
  assert.equal(gates.nearestPortal(world), null);
  const portal = gates.portalRows(world)[0]; Object.assign(world.player, { x: portal.x, y: portal.y });
  assert.equal(gates.nearestPortal(world).target_map, 51);
  world.player.dead = true; assert.equal(gates.nearestPortal(world), null);
});
test('waves persist each remaining NPC, advance after stack, and award final completion once', () => {
  setup(); const p = world.player, uri = p.uridium, credits = p.credits;
  enter(); assert.equal(world.npcs.size, 2); assert.equal(run().wave, 1);
  const last = [...world.npcs.values()][1];
  killWave(); assert.equal(world.npcs.size, 0); assert.equal(run().wave, 2); assert.equal(queue.length, 0);assert.equal(run().waiting_next_wave,1);
  assert.equal(gates.onNpcKilled(world, last, session), false);
  flush();assert.equal(world.npcs.size,0,'waiting is not an automatic deferred wave');continueNextWave(); assert.equal(world.npcs.size, 2); assert.equal(run().wave, 2);
  const finalNpc = [...world.npcs.values()][1]; killWave();
  assert.equal(run().state, 'won'); assert.equal(p.uridium, uri + 200); assert.equal(p.credits, credits + 2000);
  assert.equal(p.galaxyGatesDone, 1); assert.equal(returned, 0);
  assert.equal(gates.onNpcKilled(world, finalNpc, session), false); assert.equal(p.uridium, uri + 200);
  assert.equal(db.prepare('SELECT galaxy_gates_done FROM players WHERE id=?').get(p.userId).galaxy_gates_done, 1);
  assert.equal(db.prepare("SELECT sum(amount) AS n FROM items WHERE player_id=? AND loot_id='ammunition_laser_ucb-100'").get(p.userId).n, 200);
  assert.ok(sent.some(c => c._ === 'GalaxyGateBuilderGateCompleteCommand')); flush(); assert.equal(returned, 1); assert.equal(p.mapId, 1);
});

test('gate completion boosts owned EP and honour once without multiplying money or ammo', () => {
  const boosters = require('../game/boosters'), p = world.player;
  database.tx(db => { boosters.addOwned(db, p.userId, 'booster_ep-b01'); boosters.addOwned(db, p.userId, 'booster_hon-b01'); });
  const before = db.prepare('SELECT ep,honour,uridium FROM players WHERE id=?').get(p.userId);
  setup(); enter(); killWave();continueNextWave(); flush();
  const finalNpc = [...world.npcs.values()][1]; killWave();
  const after = db.prepare('SELECT ep,honour,uridium FROM players WHERE id=?').get(p.userId);
  assert.equal(after.ep - before.ep, 2200); assert.equal(after.honour - before.honour, 220); assert.equal(after.uridium - before.uridium, 200);
  assert.equal(gates.onNpcKilled(world, finalNpc, session), false);
  assert.deepEqual(db.prepare('SELECT ep,honour,uridium FROM players WHERE id=?').get(p.userId), after);
});
test('reconnecting resumes remaining NPCs without repeating completed kills or awards', () => {
  setup(); enter(); kill([...world.npcs.values()][0]);
  assert.equal(JSON.parse(run().remaining_json).length, 1);
  const p = world.player, restarted = makeWorld(p); restarted.sessions.add(session); session.world = restarted; world = restarted;
  gates.spawnWave(world, world.combat); assert.equal(world.npcs.size, 1); assert.equal(run().wave, 1);
  killWave(); assert.equal(run().wave, 2); flush();assert.equal(world.npcs.size,0);continueNextWave(); assert.equal(world.npcs.size, 2);
});
test('death consumes one life, resets only current wave, and a repair allows re-entry', () => {
  setup(); enter(); kill([...world.npcs.values()][0]);
  world.player.dead = true; assert.equal(gates.onPlayerDeath(world), true); assert.equal(run().lives, 2);
  assert.equal(gates.onPlayerDeath(world), false); assert.equal(run().lives, 2);
  world.npcs.clear(); gates.spawnWave(world, world.combat); assert.equal(world.npcs.size, 0);
  world.player.dead = false; gates.spawnWave(world, world.combat); assert.equal(world.npcs.size, 2); assert.equal(run().death_pending, 0);
  assert.ok(sent.some(c => c._ === 'GalaxyGateBuilderGateLifeLostCommand' && c.livesLeft === 2));
});
test('all lives lost removes entry portal and blocks further map access until rebuilt', () => {
  setup(); enter();
  for (let i = 0; i < 3; i++) {
    world.player.dead = true; gates.onPlayerDeath(world); world.npcs.clear();
    if (i < 2) { world.player.dead = false; gates.spawnWave(world, world.combat); }
  }
  assert.equal(run().state, 'failed'); assert.equal(run().lives, 0); assert.equal(gates.canEnter(world, 51), false);
  world.player.mapId = 1; world.player.dead = false; assert.deepEqual(gates.portalRows(world), []);
  assert.equal(gates.buyLife(session, 1, { db }).errorCode, 2);
  assert.equal(gates.setup(session, 1, { db }).errorCode, 1);
  setup(); assert.equal(run().state, 'active'); assert.equal(run().lives, 3);
});
test('life purchase atomically debits real currency and updates builder and runtime lives', () => {
  setup(); const before = world.player.uridium;
  const response = gates.buyLife(session, 1, { db }); world.combat.send(session, response);
  assert.equal(response.errorCode, 0); assert.equal(response.money, before - gates.LIFE_PRICE);
  assert.equal(run().lives, 4); assert.equal(world.player.uridium, response.money);
  assert.equal(systems.gateInfo(world.player, db).gates.find(g => g.id === 1).livesLeft, 4);
  db.prepare('UPDATE players SET uridium=0 WHERE id=?').run(world.player.userId); world.player.uridium = 0;
  assert.equal(gates.buyLife(session, 1, { db }).errorCode, 1); assert.equal(run().lives, 4);
});
test('life storage failure rolls back currency and both lives counters', () => {
  setup(); const before = world.player.uridium;
  db.exec("CREATE TRIGGER gate_life_failure BEFORE UPDATE ON galaxy_gate_progress BEGIN SELECT RAISE(ABORT,'injected life failure'); END");
  assert.throws(() => gates.buyLife(session, 1, { db }), /injected life failure/);
  assert.equal(world.player.uridium, before); assert.equal(run().lives, 3);
  assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(world.player.userId).uridium, before);
});
test('final reward storage failure rolls back completion and awards, leaving kill retryable', () => {
  world.config.galaxyGates.waveCount = 1; world.config.galaxyGates.npcsPerWave = 1;
  setup(); enter(); const npc = [...world.npcs.values()][0], before = world.player.uridium;
  db.exec("CREATE TRIGGER gate_reward_failure BEFORE INSERT ON items BEGIN SELECT RAISE(ABORT,'injected completion failure'); END");
  assert.throws(() => gates.onNpcKilled(world, npc, session), /injected completion failure/);
  assert.equal(run().state, 'active'); assert.equal(JSON.parse(run().remaining_json).length, 1);
  assert.equal(db.prepare('SELECT galaxy_gates_done FROM players WHERE id=?').get(world.player.userId).galaxy_gates_done, 0);
  assert.equal(world.player.uridium, before); assert.equal(world.npcs.size, 1);
  assert.ok(!sent.some(c => c._ === 'GalaxyGateBuilderGateCompleteCommand'));
  db.exec('DROP TRIGGER gate_reward_failure'); kill(npc); assert.equal(run().state, 'won');
});
test('known client gate map and wave count contracts are used for every supported gate', () => {
  delete world.config.galaxyGates.waveCount;
  for (const [id, gate] of Object.entries(gates.DEFINITIONS)) {
    if(+id===12)continue; // Owned per-source Kronos parts have dedicated tests.
    setup(Number(id)); const stored = run();
    assert.equal(stored.map_id, gate.map); assert.equal(stored.wave_count, gate.waves);
    assert.equal(gates.isGateMap(gate.map), true);
  }
  assert.equal(gates.portalRows(world).length, 10);
});
test('real Gameplay and Combat complete entry, kill, award, and return on the same authenticated session', () => {
  const World = require('../game/world'), Combat = require('../game/combat'), gameplay = require('../game/gameplay');
  const config = JSON.parse(JSON.stringify(require('../config.json')));
  config.galaxyGates = { waveCount: 1, npcsPerWave: 1, waveDelayMs: 0 };
  const w = new World(config), s = { world: w, send() {}, close() {} };
  w.login(s, world.player.userId);
  const jobs = [];
  w.schedule = (fn, delay) => { jobs.push({ fn, delay }); };
  const sender = (target, command) => {
    const decoded = codec.decode(codec.encode(command)); assert.equal(decoded.rest, 0); sent.push(decoded.obj);
  };
  const combat = new Combat(w, sender);
  gameplay.register(() => {}, { sendCmd: sender, combatFor: () => combat, buildInit: target => gameplay.initialize(target) });
  const parts = Array.from({ length: 34 }, (_, i) => i + 1);
  db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=1').run(JSON.stringify(parts), s.player.userId);
  assert.equal(gates.setup(s, 1, { db }).errorCode, 0);
  const portal = gates.portalRows(w)[0]; Object.assign(s.player, { x: portal.x, y: portal.y });
  assert.equal(gameplay.jump(s, portal.id), true);
  jobs.shift().fn(); assert.equal(s.player.mapId, 51); assert.equal(combat.npcs.size, 1);
  const npc = [...combat.npcs.values()][0]; npc.hp = 0; combat.kill(s, npc);
  assert.equal(db.prepare('SELECT state FROM galaxy_gate_runs WHERE player_id=?').get(s.player.userId).state, 'won');
  assert.equal(s.player.galaxyGatesDone, 1); assert.equal(s.player.mapId, 51);
  const transfer = jobs.find(job => job.delay === 0); assert.ok(transfer); transfer.fn();
  assert.equal(s.player.mapId, 1); assert.equal(db.prepare('SELECT map_id FROM players WHERE id=?').get(s.player.userId).map_id, 1);
  assert.ok(sent.some(c => c._ === 'GalaxyGateBuilderGateCompleteCommand'));
  assert.ok(sent.some(c => c._ === 'JumpToServerCommand'));
  w.removeSession(s); assert.equal(combat.timer, null);
});
