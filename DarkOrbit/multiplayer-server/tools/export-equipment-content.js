'use strict';
process.env.DARKORBIT_DB=':memory:';
const fs=require('node:fs'),path=require('node:path');
const root=path.resolve(__dirname,'..'),legacy=path.resolve(root,'../local-server'),database=require(path.join(legacy,'game/db'));
const db=database.open(':memory:');
try{
 const meta=require(path.join(legacy,'docs/client-map.items.json')).items;
 const keys=['kind','lootId','typeClass','typeValue','shipId','baseShipId','slotable','equipable','upgradable','sellable','repairable','designId','droneId','slots','maxQuantity','maxNanoHull','driveDef','cannonDef'];
 const items=Object.fromEntries(Object.entries(meta).map(([id,m])=>[id,Object.fromEntries(keys.filter(k=>m[k]!==undefined).map(k=>[k,m[k]]))]));
 const dr=require(path.join(legacy,'game/drones')),formations={};
 db.exec('PRAGMA foreign_keys=OFF');
 for(const id of [0,...Object.keys(dr.formationIds).map(k=>dr.formationIds[k])]){
  db.prepare('INSERT OR REPLACE INTO drone_settings VALUES(1,?)').run(id);
  formations[id]=dr.effects(1);
 }
 db.exec('PRAGMA foreign_keys=ON');
 const laser=require(path.join(legacy,'game/laser-visuals'));
 const expansion=Object.fromEntries(Object.keys(meta).filter(k=>meta[k].kind==='Ship'||meta[k].typeClass?.endsWith('.ShipDesignType')).map(k=>[k,laser.stage(k,2)]));
 const boosters=require(path.join(legacy,'game/boosters'));
 const pet=require(path.join(legacy,'game/pet-catalog'));
 const petIds=[...new Set([...Object.keys(pet.DATA),...Object.values(pet.DATA).flatMap(d=>d.levels.map(l=>l.variant))])];
 const petItems=Object.fromEntries(petIds.map(id=>[id,Array.from({length:4},(_,n)=>{const item={loot_id:id,pet_level:n+1},value=pet.resolve(item);return value?{...value,supported:!!(pet.gear(item)||pet.protocol(item))?.supported,minimumPetLevel:pet.minimumPetLevel(n+1)}:null;})]));
 const output={format:1,items,shipTypes:db.prepare('SELECT * FROM ship_types ORDER BY loot_id').all(),itemTypes:db.prepare('SELECT * FROM item_types ORDER BY loot_id').all(),
  modules:require(path.join(legacy,'game/ship-modules')).DEFINITIONS,hulls:require(path.join(legacy,'game/ship-passives')).DEFINITIONS,
  launcherTypes:require(path.join(legacy,'game/launcher-hardware')).TYPES,droneUpgrades:require(path.join(legacy,'game/data/drone-patterns.json')).upgrades,
  droneDesignTypes:require(path.join(legacy,'game/drone-designs')).TYPES,dronePatterns:require(path.join(legacy,'game/data/drone-patterns.json')).designs,formations,formationIds:dr.formationIds,skillBenefits:require(path.join(legacy,'game/skills')).BENEFITS,
  boosterTypes:Object.fromEntries(Object.entries(boosters.definitions).filter(([id])=>boosters.isSupported(id))),expansion,
  cannonTypes:Object.fromEntries(Object.keys(meta).filter(id=>meta[id].typeClass?.endsWith('.CannonType')).map(id=>[id,require(path.join(legacy,'game/advanced-weapons')).cannonType(id)])),
  petItems,petSlotBase:require(path.join(legacy,'game/pet-progression')).BASE,petAppearances:require(path.join(legacy,'game/data/pet-appearances.json')).appearances};
 const target=path.join(root,'src/DarkOrbit.Server/Equipment/equipment-content.json');fs.mkdirSync(path.dirname(target),{recursive:true});fs.writeFileSync(target,JSON.stringify(output,null,2)+'\n');
 console.log(JSON.stringify({equipmentMetadata:Object.keys(items).length,shipTypes:output.shipTypes.length,itemTypes:output.itemTypes.length}));
}finally{database.close();}
