'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),portal=require('../web/portal/render'),campaigns=require('../web/portal/shop-campaigns'),payment=require('../game/payment');
let db,p;const previousWorld=World.current;
before(()=>{database.close();db=database.open(':memory:');World.current=()=>null;p=players.loadPlayer(players.createPlayer(players.createAccount('shop-category','testpass'),'Category',1,require('../config').starter));});
after(()=>{World.current=previousWorld;database.close();});
const rows=html=>JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\}),\s*\r?\n\s*numItems/.exec(html)[1]);
const render=tpl=>portal.renderPage('internalDock',tpl,p);
function aligned(html){
 const data=rows(html),ids=[...html.matchAll(campaigns.TILE)].map(m=>m[1]);
 assert.equal(ids.length,Object.keys(data).length);assert.equal(new Set(ids).size,ids.length);
 assert.deepEqual(new Set(ids),new Set(Object.keys(data)));
 assert.equal(Number(/numItems\s*:\s*(\d+)/.exec(html)[1]),ids.length);
 assert.equal(JSON.parse(/startupItemId\s*:\s*("[^"\n]*")/.exec(html)[1]),ids[0]);
 for(const tile of html.matchAll(campaigns.TILE))assert.match(tile[0],/class="itemList_singlePrice"/);
 return data;
}
test('all196 restored Payment SKUs appear exactly once in the original Özel Fırsatlar tab',()=>{
 assert.equal(portal.hasPage('internalDock',campaigns.TEMPLATE),true);
 const html=render(campaigns.TEMPLATE),data=aligned(html);
 assert.equal(Object.keys(data).length,196);assert.deepEqual(new Set(Object.keys(data)),new Set(Object.keys(payment.captures).filter(id=>!require('../game/equipment-policy').offerRemoved(id,{localPayment:true,paymentSku:id}))));
 assert.match(html,/id="subNavSpecialOffers" class="[^"]*subNavButtonActive/);
 assert.match(html,/id="subNavExtras" class="[^"]*subNavButtonInactive/);
 assert.doesNotMatch(html,/<article>|data-sku=|internalPaymentProxy/);
 for(const [id,row]of Object.entries(data)){
  assert.equal(row.price,1000000,id);assert.equal(row.currency,'real',id);assert.equal(row.localPayment,true,id);
  const why=payment.reason(payment.entry(id),db)||require('../game/economy').offers(p.userId)[id].disabledReason;
  if(why){assert.equal(row.notBuyable,true,id);assert.match(row.description,/Yerel durum/,id);}
  const image=path.join(__dirname,'../client',row.itemListImageUrl.split('?')[0].replace(/^\/(?:client\/)?/,''));
  assert.ok(fs.statSync(image).size>0,image);
 }
 const configuration=[...html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script\s*>/gi)].map(m=>m[1]).find(s=>/Shop\.Parameters\s*=/.test(s));
 assert.match(configuration,/User\.Parameters/);assert.doesNotThrow(()=>new vm.Script(configuration));
});
test('all ordinary categories remove complete campaign tiles and selection data without empty cells',()=>{
 for(const file of fs.readdirSync(path.join(__dirname,'../web/portal/pages')).filter(f=>/^internalDock~/.test(f))){
  const html=render(file.slice('internalDock~'.length,-5)),data=aligned(html);
  assert.ok(Object.keys(data).length>0,file);
  assert.ok(Object.keys(data).every(id=>!payment.entry(id)),file);
  assert.equal((html.match(/id="subNavSpecialOffers"/g)||[]).length,1,file);
  assert.match(html,/internalDock&amp;tpl=internalDockOffers/,file);
 }
 const extras=rows(render('internalDockSpecials'));
 for(const id of ['equipment_extra_cpu_ajp-01','resource_ore_seprom','resource_upgrade-module','resource_convert-module'])assert.ok(extras[id],id);
 assert.match(fs.readFileSync(path.join(__dirname,'../client/css/local-shop.css'),'utf8'),/#item_list > \.item\s*\{[^}]*height:100px/);
});
test('Payment navigation opens the same campaign category and preserves bulk/disabled products',()=>{
 const direct=rows(render(campaigns.TEMPLATE)),paymentPage=rows(portal.renderPage('internalPayment',undefined,p));
 assert.deepEqual(paymentPage,direct);
 assert.equal(direct['package_event-deal-powerup-ammo-25'].maxAmount,1000);
 assert.equal(direct['package_event-deal-powerup-ammo-25'].isAmountSetable,true);
 assert.equal(direct['package_expo-tartarus'].isAmountSetable,false);
});
