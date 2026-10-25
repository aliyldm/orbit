'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const spawn=require('../game/normal-map-spawns'),catalog=require('../game/npc-catalog');
const keys=name=>spawn.get(name).filter(r=>!r.dependentOn).map(r=>r.key);
test('all three factions share the verified classic map families without leaking gate and event NPCs',()=>{
 for(let n=1;n<=8;n++){
  assert.deepEqual(spawn.get(`1-${n}`),spawn.get(`2-${n}`));assert.deepEqual(spawn.get(`1-${n}`),spawn.get(`3-${n}`));
  assert.ok(keys(`1-${n}`).every(k=>!k.startsWith('uber-')&&!/kucurbium|curcubitor|emperor|infernal|scorcher|melter|devourer/.test(k)));
 }
 assert.deepEqual(keys('1-1'),['streuner']);
 assert.ok(keys('1-3').includes('devolarium'));assert.ok(!keys('1-4').includes('devolarium'));
 assert.ok(keys('1-3').includes('boss-saimon'));
 assert.ok(keys('1-4').includes('sibelon'));assert.ok(!keys('1-3').includes('sibelon'));
 assert.ok(keys('1-5').includes('sibelonit'));assert.ok(keys('1-5').includes('lordakium'));
 assert.ok(keys('1-6').includes('cubikon'));assert.ok(!keys('1-7').includes('cubikon'));
 assert.ok(keys('1-8').includes('streuner-upper'));assert.ok(!keys('1-8').includes('streuner'));
});
test('4-5 has the eleven source families of bosses and ubers with precise pirate-uber membership',()=>{
 const list=keys('4-5');assert.equal(list.filter(k=>k.startsWith('boss-')).length,11);
 assert.equal(list.filter(k=>k.startsWith('uber-')&&!/interceptor|barracuda|saboteur|annihilator|battleray/.test(k)).length,11);
 for(const name of ['uber-interceptor','uber-barracuda','uber-annihilator','uber-saboteur','uber-battleray'])assert.ok(list.includes(name));
 assert.ok(!list.includes('cubikon'));assert.ok(!list.includes('battleray'));
});
test('pirate map habitat distinctions and dependent escorts survive profile serialization',()=>{
 for(const map of ['5-1','5-2','5-3'])for(const k of ['interceptor','barracuda','saboteur','annihilator','uber-interceptor','uber-barracuda'])assert.ok(keys(map).includes(k));
 assert.ok(keys('5-2').includes('uber-annihilator'));assert.ok(keys('5-2').includes('uber-saboteur'));
 assert.ok(!keys('5-1').includes('uber-annihilator'));assert.ok(!keys('5-3').includes('uber-annihilator'));
 assert.ok(keys('5-3').includes('battleray'));assert.ok(!keys('5-1').includes('battleray'));
 const escort=spawn.get('1-6').find(r=>r.key==='protegit');assert.equal(escort.dependentOn,'cubikon');assert.equal(escort.spawnTrigger,'parent-attacked');
 assert.equal(spawn.get('5-3').find(r=>r.dependentOn==='battleray').key,'interceptor');
 assert.equal(spawn.get('4-5').find(r=>r.dependentOn==='uber-battleray').key,'uber-interceptor');
});
test('every profile key is a real catalogue NPC and all unsupported population parameters remain explicit',()=>{
 for(const [name,rows]of Object.entries(spawn.profiles)){
  const seen=new Set();for(const r of rows){
   assert.ok(catalog.definitions[r.key],`${name}: missing ${r.key}`);
   assert.ok(Number.isSafeInteger(r.count)&&r.count>0);assert.ok(Number.isSafeInteger(r.respawnMs)&&r.respawnMs>0);
   assert.equal(typeof r.aggressive,'boolean');assert.equal(r.localPopulation,true);assert.equal(r.localRespawn,true);assert.equal(r.localAggression,false);
   for(const id of [...r.sourceIds,...r.aggressionSourceIds])assert.ok(spawn.SOURCES[id]);
   const identity=r.key+':'+(r.dependentOn||'');assert.ok(!seen.has(identity));seen.add(identity);
   if(r.dependentOn)assert.ok(rows.some(p=>p.key===r.dependentOn&&!p.dependentOn));
  }
 }
});
test('passive standard and boss NPCs retain evidence-backed behaviour instead of global gate aggression',()=>{
 for(const k of ['lordakium','kristallon','streuner-upper','boss-streuner-upper'])assert.equal(Object.values(spawn.profiles).flat().find(r=>r.key===k).aggressive,false,k);
 assert.equal(spawn.get('1-1')[0].aggressive,false);
 assert.equal(spawn.get('1-3').find(r=>r.key==='devolarium').aggressive,true);
 assert.equal(spawn.get('4-5').find(r=>r.key==='uber-annihilator').aggressive,false);
});
test('profiles do not mutate one another and unsupported/battle/gate maps gain no speculative NPCs',()=>{
 const a=spawn.get('1-2');a[0].count=999;a[0].sourceIds.push('injected');
 assert.notEqual(spawn.get('2-2')[0].count,999);assert.ok(!spawn.get('1-2')[0].sourceIds.includes('injected'));
 for(const map of ['4-1','4-2','4-3','4-4','5-4','1-BL','gg-alpha','unknown',null])assert.deepEqual(spawn.get(map),[]);
 assert.ok(Object.isFrozen(spawn.profiles['1-2'][0]));
});
test('retained source boundaries contain the habitat and behaviour evidence used by the profiles',()=>{
 const read=name=>fs.readFileSync(path.join(__dirname,'../decompiled/gate-source-evidence',name+'.txt'),'utf8');
 assert.match(read('npc-boss-en'),/Boss KristallinX-6\/X-7 4-5/);
 assert.match(read('npc-de-page2'),/Lebensraum: 4-5, 5-2/);
 assert.match(read('npc-es'),/Hábitat: 5-3 y Portal de invasión/);
 assert.match(read('npc-standard-en'),/These npc will not attack until fired upon/);
 assert.match(read('npc-standard-en'),/until attaked/);
 assert.deepEqual(spawn.effects.saboteur.mechanisms,['slow-target','emp-clears-slow']);
});
test('classic residents agree with native client logical IDs including Boss Saimon on x-3',()=>{
 const xml=fs.readFileSync(path.join(__dirname,'../client/spacemap/graphics/spacemap-config.xml'),'utf8').match(/<npcs>([\s\S]*?)<\/npcs>/)[1];
 const patterns=fs.readFileSync(path.join(__dirname,'../decompiled/pet-patterns/game.xml'),'utf8').replace(/<!--[\s\S]*?-->/g,'');
 const logicalByVisual=new Map();
 for(const m of patterns.matchAll(/<ship\s[^>]*>/g)){
  const type=m[0].match(/\btype="(\d+)"/),npc=m[0].match(/\bnpcId="(\d+)"/);
  if(type&&npc)logicalByVisual.set(Number(type[1]),Number(npc[1]));
 }
 for(const m of xml.matchAll(/<map ref="(\d+)">([\s\S]*?)<\/map>/g)){
  const id=Number(m[1]);let name;
  if(id>=1&&id<=12)name=`${Math.floor((id-1)/4)+1}-${(id-1)%4+1}`;
  if(id>=17&&id<=28)name=`${Math.floor((id-17)/4)+1}-${(id-17)%4+5}`;
  if(id===29)name='4-5';if(id>=91&&id<=93)name=`5-${id-90}`;
  if(!name)continue;
  const resident=new Set([...m[2].matchAll(/<npc id="(\d+)"/g)].map(n=>Number(n[1])));
  const covered=new Set(keys(name).map(k=>logicalByVisual.get(catalog.definitions[k].typeId)));
  for(const logical of covered)assert.ok(resident.has(logical),`${name}: unsolicited logical NPC ${logical}`);
  // Modern/tutorial/roaming IDs have deliberately separate scope (see docs).
  for(const logical of resident)if(![121,152,153,161,174].includes(logical))assert.ok(covered.has(logical),`${name}: missing classic logical NPC ${logical}`);
 }
});
