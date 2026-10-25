'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),r=require('../game/ranks'),d=require('../game/drone-designs');
let db,p;const now=Date.UTC(2026,9,23,12);
beforeEach(()=>{database.close();db=database.open(':memory:');p=players.createPlayer(players.createAccount('rank-design-qa','testpass'),'Pilot <QA>',1,require('../config').starter);});
afterEach(()=>database.close());
test('design-slot ownership controls Havoc/Hercules sets; cosmetic slots cannot grant bonuses and adding an uncovered drone removes a set',()=>{
 const drones=[{id:1},{id:2}],eq=(id,loot,slot='design')=>({drone_id:id,drone_slot:slot,loot_id:'drone_designs_'+loot});
 let e=d.effects(drones,[eq(1,'havoc'),eq(2,'havoc','visual')]);assert.equal(d.mounted(e,1).damage,1);e=d.effects(drones,[eq(1,'havoc'),eq(2,'havoc')]);assert.equal(d.mounted(e,1).damage,1.1);assert.equal(d.mounted(e,99).damage,1);
 assert.equal(d.effects([...drones,{id:3}],[eq(1,'havoc'),eq(2,'havoc')]).full.havoc,false);
 e=d.effects(drones,[eq(1,'hercules')]);assert.equal(e.hpBonus,0);assert.equal(d.mounted(e,1).shield,1.15);assert.equal(d.mounted(e,2).shield,1);
 assert.equal(d.effects(drones,[eq(1,'hercules'),eq(2,'hercules')]).hpBonus,.2);
});
test('Spartan individual bonus remains1% on its own drone, full10 set gives10/10/15; Hermes uses base hull, Demon uses rockets',()=>{
 const drones=Array.from({length:10},(_,i)=>({id:i+1})),equip=(type,n=10)=>drones.slice(0,n).map(x=>({drone_id:x.id,drone_slot:'design',loot_id:'drone_designs_'+type}));
 let e=d.effects(drones,equip('spartan',5));assert.equal(d.mounted(e,1).damage,1.01);assert.equal(d.mounted(e,6).damage,1);assert.equal(e.hpBonus,.05);assert.equal(d.mounted(e,1).shield,1);
 e=d.effects(drones,equip('spartan'));assert.equal(d.mounted(e,1).damage,1.1);assert.equal(d.mounted(e,1).shield,1.1);assert.equal(e.hpBonus,.15);assert.equal(d.effects(drones.slice(0,2),equip('spartan',2)).full.spartan,false);
 e=d.effects(drones,equip('hermes'));assert.equal(d.mounted(e,1).damage,1.005);assert.equal(e.baseHpBonus,.2);assert.equal(e.launcherCooldown,.9);assert.equal(e.mineCooldown,.9);assert.equal(e.abilityCooldownReduction,.1);
 e=d.effects(drones,equip('demon-epic'));assert.equal(e.rocketMultiplier,1.1);assert.equal(e.rocketCooldown,.95);assert.equal(d.mounted(e,1).damage,1);
});
test('rank ledger deduplicates a persistent NPC generation, excludes x2 starters and never invents unknown NPC points',()=>{
 const npc={mapId:3,def:{key:'boss-kristallon',normalSpawnId:5,normalSpawnSlot:0,normalSpawnGeneration:1}};
 assert.equal(r.recordNpcKill(db,p,npc,now),true);assert.equal(r.recordNpcKill(db,p,structuredClone(npc),now),false);assert.equal(r.recordNpcKill(db,p,npc,now),false);
 r.recordNpcKill(db,p,{mapId:2,def:{key:'streuner'}},now);r.recordNpcKill(db,p,{mapId:3,def:{key:'unknown'}},now);
 assert.equal(db.prepare('SELECT SUM(raw_points) n FROM rank_npc_claims').get().n,32);assert.equal(db.prepare('SELECT known FROM rank_npc_claims WHERE npc_key=?').get('unknown').known,0);
 assert.equal(r.calculate(db,p,now).breakdown.npcKills,16);r.recordDeath(db,p,{radiation:true});assert.equal(r.calculate(db,p,now).breakdown.radiationDeaths,-8);
});
test('ineligible negative-honour pilots cannot receive the unverified21 badge or company leader rank',()=>{
 const pilot={playerId:1,eligible:false,factionId:1,points:100000,breakdown:{honour:-10}};assert.equal(r.assign([pilot]).get(1),1);
});
test('rank is age/level eligible and frozen until daily05:30 reset; company leader is General and web rankings contain only local names',()=>{
 db.prepare('UPDATE accounts SET created_at=?').run(now-40*r.DAY);db.prepare('UPDATE players SET ep=10000000,honour=100000,level=18 WHERE id=?').run(p);
 r.refreshDaily(db,now,{force:true});let current=r.current(db,p,now);assert.equal(current.dailyRank,20);assert.equal(current.eligible,true);assert.equal(current.breakdown.experience,100);assert.equal(current.breakdown.honour,1000);assert.equal(current.breakdown.level,1800);
 const frozen=current.dailyPoints;db.prepare('UPDATE players SET ep=ep+100000 WHERE id=?').run(p);assert.equal(r.current(db,p,now+1000).dailyPoints,frozen);assert.notEqual(r.current(db,p,Date.UTC(2026,9,24,3)).dailyPoints,frozen);
 const template='<div id="mainContainerContent"><table id="ranking_Users"><tr><td>IMPORTED_USER</td></tr></table><table id="ranking_Clans"><td>OLD_CLAN</td></table></div>';
 const html=require('../web/portal/rankings').decorate(template,{userId:p});assert.doesNotMatch(html,/IMPORTED_USER|OLD_CLAN/);assert.match(html,/Pilot &lt;QA&gt;/);
 assert.equal(r.dayKey(Date.UTC(2026,9,24,2,29)),r.dayKey(now));assert.notEqual(r.dayKey(Date.UTC(2026,9,24,2,30)),r.dayKey(now));
});
