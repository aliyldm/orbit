'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.resolve(__dirname,'..'),base='scripts/net/bigpoint/darkorbit/',dir=path.join(root,'decompiled/native-laser-sound-patch');
const read=(stage,file)=>fs.readFileSync(path.join(dir,stage,base,file+'.as'),'utf8');
function body(s,name){const at=s.indexOf('function '+name+'(');assert.ok(at>=0,name);const begin=s.indexOf('{',at);let n=1,i=begin+1;for(;n;i++){if(s[i]==='{')n++;if(s[i]==='}')n--;}return s.slice(begin+1,i-1);}
test('current 2D/3D audio sites equal native call conditions; no custom sound interval survives',()=>{
 const gate=' && LaserEmissionSchedule.soundAllowed(this.attackerShip,this._laserTypeID,getTimer())';
 for(const [file,count]of [['map/view2D/effects/combat/laser/LaserSalvo2D',1],['map/view3D/effects/combat/laser/LaserSalvo3D',2]]){
  const before=read('before',file),after=read('verified',file),native=fs.readFileSync(path.join(root,'decompiled/laser-sound-cadence-patch/before',base,file+'.as'),'utf8');
  assert.equal(after,before.replaceAll(gate,''));assert.equal((after.match(/AudioManager.playSoundEffect\(/g)||[]).length,count);assert.equal((after.match(/if\(this\._laserPattern.getSoundID\(\) != -1\)/g)||[]).length,count);
  assert.equal((native.match(/if\(this\._laserPattern.getSoundID\(\) != -1\)/g)||[]).length,count);assert.equal(after.includes('soundAllowed'),false);
  const normalized=s=>s.replaceAll('Number(NaN)','NaN').replace(/\(Boolean\((\w+)\)\)/g,'Boolean($1)');
  for(const name of ['startAttack','shotSalvo'])if(native.includes('function '+name+'('))assert.equal(normalized(body(after,name)),normalized(body(native,name)),'captured native sound/animation body '+name);
 }
 const common='map/common/LaserEmissionSchedule',after=read('verified',common);assert.equal(after.includes('soundAllowed'),false);assert.equal(after.includes('LAST_SOUNDS'),false);
 for(const name of ['emissionCount','cannonGroupIndex','delayMs'])assert.equal(body(after,name),body(read('before',common),name),'no visual timing change');
});
test('installed native audio patch preserves all media, recipes, upgrade UI and launchers',()=>{
 const proof=require('../decompiled/native-laser-sound-patch/evidence.json');assert.equal(proof.beforeSha256,require('../decompiled/laser-rhythm-patch/evidence.json').afterSha256);assert.equal(proof.nonAbcIdentical,true);assert.equal(proof.unchangedNonAbcTags,256);assert.equal(proof.changes.length,1);assert.equal(proof.changes[0].after.tag,82);
 const visual=require('../decompiled/native-laser-visuals-patch/evidence.json');assert.equal(visual.beforeSha256,proof.afterSha256);assert.equal(crypto.createHash('sha256').update(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))).digest('hex'),require('../decompiled/ship-motion-patch/evidence.json').afterSha256);
 for(const [file,old]of [['mvc/crafting/assembly/model/AssemblyModel','laser-rhythm-patch'],['mvc/crafting/upgrade/view/UpgradeWindowMediator','laser-rhythm-patch'],['net/RocketLauncherAssembly','multi-launcher-patch']])assert.equal(read('verified',file),fs.readFileSync(path.join(root,'decompiled',old,'verified',base,file+'.as'),'utf8'));
});
