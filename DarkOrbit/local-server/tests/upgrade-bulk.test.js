'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),bulk=require('../game/upgrade-bulk'),assembly=require('../game/assembly'),World=require('../game/world'),policy=require('../game/module-policy');
let db,id,other;const old=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;const make=name=>players.createPlayer(players.createAccount(name,'testpass'),name,1,{...require('../config').starter,credits:10000000,uridium:50000000000});id=make('bulk-owner');other=make('bulk-other');});
afterEach(()=>{World.current=old;database.close();});
const give=(loot,amount=1,owner=id)=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(owner,loot,amount).lastInsertRowid);
function equip(loot,slot='laser'){const item=give(loot),ship=players.loadPlayer(id).shipId;db.prepare('UPDATE items SET ship_id=?,slot=?,slot_index=9 WHERE id=?').run(ship,slot,item);return item;}
const stock=()=>assembly.count(db,id,policy.UPGRADE),jobs=()=>db.prepare('SELECT * FROM assembly_jobs WHERE player_id=? ORDER BY target_id').all(id);
test('all weapons and shields include equipped and stored items, quote exact remaining modules and each own maximum',()=>{
 const laser=equip('equipment_weapon_laser_lf-3'),lf4=give('equipment_weapon_laser_lf-4'),shield=give('equipment_generator_shield_sg3n-b02'),cpu=give('equipment_extra_cpu_jp-02');give(policy.UPGRADE,100000);give('equipment_weapon_laser_lf-4',1,other);db.prepare('UPDATE items SET upgrade_level=4 WHERE id=?').run(lf4);
 const quote=bulk.quote(id,'weapons,shields',1000),selected=bulk.selection(id,['weapons','shields'],1000).items;assert.ok(quote.canBuild);for(const target of [laser,lf4,shield])assert.ok(selected.some(i=>i.targetId===target));assert.ok(!selected.some(i=>i.targetId===cpu));assert.equal(selected.find(i=>i.targetId===laser).to,15);assert.equal(selected.find(i=>i.targetId===lf4).to,19);assert.equal(selected.find(i=>i.targetId===shield).to,19);assert.equal(quote.totalModules,selected.reduce((n,i)=>n+i.modules,0));
 const before=db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(id),result=bulk.build(id,quote.token,2000);assert.equal(result.itemCount,selected.length);assert.equal(stock(),100000-quote.totalModules);assert.equal(jobs().length,selected.length);assert.deepEqual(db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(id),before);
 for(const item of selected){const job=jobs().find(j=>j.target_id===item.targetId);assert.equal(job.started_at,2000);assert.equal(job.amount,item.to);assembly.collect(id,item.recipe,item.targetId,job.due_at);assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(item.targetId).upgrade_level,item.to);}
});
test('insufficient modules cannot partially start a batch or charge any item',()=>{
 give('equipment_weapon_laser_lf-4');give(policy.UPGRADE,1);const quote=bulk.quote(id,'weapons',1000);assert.equal(quote.canBuild,false);assert.throws(()=>bulk.build(id,quote.token,2000),/Module/);assert.equal(stock(),1);assert.equal(jobs().length,0);
});
test('expired, foreign, replaced or stale quotes cannot mutate progress',()=>{
 const laser=give('equipment_weapon_laser_lf-4');give(policy.UPGRADE,10000);const a=bulk.quote(id,'weapons',1000);assert.throws(()=>bulk.build(other,a.token,2000),/süresi/);assert.throws(()=>bulk.build(id,a.token,1000+bulk.TTL+1),/süresi/);
 const b=bulk.quote(id,'weapons',3000),c=bulk.quote(id,'weapons',4000);assert.throws(()=>bulk.build(id,b.token,5000),/süresi/);db.prepare('UPDATE items SET upgrade_level=1 WHERE id=?').run(laser);assert.throws(()=>bulk.build(id,c.token,5000),/değişti/);assert.equal(stock(),10000);assert.equal(jobs().length,0);
});
test('failure on a later job rolls the whole batch back, then same quote can safely retry',()=>{
 const item=give('equipment_weapon_laser_lf-4');give(policy.UPGRADE,10000);const quote=bulk.quote(id,'weapons',1000);db.exec(`CREATE TRIGGER fail_later_bulk BEFORE INSERT ON assembly_jobs WHEN NEW.target_id=${item} BEGIN SELECT RAISE(ABORT,'fail later'); END`);
 assert.throws(()=>bulk.build(id,quote.token,2000),/fail later/);assert.equal(stock(),10000);assert.equal(jobs().length,0);db.exec('DROP TRIGGER fail_later_bulk');const result=bulk.build(id,quote.token,3000);assert.equal(stock(),10000-quote.totalModules);assert.equal(result.itemCount,quote.itemCount);
 const after=stock();assert.equal(bulk.build(id,quote.token,5000).replayed,true);assert.equal(stock(),after);assert.equal(jobs().length,quote.itemCount);
});
test('busy and max-level items are excluded explicitly; empty or forged category cannot buy',()=>{
 const max=give('equipment_weapon_laser_lf-4');db.prepare('UPDATE items SET upgrade_level=19 WHERE id=?').run(max);give(policy.UPGRADE,10000);const q=bulk.quote(id,'weapons',1000);bulk.build(id,q.token,2000);const again=bulk.quote(id,'weapons',3000);assert.equal(again.itemCount,0);assert.ok(again.excludedBusy>0);assert.equal(again.canBuild,false);assert.throws(()=>bulk.build(id,again.token,4000),/eşya yok/);
 for(const input of ['', 'drones','weapons,weapons','weapons,shields,cpu'])assert.throws(()=>bulk.quote(id,input),/grubunu/);
});
test('a dropped socket after commit does not turn a paid successful batch into an error or a second debit',()=>{
 give(policy.UPGRADE,10000);const player=players.loadPlayer(id),world={player,sessions:new Set([{send(){throw Error('socket closed');}}]),livePlayer:owner=>owner===id?player:null};World.current=()=>world;
 const api=require('../web/upgrade-bulk-api'),quote=api.handle(id,new URLSearchParams({action:'quote',categories:'weapons'}));assert.equal(quote.canBuild,true);
 const result=api.handle(id,new URLSearchParams({action:'build',token:quote.token}));assert.equal(result.ok,true);assert.equal(stock(),10000-quote.totalModules);assert.equal(jobs().length,quote.itemCount);
 const again=api.handle(id,new URLSearchParams({action:'build',token:quote.token}));assert.equal(again.replayed,true);assert.equal(stock(),10000-quote.totalModules);
});
