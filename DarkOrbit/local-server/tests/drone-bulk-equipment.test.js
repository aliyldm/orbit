'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),drones=require('../game/drones'),World=require('../game/world'),api=require('../web/inventory-api');
let db,pid,ship,other,otherShip,refreshes;const original=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');refreshes=0;World.current=()=>null;
 const add=name=>players.createPlayer(players.createAccount(name,'testpass'),name,1,require('../config').starter);
 pid=add('bulk'),other=add('foreign');ship=players.loadPlayer(pid).shipId;otherShip=players.loadPlayer(other).shipId;
});
afterEach(()=>{World.current=original;database.close();});
const item=(loot='equipment_weapon_laser_lf-1',owner=pid)=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(owner,loot).lastInsertRowid);
const drone=(loot='drone_iris',owner=pid)=>drones.addOwned(db,owner,loot);
const request=(plan,config=1,slotset='default',hi=ship)=>({params:{hi},from:{target:'inventory',configId:config,droneItems:plan},to:{target:'drone',configId:config,slotset}});
const portal=r=>JSON.parse(Buffer.from(api.handle(pid,new URLSearchParams({action:'droneEquip',params:Buffer.from(JSON.stringify(r)).toString('base64')})).body,'base64').toString());
const eq=(config=1)=>drones.equipped(db,ship,config);
test('native base64 droneEquip maps mixed drone capacities to exact model IDs and refreshes only once',()=>{
 const ds=[drone('drone_flax'),drone(),drone('drone_apis'),drone('drone_zeus')],ids=Array.from({length:7},()=>item());
 World.current=()=>({livePlayer:()=>null});
 const out=portal(request({[ds[0]]:[ids[0]],[ds[1]]:ids.slice(1,3),[ds[2]]:ids.slice(3,5),[ds[3]]:ids.slice(5)}));
 assert.equal(out.isError,0);assert.equal(out.data.ret,true);
 assert.deepEqual(ds.map(d=>eq().filter(i=>i.drone_id===d).map(i=>i.id)),[[ids[0]],ids.slice(1,3),ids.slice(3,5),ids.slice(5)]);
 const hangar=JSON.parse(Buffer.from(api.handle(pid,new URLSearchParams({action:'getHangar',params:Buffer.from(JSON.stringify({params:{hi:ship}})).toString('base64')})).body,'base64').toString());
 assert.deepEqual(ds.map(d=>hangar.data.ret.hangars[0].config[1].drones[d].EQ.default),[[ids[0]],ids.slice(1,3),ids.slice(3,5),ids.slice(5)]);
});
test('partly filled drones retain occupied slots and both configs permit the same physical items in the same hangar',()=>{
 const a=drone(),b=drone(),first=item(),ids=[item(),item('equipment_generator_shield_sg3n-b02'),item()];
 drones.move(pid,{hangarId:ship,from:{target:'inventory',items:[first]},to:{target:'drone',droneId:a}});
 assert.equal(portal(request({[a]:[ids[0]],[b]:ids.slice(1)})).isError,0);
 assert.deepEqual(eq().filter(i=>i.drone_id===a).map(i=>[i.id,i.slot_index]),[[first,0],[ids[0],1]]);
 assert.equal(portal(request({[a]:[ids[0]],[b]:ids.slice(1)},2)).isError,0);assert.equal(eq(2).length,3);assert.equal(eq().length,4);
});
test('invalid late groups roll back all writes and never publish a partial equipment refresh',()=>{
 const a=drone(),b=drone(),foreign=drone('drone_iris',other),ids=Array.from({length:5},()=>item());
 World.current=()=>({livePlayer:()=>players.loadPlayer(pid),refreshStats:()=>refreshes++,broadcast:()=>{refreshes++;}});
 for(const plan of [{[a]:[ids[0]],[foreign]:[ids[1]]},{[a]:[ids[0]],[b]:[item(undefined,other)]},{[a]:[ids[0]],[b]:[ids[0]]}]){
  assert.equal(portal(request(plan)).isError,1);assert.equal(eq().length,0);assert.equal(refreshes,0);
 }
 db.exec("CREATE TRIGGER bulk_fail BEFORE INSERT ON drone_equipment WHEN NEW.drone_id="+b+" BEGIN SELECT RAISE(ABORT,'bulk failure'); END");
 assert.equal(portal(request({[a]:[ids[0]],[b]:[ids[1]]})).isError,1);assert.equal(eq().length,0);assert.equal(refreshes,0);
 db.exec('DROP TRIGGER bulk_fail');assert.equal(portal(request({[a]:[ids[0]],[b]:[ids[1]]})).isError,0);assert.equal(refreshes,2);
});
test('bulk respects hangar ownership, slot compatibility and independent design slots',()=>{
 const a=drone(),b=drone(),ids=[item('drone_designs_havoc'),item('drone_designs_hercules')];
 assert.equal(portal(request({[a]:[ids[0]],[b]:[ids[1]]},1,'design')).isError,0);
 assert.ok(eq().every(i=>i.drone_slot==='design'));
 assert.equal(portal(request({[a]:[item('ammunition_laser_lcb-10')]})).isError,1);
 assert.equal(portal(request({[a]:[item()]},1,'default',otherShip)).isError,1);
 assert.equal(eq().length,2);
});
test('malformed plans, repeated assignments and mismatched configs cannot bypass native single item rules',()=>{
 const a=drone(),b=drone(),i=item();assert.equal(portal(request({[a]:[i]})).isError,0);
 assert.equal(portal(request({[b]:[i]})).isError,1);
 for(const plan of [[],{},null,{[a]:null},{['0'+a]:[item()]},{[a]:[]}])assert.equal(portal(request(plan)).isError,1);
 const r=request({[b]:[item()]});r.from.configId=2;assert.equal(portal(r).isError,1);assert.equal(eq().length,1);
});
