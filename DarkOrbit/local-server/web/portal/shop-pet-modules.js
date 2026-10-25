'use strict';
// Reuse native shop widgets and retained item assets.
const ID='equipment_petgear_g-hpl1',ICON='/do_img/global/items/equipment/petgear/g-hpl1_100x100.png';
function row(source,owned){
 const result=structuredClone(source);
 Object.assign(result,{category:'petGear',code:'G-HPL1',name:'HP Bağlantı Modülü',description:'20 saniye boyunca gemi gövdesine gelen hasarı P.E.T. karşılar. P.E.T. koruma modunda %25 ek hasar verir. Yakıt tüketimi %35 artar. Bağlantı bittiğinde 240 saniye bekleme süresi başlar.',
 price:1000000,currency:'real',cost:'1.000.000 U.',salePrice:null,isAmountSetable:false,amountsSelectable:[],maxAmount:1,isNameSetable:false,isLevelSetable:false,maxLevel:1,isPetFuel:false,isPetGear:true,isPetProtocol:false,isOwned:false,isPaymentItem:false,notBuyable:!owned,isBuyable:!!owned,itemListImageUrl:ICON});
 Object.assign(result.imageVars,{item_name:result.name,item_caption:result.code,price_plain:result.cost,loot_id:ID,imageUrl:ICON});return result;
}
function tile(html,item){
 const original=html.match(/<div class="item"[^>]*>\s*<div class="itemList_singleItem"[^>]*>\s*<a id="pet_pet10"[\s\S]*?<\/a>\s*<\/div>\s*<div\b[^>]*>[^<]*<\/div>\s*<\/div>/)?.[0];
 if(!original)throw Error('Original P.E.T. shop tile was not found.');
 const moduleTile=original.replace('id="pet_pet10"',`id="${ID}"`).replace(/\/do_img\/global\/items\/pet\/pet10_100x100\.png(?:\?[^);"\s]*)?/g,ICON).replace(/>P\.E\.T\.-10<\/div>/,`>${item.code}</div>`).replace(/>50\.000 U\.<\/div>/,`>${item.cost}</div>`);
 return html.replace(original,original+moduleTile);
}
module.exports={ID,ICON,row,tile};
