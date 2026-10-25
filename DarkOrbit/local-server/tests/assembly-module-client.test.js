'use strict';
const currentAfter=require('./helpers/installed-main').after;
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.join(__dirname,'..'),dir=path.join(root,'decompiled/assembly-module-patch'),policy=require('../game/module-policy');
const read=p=>fs.readFileSync(path.join(root,p),'utf8'),digest=b=>crypto.createHash('sha256').update(b).digest('hex');
const native=c=>fs.readFileSync(path.join(dir,'verified/scripts/net/bigpoint/darkorbit',c),'utf8');

test('installed native module artifact continues exact prior MAIN and has matching shared costs',()=>{
 const p=JSON.parse(fs.readFileSync(path.join(dir,'evidence.json'),'utf8'));
 const diagnostics=JSON.parse(read('decompiled/assembly-bootstrap-diagnostics/evidence.json'));
 const nullTraits=JSON.parse(read('decompiled/assembly-null-traits-patch/evidence.json'));
 const droneToggle=JSON.parse(read('decompiled/drone-master-toggle-patch/evidence.json'));
 const bulk=JSON.parse(read('decompiled/upgrade-bulk-patch/evidence.json'));assert.equal(bulk.beforeSha256,droneToggle.afterSha256);
 assert.equal(digest(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))),currentAfter(bulk.afterSha256));
 assert.equal(droneToggle.beforeSha256,nullTraits.afterSha256);
 assert.equal(nullTraits.beforeSha256,diagnostics.afterSha256);
 assert.equal(diagnostics.beforeSha256,p.afterSha256);
 assert.equal(p.beforeSha256,JSON.parse(read('decompiled/map-hotkey-patch/evidence.json')).afterSha256);
 assert.equal(p.nonAbcIdentical,true);assert.equal(p.unchangedNonAbcTags,256);assert.equal(p.changes.length,1);
 const recipes=policy.transformRecipes(require('../docs/client-map.items.json').items),expected={};
 for(const[id,r]of Object.entries(recipes))if([policy.UPGRADE,policy.CONVERT].includes(r.costs?.[0]?.parts?.[0]?.lootID))expected[id]=[r.costs[0].parts[0].lootID,r.costs.map(c=>[c.parts[0].ammount,c.skipCosts?.[0]?.ammount||0])];
 assert.deepEqual(Object.keys(p.overrides),Object.keys(expected));
 for(const[id,costs]of Object.entries(expected))assert.deepEqual(p.overrides[id],costs,'native shared cost mismatch: '+id);
 const s=native('mvc/crafting/assembly/model/AssemblyModel.as');
 assert.ok(s.indexOf('applyLocalModuleCosts();')<s.indexOf('public function update('));
 for(const d of policy.DEFINITIONS){assert.ok(s.includes('a.lootId = "'+d.id+'"'));assert.ok(s.includes('a.uridium = 10000;'));}
 assert.match(s,/ItemDataProvider\.items\[a\.lootId\] = new Item\(a,t\)/);
 assert.match(s,/st\.maxQuantity = 1000000000/);assert.match(s,/r\.costScalingFactor = 1/);
});

test('native inventory initialization repairs missing assembly discount dependency before item conversion',()=>{
 const s=native('net/netty/handlers/items/UserInventoryHandler.as');
 assert.ok(s.indexOf('sendNotification(AssemblyNotifications.INIT);')<s.indexOf('_loc3_.updateFromServer(_loc2_);'));
 assert.ok(s.indexOf('registerProxy(_loc3_ = new DiscountProxy());')<s.indexOf('ItemVO.fromModule(_loc7_)'));
 const overview=native('mvc/crafting/overview/view/CraftingOverviewWindowMediator.as');
 assert.match(overview,/var selected:Vector\.<Object>/);
 assert.ok(overview.indexOf('selected.length == 0')<overview.indexOf('this.hideAllTabs();',overview.indexOf('private function handleTabChanged')));
 assert.match(overview,/if\(!\(this\.TAB2CONTENT\[_loc2_\] is DisplayObject\)\)/);
 const assembly=native('mvc/crafting/assembly/view/AssemblyWindowMediator.as');
 assert.match(assembly,/_loc1_ \? _loc1_\.getEventWithId[\s\S]*?as PermaFrostFissurEvent : null/);
});

test('encoded inventory first and recipe first both release the native loading gate after lazy bootstrap',()=>{
 // Source-bounded initialization projection: INIT's first macro command is
 // synchronous; the six XML views finish later. This exercises the temporal
 // dependency and native codec, not the Flash renderer.
 const handler=native('net/netty/handlers/items/UserInventoryHandler.as'),codec=require('../game/codec/codec');
 const commands=[
  {_:'AssemblyRecipeContentModule',recipes:[]},
  {_:'UserInventoryModule',inventoryItemModules:[{_:'InventoryItemModule',lootId:policy.UPGRADE,itemId:70001,amount:3,upgradeLevel:0,hangarId:0,extAttributes:[],inventoryItemAttributes:[]}],activePremiumDiscount:0,activeRebateSubDiscount:0,activeHappyUpgradeDiscount:0}
 ].map(c=>codec.decode(codec.encode(c)).obj);
 function project(sequence,selfInit){
  const state={discount:false,items:new Set(),initialized:false,errors:[]};
  const init=()=>{state.discount=true;for(const d of policy.DEFINITIONS)state.items.add(d.id);};
  for(const c of sequence){
   if(c._==='AssemblyRecipeContentModule')init();
   if(c._==='UserInventoryModule'){
    if(!state.discount&&selfInit)init();
    if(!state.discount){state.errors.push('null DiscountProxy');continue;}
    for(const item of c.inventoryItemModules)assert.ok(state.items.has(item.lootId),'local module registered before native ItemVO conversion');
    state.initialized=true;
   }
  }
  return state;
 }
 const selfInit=handler.includes('sendNotification(AssemblyNotifications.INIT);');
 for(const sequence of [commands,commands.toReversed(),[...commands.toReversed(),...commands]]){
  const state=project(sequence,selfInit);assert.equal(state.initialized,true);assert.deepEqual(state.errors,[]);
 }
 const old=project(commands.toReversed(),false);assert.equal(old.initialized,false);assert.deepEqual(old.errors,['null DiscountProxy']);
});

test('native module names and every requested image size are in real resource registries',()=>{
 const locale=read('client/spacemap/templates/tr/resource_items.xml'),manifest=read('client/do_img/global/xml/resource_items.xml');
 for(const d of policy.DEFINITIONS){
  assert.ok(locale.includes('name="items_'+d.id+'_fullname"><![CDATA['+d.name+']]'));
  const name=d.id.slice('resource_'.length);
  for(const size of ['30x30','100x100','icon']){
   assert.ok(manifest.includes('id="'+name+'_'+size+'" location="items_resource"'));
   const b=fs.readFileSync(path.join(root,'client/do_img/global/items/resource',name+'_'+size+'.png'));
   assert.equal(b.subarray(1,4).toString(),'PNG');
  }
 }
});
