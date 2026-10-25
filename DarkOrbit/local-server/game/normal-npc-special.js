'use strict';
// Escort mechanisms are source-backed; counts, radii and refill/heal timing are
// explicit local settings in normal-map-content and config.normalNpcs.
const gates=require('./galaxy-gates');
function children(combat,mother,key){return [...combat.npcs.values()].filter(n=>n.def.normalMotherId===mother.id&&(!key||n.def.key===key)&&n.hp>0);}
function remove(combat,npc){
  combat.cancelEscortLaser?.(npc.id);
  combat.npcs.delete(npc.id);combat.broadcast({_:'ShipRemoveCommand',userId:npc.id});
  for(const session of combat.world.sessions)if(session.selected===npc.id||session.attacking===npc.id){combat.abort(session);session.selected=null;combat.send(session,{_:'ShipDeselectionCommand'});}
}
function isProtected(combat,npc){
  if(gates.isGateMap(combat.world.player?.mapId)||!npc?.def?.behavior?.supports)return false;
  return npc.def.behavior.supports.some(s=>s.protectionThreshold!==undefined&&(!npc.normalSupports?.[s.key]?.released||children(combat,npc,s.key).length>s.protectionThreshold));
}
function tick(combat,now=Date.now()){
  const world=combat.world,p=world.player;if(!p||gates.isGateMap(p.mapId))return;
  const config=world.config.normalNpcs||{};
  for(const npc of combat.npcs.values())if(Number.isFinite(npc.def.behavior?.speedFromPlayerOffset)){
    const speed=Math.max(1,p.speed+npc.def.behavior.speedFromPlayerOffset);
    if(npc.def.speed!==speed){npc.def.speed=speed;const move=npc.movement;if(move)combat.moveNpc(npc,move.targetX,move.targetY,now);}
  }
  for(const mother of [...combat.npcs.values()]){
    if(mother.hp<=0||!mother.def.behavior?.supports)continue;
    mother.normalSupports ||= {};
    for(const support of mother.def.behavior.supports){
      const state=mother.normalSupports[support.key]||={released:false,nextSpawn:0,lastHeal:0};
      const near=!p.dead&&Math.hypot(p.x-mother.x,p.y-mother.y)<=(config.escortRetainRadius??2500);
      const damaged=mother.hp<mother.def.hitpoints||mother.shield<mother.def.shield;
      const active=support.activation==='always'||(near&&damaged&&(mother.aggro||now-(mother.lastHit||0)<(config.escortIdleMs??20000)));
      if(!active){
        if(mother.cubikonOpen){combat.broadcast(spawnEffect(mother,false));mother.cubikonOpen=false;}
        for(const child of children(combat,mother,support.key))remove(combat,child);
        state.released=false;state.nextSpawn=0;continue;
      }
      const alive=children(combat,mother,support.key);
      if(mother.def.key==='cubikon'&&support.key==='protegit'&&!mother.cubikonOpen){mother.cubikonOpen=true;combat.broadcast(spawnEffect(mother,true));}
      // Battleray's first escort group is finite; after the shield opens it is
      // not instantly replenished into an unwinnable shield/healing loop.
      const canRefill=support.protectionThreshold===undefined;
      if(now>=state.nextSpawn&&(!state.released||canRefill)&&alive.length<support.count){
        const definition=require('./normal-map-content').definition;
        const occupied=new Set(alive.map(child=>child.cubikonEscort?.slot));
        for(let i=alive.length;i<support.count;i++){
          const cubikon=mother.def.key==='cubikon'&&support.key==='protegit';
          let slot=i;if(cubikon){slot=0;while(occupied.has(slot))slot++;occupied.add(slot);}
          const angle=slot*2*Math.PI/support.count;
          const def={...definition(support.key,{aggression:'aggressive',fleeAt:0}),transient:true,normalMotherId:mother.id};
          // Launch from the mothership hull, rather than materializing an
          // already-expanded perfect ring. Each guard keeps its own slot.
          const radius=cubikon?35+(slot%4)*12:220;
          const child=combat.spawn(def,{x:mother.x+Math.cos(angle)*radius,y:mother.y+Math.sin(angle)*radius});
          if(child&&cubikon){
            child.cubikonEscort={slot,angle,radius:300+(slot%4)*35,lastMove:now,launchUntil:now+1000};
            // Spread the first firing phase across a full round. Each guard
            // retains its own1s clock; the random phase is a local policy,
            // not a recovered private-server RNG formula.
            combat.queueEscortLaser?.(child,now+1000+(slot+Math.random())*1000/support.count);
            if(mother.aggro&&world.active(mother.aggro)&&!mother.aggro.jumping)child.aggro=mother.aggro;
            combat.moveNpc(child,mother.x+Math.cos(angle)*260,mother.y+Math.sin(angle)*260,now);
          }
        }
        state.released=true;state.nextSpawn=now+(config.escortRespawnMs??support.respawnMs??5000);
      }
      if(support.healEveryMs&&now-state.lastHeal>=support.healEveryMs){
        state.lastHeal=now;
        for(const child of children(combat,mother,support.key)){
          child.hp=Math.min(child.def.hitpoints,Math.round(child.hp+child.def.hitpoints*support.healFraction));
          if([...world.sessions].some(s=>s.selected===child.id))for(const session of world.sessions)if(session.selected===child.id)combat.select(session,child.id);
        }
      }
    }
    const protectedNow=isProtected(combat,mother);
    if(protectedNow&&(!mother.normalShieldShown||now-mother.normalShieldShown>=2000)){
      mother.normalShieldShown=now;combat.broadcast({_:'LegacyModule',message:`0|n|ISH|${mother.id}`});
    }else if(!protectedNow)mother.normalShieldShown=0;
  }
}
function onKilled(combat,npc){for(const child of children(combat,npc))remove(combat,child);}
function steerEscort(combat,npc,now=Date.now()){
 const state=npc.cubikonEscort;if(!state)return false;
 const mother=combat.npcs.get(npc.def.normalMotherId),world=combat.world,p=world.player;
 if(!mother||mother.hp<=0||!npc.aggro||!world.active(npc.aggro)||p.dead||npc.aggro.jumping||require('./maps').nearPeaceArea(world))return false;
 if(now<state.launchUntil||now-state.lastMove<500)return true;
 const elapsed=Math.min(2,Math.max(0,(now-state.lastMove)/1000));state.lastMove=now;
 // Per-guard orbit points prevent every Protegit converging on the same
 // player +/-150 point. Waypoints use real movement packets/speed, no teleport.
 state.angle+=npc.def.speed/state.radius*elapsed;
 combat.moveNpc(npc,p.x+Math.cos(state.angle)*state.radius,p.y+Math.sin(state.angle)*state.radius,now);
 return true;
}
function spawnEffect(npc,open){return {_:'LegacyModule',message:`0|n|s|${open?'start':'end'}|${npc.id}`};}
module.exports={tick,onKilled,isProtected,children,steerEscort,spawnEffect};
