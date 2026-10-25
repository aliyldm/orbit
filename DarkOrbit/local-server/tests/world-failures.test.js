'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { open } = require('../game/db');
const db = open(':memory:');
const players = require('../game/db/players');
const config = require('../config');
const World = require('../game/world');
const { Collectables } = require('../game/collectables');
let serial = 0;
function fixture(services = {}) {
  const account = players.createAccount(`world-failure-${++serial}`, 'test-pass');
  const id = players.createPlayer(account, 'QA', 1, config.starter);
  const world = new World(config, services);
  const session = { world, close() { this.closed = true; }, send() {} };
  world.login(session, id);
  return { id, world, session };
}

test('failed delayed harvest rolls back, closes the affected session and cancels later work', t => {
  t.mock.timers.enable({ apis: ['setTimeout'] });
  const errors = [];
  t.mock.method(console, 'error', (...args) => errors.push(args));
  const { id, world, session } = fixture();
  Object.assign(world.player, { x: 6000, y: 6000 });
  world.collectables = new Collectables(world, () => {});
  const box = world.collectables.add({ x: 6000, y: 6000, oreType: 0, amount: 10 }, false);
  db.exec("CREATE TEMP TRIGGER fail_harvest BEFORE INSERT ON player_resources BEGIN SELECT RAISE(ABORT,'injected harvest failure'); END");
  let laterRan = false;
  try {
    assert.equal(world.collectables.beginHarvest(session, { itemHash: box.hash }, true), true);
    world.schedule(() => { laterRan = true; }, 2000);
    t.mock.timers.tick(500);
    assert.equal(session.closed, true);
    assert.equal(world.player, null);
    assert.equal(world.sessions.size, 0);
    assert.equal(world.scheduled.size, 0);
    assert.equal(world.collectables, null);
    assert.equal(db.prepare('SELECT COUNT(*) n FROM player_resources WHERE player_id=?').get(id).n, 0);
    assert.match(String(errors[0][1]), /injected harvest failure/);
    t.mock.timers.tick(2000);
    assert.equal(laterRan, false);
  } finally { db.exec('DROP TRIGGER fail_harvest'); }
  const next = { world, close() {}, send() {} };
  assert.equal(world.login(next, id).userId, id);
  world.removeSession(next);
});

test('save failure still clears map state and timers and cannot leave a phantom active player', t => {
  t.mock.timers.enable({ apis: ['setTimeout'] });
  const saveError = new Error('injected save failure');
  const { id, world, session } = fixture({ players: { loadPlayer: players.loadPlayer, savePlayer() { throw saveError; } } });
  let stopped = false, cleared = false, laterRan = false;
  world.combat = { stop() { stopped = true; } };
  world.collectables = { clear() { cleared = true; } };
  world.schedule(() => { laterRan = true; }, 1000);
  assert.throws(() => world.removeSession(session), error => error === saveError);
  assert.equal(stopped, true); assert.equal(cleared, true);
  assert.equal(world.player, null); assert.equal(session.player, null);
  assert.equal(world.livePlayer(id), null); assert.equal(world.scheduled.size, 0);
  t.mock.timers.tick(2000); assert.equal(laterRan, false);
});

test('delayed failure also closes its socket if saving during cleanup fails', t => {
  t.mock.timers.enable({ apis: ['setTimeout'] });
  const errors = [];
  t.mock.method(console, 'error', (...args) => errors.push(args));
  const { world, session } = fixture({ players: { loadPlayer: players.loadPlayer, savePlayer() { throw Error('disk unavailable'); } } });
  world.schedule(() => { throw Error('delayed action failed'); }, 100);
  t.mock.timers.tick(100);
  assert.equal(session.closed, true); assert.equal(world.player, null);
  assert.equal(world.sessions.size, 0); assert.equal(world.scheduled.size, 0);
  assert.equal(errors.length, 2);
  assert.match(String(errors[1][1]), /disk unavailable/);
});
