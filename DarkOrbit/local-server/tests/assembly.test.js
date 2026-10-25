'use strict';
const {test,beforeEach,afterEach}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('fs'),os=require('os'),path=require('path');
const database=require('../game/db'),players=require('../game/db/players'),assembly=require('../game/assembly'),World=require('../game/world'),codec=require('../game/codec/codec');
const config=require('../config.json');
let db,pid,other;const originalCurrent=World.current;
function player(name){const a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');const id=players.createPlayer(Number(a.lastInsertRowid),name,1,config.starter);db.prepare('UPDATE players SET credits=10000000,uridium=10000000 WHERE id=?').run(id);return id;}
function give(id,amount=1,owner=pid){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(owner,id,amount).lastInsertRowid);}
function shieldCosts(){give('resource_convert-module',2);}
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;pid=player('craft');other=player('other');});
afterEach(()=>{World.current=originalCurrent;database.close();});
const recipe='recipe_blueprint-sg3n-b02';
test('recipe consumes exact Convert Module costs, persists time and awards only once after completion',()=>{
 shieldCosts();const cmd=assembly.build(pid,recipe,2,0,1000);
 assert.equal(cmd.status.remainingTimeMillis,10000);
 assert.equal(assembly.count(db,pid,'resource_convert-module'),0);
 assert.throws(()=>assembly.collect(pid,recipe,0,10999),/tamamlanmış/);
 assert.equal(assembly.status(pid,recipe,0,11000)._,'AssemblyRecipeReadyToCollectStatusModule');
 assembly.collect(pid,recipe,0,11000);
 assert.equal(assembly.count(db,pid,'equipment_generator_shield_sg3n-b02'),2);
 assert.equal(db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=? AND loot_id=?').get(pid,'equipment_generator_shield_sg3n-b02').n,2);
 assert.throws(()=>assembly.collect(pid,recipe,0,11001),/tamamlanmış/);
});
test('insufficient materials and failed job insert leave all input rows unchanged',()=>{
 give('resource_convert-module',1);
 give('resource_nano-condenser',1);give('resource_collectable_schism',50);
 assert.throws(()=>assembly.build(pid,recipe,2,0,1000),/malzeme/);
 assert.equal(assembly.count(db,pid,'resource_convert-module'),1);
 assert.equal(assembly.count(db,pid,'resource_nano-condenser'),1);
 db.exec("CREATE TRIGGER fail_job BEFORE INSERT ON assembly_jobs BEGIN SELECT RAISE(ABORT,'storage'); END");
 assert.throws(()=>assembly.build(pid,recipe,1,0,1000),/storage/);
 assert.equal(assembly.count(db,pid,'resource_convert-module'),1);assert.equal(assembly.count(db,pid,'resource_nano-condenser'),1);assert.equal(assembly.count(db,pid,'resource_collectable_schism'),50);
});
test('invalid quantity, unavailable schedules and duplicate builds are rejected',()=>{
 shieldCosts();for(const n of [0,-1,NaN,Infinity,1.5,10000001])assert.throws(()=>assembly.build(pid,recipe,n,0,1000),/miktarı/);
 World.current=()=>({livePlayer:()=>null,config:{assembly:{enableAllScheduled:false}}});
 assert.throws(()=>assembly.build(pid,'recipe_blueprint-hstrm-01-empyrian',1,0,1000),/kullanılamıyor/);
 World.current=()=>null;
 assembly.build(pid,recipe,1,0,1000);assert.throws(()=>assembly.build(pid,recipe,1,0,1000),/devam/);
});
test('ship crafting uses only Convert Modules and preserves the formerly required base ship',()=>{
 const ship=Number(db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,1000)').run(pid,'ship_goliath').lastInsertRowid);
 assert.throws(()=>assembly.build(pid,'recipe_blueprint-ship-goliath-plus',1,0,1000),/malzeme/);
 assert.ok(db.prepare('SELECT * FROM ships WHERE id=?').get(ship));
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,10000000);
 give('resource_convert-module',100);assembly.build(pid,'recipe_blueprint-ship-goliath-plus',1,0,1000);
 assert.equal(assembly.count(db,pid,'resource_convert-module'),0);assert.ok(db.prepare('SELECT * FROM ships WHERE id=?').get(ship));
 const job=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=?').get(pid,'recipe_blueprint-ship-goliath-plus');assembly.collect(pid,'recipe_blueprint-ship-goliath-plus',0,job.due_at);
 assert.ok(db.prepare("SELECT id FROM ships WHERE player_id=? AND loot_id='ship_goliath-plus'").get(pid));assert.ok(db.prepare('SELECT * FROM ships WHERE id=?').get(ship));
});
test('item upgrade validates ownership, exact per-level costs, skip payment and stat bonus',()=>{
 const target=give('equipment_weapon_laser_lf-4'),foreign=give('equipment_weapon_laser_lf-4',1,other);
 give('resource_upgrade-module',4);give('resource_collectable_axion-beam-regulator',4);give('resource_collectable_isochronate',1400);
 assert.throws(()=>assembly.build(pid,'upgrade_upgrade-class2',1,foreign,1000),/hedefi/);
 const before=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;
 assert.equal(assembly.build(pid,'upgrade_upgrade-class2',1,target,1000).status.remainingTimeMillis,80000);
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,before);assert.equal(assembly.count(db,pid,'resource_upgrade-module'),1);
 assembly.skip(pid,'upgrade_upgrade-class2',target,2000);assert.equal(assembly.count(db,pid,'resource_upgrade-module'),0);assert.equal(assembly.count(db,pid,'resource_collectable_isochronate'),1400);assert.equal(assembly.count(db,pid,'resource_collectable_axion-beam-regulator'),4);
 assembly.collect(pid,'upgrade_upgrade-class2',target,2000);
 assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(target).upgrade_level,1);
 const row=db.prepare('SELECT i.*,t.category,t.damage FROM items i JOIN item_types t ON t.loot_id=i.loot_id WHERE i.id=?').get(target);
 const stats=require('../game/stats').computeStats({hitpoints:1000,speed:300,cargo:100},[row]);assert.equal(stats.laserDamage,Math.round(row.damage*1.005));
});
test('source drone upgrade recipes target the correct owner and change shield equipment output',()=>{
 let d;database.tx(conn=>{d=require('../game/drones').addOwned(conn,pid,'drone_flax');});
 const shield=give('equipment_generator_shield_sg3n-b02'),ship=players.loadPlayer(pid).shipId;
 require('../game/drones').move(pid,{hangarId:ship,from:{target:'inventory',items:[shield],configId:1},to:{target:'drone',droneId:d,slotset:'default',configId:1}});
 const before=require('../game/drones').statItems(db,ship,1)[0].shield;
 give('resource_upgrade-module',1);
 assembly.build(pid,'upgrade_upgrade-class0-drone',1,assembly.DRONE_OFFSET+d,1000);
 assembly.collect(pid,'upgrade_upgrade-class0-drone',assembly.DRONE_OFFSET+d,21000);
 assert.equal(db.prepare('SELECT upgrade_level FROM drones WHERE id=?').get(d).upgrade_level,1);
 assert.equal(require('../game/drones').statItems(db,ship,1)[0].shield,before*1.004);
});
test('failed result award leaves completed job available for a safe retry',()=>{
 shieldCosts();assembly.build(pid,recipe,1,0,1000);
 db.exec("CREATE TRIGGER fail_result BEFORE INSERT ON items WHEN NEW.loot_id='equipment_generator_shield_sg3n-b02' BEGIN SELECT RAISE(ABORT,'storage'); END");
 assert.throws(()=>assembly.collect(pid,recipe,0,6000),/storage/);
 assert.equal(assembly.status(pid,recipe,0,6000)._,'AssemblyRecipeReadyToCollectStatusModule');
 db.exec('DROP TRIGGER fail_result');assembly.collect(pid,recipe,0,6000);assert.equal(assembly.count(db,pid,'equipment_generator_shield_sg3n-b02'),1);
});
test('own blueprints expose matching recipe and recipe/status/inventory packets round trip',()=>{
 const id='recipe_blueprint-phantom-legend';assert.equal(assembly.visible(db,pid,id),false);give(id);assert.equal(assembly.visible(db,pid,id),true);
 for(const cmd of assembly.buildInit(players.loadPlayer(pid),1000)){const decoded=codec.decode(codec.encode(cmd)).obj;assert.equal(decoded._,cmd._);}
 const commands=assembly.buildInit(players.loadPlayer(pid),1000);
 assert.ok(commands.find(c=>c._==='AssemblyRecipeContentModule').recipes.some(r=>r.recipeLootId===id));
 assert.ok(commands.find(c=>c._==='UserInventoryModule').inventoryItemModules.some(i=>i.lootId==='currency_uridium'&&i.amount===10000000));
});
test('jobs survive closing the database and continue after reopening',()=>{
 database.close();const dir=fs.mkdtempSync(path.join(os.tmpdir(),'darkorbit-assembly-')),file=path.join(dir,'test.db');
 try{
  db=database.open(file);pid=player('persist');shieldCosts();assembly.build(pid,recipe,1,0,1000);database.close();db=database.open(file);
  assert.equal(assembly.status(pid,recipe,0,2000).remainingTimeMillis,4000);assembly.collect(pid,recipe,0,6000);assert.equal(assembly.count(db,pid,'equipment_generator_shield_sg3n-b02'),1);
 }finally{database.close();for(const suffix of ['','-wal','-shm'])if(fs.existsSync(file+suffix))fs.unlinkSync(file+suffix);fs.rmdirSync(dir);}
});
test('assembly inventory uses live wallet and restores each window filter independently',()=>{
 const p=players.loadPlayer(pid);p.credits=12345;p.uridium=67890;World.current=()=>({livePlayer:id=>id===pid?p:null});
 assert.equal(assembly.inventoryCommand(pid).inventoryItemModules.find(i=>i.lootId==='currency_credits').amount,12345);
 const handlers=new Map();require('../game/handlers/assembly').register((n,f)=>handlers.set(n,f),{sendCmd:()=>{}});
 handlers.get('AssemblySetFilterRequest')({player:p},{assemblyWindowSettingsModule:{filterType:0,assemblyItemFilters:['weapons']}});
 handlers.get('AssemblySetFilterRequest')({player:p},{assemblyWindowSettingsModule:{filterType:1,assemblyItemFilters:['drones']}});
 const filters=assembly.buildInit(p).filter(c=>c._==='AssemblyWindowSettingsModule');
 assert.deepEqual(filters.find(c=>c.filterType===0).assemblyItemFilters,['weapons']);assert.deepEqual(filters.find(c=>c.filterType===1).assemblyItemFilters,['drones']);
 assert.equal(filters.length,3);
});
