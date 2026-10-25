'use strict';
// Reviewed contents from the captured Turkish shop descriptions. No icon is
// treated as a bundle manifest: several icon loot IDs name only a small extra.
const META=require('../docs/client-map.items.json').items;
const normalize=s=>String(s).toLowerCase().replace(/[_\s]/g,'-');
// CC-A/CC-D are portal names; native inventory uses the Spacecup group IDs.
// K-3000M is a typo in the captured Zephyr offer, whose image names K-300M.
const ALIASES={'CC-A':'ammunition_laser_spacecup_group-a','CC-D':'ammunition_laser_spacecup_group-d',
 'SR-5':'ammunition_specialammo_sr-5','K-300M':'ammunition_specialammo_k-300m','K-3000M':'ammunition_specialammo_k-300m'};
function id(code){
 if(ALIASES[code]&&META[ALIASES[code]])return ALIASES[code];
 if(META[code])return code;
 const key=normalize(code),found=Object.keys(META).filter(k=>normalize(k.slice(k.lastIndexOf('_')+1))===key||normalize(META[k].typeValue)===key);
 if(found.length!==1)throw Error(`Payment component is ambiguous or absent: ${code} (${found.length})`);
 return found[0];
}
function items(...pairs){const result={items:{}};for(const [code,n]of pairs){try{result.items[id(code)]=n;}catch{(result.unresolved??=[]).push(code);}}return result;}
const result={};
function bundle(key,...pairs){result[`package_${key}`]=items(...pairs);}
function event(key,...pairs){bundle(`event-deal-${key}`,...pairs);}

bundle('dd-f-01',['drone_designs_frost',1]);
bundle('masqueChimera',['drone_designs_phantom-red',10],['pet_designs_chimera-red',1]);
// The original Tartarus is Hot-Fusion Red (FAQ), matching the captured fiery set.
bundle('expo-tartarus',['ship_tartarus',1],['drone_designs_phantom-red',10],['pet_designs_chimera-red',1]);
for(const [sku,color]of [['01','green'],['02','orange'],['03','red']])bundle(`pd-c-${sku}`,[`pet_designs_chimera-${color}`,1]);
bundle('poisonA-EliteSet',['ship_a-elite_design_a-elite-poison',1],['drone_designs_drone-a-elite-poison',10],['pet_designs_pet-a-elite-poison',1]);
for(const ship of ['pusat','spectrum']){
 event(`poisen${ship==='pusat'?'Pusat':'Spectrum'}Set`,[`ship_${ship}_design_${ship}-poison`,1],[`drone_designs_drone-${ship}-poison`,10]);
 event(`blaze-${ship}-full`,[`ship_${ship}_design_${ship}-blaze`,1],[`drone_designs_drone-${ship}-blaze`,10],[`pet_designs_pet-${ship}-blaze`,1]);
 bundle(`deal-${ship}Chroma`,...['poison','sandstorm','blaze','ocean'].map(color=>[`ship_${ship}_design_${ship}-${color}`,1]));
}
bundle('deal-frozenMirage',...['spectrum','sentinel','venom','v-lightning','pusat','n-ambassador'].map(ship=>[`ship_${ship}_design_${ship}-frost`,1]));
// Official original manifest: board-en.darkorbit.com/threads/stellar-pathfinder-bundles-available-for-a-limited-time-only.124363/
for(const [index,ship,lasers,shields,speeds,iris,ep,seprom,uridium,ammo]of [
 [1,'goliath',5,5,15,2,10240000,3000,5000,0],
 [2,'goliath',10,10,15,4,10240000,3000,100000,0],
 [3,'aegis',20,15,15,4,10240000,3000,200000,50000],
 [4,'hammerclaw',25,25,16,8,327680000,5000,400000,100000],
 [5,'cyborg',25,30,16,8,327680000,10000,400000,200000]]){
 event(`stellar2019-${index}`,[`ship_${ship}`,1],['LF4_UNSTABLE',lasers],['SG3N-B02',shields],['G3N-7900',speeds],['drone_iris',iris],['pet_pet10',1],['SEPROM',seprom],
  ...(index>1?[['equipment_petgear_g-kk1',1]]:[]),...(ammo?[['UCB-100',ammo],['CC-D',25000]]:[]),...(index===5?[['LF4HP',5],['RSB-75',25000]]:[]));
 Object.assign(result[`package_event-deal-stellar2019-${index}`],{ep,uridium,once:true,...(index>1?{petLevels:{'equipment_petgear_g-kk1':3}}:{})});
}
for(const [index,ship,lasers,shields,speeds,ammo,seprom,ep]of [[1,'citadel',20,15,20,50000,3000,10240000],[2,'pusat',25,25,18,100000,5000,327680000],[3,'solace',25,25,18,100000,5000,327680000],[4,'solaris',25,30,16,200000,10000,327680000]]){
 event(`stellar2022-${index}`,[`ship_${ship}`,1],['LF4_UNSTABLE',lasers],['SG3N-B02',shields],['G3N-7900',speeds],['drone_iris',8],['pet_pet10',1],['equipment_petgear_g-kk1',1],['UCB-100',ammo],['CC-D',25000],['SEPROM',seprom],...(index===4?[['LF4HP',5],['RSB-75',25000]]:[]));
 Object.assign(result[`package_event-deal-stellar2022-${index}`],{ep,petLevels:{'equipment_petgear_g-kk1':3}});
}

for(const [size,n]of [['s',1],['m',2],['l',3],['xl',4]]){
 const amount=n===4?20000:n*5000;
 event(`special-gear-${size}`,['SR-5',n===4?300:n*100],['LF-4',n],['RCB-140',amount],['RSB-75',amount],...(n===4?[['UCB-100',20000],['SEPROM',6000]]:[]));
}
event('restabilize-boost',['SALVAGE_CORE',205],['UNSTABLE_SHARD',180],['POLYCHROMIUM',1300],['PERMIT_PLUS',6],['INDOCTRINEOIL',20]);
event('dmg-npc-boosters',['booster_npc-b01',1],['booster_npc-b02',1],['booster_dmg-b01',1],['booster_dmg-b02',1]);
event('dmg-npc-buster',['booster_npc-b01',1],['booster_npc-b02',1],['booster_dmg-b01',1],['booster_dmg-b02',1],['booster_dmg-h01',1],['SBL-100',3000]);
event('dmg-npc-ammo',['booster_npc-b01',1],['booster_npc-b02',1],['SBL-100',2000],['UCB-100',5000],['RSB-75',3000]);
for(const [key,ship]of [['ship-ult-berserker','berserker'],['ship-ult-spectrum','spectrum'],['ult-cyborg','cyborg']])event(key,[`ship_${ship}`,1],['SR-5',200],['IDB-125',10000],['SG3N-B03',1]);
for(const [key,ship]of [['dim','diminisher'],['sent','sentinel'],['pusat','pusat'],['zeph','zephyr']])event(`aa-feature-${key}-2023`,[`ship_${ship}`,1],['resource_booty-key-astral-prime',1]);
event('basilisk',['ship_basilisk',1]);
event('firepower',['LF4HP',2],['LF4MD',2],['AXION',85],['INDOCTRINEOIL',8]);
event('resistance',['SG3N-B03',3],['AXION',120],['OSMIUM',2500]);
for(const [key,ship]of [['phantasm-berserker','berserker'],['phantasm-sentinel','sentinel']])event(key,[`ship_${ship}_design_${ship}-phantasm`,1],['SBL-100',1250],['JOB-100',2000]);
event('phantasm-fullpack',['ship_berserker_design_berserker-phantasm',1],['ship_sentinel_design_sentinel-phantasm',1],['SBL-100',2500],['JOB-100',4000]);
for(const [key,ship]of [['dusklight-cyborg','cyborg'],['dusklight-berserker','berserker'],['dusklight-spectrum-p','spectrum-plus']])event(key,[`ship_${ship}_design_${ship}-dusklight`,1],['SBL-100',1250]);
event('dusklight-spectrum',['ship_spectrum_design_spectrum-dusklight',1],['UCB-100',10000],['SAR-02',2500],['SR-5',100]);
event('team-dusklight',['ship_spectrum_design_spectrum-dusklight',1],['ship_cyborg_design_cyborg-dusklight',1],['SBL-100',2500]);
event('dusklight-double',['ship_spectrum-plus_design_spectrum-plus-dusklight',1],['ship_berserker_design_berserker-dusklight',1],['SBL-100',2500]);
event('dusklight-hecate-plus',['ship_hecate-plus_design_hecate-plus-dusklight',1],['SPC-SPD01',1],['DCR-250',150]);
event('dusk-citadel-plus',['ship_citadel-plus_design_citadel-plus-dusklight',1],['SPC-C02',1],['DCR-250',150]);
event('aa-sent-design-2024',['ship_sentinel_design_sentinel-nobilis',1],['ship_sentinel_design_sentinel-harbinger',1],['ship_sentinel_design_sentinel-frost',1],['DCR-250',200],['UCB-100',20000]);
event('aa-dim-design-2024',['ship_diminisher_design_diminisher-nobilis',1],['ship_diminisher_design_diminisher-legend',1],['ship_diminisher_design_diminisher-frost',1],['DCR-250',200],['UCB-100',20000]);
event('halloween-tech',['tech_battle-repair-bot2',5],['tech_shield-backup2',10],['tech_energy-leech',10],['tech_frost-field',10],['OSMIUM',1000]);
event('halloween-ammo-pack',['K-300M',1500],['CC-A',4000],['RSB-75',4000],['SBL-100',3500]);
event('halloween-mega-pack',['booster_dmg-b02',1],['booster_shd-b02',1],['booster_cd-b02',1],['SBL-100',10000],['tech_anti-mine-transmitter',10]);
event('orcus-bundle',['ship_orcus',1],['resource_booty-key-blacklight-cipher',2],['resource_booty-key-blacklight-decoder',3]);
event('dusklight-fullpack',['ship_hecate_design_hecate-dusklight',1],['ship_spectrum_design_spectrum-dusklight',1],['equipment_aiprotocol_ai-sm1',1],['UCB-100',5000],['resource_booty-key-perseus',5]);
Object.assign(result['package_event-deal-dusklight-fullpack'],{energy:100,petLevels:{'equipment_aiprotocol_ai-sm1':4}});
event('aa-zephyr-design-2024',['ship_zephyr_design_zephyr-ullrin',1],['ship_zephyr_design_zephyr-nobilis',1],['K-3000M',700],['UCB-100',10000]);
event('aa-pusat-design-2024',['ship_pusat_design_pusat-poison',1],['ship_pusat_design_pusat-inferno',1],['ship_pusat_design_pusat-carbonite',1],['K-300M',700],['UCB-100',10000]);
event('bp-halloween',['resource_battle-pass',1],['SBL-100',3500],['resource_battle-pass-key',5]);
event('halloween-discovery',['resource_booty-key',100],['SEPROM',5000],['UCB-100',25000],['RSB-75',15000],['RINUSK',3000],['resource_logfile',500],['AXION',1000]);
result['package_event-deal-halloween-discovery'].uridium=150000;
event('halloween-s-corn-pack',['GOLDEN_CANDY_CORN',5],['CANDY_CORN',1000],['JOB-100',5000],['WIZ-X',1]);
event('halloween-corn-pack',['GOLDEN_CANDY_CORN',50],['CANDY_CORN',50000],['SBL-100',12500],['WIZ-X',10],['tech_anti-mine-transmitter',1]);
event('halloween-l-corn-pack',['GOLDEN_CANDY_CORN',120],['CANDY_CORN',100000],['UCB-100',25000],['WIZ-X',15],['tech_anti-mine-transmitter',1],['SEPROM',3000]);
for(const [size,iac,permit,diam]of [['s',15,2,50],['m',50,5,120],['l',120,20,400],['xl',250,50,1000]])event(`levelup-${size}`,['INDOCTRINE_ACCELERATOR',iac],['PERMIT_PLUS',permit],['DIAMETRION',diam]);
for(const [size,plate,abr,diam]of [['s',5000,0,0],['m',7500,200,0],['l',10000,300,300]])event(`lf5al-${size}`,['equipment_weapon_laser_lf-5-al',1],['PLATE',plate],...(abr?[['AXION',abr]]:[]),...(diam?[['DIAMETRION',diam]]:[]));
event('season-point-lf5mf',['equipment_weapon_laser_lf-5-mf',1],['resource_season-pass-point',1200]);
event('laser-osl-triple',['equipment_weapon_laser_os-l',3]);
event('powerup-ammo-25',['UCB-100',50000],['RCB-140',20000],['SAB-50',10000],['PLT-2021',5000],['HSTRM-01',5000]);
result['package_event-deal-powerup-uri-25']={uridium:300000,items:{}};
// Explicit hours avoid rounding the five-hour shield booster to a ten-hour item.
result['package_event-deal-powerup-booster-25']={items:{},boosterHours:{'booster_npc-b01':20,'booster_npc-b02':10,'booster_dmg-b01':10,'booster_dmg-b02':10,'booster_dmg-h01':10,'booster_shd-b02':5}};
for(const [key,color,n,alloy]of [['g','green',5,0],['b-s','blue',1,0],['b-m','blue',5,3500],['b-l','blue',10,7000],['p-s','purple',1,0],['p-m','purple',3,4250],['p-l','purple',5,8500],['r-s','red',1,0],['r-m','red',3,5000],['r-l','red',5,10000]])event(`dse-key-${key}`,[`resource_echo-key-${color}`,n],...(alloy?[['ALLOY',alloy]]:[]));
for(const [key,red,purple,blue,alloy]of [['1',1,3,10,20000],['2',3,5,0,30000],['3',0,3,10,15000]])event(`dse-key-mix-${key}`,['ALLOY',alloy],...(red?[['resource_echo-key-red',red]]:[]),...(purple?[['resource_echo-key-purple',purple]]:[]),...(blue?[['resource_echo-key-blue',blue]]:[]));
for(const [key,n]of [['armory-token',10],['armory-token-m',50],['armory-token-l',100]])event(key,['ARMORY_TOKEN',n]);
for(const [key,n]of [['mega-armory-token',1],['mega-armory-token-s',10],['mega-armory-token-m',50],['mega-armory-token-l',100]])event(key,['ARMORY_TOKEN_MEGA',n]);
event('trinity-token',['TRINITY_TOKEN',1]);
for(const [size,n]of [['s',1],['m',10],['l',50],['xl',100]])event(`xyralith-${size}`,['XYRALITH',n]);
event('tt-ammo-2604',['resource_trinity-vip-badge',1],['TRINITY_TOKEN',5],['THS-A04',1000],['COS-A04',1000]);
event('tt-resource-2604',['resource_trinity-vip-badge',1],['TRINITY_TOKEN',5],['XYRALITH',10],['QUANTUM_PRISM',10]);
event('tt-coupon-2604',['TRINITY_TOKEN',10],['THS-B03',5000],['COS-B03',5000]);
event('tt-mix-2604',['TRINITY_TOKEN',10],['XYRALITH',10],['QUANTUM_PRISM',10],['THS-A04',1000],['COS-A04',1000]);
event('voyagers-vip-badge',['resource_voyagers-vip-badge',1]);
event('voyagers-vip-special',['resource_voyagers-vip-badge',1],['AGS-X',1],['GSP-300',1000]);
for(const [size,n,h]of [['s',50,500],['m',200,2500],['l',500,5000]])event(`voyagers-resource-${size}`,['CONTAINMENT_NODE',n],['HORIZON_SHARD',h]);
event('voyagers-ammo',['equipment_weapon_drive_igd-p',1],['GSP-300',1000],['GSP-150',10000]);
event('voyagers-artificer',['equipment_weapon_drive_igd-p',1],['CONTAINMENT_NODE',300],['HORIZON_SHARD',5000]);
event('trinity-vip-discount',['resource_trinity-vip-badge',1]);
for(const kind of ['hp','shd','dmg','spc'])event(`modules-resource-${kind}`,[`equipment_shipupgrade_${kind}-xv03`,2],['OBR-100',1000],['GSP-300',1000]);
// These packets offer an inventory pass. Their online/event activation is not
// implied by inventory ownership and is identified in the local catalogue.
event('goldpass',['resource_gold-pass',1]);event('extra-goldpass',['resource_ext-gold-pass',1]);
event('double-goldpass',['resource_gold-pass',1],['resource_ext-gold-pass',1]);
event('goldpass-premium',['resource_gold-pass',1],['resource_season-pass-point',600],['DCR-250',150],['RSB-75',10000]);
event('wholesome-goldpass',['resource_gold-pass',1],['resource_ext-gold-pass',1],['resource_season-pass-point',1200],['DCR-250',200],['RSB-75',15000]);
event('wholesome-extrapass',['resource_ext-gold-pass',1],['resource_season-pass-point',1000],['DCR-250',200],['RSB-75',15000]);
result['deal_booty-key-overhaul-march-red']=items(['resource_booty-key-red',1]);
result['deal_booty-key-overhaul-march-blue']=items(['resource_booty-key-blue',1]);
module.exports={recipes:result,id};
