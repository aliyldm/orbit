'use strict';
const NPC_TEMPLATE = require('./templates/npc-ship.json');
const { open } = require('./db');
const ammo = require('./ammo');
const maps = require('./maps');
const progression = require('./progression');
const balance=require('./combat-balance');
const cpu=require('./cpu');
const TICK_MS = 1000;
const LASER_INTERVAL_MS = 1000;
const rand = (a,b)=>a+Math.random()*(b-a);
function normalSpecial(){try{return require('./normal-npc-special');}catch(error){if(error.code==='MODULE_NOT_FOUND'&&error.message.includes("'./normal-npc-special'"))return{};throw error;}}
class Combat {
  constructor(world, send) {
    this.world=world;world.combat=this;this.send=send;this.cfg=world.config.combat||{};
    this.npcs=world.npcs;this.nextId=100000;this.timer=null;this.respawns=new Set();this.lastSave=0;
    this.projectiles=new Set();this.laserTimers=new Map();this.escortLaserTimers=new Map();
  }
  broadcast(cmd){this.world.broadcast(s=>this.send(s,cmd));}
  spawnAll(){
    const p=this.world.player;if(!p)return;
    this.map=maps.getMap(p.mapId);
    if(require('./galaxy-gates').evacuateUnadmitted(this.world))return;
    if(require('./galaxy-gates').spawnWave(this.world,this))return;
    const rows=require('./normal-map-content').spawnRows(open(),p.mapId);
    for(const row of rows)for(let i=0;i<row.count;i++)require('./normal-map-runtime').spawn(this,{...row.def,normalSpawnId:row.spawnId,normalSpawnSlot:i});
  }
  spawn(def,position=null){
    if(!this.world.player||!this.map||this.map.id!==this.world.player.mapId)return null;
    if(def.normalSpawnId!=null&&def.normalSpawnSlot!=null){const existing=[...this.npcs.values()].find(n=>n.def.normalSpawnId===def.normalSpawnId&&n.def.normalSpawnSlot===def.normalSpawnSlot);if(existing)return existing;}
    const normal=def.behavior&&!def.gateRunId&&!require('./galaxy-gates').isGateMap(this.map.id);
    let x=Number.isFinite(position?.x)?Math.max(200,Math.min(this.map.width-200,position.x)):rand(500,this.map.width-500),y=Number.isFinite(position?.y)?Math.max(200,Math.min(this.map.height-200,position.y)):rand(500,this.map.height-500);
    const npc={id:this.nextId++,def,x:Math.round(x),y:Math.round(y),patrolHome:{x:Math.round(x),y:Math.round(y)},hp:def.hitpoints,shield:def.shield,aggro:!normal&&def.aggressive&&!this.world.player.dead?[...this.world.sessions][0]||null:null,nextWander:Date.now()+rand(1000,4000),lastHit:0};
    this.npcs.set(npc.id,npc);this.broadcast(this.createCmd(npc));return npc;
  }
  createCmd(npc){this.updateNpc(npc);return {...NPC_TEMPLATE,userId:npc.id,typeId:String(npc.def.typeId),userName:npc.def.name,x:Math.round(npc.x),y:Math.round(npc.y)};}
  sendAll(session){for(const npc of this.npcs.values()){this.send(session,this.createCmd(npc));if(npc.cubikonOpen)this.send(session,require('./normal-npc-special').spawnEffect(npc,true));}}
  start(){
    if(this.timer||!this.world.player||!this.world.sessions.size)return;
    if(!this.npcs.size)this.spawnAll();
    this.lastSave=Date.now();
    this.timer=setInterval(()=>{try{this.tick();}catch(e){console.error('[combat] tick:',e);}},TICK_MS);this.timer.unref?.();
  }
  stop({clear=true}={}){
    for(const id of this.escortLaserTimers.keys())this.cancelEscortLaser(id);
    require('./hades-bosses').stop(this);
    require('./normal-map-runtime').save(this,Date.now(),{departing:true});
    require('./ship-abilities').stop(this.world);
    require('./npc-special-attacks').clearSlow(this.world);
    this.cancelProjectiles();
    for(const session of this.laserTimers.keys())this.cancelLaserTimer(session);
    require('./combat-utilities').stop(this.world);
    require('./hellstorm').stop(this.world);
    require('./advanced-weapons').stop(this.world);
    require('./techs').stop(this.world);
    if(this.timer)clearInterval(this.timer);this.timer=null;
    for(const t of this.respawns)clearTimeout(t);this.respawns.clear();this.normalRespawnTimers?.clear();
    for(const s of this.world.sessions){s.attacking=s.selected=null;}
    if(clear)this.npcs.clear();
  }
  reset(){this.stop();this.start();}
  select(session,targetId){
    if(!this.world.active(session)||session.player.dead||session.jumping)return false;
    const npc=this.npcs.get(targetId);if(!npc||npc.hp<=0)return false;
    session.selected=targetId;
    this.send(session,{_:'ShipSelectionCommand',userId:npc.id,shipType:Number(npc.def.typeId),shield:Math.round(npc.shield),shieldMax:npc.def.shield,hitpoints:Math.round(npc.hp),hitpointsMax:npc.def.hitpoints,nanoHull:0,maxNanoHull:0,shieldSkill:require('./shield-visuals').target(this.world,npc.id).bubble});return true;
  }
  attack(session,targetId){
    if(!this.world.active(session)||session.player.dead||session.jumping)return false;
    const npc=this.npcs.get(targetId);if(!npc||npc.hp<=0)return false;
    this.world.updatePosition();this.updateNpc(npc);
    if(maps.nearPeaceArea(this.world))return false;
    const range=require('./ship-abilities-expanded').laserRange(this.world,this.cfg.laserRange||600);
    if(maps.dist(npc,this.world.player)>range){this.send(session,{_:'AttackRangeExceededCommand',uid:npc.id,maxRange:range,type:0});return false;}
    session.attacking=targetId;this.world.player.repairing=false;
    // One real round produces animation, sound, ammo use and damage together.
    // Never emit a cosmetic starter round before the next combat timer tick.
    this.firePlayerLaser(session,Date.now());return true;
  }
  cancelLaserTimer(session){const entry=this.laserTimers.get(session);if(entry){clearTimeout(entry.timer);this.world.scheduled.delete(entry.timer);this.laserTimers.delete(session);}}
  cancelEscortLaser(id){const entry=this.escortLaserTimers.get(id);if(entry){clearTimeout(entry.timer);this.world.scheduled.delete(entry.timer);this.escortLaserTimers.delete(id);}}
  queueEscortLaser(npc,at){
    this.cancelEscortLaser(npc.id);
    at=Math.ceil(at);
    npc.nextLaserAt=at;
    const timer=this.world.schedule(()=>{
      this.escortLaserTimers.delete(npc.id);
      const mother=this.npcs.get(npc.def.normalMotherId);
      if(this.npcs.get(npc.id)!==npc||npc.hp<=0||!mother||mother.hp<=0||!npc.cubikonEscort)return;
      const now=Date.now();if(now<at){this.queueEscortLaser(npc,at);return;}if(now-at<LASER_INTERVAL_MS)this.fireEscortLaser(npc,now);
      // Never catch up missed rounds in a burst after an event-loop delay.
      const next=at+(Math.floor((now-at)/LASER_INTERVAL_MS)+1)*LASER_INTERVAL_MS;
      if(this.npcs.get(npc.id)===npc&&npc.hp>0)this.queueEscortLaser(npc,next);
    },Math.max(1,at-Date.now()));
    this.escortLaserTimers.set(npc.id,{timer,at});
  }
  fireEscortLaser(npc,now=Date.now()){
    const w=this.world,p=w.updatePosition(now),session=npc.aggro;
    if(!p||!session||!w.active(session)||p.dead||session.jumping||maps.nearPeaceArea(w)||now<(npc.nextLaserAt||0)||now<(npc.lastEscortLaserAt||0)+LASER_INTERVAL_MS)return false;
    this.updateNpc(npc,now);const rules=this.normalRules(npc);
    if(rules?.canAttack===false)return false;
    if(npc.petAggro&&w.petRuntime?.active&&maps.dist(npc,w.petRuntime)<=(rules?.attackRange??600)){const fired=require('./pet').damage(w,npc,Math.round(rand(npc.def.damageMin,npc.def.damageMax)),this,now);if(fired)npc.lastEscortLaserAt=now;return fired;}
    if(maps.dist(npc,p)>(rules?.attackRange??600))return false;
    npc.lastEscortLaserAt=now;npc.nextLaserAt=now+LASER_INTERVAL_MS;
    p.lastCombat=now;p.repairing=false;this.broadcast(this.laserRun(npc.id,p.userId));
    this.damagePlayer(npc,Math.round(rand(npc.def.damageMin,npc.def.damageMax)),{now});return true;
  }
  queuePlayerLaser(session,at){
    if(!session.attacking)return;
    const old=this.laserTimers.get(session);if(old&&old.at<=at)return;
    this.cancelLaserTimer(session);
    const timer=this.world.schedule(()=>{this.laserTimers.delete(session);this.firePlayerLaser(session,Date.now());},Math.max(1,at-Date.now()));
    this.laserTimers.set(session,{timer,at});
  }
  abort(session){this.cancelLaserTimer(session);if(!session.attacking)return;session.attacking=null;if(this.world.player)this.broadcast({_:'AttackAbortLaserCommand',uid:this.world.player.userId});}
  scheduleImpact(session,npc,resolve,{rounds=1,airstrike=false}={}){
    const w=this.world,p=w.player,mapId=p.mapId,epoch=w.epoch;
    const delay=require('./projectiles').flightMs(w,p,npc,rounds,airstrike);
    const shot={session,npc,player:p,mapId,epoch,delay,resolveAt:Date.now()+delay,timer:null};
    shot.timer=w.schedule(()=>{
      this.projectiles.delete(shot);
      if(w.epoch!==epoch||!w.active(session)||w.player!==p||p.dead||session.jumping||p.mapId!==mapId||this.npcs.get(npc.id)!==npc||npc.hp<=0)return;
      this.updateNpc(npc);resolve();
    },delay);
    this.projectiles.add(shot);return shot;
  }
  cancelProjectiles(){for(const shot of this.projectiles){clearTimeout(shot.timer);this.world.scheduled.delete(shot.timer);}this.projectiles.clear();}
  scheduleNpcImpact(session,npc,resolve,{rounds=1,airstrike=false}={}){
    const w=this.world,p=w.player,mapId=p.mapId,epoch=w.epoch;
    const delay=require('./projectiles').flightMs(w,npc,p,rounds,airstrike);
    const shot={session,npc,player:p,mapId,epoch,delay,resolveAt:Date.now()+delay,timer:null};
    shot.timer=w.schedule(()=>{
      this.projectiles.delete(shot);
      if(w.epoch!==epoch||!w.active(session)||w.player!==p||p.dead||session.jumping||p.mapId!==mapId||this.npcs.get(npc.id)!==npc||npc.hp<=0||maps.nearPeaceArea(w))return;
      resolve();
    },delay);
    this.projectiles.add(shot);return shot;
  }
  rocket(session,cmd){
    const w=this.world,p=w.updatePosition(),now=Date.now();
    if(!w.active(session)||p.dead||session.jumping||now<(p.nextRocket||0))return false;
    const npc=this.npcs.get(cmd.targetId),lootId=require('./automation').rocketAmmo(p);
    const rocket=require('./rocket-types')[lootId];
    if(!npc||npc.hp<=0||!rocket||maps.nearPeaceArea(w))return false;
    this.updateNpc(npc,now);
    if(maps.dist(p,npc)>rocket.range){this.send(session,{_:'AttackRangeExceededCommand',uid:npc.id,maxRange:rocket.range,type:1});return false;}
    if(this.npcProtected(npc)){this.missed(npc.id,0);return false;}
    // Update only a single inventory stack; failed/out-of-range/repeated requests consume nothing.
    const result=open().prepare('UPDATE items SET amount=amount-1 WHERE id=(SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id LIMIT 1) AND amount>0').run(p.userId,lootId);
    if(!result.changes)return false;
    const cooldown=Math.round((this.cfg.rocketCooldownMs??4000)*(p.stats.formation?.rocketCooldown??1)*(p.stats.droneDesigns?.rocketCooldown??1)*cpu.rocketCooldownMultiplier(p));
    p.nextRocket=now+cooldown;p.lastCombat=now;p.repairing=false;
    cpu.breakCloak(w);
    const dmg=Math.round(rocket.damage*(p.stats.rocketMultiplier??1)*require('./handlers/lab').consumeShot(p,1));
    const {hit,smokeId,isHeatSeeking}=require('./rocket-visuals').shot(p.userId,require('./techs').rocketChance(w,lootId,balance.hitChance('rocket',this.cfg,{accuracy:p.stats.rocketHitBonus||0}),now));
    this.broadcast({_:'LegacyModule',message:`0|v|${p.userId}|${npc.id}|${hit?'H':'M'}|${rocket.visual}|${smokeId}|${Number(isHeatSeeking)}`});
    this.scheduleImpact(session,npc,()=>{
      if(hit&&!this.npcProtected(npc)){this.applyDamage(npc,dmg,this.npcAbsorb(npc));npc.aggro=session;npc.lastHit=Date.now();this.hit(p.userId,npc.id,npc,dmg,0);if(npc.hp<=0)this.kill(session,npc);}
      else this.missed(npc.id,0);
    });
    this.send(session,{_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:4},maxTime:cooldown,time:cooldown});
    ammo.notify(p,{world:w,sendCmd:this.send});
    return true;
  }
  laserRun(attackerId,targetId){
    const p=this.world.player,hero=attackerId===p?.userId;
    // NPC color0 resolves through its native ship laserClassID, retaining the
    // Devolarium/Kristallon/Protegit patterns instead of forcing hero colors.
    return{_:'AttackLaserRunCommand',attackerId,targetId,laserColor:hero?require('./laser-visuals').ammoType(p.ammo):0,isDiminishedBySkillShield:require('./shield-visuals').target(this.world,targetId).impact,skilledLaser:hero?require('./skills').hasThickLasers(attackerId):false,visualType:0};
  }
  npcProtected(npc){return !!npc&&(!!npc.def?.invulnerable||!!require('./galaxy-gates').isProtected?.(this.world,npc)||!!normalSpecial().isProtected?.(this,npc));}
  npcAbsorb(npc){return Math.max(0,Math.min(1,npc.def?.shieldAbsorb??this.cfg.npcShieldAbsorb??.8));}
  applyDamage(target,dmg,absorb=target.def?this.npcAbsorb(target):0){if(target.def&&this.npcProtected(target))return 0;const toShield=Math.min(target.shield,Math.round(dmg*Math.max(0,Math.min(1,absorb||0))));target.shield-=toShield;require('./nano-hull').damageHull(target,dmg-toShield);return dmg;}
  applyLaserDamage(source,target,damage,lootId=source.ammo,absorb=this.npcAbsorb(target)){
    if(this.npcProtected(target))return 0;
    const bonus=source===this.world.player?require('./ship-abilities').shieldBonus(this.world,target):1;
    if(lootId==='ammunition_laser_sab-50'){
      const drained=Math.min(target.shield,Math.round(damage*bonus));target.shield-=drained;source.shield=Math.min(source.shieldMax??source.stats?.shieldMax??0,source.shield+drained);return drained;
    }
    if(lootId==='ammunition_laser_cbo-100'){
      const drained=Math.min(target.shield,Math.round(damage/3));target.shield-=drained;source.shield=Math.min(source.shieldMax??source.stats?.shieldMax??0,source.shield+drained);this.applyDamage(target,damage,absorb);return damage+drained;
    }
    const shield=target.shield;this.applyDamage(target,damage,absorb);const extra=Math.min(target.shield,Math.round((shield-target.shield)*(bonus-1)));target.shield-=extra;return damage+extra;
  }
  missed(victimId,type=1){this.broadcast({_:'AttackMissedCommand',attackType:{_:'AttackTypeModule',attackTypeValue:type},targetUserId:victimId,skillColorId:0});}
  rollHit(chance=1){return chance>=1||Math.random()<Math.max(0,chance);}
  hit(attackerId,victimId,victim,dmg,attackType=1,{strike=false}={}){this.broadcast({_:'AttackHitCommand',attackType:{_:'AttackTypeModule',attackTypeValue:attackType},attackerId,victimId,victimHitpoints:Math.round(victim.hp),victimShield:Math.round(victim.shield),victimNanoHull:Math.round(victim.nanoHull||0),damage:dmg,skilled:false,strike,cannonType:0});}
  playerDamage(p,npc=null,now=Date.now()){const damage=require('./modern-lasers').rollDamage(p,npc,now,{cfg:this.cfg,range:npc?maps.dist(npc,p):0,multiplier:require('./laser-ammo').multiplier(p,npc,now)*(p.stats.npcLaserMultiplier??1)});return require('./ship-abilities').outgoing(this.world,damage);}
  firePlayerLaser(session,now=Date.now()){
    const w=this.world,p=w.updatePosition(now),npc=session.attacking&&this.npcs.get(session.attacking);
    if(!npc||npc.hp<=0){this.abort(session);return false;}
    if(!w.active(session)||p.dead||session.jumping)return false;
    this.updateNpc(npc,now);
    const range=require('./ship-abilities-expanded').laserRange(w,this.cfg.laserRange||600,now);
    if(maps.nearPeaceArea(w)||maps.dist(npc,p)>range){
      if(!maps.nearPeaceArea(w))this.send(session,{_:'AttackRangeExceededCommand',uid:npc.id,maxRange:range,type:0});
      this.abort(session);return false;
    }
    if(!p.stats.laserCount)return false;
    if(p.ammo===ammo.RSB_AMMO&&now<(p.nextRsb||0))ammo.finishSalvo(p);
    const ready=p.nextLaserAt||0;
    if(now<ready){this.queuePlayerLaser(session,ready);return false;}
    if(this.npcProtected(npc)){p.nextLaserAt=now+LASER_INTERVAL_MS;this.queuePlayerLaser(session,p.nextLaserAt);this.missed(npc.id);return true;}
    if(p.ammo===ammo.RSB_AMMO&&ammo.count(p)<p.stats.laserCount)ammo.finishSalvo(p);
    if(!ammo.consume(p)&&!(ammo.finishSalvo(p)&&ammo.consume(p))){this.abort(session);return false;}
    p.nextLaserAt=now+LASER_INTERVAL_MS;p.lastCombat=now;cpu.breakCloak(w);
    if(p.ammo==='ammunition_laser_rsb-75'){
      const cooldown=this.cfg.rsbCooldownMs??3000;p.nextRsb=now+cooldown;
      this.send(session,{_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:10},maxTime:cooldown,time:cooldown});
    }
    try {
    const dmg=require('./hades-bosses').playerDamage(this,Math.round(this.playerDamage(p,npc,now)*require('./handlers/lab').consumeShot(p,0)),now);
    this.broadcast(this.laserRun(p.userId,npc.id));
    npc.aggro=session;npc.returning=false;
    if(!this.rollHit(cpu.aimChance(p,balance.hitChance('laser',this.cfg,{accuracy:(p.stats.skills?.laserAccuracy||0)+(p.stats.laserHitBonus||0)+(p.stats.droneDesigns?.laserEfficiency||0)})))){require('./laser-ammo').fired(p,false,now);this.missed(npc.id);return true;}
    require('./laser-ammo').fired(p,true,now);
    const before=npc.hp+npc.shield,applied=this.applyLaserDamage(p,npc,dmg,p.ammo,Math.max(0,this.npcAbsorb(npc)-(p.stats.shieldPenetration||0)));require('./techs').laserHit(w,Math.max(0,before-npc.hp-npc.shield),p.ammo,now);npc.lastHit=now;npc.aggro=session;
    if(applied>0){require('./modern-lasers').onHit(this,p,npc,now);this.hit(p.userId,npc.id,npc,applied,1,{strike:!!p.modernLaserState?.critical});}else this.missed(npc.id);
    if(['ammunition_laser_sab-50','ammunition_laser_cbo-100'].includes(p.ammo))this.send(session,{_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});
    if(npc.hp<=0)this.kill(session,npc);return true;
    } finally {
      ammo.finishSalvo(p);
      this.queuePlayerLaser(session,p.nextLaserAt);
    }
  }
  damagePlayer(npc,damage,{now=Date.now(),attackType=1,evade=true,cannonType=0}={}){
    const w=this.world,p=w.player;if(!p||p.dead||maps.nearPeaceArea(w))return 0;
    if(p.ultimateCloaked){this.missed(p.userId,attackType);return 0;}
    p.lastCombat=now;p.repairing=false;
    if(require('./respawn').protectedNow(w,now)||require('./combat-utilities').protectedNow(w,now)||(evade&&!this.rollHit(balance.hitChance('npc',this.cfg,{evasion:require('./ship-abilities-expanded').evasion(w,now)+(p.stats.moduleEvasion||0)+(p.stats.skills?.evasion||0)+(p.stats.formation?.evasion||0)+(p.stats.droneDesigns?.evasion||0)+(npc.k300mUntil>now?.05:0)+(attackType===1&&npc.pldUntil>now?.4:0)})))){this.missed(p.userId,attackType);return 0;}
    const state={get hp(){return p.hitPoints;},set hp(v){p.hitPoints=v;},get shield(){return p.shield;},set shield(v){p.shield=v;},get nanoHull(){return p.nanoHull||0;},set nanoHull(v){p.nanoHull=v;}};
    if(attackType===22)damage=require('./advanced-weapons').defenseDamage(damage,p.stats.driveDefense||0);
    if(attackType===21)damage=require('./advanced-weapons').defenseDamage(damage,p.stats.cannonDefense?.[['t','c','e'][cannonType]]||0);
    const converted=require('./ship-abilities-expanded').npcIncoming(w,this,npc,damage,now);
    const dealt=require('./ship-abilities').incoming(w,state,converted.damage,p.stats.shieldAbsorb,attackType,now);
    require('./techs').protect(w,state,now);
    require('./ship-abilities-expanded').afterNpcDamage(w,converted.heal,now);
    if(dealt>0)require('./pet-special').onOwnerHit(w,npc,now);
    this.hit(npc.id,p.userId,state,dealt,attackType);if(p.hitPoints<=0)this.killPlayer(npc);
    return dealt;
  }
  updateNpc(npc,now=Date.now()){
    const m=npc.movement;if(!m)return;
    const t=Math.max(0,Math.min(1,(now-m.start)/m.duration));npc.x=m.x+(m.targetX-m.x)*t;npc.y=m.y+(m.targetY-m.y)*t;if(t===1)npc.movement=null;
  }
  normalRules(npc){
    if(!npc.def.behavior||npc.def.gateRunId||require('./galaxy-gates').isGateMap(this.map?.id??this.world.player?.mapId))return null;
    return{aggression:'passive',acquisitionRadius:900,retainRadius:2500,attackRange:600,chaseDistance:450,roam:true,chase:true,canAttack:true,fleeAt:0,fleeToCorner:false,...npc.def.behavior};
  }
  stopNpc(npc,now=Date.now()){
    if(!npc.movement)return;this.updateNpc(npc,now);npc.movement=null;
    this.broadcast({_:'MoveCommand',userId:npc.id,x:Math.round(npc.x),y:Math.round(npc.y),timeToTarget:0});
  }
  dropNpcAggro(npc,now=Date.now(),stop=true){
    if(npc.aggro){npc.aggro=null;this.broadcast({_:'AttackAbortLaserCommand',uid:npc.id});}npc.petAggro=null;
    if(stop)this.stopNpc(npc,now);
  }
  normalAi(npc,rules,now){
    const w=this.world,p=w.player,peace=maps.nearPeaceArea(w),distance=maps.dist(npc,p);
    if(npc.returning){
      this.dropNpcAggro(npc,now,false);
      const home=npc.patrolHome||npc;
      if(maps.dist(npc,home)>2&&npc.def.speed>0){if(!npc.movement)this.moveNpc(npc,home.x,home.y,now);return true;}
      npc.returning=false;this.stopNpc(npc,now);npc.nextWander=now+1000;return true;
    }
    const escaping=rules.fleeToCorner&&rules.fleeAt>0&&npc.def.speed>0&&npc.hp>0&&npc.hp<=npc.def.hitpoints*rules.fleeAt&&(npc.lastHit>0||npc.aggro||npc.fleeing);
    if(escaping){
      if(!npc.fleeing){this.dropNpcAggro(npc,now);const inset=rules.cornerInset??500;const corners=[{x:inset,y:inset},{x:this.map.width-inset,y:inset},{x:inset,y:this.map.height-inset},{x:this.map.width-inset,y:this.map.height-inset}];npc.fleeing=corners.sort((a,b)=>maps.dist(npc,a)-maps.dist(npc,b))[0];}
      else this.dropNpcAggro(npc,now,false);
      if(maps.dist(npc,npc.fleeing)>1&&!npc.movement)this.moveNpc(npc,npc.fleeing.x,npc.fleeing.y,now);
      return true;
    }
    if(npc.fleeing){npc.fleeing=null;this.stopNpc(npc,now);}
    if(npc.aggro&&(!w.active(npc.aggro)||p.dead||npc.aggro.jumping||peace||distance>rules.retainRadius)){
      this.dropNpcAggro(npc,now);
      if(rules.roam!==false&&rules.chase!==false&&npc.def.speed>0&&maps.dist(npc,npc.patrolHome||npc)>2){npc.returning=true;this.moveNpc(npc,npc.patrolHome.x,npc.patrolHome.y,now);return true;}
    }
    if(!npc.aggro&&rules.aggression==='aggressive'&&distance<=rules.acquisitionRadius&&!p.dead&&!peace&&!cpu.isCloaked(p)){const candidate=[...w.sessions][0];if(candidate&&!candidate.jumping)npc.aggro=candidate;}
    if(!npc.aggro)npc.patrolHome={x:npc.x,y:npc.y};
    return false;
  }
  moveNpc(npc,x,y,now=Date.now()){
    if(!(npc.def.speed>0)){npc.movement=null;return false;}
    this.updateNpc(npc,now);x=Math.round(Math.min(this.map.width-200,Math.max(200,x)));y=Math.round(Math.min(this.map.height-200,Math.max(200,y)));
    const effectiveSpeed=npc.def.speed*(npc.slowUntil>now ? .5 : 1)*(npc.k300mUntil>now?.8:1)*(npc.dcrUntil>now?.7:1)*(npc.anchorlockUntil>now?npc.anchorlockFactor:1);
    const timeToTarget=Math.max(1,Math.round(Math.hypot(x-npc.x,y-npc.y)/Math.max(1,effectiveSpeed)*1000));
    npc.movement={x:npc.x,y:npc.y,targetX:x,targetY:y,start:now,duration:timeToTarget};
    this.broadcast({_:'MoveCommand',userId:npc.id,x,y,timeToTarget});
  }
  tick(now=Date.now()){
    const w=this.world,p=w.updatePosition(now);if(!p||!w.sessions.size)return this.stop();
    require('./boosters').tick(w,{now});
    require('./skylab').tick(w);
    require('./assembly').tick(w,this.send,now);
    require('./handlers/lab').refresh(w);
    for(const npc of this.npcs.values())this.updateNpc(npc,now);
    require('./modern-lasers').tick(w,this,now);
    normalSpecial().tick?.(this,now);
    require('./galaxy-gates').refreshProtection?.(w,this,now);
    require('./ship-abilities').tick(w,this,now);
    require('./combat-utilities').tick(w,this,now);
    require('./npc-special-attacks').tick(this,now);
    require('./advanced-weapons').tick(w,this,now);
    require('./techs').tick(w,this,now);
    cpu.tick(w,this,now);
    for(const session of w.sessions)this.firePlayerLaser(session,now);
    for(const npc of this.npcs.values()){
      if(npc.hp<=0)continue;
      const rules=this.normalRules(npc);
      if(rules&&this.normalAi(npc,rules,now)){
        if(now-npc.lastHit>10000)npc.shield=Math.min(npc.def.shield,npc.shield+Math.max(1,npc.def.shield*0.05));
        continue;
      }
      if(require('./hades-bosses').beforeAi(this,npc,now)||require('./npc-special-attacks').beforeAi(this,npc,now))continue;
      if(!rules&&npc.def.aggressive&&!npc.aggro&&!p.dead&&!maps.nearPeaceArea(w)&&!cpu.isCloaked(p)){const candidate=[...w.sessions][0];if(candidate&&!candidate.jumping)npc.aggro=candidate;}
      if(!rules&&npc.aggro&&(!w.active(npc.aggro)||p.dead||npc.aggro.jumping||maps.nearPeaceArea(w)||(!npc.def.aggressive&&maps.dist(npc,p)>2500))){
        npc.aggro=null;this.broadcast({_:'AttackAbortLaserCommand',uid:npc.id});
      }
      if(npc.aggro){
        const escortSteering=normalSpecial().steerEscort?.(this,npc,now);
        if(!escortSteering&&rules?.chase!==false&&maps.dist(npc,p)>(rules?.chaseDistance??450))this.moveNpc(npc,p.x+rand(-150,150),p.y+rand(-150,150),now);
        if(rules?.canAttack===false)continue;
        if(npc.cubikonEscort)continue; // Independent deadlines, not the1s AI batch.
        if(npc.petAggro&&this.world.petRuntime?.active&&maps.dist(npc,this.world.petRuntime)<=(rules?.attackRange??600)){require('./pet').damage(w,npc,Math.round(rand(npc.def.damageMin,npc.def.damageMax)),this,now);}
        else if(maps.dist(npc,p)<=(rules?.attackRange??600)&&now>=(npc.nextLaserAt||0)){
          npc.nextLaserAt=now+LASER_INTERVAL_MS;
          if(require('./npc-special-attacks').attack(this,npc,npc.aggro,now))continue;
          p.lastCombat=now;p.repairing=false;this.broadcast(this.laserRun(npc.id,p.userId));
          const dmg=this.damagePlayer(npc,require('./hades-bosses').outgoing(this,npc,Math.round(rand(npc.def.damageMin,npc.def.damageMax)),now),{now});
          if(dmg>0)require('./npc-special-attacks').onLaserHit(this,npc,now);
        }
      }else if(rules?.roam!==false&&now>=npc.nextWander){this.moveNpc(npc,npc.x+rand(-600,600),npc.y+rand(-600,600),now);npc.nextWander=now+rand(3000,8000);}
      if(!npc.aggro&&now-npc.lastHit>10000)npc.shield=Math.min(npc.def.shield,npc.shield+Math.max(1,npc.def.shield*0.05));
    }
    if(!p.dead&&now-(p.lastCombat||0)>10000){
      if(!p.ultimateCloaked&&p.shield<p.shieldMax){p.shield=Math.min(p.shieldMax,Math.round(p.shield+p.shieldMax*0.05*(p.stats.shieldRegenMultiplier??1)));this.broadcast({_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});}
      if(p.repairing&&!w.movement){p.hitPoints=Math.min(p.hitMax,p.hitPoints+Math.max(1,Math.round(p.hitMax*cpu.repairFraction(p)*(p.stats.skills?.repairMultiplier??1)*(p.stats.repairMultiplier??1))));this.broadcast(require('./nano-hull').command(p));if(p.hitPoints===p.hitMax)p.repairing=false;}
    }
    require('./drones').tick(p,cmd=>this.broadcast(cmd));
    require('./pet').tick(w,this,now);
    require('./hellstorm').tick(w,this,now);
    require('./shield-visuals').refresh(w,this.send);
    this.broadcast(maps.beacon(w));
    require('./quest-station').refresh(w,this.send);
    const trade=maps.tradeState(w),tradeSignature=p.mapId+':'+trade?.activatable;
    if(this.tradeSignature!==tradeSignature){this.tradeSignature=tradeSignature;if(trade)this.broadcast(trade);}
    for(const g of [...maps.portals(p.mapId,p.factionId),...require('./galaxy-gates').portalRows(w)]){
      const available=!p.dead&&!require('./galaxy-gates').entryRestriction(w,g.target_map)&&maps.dist(p,g)<=750;
      if(this.portalStates?.get(g.id)!==available){this.portalStates ||=new Map();this.portalStates.set(g.id,available);this.broadcast(maps.portalState(g,available));}
    }
    if(now-this.lastSave>=5000){require('./normal-map-runtime').save(this,now);w.save();this.lastSave=now;}
  }
  kill(session,npc,beforeDestroy){
    if(this.npcs.get(npc.id)!==npc||this.npcProtected(npc))return;
    if(npc.def.hadesDecoy)return this.destroyWithoutReward(npc);
    const gateKill=require('./galaxy-gates').onNpcKilled(this.world,npc,session);
    const duplicateGateKill=npc.def.gateRunId&&npc.gateKillRewardClaimed===false;
    // Save reward before announcing destruction; on persistence failure no reward is claimed.
    const skill=require('./skills').effects(this.world.player.userId),formation=this.world.player.stats.formation||{},baseReward=require('./npc-cargo').rewardOverride(npc.def,{player:this.world.player,mapId:this.map.id})||npc.def.reward;
    const reward={...baseReward,ep:Math.round((baseReward.ep||0)*(skill.npcEpMultiplier??1)*(formation.ep??1)),credits:Math.round((baseReward.credits||0)*(skill.npcCreditsMultiplier??1)),honour:Math.round((baseReward.honour||0)*(skill.honourMultiplier??1)*(formation.honour??1))};
    const runtime=require('./normal-map-runtime'),managed=runtime.managed(this,npc.def),pending=[];
    const claimed=runtime.claim(this,npc,()=>progression.grant(this.world,managed?(s,c)=>pending.push([s,c]):this.send,session,reward));
    for(const [s,c] of pending)this.send(s,c);
    if(claimed){require('./pet').awardExperience(this.world,reward.ep||0);require('./modern-lasers').onNpcKill(this.world.player);}
    beforeDestroy?.();require('./hades-bosses').cleanup(this,npc);
    const wasSelected=session.selected===npc.id,wasAttacking=session.attacking===npc.id;
    this.npcs.delete(npc.id);this.cancelEscortLaser(npc.id);
    if(wasSelected)session.selected=null;
    if(wasAttacking){session.attacking=null;this.cancelLaserTimer(session);}
    normalSpecial().onKilled?.(this,npc);
    if(!duplicateGateKill&&claimed){require('./drones').onNpcKill(this.world,npc);require('./ranks').recordNpcKill(open(),this.world.player.userId,npc);require('./ship-abilities-expanded').onNpcKill(this.world);}
    this.broadcast({_:'ShipDestroyedCommand',destroyedUserId:npc.id,explosionTypeId:0});if(wasSelected)this.send(session,{_:'ShipDeselectionCommand'});this.broadcast({_:'ShipRemoveCommand',userId:npc.id});if(wasAttacking)this.broadcast({_:'AttackAbortLaserCommand',uid:this.world.player.userId});
    if(!duplicateGateKill&&claimed){this.world.collectables?.cargo(npc);progression.event(session,{type:'npcKill',npcType:String(npc.def.typeId),npcKey:npc.def.key,mapId:this.world.player.mapId,amount:1});}
    if(gateKill)return;
    this.queueRespawn(npc,managed,claimed);
  }
  queueRespawn(npc,managed,claimed){
    const runtime=require('./normal-map-runtime');
    if(require('./galaxy-gates').isGateMap(this.world.player.mapId))return;
    if(npc.def.transient)return;
    if(managed){if(claimed)runtime.spawn(this,npc.def);return;}
    const epoch=this.world.epoch,mapId=this.map.id;
    const timer=setTimeout(()=>{this.respawns.delete(timer);if(this.timer&&epoch===this.world.epoch&&this.world.player?.mapId===mapId)this.spawn(npc.def);},npc.def.respawnMs);timer.unref?.();this.respawns.add(timer);
  }
  destroyWithoutReward(npc,{explosionTypeId=0,now=Date.now()}={}){
    if(this.npcs.get(npc.id)!==npc||this.npcProtected(npc))return false;
    const runtime=require('./normal-map-runtime'),managed=runtime.managed(this,npc.def),claimed=runtime.claim(this,npc,()=>{},now);
    this.npcs.delete(npc.id);this.cancelEscortLaser(npc.id);npc.hp=0;
    for(const session of this.world.sessions)if(session.selected===npc.id||session.attacking===npc.id){this.abort(session);session.selected=null;this.send(session,{_:'ShipDeselectionCommand'});}
    normalSpecial().onKilled?.(this,npc);
    if(claimed){
      if(explosionTypeId===6)this.broadcast({_:'LegacyModule',message:`0|n|BOOOM|${npc.id}`});
      this.broadcast({_:'ShipDestroyedCommand',destroyedUserId:npc.id,explosionTypeId});
    }
    this.broadcast({_:'ShipRemoveCommand',userId:npc.id});this.queueRespawn(npc,managed,claimed);return claimed;
  }
  killPlayer(killer){
    const w=this.world,p=w.player;if(p.dead)return;
    cpu.breakCloak(w);
    require('./advanced-weapons').stop(w);
    require('./techs').stop(w);
    p.hitPoints=0;p.nanoHull=0;p.dead=true;p.repairing=false;w.stopMovement();
    require('./respawn').recordDeath(w);
    require('./ranks').recordDeath(open(),p.userId);
    require('./shield-visuals').refresh(w,this.send);
    cpu.repairDrones(w);
    require('./drones').onPlayerDeath(w);
    this.cancelProjectiles();
    require('./ship-abilities').stop(w);
    require('./npc-special-attacks').clearSlow(w);
    require('./pet').stop(w);
    for(const s of w.sessions)this.abort(s);
    for(const npc of this.npcs.values()){npc.aggro=null;this.broadcast({_:'AttackAbortLaserCommand',uid:npc.id});}
    w.save();this.broadcast({_:'ShipDestroyedCommand',destroyedUserId:p.userId,explosionTypeId:0});
    require('./galaxy-gates').onPlayerDeath(w);
    this.broadcast(require('./gameplay').deathCommand(w,killer.def.name));
  }
}
module.exports=Combat;
