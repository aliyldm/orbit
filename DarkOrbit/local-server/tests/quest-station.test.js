'use strict';
const {test,beforeEach,afterEach}=require('node:test');
const assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players');
const config=require('../config'),World=require('../game/world'),Combat=require('../game/combat');
const station=require('../game/quest-station'),systems=require('../game/handlers/systems');
const maps=require('../game/maps'),codec=require('../game/codec/codec');
let db,world,session,handlers,sent,services;
beforeEach(()=>{
 database.close();db=database.open(':memory:');
 const account=players.createAccount('quest-station','test-password');
 const id=players.createPlayer(account,'Quest station',1,config.starter);
 world=new World(config);session={world,send(){},close(){}};world.login(session,id);
 sent=[];handlers=new Map();services={db,sendCmd:(s,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);assert.deepEqual(decoded.obj,c);sent.push(c);}};
 systems.register((name,fn)=>handlers.set(name,fn),services);systems.questList(session.player,db);
 const pos=station.describe(session.player,db);Object.assign(session.player,{x:pos.x,y:pos.y});
});
afterEach(()=>{world?.removeSession(session);database.close();});
function request(name,fields={},s=session){const c=codec.decode(codec.encode({_ :name,...fields})).obj;return handlers.get(name)(s,c);}
const home=()=>request('QuestGiverApproachedRequest',{questGiverId:station.ID});
const accept=id=>request('QuestAcceptRequest',{questId:id});
const state=id=>db.prepare('SELECT * FROM player_quests WHERE player_id=? AND quest_id=?').get(session.player.userId,id);
const count=loot=>db.prepare('SELECT coalesce(sum(amount),0)n FROM items WHERE player_id=? AND loot_id=?').get(session.player.userId,loot).n;
const event=e=>systems.recordEvent(session,e,services);

test('bootstrap creates native giver after QuestList and enables its click exactly once',()=>{
 const commands=require('../game/init').buildInit(world);
 const available=commands.filter(c=>c._==='QuestGiversAvailableCommand');
 assert.equal(available.length,1);assert.equal(available[0].questGivers[0].mapObjectId,station.ID);
 const list=commands.findIndex(c=>c._==='QuestListCommand');
 const asset=commands.findIndex(c=>c._==='AssetCreateCommand'&&c.assetId===station.ID);
 const enabled=commands.findIndex(c=>c._==='QuestGiversAvailableCommand');
 assert.ok(list>=0&&list<asset&&asset<enabled);
 services.sendCmd(session,available[0]);assert.equal(station.refresh(world,services.sendCmd,db),false);
});

test('all company home actors use source identities and the same actual actor coordinates as the wire asset',()=>{
 for(const [faction,mapId,designId,name] of [[1,1,3,'Morgus Petterson'],[2,5,6,'Reginald Crowley'],[3,9,9,'Vanessa Arkadium']]){
  Object.assign(session.player,{factionId:faction,mapId});const giver=station.describe(session.player,db);
  Object.assign(session.player,{x:giver.x,y:giver.y});
  const commands=maps.commands(world),asset=commands.find(c=>c._==='AssetCreateCommand'&&c.assetId===station.ID);
  assert.equal(asset.designId,designId);assert.equal(asset.userName,name);assert.deepEqual([asset.posX,asset.posY],[giver.x,giver.y]);
  assert.equal(commands.find(c=>c._==='QuestGiversAvailableCommand').questGivers.length,1);
 }
});

test('foreign home, upper base and open space never announce an available own HOME giver',()=>{
 for(const mapId of [2,5,20,24,28,91]){
  session.player.mapId=mapId;
  assert.deepEqual(maps.commands(world).find(c=>c._==='QuestGiversAvailableCommand').questGivers,[]);
  assert.equal(station.approach(session,{questGiverId:station.ID},db),null);
 }
});

test('approach uses actor range rather than station-center range and ignores forged client coordinates',()=>{
 accept(20000);Object.assign(session.player,{x:2000,y:4600});home();assert.equal(state(20000).status,'completed');
 request('QuestGiverWindowClosedRequest',{questGiverId:station.ID});
 Object.assign(session.player,{x:18000,y:11000});
 handlers.get('QuestGiverApproachedRequest')(session,{questGiverId:station.ID,x:2000,y:3080});
 assert.equal(session.questGiverWindow,null);
});

test('wrong actor, dead, jumping and detached sockets cannot open or progress HOME',()=>{
 accept(20000);request('QuestGiverApproachedRequest',{questGiverId:1});assert.equal(session.questGiverWindow,undefined);
 session.player.dead=true;home();session.player.dead=false;session.jumping=true;home();session.jumping=false;
 const detached={world,player:session.player};request('QuestGiverApproachedRequest',{questGiverId:station.ID},detached);
 assert.equal(state(20000).progress_json,'{}');assert.equal(detached.questGiverWindow,undefined);assert.equal(session.questGiverWindow,undefined);
});

test('availability changes are sent once per transition so native window is not closed every tick',()=>{
 station.initialize(world,db);home();sent.length=0;
 for(let i=0;i<3;i++)assert.equal(station.refresh(world,services.sendCmd,db),false);
 assert.ok(session.questGiverWindow);session.player.y=7000;
 assert.equal(station.refresh(world,services.sendCmd,db),true);assert.deepEqual(sent.at(-1).questGivers,[]);assert.equal(session.questGiverWindow,null);
 assert.equal(station.refresh(world,services.sendCmd,db),false);session.player.y=3080;
 assert.equal(station.refresh(world,services.sendCmd,db),true);assert.equal(sent.at(-1).questGivers.length,1);
 assert.equal(sent.length,2);
});

test('native click, details, accept completes initially active HOME with one reward and unlocks next quest',()=>{
 home();request('QuestInfoRequest',{questId:20000});assert.equal(sent.at(-1).definition.id,20000);
 const before=count('ammunition_laser_lcb-10');accept(20000);
 assert.equal(state(20000).status,'completed');assert.equal(count('ammunition_laser_lcb-10'),before+500);
 assert.equal(sent.filter(c=>c._==='QuestCompletedCommand'&&c.id===20000).length,1);
 assert.equal(systems.questList(session.player,db).list.find(q=>q.questId===20001).acceptabilityStatus.type,1);
 home();accept(20000);assert.equal(count('ammunition_laser_lcb-10'),before+500);
 assert.equal(db.prepare('SELECT count(*)n FROM quest_reward_claims').get().n,1);
});

test('open-window accept cannot skip later ordered HOME and progress survives reconstruction',()=>{
 home();accept(20000);accept(20001);assert.equal(state(20001).progress_json,'{}');
 home();event({type:'npcKill',npcId:1,amount:2});event({type:'cargo',amount:2});assert.equal(state(20001).status,'running');
 const init=systems.buildInit(players.loadPlayer(session.player.userId),{db}).find(c=>c._==='QuestInitializationCommand'&&c.quest.id===20001);
 assert.equal(init.quest.rootCase.modifier[1].condition.state.active,true);
 home();assert.equal(state(20001).status,'completed');assert.equal(count('equipment_generator_speed_g3n-3310'),1);
});

test('closed, moved or reconnect-stale window cannot synthesize an accept-time HOME visit',()=>{
 home();request('QuestGiverWindowClosedRequest',{questGiverId:station.ID});accept(20000);assert.equal(state(20000).status,'running');
 request('QuestCancelRequest',{questId:20000});home();session.player.y=7000;accept(20000);assert.equal(state(20000).status,'running');
 request('QuestCancelRequest',{questId:20000});session.player.y=3080;home();session.questGiverWindow.mapId=5;
 accept(20000);assert.equal(state(20000).progress_json,'{}');
});

test('accept-time reward failure leaves a retryable running quest and no success or duplicate payment',()=>{
 home();const before=count('ammunition_laser_lcb-10');
 db.exec("CREATE TRIGGER quest_station_reward_failure BEFORE UPDATE ON items BEGIN SELECT RAISE(ABORT,'injected station reward failure'); END");sent.length=0;
 assert.throws(()=>accept(20000),/injected station reward failure/);assert.equal(state(20000).status,'running');assert.equal(state(20000).progress_json,'{}');
 assert.equal(count('ammunition_laser_lcb-10'),before);assert.equal(sent.some(c=>c._==='QuestCompletedCommand'),false);
 assert.equal(db.prepare('SELECT count(*)n FROM quest_reward_claims').get().n,0);
 db.exec('DROP TRIGGER quest_station_reward_failure');home();home();assert.equal(count('ammunition_laser_lcb-10'),before+500);
});

test('live combat tick updates native click availability after authoritative movement and death',()=>{
 const combat=new Combat(world,services.sendCmd);combat.map=maps.getMap(session.player.mapId);combat.lastSave=Date.now();
 station.initialize(world,db);sent.length=0;session.player.y=7000;combat.tick();
 assert.deepEqual(sent.filter(c=>c._==='QuestGiversAvailableCommand').at(-1).questGivers,[]);
 sent.length=0;combat.tick();assert.equal(sent.some(c=>c._==='QuestGiversAvailableCommand'),false);
 session.player.y=3080;combat.tick();assert.equal(sent.filter(c=>c._==='QuestGiversAvailableCommand').at(-1).questGivers.length,1);
 sent.length=0;session.player.dead=true;combat.tick();assert.deepEqual(sent.filter(c=>c._==='QuestGiversAvailableCommand').at(-1).questGivers,[]);
});
