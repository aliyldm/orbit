'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db');
const players = require('../game/db/players');
const hotbar = require('../game/hotbar');
const core = require('../game/handlers/core');
const codec = require('../game/codec/codec');
let player, other;
beforeEach(() => {
  database.close(); database.open(':memory:');
  function add(name) { return players.loadPlayer(players.createPlayer(players.createAccount(name, 'testpass'), name, 1, require('../config.json').starter)); }
  player = add('hotbar-one'); other = add('hotbar-two');
});
afterEach(() => database.close());
const move = (item, from = '', source = 0, to = 'standardSlotBar', target = 4) => hotbar.move(player.userId, {
  menuItemId: item, slotBarIdFrom: from, slotIdFrom: source, slotBarIdTo: to, slotIdTo: target });
const find = (p, bar, slot) => core.menu(p).slotBars.find(b => b.slotBarId === bar)?.slots.find(s => s.slotId === slot)?.menuItemId;
test('a category drag survives subsequent menu refreshes and player reconstruction', () => {
  assert.equal(move('ammunition_laser_mcb-50'), true);
  for (let i = 0; i < 3; i++) assert.equal(find(players.loadPlayer(player.userId), 'standardSlotBar', 4), 'ammunition_laser_mcb-50');
  assert.equal(find(other, 'standardSlotBar', 4), undefined);
  assert.equal(codec.decode(codec.encode(core.menu(player))).rest, 0);
});
test('moving occupied slots swaps, removing a slot persists, and other bars retain their slots', () => {
  assert.equal(move('ammunition_laser_lcb-10', 'standardSlotBar', 1, 'standardSlotBar', 2), true);
  assert.equal(find(player, 'standardSlotBar', 1), 'ammunition_rocket_r-310');
  assert.equal(find(player, 'standardSlotBar', 2), 'ammunition_laser_lcb-10');
  assert.equal(move('ammunition_laser_lcb-10', 'standardSlotBar', 2, 'premiumSlotBar', 3), true);
  assert.equal(find(player, 'premiumSlotBar', 3), 'ammunition_laser_lcb-10');
  assert.equal(move('ammunition_laser_lcb-10', 'premiumSlotBar', 3, '', 0), true);
  assert.equal(find(player, 'premiumSlotBar', 3), undefined);
  assert.equal(find(player, 'standardSlotBar', 1), 'ammunition_rocket_r-310');
});
test('unknown items, bars, slots and stale source slots cannot corrupt the layout', () => {
  for (const args of [['__proto__'], ['ammunition_laser_mcb-50', '', 0, '__proto__', 1], ['ammunition_laser_mcb-50', '', 0, 'standardSlotBar', 11], ['ammunition_laser_mcb-50', 'standardSlotBar', 1]])
    assert.equal(move(...args), false);
  assert.equal(find(player, 'standardSlotBar', 1), 'ammunition_laser_lcb-10');
});
test('actual SlotBarConfigSetRequest receives an authoritative menu containing the new item', () => {
  const handlers = new Map(), sent = [];
  core.register((name, fn) => handlers.set(name, fn), { sendCmd: (session, cmd) => { codec.encode(cmd); sent.push(cmd); } });
  const world = { player, sessions: new Set(), active: () => true, config: require('../config.json') };
  const session = { player, world }; world.sessions.add(session);
  handlers.get('SlotBarConfigSetRequest')(session, { _: 'SlotBarConfigSetRequest', menuItemId: 'ammunition_laser_mcb-50', slotBarIdFrom: '', slotIdFrom: 0, slotBarIdTo: 'standardSlotBar', slotIdTo: 5 });
  assert.equal(sent[0].slotBars[0].slots.find(s => s.slotId === 5).menuItemId, 'ammunition_laser_mcb-50');
});
