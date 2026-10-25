'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const script=fs.readFileSync(path.join(__dirname,'../client/resources/js/local-hangars.js'),'utf8');
function frontend({empty=false,slotLink=false}={}){
 const elements=new Map(),requests=[],intervals=[],timeouts=[],selected=[],removed=[],popup={questions:[],errors:[],hidden:0};
 function element(key){if(typeof key==='object')return key;if(!elements.has(key)){const e={key,length:key==='#equipment_container'?1:1,value:'',visible:true,classes:new Set(),events:{},attrs:{},text(v){this.value=v;return this;},val(v){if(v===undefined)return this.value;this.value=v;return this;},show(){this.visible=true;return this;},hide(){this.visible=false;return this;},toggle(v){this.visible=v;return this;},toggleClass(c,v){v?this.classes.add(c):this.classes.delete(c);return this;},hasClass(c){return this.classes.has(c);},outerHeight(){return 34;},css(k,v){this[k]=v;return this;},prop(k,v){this[k]=v;return this;},attr(k,v){if(v===undefined)return this.attrs[k];this.attrs[k]=v;return this;},on(k,fn){this.events[k]=fn;return this;},off(k,fn){removed.push({key,k,fn});return this;},each(fn){fn.call(this);return this;}};elements.set(key,e);}return elements.get(key);}
 let context;const jq=arg=>{if(typeof arg==='function'){arg();return;}return element(arg);};jq.extend=Object.assign;jq.ajax=r=>requests.push(r);
 const state={nextSlot:2,selectedSlot:1,selectedIndex:empty?-1:4,purchaseToken:'native_purchase_token_0001',online:false,slots:[{number:1,selected:true,shipId:empty?null:42}]};
 const oldClick=()=>{};const window={jQuery:jq,LocalHangarsState:state,location:{href:'',search:slotLink?'?action=internalDock&hangarSlot=1':'?action=internalDock',reload(){this.reloaded=true;}},confirm(){throw Error('original popup should be used');},Tools:{Popup:{library:{},hide(){popup.hidden++;},Presets:{showQuestionDialog(text,args){popup.questions.push({text,...args});},showErrorDialog(text){popup.errors.push(text);}}}},Shop:{Events:{onBtnGetNextHangarClick:oldClick}},HeaderFunc:{},setInterval(fn){intervals.push(fn);return intervals.length;},clearInterval(){},setTimeout(fn){timeouts.push(fn);return timeouts.length;},clearTimeout(){},setHangarBarActive(){},document:{getElementById(id){return id==='inventory'?{isReady(){window.flashInitFinished();},changeHangarSlot(index){selected.push(index);}}:null;}}};
 context=vm.createContext({window});vm.runInContext(script,context);return {window,elements,requests,intervals,timeouts,selected,removed,popup,state,oldClick};
}
test('original popup confirms250k and native AJAX sends server slot and stable replay token; duplicate confirm sends once',()=>{
 const f=frontend();f.window.LocalHangars.buy();assert.equal(f.requests.length,0);assert.match(f.popup.questions[0].text,/250\.000/);f.popup.questions[0].callback();f.popup.questions[0].callback();assert.equal(f.requests.length,1);const r=f.requests[0];assert.equal(r.url,'/ajax/hangar.php');assert.equal(r.type,'POST');assert.deepEqual({...r.data},{action:'purchase',slot:2,requestId:f.state.purchaseToken});assert.equal(f.removed[0].fn,f.oldClick);
 r.success({result:'success',state:f.state});assert.equal(f.window.location.reloaded,true);
});
test('lost purchase response retains exact request token so retry cannot become another charge',()=>{
 const f=frontend();f.window.LocalHangars.buy();f.popup.questions[0].callback();const a=f.requests[0];a.error();f.window.LocalHangars.buy();f.popup.questions[1].callback();assert.equal(f.requests[1].data.requestId,a.data.requestId);assert.equal(f.requests[1].data.slot,a.data.slot);assert.match(f.popup.errors[0],/yeniden deneyebilirsin/);
});
test('explicit header slot opens equipment with the original ships-array index exactly once',()=>{
 const f=frontend({slotLink:true});assert.deepEqual(f.selected,[]);f.intervals[0]();f.window.flashInitFinished();assert.deepEqual(f.selected,[4]);
});

test('normal Hangar opening keeps the ship browser even after Flash readiness or an empty selected slot',()=>{
 for(const empty of [false,true]){
  const f=frontend({empty});f.window.flashInitFinished();f.window.LocalHangars.flashReady();f.window.flashInitFinished();
  assert.deepEqual(f.selected,[]);assert.equal(f.intervals.length,0);assert.equal(f.elements.get('#equipment_container').visible,true);
 }
});
test('empty selected hangar hides unrelated active equipment until an owned hull is assigned',()=>{
 const f=frontend({empty:true,slotLink:true});assert.equal(f.elements.get('#equipment_container').visible,false);assert.equal(f.intervals.length,0);assert.match(f.elements.get('#local_hangar_message').value,/hangar boş/);
 f.window.jQuery('#local_hangar_ship').val('73');f.elements.get('#local_hangar_assign').events.click();assert.deepEqual({...f.requests[0].data},{action:'assign',slot:1,ship:'73'});
});
test('native inventory activation completion refreshes active identity without changing chosen view',()=>{
 const f=frontend();f.window.setHangarBarActive(true);assert.equal(f.timeouts.length,1);f.timeouts[0]();assert.equal(f.requests[0].type,'GET');f.requests[0].success({result:'success',state:{activeShipName:'GOLIATH',activeSlot:null}});assert.match(f.elements.get('#local_hangar_active').value,/GOLIATH \(hangara atanmamış\)/);assert.equal(f.window.LocalHangarsState.selectedSlot,1);
});
