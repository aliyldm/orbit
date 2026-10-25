'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open,tx}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),codec=require('../game/codec/codec'),ammo=require('../game/ammo'),hst=require('../game/hellstorm'),inventory=require('../game/inventory'),pet=require('../game/pet'),utilities=require('../game/combat-utilities'),abilities=require('../game/ship-abilities');
let n=0;
function fixture(ship=config.starter.ship){const a=players.createAccount(`gate-combat-${++n}`,'testpass'),id=players.createPlayer(a,'Gate Combat QA',1,{...config.starter,ship}),world=new World({...config,combat:{...config.combat,damageSpread:0}}),commands=[],session={world,send(){},close(){}};world.login(session,id);world.rendererMode=2;Object.assign(world.player,{x:6000,y:6000});const send=(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);commands.push(decoded.obj);};world.petSend=send;const combat=new Combat(world,send);combat.map=maps.getMap(1);return{world,commands,session,combat,p:world.player,id};}
function spawn(f,options={}){const npc=f.combat.spawn({typeId:84,name:'Gate QA',hitpoints:100000,shield:10000,speed:200,damageMin:1,damageMax:1,reward:{},respawnMs:5000,...options});Object.assign(npc,{x:6400,y:6000});f.session.selected=npc.id;return npc;}
function finish(f){f.world.removeSession(f.session);}
function item(f,id,count=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,count).lastInsertRowid);}
function hstLoad(f,id='ammunition_rocketlauncher_eco-10',count=3){const launcher=item(f,'equipment_weapon_rocketlauncher_hst-1');inventory.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[launcher]},to:{target:'ship',slotset:'heavy_guns'}});item(f,id,count);hst.select(f.session,id);hst.tick(f.world,f.combat,Date.now()+5000);}
function blast(f,id,now=Date.now()){item(f,id);return utilities.action(f.session,{menuItemId:id,actionType:1},now);}

test('gate shield50/50 overrides ordinary80/20 for hero lasers while SAB stays shield-only and clamps actual charge',()=>{
 const f=fixture(),gate=spawn(f,{shieldAbsorb:.5}),normal=spawn(f);f.combat.applyLaserDamage(f.p,gate,1000,'ammunition_laser_lcb-10');f.combat.applyLaserDamage(f.p,normal,1000,'ammunition_laser_lcb-10');assert.deepEqual([gate.shield,gate.hp],[9500,99500]);assert.deepEqual([normal.shield,normal.hp],[9200,99800]);
 f.p.shield=0;f.p.shieldMax=1000;gate.shield=200;assert.equal(f.combat.applyLaserDamage(f.p,gate,1000,'ammunition_laser_sab-50'),200);assert.deepEqual([gate.shield,gate.hp,f.p.shield],[0,99500,200]);finish(f);
});

test('standard rocket and HST resolve gate50/50 at their real delayed impact',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const f=fixture(),npc=spawn(f,{shieldAbsorb:.5});assert.equal(f.combat.rocket(f.session,{targetId:npc.id}),true);t.mock.timers.tick(800);assert.deepEqual([npc.hp,npc.shield],[99500,9500]);
 hstLoad(f);assert.equal(hst.fire(f.session,npc.id),true);t.mock.timers.tick(1434);assert.deepEqual([npc.hp,npc.shield],[96500,6500]);finish(f);
});

test('a target becoming protected in flight receives neither standard rocket damage nor SAR shield transfer',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const f=fixture(),npc=spawn(f,{shieldAbsorb:.5});f.p.shield=0;f.p.shieldMax=10000;
 f.combat.rocket(f.session,{targetId:npc.id});hstLoad(f,'ammunition_rocketlauncher_sar-01');hst.fire(f.session,npc.id);npc.def.invulnerable=true;f.commands.length=0;t.mock.timers.tick(1600);assert.deepEqual([npc.hp,npc.shield,f.p.shield],[100000,10000,0]);assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'));assert.equal(f.commands.filter(c=>c._==='AttackMissedCommand').length,2);finish(f);
});

test('protection gates reject launches without ammo loss and guard direct shared damage plus SAB transfer',()=>{
 const f=fixture(),npc=spawn(f,{invulnerable:true,shieldAbsorb:.5}),before=ammo.count(f.p,'ammunition_rocket_r-310');assert.equal(f.combat.rocket(f.session,{targetId:npc.id}),false);assert.equal(ammo.count(f.p,'ammunition_rocket_r-310'),before);
 hstLoad(f);assert.equal(hst.fire(f.session,npc.id),false);assert.equal(hst.count(f.p,'ammunition_rocketlauncher_eco-10'),3);assert.equal(hst.state(f.world).loaded,3);
 f.p.shield=0;f.p.shieldMax=10000;assert.equal(f.combat.applyLaserDamage(f.p,npc,1000,'ammunition_laser_sab-50'),0);assert.equal(f.combat.applyDamage(npc,1000),0);assert.deepEqual([npc.hp,npc.shield,f.p.shield],[100000,10000,0]);finish(f);
});

test('protected and empty-SAB hero attack ticks emit misses instead of phantom shield damage, stale targets abort once',()=>{
 const f=fixture(),npc=spawn(f,{invulnerable:true});f.session.attacking=npc.id;const before=ammo.count(f.p);f.combat.tick();assert.equal(ammo.count(f.p),before);assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'&&c.victimId===npc.id));assert.ok(f.commands.some(c=>c._==='AttackMissedCommand'&&c.targetUserId===npc.id));
 npc.def.invulnerable=false;npc.shield=0;item(f,'ammunition_laser_sab-50',100);ammo.select(f.p,'ammunition_laser_sab-50');f.commands.length=0;f.combat.tick();assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'&&c.victimId===npc.id));assert.equal(npc.hp,100000);
 f.session.attacking=9999999;f.commands.length=0;f.combat.tick();f.combat.tick();assert.equal(f.session.attacking,null);assert.equal(f.commands.filter(c=>c._==='AttackAbortLaserCommand'&&c.uid===f.id).length,1);finish(f);
});

test('PET guard applies gate50/50 and protection prevents both PET ammo debit and fake hits',()=>{
 // This test verifies allocation/protection; hit/miss RNG is tested separately.
 const f=fixture(),npc=spawn(f,{shieldAbsorb:.5});tx(d=>{pet.addOwned(d,f.id);pet.addFuel(d,f.id,100);});const laser=item(f,'equipment_weapon_laser_lf-1');pet.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[laser]},to:{target:'pet',slotset:'lasers'}});pet.launch(f.world);pet.selectGear(f.world,2);f.session.attacking=npc.id;
 const r=f.world.petRuntime,damage=r.stats.laserDamage;f.combat.rollHit=()=>true;r.lastTick=Date.now()-1000;pet.tick(f.world,f.combat);assert.deepEqual([npc.shield,npc.hp],[10000-Math.round(damage*.5),100000-(damage-Math.round(damage*.5))]);
 npc.def.invulnerable=true;f.commands.length=0;const before=ammo.count(f.p);r.lastTick=Date.now()-1000;pet.tick(f.world,f.combat);assert.equal(ammo.count(f.p),before);assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'));finish(f);
});

test('normal blast honors gate50/50 and protected shield/direct mines cannot bypass ISH',()=>{
 const f=fixture(),npc=spawn(f,{shieldAbsorb:.5});npc.x=6100;blast(f,utilities.SMB);assert.deepEqual([npc.hp,npc.shield],[90000,0]);finish(f);
 for(const id of ['ammunition_mine_sabm-01','ammunition_mine_ddm-01']){const g=fixture(),enemy=spawn(g,{invulnerable:true});enemy.x=6100;const now=Date.now();blast(g,id,now);utilities.tick(g.world,g.combat,now+1001);assert.deepEqual([enemy.hp,enemy.shield],[100000,10000]);assert.ok(!g.commands.some(c=>c._==='AttackHitCommand'));finish(g);}
});

test('Venom cannot start on protected boss and active protection suppresses ticks without catch-up damage',()=>{
 const f=fixture('ship_venom'),npc=spawn(f,{invulnerable:true}),now=Date.now(),command={menuItemId:'ability_venom',actionType:1};assert.equal(abilities.action(f.session,command,now),false);assert.equal(db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(f.id,'game.shipAbilityCooldowns'),undefined);
 npc.def.invulnerable=false;abilities.action(f.session,command,now);npc.def.invulnerable=true;abilities.tick(f.world,f.combat,now+5000);assert.equal(npc.hp,100000);npc.def.invulnerable=false;abilities.tick(f.world,f.combat,now+6000);assert.equal(npc.hp,98500);finish(f);
});

test('aggressive gate NPC acquires and chases beyond2500, ordinary NPC drops pursuit, speed0 turret stays fixed',()=>{
 const f=fixture(),gate=spawn(f,{aggressive:true}),normal=spawn(f),turret=spawn(f,{aggressive:true,speed:0});gate.x=10000;normal.x=10000;normal.aggro=f.session;normal.nextWander=Date.now()+100000;turret.x=7000;
 assert.equal(gate.aggro,f.session);f.commands.length=0;f.combat.tick();assert.equal(gate.aggro,f.session);assert.equal(normal.aggro,null);assert.ok(gate.movement);assert.equal(turret.movement,null);assert.ok(!f.commands.some(c=>c._==='MoveCommand'&&c.userId===turret.id));gate.aggro=null;f.combat.tick();assert.equal(gate.aggro,f.session);finish(f);
});

test('DB-backed gate protection hook participates in every shared damage guard',()=>{
 const f=fixture(),npc=spawn(f),gates=require('../game/galaxy-gates'),old=gates.isProtected;let calls=0;gates.isProtected=(world,target)=>{calls++;return world===f.world&&target===npc;};
 try{assert.equal(f.combat.npcProtected(npc),true);assert.equal(f.combat.applyDamage(npc,1000),0);assert.equal(f.combat.applyLaserDamage(f.p,npc,1000),0);assert.equal(npc.hp,100000);assert.ok(calls>=3);}finally{if(old)gates.isProtected=old;else delete gates.isProtected;finish(f);}
});

test('a repeated gate-slot kill removes its NPC without duplicate cargo, quest events or drone XP',()=>{
 const gates=require('../game/galaxy-gates'),drones=require('../game/drones'),progress=require('../game/progression'),oldKill=gates.onNpcKilled,oldDrone=drones.onNpcKill,oldEvent=progress.event;
 try{for(const claimed of [true,false]){const f=fixture(),npc=spawn(f,{gateRunId:123}),events=[];f.world.collectables={clear(){},cargo(){events.push('cargo');}};
  gates.onNpcKilled=(world,target)=>{target.gateKillRewardClaimed=claimed;return true;};drones.onNpcKill=()=>events.push('drone');progress.event=()=>events.push('quest');npc.hp=0;f.combat.kill(f.session,npc);assert.equal(f.combat.npcs.has(npc.id),false);assert.deepEqual(events,claimed?['drone','cargo','quest']:[]);finish(f);
 }}finally{gates.onNpcKilled=oldKill;drones.onNpcKill=oldDrone;progress.event=oldEvent;}
});
