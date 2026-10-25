'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const catalog=require('../game/pet-catalog');
const gear=(code,level=1)=>catalog.gear('equipment_petgear_'+code,level);
const protocol=(code,level=1)=>catalog.protocol('equipment_aiprotocol_'+code,level);
const row=(code,level,id)=>({loot_id:'equipment_aiprotocol_'+code,pet_level:level,slot:'protocol',...(id===undefined?{}:{id})});

test('all 27 catalog roots and every level agree with the retained client source',()=>{
 const source=fs.readFileSync(path.join(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit/items/ItemDataProvider.as'),'utf8');
 assert.equal(crypto.createHash('sha256').update(source).digest('hex'),catalog.SOURCE_SHA256);
 let roots=0;
 const re=/_loc16_ = new GeneralAttributes\(\);\s*_loc16_\.lootId = "(equipment_(?:aiprotocol|petgear)_[^"]+)";([\s\S]*?)items\["\1"\] =/g;
 for(const match of source.matchAll(re)){
  roots++;const entry=catalog.DATA[match[1]];assert.ok(entry,match[1]);let index=0;
  for(const level of match[2].matchAll(/_loc11_ = new PetEquipmentAttributes\(\);([\s\S]*?)_loc33_\.put\("([^"]+)",/g)){
   const values={};for(const attr of level[1].matchAll(/_loc11_\.values\["([^"]+)"\] = ([^;]+);/g))values[attr[1]]=Number(attr[2]);
   assert.deepEqual(entry.levels[index].values,values,level[2]);assert.equal(entry.levels[index++].variant,level[2]);
  }
  assert.equal(entry.levels.length,index);
 }
 assert.equal(roots,27);assert.equal(Object.keys(catalog.DATA).length,roots);
});

test('collector, locator, repair and trade levels use their different native values',()=>{
 assert.deepEqual([1,2,3].map(level=>gear('g-al1',level).range),[700,1500,3000]);
 assert.deepEqual([1,2,3].map(level=>gear('g-ar1',level).range),[700,1500,3000]);
 assert.deepEqual([1,2,3].map(level=>gear('g-el1',level).range),[2000,3000,5000]);
 assert.deepEqual([1,2,3].map(level=>gear('g-rl1',level).range),[2000,3000,5000]);
 assert.deepEqual([1,2,3].map(level=>gear('g-rep1',level).repair),[2000,6000,12000]);
 assert.deepEqual([1,2,3].map(level=>gear('g-tra1',level).absentMs),[300000,120000,30000]);
 assert.deepEqual([1,2,3].map(level=>gear('g-tra1',level).tradeBonus),[.05,.15,.3]);
});

test('variant suffixes are zero based and X variants do not invent a fourth collector tier',()=>{
 assert.equal(catalog.gear('equipment_petgear_g-al10').level,1);
 assert.equal(catalog.gear('equipment_petgear_g-al12').level,3);
 assert.equal(catalog.gear('equipment_petgear_g-al12X').level,3);
 assert.equal(catalog.gear('equipment_petgear_g-al12X').special,true);
 assert.equal(gear('g-al1',4),null);
 assert.equal(catalog.protocol('equipment_aiprotocol_ai-r13').level,4);
 assert.equal(catalog.gear({loot_id:'equipment_petgear_g-al1',upgrade_level:15}).level,1);
 assert.equal(catalog.gear({loot_id:'equipment_petgear_g-al1',pet_level:2}).level,2);
});

test('duplicate physical rows cannot multiply effects, separate protocols stack by addition',()=>{
 const first=row('ai-r1',3,101),second=row('ai-r1',3,102);
 assert.equal(catalog.equippedEffects([first,first,second]).radarMultiplier,1.24);
 assert.equal(catalog.equippedEffects([row('ai-r1',3),row('ai-r1',3)]).radarMultiplier,1.24);
 assert.equal(catalog.equippedEffects([{...first,slot:'laser'}]).count,0);
});

test('all ten classic protocol categories expose source percentages and distinct scopes',()=>{
 const effects=catalog.equippedEffects(['ai-lm1','ai-al1','ai-sm1','ai-hp1','ai-aim1','ai-e1','ai-cr1','ai-s1','ai-r1','ai-eco1'].map(code=>row(code,3)));
 assert.equal(effects.laserDamageMultiplier,1.04);assert.equal(effects.alienDamageMultiplier,1.06);
 assert.equal(effects.shieldMultiplier,1.04);assert.equal(effects.hitpointMultiplier,1.04);
 assert.equal(effects.accuracy,.04);assert.equal(effects.evasion,.03);
 assert.equal(effects.cargoMultiplier,1.12);assert.equal(effects.salvageMultiplier,1.03);
 assert.equal(effects.radarMultiplier,1.12);assert.equal(effects.fuelMultiplier,.96);
 assert.equal(effects.count,10);
 assert.equal(protocol('ai-eco1',2).bonus,.035);
 assert.equal(protocol('ai-ah1',3).supported,false);
});

test('classic module IDs and kamikaze thresholds/cooldowns match the client wire contract',()=>{
 assert.deepEqual(['g-al1','g-ar1','g-el1','g-rl1','g-tra1','g-rep1','g-kk1','csr-02','cgm-02'].map(code=>gear(code).type),[4,5,6,7,8,9,10,11,12]);
 assert.deepEqual([1,2,3].map(level=>gear('g-kk1',level).damage),[25000,45000,75000]);
 assert.deepEqual([1,2,3].map(level=>gear('g-kk1',level).cooldownMs),[120000,60000,30000]);
 assert.equal(gear('g-kk1',3).petHpThreshold,.2);assert.equal(gear('g-kk1',3).playerHpThreshold,.1);
 assert.equal(gear('g-kk1',3).radius,293);
 assert.equal(gear('csr-02',3).repair,25000);assert.equal(gear('csr-02',3).durationMs,5000);
 assert.equal(gear('csr-02',3).cooldownMs,15000);assert.equal(gear('csr-02',3).fuelUsage,750);
 assert.equal(gear('cgm-02',3).deflectionChance,.85);
 assert.equal(gear('g-mm1').supported,false);
});

test('gear/protocol eligibility enforces tiers and rejects corrupt levels',()=>{
 assert.equal(catalog.canEquip({loot_id:'equipment_petgear_g-al1',pet_level:2},3),false);
 assert.equal(catalog.canEquip({loot_id:'equipment_petgear_g-al1',pet_level:2},4),true);
 assert.equal(catalog.canEquip({loot_id:'equipment_aiprotocol_ai-r1',pet_level:3},7),false);
 assert.equal(catalog.canEquip({loot_id:'equipment_aiprotocol_ai-r1',pet_level:3},8),true);
 assert.equal(catalog.canEquip({loot_id:'equipment_aiprotocol_ai-r1',pet_level:4},19),false);
 for(const level of [0,-1,1.5,NaN,Infinity,5])assert.equal(gear('g-al1',level),null);
 assert.equal(catalog.resolve(null),null);assert.equal(catalog.resolve('not-an-item'),null);
 assert.equal(catalog.protocol('equipment_petgear_g-al1'),null);
});

test('only the highest installed copy supplies a gear mode; classic fuel is per minute',()=>{
 const eq=[{loot_id:'equipment_petgear_g-al1',pet_level:1,slot:'gear'},{loot_id:'equipment_petgear_g-al1',pet_level:3,slot:'gear'}];
 assert.equal(catalog.gearForType(eq,4).range,3000);assert.equal(catalog.gearForType(eq,9),null);
 assert.equal(catalog.fuelPerMinute(15),31);
 assert.equal(catalog.fuelPerMinute(15,[...eq,row('ai-r1',3)]),41);
 assert.equal(catalog.fuelPerMinute(15,[row('ai-eco1',3)]),33*.96);
 const combo=[{loot_id:'equipment_petgear_cgm-02',pet_level:3,slot:'gear'}];
 assert.equal(catalog.fuelPerMinute(15,combo,12),35*1.35);
 assert.throws(()=>catalog.fuelPerMinute(-1),RangeError);
});

test('source level slot maxima retain level zero and are distinct from purchased slots',()=>{
 assert.deepEqual(catalog.slotsAtLevel(0),{laser:1,generator:2,gear:1,protocol:2,visual:1,heat:7});
 assert.deepEqual(catalog.slotsAtLevel(10),{laser:6,generator:12,gear:6,protocol:12,visual:1,heat:7});
 assert.deepEqual(catalog.slotsAtLevel(15),{laser:10,generator:17,gear:8,protocol:12,visual:1,heat:7});
 assert.equal(catalog.slotsAtLevel(-1),null);assert.equal(catalog.slotsAtLevel(21),null);
 const supported=catalog.entries();assert.equal(supported.filter(e=>e.kind==='gear').length,10);assert.equal(supported.filter(e=>e.kind==='protocol').length,10);
 assert.equal(catalog.entries({supportedOnly:false}).length,27);
 assert.ok(catalog.entries({variants:true}).some(e=>e.variantId==='equipment_aiprotocol_ai-r12'&&e.level===3));
});
