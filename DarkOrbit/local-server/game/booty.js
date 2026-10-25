'use strict';
// Actual client box/key contracts. Classic contents are a SUPPORTED SUBSET with
// explicit local weights; unpublished original booty probabilities are unknown.
const {open}=require('./db'),loot=require('./loot-rewards');
const PROVENANCE='classic-booty-subset-local-odds-v1';
const TYPES={
 PIRATE_BOOTY:{key:'resource_booty-key',counter:'BK'},
 PIRATE_BOOTY_GOLD:{key:'resource_booty-key',counter:'BK'},
 PIRATE_BOOTY_RED:{key:'resource_booty-key-red',counter:'BKR'},
 PIRATE_BOOTY_BLUE:{key:'resource_booty-key-blue',counter:'BKB'}
};
// Each integer is a local weight, not a recovered official drop percentage.
const common=[
 [30,{items:{'ammunition_laser_mcb-25':1000}}],[25,{items:{'ammunition_laser_mcb-50':500}}],
 [15,{items:{'ammunition_rocket_plt-2021':100}}],[10,{items:{'ammunition_mine_acm-01':50}}],
 [10,{items:{resource_logfile:5}}],[8,{energy:10}],
 [2,{items:{'equipment_weapon_laser_lf-4':1}}]
];
const pools={
 PIRATE_BOOTY:[...common,[5,{items:{'equipment_weapon_laser_lf-3':1}}],[5,{items:{'equipment_generator_shield_sg3n-b02':1}}],[3,{items:{'resource_blueprint_apis-part':1}}]],
 PIRATE_BOOTY_GOLD:[...common,[3,{items:{'resource_blueprint_apis-part':1}}],[6,{items:{'resource_blueprint_zeus-part':1}}]],
 // Red/blue use matching keys and distinct local pools. These intentionally do
 // not pretend to reproduce the rotating 2017/2026 PET/material event tables.
 PIRATE_BOOTY_RED:[...common,[8,{items:{'equipment_weapon_laser_lf-3':1}}]],
 PIRATE_BOOTY_BLUE:[...common,[6,{items:{'equipment_weapon_laser_lf-4':1}}]]
};
function type(box){return TYPES[box?.boxType]||null;}
function buildInit(player,db=open()){
 return ['PIRATE_BOOTY','PIRATE_BOOTY_RED','PIRATE_BOOTY_BLUE'].map(t=>({_:'LegacyModule',message:`0|A|${TYPES[t].counter}|${loot.count(db,player.userId,TYPES[t].key)}`}));
}
function notify(world,send=world.combat?.send||require('./net').sendCmd){for(const c of buildInit(world.player))world.broadcast(s=>send(s,c));}
function canOpen(world,box){const t=type(box);return !!t&&loot.count(open(),world.player.userId,t.key)>0;}
function roll(box,player,random=Math.random){
 const db=open(),list=pools[box.boxType];if(!list)throw Error('Unknown booty box');
 const eligible=list.filter(([,reward])=>Object.entries(reward.items||{}).every(([id,amount])=>{
  const meta=require('../docs/client-map.items.json').items[id],max=Math.min(2147483647,meta?.maxQuantity||2147483647,meta?.stackable?.maxQuantity||2147483647);
  return db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(player.userId,id).n+amount<=max;
 })&&(!reward.energy||(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(player.userId)?.energy||0)+reward.energy<=2147483647));
 const total=eligible.reduce((n,[weight])=>n+weight,0),r=random();if(!(r>=0&&r<1)||!total)throw Error('Invalid booty selection');
 let n=r*total;for(const [weight,reward]of eligible){n-=weight;if(n<0)return structuredClone(reward);}
 throw Error('Empty booty selection');
}
function populate(collect){
 const w=collect.world,p=w.player,m=require('./maps').getMap(p.mapId);
 if(!require('./normal-map-layout').maps.some(row=>row.id===p.mapId)||m.is_start)return;
 const cfg=w.config.booty||{},colors=['PIRATE_BOOTY'];
 if(cfg.zeusEvent===true)colors.push('PIRATE_BOOTY_GOLD');
 if(cfg.redBlueEvent===true)colors.push('PIRATE_BOOTY_RED','PIRATE_BOOTY_BLUE');
 for(const boxType of colors)for(let i=0;i<(cfg.boxesPerColor??6);i++)collect.add({x:Math.round(800+Math.random()*(m.width-1600)),y:Math.round(800+Math.random()*(m.height-1600)),boxType,booty:true,respawnMs:cfg.respawnMs??60000},false);
}
module.exports={PROVENANCE,TYPES,type,buildInit,notify,canOpen,roll,populate};
