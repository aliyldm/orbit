'use strict';
// Memory-only benchmark: no real player, socket, or production database writes.
const fs=require('node:fs'),crypto=require('node:crypto'),{performance}=require('node:perf_hooks');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),codec=require('../game/codec/codec'),config=require('../config');
const quiet=console.log;console.log=()=>{};database.close();const db=database.open(':memory:');console.log=quiet;
const oldWorld=World.current;World.current=()=>null;
const pid=players.createPlayer(players.createAccount('assembly-benchmark','testpass'),'Assembly Benchmark',1,{...config.starter,uridium:100000000,credits:100000000}),p=players.loadPlayer(pid);
const itemCount=Math.max(1,Math.min(10000,Number(process.argv[2])||1000)),insert=db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)');
database.tx(()=>{for(let i=0;i<itemCount;i++)insert.run(pid,i%2?'equipment_weapon_laser_lf-4':'equipment_weapon_laser_lf-3',1);insert.run(pid,'resource_upgrade-module',100000);insert.run(pid,'resource_convert-module',100000);});
const assembly=require('../game/assembly'),handlers=new Map(),session={player:p},commands=[];let bytes=0,codecMs=0,queries=0;const sqlCounts=new Map();
const prepare=db.prepare.bind(db);db.prepare=sql=>{const statement=prepare(sql);return new Proxy(statement,{get(target,key){const value=Reflect.get(target,key,target);if(typeof value!=='function')return value;return (...args)=>{if(['get','all','run','iterate'].includes(String(key))){queries++;sqlCounts.set(sql,(sqlCounts.get(sql)||0)+1);}return value.apply(target,args);};}});};
function send(s,command){commands.push(command);const t=performance.now(),encoded=codec.encode(command);codecMs+=performance.now()-t;bytes+=encoded.length+3;}
require('../game/handlers/assembly').register((name,fn)=>handlers.set(name,fn),{sendCmd:send});
function measure(name,fn){commands.length=0;bytes=codecMs=queries=0;sqlCounts.clear();const t=performance.now();fn();return {name,elapsedMs:+(performance.now()-t).toFixed(2),sqlExecutions:queries,commands:commands.length,bytes,codecMs:+codecMs.toFixed(2),recipeRows:commands.filter(c=>c._==='AssemblyRecipeContentModule').reduce((n,c)=>n+c.recipes.length,0),inventoryRows:commands.filter(c=>c._==='UserInventoryModule').reduce((n,c)=>n+c.inventoryItemModules.length,0),commandKinds:Object.fromEntries([...new Set(commands.map(c=>c._))].map(k=>[k,commands.filter(c=>c._===k).length])),topSql:[...sqlCounts].sort((a,b)=>b[1]-a[1]).slice(0,6).map(([sql,count])=>({sql,count}))};}
const recipes=Object.entries(assembly.RECIPES).filter(([id,r])=>!r.targets?.length&&assembly.visible(db,pid,id)&&!assembly.unsupportedReason(id));
const results=[];
results.push(measure('buildInit + actual codec',()=>{for(const c of assembly.buildInit(p))send(session,c);}));
results.push(measure('recipeSelect',()=>handlers.get('AssemblyRecipeSelectRequest')(session,{recipeLootId:recipes[0][0]})));
results.push(measure('setFilter',()=>handlers.get('AssemblySetFilterRequest')(session,{assemblyWindowSettingsModule:{filterType:0,assemblyItemFilters:['weapons']}})));
results.push(measure('invalidBuild + error refresh',()=>handlers.get('AssemblyBuildRequest')(session,{recipeLootId:'recipe_does-not-exist',amount:1,targetItemId:0})));
const chosen=recipes.slice(0,10).map(([id])=>id),now=Date.now();
database.tx(()=>{const job=db.prepare('INSERT INTO assembly_jobs(player_id,recipe_loot_id,target_id,amount,started_at,due_at,result_json,skip_json)VALUES(?,?,0,1,?,?,?,?)');for(const id of chosen)job.run(pid,id,now-1000,now-1,JSON.stringify({parts:[{lootID:'ammunition_laser_lcb-10',ammount:1}]}),'[]');});
results.push(measure('collectAll10 + actual codec',()=>handlers.get('AssemblyCollectAllRequest')(session,{allRequests:chosen.map(recipeLootId=>({recipeLootId,targetItemId:0}))})));
const report={at:new Date().toISOString(),fixture:{memoryOnly:true,items:itemCount,recipeDefinitions:Object.keys(assembly.RECIPES).length,craftRecipes:recipes.length},sourceHashes:Object.fromEntries(['game/assembly.js','game/handlers/assembly.js'].map(file=>[file,crypto.createHash('sha256').update(fs.readFileSync(require('node:path').join(__dirname,'..',file))).digest('hex')])),results};
console.log(JSON.stringify(report,null,2));World.current=oldWorld;database.close();
