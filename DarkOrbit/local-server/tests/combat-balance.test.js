'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const balance=require('../game/combat-balance'),config=require('../config');
test('source-backed production laser range never exceeds the maximum fitted damage',()=>{
 assert.deepEqual(balance.damageRange(config.combat),[.75,1]);
 assert.equal(balance.laserDamage(200,config.combat,()=>0),150);
 assert.equal(balance.laserDamage(200,config.combat,()=>1),200);
 let total=0;
 for(let i=0;i<10001;i++){
  const damage=balance.laserDamage(12000,config.combat,()=>i/10000);
  assert.ok(damage>=9000&&damage<=12000);total+=damage;
 }
 assert.ok(Math.abs(total/10001-10500)<.5);
});
test('explicit old damageSpread override preserves deterministic fixtures and custom bounds',()=>{
 assert.equal(balance.laserDamage(1234,{...config.combat,damageSpread:0},()=>.12),1234);
 assert.deepEqual(balance.damageRange({damageSpread:.2}),[.8,1.2]);
 assert.deepEqual(balance.damageRange({laserDamageMin:.9,laserDamageMax:.8}),[.8,.9]);
 assert.deepEqual(balance.damageRange({laserDamageMin:NaN,laserDamageMax:Infinity}),[.75,1]);
 assert.equal(balance.laserDamage(-100),0);
 assert.equal(balance.laserDamage(NaN),0);
 assert.equal(balance.laserDamage(100,{},()=>-1),75);
 assert.equal(balance.laserDamage(100,{},()=>Infinity),75);
});
test('classic laser base has misses while full electro-optics reaches the local probability cap',()=>{
 assert.equal(balance.hitChance('laser',config.combat),.8);
 assert.equal(balance.hitChance('laser',config.combat,{accuracy:.25}),1);
 assert.equal(balance.hitChance('laser',config.combat,{accuracy:.25,evasion:.12}),.93);
 assert.equal(balance.hitChance('laser',{laserHitChance:.7},{accuracy:.05}),.75);
 assert.equal(balance.hitChance('laser',{laserHitChance:0}),0);
});
test('targeting CPU reduces remaining misses rather than adding 50 percentage points',()=>{
 assert.equal(balance.hitChance('laser',{}, {missReduction:.5}),.9);
 assert.ok(Math.abs(balance.hitChance('laser',{}, {missReduction:.25})-.85)<1e-12);
 assert.equal(balance.hitChance('laser',{laserHitChance:0},{missReduction:.5}),.5);
 assert.equal(balance.hitChance('laser',{}, {accuracy:.1,missReduction:.5}),.95);
 assert.equal(balance.hitChance('laser',{}, {accuracy:2,missReduction:.5}),1);
 assert.equal(balance.hitChance('laser',{}, {evasion:2,missReduction:-1}),0);
});
test('unpublished generic NPC and rocket hit rates stay explicit local defaults and accept overrides',()=>{
 for(const kind of ['npc','rocket','launcher'])assert.equal(balance.hitChance(kind,{}),1);
 assert.equal(balance.hitChance('npc',{npcHitChance:.7},{evasion:.12}),.58);
 assert.equal(balance.hitChance('rocket',{rocketHitChance:.75},{accuracy:.1}),.85);
 assert.equal(balance.hitChance('launcher',{launcherHitChance:.75}),.75);
 assert.equal(balance.hitChance('laser',{laserHitChance:NaN},{accuracy:NaN,evasion:Infinity}),.8);
 assert.throws(()=>balance.hitChance('unknown',{}),/Unknown combat/);
});
