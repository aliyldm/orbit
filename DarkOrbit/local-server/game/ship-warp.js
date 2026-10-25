'use strict';
const {open,tx}=require('./db'),maps=require('./maps'),players=require('./db/players');
const CAST_MS=10000,PRICE=200;
function send(s,c){(s.world.combat?.send||require('./net').sendCmd)(s,c);}
function visual(s,id,on,attribute=0){send(s,{_:'VisualModifierCommand',userId:s.player.userId,modifier:id,attribute,additionalAttribute:'',count:0,activated:on});}
function allowedMap(id){return !!require('./normal-map-layout').getMap(id);}
function targets(p,db=open()){
 return db.prepare(`SELECT s.*,t.name,h.slot_no FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id
 LEFT JOIN player_hangar_slots h ON h.ship_id=s.id AND h.player_id=s.player_id
 WHERE s.player_id=? AND s.id<>? AND s.favorite=1 AND s.hitpoints>0 ORDER BY COALESCE(h.slot_no,2147483647),s.id LIMIT 10`).all(p.userId,p.shipId);
}
function ready(s){const w=s.world,p=w.player;return w.active(s)&&!p.dead&&!s.jumping&&!s.cpuJump&&!s.shipWarp&&!s.attacking&&!w.movement&&allowedMap(p.mapId)&&Date.now()-(p.lastCombat||0)>=10000;}
function windowCommand(w){
 const p=w.player,near=maps.nearStation(w),voucher=require('./jump-cpu').voucherCount(p);
 return{_:'ShipWarpWindowCommand',jumpVoucherCount:voucher,uridium:p.uridium,isNearSpacestation:near,
  ships:targets(p).map(ship=>({_:'ShipWarpModule',shipId:ship.id,typeId:require('./inventory').shipAppearance(open(),ship),shipDesignName:ship.name,
   uridiumPrice:near?0:PRICE,voucherPrice:near?0:1,hangarId:ship.slot_no||ship.id,hangarName:ship.slot_no?'Hangar '+ship.slot_no:ship.name,mapId:p.mapId}))};
}
function show(s){if(!s.world.active(s)||s.player.dead)return false;send(s,windowCommand(s.world));return true;}
function cancel(s,notify=true){
 const job=s.shipWarp;if(!job)return false;s.shipWarp=null;
 if(job.timer){clearTimeout(job.timer);s.world.scheduled?.delete(job.timer);}
 if(notify&&s.world.active(s)){visual(s,46,false);visual(s,72,false);send(s,{_:'ShipWarpCanceledCommand'});send(s,{_:'LegacyModule',message:'0|A|STD|Gemi değiştirme iptal edildi; ücret alınmadı.'});}return true;
}
function validJob(s,job){
 const w=s.world,p=w.updatePosition();return w.active(s)&&p===job.player&&!p.dead&&!s.jumping&&!s.cpuJump&&!s.attacking&&!w.movement&&p.shipId===job.fromShip&&p.mapId===job.map&&maps.dist(p,job)<=1&&(p.lastCombat||0)<=job.combat&&targets(p).some(row=>row.id===job.shipId);
}
function complete(s,job){
 if(s.shipWarp!==job)return false;
 if(!validJob(s,job)){cancel(s);return false;}
 const w=s.world,p=w.player,near=maps.nearStation(w);let fresh,cost=0;
 try{tx(db=>{
  players.savePlayer(p);
  if(!near){
   const voucher=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id LIMIT 1').get(p.userId,require('./jump-cpu').VOUCHER);
   if(voucher)db.prepare('UPDATE items SET amount=amount-1 WHERE id=? AND amount>0').run(voucher.id);
   else{cost=PRICE;if(!db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(cost,p.userId,cost).changes)throw Error('Yetersiz Uridyum.');}
  }
  if(!targets(p,db).some(row=>row.id===job.shipId))throw Error('Gemi artık değiştirilebilir değil.');
  db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(job.shipId,p.userId);
  fresh=players.loadPlayer(p.userId);
 });}catch(error){cancel(s);send(s,{_:'LegacyModule',message:'0|A|STD|'+error.message});return false;}
 s.shipWarp=null;if(job.timer){clearTimeout(job.timer);w.scheduled?.delete(job.timer);}
 visual(s,46,false);visual(s,72,false);
 require('./pet').stop(w,{notify:true,resume:true});w.combat?.stop();
 // Keep the authenticated player object: session ownership and its wallet must
 // not be replaced with a second independently saved instance.
 Object.assign(p,fresh,{dead:false,repairing:false});
 delete p.ammoMultiplier;delete p.nextRocket;delete p.nextLaserAt;delete p.nextRsb;
 require('./cpu').breakCloak(w);
 send(s,{_:'ShipWarpCompletedCommand',currentShipLootId:p.typeId});
 require('./gameplay').changeMap(s,p.mapId,p.x,p.y);
 visual(s,22,true);
 return true;
}
function begin(s,id){
 const w=s.world,p=w.updatePosition();
 if(!Number.isSafeInteger(id)||!ready(s)||!targets(p).some(row=>row.id===id)){
  send(s,{_:'ShipWarpNotAllowedCommand'});send(s,{_:'LegacyModule',message:'0|A|STD|Gemi değiştirmek için hareketsiz ve savaş dışında olmalısın; favori, sağlam bir gemi seç.'});return false;
 }
 if(!maps.nearStation(w)&&require('./jump-cpu').voucherCount(p)<1&&p.uridium<PRICE){send(s,{_:'LegacyModule',message:'0|A|STD|Gemi değiştirmek için 1 atlama kuponu veya 200 Uridyum gerekli.'});return false;}
 const job={player:p,shipId:id,fromShip:p.shipId,map:p.mapId,x:p.x,y:p.y,combat:p.lastCombat||0};s.shipWarp=job;
 send(s,{_:'ShipWarpWindowCloseCommand'});visual(s,46,true);visual(s,72,true,CAST_MS/1000);
 job.timer=w.schedule(()=>complete(s,job),CAST_MS);return true;
}
function tick(w){for(const s of w.sessions){const job=s.shipWarp;if(job&&!validJob(s,job))cancel(s);}}
function register(onCmd){onCmd('ShipWarpRequest',(s,r)=>begin(s,r.shipId));}
module.exports={CAST_MS,PRICE,targets,ready,windowCommand,show,begin,cancel,complete,tick,register};
