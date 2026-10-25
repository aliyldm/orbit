'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const dir=path.resolve(__dirname,'../decompiled/laser-rhythm-patch'),base='scripts/net/bigpoint/darkorbit/';
const read=(stage,file)=>fs.readFileSync(path.join(dir,stage,base,file+'.as'),'utf8');
function body(s,name){const start=s.indexOf('function '+name+'(');assert.ok(start>=0);const begin=s.indexOf('{',start);let n=1,i=begin+1;for(;n;i++){if(s[i]==='{')n++;if(s[i]==='}')n--;}return s.slice(begin+1,i-1);}
test('compiled normal sound is immediate and once per damage round; normal visuals10percent slower, RSB unchanged',()=>{
 const s=read('verified','map/common/LaserEmissionSchedule');
 const code=body(s,'soundAllowed').replace(/:Object/g,'').replace('LAST_SOUNDS[param1] = param3;','LAST_SOUNDS.set(param1,param3);').replace('LAST_SOUNDS[param1]','LAST_SOUNDS.get(param1)');
 const allow=new Function('LAST_SOUNDS','return function(param1,param2,param3){'+code+'}')(new WeakMap()),ship={},times=[];
 for(let round=0;round<=4000;round+=1000)for(const delay of [0,220,440,660])if(allow(ship,0,round+delay))times.push(round+delay);
 assert.deepEqual(times,[0,1000,2000,3000,4000]);
 for(const t of [0,200,400,600])assert.equal(allow(ship,6,t),true);
 const delay=new Function('param1','param2','param3',body(s,'delayMs'));assert.equal(delay(0,3,4),660);assert.equal(delay(6,3,4),600);
 for(const [file,n]of [['map/view2D/effects/combat/laser/LaserSalvo2D',1],['map/view3D/effects/combat/laser/LaserSalvo3D',2]])assert.equal((read('verified',file).match(/LaserEmissionSchedule.soundAllowed\(/g)||[]).length,n);
});
test('installed MAIN preserves the compiled repeatable equipment patch and all256 non-code tags',()=>{
 const proof=require('../decompiled/laser-rhythm-patch/evidence.json'),repeat=require('../decompiled/repeatable-equipment-patch/evidence.json');assert.equal(proof.beforeSha256,repeat.afterSha256);assert.equal(proof.nonAbcIdentical,true);assert.equal(proof.unchangedNonAbcTags,256);
 const native=require('../decompiled/native-laser-sound-patch/evidence.json');assert.equal(native.beforeSha256,proof.afterSha256);
 const visual=require('../decompiled/native-laser-visuals-patch/evidence.json');assert.equal(visual.beforeSha256,native.afterSha256);assert.equal(crypto.createHash('sha256').update(fs.readFileSync(path.resolve(__dirname,'../client/spacemap/main.swf'))).digest('hex'),require('../decompiled/ship-motion-patch/evidence.json').afterSha256);
 const model=read('verified','mvc/crafting/assembly/model/AssemblyModel');assert.match(model,/recipe_blueprint-agate-lf4/);assert.match(model,/ALWAYS_USABLE/);assert.match(model,/2147483647/);
});
