'use strict';
// Decompiled Rocket2D/Rocket3D and AirstrikeEffect2D/3D timings.
function flightMs(world,attacker,target,rounds=1,airstrike=false){
 const view=world.config.combat?.projectileView;
 // Login supplies the requested renderer; map-ready confirms the actual one
 // (including a Flash 2D fallback). Saving a preference is not a scene reload,
 // so do not read newly saved DB display settings here.
 const renderer=world.rendererMode??[...world.sessions||[]][0]?.rendererMode;
 const twoD=view==='2d'||(view!=='3d'&&(renderer!==undefined?Number(renderer)===2:String(world.config.client?.flashvars?.display2d??'1')==='2'));
 const duration=Math.max(twoD?500:1000,Math.hypot(attacker.x-target.x,attacker.y-target.y)/500*1000);
 return Math.ceil(duration+(airstrike?300+500*Math.max(0,rounds-1)/Math.max(1,rounds):0));
}
module.exports={flightMs};
