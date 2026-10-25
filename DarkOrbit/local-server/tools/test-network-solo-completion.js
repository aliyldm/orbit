'use strict';
// Explicit QA fixtures only: production is never used. Authenticated shop/API
// and native menu requests are real; fast time/ship-position changes are trusted.
const assert=require('node:assert/strict');
exports.verify=async({world,a,frame,db,base,cookie,post})=>{
 const p=world.player,abilities=require('../game/ship-abilities'),pet=require('../game/pet'),send=require('../game/net').sendCmd,players=require('../game/db/players'),session=[...world.sessions][0],originalShip=p.shipId;
 const api=async(action,params={})=>{const res=await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action,params:Buffer.from(JSON.stringify(params)).toString('base64')})});return JSON.parse(Buffer.from(await res.text(),'base64'));};
 clearInterval(world.combat.timer);world.combat.timer=null;world.stopMovement();world.save();
 try{
  pet.stop(world);db.prepare('UPDATE pets SET level=20 WHERE player_id=?').run(p.userId);
  const before=p.uridium,hp=require('../game/pet-progression').hpOffer(p.userId);assert.ok(hp);let result=await post('/ajax/shop.php',{action:'purchase',itemId:hp.id,amount:'1'});assert.equal(result.result,'success');assert.equal(p.uridium,before-hp.price);
  const unlocked=require('../game/pet-progression').unlocked(p.userId),next=unlocked.laser+1;
  result=await api('unlockSlot',{target:'pet',slotset:'lasers',slotPrice:require('../game/pet-progression').price('laser',next)});assert.equal(result.isError,0);
  const hangar=(await api('getHangarList')).data.ret;assert.equal(hangar.pet.lockedSlots.lasers,12-next);
  result=await post('/ajax/shop.php',{action:'purchase',itemId:'equipment_extra_cpu_alb-x',amount:'1'});assert.equal(result.result,'success');
  const item=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='equipment_extra_cpu_alb-x' ORDER BY id DESC LIMIT 1").get(p.userId);
  assert.equal((await api('setAbCpuAmmo',{itemId:item.id,ammo:'ammunition_laser_mcb-50'})).isError,0);
  assert.equal((await api('getHangarList')).data.ret.items.find(i=>i.I===item.id).properties.attachedAmmo,'ammunition_laser_mcb-50');
  for(const [ship,menu]of [['ship_aegis','ability_aegis_hp-repair'],['ship_solace-plus','ability_solace-plus_nano-cluster-repairer-plus'],['ship_solaris-plus','ability_solaris-plus_incinerate-plus']]){
   result=await post('/ajax/shop.php',{action:'purchase',itemId:ship,amount:'1'});assert.equal(result.result,'success');
   abilities.stop(world);world.save();const owned=db.prepare('SELECT id FROM ships WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(p.userId,ship);
   db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(owned.id,p.userId);Object.assign(p,players.loadPlayer(p.userId),{x:6000,y:6000,hitPoints:1000});
   const mark=a.commands.length;for(const command of abilities.buildInit(world))send(session,command);
   await a.until(cs=>cs.slice(mark).some(c=>c._==='MenuItemStatusCommand'&&c.menuItemId===menu&&c.visible));
   let npc;if(ship==='ship_solaris-plus')npc=world.combat.spawn({typeId:84,name:'Solo Ability QA',hitpoints:100000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{}},{x:6200,y:6000});
   a.socket.write(frame({_:'MenuActionRequest',menuItemId:menu,actionType:1}));
   if(ship==='ship_solace-plus')await a.until(cs=>cs.slice(mark).some(c=>c._==='AbilityEffectActivationCommand'&&c.selectedAbilityId===140));
   else{
    await a.until(()=>world.expandedAbilityRuns?.has(menu));const run=world.expandedAbilityRuns.get(menu);abilities.tick(world,world.combat,run.nextTick);
    if(npc){assert.equal(npc.hp,85000);await a.until(cs=>cs.slice(mark).some(c=>c._==='VisualModifierCommand'&&c.modifier===87&&c.activated));}
    else{assert.equal(p.hitPoints,21000);await a.until(cs=>cs.slice(mark).some(c=>c._==='HitpointInfoCommand'&&c.hitpoints===21000));}
   }
  }
  for(const [ship,speedMultiplier]of [['ship_tartarus',1.3],['ship_tartarus-plus',1.45]]){
   result=await post('/ajax/shop.php',{action:'purchase',itemId:ship,amount:'1'});assert.equal(result.result,'success');
   abilities.stop(world);world.save();const owned=db.prepare('SELECT id FROM ships WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(p.userId,ship);
   db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(owned.id,p.userId);Object.assign(p,players.loadPlayer(p.userId),{x:6000,y:6000,lastCombat:0});
   const plus=ship.endsWith('-plus'),speed=`ability_tartarus${plus?'-plus':''}_speed-boost${plus?'-plus':''}`,rapid=`ability_tartarus${plus?'-plus':''}_rapid-fire${plus?'-plus':''}`,baseSpeed=p.speed;
   const init=abilities.buildInit(world);for(const command of init)send(session,command);
   let mark=a.commands.length;a.socket.write(frame({_:'MenuActionRequest',menuItemId:speed,actionType:1}));
   await a.until(cs=>cs.slice(mark).some(c=>c._==='VisualModifierCommand'&&c.modifier===0&&c.activated));assert.equal(p.speed,Math.round(baseSpeed*speedMultiplier));
   const count=plus?2:1;
   for(let i=0;i<count;i++){
    result=await post('/ajax/shop.php',{action:'purchase',itemId:'equipment_weapon_rocketlauncher_hst-2',amount:'1'});assert.equal(result.result,'success');
    const item=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='equipment_weapon_rocketlauncher_hst-2' AND ship_id IS NULL ORDER BY id DESC LIMIT 1").get(p.userId);
    const moved=await api('move',{hangarId:p.shipId,from:{target:'inventory',items:[item.id],configId:1},to:{target:'ship',slotset:'heavy_guns',configId:1}});assert.equal(moved.isError,0);
   }
   result=await post('/ajax/shop.php',{action:'purchase',itemId:'ammunition_rocketlauncher_eco-10',amount:'30'});assert.equal(result.result,'success');
   mark=a.commands.length;a.socket.write(frame({_:'MenuActionRequest',menuItemId:rapid,actionType:1}));
   await a.until(cs=>cs.slice(mark).some(c=>c._==='VisualModifierCommand'&&c.modifier===1&&c.activated));const launcher=require('../game/hellstorm'),loaded=count*5;assert.equal(launcher.state(world).loaded,loaded);
   const n=world.combat.spawn({typeId:84,name:'Rapid Fire wire QA',hitpoints:100000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{}},{x:6200,y:6000});
   mark=a.commands.length;a.socket.write(frame({_:'ShipSelectRequest',targetId:n.id}));await a.until(cs=>cs.slice(mark).some(c=>c._==='ShipSelectionCommand'&&c.userId===n.id));
   const stock=launcher.count(p,'ammunition_rocketlauncher_eco-10');mark=a.commands.length;a.socket.write(frame({_:'MenuActionRequest',menuItemId:launcher.ROOT,actionType:1}));
   await a.until(cs=>cs.slice(mark).some(c=>c._==='HellstormAttackCommand'&&c.targetId===n.id));assert.equal(launcher.count(p,'ammunition_rocketlauncher_eco-10'),stock-loaded);
   assert.ok(a.commands.slice(mark).some(c=>c._==='MenuItemCooldownGroupTimerCommand'&&c.cooldownType.typeValue===11&&c.time===1000));
   abilities.stop(world);world.combat.cancelProjectiles();
  }
 }finally{
  abilities.stop(world);world.save();db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(originalShip,p.userId);Object.assign(p,players.loadPlayer(p.userId),{x:6000,y:6000,lastCombat:0});world.combat.start();
 }
};
