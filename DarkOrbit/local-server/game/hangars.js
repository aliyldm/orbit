'use strict';
const {open,tx}=require('./db'),World=require('./world'),inventory=require('./inventory');
const PRICE=250000,MAX_SLOTS=require('../docs/client-map.items.json').items.hangar_slot.maxSlots;
function integer(value,label){if(!/^[1-9]\d*$/.test(String(value))||!Number.isSafeInteger(Number(value)))throw Error('Geçersiz '+label+'.');return Number(value);}
function ensure(db,playerId){
 const p=db.prepare('SELECT * FROM players WHERE id=?').get(playerId);if(!p)throw Error('Oyuncu bulunamadı.');
 db.prepare('INSERT OR IGNORE INTO player_hangar_slots(player_id,slot_no,ship_id)VALUES(?,1,?)').run(playerId,p.active_ship_id);
 db.prepare('INSERT OR IGNORE INTO player_hangar_accounts(player_id)VALUES(?)').run(playerId);return p;
}
function offline(playerId){if(World.current()?.livePlayer(playerId))throw Error('Hangar veya gemi değiştirmek için önce oyundan çık.');}
function state(playerId){
 const db=open(),p=ensure(db,playerId),live=World.current()?.livePlayer(playerId);
 const ships=db.prepare('SELECT s.id,s.loot_id,t.name FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id WHERE s.player_id=? ORDER BY s.id').all(playerId);
 const rows=db.prepare('SELECT * FROM player_hangar_slots WHERE player_id=? ORDER BY slot_no').all(playerId),selectedSlot=db.prepare('SELECT selected_slot FROM player_hangar_accounts WHERE player_id=?').get(playerId).selected_slot;
 const slots=rows.map(s=>({number:s.slot_no,shipId:s.ship_id,shipName:ships.find(x=>x.id===s.ship_id)?.name||null,selected:s.slot_no===selectedSlot,active:s.ship_id===p.active_ship_id}));
 return {price:PRICE,maxSlots:MAX_SLOTS,nextSlot:slots.length<MAX_SLOTS?Math.max(...slots.map(s=>s.number))+1:null,selectedSlot,activeShipId:p.active_ship_id,activeShipName:ships.find(s=>s.id===p.active_ship_id)?.name||'',activeSlot:slots.find(s=>s.active)?.number||null,online:!!live,
  userBalance:{credits:Number(live?.credits??p.credits),uridium:Number(live?.uridium??p.uridium)},slots,
  ships:ships.map((s,index)=>({...s,index,slot:slots.find(x=>x.shipId===s.id)?.number||null})),
  selectedIndex:ships.findIndex(s=>s.id===slots.find(s=>s.selected)?.shipId)};
}
function purchase(playerId,slotNo,requestId){
 slotNo=integer(slotNo,'hangar');if(typeof requestId!=='string'||!/^[a-zA-Z0-9_-]{16,96}$/.test(requestId))throw Error('Geçersiz satın alma kimliği.');
 const live=World.current()?.livePlayer(playerId);
 const outcome=tx(db=>{
  ensure(db,playerId);
  const receipt=db.prepare('SELECT slot_no FROM player_hangar_purchases WHERE player_id=? AND request_id=?').get(playerId,requestId);
  if(receipt){if(receipt.slot_no!==slotNo)throw Error('Bu satın alma kimliği başka bir hangar için kullanıldı.');return {replayed:true};}
  const last=db.prepare('SELECT MAX(slot_no)n,COUNT(*)c FROM player_hangar_slots WHERE player_id=?').get(playerId);
  if(last.c>=MAX_SLOTS)throw Error('Azami hangar sayısına ulaştın.');
  if(slotNo!==last.n+1)throw Error('Hangar listesi değişti; sıradaki hangarı yeniden seç.');
  if(live){if(!Number.isFinite(live.uridium)||live.uridium<0)throw Error('Geçersiz bakiye.');db.prepare('UPDATE players SET uridium=?,credits=? WHERE id=?').run(live.uridium,live.credits,playerId);}
  if(!db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(PRICE,playerId,PRICE).changes)throw Error('Yeterli uridyumun yok. Hangar fiyatı: 250.000 U.');
  const now=Date.now();db.prepare('INSERT INTO player_hangar_slots(player_id,slot_no,purchased_at)VALUES(?,?,?)').run(playerId,slotNo,now);
  db.prepare('INSERT INTO player_hangar_purchases(player_id,request_id,slot_no,price,purchased_at)VALUES(?,?,?,?,?)').run(playerId,requestId,slotNo,PRICE,now);
  return {replayed:false};
 });
 if(live&&!outcome.replayed){live.uridium-=PRICE;World.current()?.broadcast(s=>require('./net').sendCmd(s,{_:'AttributeCreditsUpdateCommand',credits:live.credits,uridium:live.uridium,jackpot:live.jackpot||0}));}
 return {...outcome,state:state(playerId)};
}
function select(playerId,slotNo){
 slotNo=integer(slotNo,'hangar');offline(playerId);
 tx(db=>{ensure(db,playerId);const s=db.prepare('SELECT * FROM player_hangar_slots WHERE player_id=? AND slot_no=?').get(playerId,slotNo);if(!s)throw Error('Bu hangara sahip değilsin.');
  if(s.ship_id)inventory.activate(playerId,s.ship_id);
  db.prepare('UPDATE player_hangar_accounts SET selected_slot=? WHERE player_id=?').run(slotNo,playerId);
 });return state(playerId);
}
function assign(playerId,slotNo,shipId){
 slotNo=integer(slotNo,'hangar');shipId=integer(shipId,'gemi');offline(playerId);
 tx(db=>{ensure(db,playerId);if(!db.prepare('SELECT 1 FROM player_hangar_slots WHERE player_id=? AND slot_no=?').get(playerId,slotNo))throw Error('Bu hangara sahip değilsin.');
  inventory.shipFor(db,playerId,shipId);
  const previous=db.prepare('SELECT slot_no FROM player_hangar_slots WHERE ship_id=?').get(shipId);if(previous&&previous.slot_no!==slotNo)throw Error('Bu gemi başka bir hangara atanmış.');
  db.prepare('UPDATE player_hangar_slots SET ship_id=? WHERE player_id=? AND slot_no=?').run(shipId,playerId,slotNo);
  inventory.activate(playerId,shipId);db.prepare('UPDATE player_hangar_accounts SET selected_slot=? WHERE player_id=?').run(slotNo,playerId);
 });return state(playerId);
}
module.exports={PRICE,MAX_SLOTS,state,purchase,select,assign};
