'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),vm=require('vm');
const dbModule=require('../game/db'),players=require('../game/db/players'),economy=require('../game/economy'),World=require('../game/world');
const payment=require('../game/payment'),META=require('../docs/client-map.items.json').items,codec=require('../game/codec/codec');
let db,index=0;const originalWorld=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});
after(()=>{World.current=originalWorld;dbModule.close();});
function fixture(uridium=5000000){const username=`payment-qa-${++index}`,account=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(username,'test');
 const id=players.createPlayer(Number(account.lastInsertRowid),username,1,require('../config.json').starter);db.prepare('UPDATE players SET uridium=?,credits=42 WHERE id=?').run(uridium,id);return id;}
function itemCount(id,loot){return db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(id,loot).n;}
function balance(id){return db.prepare('SELECT credits,uridium,ep,level FROM players WHERE id=?').get(id);}
function owned(id,loot){const m=META[loot];if(m.typeClass?.endsWith('.ShipDesignType'))return db.prepare('SELECT COUNT(*) n FROM ship_designs WHERE player_id=? AND loot_id=?').get(id,loot).n;
 if(m.kind==='Drone')return db.prepare('SELECT COUNT(*) n FROM drones WHERE player_id=? AND loot_id=?').get(id,loot).n;
 if(m.kind==='Ship')return db.prepare('SELECT COUNT(*) n FROM ships WHERE player_id=? AND loot_id=?').get(id,loot).n;
 if(m.kind==='Booster')return db.prepare('SELECT COUNT(*) n FROM player_boosters WHERE player_id=? AND loot_id=?').get(id,loot).n;
 if(loot.startsWith('resource_ore_')){const types=['prometium','endurium','terbium','xenomit','prometid','duranium','promerium','seprom','palladium'],type=types.indexOf(loot.slice(13));if(type>=0)return db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=?').get(id,type)?.amount||0;}
 return itemCount(id,loot);}
test('all 196 captured payment rows retain1m price; ordinary products retain prices except the explicit500k Plus hulls',()=>{
 const offers=economy.offers();assert.equal(Object.keys(payment.captures).length,196);
 for(const r of Object.values(payment.captures).filter(r=>offers[r.sku]))assert.deepEqual([offers[r.sku].price,offers[r.sku].currency,offers[r.sku].isPaymentItem,offers[r.sku].maxAmount],[1000000,'real',false,payment.maxAmount(r)],r.sku);
 const original=require('../web/portal/shop.json');for(const [id,row]of Object.entries(original))if(!row.isPaymentItem&&![...Object.keys(require('../game/pet-shop').offers()),'resource_pet-fuel'].includes(id)&&META[id]?.kind!=='Drone'&&!require('../game/equipment-policy').removed(id))assert.equal(offers[id].price,require('../game/ship-shop').isPlus(id)?500000:row.price,id);
 assert.equal(offers.ammunition_laser_ucb?.price,undefined);
 assert.equal(offers['package_event-deal-halloween-discovery'].price,1000000);
 assert.equal(offers['resource_booty-key-red'].price,META['resource_booty-key-red'].uridium);
 assert.equal(offers['resource_ore_seprom']?.localPayment,undefined,'an icon for a large package must not become a one-Seprom purchase');
});

test('every available captured offer delivers its complete declared contents with one atomic one-million debit',()=>{
 let count=0;
 for(const r of Object.values(payment.captures)){
  const offer=economy.offers()[r.sku];if(!offer)continue;const why=payment.reason(r,db)||offer.disabledReason;if(why)continue;
  const id=fixture(),before=balance(id),counts=Object.fromEntries(Object.keys(r.contents.items||{}).map(loot=>[loot,owned(id,loot)]));
  const bought=economy.purchase(id,r.sku,1,r.category);assert.equal(bought.result,'success',`${r.sku}: ${bought.message}`);
  assert.equal(balance(id).uridium,before.uridium-1000000+(r.contents.uridium||0),r.sku);
  assert.equal(balance(id).credits,before.credits+(r.contents.credits||0),r.sku);
  for(const [loot,n]of Object.entries(r.contents.items||{}))assert.equal(owned(id,loot),counts[loot]+n,`${r.sku} -> ${loot}`);
  count++;
 }
 assert.equal(count,143,`Expected143 current purchasable products, got ${count}`);
});

test('incomplete or nonfunctional packages display a price but cannot debit, grant an icon item, or report success',()=>{
 const id=fixture(),before=balance(id),count=db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=?').get(id).n;
 const offers=economy.offers();for(const r of Object.values(payment.captures).filter(r=>payment.reason(r,db)||!offers[r.sku]||offers[r.sku].disabledReason))assert.equal(economy.purchase(id,r.sku,1,r.category).result,'error',r.sku);
 assert.deepEqual(balance(id),before);assert.equal(db.prepare('SELECT COUNT(*) n FROM items WHERE player_id=?').get(id).n,count);
});

test('payment amounts, affordability, missing players and unknown aliases are rejected before delivery',()=>{
 const id=fixture(999999),sku='package_event-deal-voyagers-igni-l';
 assert.equal(economy.purchase(id,sku,1).result,'error');
 db.prepare('UPDATE players SET uridium=5000000 WHERE id=?').run(id);
 const before=balance(id);for(const amount of [0,-1,1.5,'1e0',1001,NaN,Infinity,'','000'])assert.equal(economy.purchase(id,sku,amount).result,'error',String(amount));
 assert.equal(economy.purchase(id,'unknown_payment_sku',1).result,'error');assert.equal(economy.purchase(2147483647,sku,1).result,'error');
 assert.deepEqual(balance(id),before);assert.equal(itemCount(id,'equipment_weapon_drive_igd-l01'),0);
});

test('multi-item storage failure rolls back all preceding deliveries and currency',()=>{
 const id=fixture(),sku='package_event-deal-powerup-ammo-25',before=balance(id),items=db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id);
 db.exec("CREATE TRIGGER fail_payment_component BEFORE INSERT ON items WHEN NEW.loot_id='ammunition_laser_sab-50' BEGIN SELECT RAISE(ABORT,'payment-storage-test'); END");
 try{const result=economy.purchase(id,sku,1);assert.equal(result.result,'error');assert.match(result.message,/payment-storage-test/);}finally{db.exec('DROP TRIGGER fail_payment_component');}
 assert.deepEqual(balance(id),before);assert.deepEqual(db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),items);
});

test('already-owned design in a bundle rolls back other products and debit',()=>{
 const id=fixture(),sku='package_event-deal-phantasm-fullpack';assert.equal(economy.purchase(id,sku,1).result,'success');
 const before=balance(id),ammo=itemCount(id,'ammunition_laser_sbl-100');
 assert.equal(economy.purchase(id,sku,1).result,'error');assert.deepEqual(balance(id),before);assert.equal(itemCount(id,'ammunition_laser_sbl-100'),ammo);
});

test('currency bundle credits real balance, Ore bundles use actual cargo, and boosters start actual timers',()=>{
 const id=fixture();assert.equal(economy.purchase(id,'package_event-deal-powerup-uri-25',1).result,'success');assert.equal(balance(id).uridium,4300000);assert.equal(itemCount(id,'currency_uridium'),0);
 assert.equal(economy.purchase(id,'package_event-deal-halloween-discovery',1).result,'success');assert.equal(balance(id).uridium,3450000);assert.equal(owned(id,'resource_ore_seprom'),5000);assert.equal(itemCount(id,'resource_ore_seprom'),0);
 const start=Date.now();assert.equal(economy.purchase(id,'package_event-deal-dmg-npc-boosters',1).result,'success');
 for(const loot of ['booster_npc-b01','booster_npc-b02','booster_dmg-b01','booster_dmg-b02']){const row=db.prepare('SELECT expires_at FROM player_boosters WHERE player_id=? AND loot_id=?').get(id,loot);assert.ok(row.expires_at>=start+36000000);assert.equal(itemCount(id,loot),0);}
});

test('live purchases retain pending rewards, send valid balance/inventory packets, and failed writes preserve memory',()=>{
 const id=fixture(),p=players.loadPlayer(id),packets=[],session={send:bytes=>packets.push(codec.decode(bytes.subarray(3)).obj)};
 const world={player:p,livePlayer:pid=>pid===id?p:null,broadcast:fn=>fn(session)};
 p.uridium+=250;p.credits+=400;World.current=()=>world;
 try{
  assert.equal(economy.purchase(id,'package_event-deal-voyagers-igni-l',1).result,'success');
  assert.equal(p.uridium,4000250);assert.equal(p.credits,442);assert.equal(balance(id).uridium,p.uridium);assert.equal(balance(id).credits,p.credits);
  assert.ok(packets.some(c=>c._==='AttributeCreditsUpdateCommand'&&c.uridium===4000250));assert.ok(packets.some(c=>c._===require('../game/inventory').buildInit(p)._));
  const before={...balance(id)},memory={uridium:p.uridium,credits:p.credits};
  db.exec("CREATE TRIGGER fail_live_payment BEFORE INSERT ON items WHEN NEW.loot_id='equipment_weapon_drive_igd-l01' BEGIN SELECT RAISE(ABORT,'live-payment-test'); END");
  try{assert.equal(economy.purchase(id,'package_event-deal-voyagers-igni-l',1).result,'error');}finally{db.exec('DROP TRIGGER fail_live_payment');}
  assert.deepEqual({...balance(id)},before);assert.deepEqual({uridium:p.uridium,credits:p.credits},memory);
 }finally{World.current=()=>null;}
});

test('native shop lists encode fixed-price products and buy request delivers alias contents',()=>{
 const id=fixture(),p=players.loadPlayer(id),shop=require('../game/handlers/shop'),handlers={},sent=[];
 const listed=new Set();
 for(const category of ['ship','shipdesign','laser','extras','customization','special']){
  const list=shop.list(p,category);assert.ok(list.itemList.length<=127);assert.equal(codec.decode(codec.encode(list)).obj._,'ShopItemListCommand');
  for(const item of list.itemList)listed.add(item.lootId);
  for(const item of list.itemList)if(economy.offers()[item.lootId]?.localPayment)assert.deepEqual([item.price[0],item.currency,item.cost,item.isPaymentItem,item.maxAmount],[1000000,'real','1000000',0,payment.maxAmount(payment.entry(economy.offers()[item.lootId].paymentSku))]);
 }
 const offers=economy.offers();for(const r of Object.values(payment.captures))if(offers[r.sku]&&!payment.reason(r,db)&&!offers[r.sku].disabledReason)assert.ok(listed.has(r.sku),`Native shop omitted ${r.sku}`);
 const source=shop.list(p,'special');assert.ok(source.itemList.some(i=>i.lootId==='package_event-deal-powerup-uri-25'));
 shop.register((name,fn)=>handlers[name]=fn,{sendCmd:(s,c)=>{codec.encode(c);sent.push(c);}});
 handlers.ShopItemBuyRequest({player:p},{lootId:'package_event-deal-voyagers-igni-l',category:'special',amount:1,level:1,buyCategory:0,action:0});
 assert.equal(sent.find(c=>c._==='ShopItemBuyCommand').resultId,1);assert.equal(itemCount(id,'equipment_weapon_drive_igd-l01'),1);assert.equal(balance(id).uridium,4000000);
});

test('portal shop rows and Payment menu use local purchase, fixed prices and no payment redirects',()=>{
 const p=players.loadPlayer(fixture()),portal=require('../web/portal/render');let rows=0;
 for(const file of ['internalDock~internalDockOffers']){
  const html=portal.renderPage(file.split('~')[0],file.split('~')[1],p,'http://127.0.0.1:8095');assert.doesNotMatch(html,/internalPaymentProxy/);
  const match=/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/.exec(html);assert.ok(match);
  for(const [sku,row]of Object.entries(JSON.parse(match[1])))if(payment.entry(sku)){
   assert.deepEqual([row.price,row.currency,row.cost,row.isPaymentItem,row.paymentUrl,row.salePrice,row.discountPercent],[1000000,'real','1.000.000 U.',false,'',1000000,1]);assert.equal(row.imageVars.price_plain,'1.000.000 U.');rows++;
  }
 }
 assert.equal(rows,196);
 const catalog=portal.renderPage('internalPayment',undefined,p);assert.match(catalog,/Shop\.Parameters\s*=/);assert.match(catalog,/category\s*:\s*'special'/);assert.doesNotMatch(catalog,/internalPaymentProxy|data-sku=/);assert.match(catalog,/\/client\/resources\/js\/shop\.js/);
});

test('account discount wrapper ignores discount for fixed local offers only',()=>{
 const context=vm.createContext({User:{getDiscountFactor:()=>0.5},Shop:{Parameters:{itemData:{paid:{localPayment:true},ordinary:{price:4000}}},Item:{getId:()=>context.selected}},selected:'paid'});
 vm.runInContext(payment.portalScript.replace(/^<script[^>]*>/,'').replace(/<\/script>$/,''),context);
 assert.equal(context.User.getDiscountFactor(),1);context.selected='ordinary';assert.equal(context.User.getDiscountFactor(),0.5);
});
