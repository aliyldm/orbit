'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),cpu=require('../game/cpu'),selection=require('../game/cpu-ammo'),ammo=require('../game/ammo'),api=require('../web/inventory-api');
let db,w,p,s,c,id,alb,rb;
beforeEach(()=>{database.close();db=database.open(':memory:');id=players.createPlayer(players.createAccount('cpu-selection','testpass'),'QA',1,{...require('../config').starter,uridium:3000000,credits:3000000});w=new World(require('../config'));s={world:w,send(){}};p=w.login(s,id);Object.assign(p,{x:6000,y:6000});c=new Combat(w,()=>{});c.map=maps.getMap(1);
 const add=(loot,slot)=>{const item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index)VALUES(?,?,1,?,'extra',?)").run(id,loot,p.shipId,slot).lastInsertRowid);return db.prepare('SELECT * FROM items WHERE id=?').get(item);};alb=add('equipment_extra_cpu_alb-x',0);rb=add('equipment_extra_cpu_rb-x',1);cpu.write(p,{'alb-x':true,'rb-x':true});});
afterEach(()=>{w.removeSession(s);database.close();});
function action(request){const r=api.handle(id,new URLSearchParams({action:'setAbCpuAmmo',params:Buffer.from(JSON.stringify(request)).toString('base64')}));return JSON.parse(Buffer.from(r.body,'base64'));}
test('native context request persists each owned CPU selection and inventory exposes attachedAmmo',()=>{
 assert.equal(action({itemId:String(alb.id),ammo:'ammunition_laser_mcb-25'}).isError,0);
 const response=JSON.parse(Buffer.from(api.handle(id,new URLSearchParams({action:'getHangarList'})).body,'base64'));
 assert.equal(response.data.ret.items.find(i=>i.I===alb.id).properties.attachedAmmo,'ammunition_laser_mcb-25');
 assert.equal(response.data.ret.items.find(i=>i.I===rb.id).properties.attachedAmmo,'ammunition_rocket_r-310');
});
test('ALB purchases selected MCB25 independently of currently firing RSB and charges its actual Uri price',()=>{
 selection.select(id,{itemId:alb.id,ammo:'ammunition_laser_mcb-25'});p.ammo='ammunition_laser_rsb-75';const before=p.uridium;cpu.tick(w,c,100000);
 assert.equal(ammo.count(p,'ammunition_laser_mcb-25'),10000);assert.equal(ammo.count(p,'ammunition_laser_rsb-75'),0);assert.equal(p.ammo,'ammunition_laser_rsb-75');assert.equal(p.uridium,before-10000*.5);
});
test('RB can maintain selected ECO10 for the Hellstorm while leaving the single rocket selection unchanged',()=>{
 assert.equal(action({itemId:rb.id,ammo:'ammunition_rocketlauncher_eco-10'}).isError,0);p.rocket='ammunition_rocket_r-310';const oldRockets=ammo.count(p,p.rocket);cpu.tick(w,c,100000);
 assert.equal(ammo.count(p,'ammunition_rocketlauncher_eco-10'),500);assert.equal(p.rocket,'ammunition_rocket_r-310');assert.equal(ammo.count(p,p.rocket),oldRockets);
 db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(p.shipId);db.prepare("UPDATE items SET amount=0 WHERE player_id=? AND loot_id='ammunition_rocketlauncher_eco-10'").run(id);cpu.tick(w,c,102000);assert.equal(ammo.count(p,'ammunition_rocketlauncher_eco-10'),0);
});
test('forged choices, foreign IDs and SQL errors cannot change a CPU attachment',()=>{
 for(const request of [{itemId:alb.id,ammo:'ammunition_laser_ucb-100'},{itemId:rb.id,ammo:'ammunition_laser_mcb-25'},{itemId:999999,ammo:'ammunition_rocket_r-310'}])assert.equal(action(request).isError,1);
 assert.equal(selection.selected(id,alb),'ammunition_laser_lcb-10');
 db.exec("CREATE TRIGGER cpu_mode_fail BEFORE INSERT ON settings BEGIN SELECT RAISE(ABORT,'cpu mode rollback'); END");assert.equal(action({itemId:alb.id,ammo:'ammunition_laser_mcb-25'}).isError,1);assert.equal(selection.selected(id,alb),'ammunition_laser_lcb-10');db.exec('DROP TRIGGER cpu_mode_fail');
});
