'use strict';
// Official DE GG FAQ 2848 (Emperor behaviours), ES Alien FAQ 135697
// (Kristallon bomb: 300,000). Server-only timings/radii below are explicitly
// configurable local defaults, not published original constants.
const maps=require('./maps');
const DEFAULTS=Object.freeze({beaconRadius:400,beaconCooldownMs:30000,beaconRestore:.1,sibelonSpeed:380,
 beaconDamageBonus:.1,cloneHullStep:1280000,cloneCooldownMs:15000,cloneRepairPerSecond:.01,bombCooldownMs:15000,bombFuseMs:3000,bombRadius:500,bombDamage:300000});
function cfg(c){return{...DEFAULTS,...c.world.config.galaxyGates?.hadesBosses};}
function eligible(c,n){return c.world.player?.mapId===203&&n.def.gateRunId&&/^emperor-(sibelon|lordakium|kristallon)$/.test(n.def.key||'');}
function modifier(c,id,code,on,attribute=0){c.broadcast({_:'VisualModifierCommand',userId:id,modifier:code,attribute,additionalAttribute:'',count:1,activated:on});}
function teleport(c,n,position){n.movement=null;n.x=Math.round(position.x);n.y=Math.round(position.y);c.broadcast({_:'ShipRemoveCommand',userId:n.id});c.broadcast(c.createCmd(n));}
function initialize(c,n,now){
 if(n.hades)return n.hades;const state=n.hades={nextSkill:now,lastTick:now,clones:[],mapId:203};
 if(n.def.key==='emperor-sibelon')state.beacons=[{x:c.map.width*.25,y:c.map.height*.25},{x:c.map.width*.75,y:c.map.height*.25},{x:c.map.width*.5,y:c.map.height*.75}].map((p,type)=>({...p,type,id:600000000+n.id*3+type}));
 if(n.def.key==='emperor-lordakium')state.cloneHull=n.hp-cfg(c).cloneHullStep;
 if(n.def.key==='emperor-kristallon'){state.nextSkill=now+cfg(c).bombCooldownMs;modifier(c,c.world.player.userId,43,true);state.polarity=true;}
 return state;
}
function beaconCommand(b){return{_:'AssetCreateCommand',assetId:b.id,designId:b.type,type:{_:'AssetTypeModule',typeValue:45},posX:Math.round(b.x),posY:Math.round(b.y),userName:'',clanId:0,clanTag:'',clanRelation:{_:'ClanRelationModule',type:0},factionId:0,showBubble:false,expansionStage:0,modifier:[],detectedByWarnRadar:false,invisible:false,visibleOnWarnRadar:false};}
function removeAsset(c,id){c.broadcast({_:'AssetRemoveCommand',uid:id,assetType:{_:'AssetTypeModule',typeValue:45}});}
function beforeAi(c,n,now=Date.now()){
 if(!eligible(c,n)||n.hp<=0)return false;
 const s=initialize(c,n,now),d=cfg(c),elapsed=Math.max(0,Math.min(5,(now-s.lastTick)/1000));s.lastTick=now;
 if(n.def.key==='emperor-sibelon'){
  if(n.shield<=0&&!s.beaconsShown){s.beaconsShown=true;for(const b of s.beacons)c.broadcast(beaconCommand(b));}
  if(s.beaconsShown&&!s.destination&&n.shield<=0&&now>=s.nextSkill){s.visits=((s.visits??-1)+1)%s.beacons.length;s.destination=s.beacons[s.visits];s.originalSpeed??=n.def.speed;n.def={...n.def,speed:d.sibelonSpeed};}
  if(s.destination){const b=s.destination;
   if(maps.dist(n,b)>d.beaconRadius){if(!n.movement)c.moveNpc(n,b.x,b.y,now);return true;}
   c.stopNpc(n,now);n.def={...n.def,speed:s.originalSpeed};
   if(b.type===1)n.shield=Math.min(n.def.shield,n.shield+Math.round(n.def.shield*d.beaconRestore));
   else if(b.type===2)n.hp=Math.min(n.def.hitpoints,n.hp+Math.round(n.def.hitpoints*d.beaconRestore));
   else s.damageUntil=now+d.beaconCooldownMs;
   c.broadcast({_:'EmperorSibelonBuffRingCommand',x:Math.round(b.x),y:Math.round(b.y),radius:d.beaconRadius,type:b.type,avatarId:n.id});
   modifier(c,n.id,50,b.type===0);modifier(c,c.world.player.userId,51,b.type===0);
   s.destination=null;s.nextSkill=now+d.beaconCooldownMs;
  }
  if(s.damageUntil&&now>=s.damageUntil){s.damageUntil=0;modifier(c,n.id,50,false);modifier(c,c.world.player.userId,51,false);}
 }
 if(n.def.key==='emperor-lordakium'){
  s.clones=s.clones.filter(id=>c.npcs.has(id));
  if(s.clones.length)n.hp=Math.min(n.def.hitpoints,n.hp+Math.round(n.def.hitpoints*d.cloneRepairPerSecond*elapsed));
  const border=n.x<500||n.y<500||n.x>c.map.width-500||n.y>c.map.height-500;
  if(!s.clones.length&&now>=s.nextSkill&&(n.hp<=s.cloneHull||border)){
   s.cloneHull=n.hp-d.cloneHullStep;s.nextSkill=now+d.cloneCooldownMs;
   teleport(c,n,{x:c.map.width*(.25+Math.random()*.5),y:c.map.height*(.25+Math.random()*.5)});
   for(const side of [-1,1]){const clone=c.spawn({...n.def,gateRunId:undefined,gateWave:undefined,gateSlot:undefined,hadesDecoy:true,hitpoints:1,shield:0,aggressive:false,speed:0,damageMin:0,damageMax:0,reward:{},respawnMs:0},{x:n.x+side*350,y:n.y+200});if(clone){clone.aggro=null;s.clones.push(clone.id);modifier(c,clone.id,48,true);}}
   modifier(c,n.id,48,true);
  }
 }
 if(n.def.key==='emperor-kristallon'){
  const p=c.world.player;
  if(s.bomb){if(now>=s.bomb.at){const bomb=s.bomb;s.bomb=null;modifier(c,p.userId,47,false);c.broadcast({_:'RemoveMineCommand',hash:bomb.hash});if(!p.dead&&maps.dist(p,bomb)<=d.bombRadius)c.damagePlayer(n,d.bombDamage,{now,attackType:2,evade:false});}}
  else if(now>=s.nextSkill&&!p.dead&&n.aggro){s.nextSkill=now+d.bombCooldownMs;s.bomb={x:Math.round(p.x),y:Math.round(p.y),at:now+d.bombFuseMs,hash:`hades-${n.id}-${now}`};modifier(c,p.userId,47,true,Math.ceil(d.bombFuseMs/1000));c.broadcast({_:'AddMineCommand',hash:s.bomb.hash,x:s.bomb.x,y:s.bomb.y,typeId:1,maxSkill1:false,maxSkill5b:false});}
 }
 return false;
}
function outgoing(c,n,damage,now=Date.now()){return Math.round(damage*(n.hades?.damageUntil>now?1+cfg(c).beaconDamageBonus:1));}
function playerDamage(c,damage,now=Date.now()){return Math.round(damage*([...c.npcs.values()].some(n=>eligible(c,n)&&n.hades?.damageUntil>now)?1-cfg(c).beaconDamageBonus:1));}
function cleanup(c,n){
 const s=n.hades;if(!s)return;
 if(s.beaconsShown)for(const b of s.beacons)removeAsset(c,b.id);
 for(const id of s.clones){const clone=c.npcs.get(id);if(clone)c.destroyWithoutReward(clone);}
 if(s.bomb)c.broadcast({_:'RemoveMineCommand',hash:s.bomb.hash});
 if(c.world.player){if(s.polarity)modifier(c,c.world.player.userId,43,false);if(s.bomb)modifier(c,c.world.player.userId,47,false);if(s.damageUntil)modifier(c,c.world.player.userId,51,false);}
 delete n.hades;
}
function stop(c){for(const n of [...c.npcs.values()])cleanup(c,n);}
module.exports={DEFAULTS,eligible,initialize,beforeAi,outgoing,playerDamage,cleanup,stop,beaconCommand};
