'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),abilities=require('../game/ship-abilities'),expanded=require('../game/ship-abilities-expanded'),codec=require('../game/codec/codec'),config=require('../config');
let db,fixtures;
beforeEach(()=>{database.close();db=database.open(':memory:');fixtures=[];});
afterEach(()=>{for(const f of fixtures)f.w.removeSession(f.s);database.close();});
function fixture(ship='ship_berserker'){
 const id=players.createPlayer(players.createAccount('reflection-'+fixtures.length,'qa-pass'),'Reflection QA',1,{...config.starter,ship}),w=new World(config),commands=[],s={world:w,send(){}};w.login(s,id);Object.assign(w.player,{x:6000,y:6000,hitPoints:100000,shield:0,nanoHull:0});const combat=new Combat(w,(s,c)=>{const d=codec.decode(codec.encode(c));assert.equal(d.rest,0);commands.push(d.obj);});combat.map=maps.getMap(1);combat.rollHit=()=>true;const f={id,w,s,p:w.player,combat,commands};fixtures.push(f);return f;
}
const use=(f,id,now=100000)=>abilities.action(f.s,{menuItemId:id,actionType:1},now);
function npc(f,hp=100000,shield=0,reward={}){return f.combat.spawn({key:'reflection-qa',typeId:84,name:'Reflection QA target',hitpoints:hp,shield,speed:0,damageMin:0,damageMax:0,reward,transient:true},{x:6200,y:6000});}
test('Berserk dynamically boosts only owner laser damage by lost hull percentage, excluding NanoHull',()=>{
 const f=fixture();assert.equal(use(f,'ability_berserker_bsk'),true);
 for(const [ratio,expected]of [[1,10000],[.75,12500],[.5,15000],[.01,19900]]){f.p.hitPoints=f.p.hitMax*ratio;f.p.nanoHull=500000;assert.equal(abilities.outgoing(f.w,10000),expected);}
 f.p.hitPoints=f.p.hitMax+100;assert.equal(abilities.outgoing(f.w,10000),10000);assert.equal(f.p.stats.rocketMultiplier,1);
 abilities.tick(f.w,f.combat,130000);assert.equal(abilities.outgoing(f.w,10000),10000);assert.equal(use(f,'ability_berserker_bsk',159999),false);assert.equal(use(f,'ability_berserker_bsk',160000),true);
 assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===84&&c.activated));
});
test('Revenge uses current official five-percent damage taken and full reflection for lasers and rockets',()=>{
 const f=fixture(),n=npc(f),speed=f.p.speed;use(f,'ability_berserker_rvg');assert.equal(f.p.speed,Math.round(speed*.95));
 for(const [attackType,damage]of [[1,2000],[2,4000]]){const hp=f.p.hitPoints,enemy=n.hp;assert.equal(f.combat.damagePlayer(n,damage,{now:101000,attackType}),Math.round(damage*.05));assert.equal(f.p.hitPoints,hp-Math.round(damage*.05));assert.equal(n.hp,enemy-damage);}
 assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===85&&c.activated));assert.equal(expanded.npcIncoming(f.w,f.combat,n,1000,106000).damage,1000);
 abilities.tick(f.w,f.combat,106000);assert.equal(f.p.speed,speed);assert.equal(use(f,'ability_berserker_rvg',279999),false);assert.equal(use(f,'ability_berserker_rvg',280000),true);
});
test('Revenge reflection does not use Berserk laser bonus; both abilities can run concurrently',()=>{
 const f=fixture(),n=npc(f);f.p.hitPoints=f.p.hitMax/2;use(f,'ability_berserker_bsk');use(f,'ability_berserker_rvg');assert.equal(abilities.outgoing(f.w,10000),15000);
 f.combat.damagePlayer(n,1000,{now:101000});assert.equal(n.hp,99000);assert.equal(f.w.expandedAbilityRuns.size,2);
});
test('Revenge reflects through normal enemy shield absorption and never bypasses invulnerable NPCs',()=>{
 const f=fixture(),n=npc(f,100000,10000);use(f,'ability_berserker_rvg');f.combat.damagePlayer(n,1000,{now:101000});assert.deepEqual([n.hp,n.shield],[99800,9200]);
 n.def.invulnerable=true;const hp=f.p.hitPoints;f.combat.damagePlayer(n,1000,{now:102000});assert.deepEqual([n.hp,n.shield],[99800,9200]);assert.equal(f.p.hitPoints,hp-50);
});
test('protection and misses prevent both retaliation damage and self damage',()=>{
 const f=fixture(),n=npc(f);use(f,'ability_berserker_rvg');f.combat.rollHit=()=>false;const hp=f.p.hitPoints;assert.equal(f.combat.damagePlayer(n,1000,{now:101000}),0);assert.equal(n.hp,100000);assert.equal(f.p.hitPoints,hp);
});
test('a reflected kill uses real rewards exactly once and leaves the Berserker with five percent damage',()=>{
 const f=fixture(),n=npc(f,100,0,{credits:123,ep:100}),credits=f.p.credits,hp=f.p.hitPoints;use(f,'ability_berserker_rvg');f.combat.damagePlayer(n,1000,{now:101000});assert.equal(f.combat.npcs.has(n.id),false);assert.equal(f.p.credits,credits+123);assert.equal(f.p.hitPoints,hp-50);
 f.combat.damagePlayer(n,1000,{now:102000});assert.equal(f.p.credits,credits+123);assert.equal(f.commands.filter(c=>c._==='ShipDestroyedCommand'&&c.destroyedUserId===n.id).length,1);
});
test('failed reflection reward persistence restores enemy state and does not apply partial self damage',()=>{
 const f=fixture(),n=npc(f,100,10,{credits:123,ep:100}),before={hp:n.hp,shield:n.shield,lastHit:n.lastHit,aggro:n.aggro},hp=f.p.hitPoints,credits=f.p.credits;use(f,'ability_berserker_rvg');
 db.exec("CREATE TRIGGER deny_reflected_reward BEFORE UPDATE OF credits ON players BEGIN SELECT RAISE(ABORT,'reflection-storage'); END");
 assert.throws(()=>f.combat.damagePlayer(n,1000,{now:101000}),/reflection-storage/);assert.equal(f.combat.npcs.get(n.id),n);for(const[k,v]of Object.entries(before))assert.equal(n[k],v);assert.equal(f.p.hitPoints,hp);assert.equal(f.p.credits,credits);assert.equal(f.commands.filter(c=>c._==='ShipDestroyedCommand').length,0);db.exec('DROP TRIGGER deny_reflected_reward');
});
test('Orcus takes twenty percent before healing eighty percent of NPC damage and does not replenish shields/NanoHull',()=>{
 const f=fixture('ship_orcus'),n=npc(f);use(f,'ability_orcus_assimilate');f.p.hitPoints=1000;assert.equal(f.combat.damagePlayer(n,1000,{now:101000}),200);assert.equal(f.p.hitPoints,1600);
 f.p.shield=1000;f.p.stats.shieldAbsorb=.8;const nano=f.p.nanoHull;assert.equal(f.combat.damagePlayer(n,1000,{now:102000}),200);assert.equal(f.p.hitPoints,2360);assert.equal(f.p.shield,840);assert.equal(f.p.nanoHull,nano);
 f.p.hitPoints=f.p.hitMax-1;f.combat.damagePlayer(n,1000,{now:103000});assert.equal(f.p.hitPoints,f.p.hitMax);assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===99&&c.activated));
});
test('fatal Orcus damage kills before conversion can heal or revive it',()=>{
 const f=fixture('ship_orcus'),n=npc(f);use(f,'ability_orcus_assimilate');f.p.hitPoints=100;f.combat.damagePlayer(n,1000,{now:101000});assert.equal(f.p.dead,true);assert.equal(f.p.hitPoints,0);assert.equal(f.w.expandedAbilityRuns.size,0);
 const cd=JSON.parse(db.prepare("SELECT value FROM settings WHERE player_id=? AND key='game.expandedShipCooldowns'").get(f.id).value);assert.equal(cd['ability_orcus_assimilate']>Date.now(),true);
});
test('Orcus conversion cannot be manually cancelled, ends at exact deadline and starts cooldown afterwards',()=>{
 const f=fixture('ship_orcus'),n=npc(f);use(f,'ability_orcus_assimilate');assert.equal(use(f,'ability_orcus_assimilate',101000),false);assert.equal(expanded.status(f.w,'ability_orcus_assimilate',{},101000).activatable,false);
 assert.equal(expanded.npcIncoming(f.w,f.combat,n,1000,119999).heal,800);assert.equal(expanded.npcIncoming(f.w,f.combat,n,1000,120000).heal,0);abilities.tick(f.w,f.combat,120000);
 assert.equal(use(f,'ability_orcus_assimilate',659999),false);assert.equal(use(f,'ability_orcus_assimilate',660000),true);
});
test('Orcus conversion rejects stale/non-NPC sources and misses do not manufacture healing',()=>{
 const f=fixture('ship_orcus'),n=npc(f);use(f,'ability_orcus_assimilate');assert.deepEqual(expanded.npcIncoming(f.w,f.combat,{id:42,hp:100},1000,101000),{damage:1000,heal:0});
 f.combat.rollHit=()=>false;const hp=f.p.hitPoints;assert.equal(f.combat.damagePlayer(n,1000,{now:101000}),0);assert.equal(f.p.hitPoints,hp);
});
test('Orcus also converts a Barracuda self-destruction after its NPC was retired before the blast',()=>{
 const f=fixture('ship_orcus'),n=npc(f);use(f,'ability_orcus_assimilate');n.selfDestructAt=101000;f.combat.npcs.delete(n.id);n.hp=0;f.p.hitPoints=1000;assert.equal(f.combat.damagePlayer(n,1000,{now:101000,attackType:2,evade:false}),200);assert.equal(f.p.hitPoints,1600);
});
test('Orcus current Amplify multiplies combined positive and negative module effects by 1.75',()=>{
 const p=require('../game/ship-passives'),base={hitMax:10000,shieldMax:10000,laserDamage:10000,rocketMultiplier:1,shipModules:{hit:-.08,shield:.10,damage:.06,evasion:.04,laserAccuracy:.02}};
 const s=p.applyStats('ship_orcus',base);assert.equal(s.hitMax,8600);assert.equal(s.shieldMax,11750);assert.equal(s.laserDamage,11050);assert.equal(s.rocketMultiplier,1.105);assert.equal(s.moduleEvasion,.07);assert.equal(s.laserHitBonus,.035);assert.equal(base.shipModules.hit,-.08);
 assert.equal(p.applyStats('ship_berserker',base).hitMax,9200);
});
test('verified Mimesis/Cyborg/SpearheadPlus passives survive the real stats pipeline without marking missing abilities complete',()=>{
 const passives=require('../game/ship-passives'),audit=require('../game/shop-product-audit'),base={hitMax:10000,shieldMax:10000,laserDamage:10000,rocketMultiplier:1};
 assert.equal(passives.applyStats('ship_cyborg',base).laserDamage,11000);assert.equal(passives.applyStats('ship_mimesis',base).shieldMax,11000);assert.equal(passives.applyStats('ship_mimesis',base).shieldPenetration,.05);assert.equal(passives.applyStats('ship_spearhead-plus',base).moduleEvasion,.05);
 for(const ship of ['ship_cyborg','ship_mimesis'])assert.equal(audit.classify(ship).status,'partial');
 const f=fixture('ship_mimesis');assert.equal(f.p.stats.shieldPenetration,.05);const n=npc(f,100000,10000);f.combat.applyLaserDamage(f.p,n,1000,'ammunition_laser_lcb-10',Math.max(0,f.combat.npcAbsorb(n)-f.p.stats.shieldPenetration));assert.deepEqual([n.hp,n.shield],[99750,9250]);
});
test('map/ship/session teardown removes speed and visual effects but preserves cooldowns',()=>{
 const f=fixture(),speed=f.p.speed;use(f,'ability_berserker_rvg');f.s.jumping=true;abilities.tick(f.w,f.combat,101000);assert.equal(f.p.speed,speed);assert.equal(f.w.expandedAbilityRuns.size,0);f.s.jumping=false;assert.equal(use(f,'ability_berserker_rvg',102000),false);
 assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===85&&!c.activated));
});
test('Mimesis Scramble consumes ten percent max shield each second, boosts lasers/speed and uses corrected65% evasion',()=>{
 const f=fixture('ship_mimesis'),speed=f.p.speed;f.p.shield=f.p.shieldMax=100000;assert.equal(use(f,'ability_mimesis_scramble'),true);assert.equal(f.p.speed,Math.round(speed*1.25));assert.equal(abilities.outgoing(f.w,10000),12500);assert.equal(expanded.evasion(f.w,101000),.65);
 abilities.tick(f.w,f.combat,100999);assert.equal(f.p.shield,100000);abilities.tick(f.w,f.combat,101000);assert.equal(f.p.shield,90000);abilities.tick(f.w,f.combat,110000);assert.equal(f.p.shield,0);assert.equal(f.p.speed,speed);assert.equal(abilities.outgoing(f.w,10000),10000);assert.equal(expanded.evasion(f.w,110000),0);assert.equal(use(f,'ability_mimesis_scramble',120000),false);
 assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===3&&!c.activated));
});
test('Mimesis shield replenishment sustains Scramble beyond the captured30s display duration',()=>{
 const f=fixture('ship_mimesis');f.p.shield=f.p.shieldMax=100000;use(f,'ability_mimesis_scramble');const n=npc(f,100000,1000000);
 for(let i=1;i<=35;i++){f.p.shield=90000;f.combat.applyLaserDamage(f.p,n,10000,'ammunition_laser_sab-50');abilities.tick(f.w,f.combat,100000+i*1000);assert.equal(f.p.shield,90000);}
 assert.equal(f.w.expandedAbilityRuns.has('ability_mimesis_scramble'),true);assert.equal(use(f,'ability_mimesis_scramble',136000),true);assert.equal(f.w.expandedAbilityRuns.size,0);
});
test('Mimesis attack evasion reaches real NPC laser rolls and shield loss cancels it in the same hit',()=>{
 const f=fixture('ship_mimesis'),n=npc(f);f.p.shield=f.p.shieldMax=100000;use(f,'ability_mimesis_scramble');let chance;f.combat.rollHit=value=>{chance=value;return false;};f.combat.damagePlayer(n,1000,{now:101000});assert.ok(Math.abs(chance-.35)<1e-9);
 f.combat.rollHit=()=>true;f.p.shield=1;f.p.stats.shieldAbsorb=.8;f.combat.damagePlayer(n,1000,{now:102000});assert.equal(f.w.expandedAbilityRuns.size,0);assert.equal(expanded.evasion(f.w,102000),0);
});
test('Mimesis config changes stop Scramble synchronously during stat refresh and reject empty shields',()=>{
 const f=fixture('ship_mimesis');assert.equal(use(f,'ability_mimesis_scramble'),false);f.p.shield=f.p.shieldMax=100000;use(f,'ability_mimesis_scramble');db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(f.p.shipId);f.w.refreshStats();assert.equal(f.w.expandedAbilityRuns.size,0);assert.equal(f.p.speed,players.loadPlayer(f.id).speed);
});
test('late rocket kill of an old target preserves current selection and ongoing laser attack',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});const f=fixture('ship_goliath'),old=npc(f,100),current=npc(f,1000000),inv=require('../game/inventory'),launcher=require('../game/hellstorm');
 const item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_weapon_rocketlauncher_hst-1',1)").run(f.id).lastInsertRowid);inv.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[item]},to:{target:'ship',slotset:'heavy_guns'}});db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'ammunition_rocketlauncher_eco-10',3)").run(f.id);
 f.combat.select(f.s,old.id);launcher.state(f.w).loaded=3;assert.equal(launcher.fire(f.s,old.id),true);f.combat.select(f.s,current.id);f.combat.attack(f.s,current.id);const mark=f.commands.length;t.mock.timers.tick(2500);
 assert.equal(f.combat.npcs.has(old.id),false);assert.equal(f.s.selected,current.id);assert.equal(f.s.attacking,current.id);assert.ok(current.hp<1000000);assert.equal(f.commands.slice(mark).some(c=>c._==='ShipDeselectionCommand'),false);assert.equal(f.commands.slice(mark).some(c=>c._==='AttackAbortLaserCommand'&&c.uid===f.id),false);
});
test('Citadel Fortify stops existing movement, rejects movement requests and reduces lasers/rockets by50%',()=>{
 const f=fixture('ship_citadel'),speed=f.p.speed;f.w.movement={x:6000,y:6000,targetX:10000,targetY:6000,start:100000,duration:10000};assert.equal(use(f,'ability_citadel_fortify'),true);assert.equal(f.p.speed,0);assert.equal(f.w.movement,null);
 assert.equal(f.w.move(f.s,{positionX:6000,positionY:6000,targetX:10000,targetY:6000}),false);assert.equal(expanded.incoming(f.w,1000,1),500);assert.equal(expanded.incoming(f.w,1000,2),500);assert.equal(abilities.outgoing(f.w,1000),1000);
 abilities.tick(f.w,f.combat,110000);assert.equal(f.p.speed,speed);assert.equal(f.w.move(f.s,{positionX:6000,positionY:6000,targetX:10000,targetY:6000}),true);assert.equal(use(f,'ability_citadel_fortify',459999),false);assert.equal(use(f,'ability_citadel_fortify',460000),true);
});
test('Citadel Plus Fortify blocks new abilities while previously active Prismatic Endurance continues',()=>{
 const f=fixture('ship_citadel-plus');assert.equal(use(f,'ability_citadel_fortify'),true);assert.equal(use(f,'ability_citadel-plus_prismatic-endurance',101000),false);abilities.stop(f.w,{now:110000});
 assert.equal(use(f,'ability_citadel-plus_prismatic-endurance',459000),true);assert.equal(use(f,'ability_citadel_fortify',460000),true);assert.equal(f.w.expandedAbilityRuns.size,2);assert.equal(expanded.incoming(f.w,1000,1),100);assert.equal(expanded.incoming(f.w,1000,2),500);
});
test('Citadel Elite uses embedded8s Fortify; stat refresh cannot undo immobility and map teardown restores speed',()=>{
 const f=fixture('ship_c-elite'),speed=f.p.speed;use(f,'ability_citadel_fortify');assert.equal(f.w.expandedAbilityRuns.get('ability_citadel_fortify').until,108000);f.w.refreshStats();assert.equal(f.p.speed,0);f.s.jumping=true;abilities.tick(f.w,f.combat,101000);assert.equal(f.p.speed,speed);assert.equal(f.w.expandedAbilityRuns.size,0);
});
