'use strict';
const lasers=require('../../game/laser-shop'),modern=require('../../game/modern-lasers'),ships=require('./shop-ships');
function populate(rows){
 const template=rows['equipment_weapon_laser_lf-1'];if(!template)throw Error('Original laser row missing');
 for(const id of lasers.IDS){
  const existing=rows[id],r=structuredClone(existing||template),offer=lasers.offer(id),name=lasers.name(id),icon='/client/do_img/global/items/'+id.replaceAll('_','/')+'_100x100.png',cost=Number(offer.price).toLocaleString('tr-TR')+(offer.currency==='virtual'?' C.':' U.');
  Object.assign(r,{category:'weapon',name,code:name,price:offer.price,salePrice:offer.price,currency:offer.currency,cost,localFixedPrice:!!offer.localFixedPrice,localLaserOffer:true,
   maxAmount:1000,isAmountSetable:true,amountsSelectable:['ten','hundred','max'],isWeapon:true,isPaymentItem:false,isActiveEventItem:false,isOwned:false,notBuyable:false,isBuyable:true,saleRemainingTime:0,discountPercent:null,discountTooltipText:null,itemListImageUrl:icon,itemListBackGroundUrl:'/do_img/global/items/bg-'+(offer.currency==='virtual'?'virtual':'real')+'_100x100.jpg'});
  Object.assign(r.imageVars,{loot_id:id,item_name:name,item_caption:'LAZER TOPU',imageUrl:icon,price_plain:cost,elite:offer.currency==='real'?1:0,event_item_enabled:0});
  if(!existing)r.description=modern.describeBundle({items:{[id]:1}});rows[id]=r;
 }
}
function tiles(html,rows){
 const layout=require('./shop-campaigns'),keep=[...html.matchAll(layout.TILE)].filter(t=>!lasers.IDS.includes(t[1])).map(t=>t[0]);
 return layout.replaceTiles(html,lasers.IDS.map(id=>ships.tile(id,rows[id])).concat(keep).join('\n'));
}
module.exports={populate,tiles};
