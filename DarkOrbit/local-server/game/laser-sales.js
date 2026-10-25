'use strict';
// Shop availability only. Never remove owned equipment, recipes or rewards.
const META=require('../docs/client-map.items.json').items;
const CLASSIC=new Set(['mp-1','lf-1','lf-2','lf-3','lf-4','sl-01','sl-02','sl-03','aa-1'].map(id=>'equipment_weapon_laser_'+id));
const REASON='LF-4 sonrası lazerlerin satın alınması kapalı.';
function blocked(id){return !!META[id]?.typeClass?.endsWith('.LaserType')&&!CLASSIC.has(id);}
function recordReason(record){return Object.keys(record?.contents?.items||{}).some(blocked)||blocked(record?.imageLootId)?REASON:null;}
function reason(id,offer={}){if(blocked(id))return REASON;if(offer.localPayment)return recordReason(require('./payment').entry(offer.paymentSku||id));return null;}
module.exports={CLASSIC,REASON,blocked,recordReason,reason};
