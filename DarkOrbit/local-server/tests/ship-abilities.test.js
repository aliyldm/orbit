'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),abilities=require('../game/ship-abilities'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let n=0;
function fixture(ship='ship_diminisher'){
 const a=players.createAccount(`ability-${++n}`,'testpass'),id=players.createPlayer(a,'Ability QA',1,{...config.starter,ship}),world=new World(config),commands=[],session={world,send(){},close(){}};world.login(session,id);Object.assign(world.player,{x:6000,y:6000});
 const combat=new Combat(world,(s,c)=>{codec.encode(c);commands.push(c);});combat.map=maps.getMap(1);return{world,session,p:world.player,id,commands,combat};
}
function target(f,{hp=100000,shield=10000,reward={}}={}){const npc=f.combat.spawn({typeId:84,name:'QA',hitpoints:hp,shield,speed:200,damageMin:1000,damageMax:1000,reward,respawnMs:5000});Object.assign(npc,{x:6200,y:6000});f.session.selected=npc.id;return npc;}
function use(f,name,now=Date.now()){return abilities.action(f.session,{menuItemId:'ability_'+name,actionType:1},now);}
function finish(f){f.world.removeSession(f.session);}

test('only actual owned active classic hull exposes its captured ability menu and cosmetic art does not remove it',()=>{
 const f=fixture();f.p.typeId='ship_diminisher_design_diminisher-lava';
 const out=abilities.buildInit(f.world);for(const c of out)codec.encode(c);assert.equal(out.filter(c=>c.visible).length,1);assert.equal(out.find(c=>c.visible).menuItemId,'ability_diminisher');assert.equal(use(f,'solace'),false);assert.ok(out.some(c=>c.menuItemId==='ability_spearhead_jam-x'&&!c.available&&!c.activatable));
 db.prepare('UPDATE players SET active_ship_id=NULL WHERE id=?').run(f.id);assert.equal(use(f,'diminisher'),false);db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(f.p.shipId,f.id);finish(f);
 const basic=fixture('ship_goliath');assert.equal(abilities.buildInit(basic.world).some(c=>c.available),false);finish(basic);
});

test('Diminisher validates selected NPC and range, sends real activation, and adds shield-only laser damage',()=>{
 const f=fixture(),npc=target(f),now=Date.now();npc.x=10000;assert.equal(use(f,'diminisher',now),false);npc.x=6200;assert.equal(use(f,'diminisher',now),true);assert.equal(use(f,'diminisher',now+1),false);
 assert.ok(f.commands.some(c=>c._==='AbilityStartCommand'&&c.selectedAbilityId===2));assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message===`0|n|SD|A|2|1|${f.id}|${npc.id}`));assert.ok(f.commands.some(c=>c._==='MenuItemCooldownGroupTimerCommand'&&c.cooldownType.typeValue===37));
 assert.equal(f.combat.applyLaserDamage(f.p,npc,1000,'ammunition_laser_lcb-10',.8),1400);assert.equal(npc.shield,8800);assert.equal(npc.hp,99800);
 npc.shield=100;f.combat.applyLaserDamage(f.p,npc,1000,'ammunition_laser_lcb-10',.8);assert.equal(npc.hp,98900);assert.equal(npc.shield,0);finish(f);
});

test('Diminisher expiry removes its effect and applies documented current-shield drawback once',()=>{
 const f=fixture(),npc=target(f),now=Date.now();f.p.shield=1000;use(f,'diminisher',now);abilities.tick(f.world,f.combat,now+14999);assert.ok(f.world.shipAbility);abilities.tick(f.world,f.combat,now+15000);assert.equal(f.world.shipAbility,null);assert.equal(f.p.shield,700);abilities.tick(f.world,f.combat,now+15001);assert.equal(f.p.shield,700);assert.equal(abilities.shieldBonus(f.world,npc),1);assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message.startsWith('0|n|SD|D|2|')));finish(f);
});

test('Solace restores exactly 35 percent of max hull with a cap and rejects full-hull reuse',()=>{
 const f=fixture('ship_solace'),now=Date.now();assert.equal(use(f,'solace',now),false);f.p.hitPoints=Math.round(f.p.hitMax*.5);const before=f.p.hitPoints;assert.equal(use(f,'solace',now),true);assert.equal(f.p.hitPoints,before+Math.round(f.p.hitMax*.35));assert.equal(players.loadPlayer(f.id).hitPoints,f.p.hitPoints);assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message===`0|n|SD|A|1|2|${f.id}`));assert.equal(use(f,'solace',now+1),false);finish(f);
});
test('owned cooldown boosters shorten a newly activated ability and never rewrite an existing deadline',()=>{
 const f=fixture('ship_solace'),now=Date.now();f.p.hitPoints=1;
 require('../game/boosters').addOwned(db,f.id,'booster_cd-b01');require('../game/boosters').addOwned(db,f.id,'booster_cd-b02');
 assert.equal(use(f,'solace',now),true);
 const stored=JSON.parse(db.prepare("SELECT value FROM settings WHERE player_id=? AND key='game.shipAbilityCooldowns'").get(f.id).value);
 assert.equal(stored.solace,now+45000);
 db.prepare('DELETE FROM player_boosters WHERE player_id=?').run(f.id);
 assert.equal(use(f,'solace',now+44999),false);assert.equal(use(f,'solace',now+45000),true);
 finish(f);
});

test('Spectrum and Sentinel affect actual NPC laser shield/hull allocation and own Spectrum laser output',()=>{
 const a=fixture('ship_spectrum'),now=Date.now();a.p.shield=10000;use(a,'spectrum',now);const oldDamage=a.combat.cfg.damageSpread;a.combat.cfg={...a.combat.cfg,damageSpread:0};assert.equal(a.combat.playerDamage(a.p),Math.round(a.p.stats.laserDamage*(a.p.ammoMultiplier||1)*(a.p.stats.npcLaserMultiplier??1)*.75));
 const state={hp:10000,shield:10000};assert.equal(abilities.incoming(a.world,state,1000,.8),100);assert.deepEqual(state,{hp:9980,shield:9920});a.combat.cfg.damageSpread=oldDamage;finish(a);
 const b=fixture('ship_sentinel');use(b,'sentinel',now);const s={hp:10000,shield:10000};assert.equal(abilities.incoming(b.world,s,1000,.8),760);assert.deepEqual(s,{hp:9800,shield:9440});finish(b);
});

test('Venom ticks directly on hull, increases damage, awards one real kill and never affects a replacement object',()=>{
 const f=fixture('ship_venom'),npc=target(f,{hp:3200,shield:10000,reward:{credits:55,ep:100}}),now=Date.now();use(f,'venom',now);abilities.tick(f.world,f.combat,now+999);assert.equal(npc.hp,3200);abilities.tick(f.world,f.combat,now+1000);assert.equal(npc.hp,1700);assert.equal(npc.shield,10000);abilities.tick(f.world,f.combat,now+2000);assert.equal(npc.hp,0);assert.equal(f.p.credits,55);abilities.tick(f.world,f.combat,now+3000);assert.equal(f.p.credits,55);finish(f);
 const g=fixture('ship_venom'),first=target(g);use(g,'venom',now);const replacement={...first,hp:99999};g.combat.npcs.set(first.id,replacement);abilities.tick(g.world,g.combat,now+1000);assert.equal(replacement.hp,99999);assert.equal(g.world.shipAbility,null);finish(g);
});

test('Lightning changes authoritative movement duration and restores speed without compounding after a stat refresh',()=>{
 const f=fixture('ship_v-lightning'),now=Date.now(),base=f.p.speed;f.world.now=()=>now;f.world.move(f.session,{positionX:6000,positionY:6000,targetX:10000,targetY:6000});assert.equal(use(f,'lightning',now),true);assert.equal(f.p.speed,Math.round(base*1.3));assert.ok(Math.abs(f.world.movement.duration-4000/f.p.speed*1000)<.01);
 abilities.tick(f.world,f.combat,now+1000);assert.equal(f.p.speed,Math.round(base*1.3));f.p.speed=base+10;abilities.tick(f.world,f.combat,now+1001);assert.equal(f.p.speed,Math.round((base+10)*1.3));abilities.tick(f.world,f.combat,now+5000);assert.equal(f.p.speed,base+10);assert.ok(f.commands.some(c=>c._==='AttributeShipSpeedUpdateCommand'));finish(f);
});

test('cooldown survives reconnect and ready status returns at the stored deadline',()=>{
 const f=fixture('ship_sentinel'),now=Date.now();use(f,'sentinel',now);finish(f);const next={world:f.world,send(){},close(){}};f.world.login(next,f.id);assert.equal(f.world.shipAbility,null);assert.equal(abilities.action(next,{menuItemId:'ability_sentinel',actionType:1},now+1000),false);assert.ok(abilities.buildInit(f.world,now+1000).some(c=>c._==='MenuItemCooldownGroupTimerCommand'&&c.time===179000));assert.equal(abilities.buildInit(f.world,now+180000).find(c=>c.menuItemId==='ability_sentinel').activatable,true);f.world.removeSession(next);
});

test('death, jump and map replacement cancel effects while leaving persisted cooldown intact',()=>{
 for(const mode of ['death','jump','map']){const f=fixture(),now=Date.now();target(f);f.p.shield=1000;use(f,'diminisher',now);if(mode==='death')f.combat.killPlayer({def:{name:'QA'}});if(mode==='jump'){f.session.jumping=true;abilities.tick(f.world,f.combat,now+1);}if(mode==='map'){f.p.mapId=2;abilities.tick(f.world,f.combat,now+1);}assert.equal(f.world.shipAbility,null);assert.equal(f.p.shield,1000);assert.ok(db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(f.id,'game.shipAbilityCooldowns'));finish(f);}
});

test('failed cooldown persistence sends no activation and unauthenticated or selection-only requests cannot activate',()=>{
 const f=fixture('ship_solace');f.p.hitPoints=100;assert.equal(abilities.action(f.session,{menuItemId:'ability_solace',actionType:0}),false);assert.equal(abilities.action({world:f.world,player:f.p},{menuItemId:'ability_solace',actionType:1}),false);
 db.exec("CREATE TRIGGER fail_ability BEFORE INSERT ON settings WHEN NEW.key='game.shipAbilityCooldowns' BEGIN SELECT RAISE(ABORT,'storage failure'); END");assert.throws(()=>use(f,'solace'),/storage failure/);db.exec('DROP TRIGGER fail_ability');assert.equal(f.p.hitPoints,100);assert.ok(!f.commands.some(c=>c._==='AbilityStartCommand'));assert.equal(f.world.shipAbility,undefined);finish(f);
});

test('real Combat.tick emits reduced NPC hit damage during Spectrum and restores normal damage on expiry',()=>{
 const f=fixture('ship_spectrum'),now=Date.now(),npc=target(f);f.p.shield=10000;f.p.stats.shieldAbsorb=.8;npc.aggro=f.session;use(f,'spectrum',now);f.combat.tick(now+1);let hits=f.commands.filter(c=>c._==='AttackHitCommand'&&c.victimId===f.id);assert.equal(hits.at(-1).damage,100);
 f.combat.tick(now+10000);hits=f.commands.filter(c=>c._==='AttackHitCommand'&&c.victimId===f.id);assert.equal(hits.at(-1).damage,1000);finish(f);
});

test('all six default activation and cooldown timers match official classic ship FAQs',()=>{
 const expected={solace:[0,90000],diminisher:[15000,90000],spectrum:[10000,180000],sentinel:[35000,180000],venom:[35000,120000],lightning:[5000,180000]};
 for(const def of abilities.DEFINITIONS){
  const [duration,cooldown]=expected[def.name],f=fixture(def.ship),now=Date.now();target(f);if(def.name==='solace')f.p.hitPoints=100;
  assert.equal(use(f,def.name,now),true);
  const timer=f.commands.find(c=>c._==='MenuItemCooldownGroupTimerCommand');assert.equal(timer.maxTime,cooldown);
  const active=f.commands.find(c=>c._==='MenuItemTimerCommand'&&c.menuItemId===def.menu);
  assert.equal(active?.maxTime||0,duration);
  assert.equal(abilities.buildInit(f.world,now+cooldown-1).find(c=>c.menuItemId===def.menu).activatable,false);
  abilities.tick(f.world,f.combat,now+duration);
  assert.equal(abilities.buildInit(f.world,now+cooldown).find(c=>c.menuItemId===def.menu).activatable,true);finish(f);
 }
});

test('laser defensive abilities preserve rocket damage and route hull damage through NanoHull',()=>{
 for(const [ship,laserDamage] of [['ship_spectrum',100],['ship_sentinel',760]]){
  const f=fixture(ship);use(f,ship.slice(5));
  const laser={hp:10000,shield:10000,nanoHull:1000};assert.equal(abilities.incoming(f.world,laser,1000,.8,1),laserDamage);
  assert.equal(laser.hp,10000);assert.ok(laser.nanoHull<1000);
  const rocket={hp:10000,shield:10000,nanoHull:1000};assert.equal(abilities.incoming(f.world,rocket,1000,.8,0),1000);assert.deepEqual(rocket,{hp:10000,shield:9200,nanoHull:800});finish(f);
 }
});

test('Solace repairs HP without manufacturing or clearing existing NanoHull in the wire update',()=>{
 const f=fixture('ship_solace');Object.assign(f.p,{hitPoints:100,nanoHull:1234,maxNanoHull:356000});use(f,'solace');
 const command=f.commands.find(c=>c._==='HitpointInfoCommand');assert.equal(command.nanoHull,1234);assert.equal(command.nanoHullMax,356000);assert.equal(f.p.nanoHull,1234);finish(f);
});

test('failed Solace hull persistence rolls back cooldown and emits no activation or phantom healing',()=>{
 const f=fixture('ship_solace');f.p.hitPoints=100;
 db.exec('CREATE TRIGGER fail_heal BEFORE UPDATE OF hitpoints ON ships BEGIN SELECT RAISE(ABORT,\'heal storage failure\'); END');assert.throws(()=>use(f,'solace'),/heal storage failure/);db.exec('DROP TRIGGER fail_heal');assert.equal(f.p.hitPoints,100);assert.ok(!f.commands.some(c=>c._==='AbilityStartCommand'));assert.equal(db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(f.id,'game.shipAbilityCooldowns'),undefined);finish(f);
});

test('Venom reward storage failure retains the original target and retries its lethal tick without fake destruction',()=>{
 const f=fixture('ship_venom'),npc=target(f,{hp:1000,reward:{credits:55}}),now=Date.now();use(f,'venom',now);
 db.exec('CREATE TRIGGER fail_venom_reward BEFORE UPDATE OF credits ON players BEGIN SELECT RAISE(ABORT,\'reward failure\'); END');assert.throws(()=>abilities.tick(f.world,f.combat,now+1000),/reward failure/);db.exec('DROP TRIGGER fail_venom_reward');
 assert.equal(npc.hp,1000);assert.equal(f.p.credits,0);assert.equal(f.combat.npcs.get(npc.id),npc);assert.ok(!f.commands.some(c=>c._==='ShipDestroyedCommand'||c._==='AttackHitCommand'));
 abilities.tick(f.world,f.combat,now+1000);assert.equal(npc.hp,0);assert.equal(f.p.credits,55);assert.equal(f.commands.filter(c=>c._==='ShipDestroyedCommand').length,1);finish(f);
});
