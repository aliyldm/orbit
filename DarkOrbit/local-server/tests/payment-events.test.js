'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict');
const dbModule=require('../game/db'),players=require('../game/db/players'),events=require('../game/payment-events'),loot=require('../game/loot-rewards');
const World=require('../game/world'),systems=require('../game/handlers/systems'),codec=require('../game/codec/codec');
let db,index=0;const originalWorld=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});
after(()=>{World.current=originalWorld;dbModule.close();});
function fixture(){const name=`pass-qa-${++index}`,account=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');const playerId=players.createPlayer(Number(account.lastInsertRowid),name,1,require('../config.json').starter);db.prepare('UPDATE players SET uridium=10000000,credits=42 WHERE id=?').run(playerId);return playerId;}
function amount(pid,id){return loot.count(db,pid,id);}
function grant(pid,id,n=1){loot.item(db,pid,id,n);}
function wallet(pid){return {...db.prepare('SELECT credits,uridium,ep,honour,level FROM players WHERE id=?').get(pid)};}
function unlock(pid){events.account(db,pid);db.prepare('UPDATE payment_event_accounts SET season_points=9000,gold=1,extra=1,trinity=1,voyagers=1,trinity_points=10900,voyagers_points=7600 WHERE player_id=?').run(pid);}

test('five pass types require owned items; Extra requires Gold; activation consumes once and is isolated',()=>{
 const a=fixture(),b=fixture();assert.throws(()=>events.activate(db,a,'gold'),/Yetersiz/);assert.throws(()=>events.activate(db,2147483647,'gold'),/Oyuncu/);
 grant(b,events.PASSES.gold);assert.throws(()=>events.activate(db,a,'gold'),/Yetersiz/);
 grant(a,events.PASSES.extra);assert.throws(()=>events.activate(db,a,'extra'),/önce Gold/);assert.equal(amount(a,events.PASSES.extra),1);
 for(const [pass,id]of Object.entries(events.PASSES)){if(pass!=='extra')grant(a,id);const before=amount(a,id);events.activate(db,a,pass);assert.equal(events.account(db,a)[pass],1);assert.equal(amount(a,id),before-1);assert.throws(()=>events.activate(db,a,pass),/zaten etkin/);}
 assert.equal(events.account(db,b).gold,0);assert.equal(amount(b,events.PASSES.gold),1);
});

test('purchased points consume only owner stock and cap at90 with official10honour per excess point',()=>{
 const pid=fixture(),other=fixture();grant(pid,'resource_season-pass-point',9200);grant(other,'resource_season-pass-point',100);
 const before=wallet(pid);events.usePoints(db,pid,9200);assert.equal(events.account(db,pid).season_points,9000);assert.equal(wallet(pid).honour,before.honour+2000);assert.equal(amount(pid,'resource_season-pass-point'),0);assert.equal(amount(other,'resource_season-pass-point'),100);
 for(const n of [0,-1,1.5,NaN,Infinity,2147483648])assert.throws(()=>events.usePoints(db,pid,n));assert.throws(()=>events.usePoints(db,pid,1),/Yetersiz/);
});

test('all270 localseason rewards actually grant once without requiring PET ownership',()=>{
 const pid=fixture();unlock(pid);const rows=events.claimAll(db,pid);assert.equal(rows.length,270);assert.equal(db.prepare('SELECT COUNT(*) n FROM payment_event_claims WHERE player_id=?').get(pid).n,270);
 assert.equal(events.claimAll(db,pid).length,0);assert.throws(()=>events.claim(db,pid,'gold',1),/zaten/);
 assert.equal(amount(pid,'equipment_weapon_laser_lf-4'),1);assert.ok(amount(pid,'ammunition_rocketlauncher_hstrm-01')>0);
 assert.ok(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(pid).amount>0);
 assert.equal(db.prepare('SELECT 1 FROM pets WHERE player_id=?').get(pid),undefined);
});

test('every official Trinity40/Voyagers30 reward row delivers with both thermal andcorrosive choices',()=>{
 for(const choice of ['thermal','corrosive']){const pid=fixture();unlock(pid);let count=0;
  for(const [name,max]of [['trinity',40],['voyagers',30]])for(const kind of ['free','vip'])for(let level=1;level<=max;level++){
   const r=events.claim(db,pid,`${name}-${kind}`,level,choice);assert.equal(Object.keys(r.items).length,1);for(const [id,n]of Object.entries(r.items))assert.ok(amount(pid,id)>=n,`${choice} ${name} ${kind} ${level} ${id}`);count++;
  }
  assert.equal(count,140);assert.equal(db.prepare('SELECT COUNT(*) n FROM payment_event_claims WHERE player_id=?').get(pid).n,140);
 }
 assert.equal(events.threshold(40,'trinity'),10900);assert.equal(events.threshold(30,'voyagers'),7600);
 const pid=fixture();assert.equal(events.levelOf(events.account(db,pid),'trinity'),0);assert.equal(events.levelOf(events.account(db,pid),'voyagers'),1,'FAQVoyagersfirstlevelcostis0');
});

test('server rejects lockedtracks/out-ofrangelevels and never mutates another player',()=>{
 const pid=fixture(),other=fixture();events.addPoints(db,pid,100);const before=wallet(pid);
 for(const [track,level]of [['gold',1],['extra',1],['free',2],['free',0],['free',91],['trinity-vip',1],['sql;DROP',1]])assert.throws(()=>events.claim(db,pid,track,level));
 assert.deepEqual(wallet(pid),before);assert.equal(amount(other,'ammunition_laser_mcb-50'),0);assert.equal(events.claim(db,pid,'free',1).items['ammunition_laser_mcb-50'],2000);
});

test('claimAll and receipt writes roll back all preceding rewards on a later storagefailure',()=>{
 const pid=fixture();unlock(pid);const before=wallet(pid),items=db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(pid);
 db.exec("CREATE TRIGGER fail_pass_reward BEFORE INSERT ON items WHEN NEW.loot_id='ammunition_rocket_plt-2021' BEGIN SELECT RAISE(ABORT,'pass-storage-test'); END");
 try{assert.throws(()=>events.claimAll(db,pid),/pass-storage-test/);}finally{db.exec('DROP TRIGGER fail_pass_reward');}
 assert.deepEqual(wallet(pid),before);assert.deepEqual(db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(pid),items);assert.equal(db.prepare('SELECT COUNT(*) n FROM payment_event_claims WHERE player_id=?').get(pid).n,0);
});

test('seasongameplay progresses without acceptedquests and deduplicates actual server eventIDs',()=>{
 const pid=fixture(),p=players.loadPlayer(pid),sent=[],session={player:p};
 assert.equal(db.prepare('SELECT COUNT(*) n FROM player_quests WHERE player_id=?').get(pid).n,0);
 systems.recordEvent(session,{type:'npcKill',amount:20,eventId:'npc-20'},{db,sendCmd:(s,c)=>sent.push(c)});
 assert.equal(events.account(db,pid).season_points,50);assert.ok(sent.some(c=>c._==='SeasonPointsInfoCommand'&&c.points===50));
 systems.recordEvent(session,{type:'npcKill',amount:20,eventId:'npc-20'},{db,sendCmd:()=>{}});assert.equal(events.account(db,pid).season_points,50);
 events.record(db,pid,{type:'collectLoot',lootId:'pirate_booty',amount:10,eventId:'not-bonus'});assert.equal(events.account(db,pid).season_points,50);
 events.record(db,pid,{type:'collectLoot',lootId:'bonus_box',amount:10,eventId:'bonus-10'});assert.equal(events.account(db,pid).season_points,90);
 for(const e of [{type:'npcKill',amount:0},{type:'npcKill',amount:1.5},{type:'npcKill',eventId:''},{type:'npcKill',eventId:'x'.repeat(201)}])assert.equal(events.record(db,pid,e),false);
});

test('daily/weekly resets atIstanbul05:30 and completed missions award once per period',()=>{
 const pid=fixture(),pre=Date.parse('2026-10-20T02:29:59Z'),post=Date.parse('2026-10-20T02:30:00Z');
 assert.equal(events.periodKey('daily',pre),'2026-10-19');assert.equal(events.periodKey('daily',post),'2026-10-20');
 assert.equal(events.periodKey('weekly',Date.parse('2026-10-19T02:29:59Z')),'2026-10-12');assert.equal(events.periodKey('weekly',Date.parse('2026-10-19T02:30:00Z')),'2026-10-19');
 events.record(db,pid,{type:'npcKill',amount:20,eventId:'a'},pre);events.record(db,pid,{type:'npcKill',amount:20,eventId:'b'},pre);assert.equal(events.account(db,pid).season_points,50);
 events.record(db,pid,{type:'npcKill',amount:20,eventId:'c'},post);assert.equal(events.account(db,pid).season_points,100);
});

test('runtime seasonaloverflow retains pending combat honour rather than restoring staleDB values',()=>{
 const pid=fixture(),p=players.loadPlayer(pid);unlock(pid);p.honourPoints+=123;
 systems.recordEvent({player:p},{type:'npcKill',amount:20,eventId:'honour-overflow'},{db,sendCmd:()=>{}});
 assert.equal(p.honourPoints,623);assert.equal(wallet(pid).honour,623);
});

test('classicgate localbridge is capped, deduplicated, adds VIP10percent only afteractivation',()=>{
 const pid=fixture();events.record(db,pid,{type:'gateComplete',eventId:'gate-run-1'});assert.equal(events.account(db,pid).trinity_points,100);assert.equal(events.account(db,pid).voyagers_points,100);
 grant(pid,events.PASSES.trinity);events.activate(db,pid,'trinity');events.record(db,pid,{type:'gateComplete',eventId:'gate-run-2'});assert.equal(events.account(db,pid).trinity_points,210);assert.equal(events.account(db,pid).voyagers_points,200);
 assert.equal(events.record(db,pid,{type:'gateComplete',eventId:'gate-run-2'}),false);assert.equal(events.account(db,pid).trinity_points,210);
 unlock(pid);events.record(db,pid,{type:'gateComplete',eventId:'gate-aftercap'});assert.equal(events.account(db,pid).trinity_points,10900);assert.equal(events.account(db,pid).voyagers_points,7600);
});

test('BattlePass activation gives oneperiod missionclaim and realkeyconsumption exchange',()=>{
 const pid=fixture(),now=Date.parse('2026-10-21T10:00:00Z');events.record(db,pid,{type:'npcKill',amount:20,eventId:'battle-npcs'},now);assert.throws(()=>events.claimBattle(db,pid,'daily-npcs',now),/etkinleştir/);
 grant(pid,events.PASSES.battlepass);events.activate(db,pid,'battlepass');events.claimBattle(db,pid,'daily-npcs',now);assert.equal(amount(pid,'resource_battle-pass-key'),1);assert.throws(()=>events.claimBattle(db,pid,'daily-npcs',now),/zaten/);
 events.exchange(db,pid,'battle-key-ucb');assert.equal(amount(pid,'resource_battle-pass-key'),0);assert.equal(amount(pid,'ammunition_laser_ucb-100'),2500);assert.throws(()=>events.exchange(db,pid,'battle-key-ucb'),/Yetersiz/);
});

test('official200fragmentcraftrecipes debitexactstock; localexchanges rollback failure',()=>{
 const pid=fixture();grant(pid,'resource_ignishard-l01',200);grant(pid,'resource_beacon-crystal',200);
 events.exchange(db,pid,'craft-igd-lite');events.exchange(db,pid,'craft-gl-chron');assert.equal(amount(pid,'equipment_weapon_drive_igd-l01'),1);assert.equal(amount(pid,'equipment_lens_gl-chron'),1);assert.equal(amount(pid,'resource_ignishard-l01'),0);assert.equal(amount(pid,'resource_beacon-crystal'),0);
 grant(pid,'resource_collectable_armory-token',10);db.exec("CREATE TRIGGER fail_pass_exchange BEFORE INSERT ON items WHEN NEW.loot_id='ammunition_laser_ucb-100' BEGIN SELECT RAISE(ABORT,'exchange-storage-test'); END");
 try{assert.throws(()=>events.exchange(db,pid,'armory-ucb'),/exchange-storage/);}finally{db.exec('DROP TRIGGER fail_pass_exchange');}assert.equal(amount(pid,'resource_collectable_armory-token'),10);
});

test('levelpurchases validate cap/cost and retain partial progress without inventing money',()=>{
 const pid=fixture();events.addPoints(db,pid,50);const before=wallet(pid);events.buyLevels(db,pid,2);assert.equal(wallet(pid).uridium,before.uridium-20000);assert.equal(events.account(db,pid).season_points,250);
 for(const n of [0,-1,1.5,NaN,Infinity,51])assert.throws(()=>events.buyLevels(db,pid,n));events.addPoints(db,pid,4750);assert.throws(()=>events.buyLevels(db,pid,1),/50/);
 const poor=fixture();db.prepare('UPDATE players SET uridium=9999 WHERE id=?').run(poor);assert.throws(()=>events.buyLevels(db,poor,1),/Yetersiz/);assert.equal(wallet(poor).uridium,9999);
});

test('nativecodec packets match zeroindexedrewardslots and nativeclaims remainidempotent',()=>{
 const pid=fixture(),p=players.loadPlayer(pid),handlers={},sent=[],session={player:p};events.addPoints(db,pid,100);systems.register((n,h)=>handlers[n]=h,{db,sendCmd:(s,c)=>{codec.decode(codec.encode(c));sent.push(c);}});
 for(const c of events.commands(db,pid)){const out=codec.decode(codec.encode(c)).obj;assert.equal(out._,c._);if(c._==='SeasonPassRewardInfoCommand'){assert.equal(out.freeRewardItems.length,90);assert.equal(out.freeRewardItems[0].level,0);assert.equal(out.freeRewardItems.at(-1).level,89);}}
 handlers.SeasonPassRewardClaimRequest(session,{level:0,goldPass:false,extGoldPass:false});const n=amount(pid,'ammunition_laser_mcb-50');assert.equal(n,2000);
 handlers.SeasonPassRewardClaimRequest(session,{level:0,goldPass:false,extGoldPass:false});assert.equal(amount(pid,'ammunition_laser_mcb-50'),n);assert.equal(sent.filter(c=>c._==='SeasonPassRewardClaimCommand').at(-1).claimed,true);
 const length=sent.length;handlers.SeasonPassRewardClaimRequest(session,{level:-1});assert.equal(sent.length,length);handlers.SeasonPassRewardClaimRequest(session,{level:90});assert.equal(sent.length,length);
 p.uridium+=500;handlers.SeasonPassLevelPurchaseRequest(session,{amount:1});assert.equal(p.uridium,9990500);assert.equal(wallet(pid).uridium,p.uridium);assert.equal(sent.findLast(c=>c._==='SeasonPassLevelPurchaseCommand').success,true);
 const before=p.uridium;handlers.SeasonPassLevelPurchaseRequest(session,{amount:-1});assert.equal(p.uridium,before);assert.equal(sent.findLast(c=>c._==='SeasonPassLevelPurchaseCommand').success,false);
});

test('nativeclaims synchronize livecargo/fuel aftercommit while preservingHP and pendingwallet',()=>{
 const pid=fixture(),p=players.loadPlayer(pid),handlers={},sent=[];unlock(pid);require('../game/pet').addOwned(db,pid,1);
 const world={player:p,petRuntime:{fuel:0},active:()=>true},session={player:p,world};p.uridium+=88;p.hp-=123;const hp=p.hp;
 systems.register((n,h)=>handlers[n]=h,{db,sendCmd:(s,c)=>sent.push(c)});handlers.SeasonPassRewardClaimRequest(session,{level:3,goldPass:false,extGoldPass:true});
 assert.equal(wallet(pid).uridium,10000088);assert.equal(p.hp,hp);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(pid).amount,1000);assert.ok(sent.some(c=>c._==='AttributeOreCountUpdateCommand'));
 require('../game/pet').addFuel(db,pid,1000);const out=events.refreshRuntime(db,p,world);assert.equal(world.petRuntime.fuel,1000);assert.ok(out.some(c=>c._==='PetFuelUpdateCommand'&&c.petFuelNow===1000));assert.equal(p.hp,hp);
});

test('portalshows activation/claims/missionprogress/realcrafting and explicit localbridge limitations',()=>{
 const pid=fixture(),html=events.render(players.loadPlayer(pid));assert.match(html,/internalPayment/);assert.match(html,/name="subaction" value="activate"/);assert.match(html,/classic|klasik/i);assert.match(html,/Özgün etkinlik haritası/);assert.match(html,/IgniDrive Lite/);assert.match(html,/Battle Pass/);
 const before=wallet(pid);assert.equal(events.handle(pid,new URLSearchParams({subaction:'level',amount:'-1'})).ok,false);assert.deepEqual(wallet(pid),before);
 assert.equal(events.handle(pid,new URLSearchParams()).ok,true);
});
