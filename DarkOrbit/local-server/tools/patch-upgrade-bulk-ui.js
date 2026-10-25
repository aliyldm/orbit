'use strict';
// In-window native bulk upgrade controls, authenticated quote/build HTTP flow,
// and source-established target recipe subscription / batch sorting fixes.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/upgrade-bulk-patch');
const java=process.env.DARKORBIT_JAVA||'C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar=process.env.DARKORBIT_FFDEC||'D:\\swfde\\ffdec.jar';
const input=path.resolve(process.argv[2]||path.join(dir,'main-before.swf')),output=path.resolve(process.argv[3]||path.join(dir,'main-patched.swf'));
const classes=['net.bigpoint.darkorbit.mvc.crafting.upgrade.view.UpgradeWindowMediator','net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeProxy','net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyModel','net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy'];
const sha=b=>crypto.createHash('sha256').update(b).digest('hex'),relative=c=>path.join('scripts',...c.split('.'))+'.as';fs.mkdirSync(dir,{recursive:true});
function run(args,name){const r=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,name),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error('JPEXS failed: '+name);}
function change(s,a,b){if(!s.includes(a))throw Error('Missing source anchor '+a.slice(0,90));return s.replace(a,b);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}out.push({tag,sha256:sha(b.subarray(at,at+n))});at+=n;}return out;}
run(['-selectclass',classes.join(','),'-export','script',path.join(dir,'before'),input],'export.log');
const source=Object.fromEntries(classes.map(c=>[c,fs.readFileSync(path.join(dir,'before',relative(c)),'utf8')]));
let s=source[classes[0]];
const imports=['flash.events.IOErrorEvent','flash.events.SecurityErrorEvent','flash.net.URLLoader','flash.net.URLRequest','flash.net.URLRequestMethod','flash.net.URLVariables','net.bigpoint.darkorbit.fui.components.buttons.button.Button','net.bigpoint.darkorbit.fui.components.text.label.Label'];
s=change(s,'   import flash.events.MouseEvent;','   import flash.events.MouseEvent;\r\n'+imports.map(c=>'   import '+c+';').join('\r\n'));
const methods=`      private var _bulkWeapons:Boolean = false;
      private var _bulkShields:Boolean = false;
      private var _bulkVersion:uint = 0;
      private var _bulkQuote:Object = null;
      private var _bulkBuilding:Boolean = false;
      private var _bulkLoader:URLLoader;
      private var _bulkExpiryTimer:uint;

      private function bulkButton(name:String) : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.bulkUpgrade." + name,this.view) as Button;
      }

      private function bulkLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.bulkUpgrade.cost",this.view) as Label;
      }

      private function initBulkUpgrade() : void
      {
         if(!this.bulkButton("weapons")) return;
         this.bulkButton("weapons").addEventListener(MouseEvent.CLICK,this.handleBulkWeapons);
         this.bulkButton("shields").addEventListener(MouseEvent.CLICK,this.handleBulkShields);
         this.bulkButton("refresh").addEventListener(MouseEvent.CLICK,this.handleBulkRefresh);
         this.bulkButton("build").addEventListener(MouseEvent.CLICK,this.handleBulkBuild);
         this.drawBulkSelection();
         this.bulkLabel().text = "Maliyet için tüm silahları ve/veya kalkanları seç.";
      }

      private function drawBulkSelection() : void
      {
         this.bulkButton("weapons").text = (this._bulkWeapons ? "[X] " : "[ ] ") + "Tüm silahlar";
         this.bulkButton("shields").text = (this._bulkShields ? "[X] " : "[ ] ") + "Tüm kalkanlar";
         this.bulkButton("weapons").enabled = !this._bulkBuilding;
         this.bulkButton("shields").enabled = !this._bulkBuilding;
         this.bulkButton("refresh").enabled = !this._bulkBuilding;
         this.bulkButton("build").enabled = !this._bulkBuilding && this._bulkQuote != null && this._bulkQuote.canBuild == true;
      }

      private function handleBulkWeapons(event:MouseEvent) : void
      {
         if(this._bulkBuilding) return;
         this._bulkWeapons = !this._bulkWeapons;
         this.refreshBulkQuote();
      }

      private function handleBulkShields(event:MouseEvent) : void
      {
         if(this._bulkBuilding) return;
         this._bulkShields = !this._bulkShields;
         this.refreshBulkQuote();
      }

      private function handleBulkRefresh(event:MouseEvent) : void
      {
         if(!this._bulkBuilding) this.refreshBulkQuote();
      }

      private function refreshBulkQuote() : void
      {
         clearTimeout(this._bulkExpiryTimer);
         this._bulkQuote = null;
         this._bulkVersion++;
         this.drawBulkSelection();
         if(!this._bulkWeapons && !this._bulkShields)
         {
            this.bulkLabel().text = "Maliyet için tüm silahları ve/veya kalkanları seç.";
            return;
         }
         this.bulkLabel().text = "Toplam Upgrade Module maliyeti hesaplanıyor...";
         this.requestBulkUpgrade("quote","");
      }

      private function handleBulkBuild(event:MouseEvent) : void
      {
         if(this._bulkBuilding || this._bulkQuote == null || this._bulkQuote.canBuild != true) return;
         if(new Date().time >= Number(this._bulkQuote.expiresAt))
         {
            this.refreshBulkQuote();
            return;
         }
         var token:String = String(this._bulkQuote.token);
         clearTimeout(this._bulkExpiryTimer);
         this._bulkQuote = null;
         this._bulkBuilding = true;
         this.drawBulkSelection();
         this.bulkLabel().text = "Seçilen eşyalar maksimum seviyeleri için başlatılıyor...";
         this.requestBulkUpgrade("build",token);
      }

      private function requestBulkUpgrade(action:String, token:String) : void
      {
         if(this._bulkLoader != null)
         {
            try { this._bulkLoader.close(); } catch(ignored:Error) {}
         }
         var loader:URLLoader = new URLLoader();
         this._bulkLoader = loader;
         var version:uint = this._bulkVersion;
         var variables:URLVariables = new URLVariables();
         variables.action = action;
         if(action == "quote")
         {
            var categories:Array = [];
            if(this._bulkWeapons) categories.push("weapons");
            if(this._bulkShields) categories.push("shields");
            variables.categories = categories.join(",");
         }
         else variables.token = token;
         var request:URLRequest = new URLRequest("http://127.0.0.1:8095/ajax/upgrade-bulk.php");
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader.addEventListener(Event.COMPLETE,function(event:Event):void
         {
            if(version != _bulkVersion) return;
            _bulkLoader = null;
            _bulkBuilding = false;
            try
            {
               var response:Object = JSON.parse(String(loader.data));
               if(response.ok != true)
               {
                  _bulkQuote = null;
                  bulkLabel().text = response.message ? String(response.message) : "İşlem tamamlanamadı. Yenile.";
               }
               else if(action == "quote")
               {
                  _bulkQuote = response;
                  bulkLabel().text = String(response.itemCount) + " eşya · Toplam " + String(response.totalModules) + " Upgrade Module\\nSende: " + String(response.availableModules) + (response.canBuild ? " · Her eşya kendi maksimumuna" : " · " + String(response.message || "Modül yetersiz / uygun eşya yok"));
                  _bulkExpiryTimer = setTimeout(expireBulkQuote,Math.max(1,Number(response.expiresAt) - new Date().time));
               }
               else
               {
                  _bulkQuote = null;
                  bulkLabel().text = response.message ? String(response.message) : "Toplu geliştirme başlatıldı. Süre sonunda Tümünü topla.";
               }
            }
            catch(error:Error)
            {
               _bulkQuote = null;
               bulkLabel().text = "Sunucu yanıtı okunamadı. Durumu yenile.";
            }
            drawBulkSelection();
         });
         var failed:Function = function(event:Event):void
         {
            if(version != _bulkVersion) return;
            _bulkLoader = null;
            _bulkQuote = null;
            _bulkBuilding = false;
            bulkLabel().text = "Bağlantı kurulamadı. Durumu yenile.";
            drawBulkSelection();
         };
         loader.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         try { loader.load(request); }
         catch(error:Error) { failed(null); }
      }

      private function expireBulkQuote() : void
      {
         this._bulkQuote = null;
         this.bulkLabel().text = "Maliyet süresi doldu. Başlatmadan önce Yenile.";
         this.drawBulkSelection();
      }

`;
s=change(s,'      private function handleRightClicked(',methods.replace(/\n/g,'\r\n')+'      private function handleRightClicked(');
s=change(s,'         this._upgradeModel.changed.add(this.invalidateTargets);\r\n         this.invalidateTargets();','         this._upgradeModel.changed.add(this.invalidateTargets);\r\n         this.initBulkUpgrade();\r\n         this.invalidateTargets();');
source[classes[0]]=s;
s=source[classes[1]];s=change(s,'this._assemblyModel.recipeAdded.add(this.handleRecipeRemoved);','this._assemblyModel.recipeRemoved.add(this.handleRecipeRemoved);');source[classes[1]]=s;
s=source[classes[2]];s=change(s,'         _loc2_.type = this.createType(param1.type);\r\n         this.sortModel();','         _loc2_.type = this.createType(param1.type);');source[classes[2]]=s;
s=source[classes[3]];s=change(s,'         this.refreshRecipes();','         this.recipes.sortModel();\r\n         this.refreshRecipes();');source[classes[3]]=s;
let last=input;for(let i=0;i<classes.length;i++){const c=classes[i],file=path.join(dir,c.split('.').at(-1)+'.as');fs.writeFileSync(file,source[c]);const next=i===classes.length-1?output:path.join(dir,'stage-'+i+'.swf');run(['-replace',last,next,c,file],'compile-'+i+'.log');last=next;}
const retained=['net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy','net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyInventoryIndex','net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper','net.bigpoint.darkorbit.map.hud.ship.TopDisplay'];
run(['-selectclass',classes.concat(retained).join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
const a=fs.readFileSync(input),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);if(ta.length!==tb.length)throw Error('Tag count changed');const changes=ta.flatMap((t,i)=>t.sha256===tb[i].sha256?[]:[{index:i,before:t,after:tb[i]}]);if(changes.length!==1||changes.some(c=>c.before.tag!==82||c.after.tag!==82))throw Error('Unexpected SWF changes');
const proof={classes,beforeSha256:sha(a),afterSha256:sha(b),unchangedNonAbcTags:ta.filter(t=>t.tag!==82).length,nonAbcIdentical:true,changes,scope:'Native Upgrade category selection + server-authoritative quote before build; recipe removed signal correction; sort once per incoming recipe batch.',limitations:['No computer-use or visual Flash verification after user stopped automation.']};fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify(proof,null,2));console.log(JSON.stringify({...proof,changes:changes.length,output}));
