'use strict';
const assert=require('node:assert/strict');
async function verify({world,a,frame,db,post,base,cookie}){
 const p=world.player,events=require('../game/payment-events'),pet=require('../game/pet');
 const endpoint=base+'/indexInternal.es?action=internalPaymentEvents';
 const page=await fetch(endpoint,{headers:{cookie}});assert.equal(page.status,200);assert.match(await page.text(),/Yerel Sezon/);
 let money=p.uridium;
 const bought=await post('/ajax/shop.php',{action:'purchase',itemId:'package_event-deal-goldpass-premium',amount:'1'});
 assert.equal(bought.result,'success');assert.equal(p.uridium,money-1000000);
 async function action(fields){const response=await fetch(endpoint,{method:'POST',headers:{cookie},body:new URLSearchParams(fields)});const html=await response.text();assert.equal(response.status,200,html.slice(0,200));return html;}
 let mark=a.commands.length;
 await action({subaction:'activate',pass:'gold'});await a.until(cs=>cs.slice(mark).some(c=>c._==='SeasonPassStatusCommand'&&c.goldPass));
 assert.equal(events.account(db,p.userId).gold,1);assert.equal(require('../game/loot-rewards').count(db,p.userId,'resource_gold-pass'),0);
 mark=a.commands.length;await action({subaction:'points',amount:'100'});await a.until(cs=>cs.slice(mark).some(c=>c._==='SeasonPointsInfoCommand'&&c.points>=100));
 assert.equal(require('../game/loot-rewards').count(db,p.userId,'resource_season-pass-point'),500);
 const loot='ammunition_laser_mcb-50',before=require('../game/ammo').count(p,loot);
 const claim={_:'SeasonPassRewardClaimRequest',level:0,goldPass:false,extGoldPass:false};
 mark=a.commands.length;a.socket.write(frame(claim));await a.until(cs=>cs.slice(mark).some(c=>c._==='SeasonPassRewardClaimCommand'&&c.level===0&&c.claimed));
 assert.equal(require('../game/ammo').count(p,loot),before+2000);
 mark=a.commands.length;a.socket.write(frame(claim));await a.until(cs=>cs.slice(mark).some(c=>c._==='SeasonPassRewardClaimCommand'&&c.level===0&&c.claimed));assert.equal(require('../game/ammo').count(p,loot),before+2000);
 money=p.uridium;const points=events.account(db,p.userId).season_points;mark=a.commands.length;
 a.socket.write(frame({_:'SeasonPassLevelPurchaseRequest',amount:1}));await a.until(cs=>cs.slice(mark).some(c=>c._==='SeasonPointsInfoCommand'&&c.points===points+100));assert.equal(p.uridium,money-10000);
 // Genuine shop purchase -> native hangar drag -> live model, using the current
 // in-memory QA player. No production items or balances are touched.
 const purchased=await post('/ajax/shop.php',{action:'purchase',itemId:'package_pd-c-01',amount:'1'});assert.equal(purchased.result,'success');
 const item=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='pet_designs_chimera-green' ORDER BY id DESC LIMIT 1").get(p.userId);
 assert.ok(world.petRuntime?.active,'the preceding map tests resume the active PET');
 const fuel=world.petRuntime.fuel,hp=world.petRuntime.hitpoints;mark=a.commands.length;
 a.socket.write(frame({_:'HangarShipMoveItemsRequest',items:[item.id],source:'inventory',destination:'pet',hangarId:p.shipId,droneId:0,index:0,configId:require('../game/inventory').activeConfig(db,p.shipId),slotSet:'visual'}));
 await a.until(cs=>cs.slice(mark).some(c=>c._==='HangarShipMoveItemsCommand'&&c.result===1)&&cs.slice(mark).some(c=>c._==='PetHeroActivationCommand'&&c.shipType===163));
 assert.equal(pet.appearance(p).type,163);assert.equal(world.petRuntime.hitpoints,hp);assert.ok(world.petRuntime.fuel<=fuel);
 assert.equal(db.prepare('SELECT COUNT(*) n FROM payment_event_claims WHERE player_id=? AND track=? AND level=1').get(p.userId,'free').n,1);
}
module.exports={verify};
