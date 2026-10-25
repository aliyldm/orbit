'use strict';
// Archived experiment, disabled at the user's request on 24 October 2026.
// No runtime world/map/movement/loot code imports this module.
const DATA=require('./data/pirate-maze.json');
function walls(mapId){return DATA.maps[mapId]?.rectangles||[];}
function inside(r,p,pad=0){return p.x>r[0]-pad&&p.x<r[2]+pad&&p.y>r[1]-pad&&p.y<r[3]+pad;}
function contains(mapId,p){return walls(mapId).some(r=>inside(r,p));}
function free(mapId,p){if(!contains(mapId,p))return {x:p.x,y:p.y};return walls(mapId).flatMap(r=>[{x:r[0]-30,y:p.y},{x:r[2]+30,y:p.y},{x:p.x,y:r[1]-30},{x:p.x,y:r[3]+30}]).filter(q=>q.x>=30&&q.y>=30&&q.x<=DATA.maps[mapId].worldSize[0]-30&&q.y<=DATA.maps[mapId].worldSize[1]-30&&!contains(mapId,q)).sort((a,b)=>Math.hypot(a.x-p.x,a.y-p.y)-Math.hypot(b.x-p.x,b.y-p.y))[0];}
function clip(mapId,a,b){let limit=1;const dx=b.x-a.x,dy=b.y-a.y,distance=Math.hypot(dx,dy);if(!distance)return {x:b.x,y:b.y};for(const r of walls(mapId)){if(inside(r,a))continue;let low=0,high=1;for(const[k,min,max]of [['x',r[0],r[2]],['y',r[1],r[3]]]){const delta=b[k]-a[k];if(!delta){if(a[k]<min||a[k]>max){low=2;break;}}else{const u=(min-a[k])/delta,v=(max-a[k])/delta;low=Math.max(low,Math.min(u,v));high=Math.min(high,Math.max(u,v));}}if(low<=high&&low>=0&&low<=1)limit=Math.min(limit,Math.max(0,low-25/distance));}return {x:Math.round(a.x+dx*limit),y:Math.round(a.y+dy*limit)};}
function commands(mapId){return walls(mapId).map((r,i)=>({_:'MapAddPOICommand',poiId:`pirate-maze-${mapId}-${i}`,poiType:{_:'POITypeModule',typeValue:5},poiTypeSpecification:'',design:{_:'POIDesignModule',designValue:4},shape:2,shapeCoordinates:r,inverted:false,active:true}));}
module.exports={DATA,walls,inside,contains,free,clip,commands};
