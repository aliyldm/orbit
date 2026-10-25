'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),content=require('../game/normal-map-content'),codec=require('../game/codec/codec'),config=require('../config');
let db,w,s,c,p,sent;
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('npc-return','testpass'),'NPC QA',1,config.starter);
 w=new World(structuredClone(config));sent=[];s={send(){}};w.login(s,id);p=w.player;Object.assign(p,{mapId:2,x:6000,y:6000});c=new Combat(w,(s,cmd)=>sent.push(codec.decode(codec.encode(cmd)).obj));c.map=maps.getMap(2);
});
afterEach(()=>{w.removeSession(s);database.close();});
test('x3/x4 rebalance supplies sixteen Devolarium/Sibelon per company and reduces smaller enemies',()=>{
 for(const company of [1,2,3])for(const suffix of [3,4]){
  const m=db.prepare('SELECT id FROM maps WHERE name=?').get(`${company}-${suffix}`),rows=content.spawnRows(db,m.id),get=key=>rows.find(r=>r.def.key===key)?.count;
  assert.equal(get(suffix===3?'devolarium':'sibelon'),16);assert.equal(get('lordakia'),6);assert.equal(get('saimon'),6);assert.equal(get('mordon'),8);
  c.stop();p.mapId=m.id;c.spawnAll();assert.equal([...c.npcs.values()].filter(n=>n.def.key===(suffix===3?'devolarium':'sibelon')).length,16);
 }
});
test('population upgrade preserves stable spawn IDs, damaged enemies and death deadlines, and runs only once',()=>{
 c.spawnAll();const npc=[...c.npcs.values()][0];npc.hp=123;c.stop();const states=db.prepare('SELECT * FROM normal_spawn_state').all(),ids=db.prepare('SELECT id FROM map_spawns ORDER BY id').all();
 db.prepare('DELETE FROM normal_world_versions WHERE version=?').run(content.POPULATION_VERSION);db.prepare("UPDATE map_spawns SET count=3 WHERE catalog_key IN ('sibelon','devolarium')").run();
 assert.equal(content.seed(db),true);assert.deepEqual(db.prepare('SELECT id FROM map_spawns ORDER BY id').all(),ids);assert.deepEqual(db.prepare('SELECT * FROM normal_spawn_state').all(),states);
 db.prepare("UPDATE map_spawns SET count=13 WHERE map_id=4 AND catalog_key='sibelon'").run();assert.equal(content.seed(db),false);assert.equal(content.spawnRows(db,4).find(r=>r.def.key==='sibelon').count,13);
 assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(),[]);
});
test('map departure forgets target and advances a retreat to the saved patrol anchor without resetting damage',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});c.spawnAll();const npc=[...c.npcs.values()].find(n=>n.def.key==='lordakia');
 Object.assign(npc,{patrolHome:{x:6000,y:6000},x:18000,y:11500,hp:321,shield:123,lastHit:100000,aggro:s});const identity=n=>n.def.normalSpawnId===npc.def.normalSpawnId&&n.def.normalSpawnSlot===npc.def.normalSpawnSlot;
 c.stop();const saved=db.prepare('SELECT * FROM normal_spawn_state WHERE player_id=? AND spawn_id=? AND slot=?').get(p.userId,npc.def.normalSpawnId,npc.def.normalSpawnSlot);assert.equal(saved.patrol_returning,1);assert.equal(saved.home_x,6000);
 p.mapId=1;c.spawnAll();c.stop();t.mock.timers.tick(1000);Object.assign(p,{mapId:2,x:18000,y:11500});c.spawnAll();let restored=[...c.npcs.values()].find(identity);
 assert.equal(restored.aggro,null);assert.equal(restored.returning,true);assert.equal(restored.hp,321);assert.equal(restored.shield,123);assert.ok(restored.x<18000);assert.ok(restored.x>6000);
 assert.equal(c.normalAi(restored,c.normalRules(restored),Date.now()),true);assert.equal(restored.aggro,null);assert.equal(restored.movement.targetX,6000);assert.equal(restored.movement.targetY,6000);
 c.stop();p.mapId=1;c.spawnAll();c.stop();t.mock.timers.tick(120000);p.mapId=2;c.spawnAll();restored=[...c.npcs.values()].find(identity);
 assert.deepEqual([restored.x,restored.y],[6000,6000]);assert.equal(restored.returning,false);assert.equal(restored.aggro,null);assert.equal(restored.hp,321);
});
test('lost pursuit actively returns to its last patrol point instead of camping at a portal',()=>{
 const npc=c.spawn(content.definition('sibelon',{aggression:'aggressive'}),{x:6000,y:6000});Object.assign(npc,{x:18000,y:11500,aggro:s});Object.assign(p,{x:18500,y:11500});
 assert.equal(c.normalAi(npc,c.normalRules(npc),Date.now()),true);assert.equal(npc.aggro,null);assert.equal(npc.returning,true);assert.equal(npc.movement.targetX,6000);
 // Even a pilot immediately re-entering the acquisition range is not an old
 // target: the retreat completes before normal contact acquisition resumes.
 Object.assign(p,{x:18000,y:11500});c.normalAi(npc,c.normalRules(npc),Date.now());assert.equal(npc.aggro,null);
});
test('native beacon shows original peacearea text at own portals and attacks consume nothing there',()=>{
 const gate=maps.portals(2,1)[0];Object.assign(p,{x:gate.x,y:gate.y});const beacon=codec.decode(codec.encode(maps.beacon(w))).obj;
 assert.equal(beacon.inPeaceArea,true);assert.equal(beacon.inStation,false);assert.equal(beacon.nearJumpGate,true);
 const npc=c.spawn(content.definition('sibelon'),{x:gate.x+100,y:gate.y});const ammo=require('../game/ammo'),before=ammo.count(p),rockets=ammo.count(p,'ammunition_rocket_r-310'),hp=p.hitPoints;
 assert.equal(c.attack(s,npc.id),false);assert.equal(c.rocket(s,{targetId:npc.id}),false);assert.equal(c.damagePlayer(npc,100,{evade:false}),0);assert.equal(p.hitPoints,hp);assert.equal(ammo.count(p),before);assert.equal(ammo.count(p,'ammunition_rocket_r-310'),rockets);
 for(const mapId of [6,13,14,15,16,51]){p.mapId=mapId;const g=maps.portals(mapId,1)[0];if(g)Object.assign(p,{x:g.x,y:g.y});assert.equal(maps.nearPeaceArea(w),false,`no permanent own portal protection on ${mapId}`);}
 const source=require('fs').readFileSync(require('path').join(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/BeaconHandler.as'),'utf8');assert.match(source,/inPeaceArea/);assert.match(source,/setDemilitarizedZone/);
});
