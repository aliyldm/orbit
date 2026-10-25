'use strict';
// Isolated integration fixture only; never use against production accounts.
const assert=require('node:assert/strict');
exports.verify=async({world,a,frame,db,base,cookie})=>{
 const p=world.player,inv=require('../game/inventory'),maps=require('../game/maps');
 const flash=async(action,r={})=>{const response=await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action,params:Buffer.from(JSON.stringify({params:{hi:p.shipId},...r})).toString('base64')})});return JSON.parse(Buffer.from(await response.text(),'base64'));};
 const saleWallet=p.credits,saleAmmo=require('../game/ammo').count(p,'ammunition_laser_lcb-10'),saleIds=['equipment_weapon_laser_lf-3','equipment_weapon_laser_lf-5-mf','ammunition_laser_lcb-10'].map((loot,i)=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,loot,i===2?10:1).lastInsertRowid));
 try{
  let reply=await flash('sell',{action:'sell',itemId:String(saleIds[0]),quantity:1,saleValue:999999999});assert.equal(reply.isError,0);assert.deepEqual(reply.data.update.deleted,[String(saleIds[0])]);assert.equal(p.credits,saleWallet+25000);
  const mark=a.commands.length;reply=await flash('sell',{action:'sell',itemId:saleIds[2],quantity:4});assert.equal(reply.isError,0);assert.deepEqual(reply.data.update.changed,{[saleIds[2]]:{Q:6}});
  await a.until(cs=>cs.slice(mark).some(c=>c._==='MenuItemStatusCommand'&&c.menuItemId==='ammunition_laser_lcb-10'&&c.counterValue===saleAmmo+6));
  reply=await flash('sellMultiple',{action:'sellMultiple',items:saleIds.slice(1).map(String)});assert.equal(reply.isError,0);assert.deepEqual(reply.data.update.deleted,saleIds.slice(1).map(String));assert.equal(p.credits,saleWallet+25000+50000+50);
  assert.equal((await flash('sell',{itemId:saleIds[0],quantity:1})).isError,1);assert.equal(p.credits,saleWallet+75050);
 }finally{for(const id of saleIds)db.prepare('DELETE FROM items WHERE id=? AND player_id=?').run(id,p.userId);p.credits=saleWallet;world.save();}
 for(const config of [1,2]){
  const free=inv.freeSlots(db,p.shipId,'laser',config).length,ids=Array.from({length:free+3},()=>Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_weapon_laser_lf-5-mf',1)").run(p.userId).lastInsertRowid));
  const listing=await flash('getHangarList');for(const id of ids){const row=listing.data.ret.items.find(i=>i.I===id),info=listing.data.ret.itemInfo.find(i=>i.L===row.L);assert.equal(info.T,0);assert.ok(info.EB.includes('SHIP'));assert.equal(row.EQH,undefined);}
  const r={from:{target:'inventory',items:ids,configId:config},to:{target:'ship',slotset:'lasers',configId:config}};
  const reply=await flash('move',r);assert.equal(reply.isError,0);assert.deepEqual(reply.data.ret,ids.slice(free));
  const hangar=(await flash('getHangarList')).data.ret.hangars.find(h=>Number(h.hangarID)===p.shipId);
  for(const [n,id]of ids.entries())assert.equal(hangar.config[config].ship.EQ.lasers.includes(id),n<free);
  if(free){const remove=await flash('move',{from:{...r.to,items:ids.slice(0,free)},to:{target:'inventory',configId:config}});assert.equal(remove.isError,0);assert.equal(remove.data.ret,true);}
  for(const id of ids)db.prepare('DELETE FROM items WHERE id=?').run(id);
 }
 const initial={x:p.x,y:p.y,credits:p.credits},station=maps.station(world),old=db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(p.userId);assert.ok(station&&station.factionId===p.factionId);
 try{
  world.stopMovement();Object.assign(p,{x:station.x,y:station.y});db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,7,91234)ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=91234').run(p.userId);
  const mark=a.commands.length;a.socket.write(frame({_:'TradeRequest'}));await a.until(cs=>cs.slice(mark).some(c=>c._==='OreTradeInfoCommand'&&c.sepromPrice===750));
  assert.equal(a.commands.slice(mark).find(c=>c._==='AttributeOreCountUpdateCommand').oreCountList.find(o=>o.oreType.typeValue===7).count,91234);
  const sell=a.commands.length;a.socket.write(frame({_:'TradeSellOreRequest',toSell:{_:'OreCountModule',oreType:{_:'OreTypeModule',typeValue:7},count:1234}}));
  await a.until(cs=>cs.slice(sell).some(c=>c._==='AttributeOreCountUpdateCommand'&&c.oreCountList.some(o=>o.oreType.typeValue===7&&o.count===90000)));
  assert.equal(p.credits,initial.credits+1234*750);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(p.userId).amount,90000);
 }finally{
  Object.assign(p,initial);if(old)db.prepare('UPDATE player_resources SET amount=? WHERE player_id=? AND ore_type=7').run(old.amount,p.userId);else db.prepare('DELETE FROM player_resources WHERE player_id=? AND ore_type=7').run(p.userId);world.save();
 }
 // Exercise real native ammo selection -> attack -> effect packet -> abort.
 // Cooldowns are reset ONLY in this isolated fixture; cadence has separate tests.
 const combat=world.combat,s=[...world.sessions].find(s=>world.active(s)),saved={x:p.x,y:p.y,ammo:p.ammo,previousLaserAmmo:p.previousLaserAmmo,shield:p.shield,nextLaserAt:p.nextLaserAt,nextRsb:p.nextRsb,lastCombat:p.lastCombat,idb:p.idb};
 Object.assign(p,{x:6000,y:6000});const target=combat.spawn({key:'native-laser-qa',typeId:84,name:'Native laser QA',hitpoints:10000000,shield:10000000,speed:0,damageMin:0,damageMax:0,reward:{},transient:true},{x:6300,y:6000});
 try{
  for(const [slug,type]of Object.entries(require('../game/laser-visuals').AMMO)){
   const loot='ammunition_laser_'+slug,before=db.prepare('SELECT SUM(amount) n FROM items WHERE player_id=? AND loot_id=?').get(p.userId,loot).n||0;
   const temporary=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1000)').run(p.userId,loot).lastInsertRowid);
   try{
    p.nextLaserAt=p.nextRsb=0;const mark=a.commands.length;a.socket.write(Buffer.concat([frame({_:'MenuActionRequest',menuItemId:loot,actionType:0}),frame({_:'AttackLaserRequest',targetId:target.id})]));
    await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackLaserRunCommand'&&c.attackerId===p.userId&&c.targetId===target.id&&c.laserColor===type));
    const abort=a.commands.length;a.socket.write(frame({_:'AttackAbortLaserRequest'}));await a.until(cs=>cs.slice(abort).some(c=>c._==='AttackAbortLaserCommand'&&c.uid===p.userId));
   }finally{
    combat.abort(s);db.prepare('DELETE FROM items WHERE player_id=? AND loot_id=?').run(p.userId,loot);if(before)db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,loot,before);
   }
  }
  // Real native key/menu path: selected target + x4 + one RSB -> x4 again.
  const x4='ammunition_laser_ucb-100',rsb='ammunition_laser_rsb-75',temp=[x4,rsb].map(loot=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1000)').run(p.userId,loot).lastInsertRowid));
  try{
   p.nextLaserAt=p.nextRsb=0;const mark=a.commands.length;
   a.socket.write(Buffer.concat([frame({_:'ShipSelectRequest',targetId:target.id}),frame({_:'MenuActionRequest',menuItemId:x4,actionType:0}),frame({_:'MenuActionRequest',menuItemId:rsb,actionType:1})]));
   await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackLaserRunCommand'&&c.attackerId===p.userId&&c.laserColor===6));assert.equal(p.ammo,x4);assert.ok(p.nextRsb>Date.now());
   await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackLaserRunCommand'&&c.attackerId===p.userId&&c.laserColor===3));
   assert.equal(a.commands.slice(mark).filter(c=>c._==='AttackLaserRunCommand'&&c.attackerId===p.userId&&c.laserColor===6).length,1);
   assert.ok(a.commands.slice(mark).some(c=>c._==='MenuItemStatusCommand'&&c.menuItemId===x4&&c.selected));
  }finally{combat.abort(s);for(const id of temp)db.prepare('DELETE FROM items WHERE id=?').run(id);}
 }finally{combat.abort(s);combat.npcs.delete(target.id);combat.broadcast({_:'ShipRemoveCommand',userId:target.id});Object.assign(p,saved);world.save();}
};
