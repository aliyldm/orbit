'use strict';
const assert=require('node:assert/strict');
async function verify({world,a,frame,db,post,base,cookie,timeout}){
 const p=world.player,cpu=require('../game/cpu');
 function assertCloaked(commands){assert.ok(commands.some(c=>c._==='ShipInitializationCommand'&&c.cloaked));assert.ok(commands.some(c=>c._==='LegacyModule'&&c.message===`0|n|INV|${p.userId}|1`));assert.ok(!commands.some(c=>c._==='LegacyModule'&&c.message===`0|n|INV|${p.userId}|0`));assert.equal(p.cloaked,true);assert.equal(cpu.charges(cloak),9);}
 // Only this in-memory QA account receives fixture funds.
 p.uridium=10000000;p.credits=10000000;p.dead=false;p.hitPoints=p.hitMax;p.lastCombat=0;
 db.prepare('UPDATE players SET uridium=?,credits=? WHERE id=?').run(p.uridium,p.credits,p.userId);
 world.stopMovement();for(const s of world.sessions)s.attacking=null;for(const n of world.npcs.values())n.aggro=null;
 const paymentPage=await fetch(base+'/indexInternal.es?action=internalPayment',{headers:{cookie}});assert.equal(paymentPage.status,200);const nativePaymentHtml=await paymentPage.text();assert.ok(/Shop\.Parameters\s*=/.test(nativePaymentHtml)&&/category\s*:\s*'special'/.test(nativePaymentHtml)&&nativePaymentHtml.includes('1000000'),'Payment uses original Specials shop and live fixed-price product rows');
 async function buyEquip(id){const before=p.uridium,expected=require('../game/economy').offers(p.userId)[id];const result=await post('/ajax/shop.php',{action:'purchase',itemId:id,amount:'1'});assert.equal(result.result,'success',id);if(expected.localPayment)assert.equal(p.uridium,before-1000000);assert.equal((await post('/ajax/shop.php',{action:'equipItems',itemId:id,amount:'1'})).result,'success',id);return db.prepare('SELECT * FROM items WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(p.userId,id);}
 await buyEquip('equipment_extra_cpu_sle-04');
 const hm=await buyEquip('equipment_extra_hmd-07');
 const jp=await buyEquip('equipment_extra_cpu_jp-01');
 await buyEquip('equipment_extra_cpu_ajp-01');
 const cloak=await buyEquip('equipment_extra_cpu_cl04k-m');
 // First native TradeRequest must open the charged remote trading CPU window.
 Object.assign(p,{x:6000,y:6000,lastCombat:0});
 const tradeMark=a.commands.length;a.socket.write(frame({_:'MenuActionRequest',menuItemId:'equipment_extra_hmd-07',actionType:1}));
 await a.until(cs=>cs.slice(tradeMark).some(c=>c._==='OreTradeInfoCommand'&&c.type===2&&c.remainingCharges===100));
 db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,0,10) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=amount+10').run(p.userId);
 const money=p.credits,sellMark=a.commands.length;a.socket.write(frame({_:'TradeSellOreRequest',toSell:{_:'OreCountModule',oreType:{_:'OreTypeModule',typeValue:0},count:10}}));
 await a.until(cs=>cs.slice(sellMark).some(c=>c._==='CPUInfoTradeDroneCommand'&&c.chargesLeft===99));assert.equal(cpu.charges(hm),99);assert.equal(p.credits,money+100);
 a.socket.write(frame({_:'LegacyModule',message:'TWC'}));
 const cloakMark=a.commands.length;a.socket.write(frame({_:'ActivationRequest',activationTypeValue:5}));await a.until(cs=>cs.slice(cloakMark).some(c=>c._==='LegacyModule'&&c.message===`0|n|INV|${p.userId}|1`));assert.equal(cpu.charges(cloak),9);assert.equal(p.cloaked,true);
 // Actual request -> materializer NanoHull -> native current-HP update.
 const random=Math.random,nanoMark=a.commands.length;
 try{Math.random=()=>.30;a.socket.write(frame({_:'GalaxyGateBuilderMultiEnergyRequest',gateId:2,spinAmount:1,useMultiplier:false}));await a.until(cs=>cs.slice(nanoMark).some(c=>c._==='GalaxyGateBuilderMultiEnergyCommand'&&c.items.some(r=>r.type===7)));}
 finally{Math.random=random;}
 assert.ok(p.nanoHull>=2000);assert.ok(a.commands.slice(nanoMark).some(c=>c._==='HitpointInfoCommand'&&c.nanoHull>=2000));
 const beforeNano=p.nanoHull,beforeHp=p.hitPoints;world.combat.damagePlayer({id:999999,def:{name:'QA'}},100,{evade:false});assert.equal(p.nanoHull,beforeNano-100);assert.equal(p.hitPoints,beforeHp);p.lastCombat=0;
 // Start the original ten-second cast at a safe base position.
 Object.assign(p,{x:2000,y:2000});const listMark=a.commands.length;a.socket.write(frame({_:'LegacyModule',message:'JCPU|GET'}));await a.until(cs=>cs.slice(listMark).some(c=>c._==='LegacyModule'&&c.message.startsWith('0|A|JCPU|I|')));
 const selectMark=a.commands.length;a.socket.write(frame({_:'LegacyModule',message:'JCPU|S|2'}));await a.until(cs=>cs.slice(selectMark).some(c=>c._==='LegacyModule'&&c.message.startsWith('0|A|JCPU|C|2|')));
 const cost=require('../game/jump-cpu').price(p,2),balance=p.uridium,jumpMark=a.commands.length;a.socket.write(frame({_:'LegacyModule',message:'JCPU|J'}));
 await a.until(cs=>p.mapId===2&&cs.slice(jumpMark).some(c=>c._==='LegacyModule'&&c.message===`0|n|INV|${p.userId}|1`),15000);assertCloaked(a.commands.slice(jumpMark));assert.equal(p.uridium,balance-cost);assert.equal(p.nanoHull,beforeNano-100);assert.ok(cpu.read(p).jumpUntil>Date.now());
 const homeMark=a.commands.length;a.socket.write(frame({_:'ActivationRequest',activationTypeValue:9}));await a.until(cs=>cs.slice(homeMark).some(c=>c._==='LegacyModule'&&c.message.includes('jump_cpu_failed_attack')));assert.equal(p.mapId,2);assert.equal(cpu.charges(jp),10);
 // Remove cooldown only inside the isolated test fixture to verify the next path.
 cpu.write(p,{...cpu.read(p),jumpUntil:0});p.lastCombat=0;const returnMark=a.commands.length;a.socket.write(frame({_:'ActivationRequest',activationTypeValue:9}));await a.until(cs=>p.mapId===1&&cs.slice(returnMark).some(c=>c._==='LegacyModule'&&c.message===`0|n|INV|${p.userId}|1`));assertCloaked(a.commands.slice(returnMark));assert.equal(cpu.charges(jp),9);
 assert.equal(db.prepare('SELECT nano_hull FROM ships WHERE id=?').get(p.shipId).nano_hull,p.nanoHull);
 await timeout(5);
}
module.exports={verify};
