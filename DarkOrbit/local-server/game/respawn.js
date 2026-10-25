'use strict';
const {open,tx}=require('./db'),maps=require('./maps'),layout=require('./normal-map-layout');
const COSTS=Object.freeze({1:0,2:500,3:2000,7:0}),PROTECTION_MS=10000,HADES_RETURN_MS=30000,deaths=new WeakMap();
function localized(baseKey,count){return{_:'MessageLocalizedWildcardCommand',baseKey,baseKeyType:{_:'ReplacementTypeModule',typeValue:5},wildCardReplacements:count===undefined?[]:[{_:'MessageWildcardReplacementModule',wildcard:'%COUNT%',replacement:String(count),replacementType:{_:'ReplacementTypeModule',typeValue:5}}]};}
function recordDeath(world,now=Date.now()){
 const p=world.player;if(!p?.dead)return false;
 breakProtection(world);const death={player:p,userId:p.userId,shipId:p.shipId,mapId:p.mapId,x:p.x,y:p.y,at:now,sessions:new Set(world.sessions)};deaths.set(world,death);
 if(p.mapId===203)world.schedule?.(()=>{if(context(world)===death)send(world,{_:'KillScreenUpdateCommand',options:command(world,'',death.at+HADES_RETURN_MS).options});},HADES_RETURN_MS);
 // Forgetting the victim must not leave a pursuer camped at the death point.
 for(const npc of world.npcs.values())if(npc.aggro&&npc.def.behavior&&npc.def.behavior.roam!==false&&npc.def.behavior.chase!==false&&npc.def.speed>0&&!npc.def.gateRunId)npc.returning=true;
 return true;
}
function context(world,session){
 const p=world.player,d=deaths.get(world);
 return d&&p?.dead&&d.player===p&&d.userId===p.userId&&d.shipId===p.shipId&&d.mapId===p.mapId&&(!session||d.sessions.has(session))&&[...world.sessions].some(s=>d.sessions.has(s)&&world.active(s))?d:null;
}
function normal(world){const id=world.player?.mapId;return !!layout.getMap(id)&&!require('./galaxy-gates').isGateMap(id);}
function nearestPortal(world,d=context(world)){
 if(!d||!normal(world))return null;
 return maps.portals(d.mapId,world.player.factionId).filter(g=>g.map_id===d.mapId&&layout.getMap(g.target_map)&&maps.getMap(g.target_map))
  .sort((a,b)=>maps.dist(d,a)-maps.dist(d,b)||a.id-b.id)[0]||null;
}
function hadesRun(world){return world.player?.mapId===203?open().prepare("SELECT * FROM galaxy_gate_runs WHERE player_id=? AND gate_id=13 AND state='active' AND lives>0 ORDER BY id DESC LIMIT 1").get(world.player.userId):null;}
function command(world,killerName='',now=Date.now()){
 const p=world.player,d=context(world),paid=!!d&&normal(world),inGate=require('./galaxy-gates').isGateMap(p.mapId);
 const run=d&&hadesRun(world),left=run?Math.max(0,Math.ceil((d.at+HADES_RETURN_MS-now)/1000)):0;
 const details={1:['ttip_killscreen_basic_repair',inGate?'desc_killscreen_free_repair_cause_galaxygate':'desc_killscreen_free_repair_cause_unknown'],2:['ttip_killscreen_repair_jumpgate','desc_killscreen_repair_gate'],3:['ttip_killscreen_repair_location','desc_killscreen_repair_location'],7:['ttip_killscreen_repair_hadesgate','desc_killscreen_free_repair_cause_hadesgate']};
 const types=[...left>0?[7]:[],1,...paid&&nearestPortal(world,d)?[2]:[],...paid?[3]:[]];
 return{_:'KillScreenPostCommand',killerName,killerEpppLink:'',playerShipAlias:p.typeId,cause:{_:'DestructionTypeModule',cause:1},options:types.map(type=>({
  _:'KillScreenOptionModule',repairType:{_:'KillScreenOptionTypeModule',repairTypeValue:type},price:{_:'PriceModule',type:[1,7].includes(type)?0:1,amount:COSTS[type]},
  affordableForPlayer:type===7||type===1&&!left||paid&&(type!==2||!!nearestPortal(world,d))&&p.uridium>=COSTS[type],cooldownTime:[1,7].includes(type)?left:0,
  descriptionKey:localized(details[type][1],type===7?run.lives:type===1?undefined:COSTS[type]),descriptionKeyAddon:localized(''),toolTipKey:localized(details[type][0]),buttonKey:localized([1,7].includes(type)?'btn_killscreen_repair_for_free':'btn_killscreen_repair_for_uri',[1,7].includes(type)?undefined:COSTS[type])
 }))};
}
function modifier(p,on){return{_:'VisualModifierCommand',userId:p.userId,modifier:33,attribute:0,additionalAttribute:'',count:0,activated:on};}
function send(world,c){const fn=world.combat?.send||require('./net').sendCmd;world.broadcast(s=>fn(s,c));}
function breakProtection(world){const p=world.player;if(!p?.respawnProtectedUntil)return false;delete p.respawnProtectedUntil;send(world,modifier(p,false));return true;}
function protectedNow(world,now=Date.now()){
 const p=world.player;if(!p?.respawnProtectedUntil)return false;
 if(p.dead||now>=p.respawnProtectedUntil){breakProtection(world);return false;}return true;
}
function buildInit(world,now=Date.now()){
 if(!protectedNow(world,now))return[];
 const p=world.player,until=p.respawnProtectedUntil;
 world.schedule(()=>{if(world.player===p&&p.respawnProtectedUntil===until)breakProtection(world);},Math.max(0,until-now));
 return[modifier(p,true)];
}
function repair(session,request,{changeMap,sendCmd},now=Date.now()){
 const world=session.world,p=world.player,type=request.selection?.repairTypeValue;
 if(!world.active(session)||!p?.dead||session.respawning||![1,2,3,7].includes(type)||request.requestModule&&request.requestModule.userID!==p.userId)return false;
 const d=context(world,session);let target,hp=p.hitMax,shield=p.shieldMax;
 const run=d&&hadesRun(world);
 if(type===7){if(!run||now>=d.at+HADES_RETURN_MS)return false;const map=maps.getMap(203);target={mapId:203,x:map.start_x,y:map.start_y};}
 else if(type===1){if(run&&now<d.at+HADES_RETURN_MS)return false;const home=maps.home(world);if(!home)return false;target={mapId:home.id,x:home.start_x,y:home.start_y};}
 else{
  if(!d||!normal(world))return false;
  if(type===2){const gate=nearestPortal(world,d);if(!gate)return false;target={mapId:d.mapId,x:gate.x,y:gate.y};}
  else{
   const map=maps.getMap(d.mapId);if(!map)return false;
   target={mapId:d.mapId,x:Math.max(0,Math.min(map.width,d.x)),y:Math.max(0,Math.min(map.height,d.y))};
   const base=open().prepare('SELECT t.hitpoints FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id WHERE s.id=? AND s.player_id=?').get(p.shipId,p.userId);
   if(!base)return false;hp=Math.max(1,Math.min(p.hitMax,Math.round(base.hitpoints*.1)));shield=0;
  }
 }
 session.respawning=true;let candidate;
 try{
  const committed=tx(db=>{
   const row=db.prepare('SELECT p.uridium,p.map_id,p.active_ship_id,s.hitpoints FROM players p JOIN ships s ON s.id=p.active_ship_id AND s.player_id=p.id WHERE p.id=?').get(p.userId);
   if(!row||row.active_ship_id!==p.shipId||row.map_id!==p.mapId||row.hitpoints>0||row.uridium<COSTS[type])return false;
   candidate={...p,...target,uridium:row.uridium-COSTS[type],hitPoints:hp,shield,nanoHull:0,dead:false,repairing:false,lastCombat:now};
   require('./db/players').savePlayer(candidate);return true;
  });
  if(!committed){sendCmd(session,{_:'LegacyModule',message:'0|A|STD|Tamir yapılamadı: yeterli Uridium ve geçerli bir imha kaydı gerekli.'});sendCmd(session,command(world));return false;}
  // Save the old scene while the live pilot still identifies its old map.
  // Applying a base destination first would make managed() skip every damaged
  // enemy from the death map and lose its latest health/patrol snapshot.
  world.combat?.stop();
  Object.assign(p,candidate);deaths.delete(world);
  // The alive state, destination and payment have already committed together.
  // Rebuilding the native scene is transport work after this durable transition.
  const moved=changeMap(session,target.mapId,target.x,target.y);
  sendCmd(session,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});
  if(type===3){p.respawnProtectedUntil=now+PROTECTION_MS;for(const c of buildInit(world,now))sendCmd(session,c);}
  return moved;
 }finally{session.respawning=false;}
}
module.exports={COSTS,PROTECTION_MS,HADES_RETURN_MS,recordDeath,context,nearestPortal,command,repair,protectedNow,breakProtection,buildInit};
