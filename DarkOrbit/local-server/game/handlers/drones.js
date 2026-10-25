'use strict';
const drones=require('../drones');
function register(onCmd,{sendCmd}) {
 onCmd('HangarShipRepairDroneRequest',(s,c)=>{
  if(!s.player)return;
  let resultId=0;try{drones.repair(s.player.userId,c.droneId);resultId=1;}catch(e){console.warn(`[drones] ${e.message}`);}
  const d=drones.views(s.player.userId).find(d=>d.droneId===c.droneId);
  sendCmd(s,{_: 'HangarShipRepairDroneCommand',resultId,droneId:c.droneId,damage:d?.damage||0,level:d?.level||0,weaponEffect:0,shildEffect:0,drones:drones.views(s.player.userId),errorMessage:null});
 });
 onCmd('HangarShipSellDroneRequest',(s,c)=>{
  if(!s.player)return;
  let resultId=0;try{drones.sell(s.player.userId,c.droneId);resultId=1;}catch(e){console.warn(`[drones] ${e.message}`);}
  sendCmd(s,{_: 'HangarShipSellDroneCommand',resultId,drones:drones.views(s.player.userId),errorMessage:null});
  if(resultId)for(const cmd of drones.buildCommands(s.player))sendCmd(s,cmd);
 });
}
module.exports={register};
