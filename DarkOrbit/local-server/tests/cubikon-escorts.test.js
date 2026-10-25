'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),content=require('../game/normal-map-content'),special=require('../game/normal-npc-special'),codec=require('../game/codec/codec');
let w,p,s,c,out,mother;
beforeEach(()=>{
 database.close();database.open(':memory:');const id=players.createPlayer(players.createAccount('cubikon-escorts','test-pass'),'QA',1,require('../config').starter);
 w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);p=w.player;Object.assign(p,{x:6000,y:6000,hitPoints:10000000,hitMax:10000000});out=[];
 c=new Combat(w,(_,cmd)=>{assert.equal(codec.decode(codec.encode(cmd)).rest,0);out.push(cmd);});c.map=maps.getMap(1);
 mother=c.spawn(content.definition('cubikon',{supports:[{key:'protegit',count:20,activation:'damaged',respawnMs:5000}]}),{x:6400,y:6000});
});
afterEach(()=>{w.removeSession(s);database.close();});
function launch(){mother.shield--;mother.lastHit=100000;mother.aggro=s;special.tick(c,100000);return special.children(c,mother);}
test('Cubikon guards emerge from its hull and fan out using movement, never preplaced in an expanded ring',()=>{
 special.tick(c,99999);assert.equal(special.children(c,mother).length,0);const children=launch();assert.equal(children.length,20);
 assert.equal(new Set(children.map(n=>n.cubikonEscort.slot)).size,20);
 for(const n of children){assert.ok(maps.dist(n,mother)<80);assert.equal(n.aggro,s);assert.ok(n.movement);assert.ok(Math.abs(maps.dist({x:n.movement.targetX,y:n.movement.targetY},mother)-260)<2);}
 assert.equal(out.filter(cmd=>cmd._==='MoveCommand'&&children.some(n=>n.id===cmd.userId)).length,20);
 special.tick(c,100001);assert.equal(special.children(c,mother).length,20);
});
test('guards retain distinct orbit destinations around a moving attacker and do not restart movement on duplicate ticks',()=>{
 const children=launch();Object.assign(p,{x:7500,y:6500});
 for(const n of children){assert.equal(special.steerEscort(c,n,101000),true);const target={x:n.movement.targetX,y:n.movement.targetY};assert.ok(Math.abs(maps.dist(p,target)-n.cubikonEscort.radius)<2);}
 assert.equal(new Set(children.map(n=>`${n.movement.targetX},${n.movement.targetY}`)).size,20);
 const n=children[0],first={...n.movement},count=out.length;special.steerEscort(c,n,101001);assert.deepEqual(n.movement,first);assert.equal(out.length,count);
 c.updateNpc(n,102000);p.x+=200;special.steerEscort(c,n,102000);assert.notEqual(n.movement.targetY,first.targetY);assert.ok(Math.abs(maps.dist(p,{x:n.movement.targetX,y:n.movement.targetY})-n.cubikonEscort.radius)<2);
});
test('refill reuses the missing orbit slot without duplicating surviving guards; Battleray behavior is separate',()=>{
 const children=launch(),removed=children[7];removed.hp=0;c.kill(s,removed);special.tick(c,105001);const alive=special.children(c,mother);
 assert.equal(alive.length,20);assert.equal(new Set(alive.map(n=>n.cubikonEscort.slot)).size,20);assert.equal(alive.filter(n=>children.includes(n)).length,19);
 const ray=c.spawn(content.definition('battleray',{supports:[{key:'interceptor',count:10,activation:'always',protectionThreshold:5}]}),{x:7000,y:7000});special.tick(c,105002);const guards=special.children(c,ray);
 assert.equal(guards.length,10);for(const n of guards){assert.equal(n.cubikonEscort,undefined);assert.ok(Math.abs(maps.dist(n,ray)-220)<2);assert.equal(special.steerEscort(c,n,106000),false);}
});
test('actual combat tick uses escort steering instead of the generic chase cluster; jump and death clean up',()=>{
 const children=launch();Object.assign(p,{x:7400,y:6400});c.tick(101001);
 for(const n of children)assert.ok(Math.abs(maps.dist(p,{x:n.movement.targetX,y:n.movement.targetY})-n.cubikonEscort.radius)<2);
 mother.hp=0;special.onKilled(c,mother);assert.ok(children.every(n=>!c.npcs.has(n.id)));c.stop();assert.equal(w.scheduled.size,0);
});

test('native Cubikon open and close animation follows child release once, and reconnect replays the current effect',()=>{launch();assert.equal(out.filter(c=>c.message===`0|n|s|start|${mother.id}`).length,1);special.tick(c,100001);assert.equal(out.filter(c=>c.message===`0|n|s|start|${mother.id}`).length,1);const mark=out.length;c.sendAll(s);assert.ok(out.slice(mark).some(c=>c.message===`0|n|s|start|${mother.id}`));Object.assign(p,{x:100,y:100});special.tick(c,100002);assert.ok(out.some(c=>c.message===`0|n|s|end|${mother.id}`));assert.equal(mother.cubikonOpen,false);assert.equal(special.children(c,mother).length,0);const fs=require('fs');assert.match(fs.readFileSync('decompiled/main/scripts/net/bigpoint/darkorbit/map/view3D/effects/impl/SpawnChildrenEffect3D.as','utf8'),/playAnimation\("open"\)/);assert.ok(fs.statSync('client/spacemap/graphics/effects/startSpawnChildrenShip80.swf').size>1000);});

function timedGuards(t){
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});t.mock.method(Math,'random',()=>.5);const guards=launch(),ids=new Set(guards.map(n=>n.id)),fired=[],send=c.send;
 for(const n of guards){n.x=6200;n.y=6000;n.movement=null;}
 c.send=(session,cmd)=>{if(cmd._==='AttackLaserRunCommand'&&ids.has(cmd.attackerId))fired.push({id:cmd.attackerId,at:Date.now()});send(session,cmd);};return{guards,fired};
}
test('Protegits fire in independent phases; the1s AI tick neither batches nor doubles their shots',t=>{
 const {guards,fired}=timedGuards(t);assert.equal(c.escortLaserTimers.size,20);const deadlines=guards.map(n=>n.nextLaserAt);assert.equal(new Set(deadlines).size,20);
 c.tick(100000);assert.equal(fired.length,0);for(let i=0;i<2000;i++)t.mock.timers.tick(1);assert.equal(fired.length,20);assert.equal(new Set(fired.map(f=>f.at)).size,20);
 const before=fired.length;c.tick(102000);c.tick(102000);assert.equal(fired.length,before);for(let i=0;i<1000;i++)t.mock.timers.tick(1);assert.equal(fired.length,40);
 for(const guard of guards){const times=fired.filter(f=>f.id===guard.id).map(f=>f.at);assert.equal(times.length,2);assert.equal(times[1]-times[0],1000);}
});
test('independent guard timers safely wait through no target, jumping, death and out-of-range states',t=>{
 const {guards,fired}=timedGuards(t);for(const n of guards)n.aggro=null;t.mock.timers.tick(2000);assert.equal(fired.length,0);assert.equal(w.active(s),true,'null aggro must not throw and close the world');
 for(const n of guards)n.aggro=s;s.jumping=true;t.mock.timers.tick(1000);assert.equal(fired.length,0);s.jumping=false;p.dead=true;t.mock.timers.tick(1000);assert.equal(fired.length,0);p.dead=false;
 p.x=12000;t.mock.timers.tick(1000);assert.equal(fired.length,0);p.x=6000;for(let i=0;i<1000;i++)t.mock.timers.tick(1);assert.equal(fired.length,20);assert.equal(new Set(fired.map(f=>f.at)).size,20);
});
test('removed escorts and a killed mother cannot leave orphan firing callbacks',t=>{
 const {guards,fired}=timedGuards(t),removed=guards[7];removed.hp=0;c.kill(s,removed);assert.equal(c.escortLaserTimers.has(removed.id),false);t.mock.timers.tick(2000);assert.equal(fired.some(f=>f.id===removed.id),false);assert.equal(fired.length,19);
 mother.hp=0;special.onKilled(c,mother);assert.equal(c.escortLaserTimers.size,0);const count=fired.length;t.mock.timers.tick(5000);assert.equal(fired.length,count);assert.equal(w.scheduled.size,0);
});
test('combat shutdown cancels every independent escort timer before a map change',t=>{
 const {fired}=timedGuards(t);c.stop();assert.equal(c.escortLaserTimers.size,0);assert.equal(w.scheduled.size,0);t.mock.timers.tick(5000);assert.equal(fired.length,0);
});
