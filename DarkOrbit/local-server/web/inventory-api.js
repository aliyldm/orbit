'use strict';
// Portal hangarı (swf_global/inventory/inventory.swf) için flashAPI/inventory.php cevapları.
// İstek: POST action=<eylem>&params=<base64 JSON {params:{hangarId, lootId, ...}}>
// Cevap: base64 JSON {isError, data:{ret, money, map?}} (net/bigpoint/dataInterchange/InterchangeBroker.as).
// Kayıttaki cevaplar (web/portal/ajax.json) alan şablonu olarak kullanılır; gemi listesi ve
// gemi/ekipman durumu DB'den üretilir. Desteklenmeyen eylemler açık hata döndürür.

const fs = require('fs');
const path = require('path');
const { open } = require('../game/db');
const { computeStats } = require('../game/stats');
const World = require('../game/world');
const inventory = require('../game/inventory');
const metadata = require('../docs/client-map.items.json').items;

const AJAX_FILE = path.join(__dirname, 'portal', 'ajax.json');
const LIST_KEY = '/flashAPI/inventory.php|getHangarList';
const OWNED_DETAILS_KEY = '/flashAPI/inventory.php|getShipDetails|ship_liberator';
const SHOP_DETAILS_KEY = '/flashAPI/inventory.php|getShipDetails|ship_pusat-plus';

function recorded(key) {
  const hit = JSON.parse(fs.readFileSync(AJAX_FILE, 'utf8'))[key];
  return hit ? JSON.parse(Buffer.from(hit.body, 'base64').toString('utf8')) : null;
}

const encode = obj => Buffer.from(JSON.stringify(obj), 'utf8').toString('base64');
const ok = (ret, player) => ({ isError: 0, data: { ret, money: money(player) } });
const fail = message => ({ isError: 1, error: { message } });

function money(p) { return { uridium: String(Math.floor(p.uridium)), credits: String(Math.floor(p.credits)) }; }

function playerRow(playerId) {
  const db = open();
  const p = db.prepare('SELECT * FROM players WHERE id = ?').get(playerId);
  if (!p) throw new Error('Oyuncu bulunamadı.');
  // Oyundaysa güncel kredi/uridyum bellekteki kopyada.
  const live = World.current() && World.current().livePlayer(playerId);
  if (live) { p.credits = live.credits; p.uridium = live.uridium; }
  return p;
}

// Gemi türü için itemInfo girdisi (yuva sayıları ship_types'tan; yuva türleri kayıttaki Liberator'la aynı).
function shipItemInfo(type, index, template) {
  const info = JSON.parse(JSON.stringify(template));
  const lv = info.levels[0];
  info.L = index;
  info.name = type.name;
  lv.slotsets.lasers.Q = type.laser_slots;
  lv.slotsets.generators.Q = type.generator_slots;
  lv.slotsets.extras.Q = type.extra_slots;
  lv.slotsets.ship_upgrades={...(lv.slotsets.ship_upgrades||{}),Q:require('../game/ship-modules').capacity(type.loot_id),T:[12]};
  lv.selling = { credits: Math.floor((type.price_credits || type.price_uridium * 10) * 0.8) };
  delete lv.cdn; // resim karmaları isteğe bağlı (ItemInfoManager), yoksa sürümsüz yol kullanılır
  return info;
}

function getHangarList(playerId) {
  const db = open();
  const p = playerRow(playerId);
  const t = recorded(LIST_KEY);
  const ret = t.data.ret;
  const ships = db.prepare('SELECT * FROM ships WHERE player_id = ? ORDER BY id').all(playerId);
  const lootIds = [...new Set(ships.map(s => s.loot_id))];
  const types = Object.fromEntries(lootIds.map(l => [l, db.prepare('SELECT * FROM ship_types WHERE loot_id = ?').get(l)]));

  ret.hangars = ships.map(s => ({
    hangarID: String(s.id),
    hangar_is_active: s.id === p.active_ship_id,
    general: { ship: { I: s.id, HP: Math.min(1, s.hitpoints / types[s.loot_id].hitpoints), L: lootIds.indexOf(s.loot_id), SM: inventory.shipAppearance(db,s), M: inventory.availableDesigns(db,s) } },
    config: Object.fromEntries([1,2].map(c => {
      const eq=inventory.equipped(db,s.id,c);
      const EQ={lasers:[],generators:[],extras:[],heavy_guns:[],ship_upgrades:[]};
      for(const i of eq) (EQ[inventory.SLOTSET[i.slot]] ||= []).push(i.id);
      return [String(c),{ship:{EQ},drones:{},pet:null}];
    }))
  }));
  ret.itemInfo = lootIds.map((l, i) => shipItemInfo(types[l], i, ret.itemInfo[0]));
  for(const s of ships)for(const id of inventory.availableDesigns(db,s))if(!lootIds.includes(id)) {
    const m=metadata[id],baseInfo=ret.itemInfo[lootIds.indexOf(s.loot_id)],info=JSON.parse(JSON.stringify(baseInfo));
    info.L=lootIds.push(id)-1;info.name=m.typeValue;ret.itemInfo.push(info);
  }
  // ItemInfoManager resolves L through map.lootIds. Include every owned item,
  // including equipped rows, so ConfigManager can resolve every EQ item id.
  const items=inventory.rows(playerId).filter(i=>i.amount>0);
  for(const i of items) {
    if(lootIds.includes(i.loot_id)) continue;
    const L=lootIds.length;
    lootIds.push(i.loot_id);
    // InventoryViewMediator uppercases the context before GridComponent tests
    // EB. Preserve the native SHIP/DRONE/PET entities for the compact view.
    ret.itemInfo.push({L,name:i.name,T:inventory.groupOf(i),C:i.category,EB:metadata[i.loot_id]?.equipable?.entities||[],
      levels:require('../game/pet-catalog').DATA[i.loot_id]?.levels.map(v=>({selling:{credits:v.sellCredits}}))||Array.from({length:metadata[i.loot_id]?.upgradable?.levels||1},()=>metadata[i.loot_id]?.sellable?{selling:metadata[i.loot_id].sellable}:{})});
  }
  ret.items=items.map(i=>({I:i.id,L:lootIds.indexOf(i.loot_id),Q:i.amount,LV:require('../game/pet-catalog').resolve(i)?i.pet_level-1:i.upgrade_level||0,...require('../game/ship-modules').portalItem(i.loot_id),...require('../game/cpu-ammo').properties(playerId,i),
    ...(i.ship_id||i.second_ship_id?{EQH:i.ship_id||i.second_ship_id,EQC:i.ship_id&&i.second_ship_id?3:i.ship_id?1:2,EQT:'ship'}:{})}));

  // Dükkan listesi kayıttaki gibi; sahip olunan gemiler hangar kimliğiyle işaretlenir.
  // Aynı türden birden fazla gemi varsa fazlası listeye ayrı girdi olarak eklenir.
  const byLoot = new Map(ret.shipInfo.map(s => [s.lootId, s]));
  const extra = [];
  for (const s of ret.shipInfo) Object.assign(s, { owned: 0, hangarId: 0, fav: 0 });
  for (const s of ships) {
    let info = byLoot.get(s.loot_id);
    if (!info) {
      info = { lootId: s.loot_id, price: { uridium: types[s.loot_id].price_uridium, credits: types[s.loot_id].price_credits, isPayment: 0 }, factionBased: 0, eventItem: 0, eventActive: 0, remodel: 0 };
      byLoot.set(s.loot_id, info);
      extra.push(info);
    } else if (info.owned) {
      info = { ...info, price: { ...info.price } };
      extra.push(info);
    }
    Object.assign(info, { owned: 1, hangarId: String(s.id), fav: s.favorite ? 1 : 0 });
  }
  ret.shipInfo.push(...extra);
  require('../game/ship-shop').decorateHangar(ret);
  ret.userInfo = { factionRelated: ({ 1: 'mmo', 2: 'eic', 3: 'vru' })[p.faction_id] || 'mmo' };
  t.data.money = money(p);
  t.data.map.lootIds = lootIds;
  return require('../game/pet').decoratePortal(playerId,require('../game/drones').decoratePortal(playerId,t));
}

function countLoose(db, playerId, where) {
  return db.prepare(`SELECT COALESCE(SUM(i.amount), 0) AS n FROM items i JOIN item_types t ON t.loot_id = i.loot_id
    WHERE i.player_id = ? AND i.ship_id IS NULL AND ${where}`).get(playerId).n;
}

function getShipDetails(playerId, params) {
  const db = open();
  const p = playerRow(playerId);
  const hangarId = Number(params.hangarId || params.hi || 0);
  if (hangarId) {
    const ship = db.prepare('SELECT * FROM ships WHERE id = ? AND player_id = ?').get(hangarId, playerId);
    if (!ship) return fail('Gemi bulunamadı.');
    const type = db.prepare('SELECT * FROM ship_types WHERE loot_id = ?').get(ship.loot_id);
    const eq = inventory.statItems(db, ship.id,inventory.activeConfig(db,ship.id));
    const st = require('../game/ship-passives').applyStats(type.loot_id,computeStats(type, eq));
    const t = recorded(OWNED_DETAILS_KEY);
    const v = t.data.ret.shipView;
    const speedGens = eq.filter(i => i.category === 'speed_generator').length;
    const shieldGens = eq.filter(i => i.category === 'shield_generator').length;
    v.weapons = {
      sumRockets: countLoose(db, playerId, "t.category = 'ammo_rocket'"),
      sumBatteries: countLoose(db, playerId, "t.category = 'ammo_laser'"),
      sumLaser: st.laserCount
    };
    v.general = { hitPoints: String(Math.min(ship.hitpoints, st.hitMax)), maxHitPoints: st.hitMax, nanohull: 0, maxNanohull: st.hitMax };
    const total = speedGens + shieldGens;
    v.generators = {
      speed: speedGens, shield: shieldGens, total, maxSpeed: st.speed,
      spread: total ? `${Math.round(shieldGens / total * 100)}/${Math.round(speedGens / total * 100)}` : '0/100'
    };
    const sum=id=>db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,id).n;
    v.vouchers={repair:String(sum('resource_repairvoucher')),jump:sum('resource_jumpvoucher')};
    for(const key of Object.keys(v.bootyKeys||{}))v.bootyKeys[key]=sum(key==='green'?'resource_booty-key':`resource_booty-key-${key}`);
    const drones=require('../game/drones').owned(db,playerId);
    const counts=Object.fromEntries(['flax','iris','apis','zeus'].map(name=>[name,drones.filter(d=>d.loot_id===`drone_${name}`).length]));
    v.drones=Object.fromEntries(Object.entries(counts).map(([key,n])=>[key,String(n)]));
    t.data.ret.droneView={droneCount:counts,maxLevels:Object.fromEntries(Object.keys(counts).map(name=>[name,Math.max(0,...drones.filter(d=>d.loot_id===`drone_${name}`).map(d=>d.level))])),
      droneData:drones.map(d=>({name:metadata[d.loot_id].typeValue,dro_level:d.level+1,damage:`${Math.round(d.damage)}%`,points:d.experience,nextLevel:require('../game/drones').nextLevel(d.level)}))};
    t.data.money = money(p);
    return t;
  }
  // Satın alınmamış gemi: dükkan görünümü (katalog değerleri).
  const type = db.prepare('SELECT * FROM ship_types WHERE loot_id = ?').get(params.lootId);
  if (!type) return fail('Gemi katalogda yok.');
  const t = recorded(SHOP_DETAILS_KEY);
  const v = t.data.ret.shipView;
  v.weapons.maxLasers = type.laser_slots;
  v.maxExtras = type.extra_slots;
  v.maxCargo = type.cargo;
  v.description = '';
  v.skills = [];
  v.ownedDesigns = [];
  v.general.maxHitPoints = v.general.maxNanohull = type.hitpoints;
  v.generators.speed = v.generators.maxSpeed = type.speed;
  v.generators.maxAmount = type.generator_slots;
  t.data.money = money(p);
  return t;
}

function activateShip(playerId, params) {
  inventory.activate(playerId,params.hangarId);
  return ok({}, playerRow(playerId));
}

function setFavourite(playerId, params) {
  inventory.favourite(playerId,params.hangarId,params.activate);
  return ok({}, playerRow(playerId));
}

function getHangar(playerId,params) {
  inventory.shipFor(open(),playerId,params.hi||params.hangarId);
  return getHangarList(playerId);
}
const ACTIONS = { getHangarList, getHangar, getShipDetails, activateShip, setFavourite,
  sell:(id,p,r)=>{const update=require('../game/inventory-sales').sell(id,{...r,...p});const response=ok(true,playerRow(id));response.data.update=update;return response;},
  sellMultiple:(id,p,r)=>{const update=require('../game/inventory-sales').sell(id,{...r,...p},{multiple:true});const response=ok(true,playerRow(id));response.data.update=update;return response;},
  changeShipModel:(id,p,r)=>ok(inventory.changeDesign(id,p.hi||r.hi,r.lootId||p.lootId),playerRow(id)),
  getCompatibleShips:(id,p)=>ok(inventory.compatibleShips(id,p.hangarId||p.hi),playerRow(id)),
  importConfig:(id,p)=>ok(inventory.importConfig(id,p.hangarId,p.importId),playerRow(id)),
  move:(id,p,request)=>ok(request.from?.target==='pet'||request.to?.target==='pet'?require('../game/pet').move(id,request):request.from?.target==='drone'||request.to?.target==='drone'?require('../game/drones').move(id,request):inventory.move(id,request),playerRow(id)),
  droneEquip:(id,p,request)=>ok(require('../game/drones').equipMany(id,request),playerRow(id)),
  moveDroneDesign:(id,p,request)=>{
    const side=request.from?.target==='drone'?request.from:request.to;
    if(!side||!['design','visual'].includes(side.slotset))throw Error('Geçersiz diroit tasarım yuvası.');
    const success=require('../game/drones').move(id,request,{partial:false});
    return ok({success,newEffects:{1:{},2:{}}},playerRow(id));
  },
  clearConfig:(id,p,r)=>ok(inventory.clear(id,p.hi||r.hi,r.configID||p.configID||1),playerRow(id)),
  saveConfig:(id,p,r)=>ok(inventory.saveLayout(id,p.hi||r.hi),playerRow(id)),
  loadConfig:(id,p,r)=>ok(inventory.loadLayout(id,p.hi||r.hi),playerRow(id)),
  repairDrone:(id,p,r)=>ok(require('../game/drones').repair(id,r.itemId||p.itemId),playerRow(id)),
  sellDrone:(id,p,r)=>ok(require('../game/drones').sell(id,r.itemId||p.itemId),playerRow(id))
  ,unlockSlot:(id,p,r)=>ok(require('../game/pet-progression').unlock(id,{...r,...p}),playerRow(id))
  ,setAbCpuAmmo:(id,p,r)=>ok(require('../game/cpu-ammo').select(id,{...r,...p}),playerRow(id))
};

// body: URLSearchParams. Transporter alanlarını (from/to/configID) koru.
function handle(playerId, body) {
  const fn = Object.hasOwn(ACTIONS, body.get('action')) ? ACTIONS[body.get('action')] : null;
  if (!fn) return {contentType:'text/html; charset=UTF-8',body:encode(fail('Bu hangar işlemi henüz desteklenmiyor.'))};
  let out;
  try {
    const request=JSON.parse(Buffer.from(body.get('params') || 'e30=', 'base64').toString('utf8'));
    if(!request||typeof request!=='object'||Array.isArray(request)) throw new Error('Geçersiz istek.');
    out = fn(playerId, request.params || request,request);
  } catch(e) { out=fail(e.message); }
  return { contentType: 'text/html; charset=UTF-8', body: encode(out) };
}

module.exports = { handle, actions: Object.keys(ACTIONS) };
