'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),{DatabaseSync}=require('node:sqlite');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),assembly=require('../game/assembly'),drones=require('../game/drones'),codec=require('../game/codec/codec'),config=require('../config');
let db,pid,p;const current=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;pid=players.createPlayer(players.createAccount('restore-ui','test'),'Restore',1,config.starter);p=players.loadPlayer(pid);});
afterEach(()=>{World.current=current;database.close();});
const give=(id,n=1)=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(pid,id,n).lastInsertRowid);

test('already-used LF4 blueprint can craft and claim multiple further weapons, charging Convert for every copy',()=>{
 const id='recipe_blueprint-agate-lf4',r=assembly.RECIPES[id],price=r.costs[0].parts[0].ammount;
 db.prepare('INSERT INTO assembly_usage(player_id,recipe_loot_id,uses)VALUES(?,?,1)').run(pid,id);give('resource_convert-module',price*3);
 assert.equal(r.usingStrategy,'ALWAYS_USABLE');assert.equal(r.stackable,true);
 for(const n of [2,1]){assembly.build(pid,id,n,0,1000);const job=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=?').get(pid,id);assembly.collect(pid,id,0,job.due_at);}
 assert.equal(assembly.count(db,pid,'equipment_weapon_laser_lf-4'),3);assert.equal(assembly.count(db,pid,'resource_convert-module'),0);
 assert.equal(db.prepare('SELECT uses FROM assembly_usage WHERE player_id=? AND recipe_loot_id=?').get(pid,id).uses,4);
 assert.equal(require('../game/module-policy').repeatableEquipment({result:[{lootID:'drone_zeus'}]},require('../docs/client-map.items.json').items),false);
});

test('assembly inventory sends real one-based drone XP levels through native codec for all six stages',()=>{
 const drone=drones.addOwned(db,pid,'drone_iris');
 for(let level=0;level<6;level++){
  db.prepare('UPDATE drones SET level=?,upgrade_level=15 WHERE id=?').run(level,drone);
  const wire=codec.decode(codec.encode(assembly.inventoryCommand(pid))).obj;
  const item=wire.inventoryItemModules.find(i=>i.itemId===assembly.DRONE_OFFSET+drone);
  assert.ok(item);assert.equal(item.upgradeLevel,15);assert.equal(item.inventoryItemAttributes.find(a=>a.key===1).value,String(level+1));
 }
});

test('native moveDroneDesign removes Havoc/Hercules/Spartan/visual from one config and rejects foreign or wrong slots',()=>{
 const api=require('../web/inventory-api'),drone=drones.addOwned(db,pid,'drone_iris');
 const call=(owner,r)=>JSON.parse(Buffer.from(api.handle(owner,new URLSearchParams({action:'moveDroneDesign',params:Buffer.from(JSON.stringify(r)).toString('base64')})).body,'base64').toString());
 for(const [loot,slot]of [['drone_designs_havoc','design'],['drone_designs_hercules','design'],['drone_designs_spartan','design'],['drone_designs_intimidator','visual']]){
  const item=give(loot);for(const configId of [1,2])drones.move(pid,{params:{hi:p.shipId},from:{target:'inventory',configId,items:[item]},to:{target:'drone',configId,droneId:drone,slotset:slot}});
  const r={params:{hi:p.shipId},from:{target:'drone',configId:1,droneId:drone,slotset:slot,items:[item]},to:{target:'inventory',configId:1}};
  const rejected=call(pid,{...r,from:{...r.from,slotset:'default'}});assert.notEqual(rejected.data?.ret?.success,true);
  const result=call(pid,r);assert.equal(result.data.ret.success,true);assert.deepEqual(result.data.ret.newEffects,{'1':{},'2':{}});
  assert.equal(drones.equipped(db,p.shipId,1).some(i=>i.id===item),false);assert.equal(drones.equipped(db,p.shipId,2).some(i=>i.id===item),true);
  assert.equal(db.prepare('SELECT amount FROM items WHERE id=?').get(item).amount,1);
  drones.move(pid,{...r,from:{...r.from,configId:2},to:{...r.to,configId:2}});
 }
 const foreign=players.createPlayer(players.createAccount('foreign','test'),'Foreign',1,config.starter),item=give('drone_designs_havoc');
 assert.notEqual(call(foreign,{params:{hi:p.shipId},from:{target:'drone',droneId:drone,slotset:'design',items:[item]},to:{target:'inventory'}}).data?.ret?.success,true);
});

test('trade icon availability, native activation and ore sale share real owner/alive/range rules',()=>{
 const maps=require('../game/maps'),gameplay=require('../game/gameplay'),collect=require('../game/collectables'),world=new World(config),sent=[];
 const session={world,close(){}};world.login(session,pid);const player=world.player;Object.assign(player,{mapId:1,x:920,y:2000});
 const send=(s,c)=>sent.push(codec.decode(codec.encode(c)).obj),handlers=new Map();gameplay.register((name,fn)=>handlers.set(name,fn),{sendCmd:send});const activate=handlers.get('MapAssetActivationRequest');
 try{
  const state=codec.decode(codec.encode(maps.tradeState(world))).obj;assert.equal(state.activatable,true);
  assert.equal(activate(session,{mapAssetId:150000022}),true);assert.ok(sent.some(c=>c._==='OreTradeInfoCommand'));
  db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,6,64)').run(pid);const credits=player.credits;
  assert.equal(collect.sell(session,{toSell:{oreType:{typeValue:6},count:64}},send),true);assert.equal(player.credits,credits+32000);
  for(const change of [{dead:true},{dead:false,x:20000},{x:920,factionId:2}]){Object.assign(player,change);assert.equal(maps.tradeState(world).activatable,false);assert.equal(activate(session,{mapAssetId:150000022}),false);}
  Object.assign(player,{factionId:1,x:920});session.jumping=true;assert.equal(maps.tradeState(world).activatable,false);assert.equal(activate(session,{mapAssetId:150000022}),false);
 }finally{world.removeSession(session);}
});

test('historical 67 lasers and four paid upgrades restore once into free inventory without touching current wallet or assignments',()=>{
 const receipt=require('../logs/retired-lasers-removal.json'),source=new DatabaseSync(path.resolve(__dirname,'..',receipt.backup),{readOnly:true});
 const restore=require('../game/restore-lasers');while(db.prepare('SELECT COUNT(*) n FROM players').get().n<3)players.createPlayer(players.createAccount('restore-'+Math.random(),'test'),'Owner',1,config.starter);
 const before=db.prepare('SELECT * FROM players ORDER BY id').all(),originalItems=db.prepare('SELECT * FROM items ORDER BY id').all();
 try{
  const report=restore.restore(db,source,receipt);assert.equal(report.reduce((n,r)=>n+r.restoredRows,0),67);assert.equal(report.reduce((n,r)=>n+r.restoredJobs,0),4);
  for(const r of report)for(const [oldId,newId]of Object.entries(r.mapping)){
   const old=source.prepare('SELECT * FROM items WHERE id=?').get(oldId),item=db.prepare('SELECT * FROM items WHERE id=?').get(newId);
   assert.equal(item.player_id,old.player_id);assert.equal(item.upgrade_level,old.upgrade_level);assert.equal(item.loot_id,old.loot_id);assert.equal(item.ship_id,null);
  }
  const size=db.prepare('SELECT COUNT(*) n FROM items').get().n;assert.ok(restore.restore(db,source,receipt).every(r=>r.repeated));assert.equal(db.prepare('SELECT COUNT(*) n FROM items').get().n,size);
  assert.deepEqual(db.prepare('SELECT * FROM players ORDER BY id').all(),before);for(const i of originalItems)assert.deepEqual(db.prepare('SELECT * FROM items WHERE id=?').get(i.id),i);
 }finally{source.close();}
});

test('restoration rolls back all rows if archive validation fails late',()=>{
 const receipt=structuredClone(require('../logs/retired-lasers-removal.json')),source=new DatabaseSync(path.resolve(__dirname,'..',receipt.backup),{readOnly:true});
 while(db.prepare('SELECT COUNT(*) n FROM players').get().n<3)players.createPlayer(players.createAccount('rollback-'+Math.random(),'test'),'Owner',1,config.starter);
 receipt.removed.rows.at(-1).upgrade_level++;const before=db.prepare('SELECT * FROM items ORDER BY id').all();
 try{assert.throws(()=>require('../game/restore-lasers').restore(db,source,receipt),/Archive and receipt differ/);assert.deepEqual(db.prepare('SELECT * FROM items ORDER BY id').all(),before);assert.equal(db.prepare('SELECT COUNT(*) n FROM settings WHERE key=?').get(require('../game/restore-lasers').KEY).n,0);}finally{source.close();}
});
