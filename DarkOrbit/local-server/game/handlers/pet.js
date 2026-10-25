'use strict';
const pet=require('../pet');
function register(onCmd,{sendCmd}){
 const active=s=>s.player&&s.world.active(s);
 const run=(s,fn)=>{if(!active(s))return;s.world.petSend=sendCmd;try{return fn(s.world);}catch(e){console.warn('[pet]',e.message);try{pet.sync(s.world);}catch(syncError){console.warn('[pet] state refresh:',syncError.message);}return false;}};
 onCmd('PetRequest',(s,c)=>run(s,w=>{switch(c.petRequestType){case 0:return pet.launch(w);case 1:return pet.stop(w);case 2:return w.petRuntime?.active?pet.stop(w):pet.launch(w);case 3:if(!w.petRuntime?.active&&!pet.launch(w))return false;return pet.selectGear(w,2);case 4:return pet.repair(w);case 5:return pet.selectGear(w,11);case 6:return pet.buyFuel(w);default:return false;}}));
 onCmd('PetGearActivationRequest',(s,c)=>run(s,w=>pet.selectGear(w,c.gearTypeToActivate?.typeValue,[6,7].includes(c.gearTypeToActivate?.typeValue)?c.optParam:undefined)));
 onCmd('HangarShipRenamePetRequest',(s,c)=>{const ok=run(s,w=>pet.rename(w,c.name));sendCmd(s,{_:'HangarShipRenamePetCommand',resultId:ok?1:0,newName:ok?c.name.trim():'',errorMessage:null});});
}
module.exports={register};
