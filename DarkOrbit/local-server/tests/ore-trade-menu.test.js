'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),gameplay=require('../game/gameplay'),maps=require('../game/maps'),loot=require('../game/collectables'),cpu=require('../game/cpu'),pet=require('../game/pet'),inv=require('../game/inventory'),codec=require('../game/codec/codec');
let db,id,w,s,p,out,handlers;
beforeEach(()=>{database.close();db=database.open(':memory:');id=players.createPlayer(players.createAccount('ore-trade','test-pass'),'Trade',1,config.starter);w=new World(config);s={world:w,send(){},close(){}};w.login(s,id);p=w.player;out=[];const send=(session,c)=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);out.push(decoded.obj);};new Combat(w,send);w.petSend=send;handlers=new Map();gameplay.register((name,fn)=>handlers.set(name,fn),{sendCmd:send});db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,7,91234)ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=91234').run(id);});
afterEach(()=>{w.cancelScheduled();w.collectables?.clear();w.removeSession(s);database.close();});
const ore=()=>db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(id).amount;
const req=(amount=1234)=>({_:'TradeSellOreRequest',toSell:{_:'OreCountModule',oreType:{_:'OreTypeModule',typeValue:7},count:amount}});
const ask=()=>handlers.get('TradeRequest')(s,{});
function equip(lootId,target='ship',slotset='extras'){const item=Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(id,lootId).lastInsertRowid);(target==='pet'?pet:inv).move(id,{hangarId:p.shipId,from:{target:'inventory',configId:1,items:[item]},to:{target,configId:1,slotset}});return db.prepare('SELECT * FROM items WHERE id=?').get(item);}
function allItems(value){if(!value||typeof value!=='object')return[];return[value,...Object.values(value).flatMap(allItems)];}
test('original ore-trade toolbar entry survives capability filtering, with a native icon/title and initially closed window',()=>{
 const commands=require('../game/init').buildInit(w);for(const c of commands)assert.equal(codec.decode(codec.encode(c)).rest,0);
 const buttons=allItems(commands).filter(i=>i._==='WindowItemCommand'&&i.itemId==='ore_trade');assert.equal(buttons.length,1);assert.equal(buttons[0].visible,true);assert.equal(buttons[0].maximized,false);assert.equal(buttons[0].windowTitle,'title_trade');
 const root=path.resolve(__dirname,'..');assert.match(fs.readFileSync(path.join(root,'client/spacemap/graphics/ui/featuresMenu_atlasXml.xml'),'utf8'),/ore_trade_normal/);
 const gui=fs.readFileSync(path.join(root,'decompiled/main/scripts/net/bigpoint/darkorbit/gui/GuiManager.as'),'utf8');assert.match(gui,/this\.createTradeWindow\(\)/);assert.match(gui,/onTradeWindowMaximizeClicked[\s\S]*?new TradeRequest/);
});
test('station needs no module: all Seprom is advertised, 750-credit price enables native stepper, sale debits only chosen amount',()=>{
 Object.assign(p,maps.station(w));assert.equal(cpu.tradeAvailable(p),false);assert.equal(ask(),true);
 assert.equal(out.find(c=>c._==='AttributeOreCountUpdateCommand').oreCountList.find(o=>o.oreType.typeValue===7).count,91234);
 assert.equal(out.find(c=>c._==='OreTradeInfoCommand').sepromPrice,750);const credits=p.credits;assert.equal(handlers.get('TradeSellOreRequest')(s,req()),true);assert.equal(ore(),90000);assert.equal(p.credits,credits+1234*750);assert.equal(players.loadPlayer(id).credits,p.credits);
 assert.throws(()=>handlers.get('TradeSellOreRequest')(s,req(91234)),/Yetersiz/);assert.equal(ore(),90000);
 const native=fs.readFileSync(path.resolve(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit/gui/elements/OreTradeModule.as'),'utf8');assert.match(native,/if\(this\.orePrice > 0 \|\| this\.displayRatioMode\)[\s\S]*?setOreAmount/);
});
test('far station, death, jumping and inactive sessions cannot open or sell remotely without HM7',()=>{
 Object.assign(p,{x:12000,y:7000});assert.equal(ask(),false);assert.equal(out.some(c=>c._==='OreTradeInfoCommand'),false);assert.ok(out.some(c=>c.message?.includes('ticaret istasyonuna')));assert.equal(handlers.get('TradeSellOreRequest')(s,req()),false);
 Object.assign(p,maps.station(w));out.length=0;s.jumping=true;assert.equal(ask(),false);assert.equal(handlers.get('TradeSellOreRequest')(s,req()),false);s.jumping=false;p.dead=true;assert.equal(ask(),false);p.dead=false;const old=s.player;s.player=null;assert.equal(ask(),false);s.player=old;assert.equal(out.length,0);assert.equal(ore(),91234);
});
test('HM7 remote Seprom sale shares price and consumes exactly one charge, never a charge for opening',()=>{
 Object.assign(p,{x:12000,y:7000});const item=equip(cpu.TRADE),charges=cpu.charges(item),credits=p.credits;assert.equal(ask(),true);assert.equal(cpu.charges(item),charges);assert.ok(out.some(c=>c._==='OreTradeInfoCommand'&&c.type===2&&c.sepromPrice===750));
 assert.equal(handlers.get('TradeSellOreRequest')(s,req()),true);assert.equal(ore(),90000);assert.equal(p.credits,credits+1234*750);assert.equal(cpu.charges(item),charges-1);
});
test('PET trade advertises and pays the same Seprom base price with the owned gear bonus',()=>{
 database.tx(d=>{pet.addOwned(d,id);pet.addFuel(d,id,100);});equip('equipment_petgear_g-tra1','pet','gears');pet.launch(w);pet.selectGear(w,8);assert.ok(out.some(c=>c._==='OreTradeInfoCommand'&&c.type===3&&c.sepromPrice===788));
 const credits=p.credits;assert.equal(handlers.get('TradeSellOreRequest')(s,req()),true);assert.equal(ore(),90000);assert.equal(p.credits,credits+Math.round(1234*750*1.05));
});
test('failed Seprom sale leaves ore and credits intact; station opening clears stale remote context',()=>{
 Object.assign(p,maps.station(w));s.cpuTradeItem=9999;ask();assert.equal(s.cpuTradeItem,undefined);const credits=p.credits;db.exec("CREATE TRIGGER fail_trade BEFORE UPDATE OF credits ON players BEGIN SELECT RAISE(ABORT,'trade-storage');END");assert.throws(()=>handlers.get('TradeSellOreRequest')(s,req()),/trade-storage/);assert.equal(p.credits,credits);assert.equal(ore(),91234);db.exec('DROP TRIGGER fail_trade');
});
