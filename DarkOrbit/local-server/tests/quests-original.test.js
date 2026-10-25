'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),systems=require('../game/handlers/systems'),content=require('../game/quests-content'),codec=require('../game/codec/codec');
let db,s,handlers,services;const quests=()=>content.missions.filter(q=>q.provenance.kind==='reconstructed-nyx');
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('nyx-qa','testpass'),'NYX',1,require('../config').starter);s={player:players.loadPlayer(id)};s.world={player:s.player,updatePosition:()=>s.player};s.player.level=18;db.prepare('UPDATE players SET level=18 WHERE id=?').run(id);handlers=new Map();services={db,sendCmd(s,c){assert.equal(codec.decode(codec.encode(c)).rest,0);}};systems.register((name,fn)=>handlers.set(name,fn),services);systems.questList(s.player,db);});
afterEach(()=>database.close());
function request(name,r){return handlers.get(name)(s,{_:name,...r});}
function accept(id){Object.assign(s.player,{mapId:1,x:2000,y:2000});request('QuestGiverApproachedRequest',{questGiverId:150000000});request('QuestAcceptRequest',{questId:id});}
const state=id=>db.prepare('SELECT * FROM player_quests WHERE player_id=? AND quest_id=?').get(s.player.userId,id);
test('all33 source-reconstructed solo NYX quests can complete and deliver each published reward exactly once',()=>{
 assert.equal(quests().length,33);
 for(const q of quests()){
  const id=q.definition.id,before=db.prepare('SELECT credits,uridium,ep FROM players WHERE id=?').get(s.player.userId);accept(id);assert.equal(state(id)?.status,'running',q.title);
  const snap=JSON.parse(state(id).snapshot_json);
  for(const el of snap.definition.rootCase.modifier){const c=el.condition;systems.recordEvent(s,{type:c.type===6?'npcKill':'collectLoot',...(c.type===6?{npcId:Number(c.matches[0])}:{lootId:c.matches[0]}),amount:c.targetValue,mapId:snap.constraints[c.id]?.maps[0]||1,eventId:`nyx:${id}:${c.id}`},services);}
  assert.equal(state(id).status,'completed',q.title);const after=db.prepare('SELECT credits,uridium,ep FROM players WHERE id=?').get(s.player.userId);
  for(const [field,loot]of [['credits','currency_credits'],['uridium','currency_uridium'],['ep','currency_experience']])assert.equal(after[field]-before[field],q.definition.rewards.find(r=>r.lootId===loot).amount,q.title+' '+field);
  const claims=db.prepare('SELECT COUNT(*) n FROM quest_reward_claims WHERE player_id=? AND quest_id=?').get(s.player.userId,id).n;assert.equal(claims,1);accept(id);assert.equal(state(id).status,'completed');assert.deepEqual(db.prepare('SELECT credits,uridium,ep FROM players WHERE id=?').get(s.player.userId),after);
 }
});
test('Stronghold keeps original NPC distinctions and x7 constraints; quest catalog is honest about rebuilt IDs and unlock policy',()=>{
 const q=quests().find(q=>q.provenance.originalTitle==='Stronghold');accept(q.definition.id);const snap=JSON.parse(state(q.definition.id).snapshot_json),c=snap.definition.rootCase.modifier[0].condition;
 systems.recordEvent(s,{type:'npcKill',npcId:Number(c.matches[0]),amount:1,mapId:18},services);assert.equal(state(q.definition.id).progress_json,'{}');
 systems.recordEvent(s,{type:'npcKill',npcKey:'boss-kristallon',amount:1,mapId:19},services);assert.equal(state(q.definition.id).progress_json,'{}');
 systems.recordEvent(s,{type:'npcKill',npcKey:'kristallon',amount:1,mapId:19},services);assert.equal(JSON.parse(state(q.definition.id).progress_json)[c.id],1);
 for(const mission of quests()){assert.equal(mission.provenance.originalId,null);assert.equal(mission.provenance.availability,'local-level-only');}
});
