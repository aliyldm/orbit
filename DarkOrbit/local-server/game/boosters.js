'use strict';
// Owner effects and hours are read from the shipped client item catalog.
// Shared/PvP/random-drop effects are deliberately not fabricated; see docs/boosters-local.md.
const META = require('../docs/client-map.items.json').items;
const SUPPORTED = new Set(['EXPERIENCE_POINTS', 'HONOUR_POINTS', 'DAMAGE', 'DAMAGE_NPC', 'HITPOINTS', 'SHIELD',
  'REPAIR', 'SHIELD_REGENERATION', 'COLLECT_RESOURCES', 'COLLECT_RESOURCES_NEWBIE',
  'LASER_HIT_CHANCE', 'ROCKET_HIT_CHANCE', 'ABILITY_COOLDOWN_TIME', 'PET_EXP_BOOSTER']);
const definitions = Object.fromEntries(Object.entries(META).filter(([, item]) => item.kind === 'Booster'));
const dbFor = options => options?.db || require('./db').open();
const nowFor = options => typeof options?.now === 'function' ? options.now() : options?.now ?? Date.now();
const MAX_SECONDS = 0x7fffffff;
function unsupportedReason(lootId) {
  const definition = definitions[lootId];
  if (!definition) return 'Booster katalogda bulunamadı.';
  if (!Number.isFinite(definition.hours) || definition.hours <= 0) return 'Booster süresi istemciden doğrulanamadı.';
  if (!definition.boostList?.length || definition.salvageEffects?.length) return 'Bu etkinlik/ödül boosterının etkisi henüz yerel sunucuda desteklenmiyor.';
  if (definition.boostList.some(boost => !SUPPORTED.has(boost.type) || !Number.isFinite(boost.factor) || boost.factor < 0))
    return 'Bu boosterın PvP, isabet veya özel yetenek etkisi henüz desteklenmiyor.';
  return null;
}
function isSupported(lootId) { return unsupportedReason(lootId) === null; }
function addOwned(db, playerId, lootId, amount = 1, options = {}) {
  const reason = unsupportedReason(lootId);
  if (reason) throw new Error(reason);
  if (!Number.isSafeInteger(amount) || amount <= 0 || amount > 1000000) throw new Error('Geçersiz booster miktarı.');
  const now = nowFor(options);
  if (!Number.isSafeInteger(now) || now < 0) throw new Error('Geçersiz booster zamanı.');
  const row = db.prepare('SELECT expires_at FROM player_boosters WHERE player_id=? AND loot_id=?').get(playerId, lootId);
  const hours = options.hours ?? definitions[lootId].hours;
  if (!Number.isFinite(hours) || hours <= 0 || hours > MAX_SECONDS / 3600) throw new Error('Geçersiz booster süresi.');
  const duration = hours * 3600000 * amount;
  const expiresAt = Math.max(now, row?.expires_at || 0) + duration;
  if (!Number.isSafeInteger(expiresAt) || expiresAt - now > MAX_SECONDS * 1000) throw new Error('Booster süresi üst sınırı aşıldı.');
  db.prepare('INSERT INTO player_boosters(player_id,loot_id,expires_at) VALUES(?,?,?) ON CONFLICT(player_id,loot_id) DO UPDATE SET expires_at=excluded.expires_at')
    .run(playerId, lootId, expiresAt);
  return expiresAt;
}
function active(playerId, options = {}) {
  return dbFor(options).prepare('SELECT loot_id,expires_at FROM player_boosters WHERE player_id=? AND expires_at>? ORDER BY loot_id')
    .all(playerId, nowFor(options)).filter(row => isSupported(row.loot_id));
}
function effects(playerId, options = {}) {
  const result = Object.fromEntries([...SUPPORTED].map(type => [type, 0]));
  for (const row of active(playerId, options)) for (const boost of definitions[row.loot_id].boostList) result[boost.type] += boost.factor;
  return result;
}
function multiplier(playerId, attribute, options = {}) { return 1 + (effects(playerId, options)[attribute] || 0) / 100; }
function applyStats(playerId, stats, options = {}) {
  const e = effects(playerId, options), factor = type => 1 + (e[type] || 0) / 100;
  return { ...stats,
    hitMax: Math.round(stats.hitMax * factor('HITPOINTS')),
    shieldMax: Math.round(stats.shieldMax * factor('SHIELD')),
    laserDamage: stats.laserDamage * factor('DAMAGE'),
    npcLaserMultiplier: (stats.npcLaserMultiplier || 1) * factor('DAMAGE_NPC'),
    // This local runtime currently attacks NPC targets only. PvP categories
    // are rejected above; NPC damage applies to both supported weapon types.
    rocketMultiplier: (stats.rocketMultiplier || 1) * factor('DAMAGE') * factor('DAMAGE_NPC'),
    repairMultiplier: (stats.repairMultiplier || 1) * factor('REPAIR'),
    shieldRegenMultiplier: (stats.shieldRegenMultiplier || 1) * factor('SHIELD_REGENERATION'),
    laserHitBonus: (stats.laserHitBonus || 0) + e.LASER_HIT_CHANCE / 100,
    rocketHitBonus: (stats.rocketHitBonus || 0) + e.ROCKET_HIT_CHANCE / 100
  };
}
function applyReward(playerId, reward, options = {}) {
  // All gameplay EP/honour grants (NPCs, quests and gate completion) pass
  // here. Resolve the active owned hull once; direct purchases stay fixed.
  reward = require('./ship-passives').applyReward(playerId, reward, { db: dbFor(options) });
  const e = effects(playerId, options), result = { ...reward };
  if (reward.ep) result.ep = Math.round(reward.ep * (1 + e.EXPERIENCE_POINTS / 100));
  if (reward.honour) result.honour = Math.round(reward.honour * (1 + e.HONOUR_POINTS / 100));
  return result;
}
function collectionMultiplier(playerId, kind = 'ore', options = {}) {
  const e = effects(playerId, options);
  return (1 + e.COLLECT_RESOURCES / 100) * (kind === 'bonusBox' ? 1 + e.COLLECT_RESOURCES_NEWBIE / 100 : 1);
}
function abilityCooldownMultiplier(playerId, options = {}) {
  return Math.max(0, 1 - effects(playerId, options).ABILITY_COOLDOWN_TIME / 100);
}
function petExperienceMultiplier(playerId, options = {}) {
  return 1 + effects(playerId, options).PET_EXP_BOOSTER / 100;
}
function buildInit(player, options = {}) {
  const rows = active(player.userId, options), e = effects(player.userId, options), now = nowFor(options);
  // A freshly loaded player's stats already include these effects. Recording
  // its initial signature avoids a redundant refresh that stops movement.
  if (player.boosterSignature === undefined) player.boosterSignature = JSON.stringify(rows);
  const owned = new Set(rows.map(row => row.loot_id));
  return [{ _: 'AttributeBoosterUpdateCommand',
    boostedAttributes: [...SUPPORTED].map(type => ({ _: 'BoosterUpdateModule', attributeType: type, value: e[type] })),
    boostedDetailsUpdate: rows.map(row => ({ _: 'BoosterPlayerDetailModule', lootId: row.loot_id, secondsLeft: Math.max(0, Math.ceil((row.expires_at - now) / 1000)) })),
    boostedDetailsRemove: Object.keys(definitions).filter(lootId => isSupported(lootId) && !owned.has(lootId))
      .map(lootId => ({ _: 'BoosterPlayerDetailModule', lootId, secondsLeft: 0 })) }];
}
function tick(world, options = {}) {
  const player = world?.player;
  if (!player) return false;
  const rows = active(player.userId, options), signature = JSON.stringify(rows);
  if (!options.force && player.boosterSignature === undefined && !rows.length) { player.boosterSignature = signature; return false; }
  if (!options.force && player.boosterSignature === signature) return false;
  player.boosterSignature = signature;
  world.refreshStats?.();
  const commands = buildInit(player, options), send = options.sendCmd || world.combat?.send || require('./net').sendCmd;
  world.broadcast(session => { for (const command of commands) send(session, command); });
  return true;
}
function purchased(world, options = {}) { return tick(world, { ...options, force: true }); }
// One-time adoption of paid, unused items from older local-server versions.
// Call within a transaction: duration starts when explicitly migrated because
// old item rows did not retain a purchase timestamp or active timer.
function adoptInventory(db, playerId, options = {}) {
  const rows = db.prepare("SELECT i.id,i.loot_id,i.amount FROM items i JOIN item_types t ON t.loot_id=i.loot_id WHERE i.player_id=? AND t.category='booster' AND i.ship_id IS NULL ORDER BY i.id").all(playerId);
  let amount = 0;
  for (const row of rows) if (isSupported(row.loot_id)) {
    addOwned(db, playerId, row.loot_id, row.amount, options);
    db.prepare('DELETE FROM items WHERE id=? AND player_id=?').run(row.id, playerId); amount += row.amount;
  }
  return amount;
}
module.exports = { definitions, SUPPORTED, unsupportedReason, isSupported, addOwned, active, effects, multiplier,
  applyStats, applyReward, collectionMultiplier, abilityCooldownMultiplier, petExperienceMultiplier, buildInit, tick, purchased, adoptInventory };
