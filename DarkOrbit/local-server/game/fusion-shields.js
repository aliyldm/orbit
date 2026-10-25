'use strict';
// Official Generators FAQ: each installed FS shield adds 6.25% regeneration.
// This multiplier composes with regeneration boosters; it does not change
// shield capacity, combat lockout or the world's existing base regeneration.
const IDS=new Set(['equipment_generator_shield_fs-01','equipment_generator_shield_fs-02','equipment_generator_shield_fs-03']);
function multiplier(equipped){return 1+equipped.filter(i=>IDS.has(i.loot_id)&&i.amount!==0).length*.0625;}
module.exports={IDS,multiplier};
