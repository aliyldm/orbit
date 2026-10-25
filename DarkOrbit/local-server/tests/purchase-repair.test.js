'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db'), players = require('../game/db/players'), repair = require('../tools/repair-drone-purchases');
const log = repair.EVENTS.map(time => `${time} 200 POST /ajax/shop.php ua="test" SHOP purchase 2 x1 -> success`).join('\n');
let db;
beforeEach(() => {
  database.close(); db = database.open(':memory:');
  for (const name of ['other', 'asd']) players.createPlayer(players.createAccount(name, 'testpass'), name, 1, { ...require('../config.json').starter, uridium: 100000 });
  db.prepare('INSERT INTO player_boosters VALUES(?,?,?)').run(2, 'booster_hon-b01', repair.EXPIRY);
  db.prepare('INSERT INTO settings VALUES(?,?,?)').run(2, 'QualitySettingsModule', JSON.stringify({ qualityShip: 0, qualityBackground: 1, qualityCustomized: false }));
});
afterEach(() => database.close());
test('approved correction creates two Iris, applies net19000 once, preserves other account, and restores original sprites', () => {
  assert.equal(repair.plan(db, log).afterUridium, 81000);
  const fixed = repair.apply(db, log); assert.equal(fixed.droneIds.length, 2);
  assert.equal(db.prepare('SELECT uridium FROM players WHERE id=2').get().uridium, 81000);
  assert.equal(db.prepare('SELECT uridium FROM players WHERE id=1').get().uridium, 100000);
  assert.equal(db.prepare('SELECT COUNT(*) n FROM player_boosters WHERE player_id=2').get().n, 0);
  const quality = JSON.parse(db.prepare('SELECT value FROM settings WHERE player_id=2').get().value);
  assert.equal(quality.qualityShip, 1); assert.equal(quality.qualityBackground, 1);
  assert.deepEqual(repair.apply(db, log), { alreadyApplied: true });
  assert.equal(db.prepare('SELECT COUNT(*) n FROM drones WHERE player_id=2').get().n, 2);
});
test('changed booster ledger or missing evidence prevents unverified compensation', () => {
  assert.throws(() => repair.apply(db, ''), /evidence/);
  db.prepare('UPDATE player_boosters SET expires_at=expires_at+1').run();
  assert.throws(() => repair.apply(db, log), /Booster changed/);
  assert.equal(db.prepare('SELECT COUNT(*) n FROM drones').get().n, 0);
});
test('a storage failure rolls back both drones, balance, booster and quality together', () => {
  db.exec("CREATE TRIGGER fail_repair BEFORE DELETE ON player_boosters BEGIN SELECT RAISE(ABORT,'repair-storage'); END");
  assert.throws(() => repair.apply(db, log), /repair-storage/);
  assert.equal(db.prepare('SELECT COUNT(*) n FROM drones').get().n, 0);
  assert.equal(db.prepare('SELECT uridium FROM players WHERE id=2').get().uridium, 100000);
  assert.equal(db.prepare('SELECT expires_at FROM player_boosters').get().expires_at, repair.EXPIRY);
});
