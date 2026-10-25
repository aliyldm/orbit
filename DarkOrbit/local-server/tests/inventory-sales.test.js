'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),api=require('../web/inventory-api'),inv=require('../game/inventory');
let db,id,foreign,ship,w,s;const original=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;const add=name=>players.createPlayer(players.createAccount(name,'test-pass'),name,1,require('../config').starter);id=add('sales');foreign=add('foreign');ship=players.loadPlayer(id).shipId;});
afterEach(()=>{if(w)w.removeSession(s);w=s=null;World.current=original;database.close();});
const item=(loot='equipment_weapon_laser_lf-3',amount=1,owner=id)=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(owner,loot,amount).lastInsertRowid);
const portal=(action,r)=>JSON.parse(Buffer.from(api.handle(id,new URLSearchParams({action,params:Buffer.from(JSON.stringify(r||{})).toString('base64')})).body,'base64'));
const balance=()=>db.prepare('SELECT credits FROM players WHERE id=?').get(id).credits;
const move=(ids,config=1,target='ship',extra={})=>({hangarId:ship,from:{target:'inventory',items:ids,configId:config},to:{target,configId:config,slotset:'lasers',...extra}});
test('native single sale deletes the item, pays catalogue credits and returns a deletion update; replay cannot pay twice',()=>{
 const i=item(),before=balance(),r=portal('sell',{action:'sell',itemId:String(i),quantity:1,saleValue:999999999});assert.equal(r.isError,0);assert.equal(r.data.ret,true);assert.deepEqual(r.data.update,{deleted:[String(i)],changed:{}});assert.equal(Number(r.data.money.credits),before+25000);assert.equal(balance(),before+25000);assert.equal(db.prepare('SELECT 1 FROM items WHERE id=?').get(i),undefined);
 assert.equal(portal('sell',{itemId:i,quantity:1}).isError,1);assert.equal(balance(),before+25000);assert.ok(!portal('getHangarList').data.ret.items.some(row=>row.I===i));
});
test('native bulk sale supports large same-type selections and uses the LF5 sale price despite its purchase lock',()=>{
 const ids=Array.from({length:150},()=>item('equipment_weapon_laser_lf-5-mf')),before=balance();db.prepare('UPDATE items SET upgrade_level=16 WHERE id=?').run(ids[0]);const r=portal('sellMultiple',{action:'sellMultiple',items:ids.map(String),price:1});assert.equal(r.isError,0);assert.deepEqual(r.data.update.deleted,ids.map(String));assert.equal(balance(),before+150*50000);assert.equal(db.prepare("SELECT COUNT(*) n FROM items WHERE player_id=? AND loot_id='equipment_weapon_laser_lf-5-mf'").get(id).n,0);
});
test('partial and complete ammunition stack sales conserve quantities and pay only the selected amount',()=>{
 const i=item('ammunition_laser_lcb-10',10),before=balance();let r=portal('sell',{itemId:i,quantity:'4'});assert.equal(r.isError,0);assert.deepEqual(r.data.update,{deleted:[],changed:{[i]:{Q:6}}});assert.equal(db.prepare('SELECT amount FROM items WHERE id=?').get(i).amount,6);assert.equal(balance(),before+20);
 assert.equal(portal('sell',{itemId:i,quantity:7}).isError,1);assert.equal(balance(),before+20);r=portal('sell',{itemId:i,quantity:6});assert.equal(r.isError,0);assert.deepEqual(r.data.update.deleted,[String(i)]);assert.equal(balance(),before+50);
});
test('foreign ownership, duplicates and a non-sellable tail roll back the entire bulk sale',()=>{
 const i=item(),other=item(undefined,1,foreign),unsellable=item('resource_convert-module'),before=balance();for(const items of [[i,other],[i,i],[i,unsellable]]){assert.equal(portal('sellMultiple',{items}).isError,1);assert.ok(db.prepare('SELECT 1 FROM items WHERE id=?').get(i));assert.equal(balance(),before);}
});
test('malformed quantities and IDs cannot become a default one-item sale',()=>{
 const i=item(),before=balance();for(const quantity of [undefined,null,true,false,0,-1,1.5,'1.5','',{},[],9007199254740992])assert.equal(portal('sell',{itemId:i,quantity}).isError,1);
 for(const itemId of [undefined,true,0,-1,'abc',{}])assert.equal(portal('sell',{itemId,quantity:1}).isError,1);assert.equal(balance(),before);assert.ok(db.prepare('SELECT 1 FROM items WHERE id=?').get(i));
});
test('an item being upgraded cannot be sold before its job is claimed',()=>{
 const i=item(),before=balance();db.prepare('INSERT INTO assembly_jobs(player_id,recipe_loot_id,target_id,amount,started_at,due_at,result_json)VALUES(?,?,?,1,0,1,?)').run(id,'qa-upgrade',i,'{}');assert.match(portal('sell',{itemId:i,quantity:1}).error.message,/İşlemdeki/);assert.equal(balance(),before);assert.ok(db.prepare('SELECT 1 FROM items WHERE id=?').get(i));
});
test('sale removes both configuration assignments, drone/PET bindings and CPU charge ledgers without orphan rows',()=>{
 const a=item(),b=item(),c=item(),cpu=item('equipment_extra_cpu_cl04k-xl'),drone=database.tx(d=>require('../game/drones').addOwned(d,id,'drone_iris'));database.tx(d=>require('../game/pet').addOwned(d,id));
 for(const config of [1,2]){inv.move(id,move([a],config));require('../game/drones').move(id,move([b],config,'drone',{droneId:drone,slotset:'default'}));require('../game/pet').move(id,move([c],config,'pet'));}db.prepare('INSERT INTO cpu_charges(item_id,remaining)VALUES(?,50)').run(cpu);
 const r=portal('sellMultiple',{items:[a,b,c,cpu]});assert.equal(r.isError,0);for(const table of ['equipment_config2','drone_equipment','pet_equipment','cpu_charges'])assert.equal(db.prepare('SELECT COUNT(*) n FROM '+table).get().n,0);assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(),[]);
});
test('PET protocol sale matches its level-specific price displayed in the native inventory',()=>{
 const i=item('equipment_aiprotocol_ai-s1');db.prepare('UPDATE items SET pet_level=3 WHERE id=?').run(i);const r=portal('getHangarList'),row=r.data.ret.items.find(row=>row.I===i),info=r.data.ret.itemInfo.find(info=>info.L===row.L);assert.equal(info.levels[row.LV].selling.credits,112500);const before=balance();assert.equal(portal('sell',{itemId:i,quantity:1}).isError,0);assert.equal(balance(),before+112500);
});
test('storage failure rolls back deletion and payout together',()=>{
 const i=item(),before=balance();db.exec("CREATE TRIGGER reject_sale BEFORE UPDATE OF credits ON players BEGIN SELECT RAISE(ABORT,'storage'); END");assert.equal(portal('sell',{itemId:i,quantity:1}).isError,1);assert.equal(balance(),before);assert.ok(db.prepare('SELECT 1 FROM items WHERE id=?').get(i));
});
test('selling a slot CPU cannot strand extras outside the remaining capacity',()=>{
 const cpu=item('equipment_extra_cpu_sle-04');inv.move(id,move([cpu],1,'ship',{slotset:'extras'}));const extras=Array.from({length:3},()=>item('equipment_extra_cpu_cl04k-xl'));inv.move(id,move(extras,1,'ship',{slotset:'extras'}));const before=balance();assert.match(portal('sell',{itemId:cpu,quantity:1}).error.message,/genişletilmiş/);assert.equal(balance(),before);assert.ok(inv.equipped(db,ship).some(i=>i.id===cpu));
});
test('online payout uses the live wallet and survives a later world save',()=>{
 w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);World.current=()=>w;w.player.credits+=777;const before=w.player.credits,i=item();const r=portal('sell',{itemId:i,quantity:1});assert.equal(r.isError,0);assert.equal(w.player.credits,before+25000);assert.equal(balance(),before+25000);w.save();assert.equal(balance(),before+25000);
});
