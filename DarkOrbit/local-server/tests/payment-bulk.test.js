'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const dbModule=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),economy=require('../game/economy'),payment=require('../game/payment'),portal=require('../web/portal/render');
let db,index=0;const originalWorld=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});after(()=>{World.current=originalWorld;dbModule.close();});
function fixture(uridium=20000000){const name=`payment-bulk-${++index}`,a=players.createAccount(name,'testpass'),id=players.createPlayer(a,name,1,require('../config.json').starter);db.prepare('UPDATE players SET uridium=? WHERE id=?').run(uridium,id);return id;}
function count(id,loot){return db.prepare('SELECT COALESCE(SUM(amount),0)n FROM items WHERE player_id=? AND loot_id=?').get(id,loot).n;}
function uri(id){return db.prepare('SELECT uridium FROM players WHERE id=?').get(id).uridium;}
function buy(id,sku,n){const result=economy.purchase(id,sku,n);assert.equal(result.result,'success',result.message);return result;}

test('three ammo packages cost3m and multiply every real bundle component exactly',()=>{
 const id=fixture();buy(id,'package_event-deal-powerup-ammo-25',3);assert.equal(uri(id),17000000);
 for(const [loot,expected]of Object.entries({'ammunition_laser_ucb-100':150000,'ammunition_laser_rcb-140':60000,'ammunition_laser_sab-50':30000,'ammunition_rocket_plt-2021':15000,'ammunition_rocketlauncher_hstrm-01':15000}))assert.equal(count(id,loot),expected,loot);
});

test('repeatable equipment creates separate usable rows while resources stack and currency packs multiply real balance',()=>{
 const id=fixture();buy(id,'package_event-deal-voyagers-igni-l',4);const items=db.prepare("SELECT amount FROM items WHERE player_id=? AND loot_id='equipment_weapon_drive_igd-l01'").all(id);assert.equal(items.length,4);assert.ok(items.every(i=>i.amount===1));
 buy(id,'package_event-deal-xyralith-s',3);assert.equal(count(id,'resource_collectable_xyralith'),3);
 const before=uri(id);buy(id,'package_event-deal-powerup-uri-25',3);assert.equal(uri(id),before-3000000+900000);
});

test('unique ships, cosmetics, PET and once-only package requests reject bulk without debit or partial delivery',()=>{
 const id=fixture(),before=db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),skus=['package_expo-tartarus','package_masqueChimera','package_event-deal-goldpass','package_event-deal-stellar2019-1','equipment_extra_hmd-07'];
 for(const sku of skus){const r=payment.entry(sku);assert.ok(r,sku);assert.equal(payment.maxAmount(r),1,sku);assert.equal(economy.purchase(id,sku,2).result,'error',sku);}
 assert.equal(uri(id),20000000);assert.deepEqual(db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),before);
});

test('bulk bounds, affordability and failed middle-of-bundle writes preserve all account state',()=>{
 const id=fixture(2500000),sku='package_event-deal-powerup-ammo-25';assert.equal(economy.purchase(id,sku,3).result,'error');assert.equal(uri(id),2500000);assert.equal(count(id,'ammunition_laser_ucb-100'),0);
 for(const quantity of [0,-1,1.5,1001,'1e0',Infinity,NaN])assert.equal(economy.purchase(id,sku,quantity).result,'error',String(quantity));
 db.prepare('UPDATE players SET uridium=20000000 WHERE id=?').run(id);
 db.exec("CREATE TRIGGER fail_bulk_component BEFORE INSERT ON items WHEN NEW.loot_id='ammunition_laser_sab-50' BEGIN SELECT RAISE(ABORT,'bulk-payment-storage'); END");
 try{const result=economy.purchase(id,sku,3);assert.equal(result.result,'error');assert.match(result.message,/bulk-payment-storage/);}finally{db.exec('DROP TRIGGER fail_bulk_component');}
 assert.equal(uri(id),20000000);assert.equal(count(id,'ammunition_laser_ucb-100'),0);assert.equal(count(id,'ammunition_laser_rcb-140'),0);
});

test('stack capacity failure rolls back its full gross bulk debit',()=>{
 const id=fixture();db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(id,'resource_collectable_xyralith',2147483646);
 assert.equal(economy.purchase(id,'package_event-deal-xyralith-s',2).result,'error');assert.equal(count(id,'resource_collectable_xyralith'),2147483646);assert.equal(uri(id),20000000);
});

test('bulk booster packages multiply exact hour grants, including five-hour shield components',()=>{
 const id=fixture(),now=Date.now();buy(id,'package_event-deal-powerup-booster-25',2);const after=Date.now();
 for(const [loot,hours]of Object.entries({'booster_npc-b01':40,'booster_npc-b02':20,'booster_dmg-b01':20,'booster_dmg-b02':20,'booster_dmg-h01':20,'booster_shd-b02':10})){const time=db.prepare('SELECT expires_at FROM player_boosters WHERE player_id=? AND loot_id=?').get(id,loot).expires_at;assert.ok(time>=now+hours*3600000&&time<=after+hours*3600000,loot);}
 assert.equal(uri(id),18000000);
});

test('original shop rows and native quantity widget send the chosen bulk amount at fixed unit price',()=>{
 const id=fixture(),html=portal.renderPage('internalDock','internalDockOffers',players.loadPlayer(id)),data=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/.exec(html)[1]);
 const sku='package_event-deal-powerup-ammo-25',r=data[sku];assert.equal(r.maxAmount,1000);assert.equal(r.isAmountSetable,true);assert.deepEqual(r.amountsSelectable,['ten','hundred','thousand','max']);assert.equal(r.price,1000000);assert.equal(data['package_expo-tartarus'].isAmountSetable,false);
 const elements=new Map(),element=key=>{if(!elements.has(key))elements.set(key,{length:1,value:'',val(v){this.value=v;return this;},text(v){this.value=v;return this;},addClass(){return this;},removeClass(){return this;},after(){return this;}});return elements.get(key);};const jq=element;jq.each=(o,fn)=>Object.entries(o).forEach(([k,v])=>fn(k,v));let balance=20000000,request;
 jq.ajax=r=>{request=r;const result=economy.purchase(id,r.data.itemId,r.data.amount);assert.equal(result.result,'success');balance=result.userBalance.uridium;};
 const context=vm.createContext({jQuery:jq,Library:{get:element},User:{getDiscountFactor:()=>.5,getBalanceByCurrencyType:()=>balance,Ship:{getLaserAmmunitionSpace:()=>1e9,getRocketSpace:()=>1e9},Pet:{}},Tools:{Text:{getFormattedNumber:n=>n.toLocaleString('tr-TR'),getWithReplacements:(key,values)=>values['%VALUE%']+' U.'}}});
 for(const file of ['shop.js','shop/item.js','shop/amountSelector.js'])vm.runInContext(fs.readFileSync(path.join(__dirname,'../client/resources/js',file),'utf8'),context);context.Shop.Parameters={itemData:data};context.Shop.LevelSelector={getSelectedLevel:()=>1};context.Shop.Item.setId(sku);
 vm.runInContext(payment.portalScript.replace(/^<script[^>]*>/,'').replace(/<\/script>$/,''),context);
 context.Shop.AmountSelector.resetSelector();assert.equal(context.Shop.AmountSelector.getMaxAmount(),20);context.Shop.AmountSelector.updateSelectedAmount(3);assert.equal(context.Shop.Item.getPriceAsText(),'3.000.000 U.');assert.equal(context.Shop.isUserBalanceSufficient(),true);
 balance=2500000;assert.equal(context.Shop.isUserBalanceSufficient(),false,'a unit salePrice must not disguise a bulk shortfall');balance=20000000;context.Shop.processPurchase();assert.equal(request.url,'/ajax/shop.php');assert.equal(request.data.amount,3);assert.equal(uri(id),17000000);
 const item=require('../game/handlers/shop').list(players.loadPlayer(id),'special').itemList.find(r=>r.lootId===sku);assert.equal(item.maxAmount,1000);
});

test('Payment navigation uses the original Specials shop instead of a separate fixed-quantity catalog',()=>{
 const id=fixture(),html=portal.renderPage('internalPayment',undefined,players.loadPlayer(id));
 assert.match(html,/body class="internalDockShop_special"/);assert.doesNotMatch(html,/<article>|data-sku=|Yerel Uridyum Dükkânı/);
 const data=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/.exec(html)[1]);assert.equal(data['package_event-deal-powerup-ammo-25'].isAmountSetable,true);assert.equal(data['package_event-deal-powerup-ammo-25'].price,1000000);
});
