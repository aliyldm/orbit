'use strict';
// Only the server's saved run policy chooses rewards; request packets cannot
// supply loot IDs or rolls. See docs/gate-completion-rewards-audit.md.
const META = require('../docs/client-map.items.json').items;
const PERMANENT = new Set(['equipment_weapon_laser_lf-4','drone_designs_havoc','drone_designs_hercules']);
const KAPPA = ['drone_designs_hercules','equipment_weapon_laser_lf-4','booster_kappa-b01',null];
const KUIPER_SHIPS = ['ship_a-elite','ship_c-elite','ship_s-elite','ship_venom','ship_pusat'];
function randomValue(random) {
  const value = random();
  if (!Number.isFinite(value) || value < 0 || value >= 1) throw new Error('Invalid gate completion roll');
  return value;
}
function resolve(db, run, random = Math.random) {
  const reward = JSON.parse(run.rewards_json);
  reward.items = { ...(reward.items || {}) };
  if (!reward.rare) return reward;
  if (reward.completionPolicy !== 'classic-rare-2026-10-20-v1') throw new Error('Unsupported gate completion policy');
  const rule = reward.rare;
  if (!Number.isFinite(rule.chance) || rule.chance < 0 || rule.chance > 1) throw new Error('Invalid gate completion chance');
  const first = !db.prepare("SELECT 1 FROM galaxy_gate_runs WHERE player_id=? AND gate_id=? AND state='won' AND id<>? LIMIT 1")
    .get(run.player_id,run.gate_id,run.id);
  let loot = null, roll = null;
  if (rule.kind === 'item') {
    if (!PERMANENT.has(rule.lootId)) throw new Error('Unsupported gate completion item');
    if (first && rule.firstGuaranteed) loot = rule.lootId;
    else { roll = randomValue(random); if (roll < rule.chance) loot = rule.lootId; }
  } else if (rule.kind === 'kappa' && rule.chance === .25) {
    roll = randomValue(random); loot = KAPPA[Math.floor(roll * KAPPA.length)];
  } else if (rule.kind === 'kuiper' && rule.chanceSource === 'local-unpublished' && rule.ownedCompensation === 200000) {
    roll = randomValue(random);
    if (roll < rule.chance) {
      const ship = KUIPER_SHIPS[Math.floor(randomValue(random) * KUIPER_SHIPS.length)];
      const owned = !!db.prepare('SELECT 1 FROM ships WHERE player_id=? AND loot_id=?').get(run.player_id,ship);
      reward.outcome = { first, roll, lootId:ship, compensation:owned ? rule.ownedCompensation : 0 };
      if (owned) reward.uridium = (reward.uridium || 0) + rule.ownedCompensation;
      else reward.ship = ship;
      return reward;
    }
  } else if(rule.kind==='saturn'&&rule.chanceSource==='local-unpublished'){
    roll=randomValue(random);let alreadyOwned=false;if(roll<rule.chance){loot='ship_g-saturn';alreadyOwned=!!db.prepare('SELECT 1 FROM ships WHERE player_id=? AND loot_id=?').get(run.player_id,loot);if(!alreadyOwned)reward.ship=loot;}
    reward.outcome={first,roll,lootId:loot,alreadyOwned};return reward;
  } else throw new Error('Unsupported gate completion rule');
  reward.outcome = { first, roll, lootId:loot };
  if (loot) reward.items[loot] = (reward.items[loot] || 0) + 1;
  return reward;
}
function deliverItems(db, playerId, reward, options = {}) {
  const delivered = {};
  if (reward.ship) {
    if (!KUIPER_SHIPS.includes(reward.ship)&&reward.ship!=='ship_g-saturn') throw new Error('Invalid gate ship');
    const definition = db.prepare('SELECT hitpoints FROM ship_types WHERE loot_id=?').get(reward.ship);
    if (!definition) throw new Error('Unknown Kuiper ship');
    db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints) VALUES(?,?,?)').run(playerId,reward.ship,definition.hitpoints);
    delivered[reward.ship] = 1;
  }
  for (const [loot, amount] of Object.entries(reward.items || {})) {
    if (!Number.isSafeInteger(amount) || amount <= 0 || amount > 1000000000) throw new Error('Invalid gate completion item amount');
    const metadata = META[loot];
    if (!metadata || !db.prepare('SELECT 1 FROM item_types WHERE loot_id=?').get(loot)) throw new Error('Unknown gate completion item');
    if (loot === 'booster_kappa-b01') {
      require('./boosters').addOwned(db,playerId,loot,amount,options); delivered[loot] = amount; continue;
    }
    if (!metadata.stackable) {
      if (!PERMANENT.has(loot) || amount > 100) throw new Error('Invalid permanent gate completion item');
      for (let i = 0; i < amount; i++) db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,1)').run(playerId,loot);
      delivered[loot] = amount; continue;
    }
    // Kronos has separate per-source limits in the shipped client. Record
    // earned parts without exceeding those slots; its playable gate is separate.
    const cap = loot.startsWith('resource_gatepart_gg-part-kronos-') ? metadata.maxQuantity : 1000000000;
    const total = db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,loot).n;
    const awarded = Math.min(amount, Math.max(0,cap-total));
    if (!awarded) continue;
    const row = db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL ORDER BY id LIMIT 1').get(playerId,loot);
    if (row) db.prepare('UPDATE items SET amount=amount+? WHERE id=?').run(awarded,row.id);
    else db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,?)').run(playerId,loot,awarded);
    delivered[loot] = awarded;
  }
  return delivered;
}
module.exports = { resolve, deliverItems, KUIPER_SHIPS };
