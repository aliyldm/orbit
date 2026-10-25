'use strict';
// Official bonus-design FAQ, not the zero-valued captured ItemDataProvider traits.
// Scope/edition decisions: docs/design-rank-current.md.
const TYPES={drone_designs_havoc:'havoc',drone_designs_hercules:'hercules',drone_designs_spartan:'spartan',
 'drone_designs_demon-silver':'demon','drone_designs_demon-epic':'demon',drone_designs_hermes:'hermes',
 drone_designs_cerberus:'cerberus','drone_designs_cerberus-inferno':'cerberus'};
function effects(drones,equipment){
 const ids=new Set(drones.map(d=>d.id)),assigned=new Map();
 for(const item of equipment)if(item.drone_slot==='design'&&ids.has(item.drone_id))assigned.set(item.drone_id,TYPES[item.loot_id]||'cosmetic');
 const count=type=>[...assigned.values()].filter(v=>v===type).length;
 const full=type=>ids.size>0&&count(type)===ids.size&&(type!=='spartan'||ids.size===10);
 const spartan=count('spartan'),hermes=count('hermes'),demon=count('demon'),cerberus=count('cerberus');
 return{assigned,counts:{spartan,hermes,demon,cerberus},full:{havoc:full('havoc'),hercules:full('hercules'),spartan:full('spartan'),hermes:full('hermes'),demon:full('demon'),cerberus:full('cerberus')},
  hpBonus:full('hercules')?.2:full('spartan')?.15:spartan*.01,
  baseHpBonus:hermes*.02,rocketMultiplier:1+Math.min(.1,demon*.01),
  rocketCooldown:full('hermes')?.9:full('demon')?.95:1,
  launcherCooldown:full('hermes')?.9:1,mineCooldown:full('hermes')?.9:1,
  abilityCooldownReduction:full('hermes')?.1:0,
  evasion:full('cerberus')?.1:0,laserEfficiency:full('cerberus')?.05:0,
  npcLaserMultiplier:1+cerberus*.01};
}
function mounted(e,droneId){
 const type=e.assigned.get(droneId);
 return{damage:type==='havoc'&&e.full.havoc?1.1:type==='spartan'?1+(e.full.spartan?.1:.01):type==='hermes'?1.005:1,
  shield:type==='hercules'?1.15:type==='spartan'&&e.full.spartan?1.1:1};
}
function summary(e){const {assigned,...rest}=e;return rest;}
module.exports={TYPES,effects,mounted,summary};
