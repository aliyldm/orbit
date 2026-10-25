'use strict';
const {test,before,after,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),core=require('../game/handlers/core'),gameplay=require('../game/gameplay'),maps=require('../game/maps'),jump=require('../game/jump-cpu'),codec=require('../game/codec/codec');
let db,f,serial=0;
before(()=>{db=database.open(':memory:');});
after(()=>database.close());
beforeEach(()=>{
 const id=players.createPlayer(players.createAccount('navigation-qa-'+ ++serial,'testpass'),'Navigation QA',1,config.starter),world=new World(config),session={world,send(){},close(){}},out=[],handlers=new Map(),jobs=[];
 world.login(session,id);
 const send=(s,c)=>{const result=codec.decode(codec.encode(c));assert.equal(result.rest,0);out.push(result.obj);};
 const combat={send,stop(){},cancelProjectiles(){},abort(){},start(){}};world.combat=combat;world.schedule=fn=>jobs.push(fn);
 core.register((name,fn)=>handlers.set(name,fn),{sendCmd:send});
 gameplay.register(()=>{},{sendCmd:send,buildInit:w=>core.buildInit(w.player),combatFor:()=>combat});
 f={world,session,p:world.player,id,out,handlers,jobs};
});
afterEach(()=>f.world.removeSession(f.session));

test('local news activation and read state use matching native event identities across reloads',()=>{
 const cc=require('../game/command-center'),init=core.buildInit(f.p),events=init.find(c=>c._==='EventUpdateCommand');
 const notice=cc.entries()[0],request={_:'CommandCenterNewsClickedRequest',...notice};
 assert.equal(events.activeCommands.length,cc.NEWS.length);
 assert.ok(events.activeCommands.every(e=>cc.valid({newsId:e.type.slice(3),eventId:e.id})&&e.timeLeft>10&&e.lang==='all'));
 f.handlers.get('CommandCenterNewsInfoRequest')(f.session,{newsInfo:[request]});assert.equal(f.out.at(-1).ids[0].clickCount,0);
 f.handlers.get('CommandCenterNewsClickedRequest')(f.session,request);assert.equal(f.out.at(-1).ids[0].clickCount,1);
 assert.equal(core.buildInit(players.loadPlayer(f.id)).find(c=>c._==='CommandCenterInfoCommand').ids[0].clickCount,1);
 const encoded=codec.decode(codec.encode(events));assert.equal(encoded.rest,0);assert.deepEqual(encoded.obj,events);
});

test('stale captured news and fabricated event identities cannot create local read records',()=>{
 const cc=require('../game/command-center'),notice=cc.entries()[0],before=f.out.length;
 for(const item of [{newsId:'BE_SeasonPass202608',eventId:13185},{...notice,eventId:notice.eventId+100}])f.handlers.get('CommandCenterNewsClickedRequest')(f.session,item);
 assert.equal(f.out.length,before);
 assert.equal(db.prepare("SELECT count(*) n FROM settings WHERE player_id=? AND key='commandCenter.news'").get(f.id).n,0);
 f.handlers.get('CommandCenterNewsInfoRequest')(f.session,{newsInfo:[{newsId:'captured',eventId:1},notice]});
 assert.equal(f.out.at(-1).ids.length,1);assert.equal(f.out.at(-1).ids[0].newsId,notice.newsId);
});

test('fresh native CommandCenter defaults to suppressed on initialization and checkbox query',()=>{
 const initial=core.buildInit(f.p).find(c=>c._==='CommandCenterDontShowInfoCommand');assert.equal(initial.inspected,true);
 f.handlers.get('CommandCenterGetDontShowRequest')(f.session);assert.equal(f.out.at(-1).inspected,true);
 assert.equal(db.prepare("SELECT count(*) n FROM settings WHERE player_id=? AND key='commandCenter.hidden'").get(f.id).n,0,'a default must not manufacture a saved preference');
});

test('CommandCenter checkbox overrides survive repeated initialization and a player reload',()=>{
 for(const inspected of [false,true]){
  f.handlers.get('CommandCenterUpdateDontShowRequest')(f.session,{inspected});
  for(let i=0;i<2;i++)assert.equal(core.buildInit(f.p).find(c=>c._==='CommandCenterDontShowInfoCommand').inspected,inspected);
  assert.equal(core.buildInit(players.loadPlayer(f.id)).find(c=>c._==='CommandCenterDontShowInfoCommand').inspected,inspected);
  f.handlers.get('CommandCenterGetDontShowRequest')(f.session);assert.equal(f.out.at(-1).inspected,inspected);
 }
});

test('each battle map entrance denies below its original level and actually transfers at the boundary',()=>{
 for(const [from,to,level] of [[4,13,8],[8,14,8],[12,15,8],[13,16,9],[17,29,12]]){
  const gate=maps.portals(from,1).find(g=>g.target_map===to);assert.ok(gate);
  Object.assign(f.p,{mapId:from,x:gate.x,y:gate.y,level:level-1});f.out.length=0;
  assert.equal(gameplay.jump(f.session,gate.id),false);assert.equal(f.jobs.length,0);assert.equal(f.p.mapId,from);
  assert.ok(f.out.some(c=>c._==='JumpDeniedCommand'&&c.mandatoryLevel===level));
  assert.ok(f.out.some(c=>c._==='LegacyModule'&&c.message.includes(maps.getMap(to).name)&&c.message.includes(`${level}. seviye`)));
  f.p.level=level;assert.equal(gameplay.jump(f.session,gate.id),true);assert.equal(f.jobs.length,1);f.jobs.shift()();
  assert.equal(f.p.mapId,to);assert.equal(f.session.jumping,false);assert.equal(db.prepare('SELECT map_id FROM players WHERE id=?').get(f.id).map_id,to);
  assert.ok(f.out.some(c=>c._==='JumpInitiatedCommand'&&c.mapId===to));
  assert.equal(f.out.findLast(c=>c._==='CommandCenterDontShowInfoCommand').inspected,true,'map initialization must not open the empty news spinner');
 }
});

test('advanced CPU lists and selects the same battle-map level boundaries',()=>{
 db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index)VALUES(?,'equipment_extra_cpu_ajp-01',1,?,'extra',50)").run(f.id,f.p.shipId);
 Object.assign(f.p,{mapId:4,uridium:1000000});
 for(const [id,level] of [[13,8],[14,8],[15,8],[16,9],[29,12]]){
  f.p.level=level-1;assert.equal(jump.select(f.session,id),false);
  assert.equal(jump.list(f.session),true);const fields=f.out.at(-1).message.split('|'),locked=fields[fields.indexOf('-1')+1].split(';').map(Number);assert.ok(locked.includes(id));
  f.p.level=level;assert.equal(jump.select(f.session,id),true);assert.equal(f.session.cpuJumpTarget,id);
  assert.equal(jump.list(f.session),true);const allowed=f.out.at(-1).message.split('|'),notAllowed=allowed[allowed.indexOf('-1')+1].split(';').map(Number);assert.ok(!notAllowed.includes(id));
 }
});
