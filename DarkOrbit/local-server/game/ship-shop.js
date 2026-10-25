'use strict';
// Only Plus hulls receive the user's 500k override. Keep ordinary captured
// Credit/Uridium prices and the earlier 1m local rule for non-shop specials.
const fs=require('node:fs'),path=require('node:path');
const PRICE=500000,PRICE_TEXT='500.000 U.';
const ajax=JSON.parse(fs.readFileSync(path.join(__dirname,'../web/portal/ajax.json'),'utf8'));
const roster=JSON.parse(Buffer.from(ajax['/flashAPI/inventory.php|getHangarList'].body,'base64').toString('utf8')).data.ret.shipInfo;
const IDS=Object.freeze([...new Set(roster.map(s=>s.lootId))]),members=new Set(IDS);
const PLUS_IDS=Object.freeze(IDS.filter(id=>id.endsWith('-plus'))),plusMembers=new Set(PLUS_IDS);
const captured=JSON.parse(fs.readFileSync(path.join(__dirname,'../web/portal/shop.json'),'utf8'));
const META=require('../docs/client-map.items.json').items;
for(const id of IDS)if(META[id]?.kind!=='Ship')throw Error(`Invalid hangar ship: ${id}`);
function name(id){return captured[id]?.name||id.slice(5).split('-').map(word=>word[0].toUpperCase()+word.slice(1)).join(' ');}
function has(id){return members.has(id);}
function isPlus(id){return plusMembers.has(id);}
function offer(id){
 if(!has(id))throw Error(`Unknown hangar ship: ${id}`);
 const original=captured[id],native=roster.find(row=>row.lootId===id).price;
 const base={name:name(id),category:'ship',isPaymentItem:false,localShipOffer:true};
 if(isPlus(id))return {...base,price:PRICE,currency:'real',localFixedPrice:true};
 if(original&&!original.isPaymentItem)return {...original,...base,localFixedPrice:false};
 if(!native.isPayment&&(native.credits>0||native.uridium>0||id==='ship_phoenix'))return {...base,price:native.credits||native.uridium,currency:native.credits>0?'virtual':native.uridium>0?'real':'virtual',localFixedPrice:false};
 return {...base,price:1000000,currency:'real',localFixedPrice:true};
}
function priceText(row){return Number(row.price).toLocaleString('tr-TR')+(row.currency==='virtual'?' C.':' U.');}
function offers(){return Object.fromEntries(IDS.map(id=>[id,offer(id)]));}
function decorateHangar(ret){for(const row of ret.shipInfo)if(has(row.lootId)){const o=offer(row.lootId);Object.assign(row,{price:{uridium:o.currency==='real'?o.price:0,credits:o.currency==='virtual'?o.price:0,isPayment:0},eventItem:0,eventActive:0});}return ret;}
module.exports={IDS,PLUS_IDS,PRICE,PRICE_TEXT,has,isPlus,name,offer,priceText,offers,decorateHangar};
