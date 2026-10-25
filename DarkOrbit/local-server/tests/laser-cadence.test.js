'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),ammo=require('../game/ammo');
let w,s,c,p,sent,npc;
beforeEach(()=>{database.close();const db=database.open(':memory:');const id=players.createPlayer(players.createAccount('cadence','testpass'),'Cadence',1,require('../config').starter);
 w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);p=w.player;Object.assign(p,{x:6000,y:6000});sent=[];c=new Combat(w,(s,cmd)=>sent.push(cmd));c.map=maps.getMap(1);c.cfg={...c.cfg,damageSpread:0,laserHitChance:1};npc=c.spawn({typeId:84,name:'QA',hitpoints:100000,shield:0,speed:100,damageMin:10,damageMax:10,reward:{}},{x:6400,y:6000});
});
afterEach(()=>{w.removeSession(s);database.close();});
const shots=()=>sent.filter(x=>x._==='AttackLaserRunCommand'&&x.attackerId===p.userId).length;

test('native special ammo packet types reach the renderer instead of red fallback; NPC class resolution stays native',()=>{
 const visuals=require('../game/laser-visuals'),codec=require('../game/codec/codec');
 for(const [slug,type]of [...Object.entries(visuals.AMMO),...Object.keys(require('../game/laser-ammo').CUP).map(g=>['spacecup_group-'+g,32])]){p.ammo='ammunition_laser_'+slug;const cmd=codec.decode(codec.encode(c.laserRun(p.userId,npc.id))).obj;assert.equal(cmd.laserColor,type,slug);assert.equal(cmd.targetId,npc.id);assert.equal(c.laserRun(npc.id,p.userId).laserColor,0);}
 const supported=[...Object.keys(require('../game/laser-ammo').BASE)],unmapped=supported.filter(k=>visuals.AMMO[k]===undefined);assert.deepEqual(unmapped,['emaa-20'],'do not silently claim a source mapping for unsupported modern visual IDs');
});

test('source600-unit laser boundary rejects601 without ammo/sound and accepts600 immediately',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});npc.x=p.x+601;const before=ammo.count(p);assert.equal(c.attack(s,npc.id),false);assert.equal(shots(),0);assert.equal(ammo.count(p),before);assert.ok(sent.some(c=>c._==='AttackRangeExceededCommand'&&c.maxRange===600));
 npc.x=p.x+600;assert.equal(c.attack(s,npc.id),true);assert.equal(shots(),1);assert.equal(ammo.count(p),before-p.stats.laserCount);
});
test('moving first attack deals damage and consumes ammo in the same round as native animation and sound',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const before=ammo.count(p),hp=npc.hp;
 w.move(s,{positionX:p.x,positionY:p.y,targetX:6200,targetY:6000});assert.equal(c.attack(s,npc.id),true);assert.equal(shots(),1);assert.ok(npc.hp<hp);assert.equal(ammo.count(p),before-p.stats.laserCount);
 assert.equal(sent.filter(x=>x._==='AttackHitCommand'&&x.victimId===npc.id).length,1);assert.ok(w.movement,'firing does not stop the ship');
 for(let n=0;n<20;n++)c.attack(s,npc.id);assert.equal(shots(),1);t.mock.timers.tick(999);assert.equal(shots(),1);t.mock.timers.tick(1);assert.equal(shots(),2);
 c.tick();c.tick();assert.equal(shots(),2);t.mock.timers.tick(1000);assert.equal(shots(),3);assert.equal(ammo.count(p),before-3*p.stats.laserCount);
});
test('out-of-range, no-ammo and dead requests produce no fake starter sounds; abort cancels scheduled rounds',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});npc.x=9000;assert.equal(c.attack(s,npc.id),false);assert.equal(shots(),0);npc.x=6400;
 database.open().prepare('UPDATE items SET amount=0 WHERE player_id=? AND loot_id=?').run(p.userId,'ammunition_laser_lcb-10');assert.equal(c.attack(s,npc.id),true);assert.equal(shots(),0);assert.equal(c.laserTimers.size,0);
 database.open().prepare('UPDATE items SET amount=100 WHERE player_id=? AND loot_id=?').run(p.userId,'ammunition_laser_lcb-10');c.attack(s,npc.id);assert.equal(shots(),1);c.abort(s);t.mock.timers.tick(3000);assert.equal(shots(),1);assert.equal(c.laserTimers.size,0);
 p.dead=true;assert.equal(c.attack(s,npc.id),false);assert.equal(shots(),1);
});
test('RSB returns to the previous ammo and keeps its independent three-second cooldown',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});database.open().prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,100)').run(p.userId,'ammunition_laser_rsb-75');ammo.select(p,'ammunition_laser_rsb-75');
 c.attack(s,npc.id);assert.equal(shots(),1);assert.equal(p.ammo,ammo.DEFAULT_AMMO);assert.equal(p.nextRsb,103000);c.abort(s);
 for(let n=0;n<20;n++){ammo.select(p,ammo.RSB_AMMO);c.attack(s,npc.id);}assert.equal(shots(),1);assert.equal(p.ammo,ammo.DEFAULT_AMMO);c.abort(s);
 t.mock.timers.tick(1000);ammo.select(p,ammo.RSB_AMMO);c.attack(s,npc.id);assert.equal(shots(),2);assert.equal(sent.filter(c=>c._==='AttackLaserRunCommand').at(-1).laserColor,0);assert.equal(p.nextRsb,103000);c.abort(s);
 t.mock.timers.tick(2000);ammo.select(p,ammo.RSB_AMMO);c.attack(s,npc.id);assert.equal(shots(),3);assert.equal(sent.filter(c=>c._==='AttackLaserRunCommand').at(-1).laserColor,6);assert.equal(p.nextRsb,106000);assert.equal(p.ammo,ammo.DEFAULT_AMMO);
 c.stop();assert.equal(c.laserTimers.size,0);t.mock.timers.tick(6000);assert.equal(shots(),3);
});

for(const miss of [false,true])test('x4 -> one RSB salvo -> continuous x4, including a missed RSB: '+miss,t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const db=database.open(),x4='ammunition_laser_ucb-100';
 for(const loot of [x4,ammo.RSB_AMMO])db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,100)').run(p.userId,loot);
 ammo.select(p,x4);const before4=ammo.count(p,x4),beforeR=ammo.count(p,ammo.RSB_AMMO),need=p.stats.laserCount;
 ammo.select(p,ammo.RSB_AMMO);if(miss)t.mock.method(c,'rollHit',()=>false);c.attack(s,npc.id);
 assert.equal(p.ammo,x4);assert.equal(ammo.count(p,ammo.RSB_AMMO),beforeR-need);assert.equal(ammo.count(p,x4),before4);assert.equal(sent.find(c=>c._==='AttackLaserRunCommand').laserColor,6);
 t.mock.timers.tick(1000);assert.equal(p.ammo,x4);assert.equal(shots(),2);assert.equal(sent.filter(c=>c._==='AttackLaserRunCommand').at(-1).laserColor,3);assert.equal(ammo.count(p,x4),before4-need);
 assert.equal(ammo.buildAmmoCommands(p).find(c=>c.menuItemId===x4).selected,true);assert.equal(ammo.buildAmmoCommands(p).find(c=>c.menuItemId===ammo.RSB_AMMO).selected,false);
});

test('the last non-RSB selection is updated and empty RSB does not interrupt ordinary fire',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const sab='ammunition_laser_sab-50',db=database.open();db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,100)').run(p.userId,sab);
 ammo.select(p,'ammunition_laser_ucb-100');ammo.select(p,sab);ammo.select(p,ammo.RSB_AMMO);c.attack(s,npc.id);
 assert.equal(p.ammo,sab);assert.equal(shots(),1);assert.equal(p.nextRsb,undefined);assert.equal(sent.find(c=>c._==='AttackLaserRunCommand').laserColor,4);
});
