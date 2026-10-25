'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db'), players = require('../game/db/players'), World = require('../game/world'), ammo = require('../game/ammo');
const original = World.current;
let player, commands, world;
beforeEach(() => {
  database.close(); const db = database.open(':memory:');
  player = players.loadPlayer(players.createPlayer(players.createAccount('ammo-delta', 'testpass'), 'ammo-delta', 1, require('../config.json').starter));
  commands = [];
  world = { livePlayer: () => player, broadcast: fn => fn({ send() {} }) };
  World.current = () => world;
  ammo.remember(player, ammo.buildAmmoCommands(player));
  db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,?)').run(player.userId, 'ammunition_laser_mcb-25', 1000);
  ammo.notify(player, { world, sendCmd: (_, c) => commands.push(c) }); commands.length = 0;
});
afterEach(() => { World.current = original; database.close(); });
test('unchanged action-bar state sends no command even after repeated refreshes', () => {
  for (let i = 0; i < 20; i++) assert.equal(ammo.notify(player, { world, sendCmd: (_, c) => commands.push(c) }), 0);
  assert.equal(commands.length, 0);
});
test('changing the selected laser sends only the old and new selection', () => {
  player.ammo = 'ammunition_laser_mcb-25'; player.ammoMultiplier = 2;
  assert.equal(ammo.notify(player, { world, sendCmd: (_, c) => commands.push(c) }), 2);
  assert.deepEqual(commands.map(c => c.menuItemId).sort(), ['ammunition_laser_lcb-10', 'ammunition_laser_mcb-25']);
  assert.equal(ammo.notify(player, { world, sendCmd: (_, c) => commands.push(c) }), 0);
});
test('a shot updates only the consumed ammunition counter rather than rebuilding all menu entries', () => {
  database.open().prepare('UPDATE items SET amount=amount-1 WHERE player_id=? AND loot_id=?').run(player.userId, ammo.DEFAULT_AMMO);
  assert.equal(ammo.notify(player, { world, sendCmd: (_, c) => commands.push(c) }), 1);
  assert.equal(commands[0].menuItemId, ammo.DEFAULT_AMMO); assert.equal(commands[0].counterValue, 4999);
});
