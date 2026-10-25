'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),pet=require('../game/pet'),inv=require('../game/inventory'),codec=require('../game/codec/codec');
let db,p;
beforeEach(()=>{database.close();db=database.open(':memory:');const a=players.createAccount('pet-visual','test');const id=players.createPlayer(a,'Pet Visual',1,require('../config.json').starter);pet.addOwned(db,id);db.prepare('UPDATE pets SET fuel=1000 WHERE player_id=?').run(id);p=players.loadPlayer(id);});
afterEach(()=>database.close());
function item(id){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(p.userId,id).lastInsertRowid);}
function equip(id,config=1){return pet.move(p.userId,{hangarId:p.shipId,from:{target:'inventory',items:[id],configId:config},to:{target:'pet',slotset:'visual',configId:config}});}
function world(){const commands=[],session={};return{player:p,config:{pet:{}},petSend(s,c){const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(c);},broadcast(fn){fn(session);},commands};}
test('all 122 cosmetic IDs resolve to numeric shipped PET patterns, including legacy nested designs',()=>{
 const map=require('../game/data/pet-appearances.json').appearances,m=require('../docs/client-map.items.json').items;
 const ids=Object.keys(m).filter(id=>m[id].typeClass?.endsWith('.PetCustomizationType'));
 assert.equal(ids.length,122);assert.deepEqual(Object.keys(map).sort(),ids.sort());
 for(const id of ids)assert.ok(Number.isSafeInteger(map[id].type)&&map[id].type>0);
 assert.equal(map['pet_designs_chimera-green'].type,163);assert.equal(map.pet_designs_frozen.type,160);assert.equal(map['pet_designs_pet-phoenix'].type,210);
});
test('physical cosmetic equipment is per configuration, consumes one slot and survives player reload',()=>{
 const green=item('pet_designs_chimera-green'),red=item('pet_designs_chimera-red');equip(green);equip(red,2);
 assert.equal(pet.appearance(p).type,163);assert.deepEqual(pet.equipmentConfigs(p.userId,p.shipId)[0].visual,[green]);
 const duplicate=item('pet_designs_chimera-orange');assert.deepEqual(equip(duplicate),[duplicate]);assert.deepEqual(pet.equipmentConfigs(p.userId,p.shipId)[0].visual,[green]);
 inv.switchConfig(p.userId,p.shipId,2);p=players.loadPlayer(p.userId);assert.equal(pet.appearance(p).type,165);
 inv.saveLayout(p.userId,p.shipId);inv.clear(p.userId,p.shipId,2);assert.equal(pet.appearance(p).lootId,'pet_pet10');assert.equal(inv.loadLayout(p.userId,p.shipId),true);assert.equal(pet.appearance(p).type,165);
});
test('equipped visual controls actual activation and persists across PET level ups',()=>{
 equip(item('pet_designs_pet-pusat-blaze'));const w=world();assert.equal(pet.launch(w),true);
 assert.equal(w.commands.find(c=>c._==='PetHeroActivationCommand').shipType,174);
 assert.equal(w.commands.find(c=>c._==='PetStatusCommand').petLootId,'pet_designs_pet-pusat-blaze');
 pet.awardExperience(w,1280000);assert.equal(w.commands.find(c=>c._==='PetLevelUpdateCommand').designId,174);
 assert.equal(pet.appearance(players.loadPlayer(p.userId)).type,174);
});
test('removing a visual refreshes the live model without refilling fuel or health',()=>{
 const id=item('pet_designs_chimera-green');equip(id);const w=world();pet.launch(w);w.petRuntime.hitpoints=123;w.petRuntime.fuel=987;
 pet.move(p.userId,{hangarId:p.shipId,from:{target:'pet',slotset:'visual',items:[id],configId:1},to:{target:'inventory',configId:1}});pet.refresh(w);
 assert.ok(w.commands.some(c=>c._==='ShipRemoveCommand'));assert.equal(w.commands.filter(c=>c._==='PetHeroActivationCommand').at(-1).shipType,12);
 assert.equal(w.petRuntime.hitpoints,123);assert.equal(w.petRuntime.fuel,987);
});
test('foreign items and noncosmetic resources cannot be installed as PET visuals',()=>{
 const a=players.createAccount('other','test'),other=players.createPlayer(a,'Other',1,require('../config.json').starter);
 const id=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'pet_designs_chimera-green',1)").run(other).lastInsertRowid);
 assert.throws(()=>equip(id),/bulunamadı/);assert.throws(()=>equip(item('resource_logfile')),/uymuyor/);
 assert.deepEqual(pet.equipmentConfigs(p.userId,p.shipId)[0].visual,[]);
});
test('actual PET XP awards apply the owned source booster once and do not create owner XP',()=>{
 const w=world();pet.launch(w);const before=p.ep;
 require('../game/boosters').addOwned(db,p.userId,'booster_p-ep-b01');
 pet.awardExperience(w,2000);assert.equal(pet.owned(p.userId).experience,105);assert.equal(p.ep,before);
});
