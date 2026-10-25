'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),path=require('path'),crypto=require('crypto');
const root=path.join(__dirname,'..'),dir='decompiled/multi-launcher-patch/verified/scripts/net/bigpoint/darkorbit/',read=p=>fs.readFileSync(path.join(root,p),'utf8');
function body(s,name){const start=s.indexOf('function '+name+'('),begin=s.indexOf('{',start);assert.ok(start>0,name);let at=begin+1,depth=1;for(;depth;at++){if(s[at]==='{')depth++;if(s[at]==='}')depth--;}return s.slice(begin+1,at-1);}
const source=read(dir+'net/RocketLauncherAssembly.as');
test('actual compiled launcher decoder accepts CSV types and six-round launcher with correct full-load sound',()=>{
 const code=body(source,'assembleSetStatusCommand').replace('var _loc2_:Vector.<int> = new Vector.<int>();','var _loc2_ = [];').replace('for each(var launcherType:String in','for(var launcherType of');
 const decode=new Function('param1','int',code),state={setRocketLauncherStatus(...args){this.last=args;}};decode.call(state,['0','RL','S','2,2','9','10'],Number);assert.deepEqual(state.last,[[2,2],9,10]);
 let sounds=[];const Settings={},AudioManager={playSoundEffect(id){sounds.push(id);}},InGameCatalog={SOUND_ID_ROCKETS_LOAD_START:'start',SOUND_ID_ROCKET_LOAD:'round',SOUND_ID_ROCKETS_LOADED:'full'};
 const status=new Function('param1','param2','param3','Settings','AudioManager','InGameCatalog',body(source,'setRocketLauncherStatus').replace(/:(?:int)\b/g,'').replace('for each(_loc5_ in','for(_loc5_ of'));
 status([2,3],9,11,Settings,AudioManager,InGameCatalog);assert.deepEqual(sounds,['full']);assert.deepEqual(Settings.rocketLauncherTypes,[2,3]);
 sounds=[];status([3],9,5,Settings,AudioManager,InGameCatalog);assert.deepEqual(sounds,['round']);
});
test('actual compiled Trinity claim transmits clicked level and VIP flag; only ABC changed and earlier UI patches remain',()=>{
 const proxy=read(dir+'mvc/gui/windows/trinityTrials/model/TrinityTrialsMainProxy.as'),sent=[];
 class Request{constructor(level,vip){Object.assign(this,{level,vip});}}
 const fn=new Function('param1','param2','TrinityTrialsClaimPassRewardRequest','connectionProxy',body(proxy,'sendPassCliamRequest').replace(/:TrinityTrialsClaimPassRewardRequest\b/g,''));fn(19,true,Request,{sendNettyRequest(r){sent.push(r);}});assert.equal(sent[0].level,19);assert.equal(sent[0].vip,true);
 const proof=require('../decompiled/multi-launcher-patch/evidence.json');assert.equal(require('./helpers/installed-main').after(proof.beforeSha256),crypto.createHash('sha256').update(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))).digest('hex'));assert.equal(proof.nonAbcIdentical,true);assert.equal(proof.changes.length,1);assert.equal(proof.changes[0].after.tag,82);
 for(const file of ['mvc/crafting/upgrade/view/UpgradeWindowMediator.as','mvc/crafting/assembly/model/AssemblyInventoryIndex.as','mvc/settingsFUI/model/SettingsWindowFUIProxy.as'])assert.equal(read(dir+file),read('decompiled/upgrade-bulk-patch/verified/scripts/net/bigpoint/darkorbit/'+file));
});
