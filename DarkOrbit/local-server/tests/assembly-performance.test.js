'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),assembly=require('../game/assembly'),codec=require('../game/codec/codec'),World=require('../game/world');
let db,p,handlers,out;const old=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;const id=players.createPlayer(players.createAccount('assembly-perf','testpass'),'Performance',1,require('../config').starter);p=players.loadPlayer(id);handlers=new Map();out=[];require('../game/handlers/assembly').register((n,f)=>handlers.set(n,f),{sendCmd:(s,c)=>{codec.encode(c);out.push(c);}});});
afterEach(()=>{World.current=old;database.close();});
test('filter saves use actual request tab, keep tabs separate and emit no expensive catalogue',()=>{
 const session={player:p};for(const type of [0,1,2])handlers.get('AssemblySetFilterRequest')(session,{filterType:type,assemblyWindowSettingsModule:{filterType:0,assemblyItemFilters:[type===1?'weapons':type===2?'generators':'ships_and_designs']}});
 assert.equal(out.length,0);for(const type of [0,1,2])assert.equal(JSON.parse(db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,'assembly_filters_'+type).value).filterType,type);
});
test('collecting ten completed jobs sends one inventory, ten statuses and only the changed ammo menu',()=>{
 const recipes=Object.entries(assembly.RECIPES).filter(([id,r])=>!r.targets?.length&&assembly.visible(db,p.userId,id)&&!assembly.unsupportedReason(id)).slice(0,10);
 const insert=db.prepare('INSERT INTO assembly_jobs(player_id,recipe_loot_id,target_id,amount,started_at,due_at,result_json,skip_json)VALUES(?,?,0,1,0,0,?,?)');
 for(const[id]of recipes)insert.run(p.userId,id,JSON.stringify({parts:[{lootID:'ammunition_laser_lcb-10',ammount:1}]}),'[]');
 const before=assembly.count(db,p.userId,'ammunition_laser_lcb-10');handlers.get('AssemblyCollectAllRequest')({player:p},{allRequests:recipes.map(([recipeLootId])=>({recipeLootId,targetItemId:0}))});
 assert.equal(assembly.count(db,p.userId,'ammunition_laser_lcb-10'),before+10);assert.equal(out.filter(c=>c._==='UserInventoryModule').length,1);assert.equal(out.filter(c=>c._==='AssemblyRecipeStatusUpdateCommand').length,10);assert.equal(out.filter(c=>c._==='AssemblyRecipeContentModule').length,0);assert.equal(out.filter(c=>c._==='MenuItemStatusCommand').length,1);assert.ok(out.length<=14);
 assert.equal(db.prepare('SELECT COUNT(*) n FROM assembly_jobs WHERE player_id=?').get(p.userId).n,0);
});
test('large account initialization queries jobs and usage in bulk instead of per target',()=>{
 const insert=db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_weapon_laser_lf-4',1)");database.tx(()=>{for(let i=0;i<1000;i++)insert.run(p.userId);});
 let executions=0;const prepare=db.prepare.bind(db);db.prepare=sql=>{const statement=prepare(sql);return new Proxy(statement,{get(t,key){const value=Reflect.get(t,key,t);return typeof value!=='function'?value:(...args)=>{if(['get','all','run'].includes(key))executions++;return value.apply(t,args);};}});};
 const commands=assembly.buildInit(p);assert.ok(commands[0].recipes.length>2000);assert.ok(executions<150,'excess SQL queries: '+executions);
});
