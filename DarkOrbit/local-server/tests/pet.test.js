'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open,tx}=require('../game/db'),db=open(':memory:');
const players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),pet=require('../game/pet'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let n=0;
function fixture(withPet=true){
 const account=players.createAccount(`pet-qa-${++n}`,'test-pass'),id=players.createPlayer(account,'PET QA',1,config.starter);
 if(withPet)tx(d=>pet.addOwned(d,id));
 const commands=[],world=new World(config),session={world,send(){},close(){}};world.login(session,id);world.petSend=(s,c)=>{codec.encode(c);commands.push(c);};
 const combat=new Combat(world,world.petSend);combat.map=maps.getMap(1);Object.assign(world.player,{x:6000,y:6000});
 return{world,session,combat,commands,id,p:world.player};
}
function item(f,lootId){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(f.id,lootId).lastInsertRowid);}
function equip(f,id,slot,configuration=1){return pet.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[id],configId:configuration},to:{target:'pet',slotset:slot,configId:configuration}});}
function fuel(f,amount=100){tx(d=>pet.addFuel(d,f.id,amount));}
function tick(f){const now=Date.now();f.world.petRuntime.lastTick=now-1000;pet.tick(f.world,f.combat,now);}
function finish(f){f.world.removeSession(f.session);}
test('an unowned PET never appears in initialization or launches',()=>{
 const f=fixture(false);assert.deepEqual(pet.buildInit(f.world),[{_:'PetInitializationCommand',hasPet:false,hasFuel:false,petIsAlive:false}]);assert.equal(pet.launch(f.world),false);assert.equal(pet.view(f.id),null);finish(f);
});
test('ownership is unique and fuel capacity enforced without phantom inventory',()=>{
 const f=fixture();assert.throws(()=>tx(d=>pet.addOwned(d,f.id)),/bir P.E.T/);assert.throws(()=>tx(d=>pet.addOwned(d,f.id,2)),/bir P.E.T/);
 assert.equal(db.prepare("SELECT SUM(amount) n FROM items WHERE player_id=? AND loot_id='pet_pet10'").get(f.id).n,1);
 assert.throws(()=>tx(d=>pet.addFuel(d,f.id,100001)),/yeterli yer/);assert.equal(pet.owned(f.id).fuel,0);finish(f);
});
test('activation uses recovered PET ship type and all emitted commands encode',()=>{
 const f=fixture();assert.equal(pet.launch(f.world),false);fuel(f);assert.equal(pet.launch(f.world),true);
 assert.equal(f.commands.find(c=>c._==='PetHeroActivationCommand').shipType,12);
 assert.equal(f.commands.find(c=>c._==='PetHeroActivationCommand').ownerId,f.id);
 for(const c of [...pet.buildInit(f.world),pet.view(f.id),...pet.equipmentConfigs(f.id,f.p.shipId)])assert.equal(codec.decode(codec.encode(c)).obj._,c._);
 assert.equal(pet.typeFor(4),13);assert.equal(pet.typeFor(7),14);assert.equal(pet.typeFor(10),15);assert.equal(pet.typeFor(15),22);finish(f);
});
test('fuel consumption persists and disconnect stops runtime without offline consumption',()=>{
 const f=fixture();fuel(f,2);pet.launch(f.world);for(let i=0;i<20;i++)tick(f);assert.equal(pet.owned(f.id).fuel,1);assert.equal(f.world.petRuntime.fuel,1);finish(f);
 assert.equal(f.world.petRuntime,null);assert.equal(pet.owned(f.id).fuel,1);
});
test('fuel hotkey debits only actual capacity and a storage failure rolls back money',()=>{
 const f=fixture();f.p.uridium=10000;db.prepare('UPDATE players SET uridium=10000 WHERE id=?').run(f.id);
 assert.equal(pet.buyFuel(f.world,100),true);assert.equal(pet.owned(f.id).fuel,100);assert.equal(f.p.uridium,9975);
 db.exec("CREATE TRIGGER fail_pet_fuel BEFORE UPDATE OF fuel ON pets BEGIN SELECT RAISE(ABORT,'pet-storage-failure'); END");
 assert.throws(()=>pet.buyFuel(f.world,100),/storage/);assert.equal(f.p.uridium,9975);assert.equal(players.loadPlayer(f.id).uridium,9975);assert.equal(pet.owned(f.id).fuel,100);db.exec('DROP TRIGGER fail_pet_fuel');finish(f);
});
test('PET equipment checks owner, slots and active configurations',()=>{
 const f=fixture(),other=fixture();const laser=item(f,'equipment_weapon_laser_lf-1');
 assert.throws(()=>pet.move(other.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[laser]},to:{target:'pet',slotset:'lasers'}}),/bulunamadı/);
 assert.throws(()=>equip(f,laser,'generators'),/uymuyor/);equip(f,laser,'lasers');assert.equal(pet.stats(f.p).laserCount,1);
 assert.throws(()=>equip(f,laser,'lasers'),/başka/);equip(f,laser,'lasers',2);
 assert.equal(pet.equipmentConfigs(f.id,f.p.shipId)[1].laser[0],laser);
 db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(f.p.shipId);assert.equal(pet.stats(f.p).laserCount,1);finish(f);finish(other);
});
test('unowned and unequipped gears cannot activate, equipped gear state persists',()=>{
 const f=fixture();assert.equal(pet.selectGear(f.world,4),false);const gear=item(f,'equipment_petgear_g-al1');equip(f,gear,'gears');assert.equal(pet.selectGear(f.world,4),true);assert.equal(pet.owned(f.id).gear,4);assert.equal(pet.selectGear(f.world,10),false);finish(f);
});
test('autoloot travels at PET speed and collects with PET distance, once',()=>{
 const f=fixture();fuel(f);equip(f,item(f,'equipment_petgear_g-al1'),'gears');pet.launch(f.world);pet.selectGear(f.world,4);
 const {Collectables}=require('../game/collectables');f.world.collectables=new Collectables(f.world,f.world.petSend);
 const box=f.world.collectables.add({x:6500,y:6000,boxType:'BONUS_BOX',reward:{credits:200}},false);
 assert.ok(maps.dist(f.p,box)>180);tick(f);assert.equal(f.p.credits,200);assert.equal(f.world.collectables.boxes.has(box.hash),false);tick(f);assert.equal(f.p.credits,200);assert.ok(f.commands.some(c=>c._==='PetHarvestEffectCommand'));finish(f);
});
test('autoresource gear persists ore in owner cargo and rejects forged collector',()=>{
 const f=fixture();fuel(f);equip(f,item(f,'equipment_petgear_g-ar1'),'gears');pet.launch(f.world);pet.selectGear(f.world,5);
 const {Collectables}=require('../game/collectables');f.world.collectables=new Collectables(f.world,f.world.petSend);const box=f.world.collectables.add({x:6500,y:6000,oreType:0,amount:10},false);
 assert.equal(f.world.collectables.collect(f.session,{itemHash:box.hash},{x:6500,y:6000,active:true}),false);tick(f);
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=0').get(f.id).amount,10);finish(f);
});
test('both original collection gears harvest Palladium but autoloot does not harvest ordinary ore',()=>{
 for(const [lootId,type] of [['equipment_petgear_g-al1',4],['equipment_petgear_g-ar1',5]]){
  const f=fixture();Object.assign(f.p,{mapId:93,x:20000,y:22000});f.combat.map=maps.getMap(93);
  fuel(f);equip(f,item(f,lootId),'gears');pet.launch(f.world);pet.selectGear(f.world,type);
  const {Collectables}=require('../game/collectables');f.world.collectables=new Collectables(f.world,f.world.petSend);
  const ore=f.world.collectables.add({x:f.p.x+10,y:f.p.y,oreType:0,amount:1},false);
  const palladium=f.world.collectables.add({x:f.p.x+20,y:f.p.y,oreType:8,amount:1},false);
  tick(f);if(type===5)tick(f);
  assert.equal(f.world.collectables.boxes.has(palladium.hash),false);assert.equal(f.world.collectables.boxes.has(ore.hash),type===4);
  assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=8').get(f.id).amount,1);finish(f);
 }
});
test('guard damage uses equipped PET lasers and consumes actual owner ammo',()=>{
 const f=fixture();fuel(f);equip(f,item(f,'equipment_weapon_laser_lf-1'),'lasers');pet.launch(f.world);pet.selectGear(f.world,2);
 f.combat.rollHit=()=>true;
 const npc=f.combat.spawn({typeId:71,name:'Lordakia',hitpoints:2000,shield:2000,speed:200,damageMin:1,damageMax:1,reward:{},respawnMs:5000});Object.assign(npc,{x:6400,y:6000});f.session.attacking=npc.id;
 const ammo=require('../game/ammo'),before=ammo.count(f.p);tick(f);assert.equal(ammo.count(f.p),before-1);assert.ok(npc.hp<2000||npc.shield<2000);assert.ok(f.commands.some(c=>c._==='AttackHitCommand'&&c.attackerId===pet.petId(f.id)));finish(f);
});
test('PET destruction persists and repair atomically restores only this owner PET',()=>{
 const f=fixture();fuel(f);pet.launch(f.world);const npc={id:999,petAggro:pet.petId(f.id)};
 assert.equal(pet.damage(f.world,npc,50000,f.combat),true);assert.equal(pet.owned(f.id).hitpoints,0);assert.equal(f.world.petRuntime,null);assert.equal(pet.launch(f.world),false);
 f.p.uridium=50;db.prepare('UPDATE players SET uridium=50 WHERE id=?').run(f.id);assert.equal(pet.repair(f.world),true);assert.equal(pet.owned(f.id).hitpoints,50000);assert.equal(f.p.uridium,50);assert.equal(pet.repair(f.world),false);finish(f);
});
test('renaming validates input and stores persisted name without pet ownership changes',()=>{
 const f=fixture();assert.equal(pet.rename(f.world,'<bad>'),false);assert.equal(pet.rename(f.world,'  Companion  '),true);assert.equal(pet.owned(f.id).name,'Companion');finish(f);
});
test('an active PET transfers across a normal jump and resumes at the new owner position',async()=>{
 const f=fixture();fuel(f);pet.launch(f.world);const prior=f.world.petRuntime;
 const game=require('../game/gameplay');game.register(()=>{}, {sendCmd:f.world.petSend,combatFor:()=>f.combat,buildInit:w=>[...game.initialize(w),...pet.buildInit(w)]});
 f.world.config={...config,gameplay:{jumpDelayMs:0}};Object.assign(f.p,{x:18500,y:11500});
 assert.equal(game.jump(f.session),true);await new Promise(resolve=>setTimeout(resolve,15));
 assert.equal(f.p.mapId,2);assert.equal(prior.active,false);assert.equal(f.world.petRuntime.active,true);assert.equal(f.world.petRuntime.x,f.p.x+80);assert.equal(pet.owned(f.id).fuel,100);finish(f);
});
test('portal PET metadata replaces a generic marker with actual slotsets and config bindings',()=>{
 const f=fixture(),laser=item(f,'equipment_weapon_laser_lf-1');equip(f,laser,'lasers');
 const response={data:{map:{lootIds:['pet_pet10'],types:[]},ret:{itemInfo:[{L:0,name:'generic'}],hangars:[{hangarID:String(f.p.shipId),general:{},config:{1:{},2:{}}}],items:[{I:laser}]}}};
 pet.decoratePortal(f.id,response);const ret=response.data.ret;
 assert.equal(ret.itemInfo[0].levels[1].slotsets.lasers.Q,6);assert.equal(ret.hangars[0].general.pet.PN,'P.E.T.');assert.equal(ret.hangars[0].general.pet.lockedSlots.gears,0);
 assert.deepEqual(ret.hangars[0].config[1].pet.EQ.lasers,[laser]);assert.equal(ret.items[0].EQT,'pet');finish(f);
});
