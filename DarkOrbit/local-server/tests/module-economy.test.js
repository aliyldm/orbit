'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),assembly=require('../game/assembly'),policy=require('../game/module-policy'),economy=require('../game/economy'),World=require('../game/world');
let db,pid;const original=World.current;
beforeEach(()=>{database.close();World.current=()=>null;db=database.open(':memory:');const account=db.prepare("INSERT INTO accounts(username,password_hash,created_at)VALUES('module-test','test',0)").run();pid=players.createPlayer(Number(account.lastInsertRowid),'Module',1,require('../config').starter);db.prepare('UPDATE players SET uridium=10000000,credits=10000000 WHERE id=?').run(pid);});
afterEach(()=>{World.current=original;database.close();});
function give(id,n=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(pid,id,n).lastInsertRowid);}
function stock(id){return assembly.count(db,pid,id);}
test('both new modules buy in bulk for exactly 10000U each without converting existing materials',()=>{
 give('resource_micro-transistors',12);give('resource_upgradevoucher',8);
 for(const id of [policy.UPGRADE,policy.CONVERT]){assert.equal(economy.offers(pid)[id].capability.status,'implemented');assert.equal(economy.purchase(pid,id,3).result,'success');assert.equal(stock(id),3);assert.equal(db.prepare('SELECT category FROM item_types WHERE loot_id=?').get(id).category,'resource');}
 assert.equal(players.loadPlayer(pid).uridium,9940000);assert.equal(stock('resource_micro-transistors'),12);assert.equal(stock('resource_upgradevoucher'),8);
});
test('all supported upgrade/craft costs and skip costs contain only the assigned module',()=>{
 let up=0,craft=0;for(const[id,r]of Object.entries(assembly.RECIPES)){
  if(assembly.unsupportedReason(id)||r.targets?.length&&!id.startsWith('upgrade_'))continue;
  const expected=r.targets?.length?policy.UPGRADE:policy.CONVERT;
  for(const c of r.costs){assert.equal(c.parts.length,1);assert.equal(c.parts[0].lootID,expected);assert.ok(Number.isSafeInteger(c.parts[0].ammount)&&c.parts[0].ammount>0);for(const p of c.skipCosts||[])assert.equal(p.lootID,expected);}
  assert.equal(r.costScalingFactor,1);if(r.targets?.length)up++;else craft++;
 }
 assert.equal(up,15);assert.ok(craft>500);
});
test('quality and target level increase upgrade requirement, multi-level build charges summed steps only once',()=>{
 const a=assembly.RECIPES['upgrade_upgrade-class1'],b=assembly.RECIPES['upgrade_upgrade-class2'],d=assembly.RECIPES['upgrade_upgrade-class2-drone'];
 assert.equal(a.costs[0].parts[0].ammount,2);assert.equal(b.costs[0].parts[0].ammount,3);assert.equal(d.costs[0].parts[0].ammount,3);assert.ok(a.costs.at(-1).parts[0].ammount>a.costs[0].parts[0].ammount);
 const target=give('equipment_weapon_laser_lf-3'),old=give('resource_collectable_axion-beam-regulator',999);give(policy.UPGRADE,100);const wallet=players.loadPlayer(pid).uridium;
 const cost=a.costs.filter(c=>c.level<=4).reduce((n,c)=>n+c.parts[0].ammount,0);assembly.build(pid,'upgrade_upgrade-class1',4,target,1000);assert.equal(stock(policy.UPGRADE),100-cost);assert.equal(players.loadPlayer(pid).uridium,wallet);assert.equal(db.prepare('SELECT amount FROM items WHERE id=?').get(old).amount,999);
 assert.throws(()=>assembly.build(pid,'upgrade_upgrade-class1',4,target,1000),/devam/);assert.equal(stock(policy.UPGRADE),100-cost);
 const due=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND target_id=?').get(pid,target).due_at;assembly.collect(pid,'upgrade_upgrade-class1',target,due);assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(target).upgrade_level,4);
});
test('craft charges Convert only and leaves formerly required ship and other ingredients untouched',()=>{
 const recipe='recipe_blueprint-ship-goliath-plus',r=assembly.RECIPES[recipe],cost=r.costs[0].parts[0].ammount;
 const ship=db.prepare("INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,'ship_goliath',1000)").run(pid);give(policy.CONVERT,cost);const uri=players.loadPlayer(pid).uridium,credits=players.loadPlayer(pid).credits;
 assembly.build(pid,recipe,1,0,1000);assert.equal(stock(policy.CONVERT),0);assert.ok(db.prepare('SELECT id FROM ships WHERE id=?').get(Number(ship.lastInsertRowid)));assert.equal(players.loadPlayer(pid).uridium,uri);assert.equal(players.loadPlayer(pid).credits,credits);
 const due=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=?').get(pid,recipe).due_at;assembly.collect(pid,recipe,0,due);assert.equal(db.prepare("SELECT COUNT(*) n FROM ships WHERE player_id=? AND loot_id='ship_goliath-plus'").get(pid).n,1);
});
test('insufficient modules and storage failures roll back both purchases and builds',()=>{
 const target=give('equipment_weapon_laser_lf-4');give(policy.UPGRADE,2);assert.throws(()=>assembly.build(pid,'upgrade_upgrade-class2',1,target,1000),/malzeme/);assert.equal(stock(policy.UPGRADE),2);
 give(policy.UPGRADE,1);db.exec("CREATE TRIGGER fail_module_job BEFORE INSERT ON assembly_jobs BEGIN SELECT RAISE(ABORT,'storage-test'); END");assert.throws(()=>assembly.build(pid,'upgrade_upgrade-class2',1,target,1000),/storage-test/);assert.equal(stock(policy.UPGRADE),3);
 db.exec("CREATE TRIGGER fail_module_purchase BEFORE INSERT ON items WHEN NEW.loot_id='resource_convert-module' BEGIN SELECT RAISE(ABORT,'purchase-test'); END");const uri=players.loadPlayer(pid).uridium;assert.equal(economy.purchase(pid,policy.CONVERT,2).result,'error');assert.equal(players.loadPlayer(pid).uridium,uri);assert.equal(stock(policy.CONVERT),0);
});
test('module capacity and forged quantities cannot charge or overflow stock',()=>{
 give(policy.UPGRADE,1000000000);const uri=players.loadPlayer(pid).uridium;assert.equal(economy.purchase(pid,policy.UPGRADE,1).result,'error');for(const n of [0,-1,1.5,Infinity,10000001])assert.equal(economy.purchase(pid,policy.CONVERT,n).result,'error');assert.equal(stock(policy.UPGRADE),1000000000);assert.equal(players.loadPlayer(pid).uridium,uri);
});
test('pending jobs preserve result but new skip consumes modules rather than historical currency/materials',()=>{
 const target=give('equipment_weapon_laser_lf-4');give(policy.UPGRADE,10);assembly.build(pid,'upgrade_upgrade-class2',1,target,1000);const before=stock(policy.UPGRADE),uri=players.loadPlayer(pid).uridium;
 db.prepare('UPDATE assembly_jobs SET skip_json=? WHERE player_id=?').run(JSON.stringify([{lootID:'currency_uridium',ammount:9000000}]),pid);assembly.skip(pid,'upgrade_upgrade-class2',target,2000);assert.equal(stock(policy.UPGRADE),before-1);assert.equal(players.loadPlayer(pid).uridium,uri);assembly.collect(pid,'upgrade_upgrade-class2',target,2000);assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(target).upgrade_level,1);
});
