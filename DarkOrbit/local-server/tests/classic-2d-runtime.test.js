'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),core=require('../game/handlers/core'),systems=require('../game/handlers/systems'),codec=require('../game/codec/codec'),view=require('../game/client-view'),{flightMs}=require('../game/projectiles');
const defaults=require('../game/handlers/systems-evidence.json').defaults.UserSettingsCommand;
let db,w,s,p,c,handlers,out;
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('classic-2d-qa','testpass'),'Classic',1,require('../config').starter);w=new World(structuredClone(require('../config')));s={world:w,send(){},rendererMode:1};w.login(s,id);p=w.player;Object.assign(p,{x:6000,y:6000});w.rendererMode=1;out=[];handlers={};const register=(name,fn)=>handlers[name]=fn,sendCmd=(_s,cmd)=>{assert.equal(codec.decode(codec.encode(cmd)).rest,0);out.push(cmd);};c=new Combat(w,sendCmd);core.register(register,{sendCmd});systems.register(register,{db,sendCmd});});
afterEach(()=>{w.removeSession(s);database.close();});
function dispatch(request,session=s){const decoded=codec.decode(codec.encode(request));assert.equal(decoded.rest,0);handlers[request._](session,decoded.obj);}
function settings(type,fields){const key=type[0].toLowerCase()+type.slice(1)+'SettingsModule',request={...defaults[key],...fields,_:type+'SettingsRequest'};delete request.notSet;dispatch(request);return out.at(-1);}
const near=[{x:0,y:0},{x:100,y:0}];
test('actual map-ready selects native2D/3D flight timings independently of saved preferences',()=>{
 assert.equal(flightMs(w,...near),1000);dispatch({_:'ReadyRequest',readyType:0,readyTypeStr:'map'});assert.equal(s.rendererMode,2);assert.equal(w.rendererMode,2);assert.equal(flightMs(w,...near),500);assert.equal(view.mode(p.userId,w.config),1,'2D fallback does not rewrite the preferred mode');
 dispatch({_:'ReadyRequest',readyType:2,readyTypeStr:'ui'});assert.equal(w.rendererMode,2);settings('Display',{displayUse2d:false});assert.equal(flightMs(w,...near),500,'settings save leaves the running2D scene intact');
 dispatch({_:'ReadyRequest',readyType:1,readyTypeStr:'map'});assert.equal(w.rendererMode,1);assert.equal(s.rendererMode,1);assert.equal(flightMs(w,...near),1000);
});
test('invalid and stale map-ready packets cannot alter an active renderer',()=>{
 for(const readyType of [-1,3,99])dispatch({_:'ReadyRequest',readyType,readyTypeStr:''});assert.equal(w.rendererMode,1);
 dispatch({_:'ReadyRequest',readyType:0,readyTypeStr:''},{...s,player:{...p}});assert.equal(w.rendererMode,1);assert.equal(out.length,0);
});
test('actual2D fallback delays a real rocket until its500ms visual arrival rather than the3D minimum',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});c.map=require('../game/maps').getMap(1);const n=c.spawn({typeId:84,name:'QA',hitpoints:10000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{},respawnMs:0},{x:6100,y:6000});dispatch({_:'ReadyRequest',readyType:0,readyTypeStr:''});assert.equal(c.rocket(s,{targetId:n.id}),true);assert.equal([...c.projectiles][0].delay,500);assert.equal(n.hp,10000);t.mock.timers.tick(499);assert.equal(n.hp,10000);t.mock.timers.tick(1);assert.equal(n.hp,9000);assert.equal(out.filter(x=>x._==='AttackHitCommand'&&x.victimId===n.id).length,1);
});
test('all four native2D quality presets retain their ship/background/zone/engine/explosion/box values across reconnect',()=>{
 settings('Display',{displayUse2d:true});
 // Source: SettingsWindowFUIProxy.updateModelWithDisplayQualityPresetting.
 const keys=['qualityBackground','qualityPOIzone','qualityShip','qualityEngine','qualityExplosion','qualityCollectables'],presets=[[0,0,0,0,0,0],[1,1,0,1,1,0],[2,3,3,2,1,3],[3,3,3,3,3,3]];
 for(let level=0;level<4;level++){const fields=Object.fromEntries(keys.map((key,i)=>[key,presets[level][i]]));const echoed=settings('Quality',{...fields,qualityPresetting:level,qualityCustomized:false});assert.equal(echoed._,'QualitySettingsModule');for(const key of keys)assert.equal(echoed[key],fields[key]);const init=systems.buildInit(players.loadPlayer(p.userId),{db})[0];for(const key of keys)assert.equal(init.qualitySettingsModule[key],fields[key]);assert.equal(view.mode(p.userId,w.config,db),2);assert.equal(init.displaySettingsModule.displayUse2d,true);}
});
test('custom2D keeps angled ships with reduced backgrounds, and another tab cannot reset quality or renderer',()=>{
 settings('Display',{displayUse2d:true});const fields={qualityCustomized:true,qualityPresetting:0,qualityBackground:0,qualityPOIzone:0,qualityShip:3,qualityEngine:1,qualityExplosion:1,qualityCollectables:3,qualityAttack:3,qualityEffect:1};settings('Quality',fields);settings('Audio',{sound:20});settings('Display',{displayUse2d:true,displayMyDrones:false});const init=systems.buildInit(players.loadPlayer(p.userId),{db})[0];for(const[key,value]of Object.entries(fields))assert.equal(init.qualitySettingsModule[key],value);assert.equal(view.mode(p.userId,w.config,db),2);assert.equal(init.displaySettingsModule.displayMyDrones,false);assert.equal(init.audioSettingsModule.sound,20);assert.equal(w.rendererMode,1,'renderer changes only after reload/map-ready');
});
