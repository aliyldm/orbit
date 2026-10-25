'use strict';
const {test,beforeEach,afterEach}=require('node:test');
const assert=require('node:assert/strict');
const database=require('../game/db');
const players=require('../game/db/players');
const inventory=require('../game/inventory');
const economy=require('../game/economy');
const ammo=require('../game/ammo');
const api=require('../web/inventory-api');
const World=require('../game/world');
const codec=require('../game/codec/codec');
const starter=require('../config.json').starter;
let db,p1,p2,s1,s2;
const originalCurrent=World.current;
beforeEach(()=>{
  database.close(); db=database.open(':memory:'); World.current=()=>null;
  const add=name=>{
    const a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');
    const id=players.createPlayer(Number(a.lastInsertRowid),name,1,starter);
    db.prepare('UPDATE players SET credits=1000000,uridium=1000000 WHERE id=?').run(id);
    return id;
  };
  p1=add('one');p2=add('two');s1=players.loadPlayer(p1).shipId;s2=players.loadPlayer(p2).shipId;
});
afterEach(()=>{World.current=originalCurrent;database.close();});
const loose=(id=p1,loot='equipment_weapon_laser_lf-1')=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(id,loot).lastInsertRowid);
const move=(id,items,config=1,to='ship',slot='lasers',ship=s1)=>inventory.move(id,{params:{hi:ship},from:{target:to==='ship'?'inventory':'ship',items,configId:config,slotset:slot},to:{target:to,slotset:slot,configId:config}});
const portal=(action,request={})=>JSON.parse(Buffer.from(api.handle(p1,new URLSearchParams({action,params:Buffer.from(JSON.stringify(request)).toString('base64')})).body,'base64').toString());

test('purchase debit and inventory insertion commit together',()=>{
  const offer=require('../web/portal/shop.json')['equipment_weapon_laser_lf-1'];
  const before=db.prepare('SELECT credits FROM players WHERE id=?').get(p1).credits;
  const count=db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=?').get(p1).n;
  assert.equal(economy.purchase(p1,'equipment_weapon_laser_lf-1',2).result,'success');
  assert.equal(db.prepare('SELECT credits FROM players WHERE id=?').get(p1).credits,before-offer.price*2);
  assert.equal(db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=?').get(p1).n,count+2);
});
test('failed insertion rolls back debit and does not change live money',()=>{
  const live=players.loadPlayer(p1);let saves=0;
  World.current=()=>({livePlayer:id=>id===p1?live:null,save:()=>saves++});
  db.exec("CREATE TRIGGER fail_purchase BEFORE INSERT ON items BEGIN SELECT RAISE(ABORT,'test storage failure'); END");
  const before=live.credits;
  assert.equal(economy.purchase(p1,'equipment_weapon_laser_lf-1',1).result,'error');
  assert.equal(live.credits,before);
  assert.equal(db.prepare('SELECT credits FROM players WHERE id=?').get(p1).credits,before);
  assert.equal(saves,0);
});
test('invalid amounts never become a default purchase',()=>{
  const before=db.prepare('SELECT COUNT(*) n FROM items').get().n;
  for(const amount of [0,-1,1.5,NaN,Infinity,'abc','',true,10000001]) assert.equal(economy.purchase(p1,'equipment_weapon_laser_lf-1',amount).result,'error');
  assert.equal(db.prepare('SELECT COUNT(*) n FROM items').get().n,before);
});
test('insufficient balance changes neither item count nor balance',()=>{
  db.prepare('UPDATE players SET credits=0,uridium=0 WHERE id=?').run(p1);
  const before=db.prepare('SELECT COUNT(*) n FROM items').get().n;
  assert.equal(economy.purchase(p1,'equipment_weapon_laser_lf-1',1).result,'error');
  assert.equal(db.prepare('SELECT COUNT(*) n FROM items').get().n,before);
});
test('move validates item ownership and ship ownership',()=>{
  const a=loose(p1),b=loose(p2);
  assert.throws(()=>move(p1,[b]),/Eşya/);
  assert.throws(()=>move(p1,[a],1,'ship','lasers',s2),/Gemi/);
  assert.equal(db.prepare('SELECT ship_id FROM items WHERE id=?').get(a).ship_id,null);
});
test('invalid types and duplicates reject atomically; capacity overflow fills available slots',()=>{
  const a=loose(),b=loose(),c=loose(),d=loose();
  assert.throws(()=>move(p1,[a],1,'ship','generators'),/yuvaya/);
  assert.throws(()=>move(p1,[a,a]),/listesi/);
  assert.deepEqual(move(p1,[a,b,c,d]),[d]);
  assert.equal(db.prepare('SELECT ship_id FROM items WHERE id=?').get(a).ship_id,s1);
  assert.equal(db.prepare('SELECT ship_id FROM items WHERE id=?').get(d).ship_id,null);
  assert.equal(inventory.equipped(db,s1,1).filter(i=>i.slot==='laser').length,4);
});
test('two configurations persist independently and share owned items on the same ship',()=>{
  const a=loose(); move(p1,[a]);move(p1,[a],2);
  assert.ok(inventory.equipped(db,s1,1).some(i=>i.id===a));
  assert.ok(inventory.equipped(db,s1,2).some(i=>i.id===a));
  move(p1,[a],1,'inventory');
  assert.ok(!inventory.equipped(db,s1,1).some(i=>i.id===a));
  assert.ok(inventory.equipped(db,s1,2).some(i=>i.id===a));
  inventory.switchConfig(p1,s1,2);assert.equal(inventory.activeConfig(db,s1),2);
});
test('an item assigned in config 2 cannot be stolen by a different owned ship',()=>{
  const a=loose();move(p1,[a],2);
  const other=Number(db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,1000)').run(p1,'ship_liberator').lastInsertRowid);
  assert.throws(()=>move(p1,[a],1,'ship','lasers',other),/başka/);
});
test('storage failure halfway through a move rolls back every item',()=>{
  const a=loose(),b=loose();
  db.exec(`CREATE TRIGGER fail_second_item BEFORE INSERT ON equipment_config2 WHEN NEW.item_id=${b} BEGIN SELECT RAISE(ABORT,'test'); END`);
  assert.throws(()=>move(p1,[a,b],2),/test/);
  assert.equal(inventory.equipped(db,s1,2).length,0);
});
test('saved layouts restore both configurations and report missing items',()=>{
  const a=loose();move(p1,[a],2);
  inventory.saveLayout(p1,s1);inventory.clear(p1,s1,1);inventory.clear(p1,s1,2);
  assert.equal(inventory.loadLayout(p1,s1),true);
  assert.ok(inventory.equipped(db,s1,2).some(i=>i.id===a));
  db.prepare('DELETE FROM items WHERE id=?').run(a);
  assert.equal(inventory.loadLayout(p1,s1),false);
});
test('activation requires ownership and an offline player',()=>{
  const other=Number(db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,1000)').run(p1,'ship_phoenix').lastInsertRowid);
  assert.throws(()=>inventory.activate(p1,s2),/Gemi/);
  World.current=()=>({livePlayer:()=>({})});
  assert.throws(()=>inventory.activate(p1,other),/oyundan/);
  World.current=()=>null;inventory.activate(p1,other);
  assert.equal(players.loadPlayer(p1).shipId,other);
});
test('portal hangar includes matching item mapping, inventory and both EQ configurations',()=>{
  const a=loose();move(p1,[a],2);
  const response=portal('getHangar',{params:{hi:s1}});
  assert.equal(response.isError,0);
  const {ret,map}=response.data;
  const hangar=ret.hangars.find(h=>h.hangarID===String(s1));
  assert.deepEqual(hangar.config[2].ship.EQ.lasers,[a]);
  const i=ret.items.find(i=>i.I===a);
  assert.equal(map.lootIds[i.L],'equipment_weapon_laser_lf-1');
  assert.equal(ret.itemInfo.find(t=>t.L===i.L).T,0);
  assert.equal(i.EQH,s1);
  assert.equal(portal('move',{params:{hi:s1},from:{target:'inventory',items:[loose()],configId:1},to:{target:'ship',slotset:'lasers',configId:1}}).data.ret,true);
  assert.equal(portal('renamePet',{}).isError,1);
});
test('socket inventory builders encode owned inventory without recorded account data',()=>{
  const p=players.loadPlayer(p1);
  const list=codec.decode(codec.encode(inventory.buildInit(p))).obj;
  assert.equal(list.ships.length,1);assert.equal(list.ships[0].shipId,s1);
  assert.equal(list.items[0].items.length,starter.items.length);
  const equipment=codec.decode(codec.encode(inventory.equipmentCommand(p1,s1))).obj;
  assert.equal(equipment.shipConfigs.length,2);
  assert.equal(equipment.shipConfigs[0].laser.length,1);
});
test('socket adapter returns real mutation result and cannot equip another player item',()=>{
  const handlers=new Map(),sent=[];
  require('../game/handlers/inventory').register((name,fn)=>handlers.set(name,fn),{sendCmd:(s,c)=>sent.push(c)});
  const session={player:players.loadPlayer(p1)};
  const cmd={hangarId:s1,source:'inventory',destination:'ship',configId:1,slotSet:'lasers',items:[loose(p2)]};
  handlers.get('HangarShipMoveItemsRequest')(session,cmd);
  assert.equal(sent.at(-1).result,0);
  cmd.items=[loose()];handlers.get('HangarShipMoveItemsRequest')(session,cmd);
  assert.equal(sent.at(-1).result,1);
  handlers.get('HangarShipDetailRequest')(session,{shipId:s1});
  assert.equal(sent.at(-1).laserCount,2);
  assert.equal(codec.decode(codec.encode(sent.at(-1))).obj.shipId,s1);
});
test('ammo consumes exactly one shot across multiple stacks and preserves shortage',()=>{
  const p=players.loadPlayer(p1);p.stats.laserCount=3;
  db.prepare('UPDATE items SET amount=2 WHERE player_id=? AND loot_id=?').run(p1,ammo.DEFAULT_AMMO);
  db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,2)').run(p1,ammo.DEFAULT_AMMO);
  assert.equal(ammo.consume(p),true);assert.equal(ammo.count(p),1);
  assert.equal(ammo.consume(p),false);assert.equal(ammo.count(p),1);
  p.stats.laserCount=0;assert.equal(ammo.consume(p),false);assert.equal(ammo.count(p),1);
});
