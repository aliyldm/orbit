'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),economy=require('../game/economy'),laserShop=require('../game/laser-shop'),codec=require('../game/codec/codec');
let db,p;const current=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;p=players.loadPlayer(players.createPlayer(players.createAccount('laser-shop-qa','test-pass'),'Laser QA',1,{...require('../config').starter,uridium:60000000,credits:10000000}));});
afterEach(()=>{World.current=current;database.close();});
test('all26 original laser types have matching portal/native offers and local HTTP icon paths, while launchers remain visible',()=>{
 assert.equal(laserShop.IDS.length,26);const html=require('../web/portal/render').renderPage('internalDock','internalDockLaser',p),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(html)[1]);
 const native=require('../game/handlers/shop').list(p,'laser');assert.equal(codec.decode(codec.encode(native)).rest,0);
 const tiles=[...html.matchAll(require('../web/portal/shop-campaigns').TILE)].map(t=>t[1]);assert.equal(tiles.length,28);assert.equal(new Set(tiles).size,28);
 for(const id of laserShop.IDS){const r=rows[id],offer=economy.offers(p.userId)[id];assert.ok(tiles.includes(id),id);assert.equal(r.price,offer.price,id);assert.equal(r.currency,offer.currency,id);assert.equal(r.imageVars.loot_id,id);assert.equal(r.maxAmount,1000);assert.equal(r.isPaymentItem,false);assert.equal(r.notBuyable,require('../game/laser-sales').blocked(id));assert.match(r.itemListImageUrl,/^\/client\/do_img\//);assert.ok(fs.statSync(path.join(__dirname,'..',r.itemListImageUrl)).size>0,id);assert.ok(native.itemList.some(item=>item.lootId===id&&item.price[0]===offer.price),id);}
 for(const id of ['equipment_weapon_rocketlauncher_hst-1','equipment_weapon_rocketlauncher_hst-2'])assert.ok(tiles.includes(id));
 for(const id of ['lf-5','lf-5-mf','lf-5-al','pr-l','os-l','am-l','lf-4-hp','lf-4-pd','lf-4-md'])assert.ok(rows['equipment_weapon_laser_'+id]);

});
test('every laser purchase delivers real individual equipment with exact price and preserves existing campaign manifests',()=>{
 for(const id of laserShop.IDS){const offer=economy.offers(p.userId)[id],key=offer.currency==='real'?'uridium':'credits',before=players.loadPlayer(p.userId)[key],owned=db.prepare('SELECT count(*) n FROM items WHERE player_id=? AND loot_id=?').get(p.userId,id).n;const r=economy.purchase(p.userId,id,2,'weapon');if(require('../game/laser-sales').blocked(id)){assert.equal(r.result,'error');assert.equal(players.loadPlayer(p.userId)[key],before);assert.equal(db.prepare('SELECT count(*) n FROM items WHERE player_id=? AND loot_id=?').get(p.userId,id).n,owned);continue;}assert.equal(r.result,'success',id);assert.equal(r.userBalance[key],before-offer.price*2,id);const items=db.prepare('SELECT * FROM items WHERE player_id=? AND loot_id=?').all(p.userId,id);assert.equal(items.length,owned+2,id);assert.ok(items.every(i=>i.amount===1),id);}
 const payment=require('../game/payment'),offers=economy.offers(p.userId);assert.equal(Object.keys(payment.captures).length,196);assert.ok(offers['package_event-deal-laser-lf5mf']);
});
