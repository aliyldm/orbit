'use strict';
// Satın alma ve ekipman takma. Portal (/ajax/shop.php) ve ileride oyun içi istekler kullanır.
// Fiyatlar canlı dükkan sayfalarından (web/portal/shop.json): currency "virtual" = kredi, "real" = uridyum.
// Oyuncu oyundaysa bellekteki kopya (World) güncellenir ki kayıtlar çakışmasın.

const fs = require('fs');
const path = require('path');
const { open, tx } = require('./db');
const inventory = require('./inventory');
const players = require('./db/players');
const World = require('./world');
const META = require('../docs/client-map.items.json').items;
const modulePolicy=require('./module-policy');
modulePolicy.registerMetadata(META);

const SHOP_FILE = path.join(__dirname, '..', 'web', 'portal', 'shop.json');
const STACKABLE = new Set(['ammo_laser', 'ammo_rocket', 'booster']);

function shop(playerId) {
  const offers=JSON.parse(fs.readFileSync(SHOP_FILE,'utf8'));
  Object.assign(offers,require('./pet-shop').offers());
  const hpOffer=require('./pet-progression').hpOffer(playerId);if(hpOffer)offers[hpOffer.id]=hpOffer;
  for(const [id,m]of Object.entries(META))if(m.kind==='Drone')offers[id]={name:m.typeValue,category:'drone',price:require('./drones').purchasePrice(playerId?open():null,playerId,id),currency:m.uridium?'real':'virtual',isPaymentItem:false};
  for(const [id,m]of Object.entries(META))if(m.kind==='Booster'&&offers[String(m.boosterId)])offers[id]={...offers[String(m.boosterId)]};
  offers['resource_pet-fuel']={name:'P.E.T. Yakıtı',category:'pet',price:META['resource_pet-fuel'].uridium,currency:'real',isPaymentItem:false};
  offers['resource_ore_seprom']={name:'Seprom',category:'extras',price:1,currency:'real',isPaymentItem:false};
  Object.assign(offers,modulePolicy.offers());
  // Local Uridium offers use embedded catalogue prices. Historical red/blue
  // payment/event availability is NOT inferred from those metadata numbers.
  for(const [id,name]of [['resource_booty-key-red','Kırmızı ganimet anahtarı'],['resource_booty-key-blue','Mavi ganimet anahtarı']])offers[id]={name,category:'extras',price:META[id].uridium,currency:'real',isPaymentItem:false};
  return require('./shop-product-audit').decorateOffers(require('./equipment-policy').filterOffers(Object.assign(require('./payment').applyOffers(offers),require('./ship-shop').offers(),require('./laser-shop').offers(),require('./ship-modules').offers())));
}

// Oyundaki kopya varsa onu, yoksa DB'den yüklenmiş oyuncuyu verir.
function playerFor(playerId) {
  const world = World.current();
  const live = world && world.livePlayer(playerId);
  const p = live || players.loadPlayer(playerId);
  return { p, live: !!live, world };
}

function balance(p) { return { uridium: Number(p.uridium), credits: Math.floor(p.credits) }; }

const freeSlots = inventory.freeSlots;

function validAmount(value) {
  return (typeof value === 'number' || (typeof value === 'string' && /^\d+$/.test(value))) && Number.isSafeInteger(Number(value)) && Number(value) > 0 && Number(value) <= 10000000;
}

function purchase(playerId, itemId, amount, category, level) {
  if (amount === undefined) amount = 1;
  if (!validAmount(amount)) return { result: 'error', message: 'Geçersiz miktar.' };
  amount = Number(amount);
  if(require('./pet-progression').hpLevel(itemId)!==null)return require('./pet-progression').buyHp(playerId,itemId,amount);
  // The captured drone and booster pages both use numeric SKU 1/2. Their
  // category disambiguates legacy requests; new browser requests use loot IDs.
  if(category==='drone')itemId=({'1':'drone_flax','2':'drone_iris'})[itemId]||itemId;
  const offer = shop(playerId)[itemId];
  if (!offer) return { result: 'error', message: 'Bu ürün local dükkanda yok.' };
  const unavailable=require('./shop-product-audit').purchaseReason(itemId,offer);
  if(unavailable)return {result:'error',message:unavailable};
  if(offer.localPayment)return purchasePayment(playerId,itemId,amount,offer);
  let petQuote;
  try{petQuote=require('./pet-shop').quote(playerId,itemId,level,open());}catch(error){return {result:'error',message:error.message};}
  if(petQuote){offer.price=petQuote.price;offer.currency=petQuote.currency;}
  if(META[itemId]?.typeClass?.includes('.pet.')&&itemId!=='pet_pet10'&&!petQuote)return {result:'error',message:'Bu P.E.T. modülü henüz desteklenmiyor.'};
  if (offer.isPaymentItem) return { result: 'error', message: 'Gerçek para ile satılan paketler local sunucuda yok.' };
  // Portal booster SKUs are numeric BoosterAttributes.boosterId values; socket
  // and persistence use the corresponding canonical lootId from the same client.
  if(offer.category==='booster'&&!META[itemId])itemId=Object.keys(META).find(id=>META[id].kind==='Booster'&&String(META[id].boosterId)===String(itemId))||itemId;
  const type = open().prepare('SELECT * FROM item_types WHERE loot_id = ?').get(itemId);
  const shipType = !type && open().prepare('SELECT * FROM ship_types WHERE loot_id = ?').get(itemId);
  const droneType = META[itemId]?.kind==='Drone';
  const boosterType=META[itemId]?.kind==='Booster';
  const designType=META[itemId]?.typeClass?.endsWith('.ShipDesignType');
  const isStackable=!!META[itemId]?.stackable || STACKABLE.has(type?.category);
  if (!type && !shipType && !designType && !droneType && !boosterType) return { result: 'error', message: 'Ürün katalogda bulunamadı.' };
  if(boosterType){const reason=require('./boosters').unsupportedReason(itemId);if(reason)return {result:'error',message:reason};}
  if (shipType && amount !== 1) return { result: 'error', message: 'Gemiler tek tek satın alınabilir.' };
  if (droneType && amount!==1)return {result:'error',message:'Diroitler tek tek satın alınabilir.'};
  if (designType && amount!==1)return {result:'error',message:'Gemi tasarımları tek tek satın alınabilir.'};
  if (type && !isStackable && amount > 1000) return { result: 'error', message: 'Tek işlemde en fazla 1000 ekipman alınabilir.' };

  const { p, live } = playerFor(playerId);
  if (!p) return { result: 'error', message: 'Oyuncu bulunamadı.' };
  const currency = offer.currency === 'real' ? 'uridium' : 'credits';
  let cost = offer.price * amount;
  if (!Number.isFinite(cost) || cost < 0 || cost>Number.MAX_SAFE_INTEGER) return { result: 'error', message: 'Geçersiz ürün fiyatı.' };
  if (p[currency] < cost) {
    return { result: 'error', message: currency === 'uridium' ? 'Yeterli uridyumun yok.' : 'Yeterli kredin yok.', userBalance: balance(p) };
  }

  try { tx(db => {
    if(droneType)cost=require('./drones').purchasePrice(db,playerId,itemId)*amount;
    // Live rewards may be newer than the last world save. Snapshot both balances
    // inside this transaction, debit and insert together, update memory after commit.
    if (live) db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits,p.uridium,playerId);
    const debited = db.prepare(`UPDATE players SET ${currency}=${currency}-? WHERE id=? AND ${currency}>=?`).run(cost,playerId,cost);
    if (!debited.changes) throw new Error('Bakiye yetersiz.');
    if(modulePolicy.DEFINITIONS.some(d=>d.id===itemId)){
      const stock=db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,itemId).n;
      if(stock+amount>1000000000)throw Error('Modül stok sınırı aşıldı.');
    }
    if(!droneType&&type&&META[itemId]?.maxQuantity>0) {
      const owned=db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,itemId).n;
      if(owned+amount>META[itemId].maxQuantity)throw new Error('Azami eşya sayısına ulaştın.');
    }
    if(itemId==='pet_pet10')require('./pet').addOwned(db,playerId,amount);
    else if(itemId==='resource_pet-fuel')require('./pet').addFuel(db,playerId,amount);
    else if(itemId==='resource_ore_seprom'){
      const stored=db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=7').get(playerId)?.amount||0;
      if(stored+amount>Math.min(2147483647,META[itemId].stackable.maxQuantity))throw Error('Seprom stok sınırı aşıldı.');
      db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,7,?) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=amount+excluded.amount').run(playerId,amount);
    }
    else if(designType)inventory.addDesign(db,playerId,itemId);
    else if(droneType){
      // Drone ownership references the same genuine client catalogue as equipment,
      // including databases seeded before Drone kinds were imported.
      const m=META[itemId];
      db.prepare('INSERT OR IGNORE INTO item_types(loot_id,name,category,price_credits,price_uridium)VALUES(?,?,?,?,?)').run(itemId,m.typeValue,'drone',m.credits||0,m.uridium||0);
      require('./drones').addOwned(db,playerId,itemId);
    }
    else if(boosterType){
      const m=META[itemId];
      db.prepare('INSERT OR IGNORE INTO item_types(loot_id,name,category,price_credits,price_uridium)VALUES(?,?,?,?,?)').run(itemId,m.typeValue,'booster',m.credits||0,m.uridium||0);
      require('./boosters').addOwned(db,playerId,itemId,amount);
    }
    else if (shipType) {
      db.prepare('INSERT INTO ships (player_id, loot_id, hitpoints) VALUES (?, ?, ?)').run(playerId, itemId, shipType.hitpoints);
    } else if (isStackable) {
      const row = db.prepare('SELECT id FROM items WHERE player_id = ? AND loot_id = ? AND ship_id IS NULL').get(playerId, itemId);
      if (row) db.prepare('UPDATE items SET amount = amount + ? WHERE id = ?').run(amount, row.id);
      else db.prepare('INSERT INTO items (player_id, loot_id, amount) VALUES (?, ?, ?)').run(playerId, itemId, amount);
    } else {
      const ins = db.prepare('INSERT INTO items (player_id, loot_id, amount, pet_level) VALUES (?, ?, 1, ?)');
      for (let i = 0; i < amount; i++) ins.run(playerId, itemId,petQuote?.level||1);
    }
  }); } catch (e) {
    return { result: 'error', message: 'Satın alma kaydedilemedi.', userBalance: balance(p) };
  }
  p[currency] -= cost;
  if(live) {
    const {sendCmd}=require('./net');
    const world=World.current();
    world.broadcast(s=>sendCmd(s,{_: 'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0}));
    require('./ammo').notify(p);
    if(/^resource_booty-key(?:-red|-blue)?$/.test(itemId))require('./booty').notify(world,sendCmd);
    if(itemId==='pet_pet10'||itemId==='resource_pet-fuel')require('./pet').purchased(world,itemId);
    if(itemId==='resource_ore_seprom')world.broadcast(s=>{for(const c of require('./collectables').resourceCommands(p))sendCmd(s,c);});
    require('./cpu').purchased(world,itemId);
    require('./assembly').refreshInventory(world,sendCmd);
    if(boosterType)require('./boosters').purchased(world);
    if(droneType||META[itemId]?.kind==='DroneFormation') {
      const cmds=require('./drones').buildCommands(p);
      world.broadcast(s=>{for(const c of cmds)sendCmd(s,c);sendCmd(s,require('./handlers/core').menu(p));});
    }
  }

  const slot = type && inventory.slotFor(type);
  const ownedPet=['pet_pet10','resource_pet-fuel'].includes(itemId)?require('./pet').owned(playerId):null;
  return {
    result: 'success',
    message: shipType ? `${offer.name} hangarına eklendi.` : droneType ? `${offer.name} diroiti satın alındı.` : `${amount} x ${offer.name} satın alındı.`,
    userBalance: balance(p),
    ...(itemId==='resource_pet-fuel'?{petFuel:ownedPet.fuel}:{}),
    ...(ownedPet?{userPet:{level:ownedPet.level,fuel:ownedPet.fuel,maxFuel:require('./pet').MAX_FUEL}}:{}),
    itemId,
    ...(droneType?{updatedPrice:require('./drones').purchasePrice(open(),playerId,itemId),dronePrices:require('./drones').shopState(open(),playerId)}:{}),
    showEquipOption: !!slot && freeSlots(open(), p.shipId, slot, inventory.activeConfig(open(),p.shipId)).length > 0
  };
}

function purchasePayment(playerId,itemId,amount,offer){
  const payment=require('./payment'),record=payment.entry(offer.paymentSku),db=open();
  if(amount>payment.maxAmount(record))return {result:'error',message:'Bu ürün için geçersiz satın alma miktarı.'};
  const why=payment.purchaseReason(record,db,playerId);if(why)return {result:'error',message:why};
  const delivery=payment.multiply(record,amount),cost=payment.PRICE*amount;
  const invalid=payment.reason(delivery,db);if(invalid)return {result:'error',message:invalid};
  const {p,live,world}=playerFor(playerId);if(!p)return {result:'error',message:'Oyuncu bulunamadı.'};
  if(p.uridium<cost)return {result:'error',message:'Yeterli uridyumun yok.',userBalance:balance(p)};
  let updated;
  try{updated=tx(conn=>{
    if(record.contents.once){
      if(!conn.prepare('INSERT OR IGNORE INTO payment_purchase_receipts(player_id,sku,purchased_at)VALUES(?,?,?)').run(playerId,record.sku,Date.now()).changes)throw Error('Bu paket hesap başına yalnızca bir kez satın alınabilir.');
    }
    if(live)conn.prepare('UPDATE players SET credits=?,uridium=?,ep=?,level=? WHERE id=?').run(p.credits,p.uridium,p.ep,p.level,playerId);
    if(!conn.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(cost,playerId,cost).changes)throw Error('Yeterli uridyumun yok.');
    payment.fulfil(conn,playerId,delivery);
    return conn.prepare('SELECT credits,uridium,ep,level FROM players WHERE id=?').get(playerId);
  });}catch(error){return {result:'error',message:`Satın alma kaydedilemedi: ${error.message}`,userBalance:balance(p)};}
  Object.assign(p,updated);
  if(live){
    const {sendCmd}=require('./net');
    world.broadcast(s=>sendCmd(s,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0}));
    require('./ammo').notify(p);
    if(Object.keys(record.contents.items||{}).some(id=>/^resource_booty-key(?:-red|-blue)?$/.test(id)))require('./booty').notify(world,sendCmd);
    if(Object.keys(record.contents.items||{}).some(id=>META[id]?.kind==='Booster')||Object.keys(record.contents.boosterHours||{}).length)require('./boosters').purchased(world);
    if(record.contents.items?.pet_pet10||record.contents.items?.['resource_pet-fuel'])require('./pet').purchased(world,record.contents.items.pet_pet10?'pet_pet10':'resource_pet-fuel');
    if(Object.keys(record.contents.items||{}).some(id=>META[id]?.kind==='Drone')){const cmds=require('./drones').buildCommands(p);world.broadcast(s=>{for(const c of cmds)sendCmd(s,c);});}
    world.broadcast(s=>sendCmd(s,inventory.buildInit(p)));
    require('./assembly').refreshInventory(world,sendCmd);
  }
  return {result:'success',message:`${amount} x ${offer.name} satın alındı.`,userBalance:balance(p),itemId,showEquipOption:false};
}

// Depodaki eşyaları aktif geminin boş yuvalarına takar; takılan sayıyı döndürür.
function equip(playerId, itemId, amount = 1) {
  if (!validAmount(amount)) return { result: 'error', message: 'Geçersiz miktar.' };
  const { p, live, world } = playerFor(playerId);
  if (!p) return { result: 'error', message: 'Oyuncu bulunamadı.' };
  const type = open().prepare('SELECT * FROM item_types WHERE loot_id = ?').get(itemId);
  const slot = type && inventory.slotFor(type);
  if (!slot) return { result: 'error', message: 'Bu eşya gemiye takılamaz.' };
  if(META[itemId]?.equipable?.entities&&!META[itemId].equipable.entities.includes('SHIP'))return {result:'error',message:'Bu eşya yalnızca P.E.T. veya diroit için kullanılabilir.'};
  if(slot==='cannon'){
    const t=require('./advanced-weapons').cannonType(itemId),eq=inventory.equipped(open(),p.shipId,inventory.activeConfig(open(),p.shipId));
    if(t<0||Number(amount)!==1||eq.some(i=>i.slot==='cannon'&&require('./advanced-weapons').cannonType(i.loot_id)===t))return {result:'error',message:'Her parçacık topu türünden yalnızca bir tane takılabilir.'};
  }
  const done = tx(db => {
    const config=inventory.activeConfig(db,p.shipId);
    const free = freeSlots(db, p.shipId, slot,config);
    const loose = db.prepare(`SELECT id FROM items i WHERE player_id = ? AND loot_id = ? AND amount=1
      AND (ship_id IS NULL OR (?=2 AND ship_id=?))
      AND NOT EXISTS(SELECT 1 FROM equipment_config2 e WHERE e.item_id=i.id AND (?=2 OR e.ship_id<>?))
      AND NOT EXISTS(SELECT 1 FROM drone_equipment d WHERE d.item_id=i.id AND (d.config_id=? OR d.ship_id<>?))
      AND NOT EXISTS(SELECT 1 FROM pet_equipment p WHERE p.item_id=i.id AND (p.config_id=? OR p.ship_id<>?)) ORDER BY id`).all(playerId,itemId,config,p.shipId,config,p.shipId,config,p.shipId,config,p.shipId);
    const n = Math.min(free.length, loose.length, Number(amount));
    const put = config===1 ? db.prepare('UPDATE items SET ship_id = ?, slot = ?, slot_index = ? WHERE id = ?')
      : db.prepare('INSERT INTO equipment_config2(ship_id,slot,slot_index,item_id) VALUES(?,?,?,?)');
    for (let i = 0; i < n; i++) put.run(p.shipId, slot, free[i], loose[i].id);
    return n;
  });
  if (live) world.refreshStats();
  if (!done) return { result: 'error', message: 'Boş yuva ya da takılacak eşya yok.', userBalance: balance(p) };
  return { result: 'success', message: `${done} eşya gemiye takıldı.`, userBalance: balance(p) };
}

// Takılı bir eşyayı depoya çıkarır.
function unequip(playerId, itemRowId) {
  const { live, world } = playerFor(playerId);
  const changed = tx(db => {
    const r=db.prepare('UPDATE items SET ship_id = NULL, slot = NULL, slot_index = NULL WHERE id = ? AND player_id = ? AND ship_id IS NOT NULL').run(itemRowId, playerId);
    const s=db.prepare('DELETE FROM equipment_config2 WHERE item_id=? AND item_id IN(SELECT id FROM items WHERE player_id=?)').run(itemRowId,playerId);
    const d=db.prepare('DELETE FROM drone_equipment WHERE item_id=? AND item_id IN(SELECT id FROM items WHERE player_id=?)').run(itemRowId,playerId);
    const pet=db.prepare('DELETE FROM pet_equipment WHERE item_id=? AND item_id IN(SELECT id FROM items WHERE player_id=?)').run(itemRowId,playerId);
    return r.changes+s.changes+d.changes+pet.changes;
  });
  if (live) world.refreshStats();
  return changed > 0;
}

module.exports = { purchase, equip, unequip, freeSlots, offers:shop };
