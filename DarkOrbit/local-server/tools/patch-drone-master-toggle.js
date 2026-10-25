'use strict';
// The generic drone checkbox is a local master switch. A transition updates
// the independent own-drone model too, so toggling back on reverses hiding.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/drone-master-toggle-patch'),cls='net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy';
const java=process.env.DARKORBIT_JAVA||'C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar=process.env.DARKORBIT_FFDEC||'D:\\swfde\\ffdec.jar';
const input=path.resolve(process.argv[2]||path.join(dir,'main-before.swf')),output=path.resolve(process.argv[3]||path.join(dir,'main-patched.swf'));
const sha=b=>crypto.createHash('sha256').update(b).digest('hex'),relative=c=>path.join('scripts',...c.split('.'))+'.as';fs.mkdirSync(dir,{recursive:true});
function run(args,name){const r=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,name),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS failed: '+name);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
run(['-selectclass',cls,'-export','script',path.join(dir,'before'),input],'export.log');
const before=fs.readFileSync(path.join(dir,'before',relative(cls)),'utf8');
const anchor='                  this.model.showDrones = param1.checkBoxSelected;\r\n';
if(!before.includes(anchor)||before.includes('this.model.showDrones = param1.checkBoxSelected;\r\n                  this.model.showMyDrones'))throw Error('Unexpected native source');
const source=before.replace(anchor,anchor+'                  this.model.showMyDrones = param1.checkBoxSelected;\r\n                  Settings.showMyDrones.value = param1.checkBoxSelected;\r\n');
fs.writeFileSync(path.join(dir,'SettingsWindowFUIProxy.as'),source);
run(['-replace',input,output,cls,path.join(dir,'SettingsWindowFUIProxy.as')],'compile.log');
const retained=['net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyInventoryIndex','net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyModel','net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper','net.bigpoint.darkorbit.map.hud.ship.TopDisplay'];
run(['-selectclass',[cls,...retained].join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
const after=fs.readFileSync(path.join(dir,'verified',relative(cls)),'utf8');if(!after.includes('this.model.showDrones = param1.checkBoxSelected;\r\n                  this.model.showMyDrones = param1.checkBoxSelected;'))throw Error('Compiled master toggle missing');
const a=fs.readFileSync(input),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);if(ta.length!==tb.length)throw Error('Tag count changed');const changes=ta.flatMap((t,i)=>t.sha256===tb[i].sha256?[]:[{index:i,before:t,after:tb[i]}]);if(changes.length!==1||changes.some(c=>c.before.tag!==82||c.after.tag!==82))throw Error('Unexpected SWF changes');
const proof={className:cls,beforeSha256:sha(a),afterSha256:sha(b),unchangedNonAbcTags:ta.filter(t=>t.tag!==82).length,nonAbcIdentical:true,changes,scope:'Only changed master drone checkbox synchronizes own-drone model and bindable setting; independent own checkbox remains.'};fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2));console.log(JSON.stringify({...proof,changes:changes.length,output}));
