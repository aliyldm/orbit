'use strict';
const {open,tx}=require('./db'),maps=require('./maps');
const npcIds=require('./quests-npc-ids.json').visualToNpcId;
const EFFECT={8:3,10:5,11:6,16:9};
const pet=()=>require('./pet');
const send=(w,c)=>pet().send(w,c);
function cooldown(playerId,type,now=Date.now()){return Math.max(0,(open().prepare('SELECT cooldown_until FROM pet_gear_state WHERE player_id=? AND gear_type=?').get(playerId,type)?.cooldown_until||0)-now);}
function setCooldown(w,type,milliseconds,now=Date.now()){
 open().prepare('INSERT INTO pet_gear_state(player_id,gear_type,cooldown_until)VALUES(?,?,?) ON CONFLICT(player_id,gear_type)DO UPDATE SET cooldown_until=excluded.cooldown_until').run(w.player.userId,type,now+milliseconds);
 buff(w,type,milliseconds);
}
function buff(w,type,ms){if(EFFECT[type])send(w,{_:'PetBuffCommand',effectAction:0,effectId:EFFECT[type],addingParameters:[Math.ceil(ms/1000)]});}
function cooldownCommands(playerId,now=Date.now()){
 return open().prepare('SELECT * FROM pet_gear_state WHERE player_id=? AND cooldown_until>?').all(playerId,now).filter(r=>EFFECT[r.gear_type]).map(r=>({_:'PetBuffCommand',effectAction:0,effectId:EFFECT[r.gear_type],addingParameters:[Math.ceil((r.cooldown_until-now)/1000)]}));
}
function targets(w,type){
 if(type===6)return [...new Set([...w.npcs.values()].filter(n=>n.hp>0).map(n=>npcIds[n.def.typeId]).filter(Number.isInteger))].sort((a,b)=>a-b).slice(0,127);
 return [...new Set([...(w.collectables?.boxes.values()||[])].filter(b=>b.oreType!==undefined).map(b=>b.oreType))].sort((a,b)=>a-b);
}
function activate(w,type,optParam,now=Date.now()){
 const r=w.petRuntime,g=pet().stats(w.player)?.gears.find(g=>g.type===type);
 if(type>2&&!g)return false;
 if([8,11,16].includes(type)&&!r?.active)return false;
 // An absent trading PET cannot be recovered early by choosing another mode.
 if(cooldown(w.player.userId,8,now)&&r?.tradeIdle)return false;
 if(cooldown(w.player.userId,type,now)){buff(w,type,cooldown(w.player.userId,type,now));return false;}
 if(type===16&&!require('./pet-link').start(w,g,now))return false;
 if(r?.gear===16&&type!==16)require('./pet-link').end(w,now);
 if([6,7].includes(type)){
  const values=targets(w,type);
  // The first native click sends int("") == 0 before its submenu exists.
  // Resource 0 remains a real selectable target when present.
  const selected=optParam===0&&!values.includes(0)?undefined:optParam;
  if(selected!==undefined&&selected!==null&&(!Number.isInteger(selected)||!values.includes(selected)))return false;
  if(r){r.locatorTarget=selected??values[0]??null;r.locatorType=type;}
  send(w,{_:'PetLocatorGearInitializationCommand',locatorType:{_:'PetGearTypeModule',typeValue:type},possibleTargetValues:values});
 }
 if(r&&type===11){
  if(w.player.hitPoints>=w.player.hitMax||r.fuel<g.fuelUsage)return false;
  tx(db=>{if(!db.prepare('UPDATE pets SET fuel=fuel-? WHERE player_id=? AND fuel>=?').run(g.fuelUsage,w.player.userId,g.fuelUsage).changes)throw new Error('P.E.T. yakıtı yetersiz.');setCooldown(w,11,g.cooldownMs,now);});
  r.fuel=pet().owned(w.player.userId).fuel;r.shipRepairUntil=now+g.durationMs;r.shipRepairLast=now;
  send(w,{_:'PetFuelUpdateCommand',petFuelNow:r.fuel,petFuelMax:pet().MAX_FUEL});
  send(w,{_:'LegacyModule',message:`0|n|HEAL_RAY|${pet().petId(w.player.userId)}|${w.player.userId}`});
 }
 if(type===8){const info=require('./collectables').tradeInfo(w);info.type=3;for(const k of Object.keys(info))if(k.endsWith('Price'))info[k]=Math.round(info[k]*(1+g.tradeBonus));send(w,info);send(w,{_:'PetTradeWindowShowCommand'});}
 if(r&&r.gear!==type){delete r.kamikaze;delete r.shipRepairUntil;if(type===11)r.shipRepairUntil=now+g.durationMs;}
 return true;
}
function onOwnerHit(w,npc,now=Date.now()){
 const r=w.petRuntime;if(!r?.active)return;
 if(r.gear===11){delete r.shipRepairUntil;pet().selectGear(w,r.stats.gears.some(g=>g.type===12)?12:2);}
 arm(w,npc,now);
}
function arm(w,npc,now=Date.now()){
 const r=w.petRuntime,p=w.player,g=r?.stats.gears.find(g=>g.type===10);
 if(!r?.active||r.gear!==10||r.kamikaze||!g||cooldown(p.userId,10,now)||maps.nearPeaceArea(w)||!npc||w.npcs.get(npc.id)!==npc||w.combat.npcProtected(npc))return false;
 if(r.hitpoints>r.stats.hitMax*g.petHpThreshold&&p.hitPoints>p.hitMax*g.playerHpThreshold)return false;
 r.kamikaze={targetId:npc.id,target:npc,detonateAt:now+g.survivalMs,mapId:p.mapId};
 send(w,{_:'LegacyModule',message:`0|n|fx|start|KAM|${pet().petId(p.userId)}`});return true;
}
function destroy(w,kind=0){
 const r=w.petRuntime;if(!r)return;r.hitpoints=0;
 send(w,{_:'LegacyModule',message:`0|n|BOOOM|${pet().petId(w.player.userId)}`});
 send(w,{_:'ShipDestroyedCommand',destroyedUserId:pet().petId(w.player.userId),explosionTypeId:kind===1?6:0});
 send(w,{_:'PetIsDestroyedCommand',destroyedType:kind});pet().stop(w);
 send(w,{_:'PetUIRepairButtonCommand',enabled:true,repairCosts:pet().repairCost(w)});
 for(const n of w.npcs.values())if(n.petAggro===pet().petId(w.player.userId)){n.petAggro=null;n.aggro=null;}
}
function tick(w,combat,elapsed,now){
 const r=w.petRuntime,p=w.player,g=r.stats.gears.find(g=>g.type===r.gear),session=[...w.sessions].find(s=>w.active(s));
 if(!session||session.jumping)return false;
 if(r.tradeIdle){if(cooldown(p.userId,8,now))return true;r.tradeIdle=false;send(w,{_:'PetIdleModeCommand',petId:pet().petId(p.userId),isIdle:false});pet().selectGear(w,1);}
 if([6,7].includes(r.gear)){
  const range=g.range*r.stats.effects.radarMultiplier;
  const rows=r.gear===6?[...combat.npcs.values()].filter(n=>n.hp>0&&npcIds[n.def.typeId]===r.locatorTarget):[...(w.collectables?.boxes.values()||[])].filter(b=>b.oreType===r.locatorTarget&&(!b.expires||b.expires>=now));
  const target=rows.filter(t=>maps.dist(p,t)<=range).sort((a,b)=>maps.dist(p,a)-maps.dist(p,b))[0];
  send(w,{_:'PetGearLocatorUpdate',x:target?Math.round(target.x):-1,y:target?Math.round(target.y):-1});
 }
 if(r.gear===11&&r.shipRepairUntil){
  const seconds=Math.max(0,(Math.min(now,r.shipRepairUntil)-(r.shipRepairLast??now-elapsed*1000))/1000);r.shipRepairLast=now;
  const before=p.hitPoints;p.hitPoints=Math.min(p.hitMax,p.hitPoints+Math.round(g.repair*seconds));
  if(p.hitPoints>before){combat.hit(pet().petId(p.userId),p.userId,{hp:p.hitPoints,shield:p.shield,nanoHull:p.nanoHull||0},p.hitPoints-before,10);send(w,require('./nano-hull').command(p));w.save();}
  if(p.hitPoints>=p.hitMax||now>=r.shipRepairUntil){delete r.shipRepairUntil;pet().selectGear(w,r.stats.gears.some(g=>g.type===12)?12:2);}return true;
 }
 if(r.gear===10){
  if(!r.kamikaze){const n=[...combat.npcs.values()].find(n=>n.aggro===session);arm(w,n,now);}
  if(r.kamikaze){const n=combat.npcs.get(r.kamikaze.targetId);if(r.kamikaze.mapId!==p.mapId||!n||n!==r.kamikaze.target||n.hp<=0||maps.nearPeaceArea(w)){delete r.kamikaze;return false;}
   pet().movePet(w,r,n,elapsed*(1+g.speedBonus));
   if(now>=r.kamikaze.detonateAt){
    setCooldown(w,10,g.cooldownMs,now);
    // Local bounded blast policy: full max damage inside the embedded client radius.
    // Source does not establish the original falloff formula.
    for(const target of [...combat.npcs.values()]){combat.updateNpc(target,now);if(target.hp<=0||combat.npcProtected(target)||maps.dist(r,target)>g.radius)continue;combat.applyDamage(target,g.damage,combat.npcAbsorb(target));target.lastHit=now;target.aggro=session;combat.hit(pet().petId(p.userId),target.id,target,g.damage,0);if(target.hp<=0)combat.kill(session,target);}
    destroy(w,1);
   }return true;
  }
 }
 return false;
}
function sell(session,cmd,sendCmd){
 const w=session.world,p=w.updatePosition(),r=w.petRuntime,gear=r?.stats.gears.find(g=>g.type===8),type=cmd.toSell?.oreType?.typeValue,amount=cmd.toSell?.count,prices=require('./collectables').PRICES;
 if(!w.active(session)||p.dead||session.jumping||!r?.active||r.gear!==8||!gear||cooldown(p.userId,8)||!prices[type]||!Number.isSafeInteger(amount)||amount<=0)return false;
 const credits=Math.round(amount*prices[type]*(1+gear.tradeBonus));if(!Number.isSafeInteger(credits)||p.credits+credits>Number.MAX_SAFE_INTEGER)return false;
 tx(db=>{if(!db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=? AND amount>=?').run(amount,p.userId,type,amount).changes)throw new Error('Yetersiz cevher.');db.prepare('UPDATE players SET credits=? WHERE id=?').run(p.credits+credits,p.userId);db.prepare('INSERT INTO pet_gear_state(player_id,gear_type,cooldown_until)VALUES(?,8,?) ON CONFLICT(player_id,gear_type)DO UPDATE SET cooldown_until=excluded.cooldown_until').run(p.userId,Date.now()+gear.absentMs);});
 p.credits+=credits;r.tradeIdle=true;for(const n of w.npcs?.values()||[])if(n.petAggro===pet().petId(p.userId))n.petAggro=null;buff(w,8,gear.absentMs);send(w,{_:'PetIdleModeCommand',petId:pet().petId(p.userId),isIdle:true});
 for(const c of require('./collectables').resourceCommands(p))sendCmd(session,c);sendCmd(session,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});require('./progression').event(session,{type:'sellOre',match:String(type+1),amount});return true;
}
module.exports={cooldown,setCooldown,cooldownCommands,targets,activate,onOwnerHit,arm,destroy,tick,sell};
