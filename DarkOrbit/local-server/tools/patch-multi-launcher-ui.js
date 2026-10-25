'use strict';
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/multi-launcher-patch');
const input=path.resolve(process.argv[2]||path.join(root,'client/spacemap/main.swf')),output=path.resolve(process.argv[3]||path.join(dir,'main-patched.swf'));
const java='C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar='D:\\swfde\\ffdec.jar';
const classes=['net.bigpoint.darkorbit.net.RocketLauncherAssembly','net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy'];
const rel=c=>path.join('scripts',...c.split('.'))+'.as',sha=b=>crypto.createHash('sha256').update(b).digest('hex');fs.mkdirSync(dir,{recursive:true});
function run(args,log){const r=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:4*1024*1024});fs.writeFileSync(path.join(dir,log),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS failed: '+log);}
function replace(s,a,b){if(!s.includes(a))throw Error('Missing source anchor '+a);return s.replace(a,b);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
fs.copyFileSync(input,path.join(dir,'main-before.swf'));
run(['-selectclass',classes.join(','),'-export','script',path.join(dir,'before'),input],'export.log');
let source=fs.readFileSync(path.join(dir,'before',rel(classes[0])),'utf8');
source=replace(source,'         _loc2_.push(int(param1[3]));','         for each(var launcherType:String in String(param1[3]).split(","))\r\n         {\r\n            _loc2_.push(int(launcherType));\r\n         }');
source=replace(source,'                  _loc4_ += 5;\r\n               }','                  _loc4_ += 5;\r\n               }\r\n               else if(_loc5_ == 3)\r\n               {\r\n                  _loc4_ += 6;\r\n               }');
const sources=[source,replace(fs.readFileSync(path.join(dir,'before',rel(classes[1])),'utf8'),'new TrinityTrialsClaimPassRewardRequest(0,param2)','new TrinityTrialsClaimPassRewardRequest(param1,param2)')];
let last=input;for(let i=0;i<classes.length;i++){const file=path.join(dir,classes[i].split('.').at(-1)+'.as');fs.writeFileSync(file,sources[i]);const next=i===classes.length-1?output:path.join(dir,'stage-'+i+'.swf');run(['-replace',last,next,classes[i],file],'compile-'+i+'.log');last=next;}
run(['-selectclass',classes.concat(['net.bigpoint.darkorbit.mvc.crafting.upgrade.view.UpgradeWindowMediator','net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyInventoryIndex','net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy']).join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
const a=fs.readFileSync(input),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);if(ta.length!==tb.length)throw Error('Tag count changed');const changes=ta.flatMap((t,i)=>t.sha256===tb[i].sha256?[]:[{index:i,before:t,after:tb[i]}]);if(changes.length!==1||changes.some(c=>c.before.tag!==82||c.after.tag!==82))throw Error('Unexpected media or SWF tag changes');
const proof={classes,beforeSha256:sha(a),afterSha256:sha(b),nonAbcIdentical:true,unchangedNonAbcTags:ta.filter(t=>t.tag!==82).length,changes,scope:'Multiple launcher type vector and six-round capacity; Trinity clicked reward level rather than constant zero.',limitations:['No rendered Flash verification.']};fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2));console.log(JSON.stringify({...proof,changes:changes.length,output}));
