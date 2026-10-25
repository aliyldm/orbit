'use strict';
// Public, deterministic content only. All legacy migrations run in memory;
// neither the live account database nor any private projection is opened.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const legacy=path.resolve(__dirname,'../../local-server');
const database=require(path.join(legacy,'game/db'));
const db=database.open(':memory:');
try {
 const layout=require(path.join(legacy,'game/normal-map-layout'));
 const maps=require(path.join(legacy,'game/maps'));
 const content=require(path.join(legacy,'game/normal-map-content'));
 const staticNames=new Set(['AssetCreateCommand','SpaceStationCommand','MapAddPOICommand']);
 const output={format:1,maps:layout.maps.map(map=>{
  const portals=layout.portalsFor(map.id).sort((a,b)=>a.id-b.id).map(p=>({...p,levels:[1,2,3].map(f=>layout.portalAccessLevel(p,f))}));
  const player={userId:999999,mapId:map.id,factionId:map.faction_id||1,x:0,y:0,level:18,stats:{}};
  const world={player,sessions:new Set(),updatePosition:()=>player};
  const commands=maps.commands(world),firstGate=commands.findIndex(c=>c._==='JumpgateCreateCommand');
  return {...map,station:layout.station(map.id),portals,spawns:content.spawnRows(db,map.id),
   staticCommands:commands.filter((c,i)=>staticNames.has(c._)&&(firstGate<0||i<firstGate)),
   afterCommands:commands.filter((c,i)=>staticNames.has(c._)&&firstGate>=0&&i>firstGate)};
 }),npcTemplate:require(path.join(legacy,'game/templates/npc-ship.json'))};
 const serialized=JSON.stringify(output,null,2)+'\n';
 const destination=path.resolve(__dirname,'../src/DarkOrbit.Server/World/world-content.json');
 fs.mkdirSync(path.dirname(destination),{recursive:true});fs.writeFileSync(destination,serialized);
 const cases=[];
 for(const m of output.maps)for(const faction of [1,2,3]){
  const points=[{x:0,y:0},...m.portals.map(p=>({x:p.x,y:p.y})),...(m.station?[{x:m.station.x,y:m.station.y}]:[])];
  for(const point of points){
   const player={userId:999999,mapId:m.id,factionId:faction,...point,level:18,stats:{}};
   const world={player,sessions:new Set(),updatePosition:()=>player};
   cases.push({map:m.id,faction,...point,commands:maps.commands(world).filter(c=>staticNames.has(c._)||c._==='JumpgateCreateCommand'||c._==='POIReadyCommand'||c._==='MapAssetActionAvailableCommand'&&m.portals.some(p=>p.id===c.mapAssetId)),beacon:maps.beacon(world)});
  }
 }
 const contracts={format:1,cases};
 const artifacts=path.resolve(__dirname,'../artifacts');fs.mkdirSync(artifacts,{recursive:true});fs.writeFileSync(path.join(artifacts,'world-contract.json'),JSON.stringify(contracts));
 console.log(JSON.stringify({maps:output.maps.length,portals:output.maps.reduce((n,m)=>n+m.portals.length,0),npcSlots:output.maps.reduce((n,m)=>n+m.spawns.reduce((n,r)=>n+r.count,0),0),sha256:crypto.createHash('sha256').update(serialized).digest('hex')}));
} finally {database.close();}
