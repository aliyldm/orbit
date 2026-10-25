'use strict';
// Narrow native client adaptation for the explicitly requested local module
// economy. Compile from the installed SWF so all earlier patches survive.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/assembly-module-patch');
const policy=require('../game/module-policy'),meta=require('../docs/client-map.items.json').items;
const recipes=policy.transformRecipes(meta);
const java=process.env.DARKORBIT_JAVA||'C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar=process.env.DARKORBIT_FFDEC||'D:\\swfde\\ffdec.jar';
const input=path.resolve(process.argv[2]||path.join(dir,'main-before.swf')),output=path.resolve(process.argv[3]||path.join(dir,'main-patched.swf'));
const classes=['net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyModel','net.bigpoint.darkorbit.net.netty.handlers.items.UserInventoryHandler','net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingOverviewWindowMediator','net.bigpoint.darkorbit.mvc.crafting.assembly.view.AssemblyWindowMediator'];
const sha=b=>crypto.createHash('sha256').update(b).digest('hex');
const relative=c=>path.join('scripts',...c.split('.'))+'.as';
fs.mkdirSync(dir,{recursive:true});
function run(args,name){const r=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,name),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS failed: '+name);}
function change(s,from,to){if(!s.includes(from))throw Error('Missing source anchor '+from.slice(0,70));return s.replace(from,to);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);if(b.toString('ascii',0,3)!=='FWS')throw Error('Unsupported compression');let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}if(at+n>b.length)throw Error('Truncated tag');out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
run(['-selectclass',classes.join(','),'-export','script',path.join(dir,'before'),input],'export.log');
const source=Object.fromEntries(classes.map(c=>[c,fs.readFileSync(path.join(dir,'before',relative(c)),'utf8')]));
const overrides={};
for(const [id,r]of Object.entries(recipes)){
 if(!r.costs?.length||r.costs[0].parts?.[0]?.lootID!==policy.UPGRADE&&r.costs[0].parts?.[0]?.lootID!==policy.CONVERT)continue;
 overrides[id]=[r.costs[0].parts[0].lootID,r.costs.map(c=>[c.parts[0].ammount,c.skipCosts?.[0]?.ammount||0])];
}
let s=source[classes[0]];
const imports=['net.bigpoint.darkorbit.items.item.Item','net.bigpoint.darkorbit.items.item.ItemTraits','net.bigpoint.darkorbit.items.item.attributes.GeneralAttributes','net.bigpoint.darkorbit.items.item.traits.StackableTrait'];
s=change(s,'   import flash.utils.setTimeout;', '   import flash.utils.setTimeout;\r\n'+imports.map(c=>'   import '+c+';').join('\r\n'));
s=change(s,'      public function AssemblyModel()\r\n      {\r\n         super();\r\n      }','      public function AssemblyModel()\r\n      {\r\n         super();\r\n         applyLocalModuleCosts();\r\n      }');
const register=policy.DEFINITIONS.map(d=>`         a = new GeneralAttributes();\n         a.lootId = ${JSON.stringify(d.id)};\n         a.typeClass = "net.bigpoint.darkorbit.asset.item.ItemType";\n         a.typeValue = ${JSON.stringify(meta[d.id].typeValue)};\n         a.uridium = ${d.price};\n         a.maxQuantity = 0;\n         t = new ItemTraits();\n         st = new StackableTrait();\n         st.maxQuantity = 1000000000;\n         st.type = "stackable";\n         t.add(st);\n         ItemDataProvider.items[a.lootId] = new Item(a,t);`).join('\n');
const method=`      private static var _localModulesApplied:Boolean = false;

      private static function applyLocalModuleCosts() : void
      {
         if(_localModulesApplied) return;
         _localModulesApplied = true;
         var a:GeneralAttributes;
         var t:ItemTraits;
         var st:StackableTrait;
${register}
         var settings:Object = ${JSON.stringify(overrides)};
         var id:String;
         var r:RecipeAttributes;
         var values:Array;
         var c:RecipeCosts;
         var part:BuildPart;
         var i:int;
         for(id in settings)
         {
            r = ItemDataProvider.getItem(id).attributes as RecipeAttributes;
            values = settings[id] as Array;
            r.costScalingFactor = 1;
            for(i = 0; i < r.costs.length; i++)
            {
               c = r.costs[i];
               c.parts = new Vector.<BuildPart>();
               part = new BuildPart();
               part.lootID = values[0];
               part.ammount = values[1][i][0];
               c.parts.push(part);
               c.skipCosts = new Vector.<BuildPart>();
               if(values[1][i][1] > 0)
               {
                  part = new BuildPart();
                  part.lootID = values[0];
                  part.ammount = values[1][i][1];
                  c.skipCosts.push(part);
               }
            }
         }
      }

`;
s=change(s,'      public function get currentRecipes()',method.replace(/\n/g,'\r\n')+'      public function get currentRecipes()');
source[classes[0]]=s;
s=source[classes[1]];
s=change(s,'   import net.bigpoint.darkorbit.mvc.discount.model.DiscountProxy;','   import net.bigpoint.darkorbit.mvc.discount.model.DiscountProxy;\r\n   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;');
s=change(s,'         _loc3_.updateFromServer(_loc2_);','         if(!_loc3_)\r\n         {\r\n            sendNotification(AssemblyNotifications.INIT);\r\n            _loc3_ = retrieveProxy(DiscountProxy.NAME) as DiscountProxy;\r\n         }\r\n         if(!_loc3_)\r\n         {\r\n            registerProxy(_loc3_ = new DiscountProxy());\r\n         }\r\n         _loc3_.updateFromServer(_loc2_);');
source[classes[1]]=s;
s=source[classes[2]];
s=change(s,'         this.hideAllTabs();\r\n         var _loc2_:String = String(this._craftingOverviewView.tabBar.getSelectedItemsData()[0]);','         var selected:Vector.<Object> = this._craftingOverviewView.tabBar.getSelectedItemsData();\r\n         if(selected == null || selected.length == 0)\r\n         {\r\n            return;\r\n         }\r\n         var _loc2_:String = String(selected[0]);\r\n         if(!(this.TAB2CONTENT[_loc2_] is DisplayObject))\r\n         {\r\n            return;\r\n         }\r\n         this.hideAllTabs();');
source[classes[2]]=s;
s=source[classes[3]];
s=change(s,'var _loc2_:PermaFrostFissurEvent = _loc1_.getEventWithId(EventActivationStateCommand.EVENTTYPE_PERMAFROST_FISSURE_ASSEMBLY_WINDOW) as PermaFrostFissurEvent;','var _loc2_:PermaFrostFissurEvent = _loc1_ ? _loc1_.getEventWithId(EventActivationStateCommand.EVENTTYPE_PERMAFROST_FISSURE_ASSEMBLY_WINDOW) as PermaFrostFissurEvent : null;');
source[classes[3]]=s;
let last=input;
for(let i=0;i<classes.length;i++){
 const c=classes[i],file=path.join(dir,c.split('.').at(-1)+'.as');fs.writeFileSync(file,source[c]);
 const next=i===classes.length-1?output:path.join(dir,'stage-'+i+'.swf');
 run(['-replace',last,next,c,file],'compile-'+i+'.log');last=next;
}
const retainedClasses=['net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper','net.bigpoint.darkorbit.map.hud.ship.TopDisplay'];
run(['-selectclass',classes.concat(retainedClasses).join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
const verified=Object.fromEntries(classes.map(c=>[c,fs.readFileSync(path.join(dir,'verified',relative(c)),'utf8')]));
if(!verified[classes[0]].includes('resource_upgrade-module')||!verified[classes[0]].includes('applyLocalModuleCosts();')||!verified[classes[1]].includes('sendNotification(AssemblyNotifications.INIT);')||!verified[classes[2]].includes('selected.length == 0')||!verified[classes[3]].includes('as PermaFrostFissurEvent : null'))throw Error('Compiled client guards not recovered');
const a=fs.readFileSync(input),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);
if(ta.length!==tb.length)throw Error('Tag count changed');
const changes=ta.flatMap((t,i)=>t.sha256===tb[i].sha256?[]:[{index:i,before:t,after:tb[i]}]);
if(changes.length!==1||changes.some(c=>c.before.tag!==82||c.after.tag!==82))throw Error('Unexpected SWF changes');
const proof={classes,beforeSha256:sha(a),afterSha256:sha(b),policySha256:sha(fs.readFileSync(path.join(root,'game/module-policy.js'))),overrides,definitions:policy.DEFINITIONS,unchangedNonAbcTags:ta.filter(t=>t.tag!==82).length,nonAbcIdentical:true,changes,limitations:['Compiled and re-decompiled actual classes; native Flash renderer not visually exercised.']};
fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2));console.log(JSON.stringify({...proof,overrides:Object.keys(overrides).length,changes:changes.length,output}));
