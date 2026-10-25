'use strict';
// Official EN bonus FAQ796 establishes amounts, ammo mapping and battle-map
// +50% (extra energy remains1). Category/amount probabilities are unpublished.
const PROVENANCE='classic-bonus-values-local-odds-v1';
const entries=[
 ...[200,500,1000].map(credits=>({credits})),
 ...[20,50,100].map(uridium=>({uridium})),
 ...[10,20,50].map(n=>({items:{'ammunition_laser_lcb-10':n}})),
 ...['ammunition_laser_mcb-25','ammunition_laser_mcb-50'].flatMap(id=>[5,10,20].map(n=>({items:{[id]:n}}))),
 {energy:1}
];
function roll(mapId,random=Math.random){
 const r=random();if(!(r>=0&&r<1))throw Error('Invalid bonus-box random sample');
 const reward=structuredClone(entries[Math.floor(r*entries.length)]),battle=[13,14,15,16,29].includes(Number(mapId)),factor=battle?1.5:1;
 for(const k of ['credits','uridium'])if(reward[k])reward[k]*=factor;
 if(reward.items)for(const k of Object.keys(reward.items))reward.items[k]=Math.round(reward.items[k]*factor);
 return reward;
}
module.exports={roll,entries,PROVENANCE};
