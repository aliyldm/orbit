'use strict';
const {open,tx}=require('./db');
// Exact choices from inventory.swf PopUp.createAutoBuy*Components.
const CHOICES={
 'equipment_extra_cpu_alb-x':['lcb-10','mcb-25','mcb-50','sab-50'].map(x=>'ammunition_laser_'+x),
 'equipment_extra_cpu_rb-x':[...['r-310','plt-2026','plt-2021','plt-3030'].map(x=>'ammunition_rocket_'+x),'ammunition_rocketlauncher_eco-10']
};
function key(id){return 'cpu.ammo.'+id;}
function selected(playerId,item,db=open()){
 const choices=CHOICES[item?.loot_id];if(!choices)return null;
 const row=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(playerId,key(item.id));return choices.includes(row?.value)?row.value:choices[0];
}
function properties(playerId,item){const ammo=selected(playerId,item);return ammo?{properties:{attachedAmmo:ammo}}:{};}
function select(playerId,request){
 const id=Number(request.itemId);if(!Number.isSafeInteger(id)||id<1)throw Error('Geçersiz CPU kimliği.');
 return tx(db=>{
  const item=db.prepare('SELECT id,loot_id FROM items WHERE id=? AND player_id=? AND amount>0').get(id,playerId),choices=CHOICES[item?.loot_id];
  if(!choices||!choices.includes(request.ammo))throw Error('Bu CPU için geçersiz cephane.');
  db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(playerId,key(id),request.ammo);return 1;
 });
}
module.exports={CHOICES,selected,properties,select};
