'use strict';
// Capability inventory, separate from price/ownership eligibility. A stored
// resource or cosmetic is not an unsupported action. Unclassified types are
// reported for review and are never silently denied merely by their type.
const META=require('../docs/client-map.items.json').items;
const reason={
 'equipment_extra_cpu_g3x-amry-s':'Bu sürümde cephane deposu sınırsız; küçük cephanelik genişleticisi ek kapasite sağlamadığı için satın alma kapalı.',
 'equipment_extra_cpu_g3x-amry-m':'Bu sürümde cephane deposu sınırsız; orta cephanelik genişleticisi ek kapasite sağlamadığı için satın alma kapalı.',
 'equipment_extra_cpu_g3x-amry-l':'Bu sürümde cephane deposu sınırsız; büyük cephanelik genişleticisi ek kapasite sağlamadığı için satın alma kapalı.',
 'equipment_extra_cpu_anti-z1':'Anti-Z1 enfeksiyon giderir; yerel enfeksiyon/tedavi sistemi henüz uygulanmadığı için satın alma kapalı.',
 'equipment_extra_cpu_anti-z1-xl':'Anti-Z1 XL enfeksiyon giderir; yerel enfeksiyon/tedavi sistemi henüz uygulanmadığı için satın alma kapalı.',
 'equipment_extra_cpu_rd-x':'RD-X diplomasi göstergesidir; klan ve diplomasi sistemi henüz uygulanmadığı için satın alma kapalı.',
 'equipment_extra_cpu_pa-x':'PA-X PvP hedefleme CPU’sudur; PvP henüz uygulanmadığı için satın alma kapalı.',
 'captain_captain-generic':'NOVA ajanı beceri ve enerji yönetimi gerektirir; ajan sistemi henüz uygulanmadığı için satın alma kapalı.',
 'equipment_shipupgrade_spc-xp01':'SPC-XP01 uygun gemilerde 16. seviyeye kadar %20 tecrübe sağlar; modülün bu etkisi henüz uygulanmadığı için satın alma kapalı.',
 'equipment_shipupgrade_spc-xp02':'SPC-XP02 uygun gemilerde 16. seviyeye kadar %15 tecrübe sağlar; modülün bu etkisi henüz uygulanmadığı için satın alma kapalı.'
};
const HANDLERS={
 LaserType:'stats / modern-lasers / combat',HellstormLauncherType:'hellstorm.hardware / fire',EngineType:'stats.computeStats',ShieldType:'stats.computeStats / fusion-shields',
 DroneType:'drones.addOwned / statItems / buildCommands',DroneFormationType:'drones.selectFormation / applyStats / tick',
 ShipDesignType:'inventory.addDesign / changeDesign / shipAppearance',DroneCustomizationType:'drones.move / designId / views',DroneDesignType:'drones.move / effects / views',
 PetType:'pet.addOwned / launch / tick',RobotType:'core repair / cpu.rb-x',ModuleType:'cpu.cloak',UpgradeType:'stats.cargoMax',
 CannonType:'advanced-weapons.fireCannon',DriveType:'advanced-weapons.fireDrive',CannonShieldType:'advanced-weapons.defenseDamage',LensType:'stats.driveDefense',
 PetCustomizationType:'pet.appearance',PetDesignType:'pet.appearance'
};
const HULL_ONLY=new Set(['ship_pusat','ship_goliath','ship_vengeance','ship_bigboy','ship_nostromo','ship_piranha','ship_phoenix','ship_liberator','ship_g-ignite','ship_n-ambassador','ship_n-diplomat','ship_n-envoy']);
const PASSIVE_ONLY=new Set(Object.keys(require('./ship-passives').DEFINITIONS).filter(id=>!require('./data/ship-abilities.json').ships[id]?.length));
const CLASSIC=new Set([...require('./ship-abilities').DEFINITIONS,...require('./ship-abilities-expanded').DEFINITIONS].map(d=>d.ship));
function canonical(id,offer={}){
 if(META[id])return id;
 if(offer.category==='booster')return Object.keys(META).find(key=>META[key].kind==='Booster'&&String(META[key].boosterId)===String(id))||id;
 if(offer.category==='drone')return {'1':'drone_flax','2':'drone_iris'}[id]||id;
 return id;
}
function result(id,status,handler,note=''){const item=META[id];return {lootId:id,type:item?.typeClass?.split('.').at(-1)||'Unknown',status,handler,note};}
function classify(id,offer={}){
 if(require('./pet-progression').hpLevel(id)!==null)return result(id,'implemented','pet-progression.buyHp','P.E.T. seviyesine kadar sırayla satın alınan can kapasitesi.');
 if(require('./module-policy').DEFINITIONS.some(d=>d.id===id))return result(id,'implemented','module-policy / assembly','');
 id=canonical(id,offer);const item=META[id];
 if(!item)return result(id,'unverified','', 'İstemci türü bulunamadı; manuel inceleme gerekiyor.');
 if(require('./equipment-policy').removed(id))return result(id,'unsupported','',require('./equipment-policy').REASON);
 if(require('./ship-modules').definition(id))return result(id,'implemented','ship-modules / inventory / stats / combat');
 if(reason[id])return result(id,'unsupported','',reason[id]);
 const type=item.typeClass?.split('.').at(-1);
 if(item.kind==='Booster'){
  const why=require('./boosters').unsupportedReason(id);
  if(why)return result(id,'unsupported','boosters.unsupportedReason',id==='booster_prc-b00'?'PRC ganimet/özel ödül olasılığını artırır; bu düşüş sistemi henüz uygulanmadığı için satın alma kapalı.':id==='booster_dmg-pvp01'?'Bu destek yalnız PvP hasarını artırır; PvP henüz uygulanmadığı için satın alma kapalı.':why);
  const shared=item.boostList?.some(b=>b.areaFactor>0);
  return result(id,shared?'partial':'implemented','boosters.addOwned / applyStats / applyReward',shared?'Sahibinin desteği çalışır; yakındaki oyunculara paylaşılan destek çok oyunculu sistemle birlikte tamamlanacak.':'');
 }
 if(type==='ShipType'){
  if(id==='ship_hecate')return result(id,'partial','ship-passives / stats','%7 hasar ve %10 kalkan pasifi çalışır. Particle Beam yalnız oyuncu hedefleri içindir; PvP henüz uygulanmadı.');
  if(CLASSIC.has(id))return result(id,'partial','ship-passives / ship-abilities / ship-abilities-expanded / stats','Gövde ve tanımlı solo yetenekler çalışır. Bazı ek yetenekler ile grup/PvP etkileşimleri henüz uygulanmadı.');
  if(HULL_ONLY.has(id)||PASSIVE_ONLY.has(id))return result(id,'implemented','stats / inventory / ship-passives');
  return result(id,'partial','stats / inventory / ship-passives','Gövde ve doğrulanmış pasif bonuslar kullanılabilir; bu geminin özel yetenek veya harita/grup/PvP etkileri henüz tamamlanmadı.');
 }
 if(type==='CPUType'){
  const cpu=require('./cpu-catalog').CATALOG[id];
  return result(id,cpu?.status==='implemented'?'implemented':cpu?.status==='unboundedAmmoModel'?'partial':'unverified','cpu / jump-cpu / combat-utilities / hellstorm',cpu?.status==='unboundedAmmoModel'?'Yerel cephane deposu sınırsız olduğu için bu kapasite genişleticisinin ek etkisi yok.':'');
 }
 if(type==='PetGearType'||type==='AIProtocolType')return require('./pet-shop').offers()[id]?result(id,'implemented','pet-shop.quote / pet.stats / pet.tick'):result(id,'unsupported','', 'Bu P.E.T. modülünün etkisi henüz uygulanmadığı için satın alma kapalı.');
 if(type==='AmmunitionType'||type==='SpecialAmmoType'){
  const menu=require('./menu-capabilities').capability(id);
  if(menu?.status&&menu.status!=='unsupported')return result(id,menu.status,menu.handler,menu.reason||'');
  if(id==='ammunition_mine_im-01')return result(id,'unsupported','','IM-01 enfeksiyon mayınıdır; enfeksiyon sistemi henüz uygulanmadığı için satın alma kapalı.');
  if(id==='ammunition_specialammo_wiz-x')return result(id,'unsupported','','WIZ-X hedefin görünüşünü geçici değiştirir; bu dönüşüm etkisi henüz uygulanmadığı için satın alma kapalı.');
  return result(id,'unverified','combat / hellstorm / advanced-weapons / combat-utilities','Cephanenin eylem tüketicisi ayrıca incelenmeli.');
 }
 if(type==='ItemType'||type==='HardwareType'||type==='OreType'){
  if(id==='resource_pet-fuel')return result(id,'implemented','pet.addFuel / tick');
  if(id==='resource_logfile')return result(id,'implemented','skills pilot-point purchase');
  if(/^resource_booty-key(?:-red|-blue)?$/.test(id))return result(id,'implemented','booty / loot-rewards.consumeKey');
  if(/(?:pass|vip-badge|season-pass-point)$/.test(id))return result(id,'partial','payment-events','Bilet/puan yerel sezon yolunda kullanılır; etkinlik ilerlemesi yerel uyarlamadır.');
  if(/^resource_(?:echo-key-|key_access-dse)/.test(id))return result(id,'collectible','inventory / payment / assembly','Anahtar depolanır; ilgili etkinlik haritası/kutusu henüz uygulanmadı.');
  return result(id,'collectible','assembly / payment-events / inventory','Malzeme depolanır; yalnız tanımlı tarif/takaslarda tüketilir.');
 }
 if(HANDLERS[type])return result(id,'implemented',HANDLERS[type]);
 if(type==='TechType')return result(id,require('./techs').recognizes(id)?'implemented':'unsupported','techs',require('./techs').recognizes(id)?'':'Bu teknolojinin etkisi henüz uygulanmadığı için satın alma kapalı.');
 if(type==='ShipUpgradeType')return result(id,'unsupported','','Bu gemi yükseltme modülünün istatistik etkisi henüz uygulanmadığı için satın alma kapalı.');
 return result(id,'unverified','','Tür için tüketici henüz doğrulanmadı; otomatik olarak işlevsiz sayılmadı.');
}
function inspect(id,offer={}){
 if(!offer.localPayment)return classify(id,offer);
 const record=require('./payment').entry(offer.paymentSku||id),why=require('./payment').reason(record);
 if(why)return {lootId:id,type:'PaymentBundle',status:'unavailable',handler:'payment.reason',note:why,components:[]};
 const ids=[...new Set([...Object.keys(record.contents.items||{}),...Object.keys(record.contents.boosterHours||{})])];
 const components=ids.map(id=>classify(id));
 const blocked=components.find(r=>r.status==='unsupported'),uncertain=components.some(r=>['partial','unverified','collectible'].includes(r.status));
 const notes=[...new Set(components.filter(r=>['partial','collectible','unverified'].includes(r.status)).map(r=>r.note).filter(Boolean))];
 return {lootId:id,type:'PaymentBundle',status:blocked?'unsupported':uncertain?'partial':'implemented',handler:'payment.fulfil',note:blocked?.note||notes.join(' '),components};
}
function purchaseReason(id,offer={}){const sales=require('./laser-sales').reason(id,offer);if(sales)return sales;const row=inspect(id,offer);return row.status==='unsupported'?row.note:null;}
function decorateOffers(offers){for(const[id,offer]of Object.entries(offers)){const row=inspect(id,offer);offer.capability=row;offer.disabledReason||=require('./laser-sales').reason(id,offer)||(row.status==='unsupported'?row.note:null);}return offers;}
function decorateRow(row,sku){
 const record=require('./payment').entry(sku),id=row.imageVars?.loot_id||sku;
 const info=record?inspect(sku,{localPayment:true,paymentSku:sku}):classify(id,{category:row.category});
 row.localCapability=info.status;
 if(info.status==='unsupported'){row.notBuyable=true;row.isBuyable=false;}
 if(info.note&&['unsupported','partial','collectible','unverified'].includes(info.status))row.description=(row.description||'')+'<br /><br /><b>Yerel durum:</b> '+info.note;
 const sales=record?require('./laser-sales').recordReason(record):require('./laser-sales').reason(id);
 if(sales){row.notBuyable=true;row.isBuyable=false;if(!(row.description||'').includes(sales))row.description=(row.description||'')+'<br /><br /><b>Yerel durum:</b> '+sales;}
 return row;
}
function audit(offers){return Object.entries(offers).map(([id,offer])=>({offerId:id,...inspect(id,offer)}));}
module.exports={canonical,classify,inspect,purchaseReason,decorateOffers,decorateRow,audit};
