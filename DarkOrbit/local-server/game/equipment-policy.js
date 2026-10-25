'use strict';
// Full captured laser catalogue restored by user request. Compatibility hooks
// remain for existing callers, without a local LF4 ceiling or filtered rewards.
const META=require('../docs/client-map.items.json').items;
const KEEP=new Set(Object.keys(META).filter(id=>META[id].typeClass?.endsWith('.LaserType'))),REMOVED=Object.freeze([]),REASON='';
function removed(){return false;}
function reward(value){return {...value,...(value.items?{items:{...value.items}}:{})};}
function offerRemoved(){return false;}
function filterOffers(offers){return {...offers};}
function purge(){throw Error('Lazer silme işlemi kapalı; bütün lazerler yeniden etkin.');}
module.exports={KEEP,REMOVED,REASON,removed,reward,offerRemoved,filterOffers,purge};
