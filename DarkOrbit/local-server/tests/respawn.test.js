'use strict';
const {test,before,after,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),config=require('../config'),respawn=require('../game/respawn'),gameplay=require('../game/gameplay'),maps=require('../game/maps'),codec=require('../game/codec/codec');
let db,f,serial=0;
before(()=>{db=database.open(':memory:');});after(()=>database.close());
beforeEach(()=>{
 const id=players.createPlayer(players.createAccount('respawn-qa-'+ ++serial,'testpass'),'Respawn QA',1,{...config.starter,uridium:10000}),world=new World(config),out=[],session={world,send(){},close(){}};
 world.login(session,id);Object.assign(world.player,{mapId:2,x:9000,y:6200,shieldMax:1000,shield:1000});
 const send=(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);out.push(decoded.obj);},combat=new Combat(world,send);combat.map=maps.getMap(2);
 const handlers=new Map();gameplay.register((name,fn)=>handlers.set(name,fn),{sendCmd:send,combatFor:()=>({start(){}}),buildInit:w=>gameplay.initialize(w)});
 f={world,p:world.player,session,id,out,combat,send,handlers};
});
afterEach(()=>{db.exec('DROP TRIGGER IF EXISTS fail_respawn');f.world.removeSession(f.session);});
function die(){f.combat.killPlayer({def:{name:'Streuner'}});assert.ok(respawn.context(f.world,f.session),'real combat death must capture paid-repair context');return f.out.findLast(c=>c._==='KillScreenPostCommand');}
function request(type,id=f.id){return{selection:{repairTypeValue:type},requestModule:{userID:id}};}

test('real native death screen contains three source option types, Uri prices and localized count replacements',()=>{
 const c=codec.decode(codec.encode(die())).obj;assert.deepEqual(c.options.map(o=>o.repairType.repairTypeValue),[1,2,3]);assert.deepEqual(c.options.map(o=>o.price.amount),[0,500,2000]);assert.deepEqual(c.options.map(o=>o.price.type),[0,1,1]);assert.ok(c.options.every(o=>o.affordableForPlayer));
 assert.equal(c.options[1].buttonKey.wildCardReplacements[0].replacement,'500');assert.equal(c.options[2].descriptionKey.wildCardReplacements[0].replacement,'2000');
});

test('same-place native repair charges once, saves ten percent base HP and grants exactly ten seconds protection',()=>{
 die();const balance=f.p.uridium,position={x:f.p.x,y:f.p.y};assert.equal(gameplay.repair(f.session,request(3)),true);
 assert.equal(f.p.mapId,2);assert.equal(f.p.x,position.x);assert.equal(f.p.y,position.y);assert.equal(f.p.uridium,balance-2000);assert.equal(f.p.shield,0);assert.equal(f.p.nanoHull,0);assert.equal(f.p.dead,false);
 const base=db.prepare('SELECT t.hitpoints FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id WHERE s.id=?').get(f.p.shipId).hitpoints;assert.equal(f.p.hitPoints,Math.round(base*.1));
 const saved=players.loadPlayer(f.id);assert.equal(saved.uridium,balance-2000);assert.equal(saved.hitPoints,f.p.hitPoints);assert.equal(saved.mapId,2);
 const until=f.p.respawnProtectedUntil;assert.equal(respawn.protectedNow(f.world,until-1),true);assert.equal(respawn.protectedNow(f.world,until),false);
 assert.ok(f.out.some(c=>c._==='VisualModifierCommand'&&c.modifier===33&&c.activated));assert.ok(f.out.some(c=>c._==='VisualModifierCommand'&&c.modifier===33&&!c.activated));
 assert.equal(gameplay.repair(f.session,request(3)),false);assert.equal(players.loadPlayer(f.id).uridium,balance-2000);
});

test('nearest-portal repair stays on the death map at the actual closest visible gate and costs500',()=>{
 die();const expected=maps.portals(2,1).sort((a,b)=>maps.dist(f.p,a)-maps.dist(f.p,b)||a.id-b.id)[0],balance=f.p.uridium;
 assert.equal(gameplay.repair(f.session,request(2)),true);assert.equal(f.p.mapId,2);assert.equal(f.p.x,expected.x);assert.equal(f.p.y,expected.y);assert.equal(f.p.uridium,balance-500);assert.equal(f.p.hitPoints,f.p.hitMax);assert.equal(respawn.protectedNow(f.world),false);
});

test('free base repair remains free and rejects a foreign owner, live session and unsupported native option',()=>{
 assert.equal(gameplay.repair(f.session,request(1)),false);die();const balance=f.p.uridium;
 assert.equal(gameplay.repair(f.session,request(1,f.id+1)),false);assert.equal(gameplay.repair(f.session,request(9)),false);assert.equal(gameplay.repair(f.session,request('3')),false);
 const other={world:f.world,player:f.p};assert.equal(gameplay.repair(other,request(1)),false);
 assert.equal(gameplay.repair(f.session,request(1)),true);assert.equal(f.p.mapId,1);assert.equal(f.p.uridium,balance);assert.equal(f.p.hitPoints,f.p.hitMax);
});

test('insufficient funds, wrong ship and forged live database state cannot debit or resurrect',()=>{
 die();f.p.uridium=499;db.prepare('UPDATE players SET uridium=499 WHERE id=?').run(f.id);assert.equal(respawn.command(f.world).options[1].affordableForPlayer,false);
 assert.equal(gameplay.repair(f.session,request(2)),false);assert.equal(f.p.dead,true);assert.equal(players.loadPlayer(f.id).hitPoints,0);assert.equal(f.p.uridium,499);
 f.p.uridium=10000;db.prepare('UPDATE players SET uridium=10000 WHERE id=?').run(f.id);const ship=f.p.shipId;f.p.shipId++;assert.equal(gameplay.repair(f.session,request(3)),false);f.p.shipId=ship;
 db.prepare('UPDATE ships SET hitpoints=1 WHERE id=?').run(ship);assert.equal(gameplay.repair(f.session,request(3)),false);assert.equal(players.loadPlayer(f.id).uridium,10000);
});

test('storage failure rolls back balance, HP and destination together and keeps the death usable',()=>{
 die();const before={uri:f.p.uridium,map:f.p.mapId,x:f.p.x,y:f.p.y};
 db.exec("CREATE TRIGGER fail_respawn BEFORE UPDATE OF hitpoints ON ships BEGIN SELECT RAISE(ABORT,'respawn-storage-failure'); END");
 assert.throws(()=>gameplay.repair(f.session,request(2)),/respawn-storage-failure/);assert.equal(f.session.respawning,false);assert.equal(f.p.dead,true);assert.equal(f.p.uridium,before.uri);assert.equal(f.p.mapId,before.map);assert.equal(f.p.x,before.x);assert.equal(f.p.y,before.y);
 const saved=players.loadPlayer(f.id);assert.equal(saved.uridium,before.uri);assert.equal(saved.hitPoints,0);assert.equal(saved.mapId,before.map);assert.ok(respawn.context(f.world,f.session));
 db.exec('DROP TRIGGER fail_respawn');assert.equal(gameplay.repair(f.session,request(2)),true);
});

test('paid repairs expire on relogin while native base repair remains available',()=>{
 die();const old=f.session,next={world:f.world,send(){},close(){}};f.world.login(next,f.id);f.session=next;f.p=f.world.player;
 const c=respawn.command(f.world);assert.equal(c.options[0].affordableForPlayer,true);assert.equal(c.options.length,1);
 assert.equal(gameplay.repair(old,request(3)),false);assert.equal(gameplay.repair(next,request(3)),false);assert.equal(gameplay.repair(next,request(1)),true);
});

test('Galaxy Gate death never sells a same-place or portal escape from wave/life accounting',()=>{
 Object.assign(f.p,{mapId:51,hitPoints:0,dead:true});f.world.save();respawn.recordDeath(f.world);
 const c=respawn.command(f.world);assert.equal(c.options.length,1);const balance=f.p.uridium;
 assert.equal(gameplay.repair(f.session,request(2)),false);assert.equal(gameplay.repair(f.session,request(3)),false);assert.equal(f.p.uridium,balance);assert.equal(f.p.mapId,51);
 assert.equal(gameplay.repair(f.session,request(1)),true);assert.equal(f.p.mapId,1);assert.equal(f.p.uridium,balance);
});

test('offensive action cancels only respawn protection, leaving independent ISH protection intact',()=>{
 die();assert.equal(gameplay.repair(f.session,request(3)),true);f.p.invulnerableUntil=Date.now()+3000;
 assert.equal(respawn.protectedNow(f.world),true);assert.equal(respawn.breakProtection(f.world),true);assert.equal(respawn.protectedNow(f.world),false);assert.ok(f.p.invulnerableUntil>Date.now());assert.equal(respawn.breakProtection(f.world),false);
});

test('real combat death and codec-decoded native selection repair atomically; NPC damage is blocked until a real laser attack',()=>{
 const ui=die(),option=ui.options.find(c=>c.repairType.repairTypeValue===3),wire=codec.decode(codec.encode({_:'KillScreenRepairRequest',selection:option.repairType,requestModule:{_:'LoginRequest',userID:f.id}}));
 assert.equal(wire.rest,0);assert.equal(f.handlers.get('KillScreenRepairRequest')(f.session,wire.obj),true);assert.equal(f.p.dead,false);assert.equal(players.loadPlayer(f.id).uridium,8000);
 const npc=f.combat.spawn({key:'respawn-qa',typeId:84,name:'Streuner',hitpoints:100000,shield:0,speed:100,damageMin:100,damageMax:100,reward:{},respawnMs:5000},{x:f.p.x+100,y:f.p.y});
 const hp=f.p.hitPoints;assert.equal(f.combat.damagePlayer(npc,100,{evade:false}),0);assert.equal(f.p.hitPoints,hp);
 assert.equal(f.combat.attack(f.session,npc.id),true);assert.equal(respawn.protectedNow(f.world),false,'successful ordinary laser fire uses the same protection cancellation as HST/modern/tech attacks');
 assert.equal(f.combat.damagePlayer(npc,100,{evade:false}),100);assert.equal(f.p.hitPoints,hp-100);
 assert.equal(f.handlers.get('KillScreenRepairRequest')(f.session,wire.obj),false);assert.equal(players.loadPlayer(f.id).uridium,8000);
});

test('base resurrection preserves damaged old-map NPCs and their return to patrol before changing pilot map',()=>{
 f.combat.spawnAll();const npc=[...f.world.npcs.values()].find(n=>n.def.key==='lordakia');Object.assign(npc,{hp:321,patrolHome:{x:6000,y:6000},x:12000,y:6200,aggro:f.session});
 die();assert.equal(npc.returning,true);assert.equal(gameplay.repair(f.session,request(1)),true);assert.equal(f.p.mapId,1);
 const row=db.prepare('SELECT * FROM normal_spawn_state WHERE player_id=? AND spawn_id=? AND slot=?').get(f.id,npc.def.normalSpawnId,npc.def.normalSpawnSlot);
 assert.equal(row.hp,321);assert.equal(row.patrol_returning,1);assert.deepEqual([row.home_x,row.home_y],[6000,6000]);
});
