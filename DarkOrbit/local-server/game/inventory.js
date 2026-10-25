'use strict';
// Contract: inventory.swf DataInterchange, ConnectionProxy and ConfigManager.
// Configuration 1 remains in items for compatibility with the original game loader.
const { open, tx } = require('./db');
const World = require('./world');
const METADATA = require('../docs/client-map.items.json').items;
const SLOT = { lasers: 'laser', generators: 'generator', extras: 'extra',heavy_guns:'heavy_gun',cannons:'cannon',drives:'drive',cannon_shields:'cannon_shield',lenses:'lens',ship_upgrades:'ship_upgrade',QuantumFluidCore:'quantum_core' };
const SLOTSET = Object.fromEntries(Object.entries(SLOT).map(([name,slot])=>[slot,name]));
const CATEGORY_SLOT = { laser: 'laser', shield_generator: 'generator', speed_generator: 'generator', extra: 'extra', cpu: 'extra',rocket_launcher:'heavy_gun' };
const GROUP = { laser: 0, speed_generator: 3, shield_generator: 4, extra: 11, cpu:7, ammo_laser: 13, ammo_rocket: 14, resource: 16 };
const error = message => { throw new Error(message); };
function slotFor(item) {
  if(METADATA[item.loot_id]?.typeClass?.includes('.ammo.'))return undefined;
  const cls=(METADATA[item.loot_id]?.typeClass||'').split('.').at(-1);
  return ({LaserType:'laser',EngineType:'generator',ShieldType:'generator',CPUType:'extra',ExtraType:'extra',RobotType:'extra',ModuleType:'extra',UpgradeType:'extra',HellstormLauncherType:'heavy_gun',CannonType:'cannon',DriveType:'drive',CannonShieldType:'cannon_shield',LensType:'lens',ShipUpgradeType:'ship_upgrade',QuantumFluidCoreType:'quantum_core'})[cls] || CATEGORY_SLOT[item.category];
}

function shipFor(db, playerId, shipId) {
  const s = db.prepare(`SELECT s.*, t.name, t.hitpoints AS hit_max, t.speed, t.cargo,
    t.laser_slots, t.generator_slots, t.extra_slots FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id
    WHERE s.id=? AND s.player_id=?`).get(Number(shipId), playerId);
  if (!s) error('Gemi bulunamadı.');
  return s;
}
function configId(value) {
  const n = Number(value);
  if (n !== 1 && n !== 2) error('Geçersiz konfigürasyon.');
  return n;
}
function equipped(db, shipId, config = 1) {
  configId(config);
  return config === 1 ? db.prepare(`SELECT i.*, t.category, t.damage, t.shield AS shield, t.shield_absorb, t.speed, t.multiplier
    FROM items i JOIN item_types t ON t.loot_id=i.loot_id WHERE i.ship_id=? AND i.slot IS NOT NULL ORDER BY i.slot_index,i.id`).all(shipId)
    : db.prepare(`SELECT i.*, e.ship_id, e.slot, e.slot_index, t.category, t.damage, t.shield, t.shield_absorb, t.speed, t.multiplier
    FROM equipment_config2 e JOIN items i ON i.id=e.item_id JOIN item_types t ON t.loot_id=i.loot_id WHERE e.ship_id=? ORDER BY e.slot_index,i.id`).all(shipId);
}
function freeSlots(db, shipId, slot, config = 1) {
  const s = db.prepare(`SELECT t.* FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id WHERE s.id=?`).get(shipId);
  if (!s || !SLOTSET[slot]) return [];
  const eq=equipped(db,shipId,config);
  const size = slot === 'laser' ? s.laser_slots : slot === 'generator' ? s.generator_slots : slot==='extra'?extraCapacity(s,eq):METADATA[s.loot_id]?.slotable?.slots.find(s=>s.name===SLOTSET[slot])?.size||0;
  const used = new Set(eq.filter(i => i.slot === slot).map(i => i.slot_index));
  return Array.from({length: size}, (_, i) => i).filter(i => !used.has(i));
}
function extraCapacity(ship,eq) {
  const extension={'equipment_extra_cpu_sle-01':2,'equipment_extra_cpu_sle-02':4,'equipment_extra_cpu_sle-03':6,'equipment_extra_cpu_sle-04':10};
  return ship.extra_slots+Math.max(0,...eq.map(i=>extension[i.loot_id]||0));
}
function refresh(playerId) {
  const world = World.current();
  const player = world?.livePlayer(playerId);
  if (player) {
    world.refreshStats();
    require('./cpu').notify(world);
    if(world.combat){const command=require('./assembly').inventoryCommand(playerId);world.broadcast(s=>(world.combat.send||require('./net').sendCmd)(s,command));}
  }
}
function requireOffline(playerId) {
  const w = World.current();
  if (w && w.livePlayer(playerId)) error('Bu işlem için önce oyundan çık.');
}

function move(playerId, request) {
  const from = request.from || {}, to = request.to || {};
  const shipId = Number(request.params?.hi || request.hangarId);
  const config = configId(to.configId || from.configId || 1);
  if (from.configId && Number(from.configId) !== config) error('Konfigürasyonlar arası taşıma desteklenmiyor.');
  if (!['inventory', 'ship'].includes(from.target) || !['inventory', 'ship'].includes(to.target)) error('Bu ekipman hedefi henüz desteklenmiyor.');
  if (from.target === to.target) error('Kaynak ve hedef aynı.');
  const ids = from.items;
  if (!Array.isArray(ids) || !ids.length || ids.length > 100 || ids.some(x => !Number.isSafeInteger(Number(x)) || Number(x) <= 0) || new Set(ids.map(Number)).size !== ids.length) error('Geçersiz eşya listesi.');
  const result = tx(db => {
    const ship=shipFor(db, playerId, shipId);
    const layout = equipped(db, shipId, config);
    const current = new Map(layout.map(i => [i.id, i]));
    const rows = ids.map(id => {
      const r = db.prepare(`SELECT i.*,t.category FROM items i JOIN item_types t ON t.loot_id=i.loot_id WHERE i.id=? AND i.player_id=?`).get(Number(id), playerId);
      if (!r || r.amount !== 1 || !slotFor(r)) error('Eşya bulunamadı veya bu eşya takılamaz.');
      return r;
    });
    if (to.target === 'ship') {
      const slot = SLOT[to.slotset];
      if (!slot || rows.some(r => slotFor(r) !== slot)) error('Eşya bu yuvaya uymuyor.');
      if(slot==='ship_upgrade')require('./ship-modules').validate(ship.loot_id,layout.concat(rows.map(r=>({...r,slot}))),{ignoreCapacity:true});
      if(rows.some(r=>METADATA[r.loot_id]?.equipable?.entities&&!METADATA[r.loot_id].equipable.entities.includes('SHIP')))error('Bu eşya yalnızca P.E.T. veya diroit için kullanılabilir.');
      if(slot==='cannon'){
        const types=layout.filter(i=>i.slot==='cannon').concat(rows).map(i=>require('./advanced-weapons').cannonType(i.loot_id));
        if(types.some(t=>t<0)||new Set(types).size!==types.length)error('Her parçacık topu türünden yalnızca bir tane takılabilir.');
      }
      const free = freeSlots(db, shipId, slot, config);
      for (const r of rows) {
        const second = db.prepare('SELECT ship_id FROM equipment_config2 WHERE item_id=?').get(r.id);
        const drone=db.prepare('SELECT ship_id,config_id FROM drone_equipment WHERE item_id=?').all(r.id);
        const pet=require('./pet').assignments(db,r.id);
        if (current.has(r.id) || (r.ship_id && r.ship_id !== shipId) || (second && second.ship_id !== shipId) || drone.concat(pet).some(e=>e.config_id===config||e.ship_id!==shipId)) error('Eşya başka bir hangarda takılı.');
      }
      rows.slice(0,free.length).forEach((r,i) => {
        if (config === 1) db.prepare('UPDATE items SET ship_id=?,slot=?,slot_index=? WHERE id=?').run(shipId,slot,free[i],r.id);
        else db.prepare('INSERT INTO equipment_config2(item_id,ship_id,slot,slot_index) VALUES(?,?,?,?)').run(r.id,shipId,slot,free[i]);
      });
      // Native ConnectionProxy expects the IDs left in inventory on overflow.
      if(free.length<rows.length)return rows.slice(free.length).map(r=>r.id);
    } else {
      if (rows.some(r => !current.has(r.id) || (from.slotset && SLOT[from.slotset] !== current.get(r.id).slot))) error('Eşya belirtilen konfigürasyonda takılı değil.');
      const remaining=layout.filter(i=>!ids.map(Number).includes(i.id));
      if(remaining.some(i=>i.slot==='extra'&&i.slot_index>=extraCapacity(ship,remaining)))error('Önce genişletilmiş yuvalardaki eşyaları çıkar.');
      rows.forEach(r => {
        if (config === 1) db.prepare('UPDATE items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE id=?').run(r.id);
        else db.prepare('DELETE FROM equipment_config2 WHERE item_id=?').run(r.id);
      });
    }
    return true;
  });
  refresh(playerId);
  return result;
}
function clear(playerId, shipId, config) {
  config = configId(config);
  tx(db => {
    shipFor(db,playerId,shipId);
    if (config === 1) db.prepare('UPDATE items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE ship_id=?').run(shipId);
    else db.prepare('DELETE FROM equipment_config2 WHERE ship_id=?').run(shipId);
    db.prepare('DELETE FROM drone_equipment WHERE ship_id=? AND config_id=?').run(shipId,config);
    require('./pet').clearConfig(db,shipId,config);
  });
  refresh(playerId);
  return true;
}
function saveLayout(playerId, shipId) {
  return tx(db => {
    shipFor(db,playerId,shipId);
    const layout = [1,2].map(c => equipped(db,shipId,c).map(i => ({id:i.id, slot:i.slot, index:i.slot_index})).concat(
      require('./drones').equipped(db,shipId,c).map(i=>({id:i.id,droneId:i.drone_id,slot:i.drone_slot,index:i.slot_index})),
      require('./pet').statItems(db,shipId,c).map(i=>({id:i.id,pet:true,slot:i.slot,index:i.slot_index}))));
    db.prepare('INSERT INTO equipment_saved(ship_id,layout) VALUES(?,?) ON CONFLICT(ship_id) DO UPDATE SET layout=excluded.layout').run(shipId,JSON.stringify(layout));
    return true;
  });
}
function loadLayout(playerId, shipId) {
  const result = tx(db => {
    shipFor(db,playerId,shipId);
    const saved = db.prepare('SELECT layout FROM equipment_saved WHERE ship_id=?').get(shipId);
    if (!saved) error('Kayıtlı konfigürasyon yok.');
    const layout = JSON.parse(saved.layout);
    db.prepare('UPDATE items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE ship_id=?').run(shipId);
    db.prepare('DELETE FROM equipment_config2 WHERE ship_id=?').run(shipId);
    db.prepare('DELETE FROM drone_equipment WHERE ship_id=?').run(shipId);
    db.prepare('DELETE FROM pet_equipment WHERE ship_id=?').run(shipId);
    let complete = true;
    layout.forEach((rows,c) => rows.forEach(r => {
      const item = db.prepare('SELECT * FROM items WHERE id=? AND player_id=?').get(r.id,playerId);
      const other = db.prepare('SELECT ship_id FROM equipment_config2 WHERE item_id=?').get(r.id);
      const drone=db.prepare('SELECT * FROM drone_equipment WHERE item_id=?').all(r.id);
      const pet=require('./pet'),assignments=pet.assignments(db,r.id);
      if (!item || item.amount !== 1 || (item.ship_id && item.ship_id !== shipId) || (other && other.ship_id !== shipId) || drone.concat(assignments).some(e=>e.ship_id!==shipId||e.config_id===c+1)) { complete=false; return; }
      if(r.pet) {
        const owner=pet.owned(playerId,db),accepts=owner&&pet.accepts(item,r.slot,owner);
        const used=db.prepare('SELECT 1 FROM pet_equipment WHERE ship_id=? AND config_id=? AND slot=? AND slot_index=?').get(shipId,c+1,r.slot,r.index);
        if(!pet.owned(playerId,db)||!accepts||r.index>=pet.SLOTS[r.slot]||used){complete=false;return;}
        db.prepare('INSERT INTO pet_equipment(player_id,ship_id,config_id,slot,slot_index,item_id)VALUES(?,?,?,?,?,?)').run(playerId,shipId,c+1,r.slot,r.index,r.id);
        return;
      }
      if(r.droneId) {
        const d=db.prepare('SELECT * FROM drones WHERE id=? AND player_id=?').get(r.droneId,playerId);
        const slot=d&&METADATA[d.loot_id].slotable.slots.find(s=>s.name===r.slot);
        const used=db.prepare('SELECT 1 FROM drone_equipment WHERE drone_id=? AND ship_id=? AND config_id=? AND slot=? AND slot_index=?').get(r.droneId,shipId,c+1,r.slot,r.index);
        if(!slot || r.index>=slot.size || used || !slot.accepts.includes((METADATA[item.loot_id]?.typeClass||'').split('.').at(-1))) {complete=false;return;}
        db.prepare('INSERT INTO drone_equipment(drone_id,ship_id,config_id,slot,slot_index,item_id)VALUES(?,?,?,?,?,?)').run(r.droneId,shipId,c+1,r.slot,r.index,r.id);
        return;
      }
      if(!freeSlots(db,shipId,r.slot,c+1).includes(r.index)){complete=false;return;}
      if(r.slot==='ship_upgrade'){try{require('./ship-modules').validate(shipFor(db,playerId,shipId).loot_id,equipped(db,shipId,c+1).concat({...item,slot:r.slot}));}catch{complete=false;return;}}
      if (c === 0) db.prepare('UPDATE items SET ship_id=?,slot=?,slot_index=? WHERE id=?').run(shipId,r.slot,r.index,r.id);
      else db.prepare('INSERT INTO equipment_config2(item_id,ship_id,slot,slot_index) VALUES(?,?,?,?)').run(r.id,shipId,r.slot,r.index);
    }));
    return complete;
  });
  refresh(playerId);
  return result;
}
function activate(playerId, shipId) {
  requireOffline(playerId);
  const s=shipFor(open(),playerId,shipId);
  open().prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(s.id,playerId);
  return s;
}
function favourite(playerId, shipId, value) {
  const s=shipFor(open(),playerId,shipId);
  open().prepare('UPDATE ships SET favorite=? WHERE id=?').run(value ? 1:0,s.id);
  return true;
}
function addDesign(db,playerId,lootId) {
  if(!METADATA[lootId]?.typeClass?.endsWith('.ShipDesignType'))error('Gemi tasarımı bulunamadı.');
  if(db.prepare('SELECT 1 FROM ship_designs WHERE player_id=? AND loot_id=?').get(playerId,lootId))error('Bu gemi tasarımına zaten sahipsin.');
  db.prepare('INSERT INTO ship_designs(player_id,loot_id)VALUES(?,?)').run(playerId,lootId);
  return true;
}
function availableDesigns(db,ship) {
  const base=METADATA[ship.loot_id];
  return [ship.loot_id,...db.prepare('SELECT loot_id FROM ship_designs WHERE player_id=? ORDER BY loot_id').all(ship.player_id).map(i=>i.loot_id).filter(id=>METADATA[id]?.baseShipId===base?.shipId)];
}
function shipAppearance(db,ship) {
  return ship.design_loot_id&&availableDesigns(db,ship).includes(ship.design_loot_id)?ship.design_loot_id:ship.loot_id;
}
function changeDesign(playerId,shipId,lootId) {
  requireOffline(playerId);
  const db=open(),ship=shipFor(db,playerId,shipId);
  if(!availableDesigns(db,ship).includes(lootId))error('Bu tasarıma sahip değilsin veya bu gemiye uymuyor.');
  db.prepare('UPDATE ships SET design_loot_id=? WHERE id=?').run(lootId===ship.loot_id?null:lootId,ship.id);
  return true;
}
function compatibleShips(playerId,originId) {
  const db=open(),origin=shipFor(db,playerId,originId);
  const source=[1,2].map(c=>equipped(db,origin.id,c));
  return db.prepare('SELECT id FROM ships WHERE player_id=? AND id<>? ORDER BY id').all(playerId,origin.id).map(i=>shipFor(db,playerId,i.id)).filter(ship=>source.every(eq=>eq.every(i=>{
    const cap=i.slot==='laser'?ship.laser_slots:i.slot==='generator'?ship.generator_slots:i.slot==='extra'?extraCapacity(ship,eq):METADATA[ship.loot_id]?.slotable?.slots.find(s=>s.name===SLOTSET[i.slot])?.size||0;
    return i.slot_index<cap;
  }))).map(s=>({name:s.name,hangarId:s.id}));
}
function importConfig(playerId,originId,targetId) {
  requireOffline(playerId);
  return tx(db=>{
    const origin=shipFor(db,playerId,originId),target=shipFor(db,playerId,targetId);
    for(const c of [1,2])require('./ship-modules').validate(target.loot_id,equipped(db,origin.id,c));
    if(!compatibleShips(playerId,origin.id).some(s=>s.hangarId===target.id))error('Hedef geminin yuvaları bu konfigürasyon için yetersiz.');
    db.prepare('UPDATE items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE ship_id=?').run(target.id);
    db.prepare('DELETE FROM equipment_config2 WHERE ship_id=?').run(target.id);
    db.prepare('DELETE FROM drone_equipment WHERE ship_id=?').run(target.id);
    db.prepare('DELETE FROM pet_equipment WHERE ship_id=?').run(target.id);
    db.prepare('UPDATE items SET ship_id=? WHERE ship_id=?').run(target.id,origin.id);
    db.prepare('UPDATE equipment_config2 SET ship_id=? WHERE ship_id=?').run(target.id,origin.id);
    db.prepare('UPDATE drone_equipment SET ship_id=? WHERE ship_id=?').run(target.id,origin.id);
    db.prepare('UPDATE pet_equipment SET ship_id=? WHERE ship_id=?').run(target.id,origin.id);
    db.prepare('UPDATE ships SET active_config=? WHERE id=?').run(origin.active_config,target.id);
    return true;
  });
}
function activeConfig(db,shipId) { return db.prepare('SELECT active_config FROM ships WHERE id=?').get(shipId)?.active_config || 1; }
function switchConfig(playerId,shipId,config) {
  config=configId(config);
  const world=World.current(),live=world?.livePlayer(playerId);
  const incoming=tx(db=>{
    const ship=shipFor(db,playerId,shipId),previous=activeConfig(db,shipId);
    if(previous===config)return live?.shipId===shipId?(live.ultimateCloaked?(live.ultimateShield||0):live.shield):ship.shield;
    const outgoing=live?.shipId===shipId?(live.ultimateCloaked?(live.ultimateShield||0):live.shield):ship.shield;
    db.prepare('INSERT INTO ship_config_shields(ship_id,config_id,shield)VALUES(?,?,?) ON CONFLICT(ship_id,config_id)DO UPDATE SET shield=excluded.shield').run(shipId,previous,outgoing);
    const shield=db.prepare('SELECT shield FROM ship_config_shields WHERE ship_id=? AND config_id=?').get(shipId,config)?.shield||0;
    db.prepare('UPDATE ships SET active_config=?,shield=? WHERE id=?').run(config,shield,shipId);
    return shield;
  });
  refresh(playerId);
  if(live?.shipId===shipId) {
    if(live.ultimateCloaked){live.ultimateShield=Math.min(incoming,live.shieldMax);live.shield=0;}
    else live.shield=Math.min(incoming,live.shieldMax);
    const {sendCmd}=require('./net');
    world.broadcast(s=>sendCmd(s,{_: 'AttributeShieldUpdateCommand',shieldNow:live.shield,shieldMax:live.shieldMax}));
  }
  return true;
}
function rows(playerId) {
  return open().prepare(`SELECT i.*,t.category,t.name,t.price_credits,t.price_uridium,e.ship_id AS second_ship_id FROM items i
    JOIN item_types t ON t.loot_id=i.loot_id LEFT JOIN equipment_config2 e ON e.item_id=i.id WHERE i.player_id=? ORDER BY i.id`).all(playerId);
}
function statItems(db,shipId,config=activeConfig(db,shipId)) {
  return equipped(db,shipId,config).concat(require('./drones').statItems(db,shipId,config));
}
function groupOf(item) {
  const cls=METADATA[item.loot_id]?.typeClass;
  if(cls) {
    const groups={LaserType:0,HellstormLauncherType:1,EngineType:3,ShieldType:4,BoosterType:6,CPUType:7,ModuleType:8,RobotType:9,UpgradeType:10,ExtraType:11,ShipUpgradeType:12,OreType:16,DroneDesignType:18,DroneCustomizationType:19,DroneFormationType:20,StationModuleType:21,PetGearType:22,AIProtocolType:23,PetDesignType:24,PetCustomizationType:25};
    const name=cls.split('.').at(-1);
    if(cls.includes('.weapon.ammo.'))return name==='LaserType'?13:name==='RocketType'?14:15;
    if(groups[name]!==undefined)return groups[name];
  }
  if (item.category==='extra') {
    if (item.loot_id.startsWith('equipment_extra_cpu_')) return 7;
    if (item.loot_id.startsWith('equipment_extra_repbot_')) return 9;
  }
  return GROUP[item.category] ?? 17;
}
function buildInit(player) {
  const db=open();
  const ships=db.prepare('SELECT * FROM ships WHERE player_id=? ORDER BY id').all(player.userId);
  const items=rows(player.userId).filter(i=>i.amount>0).map(i=>({
    _: 'HangarShipEquipmentInventoryItem', itemid:i.id,lootId:i.loot_id,
    lootType: METADATA[i.loot_id]?.typeClass || 'net.bigpoint.darkorbit.asset.item.ItemType',
    itemCount:i.amount,hangarId:i.ship_id || i.second_ship_id || db.prepare('SELECT ship_id FROM drone_equipment WHERE item_id=? LIMIT 1').get(i.id)?.ship_id || require('./pet').assignments(db,i.id)[0]?.ship_id || 0,level:require('./pet-catalog').resolve(i)?i.pet_level-1:i.upgrade_level||0
  }));
  // Flash vector lengths use signed bytes: keep each pack <=127.
  const packs=[];
  for(let n=0;n<items.length;n+=100) packs.push({_: 'InventoryItemPack',items:items.slice(n,n+100)});
  return {_: 'HangarShipsCommand',ships:ships.map(s=>({_: 'HangarShipBriefCommand',shipId:s.id,lootId:s.loot_id,isActive:s.id===player.shipId,isFavorite:!!s.favorite})),items:packs,
    allDesignPack:ships.map(s=>({_: 'ShipDesignPack',designList:availableDesigns(db,s)})),petView:require('./pet').view(player.userId),drones:require('./drones').views(player.userId)};
}
function equipmentCommand(playerId,shipId) {
  const db=open(),s=shipFor(db,playerId,shipId);
  const active=activeConfig(db,shipId);
  return {_: 'HangarShipEquipmentCommand',hangarId:s.id,shipId:s.id,lootId:s.loot_id,extrasSlotsSize1:extraCapacity(s,equipped(db,shipId,1)),extrasSlotsSize2:extraCapacity(s,equipped(db,shipId,2)),currentConfigId:active,petConfigs:require('./pet').equipmentConfigs(playerId,shipId),droneConfigs:require('./drones').configs(playerId,shipId),
    shipConfigs:[1,2].map(c=>{
      const eq=equipped(db,shipId,c),ids=slot=>eq.filter(i=>i.slot===slot).map(i=>i.id);
      return {_: 'HangarShipEquipmentMsg',setId:c,active:c===active,laser:ids('laser'),generators:ids('generator'),extra:ids('extra'),rocket:ids('heavy_gun'),upgrades:ids('ship_upgrade'),QuantumFluidCore:ids('quantum_core'),drive:ids('drive'),cannonShield:ids('cannon_shield'),cannon:ids('cannon'),lens:ids('lens')};
    })};
}
module.exports = { SLOT, SLOTSET, CATEGORY_SLOT, GROUP, slotFor, shipFor, equipped, statItems, freeSlots, move, clear, saveLayout, loadLayout, activate, favourite, activeConfig, switchConfig, rows, groupOf, buildInit, equipmentCommand,addDesign,availableDesigns,shipAppearance,changeDesign,compatibleShips,importConfig };
