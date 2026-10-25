'use strict';
// Source constants and explicit solo composition policy: docs/modern-equipment-local.md.
const META=require('../docs/client-map.items.json').items;
const PREFIX='equipment_weapon_laser_';
const MORTIFIER=[0,0,0,.10,.20,.28,.32,.36,.40,.42,.44,.46,.48,.49,.50];
const FERVOR=[0,.05,.26,.48,.71,.95];
const ANCHORLOCK=[0,.03,.05,.05,.08,.10,.12,.12,.12,.15,.15,.15,.20,.20,.20,.20,.22,.24,.25];
function upgraded(item,property='damage'){
 const rule=META[item.loot_id]?.upgradable,base=item[property]??META[item.loot_id]?.[property]??0;
 return base*(1+(item.upgrade_level||0)*(rule?.bonusPerLevel||0)/100);
}
function profile(lasers){return lasers.map(i=>({id:i.id,lootId:i.loot_id,ship:i.drone_id==null,damage:upgraded(i)}));}
function hpBonus(lasers){return lasers.reduce((n,i)=>n+(META[i.loot_id]?.equipable?.boostList||[]).filter(b=>b.type==='HITPOINTS').reduce((n,b)=>n+b.factor/100,0),0);}
function state(p,now){const s=p.modernLaserState||={charged:{},fervor:0,fervorUntil:0};if(s.fervorUntil<=now){s.fervor=0;s.fervorUntil=0;}return s;}
function onNpcKill(p,now=Date.now()){
 if(!(p.stats.laserProfiles||[]).some(i=>i.ship&&i.lootId===PREFIX+'am-l'))return;
 const s=state(p,now);s.fervor=Math.min(5,s.fervor+1);s.fervorUntil=(s.fervorUntil||now)+(s.fervor===1?20000:10000);
}
function reset(p){delete p.modernLaserState;}
function isBlacklight(npc){return /^(?:impulse|impluse|attend|invoke|mindfire)(?:[-_ ]|$)/i.test(npc?.def?.key||'')||/Impulse II|Attend IX|Invoke XVI|Mindfire Behemoth/i.test(npc?.def?.name||'');}
function maxDamage(p,npc,now=Date.now(),{fire=false,random=Math.random,range=0,normalFactor=1,unstableVariance=false}={}){
 const list=p.stats.laserProfiles;if(!list?.length)return p.stats.laserDamage*normalFactor;
 const total=list.reduce((n,i)=>n+i.damage,0),scale=total?p.stats.laserDamage/Math.round(total):1,s=state(p,now);
 const shipCount=id=>list.filter(i=>i.ship&&i.lootId===PREFIX+id).length,os=shipCount('os-l'),am=shipCount('am-l'),mf=shipCount('lf-5-mf');
 let sum=0,extra=0;if(fire)s.critical=false;
 for(const i of list){
  const id=i.lootId.slice(PREFIX.length);if(/^sl-0[123]$/.test(id)&&range>450)continue;
  let damage=i.damage;
  const unstable=id==='lf-4-unstable';
  if(unstable&&unstableVariance)damage*= (128+92*Math.max(0,Math.min(1,random())))/220;
  if(id==='lf-3')damage+=15;
  if(id==='sll-01')damage+=45;if(id==='sll-02')damage+=55;if(id==='sll-03')damage+=45;
  if(id==='lf-4-pd')damage+=5;
  if(id==='caucasus')damage*=1.15;
  if(id==='pr-l'&&isBlacklight(npc))damage*=3.5;
  // Set bonuses apply to these ship-mounted lasers, never drone/PET weapons.
  if(i.ship&&id==='lf-5-mf')damage*=1+MORTIFIER[Math.min(mf,14)];
  if(i.ship&&id==='am-l')damage*=1+(am>=3?.25:0)+FERVOR[s.fervor];
  if(i.ship&&id==='os-l'&&fire&&random()<Math.min(.5,os*.03+(os>=3?.09:0))){extra+=i.damage;s.critical=true;}
  const scatter=({'pr-l':200,caucasus:100,'sl-01':38,'sl-02':75,'sl-03':150})[id];
  if(scatter){
   const key=String(i.id??i.lootId),ready=s.charged[key]??now+5000;
   if(fire){if(now>=ready){extra+=scatter;s.charged[key]=now+5000;}else s.charged[key]=ready;}
  }
  sum+=damage*(unstable&&unstableVariance?1:normalFactor);
 }
 // Critical/scatter increments don't multiply booster gains; ammo still applies.
 return sum*scale+extra*normalFactor;
}
function rollDamage(p,npc,now=Date.now(),{cfg={},random=Math.random,multiplier=1,...options}={}){
 const [low,high]=require('./combat-balance').damageRange(cfg),normalFactor=low+(high-low)*Math.max(0,Math.min(1,random()));
 return Math.max(0,Math.round(maxDamage(p,npc,now,{...options,fire:true,normalFactor,unstableVariance:true,random})*multiplier));
}
function anchorlock(count){return count>=15?{chance:.25,factor:.45,duration:2000}:count>=10?{chance:.20,factor:.8,duration:2000}:count>=3?{chance:.10,factor:.85,duration:1000}:null;}
function onHit(combat,p,npc,now=Date.now(),random=Math.random){
 if(npc.hp<=0)return false;
 const count=(p.stats.laserProfiles||[]).filter(i=>i.ship&&i.lootId===PREFIX+'lf-5-al').length,effect=anchorlock(count);
 if(!effect||random()>=effect.chance)return false;
 const movement=npc.movement;npc.anchorlockUntil=now+effect.duration;npc.anchorlockFactor=effect.factor;
 if(movement)combat.moveNpc(npc,movement.targetX,movement.targetY,now);return true;
}
function tick(world,combat,now=Date.now()){
 for(const npc of combat.npcs.values())if(npc.anchorlockUntil&&npc.anchorlockUntil<=now){delete npc.anchorlockUntil;delete npc.anchorlockFactor;const m=npc.movement;if(m)combat.moveNpc(npc,m.targetX,m.targetY,now);}
}
function details(lootId){
 const m=META[lootId];if(!lootId.startsWith(PREFIX)||!m)return null;
 const id=lootId.slice(PREFIX.length),base=m.damage,common=`Taban hasar: ${base}.`,ship='Yetenek/set bonusu yalnız gemi yuvalarında çalışır; diroit ve P.E.T. üzerinde taban hasar verir.';
 const rules={
  'os-l':`${common} Her gemi lazeri kritik şansına %3 ekler; 3 lazerden itibaren ayrıca %9. En fazla %50 kritik şansı. Kritik vuruş bu lazerin temel hasarını ikiye katlar. ${ship}`,
  'lf-5-mf':`${common} Gemide 3/4/5/6/7/8/9/10/11/12/13/14 adet için kendi lazer hasarı bonusu sırasıyla %10/20/28/32/36/40/42/44/46/48/49/50; 14 üstünde %50 kalır. ${ship}`,
  'lf-5-al':`${common} Gemideki adede göre yalnız PvP hasarı +%3 ile +%25; NPC hasarını artırmaz. En az 3/10/15 lazer: her isabette %10/20/25 ihtimalle hedefi %15/20/55 yavaşlatır; süre 1/2/2 saniye. ${ship}`,
  'pr-l':`${common} Beş saniyede bir +200 ek hasar. Impulse II, Attend IX, Invoke XVI ve Mindfire Behemoth hedeflerinde taban hasar ×3,5. Diğer NPC’lerde bu Black Light çarpanı uygulanmaz.`,
  'am-l':`${common} NPC imhası bu lazerin NPC hasarını artırır. 1–5 yığında toplam +%5/26/48/71/95; ilk yığın 20 saniye, sonraki imhalar süreye 10 saniye ekler. En az 3 gemi lazerinde ayrıca +%25. Süre dolunca, harita değişiminde ve ölümde sıfırlanır. ${ship}`,
  'lf-4-unstable':'Her atışın taban hasarı 128–220 arasında değişir. Genel lazerin %75–100 aralığından ayrı hesaplanır.',
  'lf-4-hp':`${common} Takılı her lazer geminin temel darbe puanını %0,5 artırır.`,
  'lf-4-md':`${common} Oyunculara karşı +5 ek hasar; NPC’lere bu PvP bonusu uygulanmaz.`,
  'lf-4-pd':`${common} NPC’lere karşı +5 ek hasar.`,
  'lf-4':`${common} Standart LF-4; özel set bonusu yoktur.`,
  'lf-5':`${common} Her yükseltme kademesi +%0,5 lazer hasarı verir.`
 };
 const names={'os-l':'Odysseus Lazeri','pr-l':'Prometheus Lazeri','am-l':'Asmodeus Lazeri','lf-5-mf':'LF-5 Mortifer','lf-5-al':'LF-5 Anchorlock','lf-4-unstable':'Kararsız LF-4','lf-4-hp':'LF-4 Hyperplasmoid','lf-4-md':'LF-4 Magmadrill','lf-4-pd':'LF-4 Paritydrill'};
 return {name:names[id]||m.typeValue,text:rules[id]||common,baseDamage:base};
}
function describeBundle(contents){
 const rows=Object.keys(contents?.items||{}).map(id=>[id,details(id)]).filter(([,d])=>d);
 return rows.length?'<br /><br />'+rows.map(([id,d])=>`<b data-laser-effect="${id}">${d.name}</b><br />${d.text}`).join('<br /><br />'):'';
}
module.exports={upgraded,profile,hpBonus,state,onNpcKill,reset,maxDamage,rollDamage,anchorlock,onHit,tick,details,describeBundle,MORTIFIER,FERVOR,ANCHORLOCK};
