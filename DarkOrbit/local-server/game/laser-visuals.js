'use strict';
const patterns = require('./laser-patterns.json');
// AttackLaserRunCommand uses <patterns><lasers> type IDs, not salvoIDs or
// inventory ammunition IDs. CBO8 intentionally plays two native animations.
const AMMO=Object.freeze({'lcb-10':0,'mcb-25':1,'mcb-50':2,'ucb-100':3,'sab-50':4,'rsb-75':6,
 'cbo-100':8,'job-100':9,'rb-214':10,'pib-100':109,'a-bl':110,'rcb-140':111,'idb-125':112,'vb-142':113,'sbl-100':114});
function ammoType(lootId){const key=(lootId||'ammunition_laser_lcb-10').replace(/^ammunition_laser_/,'');return /^spacecup_group-[a-h]$/.test(key)?32:AMMO[key]??0;}
function stage(typeId, shipLaserCount) {
  if (!(shipLaserCount > 1)) return 1;
  const stages = patterns.expansions[patterns.ships[typeId]];
  if (!stages) return 1; // The client's simple-ship/model markers own this case.
  const ids = Object.keys(stages).map(Number).filter(id => id >= 1 && id <= 4).sort((a, b) => a - b);
  // Local equipment threshold; the source owns the actual salvos and positions.
  // Diminisher stage2 is TWO SINGLE salvos. Its paired emitters start at stage3.
  return ids.find(id => stages[id].some(salvo => salvo.length > 1)) || ids.at(-1) || 1;
}
module.exports = { stage, AMMO, ammoType };
