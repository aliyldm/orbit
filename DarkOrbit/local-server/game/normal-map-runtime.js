'use strict';
const {open,tx}=require('./db');
function managed(combat,def){
 const p=combat.world.player;
 if(!p||def.transient||def.gateRunId||!def.key||!Number.isSafeInteger(def.normalSpawnId)||!Number.isSafeInteger(def.normalSpawnSlot)||def.normalSpawnSlot<0)return false;
 return !!open().prepare('SELECT 1 FROM map_spawns WHERE id=? AND map_id=? AND catalog_key=? AND count>?').get(def.normalSpawnId,p.mapId,def.key,def.normalSpawnSlot);
}
function position(combat){return {x:Math.round(500+Math.random()*(combat.map.width-1000)),y:Math.round(500+Math.random()*(combat.map.height-1000))};}
function load(combat,def,now=Date.now()){
 if(!managed(combat,def))return null;
 const p=combat.world.player,db=open(),args=[p.userId,def.normalSpawnId,def.normalSpawnSlot];
 let state=db.prepare('SELECT * FROM normal_spawn_state WHERE player_id=? AND spawn_id=? AND slot=?').get(...args);
 if(state?.respawn_at>now)return {wait:state.respawn_at-now,state};
 if(!state){const point=position(combat);db.prepare('INSERT INTO normal_spawn_state(player_id,map_id,spawn_id,slot,generation,hp,shield,x,y,respawn_at,saved_at)VALUES(?,?,?,?,1,?,?,?,?,0,?)').run(p.userId,p.mapId,def.normalSpawnId,def.normalSpawnSlot,def.hitpoints,def.shield,point.x,point.y,now);}
 else if(state.respawn_at){const point=position(combat);db.prepare('UPDATE normal_spawn_state SET generation=generation+1,hp=?,shield=?,x=?,y=?,home_x=?,home_y=?,patrol_returning=0,respawn_at=0,saved_at=?,last_hit=0,self_destruct_at=0 WHERE player_id=? AND spawn_id=? AND slot=? AND generation=? AND respawn_at>0 AND respawn_at<=?').run(def.hitpoints,def.shield,point.x,point.y,point.x,point.y,now,...args,state.generation,now);}
 state=db.prepare('SELECT * FROM normal_spawn_state WHERE player_id=? AND spawn_id=? AND slot=?').get(...args);
 return {state,wait:0};
}
function schedule(combat,def,wait){
 const w=combat.world,p=w.player,mapId=p.mapId,epoch=w.epoch,key=`${p.userId}:${def.normalSpawnId}:${def.normalSpawnSlot}`;
 combat.normalRespawnTimers ||= new Map();if(combat.normalRespawnTimers.has(key))return;
 const timer=setTimeout(()=>{
  combat.respawns.delete(timer);combat.normalRespawnTimers.delete(key);
  if(combat.timer&&w.player===p&&p.mapId===mapId&&w.epoch===epoch)spawn(combat,def);
 },Math.max(1,wait));timer.unref?.();combat.respawns.add(timer);combat.normalRespawnTimers.set(key,timer);
}
function spawn(combat,def){
 const existing=[...combat.npcs.values()].find(n=>def.normalSpawnId!=null&&n.def.normalSpawnId===def.normalSpawnId&&n.def.normalSpawnSlot===def.normalSpawnSlot);if(existing)return existing;
 const loaded=load(combat,def);if(!loaded)return combat.spawn(def);
 if(loaded.wait){schedule(combat,def,loaded.wait);return null;}
 const s=loaded.state,home={x:s.home_x??s.x,y:s.home_y??s.y},distance=Math.hypot(home.x-s.x,home.y-s.y);
 // Inactive solo maps do not run a timer. Advance only an already-started
 // retreat, at the NPC's speed, before sending its first create command.
 const travel=s.patrol_returning?Math.min(distance,Math.max(0,Date.now()-s.saved_at)/1000*Math.max(0,def.speed)):0;
 const point=distance&&travel?{x:s.x+(home.x-s.x)*travel/distance,y:s.y+(home.y-s.y)*travel/distance}:{x:s.x,y:s.y};
 const npc=combat.spawn({...def,normalSpawnGeneration:s.generation},point);
 if(npc){npc.hp=Math.max(1,Math.min(def.hitpoints,s.hp));npc.shield=Math.max(0,Math.min(def.shield,s.shield));npc.lastHit=s.last_hit;npc.selfDestructAt=s.self_destruct_at;npc.patrolHome=home;npc.returning=!!s.patrol_returning&&distance-travel>1;}
 return npc;
}
function save(combat,now=Date.now(),{departing=false}={}){
 const p=combat.world.player;if(!p)return;
 const alive=[...combat.npcs.values()].filter(n=>n.hp>0&&n.def.normalSpawnGeneration&&managed(combat,n.def));if(!alive.length)return;
 tx(db=>{const update=db.prepare('UPDATE normal_spawn_state SET hp=?,shield=?,x=?,y=?,saved_at=?,last_hit=?,self_destruct_at=?,home_x=?,home_y=?,patrol_returning=? WHERE player_id=? AND spawn_id=? AND slot=? AND generation=? AND respawn_at=0');
  for(const npc of alive){combat.updateNpc(npc,now);const home=npc.patrolHome||npc,retreat=!!npc.returning||departing&&!!npc.aggro&&npc.def.behavior?.chase!==false&&npc.def.speed>0;update.run(Math.round(npc.hp),Math.round(npc.shield),npc.x,npc.y,now,Math.round(npc.lastHit||0),npc.selfDestructAt||0,home.x,home.y,Number(retreat),p.userId,npc.def.normalSpawnId,npc.def.normalSpawnSlot,npc.def.normalSpawnGeneration);}
 });
}
function claim(combat,npc,reward,now=Date.now()){
 if(!managed(combat,npc.def)){reward();return true;}
 const p=combat.world.player,before={credits:p.credits,uridium:p.uridium,ep:p.ep,honourPoints:p.honourPoints,level:p.level};
 try{return tx(db=>{
  const changed=db.prepare('UPDATE normal_spawn_state SET hp=0,shield=0,respawn_at=?,saved_at=? WHERE player_id=? AND spawn_id=? AND slot=? AND generation=? AND respawn_at=0').run(now+Math.max(1,npc.def.respawnMs??30000),now,p.userId,npc.def.normalSpawnId,npc.def.normalSpawnSlot,npc.def.normalSpawnGeneration);
  if(!changed.changes)return false;reward();return true;
 });}catch(error){Object.assign(p,before);throw error;}
}
module.exports={managed,load,spawn,save,claim};
