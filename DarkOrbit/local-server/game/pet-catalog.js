'use strict';
// Transcribed from ItemDataProvider.as; exact numeric source values, never executable AS.
const SOURCE_SHA256 = 'c717bc9de28cb7fb9ff37847de2cc48ed583c41ca054cfc385559fd6d7671102';
const DATA = {
  "equipment_aiprotocol_ai-s1": {
    "kind": "protocol",
    "typeName": "SALVAGE",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-s10",
        "values": {
          "loot_increase": 1,
          "find_chance": 1
        },
        "sellCredits": 12500
      },
      {
        "variant": "equipment_aiprotocol_ai-s11",
        "values": {
          "loot_increase": 2,
          "find_chance": 2
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_aiprotocol_ai-s12",
        "values": {
          "loot_increase": 3,
          "find_chance": 3
        },
        "sellCredits": 112500
      },
      {
        "variant": "equipment_aiprotocol_ai-s13",
        "values": {
          "loot_increase": 4,
          "find_chance": 4
        },
        "sellCredits": 187500
      }
    ]
  },
  "equipment_aiprotocol_ai-cr1": {
    "kind": "protocol",
    "typeName": "CARGO",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-cr10",
        "values": {
          "cargo_increase": 3
        },
        "sellCredits": 7500
      },
      {
        "variant": "equipment_aiprotocol_ai-cr11",
        "values": {
          "cargo_increase": 6
        },
        "sellCredits": 18750
      },
      {
        "variant": "equipment_aiprotocol_ai-cr12",
        "values": {
          "cargo_increase": 12
        },
        "sellCredits": 62500
      },
      {
        "variant": "equipment_aiprotocol_ai-cr13",
        "values": {
          "cargo_increase": 15
        },
        "sellCredits": 100000
      }
    ]
  },
  "equipment_aiprotocol_ai-al1": {
    "kind": "protocol",
    "typeName": "ALIEN",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-al10",
        "values": {
          "damage_boost": 1
        },
        "sellCredits": 7500
      },
      {
        "variant": "equipment_aiprotocol_ai-al11",
        "values": {
          "damage_boost": 3
        },
        "sellCredits": 18750
      },
      {
        "variant": "equipment_aiprotocol_ai-al12",
        "values": {
          "damage_boost": 6
        },
        "sellCredits": 62500
      },
      {
        "variant": "equipment_aiprotocol_ai-al13",
        "values": {
          "damage_boost": 8
        },
        "sellCredits": 100000
      }
    ]
  },
  "equipment_aiprotocol_ai-ah1": {
    "kind": "protocol",
    "typeName": "HEAT_GENERATION",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-ah10",
        "values": {
          "heat_generation_increase": 1
        },
        "sellCredits": 12500
      },
      {
        "variant": "equipment_aiprotocol_ai-ah11",
        "values": {
          "heat_generation_increase": 2
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_aiprotocol_ai-ah12",
        "values": {
          "heat_generation_increase": 3
        },
        "sellCredits": 112500
      }
    ]
  },
  "equipment_aiprotocol_ai-e1": {
    "kind": "protocol",
    "typeName": "EVASION",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-e10",
        "values": {
          "opponents_accuracy_reduction": 1
        },
        "sellCredits": 12500
      },
      {
        "variant": "equipment_aiprotocol_ai-e11",
        "values": {
          "opponents_accuracy_reduction": 2
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_aiprotocol_ai-e12",
        "values": {
          "opponents_accuracy_reduction": 3
        },
        "sellCredits": 112500
      },
      {
        "variant": "equipment_aiprotocol_ai-e13",
        "values": {
          "opponents_accuracy_reduction": 4
        },
        "sellCredits": 175000
      }
    ]
  },
  "equipment_aiprotocol_ai-aim1": {
    "kind": "protocol",
    "typeName": "TARGETING",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-aim10",
        "values": {
          "accuracy_increase": 1
        },
        "sellCredits": 7500
      },
      {
        "variant": "equipment_aiprotocol_ai-aim11",
        "values": {
          "accuracy_increase": 2
        },
        "sellCredits": 18750
      },
      {
        "variant": "equipment_aiprotocol_ai-aim12",
        "values": {
          "accuracy_increase": 4
        },
        "sellCredits": 62500
      },
      {
        "variant": "equipment_aiprotocol_ai-aim13",
        "values": {
          "accuracy_increase": 6
        },
        "sellCredits": 100000
      }
    ]
  },
  "equipment_aiprotocol_ai-eco1": {
    "kind": "protocol",
    "typeName": "ECONOMY",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-eco10",
        "values": {
          "fuel_usage_reduction": 3
        },
        "sellCredits": 12500
      },
      {
        "variant": "equipment_aiprotocol_ai-eco11",
        "values": {
          "fuel_usage_reduction": 3.5
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_aiprotocol_ai-eco12",
        "values": {
          "fuel_usage_reduction": 4
        },
        "sellCredits": 112500
      },
      {
        "variant": "equipment_aiprotocol_ai-eco13",
        "values": {
          "fuel_usage_reduction": 6
        },
        "sellCredits": 262500
      }
    ]
  },
  "equipment_aiprotocol_ai-hp1": {
    "kind": "protocol",
    "typeName": "HP_MANAGEMENT",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-hp10",
        "values": {
          "hp_increase": 1
        },
        "sellCredits": 12500
      },
      {
        "variant": "equipment_aiprotocol_ai-hp11",
        "values": {
          "hp_increase": 2
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_aiprotocol_ai-hp12",
        "values": {
          "hp_increase": 4
        },
        "sellCredits": 112500
      },
      {
        "variant": "equipment_aiprotocol_ai-hp13",
        "values": {
          "hp_increase": 5
        },
        "sellCredits": 175000
      }
    ]
  },
  "equipment_aiprotocol_ai-lm1": {
    "kind": "protocol",
    "typeName": "LASER_MANAGEMENT",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-lm10",
        "values": {
          "damage_increase": 1
        },
        "sellCredits": 12500
      },
      {
        "variant": "equipment_aiprotocol_ai-lm11",
        "values": {
          "damage_increase": 2
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_aiprotocol_ai-lm12",
        "values": {
          "damage_increase": 4
        },
        "sellCredits": 112500
      },
      {
        "variant": "equipment_aiprotocol_ai-lm13",
        "values": {
          "damage_increase": 6
        },
        "sellCredits": 187500
      }
    ]
  },
  "equipment_aiprotocol_ai-r1": {
    "kind": "protocol",
    "typeName": "RADAR",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-r10",
        "values": {
          "range": 2
        },
        "sellCredits": 7500
      },
      {
        "variant": "equipment_aiprotocol_ai-r11",
        "values": {
          "range": 6
        },
        "sellCredits": 18750
      },
      {
        "variant": "equipment_aiprotocol_ai-r12",
        "values": {
          "range": 12
        },
        "sellCredits": 62500
      },
      {
        "variant": "equipment_aiprotocol_ai-r13",
        "values": {
          "range": 15
        },
        "sellCredits": 100000
      }
    ]
  },
  "equipment_aiprotocol_ai-sm1": {
    "kind": "protocol",
    "typeName": "SHIELD_MANAGEMENT",
    "levels": [
      {
        "variant": "equipment_aiprotocol_ai-sm10",
        "values": {
          "shield_increase": 1
        },
        "sellCredits": 12500
      },
      {
        "variant": "equipment_aiprotocol_ai-sm11",
        "values": {
          "shield_increase": 2
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_aiprotocol_ai-sm12",
        "values": {
          "shield_increase": 4
        },
        "sellCredits": 112500
      },
      {
        "variant": "equipment_aiprotocol_ai-sm13",
        "values": {
          "shield_increase": 6
        },
        "sellCredits": 187500
      }
    ]
  },
  "equipment_petgear_g-bh1": {
    "kind": "gear",
    "typeName": "HP_BEACON",
    "levels": [
      {
        "variant": "equipment_petgear_g-bh10",
        "values": {
          "duration": 120,
          "fuel_consumption_increase": 30,
          "hpBoostPercent": 3.5,
          "cooldown": 240,
          "radius": 500
        },
        "sellCredits": 50000
      }
    ]
  },
  "equipment_petgear_g-bc1": {
    "kind": "gear",
    "typeName": "COMBAT_BEACON",
    "levels": [
      {
        "variant": "equipment_petgear_g-bc10",
        "values": {
          "duration": 120,
          "fuel_consumption_increase": 30,
          "cooldown": 240,
          "damageBoostPercent": 3.5,
          "radius": 500
        },
        "sellCredits": 50000
      }
    ]
  },
  "equipment_petgear_g-el1": {
    "kind": "gear",
    "typeName": "ENEMY_LOCATOR",
    "levels": [
      {
        "variant": "equipment_petgear_g-el10",
        "values": {
          "multiple_range": 0,
          "range": 2000
        },
        "sellCredits": 15000
      },
      {
        "variant": "equipment_petgear_g-el11",
        "values": {
          "multiple_range": 0,
          "range": 3000
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_petgear_g-el12",
        "values": {
          "multiple_range": 0,
          "range": 5000
        },
        "sellCredits": 93750
      },
      {
        "variant": "equipment_petgear_g-el12X",
        "values": {
          "multiple_range": 0,
          "range": 5000
        },
        "sellCredits": 125000
      }
    ]
  },
  "equipment_petgear_g-fs1": {
    "kind": "gear",
    "typeName": "FRIENDLY_SACRIFICE",
    "levels": [
      {
        "variant": "equipment_petgear_g-fs10",
        "values": {
          "shield_percentage": 30,
          "cooldown": 90,
          "range": 350
        },
        "sellCredits": 22500
      },
      {
        "variant": "equipment_petgear_g-fs11",
        "values": {
          "shield_percentage": 40,
          "cooldown": 75,
          "range": 400
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_petgear_g-fs12",
        "values": {
          "shield_percentage": 50,
          "cooldown": 60,
          "range": 450
        },
        "sellCredits": 112500
      },
      {
        "variant": "equipment_petgear_g-fs13",
        "values": {
          "shield_percentage": 60,
          "cooldown": 45,
          "range": 500
        },
        "sellCredits": 175000
      }
    ]
  },
  "equipment_petgear_g-kk1": {
    "kind": "gear",
    "typeName": "KAMIKAZE",
    "levels": [
      {
        "variant": "equipment_petgear_g-kk10",
        "values": {
          "speed_increase": 15,
          "max_damage": 25000,
          "dmg_reduction": 0.5,
          "hitpoint_percentage": 12.5,
          "player_hp_threshold": 10,
          "cooldown": 120,
          "pet_hp_threshold": 20,
          "min_damage": 200,
          "radius": 163,
          "survival_time": 3
        },
        "sellCredits": 18750
      },
      {
        "variant": "equipment_petgear_g-kk11",
        "values": {
          "speed_increase": 30,
          "max_damage": 45000,
          "dmg_reduction": 0.6,
          "hitpoint_percentage": 16.67,
          "player_hp_threshold": 10,
          "cooldown": 60,
          "pet_hp_threshold": 20,
          "min_damage": 400,
          "radius": 228,
          "survival_time": 4
        },
        "sellCredits": 43750
      },
      {
        "variant": "equipment_petgear_g-kk12",
        "values": {
          "speed_increase": 60,
          "max_damage": 75000,
          "dmg_reduction": 0.75,
          "hitpoint_percentage": 25,
          "player_hp_threshold": 10,
          "cooldown": 30,
          "pet_hp_threshold": 20,
          "min_damage": 400,
          "radius": 293,
          "survival_time": 5
        },
        "sellCredits": 125000
      }
    ]
  },
  "equipment_petgear_g-ar1": {
    "kind": "gear",
    "typeName": "AUTO_RESOURCE_COLLECTION",
    "levels": [
      {
        "variant": "equipment_petgear_g-ar10",
        "values": {
          "multiple_range": 0,
          "range": 700
        },
        "sellCredits": 6250
      },
      {
        "variant": "equipment_petgear_g-ar11",
        "values": {
          "multiple_range": 0,
          "range": 1500
        },
        "sellCredits": 15000
      },
      {
        "variant": "equipment_petgear_g-ar12",
        "values": {
          "multiple_range": 0,
          "range": 3000
        },
        "sellCredits": 43750
      },
      {
        "variant": "equipment_petgear_g-ar12X",
        "values": {
          "multiple_range": 0,
          "range": 3000
        },
        "sellCredits": 62500
      }
    ]
  },
  "equipment_petgear_g-hr1": {
    "kind": "gear",
    "typeName": "HEAT_RELEASE",
    "levels": [
      {
        "variant": "equipment_petgear_g-hr10",
        "values": {
          "duration": 4,
          "damage": 6250,
          "cooldown": 150,
          "range": 150,
          "dmg-reduction": 1,
          "heat-release": 7,
          "hp-inflicted": 2500
        },
        "sellCredits": 25000
      },
      {
        "variant": "equipment_petgear_g-hr11",
        "values": {
          "duration": 4,
          "damage": 8750,
          "cooldown": 120,
          "range": 175,
          "dmg-reduction": 1,
          "heat-release": 7,
          "hp-inflicted": 2800
        },
        "sellCredits": 37500
      },
      {
        "variant": "equipment_petgear_g-hr12",
        "values": {
          "duration": 4,
          "damage": 13000,
          "cooldown": 90,
          "range": 250,
          "dmg-reduction": 1,
          "heat-release": 7,
          "hp-inflicted": 3750
        },
        "sellCredits": 80000
      },
      {
        "variant": "equipment_petgear_g-hr12X",
        "values": {
          "duration": 4,
          "damage": 13000,
          "cooldown": 90,
          "range": 250,
          "dmg-reduction": 1,
          "heat-release": 7,
          "hp-inflicted": 3750
        },
        "sellCredits": 100000
      }
    ]
  },
  "equipment_petgear_g-rl1": {
    "kind": "gear",
    "typeName": "RESOURCE_LOCATOR",
    "levels": [
      {
        "variant": "equipment_petgear_g-rl10",
        "values": {
          "multiple_range": 0,
          "range": 2000
        },
        "sellCredits": 6250
      },
      {
        "variant": "equipment_petgear_g-rl11",
        "values": {
          "multiple_range": 0,
          "range": 3000
        },
        "sellCredits": 15000
      },
      {
        "variant": "equipment_petgear_g-rl12",
        "values": {
          "multiple_range": 0,
          "range": 5000
        },
        "sellCredits": 43750
      },
      {
        "variant": "equipment_petgear_g-rl12X",
        "values": {
          "multiple_range": 0,
          "range": 5000
        },
        "sellCredits": 62500
      }
    ]
  },
  "equipment_petgear_g-tra1": {
    "kind": "gear",
    "typeName": "TRADE_POD",
    "levels": [
      {
        "variant": "equipment_petgear_g-tra10",
        "values": {
          "trade_bonus": 5,
          "cooldown": 300,
          "absent": 300,
          "multiple_absent": 0
        },
        "sellCredits": 15000
      },
      {
        "variant": "equipment_petgear_g-tra11",
        "values": {
          "trade_bonus": 15,
          "cooldown": 120,
          "absent": 120,
          "multiple_absent": 0
        },
        "sellCredits": 31250
      },
      {
        "variant": "equipment_petgear_g-tra12",
        "values": {
          "trade_bonus": 30,
          "cooldown": 30,
          "absent": 30,
          "multiple_absent": 0
        },
        "sellCredits": 93750
      }
    ]
  },
  "equipment_petgear_g-hpl1": {
    "kind": "gear",
    "typeName": "HP_LINK",
    "levels": [
      {
        "variant": "equipment_petgear_g-hpl10",
        "values": {
          "duration": 20,
          "fuel_consumption_increase": 35,
          "cooldown": 240,
          "damage_increase": 25
        },
        "sellCredits": 50000
      }
    ]
  },
  "equipment_petgear_g-rep1": {
    "kind": "gear",
    "typeName": "REPAIR_PET",
    "levels": [
      {
        "variant": "equipment_petgear_g-rep10",
        "values": {
          "duration": 89,
          "hps": 2000
        },
        "sellCredits": 6250
      },
      {
        "variant": "equipment_petgear_g-rep11",
        "values": {
          "duration": 30,
          "hps": 6000
        },
        "sellCredits": 15000
      },
      {
        "variant": "equipment_petgear_g-rep12",
        "values": {
          "duration": 15,
          "hps": 12000
        },
        "sellCredits": 31250
      }
    ]
  },
  "equipment_petgear_cgm-02": {
    "kind": "gear",
    "typeName": "COMBO_GUARD",
    "levels": [
      {
        "variant": "equipment_petgear_cgm-020",
        "values": {
          "fuel_consumption_increase": 35,
          "deflection_chance": 65
        },
        "sellCredits": 50000
      },
      {
        "variant": "equipment_petgear_cgm-021",
        "values": {
          "fuel_consumption_increase": 35,
          "deflection_chance": 75
        },
        "sellCredits": 75000
      },
      {
        "variant": "equipment_petgear_cgm-022",
        "values": {
          "fuel_consumption_increase": 35,
          "deflection_chance": 85
        },
        "sellCredits": 137500
      }
    ]
  },
  "equipment_petgear_g-al1": {
    "kind": "gear",
    "typeName": "AUTO_LOOT",
    "levels": [
      {
        "variant": "equipment_petgear_g-al10",
        "values": {
          "multiple_range": 0,
          "range": 700
        },
        "sellCredits": 18750
      },
      {
        "variant": "equipment_petgear_g-al11",
        "values": {
          "multiple_range": 0,
          "range": 1500
        },
        "sellCredits": 43750
      },
      {
        "variant": "equipment_petgear_g-al12",
        "values": {
          "multiple_range": 0,
          "range": 3000
        },
        "sellCredits": 93750
      },
      {
        "variant": "equipment_petgear_g-al12X",
        "values": {
          "multiple_range": 0,
          "range": 3000
        },
        "sellCredits": 125000
      }
    ]
  },
  "equipment_petgear_csr-02": {
    "kind": "gear",
    "typeName": "COMBO_SHIP_REPAIR",
    "levels": [
      {
        "variant": "equipment_petgear_csr-020",
        "values": {
          "duration": 5,
          "fuel_consumption_increase": 35,
          "deflection_chance": 65,
          "hps": 10000,
          "fuel_usage": 200
        },
        "sellCredits": 50000
      },
      {
        "variant": "equipment_petgear_csr-021",
        "values": {
          "duration": 5,
          "fuel_consumption_increase": 35,
          "deflection_chance": 75,
          "hps": 15000,
          "fuel_usage": 400
        },
        "sellCredits": 75000
      },
      {
        "variant": "equipment_petgear_csr-022",
        "values": {
          "duration": 5,
          "fuel_consumption_increase": 35,
          "deflection_chance": 85,
          "hps": 25000,
          "fuel_usage": 750
        },
        "sellCredits": 137500
      }
    ]
  },
  "equipment_petgear_g-rt1": {
    "kind": "gear",
    "typeName": "RETARGETING",
    "levels": [
      {
        "variant": "equipment_petgear_g-rt10",
        "values": {
          "duration": 30,
          "fuel_consumption_increase": 35,
          "cooldown": 240,
          "damage_increase": 50
        },
        "sellCredits": 50000
      }
    ]
  },
  "equipment_petgear_g-mm1": {
    "kind": "gear",
    "typeName": "MEGA_MINE",
    "levels": [
      {
        "variant": "equipment_petgear_g-mm10",
        "values": {
          "mine_detonationCountdown": 2,
          "mine_damage_per_pulse": 75000,
          "mine_hp": 250000,
          "cooldown": 240,
          "mine_explosionRadius": 500,
          "mine_numberOfPulses": 5
        },
        "sellCredits": 50000
      }
    ]
  }
};

const GEAR_TYPES = Object.freeze({AUTO_LOOT:4,AUTO_RESOURCE_COLLECTION:5,ENEMY_LOCATOR:6,RESOURCE_LOCATOR:7,TRADE_POD:8,REPAIR_PET:9,KAMIKAZE:10,COMBO_SHIP_REPAIR:11,COMBO_GUARD:12,FRIENDLY_SACRIFICE:14,RETARGETING:15,HP_LINK:16,MEGA_MINE:17,COMBAT_BEACON:18,HP_BEACON:19,HEAT_RELEASE:20});
const PROTOCOL_FIELDS = Object.freeze({SALVAGE:['salvage','loot_increase'],CARGO:['cargo','cargo_increase'],ALIEN:['alienDamage','damage_boost'],EVASION:['evasion','opponents_accuracy_reduction'],TARGETING:['accuracy','accuracy_increase'],ECONOMY:['fuelReduction','fuel_usage_reduction'],HP_MANAGEMENT:['hitpoints','hp_increase'],LASER_MANAGEMENT:['laserDamage','damage_increase'],RADAR:['radar','range'],SHIELD_MANAGEMENT:['shield','shield_increase']});
const VARIANTS = new Map();
for(const [root,entry] of Object.entries(DATA))entry.levels.forEach((record,index)=>VARIANTS.set(record.variant,{root,index}));
function deepFreeze(value){for(const child of Object.values(value))if(child&&typeof child==='object')deepFreeze(child);return Object.freeze(value);}
deepFreeze(DATA);
function resolve(item,explicitLevel){
 const row=typeof item==='string'?{loot_id:item}:item;if(!row||typeof row!=='object')return null;
 const id=row.loot_id??row.lootId,variant=VARIANTS.get(id),root=variant?.root??id,entry=DATA[root];if(!entry)return null;
 const requested=explicitLevel??row.pet_level??row.gear_level??row.level;
 const level=requested===undefined?(variant?Math.min(variant.index+1,3+(entry.kind==='protocol'?1:0)):1):Number(requested);
 if(!Number.isInteger(level)||level<1||level>4)return null;
 // The optional 12X gear is a separate item with level-3 stats, not a fourth gear tier.
 const index=variant&&requested===undefined?variant.index:level-1,record=entry.levels[index];if(!record||record.variant.endsWith('X')&&level!==3)return null;
 return {lootId:root,variantId:record.variant,kind:entry.kind,typeName:entry.typeName,level,sellCredits:record.sellCredits,values:{...record.values},special:record.variant.endsWith('X')};
}
function gear(item,level){
 const result=resolve(item,level);if(result?.kind!=='gear')return null;
 const v=result.values,type=GEAR_TYPES[result.typeName];
 return {...result,type,supported:type>=4&&type<=12||type===16,range:v.range??v.radius??0,repair:v.hps??0,damage:v.max_damage??0,radius:v.radius??0,
  durationMs:(v.duration??0)*1000,cooldownMs:(v.cooldown??(type===11?15:0))*1000,absentMs:(v.absent??0)*1000,
  tradeBonus:(v.trade_bonus??0)/100,fuelMultiplier:1+(v.fuel_consumption_increase??0)/100,fuelUsage:v.fuel_usage??0,
  deflectionChance:(v.deflection_chance??0)/100,petHpThreshold:(v.pet_hp_threshold??0)/100,playerHpThreshold:(v.player_hp_threshold??0)/100,
  survivalMs:(v.survival_time??0)*1000,speedBonus:(v.speed_increase??0)/100};
}
function protocol(item,level){
 const result=resolve(item,level);if(result?.kind!=='protocol')return null;
 const field=PROTOCOL_FIELDS[result.typeName];
 return {...result,supported:!!field,effect:field?.[0]??null,bonus:field?(result.values[field[1]]/100):0};
}
function equippedEffects(rows=[]){
 const effects={laserDamage:0,alienDamage:0,shield:0,hitpoints:0,accuracy:0,evasion:0,cargo:0,salvage:0,radar:0,fuelReduction:0,count:0};
 const seen=new Set();
 for(const row of rows){
  if(row?.slot&&row.slot!=='protocol')continue;
  if(row?.id!==undefined){if(seen.has(row.id))continue;seen.add(row.id);}
  const p=protocol(row);if(!p?.supported)continue;
  effects[p.effect]+=p.bonus;effects.count++;
 }
 for(const key of Object.keys(effects))if(key!=='count')effects[key]=Math.round(effects[key]*1e12)/1e12;
 return {...effects,laserDamageMultiplier:1+effects.laserDamage,alienDamageMultiplier:1+effects.alienDamage,shieldMultiplier:1+effects.shield,
  hitpointMultiplier:1+effects.hitpoints,cargoMultiplier:1+effects.cargo,salvageMultiplier:1+effects.salvage,radarMultiplier:1+effects.radar,
  fuelMultiplier:Math.max(0,1-effects.fuelReduction)};
}
function gearForType(rows,type){return rows.filter(row=>!row.slot||row.slot==='gear').map(row=>gear(row)).filter(g=>g?.supported&&g.type===type).sort((a,b)=>b.level-a.level)[0]??null;}
function minimumPetLevel(level){return [1,4,8,20][level-1]??null;}
function canEquip(item,petLevel){const result=resolve(item);return !!result&&Number.isInteger(petLevel)&&petLevel>=minimumPetLevel(result.level);}
function fuelPerMinute(petLevel,rows=[],activeType){
 if(!Number.isInteger(petLevel)||petLevel<1)throw new RangeError('Invalid P.E.T. level.');
 const protocols=rows.filter(row=>!row.slot||row.slot==='protocol').map(row=>protocol(row)).filter(p=>p?.supported);
 const gears=rows.filter(row=>!row.slot||row.slot==='gear').map(row=>gear(row)).filter(g=>g?.supported);
 const economy=equippedEffects(rows).fuelMultiplier,active=gears.find(g=>g.type===activeType);
 return (1+petLevel*2+protocols.length*2+gears.length*4)*economy*(active?.fuelMultiplier??1);
}
// Exact PetAttributes variant capacities; these are maxima, not purchased/unlocked slots.
// The retained client supports eight gears after level 13, unlike the older six-gear FAQ.
const SLOT_TABLE = deepFreeze([
 [1,2,1,2],[2,3,2,3],[2,4,2,4],[3,5,3,5],[3,6,3,6],[4,7,4,7],[4,8,4,8],[5,9,5,9],[5,10,5,10],[6,11,6,11],
 [6,12,6,12],[7,13,7,12],[7,14,7,12],[8,15,8,12],[9,16,8,12],[10,17,8,12],[10,18,8,12],[11,19,8,12],[11,20,8,12],[12,21,8,12],[12,22,8,12]
]);
function slotsAtLevel(level){
 if(!Number.isInteger(level)||!SLOT_TABLE[level])return null;
 const [laser,generator,gear,protocol]=SLOT_TABLE[level];return {laser,generator,gear,protocol,visual:1,heat:7};
}
function entries({supportedOnly=true,variants=false}={}){
 return Object.entries(DATA).flatMap(([id,entry])=>{
  const records=variants?entry.levels.map(record=>record.variant):[id];
  return records.map(id=>entry.kind==='gear'?gear(id):protocol(id)).filter(record=>!supportedOnly||record.supported);
 });
}
module.exports={SOURCE_SHA256,DATA,GEAR_TYPES,PROTOCOL_FIELDS,SLOT_TABLE,resolve,gear,protocol,equippedEffects,gearForType,minimumPetLevel,canEquip,fuelPerMinute,slotsAtLevel,entries};
