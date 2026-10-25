'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat');
const fields=require('../game/pirate-fields'),cpu=require('../game/cpu'),maps=require('../game/maps'),{Collectables}=require('../game/collectables'),codec=require('../game/codec/codec');
let db,w,p,s,out,combat;
beforeEach(()=>{
 database.close();db=database.open(':memory:');const account=players.createAccount('pirate-fields-qa','test-pass'),id=players.createPlayer(account,'Pirate QA',1,config.starter);
 w=new World(config);s={world:w,send(){},close(){}};w.login(s,id);p=w.player;out=[];
 combat=new Combat(w,(_,c)=>{assert.equal(codec.decode(codec.encode(c)).rest,0);out.push(c);});
 Object.assign(p,{mapId:93,x:6000,y:6000});combat.map=maps.getMap(93);
});
afterEach(()=>{w.removeSession(s);database.close();});
function cloak(){cpu.write(p,{cloaked:true,aim:true});p.cloaked=true;}
test('Palladium is abundant on5-3, sparse on5-1, absent on5-2 and all nodes lie within native fog POIs',()=>{
 for(const id of [91,92,93,1]){
  p.mapId=id;const c=new Collectables(w,combat.send);c.populate();const ores=[...c.boxes.values()].filter(b=>b.oreType===8);
  assert.equal(ores.length,fields.FIELDS[id]?.count||0);for(const ore of ores){assert.ok(fields.contains(id,ore));assert.equal(ore.amount,1);}
  const commands=maps.commands(w),fog=commands.filter(c=>c.poiId?.startsWith('pirate-mist-'));
  assert.equal(fog.length,id===91||id===93?1:0);
  for(const cmd of fog){assert.deepEqual(codec.decode(codec.encode(cmd)).obj,cmd);assert.equal(cmd.design.designValue,5);assert.ok(commands.indexOf(cmd)<commands.findIndex(c=>c._==='POIReadyCommand'));}
 }
});
test('collected Palladium respawns within its field without replaying grants or reusing its hash',()=>{
 const c=new Collectables(w,combat.send);w.collectables=c;c.populate();const ore=[...c.boxes.values()].find(b=>b.oreType===8);Object.assign(p,{x:ore.x,y:ore.y});
 let delayed;w.schedule=(fn,delay)=>{assert.equal(delay,15000);delayed=fn;return {};};
 assert.equal(c.collect(s,{itemHash:ore.hash}),true);assert.equal(c.collect(s,{itemHash:ore.hash}),false);
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=8').get(p.userId).amount,1);
 delayed();const ores=[...c.boxes.values()].filter(b=>b.oreType===8);assert.equal(ores.length,480);assert.ok(ores.every(o=>fields.contains(93,o)));assert.equal(c.boxes.has(ore.hash),false);
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=8').get(p.userId).amount,1);
});
test('crossing a whole mist field between position updates permanently breaks cloak once without changing speed or shields',()=>{
 cloak();Object.assign(p,{x:20000,y:18000,speed:500,shield:1234});const before=p.speed;
 w.movement={x:p.x,y:p.y,targetX:20000,targetY:26000,start:1000,duration:16000};
 w.updatePosition(17000);assert.equal(p.cloaked,false);assert.equal(cpu.isCloaked(p),false);assert.deepEqual(cpu.read(p),{aim:true});
 assert.equal(p.speed,before);assert.equal(p.shield,1234);assert.equal(out.filter(c=>c.message===`0|n|INV|${p.userId}|0`).length,1);
 w.updatePosition(18000);assert.equal(out.filter(c=>c.message===`0|n|INV|${p.userId}|0`).length,1);
 assert.equal(fields.crosses(93,{x:1000,y:18000},{x:1000,y:26000}),false);
 assert.equal(fields.crosses(92,{x:20000,y:18000},{x:20000,y:26000}),false);
});
test('stationary fog entry/reconnect clears persisted cloak and exit does not restore it',()=>{
 cloak();Object.assign(p,{x:20000,y:22000});cpu.buildInit(p);assert.equal(p.cloaked,false);assert.equal(cpu.isCloaked(p),false);
 p.y=18000;assert.equal(cpu.isCloaked(p),false);cloak();p.y=22000;w.updatePosition();assert.equal(p.cloaked,false);
});
test('mist rejects cloak activation and automatic purchased cloak without spending charges or deleting the purchase',()=>{
 const id=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(p.userId,'equipment_extra_cpu_cl04k-xs').lastInsertRowid);
 Object.assign(p,{x:20000,y:22000});assert.equal(cpu.cloak(w),false);assert.equal(cpu.purchased(w,'equipment_extra_cpu_cl04k-xs'),false);
 assert.ok(db.prepare('SELECT id FROM items WHERE id=?').get(id));assert.equal(db.prepare('SELECT count(*) n FROM cpu_charges WHERE item_id=?').get(id).n,0);
 p.y=18000;assert.equal(cpu.purchased(w,'equipment_extra_cpu_cl04k-xs'),true);assert.equal(cpu.isCloaked(p),true);assert.equal(db.prepare('SELECT id FROM items WHERE id=?').get(id),undefined);
});
