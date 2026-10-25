'use strict';
const capture={...require('../docs/pet-shop-levels.json').items,
 'equipment_petgear_g-hpl1':{name:'HP Bağlantı Modülü',category:'petGear',levels:{1:{price:1000000,currency:'real'}}}};
const catalog=require('./pet-catalog');
// Level4 effects are present in the retained client. Their special-sale
// availability uses the user's existing fixed1mUridium local economy rule.
for(const [id,row]of Object.entries(capture))if(catalog.protocol(id,4)?.supported)
 capture[id]={...row,levels:{...row.levels,4:{price:1000000,currency:'real',localFixedPrice:true}}};
function offers(){return Object.fromEntries(Object.entries(capture).map(([id,row])=>[id,{name:row.name,category:row.category,price:row.levels[1].price,currency:row.levels[1].currency,isPaymentItem:false,levels:row.levels}]));}
function quote(playerId,id,value,db){
 const entry=capture[id];if(!entry)return null;
 const level=value===undefined||value===null||value===''?1:Number(value);
 if(!Number.isInteger(level)||!entry.levels[level])throw new Error('Geçersiz P.E.T. modül kademesi.');
 const pet=db.prepare('SELECT level FROM pets WHERE player_id=?').get(playerId);
 if(!pet||!catalog.canEquip({loot_id:id,pet_level:level},pet.level))throw new Error('Bu kademe için P.E.T. seviyesi yetersiz.');
 return {...entry.levels[level],level};
}
module.exports={offers,quote};
