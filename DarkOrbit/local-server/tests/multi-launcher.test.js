'use strict';
const{test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),inventory=require('../game/inventory'),launcher=require('../game/hellstorm'),codec=require('../game/codec/codec');
let db,w,s,p,c,out,n;
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('dual-qa','testpass'),'Dual QA',1,require('../config').starter);w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);w.rendererMode=2;p=w.player;Object.assign(p,{x:6000,y:6000});db.prepare("UPDATE ships SET loot_id='ship_citadel' WHERE id=?").run(p.shipId);out=[];c=new Combat(w,(_s,cmd)=>{codec.decode(codec.encode(cmd));out.push(cmd);});c.map=maps.getMap(1);n=c.spawn({typeId:84,name:'QA',hitpoints:1000000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{}},{x:6400,y:6000});s.selected=n.id;});
afterEach(()=>{w.removeSession(s);database.close();});
function item(id,amount=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,?)').run(p.userId,id,amount).lastInsertRowid);}
function equip(id,slot='heavy_guns',configId=1){inventory.move(p.userId,{hangarId:p.shipId,from:{target:'inventory',items:[id],configId},to:{target:'ship',slotset:slot,configId}});}
function hardware(name,level=0){const id=item('equipment_weapon_rocketlauncher_'+name);db.prepare('UPDATE items SET upgrade_level=? WHERE id=?').run(level,id);equip(id);return id;}
function shots(){return out.filter(x=>x._==='HellstormAttackCommand');}
test('Citadel loads two HST2 launchers sequentially and emits one ten-round native salvo',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});hardware('hst-2');hardware('hst-2');item('ammunition_rocketlauncher_eco-10',30);
 assert.equal(launcher.hardware(p).capacity,10);launcher.reload(w);t.mock.timers.tick(9999);assert.equal(launcher.state(w).loaded,9);t.mock.timers.tick(1);assert.equal(launcher.state(w).loaded,10);
 assert.ok(out.some(x=>x.message==='0|RL|S|2,2|9|10'));assert.equal(launcher.fire(s,n.id),true);assert.equal(shots()[0].currentLoad,10);assert.equal(launcher.count(p,'ammunition_rocketlauncher_eco-10'),20);t.mock.timers.tick(1550);assert.equal(n.hp,980000);
});
test('mixed launcher salvo and partial manual salvo apply each loaded barrel own upgrade only',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});hardware('hst-1',15);hardware('hst-2');item('ammunition_rocketlauncher_eco-10',40);launcher.reload(w);t.mock.timers.tick(5000);
 assert.equal(launcher.state(w).loaded,5);assert.equal(launcher.fire(s,n.id),true);t.mock.timers.tick(1600);assert.equal(n.hp,1000000-Math.round(2000*(3*1.075+2)));
 t.mock.timers.tick(1400);launcher.reload(w);t.mock.timers.tick(8000);assert.equal(launcher.state(w).loaded,8);assert.equal(launcher.fire(s,n.id),true);t.mock.timers.tick(1600);assert.equal(n.hp,1000000-Math.round(2000*(3*1.075+2))-Math.round(2000*(3*1.075+5)));
});
test('RLLB auto CPU reloads dual launchers at exact fractional formation deadlines',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});hardware('hst-2');hardware('hst-2');equip(item(launcher.CPU),'extras');item('ammunition_rocketlauncher_eco-10',40);p.stats.formation={launcherCooldown:.75};assert.equal(launcher.action(s,{menuItemId:launcher.CPU}),true);
 t.mock.timers.tick(749);assert.equal(launcher.state(w).loaded,0);t.mock.timers.tick(1);assert.equal(launcher.state(w).loaded,1);t.mock.timers.tick(6750);assert.equal(launcher.state(w).loaded,10);s.attacking=n.id;launcher.tick(w,c);assert.equal(shots().length,1);
 t.mock.timers.tick(2249);assert.equal(launcher.state(w).loaded,0);t.mock.timers.tick(1);assert.equal(launcher.state(w).reloadAt,110500);t.mock.timers.tick(7500);assert.equal(shots().length,2,'auto fire without global one-second combat tick');
});
test('ammo switch and logout cancel pending fractional reload callback without spending rounds',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});hardware('hst-2');item('ammunition_rocketlauncher_eco-10',20);item('ammunition_rocketlauncher_sar-01',20);p.stats.formation={launcherCooldown:.75};launcher.reload(w);t.mock.timers.tick(400);launcher.select(s,'ammunition_rocketlauncher_sar-01');t.mock.timers.tick(350);assert.equal(launcher.state(w).loaded,0);t.mock.timers.tick(400);assert.equal(launcher.state(w).loaded,1);
 launcher.stop(w);const before=out.length;t.mock.timers.tick(5000);assert.equal(out.length,before);assert.equal(launcher.count(p,'ammunition_rocketlauncher_eco-10'),20);assert.equal(launcher.count(p,'ammunition_rocketlauncher_sar-01'),20);
});
test('short inventory reserves no fake ammunition across two launchers and failed debit rolls back atomically',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});hardware('hst-2');hardware('hst-2');item('ammunition_rocketlauncher_eco-10',3);item('ammunition_rocketlauncher_eco-10',4);launcher.reload(w);t.mock.timers.tick(7000);assert.equal(launcher.state(w).loaded,7);
 db.exec("CREATE TRIGGER reject_dual BEFORE UPDATE OF amount ON items WHEN OLD.loot_id='ammunition_rocketlauncher_eco-10' AND OLD.amount=4 BEGIN SELECT RAISE(ABORT,'dual-storage'); END");assert.throws(()=>launcher.fire(s,n.id),/dual-storage/);assert.equal(launcher.count(p,'ammunition_rocketlauncher_eco-10'),7);assert.equal(launcher.state(w).loaded,7);assert.equal(shots().length,0);db.exec('DROP TRIGGER reject_dual');assert.equal(launcher.fire(s,n.id),true);assert.equal(shots()[0].currentLoad,7);assert.equal(launcher.count(p,'ammunition_rocketlauncher_eco-10'),0);
});
test('OBR hit chance uses official90percent plus research and honors explicit local override',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});hardware('ouroboros');item('ammunition_rocketlauncher_obr-100',30);launcher.select(s,'ammunition_rocketlauncher_obr-100');t.mock.timers.tick(6000);let seen;c.rollHit=chance=>{seen=chance;return false;};assert.equal(launcher.fire(s,n.id),true);assert.equal(seen,.9);assert.equal(launcher.hardware(p).type,3);t.mock.timers.tick(3000);launcher.reload(w);t.mock.timers.tick(6000);w.config.combat.launcherHitChance=.5;p.stats.skills={rocketAccuracy:.1};launcher.fire(s,n.id);assert.equal(seen,.6);
});
test('Hellstorm does not debit or apply the single-rocket Seprom coating',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});hardware('hst-2');item('ammunition_rocketlauncher_eco-10',10);db.prepare('INSERT INTO player_ore_buffs(player_id,item_type,ore_type,remaining) VALUES(?,?,?,?)').run(p.userId,1,7,50);launcher.reload(w);t.mock.timers.tick(5000);launcher.fire(s,n.id);t.mock.timers.tick(1500);assert.equal(n.hp,990000);assert.equal(db.prepare('SELECT remaining FROM player_ore_buffs WHERE player_id=? AND item_type=1').get(p.userId).remaining,50);
});
