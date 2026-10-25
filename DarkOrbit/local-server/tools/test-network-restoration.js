'use strict';
// Isolated memory account only. Trusted placement/time fixtures; real HTTP/TCP
// requests and actual decoded commands verify the client-facing contracts.
const assert=require('node:assert/strict');
async function verify({world,a,frame,db,base,cookie}){
 const p=world.player,session=[...world.sessions][0],assembly=require('../game/assembly'),net=require('../game/net'),maps=require('../game/maps');
 const recipe='recipe_blueprint-agate-lf4',r=assembly.RECIPES[recipe],before=assembly.count(db,p.userId,'equipment_weapon_laser_lf-4');
 db.prepare('INSERT INTO assembly_usage(player_id,recipe_loot_id,uses)VALUES(?,?,1) ON CONFLICT(player_id,recipe_loot_id)DO UPDATE SET uses=MAX(uses,1)').run(p.userId,recipe);
 db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,'resource_convert-module',r.costs[0].parts[0].ammount*3);
 for(const n of [2,1]){
  let mark=a.commands.length;a.socket.write(frame({_:'AssemblyBuildRequest',recipeLootId:recipe,amount:n,targetItemId:0}));
  await a.until(cs=>cs.slice(mark).some(c=>c._==='AssemblyRecipeStatusUpdateCommand'&&c.lootId===recipe&&c.status._==='AssemblyRecipeBuildStatusModule'));
  db.prepare('UPDATE assembly_jobs SET due_at=0 WHERE player_id=? AND recipe_loot_id=?').run(p.userId,recipe);mark=a.commands.length;
  a.socket.write(frame({_:'AssemblyCollectRequest',recipeLootId:recipe,targetItemId:0}));await a.until(cs=>cs.slice(mark).some(c=>c._==='AssemblyRecipeStatusUpdateCommand'&&c.lootId===recipe&&c.status._==='AssemblyRecipeAvailableStatusModule'));
 }
 assert.equal(assembly.count(db,p.userId,'equipment_weapon_laser_lf-4'),before+3);
 const drones=require('../game/drones'),drone=drones.owned(db,p.userId)[0],item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'drone_designs_havoc',1)").run(p.userId).lastInsertRowid);
 drones.move(p.userId,{params:{hi:p.shipId},from:{target:'inventory',items:[item],configId:1},to:{target:'drone',droneId:drone.id,slotset:'design',configId:1}});
 const request={params:{hi:p.shipId},from:{target:'drone',items:[item],droneId:String(drone.id),slotset:'design',configId:1},to:{target:'inventory',configId:1}};
 const response=await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'moveDroneDesign',params:Buffer.from(JSON.stringify(request)).toString('base64')})}),ret=JSON.parse(Buffer.from(await response.text(),'base64')).data.ret;
 assert.equal(ret.success,true);assert.equal(drones.equipped(db,p.shipId,1).some(i=>i.id===item),false);
 // Check the actual station icon, rather than only the generic TradeRequest.
 world.stopMovement();const station=maps.station(world);assert.ok(station);Object.assign(p,{x:station.x-1080,y:station.y});
 let mark=a.commands.length;world.broadcast(s=>net.sendCmd(s,maps.tradeState(world)));
 await a.until(cs=>cs.slice(mark).some(c=>c._==='MapAssetActionAvailableCommand'&&c.mapAssetId===150000022&&c.activatable));
 mark=a.commands.length;a.socket.write(frame({_:'MapAssetActivationRequest',mapAssetId:150000022}));await a.until(cs=>cs.slice(mark).some(c=>c._==='OreTradeInfoCommand'));
 // Real Cubikon death, then TCP collection in the same overfull-Seprom state
 // seen on production. Keep the paid stock intact and preserve the leftover.
 const saved=db.prepare('SELECT * FROM player_resources WHERE player_id=?').all(p.userId),max=p.cargoSpaceMax,skills=p.stats.skills;
 const clear=()=>db.prepare('DELETE FROM player_resources WHERE player_id=?').run(p.userId);
 try{
  clear();world.stopMovement();Object.assign(p,{x:6000,y:6000});p.stats.skills={...skills,cargoLootMultiplier:1};
  db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,7,397000)').run(p.userId);
  const npc=world.combat.spawn(require('../game/normal-map-content').definition('cubikon'),{x:p.x,y:p.y});npc.hp=0;world.combat.kill(session,npc);
  const b=[...world.collectables.boxes.values()].find(b=>b.boxType==='FROM_SHIP'&&b.x===p.x&&b.y===p.y&&b.ores?.some(o=>o.type===3&&o.amount===64));assert.ok(b);assert.equal(b.ores.length,7);
  const collect=()=>a.socket.write(frame({_:'CollectBoxRequest',itemHash:b.hash,boxX:b.x,boxY:b.y,posX:p.x,posY:p.y}));mark=a.commands.length;collect();
  await a.until(cs=>cs.slice(mark).some(c=>c._==='LMCollectResourcesCommand'&&c.contentList.some(o=>o.oreType.typeValue===3&&o.count===64)));
  await a.until(cs=>cs.slice(mark).some(c=>c.message==='0|f'));assert.equal(b.remainingOres.length,6);assert.ok(world.collectables.boxes.has(b.hash));
  db.prepare('DELETE FROM player_resources WHERE player_id=? AND ore_type=7').run(p.userId);p.cargoSpaceMax=10000;mark=a.commands.length;collect();
  await a.until(cs=>cs.slice(mark).some(c=>c._==='RemoveCollectableCommand'&&c.hash===b.hash&&c.collected));assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=6').get(p.userId).amount,64);
  assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(p.userId).amount,64);
 }finally{clear();for(const row of saved)db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?)').run(row.player_id,row.ore_type,row.amount);p.cargoSpaceMax=max;p.stats.skills=skills;require('../game/collectables').resourceCommands(p);}
 const xml=await(await fetch(base+'/client/spacemap/templates/tr/resource_loadingScreen.xml')).text();assert.match(xml,/name="btn_label_claim"><!\[CDATA\[BAŞLA\]\]>/);
}
module.exports={verify};
