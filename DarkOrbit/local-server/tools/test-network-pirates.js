'use strict';
// Called only by the isolated in-memory HTTP/TCP QA server, never production.
const assert=require('node:assert/strict');
async function verify(world,client,frame,db){
 const combat=world.combat,p=world.player,session=[...world.sessions][0];
 clearInterval(combat.timer);combat.timer=null;
 try{
  require('../game/handlers/lab').refresh(world);
  Object.assign(p,{x:6000,y:6000,hitPoints:p.hitMax,shield:0});
  for(const npc of combat.npcs.values()){
   Object.assign(npc,{x:1000,y:1000,movement:null,aggro:null,nextWander:Date.now()+60000});
   npc.def.behavior={...npc.def.behavior,aggression:'passive',roam:false};
  }
  const saboteur=[...combat.npcs.values()].find(n=>n.def.key==='saboteur');
  Object.assign(saboteur,{x:6400,y:6000,aggro:session});saboteur.def.damageMin=saboteur.def.damageMax=100;
  const speed=p.speed,slowMark=client.commands.length;combat.tick();
  await client.until(cmds=>cmds.slice(slowMark).some(c=>c._==='AttributeShipSpeedUpdateCommand'&&c.newSpeed===Math.round(speed*.3))&&cmds.slice(slowMark).some(c=>c._==='LegacyModule'&&c.message===`0|n|fx|start|SABOTEUR_DEBUFF|${p.userId}`));
  db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(p.userId,'ammunition_specialammo_emp-01');
  const empMark=client.commands.length;client.socket.write(frame({_:'MenuActionRequest',menuItemId:'ammunition_specialammo_emp-01',actionType:1}));
  await client.until(cmds=>cmds.slice(empMark).some(c=>c._==='LegacyModule'&&c.message===`0|n|fx|end|SABOTEUR_DEBUFF|${p.userId}`));assert.equal(p.speed,speed);
  saboteur.def.behavior.canAttack=false;saboteur.aggro=null;
  const annihilator=[...combat.npcs.values()].find(n=>n.def.key==='annihilator');Object.assign(annihilator,{x:6400,y:6000,aggro:session});annihilator.def.damageMin=annihilator.def.damageMax=100;
  const launchMark=client.commands.length,hull=p.hitPoints;combat.tick();assert.equal(p.hitPoints,hull);
  await client.until(cmds=>cmds.slice(launchMark).some(c=>c._==='HellstormAttackCommand'&&c.attackerId===annihilator.id&&c.currentLoad===5));
  await client.until(cmds=>cmds.slice(launchMark).some(c=>c._==='AttackHitCommand'&&c.attackerId===annihilator.id&&c.victimId===p.userId&&c.damage===100));
  assert.equal(p.hitPoints,hull-100);annihilator.def.behavior.canAttack=false;annihilator.aggro=null;
  const barracuda=[...combat.npcs.values()].find(n=>n.def.key==='barracuda');Object.assign(barracuda,{hp:1,x:6100,y:6000});
  const boomMark=client.commands.length,wallet=[p.credits,p.uridium];combat.tick();
  await client.until(cmds=>cmds.slice(boomMark).some(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===barracuda.id));
  const cmds=client.commands.slice(boomMark),boom=cmds.findIndex(c=>c._==='LegacyModule'&&c.message===`0|n|BOOOM|${barracuda.id}`),destroy=cmds.findIndex(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===barracuda.id);
  assert.ok(boom>=0&&boom<destroy);assert.deepEqual([p.credits,p.uridium],wallet);
  assert.ok(db.prepare('SELECT respawn_at FROM normal_spawn_state WHERE player_id=? AND spawn_id=? AND slot=?').get(p.userId,barracuda.def.normalSpawnId,barracuda.def.normalSpawnSlot).respawn_at>Date.now());
 }finally{combat.cancelProjectiles();require('../game/npc-special-attacks').clearSlow(world);combat.start();}
}
module.exports={verify};
