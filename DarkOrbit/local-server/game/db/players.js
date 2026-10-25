'use strict';
// Hesap ve oyuncu erişimi. Oyuncu nesnesinin alan adları ShipInitializationCommand ile uyumludur
// (game/init.js bu nesneyi doğrudan komuta yazar).

const crypto = require('crypto');
const { open, tx } = require('./index');
const { computeStats } = require('../stats');

function hashPassword(password) {
  const salt = crypto.randomBytes(16).toString('hex');
  return `${salt}:${crypto.scryptSync(password, salt, 32).toString('hex')}`;
}

function checkPassword(password, stored) {
  const [salt, hash] = stored.split(':');
  if (!salt || !/^[a-f0-9]{64}$/i.test(hash || '')) return false;
  const got = crypto.scryptSync(password, salt, 32);
  return crypto.timingSafeEqual(got, Buffer.from(hash, 'hex'));
}

function findAccount(username) {
  return open().prepare('SELECT * FROM accounts WHERE username = ?').get(username) || null;
}

function createAccount(username, password) {
  const r = open().prepare('INSERT INTO accounts (username, password_hash, created_at) VALUES (?, ?, ?)')
    .run(username, hashPassword(password), Date.now());
  return Number(r.lastInsertRowid);
}

function playerForAccount(accountId) {
  return open().prepare('SELECT id FROM players WHERE account_id = ?').get(accountId)?.id ?? null;
}

// Yeni oyuncu: fraksiyonun başlangıç haritası, başlangıç gemisi ve paketi (config.starter).
function createPlayer(accountId, name, factionId, starter) {
  return tx(db => {
    const map = db.prepare('SELECT * FROM maps WHERE faction_id = ? AND is_start = 1').get(factionId);
    const r = db.prepare(`INSERT INTO players (account_id, name, faction_id, credits, uridium, map_id, x, y, created_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`).run(accountId, name, factionId, starter.credits, starter.uridium, map.id, map.start_x, map.start_y, Date.now());
    const playerId = Number(r.lastInsertRowid);
    const shipType = db.prepare('SELECT * FROM ship_types WHERE loot_id = ?').get(starter.ship);
    const s = db.prepare('INSERT INTO ships (player_id, loot_id, hitpoints, favorite) VALUES (?, ?, ?, 1)').run(playerId, starter.ship, shipType.hitpoints);
    const shipId = Number(s.lastInsertRowid);
    db.prepare('UPDATE players SET active_ship_id = ? WHERE id = ?').run(shipId, playerId);
    const ins = db.prepare('INSERT INTO items (player_id, loot_id, amount, ship_id, slot, slot_index) VALUES (?, ?, ?, ?, ?, ?)');
    const slotCount = {};
    for (const [lootId, amount, slot] of starter.items) {
      const idx = slot ? (slotCount[slot] = (slotCount[slot] ?? -1) + 1) : null;
      ins.run(playerId, lootId, amount, slot ? shipId : null, slot || null, idx);
    }
    // Başlangıçta kalkan dolu.
    const equipped = equippedItems(db, shipId);
    db.prepare('UPDATE ships SET shield = ? WHERE id = ?').run(computeStats(shipType, equipped).shieldMax, shipId);
    return playerId;
  });
}

function equippedItems(db, shipId) {
  return db.prepare(`SELECT i.*, t.category, t.damage, t.shield, t.shield_absorb, t.speed, t.multiplier
    FROM items i JOIN item_types t ON t.loot_id = i.loot_id WHERE i.ship_id = ? AND i.slot IS NOT NULL`).all(shipId);
}

// Oyun içinde kullanılan oyuncu nesnesi.
function loadPlayer(playerId) {
  const db = open();
  const p = db.prepare('SELECT * FROM players WHERE id = ?').get(playerId);
  if (!p) return null;
  const ship = db.prepare('SELECT * FROM ships WHERE id = ?').get(p.active_ship_id);
  const shipType = db.prepare('SELECT * FROM ship_types WHERE loot_id = ?').get(ship.loot_id);
  const inventory = require('../inventory');
  const activeConfig = inventory.activeConfig(db, ship.id);
  let stats = computeStats(shipType, inventory.statItems(db, ship.id, activeConfig));
  stats = require('../ship-passives').applyStats(ship.loot_id, stats);
  stats = require('../drones').applyStats(playerId, stats);
  stats = require('../skills').applyStats(playerId, stats);
  stats = require('../handlers/lab').applyStats(playerId, stats);
  stats = require('../boosters').applyStats(playerId, stats);
  const cargoUsed = db.prepare('SELECT COALESCE(SUM(amount), 0) n FROM player_resources WHERE player_id = ? AND ore_type<>3').get(playerId).n;
  const typeId = inventory.shipAppearance(db, ship);
  return {
    userId: p.id, userName: p.name, factionId: p.faction_id, level: p.level,
    ep: p.ep, honourPoints: p.honour, credits: p.credits, uridium: p.uridium, jackpot: p.jackpot,
    mapId: p.map_id, x: p.x, y: p.y, premium: !!p.premium, galaxyGatesDone: require('../gate-rings').sync(db, p.id),
    shipId: ship.id, typeId, activeConfig, dailyRank:require('../ranks').current(db,p.id).dailyRank,
    hitPoints: Math.min(ship.hitpoints, stats.hitMax), hitMax: stats.hitMax,
    shield: Math.min(ship.shield, stats.shieldMax), shieldMax: stats.shieldMax,
    speed: stats.speed, cargoSpace: Math.max(0, stats.cargoMax - cargoUsed), cargoSpaceMax: stats.cargoMax,
    nanoHull: Math.min(ship.nano_hull||0,require('../nano-hull').maximum(ship.loot_id)), maxNanoHull: require('../nano-hull').maximum(ship.loot_id), expansionStage: require('../laser-visuals').stage(typeId, stats.shipLaserCount),
    stats
  };
}

function savePlayer(p) {
  tx(db => {
    p.galaxyGatesDone = require('../gate-rings').derive(db, p.userId);
    db.prepare(`UPDATE players SET level = ?, ep = ?, honour = ?, credits = ?, uridium = ?, jackpot = ?,
      map_id = ?, x = ?, y = ?, galaxy_gates_done = ? WHERE id = ?`)
      .run(p.level, p.ep, p.honourPoints, p.credits, p.uridium, p.jackpot, p.mapId, p.x, p.y, p.galaxyGatesDone, p.userId);
    // Ultimate Cloak temporarily suppresses the live shield. Persist its own
    // configuration's real pool, so saving/restarting cannot erase equipment HP.
    db.prepare('UPDATE ships SET hitpoints = ?, shield = ?, nano_hull=? WHERE id = ? AND player_id=?').run(p.hitPoints,p.ultimateCloaked?(p.ultimateShield||0):p.shield,Math.max(0,Math.round(p.nanoHull||0)),p.shipId,p.userId);
  });
}

module.exports = { findAccount, createAccount, checkPassword, playerForAccount, createPlayer, loadPlayer, savePlayer };
