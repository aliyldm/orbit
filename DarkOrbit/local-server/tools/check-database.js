'use strict';
// Snapshot the existing database with SQLite's online backup (includes WAL),
// then test upgrades on a second copy. Never migrate the user's source here.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { DatabaseSync, backup } = require('node:sqlite');
const database = require('../game/db');
async function main() {
  const source = path.resolve(process.argv[2] || database.DB_FILE);
  const folder = path.resolve(__dirname, '../backups'); fs.mkdirSync(folder, { recursive: true });
  const stamp = new Date().toISOString().replace(/[:.]/g, '-');
  const snapshot = path.join(folder, `darkorbit-before-${stamp}.db`);
  const check = path.join(folder, `darkorbit-migration-check-${stamp}.db`);
  const liveSource = new DatabaseSync(source, { readOnly: true });
  try { await backup(liveSource, snapshot); } finally { liveSource.close(); }
  const original = new DatabaseSync(snapshot, { readOnly: true });
  let accounts, players, ships;
  // Include new feature ledgers automatically: Payment receipts, season claims,
  // assembly jobs, both equipment configurations and future ownership tables.
  const quoted=name=>'"'+name.replaceAll('"','""')+'"';
  const progressTables=original.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all()
    .map(row=>row.name).filter(name=>!['accounts','players'].includes(name)&&original.prepare(`PRAGMA table_info(${quoted(name)})`).all().some(c=>['player_id','ship_id','account_id','drone_id'].includes(c.name)));
  const progressSnapshots=new Map();
  try {
    assert.equal(original.prepare('PRAGMA integrity_check').get().integrity_check, 'ok');
    assert.deepEqual(original.prepare('PRAGMA foreign_key_check').all(), []);
    accounts = original.prepare('SELECT * FROM accounts ORDER BY id').all();
    players = original.prepare('SELECT * FROM players ORDER BY id').all();
    ships = original.prepare('SELECT id,player_id,loot_id,hitpoints,shield,favorite FROM ships ORDER BY id').all();
    for(const table of progressTables)if(original.prepare("SELECT 1 FROM sqlite_master WHERE type='table' AND name=?").get(table)){
      // Compare all original columns; additive migrations may introduce new
      // defaulted columns without changing any previous ownership/progress.
      const columns=original.prepare(`PRAGMA table_info(${table})`).all().map(c=>'"'+c.name.replaceAll('"','""')+'"').join(',');
      progressSnapshots.set(table,{columns,rows:original.prepare(`SELECT ${columns} FROM ${table}`).all().map(row=>JSON.stringify(row)).sort()});
    }
  } finally { original.close(); }
  fs.copyFileSync(snapshot, check);
  try {
    const upgraded = database.open(check);
    assert.deepEqual(upgraded.prepare('SELECT * FROM accounts ORDER BY id').all(), accounts, 'accounts must survive migration exactly');
    const normalizeIcon=row=>{const copy={...row};delete copy.galaxy_gates_done;return copy;};
    const upgradedPlayers=upgraded.prepare('SELECT * FROM players ORDER BY id').all();
    assert.deepEqual(upgradedPlayers.map(normalizeIcon),players.map(normalizeIcon),'wallet, position and player progress must survive');
    for(const row of upgradedPlayers)assert.equal(row.galaxy_gates_done,require('../game/gate-rings').derive(upgraded,row.id),'native completion mask must match real gate history');
    assert.deepEqual(upgraded.prepare('SELECT id,player_id,loot_id,hitpoints,shield,favorite FROM ships ORDER BY id').all(), ships);
    for(const [table,{columns,rows}] of progressSnapshots)assert.deepEqual(upgraded.prepare(`SELECT ${columns} FROM ${table}`).all().map(row=>JSON.stringify(row)).sort(),rows,`${table} ownership/progress must survive exactly`);
    assert.equal(upgraded.prepare('PRAGMA integrity_check').get().integrity_check, 'ok');
    assert.deepEqual(upgraded.prepare('PRAGMA foreign_key_check').all(), []);
    for (const player of players) assert.ok(require('../game/db/players').loadPlayer(player.id));
    console.log(`PASS: ${accounts.length} accounts, ${players.length} players, ${ships.length} ships and ${progressSnapshots.size} ownership/progress tables preserved; all migrations, player stats and SQLite integrity verified.`);
    console.log(`Unmodified backup: ${snapshot}`);
    console.log(`Verified upgrade copy: ${check}`);
  } finally { database.close(); }
}
if (require.main === module) main().catch(error => { console.error(error.stack); process.exitCode = 1; });
