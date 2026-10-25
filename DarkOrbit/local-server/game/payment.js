'use strict';
// Payment is a local fixed-price currency shop. Captured IDs are retained;
// unknown package contents never turn into an arbitrary icon-item purchase.
const fs=require('fs'),path=require('path');
const META=require('../docs/client-map.items.json').items;
const {recipes}=require('./payment-bundles');
const PRICE=1000000,PRICE_TEXT='1.000.000 U.';
const captures={};
for(const filename of fs.readdirSync(path.join(__dirname,'../web/portal/pages')).sort()){
 const html=fs.readFileSync(path.join(__dirname,'../web/portal/pages',filename),'utf8');
 const match=/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/.exec(html);if(!match)continue;
 for(const [sku,row]of Object.entries(JSON.parse(match[1])))if(row.isPaymentItem){
  if(captures[sku])throw Error(`Duplicate captured payment SKU: ${sku}`);
  let contents=recipes[sku];
  // A native ship model or the HM7 is a single product. Explicit lootItems
  // describe whole packages; an imageVars loot_id alone generally does not.
  if(!contents&&row.lootItems){try{const ids=JSON.parse(row.lootItems);if(Array.isArray(ids)&&ids.length&&ids.every(id=>typeof id==='string'&&META[id]))contents={items:ids.reduce((a,id)=>(a[id]=(a[id]||0)+1,a),{})};}catch{/* missing manifest stays disabled */}}
  if(!contents&&(row.isShipModel||sku==='equipment_extra_hmd-07'))contents={items:{[row.imageVars.loot_id]:1}};
  captures[sku]={sku,name:row.name,category:['droneDesign','petDesign','fullSet','shipDesign'].includes(row.category)?'customization':row.category,
   imageLootId:row.imageVars?.loot_id,imageUrl:row.itemListImageUrl,source:`web/portal/pages/${filename}`,description:row.description,contents:contents||null};
 }
}
// Only true one-item offers may have a canonical alias. Existing normal shop
// products keep their price (e.g. blue/red keys); shared package icons cannot.
const aliases={};
for(const entry of Object.values(captures)){
 const entries=Object.entries(entry.contents?.items||{});
 if(entries.length===1&&entries[0][1]===1&&!entry.contents.unresolved?.length&&!entry.contents.uridium&&entries[0][0]===entry.imageLootId)
  (aliases[entry.imageLootId]??=[]).push(entry.sku);
}
function entry(id){return captures[id]||null;}
function maxAmount(record){
 const reward=record?.contents;if(!reward||reward.once)return 1;
 let maximum=1000;
 for(const [id,n]of Object.entries(reward.items||{})){
  const item=META[id];
  if(!item||item.kind==='Ship'||item.kind==='Drone'||id==='pet_pet10'||item.maxQuantity===1||/CustomizationType$|DroneDesignType$|ShipDesignType$/.test(item.typeClass||''))return 1;
  maximum=Math.min(maximum,Math.floor(2147483647/n));
  if(!item.stackable&&item.kind!=='Ammunition'&&item.kind!=='Booster'&&!id.startsWith('resource_ore_'))maximum=Math.min(maximum,Math.floor(1000/n));
 }
 return Math.max(1,maximum);
}
function multiply(record,amount){
 if(!Number.isSafeInteger(amount)||amount<1||amount>maxAmount(record))throw Error('Bu ürün için geçersiz satın alma miktarı.');
 const contents={...record.contents,items:Object.fromEntries(Object.entries(record.contents.items||{}).map(([id,n])=>[id,n*amount]))};
 if(contents.boosterHours)contents.boosterHours=Object.fromEntries(Object.entries(contents.boosterHours).map(([id,h])=>[id,h*amount]));
 for(const key of ['uridium','credits','ep','energy'])if(contents[key])contents[key]*=amount;
 return {...record,contents};
}
function reason(record,db){
 if(!record?.contents)return 'Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı.';
 const reward=record.contents;
 if(reward.unresolved?.length)return `Paket bileşenleri istemci kataloğunda doğrulanamadı: ${reward.unresolved.join(', ')}.`;
 if(!Object.keys(reward.items||{}).length&&!Object.keys(reward.boosterHours||{}).length&&!reward.uridium&&!reward.credits&&!reward.ep&&!reward.energy)return 'Paket içeriği boş.';
 for(const [id,hours]of Object.entries(reward.boosterHours||{})){
  if(META[id]?.kind!=='Booster'||!Number.isFinite(hours)||hours<=0||hours>1000000)return `Geçersiz destek süresi: ${id}.`;
  const why=require('./boosters').unsupportedReason(id);if(why)return why;
 }
 for(const [id,n]of Object.entries(reward.items||{})){
  const m=META[id];if(!m||!Number.isSafeInteger(n)||n<1||n>2147483647)return `Geçersiz paket bileşeni: ${id}.`;
  if(m.kind==='Booster'){const why=require('./boosters').unsupportedReason(id);if(why)return why;}
  if(db&&!m.typeClass?.endsWith('.ShipDesignType')&&m.kind!=='Ship'&&!db.prepare('SELECT 1 FROM item_types WHERE loot_id=?').get(id))return `Ürün katalogda bulunamadı: ${id}.`;
  if(db&&m.kind==='Ship'&&!m.typeClass?.endsWith('.ShipDesignType')&&!db.prepare('SELECT 1 FROM ship_types WHERE loot_id=?').get(id))return `Gemi katalogda bulunamadı: ${id}.`;
 }
 for(const field of ['uridium','credits','ep','energy'])if(reward[field]!==undefined&&(!Number.isSafeInteger(reward[field])||reward[field]<0||reward[field]>2147483647))return 'Geçersiz paket ödülü.';
 return null;
}
function purchaseReason(record,db,playerId){
 const sales=require('./laser-sales').recordReason(record);if(sales)return sales;
 const why=reason(record,db);if(why)return why;
 if(record.contents.once&&db.prepare('SELECT 1 FROM payment_purchase_receipts WHERE player_id=? AND sku=?').get(playerId,record.sku))return 'Bu paket hesap başına yalnızca bir kez satın alınabilir; bu hesapta zaten alındı.';
 return null;
}
function applyOffers(offers){
 for(const r of Object.values(captures))offers[r.sku]={name:r.name,category:r.category,price:PRICE,currency:'real',isPaymentItem:false,localPayment:true,paymentSku:r.sku,maxAmount:maxAmount(r),disabledReason:reason(r),page:r.source.slice('web/portal/pages/'.length,-5)};
 for(const [id,skus]of Object.entries(aliases))if(!offers[id]&&skus.length===1)offers[id]={...offers[skus[0]],paymentAlias:true};
 return offers;
}
function rewriteRow(row,sku){
 const r=entry(sku);if(!r)return row;
 const maximum=maxAmount(r),unavailable=reason(r)||require('./laser-sales').recordReason(r);
 Object.assign(row,{price:PRICE,currency:'real',cost:PRICE_TEXT,salePrice:PRICE,saleRemainingTime:0,discountPercent:1,discountTooltipText:null,isPaymentItem:false,paymentUrl:'',localPayment:true,isAmountSetable:maximum>1,maxAmount:maximum,amountsSelectable:maximum>1?['ten','hundred','thousand','max']:[],isActiveEventItem:false,notBuyable:!!unavailable,isBuyable:!unavailable});
 row.imageVars={...row.imageVars,price_plain:PRICE_TEXT,event_item_enabled:0};
 row.description+=require('./modern-lasers').describeBundle(r.contents);
 if(row.notBuyable)row.description+=`<br /><br /><b>Yerel durum:</b> ${unavailable}`;
 else if(Object.keys(r.contents.items||{}).some(id=>/gold-pass|vip-badge|season-pass/.test(id)))row.description+='<br /><br /><b>Yerel durum:</b> Bileti Sezon ve Biletler sayfasında etkinleştir; sezon puanları ve ödül yolları kullanılabilir. Trinity/Voyagers ilerlemesi klasik kapılar üzerinden yerel uyarlamadır.';
 return row;
}
const ORES=['prometium','endurium','terbium','xenomit','prometid','duranium','promerium','seprom','palladium'];
function fulfil(db,playerId,record){
 const why=reason(record,db);if(why)throw Error(why);
 for(const [id,n]of Object.entries(record.contents.items||{})){
  const m=META[id];
  if(m.typeClass?.endsWith('.ShipDesignType')){if(n!==1)throw Error('Geçersiz tasarım miktarı.');require('./inventory').addDesign(db,playerId,id);}
  else if(m.kind==='Ship'){if(n!==1)throw Error('Geçersiz gemi miktarı.');const t=db.prepare('SELECT * FROM ship_types WHERE loot_id=?').get(id);db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,?)').run(playerId,id,t.hitpoints);}
  else if(m.kind==='Booster')require('./boosters').addOwned(db,playerId,id,n);
  else if(m.kind==='Drone')for(let i=0;i<n;i++)require('./drones').addOwned(db,playerId,id);
  else if(id==='pet_pet10')require('./pet').addOwned(db,playerId,n);
  else if(id==='resource_pet-fuel')require('./pet').addFuel(db,playerId,n);
  else if(id.startsWith('resource_ore_')&&ORES.includes(id.slice(13))){
   const type=ORES.indexOf(id.slice(13)),owned=db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=?').get(playerId,type)?.amount||0;
   if(owned+n>2147483647)throw Error('Maden kapasitesi aşıldı.');
   db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=amount+excluded.amount').run(playerId,type,n);
  }else {
   require('./loot-rewards').item(db,playerId,id,n);
   if(record.contents.petLevels?.[id])db.prepare('UPDATE items SET pet_level=? WHERE id IN(SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL ORDER BY id DESC LIMIT ?)').run(record.contents.petLevels[id],playerId,id,n);
  }
 }
 const reward=record.contents;
 for(const [id,hours]of Object.entries(reward.boosterHours||{}))require('./boosters').addOwned(db,playerId,id,1,{hours});
 db.prepare('UPDATE players SET credits=credits+?,uridium=uridium+?,ep=ep+? WHERE id=?').run(reward.credits||0,reward.uridium||0,reward.ep||0,playerId);
 if(reward.ep){const p=db.prepare('SELECT level,ep FROM players WHERE id=?').get(playerId);db.prepare('UPDATE players SET level=? WHERE id=?').run(Math.max(p.level,require('./progression').levelFor(p.ep)),playerId);}
 if(reward.energy){db.prepare('INSERT OR IGNORE INTO galaxy_gate_accounts(player_id)VALUES(?)').run(playerId);if(!db.prepare('UPDATE galaxy_gate_accounts SET energy=energy+? WHERE player_id=? AND energy<=?').run(reward.energy,playerId,2147483647-reward.energy).changes)throw Error('Ekstra enerji kapasitesi aşıldı.');}
 return record.contents;
}
// The historical portal applies the account discount to the selected item.
// Wrap its getter only for the fixed local-price rows; ordinary offers retain it.
const portalScript='<script id="local_payment_price">(function(){if(typeof User==="undefined"||typeof Shop==="undefined")return;var base=User.getDiscountFactor;User.getDiscountFactor=function(){var r=Shop.Parameters&&Shop.Parameters.itemData&&Shop.Item&&Shop.Parameters.itemData[Shop.Item.getId()],l=Shop.LevelSelector&&Shop.LevelSelector.getSelectedLevel&&Shop.LevelSelector.getSelectedLevel(),v=r&&r.levelItemShopData&&r.levelItemShopData[l];return r&&(r.localPayment||r.localFixedPrice||v&&v.localFixedPrice)?1:base.apply(this,arguments);};})();</script>';
const escape=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[c]);
function renderCatalog(player){
 const db=require('./db').open();
 const cards=Object.values(captures).map(r=>{
  const why=purchaseReason(r,db,player.userId),description=r.description.replace(/<br\s*\/?\s*>/gi,' ').replace(/<[^>]*>/g,'');
  return `<article><img src="${escape(r.imageUrl||'')}" alt=""><h2>${escape(r.name)}</h2><p>${escape(description)}</p><strong>${PRICE_TEXT}</strong>${why?`<p class="pending">${escape(why)}</p>`:''}<button data-sku="${escape(r.sku)}" data-category="${escape(r.category)}"${why?' disabled':''}>Satın al</button><output></output></article>`;
 }).join('');
 return `<!doctype html><html lang="tr"><meta charset="utf-8"><title>Yerel Uridyum Dükkânı</title><meta name="viewport" content="width=device-width,initial-scale=1"><style>body{margin:0;background:#06121b;color:#c7dfed;font:14px Arial}header{position:sticky;top:0;background:#102b3c;padding:18px 24px;border-bottom:1px solid #39708a;z-index:1}a{color:#92d8ff;margin-right:20px}h1{font-size:21px;margin:12px 0}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:16px;padding:24px}article{background:#10232e;border:1px solid #274858;border-radius:8px;padding:16px;display:flex;flex-direction:column}article img{width:100px;height:100px;object-fit:contain;align-self:center}h2{font-size:17px}p{line-height:1.5}.pending{color:#dcb179}strong{margin-top:auto;color:#8bdfff}button{margin-top:12px;padding:11px;background:#277747;border:0;border-radius:4px;color:white;cursor:pointer}button:disabled{background:#43505a;cursor:default}output{margin-top:10px;line-height:1.4}</style><header><a href="/indexInternal.es?action=internalStart">Ana sayfa</a><a href="/indexInternal.es?action=internalDock">Dükkân</a><a href="/indexInternal.es?action=internalHangar">Hangar</a><a href="/indexInternal.es?action=internalPaymentEvents">Sezon ve Biletler</a><h1>Yerel Uridyum Dükkânı</h1><span id="balance">${Math.floor(player.uridium).toLocaleString('tr-TR')} U.</span><p>Her teklif 1.000.000 Uridyumdur. Aldığın biletleri Sezon ve Biletler sayfasında etkinleştir; puanlarını kullanıp açılan ödülleri al. Özgün Trinity/Voyagers haritaları yerine klasik kapı ilerlemesi sunan yerel uyarlama bulunur.</p></header><main>${cards}</main><script>document.querySelectorAll('button[data-sku]').forEach(function(button){button.addEventListener('click',async function(){var output=button.parentNode.querySelector('output');button.disabled=true;try{var response=await fetch('/ajax/shop.php',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:new URLSearchParams({action:'purchase',itemId:button.dataset.sku,category:button.dataset.category,amount:'1'})});var result=await response.json();output.textContent=result.message;if(result.userBalance)document.getElementById('balance').textContent=Math.floor(result.userBalance.uridium).toLocaleString('tr-TR')+' U.';}catch(error){output.textContent='Satın alma yanıtı alınamadı. Bakiyeni ve envanterini kontrol et.';}finally{button.disabled=false;}});});</script></html>`;
}
module.exports={PRICE,PRICE_TEXT,captures,aliases,entry,maxAmount,multiply,reason,purchaseReason,applyOffers,rewriteRow,fulfil,portalScript,renderCatalog};
