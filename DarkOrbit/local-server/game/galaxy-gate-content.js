'use strict';
// Major-wave membership/counts and Delta scales are official FAQ facts.
// Sub-wave splitting/timing is explicit local scheduling; see docs/gate-content.md.
const SOURCES = {
  alpha: 'https://board-en.darkorbit.com/threads/alpha-gate-faq.784/',
  delta: 'https://board-en.darkorbit.com/threads/delta-gate-faq.840/',
  epsilon: 'https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/',
  zeta: 'https://board-en.darkorbit.com/threads/zeta-gate-faq.852/',
  kappa: 'https://board-en.darkorbit.com/threads/kappa-galaxy-gate-faq.837/',
  other: 'https://board-de.darkorbit.com/threads/faq-galaxy-gates.2848/'
};
// key, count, HP/shield/damage/reward scale, invulnerable until major escorts die.
const n = (key, count, scale = 1, protectedBoss = false) => ({ key, count, scale, protectedBoss });
const major = (groups, phases, options = {}) => ({ groups, phases, ...options });
const batch = (groups, phases = 1) => ({ groups, phases });
const ordered = (batches, options = {}) => major(batches.flatMap(b => b.groups), batches.reduce((n, b) => n + b.phases, 0), { ...options, batches });
const alpha = [n('streuner', 40), n('lordakia', 40), n('mordon', 40), n('saimon', 80), n('devolarium', 20),
  n('kristallin', 80), n('sibelon', 20), n('sibelonit', 80), n('kristallon', 16), n('protegit', 30)].map(group => major([group], 4));
const lists = {
  1: alpha, 2: alpha.map(m => major(m.groups.map(g => ({ ...g, scale: 2 })), 4)),
  3: alpha.map(m => major(m.groups.map(g => ({ ...g, scale: 3 })), 4)),
  4: [
    major([n('lordakia', 5, 2), n('mordon', 10, 2), n('saimon', 15, 2)], 3),
    major([n('streuner', 11, 2), n('streuner-upper', 1, 4, true)], 3),
    major([n('mordon', 5, 2), n('saimon', 10, 2), n('kristallin', 15, 2)], 3),
    major([n('lordakia', 12, 4), n('lordakium', 1, 2, true)], 3),
    major([n('boss-lordakia', 10), n('boss-saimon', 6), n('boss-mordon', 8)], 3),
    major([n('sibelonit', 15, 2), n('sibelon', 1, 3, true)], 3),
    major([n('sibelonit', 5, 2), n('kristallin', 10, 3), n('boss-streuner-upper', 5)], 3),
    major([n('kristallin', 10, 3), n('kristallon', 1, 2, true)], 3),
    major([n('protegit', 15, 2), n('boss-lordakium', 3, 1, true)], 3),
    major([n('demaner', 3)], 2)
  ],
  5: [
    major([n('vagrant', 17)], 3), major([n('vagrant', 12), n('marauder', 5)], 3),
    major([n('marauder', 5), n('outcast', 9)], 3), major([n('marauder', 5), n('outcast', 12)], 3),
    major([n('outcast', 6), n('corsair', 9)], 3), major([n('corsair', 4), n('hooligan', 5), n('outcast', 6)], 3),
    major([n('corsair', 5), n('hooligan', 9)], 3), major([n('hooligan', 10), n('ravager', 4)], 3),
    major([n('hooligan', 5), n('ravager', 6), n('convict', 3)], 3), major([n('convict', 4)], 1),
    major([n('ravager', 5), n('convict', 6)], 2)
  ],
  6: [
    major([n('infernal', 10)], 4), major([n('infernal', 9), n('scorcher', 3)], 4),
    major([n('infernal', 5), n('scorcher', 7)], 4), major([n('scorcher', 9)], 4),
    major([n('scorcher', 8), n('melter', 2)], 4), major([n('scorcher', 3), n('melter', 6)], 4),
    major([n('melter', 10)], 4), major([n('melter', 13)], 4),
    major([n('infernal', 6), n('devourer', 1, 1, true)], 3),
    ordered([batch([n('infernal', 2), n('devourer', 1, 1, true)]), batch([n('scorcher', 14)], 2),
      batch([n('boss-streuner', 3), n('uber-streuner', 3), n('streuner-upper', 3)], 2),
      batch([n('lordakia', 3), n('boss-lordakia', 3), n('uber-lordakia', 3)], 2),
      batch([n('saimon', 3), n('boss-saimon', 3), n('uber-saimon', 3)]),
      batch([n('sibelonit', 3), n('boss-sibelonit', 3), n('uber-sibelonit', 3)]),
      batch([n('kristallin', 3), n('boss-kristallin', 3), n('uber-kristallin', 3)], 2)])
  ],
  7: [
    major([n('streuner', 10), n('vagrant', 10), n('infernal', 10)], 3),
    major([n('marauder', 6), n('scorcher', 7), n('boss-mordon', 8)], 3),
    major([n('outcast', 6), n('devolarium', 6), n('icy', 3)], 3),
    major([n('boss-sibelonit', 5), n('corsair', 5), n('scorcher', 5)], 3),
    major([n('hooligan', 4), n('kristallin', 5), n('melter', 4)], 3),
    major([n('interceptor', 8), n('barracuda', 6), n('annihilator', 3)], 3),
    major([n('boss-lordakium', 6), n('protegit', 8), n('boss-sibelon', 2)], 3),
    ordered([batch([n('kappa-kucurbium', 3)]), batch([n('kappa-kucurbium', 3)]), batch([n('uber-saimon', 8)])]),
    major([n('convict', 5), n('boss-kristallin', 5), n('kappa-demaner', 1)], 3),
    major([n('kappa-boss-kucurbium', 1)], 1), major([n('kappa-century-falcon', 1)], 1)
  ],
  8: [
    major([n('boss-streuner', 10), n('boss-lordakia', 20)], 3),
    major([n('boss-mordon', 10), n('boss-saimon', 14)], 3),
    major([n('boss-devolarium', 4), n('boss-sibelonit', 6)], 3),
    major([n('boss-sibelonit', 10), n('boss-sibelon', 1)], 3),
    major([n('boss-lordakia', 9), n('boss-lordakium', 3)], 3),
    major([n('boss-kristallin', 11), n('boss-kristallon', 1)], 3),
    major([n('boss-kristallon', 2), n('boss-kristallin', 20)], 3)
  ],
  13: ['sibelon', 'lordakium', 'kristallon'].map(key => major([n(key, 30), n(`boss-${key}`, 20), n(`uber-${key}`, 4), n(`emperor-${key}`, 1)], 4, { sequentialTypes: true })),
  // German official edition is intentionally pinned: translated EN/FR counts differ.
  19: [
    ordered([batch([n('streuner', 20)]), batch([n('streuner-upper', 5)]), batch([n('streuner-rocketeer', 1)])], { mapStage: 1 }),
    ordered([batch([n('boss-saimon', 10), n('uber-streuner-upper', 10), n('streuner-rocketeer', 1)], 3),
      batch([n('streuner-soldier', 2)]), batch([n('streuner-soldier', 10), n('saimon', 15)], 2)], { mapStage: 2 }),
    ordered([batch([n('streuner-soldier', 6), n('streuner-specialist', 1)], 2),
      batch([n('streuner-soldier', 10), n('streuner-rocketeer', 1), n('boss-sibelon', 4)], 3),
      batch([n('streuner-soldier', 11), n('streuner-specialist', 2)], 2),
      batch([n('streuner-soldier', 8), n('streuner-specialist', 2), n('streuner-rocketeer', 1)], 3)], { mapStage: 3 }),
    ordered([batch([n('streuner-soldier', 2), n('streuner-rocketeer', 2), n('streuner-turret', 4)], 3),
      batch([n('boss-saimon', 10), n('uber-sibelon', 2), n('streuner-rocketeer', 1)], 3),
      batch([n('streuner-soldier', 3), n('streuner-specialist', 1)], 3), batch([n('streuner-soldier', 3), n('streuner-specialist', 1)], 3),
      batch([n('streuner-soldier', 2), n('streuner-specialist', 1), n('streuner-rocketeer', 1)], 3),
      batch([n('streuner-soldier', 10), n('streuner-specialist', 2)], 5)], { mapStage: 4 }),
    ordered([batch([n('streuner-rocketeer', 1)]), batch([n('streuner-rocketeer', 2)], 2), batch([n('streuner-rocketeer', 6)], 3),
      batch([n('streuner-emperor', 1), n('streuner-rocketeer', 5), n('streuner-specialist', 5)], 5),
      batch([n('streuner-turret', 1), n('uber-sibelon', 2), n('streuner-soldier', 34)], 4)], { mapStage: 5 })
  ]
};
// Epsilon FAQ publishes different stats from the general LoW pirate versions.
for (const m of lists[5]) for (const g of m.groups) g.key = `epsilon-${g.key}`;
const completion = {
  1: [4000000,100000,20000,20000,2,2,0], 2: [8000000,200000,40000,40000,4,4,0],
  3: [12000000,300000,60000,60000,10,6,0], 4: [9000000,225000,45000,45000,8,5,0],
  5: [5000000,150000,25000,20000,10,0,5], 6: [6000000,200000,35000,25000,50,0,25],
  7: [9000000,350000,15000,30000,10,0,5], 8: [2750000,100000,15000,10000,3,0,5],
  13: [4000000,200000,20000,15000,8,0,4], 19: [2000000,150000,15000,0,0,0,5]
};
function completionReward(id) {
  const [ep,honour,uridium,ammunition,logs,vouchers,keys] = completion[id];
  const items = { resource_logfile: logs, resource_repairvoucher: vouchers, 'resource_booty-key': keys };
  const names = { 1:'alpha',2:'beta',3:'gamma',4:'delta',5:'epsilon',6:'zeta',7:'kappa',8:'lambda' };
  if (names[id]) items[`resource_gatepart_gg-part-kronos-${names[id]}`] = 1;
  // Probabilities are pinned separately from today's event/Dispatch additions.
  // Old Zeta 33% and Kappa 25% are explicitly printed in the Spartan FAQ.
  const rare = {
    5: { kind:'item', lootId:'equipment_weapon_laser_lf-4', chance:.25, firstGuaranteed:true },
    6: { kind:'item', lootId:'drone_designs_havoc', chance:.33, firstGuaranteed:true },
    7: { kind:'kappa', chance:.25 },
    13: { kind:'item', lootId:'equipment_weapon_laser_lf-4', chance:.25, chanceSource:'local-unpublished' },
    // The official FAQ does not publish Kuiper's probability. This local
    // default is explicit, configurable and never advertised as original.
    19: { kind:'kuiper', chance:.10, chanceSource:'local-unpublished', ownedCompensation:200000 }
  }[id];
  return { ep,honour,uridium,ammunition,credits:0,items:Object.fromEntries(Object.entries(items).filter(([, n]) => n)),
    completionPolicy:'classic-rare-2026-10-20-v1', ...(rare ? {rare} : {}) };
}
function build(gateId, resolver = require('./npc-catalog').get) {
  const majors = lists[gateId];
  if (!majors) throw new Error(`Gate content missing: ${gateId}`);
  const phases = []; let slot = 0;
  majors.forEach((m, majorIndex) => {
    const start = phases.length;
    for (let i = 0; i < m.phases; i++) phases.push({ major: majorIndex + 1, mapStage: m.mapStage || 1, slots: [] });
    const batches = m.batches || [{ groups: m.groups, phases: m.phases }];
    let offset = 0;
    for (const b of batches) { let cursor = 0; b.groups.forEach((g, groupIndex) => {
      for (let i = 0; i < g.count; i++) {
        const localPhase = offset + (g.protectedBoss ? 0 : m.sequentialTypes ? groupIndex : cursor++ % b.phases);
        phases[start + localPhase].slots.push({ slot: slot++, phase: start + localPhase + 1, key: g.key,
          protectedBoss: g.protectedBoss, def: resolver(g.key, g.scale) });
      }
    }); offset += b.phases; }
    const all = phases.slice(start).flatMap(phase => phase.slots);
    const escorts = all.filter(s => !s.protectedBoss).map(s => ({ slot: s.slot, phase: s.phase }));
    for (const s of all) if (s.protectedBoss) s.protectedBy = escorts;
  });
  return { version: 'official-classic-2026-10-20', gateId, phases, rewards: completionReward(gateId) };
}
module.exports = { SOURCES, lists, build, completionReward };
