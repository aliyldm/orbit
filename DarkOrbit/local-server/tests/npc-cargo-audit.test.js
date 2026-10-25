'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const cargo=require('../game/npc-cargo'),catalog=require('../game/npc-catalog');
const read=name=>fs.readFileSync(path.join(__dirname,'../decompiled/gate-source-evidence',name+'.txt'),'utf8');
const oreNames=['Prometium','Endurium','Terbium','Xenomit','Prometid','Duranium','Promerium','Seprom','Palladium'];
function sourceRows(body,spanish=false){
 return oreNames.flatMap((name,type)=>{
  if(spanish&&type===3)name='Xenomita';
  const m=body.match(new RegExp('^\\s*'+name+'\\s*:\\s*([\\d.,]+)','m'));
  const amount=m?Number(m[1].replace(/[.,]/g,'')):0;return amount?[{type,amount}]:[];
 });
}
function block(text,start,end){const at=text.indexOf(start);assert.ok(at>=0,start);const stop=end?text.indexOf(end,at+start.length):text.length;assert.ok(stop>at);return text.slice(at,stop);}
test('cargo resolver reproduces all 45 audited normal rows and returns independent arrays',()=>{
 const expected=require('../game/normal-npc-cargo.json');
 for(const [key,rows]of Object.entries(expected))assert.deepEqual(cargo.resolve(catalog.get(key)),rows,key);
 const first=cargo.resolve(catalog.get('cubikon'));first[0].amount=0;
 assert.equal(cargo.resolve(catalog.get('cubikon'))[0].amount,1200);
});
test('own-home Streuner cargo follows exact level table for all three factions only',()=>{
 for(const [factionId,mapId]of [[1,1],[2,5],[3,9]])for(const [level,amount]of [[1,10],[6,10],[7,5],[8,2],[9,1],[10,0],[15,0],[30,0]]){
  const rows=cargo.resolve(catalog.get('streuner'),{player:{factionId,level,mapId}});
  assert.deepEqual(rows,amount?[{type:0,amount},{type:1,amount}]:[]);
 }
 assert.equal(cargo.resolve(catalog.get('streuner'),{player:{factionId:1,level:20,mapId:5}})[0].amount,10);
 assert.equal(cargo.resolve(catalog.get('streuner'),{player:{factionId:1,level:20,mapId:2}})[0].amount,10);
 assert.equal(cargo.resolve(catalog.get('boss-streuner'),{player:{factionId:1,level:20,mapId:1}})[0].amount,40);
});
test('home Streuner kill reward uses documented integer table and stops at level 15',()=>{
 const text=read('npc-standard-en');assert.ok(text.includes('Reward and cargo reduction'));assert.ok(text.includes('Level 15+ NOTHING NOTHING'));
 for(const [level,ep,honour]of [[7,200,1],[8,100,0],[9,50,0],[10,25,0],[11,12,0],[12,6,0],[13,3,0],[14,1,0],[15,0,0],[20,0,0]])
  assert.deepEqual(cargo.rewardOverride(catalog.get('streuner'),{player:{factionId:1,mapId:1,level}}),{ep,credits:ep,honour,uridium:0});
 assert.equal(cargo.rewardOverride(catalog.get('streuner'),{player:{factionId:2,mapId:1,level:20}}),null);
 assert.equal(cargo.rewardOverride(catalog.get('streuner'),{player:{factionId:1,mapId:1,level:6}}),null);
});
test('all eleven Zeta and Epsilon NPC cargo definitions match their pinned EN sources including Seprom',()=>{
 const zeta=read('zeta-en');
 const zetaHeaders=[['infernal','= [Infernal] ='],['scorcher','=[ Scorcher ]='],['melter','=[ Melter ]='],['devourer','=[ Devourer ]=']];
 for(let i=0;i<zetaHeaders.length;i++){
  const [key,header]=zetaHeaders[i];assert.deepEqual(cargo.resolve(catalog.get(key)),sourceRows(block(zeta,header,zetaHeaders[i+1]?.[1]||'Special Booty Days')),key);
 }
 const epsilon=read('epsilon-en'),names=['Vagrant','Marauder','Outcast','Corsair','Hooligan','Ravager','Convict'];
 for(let i=0;i<names.length;i++){
  const key='epsilon-'+names[i].toLowerCase();
  assert.deepEqual(cargo.resolve(catalog.get(key)),sourceRows(block(epsilon,'-= ['+names[i]+'] =-',names[i+1]&&'-= ['+names[i+1]+'] =-')),key);
 }
});
test('DE LoW versions explicitly have no ore and do not overwrite their Epsilon versions',()=>{
 const source=read('npc-de')+read('npc-de-page2');
 for(const [name,number]of [['Vagrant',16],['Marauder',17],['Outcast',18],['Convict',19],['Ravager',20],['Hooligan',21]]){
  const body=block(source,' '+number+'. '+name,'Zuletzt bearbeitet');assert.match(body,/Rohstoffe gibt es bei diesem\s*Gegner nicht/);
  assert.deepEqual(cargo.resolve(catalog.get(name.toLowerCase())),[]);
  assert.ok(cargo.resolve(catalog.get('epsilon-'+name.toLowerCase())).length>0);
 }
 assert.deepEqual(cargo.resolve(catalog.get('corsair')),[]);
});
test('ES Kappa and Hades cargo is source-specific instead of visual-ID inheritance',()=>{
 const es=read('npc-es');
 for(const [key,start,end]of [
  ['emperor-sibelon','Emperador Sibelon','Emperador Lordakium'],
  ['emperor-lordakium','Emperador Lordakium','Emperador Kristallon'],
  ['emperor-kristallon','Emperador Kristallon','ALIENS KUIPER'],
  ['kappa-demaner','DemaNeR&#8203;','Kucurbium&#8203;'],
  ['kappa-kucurbium','Kucurbium&#8203;','Boss Kucurbium&#8203;'],
  ['kappa-boss-kucurbium','Boss Kucurbium&#8203;','La seguridad de tu cuenta']]){
  assert.deepEqual(cargo.resolve(catalog.get(key)),sourceRows(block(es,start,end),true),key);
 }
 assert.equal(cargo.resolve(catalog.get('demaner')).find(r=>r.type===3).amount,22);
 assert.equal(cargo.resolve(catalog.get('kappa-demaner')).find(r=>r.type===3).amount,32);
});
test('unverified scaled and Kuiper-special cargo stays unknown without synthetic ten-plus-ten',()=>{
 assert.equal(cargo.resolve(catalog.get('streuner',2)),null);assert.equal(cargo.resolve(catalog.get('kristallon',3)),null);
 for(const key of ['streuner-soldier','streuner-specialist','streuner-turret','streuner-emperor','streuner-rocketeer'])assert.equal(cargo.resolve(catalog.get(key)),null);
 assert.equal(cargo.resolve({typeId:84,hitpoints:800}),null);
 assert.equal(cargo.resolve(catalog.get('streuner'),{scale:2}),null);
});

test('all 28 Kronos ore records match each individual official ES block, including asymmetries',()=>{
 const text=read('npc-es'),kronos=require('../game/kronos');
 const headers=[...text.matchAll(/^(Saturn [A-Za-z]+|Evil Iris|Evil)&#8203;/gm)];
 assert.equal(headers.length,28);
 for(let i=0;i<headers.length;i++){
  const h=headers[i],key=h[1].replace(/^Saturn /,'').toLowerCase().replace(' ','-');
  const body=text.slice(h.index,headers[i+1]?.index??text.indexOf('La seguridad de tu cuenta',h.index));
  const def=kronos.definition(key);assert.deepEqual(cargo.resolve(def),sourceRows(body,true),key);
  assert.equal(cargo.resolve({...def,hitpoints:def.hitpoints*2}),null);
 }
 assert.equal(cargo.resolve(kronos.definition('revenge')).some(o=>o.type===6),false);
 assert.equal(cargo.resolve(kronos.definition('evil')).find(o=>o.type===2).amount,300);
});

test('invasion Kucurbium and Boss cargo use their explicit DE x-1 edition',()=>{
 const text=read('npc-de');
 for(const [key,start,end]of [['kucurbium','14.1 Kucurbium','Invasionsgate x-3:'],['boss-kucurbium','14.2 Boss Kucurbium','Invasionsgate x-3:']]){
  const at=text.lastIndexOf(start),body=text.slice(at,text.indexOf(end,at)),expected=[];
  for(let type=0;type<oreNames.length;type++){
   const m=body.match(new RegExp('^([\\d.]+) '+oreNames[type]+'(?:\\s|$)','m'));
   if(m)expected.push({type,amount:Number(m[1].replaceAll('.',''))});
  }
  assert.equal(expected.length,7);assert.deepEqual(cargo.resolve(catalog.get(key)),expected,key);
 }
});
