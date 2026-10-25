'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const dbModule=require('../game/db'),players=require('../game/db/players'),economy=require('../game/economy'),World=require('../game/world'),portal=require('../web/portal/render');
let db,index=0;const originalWorld=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});
after(()=>{World.current=originalWorld;dbModule.close();});
function fixture(){const name=`portal-shop-${++index}`,account=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');const id=players.createPlayer(Number(account.lastInsertRowid),name,1,require('../config.json').starter);db.prepare('UPDATE players SET credits=10000000,uridium=10000000 WHERE id=?').run(id);return id;}
function rendered(playerId,tpl){return portal.renderPage('internalDock',tpl,players.loadPlayer(playerId));}
function rows(html){return JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/.exec(html)[1]);}
function cost(html,rowId){const escaped=rowId.replace(/[.*+?^${}()|[\]\\]/g,'\\$&');const match=new RegExp('<a id="'+escaped+'"[\\s\\S]*?<\\/a>\\s*<\\/div>\\s*<div class="itemList_singlePrice"[^>]*>([^<]*)<\\/div>').exec(html);assert.ok(match,`missing live price node for ${rowId}`);return match[1];}

test('ship descriptions stay inside one valid HTML script and preserve decoded description markup',()=>{
 const playerId=fixture(),html=rendered(playerId,'internalDockShips');
 // This models the HTML tokenizer boundary, which JavaScript-only JSON parsing misses.
 const scripts=[...html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script\s*>/gi)].map(m=>m[1]);
 const configuration=scripts.find(s=>/Shop\.Parameters\s*=/.test(s));assert.ok(configuration);
 assert.match(configuration,/User\.Parameters\s*=/,'embedded description must not terminate the configuration script');
 assert.doesNotThrow(()=>new vm.Script(configuration));
 const data=rows(html),raw=fs.readFileSync(path.join(__dirname,'../web/portal/pages/internalDock~internalDockShips.html'),'utf8');
 assert.equal(data.ship_pusat.description,rows(raw).ship_pusat.description,'escaping the outer script must not alter the actual description');
 assert.match(data.ship_pusat.description,/<table id="shipDetails">/);assert.match(data.ship_pusat.description,/<script/);
 assert.doesNotMatch(configuration,/<\/script/i);assert.match(configuration,/\\u003c/);
});

test('all captured shop configuration scripts compile with their closing data intact',()=>{
 const playerId=fixture();for(const file of fs.readdirSync(path.join(__dirname,'../web/portal/pages')).filter(f=>/^internalDock~/.test(f))){
  const html=rendered(playerId,file.slice('internalDock~'.length,-5));
  const configuration=[...html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script\s*>/gi)].map(m=>m[1]).find(s=>/Shop\.Parameters\s*=/.test(s));
  if(configuration){assert.match(configuration,/User\.Parameters\s*=/,file);assert.doesNotThrow(()=>new vm.Script(configuration),file);}
 }
});

test('rendered drone list and selection data use the next owned-count price after buying and reloading',()=>{
 const playerId=fixture();assert.equal(economy.purchase(playerId,'drone_iris',1).result,'success');assert.equal(economy.purchase(playerId,'drone_flax',1).result,'success');
 const html=rendered(playerId,'internalDockDrones'),data=rows(html);
 assert.equal(data['1'].price,200000);assert.equal(data['2'].price,24000);assert.equal(data['1'].imageVars.price_plain,'200.000 C.');assert.equal(data['2'].imageVars.price_plain,'24.000 U.');
 assert.equal(cost(html,'1'),'200.000 C.');assert.equal(cost(html,'2'),'24.000 U.');
 assert.match(html,/shop\/itemlist\.js\?[^"\s]*&local=20261023currency/);
});

function frontend(data){
 const prices={},preview={},empty={length:0},nodes={};let balance={credits:10000000,uridium:10000000};
 function node(text){return {length:1,value:text,classes:new Set(),text(value){this.value=value;return this;},find(){return empty;},addClass(c){this.classes.add(c);return this;}};}
 for(const rowId of Object.keys(data)){const price=node(data[rowId].cost);nodes[rowId]={price,find(selector){return selector==='.itemList_singlePrice'&&price.classes.has('itemList_singlePrice')?price:empty;},children(){return {last:()=>price};}};}
 const jq=()=>({length:0});jq.each=(object,fn)=>Object.entries(object).forEach(([k,v])=>fn(k,v));
 const context=vm.createContext({jQuery:jq,Library:{get:()=>({val:value=>{prices.selected=value;}})},User:{Pet:{},setBalance:b=>balance=b,getDiscountFactor:()=>1,getBalanceByCurrencyType:currency=>balance[currency==='virtual'?'credits':'uridium']},
  Tools:{Text:{getFormattedNumber:n=>Number(n).toLocaleString('tr-TR'),getWithReplacements:(key,values)=>values['%VALUE%']+(key==='pricetag_credits_compact'?' C.':' U.')},Popup:{Presets:{showSuccessDialog(){},showErrorDialog(){}}},ErrorHandler:{Events:{onGeneralError:message=>{throw Error(message);}}}}});
 for(const file of ['shop.js','shop/item.js','shop/itemlist.js','shop/amountSelector.js'])vm.runInContext(fs.readFileSync(path.join(__dirname,'../client/resources/js',file),'utf8'),context);
 const shop=context.Shop;shop.Parameters={itemData:data};shop.Itemlist.getItemContainerById=id=>nodes[id];shop.Item.resizeText=(value,key)=>preview[key]=value;
 shop.updateBuyButton=()=>{prices.disabled=shop.Item.notBuyable()||!shop.isUserBalanceSufficient();};
 return {shop,nodes,prices,preview};
}

test('real purchase callback updates bare captured price nodes, selected preview, affordability and correct debit immediately',()=>{
 const playerId=fixture(),front=frontend(rows(rendered(playerId,'internalDockDrones'))),{shop,nodes,prices,preview}=front;
 shop.Item.setId('2');shop.AmountSelector.setSelectedAmount(1);
 const iris=economy.purchase(playerId,'2',1,'drone');assert.equal(iris.result,'success');assert.equal(iris.userBalance.uridium,9985000);
 shop.Events.onPurchaseSuccess(iris);
 assert.equal(nodes['2'].price.value,'24.000 U.');assert.equal(nodes['1'].price.value,'100.000 C.');assert.equal(prices.selected,'24.000 U.');assert.equal(preview.previewPrice,'24.000 U.');assert.equal(prices.disabled,false);
 shop.Item.setId('1');const flax=economy.purchase(playerId,'1',1,'drone');assert.equal(flax.userBalance.credits,9900000);shop.Events.onPurchaseSuccess(flax);
 assert.equal(nodes['1'].price.value,'200.000 C.');assert.equal(nodes['2'].price.value,'24.000 U.');assert.equal(prices.selected,'200.000 C.');assert.equal(preview.previewPrice,'200.000 C.');
 // Backend state remains authoritative if the next purchase consumes the last funds.
 shop.Item.setId('2');const result={...economy.purchase(playerId,'2',1,'drone'),userBalance:{credits:0,uridium:0}};shop.Events.onPurchaseSuccess(result);
 assert.equal(nodes['2'].price.value,'42.000 U.');assert.equal(prices.disabled,true);
});

test('eighth standard drone disables both drone rows immediately and a ninth request cannot debit',()=>{
 const playerId=fixture(),{shop,nodes,prices}=frontend(rows(rendered(playerId,'internalDockDrones')));shop.Item.setId('2');shop.AmountSelector.setSelectedAmount(1);
 for(let n=0;n<8;n++){const response=economy.purchase(playerId,'2',1,'drone');assert.equal(response.result,'success');shop.Events.onPurchaseSuccess(response);}
 assert.equal(shop.Parameters.itemData['1'].notBuyable,true);assert.equal(shop.Parameters.itemData['2'].notBuyable,true);assert.equal(prices.disabled,true);
 assert.equal(nodes['2'].price.value,'200.000 U.');
 const before=db.prepare('SELECT uridium FROM players WHERE id=?').get(playerId).uridium;assert.equal(economy.purchase(playerId,'2',1,'drone').result,'error');assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(playerId).uridium,before);
});
