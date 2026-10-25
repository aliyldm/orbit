'use strict';
const crypto = require('crypto');
const evidence = require('./skylab-evidence.json');
const ORES = ['prometium', 'endurium', 'terbium', 'xenomit', 'prometid', 'duranium', 'promerium', 'seprom'];
const MODULES = {
  baseModule: { level: 1, label: 'Temel modül' }, solarModule: { level: 1, label: 'Solar modülü' },
  storageModule: { level: 1, label: 'Depo modülü' }, transportModule: { level: 1, max: 1, label: 'Transport modülü' },
  xenoModule: { level: 0, label: 'Xeno modülü', ore: 3, rate: 11 },
  prometiumCollector: { level: 1, label: 'Prometium toplayıcısı', ore: 0, rate: 2200 },
  enduriumCollector: { level: 1, label: 'Endurium toplayıcısı', ore: 1, rate: 2200 },
  terbiumCollector: { level: 1, label: 'Terbium toplayıcısı', ore: 2, rate: 2200 },
  prometidRefinery: { level: 0, label: 'Prometid rafinerisi', ore: 4, rate: 73, recipe: evidence.recipes[4] },
  duraniumRefinery: { level: 0, label: 'Duranium rafinerisi', ore: 5, rate: 73, recipe: evidence.recipes[5] },
  promeriumRefinery: { level: 0, label: 'Promerium rafinerisi', ore: 6, rate: 7, recipe: evidence.recipes[6] },
  sepromRefinery: { level: 0, label: 'Seprom rafinerisi', ore: 7, rate: 1, recipe: { 6: 10 } }
};
const dbFor = options => options?.db || require('./db').open();
function nowFor(options) { return typeof options?.now === 'function' ? options.now() : options?.now ?? Date.now(); }
function tx(db, fn) {
  db.exec('SAVEPOINT skylab_operation');
  try { const result = fn(); db.exec('RELEASE skylab_operation'); return result; }
  catch (error) { db.exec('ROLLBACK TO skylab_operation; RELEASE skylab_operation'); throw error; }
}
function ensure(db, id, now) {
  if (!db.prepare('SELECT 1 FROM players WHERE id=?').get(id)) throw new Error('Oyuncu bulunamadı');
  db.prepare('INSERT OR IGNORE INTO skylab_accounts VALUES(?,?,?)').run(id, now, crypto.randomBytes(24).toString('hex'));
  for (const [name, module] of Object.entries(MODULES))
    db.prepare('INSERT OR IGNORE INTO skylab_modules(player_id,name,level) VALUES(?,?,?)').run(id, name, module.level);
  for (let type = 0; type < ORES.length; type++) db.prepare('INSERT OR IGNORE INTO skylab_resources(player_id,ore_type) VALUES(?,?)').run(id, type);
}
function moduleRows(db, id) { return Object.fromEntries(db.prepare('SELECT * FROM skylab_modules WHERE player_id=?').all(id).map(module => [module.name, module])); }
function resources(db, id) { return Object.fromEntries(db.prepare('SELECT ore_type,amount FROM skylab_resources WHERE player_id=?').all(id).map(row => [row.ore_type, row.amount])); }
function capacities(modules) {
  const factor = Math.max(1, modules.storageModule.level) ** 2;
  return Object.fromEntries([105600, 105600, 105600, 528, 5280, 5280, 528, 48].map((value, type) => [type, value * factor]));
}
function power(modules) {
  const available = 170 * modules.solarModule.level;
  const used = Object.entries(modules).reduce((sum, [name, module]) => sum + (name !== 'solarModule' && module.active ? module.level * 16 : 0), 0);
  return { available, used, efficiency: used ? Math.min(1, available / used) : 1 };
}
function produce(db, id, modules, dt) {
  if (dt <= 0) return;
  const stock = resources(db, id), cap = capacities(modules), energy = power(modules);
  const producers = Object.entries(MODULES).filter(([name, definition]) => definition.rate && modules[name].active && modules[name].level && !modules[name].upgrade_until)
    .map(([name, definition]) => ({ ...definition, perMs: definition.rate * modules[name].level ** 2 / 3600000 * energy.efficiency }));
  // Minute slices preserve input/output flow during long absences. Once the
  // storage reaches a steady state, the rest of the elapsed interval is free.
  while (dt > 0) {
    const step = Math.min(dt, 60000), before = Object.values(stock);
    for (const definition of producers) {
      let amount = Math.min(cap[definition.ore] - stock[definition.ore], definition.perMs * step);
      if (definition.recipe) for (const [type, cost] of Object.entries(definition.recipe)) amount = Math.min(amount, stock[type] / cost);
      amount = Math.max(0, amount);
      if (definition.recipe) for (const [type, cost] of Object.entries(definition.recipe)) stock[type] = Math.max(0, stock[type] - amount * cost);
      stock[definition.ore] += amount;
    }
    dt -= step;
    if (before.every((amount, index) => Math.abs(amount - stock[index]) < 1e-9)) break;
  }
  for (const [type, amount] of Object.entries(stock)) db.prepare('UPDATE skylab_resources SET amount=? WHERE player_id=? AND ore_type=?').run(Math.round(amount * 1e6) / 1e6, id, Number(type));
}
function cargoCapacity(db, id) {
  const p = db.prepare('SELECT active_ship_id FROM players WHERE id=?').get(id);
  if (!p?.active_ship_id) return 0;
  const ship = db.prepare('SELECT * FROM ships WHERE id=?').get(p.active_ship_id);
  const type = db.prepare('SELECT * FROM ship_types WHERE loot_id=?').get(ship.loot_id);
  return require('./stats').computeStats(type, []).cargoMax;
}
function cargoUsed(db, id) { return db.prepare('SELECT coalesce(sum(amount),0) AS n FROM player_resources WHERE player_id=? AND ore_type<>3').get(id).n; }
function deliver(db, id, now) {
  const transport = db.prepare("SELECT * FROM skylab_transports WHERE player_id=? AND state='pending' AND arrive_at<=?").get(id, now);
  if (!transport) return false;
  const payload = JSON.parse(transport.payload_json), total = Object.values(payload).reduce((a, b) => a + b, 0);
  if (total > Math.max(0, cargoCapacity(db, id) - cargoUsed(db, id))) return false;
  for (const [type, amount] of Object.entries(payload)) db.prepare('INSERT INTO player_resources(player_id,ore_type,amount) VALUES(?,?,?) ON CONFLICT(player_id,ore_type) DO UPDATE SET amount=amount+excluded.amount').run(id, Number(type), amount);
  db.prepare("UPDATE skylab_transports SET state='delivered',delivered_at=? WHERE id=? AND state='pending'").run(now, transport.id);
  return true;
}
function sync(db, id, now) {
  ensure(db, id, now);
  const account = db.prepare('SELECT * FROM skylab_accounts WHERE player_id=?').get(id);
  let cursor = account.last_update;
  if (!Number.isSafeInteger(now) || now < cursor) now = cursor;
  const modules = moduleRows(db, id);
  const boundaries = [...new Set(Object.values(modules).filter(module => module.upgrade_until && module.upgrade_until <= now).map(module => Math.max(cursor, module.upgrade_until)))].sort((a, b) => a - b);
  boundaries.push(now);
  for (const end of boundaries) {
    produce(db, id, modules, end - cursor); cursor = end;
    for (const module of Object.values(modules)) if (module.upgrade_until && module.upgrade_until <= end) {
      module.level = module.target_level; module.upgrade_until = module.target_level = null;
      db.prepare('UPDATE skylab_modules SET level=?,upgrade_until=NULL,target_level=NULL WHERE player_id=? AND name=?').run(module.level, id, module.name);
    }
  }
  const delivered = deliver(db, id, now);
  db.prepare('UPDATE skylab_accounts SET last_update=? WHERE player_id=?').run(now, id);
  return delivered;
}
function consume(db, playerId, oreType, amount) {
  if (!Number.isSafeInteger(amount) || amount <= 0 || !Number.isInteger(oreType) || oreType < 0 || oreType > 7) throw new Error('Geçersiz kaynak miktarı');
  const result = db.prepare('UPDATE skylab_resources SET amount=amount-? WHERE player_id=? AND ore_type=? AND amount>=?').run(amount, playerId, oreType, amount);
  if (!result.changes) throw new Error(`Yetersiz Skylab ${ORES[oreType]}`);
  return true;
}
function cost(name, level) {
  const definition = MODULES[name], recorded = evidence.upgrades[name];
  if (!definition || !recorded?.Credits || level >= (definition.max || 20)) return null;
  const scale = 1.6 ** (level - definition.level);
  const number = value => Number(value.replace(/,/g, ''));
  const parts = recorded.Zaman.normal.split(':').map(Number);
  return { credits: Math.ceil(number(recorded.Credits.normal) * scale), uridium: Math.ceil(number(recorded.Uridium.instant) * scale),
    ores: [0, 1, 2].map((type, index) => [type, Math.ceil(number(recorded[['Prometium', 'Endurium', 'Terbium'][index]].normal) * scale)]),
    duration: Math.ceil((parts[0] * 60 + parts[1]) * 60000 * scale) };
}
function snapshot(db, id, now) {
  const modules = moduleRows(db, id), stock = resources(db, id), cap = capacities(modules);
  const player = db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(id);
  return { playerId: id, now, token: db.prepare('SELECT reload_token FROM skylab_accounts WHERE player_id=?').get(id).reload_token,
    modules: Object.fromEntries(Object.entries(modules).map(([name, module]) => [name, { ...module, nextCost: cost(name, module.level) }])),
    resources: stock, capacities: cap, power: power(modules), credits: player.credits, uridium: player.uridium,
    cargoCapacity: cargoCapacity(db, id), cargoUsed: cargoUsed(db, id),
    transport: db.prepare("SELECT * FROM skylab_transports WHERE player_id=? AND state='pending'").get(id) || null };
}
function state(playerId, options = {}) {
  const db = dbFor(options), now = nowFor(options);
  const value = tx(db, () => { sync(db, playerId, now); return snapshot(db, playerId, Math.max(now, db.prepare('SELECT last_update FROM skylab_accounts WHERE player_id=?').get(playerId).last_update)); });
  if (options.notify !== false) notify(playerId);
  return value;
}
function operate(playerId, params, options = {}) {
  const db = dbFor(options), now = nowFor(options);
  const result = tx(db, () => {
    sync(db, playerId, now);
    const account = db.prepare('SELECT * FROM skylab_accounts WHERE player_id=?').get(playerId);
    if (params.get('reloadToken') !== account.reload_token) throw new Error('Geçersiz Skylab işlem anahtarı');
    const action = params.get('subaction'), name = params.get('construction');
    const modules = moduleRows(db, playerId), module = modules[name];
    if (action === 'upgrade' || action === 'instantUpgrade') {
      if (!module || module.upgrade_until) throw new Error('Modül bulunamadı veya zaten geliştiriliyor');
      const offer = cost(name, module.level);
      if (!offer) throw new Error('Azami modül seviyesine ulaşıldı');
      if (name !== 'baseModule' && module.level >= modules.baseModule.level) throw new Error('Önce temel modülü geliştirin');
      const instant = action === 'instantUpgrade', price = instant ? offer.uridium : 0;
      const paid = db.prepare('UPDATE players SET credits=credits-?,uridium=uridium-? WHERE id=? AND credits>=? AND uridium>=?')
        .run(offer.credits, price, playerId, offer.credits, price);
      if (!paid.changes) throw new Error('Yetersiz kredi veya uridium');
      for (const [type, amount] of offer.ores) consume(db, playerId, type, amount);
      if (instant) db.prepare('UPDATE skylab_modules SET level=level+1 WHERE player_id=? AND name=?').run(playerId, name);
      else db.prepare('UPDATE skylab_modules SET target_level=level+1,upgrade_until=? WHERE player_id=? AND name=?').run(now + offer.duration, playerId, name);
    } else if (action === 'setActive' || action === 'setInactive') {
      if (!module || !module.level || ['baseModule', 'solarModule', 'storageModule'].includes(name)) throw new Error('Bu modülün enerji durumu değiştirilemez');
      db.prepare('UPDATE skylab_modules SET active=? WHERE player_id=? AND name=?').run(action === 'setActive' ? 1 : 0, playerId, name);
    } else if (action === 'startTransport') {
      if (name !== 'TRANSPORT_MODULE' || !modules.transportModule.active) throw new Error('Transport modülü etkin değil');
      if (db.prepare("SELECT 1 FROM skylab_transports WHERE player_id=? AND state='pending'").get(playerId)) throw new Error('Bir transport zaten yolda');
      const mode = params.get('mode');
      if (!['normal', 'fast'].includes(mode)) throw new Error('Geçersiz transport türü');
      const payload = {};
      for (let type = 0; type < ORES.length; type++) {
        const raw = params.get('count_' + ORES[type]) ?? '0';
        if (!/^\d+$/.test(raw) || !Number.isSafeInteger(Number(raw)) || Number(raw) > 100000000) throw new Error('Geçersiz transport miktarı');
        if (Number(raw)) payload[type] = Number(raw);
      }
      const total = Object.values(payload).reduce((a, b) => a + b, 0);
      if (!total || total > cargoCapacity(db, playerId) - cargoUsed(db, playerId)) throw new Error('Geminin kargo kapasitesi yetersiz');
      for (const [type, amount] of Object.entries(payload)) consume(db, playerId, Number(type), amount);
      if (mode === 'fast' && !db.prepare('UPDATE players SET uridium=uridium-1250 WHERE id=? AND uridium>=1250').run(playerId).changes) throw new Error('Yetersiz uridium');
      db.prepare("INSERT INTO skylab_transports(player_id,payload_json,created_at,arrive_at,state) VALUES(?,?,?,?,'pending')")
        .run(playerId, JSON.stringify(payload), now, mode === 'fast' ? now : now + total * 3600);
      if (mode === 'fast') deliver(db, playerId, now);
    } else throw new Error('Bilinmeyen Skylab işlemi');
    return snapshot(db, playerId, now);
  });
  notify(playerId);
  return result;
}
function notify(id, world = require('./world').current()) {
  const player = world?.livePlayer?.(id);
  if (!player) return;
  const row = require('./db').open().prepare('SELECT credits,uridium FROM players WHERE id=?').get(id);
  Object.assign(player, row);
  const commands = require('./collectables').resourceCommands(player);
  world.broadcast(session => {
    const send = world.combat?.send || require('./net').sendCmd;
    for (const command of commands) send(session, command);
    send(session, { _: 'LegacyModule', message: `0|LM|ST|CRE|0|${player.credits}` });
    send(session, { _: 'LegacyModule', message: `0|LM|ST|URI|0|${player.uridium}` });
  });
  const level = require('./db').open().prepare("SELECT level FROM skylab_modules WHERE player_id=? AND name='prometiumCollector'").get(id)?.level || 0;
  if (level) for (const session of world.sessions) if (session.player === player)
    require('./handlers/systems').recordEvent(session, { type: 'skylabUpgrade', match: 'PROMETIUM_COLLECTOR', amount: level });
}
function tick(world) {
  const p = world.player;
  if (!p) return false;
  const db = require('./db').open();
  if (!db.prepare("SELECT 1 FROM skylab_transports WHERE player_id=? AND state='pending' AND arrive_at<=?").get(p.userId, Date.now())) return false;
  const delivered = tx(db, () => { ensure(db, p.userId, Date.now()); return deliver(db, p.userId, Date.now()); });
  if (delivered) notify(p.userId, world);
  return delivered;
}
module.exports = { MODULES, ORES, state, operate, consume, cost, capacities, power, tick, notify, tx };
