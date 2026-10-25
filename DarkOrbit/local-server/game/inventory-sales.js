'use strict';
// Native Flash sell/sellMultiple actions. Never trust a client-supplied price.
const {tx}=require('./db'),META=require('../docs/client-map.items.json').items;
function positive(value){return (typeof value==='number'||typeof value==='string'&&/^\d+$/.test(value))&&Number.isSafeInteger(Number(value))&&Number(value)>0;}
function price(item){
 const pet=require('./pet-catalog').resolve(item),credits=pet?pet.sellCredits:META[item.loot_id]?.sellable?.credits;
 if(!Number.isSafeInteger(credits)||credits<=0)throw Error('Bu eşya satılamaz.');
 return credits;
}
function sell(playerId,request,{multiple=false}={}){
 const ids=multiple?request.items:[request.itemId];
 if(!Array.isArray(ids)||!ids.length||ids.length>10000||ids.some(i=>!positive(i))||new Set(ids.map(Number)).size!==ids.length)throw Error('Geçersiz eşya listesi.');
 if(!multiple&&!positive(request.quantity))throw Error('Geçersiz satış miktarı.');
 const world=require('./world').current(),live=world?.livePlayer(playerId);
 const result=tx(db=>{
  const player=db.prepare('SELECT credits FROM players WHERE id=?').get(playerId);if(!player)throw Error('Oyuncu bulunamadı.');
  const rows=ids.map(id=>{
   const row=db.prepare('SELECT * FROM items WHERE id=? AND player_id=? AND amount>0').get(Number(id),playerId);if(!row)throw Error('Eşya bulunamadı.');
   const count=multiple?row.amount:Number(request.quantity);if(count>row.amount)throw Error('Yeterli eşya yok.');
   if(db.prepare('SELECT 1 FROM assembly_jobs WHERE player_id=? AND target_id=?').get(playerId,row.id))throw Error('İşlemdeki eşya satılamaz; önce geliştirme veya birleştirme işlemini tamamla.');
   return {...row,count,credits:price(row)*count};
  });
  const total=rows.reduce((sum,i)=>sum+i.credits,0),balance=live?.credits??player.credits;
  if(!Number.isSafeInteger(total)||!Number.isSafeInteger(balance+total))throw Error('Satış tutarı sınırı aşıldı.');
  const removed=new Set(rows.filter(i=>i.count===i.amount).map(i=>i.id)),inv=require('./inventory');
  // Match the existing unequip rule: never strand extras beyond a removed CPU.
  for(const ship of db.prepare('SELECT s.id,t.extra_slots FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id WHERE s.player_id=?').all(playerId))for(const config of [1,2]){
   const layout=inv.equipped(db,ship.id,config),remaining=layout.filter(i=>!removed.has(i.id)),extension={'equipment_extra_cpu_sle-01':2,'equipment_extra_cpu_sle-02':4,'equipment_extra_cpu_sle-03':6,'equipment_extra_cpu_sle-04':10},capacity=ship.extra_slots+Math.max(0,...remaining.map(i=>extension[i.loot_id]||0));
   if(layout.some(i=>removed.has(i.id)&&extension[i.loot_id])&&remaining.some(i=>i.slot==='extra'&&i.slot_index>=capacity))throw Error('Önce genişletilmiş yuvalardaki eşyaları çıkar.');
  }
  const affectsEquipment=rows.some(row=>row.ship_id||db.prepare('SELECT 1 FROM equipment_config2 WHERE item_id=? UNION ALL SELECT 1 FROM drone_equipment WHERE item_id=? UNION ALL SELECT 1 FROM pet_equipment WHERE item_id=?').get(row.id,row.id,row.id));
  const update={deleted:[],changed:{}};
  for(const row of rows){
   if(removed.has(row.id)){db.prepare('DELETE FROM items WHERE id=? AND player_id=?').run(row.id,playerId);update.deleted.push(String(row.id));}
   else{const left=row.amount-row.count;db.prepare('UPDATE items SET amount=? WHERE id=? AND player_id=?').run(left,row.id,playerId);update.changed[row.id]={Q:left};}
  }
  db.prepare('UPDATE players SET credits=? WHERE id=?').run(balance+total,playerId);
  return {update,balance:balance+total,affectsEquipment};
 });
 if(live){live.credits=result.balance;try{if(result.affectsEquipment){world.refreshStats();require('./cpu').notify(world);}if(world.combat){const command=require('./assembly').inventoryCommand(playerId);world.broadcast(s=>world.combat.send(s,command));require('./ammo').notify(live);}}catch(error){console.warn('[inventory-sale] committed; refresh failed:',error.message);}}
 return result.update;
}
module.exports={price,sell};
