'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const dir=path.resolve(__dirname,'../decompiled/laser-sound-cadence-patch'),base='scripts/net/bigpoint/darkorbit/';
const read=(stage,file)=>fs.readFileSync(path.join(dir,stage,base,file+'.as'),'utf8');
function body(source,name){const start=source.indexOf('function '+name+'(');assert.ok(start>=0,name);const begin=source.indexOf('{',start);let depth=1,at=begin+1;for(;depth;at++){if(source[at]==='{')depth++;if(source[at]==='}')depth--;}return source.slice(begin+1,at-1);}
function gate(){const source=read('verified','map/common/LaserEmissionSchedule'),code=body(source,'soundAllowed').replace(/:Object/g,'').replace('LAST_SOUNDS[param1] = param3;','LAST_SOUNDS.set(param1,param3);').replace('LAST_SOUNDS[param1]','LAST_SOUNDS.get(param1)');return new Function('LAST_SOUNDS','return function(param1,param2,param3){'+code+'}')(new WeakMap());}
test('compiled shared audio gate plays the first normal sound immediately and at most once per2seconds despite cannon groups',()=>{
 const allow=gate(),ship={},played=[];for(let round=0;round<=4000;round+=1000)for(const delay of [0,200,400,600])if(allow(ship,0,round+delay))played.push(round+delay);
 assert.deepEqual(played,[0,2000,4000]);assert.equal(allow({},0,50),true,'different attackers have independent gates');
});
test('compiled RSB branch preserves every old sound site and handles clock resets without a stuck mute',()=>{
 const allow=gate(),ship={};for(const t of [0,200,400,600,3000,3200,3400,3600])assert.equal(allow(ship,6,t),true);
 assert.equal(allow(ship,0,0),true);assert.equal(allow(ship,0,1999),false);assert.equal(allow(ship,0,2000),true);assert.equal(allow(ship,0,1),true);
});
test('both renderers gate only audio sites; original salvo counts, cannon grouping and emission delays are byte-for-byte source-equivalent',()=>{
 const common='map/common/LaserEmissionSchedule';for(const name of ['emissionCount','cannonGroupIndex','delayMs'])assert.equal(body(read('before',common),name),body(read('verified',common),name));
 for(const [file,sites] of [['map/view2D/effects/combat/laser/LaserSalvo2D',1],['map/view3D/effects/combat/laser/LaserSalvo3D',2]]){
  const source=read('verified',file);assert.equal((source.match(/LaserEmissionSchedule.soundAllowed\(/g)||[]).length,sites);assert.equal((source.match(/AudioManager.playSoundEffect\(/g)||[]).length,sites);assert.equal(body(source,'getLaserCannonLocalPosition'),body(read('before',file),'getLaserCannonLocalPosition'));
 }
});
test('installed sound patch extends the existing MAIN chain without changing media or earlier UI/launcher classes',()=>{
 const proof=require('../decompiled/laser-sound-cadence-patch/evidence.json'),previous=require('../decompiled/multi-launcher-patch/evidence.json');assert.equal(proof.beforeSha256,previous.afterSha256);assert.equal(proof.nonAbcIdentical,true);assert.equal(proof.unchangedNonAbcTags,256);assert.equal(proof.changes.length,1);assert.equal(proof.changes[0].after.tag,82);
 const hash=crypto.createHash('sha256').update(fs.readFileSync(path.resolve(__dirname,'../client/spacemap/main.swf'))).digest('hex');assert.equal(hash,require('./helpers/installed-main').after(previous.beforeSha256));
 for(const file of ['mvc/crafting/upgrade/view/UpgradeWindowMediator','mvc/crafting/assembly/model/AssemblyInventoryIndex','mvc/settingsFUI/model/SettingsWindowFUIProxy','net/RocketLauncherAssembly'])assert.equal(read('verified',file),fs.readFileSync(path.resolve(__dirname,'../decompiled/multi-launcher-patch/verified',base,file+'.as'),'utf8'));
});
