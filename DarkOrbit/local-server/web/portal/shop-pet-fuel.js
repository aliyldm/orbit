'use strict';
// The captured P.E.T. gear list omitted fuel, although the original shop scripts
// implement isPetFuel, quantity selection and User.Pet depot limits already.
const ID='resource_pet-fuel',ICON='/do_img/global/items/resource/pet-fuel_100x100.png';
function row(source,owned){
 const result=structuredClone(source),price=require('../../docs/client-map.items.json').items[ID].uridium;
 Object.assign(result,{category:'pet',code:'FUEL 100',name:'P.E.T. yakıtı',description:"P.E.T.'in sadece yakıtla çalışır.",price,currency:'real',cost:'0,25 U.',salePrice:null,
  isAmountSetable:true,amountsSelectable:['ten','hundred','thousand','max'],maxAmount:0,isNameSetable:false,isLevelSetable:false,isPetFuel:true,isPetGear:false,isPetProtocol:false,isOwned:false,isPaymentItem:false,notBuyable:!owned,isBuyable:!!owned,
  itemListImageUrl:ICON});
 Object.assign(result.imageVars,{item_name:result.name,item_caption:result.code,price_plain:result.cost,loot_id:ID,imageUrl:ICON});
 return result;
}
function tile(html,item){
 // Reuse the original item markup/styles/hover/selection nodes verbatim.
 const original=html.match(/<div class="item"[^>]*>\s*<div class="itemList_singleItem"[^>]*>\s*<a id="pet_pet10"[\s\S]*?<\/a>\s*<\/div>\s*<div\b[^>]*>[^<]*<\/div>\s*<\/div>/)?.[0];
 if(!original)throw Error('Original P.E.T. shop tile was not found.');
 const fuel=original.replace('id="pet_pet10"',`id="${ID}"`).replace(/\/do_img\/global\/items\/pet\/pet10_100x100\.png(?:\?[^);"\s]*)?/g,ICON).replace(/>P\.E\.T\.-10<\/div>/,`>${item.code}</div>`).replace(/>50\.000 U\.<\/div>/,`>${item.cost}</div>`);
 return html.replace(original,original+fuel);
}
module.exports={ID,ICON,row,tile};
