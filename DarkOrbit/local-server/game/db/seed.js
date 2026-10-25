'use strict';
// Katalog tohumu: gemi/eşya türleri, haritalar, NPC türleri ve doğma noktaları.
// Klasik dünya normal-map-content sürümü ilk kurulumda uygulanır ve önceki
// dünya kayıtları arşivlenir; sonraki açılışlarda nüfus düzeni yeniden yazılmaz.
//
// Kaynaklar:
//  - NPC tip/can/kalkan: canlı kayıt (tip 84: 800/400, 71: 2000/2000, 119 "-=[ Curcubitor ]=-": 10000/7500).
//  - Eşya kimliği biçimi: istemcinin görsel yolları (equipment/weapon/laser/lf-1 ...).
//  - Gemi/eşya istatistikleri ve fiyatlar: istemciye gömülü katalog (main.swf), katalog her açılışta
//    tablolara işlenir (ON CONFLICT DO UPDATE); el ile değiştirmek için catalog.json'u düzenleyin.

// Gemi ve eşya türleri istemciye gömülü katalogdan gelir (game/db/catalog.json, tools/import-catalog.js).
const CATALOG = require('./catalog.json');

// Harita kimlikleri istemcinin harita numaraları: 1-1=1 … 1-4=4, 2-1=5 … 3-4=12.
// [id, ad, fraksiyon, başlangıç mı, başlangıç x, başlangıç y]
const MAPS = [
  [1, '1-1', 1, 1, 3267, 2635], [2, '1-2', 1, 0, 1000, 1000], [3, '1-3', 1, 0, 1000, 1000], [4, '1-4', 1, 0, 1000, 1000],
  [5, '2-1', 2, 1, 19200, 1800], [6, '2-2', 2, 0, 1000, 1000], [7, '2-3', 2, 0, 1000, 1000], [8, '2-4', 2, 0, 1000, 1000],
  [9, '3-1', 3, 1, 19200, 11300], [10, '3-2', 3, 0, 1000, 1000], [11, '3-3', 3, 0, 1000, 1000], [12, '3-4', 3, 0, 1000, 1000]
];

// [tip, ad, can, kalkan, hız, hasar min, hasar max, EP, onur, kredi, uridyum]
const NPCS = [
  [84, '-=[ Streuner ]=-', 800, 400, 280, 15, 25, 400, 2, 400, 1],
  [71, '-=[ Lordakia ]=-', 2000, 2000, 300, 70, 90, 800, 4, 800, 2],
  [119, '-=[ Curcubitor ]=-', 10000, 7500, 280, 120, 180, 420, 2, 400, 1]
];

// [harita, tip, adet]
const SPAWNS = [
  [1, 84, 15], [5, 84, 15], [9, 84, 15],
  [2, 84, 10], [2, 71, 6], [2, 119, 4],
  [6, 84, 10], [6, 71, 6], [10, 84, 10], [10, 71, 6]
];

function run(db) {
  const ship = db.prepare(`INSERT INTO ship_types (loot_id, name, hitpoints, speed, cargo, laser_slots, generator_slots, extra_slots, price_credits, price_uridium)
    VALUES (?,?,?,?,?,?,?,?,?,?) ON CONFLICT(loot_id) DO UPDATE SET name=excluded.name, hitpoints=excluded.hitpoints, speed=excluded.speed,
    cargo=excluded.cargo, laser_slots=excluded.laser_slots, generator_slots=excluded.generator_slots, extra_slots=excluded.extra_slots,
    price_credits=excluded.price_credits, price_uridium=excluded.price_uridium`);
  const item = db.prepare(`INSERT INTO item_types (loot_id, name, category, damage, shield, shield_absorb, speed, multiplier, price_credits, price_uridium)
    VALUES (?,?,?,?,?,?,?,?,?,?) ON CONFLICT(loot_id) DO UPDATE SET name=excluded.name, category=excluded.category, damage=excluded.damage,
    shield=excluded.shield, shield_absorb=excluded.shield_absorb, speed=excluded.speed, multiplier=excluded.multiplier,
    price_credits=excluded.price_credits, price_uridium=excluded.price_uridium`);
  const map = db.prepare('INSERT OR IGNORE INTO maps (id, name, faction_id, is_start, start_x, start_y) VALUES (?,?,?,?,?,?)');
  const npc = db.prepare('INSERT OR IGNORE INTO npc_types (type_id, name, hitpoints, shield, speed, damage_min, damage_max, reward_ep, reward_honour, reward_credits, reward_uridium) VALUES (?,?,?,?,?,?,?,?,?,?,?)');
  db.exec('BEGIN');
  try {
    for (const v of CATALOG.ships) ship.run(v.lootId, v.name, v.hitpoints, v.speed, v.cargo, v.laserSlots, v.generatorSlots, v.extraSlots, v.credits, v.uridium);
    for (const v of CATALOG.items) item.run(v.lootId, v.name, v.category, v.damage, v.shield, v.absorb, v.speed, v.multiplier, v.credits, v.uridium);
    for(const v of require('../module-policy').DEFINITIONS)item.run(v.id,v.name,'resource',0,0,0,0,1,0,v.price);
    MAPS.forEach(r => map.run(...r));
    NPCS.forEach(r => npc.run(...r));
    require('../npc-catalog').seed(db);
    if (!db.prepare('SELECT 1 FROM map_spawns LIMIT 1').get()) {
      const spawn = db.prepare('INSERT INTO map_spawns (map_id, npc_type, count) VALUES (?,?,?)');
      SPAWNS.forEach(r => spawn.run(...r));
    }
    require('../normal-map-content').seed(db);
    db.exec('COMMIT');
  } catch (e) {
    db.exec('ROLLBACK');
    throw e;
  }
}

module.exports = { run };
