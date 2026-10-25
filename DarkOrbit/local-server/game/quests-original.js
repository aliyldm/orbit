'use strict';
// Objective/reward facts from the 2015 NYX player report on the official forum.
// Reconstructed IDs, translated summaries and level-only availability are local;
// unreported prerequisite chains, timers and PvP objectives are NOT invented.
const source='https://board-en.darkorbit.com/threads/nyx-mission-faq.102728/';
const npc=(key,count,map)=>({key,count,map}),ore=(key,count,map)=>({ore:key,count,map});
const rows=[
 [5,'Break the Supply Chain',25,1600,50000,[npc('mordon',2)]],
 [5,'Expedition Escort',25,1600,50000,[npc('boss-lordakia',1),npc('mordon',2)]],
 [6,'Crystal Shield',30,1750,60000,[npc('saimon',10)]],
 [6,'Kristallon Query',30,1750,60000,[npc('boss-saimon',2)]],
 [6,'Ancient and Forgotten',30,1750,60000,[npc('mordon',3)]],
 [6,'The Lost Colony',30,1750,60000,[npc('lordakia',5,3),npc('saimon',5,3)]],
 [6,'Slave Traders',30,1750,60000,[npc('lordakia',10,3),npc('mordon',1,3)]],
 [6,'Patronage',30,1750,60000,[npc('saimon',12,3)]],
 [6,'Propaganda! Propaganda!',30,1750,60000,[npc('mordon',5,3)]],
 [6,'Nasty Surprise',30,1750,60000,[npc('saimon',10,3),npc('boss-saimon',1,3),npc('boss-mordon',1,3)]],
 [6,'Ore Bottleneck',30,1750,60000,[ore('prometium',350)]],
 [6,'Endurium Reserves',30,1750,60000,[ore('endurium',350)]],
 [6,'Prometid Bribery',30,1750,60000,[ore('endurium',200,2),ore('prometium',200,2)]],
 [6,'Terbium Core',30,1750,60000,[ore('terbium',200,3)]],
 [8,'Data Acquisition',40,18900,80000,[npc('mordon',5,4)]],
 [8,'Sitting Duck',40,18900,80000,[ore('duranium',50)]],
 [8,'War Machine',40,18900,80000,[npc('saimon',10),npc('mordon',2)]],
 [8,'Breakthrough',40,18900,80000,[ore('prometid',50)]],
 [8,'Puppeteer',40,18900,80000,[npc('lordakia',10,4),npc('saimon',3,4),npc('mordon',1,4)]],
 [8,'The Scout',40,18900,80000,[npc('saimon',15)]],
 [8,'Prepare for Trouble',40,18900,80000,[ore('promerium',20)]],
 [12,'The Usual Suspects',60,565000,120000,[npc('sibelonit',15,5)]],
 [12,'Blood Ties',60,565000,120000,[npc('lordakium',3,5)]],
 [12,'About-Face',60,565000,120000,[npc('kristallin',10,6)]],
 [12,'Stronghold',60,565000,120000,[npc('kristallon',1,7),npc('kristallin',7,7)]],
 [12,'Stealth Observation',60,565000,120000,[npc('streuner-upper',25,8)]],
 [12,'Sabotage Suppliers',96,565000,120000,[npc('kristallin',12,7),npc('kristallin',12,6)]],
 [12,'Target Unclear',192,565000,120000,[npc('kristallon',3,7),npc('kristallon',3,6)]],
 [12,'New Lead',84,565000,120000,[npc('sibelonit',12),npc('lordakium',3)]],
 [12,'Duke in the Spotlight',60,565000,120000,[npc('lordakia',15,5),npc('lordakium',3,5)]],
 [12,'Pilot Proficiency',100,565000,120000,[npc('sibelonit',20),npc('sibelon',5)]],
 [12,'Treacherous Beacon',280,565000,120000,[npc('sibelon',5),npc('lordakium',5),npc('kristallon',5)],['ammunition_mine_acm-01',5]],
 [12,'The Mad Duke',100,565000,120000,[npc('lordakium',7),npc('kristallon',7)],['ammunition_mine_acm-01',5]]
];
function make({quest,condition,loot,uri,ep,credits}){
 const catalog=require('./npc-catalog'),ids=require('./quests-npc-ids.json').visualToNpcId;
 return rows.map(([level,title,u,x,c,goals,extra],i)=>{
  const objectives=goals.map(g=>condition(g.ore?67:6,g.count,[g.ore?'resource_ore_'+g.ore:String(ids[catalog.definitions[g.key]?.typeId])],g.map?['own:'+g.map]:undefined));
  if(objectives.some(o=>o.matches.includes('undefined')))throw Error('Unknown NYX NPC '+title);
  const rewards=[uri(u),ep(x),credits(c),...(extra?[loot(...extra)]:[])],description=goals.map(g=>`${g.count} ${g.ore||g.key}${g.map?' (şirketinin x-'+g.map+' haritası)':''}${g.ore?' topla':' yok et'}`).join('; ')+'.';
  const q=quest(910001+i,level,null,objectives,rewards,{title:'[NYX] '+title,description});
  q.provenance={kind:'reconstructed-nyx',source,edition:2015,originalTitle:title,originalId:null,availability:'local-level-only'};return q;
 });
}
module.exports={rows,source,make};
