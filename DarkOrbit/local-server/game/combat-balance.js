'use strict';
// Public evidence and the limits of the reconstruction: docs/combat-balance-audit.md.
const SOURCES=Object.freeze({
 laserDamage:'https://board-en.darkorbit.com/threads/laser-damage-charts.888/',
 laserHitChance:'https://board-en.darkorbit.com/threads/permafrost-fissure-faq.117725/',
 abilities:'https://board-de.darkorbit.com/threads/faq-schiffe.2749/'
});
const DEFAULTS=Object.freeze({laserDamageMin:.75,laserDamageMax:1,laserHitChance:.8,npcHitChance:1,rocketHitChance:1,launcherHitChance:1});
const finite=(value,fallback)=>Number.isFinite(value)?value:fallback;
const clamp=(value,fallback=0)=>Math.max(0,Math.min(1,finite(value,fallback)));
function damageRange(cfg={}){
 // Keep explicit historical/custom overrides, particularly damageSpread:0 in
 // deterministic integration scenarios. The production config uses bounds.
 if(Number.isFinite(cfg.damageSpread)){
  const spread=Math.max(0,Math.min(1,cfg.damageSpread));return[1-spread,1+spread];
 }
 const low=clamp(cfg.laserDamageMin,DEFAULTS.laserDamageMin),high=clamp(cfg.laserDamageMax,DEFAULTS.laserDamageMax);
 return low<=high?[low,high]:[high,low];
}
function laserDamage(base,cfg={},random=Math.random){
 const [low,high]=damageRange(cfg),roll=clamp(random());
 return Math.max(0,Math.round(Math.max(0,finite(base,0))*(low+(high-low)*roll)));
}
function hitChance(kind,cfg={}, {accuracy=0,evasion=0,missReduction=0}={}){
 const key=kind+'HitChance';
 if(!Object.hasOwn(DEFAULTS,key))throw new TypeError('Unknown combat hit chance: '+kind);
 // Additive skill/evasion composition is local policy: the public client
 // gives the percentages but does not reveal the private server formula.
 const base=clamp(clamp(cfg[key],DEFAULTS[key])+finite(accuracy,0)-finite(evasion,0));
 return clamp(base+(1-base)*clamp(missReduction));
}
// A published ammunition chance wins over an unpublished generic fallback;
// explicit operator overrides remain intentional. Never infer extra rates.
function itemHitChance(kind,item,cfg={},bonuses={}){
 const key=kind+'HitChance';
 return hitChance(kind,Number.isFinite(item?.hitChance)&&!Number.isFinite(cfg[key])?{...cfg,[key]:item.hitChance}:cfg,bonuses);
}
module.exports={SOURCES,DEFAULTS,damageRange,laserDamage,hitChance,itemHitChance};
