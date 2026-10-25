'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict');
const dbModule=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),economy=require('../game/economy'),audit=require('../game/shop-product-audit'),portal=require('../web/portal/render');
let db,index=0;const original=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});after(()=>{World.current=original;dbModule.close();});
function fixture(){const id=Number(db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run('shop-audit-'+(++index),'test').lastInsertRowid),p=players.createPlayer(id,'audit'+index,1,require('../config.json').starter);db.prepare('UPDATE players SET credits=100000000,uridium=100000000 WHERE id=?').run(p);return p;}
function snapshot(id){return {p:db.prepare('SELECT * FROM players WHERE id=?').get(id),items:db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),boosters:db.prepare('SELECT * FROM player_boosters WHERE player_id=?').all(id)};}
function rows(id,tpl){return JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/.exec(portal.renderPage('internalDock',tpl,players.loadPlayer(id)))[1]);}
test('every offered product and every resolved Payment component has an explicit typed classification',()=>{
 const all=audit.audit(economy.offers());assert.ok(all.length>500);
 for(const row of all){assert.ok(row.type&&row.status&&row.handler!==undefined,row.offerId);assert.notEqual(row.status,'unverified',row.offerId);for(const c of row.components||[])assert.notEqual(c.status,'unverified',row.offerId+':'+c.lootId);}
 assert.ok(all.some(r=>r.status==='collectible'));assert.ok(all.some(r=>r.status==='partial'));
 assert.equal(audit.classify('nonexistent_future_product').status,'unverified');assert.equal(audit.purchaseReason('nonexistent_future_product'),null,'unknown type is not an automatic deny rule');
});
test('unsupported functional products are rejected before any debit, insert, booster or receipt',()=>{
 const id=fixture(),before=snapshot(id);
 for(const sku of ['equipment_extra_cpu_anti-z1','equipment_extra_cpu_anti-z1-xl','equipment_extra_cpu_rd-x','captain_captain-generic','ammunition_mine_im-01','34','46','booster_prc-b00','booster_dmg-pvp01','equipment_petgear_g-fs1','equipment_petgear_g-hr1','equipment_aiprotocol_ai-ah1']){
  const response=economy.purchase(id,sku,1);assert.equal(response.result,'error',sku);assert.match(response.message,/henüz|desteklenmiyor/,sku);assert.deepEqual(snapshot(id),before,sku);
 }
 assert.equal(db.prepare('SELECT COUNT(*)n FROM payment_purchase_receipts WHERE player_id=?').get(id).n,0);
});
test('a mixed package with a known nonfunctional component is atomic and explains that component',()=>{
 const id=fixture(),before=snapshot(id),sku='package_event-deal-halloween-corn-pack',offer=economy.offers(id)[sku];
 const entry=audit.inspect(sku,offer);assert.equal(entry.status,'unsupported');assert.ok(entry.components.some(c=>c.lootId==='ammunition_specialammo_wiz-x'&&c.status==='unsupported'));
 const response=economy.purchase(id,sku,2);assert.equal(response.result,'error');assert.match(response.message,/WIZ-X/);assert.deepEqual(snapshot(id),before);
});
test('passive equipment, crafting material, cosmetic and a partially supported ship remain purchasable',()=>{
 const id=fixture();for(const sku of ['equipment_generator_shield_fs-01','resource_nano-case','resource_logfile','ship_goliath_design_amber','ship_aegis']){
  assert.notEqual(economy.offers(id)[sku].capability.status,'unsupported',sku);const response=economy.purchase(id,sku,1);assert.equal(response.result,'success',sku+':'+response.message);
 }
});
test('native portal exposes honest descriptions and disables unavailable effects using original buyability flags',()=>{
 const id=fixture(),extras=rows(id,'internalDockSpecials'),ships=rows(id,'internalDockShips'),booster=rows(id,'internalDockBooster');
 for(const sku of ['equipment_extra_cpu_anti-z1','equipment_extra_cpu_rd-x','captain_captain-generic']){assert.equal(extras[sku].notBuyable,true,sku);assert.equal(extras[sku].isBuyable,false);assert.match(extras[sku].description,/Yerel durum/);}
 assert.equal(ships.ship_aegis.localCapability,'partial');assert.match(ships.ship_aegis.description,/tanımlı solo yetenekler/);assert.notEqual(ships.ship_aegis.notBuyable,true);
 for(const sku of ['34','46']){assert.equal(booster[sku].notBuyable,true,sku);assert.match(booster[sku].description,/PvP|ganimet/);}
 const pack=rows(id,'internalDockOffers')['package_expo-tartarus'];assert.equal(pack.localCapability,'partial');assert.match(pack.description,/tanımlı solo yetenekler/);assert.equal(pack.notBuyable,false);
});
test('native in-game shop list excludes nonfunctional products and keeps real fuel/material offers',()=>{
 const id=fixture(),p=players.loadPlayer(id),shop=require('../game/handlers/shop');
 const extras=shop.list(p,'extras').itemList.map(x=>x.lootId);assert.ok(extras.includes('resource_booty-key'));assert.ok(!extras.includes('equipment_extra_cpu_anti-z1'));assert.ok(!extras.includes('equipment_extra_cpu_rd-x'));
 const boosters=shop.list(p,'booster').itemList.map(x=>x.lootId);assert.ok(!boosters.includes('booster_prc-b00'));assert.ok(!boosters.includes('34'));assert.ok(boosters.includes('booster_dmg-b01'));
});
