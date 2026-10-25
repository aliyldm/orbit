'use strict';
// Compile against the actual installed MAIN, preserving previous patches.
// Only KeyboardMapper changes; the original lock/chat/repeat guard remains
// in EventManager, and a user-assigned M always takes precedence.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/map-hotkey-patch');
const cls='net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper';
const java=process.env.DARKORBIT_JAVA||'C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar=process.env.DARKORBIT_FFDEC||'D:\\swfde\\ffdec.jar';
const input=path.resolve(process.argv[2]||path.join(dir,'main-before.swf')),output=path.resolve(process.argv[3]||path.join(dir,'main-patched.swf'));
const sha=b=>crypto.createHash('sha256').update(b).digest('hex');
fs.mkdirSync(dir,{recursive:true});
function run(args,name){const r=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,name),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS failed: '+name);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);if(b.toString('ascii',0,3)!=='FWS')throw Error('Unsupported compression');let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}if(at+n>b.length)throw Error('Truncated tag');out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
run(['-selectclass',cls,'-export','script',path.join(dir,'before'),input],'export.log');
const relative=path.join('scripts',...cls.split('.'))+'.as';
const before=fs.readFileSync(path.join(dir,'before',relative),'utf8');
const anchor='         var _loc2_:Vector.<Object> = this._keymap[param1.toString()];\r\n';
const guard='         if(param1 == 77 && _loc2_ == null)\r\n         {\r\n            GuiManager.instance.createSpaceMapWindow();\r\n            GameFacade.getInstance().sendNotification(GuiNotifications.TOGGLE_WINDOW_BY_ID,new ToggleWindowVO(null,"spacemap",false));\r\n            GameFacade.getInstance().sendNotification(FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS);\r\n            return;\r\n         }\r\n';
const imports=['net.bigpoint.darkorbit.gui.GuiManager','net.bigpoint.darkorbit.mvc.application.GameFacade','net.bigpoint.darkorbit.mvc.gui.GuiNotifications','net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications','net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.logic.ToggleWindowVO'];
if(!before.includes(anchor)||before.includes('param1 == 77'))throw Error('Unexpected KeyboardMapper source');
const patched=before.replace('   import net.bigpoint.darkorbit.managers.ScreenManager;',imports.map(x=>'   import '+x+';').join('\r\n')+'\r\n   import net.bigpoint.darkorbit.managers.ScreenManager;').replace(anchor,anchor+guard);
const source=path.join(dir,'KeyboardMapper.as');fs.writeFileSync(source,patched);
run(['-replace',input,output,cls,source],'compile.log');
run(['-selectclass',cls,'-export','script',path.join(dir,'verified'),output],'verify.log');
const after=fs.readFileSync(path.join(dir,'verified',relative),'utf8');
if(!after.includes(guard)||!after.includes('if(_loc2_ != null)'))throw Error('Compiled map fallback not recovered');
const a=fs.readFileSync(input),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);
if(ta.length!==tb.length)throw Error('Tag count changed');
const changes=ta.flatMap((t,i)=>t.sha256===tb[i].sha256?[]:[{index:i,before:t,after:tb[i]}]);
if(changes.length!==1||changes.some(c=>c.before.tag!==82||c.after.tag!==82))throw Error('Unexpected SWF changes');
const proof={className:cls,beforeSha256:sha(a),afterSha256:sha(b),unchangedNonAbcTags:ta.filter(t=>t.tag!==82).length,nonAbcIdentical:true,changes,guard,limitations:['Compiled and decompiled native handler; Flash keyboard event was not visually exercised.']};
fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2));console.log(JSON.stringify({...proof,changes:changes.length,output}));
