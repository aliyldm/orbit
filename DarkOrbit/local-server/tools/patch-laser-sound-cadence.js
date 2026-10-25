'use strict';
// Audio-only gate: normal laser sounds once per attacker/2s across2D/3D.
// RSB6 and every visual emission/impact timer remain unchanged.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/laser-sound-cadence-patch');
const input=path.resolve(process.argv[2]||path.join(root,'client/spacemap/main.swf')),output=path.resolve(process.argv[3]||path.join(dir,'main-patched.swf'));
const java='C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar='D:\\swfde\\ffdec.jar';
const classes=['net.bigpoint.darkorbit.map.common.LaserEmissionSchedule','net.bigpoint.darkorbit.map.view2D.effects.combat.laser.LaserSalvo2D','net.bigpoint.darkorbit.map.view3D.effects.combat.laser.LaserSalvo3D'];
const rel=c=>path.join('scripts',...c.split('.'))+'.as',sha=b=>crypto.createHash('sha256').update(b).digest('hex');fs.mkdirSync(dir,{recursive:true});
function run(args,log){const r=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,log),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS failed: '+log);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
fs.copyFileSync(input,path.join(dir,'main-before.swf'));
run(['-selectclass',classes.join(','),'-export','script',path.join(dir,'before'),input],'export.log');
let last=input;
for(let i=0;i<classes.length;i++){
 const cls=classes[i];let source=fs.readFileSync(path.join(dir,'before',rel(cls)),'utf8');
 if(i===0){
  source=source.replace('   public final class LaserEmissionSchedule','   import flash.utils.Dictionary;\r\n\r\n   public final class LaserEmissionSchedule');
  const anchor='      public function LaserEmissionSchedule()';if(!source.includes(anchor)||source.includes('soundAllowed'))throw Error('Unexpected emission schedule');
  source=source.replace(anchor,`      private static const LAST_SOUNDS:Dictionary = new Dictionary(true);

      public static function soundAllowed(param1:Object, param2:int, param3:int) : Boolean
      {
         if(param2 == 6) return true;
         var previous:Object = LAST_SOUNDS[param1];
         if(previous !== undefined && param3 >= Number(previous) && param3 - Number(previous) < 2000) return false;
         LAST_SOUNDS[param1] = param3;
         return true;
      }

` .replace(/\n/g,'\r\n')+anchor);
 }else{
  // JPEXS cannot recompile the exported NaN optional default. This provider's
  // third argument is unused (the body only sets param2 to0,0,0); normalize its
  // fallback to0 without changing any cannon coordinate calculation.
  const unused='public function getLaserCannonLocalPosition(param1:String, param2:Vector3D, param3:Number = NaN) : void';
  if(!source.includes(unused))throw Error('Unexpected position provider');
  source=source.replace(unused,unused.replace('= NaN','= 0'));
  const anchor='if(this._laserPattern.getSoundID() != -1)',count=source.split(anchor).length-1;
  if(count!==(i===1?1:2))throw Error('Unexpected sound sites in '+cls);
  source=source.replaceAll(anchor,'if(this._laserPattern.getSoundID() != -1 && LaserEmissionSchedule.soundAllowed(this.attackerShip,this._laserTypeID,getTimer()))');
 }
 const file=path.join(dir,cls.split('.').at(-1)+'.as');fs.writeFileSync(file,source);
 const next=i===classes.length-1?output:path.join(dir,'stage-'+i+'.swf');run(['-replace',last,next,cls,file],'compile-'+i+'.log');last=next;
}
const retained=['net.bigpoint.darkorbit.mvc.crafting.upgrade.view.UpgradeWindowMediator','net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyInventoryIndex','net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy','net.bigpoint.darkorbit.net.RocketLauncherAssembly'];
run(['-selectclass',classes.concat(retained).join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
for(const cls of classes)if(!fs.readFileSync(path.join(dir,'verified',rel(cls)),'utf8').includes('soundAllowed'))throw Error('Compiled audio gate missing');
const a=fs.readFileSync(input),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);if(ta.length!==tb.length)throw Error('Tag count changed');const changes=ta.flatMap((t,i)=>t.sha256===tb[i].sha256?[]:[{index:i,before:t,after:tb[i]}]);if(changes.length!==1||changes.some(c=>c.before.tag!==82||c.after.tag!==82))throw Error('Unexpected media changes');
const proof={classes,beforeSha256:sha(a),afterSha256:sha(b),nonAbcIdentical:true,unchangedNonAbcTags:ta.filter(t=>t.tag!==82).length,changes,intervalMs:2000,rsbBypass:6,scope:'Per-attacker audio gating. Emission scheduling, sound samples, damage and ammo cadence unchanged.',compilerNormalization:'Unused third default in the two dummy cannon-position providers: NaN to0 (no body reads this argument).',limitations:['No audible Qt/Flash playback verification.']};fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2)+'\n');console.log(JSON.stringify({...proof,changes:changes.length,output}));
