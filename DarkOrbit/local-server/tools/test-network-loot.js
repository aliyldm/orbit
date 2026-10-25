'use strict';
// Isolated QA server only. Public requests use real HTTP/TCP; positioning,
// deterministic prize and gate kills are explicitly trusted memory fixtures.
const assert=require('node:assert/strict');
async function boxes(world,client,frame,db,post){
 const combat=world.combat,p=world.player;
 clearInterval(combat.timer);combat.timer=null;
 const oldOpening=world.config.booty.openingMs;world.config.booty.openingMs=1000;
 try{
  for(const [boxType,key,counter]of [['PIRATE_BOOTY','resource_booty-key','BK'],['PIRATE_BOOTY_GOLD','resource_booty-key','BK'],['PIRATE_BOOTY_RED','resource_booty-key-red','BKR'],['PIRATE_BOOTY_BLUE','resource_booty-key-blue','BKB']]){
   const mark=client.commands.length,purchase=await post('/ajax/shop.php',{action:'purchase',itemId:key,amount:'1'});assert.equal(purchase.result,'success');
   await client.until(cmds=>cmds.slice(mark).some(c=>c._==='LegacyModule'&&c.message===`0|A|${counter}|1`));
   const b=[...world.collectables.boxes.values()].find(b=>b.boxType===boxType);assert.ok(b);Object.assign(p,{x:b.x,y:b.y});
   b.pendingReward={items:{resource_logfile:1}};const before=require('../game/loot-rewards').count(db,p.userId,'resource_logfile');
   const openMark=client.commands.length;client.socket.write(frame({_:'CollectBoxRequest',itemHash:b.hash,boxX:b.x,boxY:b.y,posX:p.x,posY:p.y}));
   await client.until(cmds=>cmds.slice(openMark).some(c=>c._==='LegacyModule'&&c.message==='0|y|SLA|1'));
   assert.equal(require('../game/loot-rewards').count(db,p.userId,key),1,'key is not spent at opening start');
   try{await client.until(cmds=>cmds.slice(openMark).some(c=>c._==='RemoveCollectableCommand'&&c.hash===b.hash&&c.collected));}catch(error){error.message+=' booty fixture: '+JSON.stringify({boxType,hp:p.hitPoints,dead:p.dead,position:{x:p.x,y:p.y},box:{x:b.x,y:b.y,exists:world.collectables.boxes.has(b.hash),expires:b.expires,opening:!!b.opening},harvest:sessionHarvest(world),messages:client.commands.slice(openMark).filter(c=>c._==='LegacyModule').map(c=>c.message)});throw error;}
   assert.equal(require('../game/loot-rewards').count(db,p.userId,key),0);assert.equal(require('../game/loot-rewards').count(db,p.userId,'resource_logfile'),before+1);
   assert.equal(db.prepare('SELECT key_loot_id FROM loot_claims WHERE box_hash=?').get(b.hash).key_loot_id,key);
  }
  await cargo(world,client,frame,db);
 }finally{world.config.booty.openingMs=oldOpening;combat.start();}
}
function sessionHarvest(world){return [...world.sessions].map(s=>s.harvest?{hash:s.harvest.hash,readyAt:s.harvest.readyAt,now:Date.now()}:null);}
async function cargo(world,client,frame,db){
 const p=world.player,c=world.collectables,saved=db.prepare('SELECT * FROM player_resources WHERE player_id=?').all(p.userId),max=p.cargoSpaceMax;
 const clear=()=>db.prepare('DELETE FROM player_resources WHERE player_id=?').run(p.userId);
 const collect=b=>client.socket.write(frame({_:'CollectBoxRequest',itemHash:b.hash,boxX:b.x,boxY:b.y,posX:p.x,posY:p.y}));
 try{
  clear();world.stopMovement();p.cargoSpaceMax=100000;
  let b=c.add({x:Math.round(p.x)+10,y:Math.round(p.y),boxType:'FROM_SHIP',ores:[{type:0,amount:10}]});
  let mark=client.commands.length;collect(b);
  await client.until(cs=>cs.slice(mark).some(cmd=>cmd.message===`0|A|SLA|0|${p.userId}`));
  client.socket.write(frame({_:'MoveRequest',positionX:Math.round(p.x),positionY:Math.round(p.y),targetX:b.x,targetY:b.y}));
  await client.until(cs=>cs.slice(mark).some(cmd=>cmd._==='RemoveCollectableCommand'&&cmd.hash===b.hash&&cmd.collected));
  assert.equal(client.commands.slice(mark).some(cmd=>cmd.message===`0|A|SLC|0|${p.userId}`),false,'queued arrival must not cancel cargo');
  assert.ok(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=0').get(p.userId).amount>=10);
  world.stopMovement();clear();p.cargoSpaceMax=1;
  db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,0,1)').run(p.userId);
  b=c.add({x:Math.round(p.x),y:Math.round(p.y),boxType:'FROM_SHIP',ores:[{type:0,amount:10}]});mark=client.commands.length;collect(b);
  await client.until(cs=>cs.slice(mark).some(cmd=>cmd.message==='0|f'));assert.ok(c.boxes.has(b.hash));
  assert.equal(client.commands.slice(mark).some(cmd=>cmd.message?.includes('|SLA|')),false);c.boxes.delete(b.hash);
  clear();b=c.add({x:Math.round(p.x),y:Math.round(p.y),boxType:'FROM_SHIP',ores:[{type:0,amount:10}]});mark=client.commands.length;collect(b);
  await client.until(cs=>cs.slice(mark).some(cmd=>cmd._==='LMCollectResourcesCommand'));
  assert.ok(c.boxes.has(b.hash));assert.ok(b.remainingOres[0].amount>=9);
  const remainder=b.remainingOres[0].amount;clear();p.cargoSpaceMax=100000;mark=client.commands.length;collect(b);
  await client.until(cs=>cs.slice(mark).some(cmd=>cmd._==='RemoveCollectableCommand'&&cmd.hash===b.hash));
  assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=0').get(p.userId).amount,remainder);
  clear();b=c.cargo({def:require('../game/kronos').definition('phoenix'),x:p.x,y:p.y});assert.equal(b.ores.find(o=>o.type===0).amount,25);
  mark=client.commands.length;collect(b);await client.until(cs=>cs.slice(mark).some(cmd=>cmd._==='RemoveCollectableCommand'&&cmd.hash===b.hash));
 }finally{
  world.stopMovement();clear();for(const row of saved)db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?)').run(row.player_id,row.ore_type,row.amount);
  p.cargoSpaceMax=max;require('../game/collectables').resourceCommands(p);
 }
}
async function epsilon(world,client,frame,db){
 const gates=require('../game/galaxy-gates'),p=world.player,session=[...world.sessions][0];
 const existing=world.config.galaxyGates,oldDelay=existing?.waveDelayMs;world.config.galaxyGates||={};world.config.galaxyGates.waveDelayMs=5;
 try{
  const count=id=>require('../game/loot-rewards').count(db,p.userId,id),beforeLf4=count('equipment_weapon_laser_lf-4'),beforeKeys=count('resource_booty-key');
  db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=5').run(JSON.stringify(Array.from({length:99},(_,i)=>i+1)),p.userId);
  const mark=client.commands.length;client.socket.write(frame({_:'GalaxyGateBuilderSetupGateRequest',gateId:5}));await client.until(cmds=>cmds.slice(mark).some(c=>c._==='GalaxyGateBuilderSetupGateCommand'&&c.id===5&&c.errorCode===0));
  const gate=gates.portalRows(world).find(g=>g.gateRunId===db.prepare("SELECT id FROM galaxy_gate_runs WHERE player_id=? AND gate_id=5 AND state='active'").get(p.userId).id);Object.assign(p,{x:gate.x,y:gate.y});client.socket.write(frame({_:'JumpRequest'}));
  await client.until(()=>p.mapId===70);const deadline=Date.now()+10000;
  while(p.mapId===70&&Date.now()<deadline){
   clearInterval(world.combat.timer);world.combat.timer=null;
   const run=db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=? AND gate_id=5 ORDER BY id DESC LIMIT 1').get(p.userId);if(run.state==='won')break;
   if(run.waiting_next_wave){
    const next=gates.portalRows(world).find(row=>row.gateAction==='continue');assert.ok(next,'Epsilon checkpoint has a native continue portal');
    const transition=client.commands.length;Object.assign(p,{x:next.x,y:next.y});client.socket.write(frame({_:'MapAssetActivationRequest',mapAssetId:next.id}));
    await client.until(cmds=>cmds.slice(transition).some(c=>c._==='JumpToServerCommand')&&world.npcs.size>0);continue;
   }
   for(const npc of [...world.npcs.values()]){npc.hp=0;world.combat.kill(session,npc);}
   await new Promise(resolve=>setTimeout(resolve,8));
  }
  await client.until(cmds=>cmds.slice(mark).some(c=>c._==='GalaxyGateBuilderGateCompleteCommand'&&c.gateId===5));
  await client.until(()=>p.mapId===1);assert.equal(count('equipment_weapon_laser_lf-4'),beforeLf4+1);assert.equal(count('resource_booty-key'),beforeKeys+5);
  assert.ok(client.commands.slice(mark).some(c=>c._==='LegacyModule'&&c.message===`0|A|BK|${beforeKeys+5}`));
  const run=db.prepare('SELECT id FROM galaxy_gate_runs WHERE player_id=? AND gate_id=5 ORDER BY id DESC LIMIT 1').get(p.userId);assert.equal(db.prepare('SELECT count(*) n FROM galaxy_gate_completion_claims WHERE run_id=?').get(run.id).n,1);
 }finally{if(existing){if(oldDelay===undefined)delete world.config.galaxyGates.waveDelayMs;else world.config.galaxyGates.waveDelayMs=oldDelay;}else delete world.config.galaxyGates;}
}
module.exports={boxes,epsilon};
