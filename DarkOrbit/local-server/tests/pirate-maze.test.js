'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),maps=require('../game/maps'),Combat=require('../game/combat'),{Collectables}=require('../game/collectables');
const archive=require('../game/data/pirate-maze.json');let w,p,s;
beforeEach(()=>{database.close();database.open(':memory:');const id=players.createPlayer(players.createAccount('maze-qa','testpass'),'Maze QA',1,require('../config').starter);w=new World(require('../config'));s={world:w,send(){}};p=w.login(s,id);});
afterEach(()=>{w.removeSession(s);database.close();});
test('5-x no longer sends maze obstacles; Palladium mist remains',()=>{
 for(const id of [91,92,93]){p.mapId=id;const commands=maps.commands(w);assert.equal(commands.some(c=>c.poiId?.startsWith('pirate-maze-')),false);assert.equal(commands.some(c=>c.poiId===`pirate-mist-${id}`),id!==92);}
});
test('player destinations can cross former maze walls without clipping',()=>{
 for(const id of [91,93]){p.mapId=id;const r=archive.maps[id].rectangles.find(r=>r[2]-r[0]>2000&&r[3]-r[1]<1000);Object.assign(p,{x:(r[0]+r[2])/2,y:r[1]-400});const target={x:p.x,y:r[3]+1000};w.move(s,{positionX:p.x,positionY:p.y,targetX:target.x,targetY:target.y});assert.equal(w.movement.targetY,target.y);w.updatePosition(w.movement.start+w.movement.duration+1);assert.equal(p.y,target.y);}
});
test('NPCs and dropped cargo retain their exact positions inside former walls',()=>{
 for(const id of [91,93]){p.mapId=id;const r=archive.maps[id].rectangles[0],position={x:Math.round((r[0]+r[2])/2),y:Math.round((r[1]+r[3])/2)};const combat=new Combat(w,()=>{});combat.map=maps.getMap(id);const npc=combat.spawn(require('../game/npc-catalog').get('interceptor'),position);assert.equal(npc.x,position.x);assert.equal(npc.y,position.y);const c=new Collectables(w,()=>{}),b=c.cargo(npc);assert.equal(b.x,position.x);assert.equal(b.y,position.y);}
});
