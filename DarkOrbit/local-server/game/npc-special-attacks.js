'use strict';
// Mechanisms: official Spanish NPC FAQ. Numeric defaults below are LOCAL policy.
// Only the three proven base pirates opt in; Uber/gate variants are unchanged.
const maps=require('./maps'),speed=require('./player-speed');
function config(combat,name){return combat.world.config.normalNpcs?.[name]||{};}
function enabled(combat,npc,key){return npc.def.key===key&&!!combat.normalRules(npc);}
function slowEffect(combat,on){combat.broadcast({_:'LegacyModule',message:`0|n|fx|${on?'start':'end'}|SABOTEUR_DEBUFF|${combat.world.player.userId}`});}
function clearSlow(world,now=Date.now()){
  const p=world.player;if(!p?.npcSlow)return false;
  p.npcSlow=null;speed.set(world,'npcSlow',1,now);
  if(world.combat)slowEffect(world.combat,false);
  return true;
}
function onLaserHit(combat,npc,now=Date.now()){
  const w=combat.world,p=w.player;if(!enabled(combat,npc,'saboteur')||p.dead)return;
  const cfg=config(combat,'saboteur'),first=!p.npcSlow;
  p.npcSlow={until:now+(cfg.durationMs??5000),sourceId:npc.id};
  speed.set(w,'npcSlow',Math.max(.01,Math.min(1,cfg.speedMultiplier??.3)),now);
  if(first)slowEffect(combat,true);
}
function tick(combat,now=Date.now()){
  const p=combat.world.player;if(p?.npcSlow&&(p.dead||now>=p.npcSlow.until))clearSlow(combat.world,now);
}
function beforeAi(combat,npc,now=Date.now()){
  if(!enabled(combat,npc,'barracuda'))return false;
  const cfg=config(combat,'barracuda'),p=combat.world.player;
  if(!npc.selfDestructAt&&npc.hp>0&&npc.hp<=npc.def.hitpoints*(cfg.triggerHullFraction??.1)){
    npc.selfDestructAt=now+(cfg.fuseMs??10000);
    try{require('./normal-map-runtime').save(combat,now);}catch(error){npc.selfDestructAt=0;throw error;}
  }
  if(!npc.selfDestructAt)return false;
  if(!npc.kamikazeAnnounced){npc.kamikazeAnnounced=true;combat.broadcast({_:'LegacyModule',message:`0|n|fx|start|KAM|${npc.id}`});}
  const session=[...combat.world.sessions].find(s=>combat.world.active(s)&&!s.jumping);
  const canHit=session&&!p.dead&&!maps.nearPeaceArea(combat.world);
  const distance=maps.dist(npc,p);
  if(now<npc.selfDestructAt&&!(canHit&&distance<=(cfg.contactRadius??150)))return false;
  // Commit retirement before damage/visuals. A failed DB write cannot explode
  // the same population generation twice or turn self-destruction into loot.
  if(combat.destroyWithoutReward(npc,{explosionTypeId:6,now})&&canHit&&distance<=(cfg.blastRadius??500)){
    combat.damagePlayer(npc,Math.round(p.hitMax*(cfg.damageHullFraction??.2)),{now,attackType:2,evade:false});
  }
  return true;
}
function attack(combat,npc,session,now=Date.now()){
  if(!enabled(combat,npc,'annihilator'))return false;
  const p=combat.world.player;
  if(!combat.world.active(session)||p.dead||session.jumping||maps.nearPeaceArea(combat.world))return true;
  if(now<(npc.nextHellstorm||0))return true;
  const cfg=config(combat,'annihilator'),rounds=Math.max(1,Math.min(5,Math.round(cfg.rounds??5)));
  npc.nextHellstorm=now+Math.max(1000,cfg.cooldownMs??5000);
  const hit=combat.rollHit((combat.cfg.npcHitChance??1)-require('./ship-abilities-expanded').evasion(combat.world,now)-(p.stats.moduleEvasion||0)-(p.stats.skills?.evasion||0)-(p.stats.formation?.evasion||0)-(p.stats.droneDesigns?.evasion||0));
  const damage=Math.round(npc.def.damageMin+Math.random()*(npc.def.damageMax-npc.def.damageMin));
  p.lastCombat=now;p.repairing=false;
  combat.broadcast({_:'HellstormAttackCommand',attackerId:npc.id,targetId:p.userId,hit,currentLoad:rounds,rocketType:{_:'AmmunitionTypeModule',typeValue:21}});
  combat.scheduleNpcImpact(session,npc,()=>{
    if(hit)combat.damagePlayer(npc,damage,{attackType:0,evade:false});else combat.missed(p.userId,0);
  },{rounds,airstrike:true});
  return true;
}
module.exports={tick,onLaserHit,clearSlow,beforeAi,attack};
