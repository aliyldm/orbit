'use strict';
const currentAfter=require('./helpers/installed-main').after;
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.join(__dirname,'..'),dir=path.join(root,'decompiled/assembly-null-traits-patch'),relative='scripts/net/bigpoint/darkorbit/mvc/crafting/assembly/model/AssemblyInventoryIndex.as';
const read=p=>fs.readFileSync(path.join(dir,p),'utf8');
function actualUpdateMethod(source){
 const start=source.indexOf('public function updateItem('),body=source.indexOf('{',start);let depth=1,at=body+1;
 for(;depth;at++){if(source[at]==='{')depth++;else if(source[at]==='}')depth--;}
 const code=source.slice(body+1,at-1).replace(/var (\w+):(String|Number|Object)/g,'var $1');
 return new Function('param1','param2','TraitTypes',code);
}
function index(){return{items:{},blockedTargets:{},amounts:{},addAmount(id,n){this.amounts[id]=(this.amounts[id]||0)+n;}};}
test('compiled native updater counts no-trait Gold Pass and resources while retaining equipped and upgrade locks',()=>{
 const original=actualUpdateMethod(read('before/'+relative)),fixed=actualUpdateMethod(read('verified/'+relative));
 const traits={UPGRADABLE:'upgradable'},gold={id:1900,lootID:'resource_gold-pass',amount:1,isEquipped:false,item:{traits:null}};
 assert.throws(()=>original.call(index(),gold.id,gold,traits),TypeError,'actual former native method dereferences null ItemTraits');
 const state=index();fixed.call(state,gold.id,gold,traits);assert.equal(state.amounts[gold.lootID],1);
 const currency={...gold,id:1901,lootID:'currency_uridium',amount:500};fixed.call(state,currency.id,currency,traits);assert.equal(state.amounts[currency.lootID],500);
 const resource={...gold,id:1902,lootID:'resource_convert-module',amount:12,item:{traits:{getTraitByType:()=>null}}};fixed.call(state,resource.id,resource,traits);assert.equal(state.amounts[resource.lootID],12);
 const equipped={...resource,id:1903,amount:4,isEquipped:true};fixed.call(state,equipped.id,equipped,traits);assert.equal(state.amounts[resource.lootID],12);
 const laser={...gold,id:1904,lootID:'equipment_weapon_laser_lf-4',amount:1,item:{traits:{getTraitByType:()=>({})}}};state.blockedTargets[laser.id]=true;fixed.call(state,laser.id,laser,traits);assert.equal(state.amounts[laser.lootID],0);
 delete state.blockedTargets[laser.id];fixed.call(state,laser.id,laser,traits);assert.equal(state.amounts[laser.lootID],1);
 fixed.call(state,laser.id,null,traits);assert.equal(state.amounts[laser.lootID],0);
 const noItem={...gold,id:1905,item:null};fixed.call(state,noItem.id,noItem,traits);assert.equal(state.amounts[gold.lootID],2);
 const provider=fs.readFileSync(path.join(root,'decompiled/main/scripts/net/bigpoint/darkorbit/items/ItemDataProvider.as'),'utf8');
 assert.match(provider,/_loc32_ = null;\s*_loc\d+_ = new Item\([^\n]+\);\s*items\["resource_gold-pass"\]/);
});
test('installed native null-traits correction follows diagnostic artifact and preserves every media tag',()=>{
 const p=JSON.parse(read('evidence.json')),prior=JSON.parse(fs.readFileSync(path.join(root,'decompiled/assembly-bootstrap-diagnostics/evidence.json'),'utf8'));
 const droneToggle=JSON.parse(fs.readFileSync(path.join(root,'decompiled/drone-master-toggle-patch/evidence.json'),'utf8'));
 const bulk=JSON.parse(fs.readFileSync(path.join(root,'decompiled/upgrade-bulk-patch/evidence.json'),'utf8'));
 assert.equal(p.beforeSha256,prior.afterSha256);assert.equal(droneToggle.beforeSha256,p.afterSha256);assert.equal(bulk.beforeSha256,droneToggle.afterSha256);assert.equal(currentAfter(bulk.afterSha256),crypto.createHash('sha256').update(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))).digest('hex'));
 assert.equal(p.nonAbcIdentical,true);assert.equal(p.unchangedNonAbcTags,256);assert.equal(p.changes.length,1);
});
