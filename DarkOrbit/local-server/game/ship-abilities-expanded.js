'use strict';
// Shipped per-hull durations/parameters, official Plus effects. Solo consumers;
// group-only abilities are intentionally not advertised by this module.
const {open,tx}=require('./db'),maps=require('./maps'),DATA=require('./data/ship-abilities.json').ships;
const KEY='game.expandedShipCooldowns';
const TOGGLE_KEY='game.shipAbilityToggles';
const nativeTemplates=new Map();
(function walk(v){if(!v||typeof v!=='object')return;if(v._==='MenuItemStatusCommand'&&v.menuItemId?.startsWith('ability_'))nativeTemplates.set(v.menuItemId,v);for(const value of Object.values(v))if(value&&typeof value==='object')walk(value);})(require('./templates/init.json'));
const SPECS={
 HEALING_BEAM:{menu:'ability_aegis_hp-repair',kind:'hp',id:101,group:26,param:1},
 SHIELD_RECHARGE:{menu:'ability_aegis_shield-repair',kind:'shield',id:104,group:28,param:1},
 HEALING_POD:{menu:'ability_aegis_repair-pod',kind:'pod',id:105,group:29,param:0},
 SELF_REPAIR:{menu:'ability_liberator-plus_self-repair',kind:'hp',param:0},
 INSTANT_HEAL_PLUS:{menu:'ability_solace-plus_nano-cluster-repairer-plus',kind:'instant',id:140,group:36,fraction:.5},
 INCINERATE:{menu:'ability_solaris_inc',kind:'burn',visual:87,radius:600,param:0,endCooldown:true},
 INCINERATE_PLUS:{menu:'ability_solaris-plus_incinerate-plus',kind:'burn',visual:87,radius:600,param:0,endCooldown:true},
 PRISMATIC_ENDURANCE:{menu:'ability_citadel-plus_prismatic-endurance',kind:'defense',visual:105,laserReduction:.8},
 SPEED_BOOST:{menu:'ability_tartarus_speed-boost',kind:'toggle',visual:0,speedParam:1,damageParam:0},
 SPEED_BOOST_PLUS:{menu:'ability_tartarus-plus_speed-boost-plus',kind:'toggle',visual:0,speedParam:1,damageParam:0},
 RAPID_FIRE:{menu:'ability_tartarus_rapid-fire',kind:'rapid',visual:1},
 RAPID_FIRE_PLUS:{menu:'ability_tartarus-plus_rapid-fire-plus',kind:'rapid',visual:1,launcherDamage:1.2},
 BERSERK:{menu:'ability_berserker_bsk',kind:'berserk',visual:84},
 REVENGE:{menu:'ability_berserker_rvg',kind:'revenge',visual:85,speedEffect:.95},
 ASSIMILATE:{menu:'ability_orcus_assimilate',kind:'assimilate',visual:99,endCooldown:true,noManualStop:true},
 ULTIMATE_CLOAKING:{menu:'ability_spearhead_ultimate-cloak',kind:'ultimateCloak',id:103,group:27,startEffectOnly:true},
 SCRAMBLE:{menu:'ability_mimesis_scramble',kind:'scramble',visual:3,speedEffect:1.25,laserEffect:1.25,shieldDrain:.10,evasion:.65,indefinite:true,manualStop:true},
 FORTIFY:{menu:'ability_citadel_fortify',kind:'fortify',id:109,group:33,visual:8,speedEffect:0,damageReduction:.5},
 TELEPORT:{menu:'ability_mimesis_phase-out',kind:'phase',visual:4},
 SUPERCHARGE:{menu:'ability_retiarus_spc',kind:'speed',speedEffect:1.10},
 MOMENTUM:{menu:'ability_zephyr_mmt',kind:'momentum',chargeMax:20,rangePerCharge:5,speedPerCharge:.015,speedCap:750}
};
const DEFINITIONS=Object.entries(DATA).flatMap(([ship,rows])=>rows.flatMap(row=>{
 const spec=SPECS[row.type];if(!spec)return[];
 const params=row.params.length?row.params:DATA.ship_aegis?.find(a=>a.type===row.type)?.params||[];
 return[{ship,...row,...spec,rate:params[spec.param]||0,speedMultiplier:1+(params[spec.speedParam]||0),laserMultiplier:1+(params[spec.damageParam]||0),radius:spec.kind==='pod'?(params[1]||500):spec.radius}];
}));
function hull(p){return open().prepare('SELECT s.loot_id FROM players p JOIN ships s ON s.id=p.active_ship_id AND s.player_id=p.id WHERE p.id=? AND s.id=?').get(p.userId,p.shipId)?.loot_id;}
function definitions(p){const ship=hull(p);return DEFINITIONS.filter(d=>d.ship===ship);}
function recognizes(id){return Object.values(SPECS).some(d=>d.menu===id);}
function read(p){try{return JSON.parse(open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,KEY)?.value||'{}');}catch{return{};}}
function write(p,value){open().prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,KEY,JSON.stringify(value));}
function runs(w){return w.expandedAbilityRuns||(w.expandedAbilityRuns=new Map());}
function charges(w,d){return w.shipAbilityCharges?.get(w.player.userId+':'+d.ship)||0;}
function setCharges(w,d,count){(w.shipAbilityCharges||=new Map()).set(w.player.userId+':'+d.ship,count);}
function toggle(p){try{return JSON.parse(open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,TOGGLE_KEY)?.value||'null');}catch{return null;}}
function writeToggle(p,value){open().prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,TOGGLE_KEY,JSON.stringify(value));}
function runValid(w,r){return w.player===r.player&&!w.player.dead&&w.active(r.session)&&!r.session.jumping&&w.player.shipId===r.shipId&&w.player.mapId===r.mapId;}
// Return replay packets after the new map's hero is created. A toggle survives
// map reload/logout; death or selecting another hull clears the saved choice.
function resume(w,now=Date.now()){
 const p=w.player,saved=toggle(p);if(!saved)return[];
 const d=definitions(p).find(d=>d.kind==='toggle'&&d.ship===saved.ship&&d.menu===saved.menu);
 if(p.dead||!d){writeToggle(p,null);return[];}
 if(!runs(w).has(d.menu)){
  const session=[...w.sessions].find(s=>w.active(s));if(!session)return[];
  runs(w).set(d.menu,{def:d,player:p,session,shipId:p.shipId,mapId:p.mapId,until:Infinity});
  require('./player-speed').set(w,'ship-toggle',d.speedMultiplier,now);
 }
 return[{_:'VisualModifierCommand',userId:p.userId,modifier:d.visual,attribute:0,additionalAttribute:'',count:0,activated:true},{_:'AttributeShipSpeedUpdateCommand',newSpeed:p.speed,displaySpeed:p.speed}];
}
function send(w,c){const f=w.combat?.send||require('./net').sendCmd;w.broadcast(s=>f(s,c));}
function status(w,id,template,now=Date.now()){
 if(!recognizes(id))return null;
 const d=definitions(w.player).find(d=>d.menu===id);if(!d)return null;
 template||=nativeTemplates.get(id)||{};
 const active=runs(w).has(id),until=read(w.player)[id]||0;
 const counter=d.chargeMax?{counterValue:charges(w,d)}:{};
 if(d.kind==='phase'&&!phaseMap(w.player))return{...structuredClone(template),_:'MenuItemStatusCommand',menuItemId:id,iconLootId:template.iconLootId||id,visible:true,available:true,activatable:false,selected:active,blocked:true};
 return{...structuredClone(template),...counter,_:'MenuItemStatusCommand',menuItemId:id,iconLootId:template.iconLootId||id,visible:true,available:true,activatable:!w.player.dead&&!abilityLocked(w)&&(!d.chargeMax||charges(w,d)>0)&&(d.kind==='toggle'?now>=until:active&&(d.manualStop||d.endCooldown&&!d.noManualStop)||!active&&now>=until),selected:active,blocked:false};
}
function cooldown(w,d,until,now){
 if(d.group)send(w,{_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:d.group},time:Math.max(0,until-now),maxTime:Math.max(0,until-now)});
 send(w,{_:'MenuItemTimerCommand',menuItemId:d.menu,timerState:{_:'TimerStateModule',timerStateValue:2},time:Math.max(0,until-now),maxTime:Math.max(0,until-now),activatable:false});
}
function timers(w,now=Date.now()){
 const out=[],cd=read(w.player);for(const d of definitions(w.player))if(cd[d.menu]>now&&(!runs(w).has(d.menu)||d.kind==='toggle'))out.push({_:'MenuItemTimerCommand',menuItemId:d.menu,timerState:{_:'TimerStateModule',timerStateValue:2},time:cd[d.menu]-now,maxTime:cd[d.menu]-now,activatable:false});return out;
}
function visual(w,r,on){
 const d=r.def,p=w.player;
 if(d.id){send(w,{_:on?'AbilityStartCommand':'AbilityStopCommand',selectedAbilityId:d.id,activatorId:p.userId,...(on?{noStopCommand:!d.duration}:{targetIds:[p.userId]})});
  if(on&&d.kind!=='pod'&&!d.startEffectOnly)send(w,{_:'AbilityEffectActivationCommand',selectedAbilityId:d.id,activatorId:p.userId,isPersistent:!!d.duration,targetIds:[p.userId]});
  if(!on&&!d.startEffectOnly)send(w,{_:'AbilityEffectDeActivationCommand',selectedAbilityId:d.id,activatorId:p.userId,targetIds:[p.userId]});
 }
 if(d.visual!==undefined)send(w,{_:'VisualModifierCommand',userId:p.userId,modifier:d.visual,attribute:0,additionalAttribute:'',count:0,activated:on});
 if(d.kind==='pod'){
  if(on)send(w,{_:'AssetCreateCommand',type:{_:'AssetTypeModule',typeValue:33},assetId:r.assetId,userName:'',factionId:p.factionId,posX:Math.round(r.x),posY:Math.round(r.y),modifier:[],clanRelation:{_:'ClanRelationModule',typeValue:0}});
  else send(w,{_:'AssetRemoveCommand',assetType:{_:'AssetTypeModule',typeValue:33},uid:r.assetId});
 }
}
function stopOne(w,r,now=Date.now()){
 runs(w).delete(r.def.menu);if(w.player!==r.player)return;
 if(r.def.kind==='toggle'){
  require('./player-speed').set(w,'ship-toggle',1,now);
  if(w.player.dead||hull(w.player)!==r.def.ship)writeToggle(w.player,null);
 }
 if(r.def.speedEffect!==undefined)require('./player-speed').set(w,'ability:'+r.def.menu,1,now);
 if(r.def.kind==='momentum'){const speed=require('./player-speed');speed.set(w,'ability:'+r.def.menu,1,now);speed.limit(w,'ability:'+r.def.menu,null,now);}
 if(r.def.kind==='ultimateCloak'){
  w.player.ultimateCloaked=false;
  w.player.shield=Math.min(w.player.shieldMax,w.player.ultimateShield||0);delete w.player.ultimateShield;
  send(w,{_:'AttributeShieldUpdateCommand',shieldNow:w.player.shield,shieldMax:w.player.shieldMax});
 }
 if(r.def.endCooldown){const until=now+r.cooldown;write(w.player,{...read(w.player),[r.def.menu]:until});cooldown(w,r.def,until,now);}
 visual(w,r,false);
 if(r.def.kind==='ultimateCloak'){w.player.cloaked=require('./cpu').isCloaked(w.player);send(w,require('./cpu').cloakCommand(w.player));}
 send(w,status(w,r.def.menu,r.template,now)||{...structuredClone(r.template),_:'MenuItemStatusCommand',menuItemId:r.def.menu,visible:false,available:false,activatable:false,selected:false,blocked:false});
}
function stop(w,now=Date.now()){const active=[...runs(w).values()];for(const r of active)stopOne(w,r,now);return !!active.length;}
function heal(w,amount,shield=false){
 const p=w.player;if(shield){const old=p.shield;p.shield=Math.min(p.shieldMax,p.shield+amount);if(old!==p.shield)send(w,{_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});}
 else{const old=p.hitPoints;p.hitPoints=Math.min(p.hitMax,p.hitPoints+amount);if(old!==p.hitPoints)send(w,{_:'HitpointInfoCommand',hitpoints:p.hitPoints,hitpointsMax:p.hitMax,nanoHull:p.nanoHull||0,nanoHullMax:p.maxNanoHull||0});}
}
function phaseMap(p){const map=maps.getMap(p.mapId);return map&&/^[1-4]-[1-9]$/.test(map.name)?map:null;}
function phaseDestination(p,random=Math.random){
 // Mini-map display units are 1/100 of world coordinates (50 => 5000).
 // This solo server currently implements only normal 1-x..4-x maps here.
 const map=phaseMap(p);if(!map)return null;
 const at=angle=>{const x=Math.round(p.x+5000*Math.cos(angle)),y=Math.round(p.y+5000*Math.sin(angle));return x>=0&&y>=0&&x<=map.width&&y<=map.height?{x,y}:null;};
 for(let i=0;i<64;i++){const dest=at(random()*Math.PI*2);if(dest)return dest;}
 // Bounded fallback for a pathological RNG / a ship at a map corner. Never
 // clamp into a shorter hop or enter radiation when no full-length hop fits.
 const offset=random()*Math.PI*2;for(let i=0;i<256;i++){const dest=at(offset+i*Math.PI/128);if(dest)return dest;}
 return null;
}
function action(session,cmd,now=Date.now(),template){
 const w=session.world,p=w.player;if(!w.active(session)||p.dead||session.jumping||cmd.actionType!==1||abilityLocked(w))return false;
 const d=definitions(p).find(d=>d.menu===cmd.menuItemId);if(!d)return false;
 const existing=runs(w).get(d.menu);if(existing){
  if(d.kind==='toggle'){
   if(now<(read(p)[d.menu]||0))return false;
   const until=now+d.cooldown;tx(()=>{write(p,{...read(p),[d.menu]:until});writeToggle(p,null);});
   stopOne(w,existing,now);cooldown(w,d,until,now);return true;
  }
  if(!d.endCooldown&&!d.manualStop||d.noManualStop)return false;stopOne(w,existing,now);return true;
 }
 if(now<(read(p)[d.menu]||0))return false;
 // Historical tactical guide's20s combat lock. Native server does not expose
 // this threshold; document the selected edition rather than claiming recovery.
 if(d.kind==='ultimateCloak'&&(session.attacking||p.lastCombat>0&&now-p.lastCombat<20000))return false;
 if(d.kind==='scramble'&&(p.shield<=0||p.shieldMax<=0))return false;
 const chargeCount=d.chargeMax?charges(w,d):0;if(d.chargeMax&&!chargeCount)return false;
 if(['hp','instant'].includes(d.kind)&&p.hitPoints>=p.hitMax||d.kind==='shield'&&p.shield>=p.shieldMax)return false;
 const phase=d.kind==='phase'?phaseDestination(w.updatePosition(now)):null;if(d.kind==='phase'&&!phase)return false;
 const multiplier=d.kind==='toggle'?1:Math.max(.25,require('./boosters').abilityCooldownMultiplier(p.userId)-(p.stats.abilityCooldownReduction||0)),cd=Math.round(d.cooldown*multiplier),until=now+cd+(d.endCooldown?d.duration:0);
 tx(db=>{write(p,{...read(p),[d.menu]:until});if(d.kind==='toggle')writeToggle(p,{ship:d.ship,menu:d.menu});if(d.kind==='instant')db.prepare('UPDATE ships SET hitpoints=? WHERE id=? AND player_id=?').run(Math.min(p.hitMax,p.hitPoints+Math.round(p.hitMax*d.fraction)),p.shipId,p.userId);});
 const pos=w.updatePosition(now),r={def:d,player:p,session,shipId:p.shipId,mapId:p.mapId,x:pos.x,y:pos.y,assetId:700000000+p.userId,until:now+d.duration,nextTick:now+1000,cooldown:cd,template};
 if(d.duration||d.kind==='toggle')runs(w).set(d.menu,r);
 if(d.indefinite){r.until=Infinity;r.configId=require('./inventory').activeConfig(open(),p.shipId);}
 if(d.kind==='toggle'){r.until=Infinity;require('./player-speed').set(w,'ship-toggle',d.speedMultiplier,now);}
 if(d.speedEffect!==undefined)require('./player-speed').set(w,'ability:'+d.menu,d.speedEffect,now);
 if(d.kind==='momentum'){
  setCharges(w,d,0);const speed=require('./player-speed');speed.limit(w,'ability:'+d.menu,d.speedCap,now);speed.set(w,'ability:'+d.menu,1+chargeCount*d.speedPerCharge,now);
 }
 if(d.kind==='fortify')send(w,{_:'MoveCommand',userId:p.userId,x:Math.round(p.x),y:Math.round(p.y),timeToTarget:0});
 if(d.kind==='ultimateCloak'){
  p.ultimateShield=p.shield;p.shield=0;p.ultimateCloaked=true;p.cloaked=true;
  send(w,{_:'AttributeShieldUpdateCommand',shieldNow:0,shieldMax:p.shieldMax});
  for(const npc of w.npcs.values())if(npc.aggro===session)w.combat?.dropNpcAggro(npc,now);
 }
 if(d.kind==='rapid')require('./hellstorm').rapidStart(w,now);
 visual(w,r,true);
 if(phase){
  w.collectables?.cancelHarvest(session);require('./ship-warp').cancel(session);
  w.movement=null;Object.assign(p,phase);session.target={...phase};
  send(w,{_:'MoveCommand',userId:p.userId,x:phase.x,y:phase.y,timeToTarget:0});
  send(w,maps.beacon(w));
 }
 if(d.kind==='instant')heal(w,Math.round(p.hitMax*d.fraction));
 if(!d.endCooldown)cooldown(w,d,until,now);
 if(d.duration&&!d.indefinite)send(w,{_:'MenuItemTimerCommand',menuItemId:d.menu,timerState:{_:'TimerStateModule',timerStateValue:1},time:d.duration,maxTime:d.duration,activatable:!!d.endCooldown&&!d.noManualStop});
 send(w,status(w,d.menu,template,now));return true;
}
function burn(w,combat,r,at){
 const p=w.updatePosition(at);if(maps.nearPeaceArea(w))return;
 for(const n of [...combat.npcs.values()]){
  combat.updateNpc(n,at);if(n.hp<=0||combat.npcProtected(n)||maps.dist(p,n)>r.def.radius)continue;
  const hp=n.hp,shield=n.shield;combat.applyDamage(n,r.def.rate,combat.npcAbsorb(n));n.lastHit=at;n.aggro=r.session;p.lastCombat=at;
  try{if(n.hp<=0)combat.kill(r.session,n,()=>combat.hit(p.userId,n.id,n,r.def.rate,0));else combat.hit(p.userId,n.id,n,r.def.rate,0);}
  catch(error){n.hp=hp;n.shield=shield;throw error;}
 }
}
function tick(w,combat,now=Date.now(),templates=new Map()){
 const p=w.player;if(!p)return;
 const ship=hull(p);for(const r of [...runs(w).values()]){
  if(p!==r.player||p.dead||!w.active(r.session)||r.session.jumping||p.shipId!==r.shipId||p.mapId!==r.mapId||ship!==r.def.ship){stopOne(w,r,now);continue;}
  if(r.def.kind==='scramble'){
   if(p.shield<=0||r.configId!==require('./inventory').activeConfig(open(),p.shipId)){stopOne(w,r,now);continue;}
   while(r.nextTick<=now){const at=r.nextTick;r.nextTick+=1000;p.shield=Math.max(0,p.shield-Math.ceil(p.shieldMax*r.def.shieldDrain));send(w,{_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});if(p.shield<=0){stopOne(w,r,at);break;}}
   if(!runs(w).has(r.def.menu))continue;
  }
  while(['hp','shield','pod','burn'].includes(r.def.kind)&&r.nextTick<=now&&r.nextTick<=r.until){const at=r.nextTick;
   if(r.def.kind==='burn')burn(w,combat,r,at);
   else if(r.def.kind==='hp')heal(w,r.def.rate);
   else if(r.def.kind==='shield')heal(w,r.def.rate,true);
   else if(r.def.kind==='pod'&&maps.dist(p,r)<=r.def.radius)heal(w,r.def.rate);
   r.nextTick+=1000;
  }
  if(now>=r.until){stopOne(w,r,r.until);w.save();}
 }
 const cd=read(p),signature=ship+':'+JSON.stringify(Object.entries(cd).map(([id,until])=>[id,now<until]))+':'+[...runs(w).keys()].join(',');
 if(w.expandedAbilityMenuSignature!==signature){w.expandedAbilityMenuSignature=signature;for(const d of definitions(p))send(w,status(w,d.menu,templates.get(d.menu),now));}
}
function incoming(w,damage,attackType){let multiplier=1;for(const r of runs(w).values()){if(attackType===1&&r.def.laserReduction)multiplier*=1-r.def.laserReduction;if(r.def.damageReduction)multiplier*=1-r.def.damageReduction;}return Math.round(damage*multiplier);}
function abilityLocked(w){return [...runs(w).values()].some(r=>r.def.kind==='fortify'&&runValid(w,r));}
function outgoing(w,damage){
 let multiplier=1;for(const r of runs(w).values())if(runValid(w,r)){
  if(r.def.kind==='toggle')multiplier*=r.def.laserMultiplier;
  if(r.def.kind==='berserk')multiplier*=1+Math.max(0,Math.min(1,1-w.player.hitPoints/Math.max(1,w.player.hitMax)));
  if(r.def.laserEffect)multiplier*=r.def.laserEffect;
 }
 return Math.round(damage*multiplier);
}
function activeRun(w,kind,now){return [...runs(w).values()].find(r=>r.def.kind===kind&&runValid(w,r)&&now<r.until);}
// After protection/evasion and weapon defenses, before shield/NanoHull/HP Link.
// April 2022 sync: Revenge reflects 100%, but the Berserker still takes 5%.
function npcIncoming(w,combat,npc,damage,now=Date.now()){
 const destroyedNpc=npc?.hp===0&&npc.selfDestructAt>0;
 if(!npc||(combat.npcs.get(npc.id)!==npc||npc.hp<=0)&&!destroyedNpc)return{damage,heal:0};
 if(activeRun(w,'revenge',now)&&combat.npcs.get(npc.id)===npc&&npc.hp>0){
  if(!combat.npcProtected(npc)){
   const before={hp:npc.hp,shield:npc.shield,lastHit:npc.lastHit,aggro:npc.aggro};
   combat.applyDamage(npc,damage,combat.npcAbsorb(npc));npc.lastHit=now;npc.aggro=[...w.sessions].find(s=>w.active(s));
   try{if(npc.hp<=0)combat.kill(npc.aggro,npc,()=>combat.hit(w.player.userId,npc.id,npc,damage,0));else combat.hit(w.player.userId,npc.id,npc,damage,0);}
   catch(error){Object.assign(npc,before);throw error;}
  }
  return{damage:Math.round(damage*.05),heal:0};
 }
 if(activeRun(w,'assimilate',now))return{damage:damage-Math.round(damage*.8),heal:Math.round(damage*.8)};
 return{damage,heal:0};
}
function configurationChanged(w,now=Date.now()){
 if(!w.player)return;for(const r of [...runs(w).values()])if(r.def.kind==='scramble'&&(w.player.shield<=0||r.configId!==require('./inventory').activeConfig(open(),w.player.shipId)))stopOne(w,r,now);
}
function afterNpcDamage(w,amount,now=Date.now()){if(amount>0&&w.player.hitPoints>0&&!w.player.dead)heal(w,amount);if(w.player.shield<=0)configurationChanged(w,now);}
function evasion(w,now=Date.now()){return activeRun(w,'scramble',now)?.def.evasion||0;}
function breakUltimate(w,now=Date.now()){
 const run=[...runs(w).values()].find(r=>r.def.kind==='ultimateCloak');if(!run)return false;stopOne(w,run,now);return true;
}
function launcher(w,now=Date.now()){
 const r=[...runs(w).values()].find(r=>r.def.kind==='rapid'&&runValid(w,r)&&now<r.until);
 return r?{cooldown:1000,damage:r.def.launcherDamage||1}:null;
}
function onNpcKill(w){
 if(!w.player||w.player.dead)return;
 for(const d of definitions(w.player).filter(d=>d.chargeMax)){
  setCharges(w,d,Math.min(d.chargeMax,charges(w,d)+1));send(w,status(w,d.menu));
 }
}
function laserRange(w,base=600,now=Date.now()){
 if(!w.shipAbilityCharges?.size)return base;
 const d=definitions(w.player).find(d=>d.rangePerCharge);
 return base+(d&&!activeRun(w,d.kind,now)?charges(w,d)*d.rangePerCharge:0);
}
module.exports={DEFINITIONS,definitions,recognizes,status,timers,action,tick,stop,incoming,outgoing,launcher,resume,npcIncoming,afterNpcDamage,breakUltimate,evasion,configurationChanged,abilityLocked,phaseDestination,onNpcKill,laserRange};

