'use strict';
const shipShop=require('../../game/ship-shop');
const fs=require('node:fs'),path=require('node:path');
const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[c]);
function iconFor(id){
 const base='/do_img/global/items/'+id.replaceAll('_','/');
 const candidates=[base+'_100x100.png',base+'-mmo_100x100.png',base+'/design/'+id.slice(5)+'_100x100.png'];
 const icon=candidates.find(file=>fs.existsSync(path.join(__dirname,'../../client',file)));
 if(!icon)throw Error(`Ship shop icon missing: ${id}`);return '/client'+icon;
}
function row(id,type,template,existing){
 const r=structuredClone(existing||template),name=shipShop.name(id),icon=iconFor(id),offer=shipShop.offer(id),cost=shipShop.priceText(offer);
 Object.assign(r,{category:'ship',code:name,name,price:offer.price,salePrice:offer.price,currency:offer.currency,cost,
  isAmountSetable:false,amountsSelectable:[],maxAmount:1,isPaymentItem:false,isActiveEventItem:false,isServerExclusive:false,
  requiresShipInActiveHangar:false,isOwned:false,isBuyable:true,notBuyable:false,isShip:true,saleRemainingTime:0,discountPercent:null,discountTooltipText:null,
  localFixedPrice:offer.localFixedPrice,localShipOffer:true,itemListImageUrl:icon,itemListBackGroundUrl:'/do_img/global/items/bg-'+offer.currency+'_100x100.jpg'});
 Object.assign(r.imageVars,{loot_id:id,item_name:name,item_caption:name,price_plain:cost,imageUrl:icon,elite:offer.currency==='real'?1:0,event_item_enabled:0,serverExclusive:0,inuse:0,in_use_plain:''});
 if(!existing){
  const stats=[['Hız',type.speed],['Kargo',type.cargo],['Lazer',type.laser_slots],['Jeneratörler',type.generator_slots],['Darbe Puanı',type.hitpoints],['Ekstralar',type.extra_slots]];
  r.description=`<table id="shipDetails">${stats.map(([label,value],i)=>`<tr class="${i%2?'even':'odd'}"><td class="label">${esc(label)}</td><td class="firstColumn">${Number(value).toLocaleString('tr-TR')}</td></tr>`).join('')}</table>`;
 }
 return r;
}
function populate(rows,db){
 const template=rows.ship_pusat||Object.values(rows).find(r=>r.isShip);if(!template)throw Error('Original ship shop row missing');
 for(const id of shipShop.IDS){const type=db.prepare('SELECT * FROM ship_types WHERE loot_id=?').get(id);if(!type)throw Error(`Ship catalog missing ${id}`);rows[id]=row(id,type,template,rows[id]);}
}
function tile(id,r){
 return `<div class="item" style="background-image:url(${esc(r.itemListBackGroundUrl)})"><div class="itemList_singleItem" style="background-image:url(${esc(r.itemListImageUrl)})"><a id="${esc(id)}" href="javascript:void(0);"><div class="item_borders"><div class="item_hover"></div><div class="item_active"></div><div class="sale_active"></div><div class="localShipName">${esc(r.name)}</div></div></a></div><div style="height:13px;text-align:center;width:94px;margin:-16px 3px 3px;overflow:hidden;font:10px Verdana,Arial,sans-serif;color:#537c9c;background:#0a131a">${esc(r.cost)}</div></div>`;
}
function tiles(html,rows){
 const content=shipShop.IDS.map(id=>tile(id,rows[id])).join('\n');
 return require('./shop-campaigns').replaceTiles(html,content);
}
module.exports={row,populate,tiles,iconFor,tile};
