'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {open}=require('../game/db'),db=open(':memory:'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),u=require('../game/combat-utilities'),inventory=require('../game/inventory'),codec=require('../game/codec/codec'),maps=require('../game/maps');
let n=0;
function fixture(){const a=players.createAccount(`utility-${++n}`,'testpass'),id=players.createPlayer(a,'QA',1,config.starter),world=new World(config),commands=[],s={world,send(){},close(){}};world.login(s,id);Object.assign(world.player,{x:6000,y:6000});const combat=new Combat(world,(s,c)=>{codec.encode(c);commands.push(c);});combat.map=maps.getMap(1);return{world,s,p:world.player,id,commands,combat};}
function add(f,id,amount=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,amount).lastInsertRowid);}
function equip(f,id){return inventory.move(f.id,{hangarId:f.p.shipId,from:{target:'inventory',items:[id]},to:{target:'ship',slotset:'extras'}});}
function npc(f){const n=f.combat.spawn({typeId:71,name:'QA',hitpoints:10000,shield:10000,speed:200,damageMin:100,damageMax:100,reward:{},respawnMs:5000});Object.assign(n,{x:6100,y:6000});return n;}
function run(f,id,now=Date.now()){return u.action(f.s,{menuItemId:id,actionType:1},now);}
function finish(f){f.world.removeSession(f.s);}
test('mine is charged once, arms before NPC trigger and uses real AddMine plus explosion contract',()=>{
 const f=fixture(),target=npc(f);add(f,'ammunition_mine_acm-01',2);const now=Date.now();assert.equal(run(f,'ammunition_mine_acm-01',now),true);assert.equal(u.count(f.p,'ammunition_mine_acm-01'),1);
 u.tick(f.world,f.combat,now+500);assert.equal(target.shield,10000);u.tick(f.world,f.combat,now+1001);assert.equal(f.world.utilityMines.size,0);assert.equal(target.shield,8400);assert.equal(target.hp,9600);
 u.tick(f.world,f.combat,now+2000);assert.equal(target.hp,9600);assert.ok(f.commands.some(c=>c._==='AddMineCommand'&&c.typeId===1));assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message.startsWith('0|LM|ST|MIN|')));finish(f);
});
test('shield and direct mines apply their distinct source percentage effects',()=>{
 for(const [id,expectedHp,expectedShield]of[['ammunition_mine_sabm-01',10000,5000],['ammunition_mine_ddm-01',8000,10000]]){const f=fixture(),target=npc(f);add(f,id);const now=Date.now();run(f,id,now);u.tick(f.world,f.combat,now+1001);assert.equal(target.hp,expectedHp);assert.equal(target.shield,expectedShield);finish(f);}
});
test('slow mine uses recovered visual7 and slows movement for five seconds without mutating base speed',()=>{
 const f=fixture(),target=npc(f);add(f,'ammunition_mine_slm-01');const now=Date.now();run(f,'ammunition_mine_slm-01',now);u.tick(f.world,f.combat,now+1001);assert.equal(target.def.speed,200);assert.ok(target.slowUntil>now);
 f.combat.moveNpc(target,target.x+200,target.y,now+1100);assert.equal(target.movement.duration,2000);u.tick(f.world,f.combat,now+7000);assert.equal(target.slowUntil,0);assert.ok(f.commands.some(c=>c._==='AddMineCommand'&&c.typeId===7));finish(f);
});
test('ISH requires equipped CPU and atomically consumes 10 mines plus 100 Xenomit',()=>{
 const f=fixture();add(f,'ammunition_mine_acm-01',20);db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,3,200)').run(f.id);assert.equal(run(f,u.ISH),false);
 equip(f,add(f,u.ISH));const now=Date.now();assert.equal(run(f,u.ISH,now),true);assert.equal(u.count(f.p,'ammunition_mine_acm-01'),10);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=?').get(f.id).amount,100);
 assert.equal(u.protectedNow(f.world,now+2999),true);assert.equal(u.protectedNow(f.world,now+3000),false);assert.equal(run(f,u.ISH,now+1000),false);assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message===`0|n|ISH|${f.id}`));finish(f);
});
test('missing Xenomit rolls back the mine debit and cooldown state',()=>{
 const f=fixture();equip(f,add(f,u.ISH));add(f,'ammunition_mine_acm-01',10);assert.throws(()=>run(f,u.ISH),/Xenomit/);assert.equal(u.count(f.p,'ammunition_mine_acm-01'),10);assert.equal(u.cooldowns(f.p).instashield,undefined);finish(f);
});
test('EMP consumes real charge, stops both sides of NPC targeting and preserves enemy hull',()=>{
 const f=fixture(),target=npc(f);add(f,u.EMP);target.aggro=f.s;f.s.attacking=f.s.selected=target.id;assert.equal(run(f,u.EMP),true);assert.equal(target.aggro,null);assert.equal(f.s.attacking,null);assert.equal(f.s.selected,null);assert.equal(target.hp,10000);assert.equal(u.count(f.p,u.EMP),0);assert.ok(f.commands.some(c=>c._==='LegacyModule'&&c.message===`0|n|EMP|${f.id}`));finish(f);
});
test('smartbomb consumes purchased charge, damages nearby NPC and does not damage owner',()=>{
 const f=fixture(),target=npc(f);add(f,u.SMB);const hp=f.p.hitPoints;assert.equal(run(f,u.SMB),true);assert.equal(target.hp,9600);assert.equal(f.p.hitPoints,hp);assert.equal(u.count(f.p,u.SMB),0);finish(f);
});
test('cooldowns persist across reconnect and active mines clear on disconnect',()=>{
 const f=fixture();add(f,'ammunition_mine_acm-01',2);const now=Date.now();run(f,'ammunition_mine_acm-01',now);finish(f);assert.equal(f.world.utilityMines,null);
 const world=new World(config),s={world,send(){},close(){}};world.login(s,f.id);world.combat=new Combat(world,()=>{});Object.assign(world.player,{x:6000,y:6000});assert.equal(u.action(s,{menuItemId:'ammunition_mine_acm-01',actionType:1},now+1000),false);assert.equal(u.count(world.player,'ammunition_mine_acm-01'),1);world.removeSession(s);
});
