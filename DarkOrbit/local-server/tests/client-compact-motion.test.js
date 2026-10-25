'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib');
const root=path.resolve(__dirname,'..'),sha=b=>crypto.createHash('sha256').update(b).digest('hex');
const read=f=>fs.readFileSync(path.join(root,f),'utf8'),invBase='decompiled/compact-inventory-patch/verified/scripts/net/bigpoint/darkorbit/equipment/';
function body(s,name){const at=s.indexOf('function '+name+'(');assert.ok(at>=0,name);const begin=s.indexOf('{',at);let n=1,i=begin+1;for(;n;i++){if(s[i]==='{')n++;if(s[i]==='}')n--;}return s.slice(begin+1,i-1);}
const js=s=>s.replace(/var (\w+):[\w.]+/g,'var $1').replace(/ as HangarManagerProxy/g,'');
function tags(file){let b=fs.readFileSync(path.join(root,file));if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const out=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;let n=h&63;if(n===63){n=b.readUInt32LE(at);at+=4;}out.push({tag:h>>6,hash:sha(b.subarray(at,at+n))});at+=n;}return out;}
test('installed compact inventory changes one ABC only and retains every non-code tag and the bulk drag patch',()=>{
 const p=require('../decompiled/compact-inventory-patch/evidence.json');assert.equal(sha(fs.readFileSync(path.join(root,'client/swf_global/inventory/inventory.swf'))),require('../decompiled/inventory-sales-selection-patch/evidence.json').afterSha256);
 const a=tags('decompiled/compact-inventory-patch/inventory-before.swf'),b=tags('client/swf_global/inventory/inventory.swf');assert.equal(a.length,b.length);const changes=a.filter((t,i)=>t.hash!==b[i].hash);assert.equal(changes.length,1);assert.equal(changes[0].tag,82);
 assert.equal(read(invBase+'view/components/items/DragComponent.as'),read('decompiled/drone-bulk-patch/actual-after/scripts/net/bigpoint/darkorbit/equipment/view/components/items/DragComponent.as'));
});
test('compiled compact filter shows every loose LF5 despite stale icon flags and follows config changes',()=>{
 const Settings={activeConfig:1},ItemFilter=class{filterByArrayOfSpecificGroups(groups,icons,includeEquipped){return icons.filter(i=>groups.includes(i.group)&&(includeEquipped||!i.equippedInConfigs[Settings.activeConfig]));}getItemsNotInOtherArray(a,b){return a.filter(i=>!b.includes(i));}};ItemFilter.CONTEXT_FILTER='context_filter';
 const proxy={getSelectedHangarSlot:()=>({hangarID:14})},Facade={getInstance:()=>({retrieveProxy:()=>proxy})},HangarManagerProxy={PROXY_NAME:'hangars'};
 const filter=new Function('param1','param2','param3','param4','Settings','ItemFilter','Facade','HangarManagerProxy',js(body(read(invBase+'view/components/items/GridComponent.as'),'filterByContext')));
 const icon=(id,{other=false,eq={},entities=['SHIP','DRONE','PET'],group='laser'}={})=>({id,group,equippedInConfigs:{1:true,2:true},getItemInstanceData:()=>({equippedInConfigs:eq,getEquipByOnly:()=>entities,isEquippedInOtherHangar:()=>other})});
 const loose=Array.from({length:40},(_,i)=>icon(i)),config1=icon(41,{eq:{1:{}}}),config2=icon(42,{eq:{2:{}}}),other=icon(43,{other:true}),petOnly=icon(44,{entities:['PET']}),resource=icon(45,{group:'resource'});
 const grid={_iconsInThisMenu:[...loose,config1,config2,other,petOnly,resource],gridArranger:{},changeVisibleState(){},addDragListeners(){},removeDragListeners(){},putToBack(){},redrawGridWithSortedAndNonFilteredItems(){},removeAllEquippedOverlays(){},changeEquipmentState(){}};
 const run=()=>filter.call(grid,['laser'],[],[], 'SHIP',Settings,ItemFilter,Facade,HangarManagerProxy);
 run();assert.deepEqual(grid.sortedItems.map(i=>i.id),[...loose.map(i=>i.id),42]);Settings.activeConfig=2;run();assert.deepEqual(grid.sortedItems.map(i=>i.id),[...loose.map(i=>i.id),41]);
 // Removing an item from the model makes it available without recreating icons.
 config2.getItemInstanceData().equippedInConfigs[2]=null;run();assert.ok(grid.sortedItems.includes(config2));assert.ok(!grid.sortedItems.includes(other));
});
test('compiled compact scrolling ends after the last visible item; expanded bounds stay unchanged',()=>{
 const update=new Function('ItemFilter',js(body(read(invBase+'view/components/InventoryView.as'),'updateSpecificScrollbar'))),ItemFilter={CONTEXT_FILTER:'context_filter'},seen=[];
 const view={grid:{height:25000,currentFilter:ItemFilter.CONTEXT_FILTER,lowestOfSortedItems:{y:420,height:35}},inventoryScroller:{setScrollBarConditions:n=>seen.push(n),checkScrollBarWithinBounds(){}}};
 update.call(view,ItemFilter);assert.equal(seen.pop(),455);view.grid.currentFilter='user';update.call(view,ItemFilter);assert.equal(seen.pop(),25000);
});
test('compiled 2D viewport uses native1x initial scale and retains user zoom on resize',()=>{
 const rel='scripts/net/bigpoint/darkorbit/map/view2D/MapView2D.as',source=read('decompiled/ship-motion-patch/verified/'+rel),host=read('decompiled/ship-motion-audit/host/'+rel);
 assert.equal(body(source,'setViewportSize'),body(host,'setViewportSize'));
 const set=new Function('param1','param2',body(source,'setViewportSize')),view={updateViewports(){}};set.call(view,770,395);assert.equal(view.zoom,1);assert.equal(view._viewportHalfWidth,385);view._userZoom=.5;set.call(view,1920,1080);assert.equal(view.zoom,.5);
 const proof=require('../decompiled/ship-motion-patch/evidence.json');assert.equal(proof.beforeSha256,require('../decompiled/native-laser-visuals-patch/evidence.json').afterSha256);assert.equal(sha(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))),proof.afterSha256);
 for(const f of ['map/view2D/display/ship/ShipClip','map/view2D/display/ship/Ship2D','map/model/traits/MoveTrait','mvc/application/view/ApplicationMediator']){const rel='scripts/net/bigpoint/darkorbit/'+f+'.as';assert.equal(read('decompiled/ship-motion-patch/verified/'+rel),read('decompiled/ship-motion-audit/host/'+rel));}
 assert.match(read('decompiled/ship-motion-patch/verified/scripts/net/bigpoint/darkorbit/mvc/application/view/ApplicationMediator.as'),/frameRate = 60/);
});
