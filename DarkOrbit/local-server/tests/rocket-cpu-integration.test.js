'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),inventory=require('../game/inventory'),launcher=require('../game/hellstorm'),cpu=require('../game/cpu'),ammo=require('../game/ammo'),codec=require('../game/codec/codec'),gameplay=require('../game/gameplay');
let db,w,s,p,c,out,npc;
beforeEach(()=>{
 database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('rocket-flow','testpass'),'Rocket Flow',1,require('../config').starter);
 w=new World(structuredClone(require('../config')));s={world:w,send(){}};w.login(s,id);p=w.player;Object.assign(p,{x:6000,y:6000});out=[];
 c=new Combat(w,(_session,command)=>{codec.decode(codec.encode(command));out.push(command);});c.map=maps.getMap(1);
 npc=c.spawn({typeId:84,name:'QA',hitpoints:1000000,shield:0,speed:0,damageMin:0,damageMax:0,reward:{}},{x:6400,y:6000});s.selected=npc.id;
 gameplay.register(()=>{},{sendCmd:(_s,cmd)=>out.push(cmd),combatFor:()=>c});
});
afterEach(()=>{w.removeSession(s);database.close();});
function item(loot,amount=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,loot,amount).lastInsertRowid);}
function equip(id,slot='extras',configId=1){inventory.move(p.userId,{hangarId:p.shipId,from:{target:'inventory',items:[id],configId},to:{target:'ship',slotset:slot,configId}});}
function action(id,actionType=0){return gameplay.menuAction(s,codec.decode(codec.encode({_:'MenuActionRequest',menuItemId:id,actionType,sourceType:0})).obj);}
function shots(){return out.filter(x=>x._==='HellstormAttackCommand');}
test('native RLLB toggle preloads five rockets while idle, attacks real laser target, waits three seconds then repeats',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});equip(item('equipment_weapon_rocketlauncher_hst-2'),'heavy_guns');equip(item(launcher.CPU));item('ammunition_rocketlauncher_hstrm-01',30);
 action('ammunition_rocketlauncher_hstrm-01');assert.equal(action(launcher.CPU),true);
 for(let sec=1;sec<=5;sec++){t.mock.timers.tick(1000);c.tick();assert.equal(launcher.state(w).loaded,sec);assert.equal(shots().length,0);}
 assert.equal(c.attack(s,npc.id),true);c.tick();assert.equal(shots().length,1);assert.equal(shots()[0].currentLoad,5);assert.equal(launcher.count(p,'ammunition_rocketlauncher_hstrm-01'),25);
 assert.equal(launcher.reload(w),false,'manual reload cannot bypass the three-second lock');
 for(let sec=1;sec<=2;sec++){t.mock.timers.tick(1000);c.tick();assert.equal(launcher.state(w).loaded,0);assert.equal(launcher.state(w).reloadAt,0);}
 t.mock.timers.tick(1000);c.tick();assert.equal(launcher.state(w).reloadAt,109000);
 for(let sec=1;sec<=5;sec++){t.mock.timers.tick(1000);c.tick();}
 assert.equal(shots().length,2);assert.equal(shots()[1].currentLoad,5);assert.equal(launcher.count(p,'ammunition_rocketlauncher_hstrm-01'),20);
 c.abort(s);for(let sec=1;sec<=9;sec++){t.mock.timers.tick(1000);c.tick();}assert.equal(shots().length,2);assert.equal(launcher.state(w).loaded,5,'CPU reloads even when the laser attack ends');
});
test('laser ammo notifications and full menus preserve the real selected launcher ammo and CPU toggle',()=>{
 equip(item('equipment_weapon_rocketlauncher_hst-2'),'heavy_guns');equip(item(launcher.CPU));item('ammunition_rocketlauncher_sar-02',20);item('ammunition_rocketlauncher_eco-10',20);
 action('ammunition_rocketlauncher_sar-02');action(launcher.CPU);
 const statuses=ammo.buildAmmoCommands(p).filter(x=>x.menuItemId.startsWith('ammunition_rocketlauncher_'));
 assert.deepEqual(statuses.filter(x=>x.selected).map(x=>x.menuItemId),['ammunition_rocketlauncher_sar-02']);
 const menu=require('../game/handlers/core').menu(p);const find=id=>menu.categories.flatMap(x=>x.menuItems).find(x=>x.status.menuItemId===id).status;
 assert.equal(find(launcher.CPU).selected,true);assert.equal(find('ammunition_rocketlauncher_sar-02').selected,true);assert.equal(find('ammunition_rocketlauncher_eco-10').selected,false);
 action(launcher.CPU);assert.equal(require('../game/menu-capabilities').status(p,find(launcher.CPU)).selected,false);
});
test('same physical HST equipped in both configurations unloads and CPU resumes idle loading without resetting cooldown',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});const hst=item('equipment_weapon_rocketlauncher_hst-2'),chip=item(launcher.CPU);for(const cfg of [1,2]){equip(hst,'heavy_guns',cfg);equip(chip,'extras',cfg);}item('ammunition_rocketlauncher_eco-10',20);action(launcher.CPU);
 t.mock.timers.tick(5000);launcher.tick(w,c);assert.equal(launcher.state(w).loaded,5);
 db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(p.shipId);assert.equal(launcher.state(w).loaded,0);launcher.tick(w,c);assert.ok(launcher.state(w).reloadAt>0);
 t.mock.timers.tick(5000);launcher.tick(w,c);assert.equal(launcher.state(w).loaded,5);launcher.fire(s,npc.id);const until=launcher.state(w).nextFire;
 db.prepare('UPDATE ships SET active_config=1 WHERE id=?').run(p.shipId);assert.equal(launcher.state(w).nextFire,until);assert.equal(launcher.reload(w),false);
});
test('AROL menu toggle fires selected single rockets at real cooldown and stops on laser abort or unequipped config',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});equip(item(cpu.PREFIX+'arol-x'));equip(item(cpu.PREFIX+'rok-t01'));item('ammunition_rocket_plt-3030',20);
 assert.equal(action('ammunition_rocket_plt-3030'),true);assert.equal(action(cpu.PREFIX+'arol-x'),true);assert.equal(cpu.buildInit(p).find(x=>x._==='CPUInfoAutoRocketCommand').isActive,true);
 const before=ammo.count(p,p.rocket);c.tick();assert.equal(ammo.count(p,p.rocket),before);c.attack(s,npc.id);t.mock.timers.tick(1000);c.tick();assert.equal(ammo.count(p,p.rocket),before-1);
 t.mock.timers.tick(1000);c.tick();assert.equal(ammo.count(p,p.rocket),before-1);t.mock.timers.tick(1000);c.tick();assert.equal(ammo.count(p,p.rocket),before-2);
 c.abort(s);t.mock.timers.tick(3000);c.tick();assert.equal(ammo.count(p,p.rocket),before-2);
 c.attack(s,npc.id);db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(p.shipId);t.mock.timers.tick(2000);c.tick();assert.equal(ammo.count(p,p.rocket),before-2);
});
test('jumping requests cannot toggle or load a launcher through the native menu',()=>{
 equip(item('equipment_weapon_rocketlauncher_hst-2'),'heavy_guns');equip(item(launcher.CPU));item('ammunition_rocketlauncher_eco-10',20);s.jumping=true;
 assert.equal(action(launcher.CPU),false);assert.equal(action(launcher.ROOT,1),false);assert.equal(cpu.read(p)['rllb-x'],undefined);assert.equal(launcher.state(w).reloadAt,0);
});
test('all six catalog launchers actually load and fire their documented capacities with per-item upgrade damage',t=>{
 t.mock.timers.enable({apis:['Date','setTimeout'],now:100000});
 const hardware=require('../game/launcher-hardware');item('ammunition_rocketlauncher_eco-10',100);
 for(const [name,def]of Object.entries(hardware.TYPES)){
  db.prepare("DELETE FROM items WHERE player_id=? AND slot='heavy_gun'").run(p.userId);const id=item('equipment_weapon_rocketlauncher_'+name);equip(id,'heavy_guns');db.prepare('UPDATE items SET upgrade_level=3 WHERE id=?').run(id);
  Object.assign(p,{stats:players.loadPlayer(p.userId).stats});launcher.stop(w);assert.equal(launcher.hardware(p).capacity,def.capacity);
  launcher.reload(w);t.mock.timers.tick(6000);launcher.tick(w,c);assert.equal(launcher.state(w).loaded,def.capacity);
  const expected=Math.round(launcher.AMMO['ammunition_rocketlauncher_eco-10'].damage*def.capacity*p.stats.rocketMultiplier*launcher.hardware(p).upgradeMultiplier),before=npc.hp;
  assert.equal(launcher.fire(s,npc.id),true,name);assert.equal(shots().at(-1).currentLoad,def.capacity);assert.equal(launcher.state(w).nextFire-Date.now(),def.cooldown);
  t.mock.timers.tick(2500);assert.equal(before-npc.hp,expected,name);
 }
});
test('Hydra hull and shield and Neptune laser/single-rocket bonuses survive the real loaded stat pipeline',()=>{
 const base=players.loadPlayer(p.userId).stats,hydra=item('equipment_weapon_rocketlauncher_hydra');equip(hydra,'heavy_guns');let fresh=players.loadPlayer(p.userId).stats;
 assert.equal(fresh.hitMax,Math.round(base.hitMax*1.3));assert.equal(fresh.shieldMax,Math.round(base.shieldMax*1.25));
 db.prepare('DELETE FROM items WHERE id=?').run(hydra);equip(item('equipment_weapon_rocketlauncher_neptune'),'heavy_guns');fresh=players.loadPlayer(p.userId).stats;
 assert.equal(fresh.laserDamage,Math.round(base.laserDamage*1.05));assert.equal(fresh.rocketMultiplier,base.rocketMultiplier*1.05);
});
test('Triskelion equipment reduces a real ship ability cooldown by25percentagepoints and does not rewrite its deadline',()=>{
 db.prepare("UPDATE ships SET loot_id='ship_solace' WHERE id=?").run(p.shipId);equip(item('equipment_weapon_rocketlauncher_triskelion'),'heavy_guns');p.stats=players.loadPlayer(p.userId).stats;p.hitPoints=1;
 const ability=require('../game/ship-abilities'),now=Date.now();assert.equal(p.stats.abilityCooldownReduction,.25);assert.equal(ability.action(s,{menuItemId:'ability_solace',actionType:1},now),true);
 const stored=JSON.parse(db.prepare("SELECT value FROM settings WHERE player_id=? AND key='game.shipAbilityCooldowns'").get(p.userId).value);assert.equal(stored.solace,now+67500);
 db.prepare("DELETE FROM items WHERE player_id=? AND slot='heavy_gun'").run(p.userId);p.stats=players.loadPlayer(p.userId).stats;assert.equal(ability.action(s,{menuItemId:'ability_solace',actionType:1},now+67499),false);
});
