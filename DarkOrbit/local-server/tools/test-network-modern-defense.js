'use strict';
// Isolated QA server only. Ship selection and simulated NPC hits are trusted
// fixtures; purchases, inventory moves and ability activations use real wire APIs.
const assert=require('node:assert/strict');
exports.verify=async({world,a,frame,db,base,cookie,post})=>{
 const p=world.player,session=[...world.sessions][0],originalShip=p.shipId,abilities=require('../game/ship-abilities'),players=require('../game/db/players'),send=require('../game/net').sendCmd,combat=world.combat;
 const api=async(action,params)=>{const res=await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action,params:Buffer.from(JSON.stringify(params)).toString('base64')})});return JSON.parse(Buffer.from(await res.text(),'base64'));};
 clearInterval(combat.timer);combat.timer=null;world.stopMovement();world.save();
 async function ship(lootId){
  const result=await post('/ajax/shop.php',{action:'purchase',itemId:lootId,amount:'1'});assert.equal(result.result,'success',lootId+':'+result.message);
  abilities.stop(world);world.save();const row=db.prepare('SELECT id FROM ships WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(p.userId,lootId);db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(row.id,p.userId);Object.assign(p,players.loadPlayer(p.userId),{x:6000,y:6000,lastCombat:0});for(const c of abilities.buildInit(world))send(session,c);
 }
 async function use(menu,visual,id){
  const mark=a.commands.length;a.socket.write(frame({_:'MenuActionRequest',menuItemId:menu,actionType:1}));await a.until(cs=>cs.slice(mark).some(c=>visual!==undefined?c._==='VisualModifierCommand'&&c.modifier===visual&&c.activated:id!==undefined?c._==='AbilityStartCommand'&&c.selectedAbilityId===id:c._==='MenuItemStatusCommand'&&c.menuItemId===menu&&c.selected));
 }
 async function shield(){
  const result=await post('/ajax/shop.php',{action:'purchase',itemId:'equipment_generator_shield_sg3n-b02',amount:'1'});assert.equal(result.result,'success');
  const item=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='equipment_generator_shield_sg3n-b02' AND ship_id IS NULL ORDER BY id DESC LIMIT 1").get(p.userId);assert.equal((await api('move',{hangarId:p.shipId,from:{target:'inventory',items:[item.id],configId:1},to:{target:'ship',slotset:'generators',configId:1}})).isError,0);
 }
 const target=()=>combat.spawn({key:'native-defense-qa',typeId:84,name:'Defense wire QA',hitpoints:100000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{},transient:true},{x:6200,y:6000});
 try{
  await ship('ship_berserker');await use('ability_berserker_bsk',84);p.hitPoints=Math.round(p.hitMax/2);assert.equal(abilities.outgoing(world,10000),15000);
  await use('ability_berserker_rvg',85);const n=target(),hp=p.hitPoints,mark=a.commands.length;combat.damagePlayer(n,1000,{evade:false});assert.equal(n.hp,99000);assert.equal(p.hitPoints,hp-50);await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackHitCommand'&&c.attackerId===p.userId&&c.victimId===n.id));
  await ship('ship_orcus');p.hitPoints=1000;await use('ability_orcus_assimilate',99);combat.damagePlayer(target(),1000,{evade:false});assert.equal(p.hitPoints,1600);
  await ship('ship_spearhead');await shield();p.shield=5000;await use('ability_spearhead_ultimate-cloak',undefined,103);assert.equal(require('../game/cpu').isCloaked(p),true);assert.equal(p.shield,0);assert.equal(p.ultimateShield,5000);
  const box=world.collectables.add({x:6000,y:6000,boxType:'BONUS_BOX',reward:{credits:1}}),harvestMark=a.commands.length;a.socket.write(frame({_:'CollectBoxRequest',itemHash:box.hash}));await a.until(cs=>cs.slice(harvestMark).some(c=>c._==='AbilityStopCommand'&&c.selectedAbilityId===103));assert.equal(!!p.ultimateCloaked,false);assert.equal(p.shield,5000);world.collectables.cancelHarvest(session);
  await ship('ship_mimesis');await shield();p.shield=p.shieldMax;const shieldMax=p.shieldMax,baseSpeed=p.speed;await use('ability_mimesis_scramble',3);assert.equal(p.speed,Math.round(baseSpeed*1.25));const run=world.expandedAbilityRuns.get('ability_mimesis_scramble');abilities.tick(world,combat,run.nextTick);assert.equal(p.shield,shieldMax-Math.ceil(shieldMax*.1));assert.equal(abilities.outgoing(world,10000),12500);
  const phaseOrigin={x:p.x,y:p.y};await use('ability_mimesis_phase-out',4);assert.ok(Math.abs(Math.hypot(p.x-phaseOrigin.x,p.y-phaseOrigin.y)-5000)<1);
  await a.until(cs=>cs.some(c=>c._==='MoveCommand'&&c.userId===p.userId&&c.timeToTarget===0&&c.x===p.x&&c.y===p.y));
  await ship('ship_citadel');await use('ability_citadel_fortify',8);assert.equal(p.speed,0);const fortified=target(),moveMark=a.commands.length;
  a.socket.write(Buffer.concat([frame({_:'MoveRequest',positionX:6000,positionY:6000,targetX:8000,targetY:6000}),frame({_:'ShipSelectRequest',targetId:fortified.id})]));await a.until(cs=>cs.slice(moveMark).some(c=>c._==='ShipSelectionCommand'&&c.userId===fortified.id));assert.equal(world.movement,null);assert.deepEqual([p.x,p.y],[6000,6000]);
  await ship('ship_zephyr');const zephyrSpeed=p.speed;for(let i=0;i<2;i++){const n=target();n.hp=0;combat.kill(session,n);}
  assert.equal(require('../game/ship-abilities-expanded').laserRange(world),610);await use('ability_zephyr_mmt');assert.equal(p.speed,Math.round(zephyrSpeed*1.03));assert.equal(require('../game/ship-abilities-expanded').laserRange(world),600);
  await ship('ship_retiarus');const retiarusSpeed=p.speed;await use('ability_retiarus_spc');assert.equal(p.speed,Math.round(retiarusSpeed*1.1));
 }finally{
  abilities.stop(world);world.save();db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(originalShip,p.userId);Object.assign(p,players.loadPlayer(p.userId),{x:6000,y:6000,lastCombat:0});combat.start();
 }
};
