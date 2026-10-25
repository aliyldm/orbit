'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),{Collectables,resourceCommands}=require('../game/collectables'),booty=require('../game/booty'),bonus=require('../game/bonus-boxes'),loot=require('../game/loot-rewards'),content=require('../game/normal-map-content'),codec=require('../game/codec/codec');
let db,f;
beforeEach(t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});database.close();db=database.open(':memory:');
 const account=players.createAccount('loot-audit','testpass'),id=players.createPlayer(account,'Loot QA',1,config.starter),world=new World(structuredClone(config)),commands=[];
 const session={world,send(){},close(){}};world.login(session,id);Object.assign(world.player,{mapId:2,x:6000,y:6000,oreBuffSignature:'[]'});
 const send=(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(decoded.obj);};
 const combat=new Combat(world,send);combat.map=maps.getMap(2);const collect=new Collectables(world,send);world.collectables=collect;
 f={world,session,commands,send,combat,collect,p:world.player,id};
});
afterEach(()=>{f.world.removeSession(f.session);database.close();});
function box(type='PIRATE_BOOTY',extra={}){return f.collect.add({x:f.p.x,y:f.p.y,boxType:type,...extra},false);}
function key(id='resource_booty-key',n=1){db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,n);}
function messages(){return f.commands.filter(c=>c._==='LegacyModule').map(c=>c.message);}
function amount(id){return loot.count(db,f.id,id);}

test('normal bonus amounts and battle-map counterparts reproduce the published FAQ table',()=>{
 const normal=[],battle=[];for(let i=0;i<bonus.entries.length;i++){normal.push(bonus.roll(2,()=>(i+.5)/bonus.entries.length));battle.push(bonus.roll(13,()=>(i+.5)/bonus.entries.length));}
 assert.deepEqual(normal.filter(r=>r.credits).map(r=>r.credits),[200,500,1000]);assert.deepEqual(normal.filter(r=>r.uridium).map(r=>r.uridium),[20,50,100]);
 for(const [id,expected]of [['ammunition_laser_lcb-10',[10,20,50]],['ammunition_laser_mcb-25',[5,10,20]],['ammunition_laser_mcb-50',[5,10,20]]])assert.deepEqual(normal.flatMap(r=>r.items?.[id]?[r.items[id]]:[]),expected);
 assert.deepEqual(battle.filter(r=>r.credits).map(r=>r.credits),[300,750,1500]);assert.deepEqual(battle.filter(r=>r.uridium).map(r=>r.uridium),[30,75,150]);
 assert.deepEqual(battle.flatMap(r=>r.items?.['ammunition_laser_mcb-25']?[r.items['ammunition_laser_mcb-25']]:[]),[8,15,30]);assert.equal(battle.find(r=>r.energy).energy,1);
 assert.throws(()=>bonus.roll(2,()=>1),/Invalid/);
});

test('normal maps advertise all locally enabled booty colors; starter and gate maps exclude booty',()=>{
 f.collect.populate();for(const boxType of Object.keys(booty.TYPES))assert.equal([...f.collect.boxes.values()].filter(b=>b.boxType===boxType).length,6);
 assert.equal([...f.collect.boxes.values()].filter(b=>b.bonus).length,24);
 for(const mapId of [1,51]){f.p.mapId=mapId;const c=new Collectables(f.world,f.send);c.populate();assert.equal([...c.boxes.values()].filter(b=>booty.type(b)).length,0);if(mapId===51)assert.equal(c.boxes.size,0);}
});

test('red/blue and Zeus colors follow explicit event switches rather than always spawning',()=>{
 f.world.config.booty.redBlueEvent=false;f.world.config.booty.zeusEvent=false;f.collect.populate();assert.equal([...f.collect.boxes.values()].filter(b=>booty.type(b)).length,6);assert.ok([...f.collect.boxes.values()].filter(b=>booty.type(b)).every(b=>b.boxType==='PIRATE_BOOTY'));
});

test('gold shares green keys, red and blue require their own keys and no direct collection bypass exists',()=>{
 key();for(const type of ['PIRATE_BOOTY','PIRATE_BOOTY_GOLD'])assert.equal(booty.canOpen(f.world,box(type)),true);
 for(const type of ['PIRATE_BOOTY_RED','PIRATE_BOOTY_BLUE'])assert.equal(booty.canOpen(f.world,box(type)),false);
 const b=box();assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),false);assert.equal(amount('resource_booty-key'),1);
 assert.equal(f.collect.beginHarvest(f.session,{itemHash:box('PIRATE_BOOTY_RED').hash}),false);assert.equal(f.world.scheduled.size,0);
});

test('booty opening uses the exact beam duration then atomically debits one key and grants a real item',t=>{
 key();const b=box();b.pendingReward={items:{'equipment_weapon_laser_lf-4':1}};f.session.attacking=999;
 assert.equal(f.collect.beginHarvest(f.session,{itemHash:b.hash}),true);assert.equal(f.session.attacking,999);assert.ok(messages().includes('0|y|SLA|5'));
 t.mock.timers.tick(4999);assert.equal(amount('resource_booty-key'),1);assert.equal(amount('equipment_weapon_laser_lf-4'),0);t.mock.timers.tick(1);
 assert.equal(amount('resource_booty-key'),0);assert.equal(amount('equipment_weapon_laser_lf-4'),1);assert.equal(f.collect.boxes.has(b.hash),false);
 assert.equal(db.prepare('SELECT count(*) n FROM loot_claims').get().n,1);assert.ok(messages().includes('0|A|BK|0'));assert.ok(messages().includes('0|y|LOT|equipment_weapon_laser_lf-4|1'));
 assert.ok(f.commands.some(c=>c._==='HangarShipsCommand'&&c.items.some(pack=>pack.items.some(i=>i.lootId==='equipment_weapon_laser_lf-4'))));
 assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),false);
});

test('movement cancels opening with the original effect and retains the unused key',t=>{
 key();const b=box();f.collect.beginHarvest(f.session,{itemHash:b.hash});t.mock.timers.tick(1000);f.world.move(f.session,{positionX:6000,positionY:6000,targetX:6100,targetY:6000});t.mock.timers.tick(5000);
 assert.equal(amount('resource_booty-key'),1);assert.equal(f.collect.boxes.has(b.hash),true);assert.ok(messages().includes('0|y|SLC'));assert.equal(db.prepare('SELECT count(*) n FROM loot_claims').get().n,0);
});

test('a key removed while opening cannot become a free reward',t=>{
 key();const b=box();b.pendingReward={uridium:100};f.collect.beginHarvest(f.session,{itemHash:b.hash});db.prepare('UPDATE items SET amount=0 WHERE player_id=? AND loot_id=?').run(f.id,'resource_booty-key');t.mock.timers.tick(5000);
 assert.equal(f.p.uridium,0);assert.equal(f.collect.boxes.has(b.hash),true);assert.equal(db.prepare('SELECT count(*) n FROM loot_claims').get().n,0);
});

test('SQL failure rolls back key, wallet, equipment and receipt; retry grants exactly once',()=>{
 key();const b=box(),reward={uridium:100,items:{'equipment_weapon_laser_lf-4':1}};
 db.exec("CREATE TRIGGER loot_fail BEFORE INSERT ON loot_claims BEGIN SELECT RAISE(ABORT,'loot failure'); END");assert.throws(()=>loot.grant(f.world,b,reward,{key:'resource_booty-key'}),/loot failure/);db.exec('DROP TRIGGER loot_fail');
 assert.equal(amount('resource_booty-key'),1);assert.equal(amount('equipment_weapon_laser_lf-4'),0);assert.equal(f.p.uridium,0);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(f.id).uridium,0);
 assert.equal(loot.grant(f.world,b,reward,{key:'resource_booty-key'}),true);key();assert.equal(loot.grant(f.world,b,reward,{key:'resource_booty-key'}),false);assert.equal(amount('resource_booty-key'),1);assert.equal(f.p.uridium,100);
});

test('red and blue keys debit independently and publish their actual counters',t=>{
 key('resource_booty-key-red');key('resource_booty-key-blue');
 for(const [type,id,counter]of [['PIRATE_BOOTY_RED','resource_booty-key-red','BKR'],['PIRATE_BOOTY_BLUE','resource_booty-key-blue','BKB']]){const b=box(type);b.pendingReward={energy:1};f.collect.beginHarvest(f.session,{itemHash:b.hash});t.mock.timers.tick(5000);assert.equal(amount(id),0);assert.ok(messages().includes(`0|A|${counter}|0`));}
 assert.equal(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(f.id).energy,2);
});

test('bonus ammo and energy are real persistent rewards, affected by bonus loot skills only once',()=>{
 f.p.stats.skills={...f.p.stats.skills,bonusLootMultiplier:2};const ammoBox=box('BONUS_BOX',{bonus:true,pendingReward:{items:{'ammunition_laser_mcb-25':10}}});assert.equal(f.collect.collect(f.session,{itemHash:ammoBox.hash}),true);assert.equal(amount('ammunition_laser_mcb-25'),20);
 const ee=box('BONUS_BOX',{bonus:true,pendingReward:{energy:1}});assert.equal(f.collect.collect(f.session,{itemHash:ee.hash}),true);assert.equal(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(f.id).energy,2);
});

test('bonus grant keeps legitimate fractional Uridium balances from PET fuel purchases',()=>{
 f.p.uridium=.75;const b=box('BONUS_BOX',{reward:{uridium:20}});assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true);assert.equal(f.p.uridium,20.75);
});

test('respawning bonus boxes get a fresh hash and do not inherit the previous random prize',t=>{
 const b=box('BONUS_BOX',{bonus:true,respawnMs:1000,pendingReward:{uridium:20}});f.collect.collect(f.session,{itemHash:b.hash});t.mock.timers.tick(1000);const next=[...f.collect.boxes.values()][0];assert.notEqual(next.hash,b.hash);assert.equal(next.pendingReward,undefined);assert.equal(next.grantedReward,undefined);
});

test('Xenomit occupies no cargo and remains collectable even when ordinary cargo is full',()=>{
 db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,0,?)').run(f.id,f.p.cargoSpaceMax);db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,3,100000)').run(f.id);resourceCommands(f.p);assert.equal(f.p.cargoSpace,0);
 const b=box('FROM_SHIP',{ores:[{type:0,amount:10},{type:3,amount:20}]});assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(f.id).amount,100020);assert.equal(f.p.cargoSpace,0);
 db.prepare('DELETE FROM player_resources WHERE ore_type=0').run();assert.equal(players.loadPlayer(f.id).cargoSpace,f.p.cargoSpaceMax);assert.equal(require('../game/skylab').state(f.id).cargoUsed,0);
});

test('cargo drops use source-specific gate ores and never invent a generic unknown fallback',()=>{
 const catalog=require('../game/npc-catalog');const infernal={def:catalog.get('infernal'),x:6000,y:6000};const b=f.collect.cargo(infernal);assert.equal(b.ores.find(r=>r.type===7).amount,1);
 assert.equal(f.collect.cargo({def:catalog.get('streuner-emperor'),x:6000,y:6000}),null);assert.equal(f.collect.cargo({def:{typeId:999},x:6000,y:6000}),null);assert.equal(f.collect.cargo({def:catalog.get('vagrant'),x:6000,y:6000}),null);
});

test('own-home high-level Streuner uses reduced kill and cargo rewards in the real combat path',()=>{
 f.p.mapId=1;f.p.level=7;f.combat.map=maps.getMap(1);f.collect.mapId=1;
 const npc=f.combat.spawn(content.definition('streuner'),{x:6000,y:6000});const b=f.collect.cargo(npc);assert.deepEqual(b.ores,[{type:0,amount:5},{type:1,amount:5}]);npc.hp=0;f.combat.kill(f.session,npc);assert.equal(f.p.credits,200);assert.equal(f.p.ep,200);assert.equal(f.p.uridium,0);assert.equal(f.p.honourPoints,1);
 f.p.level=10;assert.equal(f.collect.cargo({def:content.definition('streuner'),x:6000,y:6000}),null);
});

test('PET cannot bypass key opening even when it is at the chest',()=>{
 key();const b=box();const pet={x:6000,y:6000,active:true};f.world.petRuntime=pet;assert.equal(f.collect.collect(f.session,{itemHash:b.hash},pet),false);assert.equal(amount('resource_booty-key'),1);f.world.petRuntime=null;
});

test('booty prize selection excludes full blueprint and overflowing ammo/energy rewards',()=>{
 key('resource_blueprint_zeus-part',45);key('ammunition_laser_mcb-25',2147483647);db.prepare('INSERT INTO galaxy_gate_accounts(player_id,energy)VALUES(?,2147483647)').run(f.id);
 const b=box('PIRATE_BOOTY_GOLD');
 for(let i=0;i<100;i++){const reward=booty.roll(b,f.p,()=>(i+.5)/100);assert.equal(reward.items?.['resource_blueprint_zeus-part'],undefined);assert.equal(reward.items?.['ammunition_laser_mcb-25'],undefined);assert.equal(reward.energy,undefined);}
});

test('the client deferred final approach does not cancel an already started cargo beam',t=>{
 const b=box('FROM_SHIP',{x:6010,ores:[{type:0,amount:10}]});
 assert.equal(f.collect.beginHarvest(f.session,{itemHash:b.hash}),true);
 t.mock.timers.tick(100);f.world.move(f.session,{positionX:6000,positionY:6000,targetX:6010,targetY:6000});
 t.mock.timers.tick(400);assert.equal(f.collect.boxes.has(b.hash),false);
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=0').get(f.id).amount,10);
 assert.equal(messages().some(m=>m.startsWith('0|A|SLC')),false);
});

test('a no-op arrival update preserves booty opening; a different destination still cancels',t=>{
 key();const b=box();b.pendingReward={uridium:20};f.collect.beginHarvest(f.session,{itemHash:b.hash});
 t.mock.timers.tick(100);f.world.move(f.session,{positionX:6000,positionY:6000,targetX:6000,targetY:6000});
 t.mock.timers.tick(4900);assert.equal(f.collect.boxes.has(b.hash),false);assert.equal(f.p.uridium,20);
 const cargo=box('FROM_SHIP',{ores:[{type:0,amount:10}]});f.collect.beginHarvest(f.session,{itemHash:cargo.hash});
 f.world.move(f.session,{positionX:6000,positionY:6000,targetX:6500,targetY:6000});t.mock.timers.tick(500);
 assert.equal(f.collect.boxes.has(cargo.hash),true);assert.equal(f.session.harvest,null);
});

test('full ordinary cargo reports the native localized reason before starting a beam',()=>{
 db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,0,?)').run(f.id,f.p.cargoSpaceMax);
 const b=box('FROM_SHIP',{ores:[{type:0,amount:10}]});
 assert.equal(f.collect.beginHarvest(f.session,{itemHash:b.hash}),false);
 assert.ok(messages().includes('0|f'));assert.equal(messages().some(m=>m.includes('|SLA|')),false);
 assert.equal(f.collect.boxes.has(b.hash),true);assert.equal(f.session.harvest,undefined);
});

test('capacity exhausted during the beam reports full cargo and retains the drop',t=>{
 const b=box('FROM_SHIP',{ores:[{type:0,amount:10}]});f.collect.beginHarvest(f.session,{itemHash:b.hash});
 db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,0,?)').run(f.id,f.p.cargoSpaceMax);
 t.mock.timers.tick(500);assert.ok(messages().includes('0|f'));assert.equal(f.collect.boxes.has(b.hash),true);
});

test('PET cannot take cargo reserved by the player beam and the ore is granted exactly once',t=>{
 const b=box('FROM_SHIP',{ores:[{type:0,amount:10}]});f.collect.beginHarvest(f.session,{itemHash:b.hash});
 const pet={x:6000,y:6000,active:true,stats:{effects:{salvageMultiplier:1}}};f.world.petRuntime=pet;
 assert.equal(f.collect.collect(f.session,{itemHash:b.hash},pet),false);
 t.mock.timers.tick(500);assert.equal(f.collect.collect(f.session,{itemHash:b.hash},pet),false);
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=0').get(f.id).amount,10);f.world.petRuntime=null;
});

test('partial cargo retains the remaining ore and never reapplies skill bonuses or Xenomit',()=>{
 f.p.cargoSpaceMax=10;f.p.stats.skills={...f.p.stats.skills,cargoLootMultiplier:2};
 const b=box('FROM_SHIP',{ores:[{type:0,amount:10},{type:1,amount:10},{type:3,amount:5}]});
 assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true);
 assert.equal(f.collect.boxes.has(b.hash),true);assert.deepEqual(b.remainingOres,[{type:0,amount:10},{type:1,amount:20}]);
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(f.id).amount,10);
 assert.equal(f.commands.some(c=>c._==='RemoveCollectableCommand'&&c.hash===b.hash),false);
 // A different later skill level must not multiply the leftovers again.
 f.p.stats.skills.cargoLootMultiplier=3;db.prepare('DELETE FROM player_resources WHERE player_id=? AND ore_type<>3').run(f.id);
 f.p.cargoSpaceMax=100;assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true);
 assert.equal(f.collect.boxes.has(b.hash),false);
 assert.deepEqual(db.prepare('SELECT ore_type,amount FROM player_resources WHERE player_id=? ORDER BY ore_type').all(f.id).map(r=>({...r})),[{ore_type:0,amount:10},{ore_type:1,amount:20},{ore_type:3,amount:10}]);
});

test('remaining ordinary cargo cannot masquerade as fresh Xenomit when the hold is full',()=>{
 f.p.cargoSpaceMax=1;const b=box('FROM_SHIP',{ores:[{type:0,amount:10},{type:3,amount:5}]});
 assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true);
 assert.equal(f.collect.beginHarvest(f.session,{itemHash:b.hash}),false);assert.ok(messages().includes('0|f'));
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(f.id).amount,5);
});

test('Kronos NPC death creates its actual source cargo in the combat kill path',()=>{
 const def=require('../game/kronos').definition('phoenix'),npc=f.combat.spawn(def,{x:f.p.x,y:f.p.y});
 npc.hp=0;f.combat.kill(f.session,npc);
 const b=[...f.collect.boxes.values()].find(b=>b.boxType==='FROM_SHIP');assert.ok(b);
 assert.deepEqual(b.ores,[{type:0,amount:25},{type:1,amount:25},{type:2,amount:25},{type:4,amount:10},{type:5,amount:10}]);
});

test('Cubikon death leaves all seven official ores; a Seprom-filled hold collects only Xenomit and retains everything else',()=>{
 const expected=[{type:0,amount:1200},{type:1,amount:1200},{type:2,amount:1200},{type:3,amount:64},{type:4,amount:512},{type:5,amount:512},{type:6,amount:64}];
 f.p.stats.skills={...f.p.stats.skills,cargoLootMultiplier:1};
 const npc=f.combat.spawn(content.definition('cubikon'),{x:f.p.x,y:f.p.y});npc.hp=0;f.combat.kill(f.session,npc);
 const b=[...f.collect.boxes.values()].find(b=>b.boxType==='FROM_SHIP');assert.deepEqual(b.ores,expected);
 // Mirrors the observed account:397000Seprom is well beyond hull capacity.
 db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,7,397000)').run(f.id);
 assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true);assert.equal(f.p.cargoSpace,0);
 assert.deepEqual(b.remainingOres,expected.filter(o=>o.type!==3));assert.ok(messages().includes('0|f'));
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(f.id).amount,64);
 assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(f.id).amount,397000);
 assert.equal(f.commands.some(c=>c._==='RemoveCollectableCommand'&&c.hash===b.hash),false);
 // Empty hold without deleting the box: the rest can be retrieved exactly once.
 db.prepare('DELETE FROM player_resources WHERE player_id=? AND ore_type=7').run(f.id);f.p.cargoSpaceMax=6000;
 assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true);assert.equal(f.collect.boxes.has(b.hash),false);
 assert.deepEqual(db.prepare('SELECT ore_type,amount FROM player_resources WHERE player_id=? ORDER BY ore_type').all(f.id).map(r=>({type:r.ore_type,amount:r.amount})),expected);
});

test('all 45 normal NPC deaths produce source-specific ore and collect the same native ore IDs into an empty hold',()=>{
 f.p.cargoSpaceMax=100000;f.p.stats.skills={...f.p.stats.skills,cargoLootMultiplier:1};
 for(const [key,expected]of Object.entries(require('../game/normal-npc-cargo.json'))){
  db.prepare('DELETE FROM player_resources WHERE player_id=?').run(f.id);f.collect.boxes.clear();
  const npc=f.combat.spawn(content.definition(key),{x:f.p.x,y:f.p.y});npc.hp=0;f.combat.kill(f.session,npc);
  const b=[...f.collect.boxes.values()].find(b=>b.boxType==='FROM_SHIP');assert.ok(b,key);assert.deepEqual(b.ores,expected,key);
  assert.equal(f.collect.collect(f.session,{itemHash:b.hash}),true,key);
  assert.deepEqual(db.prepare('SELECT ore_type,amount FROM player_resources WHERE player_id=? ORDER BY ore_type').all(f.id).map(r=>({type:r.ore_type,amount:r.amount})),expected,key);
 }
});
