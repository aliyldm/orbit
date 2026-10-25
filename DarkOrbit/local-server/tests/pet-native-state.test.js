'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),config=require('../config'),pet=require('../game/pet'),special=require('../game/pet-special'),codec=require('../game/codec/codec'),gameplay=require('../game/gameplay');
let db,f;
// Narrow reference projection of shipped PetWindowAssembly / native handlers.
// In particular Initialization resets Play; UIRepairButton only enables repair,
// HeroActivation deduplicates via ShipManager and restores Stop; Deactivation
// resets UI but does not remove the map entity. This is not a Flash renderer.
class NativePetState{
 constructor(){this.entities=new Map();this.gears=new Set();this.play=true;this.stop=false;this.repair=false;this.created=0;}
 apply(c){
  if(c._==='PetInitializationCommand'){this.repair=!c.petIsAlive;this.play=c.petIsAlive;this.stop=false;}
  if(c._==='PetHeroActivationCommand'){if(!this.entities.has(c.petId)){this.entities.set(c.petId,{visible:true});this.created++;}this.play=false;this.stop=true;this.repair=false;}
  if(c._==='PetDeactivationCommand'){this.play=true;this.stop=false;this.repair=false;this.gears.clear();}
  if(c._==='ShipRemoveCommand')this.entities.delete(c.userId);
  if(c._==='PetIsDestroyedCommand'){this.play=false;this.stop=false;this.repair=true;}
  if(c._==='PetRepairCompleteCommand'){this.play=true;this.stop=false;this.repair=false;}
  if(c._==='PetGearResetCommand')this.gears.clear();
  if(c._==='PetGearAddCommand')this.gears.add(c.gearType.typeValue);
  if(c._==='PetGearSelectCommand'&&this.gears.has(c.gearType.typeValue)){this.gear=c.gearType.typeValue;this.target=c.optionalParams[0];}
  if(c._==='PetIdleModeCommand'&&this.entities.has(c.petId))this.entities.get(c.petId).visible=!c.isIdle;
  if(c._==='PetStatusCommand'&&this.entities.has(c.petId))this.status=c;
 }
}
beforeEach(()=>{
 database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('pet-native-qa','testpass'),'PET State QA',1,{...config.starter,uridium:10000}),world=World.instance(config),commands=[],ui=new NativePetState();
 pet.addOwned(db,id);pet.addFuel(db,id,1000);
 const send=(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(decoded.obj);ui.apply(decoded.obj);};
 const session={world,send(buffer){const decoded=codec.decode(buffer.subarray(3));assert.equal(decoded.rest,0);commands.push(decoded.obj);ui.apply(decoded.obj);},close(){}};
 world.login(session,id);Object.assign(world.player,{x:6000,y:6000});world.petSend=send;const combat=new Combat(world,send);combat.map=require('../game/maps').getMap(1);
 const handlers=new Map();require('../game/handlers/pet').register((name,fn)=>handlers.set(name,fn),{sendCmd:send});
 gameplay.register(()=>{},{sendCmd:send,combatFor:()=>({start(){}}),buildInit:w=>pet.buildInit(w)});
 f={world,s:session,p:world.player,id,commands,ui,send,combat,handlers};for(const c of pet.buildInit(world))send(session,c);
});
afterEach(()=>{db.exec('DROP TRIGGER IF EXISTS fail_pet_recall');f.world.removeSession(f.s);database.close();});
function request(type){const decoded=codec.decode(codec.encode({_:'PetRequest',petRequestType:type}));assert.equal(decoded.rest,0);return f.handlers.get('PetRequest')(f.s,decoded.obj);}
function gear(id,slot='gears'){const item=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(f.id,id).lastInsertRowid);pet.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item],configId:1},to:{target:'pet',slotset:slot,configId:1}});return item;}
function active(){assert.equal(f.ui.entities.size,1);assert.equal(f.ui.stop,true);assert.equal(f.ui.play,false);assert.equal(f.ui.repair,false);assert.equal(f.world.petRuntime.active,true);}

test('native launch→fuel purchase→equipment refresh retains Stop; recall removes entity and persists actual HP/fuel',()=>{
 assert.equal(request(0),true);active();const r=f.world.petRuntime;r.hitpoints=1234;pet.save(f.world);
 pet.addFuel(db,f.id,10);pet.purchased(f.world,'resource_pet-fuel');active();assert.equal(f.ui.status.petHitPoints,1234);assert.equal(f.ui.created,1);
 gear('equipment_petgear_g-al1');active();assert.ok(f.ui.gears.has(4));assert.equal(f.ui.created,1);
 assert.equal(request(1),true);assert.equal(f.world.petRuntime,null);assert.equal(f.ui.entities.size,0);assert.equal(f.ui.play,true);assert.equal(f.ui.stop,false);assert.equal(pet.owned(f.id).hitpoints,1234);assert.equal(pet.owned(f.id).fuel,1010);
});

test('duplicate explicit Launch repairs stale Play without toggling off, refill or extra entity; duplicate Recall stays inactive',()=>{
 request(0);const r=f.world.petRuntime;r.hitpoints=777;r.fuel=990;pet.save(f.world);f.send(f.s,{_:'PetInitializationCommand',hasPet:true,hasFuel:true,petIsAlive:true});assert.equal(f.ui.play,true);assert.equal(f.ui.entities.size,1);
 assert.equal(request(0),true);active();assert.equal(f.world.petRuntime,r);assert.equal(r.hitpoints,777);assert.equal(r.fuel,990);assert.equal(f.ui.created,1);
 assert.equal(request(1),true);assert.equal(request(1),true);assert.equal(f.ui.entities.size,0);assert.equal(f.world.petRuntime,null);assert.equal(pet.owned(f.id).fuel,990);
});

test('native Toggle recalls even in combat; failed database recall preserves active entity and can retry',()=>{
 request(0);const npc={petAggro:pet.petId(f.id)};f.world.npcs.set(999,npc);f.p.lastCombat=Date.now();
 db.exec("CREATE TRIGGER fail_pet_recall BEFORE UPDATE ON pets BEGIN SELECT RAISE(ABORT,'pet-recall-failure'); END");assert.equal(request(1),false);active();assert.equal(f.ui.created,1);
 db.exec('DROP TRIGGER fail_pet_recall');assert.equal(request(2),true);assert.equal(f.world.petRuntime,null);assert.equal(f.ui.entities.size,0);assert.equal(npc.petAggro,null);
});

test('map transition resumes once with Stop; repeated native initialization remains synchronized and relog leaves PET recalled',()=>{
 request(0);const fuel=pet.owned(f.id).fuel;assert.equal(gameplay.changeMap(f.s,2,2300,2300),true);active();assert.equal(f.ui.entities.size,1);assert.equal(pet.owned(f.id).fuel,fuel);
 for(let i=0;i<3;i++)for(const c of pet.buildInit(f.world))f.send(f.s,c);active();assert.equal(f.ui.entities.size,1);
 f.world.removeSession(f.s);const next={world:f.world,send(){},close(){}};f.world.login(next,f.id);f.s=next;f.p=f.world.player;
 f.ui.entities.clear();for(const c of pet.buildInit(f.world))f.send(next,c);assert.equal(f.world.petRuntime,null);assert.equal(f.ui.play,true);assert.equal(f.ui.entities.size,0);assert.equal(pet.owned(f.id).fuel,fuel);
});

test('kamikaze destruction ends on native Repair rather than Play; repair and launch work without losing cooldown',()=>{
 gear('equipment_petgear_g-kk1');request(0);pet.selectGear(f.world,10);special.setCooldown(f.world,10,120000);special.destroy(f.world,1);
 assert.equal(f.world.petRuntime,null);assert.equal(f.ui.entities.size,0);assert.equal(f.ui.repair,true);assert.equal(f.ui.play,false);assert.equal(pet.owned(f.id).hitpoints,0);
 assert.equal(request(4),true);assert.equal(f.ui.play,true);assert.equal(request(0),true);active();assert.equal(pet.selectGear(f.world,10),false);assert.ok(special.cooldown(f.id,10)>0);
});

test('locator refresh preserves runtime selection and idle trade refresh cannot expose absent PET',()=>{
 gear('equipment_petgear_g-rl1');request(0);f.world.collectables={boxes:new Map([['ore',{oreType:0,x:6100,y:6000}]]),clear(){}};assert.equal(pet.selectGear(f.world,7,0),true);pet.refresh(f.world);active();assert.equal(f.ui.gear,7);assert.equal(f.ui.target,0);assert.ok(f.commands.some(c=>c._==='PetLocatorGearInitializationCommand'&&c.possibleTargetValues.includes(0)));
 f.world.petRuntime.tradeIdle=true;pet.purchased(f.world,'resource_pet-fuel');assert.equal(f.ui.entities.get(pet.petId(f.id)).visible,false);assert.equal(f.ui.stop,true);assert.equal(f.ui.play,false);
});

test('recall and relaunch rebuild the native gear list on every activation, preserving chosen gear and resources',()=>{
 gear('equipment_petgear_g-al1');gear('equipment_petgear_g-rep1');request(0);pet.selectGear(f.world,4);const r=f.world.petRuntime;r.hitpoints=1234;pet.save(f.world);const fuel=r.fuel;
 for(let i=0;i<3;i++){
  assert.equal(request(1),true);assert.equal(f.ui.gears.size,0,'native deactivation removes the gear entries');const mark=f.commands.length;
  assert.equal(request(0),true);active();assert.deepEqual([...f.ui.gears].sort((a,b)=>a-b),[1,2,4,9]);assert.equal(f.ui.gear,4);assert.equal(f.world.petRuntime.hitpoints,1234);assert.equal(f.world.petRuntime.fuel,fuel);
  const added=f.commands.slice(mark).filter(c=>c._==='PetGearAddCommand').map(c=>c.gearType.typeValue);assert.deepEqual(added,[1,2,4,9]);
 }
});

test('a rejected cooldown selection restores the native optimistic header without spending fuel or changing gear',()=>{
 gear('equipment_petgear_g-kk1');request(0);pet.selectGear(f.world,2);const r=f.world.petRuntime,fuel=r.fuel;special.setCooldown(f.world,10,120000);f.ui.gear=10;
 const gearRequest=codec.decode(codec.encode({_:'PetGearActivationRequest',gearTypeToActivate:{_:'PetGearTypeModule',typeValue:10},optParam:0})).obj;
 assert.equal(f.handlers.get('PetGearActivationRequest')(f.s,gearRequest),false);active();assert.equal(f.ui.gear,2);assert.ok(f.ui.gears.has(10));assert.equal(r.gear,2);assert.equal(r.fuel,fuel);assert.equal(pet.owned(f.id).gear,2);assert.ok(special.cooldown(f.id,10)>0);
});

test('trade absence rejects mode changes while restoring its visible state and actual selection',()=>{
 gear('equipment_petgear_g-tra1');request(0);assert.equal(pet.selectGear(f.world,8),true);const r=f.world.petRuntime;r.tradeIdle=true;special.setCooldown(f.world,8,300000);f.ui.gear=2;
 assert.equal(pet.selectGear(f.world,2),false);active();assert.equal(f.ui.gear,8);assert.equal(r.gear,8);assert.equal(f.ui.entities.get(pet.petId(f.id)).visible,false);assert.ok(special.cooldown(f.id,8)>0);
});

test('configuration changes expose only equipped modes but always retain passive/guard and a valid selection',()=>{
 gear('equipment_petgear_g-al1');request(0);pet.selectGear(f.world,4);require('../game/inventory').switchConfig(f.id,f.p.shipId,2);active();assert.deepEqual([...f.ui.gears],[1,2]);assert.equal(f.ui.gear,1);assert.equal(pet.selectGear(f.world,4),false);assert.equal(f.ui.gear,1);
 require('../game/inventory').switchConfig(f.id,f.p.shipId,1);active();assert.deepEqual([...f.ui.gears],[1,2,4]);assert.equal(pet.selectGear(f.world,4),true);assert.equal(f.ui.gear,4);
});

test('a failed gear persistence request restores the actual mode instead of leaving the optimistic native header',()=>{
 gear('equipment_petgear_g-al1');request(0);pet.selectGear(f.world,2);f.ui.gear=4;db.exec("CREATE TRIGGER fail_gear BEFORE UPDATE OF gear ON pets BEGIN SELECT RAISE(ABORT,'gear-storage'); END");
 try{const packet=codec.decode(codec.encode({_:'PetGearActivationRequest',gearTypeToActivate:{_:'PetGearTypeModule',typeValue:4},optParam:0})).obj;assert.equal(f.handlers.get('PetGearActivationRequest')(f.s,packet),false);active();assert.equal(f.ui.gear,2);assert.equal(f.world.petRuntime.gear,2);assert.equal(pet.owned(f.id).gear,2);}finally{db.exec('DROP TRIGGER fail_gear');}
});

test('freshly exported installed native UI confirms menu clearing on recall and optimistic gear selection',()=>{
 const fs=require('node:fs'),crypto=require('node:crypto'),path=require('node:path'),root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/pet-ui-resync-audit'),proof=require('../decompiled/pet-ui-resync-audit/evidence.json'),sha=b=>crypto.createHash('sha256').update(b).digest('hex');
 assert.equal(sha(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))),proof.mainSha256);for(const c of proof.classes)assert.equal(sha(fs.readFileSync(path.join(dir,'current/scripts',...c.name.split('.'))+'.as')),c.sha256);
 const source=fs.readFileSync(path.join(dir,'current/scripts/net/bigpoint/darkorbit/net/PetWindowAssembly.as'),'utf8');assert.match(source,/function petDeactivation\(\)[\s\S]*?this\.resetPetWindowValues\(\)/);assert.match(source,/function resetPetWindowValues\(\)[\s\S]*?this\.resetGears\(\)/);assert.match(source,/function resetGears\(\)[\s\S]*?mainMenu\.removeAllElements\(\)[\s\S]*?setSelectedText\(""\)/);assert.match(source,/function setSelectedItem\([\s\S]*?setSelectedText\(param2\)[\s\S]*?this\.requestGearActivation\(param3,param4\)/);
});
