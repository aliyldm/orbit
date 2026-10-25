'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),content=require('../game/normal-map-content'),special=require('../game/npc-special-attacks'),runtime=require('../game/normal-map-runtime'),utilities=require('../game/combat-utilities'),abilities=require('../game/ship-abilities'),codec=require('../game/codec/codec');
let db,f;
beforeEach(t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});
 database.close();db=database.open(':memory:');const a=players.createAccount('pirate-special-qa','testpass'),id=players.createPlayer(a,'Pirate QA',1,config.starter),world=new World(structuredClone(config)),commands=[];
 const session={world,send(){},close(){}};world.login(session,id);world.rendererMode=2;
 Object.assign(world.player,{mapId:91,x:6000,y:6000,hitPoints:1000000,hitMax:1000000,shield:0,oreBuffSignature:'[]'});
 const combat=new Combat(world,(s,c)=>{const d=codec.decode(codec.encode(c));assert.equal(d.rest,0);commands.push(d.obj);});combat.map=maps.getMap(91);
 f={world,session,combat,commands,id,p:world.player};
});
afterEach(()=>{f.world.removeSession(f.session);database.close();});
function spawn(key,overrides={},position={x:6400,y:6000}){return f.combat.spawn({...content.definition(key,{aggression:'aggressive',roam:false}),damageMin:1000,damageMax:1000,...overrides},position);}
function hits(){return f.commands.filter(c=>c._==='AttackHitCommand'&&c.victimId===f.id);}
function messages(){return f.commands.filter(c=>c._==='LegacyModule').map(c=>c.message);}
function managed(){const row=content.spawnRows(db,91).find(r=>r.def.key==='barracuda');const npc=runtime.spawn(f.combat,{...row.def,normalSpawnId:row.spawnId,normalSpawnSlot:0});Object.assign(npc,{x:6400,y:6000});return npc;}
function saved(npc){return db.prepare('SELECT * FROM normal_spawn_state WHERE player_id=? AND spawn_id=? AND slot=0').get(f.id,npc.def.normalSpawnId);}

test('Saboteur landed laser reduces real movement speed once and rescales an in-progress route',t=>{
 const npc=spawn('saboteur'),base=f.p.speed;
 f.world.move(f.session,{positionX:6000,positionY:6000,targetX:10000,targetY:6000});
 f.combat.tick();assert.equal(f.p.speed,Math.round(base*.3));assert.equal(f.p.hitPoints,999000);
 assert.equal(f.world.movement.duration,4000/f.p.speed*1000);
 assert.ok(messages().includes(`0|n|fx|start|SABOTEUR_DEBUFF|${f.id}`));
 t.mock.timers.tick(1000);f.combat.tick();assert.equal(f.p.speed,Math.round(base*.3));assert.equal(f.p.npcSlow.until,106000);
 assert.equal(messages().filter(m=>m.includes('|start|SABOTEUR_DEBUFF|')).length,1);
 assert.ok(f.commands.some(c=>c._==='AttributeShipSpeedUpdateCommand'&&c.newSpeed===f.p.speed));assert.equal(npc.aggro,f.session);
});

test('missed or invulnerability-blocked Saboteur lasers cannot apply a slow',()=>{
 spawn('saboteur');f.combat.cfg.npcHitChance=0;f.combat.tick();assert.equal(f.p.npcSlow,undefined);assert.equal(hits().length,0);
 f.combat.cfg.npcHitChance=1;f.p.invulnerableUntil=110000;f.combat.tick();assert.equal(f.p.npcSlow,undefined);assert.equal(hits().length,0);
});

test('Saboteur expiry restores equipment speed and publishes exactly one end effect',t=>{
 const npc=spawn('saboteur'),base=f.p.speed;special.onLaserHit(f.combat,npc);t.mock.timers.tick(4999);special.tick(f.combat);assert.equal(f.p.speed,Math.round(base*.3));
 t.mock.timers.tick(1);special.tick(f.combat);special.tick(f.combat);assert.equal(f.p.speed,base);assert.equal(f.p.npcSlow,null);assert.equal(messages().filter(m=>m.includes('|end|SABOTEUR_DEBUFF|')).length,1);
});

test('EMP clears slow only after a successful inventory/cooldown commit',()=>{
 const npc=spawn('saboteur'),base=f.p.speed;special.onLaserHit(f.combat,npc);
 assert.throws(()=>utilities.action(f.session,{menuItemId:utilities.EMP,actionType:1}),/Yetersiz/);assert.equal(f.p.speed,Math.round(base*.3));
 db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(f.id,utilities.EMP);
 assert.equal(utilities.action(f.session,{menuItemId:utilities.EMP,actionType:1}),true);assert.equal(f.p.speed,base);assert.equal(f.p.npcSlow,null);assert.equal(utilities.count(f.p,utilities.EMP),0);
});

test('equipment/config stat refresh preserves slow and expiry restores the fresh base',()=>{
 const npc=spawn('saboteur');special.onLaserHit(f.combat,npc);f.world.refreshStats();const base=players.loadPlayer(f.id).speed;assert.equal(f.p.speed,Math.round(base*.3));
 special.clearSlow(f.world);assert.equal(f.p.speed,base);
});

test('Lightning and slow compose, clear independently and never compound after refresh',()=>{
 db.prepare("UPDATE ships SET loot_id='ship_v-lightning' WHERE id=?").run(f.p.shipId);f.world.refreshStats();const base=f.p.speed,npc=spawn('saboteur');
 special.onLaserHit(f.combat,npc);assert.equal(abilities.action(f.session,{menuItemId:'ability_lightning',actionType:1}),true);assert.equal(f.p.speed,Math.round(base*.3*1.3));
 f.world.refreshStats();assert.equal(f.p.speed,Math.round(base*.3*1.3));special.clearSlow(f.world);assert.equal(f.p.speed,Math.round(base*1.3));
 special.onLaserHit(f.combat,npc);abilities.stop(f.world);assert.equal(f.p.speed,Math.round(base*.3));special.clearSlow(f.world);assert.equal(f.p.speed,base);
});

test('death and map teardown clear transient slow without permanently saving reduced speed',()=>{
 const npc=spawn('saboteur'),base=f.p.speed;special.onLaserHit(f.combat,npc);f.combat.killPlayer(npc);assert.equal(f.p.speed,base);assert.equal(f.p.npcSlow,null);
 f.p.dead=false;special.onLaserHit(f.combat,npc);f.combat.stop();assert.equal(f.p.speed,base);assert.equal(f.p.npcSlow,null);assert.equal(players.loadPlayer(f.id).speed,base);
});

test('Annihilator launches actual five-round Hellstorm and deals damage only at final missile impact',t=>{
 const npc=spawn('annihilator');const stock=db.prepare('SELECT sum(amount) n FROM items WHERE player_id=?').get(f.id).n;
 f.combat.tick();const shot=f.commands.find(c=>c._==='HellstormAttackCommand');assert.equal(shot.attackerId,npc.id);assert.equal(shot.targetId,f.id);assert.equal(shot.currentLoad,5);assert.equal(shot.rocketType.typeValue,21);
 assert.ok(!f.commands.some(c=>c._==='AttackLaserRunCommand'&&c.attackerId===npc.id));assert.equal(hits().length,0);assert.equal([...f.combat.projectiles][0].delay,1500);
 t.mock.timers.tick(1499);assert.equal(f.p.hitPoints,1000000);t.mock.timers.tick(1);assert.equal(f.p.hitPoints,999000);assert.equal(hits()[0].attackType.attackTypeValue,0);assert.equal(f.combat.projectiles.size,0);
 assert.equal(db.prepare('SELECT sum(amount) n FROM items WHERE player_id=?').get(f.id).n,stock);
});

test('Annihilator cooldown prevents tick spam and takes effect at the configured deadline',t=>{
 spawn('annihilator');f.combat.tick();t.mock.timers.tick(1000);f.combat.tick();assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,1);
 t.mock.timers.tick(4000);f.combat.tick();assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,2);
});

test('Annihilator impact observes current invulnerability and a launch miss cannot damage',t=>{
 spawn('annihilator');f.combat.tick();f.p.invulnerableUntil=110000;t.mock.timers.tick(1500);assert.equal(hits().length,0);
 f.p.invulnerableUntil=0;f.combat.cfg.npcHitChance=0;t.mock.timers.tick(3500);f.combat.tick();assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').at(-1).hit,false);t.mock.timers.tick(1500);assert.equal(hits().length,0);
});

test('removed/replaced launchers and jumping sessions cannot deliver stale NPC impacts',t=>{
 const npc=spawn('annihilator');f.combat.tick();f.combat.npcs.set(npc.id,{...npc});t.mock.timers.tick(1500);assert.equal(hits().length,0);
 f.combat.npcs.set(npc.id,npc);t.mock.timers.tick(3500);f.combat.tick();f.session.jumping=true;t.mock.timers.tick(1500);assert.equal(hits().length,0);
 f.session.jumping=false;f.combat.cancelProjectiles();assert.equal(f.combat.projectiles.size,0);
});

test('special attacks cannot acquire distant, station-protected, dead or jumping players',()=>{
 const npc=spawn('annihilator',{}, {x:12000,y:6000});f.combat.tick();assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,0);
 Object.assign(npc,{x:6400,y:6000,movement:null});f.session.jumping=true;f.combat.tick();f.session.jumping=false;f.p.dead=true;f.combat.tick();assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,0);
 f.p.dead=false;f.p.mapId=1;f.combat.map=maps.getMap(1);Object.assign(f.p,{x:2000,y:2000});Object.assign(npc,{x:2100,y:2000});f.combat.tick();assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,0);
});

test('Barracuda saves its fuse before warning, explodes once and retires without kill rewards or cargo',t=>{
 const npc=managed(),before=f.p.credits;npc.hp=100;const xp=db.prepare('SELECT experience FROM drones WHERE player_id=?').all(f.id);let cargo=0;f.world.collectables={cargo(){cargo++;},clear(){}};
 assert.equal(special.beforeAi(f.combat,npc),false);assert.equal(saved(npc).self_destruct_at,110000);assert.ok(messages().includes(`0|n|fx|start|KAM|${npc.id}`));assert.equal(hits().length,0);
 t.mock.timers.tick(9999);assert.equal(special.beforeAi(f.combat,npc),false);t.mock.timers.tick(1);assert.equal(special.beforeAi(f.combat,npc),true);assert.equal(f.p.hitPoints,800000);assert.equal(f.p.credits,before);assert.equal(cargo,0);assert.deepEqual(db.prepare('SELECT experience FROM drones WHERE player_id=?').all(f.id),xp);
 assert.equal(f.combat.npcs.has(npc.id),false);assert.equal(saved(npc).respawn_at,140000);assert.equal(f.combat.respawns.size,1);
 assert.equal(special.beforeAi(f.combat,npc),true);assert.equal(f.p.hitPoints,800000);assert.equal(f.commands.filter(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===npc.id).length,1);
 const boom=f.commands.findIndex(c=>c._==='LegacyModule'&&c.message===`0|n|BOOOM|${npc.id}`),destroy=f.commands.findIndex(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===npc.id);assert.ok(boom>=0&&boom<destroy);
});

test('armed Barracuda detonates on contact and clears selection without cargo',()=>{
 const npc=spawn('barracuda',{}, {x:6100,y:6000});npc.hp=1;f.session.selected=f.session.attacking=npc.id;special.beforeAi(f.combat,npc);assert.equal(f.p.hitPoints,800000);assert.equal(f.session.selected,null);assert.equal(f.session.attacking,null);assert.equal(f.p.credits,0);
});

test('Barracuda fuse outside blast radius still retires but does not hurt the player',t=>{
 const npc=spawn('barracuda',{}, {x:7000,y:6000});npc.hp=1;special.beforeAi(f.combat,npc);t.mock.timers.tick(10000);special.beforeAi(f.combat,npc);assert.equal(f.p.hitPoints,1000000);assert.equal(hits().length,0);assert.equal(f.combat.npcs.has(npc.id),false);
});

test('armed Barracuda can be killed normally before its fuse, giving one real reward',t=>{
 const npc=managed();npc.hp=100;special.beforeAi(f.combat,npc);const credit=npc.def.reward.credits;npc.hp=0;f.combat.kill(f.session,npc);assert.equal(f.p.credits,credit);t.mock.timers.tick(10000);special.beforeAi(f.combat,npc);assert.equal(f.p.credits,credit);assert.equal(hits().length,0);assert.equal(f.commands.filter(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===npc.id).length,1);
});

test('unloading/reloading a map keeps the fuse deadline and fresh respawn clears it',t=>{
 const npc=managed();npc.hp=100;special.beforeAi(f.combat,npc);const def=npc.def;f.combat.stop();t.mock.timers.tick(11000);const restored=runtime.spawn(f.combat,def);assert.equal(restored.selfDestructAt,110000);
 special.beforeAi(f.combat,restored);assert.equal(f.combat.npcs.has(restored.id),false);assert.equal(saved(restored).respawn_at,141000);
 t.mock.timers.tick(30000);const fresh=runtime.spawn(f.combat,def);assert.equal(fresh.selfDestructAt,0);assert.equal(fresh.hp,def.hitpoints);assert.equal(fresh.def.normalSpawnGeneration,2);
});

test('failed fuse persistence rolls back arming and sends no warning',()=>{
 const npc=managed();npc.hp=100;db.exec("CREATE TRIGGER fail_fuse BEFORE UPDATE OF self_destruct_at ON normal_spawn_state BEGIN SELECT RAISE(ABORT,'fuse failure'); END");
 assert.throws(()=>special.beforeAi(f.combat,npc),/fuse failure/);db.exec('DROP TRIGGER fail_fuse');assert.equal(npc.selfDestructAt,0);assert.equal(saved(npc).self_destruct_at,0);assert.ok(!messages().some(m=>m.includes('|KAM|')));
});

test('failed retirement persistence cannot damage, announce destruction or create a respawn',t=>{
 const npc=managed();npc.hp=100;special.beforeAi(f.combat,npc);t.mock.timers.tick(10000);
 db.exec("CREATE TRIGGER fail_retire BEFORE UPDATE OF respawn_at ON normal_spawn_state BEGIN SELECT RAISE(ABORT,'retire failure'); END");assert.throws(()=>special.beforeAi(f.combat,npc),/retire failure/);db.exec('DROP TRIGGER fail_retire');assert.equal(f.p.hitPoints,1000000);assert.ok(f.combat.npcs.has(npc.id));assert.equal(f.combat.respawns.size,0);assert.ok(!messages().some(m=>m.includes('|BOOOM|')));
 special.beforeAi(f.combat,npc);assert.equal(f.p.hitPoints,800000);assert.equal(f.combat.respawns.size,1);
});

test('Barracuda blast respects active instashield and still retires the NPC',()=>{
 const npc=spawn('barracuda',{}, {x:6100,y:6000});npc.hp=1;f.p.invulnerableUntil=110000;special.beforeAi(f.combat,npc);assert.equal(f.p.hitPoints,1000000);assert.equal(hits().length,0);assert.equal(f.combat.npcs.has(npc.id),false);
});

test('unproven Uber variants and gate NPCs do not inherit base pirate special abilities',()=>{
 for(const key of ['uber-barracuda','uber-saboteur','uber-annihilator']){const npc=spawn(key);npc.hp=1;assert.equal(special.beforeAi(f.combat,npc),false);special.onLaserHit(f.combat,npc);assert.equal(special.attack(f.combat,npc,f.session),false);}
 for(const key of ['barracuda','saboteur','annihilator']){const npc=spawn(key,{gateRunId:123});npc.hp=1;assert.equal(special.beforeAi(f.combat,npc),false);special.onLaserHit(f.combat,npc);assert.equal(special.attack(f.combat,npc,f.session),false);}
 assert.equal(f.p.npcSlow,undefined);assert.equal(messages().filter(m=>m.includes('|KAM|')).length,0);
});
