'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),cpu=require('../game/cpu'),init=require('../game/init'),gameplay=require('../game/gameplay'),core=require('../game/handlers/core'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let db,w,s,p,c,out,handlers,item;
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('cloak-map-qa','testpass'),'Cloak',1,require('../config').starter);w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);p=w.player;out=[];const send=(_s,cmd)=>{assert.equal(codec.decode(codec.encode(cmd)).rest,0);out.push(cmd);};c=new Combat(w,send);c.map=maps.getMap(1);handlers=new Map();core.register((name,fn)=>handlers.set(name,fn),{sendCmd:send});gameplay.register(()=>{},{sendCmd:send,buildInit:init.buildInit,combatFor:()=>c});item={id:Number(db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index)VALUES(?,'equipment_extra_cpu_cl04k-m',1,?,'extra',0)").run(id,p.shipId).lastInsertRowid),loot_id:cpu.PREFIX+'cl04k-m'};});
afterEach(()=>{w.removeSession(s);database.close();});
function assertNativeState(commands,expected){let drawn;for(const cmd of commands){if(cmd._==='ShipInitializationCommand')drawn=cmd.cloaked;const match=cmd._==='LegacyModule'&&new RegExp('^0\\|n\\|INV\\|'+p.userId+'\\|([01])$').exec(cmd.message);if(match)drawn=match[1]==='1';}assert.equal(drawn,expected);assert.ok(commands.some(cmd=>cmd._==='LegacyModule'&&cmd.message===`0|n|INV|${p.userId}|${Number(expected)}`));if(expected)assert.ok(!commands.some(cmd=>cmd._==='LegacyModule'&&cmd.message===`0|n|INV|${p.userId}|0`),'captured decloak cannot overwrite live cloak');}
test('recovered captured INV0 cannot clear cloak on normal map initialization, return or reconnect',()=>{
 assert.equal(cpu.cloak(w),true);assert.equal(cpu.charges(item),9);assertNativeState(init.buildInit(w),true);
 out=[];assert.equal(gameplay.changeMap(s,2,6000,6000),true);assertNativeState(out,true);assert.equal(cpu.isCloaked(p),true);assert.equal(cpu.charges(item),9);
 out=[];assert.equal(gameplay.changeMap(s,1,6000,6000),true);assertNativeState(out,true);assert.equal(cpu.charges(item),9);
 const fresh=players.loadPlayer(p.userId);assert.equal(cpu.isCloaked(fresh),true);w.player=fresh;assertNativeState(init.buildInit(w),true);w.player=p;
});
test('both2D/3D map-ready acknowledgements resync actual cloak without spending charges; attack removes it permanently',()=>{
 cpu.cloak(w);for(const readyType of [0,1]){out=[];handlers.get('ReadyRequest')(s,{readyType});assertNativeState(out,true);assert.equal(cpu.charges(item),9);}
 out=[];handlers.get('ReadyRequest')(s,{readyType:2});assert.equal(out.length,0);handlers.get('ReadyRequest')(s,{readyType:99});assert.equal(out.length,0);
 cpu.breakCloak(w);assertNativeState(init.buildInit(w),false);out=[];handlers.get('ReadyRequest')(s,{readyType:1});assertNativeState(out,false);assert.equal(cpu.read(p).cloaked,undefined);assert.equal(cpu.charges(item),9);
});
test('clear/dead/foreign sessions cannot be falsely recloaked by ready messages',()=>{
 assertNativeState(init.buildInit(w),false);out=[];p.dead=true;handlers.get('ReadyRequest')(s,{readyType:1});assert.equal(out.length,0);p.dead=false;
 handlers.get('ReadyRequest')({...s,player:{...p}},{readyType:1});assert.equal(out.length,0);
 cpu.write(p,{cloaked:true});p.mapId=51;assert.equal(cpu.cloakCommand(p).message,`0|n|INV|${p.userId}|0`);
});
