'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),launcher=require('../game/hellstorm'),inventory=require('../game/inventory'),codec=require('../game/codec/codec'),maps=require('../game/maps'),{flightMs}=require('../game/projectiles');
let sequence=0;
function fixture(t,{hp=5000,shield=0}={}){
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});
 const account=players.createAccount(`flight-${++sequence}`,'testpass'),id=players.createPlayer(account,'Flight QA',1,config.starter),world=new World(config),commands=[],session={world,send(){},close(){}};world.login(session,id);Object.assign(world.player,{x:6000,y:6000});
 world.rendererMode=2;const send=(s,c)=>{codec.encode(c);commands.push(c);},combat=new Combat(world,send);combat.map=maps.getMap(1);
 const npc=combat.spawn({typeId:84,name:'Streuner',hitpoints:hp,shield,speed:200,damageMin:1,damageMax:1,reward:{ep:400,honour:2,credits:400,uridium:1},respawnMs:5000});Object.assign(npc,{x:6400,y:6000});session.selected=npc.id;
 return{world,session,combat,commands,npc,id,p:world.player,send};
}
function finish(f){f.world.removeSession(f.session);}
function prepareHst(f){const item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_weapon_rocketlauncher_hst-1',1)").run(f.id).lastInsertRowid);inventory.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item]},to:{target:'ship',slotset:'heavy_guns'}});db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'ammunition_rocketlauncher_eco-10',3)").run(f.id);launcher.reload(f.world);launcher.tick(f.world,f.combat,Date.now()+5000);}
test('standard rocket launches now but damage, kill and reward occur only at visual impact',t=>{
 const f=fixture(t,{hp:500});const before=require('../game/ammo').count(f.p,'ammunition_rocket_r-310');assert.equal(f.combat.rocket(f.session,{targetId:f.npc.id}),true);
 assert.equal(require('../game/ammo').count(f.p,'ammunition_rocket_r-310'),before-1);assert.equal(f.npc.hp,500);assert.equal(f.p.credits,0);assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message.startsWith('0|v|')));assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'||c._==='ShipDestroyedCommand'));
 t.mock.timers.tick(799);assert.equal(f.npc.hp,500);assert.equal(f.p.credits,0);t.mock.timers.tick(1);assert.equal(f.npc.hp,0);assert.equal(f.p.credits,400);assert.ok(f.commands.some(c=>c._==='AttackHitCommand'&&c.victimId===f.npc.id));assert.ok(f.commands.some(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===f.npc.id));assert.equal(f.combat.projectiles.size,0);finish(f);
});
test('Hellstorm aggregate damage waits for the final staggered missile to arrive',t=>{
 const f=fixture(t,{hp:10000});prepareHst(f);assert.equal(launcher.fire(f.session,f.npc.id),true);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),0);assert.equal(f.npc.hp,10000);
 const shot=f.commands.find(c=>c._==='HellstormAttackCommand');assert.equal(shot.currentLoad,3);assert.equal([...f.combat.projectiles][0].delay,1434);
 t.mock.timers.tick(1433);assert.equal(f.npc.hp,10000);assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'));t.mock.timers.tick(1);assert.equal(f.npc.hp,4000);assert.equal(f.commands.filter(c=>c._==='AttackHitCommand').length,1);finish(f);
});
test('flight timing follows recovered 2D and 3D minimums and salvo launch stagger',()=>{
 const w={config:{client:{flashvars:{display2d:'2'}}}},a={x:0,y:0},b={x:100,y:0};assert.equal(flightMs(w,a,b),500);assert.equal(flightMs(w,a,b,3,true),1134);
 w.config.client.flashvars.display2d='1';assert.equal(flightMs(w,a,b),1000);assert.equal(flightMs(w,a,b,3,true),1634);
 w.config.combat={projectileView:'3d'};assert.equal(flightMs(w,a,b),1000);assert.equal(flightMs(w,a,b,3,true),1634);
 delete w.config.combat;w.rendererMode=1;assert.equal(flightMs(w,a,b),1000);w.rendererMode=2;assert.equal(flightMs(w,a,b),500);
 delete w.rendererMode;w.sessions=new Set([{rendererMode:2}]);assert.equal(flightMs(w,a,b),500);w.config.client.flashvars.display2d='1';assert.equal(flightMs(w,a,b),500);
});
test('disconnect cancels impact timers without refunding a missile already launched',t=>{
 const f=fixture(t);const before=require('../game/ammo').count(f.p,'ammunition_rocket_r-310');f.combat.rocket(f.session,{targetId:f.npc.id});finish(f);assert.equal(f.combat.projectiles.size,0);assert.equal(f.world.scheduled.size,0);t.mock.timers.tick(2000);assert.equal(f.npc.hp,5000);assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'));assert.equal(require('../game/ammo').count(f.p,'ammunition_rocket_r-310'),before-1);
});
test('starting a jump cancels in-flight damage before the map transition finishes',t=>{
 const f=fixture(t);Object.assign(f.p,{x:18500,y:11500});Object.assign(f.npc,{x:18900,y:11500});
 const game=require('../game/gameplay');game.register(()=>{}, {sendCmd:f.send,combatFor:()=>f.combat,buildInit:w=>game.initialize(w)});
 f.combat.rocket(f.session,{targetId:f.npc.id});assert.equal(game.jump(f.session),true);assert.equal(f.combat.projectiles.size,0);t.mock.timers.tick(1000);assert.equal(f.npc.hp,5000);assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'));finish(f);
});
test('a removed or replaced NPC object cannot receive an old missile impact',t=>{
 const f=fixture(t);f.combat.rocket(f.session,{targetId:f.npc.id});const replacement={...f.npc,hp:9999};f.combat.npcs.set(f.npc.id,replacement);t.mock.timers.tick(800);assert.equal(replacement.hp,9999);assert.equal(f.npc.hp,5000);assert.ok(!f.commands.some(c=>c._==='AttackHitCommand'));finish(f);
});
test('two lethal projectiles award one kill and the later salvo cannot reward a removed target',t=>{
 const f=fixture(t,{hp:500});prepareHst(f);launcher.fire(f.session,f.npc.id);f.combat.rocket(f.session,{targetId:f.npc.id});t.mock.timers.tick(800);assert.equal(f.p.credits,400);t.mock.timers.tick(1000);assert.equal(f.p.credits,400);assert.equal(f.commands.filter(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===f.npc.id).length,1);finish(f);
});
test('player death cancels projectiles and moving targets keep the client homing duration',t=>{
 const f=fixture(t);f.combat.rocket(f.session,{targetId:f.npc.id});f.combat.killPlayer({def:{name:'Lordakia'}});t.mock.timers.tick(1000);assert.equal(f.npc.hp,5000);assert.equal(f.combat.projectiles.size,0);finish(f);
});
test('moving the same target does not restart its already launched homing timer',t=>{
 const f=fixture(t);f.combat.rocket(f.session,{targetId:f.npc.id});f.npc.x=10000;t.mock.timers.tick(800);assert.equal(f.npc.hp,4000);assert.ok(f.commands.some(c=>c._==='AttackHitCommand'));finish(f);
});
