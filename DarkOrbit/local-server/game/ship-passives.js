'use strict';
// Exact hull IDs and percentages from captured Ships rows. Cosmetic skins
// never add another hull bonus. Evidence / edition differences are documented
// in docs/shop-product-audit.md.
const DEFINITIONS=Object.freeze({
 'ship_g-enforcer':{damage:.05},'ship_g-bastion':{shield:.10},
 'ship_g-veteran':{ep:.10},'ship_g-exalted':{honour:.10},
 'ship_solace':{shield:.10},'ship_sentinel':{shield:.10},'ship_spectrum':{shield:.25},
 'ship_diminisher':{damage:.05},'ship_venom':{damage:.05},'ship_v-lightning':{damage:.05},
 'ship_g-referee':{damage:.05},'ship_v-revenge':{damage:.05},
 'ship_g-kick':{shield:.10},'ship_v-avenger':{shield:.10},
 'ship_g-goal':{ep:.10},'ship_v-adept':{ep:.10},'ship_bb-solemn':{ep:.10},
 'ship_v-corsair':{honour:.10},'ship_g-champion':{damage:.05,honour:.10},
 'ship_g-centaur':{hit:.10},'ship_g-saturn':{hit:.20},
 'ship_g-surgeon':{damage:.06,ep:.06,honour:.06},
 'ship_solace-plus':{shield:.15},
 'ship_hecate':{damage:.07,shield:.10},
 'ship_cyborg':{damage:.10},'ship_mimesis':{shield:.10,shieldPenetration:.05},'ship_spearhead-plus':{evasion:.05},
 'ship_a-veteran':{ep:.05,honour:.05},'ship_c-veteran':{ep:.05,honour:.05},'ship_s-veteran':{ep:.05,honour:.05},
 'ship_a-elite':{damage:.05},'ship_c-elite':{damage:.05},'ship_s-elite':{damage:.05}
});
function applyStats(lootId,stats){
 const b={...(DEFINITIONS[lootId]||{})},factor=lootId==='ship_orcus'?1.75:1,m=Object.fromEntries(Object.entries(stats.shipModules||{}).map(([k,v])=>[k,v*factor]));
 if(lootId==='ship_solaris-plus')b.damage=(b.damage||0)+.03*Math.min(4,stats.shipModuleCount||0);
 return {...stats,shipModules:m,hitMax:Math.round(stats.hitMax*(1+(b.hit||0)+(m.hit||0))),shieldMax:Math.round(stats.shieldMax*(1+(b.shield||0)+(m.shield||0))),
  laserHitBonus:(stats.laserHitBonus||0)+(m.laserAccuracy||0),rocketHitBonus:(stats.rocketHitBonus||0)+(m.rocketAccuracy||0),moduleEvasion:(stats.moduleEvasion||0)+(b.evasion||0)+(m.evasion||0),shieldPenetration:(stats.shieldPenetration||0)+(b.shieldPenetration||0)+(m.shieldPenetration||0),
  laserDamage:stats.laserDamage*(1+(b.damage||0)+(m.damage||0)),rocketMultiplier:(stats.rocketMultiplier??1)*(1+(b.damage||0)+(m.damage||0)+(m.rocketDamage||0))};
}
function hull(playerOrId,db){
 const id=typeof playerOrId==='object'?playerOrId.userId:playerOrId;
 return db.prepare('SELECT s.loot_id FROM players p JOIN ships s ON s.id=p.active_ship_id AND s.player_id=p.id WHERE p.id=?').get(id)?.loot_id;
}
function applyReward(playerOrId,reward,{db=require('./db').open()}={}){
 const ship=hull(playerOrId,db),b=DEFINITIONS[ship]||{},out={...reward},pid=typeof playerOrId==='object'?playerOrId.userId:playerOrId;
 const p=db.prepare('SELECT level,active_ship_id FROM players WHERE id=?').get(pid),inv=require('./inventory');
 const m=p?require('./ship-modules').effects(ship,inv.equipped(db,p.active_ship_id,inv.activeConfig(db,p.active_ship_id)),p.level):{};
 if(ship==='ship_orcus')for(const key of Object.keys(m))m[key]*=1.75;
 // Penalties are not increased by a positive reward bonus.
 for(const key of ['ep','honour'])if(out[key]>0&&(b[key]||m[key]))out[key]=Math.round(out[key]*(1+(b[key]||0)+(m[key]||0)));
 return out;
}
module.exports={DEFINITIONS,applyStats,applyReward,hull};
