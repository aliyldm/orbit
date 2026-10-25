'use strict';
// Official NPC membership / behaviour; population counts and respawn times are
// explicit local tuning. No DB writes or catalogue-stat overrides in this module.
const SOURCES=Object.freeze({
 clientConfig:'client/spacemap/graphics/spacemap-config.xml',
 standardEn:'https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/',
 bossEn:'https://board-en.darkorbit.com/threads/boss-alien-faq.801/',
 npcDe:'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/',
 npcDe2:'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2',
 npcEs:'https://board-es.darkorbit.com/threads/faqs-aliens.135697/'
});
const passive=new Set(['streuner','lordakium','kristallon','cubikon','streuner-upper',
 'boss-streuner','boss-lordakium','boss-kristallon','boss-streuner-upper',
 'uber-streuner','uber-lordakium','uber-kristallon','uber-streuner-upper',
 'uber-barracuda','uber-annihilator','uber-saboteur','uber-battleray']);
const enAggression=new Set(['streuner','lordakium','cubikon','streuner-upper','boss-streuner','boss-streuner-upper']);
function row(key,count,sourceIds,extra={}){
 const boss=key.startsWith('boss-'),uber=key.startsWith('uber-');
 return {key,count,respawnMs:boss?90000:uber?120000:key==='cubikon'||key==='battleray'?120000:30000,
  aggressive:!passive.has(key),localPopulation:true,localRespawn:true,localAggression:false,
  sourceIds,aggressionSourceIds:[enAggression.has(key)?key.startsWith('boss-')?'bossEn':'standardEn':'npcEs'],...extra};
}
const standard=(key,count,extra={})=>row(key,count,['standardEn','npcDe'],extra);
const boss=(key,count=1)=>row('boss-'+key,count,['bossEn','npcDe']);
const uber=(key,count=1)=>row('uber-'+key,count,['npcDe']);
const pirate=(key,count,extra={})=>row(key,count,['npcDe2','npcEs'],extra);
const suffixProfiles={
 'x-1':[standard('streuner',20)],
 'x-2':[standard('streuner',24),standard('lordakia',16),boss('streuner'),boss('lordakia')],
 'x-3':[standard('lordakia',6),standard('saimon',6),standard('mordon',8),standard('devolarium',16),boss('mordon'),
  row('boss-saimon',1,['clientConfig']),boss('devolarium')],
 'x-4':[standard('lordakia',6),standard('saimon',6),standard('mordon',8),standard('sibelon',16),boss('saimon'),boss('sibelon')],
 'x-5':[standard('lordakia',8),standard('sibelonit',12),standard('lordakium',12),boss('sibelonit'),boss('lordakium')],
 'x-6':[standard('kristallin',16),standard('kristallon',12),boss('kristallin'),standard('cubikon',2),
  standard('protegit',20,{dependentOn:'cubikon',spawnTrigger:'parent-attacked',sourceIds:['npcDe','standardEn']})],
 'x-7':[standard('kristallin',12),standard('kristallon',18),boss('kristallin',2),boss('kristallon')],
 'x-8':[standard('streuner-upper',24),boss('streuner-upper',2)]
};
const families=['streuner','lordakia','saimon','mordon','devolarium','sibelon','sibelonit','lordakium','kristallin','kristallon','streuner-upper'];
const pvp45=[...families.map(k=>boss(k)),...families.map(k=>uber(k)),
 pirate('uber-interceptor',1),pirate('uber-barracuda',1),pirate('uber-saboteur',1),pirate('uber-annihilator',1),pirate('uber-battleray',1),
 pirate('uber-interceptor',10,{dependentOn:'uber-battleray',spawnTrigger:'parent-present'})];
function pirates(map){
 const rows=[pirate('interceptor',20),pirate('barracuda',10),pirate('saboteur',6),pirate('annihilator',6),
  pirate('uber-interceptor',1),pirate('uber-barracuda',1)];
 if(map==='5-2')rows.push(pirate('uber-saboteur',1),pirate('uber-annihilator',1));
 if(map==='5-3')rows.push(pirate('battleray',1),pirate('interceptor',10,{dependentOn:'battleray',spawnTrigger:'parent-present'}));
 return rows;
}
const profiles={};
for(let faction=1;faction<=3;faction++)for(let suffix=1;suffix<=8;suffix++)profiles[`${faction}-${suffix}`]=suffixProfiles[`x-${suffix}`];
profiles['4-5']=pvp45;
for(const map of ['5-1','5-2','5-3'])profiles[map]=pirates(map);
// Mechanism evidence only. Numeric proc chance, radius, healing rate, escort
// count and explosion formula are not implied by these source labels.
const effects={
 saimon:{sourceIds:['npcEs'],mechanisms:['low-hp-emp-unlock-target']},
 mordon:{sourceIds:['npcEs'],mechanisms:['slowing-rocket']},
 sibelon:{sourceIds:['npcEs'],mechanisms:['steal-target-shield-until-own-shield-empty']},
 lordakium:{sourceIds:['npcEs'],mechanisms:['spawn-spore-lordakia-on-death']},
 'boss-lordakia':{sourceIds:['bossEn'],mechanisms:['call-lordakia-for-help']},
 cubikon:{sourceIds:['npcDe','standardEn'],mechanisms:['protegit-escorts-on-attack','shared-kill-reward']},
 barracuda:{sourceIds:['npcEs'],mechanisms:['low-hp-self-destruct'],approximateSelfDestructDelayMs:10000},
 saboteur:{sourceIds:['npcEs'],mechanisms:['slow-target','emp-clears-slow']},
 annihilator:{sourceIds:['npcEs'],mechanisms:['hellstorm-rockets']},
 battleray:{sourceIds:['npcEs'],mechanisms:['interceptor-escorts','escort-dependent-invulnerability','heal-interceptors','shared-kill-reward']},
 'uber-barracuda':{sourceIds:['npcEs'],mechanisms:['low-hp-self-destruct']},
 'uber-saboteur':{sourceIds:['npcEs'],mechanisms:['slow-target','emp-clears-slow']},
 'uber-annihilator':{sourceIds:['npcEs'],mechanisms:['hellstorm-rockets']},
 'uber-battleray':{sourceIds:['npcEs'],mechanisms:['uber-interceptor-escorts']}
};
function deepFreeze(value){if(value&&typeof value==='object'&&!Object.isFrozen(value)){Object.values(value).forEach(deepFreeze);Object.freeze(value);}return value;}
deepFreeze(profiles);deepFreeze(suffixProfiles);deepFreeze(effects);
function get(mapName){return structuredClone(profiles[String(mapName)]||suffixProfiles[String(mapName)]||[]);}
module.exports={profiles,suffixProfiles,get,effects,SOURCES};
