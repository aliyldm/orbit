'use strict';
const{test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),assembly=require('../game/assembly'),inventory=require('../game/inventory'),drones=require('../game/drones'),pet=require('../game/pet'),lasers=require('../game/modern-lasers'),World=require('../game/world'),META=require('../docs/client-map.items.json').items;
let db,pid,p;const originalCurrent=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;pid=players.createPlayer(players.createAccount('upgrade-effects','test'),'Effects',1,{...require('../config.json').starter,ship:'ship_goliath'});p=players.loadPlayer(pid);});
afterEach(()=>{World.current=originalCurrent;database.close();});
function give(id,amount=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(pid,id,amount).lastInsertRowid);}
function ship(item,slot){inventory.move(pid,{hangarId:p.shipId,from:{target:'inventory',items:[item],configId:1},to:{target:'ship',slotset:slot,configId:1}});}
function upgrade(item,loot,level){
 const [id,r]=Object.entries(assembly.RECIPES).find(([,r])=>r.targets?.includes(loot)&&/^upgrade_(item|drone)-upgrade$/.test(r.result?.[0]?.lootID));
 for(const step of r.costs.filter(c=>c.level<=level))for(const cost of step.parts)give(cost.lootID,cost.ammount);
 assembly.build(pid,id,level,item,1000);const job=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND target_id=?').get(pid,item);assembly.collect(pid,id,item,job.due_at);
}
test('real LF3/LF4 upgrades change owned ship stats and actual NPC damage profiles at levels16/20',()=>{
 for(const[loot,slot,steps]of[['equipment_weapon_laser_lf-3','lasers',15],['equipment_weapon_laser_lf-4','lasers',19]]){
  const item=give(loot);ship(item,slot);const before=players.loadPlayer(pid),oldDamage=lasers.maxDamage(before,{def:{name:'Streuner'}},1000);upgrade(item,loot,steps);const after=players.loadPlayer(pid);
  const expected=Math.round(META[loot].damage*steps*.005);assert.equal(after.stats.laserDamage-before.stats.laserDamage,expected);assert.ok(lasers.maxDamage(after,{def:{name:'Streuner'}},1000)>oldDamage);
  assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(item).upgrade_level,steps);
 }
});
test('real shield upgrade raises actual equipped shield capacity19percent at level20 without changing absorption',()=>{
 const loot='equipment_generator_shield_sg3n-b02',item=give(loot);ship(item,'generators');const before=players.loadPlayer(pid);upgrade(item,loot,19);const after=players.loadPlayer(pid);
 assert.equal(after.shieldMax-before.shieldMax,1900);assert.equal(after.stats.shieldAbsorb,before.stats.shieldAbsorb);assert.equal(after.hitMax,before.hitMax);
});
test('drone growth and upgrades multiply only its mounted laser/shield, then combine with each items own upgrade',()=>{
 const drone=drones.addOwned(db,pid,'drone_iris'),laser=give('equipment_weapon_laser_lf-4'),shield=give('equipment_generator_shield_sg3n-b02'),shipLaser=give('equipment_weapon_laser_lf-4');ship(shipLaser,'lasers');
 drones.move(pid,{hangarId:p.shipId,from:{target:'inventory',items:[laser,shield],configId:1},to:{target:'drone',droneId:drone,slotset:'default',configId:1}});db.prepare('UPDATE drones SET level=5 WHERE id=?').run(drone);
 const before=players.loadPlayer(pid),mountedBefore=drones.statItems(db,p.shipId),shipBefore=inventory.statItems(db,p.shipId).find(i=>i.id===shipLaser).damage;
 assert.equal(mountedBefore.find(i=>i.id===laser).damage,META['equipment_weapon_laser_lf-4'].damage*1.1);assert.equal(mountedBefore.find(i=>i.id===shield).shield,12000);
 upgrade(assembly.DRONE_OFFSET+drone,'drone_iris',15);const upgraded=drones.statItems(db,p.shipId);
 const rate=require('../game/data/drone-patterns.json').upgrades.drone_iris[5];assert.equal(upgraded.find(i=>i.id===laser).damage,mountedBefore.find(i=>i.id===laser).damage*(1+15*rate.DRONE_DAMAGE_UPGRADE/100));assert.equal(Math.round(upgraded.find(i=>i.id===shield).shield),13800);
 assert.equal(inventory.statItems(db,p.shipId).find(i=>i.id===shipLaser).damage,shipBefore);assert.ok(players.loadPlayer(pid).stats.laserDamage>before.stats.laserDamage);
 upgrade(laser,'equipment_weapon_laser_lf-4',19);const combined=players.loadPlayer(pid);assert.ok(combined.stats.laserProfiles.find(i=>i.id===laser).damage>upgraded.find(i=>i.id===laser).damage);assert.equal(combined.stats.laserProfiles.find(i=>i.id===shipLaser).damage,shipBefore);
});
test('PET laser and shield upgrades affect real PET stats without increasing the owners weapons or shields',()=>{
 pet.addOwned(db,pid);const laser=give('equipment_weapon_laser_lf-4'),shield=give('equipment_generator_shield_sg3n-b02');
 for(const[item,slot]of[[laser,'lasers'],[shield,'generators']])pet.move(pid,{hangarId:p.shipId,from:{target:'inventory',items:[item],configId:1},to:{target:'pet',slotset:slot,configId:1}});
 const before=pet.stats(p),owner=players.loadPlayer(pid);upgrade(laser,'equipment_weapon_laser_lf-4',19);upgrade(shield,'equipment_generator_shield_sg3n-b02',19);const after=pet.stats(p);
 assert.equal(after.laserDamage,before.laserDamage*1.095);assert.equal(after.shieldMax,before.shieldMax*1.19);assert.equal(after.laserProfiles[0].ship,false);assert.equal(players.loadPlayer(pid).stats.laserDamage,owner.stats.laserDamage);assert.equal(players.loadPlayer(pid).shieldMax,owner.shieldMax);
});
