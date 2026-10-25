'use strict';
const currentAfter=require('./helpers/installed-main').after;
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.join(__dirname,'..'),dir=path.join(root,'decompiled/upgrade-bulk-patch'),read=p=>fs.readFileSync(path.join(dir,p),'utf8');
const native=name=>read('verified/scripts/net/bigpoint/darkorbit/'+name);
const source=native('mvc/crafting/upgrade/view/UpgradeWindowMediator.as');
function body(source,name){const start=source.indexOf('function '+name+'(');assert.ok(start>0,name);const begin=source.indexOf('{',start);let at=begin+1,depth=1;for(;depth;at++){if(source[at]==='{')depth++;if(source[at]==='}')depth--;}return source.slice(begin+1,at-1);}
function javascript(code){return code.replace(/:\s*(?:void|String|Number|uint|int|Boolean|Object|Array|Function|Event|Error|URLLoader|URLVariables|URLRequest|UpgradeWindowMediator)\b/g,'');}
function nativeMethod(name,globals={}){return new Function('event',...Object.keys(globals),'with(this){'+javascript(body(source,name))+'}');}
function fixture(){const buttons=Object.fromEntries(['weapons','shields','refresh','build'].map(k=>[k,{text:'',enabled:false}])),label={text:''};return{_bulkWeapons:false,_bulkShields:false,_bulkBuilding:false,_bulkQuote:null,_bulkVersion:0,_bulkLoader:null,_bulkExpiryTimer:0,expireBulkQuote(){this._bulkQuote=null;},buttons,label,requests:[],bulkButton(k){return buttons[k];},bulkLabel(){return label;},drawBulkSelection(){nativeMethod('drawBulkSelection').call(this,null);},refreshBulkQuote(){this.requests.push(['quote']);},requestBulkUpgrade(...args){this.requests.push(args);}};}
test('actual compiled bulk controls gate building behind explicit valid quote and consume token before request',()=>{
 const state=fixture();let now=1000;function Clock(){this.time=now;}
 const build=nativeMethod('handleBulkBuild',{Date:Clock,clearTimeout:()=>{}}),invoke=()=>build.call(state,null,Clock,()=>{});
 invoke();assert.deepEqual(state.requests,[]);
 state._bulkQuote={canBuild:false,token:'no',expiresAt:2000};invoke();assert.deepEqual(state.requests,[]);
 state._bulkQuote={canBuild:true,token:'quoted-token',expiresAt:2000};invoke();assert.deepEqual(state.requests,[['build','quoted-token']]);assert.equal(state._bulkQuote,null);assert.equal(state._bulkBuilding,true);assert.equal(state.buttons.build.enabled,false);
 invoke();assert.equal(state.requests.length,1,'second click cannot send a second build');
 state._bulkBuilding=false;state._bulkQuote={canBuild:true,token:'expired',expiresAt:999};invoke();assert.deepEqual(state.requests.at(-1),['quote'],'expired click requotes, never silently buys at new price');
});
test('compiled all-weapons and all-shields selectors combine without excluding each other',()=>{
 const state=fixture();nativeMethod('handleBulkWeapons').call(state,null);assert.equal(state._bulkWeapons,true);assert.equal(state._bulkShields,false);
 nativeMethod('handleBulkShields').call(state,null);assert.equal(state._bulkWeapons,true);assert.equal(state._bulkShields,true);
 state._bulkBuilding=true;nativeMethod('handleBulkWeapons').call(state,null);assert.equal(state._bulkWeapons,true,'selection locked during mutation');
});
test('compiled native HTTP flow displays authoritative quote total, ignores stale responses and handles errors',()=>{
 const state=fixture(),loaders=[];let now=1000;function Clock(){this.time=now;}
 class Loader{constructor(){this.listeners={};loaders.push(this);}addEventListener(name,fn){this.listeners[name]=fn;}load(request){this.request=request;}close(){this.closed=true;}}
 function Request(url){this.url=url;}function Variables(){}
 const values={URLLoader:Loader,URLRequest:Request,URLRequestMethod:{POST:'POST'},URLVariables:Variables,Event:{COMPLETE:'complete'},IOErrorEvent:{IO_ERROR:'ioerror'},SecurityErrorEvent:{SECURITY_ERROR:'securityerror'},Date:Clock,setTimeout:()=>7,JSON};
 const request=new Function('action','token',...Object.keys(values),'with(this){'+javascript(body(source,'requestBulkUpgrade'))+'}');
 const send=(action,token)=>request.call(state,action,token,...Object.values(values));
 state._bulkWeapons=state._bulkShields=true;send('quote','');const first=loaders.at(-1);
 assert.equal(first.request.url,'http://127.0.0.1:8095/ajax/upgrade-bulk.php');assert.equal(first.request.method,'POST');assert.equal(first.request.data.categories,'weapons,shields');assert.deepEqual(Object.keys(first.request.data).sort(),['action','categories']);
 first.data=JSON.stringify({ok:true,token:'server-token',itemCount:47,totalModules:3000,availableModules:4000,canBuild:true,expiresAt:121000});first.listeners.complete({});
 assert.equal(state._bulkQuote.token,'server-token');assert.match(state.label.text,/47 eşya · Toplam 3000 Upgrade Module\nSende: 4000/);assert.equal(state.buttons.build.enabled,true);
 state._bulkVersion++;first.data=JSON.stringify({ok:true,token:'stale',itemCount:99,totalModules:999,canBuild:true});first.listeners.complete({});assert.equal(state._bulkQuote.token,'server-token','older response cannot replace current quote');
 send('build','server-token');const build=loaders.at(-1);assert.deepEqual(Object.assign({},build.request.data),{action:'build',token:'server-token'});
 build.data=JSON.stringify({ok:false,message:'Eşyalar değişti; yenile.'});build.listeners.complete({});assert.equal(state._bulkQuote,null);assert.equal(state.label.text,'Eşyalar değişti; yenile.');assert.equal(state.buttons.build.enabled,false);
 send('quote','');loaders.at(-1).listeners.ioerror({});assert.equal(state._bulkQuote,null);assert.match(state.label.text,/Bağlantı/);
});
test('native upgrade XML keeps themed bulk selection and visible cost inside existing tab bounds',()=>{
 const xml=fs.readFileSync(path.join(root,'client/spacemap/graphics/ui/windows/crafting/upgrade/upgradeWindowUI.xml'),'utf8');
 for(const name of ['bulkUpgrade','weapons','shields','refresh','cost','build'])assert.ok(xml.includes('name="'+name+'"'));
 assert.match(xml,/<button name="build"[^>]+enabled="false"[^>]+commonui_scale9_button_green/);
 assert.match(xml,/<label name="cost"[^>]+width="315"[^>]+height="32"/);
 assert.match(xml,/standardViewContainer"[\s\S]*?marginTop="69"/);assert.match(xml,/upgradeContainer"[\s\S]*?marginTop="12"/);
 const tag=name=>new RegExp('<(?:container|Grid) name="'+name+'"[^>]*>').exec(xml)?.[0],attr=(t,name)=>Number(new RegExp(name+'="(\\d+)"').exec(t)[1]);
 const holder=tag('itemGridContainer'),grid=tag('upgradeItemsGrid');
 assert.match(holder,/autoSizeHeight="false"/);assert.match(grid,/autoSizeHeight="false"/);
 assert.ok(attr(holder,'height')>=attr(grid,'marginTop')+attr(grid,'height'),'vertical parent must reserve the full grid viewport even with thousands of items');
 assert.ok(69+4+43+2+5+attr(holder,'height')+12+128<=450,'fixed grid and full upgrade footer fit inside the window');
 assert.ok(source.indexOf('this.initBulkUpgrade();')>source.indexOf('this._upgradeModel.changed.add(this.invalidateTargets);'));
});
test('recipe subscriptions retain upgrade definitions and recipe packet sorts once rather than per entry',()=>{
 const proxy=native('mvc/crafting/upgrade/model/UpgradeProxy.as');assert.match(proxy,/recipeAdded\.add\(this\.handleRecipeAdded\)/);assert.match(proxy,/recipeRemoved\.add\(this\.handleRecipeRemoved\)/);assert.doesNotMatch(proxy,/recipeAdded\.add\(this\.handleRecipeRemoved\)/);
 const model=native('mvc/crafting/assembly/model/AssemblyModel.as'),batch=native('mvc/crafting/assembly/model/AssemblyProxy.as');
 assert.doesNotMatch(body(model,'update'),/sortModel/);assert.equal((body(batch,'updateFromServer').match(/sortModel\(\)/g)||[]).length,1);
 assert.ok(body(batch,'updateFromServer').indexOf('sortModel()')>body(batch,'updateFromServer').indexOf('_loc4_++;'));
 const before=read('before/scripts/net/bigpoint/darkorbit/mvc/crafting/assembly/model/AssemblyModel.as');assert.equal(body(model,'applyLocalModuleCosts'),body(before,'applyLocalModuleCosts'),'662 module-cost overrides preserved');
});
test('installed native bulk artifact follows drone master patch and keeps prior unrelated classes intact',()=>{
 const p=JSON.parse(read('evidence.json')),prior=JSON.parse(fs.readFileSync(path.join(root,'decompiled/drone-master-toggle-patch/evidence.json'),'utf8'));
 assert.equal(p.beforeSha256,prior.afterSha256);assert.equal(currentAfter(p.afterSha256),crypto.createHash('sha256').update(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))).digest('hex'));assert.equal(p.nonAbcIdentical,true);assert.equal(p.unchangedNonAbcTags,256);assert.equal(p.changes.length,1);
 for(const file of ['mvc/settingsFUI/model/SettingsWindowFUIProxy.as','mvc/crafting/assembly/model/AssemblyInventoryIndex.as','managers/keyboardManager/KeyboardMapper.as','map/hud/ship/TopDisplay.as'])assert.equal(native(file),fs.readFileSync(path.join(root,'decompiled/drone-master-toggle-patch/verified/scripts/net/bigpoint/darkorbit',file),'utf8'));
});
