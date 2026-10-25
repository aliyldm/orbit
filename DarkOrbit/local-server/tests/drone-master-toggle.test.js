'use strict';
const currentAfter=require('./helpers/installed-main').after;
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.join(__dirname,'..'),dir=path.join(root,'decompiled/drone-master-toggle-patch'),relative='scripts/net/bigpoint/darkorbit/mvc/settingsFUI/model/SettingsWindowFUIProxy.as',read=p=>fs.readFileSync(path.join(dir,p),'utf8');
function actualCase(source,name){const start=source.indexOf('case SettingsCheckBoxItemVO.'+name+':'),end=source.indexOf('            case ',start+8);assert.ok(start>0&&end>start);const body=source.slice(source.indexOf(':',start)+1,end).replace(/\bbreak;/g,'').replace(/\bsendNotification\(/g,'this.sendNotification(');return new Function('param1','Settings','SettingsWindowNotifications',body);}
function fixture(master,own){return{model:{showDrones:master,showMyDrones:own,showPlayerNames:true},save:0,sendNotification(){this.save++;}};}
const constants={SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON:'save'};
test('compiled master checkbox off/on restores own drones immediately and in saved UI model',()=>{
 const before=read('before/'+relative),after=read('verified/'+relative),id='SETTINGS_CHECK_BOX_ID_SHOW_DRONES';
 const old=fixture(false,false),oldSettings={showDrones:{value:false},showMyDrones:{value:false}};actualCase(before,id).call(old,{checkBoxSelected:true},oldSettings,constants);assert.equal(old.model.showMyDrones,false,'former native toggle left own drones hidden');
 const state=fixture(true,false),settings={showDrones:{value:true},showMyDrones:{value:false}};const run=actualCase(after,id);
 for(const checked of [false,true,false,true]){run.call(state,{checkBoxSelected:checked},settings,constants);assert.deepEqual([state.model.showDrones,state.model.showMyDrones,settings.showDrones.value,settings.showMyDrones.value],[checked,checked,checked,checked]);}
 assert.equal(state.save,4);assert.equal(state.model.showPlayerNames,true);
 assert.match(after,/SETTINGS_WINDOW_FUI_APPLY_MODEL_CHANGES,this\.model/);
});
test('unchanged master preserves separate own-drone choice; own checkbox does not alter global flag',()=>{
 const source=read('verified/'+relative),state=fixture(true,false),settings={showDrones:{value:true},showMyDrones:{value:false}};
 actualCase(source,'SETTINGS_CHECK_BOX_ID_SHOW_DRONES').call(state,{checkBoxSelected:true},settings,constants);assert.equal(state.model.showMyDrones,false);assert.equal(settings.showMyDrones.value,false);assert.equal(state.save,0);
 actualCase(source,'SETTINGS_CHECK_BOX_ID_SHOW_MY_DRONES').call(state,{checkBoxSelected:true},settings,constants);assert.equal(state.model.showDrones,true);assert.equal(settings.showDrones.value,true);assert.equal(state.model.showMyDrones,true);assert.equal(settings.showMyDrones.value,true);
});
test('installed drone master artifact follows verified assembly correction without changing media or earlier patches',()=>{
 const p=JSON.parse(read('evidence.json')),before=JSON.parse(fs.readFileSync(path.join(root,'decompiled/assembly-null-traits-patch/evidence.json'),'utf8'));
 const bulk=JSON.parse(fs.readFileSync(path.join(root,'decompiled/upgrade-bulk-patch/evidence.json'),'utf8'));
 assert.equal(p.beforeSha256,before.afterSha256);assert.equal(bulk.beforeSha256,p.afterSha256);assert.equal(currentAfter(bulk.afterSha256),crypto.createHash('sha256').update(fs.readFileSync(path.join(root,'client/spacemap/main.swf'))).digest('hex'));
 assert.equal(p.nonAbcIdentical,true);assert.equal(p.unchangedNonAbcTags,256);assert.equal(p.changes.length,1);
 for(const name of ['mvc/crafting/assembly/model/AssemblyModel.as','mvc/crafting/assembly/model/AssemblyInventoryIndex.as','managers/keyboardManager/KeyboardMapper.as','map/hud/ship/TopDisplay.as'])assert.equal(read('verified/scripts/net/bigpoint/darkorbit/'+name),fs.readFileSync(path.join(root,'decompiled/assembly-null-traits-patch/verified/scripts/net/bigpoint/darkorbit',name),'utf8'));
});
