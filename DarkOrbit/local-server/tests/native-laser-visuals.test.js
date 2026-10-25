'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/native-laser-visuals-patch'),base='scripts/net/bigpoint/darkorbit/';
function body(s,name){const at=s.indexOf('function '+name+'(');assert.ok(at>=0,name);const begin=s.indexOf('{',at);let n=1,i=begin+1;for(;n;i++){if(s[i]==='{')n++;if(s[i]==='}')n--;}return s.slice(begin+1,i-1);}
const read=file=>fs.readFileSync(path.join(dir,'verified',base,file+'.as'),'utf8');
test('installed native sub-salvo scheduling is200ms for every ammo type and ship group count',()=>{
 const source=read('map/common/LaserEmissionSchedule'),delay=new Function('param1','param2','param3',body(source,'delayMs')),count=new Function('param1','param2',body(source,'emissionCount'));
 for(const type of [0,1,2,3,4,6,8,9,10,109,110,111,112,113,114,32])for(const groups of [1,2,4,6]){assert.equal(count(type,groups),groups);assert.deepEqual(Array.from({length:groups},(_,i)=>delay(type,i,groups)),Array.from({length:groups},(_,i)=>i*200));}
 assert.equal(source.includes('soundAllowed'),false);assert.throws(()=>delay(0,-1,4),RangeError);
});
test('all14 laser/render/audio classes match the captured host, with only reviewed decompiler normalization',()=>{
 const evidence=require('../decompiled/native-laser-visuals-patch/evidence.json'),normalize=s=>s.replaceAll('musicPatterns[int(typeID)]','musicPatterns[typeID]').replaceAll('musicPatterns[int(param1)]','musicPatterns[param1]').replaceAll('Boolean(lastTrack.resKey != param2.resKey)','lastTrack.resKey != param2.resKey').replaceAll('Number(NaN)','NaN').replace(/\(Boolean\((\w+)\)\)/g,'Boolean($1)').replace(/(getLaserCannonLocalPosition\(param1:String, param2:Vector3D, param3:Number = )0(?=\))/g,'$1NaN');
 assert.equal(evidence.comparisons.length,14);for(const c of evidence.comparisons){const rel=path.join('scripts',...c.class.split('.'))+'.as',current=fs.readFileSync(path.join(dir,'verified',rel),'utf8'),host=fs.readFileSync(path.join(dir,'host',rel),'utf8');assert.equal(normalize(current),normalize(host),c.class);}
 assert.equal(evidence.changes.length,1);assert.equal(evidence.changes[0].after.tag,82);assert.equal(evidence.nonAbcIdentical,true);assert.equal(evidence.unchangedNonAbcTags,256);assert.equal(crypto.createHash('sha256').update(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))).digest('hex'),require('../decompiled/ship-motion-patch/evidence.json').afterSha256);
});
test('native laser definitions, sound IDs, quality-dependent emitters and CBO double effect stay intact',()=>{
 const evidence=require('../decompiled/native-laser-visuals-patch/evidence.json');assert.deepEqual(evidence.sections.map(s=>s.name),['laserDefinitions','laserDefinitionsAprilsFools','lasers','expansions']);assert.ok(evidence.sections.every(s=>s.identical));
 const xml=fs.readFileSync(path.join(dir,'game-current.xml'),'utf8'),host=fs.readFileSync(path.join(dir,'game-host.xml'),'utf8'),patterns=xml.match(/<lasers>([\s\S]*?)<\/lasers>/)[1],defs=xml.match(/<laserDefinitions>([\s\S]*?)<\/laserDefinitions>/)[1];
 for(const [slug,type]of Object.entries(require('../game/laser-visuals').AMMO)){const entry=patterns.match(new RegExp('<laser class="0" type="'+type+'"[^>]*>([\\s\\S]*?)<\\/laser>'));assert.ok(entry,slug);for(const id of [...entry[1].matchAll(/salvoID="(\d+)"/g)].map(m=>m[1]))assert.match(defs,new RegExp('<laser salvoID="'+id+'"'),slug);}
 assert.match(patterns,/<laser class="0" type="8"[^>]*>[\s\S]*?<salvo salvoID="14"\/>\s*<salvo salvoID="15"\/>/);
 for(const id of evidence.soundIds){const rx=new RegExp('<sound\\s+id="'+id+'"[^>]*>[\\s\\S]*?<\\/sound>');assert.equal(xml.match(rx)[0],host.match(rx)[0],String(id));}
 const renderer=read('map/view2D/effects/combat/laser/LaserSalvo2D');assert.match(renderer,/Settings\.qualityShip\.value <= Settings\.QUALITY_LOW/);assert.match(renderer,/this\._skilledLaser/);assert.match(read('pattern/PatternManager'),/laserClasses\[param1\] \|\| laserClasses\[0\]/);
});
test('native audio cleanup removes all completed/stopped channel references without suppressing later sounds',()=>{
 const source=read('audio/AudioManager'),channel={},other={},unique={7:channel,9:other},stack=[channel,other,channel],ids=[0,9,0];
 const code=body(source,'forgetSoundChannel').replace(/:(?:int|\*)/g,'').replace('int(currentlyPlayingStackingSounds.length - 1)','Math.trunc(currentlyPlayingStackingSounds.length - 1)');
 const forget=new Function('getCurrentlyPlayingSoundChannel','currentlyPlayingUniqueSounds','currentlyPlayingStackingSounds','currentlyPlayingStackingSoundsPatternIDs','return function(param1){'+code+'}')(c=>Object.keys(unique).find(k=>unique[k]===c)??-1,unique,stack,ids);forget(channel);assert.deepEqual(unique,{9:other});assert.deepEqual(stack,[other]);assert.deepEqual(ids,[9]);forget(channel);assert.deepEqual(stack,[other]);
 assert.match(body(source,'removeLoop'),/if\(param1 == null\)[\s\S]*?return;[\s\S]*?forgetSoundChannel\(param1\);/);
});
