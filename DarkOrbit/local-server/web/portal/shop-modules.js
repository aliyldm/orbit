'use strict';
// Keep the captured Extras selection, preview and amount controls for both
// local crafting currencies. Definitions are shared with the purchase server.
const SOURCE='equipment_extra_cpu_ajp-01';
function definitions(){return require('../../game/module-policy').DEFINITIONS;}
function row(template,definition){
 const r=structuredClone(template),cost=definition.price.toLocaleString('tr-TR')+' U.';
 Object.assign(r,{code:definition.name,name:definition.name,description:definition.description,price:definition.price,salePrice:definition.price,currency:'real',cost,
  isAmountSetable:true,amountsSelectable:['ten','hundred','thousand','max'],maxAmount:10000000,isConsumingCargoSpace:false,isPaymentItem:false,isActiveEventItem:false,isBuyable:true,notBuyable:false,itemListImageUrl:definition.icon});
 Object.assign(r.imageVars,{loot_id:definition.id,item_name:r.name,item_caption:definition.name,price_plain:cost,imageUrl:definition.icon});
 return r;
}
function tiles(html){
 const pattern=new RegExp('<div class="item"[^>]*>\\s*<div class="itemList_singleItem"[^>]*>\\s*<a id="'+SOURCE+'"[\\s\\S]*?<\\/a>\\s*<\\/div>\\s*<div\\b[^>]*>[^<]*<\\/div>\\s*<\\/div>');
 const original=html.match(pattern)?.[0];if(!original)throw Error('Original Extras tile missing');
 const copies=definitions().map(d=>original.replace('id="'+SOURCE+'"','id="'+d.id+'"')
  .replace(/\/do_img\/global\/items\/equipment\/extra\/cpu\/ajp-01_100x100\.png(?:\?[^);"\s]*)?/g,d.icon)
  .replace(/>AJP01-CPU<\/div>/,'>'+d.name+'</div>')
  .replace(/>75\.000 U\.<\/div>/,'>'+d.price.toLocaleString('tr-TR')+' U.</div>'));
 return html.replace(original,copies.join('')+original);
}
module.exports={SOURCE,definitions,row,tiles};
