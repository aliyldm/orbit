'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),assembly=require('../game/assembly'),codec=require('../game/codec/codec'),World=require('../game/world'),config=require('../config'),inventory=require('../game/inventory'),drones=require('../game/drones'),pet=require('../game/pet'),META=require('../docs/client-map.items.json').items;
let db,f;
beforeEach(()=>{
 database.close();db=database.open(':memory:');const account=Number(db.prepare("INSERT INTO accounts(username,password_hash,created_at)VALUES('native-tabs-qa','test',0)").run().lastInsertRowid),id=players.createPlayer(account,'Native Tabs',1,{...config.starter,ship:'ship_goliath',credits:1000000000,uridium:1000000000}),world=World.instance(config),out=[];
 const send=(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);out.push(decoded.obj);};const session={world,send(b){const decoded=codec.decode(b.subarray(3));assert.equal(decoded.rest,0);out.push(decoded.obj);},close(){}};
 world.login(session,id);const handlers=new Map();require('../game/handlers/assembly').register((name,fn)=>handlers.set(name,fn),{sendCmd:send});f={id,world,p:world.player,s:session,out,send,handlers};
});
afterEach(()=>{f.world.removeSession(f.s);database.close();});
function give(id,n=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,n).lastInsertRowid);}
function decodedInit(){return assembly.buildInit(f.p).map(c=>codec.decode(codec.encode(c)).obj);}
// Source-derived UpgradeProxy/UpgradeTypeModel projection. A type is visible
// only when a generic target0 state and a matching owned inventory target exist.
function nativeTargets(commands,kind){
 const definitions=commands.find(c=>c._==='AssemblyRecipeContentModule').recipes.filter(c=>c.targetItemId===0&&c.recipeLootId.startsWith(kind)),items=commands.find(c=>c._==='UserInventoryModule').inventoryItemModules,out=new Set();
 for(const definition of definitions){const recipe=assembly.RECIPES[definition.recipeLootId];for(const item of items){if(!recipe.targets?.includes(item.lootId)||!META[item.lootId]?.upgradable)continue;if(kind==='disassemble_'&&(item.upgradeLevel<=0||item.hangarId!==0))continue;if(kind==='upgrade_'&&item.upgradeLevel>=META[item.lootId].upgradable.levels)continue;out.add(item.itemId);}}
 return out;
}

test('shipped native source requires target0 recipe states and treats every nonzero hangar binding as equipped',()=>{
 const root=path.join(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit');
 const proxy=fs.readFileSync(path.join(root,'mvc/crafting/upgrade/model/UpgradeProxy.as'),'utf8'),type=fs.readFileSync(path.join(root,'mvc/crafting/upgrade/model/UpgradeTypeModel.as'),'utf8'),pair=fs.readFileSync(path.join(root,'mvc/crafting/upgrade/model/UpgradeRecipeItemPair.as'),'utf8');
 assert.match(proxy,/if\(_loc2_\.targetId == 0\)[\s\S]*?addState\(_loc2_\)/);assert.match(type,/param1\.recipes\.length > 0 && param1\.hasTargets/);assert.match(pair,/!param1\.item\.isEquipped/);
 const commands=decodedInit(),recipes=commands[0].recipes,cap=assembly.capabilities();assert.equal(cap.upgrade.sourceRecipeClasses.length,15);assert.equal(cap.disassembly.sourceRecipeClasses.length,8);
 for(const id of [...cap.upgrade.sourceRecipeClasses,...cap.disassembly.sourceRecipeClasses])assert.ok(recipes.some(r=>r.recipeLootId===id&&r.targetItemId===0),id);
 const equippedStarter=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='equipment_weapon_laser_lf-1'").get(f.id).id;assert.ok(nativeTargets(commands,'upgrade_').has(equippedStarter));
 const broken=structuredClone(commands);broken[0].recipes=broken[0].recipes.filter(r=>r.targetItemId!==0);assert.equal(nativeTargets(broken,'upgrade_').size,0,'the former payload reproduces the actual empty-tab condition');
});

test('owned ship/config2/drone/PET equipment and drones appear in Upgrade, while only genuinely free upgraded items appear in Disassembly',()=>{
 const laser='equipment_weapon_laser_lf-4',free=give(laser),second=give(laser),onDrone=give(laser),onPet=give(laser),iris=drones.addOwned(db,f.id,'drone_iris');
 inventory.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[second],configId:2},to:{target:'ship',slotset:'lasers',configId:2}});
 drones.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[onDrone],configId:1},to:{target:'drone',droneId:iris,slotset:'default',configId:1}});
 pet.addOwned(db,f.id);pet.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[onPet],configId:1},to:{target:'pet',slotset:'lasers',configId:1}});
 for(const id of [free,second,onDrone,onPet])db.prepare('UPDATE items SET upgrade_level=2 WHERE id=?').run(id);const cpu=give('equipment_extra_cpu_jp-02'),resource=give('resource_collectable_axion-beam-regulator',50),commands=decodedInit(),up=nativeTargets(commands,'upgrade_'),down=nativeTargets(commands,'disassemble_');
 for(const id of [free,second,onDrone,onPet,assembly.DRONE_OFFSET+iris])assert.ok(up.has(id),String(id));assert.ok(!up.has(cpu));assert.ok(!up.has(resource));assert.ok(down.has(free));for(const id of [second,onDrone,onPet])assert.ok(!down.has(id));
 const modules=commands[1].inventoryItemModules;for(const id of [second,onDrone,onPet])assert.equal(modules.find(i=>i.itemId===id).hangarId,f.p.shipId);
 for(const id of [second,onDrone,onPet])assert.throws(()=>assembly.build(f.id,'disassemble_disassemble-class2',1,id),/takılı olmayan/);
});

test('real shop purchase→equipped upgrade→native claim refreshes visible level and actual laser stats once',()=>{
 const loot='equipment_weapon_laser_lf-3',result=require('../game/economy').purchase(f.id,loot,1);assert.equal(result.result,'success');const item=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? ORDER BY id DESC').get(f.id,loot).id;
 const refresh=[f.out.findLast(c=>c._==='AssemblyRecipeContentModule'),f.out.findLast(c=>c._==='UserInventoryModule')];assert.ok(refresh.every(Boolean),'the real live purchase must push the original crafting inventory without a relogin or manual refresh');assert.ok(nativeTargets(refresh,'upgrade_').has(item));assert.ok(refresh[0].recipes.every(r=>/^(upgrade_|disassemble_)/.test(r.recipeLootId)),'a purchase update must not resend hundreds of ordinary recipes');
 inventory.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item],configId:1},to:{target:'ship',slotset:'lasers',configId:1}});const before=f.p.stats.laserDamage;give('resource_upgrade-module',10);
 const request=codec.decode(codec.encode({_:'AssemblyBuildRequest',recipeLootId:'upgrade_upgrade-class1',amount:1,targetItemId:item})).obj;f.handlers.get('AssemblyBuildRequest')(f.s,request);const job=db.prepare('SELECT * FROM assembly_jobs WHERE player_id=? AND target_id=?').get(f.id,item);assert.ok(job);assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(item).upgrade_level,0);
 db.prepare('UPDATE assembly_jobs SET due_at=0 WHERE player_id=? AND target_id=?').run(f.id,item);f.handlers.get('AssemblyCollectRequest')(f.s,codec.decode(codec.encode({_:'AssemblyCollectRequest',recipeLootId:'upgrade_upgrade-class1',targetItemId:item})).obj);
 assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(item).upgrade_level,1);assert.ok(f.p.stats.laserDamage>before);assert.equal(f.out.findLast(c=>c._==='UserInventoryModule').inventoryItemModules.find(i=>i.itemId===item).upgradeLevel,1);assert.throws(()=>assembly.collect(f.id,'upgrade_upgrade-class1',item),/tamamlanmış/);
});

test('free upgraded item has native disassembly state and real claim removes it with exact source refunds',()=>{
 const target=give('equipment_weapon_laser_lf-4');db.prepare('UPDATE items SET upgrade_level=1 WHERE id=?').run(target);assert.ok(nativeTargets(decodedInit(),'disassemble_').has(target));
 const r=assembly.RECIPES['disassemble_disassemble-class2'],parts=r.costs.find(c=>c.level===1).parts;for(const p of parts.filter(p=>p.ammount>0))if(!p.lootID.startsWith('currency_'))give(p.lootID,p.ammount);
 const before=new Map(parts.filter(p=>p.ammount<0).map(p=>[p.lootID,assembly.count(db,f.id,p.lootID)]));assembly.build(f.id,'disassemble_disassemble-class2',1,target,1000);assembly.collect(f.id,'disassemble_disassemble-class2',target,1000);
 assert.ok(!nativeTargets(decodedInit(),'disassemble_').has(target));for(const p of parts.filter(p=>p.ammount<0))assert.equal(assembly.count(db,f.id,p.lootID),before.get(p.lootID)-p.ammount);
});

test('16-level classic source class rejects further upgrades without charging; CPUs cannot be forged into valid targets',()=>{
 const laser=give('equipment_weapon_laser_lf-1'),cpu=give('equipment_extra_cpu_jp-02');db.prepare('UPDATE items SET upgrade_level=15 WHERE id=?').run(laser);const before=players.loadPlayer(f.id).credits;
 assert.throws(()=>assembly.build(f.id,'upgrade_upgrade-class0',16,laser),/seviyesi/);assert.throws(()=>assembly.build(f.id,'upgrade_upgrade-class0',1,cpu),/hedefi/);assert.equal(players.loadPlayer(f.id).credits,before);
});

test('unsupported Stabilize/Hyperforge actions return explicit native explanation and cannot spend or destroy owned placeholders',()=>{
 const target=give('equipment_shipupgrade_dmg-xt10'),core=give('equipment_core_ax-10'),before=players.loadPlayer(f.id);
 for(const name of ['UnstableModuleRerollRequest','UnstableModuleRestabiliseRequest','UnstableModuleRecycleRequest','QuantumFluidCoreRequest']){assert.equal(f.handlers.get(name)(f.s,{itemId:target,ItemId:core,type:1}),false);assert.ok(f.out.at(-1).message.includes('henüz yok'));}
 assert.equal(assembly.capabilities().restabilize.supported,false);assert.equal(assembly.capabilities().hyperforge.supported,false);assert.equal(players.loadPlayer(f.id).uridium,before.uridium);assert.equal(db.prepare('SELECT amount FROM items WHERE id=?').get(target).amount,1);assert.equal(db.prepare('SELECT amount FROM items WHERE id=?').get(core).amount,1);
});
