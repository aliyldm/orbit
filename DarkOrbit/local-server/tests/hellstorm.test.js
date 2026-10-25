'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),launcher=require('../game/hellstorm'),inventory=require('../game/inventory'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let sequence=0;
function fixture(){const a=players.createAccount(`hst-${++sequence}`,'testpass'),id=players.createPlayer(a,'HST QA',1,config.starter),world=new World(config),commands=[],s={world,send(){},close(){}};world.login(s,id);world.rendererMode=2;Object.assign(world.player,{x:6000,y:6000});const send=(s,c)=>{codec.encode(c);commands.push(c);},combat=new Combat(world,send);combat.map=maps.getMap(1);return{world,s,p:world.player,id,commands,combat};}
function add(f,id,amount=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,amount).lastInsertRowid);}
function equip(f,id,slot='heavy_guns',configId=1){return inventory.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[id],configId},to:{target:'ship',slotset:slot,configId}});}
function npc(f){const n=f.combat.spawn({typeId:71,name:'QA Lordakia',hitpoints:100000,shield:0,speed:200,damageMin:1,damageMax:1,reward:{},respawnMs:5000});Object.assign(n,{x:6400,y:6000});f.s.selected=n.id;return n;}
function loaded(f,now=Date.now()){launcher.reload(f.world,now);launcher.tick(f.world,f.combat,now+5000);return launcher.state(f.world);}
function finish(f){f.world.removeSession(f.s);}

test('real HST upgrade collection increases delayed salvo damage and SAR absorption by its native perlevel bonus',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});
 for(const[loot,steps,ammo,shield]of[['equipment_weapon_rocketlauncher_hst-1',15,'ammunition_rocketlauncher_eco-10',0],['equipment_weapon_rocketlauncher_hst-2',19,'ammunition_rocketlauncher_sar-01',20000]]){
  const f=fixture(),item=add(f,loot),assembly=require('../game/assembly');equip(f,item);add(f,ammo,10);const target=npc(f);target.shield=shield;target.maxShield=shield;Object.assign(f.p,{shield:0,shieldMax:50000});
  const[id,r]=Object.entries(assembly.RECIPES).find(([,r])=>r.targets?.includes(loot)&&r.result[0]?.lootID==='upgrade_item-upgrade');for(const step of r.costs.filter(c=>c.level<=steps))for(const part of step.parts)add(f,part.lootID,part.ammount);
  assembly.build(f.id,id,steps,item,1000);const job=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND target_id=?').get(f.id,item);assembly.collect(f.id,id,item,job.due_at);
  assert.equal(launcher.hardware(f.p).upgradeMultiplier,1+steps*.005);launcher.select(f.s,ammo);const st=loaded(f),quantity=st.loaded;f.combat.rollHit=()=>true;assert.equal(launcher.fire(f.s,target.id,Date.now()+10000),true);assert.equal(target.hp,100000);assert.equal(target.shield,shield);t.mock.timers.tick(1500);
  if(shield){const expected=Math.round(launcher.AMMO[ammo].shieldLeechDamage*quantity*(1+steps*.005));assert.equal(target.shield,shield-expected);assert.equal(f.p.shield,expected);}else assert.equal(target.hp,100000-Math.round(launcher.AMMO[ammo].damage*quantity*(1+steps*.005)));
  finish(f);
 }
});
test('only equipped HST in the active configuration provides source capacities 3 and 5',()=>{
 const f=fixture(),hst=add(f,'equipment_weapon_rocketlauncher_hst-1');assert.equal(launcher.state(f.world).capacity,0);equip(f,hst);assert.equal(launcher.state(f.world).capacity,3);
 const hst2=add(f,'equipment_weapon_rocketlauncher_hst-2');equip(f,hst2,'heavy_guns',2);db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(f.p.shipId);assert.equal(launcher.state(f.world).capacity,5);finish(f);
});
test('reload reports real client status and fire consumes exactly 3 ECO rounds atomically',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});
 const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-1'));add(f,'ammunition_rocketlauncher_eco-10',10);const target=npc(f);
 const st=loaded(f);assert.equal(st.loaded,3);assert.equal(launcher.count(f.p,st.ammo),10,'loading preview never silently loses ammo');
 assert.equal(launcher.fire(f.s,target.id,Date.now()+5001),true);assert.equal(launcher.count(f.p,st.ammo),7);assert.equal(target.hp,100000);t.mock.timers.tick(1434);assert.equal(target.hp,94000);
 const shot=f.commands.find(c=>c._==='HellstormAttackCommand');assert.equal(shot.currentLoad,3);assert.equal(shot.rocketType.typeValue,23);assert.equal(codec.decode(codec.encode(shot)).obj.currentLoad,3);
 assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message==='0|RL|S|1|9|3'));assert.equal(launcher.fire(f.s,target.id,st.nextFire-1),false);assert.equal(launcher.count(f.p,st.ammo),7);finish(f);
});
test('activation queues one salvo until reload completes and rejects remote or absent targets',()=>{
 const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-1'));add(f,'ammunition_rocketlauncher_eco-10',10);const target=npc(f),now=Date.now();
 assert.equal(launcher.action(f.s,{menuItemId:launcher.ROOT,actionType:1}),true);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),10);
 launcher.tick(f.world,f.combat,now+5000);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),7);assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,1);
 target.x=8000;loaded(f,now+6000);assert.equal(launcher.fire(f.s,target.id,now+12000),false);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),7);assert.equal(launcher.fire(f.s,999999,now+12000),false);finish(f);
});
test('reload uses available partial stacks and a failed debit rolls back every round',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});
 const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-2'));add(f,'ammunition_rocketlauncher_eco-10',1);add(f,'ammunition_rocketlauncher_eco-10',1);const target=npc(f),st=loaded(f);assert.equal(st.loaded,2);
 db.exec("CREATE TRIGGER reject_hst BEFORE UPDATE OF amount ON items WHEN NEW.loot_id='ammunition_rocketlauncher_eco-10' BEGIN SELECT RAISE(ABORT,'hst-storage'); END");
 assert.throws(()=>launcher.fire(f.s,target.id,Date.now()+10000),/hst-storage/);assert.equal(launcher.count(f.p,st.ammo),2);assert.equal(st.loaded,2);assert.equal(target.hp,100000);db.exec('DROP TRIGGER reject_hst');
 assert.equal(launcher.fire(f.s,target.id,Date.now()+10000),true);assert.equal(launcher.count(f.p,st.ammo),0);assert.equal(target.hp,100000);t.mock.timers.tick(1350);assert.equal(target.hp,96000);finish(f);
});
test('SAR missiles drain shields and restore owner shields without hull damage',t=>{
 t.mock.timers.enable({apis:['setTimeout','Date'],now:100000});
 const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-1'));add(f,'ammunition_rocketlauncher_sar-01',10);const target=npc(f);target.shield=5000;Object.assign(f.p,{shield:0,shieldMax:2000});
 launcher.select(f.s,'ammunition_rocketlauncher_sar-01');loaded(f);assert.equal(launcher.fire(f.s,target.id,Date.now()+10000),true);assert.equal(target.shield,5000);assert.equal(f.p.shield,0);t.mock.timers.tick(1434);assert.equal(target.hp,100000);assert.equal(target.shield,2000);assert.equal(f.p.shield,2000);finish(f);
});
test('auto launcher requires equipped CPU and fires only during real laser attack',()=>{
 const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-1'));add(f,'ammunition_rocketlauncher_eco-10',10);const target=npc(f);
 assert.equal(launcher.action(f.s,{menuItemId:launcher.CPU}),false);equip(f,add(f,launcher.CPU),'extras');assert.equal(launcher.action(f.s,{menuItemId:launcher.CPU}),true);
 const now=Date.now();launcher.tick(f.world,f.combat,now+5000);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),10);f.s.attacking=target.id;launcher.tick(f.world,f.combat,now+6000);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),7);finish(f);
});
test('stale sessions, dead players and empty stock never produce a launcher shot',()=>{
 const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-1'));const target=npc(f);assert.equal(launcher.reload(f.world),false);assert.equal(launcher.fire(f.s,target.id),false);
 add(f,'ammunition_rocketlauncher_eco-10',3);loaded(f);f.p.dead=true;assert.equal(launcher.fire(f.s,target.id),false);f.p.dead=false;const stale={world:f.world,player:f.p};assert.equal(launcher.fire(stale,target.id),false);assert.equal(launcher.legacy(stale,'RL|L'),false);
 assert.equal(f.commands.filter(c=>c._==='HellstormAttackCommand').length,0);finish(f);
});
test('config changes and disconnect clear virtual loaded rounds while preserving real ammo',()=>{
 const f=fixture();equip(f,add(f,'equipment_weapon_rocketlauncher_hst-1'));add(f,'ammunition_rocketlauncher_eco-10',3);loaded(f);assert.equal(launcher.state(f.world).loaded,3);
 db.prepare('UPDATE ships SET active_config=2 WHERE id=?').run(f.p.shipId);assert.equal(launcher.state(f.world).loaded,0);assert.equal(launcher.state(f.world).capacity,0);assert.equal(launcher.count(f.p,'ammunition_rocketlauncher_eco-10'),3);
 finish(f);assert.equal(f.world.launcherState,null);assert.equal(db.prepare("SELECT SUM(amount) n FROM items WHERE player_id=? AND loot_id='ammunition_rocketlauncher_eco-10'").get(f.id).n,3);
});

