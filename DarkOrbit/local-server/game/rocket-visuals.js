'use strict';
// Pilot BIO FAQ: max Rocket Fusion => purple trail; Heat Seeking glow only
// on a hit rescued by the skill. Client v[6]/v[7] select smoke/heat seeking.
const clamp = n => Math.max(0, Math.min(1, n));
function shot(playerId, baseChance = 1, random = Math.random) {
  const levels = require('./skills').state(playerId).levels;
  const smokeId = levels['6'] === 5 ? 1 : 0;
  const bonus = [0,.01,.02,.04,.06,.10][levels['20'] || 0] || 0;
  const base = clamp(Number.isFinite(baseChance) ? baseChance : 1);
  const chance = clamp(base + bonus);
  const roll = base === 1 ? 0 : random();
  const hit = roll < chance;
  return { hit, smokeId, isHeatSeeking: hit && bonus > 0 && roll >= base };
}
module.exports = { shot };
