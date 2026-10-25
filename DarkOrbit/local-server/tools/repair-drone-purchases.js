'use strict';
// Evidence-scoped repair approved in chat: two Iris attempts hit numeric
// Booster SKU2 at these exact timestamps. Must run with the game server stopped.
const fs = require('node:fs');
const assert = require('node:assert/strict');
const path = require('node:path');
const REPAIR = 'iris-sku-collision-player2-2026-10-19';
const EVENTS = ['2026-10-19T18:43:39.367Z', '2026-10-19T18:49:05.649Z'];
const EXPIRY = 1792507419366;
function plan(db, log) {
  const exists = db.prepare("SELECT 1 FROM sqlite_master WHERE name='local_repairs'").get();
  if (exists && db.prepare('SELECT 1 FROM local_repairs WHERE id=?').get(REPAIR)) return { alreadyApplied: true };
  const player = db.prepare('SELECT p.*,a.username FROM players p JOIN accounts a ON a.id=p.account_id WHERE p.id=2').get();
  assert.equal(player?.username, 'asd', 'Account identity differs; no changes allowed.');
  for (const time of EVENTS) assert.ok(log.includes(`${time} 200 POST /ajax/shop.php`) && log.split('\n').some(line => line.startsWith(time) && line.includes('SHOP purchase 2 x1 -> success')), 'Purchase evidence is missing.');
  const booster = db.prepare('SELECT * FROM player_boosters WHERE player_id=2 AND loot_id=?').get('booster_hon-b01');
  assert.equal(booster?.expires_at, EXPIRY, 'Booster changed since the two verified mistakes; refusing to remove other purchases.');
  assert.equal(db.prepare('SELECT COUNT(*) n FROM drones WHERE player_id=2').get().n, 0, 'Drone ownership changed; re-evaluate the repair.');
  assert.ok(player.uridium >= 19000, 'Insufficient balance for approved correction.');
  return { playerId: 2, username: player.username, refund: 20000, prices: [15000, 24000], charge: 39000, netDebit: 19000,
    beforeUridium: player.uridium, afterUridium: player.uridium - 19000, events: EVENTS };
}
function apply(db, log) {
  db.exec('SAVEPOINT repair_iris_sku');
  try {
    const quote = plan(db, log); if (quote.alreadyApplied) { db.exec('RELEASE repair_iris_sku'); return quote; }
    const drones = require('../game/drones'), meta = require('../docs/client-map.items.json').items.drone_iris;
    db.prepare('INSERT OR IGNORE INTO item_types(loot_id,name,category,price_credits,price_uridium)VALUES(?,?,?,?,?)').run('drone_iris', meta.typeValue, 'drone', meta.credits || 0, meta.uridium || 0);
    const droneIds = [];
    for (const price of quote.prices) {
      assert.equal(drones.purchasePrice(db, 2, 'drone_iris'), price);
      droneIds.push(drones.addOwned(db, 2, 'drone_iris'));
    }
    assert.equal(db.prepare('UPDATE players SET uridium=uridium-? WHERE id=2 AND uridium>=?').run(quote.netDebit, quote.netDebit).changes, 1);
    assert.equal(db.prepare('DELETE FROM player_boosters WHERE player_id=2 AND loot_id=? AND expires_at=?').run('booster_hon-b01', EXPIRY).changes, 1);
    // The requested angled 2D artwork is disabled only by qualityShip=0.
    const row = db.prepare('SELECT value FROM settings WHERE player_id=2 AND key=?').get('QualitySettingsModule');
    if (row) {
      const quality = JSON.parse(row.value); quality.qualityShip = Math.max(1, quality.qualityShip); quality.qualityCustomized = true;
      db.prepare('UPDATE settings SET value=? WHERE player_id=2 AND key=?').run(JSON.stringify(quality), 'QualitySettingsModule');
    }
    const result = { ...quote, droneIds, appliedAt: new Date().toISOString() };
    db.exec('CREATE TABLE IF NOT EXISTS local_repairs(id TEXT PRIMARY KEY,player_id INTEGER NOT NULL REFERENCES players(id),details TEXT NOT NULL,applied_at INTEGER NOT NULL)');
    db.prepare('INSERT INTO local_repairs VALUES(?,?,?,?)').run(REPAIR, 2, JSON.stringify(result), Date.now());
    db.exec('RELEASE repair_iris_sku'); return result;
  } catch (error) { db.exec('ROLLBACK TO repair_iris_sku; RELEASE repair_iris_sku'); throw error; }
}
async function main() {
  const database = require('../game/db');
  const db = process.argv.includes('--apply') ? database.open() : new (require('node:sqlite').DatabaseSync)(database.DB_FILE, { readOnly: true });
  try {
    const log = fs.readFileSync(path.resolve(__dirname, '../logs/http-requests.log'), 'utf8');
    console.log(JSON.stringify(process.argv.includes('--apply') ? apply(db, log) : plan(db, log), null, 2));
    assert.equal(db.prepare('PRAGMA integrity_check').get().integrity_check, 'ok');
    assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(), []);
  } finally { process.argv.includes('--apply') ? database.close() : db.close(); }
}
module.exports = { plan, apply, EVENTS, EXPIRY };
if (require.main === module) main().catch(error => { console.error(error.stack); process.exitCode = 1; });
