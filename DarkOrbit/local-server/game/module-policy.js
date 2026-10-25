'use strict';
// User-requested local economy. Kept separate from the captured original data.
const UPGRADE='resource_upgrade-module',CONVERT='resource_convert-module';
const DEFINITIONS=[
 {id:UPGRADE,name:'Upgrade Module',price:10000,description:'Lazer, kalkan, roketatar ve diroit geliştirmelerinde kullanılır. Gereken adet kalite ve hedef seviyeyle artar.',icon:'/do_img/global/items/resource/upgrade-module_100x100.png'},
 {id:CONVERT,name:'Convert Module',price:10000,description:'Birleştir tariflerinin tek üretim malzemesidir. Gereken adet üretilen eşyanın gücüne göre değişir.',icon:'/do_img/global/items/resource/convert-module_100x100.png'}
];
function registerMetadata(meta){for(const d of DEFINITIONS)meta[d.id]||={kind:'General',lootId:d.id,typeClass:'net.bigpoint.darkorbit.asset.item.ItemType',typeValue:d.id===UPGRADE?'UPGRADE_MODULE':'CONVERT_MODULE',uridium:d.price,maxQuantity:0,isFractionDependent:false,damage:0,stackable:{maxQuantity:1000000000}};return meta;}
function offers(){return Object.fromEntries(DEFINITIONS.map(d=>[d.id,{name:d.name,category:'extras',price:d.price,currency:'real',isPaymentItem:false}]));}
function upgradeTier(recipe){
 const n=Number(recipe.lootId.match(/upgrade-class(\d+)/)?.[1]||0);
 // Classic LF3=2, LF4/Iris=3; newer weapon classes increase progressively.
 return n===0?1:n===1?2:n===2?3:Math.min(12,n+1);
}
function outputUnits(id,meta){
 const m=meta[id]||{},type=m.typeClass?.split('.').at(-1)||'';
 if(type==='ShipType')return /plus|centurion|orcus|solaris/.test(id)?100:Math.max(10,Math.min(75,Math.ceil((m.maxLaser||5)*2)));
 if(m.kind==='Drone')return id==='drone_flax'?2:id==='drone_iris'?4:20;
 if(type==='LaserType')return /lf-5/.test(id)?20:/pr-l|lf-4-(?:hp|md|pd)|os-l|am-l/.test(id)?10:/lf-4/.test(id)?6:/lf-3/.test(id)?3:Math.max(1,Math.ceil((m.damage||100)/100));
 if(type==='ShieldType')return Math.max(1,Math.min(20,Math.ceil((m.output||m.shield||m.capacity||10000)/10000)));
 if(type==='CannonType'||type==='DriveType'||type==='CannonShieldType'||type==='LensType')return 20;
 if(type==='ShipUpgradeType'||type==='QuantumFluidCoreType')return 15;
 if(type==='ShipDesignType')return 20;
 if(/Drone(?:Design|Customization|Formation)Type/.test(type))return 10;
 if(type==='PetType')return 10;
 if(type==='PetGearType'||type==='AIProtocolType')return 5;
 if(/AmmunitionType|SpecialAmmoType/.test(type)||/currency_|resource_pet-fuel|resource_extra-energy/.test(id))return .01;
 const price=m.uridium;
 return Number.isFinite(price)&&price>0&&price<4294967295?Math.max(1,Math.min(100,Math.ceil(price/10000))):1;
}
function transformRecipes(meta){
 registerMetadata(meta);
 const out={};for(const[id,source]of Object.entries(meta)){
  if(source.kind!=='Recipe')continue;
  const r=structuredClone(source);out[id]=r;
  const upgrade=/^upgrade_(?:item|drone)-upgrade$/.test(r.result?.[0]?.lootID);
  if(repeatableEquipment(r,meta)){r.usingStrategy='ALWAYS_USABLE';r.maxUses=2147483647;r.stackable=true;}
  if(r.targets?.length&&!upgrade)continue; // Disassembly/CBS are separate features.
  r.costScalingFactor=1;
  if(upgrade){const tier=upgradeTier(r);for(const c of r.costs){c.parts=[{_class:'BuildPart',lootID:UPGRADE,ammount:tier*Math.ceil(c.level/3)}];c.skipCosts=c.skipCosts?.length?[{_class:'BuildPart',lootID:UPGRADE,ammount:Math.max(1,Math.ceil(tier*c.level/6))}]:[];}}
  else{const units=Math.max(1,Math.ceil((r.result||[]).reduce((sum,p)=>sum+outputUnits(p.lootID,meta)*p.ammount,0)));for(const c of r.costs){c.parts=[{_class:'BuildPart',lootID:CONVERT,ammount:units}];c.skipCosts=c.skipCosts?.length?[{_class:'BuildPart',lootID:CONVERT,ammount:Math.max(1,Math.ceil(units/10))}]:[];}}
 }
 return out;
}
function repeatableEquipment(r,meta){
 return !r.targets?.length&&r.result?.length>0&&r.result.every(p=>{
  const m=meta[p.lootID];return m&&m.maxQuantity!==1&&/\.(?:LaserType|ShieldType|EngineType|HellstormLauncherType|CPUType|RobotType|ExtraType|PetGearType|AIProtocolType|CannonType|DriveType|LensType|CannonShieldType)$/.test(m.typeClass||'');
 });
}
module.exports={UPGRADE,CONVERT,DEFINITIONS,registerMetadata,offers,upgradeTier,outputUnits,transformRecipes,repeatableEquipment};
