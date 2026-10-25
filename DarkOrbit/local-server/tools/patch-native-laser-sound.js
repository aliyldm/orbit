'use strict';
// Restore captured native audio call conditions, preserving all visual timers.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/native-laser-sound-patch'),input=path.join(root,'client/spacemap/main.swf'),output=path.join(dir,'main-patched.swf');
const classes=['net.bigpoint.darkorbit.map.common.LaserEmissionSchedule','net.bigpoint.darkorbit.map.view2D.effects.combat.laser.LaserSalvo2D','net.bigpoint.darkorbit.map.view3D.effects.combat.laser.LaserSalvo3D'];
const rel=c=>path.join('scripts',...c.split('.'))+'.as',sha=b=>crypto.createHash('sha256').update(b).digest('hex');fs.mkdirSync(dir,{recursive:true});
function run(args,log){const r=spawnSync('C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',['-jar','D:\\swfde\\ffdec.jar',...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,log),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS: '+log);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
const before=fs.readFileSync(input);if(sha(before)!==require('../decompiled/laser-rhythm-patch/evidence.json').afterSha256)throw Error('Unexpected installed MAIN');
fs.copyFileSync(input,path.join(dir,'main-before.swf'));run(['-selectclass',classes.join(','),'-export','script',path.join(dir,'before'),input],'export.log');
let last=input;
for(let n=0;n<classes.length;n++){
 const cls=classes[n];let source=fs.readFileSync(path.join(dir,'before',rel(cls)),'utf8');
 if(n===0){
  const start=source.indexOf('      public static function soundAllowed('),end=source.indexOf('      public static function emissionCount(');
  if(start<0||end<start||!source.includes('< 1000'))throw Error('Unexpected audio gate');
  source=source.slice(0,start)+source.slice(end);
  source=source.replace('   import flash.utils.Dictionary;','').replace('      private static const LAST_SOUNDS:Dictionary = new Dictionary(true);','');
 }else{
  const gate=' && LaserEmissionSchedule.soundAllowed(this.attackerShip,this._laserTypeID,getTimer())',count=source.split(gate).length-1;
  if(count!==(n===1?1:2))throw Error('Unexpected sound sites');
  source=source.replaceAll(gate,'');
 }
 const file=path.join(dir,cls.split('.').at(-1)+'.as');fs.writeFileSync(file,source);
 const next=n===classes.length-1?output:path.join(dir,'stage-'+n+'.swf');run(['-replace',last,next,cls,file],'compile-'+n+'.log');last=next;
}
const retained=['net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyModel','net.bigpoint.darkorbit.mvc.crafting.upgrade.view.UpgradeWindowMediator','net.bigpoint.darkorbit.net.RocketLauncherAssembly'];
run(['-selectclass',[...classes,...retained].join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
for(const cls of classes)if(fs.readFileSync(path.join(dir,'verified',rel(cls)),'utf8').includes('soundAllowed'))throw Error('Audio gate retained');
const after=fs.readFileSync(output),a=tags(before),b=tags(after);if(a.length!==b.length)throw Error('Tag count differs');const changes=a.flatMap((t,i)=>t.sha256===b[i].sha256?[]:[{index:i,before:t,after:b[i]}]);if(changes.length!==1||changes[0].before.tag!==82||changes[0].after.tag!==82)throw Error('Non-code data changed');
const proof={beforeSha256:sha(before),afterSha256:sha(after),classes,nonAbcIdentical:true,unchangedNonAbcTags:a.filter(t=>t.tag!==82).length,changes,scope:'Remove custom 1-second audio gate; captured native 2D/3D sound sites. Visual sub-salvos220ms/RSB200ms retained; damage/ammo unchanged.',limitations:['No live original-server timing capture or audible Qt verification.']};fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2)+'\n');console.log(JSON.stringify(proof));
