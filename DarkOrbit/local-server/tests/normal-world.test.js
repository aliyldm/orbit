'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),content=require('../game/normal-map-content'),layout=require('../game/normal-map-layout'),profiles=require('../game/normal-map-spawns'),special=require('../game/normal-npc-special'),codec=require('../game/codec/codec'),loot=require('../game/collectables'),gameplay=require('../game/gameplay');
let db,f;
beforeEach(()=>{
 database.close();db=database.open(':memory:');const account=players.createAccount('normal-world-qa','testpass'),id=players.createPlayer(account,'World QA',1,config.starter),world=new World(config),commands=[];
 const session={world,send(){},close(){}};world.login(session,id);world.rendererMode=2;
 Object.assign(world.player,{x:6000,y:6000,hitPoints:100000000,hitMax:100000000,level:17});
 const send=(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(decoded.obj);};
 const combat=new Combat(world,send);combat.map=maps.getMap(1);f={world,commands,session,combat,p:world.player,id,send};
});
afterEach(()=>{f.world.removeSession(f.session);database.close();});
function spawn(key,behavior={},extra={}){return f.combat.spawn({...content.definition(key,behavior),...extra},{x:6400,y:6000});}

test('versioned world installation covers32 maps and96 routes, preserves old layout evidence and subsequent custom tuning',()=>{
 assert.equal(db.prepare('SELECT count(*) n FROM portals').get().n,96);
 const installed=db.prepare('SELECT * FROM normal_world_versions WHERE version=?').get(content.VERSION),old=JSON.parse(installed.previous_content_json);
 assert.equal(old.portals.length,24);assert.ok(old.spawns.some(s=>s.npc_type===119));
 assert.equal(db.prepare('SELECT count(*) n FROM maps WHERE id IN (51,52,53,55,70,73,74,75,203,300)').get().n,10);
 db.prepare('UPDATE map_spawns SET count=23 WHERE map_id=1').run();assert.equal(content.seed(db),false);
 assert.equal(db.prepare('SELECT count FROM map_spawns WHERE map_id=1').get().count,23);
 assert.equal(db.prepare('PRAGMA foreign_key_check').all().length,0);
});

test('failed normal world installation rolls back routes, population and the version marker together',()=>{
 db.prepare('DELETE FROM normal_world_versions WHERE version=?').run(content.VERSION);
 const routes=db.prepare('SELECT * FROM portals ORDER BY id').all(),spawns=db.prepare('SELECT * FROM map_spawns ORDER BY id').all();
 db.exec("CREATE TRIGGER world_install_fail BEFORE INSERT ON map_spawns BEGIN SELECT RAISE(ABORT,'world install failure'); END");
 assert.throws(()=>content.seed(db),/world install failure/);
 assert.deepEqual(db.prepare('SELECT * FROM portals ORDER BY id').all(),routes);assert.deepEqual(db.prepare('SELECT * FROM map_spawns ORDER BY id').all(),spawns);
 assert.equal(db.prepare('SELECT count(*) n FROM normal_world_versions WHERE version=?').get(content.VERSION).n,0);
});

test('every normal map spawns precisely its permanent profile with real codec models and no gate shield policy',()=>{
 for(const map of layout.maps){
  f.combat.stop();Object.assign(f.p,{mapId:map.id,x:6000,y:6000,dead:false});f.combat.spawnAll();
  const expected=profiles.get(map.name).filter(r=>!r.dependentOn).reduce((n,r)=>n+r.count,0);
  assert.equal(f.combat.npcs.size,expected,map.name);
  f.combat.spawnAll();assert.equal(f.combat.npcs.size,expected,`${map.name} no double population`);
  for(const npc of f.combat.npcs.values()){
   assert.ok(npc.def.key);assert.equal(f.combat.npcAbsorb(npc),.8);assert.ok(npc.x>=0&&npc.x<=map.width&&npc.y>=0&&npc.y<=map.height);
   assert.notEqual(npc.def.typeId,119);assert.ok(npc.def.cargo?.length);
  }
 }
 assert.equal(f.world.scheduled.size,0);assert.equal(f.combat.respawns.size,0);
});

test('Cubikon deploys guards only after real damage, remains harmless and cleans only its own guards on death',()=>{
 const mother=spawn('cubikon',{supports:[{key:'protegit',count:20,activation:'damaged',respawnMs:5000}]}),other=spawn('protegit');
 special.tick(f.combat,100000);assert.equal(special.children(f.combat,mother).length,0);
 mother.aggro=f.session;mother.shield--;mother.lastHit=100000;special.tick(f.combat,100001);
 assert.equal(special.children(f.combat,mother).length,20);special.tick(f.combat,100002);assert.equal(special.children(f.combat,mother).length,20);
 const child=special.children(f.combat,mother)[0],uri=f.p.uridium;child.hp=0;f.combat.kill(f.session,child);
 assert.equal(f.p.uridium,uri+16);assert.equal(f.combat.respawns.size,0,'transient guards have no standalone respawn');
 special.tick(f.combat,105001);assert.equal(special.children(f.combat,mother).length,20);
 mother.hp=0;f.combat.kill(f.session,mother);assert.equal(special.children(f.combat,mother).length,0);assert.ok(f.combat.npcs.has(other.id));
});

test('Battleray guard shield blocks all shared damage until partial escorts die and surviving guards receive healing',()=>{
 const mother=spawn('battleray',{supports:[{key:'interceptor',count:10,activation:'always',protectionThreshold:5,healEveryMs:10000,healFraction:.1}]});
 assert.equal(f.combat.npcProtected(mother),true);const hp=mother.hp,shield=mother.shield;f.combat.applyDamage(mother,1000);assert.deepEqual([mother.hp,mother.shield],[hp,shield]);
 special.tick(f.combat,100000);assert.equal(special.children(f.combat,mother).length,10);assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message===`0|n|ISH|${mother.id}`));
 for(const npc of special.children(f.combat,mother).slice(0,5)){npc.hp=0;f.combat.kill(f.session,npc);}
 assert.equal(f.combat.npcProtected(mother),false);const child=special.children(f.combat,mother)[0];child.hp=100;
 special.tick(f.combat,110000);assert.equal(child.hp,6100);assert.equal(special.children(f.combat,mother).length,5,'shield does not instantly refill into a deadlock');
 f.combat.applyDamage(mother,1000);assert.equal(mother.hp,hp-200);assert.equal(mother.shield,shield-800);
});

test('native upper bases use outpost assets and neutral pirate base uses actual station6 plus invisible trader52',()=>{
 f.p.mapId=20;const upper=maps.commands(f.world);assert.ok(upper.some(c=>c._==='AssetCreateCommand'&&c.type.typeValue===47));assert.ok(upper.some(c=>c._==='AssetCreateCommand'&&c.type.typeValue===51));assert.ok(!upper.some(c=>c._==='AssetCreateCommand'&&c.type.typeValue===46));
 Object.assign(f.p,{mapId:92,x:10500,y:6550});const pirate=maps.commands(f.world);assert.equal(maps.nearStation(f.world),true);
 assert.ok(pirate.some(c=>c._==='SpaceStationCommand'&&c.type===6));assert.ok(pirate.some(c=>c._==='AssetCreateCommand'&&c.type.typeValue===52));assert.equal(loot.tradeInfo(f.world).type,5);
 for(const c of [...upper,...pirate])assert.equal(codec.decode(codec.encode(c)).rest,0);
});

test('normal NPC cargo uses exact source contents and the real harvest respects free space',()=>{
 f.world.collectables=new loot.Collectables(f.world,f.send);const npc=spawn('mordon');Object.assign(npc,{x:f.p.x,y:f.p.y});
 const box=f.world.collectables.cargo(npc);assert.deepEqual(box.ores,require('../game/normal-npc-cargo.json').mordon);
 const capacity=f.p.cargoSpaceMax;assert.equal(f.world.collectables.collect(f.session,{itemHash:box.hash}),true);
 const total=db.prepare('SELECT sum(amount) n FROM player_resources WHERE player_id=?').get(f.id).n;assert.ok(total>20&&total<=capacity);
});

test('pirate palladium collects and exchanges15to1 only at the neutral base, with atomic rollback',()=>{
 Object.assign(f.p,{mapId:93,x:6000,y:6000});const collect=new loot.Collectables(f.world,f.send);collect.populate();assert.equal([...collect.boxes.values()].filter(b=>b.oreType===8).length,480);
 const ore=collect.add({x:f.p.x,y:f.p.y,oreType:8,amount:30});assert.equal(collect.collect(f.session,{itemHash:ore.hash}),true);
 assert.equal(loot.exchangePalladium(f.session,'30',f.send),false);Object.assign(f.p,{mapId:92,x:10500,y:6550});
 assert.equal(loot.exchangePalladium(f.session,'16',f.send),false);assert.equal(loot.exchangePalladium(f.session,'30',f.send),true);
 assert.equal(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(f.id).energy,2);
 assert.equal(loot.exchangePalladium(f.session,'30',f.send),false);
 db.prepare('UPDATE player_resources SET amount=30 WHERE player_id=? AND ore_type=8').run(f.id);
 db.exec("CREATE TRIGGER exchange_fail BEFORE UPDATE ON galaxy_gate_accounts BEGIN SELECT RAISE(ABORT,'exchange failure'); END");
 assert.throws(()=>loot.exchangePalladium(f.session,'30',f.send),/exchange failure/);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=8').get(f.id).amount,30);
});

test('actual jump enforces company-sensitive map and direct-link levels and hides foreign pirate exits',()=>{
 gameplay.register(()=>{},{sendCmd:f.send,combatFor:()=>f.combat,buildInit:()=>[]});
 Object.assign(f.p,{mapId:3,level:2});const gate=maps.portals(3,1).find(p=>p.target_map===4);Object.assign(f.p,{x:gate.x,y:gate.y});
 assert.equal(gameplay.jump(f.session,gate.id),false);assert.ok(f.commands.some(c=>c._==='JumpDeniedCommand'&&c.mandatoryLevel===3));
 f.p.level=3;assert.equal(gameplay.jump(f.session,gate.id),true);f.world.cancelScheduled();f.session.jumping=false;
 Object.assign(f.p,{mapId:91,level:17});assert.equal(maps.portals(91,1).length,1);assert.equal(maps.portals(91,2).length,1);
 assert.notEqual(maps.portals(91,1)[0].id,maps.portals(91,2)[0].id);
});
