'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs'), path = require('node:path');
const database = require('../game/db'), players = require('../game/db/players'), systems = require('../game/handlers/systems');
const rewards = require('../game/gate-builder-rewards'), codec = require('../game/codec/codec');
let db, p, other;
beforeEach(() => {
  database.close(); db = database.open(':memory:');
  const add = name => {
    const account = db.prepare('INSERT INTO accounts(username,password_hash,created_at) VALUES(?,?,0)').run(name, 'test');
    const id = players.createPlayer(Number(account.lastInsertRowid), name, 1, require('../config.json').starter);
    db.prepare('UPDATE players SET uridium=1000000 WHERE id=?').run(id); return players.loadPlayer(id);
  };
  p = add('reward-one'); other = add('reward-two'); systems.gateInfo(p, db);
});
afterEach(() => database.close());
function count(loot, playerId = p.userId) {
  return loot === 'resource_ore_xenomit' ? db.prepare('SELECT coalesce(sum(amount),0) n FROM player_resources WHERE player_id=? AND ore_type=3').get(playerId).n
    : db.prepare('SELECT coalesce(sum(amount),0) n FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').get(playerId, loot).n;
}
function roundTrip(command) { const result = codec.decode(codec.encode(command)); assert.equal(result.rest, 0); assert.deepEqual(result.obj, command); }
const categoryRoll = { ammo: 0.5, ore: 0.2, voucher: 0.26, logfile: 0.285 };
const forceTier = tier => Object.fromEntries(['normal', 'rare', 'veryRare'].map(name => [name, name === tier ? 1 : 0]));
function spin(tier, category, index, amount = 1, useMultiplier = false) {
  const values = [categoryRoll[category], (index + 0.5) / rewards.packages[tier][category].length]; let i = 0;
  return systems.spin(p, { gateId: 1, spinAmount: amount, useMultiplier }, db, () => values[i++ % 2], forceTier(tier));
}

test('all 27 supported packages grant exact owned ledger entries and matching codec outputs', () => {
  let visited = 0;
  for (const [tier, categories] of Object.entries(rewards.packages)) for (const [category, list] of Object.entries(categories)) {
    for (let index = 0; index < list.length; index++) {
      const expected = list[index].rewards, before = new Map(expected.map(item => [item.lootId, count(item.lootId)]));
      const result = spin(tier, category, index); assert.equal(result.errorCode, 0); roundTrip(result);
      assert.equal(result.items.length, expected.length);
      for (const item of expected) {
        assert.equal(count(item.lootId) - before.get(item.lootId), item.amount, `${tier}/${list[index].id}/${item.lootId}`);
        assert.equal(count(item.lootId, other.userId), 0);
        const output = result.items.find(output => output.type === item.type && output.item_id === item.itemId);
        assert.equal(output?.amount, item.amount); assert.equal(output.multiplier_used, 0);
      }
      visited++;
    }
  }
  assert.equal(visited, 27);
});

test('source decoder supports every advertised ammo icon and names, with no fake arbitrary loot IDs', () => {
  const base = path.join(__dirname, '../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/galaxygatebuilder');
  const model = fs.readFileSync(path.join(base, 'model/GalaxyGateBuilderModel.as'), 'utf8');
  const ammo = fs.readFileSync(path.join(base, 'model/vo/AmmoOutputVO.as'), 'utf8');
  const generic = fs.readFileSync(path.join(base, 'model/vo/OutputVO.as'), 'utf8');
  const expected = { mcb25: [2, 'TYPE_MCB_25', 'MCB-25'], mcb50: [3, 'TYPE_MCB_50', 'MCB-50'],
    ucb100: [4, 'TYPE_UCB_100', 'UCB-100'], sab50: [5, 'TYPE_ABS', 'SAB'], plt2021: [3, 'TYPE_ROCKET_PLT_2121', 'PLT-2021'], acm01: [11, 'TYPE_MINE_ACM_1', 'log_entry_mine_'] };
  for (const [key, [id, symbol, label]] of Object.entries(expected)) {
    assert.equal(rewards.LOOT[key][2], id);
    assert.match(model, new RegExp(`case ${id}:[\\s\\S]{0,100}AmmoOutputVO\\.${symbol}`));
    assert.ok(ammo.includes(`"${label}"`));
  }
  assert.ok(generic.includes('"Xenomit"')); assert.ok(generic.includes('"log_entry_repair_voucher_s"')); assert.ok(generic.includes('"log_entry_logfiles_s"'));
});

test('rarity boundaries and configured weights select normal, rare and very rare honestly', () => {
  assert.equal(rewards.choose('ammo', 0).tier, 'normal');
  assert.equal(rewards.choose('ammo', 0.849999).tier, 'normal');
  assert.equal(rewards.choose('ammo', 0.85).tier, 'rare');
  assert.equal(rewards.choose('ammo', 0.979999).tier, 'rare');
  assert.equal(rewards.choose('ammo', 0.98).tier, 'veryRare');
  assert.equal(rewards.choose('ammo', 0.999999).tier, 'veryRare');
  assert.equal(rewards.choose('ammo', 0.999, forceTier('normal')).tier, 'normal');
  for (const invalid of [{ normal: 0, rare: 0, veryRare: 0 }, { normal: -1 }, { rare: 1.5 }, { unknown: 1 }, { normal: 1000001 }]) assert.throws(() => rewards.weights(invalid));
});

test('one selected energy multiplies every package component once then consumes bank', () => {
  db.prepare('UPDATE galaxy_gate_progress SET multiplier=5 WHERE player_id=? AND gate_id=1').run(p.userId);
  const chosen = rewards.packages.veryRare.ammo[0], before = new Map(chosen.rewards.map(item => [item.lootId, count(item.lootId)]));
  const result = spin('veryRare', 'ammo', 0, 5, true); roundTrip(result);
  assert.equal(result.multiplier, 0); assert.equal(result.items.length, 6);
  for (const item of chosen.rewards) {
    assert.equal(count(item.lootId) - before.get(item.lootId), item.amount * 10);
    const used = result.items.find(output => output.type === item.type && output.item_id === item.itemId && output.multiplier_used === 6);
    const plain = result.items.find(output => output.type === item.type && output.item_id === item.itemId && output.multiplier_used === 0);
    assert.equal(used.amount, item.amount * 6); assert.equal(used.multiplier_amount, item.amount * 5); assert.equal(used.spins, 1);
    assert.equal(plain.amount, item.amount * 4); assert.equal(plain.spins, 4);
  }
});

test('100 three-item packages aggregate safely without losing paid output or overflowing vector', () => {
  const result = spin('veryRare', 'ammo', 4, 100); roundTrip(result);
  assert.equal(result.items.length, 3);
  for (const entry of rewards.packages.veryRare.ammo[4].rewards) {
    const output = result.items.find(item => item.type === entry.type && item.item_id === entry.itemId);
    assert.equal(output.amount, entry.amount * 100); assert.equal(output.spins, 100);
  }
});

test('failure in second bundle component rolls back all earlier items, cost, energy and bank', () => {
  db.prepare('UPDATE galaxy_gate_accounts SET energy=1 WHERE player_id=?').run(p.userId);
  db.prepare('UPDATE galaxy_gate_progress SET multiplier=3 WHERE player_id=? AND gate_id=1').run(p.userId);
  const before = p.uridium, laserBefore = count('ammunition_laser_mcb-25');
  db.exec("CREATE TRIGGER bundle_failure BEFORE INSERT ON items WHEN NEW.loot_id='ammunition_laser_mcb-50' BEGIN SELECT RAISE(ABORT,'bundle second item failure'); END");
  assert.throws(() => spin('rare', 'ammo', 0, 1, true), /bundle second item failure/);
  assert.equal(count('ammunition_laser_mcb-25'), laserBefore); assert.equal(p.uridium, before);
  assert.equal(systems.gateInfo(p, db).samples, 1); assert.equal(systems.gateInfo(p, db).gates[0].multiplier, 3);
});

test('invalid rarity config or random bounds leave a paid spin completely unchanged', () => {
  db.prepare('UPDATE galaxy_gate_progress SET multiplier=4 WHERE player_id=? AND gate_id=1').run(p.userId);
  const before = p.uridium;
  for (const invalid of [NaN, -0.1, 1, Infinity]) {
    assert.throws(() => systems.spin(p, { gateId: 1, spinAmount: 1, useMultiplier: true }, db, () => invalid), /random value/);
  }
  assert.throws(() => systems.spin(p, { gateId: 1, spinAmount: 1, useMultiplier: true }, db, () => 0.5, forceTier('missing')), /Empty gate reward/);
  assert.equal(p.uridium, before); assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(p.userId).uridium, before);
  assert.equal(systems.gateInfo(p, db).gates[0].multiplier, 4);
});
