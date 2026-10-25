'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),pet=require('../game/pet'),levels=require('../game/pet-levels'),gates=require('../game/galaxy-gates'),systems=require('../game/handlers/systems'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),codec=require('../game/codec/codec');
let db,f;const originalCurrent=World.current;
beforeEach(()=>{
 database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('original-rules','testpass'),'QA',1,require('../config').starter);pet.addOwned(db,id);pet.addFuel(db,id,10000);
 const world=new World(require('../config')),commands=[],session={world,send(){},close(){}};World.current=()=>world;world.login(session,id);world.petSend=(s,c)=>{codec.encode(c);commands.push(c);};const combat=new Combat(world,world.petSend);combat.map=maps.getMap(1);Object.assign(world.player,{x:6000,y:6000});pet.launch(world);f={world,session,combat,commands,id,p:world.player};
});
afterEach(()=>{try{f?.world.removeSession(f.session);}finally{World.current=originalCurrent;database.close();}});
function equip(id,slot){const item=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(f.id,id).lastInsertRowid);pet.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item],configId:1},to:{target:'pet',slotset:slot,configId:1}});return item;}
test('PET original absolute XP thresholds have exact boundaries through20, with no extra level at cap',()=>{
 for(let level=1;level<=20;level++){assert.equal(levels.levelFor(levels.EXPERIENCE[level]),level);assert.equal(levels.levelFor(levels.EXPERIENCE[level]-1),level-1);}
 assert.equal(levels.next(15),39000000);assert.equal(levels.next(19),150000000);assert.equal(levels.next(20),0);assert.equal(levels.levelFor(1e12),20);
});
test('PET receives exactly5% including tiny rewards, persists level20 and emits native level commands',()=>{
 const r=f.world.petRuntime;for(let i=0;i<20;i++)pet.awardExperience(f.world,1);assert.equal(pet.owned(f.id).experience,1);
 r.level=15;r.experience=27000000;pet.save(f.world);pet.awardExperience(f.world,240000000);assert.equal(pet.owned(f.id).level,16);assert.equal(pet.owned(f.id).experience,39000000);
 pet.awardExperience(f.world,2220000000);assert.equal(pet.owned(f.id).level,20);assert.equal(pet.owned(f.id).experience,150000000);
 assert.ok(f.commands.some(c=>c._==='PetLevelUpdateCommand'&&c.petLevel===20));pet.stop(f.world);pet.launch(f.world);assert.equal(f.world.petRuntime.level,20);
 assert.equal(pet.view(f.id).expNextLevel,0);assert.equal(pet.decoratePortal(f.id,{data:{ret:{items:[],itemInfo:[],hangars:[]},map:{lootIds:[],types:[]}}}).data.ret.itemInfo[0].levels.length,21);
});
test('passive level bonuses affect actual equipped PET damage/shield and persist in refreshed stats',()=>{
 equip('equipment_weapon_laser_lf-1','lasers');equip('equipment_generator_shield_sg3n-b02','generators');
 const baseLaser=db.prepare("SELECT damage FROM item_types WHERE loot_id='equipment_weapon_laser_lf-1'").get().damage,baseShield=db.prepare("SELECT shield FROM item_types WHERE loot_id='equipment_generator_shield_sg3n-b02'").get().shield;
 for(const [level,damage,shield]of [[1,1,1.02],[2,1.02,1.02],[15,1.12,1.15],[16,1.14,1.15],[17,1.14,1.16],[18,1.16,1.16],[20,1.16,1.18]]){
  db.prepare('UPDATE pets SET level=? WHERE player_id=?').run(level,f.id);const s=pet.stats(f.p);assert.ok(Math.abs(s.laserDamage-baseLaser*damage)<1e-9);assert.equal(s.shieldMax,Math.round(baseShield*shield));
 }
});
test('source tier4 protocols require PET20, charge the fixed special price and apply their actual source effect',()=>{
 const id='equipment_aiprotocol_ai-lm1',economy=require('../game/economy');db.prepare('UPDATE players SET uridium=3000000 WHERE id=?').run(f.id);f.p.uridium=3000000;
 db.prepare('UPDATE pets SET level=19 WHERE player_id=?').run(f.id);f.world.petRuntime.level=19;assert.equal(economy.purchase(f.id,id,1,'pet_protocol',4).result,'error');assert.equal(f.p.uridium,3000000);
 db.prepare('UPDATE pets SET level=20 WHERE player_id=?').run(f.id);f.world.petRuntime.level=20;assert.equal(economy.purchase(f.id,id,1,'pet_protocol',4).result,'success');assert.equal(f.p.uridium,2000000);
 const item=db.prepare('SELECT * FROM items WHERE player_id=? AND loot_id=?').get(f.id,id);assert.equal(item.pet_level,4);pet.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item.id],configId:1},to:{target:'pet',slotset:'protocols',configId:1}});assert.equal(pet.stats(f.p).effects.laserDamageMultiplier,1.06);
 const html=require('../web/portal/render').renderPage('internalDock','internalDockPetProtocols',f.p),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(html)[1]);assert.equal(rows[id].maxLevel,4);assert.equal(rows[id].levelItemShopData[4].price,1000000);assert.match(rows[id].levelItemShopData[4].description,/%6/);
 const vm=require('node:vm');let selected=4;const context={User:{getDiscountFactor:()=>.8},Shop:{Parameters:{itemData:rows},Item:{getId:()=>id},LevelSelector:{getSelectedLevel:()=>selected}}};vm.runInNewContext(require('../game/payment').portalScript.replace(/<\/?script[^>]*>/g,''),context);assert.equal(context.User.getDiscountFactor(),1);selected=3;assert.equal(context.User.getDiscountFactor(),.8);
});
test('PET starts with original50k HP and XP alone cannot purchase automatic HP cap upgrades',()=>{
 assert.equal(pet.owned(f.id).hitpoints,50000);assert.equal(pet.stats(f.p).hitMax,50000);
 db.prepare('UPDATE pets SET level=20,experience=150000000 WHERE player_id=?').run(f.id);assert.equal(pet.stats(f.p).hitMax,50000);
 db.prepare('UPDATE pets SET hp_upgrade_level=20 WHERE player_id=?').run(f.id);assert.equal(pet.stats(f.p).hitMax,250000);
});
test('ownership alone cannot enter original Hades; source parts and lives remain untouched on denied jump',()=>{
 systems.gateInfo(f.p,db);db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=13').run(JSON.stringify(Array.from({length:45},(_,i)=>i+1)),f.id);assert.equal(gates.setup(f.session,13).errorCode,0);
 const before=db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=?').get(f.id),portal=gates.portalRows(f.world).find(g=>g.target_map===203);Object.assign(f.p,{x:portal.x,y:portal.y});
 assert.equal(gates.canEnter(f.world,203),false);assert.match(gates.entryRestriction(f.world,203),/4–8/);assert.equal(gates.portals(f.world).find(c=>c._==='MapAssetActionAvailableCommand').activatable,false);
 const game=require('../game/gameplay');game.register(()=>{},{sendCmd:f.world.petSend});assert.equal(game.jump(f.session,portal.id),false);assert.equal(f.session.jumping,undefined);assert.equal(f.p.mapId,1);
 assert.deepEqual(db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=?').get(f.id),before);assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message.includes('4–8')));
});
test('a saved solo Hades map evacuates to home without spawning or consuming another life',()=>{
 const queue=[];f.world.schedule=fn=>queue.push(fn);f.p.mapId=203;let destination;f.world.gatesChangeMap=(s,map,x,y)=>{destination={map,x,y};};f.combat.spawnAll();assert.equal(f.world.npcs.size,0);assert.equal(queue.length,1);queue[0]();assert.equal(destination.map,1);
});
test('level20 migration preserves PET ownership, both configurations and persistent module cooldowns',()=>{
 const {DatabaseSync}=require('node:sqlite'),old=new DatabaseSync(':memory:');old.exec('PRAGMA foreign_keys=ON;');
 const folder=path.join(__dirname,'../game/db/migrations');for(const file of fs.readdirSync(folder).filter(f=>f.endsWith('.sql')&&f<'030-'))old.exec(fs.readFileSync(path.join(folder,file),'utf8'));
 // Real populated schema; use a copy of the fixture player graph to satisfy FKs.
 old.exec('PRAGMA foreign_keys=OFF');old.prepare('INSERT INTO pets(player_id,name,level,experience,hitpoints,shield,fuel,gear,created_at,fuel_fraction)VALUES(17,?,15,27000000,1234,5678,87654,16,42,.25)').run('Preserved PET');old.exec('INSERT INTO pet_gear_state VALUES(17,16,123456789)');
 old.exec("INSERT INTO pet_equipment VALUES(17,1,1,'gear',0,123),(17,1,2,'gear',0,123)");
 const before=old.prepare('SELECT * FROM pets').all(),eq=old.prepare('SELECT * FROM pet_equipment').all(),cool=old.prepare('SELECT * FROM pet_gear_state').all();old.exec(fs.readFileSync(path.join(folder,'030-pet-level20.sql'),'utf8'));
 old.exec(fs.readFileSync(path.join(folder,'031-pet-hp-cap.sql'),'utf8'));
 assert.deepEqual(old.prepare('SELECT player_id,name,level,experience,hitpoints,shield,fuel,gear,created_at,fuel_fraction FROM pets').all(),before);assert.deepEqual(old.prepare('SELECT * FROM pet_equipment').all(),eq);assert.deepEqual(old.prepare('SELECT * FROM pet_gear_state').all(),cool);assert.equal(old.prepare('SELECT hp_upgrade_level n FROM pets').get().n,0);old.exec('UPDATE pets SET level=20');assert.throws(()=>old.exec('UPDATE pets SET level=21'));old.close();
});
test('implicit database reopen in a test worker uses memory and cannot migrate the real account store',()=>{
 assert.ok(process.env.NODE_TEST_CONTEXT);database.close();const memory=database.open();assert.equal(memory.prepare('PRAGMA database_list').all().find(d=>d.name==='main').file,'');assert.equal(memory.prepare('SELECT COUNT(*) n FROM accounts').get().n,0);
});
