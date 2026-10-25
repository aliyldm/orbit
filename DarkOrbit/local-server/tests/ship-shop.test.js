'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),economy=require('../game/economy'),shipShop=require('../game/ship-shop'),portal=require('../web/portal/render'),campaigns=require('../web/portal/shop-campaigns'),codec=require('../game/codec/codec');
let db,p;const previous=World.current;
const original=require('../web/portal/shop.json'),ajax=require('../web/portal/ajax.json'),roster=JSON.parse(Buffer.from(ajax['/flashAPI/inventory.php|getHangarList'].body,'base64')).data.ret.shipInfo;
function expected(id){
 if(id.endsWith('-plus'))return {price:500000,currency:'real',fixed:true};
 if(original[id]&&!original[id].isPaymentItem)return {price:original[id].price,currency:original[id].currency,fixed:false};
 const r=roster.find(r=>r.lootId===id).price;
 if(!r.isPayment&&(r.credits||r.uridium||id==='ship_phoenix'))return {price:r.credits||r.uridium,currency:r.credits||!r.uridium?'virtual':'real',fixed:false};
 return {price:1000000,currency:'real',fixed:true};
}
function hangarPrice(o){return {uridium:o.currency==='real'?o.price:0,credits:o.currency==='virtual'?o.price:0,isPayment:0};}
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;p=players.loadPlayer(players.createPlayer(players.createAccount('ship-shop-qa','test-pass'),'Ship QA',1,{...require('../config').starter,uridium:2000000000,credits:2000000000}));});
afterEach(()=>{World.current=previous;database.close();});

test('all80 hangar ships appear once; only Plus ships receive500k and ordinary prices retain their currency',()=>{
 const native=require('../game/handlers/shop').list(p,'ship'),hulls=native.itemList.filter(r=>shipShop.has(r.lootId));assert.equal(hulls.length,80);assert.deepEqual(new Set(hulls.map(r=>r.lootId)),new Set(shipShop.IDS));
 assert.equal(codec.decode(codec.encode(native)).rest,0);
 for(const r of hulls){const o=expected(r.lootId);assert.deepEqual(r.price,[o.price],r.lootId);assert.equal(r.cost,String(o.price));assert.equal(r.currency,o.currency);assert.equal(r.maxAmount,1);assert.equal(r.isPaymentItem,0);}
 const offers=economy.offers(p.userId);
 for(const[id,price,currency]of [['ship_phoenix',0,'virtual'],['ship_liberator',40000,'virtual'],['ship_bigboy',285000,'virtual'],['ship_goliath',50000,'real'],['ship_pusat',250000,'real'],['ship_solace',250000,'real'],['ship_g-ignite',1000000,'real'],['ship_pusat-plus',500000,'real'],['ship_solace-plus',500000,'real']])assert.deepEqual([offers[id].price,offers[id].currency],[price,currency],id);
 assert.deepEqual(new Set(shipShop.PLUS_IDS),new Set(roster.filter(r=>r.lootId.endsWith('-plus')).map(r=>r.lootId)));
});

test('every hull charges its restored currency and price, delivers full health and preserves active equipment and catalog stats',()=>{
 const types=db.prepare('SELECT * FROM ship_types ORDER BY loot_id').all(),active=p.shipId,originalCount=db.prepare('SELECT count(*) n FROM ships WHERE player_id=?').get(p.userId).n;
 for(const id of shipShop.IDS){
  const before=players.loadPlayer(p.userId),o=expected(id),result=economy.purchase(p.userId,id,1,'ship');assert.equal(result.result,'success',id);assert.equal(result.userBalance.uridium,before.uridium-(o.currency==='real'?o.price:0),id);assert.equal(result.userBalance.credits,before.credits-(o.currency==='virtual'?o.price:0),id);
  const delivered=db.prepare('SELECT * FROM ships WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(p.userId,id);assert.equal(delivered.hitpoints,db.prepare('SELECT hitpoints FROM ship_types WHERE loot_id=?').get(id).hitpoints,id);
 }
 assert.equal(players.loadPlayer(p.userId).shipId,active);assert.equal(db.prepare('SELECT count(*) n FROM ships WHERE player_id=?').get(p.userId).n,originalCount+80);
 assert.deepEqual(db.prepare('SELECT * FROM ship_types ORDER BY loot_id').all(),types);
 const hangar=JSON.parse(Buffer.from(require('../web/inventory-api').handle(p.userId,new URLSearchParams({action:'getHangarList'})).body,'base64'));
 assert.equal(hangar.isError,0);assert.equal(hangar.data.ret.hangars.length,originalCount+80);
 for(const r of hangar.data.ret.shipInfo)if(shipShop.has(r.lootId)){assert.deepEqual(r.price,hangarPrice(expected(r.lootId)));assert.equal(r.owned,1);}
});

test('insufficient funds, bulk ships and SQL delivery failure cannot debit or create a hull',()=>{
 const id='ship_pusat-plus',count=()=>db.prepare('SELECT count(*) n FROM ships WHERE player_id=?').get(p.userId).n,before=count();
 db.prepare('UPDATE players SET uridium=499999 WHERE id=?').run(p.userId);assert.equal(economy.purchase(p.userId,id,1).result,'error');assert.equal(count(),before);assert.equal(players.loadPlayer(p.userId).uridium,499999);
 db.prepare('UPDATE players SET uridium=1000000 WHERE id=?').run(p.userId);assert.equal(economy.purchase(p.userId,id,2).result,'error');
 db.exec("CREATE TRIGGER reject_ship BEFORE INSERT ON ships BEGIN SELECT RAISE(ABORT,'qa delivery failure'); END");assert.equal(economy.purchase(p.userId,id,1).result,'error');assert.equal(count(),before);assert.equal(players.loadPlayer(p.userId).uridium,1000000);
});

test('portal prices, currency backgrounds, sorting, hangar quotes and Plus fixed-price display agree for all80 ships',()=>{
 const html=portal.renderPage('internalDock','internalDockShips',p),data=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(html)[1]),tiles=[...html.matchAll(campaigns.TILE)];
 assert.equal(Object.keys(data).length,80);assert.equal(tiles.length,80);assert.deepEqual(new Set(tiles.map(t=>t[1])),new Set(shipShop.IDS));assert.match(html,/numItems\s*:\s*80/);
 for(const id of shipShop.IDS){const r=data[id],o=expected(id);assert.equal(r.price,o.price,id);assert.equal(r.salePrice,o.price);assert.equal(r.currency,o.currency);assert.equal(r.cost,o.price.toLocaleString('tr-TR')+(o.currency==='real'?' U.':' C.'));assert.equal(r.imageVars.price_plain,r.cost);assert.equal(r.localFixedPrice,o.fixed);assert.equal(r.isPaymentItem,false);assert.equal(r.notBuyable,false);assert.ok(r.itemListBackGroundUrl.includes('bg-'+o.currency+'_'));assert.ok(r.itemListImageUrl.startsWith('/client/do_img/'),id);assert.ok(fs.statSync(path.join(__dirname,'../client',r.itemListImageUrl.slice('/client'.length))).size>0,id);}
 const order=tiles.map(t=>data[t[1]]),compare=require('../web/portal/shop-sort').compare;for(let i=1;i<order.length;i++)assert.ok(compare(order[i-1],order[i])<=0,'Credits first, then unit price');
 for(const script of [...html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script\s*>/gi)].map(m=>m[1]))assert.doesNotThrow(()=>new vm.Script(script));
 const priceScript=/<script id="local_payment_price">([\s\S]*?)<\/script>/.exec(html)[1],ctx={User:{getDiscountFactor:()=>.75},Shop:{Parameters:{itemData:data},Item:{getId:()=> 'ship_solace-plus'}}};vm.runInNewContext(priceScript,ctx);assert.equal(ctx.User.getDiscountFactor(),1);
 ctx.Shop.Item.getId=()=> 'ship_goliath';assert.equal(ctx.User.getDiscountFactor(),.75);
 const hangar=JSON.parse(Buffer.from(require('../web/inventory-api').handle(p.userId,new URLSearchParams({action:'getHangarList'})).body,'base64'));
 assert.equal(hangar.data.ret.shipInfo.filter(s=>shipShop.has(s.lootId)).length,80);for(const r of hangar.data.ret.shipInfo)if(shipShop.has(r.lootId))assert.deepEqual(r.price,hangarPrice(expected(r.lootId)));
});
