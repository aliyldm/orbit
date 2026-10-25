'use strict';
// Runtime movement modifiers compose without overwriting equipment/config speed.
// Neither modifiers nor their reduced speed are saved as permanent ship stats.
function state(player) {
  const s=player.speedEffects ||= {base:player.speed,applied:player.speed,multipliers:{}};
  if(player.speed!==s.applied)s.base=player.speed;
  return s;
}
function refresh(world,now=Date.now(),{baseSpeed,notify=true}={}) {
  const p=world.updatePosition(now);if(!p)return;
  const s=state(p);if(baseSpeed!==undefined)s.base=baseSpeed;
  const cap=Math.min(Infinity,...Object.values(s.caps||{}));
  const speed=Math.max(0,Math.min(cap,Math.round(Object.values(s.multipliers).reduce((n,m)=>n*m,s.base))));
  const changed=p.speed!==speed;p.speed=s.applied=speed;
  if(!changed)return speed;
  const m=world.movement;
  if(m){const duration=speed?Math.hypot(m.targetX-p.x,m.targetY-p.y)/speed*1000:0;world.movement=duration?{x:p.x,y:p.y,targetX:m.targetX,targetY:m.targetY,start:now,duration}:null;}
  if(notify){const send=world.combat?.send||require('./net').sendCmd;world.broadcast(session=>send(session,{_:'AttributeShipSpeedUpdateCommand',newSpeed:speed,displaySpeed:speed}));}
  return speed;
}
function set(world,key,multiplier,now=Date.now()) {
  if(!world.player)return;
  const s=state(world.player);
  if(multiplier===1||multiplier==null)delete s.multipliers[key];else s.multipliers[key]=multiplier;
  return refresh(world,now);
}
function limit(world,key,cap,now=Date.now()) {
  if(!world.player)return;
  const s=state(world.player);s.caps||={};
  if(cap==null)delete s.caps[key];else s.caps[key]=cap;
  return refresh(world,now);
}
module.exports={refresh,set,limit};
