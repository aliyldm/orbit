'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db');
const players = require('../game/db/players');
const api = require('../web/upgrade-api');
let db, player, laser;
beforeEach(() => {
  database.close(); db = database.open(':memory:');
  const id = players.createPlayer(players.createAccount('upgrade-ui', 'testpass'), 'upgrade-ui', 1, { ...require('../config.json').starter, credits: 100000000, uridium: 100000000 });
  player = players.loadPlayer(id);
  laser = Number(db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,1)').run(id, 'equipment_weapon_laser_lf-3').lastInsertRowid);
});
afterEach(() => database.close());
test('upgrade page shows actual owned targets, human level1-to16 and cost previews', () => {
  const html = api.render(player);
  assert.match(html, /Eşya Geliştirme/); assert.match(html, /Seviye 1 \/ 16/);
  assert.match(html, /<option value="16"/);
  assert.match(html, /data-cost="/);
  assert.match(html, /Montaj → Geliştirme/);
});
test('human level16 submits source upgrade index15 and completed job can be collected once', () => {
  const target = api.targets(player.userId, 1000).find(row => row.item.id === laser);
  for (const step of target.definition.costs) for (const part of step.parts) if (!part.lootID.startsWith('currency_'))
    db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,?)').run(player.userId, part.lootID, part.ammount);
  const params = new URLSearchParams({ subaction: 'build', recipe: target.recipeId, target: String(laser), level: '16' });
  const result = api.handle(player.userId, params, { now: 1000 }); assert.equal(result.ok, true, result.message);
  const job = db.prepare('SELECT * FROM assembly_jobs WHERE player_id=? AND target_id=?').get(player.userId, laser);
  assert.equal(job.amount, 15);
  params.set('subaction', 'collect');
  assert.equal(api.handle(player.userId, params, { now: job.due_at - 1 }).ok, false);
  assert.equal(api.handle(player.userId, params, { now: job.due_at }).ok, true);
  assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(laser).upgrade_level, 15);
  assert.equal(api.handle(player.userId, params, { now: job.due_at }).ok, false);
});
test('other-account and nonexistent upgrade targets cannot debit this account', () => {
  const money = db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(player.userId);
  const result = api.handle(player.userId, new URLSearchParams({ subaction: 'build', recipe: 'upgrade_upgrade-class1', target: '999999', level: '16' }));
  assert.equal(result.ok, false); assert.deepEqual(db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(player.userId), money);
});
