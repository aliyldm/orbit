'use strict';
const {test,beforeEach,afterEach}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs'),vm=require('node:vm');
const database=require('../game/db'),players=require('../game/db/players');
const drones=require('../game/drones'),economy=require('../game/economy'),World=require('../game/world');
let db,pid,other;const current=World.current;
beforeEach(()=>{
 database.close();db=database.open(':memory:');World.current=()=>null;
 const add=name=>{const a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');return players.createPlayer(Number(a.lastInsertRowid),name,1,require('../config.json').starter);};
 pid=add('prices');other=add('other');db.prepare('UPDATE players SET credits=100000000,uridium=10000000').run();
});
afterEach(()=>{World.current=current;database.close();});
const money=()=>db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(pid);
test('Flax prices increase on every purchase and return the next price and real balance',()=>{
 const prices=[100000,200000,400000,800000,1600000,3200000,6400000,12800000];let balance=money().credits;
 for(let i=0;i<prices.length;i++){
  assert.equal(economy.offers(pid).drone_flax.price,prices[i]);
  const r=economy.purchase(pid,'drone_flax',1);balance-=prices[i];
  assert.equal(r.result,'success');assert.match(r.message,/FLAX diroiti/);
  assert.equal(r.userBalance.credits,balance);assert.equal(money().credits,balance);
  assert.equal(r.updatedPrice,prices[Math.min(i+1,7)]);
  assert.equal(r.dronePrices.drone_flax.notBuyable,i===7);
 }
 assert.equal(economy.purchase(pid,'drone_flax',1).result,'error');assert.equal(money().credits,balance);
});
test('Iris and Flax prices use same-type ownership, separate accounts and current ownership after sale',()=>{
 economy.purchase(pid,'drone_iris',1);economy.purchase(pid,'drone_flax',1);
 assert.equal(economy.offers(pid).drone_iris.price,24000);assert.equal(economy.offers(pid).drone_flax.price,200000);
 assert.equal(economy.offers(other).drone_iris.price,15000);assert.equal(economy.offers(other).drone_flax.price,100000);
 const d=drones.owned(db,pid).find(d=>d.loot_id==='drone_iris');drones.sell(pid,d.id);
 assert.equal(economy.offers(pid).drone_iris.price,15000);
});
test('insufficient funds and failed ownership storage never advance the price ladder',()=>{
 economy.purchase(pid,'drone_flax',1);db.prepare('UPDATE players SET credits=199999 WHERE id=?').run(pid);
 assert.equal(economy.purchase(pid,'drone_flax',1).result,'error');assert.equal(money().credits,199999);
 db.prepare('UPDATE players SET credits=200000 WHERE id=?').run(pid);
 db.exec("CREATE TRIGGER fail_drone BEFORE INSERT ON drones BEGIN SELECT RAISE(ABORT,'storage'); END");
 assert.equal(economy.purchase(pid,'drone_flax',1).result,'error');assert.equal(money().credits,200000);
 assert.equal(economy.offers(pid).drone_flax.price,200000);assert.equal(drones.owned(db,pid).length,1);
});
test('numeric portal row collisions resolve by category without buying or charging a booster',()=>{
 const before=money();let r=economy.purchase(pid,'1',1,'drone');
 assert.equal(r.itemId,'drone_flax');assert.equal(r.result,'success');
 assert.equal(money().credits,before.credits-100000);assert.equal(money().uridium,before.uridium);
 r=economy.purchase(pid,'2',1,'drone');assert.equal(r.itemId,'drone_iris');
 assert.equal(money().uridium,before.uridium-15000);
 assert.equal(db.prepare('SELECT COUNT(*) n FROM player_boosters WHERE player_id=?').get(pid).n,0);
 r=economy.purchase(pid,'1',1,'booster');assert.equal(r.itemId,'booster_ep-b01');
 assert.equal(drones.owned(db,pid).length,2);assert.equal(money().uridium,before.uridium-25000);
});
test('recorded portal rows retain DOM identities with account-specific canonical product prices',()=>{
 economy.purchase(pid,'drone_flax',1);economy.purchase(pid,'drone_iris',1);
 const html=require('../web/portal/render').renderPage('internalDock','internalDockDrones',players.loadPlayer(pid));
 const data=JSON.parse(html.match(/itemData\s*:\s*(\{[^\r\n]*\}),\s*\r?\n\s*numItems/)[1]);
 assert.equal(data['1'].imageVars.loot_id,'drone_flax');assert.equal(data['1'].price,200000);assert.equal(data['1'].salePrice,200000);
 assert.equal(data['2'].price,24000);assert.match(html,/userDroneAmount\s*:\s*2/);
 assert.equal(require('../game/handlers/shop').list(players.loadPlayer(pid),'drone').itemList.find(i=>i.lootId==='drone_iris').price[0],24000);
});
test('browser submits canonical loot identity and applies price, sale price and capacity together',()=>{
 let submitted;const rows={'1':{price:100000,currency:'virtual',imageVars:{loot_id:'drone_flax'}},'2':{price:15000,currency:'real',imageVars:{loot_id:'drone_iris'}}};
 const jq=()=>({length:0});Object.assign(jq,{ajax:r=>{submitted=r.data;},each:(o,fn)=>Object.entries(o).forEach(([k,v])=>fn(k,v))});
 const context={jQuery:jq};vm.createContext(context);vm.runInContext(fs.readFileSync(require.resolve('../client/resources/js/shop.js'),'utf8'),context);
 const shop=context.Shop;shop.Parameters={itemData:rows};shop.getAjaxUrl=()=>'/ajax/shop.php';let selected='1';
 shop.Item={getId:()=>selected,getImageData:()=>rows[selected].imageVars,getCategory:()=> 'drone',getSelectedAmount:()=>1,getSelectedLevel:()=>0,getSelectedName:()=>'',setPrice:p=>{rows[selected].price=p;},setSalePrice:p=>{rows[selected].salePrice=p;}};
 shop.Itemlist={updateItemCost:()=>{}};shop.updateBuyButton=()=>{};
 context.Tools={Text:{getFormattedNumber:n=>String(n)}};
 shop.processPurchase();assert.equal(submitted.itemId,'drone_flax');assert.equal(submitted.category,'drone');
 selected='2';shop.processPurchase();assert.equal(submitted.itemId,'drone_iris');
 shop.applyDronePrices({drone_flax:{price:200000,notBuyable:true},drone_iris:{price:24000,notBuyable:true}});
 assert.equal(rows['1'].price,200000);assert.equal(rows['1'].salePrice,200000);assert.equal(rows['2'].salePrice,24000);assert.equal(rows['1'].notBuyable,true);assert.equal(rows['2'].notBuyable,true);
});
