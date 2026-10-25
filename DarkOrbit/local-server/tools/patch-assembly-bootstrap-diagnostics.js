'use strict';
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/assembly-bootstrap-diagnostics');
const java=process.env.DARKORBIT_JAVA||'C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar=process.env.DARKORBIT_FFDEC||'D:\\swfde\\ffdec.jar';
const input=path.resolve(process.argv[2]||path.join(dir,'main-before.swf')),output=path.resolve(process.argv[3]||path.join(dir,'main-patched.swf'));
const classes=['net.bigpoint.darkorbit.fui.UISystem','net.bigpoint.darkorbit.net.netty.CommandHandler','net.bigpoint.darkorbit.net.netty.handlers.items.UserInventoryHandler'];
const sha=b=>crypto.createHash('sha256').update(b).digest('hex'),relative=c=>path.join('scripts',...c.split('.'))+'.as';
fs.mkdirSync(dir,{recursive:true});
function run(args,name){const r=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,name),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS failed: '+name);}
function change(s,a,b){if(!s.includes(a))throw Error('Missing source anchor '+a.slice(0,70));return s.replace(a,b);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
run(['-selectclass',classes.join(','),'-export','script',path.join(dir,'before'),input],'export.log');
const source=Object.fromEntries(classes.map(c=>[c,fs.readFileSync(path.join(dir,'before',relative(c)),'utf8')]));
let s=source[classes[0]];
s=change(s,'   import flash.display.Stage;','   import flash.display.Stage;\r\n   import flash.events.Event;\r\n   import flash.events.IOErrorEvent;\r\n   import flash.events.SecurityErrorEvent;\r\n   import flash.net.URLLoader;\r\n   import flash.net.URLRequest;');
const helper=`      private static var _localDiagnosticCount:int = 0;

      public static function localFlashDiag(stage:String, detail:String = "") : void
      {
         if(_localDiagnosticCount >= 40) return;
         _localDiagnosticCount++;
         try
         {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void {});
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(e:Event):void {});
            loader.load(new URLRequest("http://127.0.0.1:8095/client/do_img/global/items/resource/upgrade-module_30x30.png?flashdiag=" + encodeURIComponent(stage) + "&detail=" + encodeURIComponent(detail.substr(0,1800)) + "&n=" + _localDiagnosticCount));
         }
         catch(ignored:Error) {}
      }

`;
s=change(s,'      public function buildWithCallback(',helper.replace(/\n/g,'\r\n')+'      public function buildWithCallback(');
const before='         this.build(param1,param2,true);\r\n         if(param4)\r\n         {\r\n            param3.apply(undefined,param4);\r\n         }\r\n         else\r\n         {\r\n            param3();\r\n         }';
const after=`         var description:String = param1 is XML ? XML(param1).toXMLString() : String(param1);
         var crafting:Boolean = description.indexOf("assembly_") >= 0 || description.indexOf("crafting_") >= 0 || description.indexOf("upgrade_") >= 0;
         if(crafting) localFlashDiag("ui-begin",description.substr(0,180));
         try
         {
            this.build(param1,param2,true);
            if(crafting) localFlashDiag("ui-built",description.substr(0,180));
            if(param4)
            {
               param3.apply(undefined,param4);
            }
            else
            {
               param3();
            }
            if(crafting) localFlashDiag("ui-callback-done",description.substr(0,180));
         }
         catch(error:Error)
         {
            localFlashDiag("ui-error",description.substr(0,180) + " | " + error.name + " | " + error.message + " | " + error.getStackTrace());
            throw error;
         }`;
s=change(s,before,after.replace(/\n/g,'\r\n'));source[classes[0]]=s;
s=source[classes[1]];
s=change(s,'   import flash.events.Event;','   import flash.events.Event;\r\n   import net.bigpoint.darkorbit.fui.UISystem;');
s=change(s,'            EventStreamClient.track("flash.error",{','            UISystem.localFlashDiag("command-error",String(command.getLibcomModuleId()) + " | " + error.name + " | " + error.message + " | " + error.getStackTrace());\r\n            EventStreamClient.track("flash.error",{');source[classes[1]]=s;
s=source[classes[2]];
s=change(s,'   import net.bigpoint.darkorbit.com.module.InventoryItemModule;','   import net.bigpoint.darkorbit.com.module.InventoryItemModule;\r\n   import net.bigpoint.darkorbit.fui.UISystem;');
s=change(s,'         var _loc3_:DiscountProxy = retrieveProxy(DiscountProxy.NAME) as DiscountProxy;','         UISystem.localFlashDiag("inventory-begin",String(_loc2_.inventoryItemModules.length));\r\n         var _loc3_:DiscountProxy = retrieveProxy(DiscountProxy.NAME) as DiscountProxy;');
s=change(s,'         _loc4_.inventory.dispatchItemChanged();','         _loc4_.inventory.dispatchItemChanged();\r\n         UISystem.localFlashDiag("inventory-ready",String(_loc4_.inventory.isInitialized.value));');source[classes[2]]=s;
let last=input;for(let i=0;i<classes.length;i++){const c=classes[i],file=path.join(dir,c.split('.').at(-1)+'.as');fs.writeFileSync(file,source[c]);const next=i===classes.length-1?output:path.join(dir,'stage-'+i+'.swf');run(['-replace',last,next,c,file],'compile-'+i+'.log');last=next;}
const retained=['net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyModel','net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper','net.bigpoint.darkorbit.map.hud.ship.TopDisplay'];
run(['-selectclass',classes.concat(retained).join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
const a=fs.readFileSync(input),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);if(ta.length!==tb.length)throw Error('Tag count changed');const changes=ta.flatMap((t,i)=>t.sha256===tb[i].sha256?[]:[{index:i,before:t,after:tb[i]}]);if(changes.length!==1||changes.some(c=>c.before.tag!==82||c.after.tag!==82))throw Error('Unexpected SWF changes');
const proof={classes,beforeSha256:sha(a),afterSha256:sha(b),unchangedNonAbcTags:ta.filter(t=>t.tag!==82).length,nonAbcIdentical:true,changes,scope:'bounded40requests localhost diagnostic only; no error swallowed, no inventory manufactured',limitations:['Not yet observed in actual Flash runtime.']};fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2));console.log(JSON.stringify({...proof,changes:changes.length,output}));
