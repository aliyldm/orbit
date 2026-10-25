'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const dbModule=require('../game/db'),players=require('../game/db/players'),economy=require('../game/economy'),World=require('../game/world'),pet=require('../game/pet'),portal=require('../web/portal/render');
let db,index=0;const originalWorld=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});
after(()=>{World.current=originalWorld;dbModule.close();});
function fixture({owned=true,fuel=0,uridium=10000}={}){const name=`native-fuel-${++index}`,account=players.createAccount(name,'testpass'),id=players.createPlayer(account,name,1,require('../config.json').starter);db.prepare('UPDATE players SET uridium=? WHERE id=?').run(uridium,id);if(owned){pet.addOwned(db,id,1);if(fuel)pet.addFuel(db,id,fuel);}return id;}
function render(id,tpl='internalDockPetGear'){return portal.renderPage('internalDock',tpl,players.loadPlayer(id));}
function rows(html){return JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/.exec(html)[1]);}
function parameters(html){return JSON.parse(/User\.Parameters\s*=\s*(\{[^\r\n]*\});/.exec(html)[1]);}
function frontend(id){
 const html=render(id),elements=new Map(),requests=[],responses=[];
 const element=key=>{if(!elements.has(key))elements.set(key,{length:1,value:'',classes:new Set(),val(v){if(v===undefined)return this.value;this.value=v;return this;},html(v){this.value=v;return this;},text(v){this.value=v;return this;},addClass(c){this.classes.add(c);return this;},removeClass(c){this.classes.delete(c);return this;},after(){return this;}});return elements.get(key);};
 const jq=element;jq.each=(object,fn)=>Object.entries(object).forEach(([k,v])=>fn(k,v));
 jq.ajax=request=>{requests.push(request);const result=economy.purchase(id,request.data.itemId,request.data.amount,request.data.category,request.data.level);responses.push(result);request.success(result);};
 const context=vm.createContext({jQuery:jq,Library:{get:element},Tools:{Popup:{Presets:{showSuccessDialog(){},showErrorDialog(){}}},ErrorHandler:{Events:{onGeneralError:m=>{throw Error(m);},onTypeUndefined:m=>{throw Error(m);}}}}});
 for(const file of ['tools/text.js','user.js','user/pet.js','user/ship.js','shop.js','shop/item.js','shop/amountSelector.js'])vm.runInContext(fs.readFileSync(path.join(__dirname,'../client/resources/js',file),'utf8'),context);
 context.Tools.Text.resources=JSON.parse(/var textResources\s*=\s*(\{[^\r\n]*\});/.exec(html)[1]);context.User.Parameters=parameters(html);context.User.Pet.hasPet=context.User.Parameters.pet.hasPet;
 const s=context.Shop;s.Parameters={itemData:rows(html)};s.LevelSelector={getSelectedLevel:()=>1};s.NameSelector={getName:()=> 'P.E.T.'};s.Item.setId('resource_pet-fuel');s.AmountSelector.resetSelector();s.updateBuyButton();
 return {context,s,elements,requests,responses};
}

test('portal no longer injects three fixed shortcuts or the separate fuel form/script',()=>{
 const id=fixture();for(const [action,tpl]of [['internalStart',null],['internalPilotSheet',null],['internalDock','internalDockPetGear'],['internalDock','internalDockDrones'],['internalDock','internalDockShips']]){
  const html=portal.renderPage(action,tpl,players.loadPlayer(id));assert.doesNotMatch(html,/local_(?:upgrade_link|assembly_link|pet_fuel_link|pet_fuel\b)|pet_fuel_form|local-pet-fuel\.js/,action+' '+tpl);
 }
 assert.equal(fs.existsSync(path.join(__dirname,'../web/pet-fuel-ui.js')),false);assert.equal(fs.existsSync(path.join(__dirname,'../client/resources/js/local-pet-fuel.js')),false);
});

test('fuel is one normal selectable product tile inside the original PET modules list',()=>{
 const id=fixture(),html=render(id),data=rows(html),r=data['resource_pet-fuel'];
 assert.ok(r);assert.equal(r.category,'pet');assert.equal(r.price,.25);assert.equal(r.currency,'real');assert.equal(r.isPetFuel,true);assert.equal(r.isAmountSetable,true);assert.equal(r.isNameSetable,false);assert.equal(r.isLevelSetable,false);assert.equal(r.maxAmount,0);assert.equal(r.cost,'0,25 U.');assert.equal(r.code,'FUEL 100');
 assert.equal(Object.keys(data).length,15);assert.equal(/numItems\s*:\s*(\d+)/.exec(html)[1],'15');assert.equal((html.match(/<a id="resource_pet-fuel"/g)||[]).length,1);
 const start=html.indexOf('<div id="item_list">'),tile=html.indexOf('<a id="resource_pet-fuel"');assert.ok(tile>start);assert.ok(tile<html.indexOf('<a id="equipment_petgear_csr-02"'));
 assert.match(html,/background-image:url\(\/client\/do_img\/global\/items\/resource\/pet-fuel_100x100\.png\)/);assert.match(html,/>FUEL 100<\/div>/);assert.match(html,/class="itemList_singlePrice"[^>]*>0,25 U\.<\/div>/);
 assert.equal(fs.existsSync(path.join(__dirname,'../client/do_img/global/items/resource/pet-fuel_100x100.png')),true);
 assert.equal(rows(render(id,'internalDockPetProtocols'))['resource_pet-fuel'],undefined);
});

test('native quantity selector respects actual PET ownership, depot and fractional wallet on page load',()=>{
 const noPet=fixture({owned:false}),missing=frontend(noPet);assert.equal(missing.context.User.Pet.hasPet,false);assert.equal(missing.s.AmountSelector.getMaxAmount(),0);assert.equal(missing.elements.get('#buy_button').classes.has('inactive'),true);
 const id=fixture({fuel:99800,uridium:12.75}),f=frontend(id);assert.equal(f.context.User.Pet.getFuel(),99800);assert.equal(f.context.User.Pet.getMaxFuel(),100000);assert.equal(f.context.User.getBalanceByCurrencyType('real'),12.75);assert.equal(f.s.AmountSelector.getMaxAmount(),51);
 f.s.AmountSelector.updateSelectedAmount(51);assert.equal(f.s.Item.getPriceAsText(),'12,75 U.');assert.equal(f.s.isUserBalanceSufficient(),true);
 f.context.User.setBalance({credits:0,uridium:100000});f.s.AmountSelector.resetSelector();assert.equal(f.s.AmountSelector.getMaxAmount(),200,'depot space is authoritative when funds are ample');
});

test('original Shop purchase request and callback buy1000 fuel for250Uri and immediately refresh depot/capacity/balance',()=>{
 const id=fixture({fuel:99000,uridium:1000}),f=frontend(id);f.s.AmountSelector.updateSelectedAmount(1000);assert.equal(f.s.Item.getPriceAsText(),'250 U.');f.s.processPurchase();
 assert.equal(f.requests.length,1);const request=f.requests[0];assert.equal(request.url,'/ajax/shop.php');assert.equal(request.data.action,'purchase');assert.equal(request.data.itemId,'resource_pet-fuel');assert.equal(request.data.amount,1000);
 assert.equal(f.responses[0].result,'success');assert.equal(pet.owned(id).fuel,100000);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(id).uridium,750);
 assert.equal(f.context.User.Pet.hasPet,true);assert.equal(f.context.User.Pet.getFuel(),100000);assert.equal(f.context.User.getBalanceByCurrencyType('real'),750);assert.equal(f.s.AmountSelector.getMaxAmount(),0);assert.equal(f.elements.get('#buy_button').classes.has('inactive'),true);
 const reloaded=parameters(render(id));assert.equal(reloaded.pet.fuel,100000);assert.equal(reloaded.balance.uridium,750);
});

test('single-unit precision is preserved across purchases/reloads and over-capacity requests cannot debit',()=>{
 const id=fixture({uridium:1}),f=frontend(id);f.s.AmountSelector.updateSelectedAmount(3);f.s.processPurchase();assert.equal(f.responses[0].result,'success');assert.equal(pet.owned(id).fuel,3);assert.equal(f.context.User.getBalanceByCurrencyType('real'),.25);assert.equal(f.s.AmountSelector.getMaxAmount(),1);
 assert.equal(parameters(render(id)).balance.uridium,.25);assert.equal(economy.purchase(id,'resource_pet-fuel',2).result,'error');assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(id).uridium,.25);
 const full=fixture({fuel:100000}),before=db.prepare('SELECT uridium FROM players WHERE id=?').get(full).uridium;assert.equal(economy.purchase(full,'resource_pet-fuel',1).result,'error');assert.equal(pet.owned(full).fuel,100000);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(full).uridium,before);
});

test('an unrelated successful shop response no longer clears existing PET ownership',()=>{
 const id=fixture({fuel:20}),f=frontend(id);f.s.Events.onPurchaseSuccess({result:'success',message:'test',userBalance:{credits:0,uridium:10000}});assert.equal(f.context.User.Pet.hasPet,true);assert.equal(f.context.User.Pet.getFuel(),20);
});

test('native PET shop lists HP Link and its actual purchase equips a selectable native gear',()=>{
 const id=fixture({uridium:2000000}),html=render(id),data=rows(html),key='equipment_petgear_g-hpl1';
 assert.ok(html.includes('id="'+key+'"'));assert.equal(data[key].price,1000000);assert.equal(data[key].isPetGear,true);assert.equal(data[key].isPetFuel,false);assert.equal(data[key].notBuyable,false);
 const result=economy.purchase(id,key,1,'petGear',1);assert.equal(result.result,'success');assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(id).uridium,1000000);
 const item=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=?').get(id,key),p=players.loadPlayer(id);
 pet.move(id,{hangarId:p.shipId,from:{target:'inventory',items:[item.id],configId:1},to:{target:'pet',slotset:'gears',configId:1}});assert.ok(pet.stats(p).gears.some(g=>g.type===16));
 const unowned=fixture({owned:false});assert.equal(rows(render(unowned))[key].notBuyable,true);assert.equal(economy.purchase(unowned,key,1).result,'error');
});

test('a fresh account buys PET then fuel through the same original shop without reloading',()=>{
 const id=fixture({owned:false,uridium:100000}),f=frontend(id);assert.equal(f.context.User.Pet.hasPet,false);f.s.Item.setId('pet_pet10');f.s.processPurchase();
 assert.equal(f.responses[0].result,'success');assert.equal(f.responses[0].userPet.maxFuel,100000);assert.equal(f.context.User.Pet.hasPet,true);assert.equal(f.context.User.Pet.getFuel(),0);assert.equal(f.s.Parameters.itemData['resource_pet-fuel'].notBuyable,false);
 f.s.Item.setId('resource_pet-fuel');f.s.AmountSelector.resetSelector();f.s.AmountSelector.updateSelectedAmount(1000);f.s.processPurchase();
 assert.equal(f.responses[1].result,'success');assert.equal(f.context.User.Pet.getFuel(),1000);assert.equal(pet.owned(id).fuel,1000);assert.equal(f.context.User.getBalanceByCurrencyType('real'),49750);
});
