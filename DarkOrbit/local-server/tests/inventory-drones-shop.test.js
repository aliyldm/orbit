'use strict';
const {test,beforeEach,afterEach}=require('node:test');
const assert=require('node:assert/strict');
const dbModule=require('../game/db');
const players=require('../game/db/players');
const inv=require('../game/inventory');
const drones=require('../game/drones');
const economy=require('../game/economy');
const World=require('../game/world');
const codec=require('../game/codec/codec');
const ammo=require('../game/ammo');
const starter=require('../config.json').starter;
let db,pid,ship,other;
const current=World.current;
beforeEach(()=>{
 dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;
 const add=name=>{const a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');return players.createPlayer(Number(a.lastInsertRowid),name,1,starter);};
 pid=add('drones');other=add('other');ship=players.loadPlayer(pid).shipId;
 db.prepare('UPDATE players SET credits=10000000,uridium=10000000 WHERE id=?').run(pid);
});
afterEach(()=>{World.current=current;dbModule.close();});
const buy=()=>{assert.equal(economy.purchase(pid,'drone_iris',1).result,'success');return drones.owned(db,pid).at(-1).id;};
const addLaser=()=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(pid,'equipment_weapon_laser_lf-1').lastInsertRowid);
const move=(item,drone,config=1,to='drone')=>drones.move(pid,{hangarId:ship,from:{target:to==='drone'?'inventory':'drone',items:[item],configId:config,droneId:drone,slotset:'default'},to:{target:to,configId:config,droneId:drone,slotset:'default'}});

test('drone purchases debit the official price ladder and store ownership with combined eight limit',()=>{
 const start=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;
 for(let n=0;n<8;n++)buy();
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,start-647000);
 assert.equal(economy.purchase(pid,'drone_flax',1).result,'error');
 assert.equal(drones.owned(db,pid).length,8);
 assert.equal(db.prepare("SELECT COUNT(*) n FROM items WHERE player_id=? AND loot_id='drone_iris'").get(pid).n,0);
});
test('drone ownership failure rolls back the debit',()=>{
 db.exec("CREATE TRIGGER fail_drone BEFORE INSERT ON drones BEGIN SELECT RAISE(ABORT,'test'); END");
 const start=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;
 assert.equal(economy.purchase(pid,'drone_iris',1).result,'error');
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,start);
});
test('drone equipment uses real slots, ownership, both configs and contributes to laser stats',()=>{
 const d=buy(),laser=addLaser();move(laser,d);move(laser,d,2);
 assert.equal(inv.statItems(db,ship,1).filter(i=>i.category==='laser').length,2);
 assert.equal(drones.equipped(db,ship,2).length,1);
 assert.throws(()=>inv.move(pid,{hangarId:ship,from:{target:'inventory',configId:1,items:[laser]},to:{target:'ship',slotset:'lasers',configId:1}}),/başka/);
 assert.throws(()=>drones.move(other,{hangarId:players.loadPlayer(other).shipId,from:{target:'inventory',items:[laser]},to:{target:'drone',droneId:d,slotset:'default'}}),/Diroit/);
 move(laser,d,1,'inventory');assert.equal(drones.equipped(db,ship,1).length,0);assert.equal(drones.equipped(db,ship,2).length,1);
});
test('repair uses source price and sale returns equipped items to storage',()=>{
 const d=buy(),laser=addLaser();move(laser,d);
 db.prepare('UPDATE drones SET damage=50 WHERE id=?').run(d);
 const start=db.prepare('SELECT uridium,credits FROM players WHERE id=?').get(pid);
 drones.repair(pid,d);
 assert.equal(drones.droneFor(db,pid,d).damage,0);
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,start.uridium-500);
 drones.sell(pid,d);
 assert.equal(drones.owned(db,pid).length,0);assert.equal(drones.equipped(db,ship,1).length,0);
 assert.ok(db.prepare('SELECT * FROM items WHERE id=?').get(laser));
 assert.equal(db.prepare('SELECT credits FROM players WHERE id=?').get(pid).credits,start.credits+500000);
});
test('formation requires ownership and four drones and applies source stats',()=>{
 buy();assert.equal(economy.purchase(pid,'drone_formation_f-01-tu',1).result,'success');
 assert.throws(()=>drones.selectFormation(pid,'drone_formation_f-01-tu'),/dört/);
 buy();buy();buy();drones.selectFormation(pid,'drone_formation_f-01-tu');
 assert.equal(drones.formation(pid),1);
 assert.throws(()=>drones.selectFormation(pid,'drone_formation_f-13-bt'),/sahip/);
 const stats=drones.applyStats(pid,{shieldMax:10000,laserDamage:1000,hitMax:1000,speed:300,shieldAbsorb:.8});
 assert.equal(stats.shieldMax,11000);assert.equal(stats.laserDamage,925);
 assert.equal(drones.formationIds['drone_formation_f-3d-x'],42);
});
test('drone display and socket equipment packets round trip with owned ids',()=>{
 const d=buy(),laser=addLaser();move(laser,d);
 const p=players.loadPlayer(pid),cmd=inv.buildInit(p);
 assert.equal(cmd.drones[0].droneId,d);
 const decoded=codec.decode(codec.encode(inv.equipmentCommand(pid,ship))).obj;
 assert.deepEqual(decoded.droneConfigs[0].setDroneEquipment[0].defaults,[laser]);
 assert.equal(codec.decode(codec.encode(drones.buildCommands(p)[0])).obj.message,`0|n|d|${pid}|2|1|0|0`);
 const item=cmd.items.flatMap(p=>p.items).find(i=>i.itemid===laser);
 assert.equal(item.lootType,'net.bigpoint.darkorbit.asset.weapon.LaserType');
});
test('portal hangar renders actual drone slotsets and assignments',()=>{
 const d=buy(),laser=addLaser();move(laser,d);
 const api=require('../web/inventory-api'),body=new URLSearchParams({action:'getHangar',params:Buffer.from(JSON.stringify({params:{hi:ship}})).toString('base64')});
 const result=JSON.parse(Buffer.from(api.handle(pid,body).body,'base64').toString());
 const hangar=result.data.ret.hangars[0],general=hangar.general.drones[0];
 assert.equal(general.I,d);
 assert.equal(result.data.ret.itemInfo.find(i=>i.L===general.L).levels[0].slotsets.default.Q,2);
 assert.deepEqual(hangar.config[1].drones[d].EQ.default,[laser]);
});
test('socket shop listing and buy response use real purchase and reject mismatched category',()=>{
 const handlers=new Map(),sent=[];
 require('../game/handlers/shop').register((name,fn)=>handlers.set(name,fn),{sendCmd:(s,c)=>sent.push(c)});
 const session={player:players.loadPlayer(pid)};
 handlers.get('ShopItemListRequest')(session,{category:'drone'});
 const list=codec.decode(codec.encode(sent.at(-1))).obj;
 assert.equal(list.itemList.find(i=>i.lootId==='drone_iris').price[0],15000);
 handlers.get('ShopItemBuyRequest')(session,{lootId:'drone_iris',category:'drone',amount:1,action:'buy',buyCategory:'drone'});
 assert.equal(sent.at(-2).resultId,1);assert.equal(drones.owned(db,pid).length,1);
 handlers.get('ShopItemBuyRequest')(session,{lootId:'drone_iris',category:'laser',amount:1});
 assert.equal(sent.at(-1).resultId,0);assert.equal(drones.owned(db,pid).length,1);
});
test('initial ammo menu counters and tooltips use own inventory and selected rocket',()=>{
 const p=players.loadPlayer(pid);p.rocket='ammunition_rocket_plt-2026';
 const commands=ammo.buildAmmoCommands(p),laser=commands.find(c=>c.menuItemId===ammo.DEFAULT_AMMO);
 assert.equal(laser.counterValue,5000);assert.equal(laser.selected,true);
 assert.ok(JSON.stringify(laser.toolTipItemBar).includes('5000'));
 const r=commands.find(c=>c.menuItemId==='ammunition_rocket_r-310');assert.equal(r.counterValue,20);assert.equal(r.selected,false);
 assert.equal(codec.decode(codec.encode(laser)).obj.counterValue,5000);
});
test('config switch stores independent shield pools',()=>{
 db.prepare('UPDATE ships SET shield=1500 WHERE id=?').run(ship);
 inv.switchConfig(pid,ship,2);assert.equal(db.prepare('SELECT shield FROM ships WHERE id=?').get(ship).shield,0);
 db.prepare('UPDATE ships SET shield=2000 WHERE id=?').run(ship);
 inv.switchConfig(pid,ship,1);assert.equal(db.prepare('SELECT shield FROM ships WHERE id=?').get(ship).shield,1500);
 inv.switchConfig(pid,ship,2);assert.equal(db.prepare('SELECT shield FROM ships WHERE id=?').get(ship).shield,2000);
});
test('heavy launcher uses the source heavy_guns capacity in both configurations',()=>{
 const launcher=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(pid,'equipment_weapon_rocketlauncher_hst-2').lastInsertRowid);
 for(const config of [1,2])inv.move(pid,{hangarId:ship,from:{target:'inventory',configId:config,items:[launcher]},to:{target:'ship',slotset:'heavy_guns',configId:config}});
 const packet=codec.decode(codec.encode(inv.equipmentCommand(pid,ship))).obj;
 assert.deepEqual(packet.shipConfigs[0].rocket,[launcher]);assert.deepEqual(packet.shipConfigs[1].rocket,[launcher]);
 const ammoId=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(pid,'ammunition_laser_lcb-10').lastInsertRowid);
 assert.throws(()=>inv.move(pid,{hangarId:ship,from:{target:'inventory',items:[ammoId]},to:{target:'ship',slotset:'lasers'}}),/takılamaz/);
});
test('CPU slot extender expands only its configuration and cannot strand occupied extras',()=>{
 const put=id=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(pid,id).lastInsertRowid);
 const moveExtra=id=>inv.move(pid,{hangarId:ship,from:{target:'inventory',items:[id],configId:1},to:{target:'ship',slotset:'extras',configId:1}});
 const extender=put('equipment_extra_cpu_sle-01');moveExtra(extender);
 assert.equal(inv.freeSlots(db,ship,'extra',1).length,3);assert.equal(inv.freeSlots(db,ship,'extra',2).length,2);
 for(let n=0;n<3;n++)moveExtra(put('equipment_extra_cpu_ags-x'));
 assert.throws(()=>inv.move(pid,{hangarId:ship,from:{target:'ship',items:[extender],configId:1,slotset:'extras'},to:{target:'inventory',configId:1}}),/genişletilmiş/);
 assert.equal(inv.equipmentCommand(pid,ship).extrasSlotsSize1,4);
});
test('owned ship design purchase and offline activation preserve base ship and enforce compatibility',()=>{
 assert.equal(economy.purchase(pid,'ship_pusat',1).result,'success');
 const pusat=db.prepare("SELECT * FROM ships WHERE player_id=? AND loot_id='ship_pusat'").get(pid);
 const design='ship_pusat_design_pusat-frost';
 const start=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;
 assert.equal(economy.purchase(pid,design,1).result,'success');
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,start-250000);
 assert.equal(economy.purchase(pid,design,1).result,'error');
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,start-250000);
 assert.throws(()=>inv.changeDesign(pid,ship,design),/uymuyor/);
 inv.changeDesign(pid,pusat.id,design);
 assert.equal(inv.shipAppearance(db,inv.shipFor(db,pid,pusat.id)),design);
 assert.equal(inv.shipFor(db,pid,pusat.id).loot_id,'ship_pusat');
 World.current=()=>({livePlayer:()=>({})});assert.throws(()=>inv.changeDesign(pid,pusat.id,'ship_pusat'),/oyundan/);
});
test('configuration import moves both layouts and drone gear without duplicating or deleting items',()=>{
 const target=Number(db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,1000)').run(pid,'ship_liberator').lastInsertRowid);
 const d=buy(),laser=addLaser();move(laser,d,2);
 const original=inv.equipped(db,ship,1).map(i=>i.id),count=db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=?').get(pid).n;
 assert.ok(inv.compatibleShips(pid,ship).some(s=>s.hangarId===target));
 inv.importConfig(pid,ship,target);
 assert.equal(inv.equipped(db,ship,1).length,0);assert.deepEqual(inv.equipped(db,target,1).map(i=>i.id),original);
 assert.equal(drones.equipped(db,target,2)[0].id,laser);
 assert.equal(db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=?').get(pid).n,count);
});
test('saved layouts include drone equipment and restore it after clearing',()=>{
 const d=buy(),laser=addLaser();move(laser,d,2);
 inv.saveLayout(pid,ship);inv.clear(pid,ship,2);
 assert.equal(drones.equipped(db,ship,2).length,0);
 assert.equal(inv.loadLayout(pid,ship),true);assert.equal(drones.equipped(db,ship,2)[0].id,laser);
});
test('PET and fuel purchases commit ownership and fractional source fuel cost atomically',()=>{
 const pet=require('../game/pet');
 assert.equal(economy.purchase(pid,'pet_pet10',1).result,'success');
 assert.ok(pet.owned(pid));
 const before=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;
 assert.equal(economy.purchase(pid,'resource_pet-fuel',3).result,'success');
 assert.equal(pet.owned(pid).fuel,3);
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,before-.75);
 assert.equal(economy.purchase(pid,'resource_pet-fuel',100000).result,'error');
 assert.equal(pet.owned(pid).fuel,3);
 assert.equal(economy.purchase(pid,'pet_pet10',1).result,'error');
});
test('equipped cosmetic design uses the exact main gameXML legacy design id',()=>{
 const d=buy();assert.equal(economy.purchase(pid,'drone_designs_champion',1).result,'success');
 const design=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='drone_designs_champion'").get(pid).id;
 drones.move(pid,{hangarId:ship,from:{target:'inventory',items:[design],configId:1},to:{target:'drone',droneId:d,slotset:'visual',configId:1}});
 assert.equal(drones.designId('drone_designs_champion'),25);
 assert.equal(drones.buildCommands(players.loadPlayer(pid))[0].message,`0|n|d|${pid}|2|1|0|25`);
});
test('socket shop aliases match real client categories',()=>{
 const list=require('../game/handlers/shop').list,p=players.loadPlayer(pid);
 assert.ok(list(p,'laser').itemList.some(i=>i.lootId==='equipment_weapon_laser_lf-1'));
 assert.ok(list(p,'ammunition').itemList.some(i=>i.lootId==='ammunition_laser_lcb-10'));
 assert.ok(list(p,'petgear').itemList.some(i=>i.lootId==='equipment_petgear_g-al1'));
 assert.ok(list(p,'shipdesign').itemList.some(i=>i.lootId==='ship_pusat_design_pusat-frost'));
});
test('compact inventory accepts loose ship equipment and the exact Flash move persists it',()=>{
 assert.equal(economy.purchase(pid,'equipment_weapon_laser_lf-3',2).result,'success');
 const api=require('../web/inventory-api');
 const request=(action,params)=>JSON.parse(Buffer.from(api.handle(pid,new URLSearchParams({action,params:Buffer.from(JSON.stringify(params)).toString('base64')})).body,'base64').toString());
 let response=request('getHangar',{params:{hi:ship}}),ret=response.data.ret;
 const loose=ret.items.filter(i=>response.data.map.lootIds[i.L]==='equipment_weapon_laser_lf-3');
 assert.equal(loose.length,2);
 for(const item of loose){
  // InventoryViewMediator uppercases ActionIdentifiers before GridComponent;
  // truthiness; EQH:0 would become the truthy string "0" and hide this row.
  const info=ret.itemInfo.find(t=>t.L===item.L);
  assert.ok(info.EB.includes('SHIP'));
  assert.equal(Object.hasOwn(item,'EQH'),false);
  const equippedHangar=Object.hasOwn(item,'EQH')?String(item.EQH):undefined;
  assert.equal(Boolean(equippedHangar)&&equippedHangar!==String(ship),false);
 }
 assert.equal(request('move',{params:{hi:ship},from:{target:'inventory',configId:1,items:[String(loose[0].I)]},to:{target:'ship',configId:1,slotset:'lasers'}}).data.ret,true);
 response=request('getHangar',{params:{hi:ship}});
 assert.ok(response.data.ret.hangars.find(h=>Number(h.hangarID)===ship).config[1].ship.EQ.lasers.includes(loose[0].I));
 assert.equal(response.data.ret.items.find(i=>i.I===loose[0].I).EQH,ship);
});
test('old database without drone catalogue rows accepts real drone ownership',()=>{
 db.prepare("DELETE FROM item_types WHERE loot_id='drone_iris'").run();
 assert.equal(economy.purchase(pid,'drone_iris',1).result,'success');
 assert.equal(drones.owned(db,pid).length,1);
 assert.equal(db.prepare("SELECT category FROM item_types WHERE loot_id='drone_iris'").get().category,'drone');
 assert.equal(db.prepare("SELECT COUNT(*) n FROM items WHERE player_id=? AND loot_id='drone_iris'").get(pid).n,0);
});
test('numeric portal booster SKU maps to its source booster id and commits the ledger',()=>{
 db.prepare("DELETE FROM item_types WHERE loot_id='booster_ep-b01'").run();
 const before=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;
 assert.equal(economy.purchase(pid,'1',1).result,'success');
 assert.ok(db.prepare("SELECT * FROM player_boosters WHERE player_id=? AND loot_id='booster_ep-b01'").get(pid));
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,before-10000);
 assert.equal(economy.purchase(pid,'21',1).result,'success');
 assert.ok(db.prepare("SELECT * FROM player_boosters WHERE player_id=? AND loot_id='booster_cd-b01'").get(pid));
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,before-20000);
});
test('failed booster ledger storage rolls back its debit',()=>{
 const before=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;
 db.exec("CREATE TRIGGER fail_booster BEFORE INSERT ON player_boosters BEGIN SELECT RAISE(ABORT,'storage'); END");
 assert.equal(economy.purchase(pid,'3',1).result,'error');
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,before);
});
test('drone experience advances all six tiers separately from sixteen upgrade levels',()=>{
 const d=buy(),shield=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(pid,'equipment_generator_shield_sg3n-b02').lastInsertRowid);
 move(shield,d);const base=drones.statItems(db,ship,1)[0].shield;
 drones.awardPoints(pid,99);assert.equal(drones.droneFor(db,pid,d).level,0);
 drones.awardPoints(pid,1);assert.equal(drones.droneFor(db,pid,d).level,1);
 drones.awardPoints(pid,1500);assert.equal(drones.droneFor(db,pid,d).level,5);
 assert.equal(drones.droneFor(db,pid,d).upgrade_level,0);
 assert.equal(drones.statItems(db,ship,1)[0].shield,base*1.2);
 assert.equal(drones.views(pid)[0].nextLevel,0);
 db.prepare('UPDATE drones SET damage=20 WHERE id=?').run(d);drones.repair(pid,d);
 assert.equal(drones.droneFor(db,pid,d).level,4);assert.equal(drones.droneFor(db,pid,d).experience,800);
});
test('drone NPC points follow the historical ship matrix and seasonal overrides are explicit',()=>{
 assert.equal(drones.npcPoints({typeId:'ship_phoenix'},{def:{name:'-=[ Streuner ]=-'}}),4);
 assert.equal(drones.npcPoints({typeId:'ship_liberator'},{def:{name:'-=[ Lordakia ]=-'}}),2);
 assert.equal(drones.npcPoints({typeId:'ship_goliath'},{def:{name:'-=[ Streuner ]=-'}}),0);
 assert.equal(drones.npcPoints({typeId:'ship_goliath'},{def:{name:'-=[ Kristallon ]=-'}}),18);
 assert.equal(drones.npcPoints({typeId:'ship_goliath'},{def:{name:'Curcubitor',typeId:119,reward:{ep:420}}},{drones:{pointsByNpc:{119:7}}}),7);
});
