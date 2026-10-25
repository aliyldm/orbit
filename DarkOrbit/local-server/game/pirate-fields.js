'use strict';
// Official pirate FAQ: sparse 5-1, abundant 5-3, ore inside decloaking mist.
// Bounds/density/respawn are LOCAL tuning, not recovered server constants.
// Native MapAddPOICommand renders the existing nebula asset in both renderers.
const FIELDS = Object.freeze({
  91: Object.freeze({x:18000,y:11000,right:24000,bottom:15500,count:60,respawnMs:15000}),
  93: Object.freeze({x:9000,y:19500,right:33000,bottom:24500,count:480,respawnMs:15000})
});
function contains(mapId,point) {
  const f=FIELDS[mapId];return !!f&&point.x>=f.x&&point.x<=f.right&&point.y>=f.y&&point.y<=f.bottom;
}
function crosses(mapId,a,b) {
  const f=FIELDS[mapId];if(!f)return false;
  // Slab intersection also catches a full traversal between position updates.
  let low=0,high=1;
  for(const [key,min,max] of [['x',f.x,f.right],['y',f.y,f.bottom]]) {
    const delta=b[key]-a[key];
    if(delta===0){if(a[key]<min||a[key]>max)return false;continue;}
    const t1=(min-a[key])/delta,t2=(max-a[key])/delta;
    low=Math.max(low,Math.min(t1,t2));high=Math.min(high,Math.max(t1,t2));
    if(low>high)return false;
  }
  return true;
}
function commands(mapId) {
  const f=FIELDS[mapId];return f?[{_:'MapAddPOICommand',poiId:`pirate-mist-${mapId}`,poiType:{_:'POITypeModule',typeValue:0},poiTypeSpecification:'',design:{_:'POIDesignModule',designValue:5},shape:2,shapeCoordinates:[f.x,f.y,f.right,f.bottom],inverted:false,active:true}]:[];
}
function point(f,random=Math.random) {
  return {x:Math.round(f.x+100+random()*(f.right-f.x-200)),y:Math.round(f.y+100+random()*(f.bottom-f.y-200))};
}
function populate(collectables) {
  const f=FIELDS[collectables.mapId];if(!f)return;
  // Stratification avoids empty patches caused by purely random clustering.
  const cols=Math.ceil(Math.sqrt(f.count*(f.right-f.x)/(f.bottom-f.y))),rows=Math.ceil(f.count/cols);
  for(let i=0;i<f.count;i++)collectables.add({
    x:Math.round(f.x+100+((i%cols)+Math.random())/cols*(f.right-f.x-200)),
    y:Math.round(f.y+100+(Math.floor(i/cols)+Math.random())/rows*(f.bottom-f.y-200)),
    oreType:8,amount:1,respawnMs:f.respawnMs,pirateField:true
  },false);
}
function apply(world,previous=world.player) {
  const p=world.player;
 if(p?.cloaked&&!p.ultimateCloaked&&!p.dead&&crosses(p.mapId,previous,p))require('./cpu').breakCloak(world);
}
function respawn(mapId,box) {
  const f=FIELDS[mapId];return box.pirateField&&f?{...box,...point(f)}:box;
}
module.exports={FIELDS,contains,crosses,commands,point,populate,apply,respawn};
