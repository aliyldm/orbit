'use strict';
const assert=require('node:assert/strict');
async function verify({world,a,frame,db,post,timeout}){
 const p=world.player,combat=world.combat,advanced=require('../game/advanced-weapons');
 // Explicit in-memory integration fixture; never called by production startup.
 p.uridium=10000000;p.credits=10000000;p.lastCombat=0;p.dead=false;p.hitPoints=p.hitMax;
 db.prepare('UPDATE players SET uridium=?,credits=? WHERE id=?').run(p.uridium,p.credits,p.userId);
 world.stopMovement();for(const s of world.sessions)s.attacking=null;for(const n of combat.npcs.values())n.aggro=null;Object.assign(p,{x:6000,y:6000});
 async function purchase(sku){const before=p.uridium,r=await post('/ajax/shop.php',{action:'purchase',itemId:sku,amount:'1'});assert.equal(r.result,'success',sku);assert.equal(p.uridium,before-1000000);}
 async function equip(id){const r=await post('/ajax/shop.php',{action:'equipItems',itemId:id,amount:'1'});assert.equal(r.result,'success',id);}
 const walletBefore=p.uridium,stockBefore=require('../game/assembly').count(db,p.userId,'equipment_weapon_laser_pr-l');const blocked=await post('/ajax/shop.php',{action:'purchase',itemId:'package_event-deal-laser-prl',amount:'1'});assert.equal(blocked.result,'error');assert.equal(p.uridium,walletBefore);assert.equal(require('../game/assembly').count(db,p.userId,'equipment_weapon_laser_pr-l'),stockBefore);
 await purchase('package_event-deal-voyagers-igni-p');await equip('equipment_weapon_drive_igd-p');
 await purchase('package_event-deal-voyagers-gl-o');await equip('equipment_lens_gl-omega');assert.equal(p.stats.driveDefense,150);
 // Owned formations must be revealed by the actual menu, because the Flash
 // AvailableFormations handler is empty. Add only paid QA Iris if needed.
 const drones=require('../game/drones');while(drones.owned(db,p.userId).length<4)assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:'drone_iris',amount:'1'})).result,'success');
 let formationMark=a.commands.length;assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:'drone_formation_f-01-tu',amount:'1'})).result,'success');
 function statuses(cs,id){const found=[];const visit=x=>{if(!x||typeof x!=='object')return;if(x._==='MenuItemStatusCommand'&&x.menuItemId===id)found.push(x);Object.values(x).forEach(visit);};cs.forEach(visit);return found;}
 await a.until(cs=>statuses(cs.slice(formationMark),'drone_formation_f-01-tu').some(c=>c.visible&&c.available));
 formationMark=a.commands.length;a.socket.write(frame({_:'MenuActionRequest',menuItemId:'drone_formation_f-01-tu',actionType:0}));await a.until(cs=>cs.slice(formationMark).some(c=>c._==='DroneFormationChangeCommand'&&c.selectedFormationId===1));await a.until(cs=>statuses(cs.slice(formationMark),'drone_formation_f-01-tu').some(c=>c.selected));
 const droneWire=drones.buildCommands(p)[0].message.split('|').slice(4);for(let i=0;i<droneWire.length;i+=4)assert.ok(Number(droneWire[i+1])>=1&&Number(droneWire[i+1])<=6);
 for(const [id,amount]of [['equipment_weapon_cannon_c-helios',1],['ammunition_slug_ths-d01',2],['ammunition_spool_gsp-30',4],[advanced.SR5,2]])db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,id,amount);
 await equip('equipment_weapon_cannon_c-helios');
 const npc=combat.spawn({typeId:71,name:'Network weapon QA',hitpoints:1000000,shield:1000000,shieldAbsorb:.8,speed:0,damageMin:0,damageMax:0,reward:{},respawnMs:100000,transient:true});Object.assign(npc,{x:6100,y:6000});
 let mark=a.commands.length;a.socket.write(frame({_:'ShipSelectRequest',targetId:npc.id}));await a.until(cs=>cs.slice(mark).some(c=>c._==='ShipSelectionCommand'&&c.userId===npc.id));
 const oldRoll=combat.rollHit;combat.rollHit=()=>true;
 try{
  mark=a.commands.length;a.socket.write(frame({_:'AttackLaserRequest',targetId:npc.id}));await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackHitCommand'&&c.attackerId===p.userId&&c.attackType.attackTypeValue===1));for(const session of world.sessions)combat.abort(session);
  mark=a.commands.length;const shield=npc.shield;a.socket.write(frame({_:'MenuActionRequest',menuItemId:'ammunition_slug_ths-d01',actionType:1}));await a.until(cs=>cs.slice(mark).some(c=>c._==='CannonAttackCommand'&&c.attackedId===npc.id));await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackHitCommand'&&c.attackType.attackTypeValue===21));assert.ok(npc.shield<shield);assert.equal(require('../game/ammo').count(p,'ammunition_slug_ths-d01'),1);
  mark=a.commands.length;a.socket.write(frame({_:'MenuActionRequest',menuItemId:'ammunition_spool_gsp-30',actionType:1}));await a.until(cs=>cs.slice(mark).some(c=>c._==='MenuItemCooldownGroupTimerCommand'&&c.cooldownType.typeValue===61));await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackHitCommand'&&c.attackType.attackTypeValue===22));assert.equal(require('../game/ammo').count(p,'ammunition_spool_gsp-30'),3);
  // Reset shield for a distinct real shield-only SR-5 impact assertion.
  npc.shield=1000000;p.shield=0;mark=a.commands.length;
  assert.ok(world.active([...world.sessions][0])&&!p.dead&&![...world.sessions][0].jumping&&combat.npcs.has(npc.id)&&npc.hp>0&&[...world.sessions][0].selected===npc.id,
    JSON.stringify({label:'SR5 preconditions',active:world.active([...world.sessions][0]),dead:p.dead,jumping:[...world.sessions][0].jumping,selected:[...world.sessions][0].selected,npc:npc.id,hp:npc.hp,x:p.x,y:p.y,nx:npc.x,ny:npc.y,cooldowns:advanced.state(p),stock:require('../game/ammo').count(p,advanced.SR5)}));
  a.socket.write(frame({_:'MenuActionRequest',menuItemId:advanced.SR5,actionType:1}));await a.until(cs=>cs.slice(mark).some(c=>c._==='MenuItemCooldownGroupTimerCommand'&&c.cooldownType.typeValue===14));await a.until(cs=>cs.slice(mark).some(c=>c._==='AttackHitCommand'&&c.attackType.attackTypeValue===0&&c.damage===80000));assert.equal(require('../game/ammo').count(p,advanced.SR5),1);assert.ok(p.shield>0);
  assert.ok(advanced.state(p).sr5>Date.now());assert.ok(advanced.buildInit(world).some(c=>c.cooldownType.typeValue===14));
 }finally{combat.rollHit=oldRoll;advanced.stop(world);combat.npcs.delete(npc.id);combat.broadcast({_:'ShipRemoveCommand',userId:npc.id});for(const s of world.sessions)if(s.selected===npc.id)s.selected=null;}
 await timeout(5);
}
module.exports={verify};
