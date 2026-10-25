'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const cargo=require('../game/normal-npc-cargo.json'),profiles=require('../game/normal-map-spawns').profiles,catalog=require('../game/npc-catalog');
const oreNames=['Prometium','Endurium','Terbium','Xenomit','Prometid','Duranium','Promerium',null,'Palladium'];
const amount=(key,type)=>cargo[key].find(r=>r.type===type)?.amount||0;
test('every classic resident and dependent escort has a sourced cargo record with native ore IDs',()=>{
 const keys=[...new Set(Object.values(profiles).flat().map(r=>r.key))].sort();
 assert.deepEqual(Object.keys(cargo).sort(),keys);
 for(const [key,rows]of Object.entries(cargo)){
  assert.ok(catalog.definitions[key]);const seen=new Set();
  for(const r of rows){assert.ok(oreNames[r.type]);assert.ok(Number.isSafeInteger(r.amount)&&r.amount>0);assert.ok(!seen.has(r.type));seen.add(r.type);}
 }
 for(const key of ['infernal','epsilon-vagrant','emperor-sibelon','kappa-kucurbium'])assert.equal(cargo[key],undefined);
});
test('source exceptions survive instead of nominal boss/uber multiplication',()=>{
 assert.equal(amount('boss-streuner',2),10);assert.equal(amount('uber-streuner',2),20);
 assert.equal(amount('streuner-upper',4),15);assert.equal(amount('boss-streuner-upper',4),32);
 assert.equal(amount('uber-streuner-upper',4),120);assert.equal(amount('boss-streuner-upper',6),0);
 assert.equal(amount('boss-lordakia',3),1);assert.equal(amount('uber-lordakia',6),0);
 assert.equal(amount('uber-barracuda',6),100);assert.equal(amount('uber-annihilator',4),200);
});
test('pirate palladium and full Cubikon cargo preserve ore types instead of generic ten-plus-ten drops',()=>{
 assert.equal(amount('uber-interceptor',8),2);assert.equal(amount('uber-annihilator',8),4);
 assert.equal(amount('uber-saboteur',8),2);assert.equal(amount('uber-battleray',8),8);
 assert.equal(amount('interceptor',8),0);
 assert.deepEqual(cargo.streuner,[{type:0,amount:10},{type:1,amount:10}]);
 assert.equal(amount('cubikon',0),1200);assert.equal(amount('cubikon',3),64);assert.equal(amount('cubikon',6),64);
 assert.equal(amount('protegit',0),100);assert.equal(amount('protegit',4),16);
});
test('all 45 cargo rows reproduce explicit ore lines from the retained DE source editions',()=>{
 const names=new Map(Object.keys(cargo).map(key=>[catalog.definitions[key].name.replace(/\s/g,''),key])),verified=new Set();
 for(const source of ['npc-de','npc-de-page2']){
  const text=fs.readFileSync(path.join(__dirname,'../decompiled/gate-source-evidence',source+'.txt'),'utf8');
  const headers=[...text.matchAll(/^\s*\d{1,2}\.\d{0,2}\s+([^\r\n]+)$/gm)];
  for(let i=0;i<headers.length;i++){
   const key=names.get(headers[i][1].replace(/Über\s*/g,'Uber ').replace(/\s/g,''));if(!key)continue;
   const body=text.slice(headers[i].index,headers[i+1]?.index??text.length);if(!body.includes('Hitpoints:'))continue;
   const expected=[];
   for(let type=0;type<oreNames.length;type++){
    const ore=oreNames[type];if(!ore)continue;
    for(const line of body.split('\n')){
     const direct=line.trim().match(new RegExp('^'+ore+':\\s*([\\d.]+)(?:\\s|$)'));
     const reverse=line.trim().match(new RegExp('^([\\d.]+) '+ore+'(?:\\s|$)'));
     const m=direct||reverse;if(!m)continue;const amount=Number(m[1].split('.').join(''));
     if(amount)expected.push({type,amount});break;
    }
   }
   assert.deepEqual(cargo[key],expected,source+':'+key);verified.add(key);
  }
 }
 assert.equal(verified.size,45);
});
