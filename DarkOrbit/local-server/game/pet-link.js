'use strict';
// G-HPL1: official Galactic Strife 11/2019 FAQ, native ItemDataProvider.
// Shield damage is resolved first; redirected damage consumes PET hull only.
const pet=()=>require('./pet'),special=()=>require('./pet-special');
const TYPE=16,VISUAL=86;
function visual(w,on){pet().send(w,{_:'VisualModifierCommand',userId:pet().petId(w.player.userId),modifier:VISUAL,attribute:w.player.userId,additionalAttribute:'',count:1,activated:on});}
function current(w,now=Date.now()){
 const r=w.petRuntime,link=r?.hpLink;
 return r?.active&&link&&link.until>now&&link.shipId===w.player.shipId&&link.mapId===w.player.mapId&&r.gear===TYPE&&r.hitpoints>0?link:null;
}
function end(w,now=Date.now()){
 const r=w.petRuntime,link=r?.hpLink;if(!link)return false;
 // Reserve the full lifetime + cooldown at activation. End it explicitly so
 // docking, death, changing config or reconnecting cannot bypass the cooldown.
 special().setCooldown(w,TYPE,link.cooldownMs,now);delete r.hpLink;visual(w,false);return true;
}
function start(w,g,now=Date.now()){
 const r=w.petRuntime;if(!r?.active||r.hitpoints<=0||r.hpLink||special().cooldown(w.player.userId,TYPE,now))return false;
 special().setCooldown(w,TYPE,g.durationMs+g.cooldownMs,now);
 r.hpLink={until:now+g.durationMs,cooldownMs:g.cooldownMs,shipId:w.player.shipId,mapId:w.player.mapId,damageMultiplier:1+(g.values.damage_increase||0)/100};
 visual(w,true);return true;
}
function tick(w,now=Date.now()){
 if(!w.petRuntime?.hpLink||current(w,now))return false;
 end(w,now);if(w.petRuntime?.gear===TYPE)pet().selectGear(w,2);return true;
}
function redirect(w,amount,now=Date.now()){
 if(!Number.isFinite(amount)||amount<=0)return 0;
 tick(w,now);if(!current(w,now))return 0;
 const r=w.petRuntime,absorbed=Math.min(r.hitpoints,Math.round(amount));r.hitpoints-=absorbed;r.lastCombat=now;
 pet().send(w,{_:'PetHitpointsUpdateCommand',hitpointsNow:r.hitpoints,hitpointsMax:r.stats.hitMax,useRepairGear:false});
 pet().save(w);
 if(r.hitpoints<=0){end(w,now);special().destroy(w);}
 return absorbed;
}
function damageMultiplier(w,now=Date.now()){return current(w,now)?.damageMultiplier||1;}
function sync(w){if(current(w))visual(w,true);}
module.exports={TYPE,VISUAL,current,start,end,tick,redirect,damageMultiplier,sync};
