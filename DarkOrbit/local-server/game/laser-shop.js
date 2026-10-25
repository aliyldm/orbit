'use strict';
const META=require('../docs/client-map.items.json').items,original=require('../web/portal/shop.json');
const IDS=Object.freeze(Object.keys(META).filter(id=>META[id].typeClass?.endsWith('.LaserType')&&!require('./equipment-policy').removed(id)));
function name(id){const details=require('./modern-lasers').details(id),slug=id.slice('equipment_weapon_laser_'.length);return original[id]?.name||(/^[A-Z0-9_]+$/.test(details.name)?slug.toUpperCase():details.name);}
function offer(id){
 if(original[id]&&!original[id].isPaymentItem)return {...original[id],localLaserOffer:true};
 const m=META[id],credit=Number.isFinite(m.credits)&&m.credits>0&&m.credits<4294967295,uri=Number.isFinite(m.uridium)&&m.uridium>0&&m.uridium<4294967295;
 return {name:name(id),category:'weapon',price:credit?m.credits:uri?m.uridium:1000000,currency:credit?'virtual':'real',isPaymentItem:false,localLaserOffer:true,localFixedPrice:!credit&&!uri};
}
function offers(){return Object.fromEntries(IDS.map(id=>[id,offer(id)]));}
module.exports={IDS,name,offer,offers};
