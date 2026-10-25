'use strict';
// Gemi istatistikleri: gemi türünün taban değerleri + takılı eşyalar.
//   can      = ship_types.hitpoints
//   kalkan   = takılı kalkan jeneratörlerinin toplamı; emilim = onların ortalaması
//   hız      = taban hız + hız jeneratörleri
//   hasar    = takılı lazerlerin toplamı (atış başına), seçili cephanenin çarpanıyla
// Değerlerin kaynağı game/db/seed.js'deki katalog.

const META=require('../docs/client-map.items.json').items;
function upgraded(item,property) {
  const rule=META[item.loot_id]?.upgradable;
  const relevant=property==='damage'?rule?.upgradeType==='LASER_DAMAGE_UPGRADE':property==='shield'&&rule?.upgradeType==='GENERATOR_SHIELD_UPGRADE';
  return relevant?item[property]*(1+(item.upgrade_level||0)*rule.bonusPerLevel/100):item[property];
}
function computeStats(shipType, equipped) {
  const launcher=require('./launcher-hardware').passives(equipped);
  const shields = equipped.filter(i => i.category === 'shield_generator');
  const shieldMax = Math.round(shields.reduce((a, i) => a + upgraded(i,'shield'), 0));
  const absorb = shields.length ? shields.reduce((a, i) => a + i.shield_absorb, 0) / shields.length : 0;
  const speed = shipType.speed + equipped.filter(i => i.category === 'speed_generator').reduce((a, i) => a + i.speed, 0);
  const lasers = equipped.filter(i => i.category === 'laser');
  return {
    shipModules:require('./ship-modules').effects(shipType.loot_id,equipped),
    shipModuleCount:equipped.filter(i=>i.slot==='ship_upgrade'&&require('./ship-modules').compatible(i.loot_id,shipType.loot_id)).length,
    hitMax: Math.round(shipType.hitpoints*(1+require('./modern-lasers').hpBonus(lasers))*(1+launcher.hp)),
    shieldMax: Math.round(shieldMax*(1+launcher.shield)),
    shieldRegenMultiplier: require('./fusion-shields').multiplier(shields),
    shieldAbsorb: absorb,
    speed,
    speedGeneratorBonus: equipped.filter(i=>i.category==='speed_generator').reduce((a,i)=>a+i.speed,0),
    laserCount: lasers.length,
    shipLaserCount: lasers.filter(i => i.drone_id == null).length,
    laserDamage: Math.round(lasers.reduce((a, i) => a + upgraded(i,'damage'), 0)*(1+launcher.damage)),
    rocketMultiplier:1+launcher.damage,
    abilityCooldownReduction:launcher.abilityCooldown,
    laserProfiles: require('./modern-lasers').profile(lasers),
    driveDefense: Math.round(equipped.filter(i=>i.slot==='lens').reduce((n,i)=>n+require('./modern-lasers').upgraded({...i,driveDef:META[i.loot_id]?.driveDef||0},'driveDef'),0)),
    cannonDefense: Object.fromEntries(['t','c','e'].map(type=>[type,Math.round(equipped.filter(i=>i.slot==='cannon_shield'&&i.loot_id.startsWith('equipment_cannon_shield_mr-'+type)).reduce((n,i)=>n+require('./modern-lasers').upgraded({...i,cannonDef:META[i.loot_id]?.cannonDef||0},'cannonDef'),0))])),
    cargoMax: shipType.cargo*(equipped.some(i=>i.slot==='extra'&&i.loot_id==='equipment_extra_cpu_g3x-crgo-x')?2:1)
  };
}

module.exports = { computeStats };
