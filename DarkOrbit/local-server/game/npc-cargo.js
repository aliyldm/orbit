'use strict';
// Source-edition aware cargo, independent of the client visual/type identifier.
// null means unverified; [] means the selected source explicitly has no ore.
const normal = require('./normal-npc-cargo.json');
const catalog = require('./npc-catalog');
const kronosCargo = require('./data/kronos-cargo.json');
const rows = counts => counts.flatMap((amount,type) => amount ? [{type,amount}] : []);
const special = {
  // EN Zeta FAQ, matching this project's selected Zeta stat edition.
  infernal: rows([100,100,100,0,16,16,2,1]),
  scorcher: rows([200,200,200,0,32,32,4,2]),
  melter: rows([300,300,300,0,128,128,16,8]),
  devourer: rows([1600,1600,1600,64,256,256,32,16]),
  // EN Epsilon FAQ; deliberately different from the DE LoW variants below.
  'epsilon-vagrant': rows([50,50,50,1,4,4]),
  'epsilon-marauder': rows([75,75,75,2,8,8]),
  'epsilon-outcast': rows([100,100,100,4,16,16,1,1]),
  'epsilon-corsair': rows([150,150,150,8,25,25,2,2]),
  'epsilon-hooligan': rows([200,200,200,12,32,32,4,4]),
  'epsilon-ravager': rows([300,300,300,16,50,50,8,8]),
  'epsilon-convict': rows([400,400,400,24,64,64,16,16]),
  // DE general/LoW NPC edition (not the EN Epsilon version).
  vagrant: [], marauder: [], outcast: [], corsair: [], hooligan: [], ravager: [], convict: [],
  demaner: rows([300,300,300,22,128,128,32]),
  // DE invasion x-1 edition; Kappa has separate named variants below.
  kucurbium: rows([1200,1200,1200,256,512,512,64]),
  'boss-kucurbium': rows([4800,4800,4800,1024,2048,2048,256]),
  icy: rows([100,100,100,0,16,16,2]),
  'century-falcon': rows([1,1,1,1,1,1,1]),
  // ES explicit Kappa and Hades variants, matching their selected stat edition.
  'kappa-demaner': rows([300,300,300,32,128,128,32]),
  'kappa-kucurbium': rows([1200,1200,1200,256,512,512,64]),
  'kappa-boss-kucurbium': rows([4800,4800,4800,1024,2048,2048,256]),
  'kappa-century-falcon': rows([1,1,1,1,1,1,1]),
  'emperor-sibelon': rows([1600,1600,1600,64,256,256,32]),
  'emperor-lordakium': rows([2560,2560,2560,64,512,512,64]),
  'emperor-kristallon': rows([2560,2560,2560,128,1024,1024,128])
};
function ownStarterStreuner(def,{player,mapId}={}) {
  return def?.key==='streuner' && !def.gateRunId && player &&
    [1,5,9][Number(player.factionId)-1] === Number(mapId ?? player.mapId);
}
function resolve(def,context={}) {
  if(def&&Object.hasOwn(kronosCargo,def.key)) {
    const canonical=require('./kronos').definition(def.key.slice(7));
    const scale=context.scale??def.scale??(def.hitpoints===undefined?1:def.hitpoints/canonical.hitpoints);
    return scale===1?structuredClone(kronosCargo[def.key]):null;
  }
  if(!def || !catalog.definitions[def.key]) return null;
  const canonical=catalog.definitions[def.key];
  // The gate multiplier documents combat/currency; it does not establish ore.
  const scale=context.scale ?? def.scale ?? (def.hitpoints === undefined ? 1 : def.hitpoints/canonical.hitpoints);
  if(scale !== 1) return null;
  if(ownStarterStreuner(def,context) && Number(context.player.level)>=7) {
    const amount=({7:5,8:2,9:1})[context.player.level] ?? 0;
    return amount ? rows([amount,amount]) : [];
  }
  const result=Object.hasOwn(normal,def.key) ? normal[def.key] : special[def.key];
  return result === undefined ? null : structuredClone(result);
}
// Exact EN x-1 table, before player skill/formation/booster reward multipliers.
// Returning null means preserve the NPC's ordinary base reward.
function rewardOverride(def,context={}) {
  if(!ownStarterStreuner(def,context) || !Number.isInteger(context.player.level) || context.player.level<7) return null;
  const level=context.player.level;
  const ep=level>=15 ? 0 : ({7:200,8:100,9:50,10:25,11:12,12:6,13:3,14:1})[level];
  return {ep,credits:ep,honour:level===7?1:0,uridium:0};
}
module.exports={resolve,rewardOverride};
