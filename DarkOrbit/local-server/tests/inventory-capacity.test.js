'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),inv=require('../game/inventory'),drones=require('../game/drones'),pet=require('../game/pet'),World=require('../game/world'),original=World.current;
let db,id,ship,other;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;const create=name=>players.createPlayer(players.createAccount(name,'test-pass'),name,1,require('../config').starter);id=create('capacity');other=create('other');ship=players.loadPlayer(id).shipId;});
afterEach(()=>{World.current=original;database.close();});
const item=(loot='equipment_weapon_laser_lf-3',owner=id)=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(owner,loot).lastInsertRowid);
const request=(ids,target='ship',config=1,extra={})=>({hangarId:ship,from:{target:'inventory',items:ids.map(String),configId:config},to:{target,slotset:'lasers',configId:config,...extra}});
function leaveSlots(config,count=2,slot='laser',loot='equipment_weapon_laser_lf-3',slotset='lasers'){
 const n=inv.freeSlots(db,ship,slot,config).length-count;if(n>0)assert.equal(inv.move(id,request(Array.from({length:n},()=>item(loot)),'ship',config,{slotset})),true);
}
function portal(action,r){return JSON.parse(Buffer.from(require('../web/inventory-api').handle(id,new URLSearchParams({action,params:Buffer.from(JSON.stringify({params:{hi:ship},...r})).toString('base64')})).body,'base64'));}
for(const config of [1,2])test('ship fills available laser slots and returns only overflow to the native client, config '+config,()=>{
 leaveSlots(config);const ids=Array.from({length:5},()=>item()),r=request(ids,'ship',config),reply=portal('move',r);assert.equal(reply.isError,0);assert.deepEqual(reply.data.ret,ids.slice(2));
 const equipped=new Set(inv.equipped(db,ship,config).map(i=>i.id));for(const [n,i]of ids.entries())assert.equal(equipped.has(i),n<2);
 assert.equal(inv.equipped(db,ship,config===1?2:1).some(i=>ids.includes(i.id)),false);
 assert.deepEqual(inv.move(id,request(ids.slice(2),'ship',config)),ids.slice(2),'full destination rejects only capacity, with no error or lost items');
 const hangar=portal('getHangar',{}).data.ret.hangars.find(h=>Number(h.hangarID)===ship);for(const [n,i]of ids.entries())assert.equal(hangar.config[config].ship.EQ.lasers.includes(i),n<2);
 assert.equal(db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=? AND id IN('+ids.map(()=>'?').join(',')+')').get(id,...ids).n,5);
});
test('shield generators also fill remaining slots rather than reject the whole selection',()=>{
 leaveSlots(1,1,'generator','equipment_generator_shield_sg3n-b02','generators');const ids=Array.from({length:3},()=>item('equipment_generator_shield_sg3n-b02'));
 assert.deepEqual(inv.move(id,request(ids,'ship',1,{slotset:'generators'})),ids.slice(1));assert.ok(inv.equipped(db,ship).some(i=>i.id===ids[0]));
});

for(const config of [1,2])test('owned LF5 remains transferable while shop purchases are disabled, config '+config,()=>{
 const ids=Array.from({length:3},()=>item('equipment_weapon_laser_lf-5-mf')),response=portal('getHangarList',{}),ret=response.data.ret;
 for(const id of ids){const row=ret.items.find(i=>i.I===id),info=ret.itemInfo.find(i=>i.L===row.L);assert.equal(info.T,0);assert.deepEqual(info.EB,['SHIP','PET','DRONE']);assert.equal(row.EQH,undefined);}
 assert.equal(portal('move',request([ids[0]],'ship',config)).data.ret,true);
 const drone=database.tx(d=>drones.addOwned(d,id,'drone_iris'));assert.equal(portal('move',request([ids[1]],'drone',config,{droneId:drone,slotset:'default'})).data.ret,true);
 database.tx(d=>pet.addOwned(d,id));assert.equal(portal('move',request([ids[2]],'pet',config)).data.ret,true);
 assert.ok(inv.equipped(db,ship,config).some(i=>i.id===ids[0]));assert.ok(drones.equipped(db,ship,config).some(i=>i.id===ids[1]));assert.ok(pet.statItems(db,ship,config).some(i=>i.id===ids[2]));
});
test('invalid ownership or assignment in the overflow tail still rolls back the whole ship request',()=>{
 leaveSlots(1,1);const good=item(),foreign=item(undefined,other);assert.throws(()=>inv.move(id,request([good,foreign])),/bulunamadı/);assert.equal(db.prepare('SELECT ship_id FROM items WHERE id=?').get(good).ship_id,null);
 const occupied=item();inv.move(id,request([occupied]));assert.throws(()=>inv.move(id,request([good,occupied])),/takılı/);assert.equal(db.prepare('SELECT ship_id FROM items WHERE id=?').get(good).ship_id,null);
});
test('single and multi-drone capacity replies use rejected IDs; a forged later group rolls back earlier groups',()=>{
 const first=database.tx(d=>drones.addOwned(d,id,'drone_iris')),second=database.tx(d=>drones.addOwned(d,id,'drone_iris')),ids=Array.from({length:9},()=>item());
 assert.deepEqual(drones.move(id,request(ids.slice(0,3),'drone',1,{droneId:first,slotset:'default'})),[ids[2]]);
 const r={hangarId:ship,from:{target:'inventory',configId:1,droneItems:{[first]:[ids[2]],[second]:ids.slice(3,6)}},to:{target:'drone',configId:1,slotset:'default'}};
 assert.deepEqual(portal('droneEquip',r).data.ret,[ids[2],ids[5]]);
 assert.deepEqual(drones.equipped(db,ship).map(i=>i.id),[ids[0],ids[1],ids[3],ids[4]]);
 r.from.configId=r.to.configId=2;r.from.droneItems={[first]:[ids[6]],[second]:[item(undefined,other)]};assert.throws(()=>drones.equipMany(id,r),/uymuyor/);assert.equal(db.prepare('SELECT COUNT(*) n FROM drone_equipment WHERE item_id=?').get(ids[6]).n,0);
});
test('PET fills unlocked capacity and leaves overflow in storage in both configurations',()=>{
 database.tx(d=>pet.addOwned(d,id));for(const config of [1,2]){const ids=Array.from({length:8},()=>item());assert.deepEqual(pet.move(id,request(ids,'pet',config)),ids.slice(6));assert.deepEqual(pet.statItems(db,ship,config).map(i=>i.id).sort((a,b)=>a-b),ids.slice(0,6));assert.deepEqual(pet.move(id,request(ids.slice(6),'pet',config)),ids.slice(6));}
});
test('native design Boolean contract cannot report a partial move as a full success',()=>{
 const drone=database.tx(d=>drones.addOwned(d,id,'drone_iris')),ids=[item('drone_designs_havoc'),item('drone_designs_hercules')],r=request(ids,'drone',1,{droneId:drone,slotset:'design'});
 assert.equal(portal('moveDroneDesign',r).data.ret.success,false);assert.equal(drones.equipped(db,ship).length,0);
 assert.equal(portal('moveDroneDesign',request([ids[0]],'drone',1,{droneId:drone,slotset:'design'})).data.ret.success,true);
});
test('installed native normal and multi-drone response routes subtract rejected IDs, and restore inventory icons',()=>{
 const base=path.resolve(__dirname,'../decompiled/inventory-compact-capacity/before/scripts/net/bigpoint/darkorbit/equipment'),source=fs.readFileSync(path.join(base,'model/ConnectionProxy.as'),'utf8');
 assert.match(source,/getItemsNotInOtherArray\(this.itemsToMove,param1 as Array\)/);assert.match(source,/returnFilteredOutNotAcceptedItems\(_loc12_,param1\)/);
 const start=source.indexOf('private function returnFilteredOutNotAcceptedItems'),end=source.indexOf('private function',start+20),body=source.slice(start,end);
 assert.match(body,/_loc6_ == _loc5_[\s\S]*?_loc4_ = false/);assert.match(body,/if\(_loc4_\)[\s\S]*?_loc3_\.push\(_loc5_\)/,'multi-drone array is rejected, not accepted IDs');
 const mediator=fs.readFileSync(path.join(base,'view/mediators/InventoryViewMediator.as'),'utf8');assert.match(mediator,/case ApplicationNotificationNames.KEEP_IN_INVENTORY:[\s\S]*?replaceItemsThatAlreadyExist\(\)/);
});
