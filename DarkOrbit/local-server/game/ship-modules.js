'use strict';
// Stable module rules: official FAQ; current edition effects/ship whitelist
// verified against shipped resource_items.xml. Never inherit Plus compatibility.
const META=require('../docs/client-map.items.json').items,PREFIX='equipment_shipupgrade_';
const groups={vp:['vengeance','v-lightning','v-adept','v-avenger','v-corsair','v-revenge','pusat'],cit:['citadel','citadel-plus','c-veteran','c-elite'],spear:['spearhead','s-elite','s-veteran'],gol:['goliath','goliath-plus','g-bastion','g-centaur','g-champion','g-enforcer','g-exalted','g-goal','g-ignite','g-kick','g-peacemaker','g-referee','g-saturn','g-sovereign','g-surgeon','g-vanquisher','g-veteran','goliath-x']};
const rows=[
 ['dmg-mtch01','DAMAGE',['hammerclaw','hammerclaw-plus','mimesis','tartarus','tartarus-plus',...groups.cit],{damage:7}],
 ['dmg-sg01','DAMAGE',['goliath-x','goliath','goliath-plus',...groups.spear,'spearhead-plus','sentinel','solace','solace-plus'],{damage:5}],
 ['spc-c01','SPECIAL',groups.cit,{laserAccuracy:5,rocketAccuracy:5}],
 ['spc-c02','SPECIAL',groups.cit,{laserAccuracy:10,rocketAccuracy:10,hit:-5}],
 ['dmg-vp01','DAMAGE',groups.vp,{damage:10}],['hp-vp01','HP',groups.vp,{hit:15}],
 ['spc-xp01','SPECIAL',['leonov','bigboy','bb-solemn','nostromo','n-ambassador','n-diplomat','n-envoy','piranha','phoenix'],{ep:20},16],
 ['spc-xp02','SPECIAL',groups.gol,{ep:15},16],['hp-s01','HP',groups.spear,{hit:15}],
 ['dmg-t01','DAMAGE',['tartarus'],{damage:10,hit:-8}],['dmg-t02','DAMAGE',['tartarus'],{damage:12,shield:-12}],
 ['shd-t01','SHIELD',['tartarus'],{shield:15,evasion:10,hit:-10}],
 ['dmg-ms01','DAMAGE',['mimesis'],{damage:10,hit:-8,evasion:5}],['dmg-ms02','DAMAGE',['mimesis'],{damage:12,shield:-5,evasion:5}],['shd-ms01','SHIELD',['mimesis'],{shield:8,hit:-5,evasion:5}],
 ['hp-ham01','HP',['hammerclaw','aegis'],{hit:15}],['dmg-leo01','DAMAGE',['leonov'],{rocketDamage:30,laserAccuracy:20}],
 ['shd-dim01','SHIELD',['diminisher'],{shield:25}],['spc-roc01','SPECIAL',['solaris','disruptor','zephyr','spectrum','tartarus'],{rocketDamage:4,rocketAccuracy:4}],
 ['spc-spe01','SPECIAL',['spectrum'],{shield:10,rocketDamage:20}],['shd-gol01','SHIELD',['goliath','goliath-x','goliath-plus','g-champion'],{shield:5,evasion:5}],
 ['dmg-st01','DAMAGE',['spectrum','tartarus'],{damage:8}],['hp-dim01','HP',['diminisher'],{hit:10}],
 ['dmg-sdz01','DAMAGE',['solaris','disruptor','zephyr'],{damage:4}],['hp-c01','HP',groups.cit,{hit:10}],
 ['spc-eva01','SPECIAL',['g-bastion','g-enforcer','disruptor','g-saturn'],{evasion:10}],
 ['hp-bes01','HP',['g-bastion','g-enforcer','g-saturn'],{hit:20}],['hp-t01','HP',['tartarus'],{hit:25}],['spc-sl01','SPECIAL',['sentinel','solace'],{shield:-5,laserAccuracy:5,rocketAccuracy:5}],
 // Captured resource_items.xml supplies these later stable-module effects.
 ['shd-c01','SHIELD',groups.cit,{shield:15,damage:5,hit:-5}],['hp-sol01','HP',['solace'],{hit:15}]
];
const DEFINITIONS=Object.fromEntries(rows.map(([slug,kind,ships,effects,maxLevel])=>[PREFIX+slug,{slug,kind,ships:ships.map(s=>'ship_'+s),effects,maxLevel}]));
// Original icons.swf bitmaps124/125/122/121: green/red/blue/yellow.
const ICONS={HP:1,DAMAGE:2,SHIELD:3,SPECIAL:4};
function definition(id){return DEFINITIONS[id];}
function capacity(ship){return META[ship]?.slotable?.slots.find(s=>s.name==='ship_upgrades')?.size||0;}
function ships(d){return d.ships;}
function compatible(id,ship){const d=definition(id);return !!d&&ships(d).includes(ship);}
function validate(ship,items,{ignoreCapacity=false}={}){const mods=items.filter(i=>i.slot==='ship_upgrade');if(!ignoreCapacity&&mods.length>capacity(ship))throw Error('Gemi modülü yuvası yetersiz.');const classes=new Set();for(const i of mods){const d=definition(i.loot_id);if(!compatible(i.loot_id,ship))throw Error('Bu modül seçili gemiye takılamaz.');if(classes.has(d.kind))throw Error('Aynı sınıftan yalnızca bir gemi modülü takılabilir.');classes.add(d.kind);}return mods;}
function effects(ship,items,level=1){const out={},used=new Set();for(const i of items.filter(i=>i.slot==='ship_upgrade').slice(0,capacity(ship))){const d=definition(i.loot_id);if(!compatible(i.loot_id,ship)||used.has(d.kind))continue;used.add(d.kind);if(d.maxLevel&&level>d.maxLevel)continue;for(const[k,v]of Object.entries(d.effects))out[k]=(out[k]||0)+v/100;}return out;}
function describe(id){const d=definition(id);if(!d)return '';const names={damage:'Silah hasarı',rocketDamage:'Roket hasarı',hit:'Darbe puanı',shield:'Kalkan',laserAccuracy:'Lazer isabeti',rocketAccuracy:'Roket isabeti',evasion:'Kaçınma',ep:'Tecrübe'};return Object.entries(d.effects).map(([k,v])=>(v>0?'+':'')+v+'% '+names[k]).join(', ')+'. Uygun gemiler: '+ships(d).map(s=>s.slice(5)).join(', ')+(d.maxLevel?'. En fazla oyuncu seviyesi: '+d.maxLevel:'')+'.';}
function offers(){const old=require('../web/portal/shop.json');return Object.fromEntries(Object.entries(DEFINITIONS).map(([id,d])=>[id,{...(old[id]||{price:1000000,currency:'real',localFixedPrice:true}),name:d.slug.toUpperCase(),category:'extras',isPaymentItem:false,localShipModule:true}]));}
function portalItem(id){const d=definition(id);if(!d)return {};const names={hit:'HITPOINTS',damage:'DAMAGE',shield:'SHIELD',evasion:'EVASION',laserAccuracy:'HITCHANCE_LASER',rocketAccuracy:'HITCHANCE_ROCKET',rocketDamage:'DMG_ROCKETS',ep:'EXPERIENCE'};return {SUS:ships(d).join(','),SUM:Object.entries(d.effects).map(([k,v])=>names[k]+','+v).join(';')};}
function command(p){const inv=require('./inventory'),db=require('./db').open(),ship=db.prepare('SELECT loot_id FROM ships WHERE id=?').get(p.shipId).loot_id,items=inv.equipped(db,p.shipId,inv.activeConfig(db,p.shipId));return {_:'ShipUpgradeModuleUpdateCommand',uid:p.userId,max:capacity(ship),moduleTypeIds:items.filter(i=>i.slot==='ship_upgrade'&&compatible(i.loot_id,ship)).map(i=>ICONS[definition(i.loot_id).kind])};}
module.exports={DEFINITIONS,definition,capacity,ships,compatible,validate,effects,describe,offers,portalItem,command};
