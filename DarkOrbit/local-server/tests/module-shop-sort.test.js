'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const database=require('../game/db'),players=require('../game/db/players'),economy=require('../game/economy'),World=require('../game/world'),portal=require('../web/portal/render');
let db,p;const originalWorld=World.current;
before(()=>{database.close();db=database.open(':memory:');World.current=()=>null;const id=players.createPlayer(players.createAccount('module-shop','testpass'),'Modules',1,{...require('../config').starter,uridium:5000000,credits:10000000});p=players.loadPlayer(id);});
after(()=>{World.current=originalWorld;database.close();});
function rows(html){return JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\}),\s*\r?\n\s*numItems/.exec(html)[1]);}
function rowOrder(html,data){return [...html.matchAll(/<a id="([^"]+)"/g)].map(m=>m[1]).filter(id=>Object.hasOwn(data,id));}
function ascending(values,label){for(let i=1;i<values.length;i++){
 const rank=row=>row.currency==='virtual'?0:row.currency==='real'?1:2;
 const previous=values[i-1],current=values[i];assert.ok(rank(current)>rank(previous)||(rank(current)===rank(previous)&&Number(current.price)>=Number(previous.price)),`${label}: ${JSON.stringify(previous)} before ${JSON.stringify(current)}`);
}}
test('both module products use original Extras quantity UI and real shared prices/icons',()=>{
 const html=portal.renderPage('internalDock','internalDockSpecials',p),data=rows(html),order=rowOrder(html,data);
 for(const definition of require('../game/module-policy').DEFINITIONS){
  const row=data[definition.id];assert.ok(row,definition.id);assert.equal(row.price,10000);assert.equal(row.salePrice,10000);assert.equal(row.isAmountSetable,true);assert.equal(row.notBuyable,false);assert.equal(row.isPaymentItem,false);assert.equal(row.cost,'10.000 U.');assert.equal(row.imageVars.loot_id,definition.id);assert.equal(order.filter(id=>id===definition.id).length,1);
  assert.ok(fs.existsSync(path.join(__dirname,'../client',definition.icon.replace(/^\/(?:client\/)?/,''))),definition.icon);
  assert.equal(economy.offers(p.userId)[definition.id].price,row.price);
 }
 assert.equal(data.resource_ore_seprom.price,1);assert.equal(Number(/numItems\s*:\s*(\d+)/.exec(html)[1]),Object.keys(data).length);
});
test('every captured shop orders Credits first then current unit price and preserves selection keys',()=>{
 for(const file of fs.readdirSync(path.join(__dirname,'../web/portal/pages')).filter(f=>/^internalDock~/.test(f))){
  const html=portal.renderPage('internalDock',file.slice('internalDock~'.length,-5),p);if(!html.includes('Shop.Parameters'))continue;
  const data=rows(html),ids=rowOrder(html,data);assert.ok(ids.length>0,file);assert.equal(new Set(ids).size,ids.length,file);assert.equal(ids.length,Object.keys(data).length,file);
  ascending(ids.map(id=>data[id]),file);
 }
 const html=portal.renderPage('internalDock','internalDockDrones',p),order=rowOrder(html,rows(html));assert.ok(order.indexOf('1')<order.indexOf('2'));
});
test('native shop lists use the same ascending current account prices including both Extras modules',()=>{
 const native=require('../game/handlers/shop');for(const category of ['ship','laser','drone','extras','ammunition','generator','petgear','protocol','special']){
  const list=native.list(p,category).itemList;ascending(list.map(item=>({...item,price:item.price[0]})),category);
 }
 const extras=native.list(p,'extras').itemList;
 for(const id of ['resource_upgrade-module','resource_convert-module'])assert.ok(extras.some(item=>item.lootId===id&&item.price[0]===10000),id);
});
test('native campaign capacity does not hide expensive bundles or ordinary Extras when sorting',()=>{
 const native=require('../game/handlers/shop'),payment=require('../game/payment'),offers=economy.offers(p.userId);
 const special=native.list(p,'special').itemList,extras=native.list(p,'extras').itemList;
 assert.ok(special.length<=127);assert.ok(extras.length<=127);
 for(const [id,offer]of Object.entries(offers)){
  if(offer.category!=='special'||offer.disabledReason)continue;
  if(offer.localPayment){if(offer.paymentAlias||payment.reason(payment.entry(offer.paymentSku),db))continue;assert.ok(special.some(item=>item.lootId===id),id);}
  else assert.ok(extras.some(item=>item.lootId===id),id);
 }
 assert.ok(special.every(item=>offers[item.lootId].localPayment&&!offers[item.lootId].paymentAlias));
 const codec=require('../game/codec/codec');assert.equal(codec.decode(codec.encode(native.list(p,'special'))).rest,0);assert.equal(codec.decode(codec.encode(native.list(p,'extras'))).rest,0);
});
test('browser price refresh moves original nodes and rebuilds keyboard selection order without duplicates',()=>{
 const a={id:'iris',handler:'iris-click'},b={id:'flax',handler:'flax-click'},c={id:'formation',handler:'formation-click'},nodes=[a,b,c];
 const list={length:1,children(){return {get:()=>nodes.slice()};},append(node){nodes.splice(nodes.indexOf(node),1);nodes.push(node);}};
 const jq=value=>value==='#item_list'?list:{find(){return {attr:()=>value.id};}};
 const context=vm.createContext({jQuery:jq});vm.runInContext(fs.readFileSync(path.join(__dirname,'../client/resources/js/shop.js'),'utf8'),context);
 const shop=context.Shop;shop.Parameters={itemData:{iris:{price:15000},flax:{price:100000},formation:{price:75000}}};let refreshed=0;
 shop.Itemlist={Attributes:{},getItemLinkIdsFromDom:()=>nodes.map(n=>n.id),fetchItemLinkObjects(){refreshed++;}};
 shop.sortItemsByPrice();assert.deepEqual(nodes,[a,c,b]);assert.deepEqual(shop.Itemlist.Attributes.itemLinkIds,['iris','formation','flax']);
 shop.Parameters.itemData.iris.price=120000;shop.sortItemsByPrice();assert.deepEqual(nodes,[c,b,a]);assert.equal(a.handler,'iris-click');assert.equal(refreshed,2);assert.equal(nodes.length,3);
 shop.Parameters.itemData.flax.currency='virtual';shop.Parameters.itemData.iris.currency='real';shop.Parameters.itemData.formation.currency='real';
 shop.sortItemsByPrice();assert.deepEqual(nodes,[b,c,a],'Credits first even when more expensive numerically');
});
