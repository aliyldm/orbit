'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),Collectables=require('../game/collectables').Collectables,maps=require('../game/maps'),abilities=require('../game/ship-abilities'),expanded=require('../game/ship-abilities-expanded'),codec=require('../game/codec/codec'),config=require('../config');
let db,f;
beforeEach(()=>{
 database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('phase-qa','qa-pass'),'Phase QA',1,{...config.starter,ship:'ship_mimesis'}),w=new World(config),out=[],s={world:w,send(){}};w.login(s,id);Object.assign(w.player,{x:10000,y:6500});
 const combat=new Combat(w,(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);out.push(decoded.obj);});combat.map=maps.getMap(1);w.collectables=new Collectables(w,combat.send);f={id,w,s,p:w.player,combat,out};
});
afterEach(()=>{f.w.removeSession(f.s);database.close();});
const menu='ability_mimesis_phase-out',use=(now=100000)=>abilities.action(f.s,{menuItemId:menu,actionType:1},now);
test('Phase Out instantly moves exactly50mini-map units, stops the route and keeps normal defenses',()=>{
 f.w.movement={x:10000,y:6500,targetX:12000,targetY:6500,start:100000,duration:10000};const before={x:f.p.x,y:f.p.y},hp=f.p.hitPoints;
 assert.equal(use(),true);assert.equal(f.w.movement,null);assert.ok(Math.abs(maps.dist(before,f.p)-5000)<1);assert.deepEqual(f.s.target,{x:f.p.x,y:f.p.y});
 assert.ok(f.out.some(c=>c._==='MoveCommand'&&c.userId===f.id&&c.x===f.p.x&&c.y===f.p.y&&c.timeToTarget===0));assert.ok(f.out.some(c=>c._==='VisualModifierCommand'&&c.modifier===4&&c.activated));
 const n=f.combat.spawn({key:'phase-hit',typeId:84,name:'Phase hit',hitpoints:10000,shield:0,speed:0,damageMin:1,damageMax:1,reward:{},transient:true},{x:f.p.x+100,y:f.p.y});f.combat.damagePlayer(n,100,{now:100001,evade:false});assert.equal(f.p.hitPoints,hp-100,'the presentation effect is not invulnerability');
 abilities.tick(f.w,f.combat,102000);assert.ok(f.out.some(c=>c._==='VisualModifierCommand'&&c.modifier===4&&!c.activated));assert.equal(use(399999),false);assert.equal(use(400000),true);
});
test('destination selection never clamps distance or places the ship in radiation at corners and edges',()=>{
 for(const [x,y]of [[0,0],[21000,0],[21000,13100],[0,13100],[21000,6500],[10000,0]]){
  Object.assign(f.p,{x,y});for(let i=0;i<20;i++){const dest=expanded.phaseDestination(f.p);assert.ok(dest);assert.ok(Math.abs(maps.dist(f.p,dest)-5000)<1);assert.ok(dest.x>=0&&dest.x<=21000&&dest.y>=0&&dest.y<=13100);}
 }
 Object.assign(f.p,{x:0,y:0});const dest=expanded.phaseDestination(f.p,()=>.625);assert.ok(dest&&dest.x>=0&&dest.y>=0,'bounded fallback handles pathological RNG');
 Object.assign(f.p,{x:-10000,y:-10000});assert.equal(expanded.phaseDestination(f.p),null);
});
test('gate, pirate and unimplemented special maps reject before cooldown or visual output',()=>{
 for(const mapId of [51,52,53,55,70,73,74,75,76,91,92,93,203,300,99999]){
  f.p.mapId=mapId;assert.equal(use(),false);const status=expanded.status(f.w,menu,{},100000);assert.equal(status.activatable,false);assert.equal(status.blocked,true);
 }
 assert.equal(f.out.length,0);assert.equal(db.prepare("SELECT count(*) n FROM settings WHERE key='game.expandedShipCooldowns'").get().n,0);
 f.p.mapId=1;assert.equal(use(),true);
});
test('real teleport cancels harvest and pending warp while preserving cloak and current target',()=>{
 const box=f.w.collectables.add({x:f.p.x,y:f.p.y,oreType:0,amount:1},false);assert.equal(f.w.collectables.beginHarvest(f.s,{itemHash:box.hash},true),true);
 require('../game/cpu').write(f.p,{cloaked:true});f.s.shipWarp={};f.s.selected=123;f.s.attacking=123;
 assert.equal(use(),true);assert.equal(!!f.s.harvest,false);assert.equal(f.s.shipWarp,null);assert.equal(require('../game/cpu').isCloaked(f.p),true);assert.equal(f.s.selected,123);assert.equal(f.s.attacking,123);
});
test('failed cooldown storage cannot teleport, cancel an existing route or announce an effect',()=>{
 f.w.movement={x:10000,y:6500,targetX:12000,targetY:6500,start:100000,duration:10000};const route=f.w.movement;
 db.exec("CREATE TRIGGER deny_phase BEFORE INSERT ON settings WHEN NEW.key='game.expandedShipCooldowns' BEGIN SELECT RAISE(ABORT,'phase-storage'); END");assert.throws(()=>use(),/phase-storage/);
 assert.deepEqual([f.p.x,f.p.y],[10000,6500]);assert.equal(f.w.movement,route);assert.equal(f.out.length,0);db.exec('DROP TRIGGER deny_phase');
});
test('map teardown stops the presentation and does not erase its persisted cooldown',()=>{
 assert.equal(use(),true);f.p.mapId=2;abilities.tick(f.w,f.combat,100500);assert.equal(f.w.expandedAbilityRuns.size,0);assert.equal(use(100501),false);
 const reloaded=players.loadPlayer(f.id);assert.ok(reloaded);const until=JSON.parse(db.prepare("SELECT value FROM settings WHERE player_id=? AND key='game.expandedShipCooldowns'").get(f.id).value)[menu];assert.equal(until,400000);
});
