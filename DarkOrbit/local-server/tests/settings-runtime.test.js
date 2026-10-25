'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),path=require('path');
const database=require('../game/db'),players=require('../game/db/players'),systems=require('../game/handlers/systems'),codec=require('../game/codec/codec'),defaults=require('../game/handlers/systems-evidence.json').defaults.UserSettingsCommand;
let db,player,other,handlers,sent,session;const asRoot=path.join(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit');
before(()=>{database.close();db=database.open(':memory:');const fixture=name=>{const a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');return players.loadPlayer(players.createPlayer(Number(a.lastInsertRowid),name,1,require('../config.json').starter));};player=fixture('settings-live');other=fixture('settings-other');handlers={};sent=[];session={player,world:{player}};systems.register((n,h)=>handlers[n]=h,{db,sendCmd:(s,c)=>{assert.equal(s,session);const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);assert.deepEqual(decoded.obj,c);sent.push(c);}});});
after(()=>database.close());
const source=f=>fs.readFileSync(path.join(asRoot,f),'utf8');
function request(type,overrides={}){const field=type[0].toLowerCase()+type.slice(1)+'SettingsModule',r={...defaults[field],...overrides,_:type+'SettingsRequest'};delete r.notSet;handlers[r._](session,r);return sent.at(-1);}

test('each settings tab emits only its committed native module immediately without relog',()=>{
 const cases={Display:{displayMyDrones:false,displayDrones:true},Audio:{sound:31,music:25,voice:19,playCombatMusic:false},Gameplay:{doubleclickAttack:false,quickslotStopAttack:false},Quality:{qualityShip:1,qualityAttack:2},Quest:{completedFilter:true,availableFilter:false}};
 const lookup=source('net/netty/HandlerLookup.as');
 for(const [type,fields]of Object.entries(cases)){
  const before=sent.length,c=request(type,fields);assert.equal(sent.length,before+1);assert.equal(c._,type+'SettingsModule');assert.ok(lookup.includes(`handlerLookup[${c._}.instance.getLibcomModuleId()]`));
  for(const [key,value]of Object.entries(fields))assert.equal(c[key],value);
  const stored=JSON.parse(db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(player.userId,c._).value);assert.deepEqual(c,stored);
 }
 assert.equal(sent.some(c=>c._==='UserSettingsCommand'),false,'saving a tab must not recreate unrelated settings UI');
 assert.equal(db.prepare('SELECT COUNT(*) n FROM settings WHERE player_id=?').get(other.userId).n,0);
});

test('general drone visibility hides own models too; own checkbox can hide only own models and reconnect preserves it',()=>{
 for(const [own,others]of [[false,true],[true,false],[false,false],[true,true]]){
  const c=request('Display',{displayMyDrones:own,displayDrones:others});assert.deepEqual([c.displayMyDrones,c.displayDrones],[own&&others,others]);
  const restored=systems.buildInit(players.loadPlayer(player.userId),{db})[0].displaySettingsModule;assert.deepEqual([restored.displayMyDrones,restored.displayDrones],[own&&others,others]);
 }
 const h=source('net/netty/handlers/settings/DisplaySettingsHandler.as');assert.match(h,/Settings\.showDrones\.value = param1\.displayDrones/);assert.match(h,/Settings\.showMyDrones\.value = param1\.displayMyDrones/);
 for(const file of ['map/view2D/display/ship/drones/DronesFormation2D.as','map/view3D/display3D/ship/drones/DronesFormation3D.as'])assert.match(source(file),/isHeroShip\(\) \? Settings\.showMyDrones : Settings\.showDrones/);
});

test('legacy saved general-off own-on preference restores hidden without waiting for another save',()=>{
 const value={...defaults.displaySettingsModule,displayDrones:false,displayMyDrones:true};
 db.prepare('INSERT OR REPLACE INTO settings(player_id,key,value)VALUES(?,?,?)').run(player.userId,'DisplaySettingsModule',JSON.stringify(value));
 const display=systems.buildInit(player,{db})[0].displaySettingsModule;
 assert.equal(display.displayDrones,false);assert.equal(display.displayMyDrones,false);
});

test('master off then on restores own models even when the request carries the previously forced own-off value',()=>{
 const off=request('Display',{displayDrones:false,displayMyDrones:true});assert.deepEqual([off.displayDrones,off.displayMyDrones],[false,false]);
 const on=request('Display',{displayDrones:true,displayMyDrones:false});assert.deepEqual([on.displayDrones,on.displayMyDrones],[true,true]);
 const restored=systems.buildInit(player,{db})[0].displaySettingsModule;assert.equal(restored.displayMyDrones,true);
 const ownOff=request('Display',{displayDrones:true,displayMyDrones:false});assert.deepEqual([ownOff.displayDrones,ownOff.displayMyDrones],[true,false],'the independent own-only preference remains available');
});

test('settings validation bounds actual liveack and rejects stale sessions before writes',()=>{
 assert.deepEqual([request('Audio',{sound:999,music:-5,voice:10}).sound,sent.at(-1).music],[100,0]);
 const c=request('Display',{displaySetting3DqualityAntialias:99,displaySetting3DqualityBackground:-4});assert.equal(c.displaySetting3DqualityAntialias,4);assert.equal(c.displaySetting3DqualityBackground,0);
 assert.equal(request('Quality',{qualityShip:99}).qualityShip,3);
 const n=sent.length;assert.throws(()=>request('Display',{displayMyDrones:'false'}),/Invalid/);assert.equal(sent.length,n);
 handlers.AudioSettingsRequest({player:other,world:session.world},{_: 'AudioSettingsRequest'});assert.equal(sent.length,n);assert.equal(db.prepare('SELECT COUNT(*) n FROM settings WHERE player_id=?').get(other.userId).n,0);
});

test('stock compact row uses actual F/I/A/Z type codes, equipmentdesign colors and meanlevel',()=>{
 const drones=require('../game/drones'),loot=require('../game/loot-rewards');let ids=[];
 for(const key of ['drone_flax','drone_iris','drone_apis','drone_zeus'])ids.push(drones.addOwned(db,player.userId,key));
 for(const [index,design]of [[1,'drone_designs_havoc'],[2,'drone_designs_hercules']]){
  loot.item(db,player.userId,design,1);const item=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(player.userId,design);
  db.prepare("INSERT INTO drone_equipment(drone_id,ship_id,config_id,slot,slot_index,item_id)VALUES(?,?,1,'design',0,?)").run(ids[index],player.shipId,item.id);
 }
 const message=drones.buildCommands(player).find(c=>c._==='LegacyModule').message,fields=message.split('|').slice(4),groups=[];for(let i=0;i<fields.length;i+=4)groups.push(fields.slice(i,i+4).map(Number));
 assert.deepEqual(groups.map(d=>d[0]),[1,2,3,4]);assert.deepEqual(groups.map(d=>d[1]),[1,1,1,1]);assert.deepEqual(groups.map(d=>d[2]),[0,1,2,0]);
 const model=source('map/model/ship/drones/Drone.as'),xml=fs.readFileSync(path.join(__dirname,'../decompiled/pet-patterns/game.xml'),'utf8');
 for(const [type,letter]of [[1,'F'],[2,'I'],[3,'A'],[4,'Z']])assert.ok(model.includes(`simpleDroneDisplayLetterMap[${type}] = "${letter}"`));
 assert.match(model,/_statsDesign\.color\.toString\(16\)/);assert.match(xml,/<design id="1" assetId="havok" color="0xFF0000"/);assert.match(xml,/<design id="2" assetId="hercules" color="0x328fcc"/);
 assert.match(source('map/model/ship/drones/Drones.as'),/simpleDroneRepresentation\.value = _loc3_/);
});

test('compiled compactrow keeps native text and listens to visibility changes with cleanup',()=>{
 const patched=fs.readFileSync(path.join(__dirname,'../decompiled/settings-drone-patch/verified/scripts/net/bigpoint/darkorbit/map/hud/ship/TopDisplay.as'),'utf8');
 assert.match(patched,/Settings\.showMyDrones\.value : Settings\.showDrones\.value/);assert.match(patched,/_droneSimpleDisplay\.htmlText = this\._drones\.simpleDroneRepresentation\.value/);
 for(const setting of ['showMyDrones','showDrones']){assert.ok(patched.includes(`Settings.${setting}.changed.add(this.markDirty)`));assert.ok(patched.includes(`Settings.${setting}.changed.remove(this.markDirty)`));}
 const proof=JSON.parse(fs.readFileSync(path.join(__dirname,'../decompiled/settings-drone-patch/artifact-verification.json'),'utf8'));assert.equal(proof.nonAbcIdentical,true);assert.notEqual(proof.beforeSha256,proof.afterSha256);
});
