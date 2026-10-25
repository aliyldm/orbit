'use strict';
function row(source,offer){
 if(!offer)return null;const out=structuredClone(source),icon='/do_img/global/items/pet/pet10_100x100.png';
 Object.assign(out,{category:'petGear',code:'HP +10.000',name:offer.name,description:`${offer.level}. can kapasitesi geliştirmesi: P.E.T. azami darbe puanına 10.000 ekler. Canı otomatik doldurmaz. Kademeler sırayla alınır.`,price:offer.price,cost:offer.price.toLocaleString('tr-TR')+' U.',currency:'real',salePrice:null,isAmountSetable:false,amountsSelectable:[],maxAmount:1,isNameSetable:false,isLevelSetable:false,maxLevel:1,isPetFuel:false,isPetGear:false,isPetProtocol:false,isOwned:false,isPaymentItem:false,notBuyable:false,isBuyable:true,itemListImageUrl:icon});
 Object.assign(out.imageVars,{item_name:out.name,item_caption:out.code,price_plain:out.cost,loot_id:offer.id,imageUrl:icon});return out;
}
function tile(html,item){
 if(!item)return html;
 const original=html.match(/<div class="item"[^>]*>\s*<div class="itemList_singleItem"[^>]*>\s*<a id="pet_pet10"[\s\S]*?<\/a>\s*<\/div>\s*<div\b[^>]*>[^<]*<\/div>\s*<\/div>/)?.[0];
 if(!original)throw Error('Original P.E.T. shop tile missing.');
 return html.replace(original,original+original.replace('id="pet_pet10"',`id="${item.imageVars.loot_id}"`).replace(/>P\.E\.T\.-10<\/div>/,`>${item.code}</div>`).replace(/>50\.000 U\.<\/div>/,`>${item.cost}</div>`));
}
module.exports={row,tile};
