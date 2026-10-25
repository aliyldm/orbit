'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),path=require('path');
const database=require('../game/db'),players=require('../game/db/players'),n=require('../game/native-rewards'),e=require('../game/payment-events'),loot=require('../game/loot-rewards'),codec=require('../game/codec/codec');
let db,id,other;const now=Date.UTC(2026,9,23,12);
beforeEach(()=>{database.close();db=database.open(':memory:');const add=name=>players.createPlayer(players.createAccount(name,'testpass'),name,1,require('../config').starter);id=add('native-reward-qa');other=add('native-other');});
afterEach(()=>database.close());
test('daily calendar books real items once per reset, isolates accounts and skips missed dates without losing sequence',()=>{
 db.prepare('UPDATE players SET premium=0 WHERE id=?').run(id);
 assert.equal(n.dailyState(db,id,now).day,1);assert.equal(n.dailyClaim(db,id,now).repeated,false);
 const booster=db.prepare('SELECT * FROM player_boosters WHERE player_id=? AND loot_id=?').get(id,'booster_ep-dlb');assert.ok(booster);const expiry=booster.expires_at;assert.equal(n.dailyClaim(db,id,now).repeated,true);assert.equal(db.prepare('SELECT expires_at FROM player_boosters WHERE player_id=? AND loot_id=?').get(id,'booster_ep-dlb').expires_at,expiry);
 assert.equal(n.dailyState(db,other,now).day,1);assert.equal(n.dailyState(db,id,now+3*86400000).day,2);
 const json=n.dailyJson(db,id,'http://localhost/client/',now);assert.equal(json.rewards[0][0].booked,true);assert.equal(json.rewards[1][0].booked,false);assert.equal(n.dailyCommand(db,id,now).claimed,true);
 const reset=Date.UTC(2026,9,24,2,30);assert.equal(n.dailyState(db,id,reset-1).claimable,false);assert.equal(n.dailyState(db,id,reset).claimable,true);
});
test('daily delivery failure rolls back inventory and receipt, premium entitlement controls extras, month changes reset sequence',()=>{
 const rows=db.prepare('SELECT * FROM items WHERE player_id=?').all(id);db.exec("CREATE TRIGGER reject_calendar BEFORE INSERT ON daily_login_claims BEGIN SELECT RAISE(ABORT,'receipt failure'); END");
 assert.throws(()=>n.dailyClaim(db,id,now),/receipt failure/);assert.deepEqual(db.prepare('SELECT * FROM items WHERE player_id=?').all(id),rows);assert.equal(n.dailyState(db,id,now).count,0);db.exec('DROP TRIGGER reject_calendar');
 assert.notDeepEqual(n.calendarReward(25,true),n.calendarReward(25,false));n.dailyClaim(db,id,now);assert.equal(n.dailyState(db,id,Date.UTC(2026,10,1,3)).count,0);
});
test('native pass status and claims use same owned entitlement and receipt as web; native missions and XML IDs agree',()=>{
 e.account(db,id);db.prepare('UPDATE payment_event_accounts SET trinity_points=100 WHERE player_id=?').run(id);
 let p=n.passCommand(db,id,'trinity');assert.equal(p.normalItemList[0].statusType,2);assert.equal(p.vipItemList[0].statusType,0);assert.equal(p.normalItemList[1].statusType,3);
 e.claim(db,id,'trinity-free',1);p=n.passCommand(db,id,'trinity');assert.equal(p.normalItemList[0].statusType,1);assert.throws(()=>e.claim(db,id,'trinity-free',1),/alındı/);
 for(const c of [...n.commands(db,id,now),n.dailyCommand(db,id,now)])assert.equal(codec.decode(codec.encode(c)).rest,0);
 const xml=fs.readFileSync(path.join(__dirname,'../client/spacemap/graphics/ui/windows/battlePass/externals/pass_local.xml'),'utf8'),locale=fs.readFileSync(path.join(__dirname,'../client/spacemap/templates/tr/resource_quest.xml'),'utf8');
 for(const m of n.missionCommand(db,id,now).missionItems){const q=m.questDefinitionModule;assert.ok(xml.includes('questId="'+q.id+'"'));assert.ok(locale.includes('name="quest_title_'+q.id+'"'));}
 assert.ok(fs.readFileSync(path.join(__dirname,'../client/spacemap/xml/resources.xml'),'utf8').includes('id="pass_local"'));
});
test('completed local objectives do not replay completion notifications for every subsequent NPC kill',()=>{
 const mission=e.MISSIONS.find(m=>m.key==='daily-npcs');e.record(db,id,{type:'npcKill',amount:20},now);
 let out=n.progressCommands(db,id,{type:'npcKill'},now,{'daily-npcs':19,'weekly-npcs':19,'season-npcs':19});assert.equal(out.filter(c=>c._==='QuestCompletedCommand'&&c.id===n.MISSION_ID).length,1);
 e.record(db,id,{type:'npcKill',amount:1},now);out=n.progressCommands(db,id,{type:'npcKill'},now,{'daily-npcs':20,'weekly-npcs':20,'season-npcs':20});assert.equal(out.filter(c=>c._==='QuestCompletedCommand').length,0);assert.ok(!out.some(c=>c.questConditionId===n.MISSION_ID*100+1));
});
