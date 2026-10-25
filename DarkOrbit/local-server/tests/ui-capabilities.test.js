'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict');
const caps=require('../game/ui-capabilities'),template=require('../game/templates/init.json').commands,codec=require('../game/codec/codec');
const dbModule=require('../game/db'),players=require('../game/db/players'),World=require('../game/world');
let db;const originalCurrent=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});
after(()=>{World.current=originalCurrent;dbModule.close();});
function allItems(value,out=[]){if(value&&typeof value==='object'){if(['WindowItemCommand','ItemCommand'].includes(value._)&&value.itemId)out.push(value);for(const v of Object.values(value))if(v&&typeof v==='object')allItems(v,out);}return out;}
test('actual captured layout hides unsupported toolbar actions without changing supported native panels',()=>{
 // Layout commands nest the toolbar vector; both shapes must use the policy.
 const before=structuredClone(template),after=caps.apply(template);
 assert.deepEqual(template,before,'do not mutate captured shared state');
 for(const command of after)assert.equal(codec.decode(codec.encode(command)).rest,0);
 const bars=allItems(after),unimplemented=bars.filter(i=>!caps.capability(i.itemId).supported);
 assert.ok(unimplemented.length>0);
 for(const item of unimplemented){assert.equal(item.visible,false,item.itemId);if(item._==='WindowItemCommand')assert.equal(item.maximized,false,item.itemId);}
 for(const id of ['user','ship','minimap','spacemap','quests','refinement','assembly','ggBuilder','settings','shop','seasonPass'])assert.ok(bars.some(i=>i.itemId===id&&i.visible),id);
});
test('feature filtering preserves all local pass state and only changes visibility of unsupported features',()=>{
 const original={_:'SeasonPassStatusCommand',seasonName:'Owned local season'},data={_:'SomeState',value:42};
 const bar={_:'UIFeatureBarCommand',featureBarItems:[{_:'ItemCommand',itemId:'dispatch',visible:true},{_:'ItemCommand',itemId:'seasonPass',visible:true},{_:'ItemCommand',itemId:'fullscreen',visible:true},{_:'ItemCommand',itemId:'trinityTrials',visible:true}]};
 const result=caps.apply([original,data,bar]);
 assert.equal(result[0],original);assert.equal(result[1],data);
 assert.equal(result[2].featureBarItems[0].visible,false);assert.equal(result[2].featureBarItems[1].visible,true);assert.equal(result[2].featureBarItems[2].visible,true);
 assert.equal(result[2].featureBarItems[3].visible,true);
 assert.equal(bar.featureBarItems[0].visible,true);
});
test('real initialization cannot restore unavailable multiplayer/modern buttons from saved layout',()=>{
 const id=players.createPlayer(players.createAccount('ui-capabilities','testpass'),'UI',1,require('../config').starter),world=new World(require('../config')),session={world,send(){},close(){}};
 world.login(session,id);
 db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?)').run(id,'UIWindowUpdateRequest',JSON.stringify({chat:{posX:20,posY:20,width:200,height:200,maximized:true},dispatch:{posX:30,posY:30,width:300,height:300,maximized:true}}));
 try{
  const commands=require('../game/init').buildInit(world),items=allItems(commands);
  for(const item of items)if(!caps.capability(item.itemId).supported){assert.equal(item.visible,false,item.itemId);if(item._==='WindowItemCommand')assert.equal(item.maximized,false,item.itemId);}
  assert.ok(items.some(i=>i.itemId==='seasonPass'&&i.visible));
  assert.ok(commands.some(c=>c._==='SeasonPassStatusCommand'));assert.ok(commands.some(c=>c._==='SeasonPassRewardInfoCommand'));
 }finally{world.cancelScheduled();world.collectables?.clear();world.removeSession(session);}
});
