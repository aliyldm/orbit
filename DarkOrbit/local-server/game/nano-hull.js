'use strict';
const META=require('../docs/client-map.items.json').items;
function maximum(lootId){const value=META[lootId]?.maxNanoHull;return Number.isSafeInteger(value)&&value>0?value:0;}
function damageHull(state,damage){
 if(!Number.isFinite(damage)||damage<=0)return 0;
 damage=Math.round(damage);const nano=Math.max(0,Number(state.nanoHull)||0),absorbed=Math.min(nano,damage);
 if(nano>0)state.nanoHull=nano-absorbed;
 const before=state.hp;state.hp=Math.max(0,state.hp-(damage-absorbed));
 return absorbed+before-state.hp;
}
function command(p){return {_:'HitpointInfoCommand',hitpoints:p.hitPoints,hitpointsMax:p.hitMax,nanoHull:p.nanoHull||0,nanoHullMax:p.maxNanoHull||0};}
function ship(db,playerId,shipId){
 return db.prepare('SELECT id,loot_id,hitpoints,nano_hull FROM ships WHERE id=? AND player_id=?').get(shipId,playerId);
}
function grant(db,playerId,shipId,amount){
 if(!Number.isSafeInteger(amount)||amount<1)throw new Error('Geçersiz NanoHull miktarı.');
 const row=ship(db,playerId,shipId);if(!row)throw new Error('NanoHull gemisi bulunamadı.');
 // NanoHull cannot revive or repair a destroyed hull.
 if(row.hitpoints<=0)return 0;
 const delivered=Math.min(amount,Math.max(0,maximum(row.loot_id)-row.nano_hull));
 if(delivered)db.prepare('UPDATE ships SET nano_hull=nano_hull+? WHERE id=? AND player_id=?').run(delivered,shipId,playerId);
 return delivered;
}
function refresh(p,db){const row=ship(db,p.userId,p.shipId);if(!row)return;p.maxNanoHull=maximum(row.loot_id);p.nanoHull=Math.min(row.nano_hull,p.maxNanoHull);}
module.exports={maximum,damageHull,command,ship,grant,refresh};
