'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),economy=require('../game/economy'),World=require('../game/world'),sales=require('../game/laser-sales'),payment=require('../game/payment');
let db,p;const current=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;p=players.loadPlayer(players.createPlayer(players.createAccount('laser-sales','test'),'Sales',1,{...require('../config').starter,credits:10000000,uridium:10000000}));});
afterEach(()=>{World.current=current;database.close();});
test('all26 laser tiles remain visible while the17 post-LF4 products disable the original purchase button',()=>{
 const html=require('../web/portal/render').renderPage('internalDock','internalDockLaser',p),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(html)[1]),ids=require('../game/laser-shop').IDS;
 assert.equal(ids.filter(sales.blocked).length,17);assert.equal(ids.length,26);
 for(const id of ids){assert.ok(rows[id],id);assert.equal(rows[id].notBuyable,sales.blocked(id),id);if(sales.blocked(id)){assert.equal(rows[id].isBuyable,false);assert.ok(rows[id].description.includes(sales.REASON));}}
});
test('direct and mixed-package purchases cannot debit, add items or create a receipt for restricted lasers',()=>{
 const offers=economy.offers(p.userId),beforeWallet=db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(p.userId),beforeItems=db.prepare('SELECT * FROM items ORDER BY id').all();let direct=0,bundles=0;
 for(const [id,o]of Object.entries(offers))if(sales.reason(id,o)){
  for(const amount of [1,3]){const result=economy.purchase(p.userId,id,amount,o.category);assert.equal(result.result,'error',id);assert.equal(result.message,sales.REASON,id);}
  if(o.localPayment)bundles++;else direct++;
 }
 assert.equal(direct,17);assert.ok(bundles>=20);assert.deepEqual(db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(p.userId),beforeWallet);assert.deepEqual(db.prepare('SELECT * FROM items ORDER BY id').all(),beforeItems);assert.equal(db.prepare('SELECT COUNT(*) n FROM payment_purchase_receipts').get().n,0);
});
test('restricted bundles stay on Special Offers with original manifests; pure ammo and LF4 remain buyable',()=>{
 const html=require('../web/portal/render').renderPage('internalDock','internalDockOffers',p),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(html)[1]);
 assert.equal(Object.keys(rows).length,196);for(const record of Object.values(payment.captures))if(sales.recordReason(record)){assert.equal(rows[record.sku].notBuyable,true,record.sku);assert.equal(rows[record.sku].isBuyable,false);assert.ok(record.contents===null||record.contents.items);}
 assert.equal(economy.purchase(p.userId,'equipment_weapon_laser_lf-4',1).result,'success');assert.equal(economy.purchase(p.userId,'ammunition_laser_lcb-10',100).result,'success');
});
test('owned modern lasers and their assignments, levels and pending upgrades survive rejected purchases',()=>{
 const id=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount,upgrade_level)VALUES(?,'equipment_weapon_laser_lf-5-mf',1,19)").run(p.userId).lastInsertRowid),inv=require('../game/inventory');
 inv.move(p.userId,{hangarId:p.shipId,from:{target:'inventory',items:[id],configId:1},to:{target:'ship',slotset:'lasers',configId:1}});
 const before=db.prepare('SELECT * FROM items WHERE id=?').get(id),stats=players.loadPlayer(p.userId).stats;
 assert.equal(economy.purchase(p.userId,'equipment_weapon_laser_lf-5-mf',1).result,'error');assert.deepEqual(db.prepare('SELECT * FROM items WHERE id=?').get(id),before);assert.deepEqual(players.loadPlayer(p.userId).stats,stats);
 assert.equal(require('../game/equipment-policy').removed(before.loot_id),false);assert.ok(Object.values(require('../game/assembly').RECIPES).some(r=>r.targets?.includes(before.loot_id)));
});

test('forged native shop buy requests reject restricted laser and bundle without touching balances',()=>{
 const handlers=new Map(),sent=[],codec=require('../game/codec/codec');require('../game/handlers/shop').register((name,fn)=>handlers.set(name,fn),{sendCmd:(s,c)=>sent.push(codec.decode(codec.encode(c)).obj)});
 const before=db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(p.userId);
 for(const [id,category]of [['equipment_weapon_laser_lf-5-mf','laser'],['package_event-deal-laser-prl','special']]){
  handlers.get('ShopItemBuyRequest')({player:p},{lootId:id,category,amount:3,level:0,buyCategory:0,action:0});const reply=sent.at(-1);assert.equal(reply._,'ShopItemBuyCommand');assert.equal(reply.resultId,0);assert.equal(reply.realBuyAmount,0);
 }
 assert.deepEqual(db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(p.userId),before);
});
