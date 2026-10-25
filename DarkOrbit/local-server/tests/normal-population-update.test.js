'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),content=require('../game/normal-map-content'),profiles=require('../game/normal-map-spawns'),layout=require('../game/normal-map-layout'),players=require('../game/db/players'),config=require('../config');
let db;
beforeEach(()=>{database.close();db=database.open(':memory:');});
afterEach(()=>database.close());
const mapId=name=>layout.maps.find(m=>m.name===name).id;
const row=(map,key)=>db.prepare('SELECT * FROM map_spawns WHERE map_id=? AND catalog_key=?').get(mapId(map),key);
function prepareUpgrade(){db.prepare('DELETE FROM normal_world_versions WHERE version=?').run(content.POPULATION_VERSION);db.prepare('INSERT OR IGNORE INTO normal_world_versions VALUES(?,?,?)').run('normal-population-2026-10-21-v2',1,'{}');}

test('population v3 sets large NPC targets for all factions and pirates without changing habitat membership',()=>{
 assert.equal(content.POPULATION_VERSION,'normal-population-2026-10-23-v3');
 for(const faction of [1,2,3])for(const [suffix,key,count]of [[3,'devolarium',16],[4,'sibelon',16],[5,'lordakium',12],[5,'lordakia',8],[5,'sibelonit',12],[6,'kristallon',12],[7,'kristallon',18],[7,'kristallin',12]]){
  assert.equal(row(`${faction}-${suffix}`,key).count,count);assert.equal(profiles.get(`${faction}-${suffix}`).find(r=>r.key===key).count,count);
 }
 for(const map of ['5-1','5-2','5-3'])assert.equal(row(map,'annihilator').count,6);
 for(const map of layout.maps){const expected=profiles.get(map.name).filter(r=>!r.dependentOn).map(r=>r.key).sort(),actual=db.prepare('SELECT catalog_key FROM map_spawns WHERE map_id=? ORDER BY catalog_key').all(map.id).map(r=>r.catalog_key);assert.deepEqual(actual,expected,map.name);}
});

test('population upgrade changes counts in place once and preserves pilot damage, respawn generation and custom rows',()=>{
 const id=players.createPlayer(players.createAccount('population-upgrade','test-pass'),'NPC QA',1,config.starter);
 const spawn=row('1-7','kristallon');db.prepare('UPDATE map_spawns SET count=5,respawn_ms=65432,behavior_json=? WHERE id=?').run('{"aggression":"passive","roam":false}',spawn.id);
 db.prepare('INSERT INTO normal_spawn_state(player_id,map_id,spawn_id,slot,generation,hp,shield,x,y,respawn_at,saved_at,last_hit)VALUES(?,?,?,?,?,?,?,?,?,?,?,?)').run(id,mapId('1-7'),spawn.id,2,7,0,123,555,777,123456789,98765,1234);
 const state=db.prepare('SELECT * FROM normal_spawn_state').get(),player=db.prepare('SELECT * FROM players WHERE id=?').get(id),items=db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),ships=db.prepare('SELECT * FROM ships WHERE player_id=? ORDER BY id').all(id);
 const custom=Number(db.prepare('INSERT INTO map_spawns(map_id,npc_type,count,respawn_ms)VALUES(?,?,?,?)').run(mapId('1-7'),spawn.npc_type,2,12345).lastInsertRowid);
 prepareUpgrade();assert.equal(content.seed(db),true);
 const updated=row('1-7','kristallon');assert.equal(updated.id,spawn.id);assert.equal(updated.count,18);assert.equal(updated.respawn_ms,65432);assert.equal(updated.behavior_json,'{"aggression":"passive","roam":false}');
 assert.deepEqual(db.prepare('SELECT * FROM normal_spawn_state').get(),state);assert.deepEqual(db.prepare('SELECT * FROM players WHERE id=?').get(id),player);assert.deepEqual(db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),items);assert.deepEqual(db.prepare('SELECT * FROM ships WHERE player_id=? ORDER BY id').all(id),ships);
 assert.equal(db.prepare('SELECT count FROM map_spawns WHERE id=?').get(custom).count,2);
 assert.ok(JSON.parse(db.prepare('SELECT previous_content_json FROM normal_world_versions WHERE version=?').get(content.POPULATION_VERSION).previous_content_json).spawns.some(r=>r.id===spawn.id&&r.count===5));
 db.prepare('UPDATE map_spawns SET count=21 WHERE id=?').run(spawn.id);assert.equal(content.seed(db),false);assert.equal(row('1-7','kristallon').count,21);assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(),[]);
});

test('population upgrade fills missing parent profiles with their real dependent escort behavior',()=>{
 const cubikon=row('1-6','cubikon'),battleray=row('5-3','battleray');db.prepare('DELETE FROM map_spawns WHERE id IN (?,?)').run(cubikon.id,battleray.id);prepareUpgrade();assert.equal(content.seed(db),true);
 assert.deepEqual(JSON.parse(row('1-6','cubikon').behavior_json).supports,[{key:'protegit',count:20,activation:'damaged',respawnMs:5000}]);
 assert.deepEqual(JSON.parse(row('5-3','battleray').behavior_json).supports,[{key:'interceptor',count:10,activation:'always',respawnMs:5000,protectionThreshold:5,healEveryMs:10000,healFraction:.1}]);
 assert.equal(db.prepare("SELECT COUNT(*) n FROM map_spawns WHERE catalog_key='protegit'").get().n,0,'dependent escorts are never standalone population rows');
 assert.equal(content.seed(db),false);
});

test('failed population update rolls back every preceding count and does not commit its version marker',()=>{
 prepareUpgrade();db.prepare("UPDATE map_spawns SET count=3 WHERE catalog_key='kristallon'").run();db.prepare("UPDATE map_spawns SET count=5 WHERE catalog_key='devolarium'").run();
 const before=db.prepare('SELECT * FROM map_spawns ORDER BY id').all();db.exec("CREATE TRIGGER population_fail BEFORE UPDATE ON map_spawns WHEN OLD.catalog_key='kristallon' BEGIN SELECT RAISE(ABORT,'population failure'); END");
 assert.throws(()=>content.seed(db),/population failure/);assert.deepEqual(db.prepare('SELECT * FROM map_spawns ORDER BY id').all(),before);assert.equal(db.prepare('SELECT 1 FROM normal_world_versions WHERE version=?').get(content.POPULATION_VERSION),undefined);
 db.exec('DROP TRIGGER population_fail');assert.equal(content.seed(db),true);assert.equal(row('1-7','kristallon').count,18);
});
