'use strict';
// Atomic box receipt + optional key debit + currency/items/extra-energy credit.
// This module does not choose original drop chances; profiles declare provenance.
const {open,tx}=require('./db'),META=require('../docs/client-map.items.json').items;
function integer(n){if(!Number.isSafeInteger(n)||n<0||n>2147483647)throw Error('Invalid loot amount');return n;}
function count(db,playerId,id){return db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').get(playerId,id).n;}
function consumeKey(db,playerId,id){
 const row=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id LIMIT 1').get(playerId,id);
 return !!row&&!!db.prepare('UPDATE items SET amount=amount-1 WHERE id=? AND amount>0').run(row.id).changes;
}
function item(db,playerId,id,amount){
 if(require('./equipment-policy').removed(id))return;
 integer(amount);if(!amount)return;
 const meta=META[id];if(!meta||!db.prepare('SELECT 1 FROM item_types WHERE loot_id=?').get(id))throw Error(`Unknown loot item: ${id}`);
 const owned=db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,id).n;
 if(owned+amount>Math.min(2147483647,meta.maxQuantity||2147483647,meta.stackable?.maxQuantity||2147483647))throw Error('Loot item capacity exceeded');
 const stack=!!meta.stackable||meta.kind==='Ammunition';
 if(stack){const row=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL ORDER BY id LIMIT 1').get(playerId,id);
  if(row)db.prepare('UPDATE items SET amount=amount+? WHERE id=?').run(amount,row.id);else db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(playerId,id,amount);
 }else{if(amount>1000)throw Error('Too many loot equipment items');const insert=db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)');for(let i=0;i<amount;i++)insert.run(playerId,id);}
}
function grant(world,box,reward,{key=null,profile='local-explicit'}={}){
 reward=require('./equipment-policy').reward(reward);
 const p=world.player;
 for(const field of ['credits','uridium','energy'])integer(reward[field]||0);
 const result=tx(conn=>{
  if(conn.prepare('SELECT 1 FROM loot_claims WHERE box_hash=?').get(box.hash))return null;
  if(key&&!consumeKey(conn,p.userId,key))return null;
  const credits=p.credits+(reward.credits||0),uridium=p.uridium+(reward.uridium||0);
  if(!Number.isFinite(credits)||!Number.isFinite(uridium)||credits<0||uridium<0||credits>Number.MAX_SAFE_INTEGER||uridium>Number.MAX_SAFE_INTEGER)throw Error('Loot balance overflow');
  conn.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(credits,uridium,p.userId);
  for(const [id,amount]of Object.entries(reward.items||{}))item(conn,p.userId,id,amount);
  if(reward.energy){conn.prepare('INSERT OR IGNORE INTO galaxy_gate_accounts(player_id)VALUES(?)').run(p.userId);if(!conn.prepare('UPDATE galaxy_gate_accounts SET energy=energy+? WHERE player_id=? AND energy<=?').run(reward.energy,p.userId,2147483647-reward.energy).changes)throw Error('Extra energy overflow');}
  for(const ore of reward.ores||[]){integer(ore.type);integer(ore.amount);if(ore.type>8)throw Error('Unknown loot ore');conn.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=amount+excluded.amount').run(p.userId,ore.type,ore.amount);}
  conn.prepare('INSERT INTO loot_claims(box_hash,player_id,map_id,box_type,key_loot_id,profile,reward_json,claimed_at)VALUES(?,?,?,?,?,?,?,?)').run(box.hash,p.userId,p.mapId,box.boxType,key,profile,JSON.stringify(reward),Date.now());
  return {credits,uridium};
 });
 if(result)Object.assign(p,result);
 return !!result;
}
function notify(world,session,send,reward){
 reward=require('./equipment-policy').reward(reward);
 const p=world.player;
 for(const [field,code]of [['credits','CRE'],['uridium','URI']])if(reward[field])send(session,{_:'LegacyModule',message:`0|LM|ST|${code}|${reward[field]}|${p[field]}`});
 for(const [id,n]of Object.entries(reward.items||{}))if(n)send(session,{_:'LegacyModule',message:`0|y|LOT|${id}|${n}`});
 if(reward.energy)send(session,{_:'LegacyModule',message:`0|y|XEN|${reward.energy}`});
 if(Object.keys(reward.items||{}).length){require('./ammo').notify(p,{world,sendCmd:send});send(session,require('./inventory').buildInit(p));}
}
module.exports={grant,notify,count,item};
