'use strict';
// Classic Hellstorm FAQ, Retriever Dispatch FAQ and Galactic Strife09/2026 FAQ.
// Native status preserves a vector of equipped launcher types. Type3 is the
// six-round extension installed by tools/patch-multi-launcher-ui.js.
const PREFIX='equipment_weapon_rocketlauncher_';
const TYPES=Object.freeze({
 'hst-1':{capacity:3,type:1,cooldown:3000},'hst-2':{capacity:5,type:2,cooldown:3000},
 triskelion:{capacity:3,type:1,cooldown:4000,abilityCooldown:.25},
 hydra:{capacity:5,type:2,cooldown:4000,hp:.30,shield:.25},
 neptune:{capacity:5,type:2,cooldown:4000,damage:.05},
 ouroboros:{capacity:6,type:3,cooldown:3000,launcherDamage:.05}
});
function definition(id){return id?.startsWith(PREFIX)?TYPES[id.slice(PREFIX.length)]:undefined;}
function equipped(items){return items.filter(i=>i.slot==='heavy_gun'&&definition(i.loot_id));}
function passives(items){return equipped(items).reduce((out,item)=>{const d=definition(item.loot_id);for(const key of ['hp','shield','damage','abilityCooldown'])out[key]+=d[key]||0;return out;},{hp:0,shield:0,damage:0,abilityCooldown:0});}
module.exports={TYPES,definition,equipped,passives};
