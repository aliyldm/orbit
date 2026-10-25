'use strict';
const evidence = require('../skylab-evidence.json');
const RECIPES = evidence.recipes;
const DAMAGE = { 4: 1.15, 6: 1.30, 7: 1.60, 28: 1.50 };
const PERFORMANCE = { 5: 1.10, 6: 1.20, 7: 1.40, 28: 1.50 };
const dbFor = options => options?.db || require('../db').open();
const timeFor = options => typeof options?.now === 'function' ? options.now() : options?.now ?? Date.now();
function valid(item, ore) {
  return Number.isInteger(item) && item >= 0 && item <= 3 &&
    (item <= 1 ? Object.hasOwn(DAMAGE, ore) : Object.hasOwn(PERFORMANCE, ore) && (item !== 2 || ![7, 28].includes(ore)));
}
function buffRows(id, options = {}) { return dbFor(options).prepare('SELECT * FROM player_ore_buffs WHERE player_id=?').all(id); }
function buildInit(player, options = {}) {
  const now = timeFor(options), rows = new Map(buffRows(player.userId, options).map(row => [row.item_type, row]));
  if (player.oreBuffSignature === undefined) player.oreBuffSignature = JSON.stringify([...rows.values()]
    .filter(row => row.item_type >= 2 && row.expires_at > now).map(row => [row.item_type, row.ore_type, row.expires_at]));
  return [{ _: 'LabUpdateItemCommand', itemsUpdatedInfo: Array.from({ length: 4 }, (_, item) => {
    const row = rows.get(item), count = !row ? 0 : item < 2 ? row.remaining : Math.max(0, Math.ceil((row.expires_at - now) / 60000));
    return { _: 'UpdateItemModule', itemToUpdate: { _: 'LabItemModule', itemValue: item },
      oreCountToUpdateWith: { _: 'OreCountModule', oreType: { _: 'OreTypeModule', typeValue: row?.ore_type || 0 }, count } };
  }) }];
}
function refine(player, request, options = {}) {
  const type = request.toProduce?.oreType?.typeValue, amount = request.toProduce?.count, recipe = RECIPES[type];
  if (!recipe || !Number.isSafeInteger(amount) || amount <= 0 || amount > 1000000) throw new Error('Geçersiz rafineri isteği');
  const db = dbFor(options);
  require('../skylab').tx(db, () => {
    for (const [ore, perUnit] of Object.entries(recipe)) {
      const total = perUnit * amount;
      if (!db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=? AND amount>=?').run(total, player.userId, Number(ore), total).changes)
        throw new Error('Rafineri için yeterli cevher yok');
    }
    db.prepare('INSERT INTO player_resources(player_id,ore_type,amount) VALUES(?,?,?) ON CONFLICT(player_id,ore_type) DO UPDATE SET amount=amount+excluded.amount').run(player.userId, type, amount);
  });
  return true;
}
function update(player, request, options = {}) {
  const item = request.itemToUpdate?.itemValue, ore = request.updateWith?.oreType?.typeValue, amount = request.updateWith?.count;
  if (!valid(item, ore) || !Number.isSafeInteger(amount) || amount <= 0 || amount > 100000) throw new Error('Geçersiz cevher geliştirmesi');
  const db = dbFor(options), now = timeFor(options);
  require('../skylab').tx(db, () => {
    const old = db.prepare('SELECT * FROM player_ore_buffs WHERE player_id=? AND item_type=?').get(player.userId, item);
    const same = old?.ore_type === ore;
    const before = same ? item < 2 ? old.remaining : Math.max(0, Math.ceil((old.expires_at - now) / 60000)) : 0;
    const remaining = before + amount * 10;
    if (remaining > 1000000) throw new Error('Cevher geliştirmesi üst sınırı aşıldı');
    if (!db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=? AND amount>=?').run(amount, player.userId, ore, amount).changes)
      throw new Error('Yeterli geliştirme cevheri yok');
    const expires = item < 2 ? null : (same ? Math.max(now, old.expires_at) : now) + amount * 600000;
    db.prepare('INSERT INTO player_ore_buffs(player_id,item_type,ore_type,remaining,expires_at) VALUES(?,?,?,?,?) ON CONFLICT(player_id,item_type) DO UPDATE SET ore_type=excluded.ore_type,remaining=excluded.remaining,expires_at=excluded.expires_at')
      .run(player.userId, item, ore, item < 2 ? remaining : 0, expires);
  });
  return true;
}
function consumeShot(player, itemType, options = {}) {
  if (![0, 1].includes(itemType)) return 1;
  const db = dbFor(options);
  return require('../skylab').tx(db, () => {
    const row = db.prepare('SELECT * FROM player_ore_buffs WHERE player_id=? AND item_type=? AND remaining>0').get(player.userId, itemType);
    if (!row) return 1;
    db.prepare('UPDATE player_ore_buffs SET remaining=remaining-1 WHERE player_id=? AND item_type=?').run(player.userId, itemType);
    return DAMAGE[row.ore_type] || 1;
  });
}
function applyStats(playerId, stats, options = {}) {
  const now = timeFor(options), rows = buffRows(playerId, options);
  let speed = 1, shield = 1;
  for (const row of rows) if (row.expires_at > now) {
    if (row.item_type === 2) speed = PERFORMANCE[row.ore_type] || 1;
    if (row.item_type === 3) shield = PERFORMANCE[row.ore_type] || 1;
  }
  // Ore improves engine generators, not the naked hull's flight speed. The
  // generator contribution follows formation speed composition in drones.js.
  return { ...stats, speed: Math.round(stats.speed + (stats.speedGeneratorBonus||0)*(speed-1)), shieldMax: Math.round(stats.shieldMax * shield) };
}
function refresh(world) {
  const player = world.player;
  if (!player) return;
  const now = Date.now(), rows = buffRows(player.userId);
  const signature = JSON.stringify(rows.filter(row => row.item_type >= 2 && row.expires_at > now).map(row => [row.item_type, row.ore_type, row.expires_at]));
  if (signature === player.oreBuffSignature) return;
  player.oreBuffSignature = signature;
  world.refreshStats?.();
}
function register(onCmd, services = {}) {
  const send = services.sendCmd || require('../net').sendCmd;
  function current(session) { return session.player && session.world?.player === session.player; }
  function commands(session) {
    for (const command of require('../collectables').resourceCommands(session.player)) send(session, command);
    for (const command of buildInit(session.player, services)) send(session, command);
  }
  onCmd('LabUpdateRequest', session => { if (current(session)) commands(session); });
  onCmd('LabRefinementRequest', (session, request) => {
    if (!current(session) || session.player.dead) return;
    try { refine(session.player, request, services); commands(session); }
    catch (error) { send(session, { _: 'LegacyModule', message: `0|A|STD|${error.message}` }); }
  });
  onCmd('LabUpdateItemRequest', (session, request) => {
    if (!current(session) || session.player.dead) return;
    try { update(session.player, request, services); refresh(session.world); commands(session); }
    catch (error) { send(session, { _: 'LegacyModule', message: `0|A|STD|${error.message}` }); }
  });
}
module.exports = { register, buildInit, refine, update, consumeShot, applyStats, refresh, RECIPES, DAMAGE, PERFORMANCE };
