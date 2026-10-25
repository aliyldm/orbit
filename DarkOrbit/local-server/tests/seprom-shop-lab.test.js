'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),economy=require('../game/economy'),World=require('../game/world'),lab=require('../game/handlers/lab'),codec=require('../game/codec/codec');
let db,p;const original=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;const id=players.createPlayer(players.createAccount('seprom-test','testpass'),'Seprom',1,{...require('../config').starter,uridium:10000});p=players.loadPlayer(id);});
afterEach(()=>{World.current=original;database.close();});
const stock=()=>db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(p.userId)?.amount||0;
const update=(item,ore,amount=1,now=1000)=>lab.update(p,{itemToUpdate:{itemValue:item},updateWith:{oreType:{typeValue:ore},count:amount}},{db,now});
test('normal and native shop expose actual Seprom1U quantity product, credit ore stock and never create inventory placeholders',()=>{
 assert.equal(economy.offers(p.userId).resource_ore_seprom.price,1);
 assert.equal(economy.purchase(p.userId,'resource_ore_seprom',37).result,'success');assert.equal(stock(),37);
 assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(p.userId).uridium,9963);
 assert.equal(db.prepare('SELECT COUNT(*)n FROM items WHERE player_id=? AND loot_id=?').get(p.userId,'resource_ore_seprom').n,0);
 const html=require('../web/portal/render').renderPage('internalDock','internalDockSpecials',players.loadPlayer(p.userId)),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\}),\s*\r?\n\s*numItems/.exec(html)[1]);
 const row=rows.resource_ore_seprom;assert.equal(row.price,1);assert.equal(row.isAmountSetable,true);assert.equal(row.isPaymentItem,false);assert.match(html,/id="resource_ore_seprom"/);assert.match(html,/seprom_100x100\.png/);
 const native=require('../game/handlers/shop').list(p,'extras').itemList.find(x=>x.lootId==='resource_ore_seprom');assert.deepEqual(native.price,[1]);assert.equal(native.isPaymentItem,0);
});
test('insufficient balance, forged quantity, storage overflow and late storage failure cannot debit or partly deliver Seprom',()=>{
 for(const n of [10001,0,-1,'1e3',1.5])assert.equal(economy.purchase(p.userId,'resource_ore_seprom',n).result,'error');assert.equal(stock(),0);
 db.exec("CREATE TRIGGER seprom_fail BEFORE INSERT ON player_resources WHEN NEW.ore_type=7 BEGIN SELECT RAISE(ABORT,'Seprom failure'); END");
 assert.equal(economy.purchase(p.userId,'resource_ore_seprom',10).result,'error');assert.equal(stock(),0);assert.equal(players.loadPlayer(p.userId).uridium,10000);db.exec('DROP TRIGGER seprom_fail');
 db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,7,1000000000)').run(p.userId);assert.equal(economy.purchase(p.userId,'resource_ore_seprom',1).result,'error');assert.equal(stock(),1000000000);
});
test('bought Seprom feeds native enrichment, adds60% laser/rocket and40%shield, cannot increase engine speed or ArGe cost',()=>{
 assert.equal(economy.purchase(p.userId,'resource_ore_seprom',4).result,'success');
 for(const item of [0,1,3])update(item,7);assert.equal(stock(),1);
 assert.equal(lab.consumeShot(p,0,{db}),1.6);assert.equal(lab.consumeShot(p,1,{db}),1.6);
 assert.equal(lab.applyStats(p.userId,{speed:400,speedGeneratorBonus:100,shieldMax:1000},{db,now:1001}).shieldMax,1400);
 assert.throws(()=>update(2,7),/Geçersiz/);assert.equal(stock(),1);
 const info=lab.buildInit(p,{db,now:1001})[0];assert.equal(codec.decode(codec.encode(info)).rest,0);assert.equal(info.itemsUpdatedInfo[3].oreCountToUpdateWith.count,10);
 assert.equal(lab.applyStats(p.userId,{speed:400,shieldMax:1000},{db,now:601000}).shieldMax,1000);
});
test('engine ore improves installed generators only, with correct timers and compatibility',()=>{
 db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,6,2)').run(p.userId);update(2,6);
 assert.equal(lab.applyStats(p.userId,{speed:300,shieldMax:0,speedGeneratorBonus:0},{db,now:1001}).speed,300);
 assert.equal(lab.applyStats(p.userId,{speed:400,shieldMax:0,speedGeneratorBonus:100},{db,now:1001}).speed,420);
 assert.equal(lab.applyStats(p.userId,{speed:400,shieldMax:0,speedGeneratorBonus:100},{db,now:601000}).speed,400);
 for(const [ore,damage,performance]of [[4,1.15,null],[5,null,1.1],[6,1.3,1.2],[7,1.6,1.4],[28,1.5,1.5]]){if(damage)assert.equal(lab.DAMAGE[ore],damage);if(performance)assert.equal(lab.PERFORMANCE[ore],performance);}
});
test('live purchase preserves pending wallet reward and publishes actual native ore stock immediately',()=>{
 const w=new World(require('../config')),sent=[],s={world:w,send(b){sent.push(codec.decode(b.subarray(3)).obj);}};w.login(s,p.userId);World.current=()=>w;
 w.player.uridium=12000;assert.equal(economy.purchase(p.userId,'resource_ore_seprom',55).result,'success');assert.equal(w.player.uridium,11945);assert.equal(stock(),55);
 assert.ok(sent.some(c=>c._==='AttributeOreCountUpdateCommand'&&c.oreCountList.some(o=>o.oreType.typeValue===7&&o.count===55)));
 assert.ok(sent.some(c=>c._==='UserInventoryModule'));w.removeSession(s);
});
