'use strict';
const ID=150000000;
const PEOPLE={1:{designId:3,name:'Morgus Petterson'},2:{designId:6,name:'Reginald Crowley'},3:{designId:9,name:'Vanessa Arkadium'}};
const delivered=new WeakMap();
function describe(player,db=require('./db').open()){
 if(!player)return null;
 const map=db.prepare('SELECT * FROM maps WHERE id=? AND is_start=1 AND faction_id=?').get(player.mapId,player.factionId);
 if(!map)return null;
 const station=require('./normal-map-layout').station(map.id)||{x:player.factionId===1?2000:map.width-2000,y:player.factionId===3?map.height-2000:2000};
 return{id:ID,mapId:map.id,factionId:player.factionId,...PEOPLE[player.factionId],x:station.x,y:station.y+(player.factionId===3?-1080:1080)};
}
function appearance(asset,factionId){const person=PEOPLE[factionId];return person?{...asset,designId:person.designId,userName:person.name}:asset;}
function available(world,db=require('./db').open()){
 const player=world?.updatePosition?.()||world?.player,station=describe(player,db),radius=world?.config?.gameplay?.questGiverRange??1800;
 return station&&!player.dead&&![...(world.sessions||[])].some(s=>s.jumping)&&Math.hypot(player.x-station.x,player.y-station.y)<=radius?station:null;
}
function command(world,db=require('./db').open()){
 const station=available(world,db);
 return{_:'QuestGiversAvailableCommand',questGivers:station?[{_:'QuestGiverModule',questGiverId:0,mapObjectId:station.id,toolTip:{_:'MessageKeyListWildcardCommand',commandList:[{_:'MessageKeyListWildcardModule',wildCardReplacements:[],baseKey:station.name,baseKeyType:{_:'ReplacementTypeModule',typeValue:0},textStyle:0}]}}]:[]};
}
function signature(world,message){return`${world.player?.userId}:${world.player?.mapId}:${message.questGivers.length}`;}
function initialize(world,db=require('./db').open()){const message=command(world,db);delivered.set(world,signature(world,message));return[message];}
function refresh(world,sendCmd=require('./net').sendCmd,db=require('./db').open()){
 if(!world?.player)return false;const message=command(world,db),key=signature(world,message);
 if(delivered.get(world)===key)return false;
 delivered.set(world,key);world.broadcast(session=>{if(!message.questGivers.length)session.questGiverWindow=null;sendCmd(session,message);});return true;
}
function approach(session,request,db=require('./db').open()){
 const world=session.world;if(!world||world.player!==session.player||typeof world.active==='function'&&!world.active(session)||session.jumping)return null;
 const station=available(world,db);if(!station||request.questGiverId!==station.id)return null;
 session.questGiverWindow={playerId:session.player.userId,mapId:station.mapId,assetId:station.id};return station;
}
function current(session,db=require('./db').open()){
 const world=session.world;if(!world||world.player!==session.player||typeof world.active==='function'&&!world.active(session))return false;
 const saved=session.questGiverWindow,station=available(session.world,db);
 return !!saved&&!!station&&!session.jumping&&saved.playerId===session.player?.userId&&saved.mapId===station.mapId&&saved.assetId===station.id;
}
module.exports={ID,PEOPLE,describe,appearance,available,command,initialize,refresh,approach,current};
