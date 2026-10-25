'use strict';
const test = require('node:test'), assert = require('node:assert/strict');
const { open } = require('../game/db'), db = open(':memory:');
const players = require('../game/db/players'), config = require('../config.json');
const World = require('../game/world'), codec = require('../game/codec/codec');
const visuals = require('../game/laser-visuals'), { computeStats } = require('../game/stats');
let serial = 0;
function fixture(t, ship = 'ship_diminisher') {
  const account = players.createAccount(`laser-visual-${++serial}`, 'test-pass');
  const id = players.createPlayer(account, 'QA', 1, { ...config.starter, ship });
  const world = new World(config), commands = [];
  const session = { world, close() {}, send(frame) { const c = codec.decode(frame.subarray(3)); assert.equal(c.rest, 0); commands.push(c.obj); } };
  world.login(session, id);
  t.after(() => world.removeSession(session));
  return { id, world, session, commands, p: world.player };
}
function addLaser(f, index = 1) {
  return Number(db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index) VALUES(?,'equipment_weapon_laser_lf-1',1,?,'laser',?)").run(f.id, f.p.shipId, index).lastInsertRowid);
}

test('ship-specific paired stage uses actual native salvos and inherited cosmetic patterns', () => {
  assert.equal(visuals.stage('ship_liberator', 1), 1);
  assert.equal(visuals.stage('ship_liberator', 2), 2);
  // Diminisher stage2 alternates front/rear SINGLE shots, stage3 contains pairs.
  assert.equal(visuals.stage('ship_diminisher', 2), 3);
  assert.equal(visuals.stage('ship_spectrum', 2), 3);
  assert.equal(visuals.stage('ship_diminisher_design_diminisher-lava', 2), 3);
  assert.equal(visuals.stage('unknown_ship', 2), 1);
});

test('drone lasers contribute damage and ammo count without manufacturing extra ship-mounted lasers', () => {
  const stats = computeStats({ hitpoints: 1000, speed: 300, cargo: 500 }, [
    { category: 'laser', damage: 65, loot_id: 'equipment_weapon_laser_lf-1' },
    { category: 'laser', damage: 65, loot_id: 'equipment_weapon_laser_lf-1', drone_id: 42 }
  ]);
  assert.equal(stats.laserCount, 2); assert.equal(stats.shipLaserCount, 1);
  assert.equal(stats.laserDamage, 130);
});

test('hero initialization carries actual laser stage rather than the recorded one-laser state', t => {
  const f = fixture(t); addLaser(f);
  f.world.removeSession(f.session); f.world.login(f.session, f.id);
  const hero = require('../game/init').buildInit(f.world).find(c => c._ === 'ShipInitializationCommand');
  const decoded = codec.decode(codec.encode(hero)).obj;
  assert.equal(decoded.expansionStage, 3);
  assert.equal(decoded.typeId, 'ship_diminisher');
});

test('equipping and removing a second laser updates live emitters once without a map reload', t => {
  const f = fixture(t); assert.equal(f.p.expansionStage, 1);
  const second = addLaser(f); f.world.refreshStats();
  const changes = () => f.commands.filter(c => c._ === 'ShipExtensionsCommand');
  assert.deepEqual(changes(), [{ _: 'ShipExtensionsCommand', userId: f.id, extensionStage: 3 }]);
  f.world.refreshStats(); assert.equal(changes().length, 1);
  db.prepare('UPDATE items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE id=?').run(second);
  f.world.refreshStats(); assert.equal(f.p.expansionStage, 1);
  assert.equal(changes().at(-1).extensionStage, 1);
});

test('configuration two and reconnect preserve the matching laser stage', t => {
  const f = fixture(t, 'ship_liberator');
  const first = db.prepare("SELECT id FROM items WHERE player_id=? AND slot='laser'").get(f.id).id;
  const second = Number(db.prepare("INSERT INTO items(player_id,loot_id,amount) VALUES(?,'equipment_weapon_laser_lf-1',1)").run(f.id).lastInsertRowid);
  const assign = db.prepare("INSERT INTO equipment_config2(item_id,ship_id,slot,slot_index) VALUES(?,?,'laser',?)");
  assign.run(first, f.p.shipId, 0); assign.run(second, f.p.shipId, 1);
  assert.equal(f.p.stats.shipLaserCount, 1);
  db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(f.p.shipId);
  f.world.refreshStats(); assert.equal(f.p.stats.shipLaserCount, 2); assert.equal(f.p.expansionStage, 2);
  f.world.removeSession(f.session); f.world.login(f.session, f.id);
  assert.equal(f.world.player.expansionStage, 2);
  db.prepare('UPDATE ships SET active_config=1 WHERE id=?').run(f.p.shipId);
  f.world.refreshStats(); assert.equal(f.world.player.expansionStage, 1);
});

test('laser damage uses verified75-to100percent bounds separately from visual barrel patterns', t => {
  const f = fixture(t), Combat = require('../game/combat');
  const combat = new Combat(f.world, () => {});
  f.p.stats.laserDamage = 1000; f.p.stats.npcLaserMultiplier = 1; f.p.ammoMultiplier = 1;
  const random = t.mock.method(Math, 'random', () => 0);
  assert.equal(combat.playerDamage(f.p), 750);
  random.mock.mockImplementation(() => .5); assert.equal(combat.playerDamage(f.p), 875);
  random.mock.mockImplementation(() => 1 - Number.EPSILON); assert.equal(combat.playerDamage(f.p), 1000);
});
