'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),pet=require('../game/pet'),progress=require('../game/pet-progression'),economy=require('../game/economy'),api=require('../web/inventory-api');
let db,id,p;const previous=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;id=players.createPlayer(players.createAccount('pet-purchase','testpass'),'QA',1,{...require('../config').starter,uridium:3000000});pet.addOwned(db,id);p=players.loadPlayer(id);});
afterEach(()=>{World.current=previous;database.close();});
test('HP levels are purchased in order at official costs, capped by experience level and do not heal',()=>{
 const before=pet.owned(id).hitpoints;assert.equal(economy.offers(id)['pet_hp-upgrade-1'].price,5000);
 assert.equal(economy.purchase(id,'pet_hp-upgrade-1',2).result,'error');assert.equal(economy.purchase(id,'pet_hp-upgrade-2',1).result,'error');
 const purchase=economy.purchase(id,'pet_hp-upgrade-1',1);assert.equal(purchase.result,'success');assert.equal(purchase.userBalance.uridium,2995000);assert.equal(pet.stats(p).hitMax,60000);assert.equal(pet.owned(id).hitpoints,before);
 assert.equal(players.loadPlayer(id).uridium,2995000);assert.equal(economy.purchase(id,'pet_hp-upgrade-1',1).result,'error');assert.equal(progress.hpOffer(id),null);
 db.prepare('UPDATE pets SET level=20 WHERE player_id=?').run(id);
 for(let n=2;n<=20;n++){assert.equal(progress.hpOffer(id).price,Math.min(50000,n*5000));assert.equal(economy.purchase(id,'pet_hp-upgrade-'+n,1).result,'success');}
 assert.equal(pet.stats(p).hitMax,250000);assert.equal(progress.hpOffer(id),null);
});
test('slot purchase uses owned PET level and server price, persists and changes native locked slots',()=>{
 assert.throws(()=>progress.unlock(id,{target:'pet',slotset:'lasers',slotPrice:19000}),/seviye/);
 db.prepare('UPDATE pets SET level=20 WHERE player_id=?').run(id);
 const portal=()=>pet.decoratePortal(id,{data:{ret:{items:[],itemInfo:[],hangars:[]},map:{lootIds:[],types:[]}}}).data.ret;
 let v=portal();assert.equal(v.pet.lockedSlots.lasers,6);assert.equal(v.itemInfo[0].levels[20].slotsets.lasers.Q,12);assert.equal(v.itemInfo[0].costWeaponSlot[6],19000);
 assert.throws(()=>progress.unlock(id,{target:'pet',slotset:'lasers',slotPrice:1}),/fiyat/);assert.equal(players.loadPlayer(id).uridium,3000000);
 const raw=Buffer.from(JSON.stringify({target:'pet',slotset:'lasers',slotPrice:19000})).toString('base64');
 const result=JSON.parse(Buffer.from(api.handle(id,new URLSearchParams({action:'unlockSlot',params:raw})).body,'base64'));
 assert.equal(result.isError,0);assert.equal(result.data.ret,1);assert.equal(progress.unlocked(id).laser,7);assert.equal(players.loadPlayer(id).uridium,2981000);
 assert.equal(portal().pet.lockedSlots.lasers,5);assert.equal(pet.view(id).lasers,7);
 for(let n=8;n<=12;n++)progress.unlock(id,{target:'pet',slotset:'lasers',slotPrice:progress.price('laser',n)});
 assert.equal(portal().pet.lockedSlots.lasers,0);assert.throws(()=>progress.unlock(id,{target:'pet',slotset:'lasers'}),/bütün/);
});
test('no balance or slot state changes on SQL failure and unaffordable upgrades',()=>{
 db.prepare('UPDATE pets SET level=20 WHERE player_id=?').run(id);
 db.exec("CREATE TRIGGER pet_slot_fail BEFORE INSERT ON settings BEGIN SELECT RAISE(ABORT,'slot rollback'); END");
 assert.throws(()=>progress.unlock(id,{target:'pet',slotset:'lasers'}),/rollback/);assert.equal(players.loadPlayer(id).uridium,3000000);assert.equal(progress.unlocked(id).laser,6);db.exec('DROP TRIGGER pet_slot_fail');
 db.prepare('UPDATE players SET uridium=100 WHERE id=?').run(id);assert.equal(economy.purchase(id,'pet_hp-upgrade-1',1).result,'error');assert.equal(pet.owned(id).hp_upgrade_level,0);assert.equal(players.loadPlayer(id).uridium,100);
});
test('HP shop product reuses the original themed PET grid and exposes the next exact step',()=>{
 const html=require('../web/portal/render').renderPage('internalDock','internalDockPetGear',p),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(html)[1]);
 assert.ok(rows['pet_hp-upgrade-1']);assert.equal(rows['pet_hp-upgrade-1'].price,5000);assert.equal(rows['pet_hp-upgrade-1'].isLevelSetable,false);assert.match(html,/<a id="pet_hp-upgrade-1"/);assert.match(html,/>HP \+10\.000<\/div>/);
});
test('live PET cap and wallet update immediately while preserving current HP',()=>{
 const w=new World(require('../config')),session={world:w,send(){}};w.login(session,id);World.current=()=>w;w.petSend=()=>{};pet.addFuel(db,id,1000);pet.launch(w);w.petRuntime.hitpoints=12345;
 assert.equal(economy.purchase(id,'pet_hp-upgrade-1',1).result,'success');assert.equal(w.player.uridium,2995000);assert.equal(w.petRuntime.stats.hitMax,60000);assert.equal(w.petRuntime.hitpoints,12345);w.removeSession(session);assert.equal(players.loadPlayer(id).uridium,2995000);
});

