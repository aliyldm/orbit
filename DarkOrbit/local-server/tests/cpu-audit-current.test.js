'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),cpu=require('../game/cpu'),ammo=require('../game/ammo'),codec=require('../game/codec/codec'),maps=require('../game/maps'),weapons=require('../game/advanced-weapons');
let db,w,s,p,c,out,slot;
beforeEach(()=>{database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('cpu-audit-current','testpass'),'CPU',1,require('../config').starter);w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);p=w.player;Object.assign(p,{credits:10000000,uridium:1000000,premium:false,x:6000,y:6000,lastCombat:0});db.prepare('UPDATE players SET credits=?,uridium=?,premium=0 WHERE id=?').run(p.credits,p.uridium,id);out=[];c=new Combat(w,(_s,cmd)=>{assert.equal(codec.decode(codec.encode(cmd)).rest,0);out.push(cmd);});c.map=maps.getMap(1);slot=0;});
afterEach(()=>{w.removeSession(s);database.close();});
function equip(id,kind='extra'){id=id.startsWith('equipment_')?id:cpu.PREFIX+id;return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index)VALUES(?,?,1,?,?,?)').run(p.userId,id,p.shipId,kind,slot++).lastInsertRowid);}
function ore(type,n){db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=excluded.amount').run(p.userId,type,n);}
function stock(id,n){db.prepare('DELETE FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').run(p.userId,id);db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,id,n);}
function buff(type,oreType){db.prepare('INSERT INTO player_ore_buffs(player_id,item_type,ore_type,remaining,expires_at)VALUES(?,?,?,0,0)').run(p.userId,type,oreType);}
for(const [id,types]of [['nc-awl-x',[0]],['nc-awr-x',[1]],['nc-awb-x',[0,1]],['nc-agb-x',[2,3]]])test(id+' consumes only its matching ores/buffs and preserves current lab weapon selection',()=>{
 equip(id);for(const type of [0,1])buff(type,4);for(const type of [4,5,6,7])ore(type,10);
 assert.equal(cpu.autoUpgrade(p,100000),true);for(const type of [0,1,2,3]){const b=db.prepare('SELECT * FROM player_ore_buffs WHERE player_id=? AND item_type=?').get(p.userId,type);if(types.includes(type)){assert.equal(b.ore_type,type<2?4:type===2?6:7);assert.equal(type<2?b.remaining:b.expires_at,type<2?10:700000);}else assert.equal(b?.remaining||0,0);}
 const rows=db.prepare('SELECT * FROM player_resources WHERE player_id=?').all(p.userId);cpu.autoUpgrade(p,100001);assert.deepEqual(db.prepare('SELECT * FROM player_resources WHERE player_id=?').all(p.userId),rows);
});
test('selected weapon ore shortage does not silently spend stronger ore, and combined lab errors roll all changes back',()=>{
 equip('nc-awb-x');buff(0,4);buff(1,4);ore(4,0);ore(7,10);assert.equal(cpu.autoUpgrade(p),false);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(p.userId).amount,10);ore(4,2);
 db.exec("CREATE TRIGGER fail_cpu_lab BEFORE UPDATE ON player_ore_buffs WHEN NEW.item_type=1 BEGIN SELECT RAISE(ABORT,'cpu-lab-failure'); END");assert.throws(()=>cpu.autoUpgrade(p),/cpu-lab-failure/);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=4').get(p.userId).amount,2);assert.equal(db.prepare('SELECT SUM(remaining) n FROM player_ore_buffs WHERE player_id=?').get(p.userId).n,0);
});
for(const [cpuId,key,id,threshold,quantity]of [['alb-x','ammo','ammunition_laser_lcb-10',1000,10000],['rb-x','rocket','ammunition_rocket_r-310',100,500]])test(cpuId+' respects exact threshold, toggle, actual price and active configuration',()=>{
 equip(cpuId);p[key]=id;stock(id,threshold);cpu.write(p,{[cpuId]:true});const balance=p.credits;cpu.tick(w,c,100000);assert.equal(ammo.count(p,id),threshold);assert.equal(p.credits,balance);
 stock(id,threshold-1);cpu.tick(w,c,102000);assert.equal(ammo.count(p,id),threshold-1+quantity);assert.equal(p.credits,balance-quantity*require('../game/economy').offers(p.userId)[id].price);
 stock(id,0);cpu.write(p,{[cpuId]:false});cpu.tick(w,c,104000);assert.equal(ammo.count(p,id),0);cpu.write(p,{[cpuId]:true});db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(p.shipId);cpu.tick(w,c,106000);assert.equal(ammo.count(p,id),0);
});
for(const [id,base]of [['aim-01',.85],['aim-02',.9]])test(id+' improves MISS probability, consumes10Xenomit and stops at shortage or inactive config',()=>{
 equip(id);cpu.write(p,{aim:true});ore(3,10);assert.ok(Math.abs(cpu.aimChance(p,.8)-base)<1e-12);assert.equal(cpu.aimChance(p,.8),.8);ore(3,10);db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(p.shipId);assert.equal(cpu.aimChance(p,.8),.8);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(p.userId).amount,10);
});
for(const [id,hardware,kind,ammoId,packet]of [['rg-sl','equipment_weapon_cannon_c-helios','cannon','ammunition_slug_ths-d01','CannonAttackCommand'],['ags-x','equipment_weapon_drive_igd-l01','drive','ammunition_spool_gsp-30','PlayVisualEffectCommand']])test(id+' fires its real selected weapon only with attack, ammunition and equipped CPU',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});equip(id);equip(hardware,kind);stock(ammoId,10);const n=c.spawn({typeId:84,key:'streuner',name:'QA',hitpoints:1000000,shield:0,speed:0,damageMin:0,damageMax:0,respawnMs:0,reward:{}},{x:6300,y:6000});c.rollHit=()=>true;cpu.write(p,{[id]:true});
 cpu.tick(w,c);assert.equal(ammo.count(p,ammoId),10);s.attacking=n.id;s.selected=n.id;cpu.tick(w,c,102000);assert.equal(ammo.count(p,ammoId),9);assert.ok(out.some(x=>x._===packet));cpu.tick(w,c,103000);assert.equal(ammo.count(p,ammoId),9);
 db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(p.shipId);cpu.tick(w,c,120000);assert.equal(ammo.count(p,ammoId),9);
});
test('all40 CPU catalog items are classified; unavailable or obsolete CPU purchases cannot debit the account',()=>{
 const catalog=require('../game/cpu-catalog').CATALOG,counts={};for(const row of Object.values(catalog))counts[row.status]=(counts[row.status]||0)+1;assert.equal(Object.keys(catalog).length,40);assert.deepEqual(counts,{implemented:33,partial:1,unsupported:3,unboundedAmmoModel:3});
 const before=db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(p.userId);
 for(const suffix of ['anti-z1','anti-z1-xl','pa-x','rd-x','g3x-amry-s','g3x-amry-m','g3x-amry-l']){const result=require('../game/economy').purchase(p.userId,cpu.PREFIX+suffix,1);assert.equal(result.result,'error',suffix);assert.deepEqual(db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(p.userId),before);}
});
