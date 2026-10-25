'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict'), fs = require('fs'), path = require('path');
const database = require('../game/db'), players = require('../game/db/players');
const skylab = require('../game/skylab'), lab = require('../game/handlers/lab'), api = require('../web/skylab-api'), codec = require('../game/codec/codec');
let db, p, other, now;
beforeEach(() => {
  database.close(); db = database.open(':memory:'); now = 1000000;
  const add = name => {
    const a = db.prepare('INSERT INTO accounts(username,password_hash,created_at) VALUES(?,?,0)').run(name, 'test');
    const id = players.createPlayer(Number(a.lastInsertRowid), name, 1, require('../config.json').starter);
    db.prepare('UPDATE players SET credits=1000000,uridium=100000 WHERE id=?').run(id); return players.loadPlayer(id);
  };
  p = add('skylab-one'); other = add('skylab-two'); skylab.state(p.userId, opts());
});
afterEach(() => database.close());
const opts = () => ({ db, now, notify: false });
const state = (id = p.userId) => skylab.state(id, opts());
const command = (action, construction, fields = {}) => new URLSearchParams({ action: 'internalSkylab', subaction: action, construction,
  reloadToken: state().token, ...fields });
const operate = (action, name, fields) => skylab.operate(p.userId, command(action, name, fields), opts());
const stock = (type, amount, id = p.userId) => db.prepare('UPDATE skylab_resources SET amount=? WHERE player_id=? AND ore_type=?').run(amount, id, type);
const fund = () => { for (let type = 0; type < 3; type++) stock(type, 100000); };
const cargo = (type, amount, id = p.userId) => db.prepare('INSERT INTO player_resources(player_id,ore_type,amount) VALUES(?,?,?) ON CONFLICT(player_id,ore_type) DO UPDATE SET amount=excluded.amount').run(id, type, amount);
const cargoCount = (type, id = p.userId) => db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=?').get(id, type)?.amount || 0;
const ore = (type, count) => ({ _: 'OreCountModule', oreType: { _: 'OreTypeModule', typeValue: type }, count });

test('fresh Skylab uses captured initial module levels and capacities without copying recorded stock', () => {
  const s = state(); assert.equal(s.modules.baseModule.level, 1); assert.equal(s.modules.prometiumCollector.level, 1);
  assert.equal(s.modules.prometidRefinery.level, 0); assert.equal(s.resources[0], 0);
  assert.equal(s.capacities[0], 105600); assert.equal(s.capacities[7], 48);
  assert.deepEqual(s.power, { available: 170, used: 96, efficiency: 1 });
});
test('offline elapsed production persists, is idempotent and keeps account ownership', () => {
  skylab.state(other.userId, opts()); now += 3600000;
  assert.equal(state().resources[0], 2200); assert.equal(state().resources[1], 2200);
  assert.equal(state().resources[0], 2200);
  assert.equal(db.prepare('SELECT amount FROM skylab_resources WHERE player_id=? AND ore_type=0').get(other.userId).amount, 0);
  now -= 3600000; assert.equal(state().resources[0], 2200);
});
test('disabled modules stop producing, active modules continue, and storage never exceeds caps', () => {
  operate('setInactive', 'prometiumCollector'); now += 3600000;
  assert.equal(state().resources[0], 0); assert.equal(state().resources[1], 2200);
  operate('setActive', 'prometiumCollector'); now += 365 * 86400000;
  const s = state(); for (let type = 0; type < 3; type++) assert.equal(s.resources[type], s.capacities[type]);
});
test('instant upgrade pays captured costs and enforces base-module prerequisites', () => {
  fund(); const before = state();
  assert.throws(() => operate('upgrade', 'prometiumCollector'), /temel modülü/);
  const after = operate('instantUpgrade', 'baseModule');
  assert.equal(after.modules.baseModule.level, 2);
  assert.equal(after.credits, before.credits - 16352); assert.equal(after.uridium, before.uridium - 1487);
  assert.equal(after.resources[0], before.resources[0] - 707);
});
test('timed upgrades survive elapsed time, pause this module and finish only once', () => {
  fund(); operate('instantUpgrade', 'baseModule');
  const s = operate('upgrade', 'prometiumCollector'), until = s.modules.prometiumCollector.upgrade_until;
  const before = s.resources[0]; now = until - 1;
  assert.equal(state().modules.prometiumCollector.level, 1); assert.equal(state().resources[0], before);
  now = until + 3600000; const after = state();
  assert.equal(after.modules.prometiumCollector.level, 2); assert.equal(after.modules.prometiumCollector.upgrade_until, null);
  assert.equal(after.resources[0], Math.min(after.capacities[0], before + 8800));
  assert.equal(state().resources[0], after.resources[0]);
});
test('failed costs roll back money, resources and construction together', () => {
  stock(0, 1000); stock(1, 1000); stock(2, 0);
  const before = state(); assert.throws(() => operate('instantUpgrade', 'baseModule'), /Yetersiz Skylab/);
  const after = state(); assert.equal(after.credits, before.credits); assert.equal(after.uridium, before.uridium);
  assert.equal(after.resources[0], before.resources[0]); assert.equal(after.modules.baseModule.level, 1);
});
test('production refiners consume source recipe quantities and cannot mint input resources', () => {
  fund(); operate('instantUpgrade', 'prometidRefinery');
  const before = state(); now += 3600000; const after = state(), output = after.resources[4];
  assert.equal(output, 73);
  assert.equal(after.resources[0], before.resources[0] + 2200 - output * 20);
  assert.equal(after.resources[1], before.resources[1] + 2200 - output * 10);
});
test('transport debits owned stock now and delivers once after its persisted arrival time', () => {
  stock(0, 500); stock(1, 500);
  let s = operate('startTransport', 'TRANSPORT_MODULE', { mode: 'normal', count_prometium: '10', count_endurium: '20' });
  assert.equal(s.resources[0], 490); assert.equal(cargoCount(0), 0);
  assert.throws(() => operate('startTransport', 'TRANSPORT_MODULE', { mode: 'normal', count_prometium: '1' }), /zaten yolda/);
  now = s.transport.arrive_at - 1; assert.equal(state().transport.state, 'pending');
  now++; s = state(); assert.equal(s.transport, null); assert.equal(cargoCount(0), 10); assert.equal(cargoCount(1), 20);
  state(); assert.equal(cargoCount(0), 10); assert.equal(cargoCount(0, other.userId), 0);
});
test('cargo-full arrival waits without dropping transport contents and delivers after space frees', () => {
  stock(0, 100); const sent = operate('startTransport', 'TRANSPORT_MODULE', { mode: 'normal', count_prometium: '10' });
  cargo(1, sent.cargoCapacity); now = sent.transport.arrive_at + 1;
  assert.ok(state().transport); assert.equal(cargoCount(0), 0);
  cargo(1, sent.cargoCapacity - 10); assert.equal(state().transport, null); assert.equal(cargoCount(0), 10);
});
test('instant transport pays the captured 1250 uridium and enforces cargo limits and amounts', () => {
  stock(0, 100); const before = state();
  const sent = operate('startTransport', 'TRANSPORT_MODULE', { mode: 'fast', count_prometium: '10' });
  assert.equal(sent.uridium, before.uridium - 1250); assert.equal(cargoCount(0), 10); assert.equal(sent.transport, null);
  for (const bad of ['-1', '1.5', 'NaN', '100000000000000000']) assert.throws(() => operate('startTransport', 'TRANSPORT_MODULE', { mode: 'normal', count_prometium: bad }), /Geçersiz transport miktarı/);
  assert.throws(() => operate('startTransport', 'TRANSPORT_MODULE', { mode: 'normal', count_prometium: String(sent.cargoCapacity + 1) }), /kapasitesi/);
});
test('CSRF tokens and shared consume helper preserve owner and transaction boundaries', () => {
  fund(); const before = state();
  const bad = command('instantUpgrade', 'baseModule'); bad.set('reloadToken', 'invalid');
  assert.equal(api.handle(p.userId, bad, opts()).ok, false);
  stock(7, 20); assert.throws(() => skylab.tx(db, () => { skylab.consume(db, p.userId, 7, 5); throw new Error('rollback skill cost'); }), /rollback/);
  assert.equal(state().resources[7], 20);
  assert.equal(state().credits, before.credits);
});
test('existing Skylab page renders live counters, original action forms and self-contained controls', () => {
  const original = fs.readFileSync(path.join(__dirname, '../web/portal/pages/internalSkylab.html'), 'utf8');
  const s = state(), html = api.render(p, original, { ...opts(), state: s });
  assert.ok(html.includes('window.Skylab=')); assert.ok(!html.includes('src="/client/js/skylab.js'));
  assert.ok(html.includes('name="count_prometium"')); assert.ok(html.includes('name="construction" value="TRANSPORT_MODULE"'));
  assert.ok(html.includes('reloadToken=' + s.token)); assert.ok(!html.includes('reloadToken=REDACTED'));
  assert.ok(html.includes('Skylab → Gemi')); assert.ok(html.includes('0 / 105.600'));
  assert.equal(api.replaceInner('<div id="x"><div>A</div>B</div><div>C</div>', 'x', 'changed'), '<div id="x">changed</div><div>C</div>');
});
test('ship refinement implements exact client recipes and atomically rejects missing inputs', () => {
  cargo(0, 100); cargo(1, 100);
  lab.refine(p, { toProduce: ore(4, 2) }, opts()); assert.equal(cargoCount(0), 60); assert.equal(cargoCount(1), 80); assert.equal(cargoCount(4), 2);
  cargo(0, 100); cargo(1, 0); assert.throws(() => lab.refine(p, { toProduce: ore(4, 1) }, opts()), /yeterli cevher yok/);
  assert.equal(cargoCount(0), 100); assert.equal(cargoCount(4), 2);
  assert.throws(() => lab.refine(p, { toProduce: ore(7, 1) }, opts()), /Geçersiz/);
});
test('laser and rocket ore upgrades consume actual cargo and expire after ten shots per ore', () => {
  cargo(4, 5); lab.update(p, { itemToUpdate: { itemValue: 0 }, updateWith: ore(4, 1) }, opts());
  assert.equal(cargoCount(4), 4);
  for (let i = 0; i < 10; i++) assert.equal(lab.consumeShot(p, 0, opts()), 1.15);
  assert.equal(lab.consumeShot(p, 0, opts()), 1);
  cargo(7, 1); lab.update(p, { itemToUpdate: { itemValue: 1 }, updateWith: ore(7, 1) }, opts());
  assert.equal(lab.consumeShot(p, 1, opts()), 1.6); assert.equal(cargoCount(7), 0);
  assert.throws(() => lab.update(p, { itemToUpdate: { itemValue: 0 }, updateWith: ore(5, 1) }, opts()), /Geçersiz/);
});
test('drive and shield boosts use real resource compatibility, timers and packet shapes', () => {
  cargo(6, 4); lab.update(p, { itemToUpdate: { itemValue: 2 }, updateWith: ore(6, 1) }, opts());
  lab.update(p, { itemToUpdate: { itemValue: 3 }, updateWith: ore(6, 1) }, opts());
  const base = { speed: 400, speedGeneratorBonus:100, shieldMax: 1000 };
  assert.deepEqual(lab.applyStats(p.userId, base, opts()), { speed: 420, speedGeneratorBonus:100, shieldMax: 1200 });
  for (const command of lab.buildInit(p, opts())) {
    const decoded = codec.decode(codec.encode(command)); assert.equal(decoded.rest, 0); assert.deepEqual(decoded.obj, command);
    assert.equal(command.itemsUpdatedInfo[2].oreCountToUpdateWith.count, 10);
  }
  now += 600000; assert.deepEqual(lab.applyStats(p.userId, base, opts()), base);
  assert.throws(() => lab.update(p, { itemToUpdate: { itemValue: 2 }, updateWith: ore(7, 1) }, opts()), /Geçersiz/);
});
test('long absences refill inputs after refining storage fills, without exceeding any cap', () => {
  db.prepare("UPDATE skylab_modules SET level=1 WHERE player_id=? AND name NOT IN ('baseModule','solarModule')").run(p.userId);
  db.prepare("UPDATE skylab_modules SET level=2 WHERE player_id=? AND name IN ('baseModule','solarModule')").run(p.userId);
  now += 365 * 86400000; const s = state();
  for (let type = 0; type < 8; type++) assert.ok(Math.abs(s.resources[type] - s.capacities[type]) < 0.001, `${type}: ${s.resources[type]} vs ${s.capacities[type]}`);
});
test('transport storage failures roll back source stock and fees, then allow a clean retry', () => {
  stock(0, 100); const before = state();
  db.exec("CREATE TRIGGER fail_skylab_transport BEFORE INSERT ON skylab_transports BEGIN SELECT RAISE(ABORT,'transport persistence failure'); END");
  assert.throws(() => operate('startTransport', 'TRANSPORT_MODULE', { mode: 'fast', count_prometium: '10' }), /transport persistence failure/);
  const after = state(); assert.equal(after.resources[0], before.resources[0]); assert.equal(after.uridium, before.uridium); assert.equal(cargoCount(0), 0);
  db.exec('DROP TRIGGER fail_skylab_transport'); operate('startTransport', 'TRANSPORT_MODULE', { mode: 'fast', count_prometium: '10' }); assert.equal(cargoCount(0), 10);
});
test('arrival failure leaves the transport pending and never duplicates cargo on retry', () => {
  stock(0, 100); const s = operate('startTransport', 'TRANSPORT_MODULE', { mode: 'normal', count_prometium: '10' }); now = s.transport.arrive_at;
  db.exec("CREATE TRIGGER fail_skylab_arrival BEFORE INSERT ON player_resources BEGIN SELECT RAISE(ABORT,'arrival persistence failure'); END");
  assert.throws(state, /arrival persistence failure/); assert.equal(cargoCount(0), 0);
  assert.equal(db.prepare('SELECT state FROM skylab_transports WHERE id=?').get(s.transport.id).state, 'pending');
  db.exec('DROP TRIGGER fail_skylab_arrival'); state(); state(); assert.equal(cargoCount(0), 10);
});
test('captured Skylab quest validates actual module level and grants its real reward once', () => {
  const systems = require('../game/handlers/systems'), handlers = new Map(), commands = [];
  p.level = 6; db.prepare('UPDATE players SET level=6 WHERE id=?').run(p.userId);
  const session = { player: p, world: { player: p } };
  systems.register((name, fn) => handlers.set(name, fn), { db, sendCmd: (s, command) => commands.push(codec.decode(codec.encode(command)).obj) });
  handlers.get('QuestAcceptRequest')(session, { _: 'QuestAcceptRequest', questId: 2 });
  assert.equal(db.prepare('SELECT status FROM player_quests WHERE player_id=? AND quest_id=2').get(p.userId).status, 'completed');
  const count = () => db.prepare("SELECT count(*) AS n FROM items WHERE player_id=? AND loot_id='equipment_extra_hmd-07'").get(p.userId).n;
  assert.equal(count(), 1); assert.ok(commands.some(command => command._ === 'QuestCompletedCommand' && command.id === 2));
  handlers.get('QuestAcceptRequest')(session, { _: 'QuestAcceptRequest', questId: 2 }); assert.equal(count(), 1);
});
