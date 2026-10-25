'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),techs=require('../game/techs'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let index=0;
function fixture(){const a=players.createAccount(`tech-qa-${++index}`,'testpass'),id=players.createPlayer(a,'Tech QA',1,{...config.starter,ship:'ship_goliath'}),w=new World(config),commands=[],s={world:w,send(){},close(){}};w.login(s,id);const p=w.player;Object.assign(p,{x:6000,y:6000});const combat=new Combat(w,(_,c)=>{codec.encode(c);commands.push(c);});combat.map=maps.getMap(1);return{w,p,s,id,combat,commands};}
function stock(f,id,n=2){db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,n);}
function count(f,id){return techs.quantities(f.p).get(id)||0;}
function use(f,id,now=Date.now()){return techs.action(f.s,{menuItemId:id,actionType:1},now);}
function target(f,{hp=1000000,shield=0,x=6200,y=6000}={}){const n=f.combat.spawn({typeId:84,name:'Tech QA NPC',hitpoints:hp,shield,speed:200,damageMin:1,damageMax:1,reward:{},respawnMs:5000});Object.assign(n,{x,y});f.s.selected=n.id;return n;}
function finish(f){f.w.removeSession(f.s);}

test('nine supported techs expose real stock and six unsupported techs never become activatable',()=>{
 const f=fixture();assert.equal(Object.keys(techs.DEFINITIONS).length,9);assert.equal(Object.keys(techs.UNSUPPORTED).length,6);
 for(const id of [...Object.keys(techs.DEFINITIONS),...Object.keys(techs.UNSUPPORTED)])stock(f,id,3);
 const commands=techs.buildInit(f.w);for(const c of commands)codec.encode(c);
 for(const id of Object.keys(techs.DEFINITIONS)){const c=commands.find(c=>c.menuItemId===id);assert.equal(c.counterValue,3);assert.equal(c.activatable,true);assert.equal(c.visible,true);}
 for(const id of Object.keys(techs.UNSUPPORTED)){assert.equal(commands.find(c=>c.menuItemId===id).activatable,false);assert.equal(use(f,id),false);assert.equal(count(f,id),3);}
 finish(f);
});

test('empty stock, stale sessions, dead or jumping players reject activation without a cooldown',()=>{
 const f=fixture(),id='tech_energy-leech';assert.equal(use(f,id),false);stock(f,id);
 f.p.dead=true;assert.equal(use(f,id),false);f.p.dead=false;f.s.jumping=true;assert.equal(use(f,id),false);f.s.jumping=false;
 assert.equal(techs.action({world:f.w},{menuItemId:id,actionType:1}),false);assert.equal(count(f,id),2);assert.equal(techs.read(f.p)[id],undefined);finish(f);
});

test('shield backups grant exact75k/450k with a max cap and never refill NanoHull',()=>{
 const f=fixture(),now=Date.now(),one='tech_backup-shields',two='tech_shield-backup2';stock(f,one);stock(f,two);Object.assign(f.p,{shieldMax:1000000,shield:1000000,nanoHull:123});
 assert.equal(use(f,one,now),false);assert.equal(count(f,one),2);f.p.shield=0;
 assert.equal(use(f,one,now),true);assert.equal(f.p.shield,75000);assert.equal(count(f,one),1);assert.equal(f.p.nanoHull,123);
 assert.equal(use(f,one,now+1),false);f.p.shield=800000;assert.equal(use(f,two,now),true);assert.equal(f.p.shield,1000000);assert.equal(techs.read(f.p)[two],now+1200000);
 assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message===`0|TX|A|0|SBU2|${f.id}`));finish(f);
});

test('classic battle robot repairs ten discrete seconds during combat, capped, without NanoHull healing',()=>{
 const f=fixture(),id='tech_battle-repair-bot',now=Date.now();stock(f,id);Object.assign(f.p,{hitPoints:1,hitMax:1000000,nanoHull:567,lastCombat:now});
 assert.equal(use(f,id,now),true);assert.equal(f.p.hitPoints,1);techs.tick(f.w,f.combat,now+999);assert.equal(f.p.hitPoints,1);
 techs.tick(f.w,f.combat,now+1000);assert.equal(f.p.hitPoints,10001);techs.tick(f.w,f.combat,now+10000);assert.equal(f.p.hitPoints,100001);assert.equal(f.p.nanoHull,567);
 techs.tick(f.w,f.combat,now+11000);assert.equal(f.p.hitPoints,100001);assert.equal(techs.read(f.p)[id],now+120000);
 assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===60&&c.activated));assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===60&&!c.activated));finish(f);
});

test('BRB2 restores exactHP/shield ticks and starts20minute cooldown after10second runtime',()=>{
 const f=fixture(),id='tech_battle-repair-bot2',now=Date.now();stock(f,id);Object.assign(f.p,{hitPoints:1,hitMax:1000000,shield:1,shieldMax:1000000});
 assert.equal(use(f,id,now),true);techs.tick(f.w,f.combat,now+10000);assert.equal(f.p.hitPoints,200001);assert.equal(f.p.shield,350001);assert.equal(techs.read(f.p)[id],now+1210000);
 assert.equal(use(f,id,now+1209999),false);assert.equal(count(f,id),1);finish(f);
});

test('energy leech heals10percent of actual allowed laser damage with HP cap and real duration',()=>{
 const f=fixture(),id='tech_energy-leech',now=Date.now();stock(f,id);f.p.hitPoints=100;assert.equal(use(f,id,now),true);
 assert.equal(techs.laserHit(f.w,12340,'ammunition_laser_lcb-10',now+1),1234);assert.equal(f.p.hitPoints,1334);
 for(const ammo of ['ammunition_laser_sab-50','ammunition_laser_rsb-75'])assert.equal(techs.laserHit(f.w,90000,ammo,now+2),0);
 f.p.hitPoints=f.p.hitMax-10;assert.equal(techs.laserHit(f.w,1000,'ammunition_laser_ucb-100',now+3),10);assert.equal(f.p.hitPoints,f.p.hitMax);
 assert.equal(techs.laserHit(f.w,1000,'ammunition_laser_ucb-100',now+900000),0);assert.equal(techs.read(f.p)[id],now+1800000);finish(f);
});

test('precision targeter guarantees only normal rockets, excludesHST and special rockets and expires',()=>{
 const f=fixture(),id='tech_precision-targeter',now=Date.now();stock(f,id);assert.equal(use(f,id,now),true);
 for(const ammo of ['ammunition_rocket_r-310','ammunition_rocket_plt-2026','ammunition_rocket_plt-2021','ammunition_rocket_plt-3030'])assert.equal(techs.rocketChance(f.w,ammo,.1,now+1),1);
 for(const ammo of ['ammunition_rocket_dcr-250','ammunition_rocket_pld-8','ammunition_rocketlauncher_hstrm-01'])assert.equal(techs.rocketChance(f.w,ammo,.1,now+1),.1);
 assert.equal(use(f,id,now+300000),false,'cooldown readiness does not stack an already active tech');assert.equal(techs.rocketChance(f.w,'ammunition_rocket_r-310',.1,now+900000),.1);finish(f);
});

test('chain impulse validates selected range, damages at most7NPC hulls directly and preserves shields',()=>{
 const f=fixture(),id='tech_chain-impulse',now=Date.now();stock(f,id);const npcs=Array.from({length:9},(_,i)=>target(f,{hp:100000,shield:200000,x:6100+i*10}));
 f.s.selected=999999;assert.equal(use(f,id,now),false);assert.equal(count(f,id),2);f.s.selected=npcs[0].id;
 assert.equal(use(f,id,now),true);assert.equal(npcs.filter(n=>n.hp===90000).length,7);assert.equal(npcs.filter(n=>n.hp===100000).length,2);assert.ok(npcs.every(n=>n.shield===200000));assert.equal(count(f,id),1);
 assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message.startsWith(`0|TX|ECI|1|${f.id}|`)));assert.equal(use(f,id,now+1),false);finish(f);
});

test('NPC nuke produces six100k pulses over60seconds and ignores distant NPCs',()=>{
 const f=fixture(),id='tech_npc-nuke',now=Date.now();stock(f,id);const close=target(f),far=target(f,{x:9000});
 assert.equal(use(f,id,now),true);assert.equal(close.hp,900000);assert.equal(far.hp,1000000);
 techs.tick(f.w,f.combat,now+59999);assert.equal(close.hp,400000);techs.tick(f.w,f.combat,now+60000);assert.equal(close.hp,400000);assert.equal(far.hp,1000000);
 assert.equal(techs.read(f.p)[id],now+1260000);assert.equal(use(f,id,now+1259999),false);finish(f);
});

test('AAER is enforced in real NPC incoming damage and cannot protect after its10second duration',()=>{
 const f=fixture(),id='tech_anti-ai-emergency-reserves',now=Date.now();stock(f,id);const npc=target(f);Object.assign(f.p,{hitPoints:10,shield:0,nanoHull:0});assert.equal(use(f,id,now),true);
 f.combat.damagePlayer(npc,1000,{now:now+1,evade:false});assert.equal(f.p.hitPoints,1);assert.equal(f.p.dead,false);assert.equal(techs.read(f.p)[id],now+1800000);
 const state={hp:0};assert.equal(techs.protect(f.w,state,now+10000),false);assert.equal(state.hp,0);finish(f);
});

test('classic simultaneous limit prevents a fourth active tech without consuming it',()=>{
 const f=fixture(),now=Date.now(),ids=['tech_energy-leech','tech_precision-targeter','tech_battle-repair-bot','tech_anti-ai-emergency-reserves'];f.p.hitPoints=1;
 for(const id of ids)stock(f,id);for(const id of ids.slice(0,3))assert.equal(use(f,id,now),true);
 assert.equal(use(f,ids[3],now),false);assert.equal(count(f,ids[3]),2);finish(f);
});

test('stock and cooldown writes rollback together on storage failure; cooldown survives reload',()=>{
 const f=fixture(),id='tech_energy-leech',now=Date.now();stock(f,id);
 db.exec("CREATE TRIGGER fail_tech BEFORE INSERT ON settings WHEN NEW.key='game.techCooldowns' BEGIN SELECT RAISE(ABORT,'tech-storage'); END");
 try{assert.throws(()=>use(f,id,now),/tech-storage/);}finally{db.exec('DROP TRIGGER fail_tech');}
 assert.equal(count(f,id),2);assert.equal(techs.read(f.p)[id],undefined);assert.equal(techs.active(f.p,id,now),null);
 assert.equal(use(f,id,now),true);const loaded=players.loadPlayer(f.id);assert.equal(techs.read(loaded)[id],now+1800000);techs.stop(f.w);assert.equal(techs.active(f.p,id,now),null);assert.equal(count(f,id),1);assert.equal(use(f,id,now+1),false);finish(f);
});
