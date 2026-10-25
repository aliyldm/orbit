'use strict';
function handle(playerId,params){
 try{
  const action=params.get('action'),bulk=require('../game/upgrade-bulk');
  if(action==='quote')return bulk.quote(playerId,params.get('categories'));
  if(action!=='build')throw Error('Bilinmeyen toplu geliştirme işlemi.');
  const handler=require('../game/handlers/assembly'),previousIds=handler.ids(playerId),result=bulk.build(playerId,params.get('token'));
  if(!result.replayed){
   const world=require('../game/world').current();
   if(world?.livePlayer(playerId))try{handler.refresh(world,result.targets,{previousIds});}catch(error){console.warn('[upgrade-bulk] Committed batch; live refresh deferred:',error.message);}
  }
  return result;
 }catch(error){return{ok:false,message:error.message};}
}
module.exports={handle};
