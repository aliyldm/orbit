'use strict';
// The unmodified builder knows exactly six ammo icons/names and Xenomit,
// repair vouchers and logfiles. Packages diversify those real outputs without
// falsely relabeling unsupported ammo/keys; see docs/systems.md.
const DEFAULT_TIER_WEIGHTS = { normal: 85, rare: 13, veryRare: 2 };
const LOOT = {
  mcb25: ['ammunition_laser_mcb-25', 1, 2], mcb50: ['ammunition_laser_mcb-50', 1, 3],
  ucb100: ['ammunition_laser_ucb-100', 1, 4], sab50: ['ammunition_laser_sab-50', 1, 5],
  plt2021: ['ammunition_rocket_plt-2021', 2, 3], acm01: ['ammunition_mine_acm-01', 3, 11],
  xenomit: ['resource_ore_xenomit', 4, 0], voucher: ['resource_repairvoucher', 5, 0], logfile: ['resource_logfile', 8, 0]
};
const pack = (id, entries) => ({ id, rewards: entries.map(([key, amount]) => {
  const [lootId, type, itemId] = LOOT[key]; return { lootId, type, itemId, amount };
}) });
const packages = {
  normal: {
    ammo: [pack('mcb25', [['mcb25', 280]]), pack('mcb50', [['mcb50', 100]]), pack('ucb100', [['ucb100', 50]]),
      pack('sab50', [['sab50', 100]]), pack('plt2021', [['plt2021', 40]]), pack('acm01', [['acm01', 3]])],
    ore: [pack('xenomit', [['xenomit', 10]])], voucher: [pack('voucher', [['voucher', 1]])], logfile: [pack('logfile', [['logfile', 1]])]
  },
  rare: {
    ammo: [pack('laser-supply', [['mcb25', 560], ['mcb50', 150]]), pack('laser-upgrade', [['mcb50', 250], ['ucb100', 100]]),
      pack('shield-hunter', [['ucb100', 150], ['sab50', 250]]), pack('shield-and-rocket', [['sab50', 300], ['plt2021', 120]]),
      pack('explosive-supply', [['plt2021', 160], ['acm01', 12]]), pack('mine-and-laser', [['acm01', 15], ['mcb25', 800]])],
    ore: [pack('xenomit-crate', [['xenomit', 60]])], voucher: [pack('repair-supply', [['voucher', 3]])], logfile: [pack('research-supply', [['logfile', 5]])]
  },
  veryRare: {
    ammo: [pack('laser-arsenal', [['mcb25', 1400], ['mcb50', 500], ['ucb100', 300]]),
      pack('heavy-hunter', [['ucb100', 400], ['sab50', 800], ['plt2021', 400]]),
      pack('defence-arsenal', [['sab50', 1000], ['acm01', 45], ['mcb50', 600]]),
      pack('explosive-arsenal', [['plt2021', 600], ['acm01', 60], ['ucb100', 400]]),
      pack('assault-arsenal', [['mcb50', 1000], ['ucb100', 500], ['plt2021', 800]]),
      pack('mixed-arsenal', [['mcb25', 2000], ['sab50', 1000], ['acm01', 75]])],
    ore: [pack('xenomit-reserve', [['xenomit', 300]])], voucher: [pack('repair-reserve', [['voucher', 10]])], logfile: [pack('research-reserve', [['logfile', 20]])]
  }
};
function weights(config = {}) {
  const result = { ...DEFAULT_TIER_WEIGHTS, ...config };
  for (const [tier, weight] of Object.entries(result)) {
    if (!Object.hasOwn(packages, tier) || !Number.isSafeInteger(weight) || weight < 0 || weight > 1000000) throw new Error('Invalid gate reward tier weights');
  }
  if (!Object.values(result).some(value => value > 0)) throw new Error('Empty gate reward tier weights');
  return result;
}
function choose(category, roll, config) {
  if (!Number.isFinite(roll) || roll < 0 || roll >= 1) throw new Error('Invalid gate random value');
  const w = weights(config), total = Object.values(w).reduce((sum, value) => sum + value, 0);
  let cursor = roll * total;
  for (const tier of ['normal', 'rare', 'veryRare']) {
    if (cursor < w[tier]) {
      const list = packages[tier][category];
      if (!list) throw new Error('Invalid gate reward category');
      return { tier, ...list[Math.min(list.length - 1, Math.floor(cursor / w[tier] * list.length))] };
    }
    cursor -= w[tier];
  }
  throw new Error('Invalid gate reward selection');
}
// Multi-energy packets have byte-sized vectors. Merge identical output modules
// so even 100 three-item packages fit without dropping a real paid reward.
function aggregate(items) {
  const result = [], groups = new Map();
  for (const item of items) {
    if (item._ === 'GalaxyGateBuilderPartItemModule') { result.push(item); continue; }
    const key = `${item._}:${item.type}:${item.item_id}:${item.multiplier_used}`;
    const old = groups.get(key);
    if (old) { old.amount += item.amount; old.multiplier_amount += item.multiplier_amount; old.spins += item.spins; }
    else { const copy = { ...item }; groups.set(key, copy); result.push(copy); }
  }
  if (result.length > 255 || result.some(item => item.spins > 127 || item.amount > 0x7fffffff)) throw new Error('Gate reward packet overflow');
  return result;
}
module.exports = { LOOT, DEFAULT_TIER_WEIGHTS, packages, weights, choose, aggregate };
