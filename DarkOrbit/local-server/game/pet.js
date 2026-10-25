'use strict';
const {open,tx}=require('./db');
const maps=require('./maps');
const META=require('../docs/client-map.items.json').items;
const catalog=require('./pet-catalog');
const special=require('./pet-special');
const levels=require('./pet-levels');
const APPEARANCES=require('./data/pet-appearances.json').appearances;
const GEARS=Object.fromEntries(catalog.entries({supportedOnly:true}).filter(i=>i.kind==='gear').map(i=>[i.lootId,catalog.gear(i.lootId)]));
// Existing local slots remain unlocked; protocol slots use the classic maximum.
const SLOTS={laser:6,generator:12,gear:6,protocol:12,visual:1};
const SLOT_NAMES={lasers:'laser',laser:'laser',generators:'generator',generator:'generator',gears:'gear',gear:'gear',protocols:'protocol',protocol:'protocol',visual:'visual'};
const MAX_FUEL=100000;
const LASER_INTERVAL_MS=1000;
const petId=id=>300000000+id;
const typeFor=level=>[12,13,14,15,22][Math.min(4,Math.floor((level-1)/3))];
function appearance(player,db=open()){
 const item=statItems(db,player.shipId,require('./inventory').activeConfig(db,player.shipId)).find(i=>i.slot==='visual'&&APPEARANCES[i.loot_id]);
 return item?{lootId:item.loot_id,type:APPEARANCES[item.loot_id].type}:{lootId:'pet_pet10',type:typeFor(owned(player.userId,db)?.level||1)};
}
function owned(playerId,db=open()){return db.prepare('SELECT * FROM pets WHERE player_id=?').get(playerId)||null;}
function addOwned(db,playerId,amount=1){
 if(amount!==1||owned(playerId,db))throw new Error('Yalnız bir P.E.T. sahibi olabilirsin.');
 db.prepare('INSERT INTO pets(player_id,hitpoints,created_at)VALUES(?,50000,?)').run(playerId,Date.now());
 db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'pet_pet10',1)").run(playerId);
 return petId(playerId);
}
function addFuel(db,playerId,amount){
 if(!Number.isSafeInteger(amount)||amount<1)throw new Error('Geçersiz yakıt miktarı.');
 if(!db.prepare('UPDATE pets SET fuel=fuel+? WHERE player_id=? AND fuel<=?').run(amount,playerId,MAX_FUEL-amount).changes)throw new Error('P.E.T. yok veya yakıt deposunda yeterli yer yok.');
 return owned(playerId,db).fuel;
}
function assignments(db,itemId){return db.prepare('SELECT ship_id,config_id FROM pet_equipment WHERE item_id=?').all(itemId);}
function clearConfig(db,shipId,config){db.prepare('DELETE FROM pet_equipment WHERE ship_id=? AND config_id=?').run(shipId,config);}
function statItems(db,shipId,config=1){
 return db.prepare(`SELECT i.*,e.slot,e.slot_index,e.ship_id,e.config_id,t.category,t.damage,t.shield,t.shield_absorb,t.speed FROM pet_equipment e JOIN items i ON i.id=e.item_id JOIN item_types t ON t.loot_id=i.loot_id WHERE e.ship_id=? AND e.config_id=? ORDER BY e.slot,e.slot_index`).all(shipId,config);
}
function stats(player,db=open()){
 const pet=owned(player.userId,db);if(!pet)return null;
 const eq=statItems(db,player.shipId,require('./inventory').activeConfig(db,player.shipId));
 const shields=eq.filter(i=>i.slot==='generator'),lasers=eq.filter(i=>i.slot==='laser'),effects=catalog.equippedEffects(eq),levelBonus=levels.bonuses(pet.level);
 const upgraded=(i,key)=>{const rule=META[i.loot_id]?.upgradable;return i[key]*(1+(rule?.upgradeType===(key==='damage'?'LASER_DAMAGE_UPGRADE':'GENERATOR_SHIELD_UPGRADE')?(i.upgrade_level||0)*rule.bonusPerLevel/100:0));};
 return {hitMax:Math.round((50000+Math.min(pet.level,pet.hp_upgrade_level||0)*10000)*effects.hitpointMultiplier*(1+require('./modern-lasers').hpBonus(lasers))),shieldMax:Math.round(shields.reduce((n,i)=>n+upgraded(i,'shield'),0)*effects.shieldMultiplier*levelBonus.shieldMultiplier),shieldAbsorb:shields.length?shields.reduce((n,i)=>n+i.shield_absorb,0)/shields.length:0,
 laserProfiles:require('./modern-lasers').profile(lasers).map(i=>({...i,ship:false})),laserCount:lasers.length,laserDamage:lasers.reduce((n,i)=>n+upgraded(i,'damage'),0)*effects.laserDamageMultiplier*levelBonus.damageMultiplier,speed:Math.round(player.speed),effects,levelBonus,equipment:eq,gears:[...new Set(eq.filter(i=>i.slot==='gear').map(i=>catalog.gear(i)?.type))].map(type=>catalog.gearForType(eq,type)).filter(Boolean)};
}
function accepts(item,slot,pet){
 if(slot==='visual')return !!APPEARANCES[item.loot_id]&&META[item.loot_id]?.typeClass?.endsWith('.PetCustomizationType');
 if(slot==='laser')return item.category==='laser'||META[item.loot_id]?.typeClass?.endsWith('.LaserType');
 if(slot==='generator')return item.category==='shield_generator'||META[item.loot_id]?.typeClass?.endsWith('.ShieldType');
 const entry=slot==='gear'?catalog.gear(item):slot==='protocol'?catalog.protocol(item):null;
 return !!entry?.supported&&catalog.canEquip(item,pet.level);
}
function applyCargo(world){
 const p=world.player;if(!p)return;const base=p.stats.cargoMax;
 if(!Number.isFinite(base))return;
 p.cargoSpaceMax=Math.round(base*(world.petRuntime?.active?catalog.equippedEffects(statItems(open(),p.shipId,require('./inventory').activeConfig(open(),p.shipId))).cargoMultiplier:1));
 for(const c of require('./collectables').resourceCommands(p))send(world,c);
}
function equipmentConfigs(playerId,shipId){
 if(!owned(playerId))return [];
 const active=require('./inventory').activeConfig(open(),shipId);
 return [1,2].map(config=>{const eq=statItems(open(),shipId,config),ids=s=>eq.filter(i=>i.slot===s).map(i=>i.id);return{_:'HangarPetEquipmentMsg',setId:config,active:config===active,laser:ids('laser'),generator:ids('generator'),gear:ids('gear'),protocol:ids('protocol'),visual:ids('visual'),heat:[]};});
}
function move(playerId,r){
 const inv=require('./inventory'),from=r.from||{},to=r.to||{},shipId=Number(r.params?.hi||r.hangarId),config=Number(to.configId||from.configId||1),ids=from.items;
 if(![1,2].includes(config)||(from.configId&&Number(from.configId)!==config)||!['inventory','pet'].includes(from.target)||!['inventory','pet'].includes(to.target)||from.target===to.target)throw new Error('Geçersiz P.E.T. hedefi.');
 if(!Array.isArray(ids)||!ids.length||ids.length>100||ids.some(i=>!Number.isSafeInteger(Number(i))||Number(i)<=0)||new Set(ids.map(Number)).size!==ids.length)throw new Error('Geçersiz eşya listesi.');
 const result=tx(db=>{
  inv.shipFor(db,playerId,shipId);if(!owned(playerId,db))throw new Error('P.E.T. sahibi değilsin.');
  const target=to.target==='pet'?to:from,slot=SLOT_NAMES[target.slotset];if(!slot)throw new Error('Bu P.E.T. yuvası desteklenmiyor.');
  const eq=statItems(db,shipId,config),items=ids.map(id=>db.prepare('SELECT i.*,t.category FROM items i JOIN item_types t ON t.loot_id=i.loot_id WHERE i.id=? AND i.player_id=?').get(Number(id),playerId));
  if(items.some(i=>!i||i.amount!==1))throw new Error('Takılabilir eşya bulunamadı.');
  if(to.target==='pet'){
   if(items.some(i=>!accepts(i,slot,owned(playerId,db))))throw new Error('Eşya bu P.E.T. yuvasına uymuyor veya P.E.T. seviyesi yetersiz.');
   const used=new Set(eq.filter(i=>i.slot===slot).map(i=>i.slot_index)),free=Array.from({length:require('./pet-progression').unlocked(playerId,db)[slot]},(_,i)=>i).filter(i=>!used.has(i));
   for(const i of items){
    const second=db.prepare('SELECT ship_id FROM equipment_config2 WHERE item_id=?').get(i.id),drone=db.prepare('SELECT ship_id,config_id FROM drone_equipment WHERE item_id=?').all(i.id),pet=assignments(db,i.id);
    if((i.ship_id&&(config===1||i.ship_id!==shipId))||(second&&(config===2||second.ship_id!==shipId))||[...drone,...pet].some(e=>e.config_id===config||e.ship_id!==shipId))throw new Error('Eşya başka bir yuvada takılı.');
   }
   items.slice(0,free.length).forEach((i,n)=>db.prepare('INSERT INTO pet_equipment(player_id,ship_id,config_id,slot,slot_index,item_id)VALUES(?,?,?,?,?,?)').run(playerId,shipId,config,slot,free[n],i.id));
   if(free.length<items.length)return items.slice(free.length).map(i=>i.id);
  }else{
   if(items.some(i=>!eq.some(e=>e.id===i.id&&e.slot===slot)))throw new Error('Eşya bu P.E.T. konfigürasyonunda takılı değil.');
   for(const i of items)db.prepare('DELETE FROM pet_equipment WHERE item_id=? AND config_id=?').run(i.id,config);
  }
  return true;
 });
 const world=require('./world').current();if(world?.livePlayer(playerId))refresh(world);
 return result;
}
function view(playerId){
 const pet=owned(playerId);if(!pet)return null;
 const p=require('./db/players').loadPlayer(playerId),s=stats(p),progress=require('./pet-progression'),slots=progress.unlocked(playerId),max=progress.maximum(pet);
 return {_:'HangarShipPetView',rootId:'pet_pet10',name:pet.name,level:pet.level,exp:pet.experience,expNextLevel:levelThreshold(pet.level),fuel:pet.fuel,maxFuel:MAX_FUEL,hitPoints:Math.min(pet.hitpoints,s.hitMax),maxHitPoints:s.hitMax,
 maxLaserSlots:max.laser,maxGeneratorSlots:max.generator,maxGearSlots:max.gear,maxProtocolSlots:max.protocol,maxHeatSlots:0,lasers:slots.laser,maxLasers:max.laser,shieldGenerators:slots.generator,
 petHeatSlotPrice:0,petGearsSlotPrice:progress.price('gear',slots.gear+1)||0,petProtocolsSlotPrice:progress.price('protocol',slots.protocol+1)||0,petRenamePrice:0,petGeneratorsSlotPrice:progress.price('generator',slots.generator+1)||0,petLasersSlotPrice:progress.price('laser',slots.laser+1)||0,damageDistribution:0,maxDamageDistribution:0};
}
function decoratePortal(playerId,response){
 const pet=owned(playerId);if(!pet)return response;
 const {ret,map}=response.data;
 if(!map.lootIds.includes('pet_pet10'))map.lootIds.push('pet_pet10');
 const L=map.lootIds.indexOf('pet_pet10'),T=map.types.includes('Pet_PetType')?map.types.indexOf('Pet_PetType'):map.types.push('Pet_PetType')-1;
 const progress=require('./pet-progression'),slots=progress.unlocked(playerId),max=progress.maximum(pet);
 const info={L,T,name:'PET10',C:'pet',costWeaponSlot:progress.PRICES.laser.slice(1),costGeneratorSlot:progress.PRICES.generator.slice(1),costGearSlot:progress.PRICES.gear.slice(1),costProtocolSlot:progress.PRICES.protocol.slice(1),levels:Array.from({length:21},()=>({slotsets:{lasers:{T:[0],Q:max.laser},generators:{T:[4],Q:max.generator},gears:{T:[22],Q:max.gear},protocols:{T:[23],Q:max.protocol},visual:{T:[25],Q:1},heat:{T:[0,4],Q:0}}}))};
 const old=ret.itemInfo.findIndex(i=>i.L===L);if(old<0)ret.itemInfo.push(info);else ret.itemInfo[old]=info;
 ret.pet={I:petId(playerId),L,LV:pet.level,PN:pet.name,HP:pet.hitpoints,FU:pet.fuel,lockedSlots:{lasers:max.laser-slots.laser,generators:max.generator-slots.generator,gears:max.gear-slots.gear,protocols:max.protocol-slots.protocol,visual:0,heat:0}};
 for(const h of ret.hangars){h.general.pet=ret.pet;for(const config of [1,2]){const eq=statItems(open(),Number(h.hangarID),config);h.config[config].pet={EQ:Object.fromEntries(Object.entries(SLOT_NAMES).filter(([name])=>['lasers','generators','gears','protocols','visual'].includes(name)).map(([name,slot])=>[name,eq.filter(i=>i.slot===slot).map(i=>i.id)]))};}}
 for(const item of ret.items){const eq=assignments(open(),item.I);if(eq.length){item.EQH=eq[0].ship_id;item.EQC=eq.length===2?3:eq[0].config_id;item.EQT='pet';}}
 return response;
}
function levelThreshold(level){return levels.next(level);}
function send(world,cmd){const fn=world.petSend||world.combat?.send||require('./net').sendCmd;world.broadcast(s=>fn(s,cmd));}
function gearType(type){return{_:'PetGearTypeModule',typeValue:type};}
function status(world,r=world.petRuntime){
 const p=world.player,pet=r||owned(p.userId),s=stats(p);
 return {_:'PetStatusCommand',petId:petId(p.userId),petLevel:pet.level,petExperiencePoints:pet.experience,petExperiencePointsUntilNextLevel:levelThreshold(pet.level),petHitPoints:Math.round(Math.min(pet.hitpoints,s.hitMax)),petHitPointsMax:s.hitMax,petShieldEnergyNow:Math.round(Math.min(pet.shield,s.shieldMax)),petShieldEnergyMax:s.shieldMax,petCurrentFuel:pet.fuel,petMaxFuel:MAX_FUEL,petSpeed:s.speed,petName:pet.name,petLootId:appearance(p).lootId};
}
function activation(world,r){const p=world.player;return {_:'PetHeroActivationCommand',ownerId:p.userId,petId:petId(p.userId),shipType:appearance(p).type,expansionStage:0,petName:r.name,factionId:p.factionId,clanId:0,petLevel:r.level,clanTag:'',x:Math.round(r.x),y:Math.round(r.y),petSpeed:r.stats.speed,minimapStrategyModule:{_:'MinimapStrategyModule',minimapStrategy:0}};}
function buildInit(world){
 const p=world.player;if(!p)return[];const pet=owned(p.userId);
 if(!pet)return[{_:'PetInitializationCommand',hasPet:false,hasFuel:false,petIsAlive:false}];
 const s=stats(p),r=world.petRuntime,state=r?.active?r:pet,selected=availableGears(s).includes(state.gear)?state.gear:1,locator=r?.active&&[6,7].includes(selected),out=[{_:'PetInitializationCommand',hasPet:true,hasFuel:state.fuel>0,petIsAlive:state.hitpoints>0},{_:'PetGearResetCommand'},...availableGears(s).map(type=>({_:'PetGearAddCommand',gearType:gearType(type),level:s.gears.find(g=>g.type===type)?.level||1,amount:1,enabled:true})),
  ...(locator?[{_:'PetLocatorGearInitializationCommand',locatorType:gearType(selected),possibleTargetValues:special.targets(world,selected)}]:[]),
  {_:'PetGearSelectCommand',gearType:gearType(selected),optionalParams:locator?[r.locatorTarget??-1]:[]},{_:'PetUIRepairButtonCommand',enabled:state.hitpoints<=0,repairCosts:repairCost(world)},...special.cooldownCommands(p.userId)];
 // Native initialization shows Play even for an existing map entity. Always
 // restore hero activation after that reset; ShipManager.createPet deduplicates
 // the same entity ID/pattern and activation restores the actual Stop listener.
 if(r?.active)out.push(activation(world,r),status(world,r),{_:'PetIdleModeCommand',petId:petId(p.userId),isIdle:!!r.tradeIdle});
 out.push({_:'PetFuelUpdateCommand',petFuelNow:state.fuel,petFuelMax:MAX_FUEL},{_:'PetHitpointsUpdateCommand',hitpointsNow:Math.min(state.hitpoints,s.hitMax),hitpointsMax:s.hitMax,useRepairGear:false},{_:'PetShieldUpdateCommand',petShieldNow:Math.min(state.shield,s.shieldMax),petShieldMax:s.shieldMax});return out;
}
function sync(world){for(const command of buildInit(world))send(world,command);require('./pet-link').sync(world);}
function availableGears(s){return[1,2,...new Set(s.gears.map(g=>g.type))];}
function launch(world){
 const p=world.player;if(!p||p.dead)return false;
 // Recover a stale Play button without toggling off, spending fuel, refilling
 // health or creating another runtime. This is a LAUNCH state request.
 if(world.petRuntime?.active){sync(world);return true;}
 const pet=owned(p.userId);if(special.cooldown(p.userId,8))return false;if(!pet||pet.hitpoints<=0||pet.fuel<=0){if(pet?.fuel<=0)send(world,{_:'PetOutOfFuelCommand'});return false;}
 const s=stats(p),r={...pet,active:true,x:p.x+80,y:p.y+80,stats:s,lastTick:Date.now(),gear:availableGears(s).includes(pet.gear)?pet.gear:1};
 // Transactional/locator modes require a fresh explicit activation after relog.
 if([6,7,8,10,11,16].includes(r.gear))r.gear=1;
 // Deactivation clears the native gear menu. Every real launch must rebuild
 // it before selecting the saved mode, not just recreate the map entity.
 world.petRuntime=r;r.appearanceType=appearance(p).type;applyCargo(world);sync(world);return true;
}
function save(world){const r=world.petRuntime;if(!r||!world.player)return;open().prepare('UPDATE pets SET hitpoints=?,shield=?,fuel=?,fuel_fraction=?,gear=?,level=?,experience=? WHERE player_id=?').run(Math.round(r.hitpoints),Math.round(r.shield),r.fuel,r.fuel_fraction||0,r.gear,r.level,r.experience,world.player.userId);}
function stop(world,{notify=true,resume=false}={}){
 const r=world.petRuntime,p=world.player;if(!resume)world.petResume=false;
 if(!p){world.petRuntime=null;return false;}if(r){require('./pet-link').end(world);save(world);}if(resume)world.petResume=!!r?.active;
 if(r)r.active=false;world.petRuntime=null;
 if(notify&&p&&(r||owned(p.userId))){send(world,{_:'PetLaserAttackStopCommand',petId:petId(p.userId)});send(world,{_:'PetDeactivationCommand',petId:petId(p.userId)});send(world,{_:'ShipRemoveCommand',userId:petId(p.userId)});
  // Destruction's native repair state must follow deactivation, which otherwise
  // replaces the Repair button with Play after a kamikaze explosion.
  if((r?.hitpoints??owned(p.userId)?.hitpoints)<=0)sync(world);
 }
 for(const npc of world.npcs?.values()||[])if(npc.petAggro===petId(p.userId))npc.petAggro=null;
 if(r)applyCargo(world);return !!(r||p&&owned(p.userId));
}
function refresh(world){const r=world.petRuntime;if(!r)return;r.stats=stats(world.player);const visual=appearance(world.player).type;if(r.active&&r.appearanceType!==visual){r.appearanceType=visual;send(world,{_:'ShipRemoveCommand',userId:petId(world.player.userId)});}r.hitpoints=Math.min(r.hitpoints,r.stats.hitMax);r.shield=Math.min(r.shield,r.stats.shieldMax);if(!availableGears(r.stats).includes(r.gear)){r.gear=1;delete r.kamikaze;delete r.shipRepairUntil;}applyCargo(world);save(world);sync(world);}
function purchased(world,itemId){
 if(!world.player||!['pet_pet10','resource_pet-fuel'].includes(itemId))return;
 const row=owned(world.player.userId);if(world.petRuntime)world.petRuntime.fuel=row.fuel;
 if(itemId==='pet_pet10')send(world,{_:'PetPurchasedCommand'});
 sync(world);
}
function selectGear(world,type,optParam){
 if(!Number.isInteger(type)||!world.player||world.player.dead)return false;
 // Native clicks update the combo optimistically before sending a request.
 // A rejected action must restore the authoritative menu/mode as well.
 const rejected=()=>{sync(world);return false;};
 const s=stats(world.player);if(!s||!availableGears(s).includes(type))return rejected();
 // The native D shortcut activates the repair combo directly, including a
 // docked PET. Validate before launch so an unusable shortcut stays harmless.
 if(type===11&&!world.petRuntime?.active){const g=s.gears.find(g=>g.type===11),p=world.player,row=owned(p.userId);
  if(p.hitPoints>=p.hitMax||row.fuel<g.fuelUsage||special.cooldown(p.userId,11)||!launch(world))return rejected();
 }
 if(!special.activate(world,type,optParam))return rejected();
 open().prepare('UPDATE pets SET gear=? WHERE player_id=?').run(type,world.player.userId);if(world.petRuntime){
  if(world.petRuntime.gear!==type)send(world,{_:'PetLaserAttackStopCommand',petId:petId(world.player.userId)});
  world.petRuntime.gear=type;
  if([4,5].includes(type))for(const npc of world.npcs?.values()||[])if(npc.petAggro===petId(world.player.userId))npc.petAggro=null;
 }
 send(world,{_:'PetGearSelectCommand',gearType:gearType(type),optionalParams:[6,7].includes(type)&&world.petRuntime?.locatorTarget!==null?[world.petRuntime?.locatorTarget??-1]:[]});return true;
}
function repairCost(world){const p=world.player;if(p?.premium)return 0;return world.config.pet?.repairCost??[0,0,0,10,20,30,50,70,90,120,150,180,220,260,300,350][Math.min(15,owned(p.userId)?.level||1)];}
function repair(world){
 const p=world.player,pet=owned(p.userId);if(!pet||pet.hitpoints>0||p.dead)return false;const cost=repairCost(world),s=stats(p);
 tx(db=>{if(!db.prepare('UPDATE players SET uridium=? WHERE id=? AND ?>=?').run(p.uridium-cost,p.userId,p.uridium,cost).changes)throw new Error('P.E.T. tamiri için uridyum yetersiz.');db.prepare('UPDATE pets SET hitpoints=?,shield=0 WHERE player_id=?').run(s.hitMax,p.userId);});
 p.uridium-=cost;send(world,{_:'PetRepairCompleteCommand'});for(const c of buildInit(world))send(world,c);send(world,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot});return true;
}
function buyFuel(world,amount=10000){
 const p=world.player,pet=owned(p.userId);if(!pet)return false;
 amount=Math.min(amount,MAX_FUEL-pet.fuel);if(!Number.isSafeInteger(amount)||amount<1){send(world,{_:'PetFuelCargoFullMessage'});return false;}
 const price=open().prepare("SELECT price_uridium FROM item_types WHERE loot_id='resource_pet-fuel'").get()?.price_uridium??0.25,cost=amount*price;
 tx(db=>{if(!db.prepare('UPDATE players SET uridium=? WHERE id=? AND ?>=?').run(p.uridium-cost,p.userId,p.uridium,cost).changes)throw new Error('P.E.T. yakıtı için uridyum yetersiz.');addFuel(db,p.userId,amount);});p.uridium-=cost;
 if(world.petRuntime)world.petRuntime.fuel+=amount;
 send(world,{_:'PetFuelUpdateCommand',petFuelNow:pet.fuel+amount,petFuelMax:MAX_FUEL});send(world,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot});return true;
}
function movePet(world,r,target,seconds){
 const d=maps.dist(r,target);if(d<=10)return;const step=Math.min(d,r.stats.speed*seconds),x=r.x+(target.x-r.x)*step/d,y=r.y+(target.y-r.y)*step/d;r.x=x;r.y=y;
 send(world,{_:'MoveCommand',userId:petId(world.player.userId),x:Math.round(x),y:Math.round(y),timeToTarget:Math.round(step/r.stats.speed*1000)});
}
function tick(world,combat,now=Date.now()){
 const r=world.petRuntime,p=world.player;if(!r?.active||!p)return;
 if(p.dead)return stop(world);require('./pet-link').tick(world,now);const elapsed=Math.max(0,Math.min(5,(now-r.lastTick)/1000));if(elapsed<0.5)return;r.lastTick=now;
 r.stats=stats(p);if(!availableGears(r.stats).includes(r.gear))selectGear(world,1);
 const burn=(r.fuel_fraction||0)+catalog.fuelPerMinute(r.level,r.stats.equipment,r.gear)*elapsed/60,use=Math.floor(burn+1e-12);
 if(r.fuel<=0||!open().prepare('UPDATE pets SET fuel=fuel-?,fuel_fraction=? WHERE player_id=? AND fuel>=?').run(use,Math.max(0,burn-use),p.userId,use).changes){r.fuel=0;r.fuel_fraction=0;stop(world);send(world,{_:'PetOutOfFuelCommand'});return;}
 r.fuel_fraction=Math.max(0,burn-use);r.fuel=owned(p.userId).fuel;if(use)send(world,{_:'PetFuelUpdateCommand',petFuelNow:r.fuel,petFuelMax:MAX_FUEL});
 if(now-(r.lastCombat||0)>10000&&r.shield<r.stats.shieldMax){r.shield=Math.min(r.stats.shieldMax,Math.round(r.shield+r.stats.shieldMax*0.05*elapsed));send(world,{_:'PetShieldUpdateCommand',petShieldNow:r.shield,petShieldMax:r.stats.shieldMax});}
 const session=[...world.sessions].find(s=>world.active(s));if(!session||session.jumping)return;
 if(special.tick(world,combat,elapsed,now)){if(world.petRuntime)save(world);return;}
 let target={x:p.x+80,y:p.y+80};
 if(r.gear===4||r.gear===5){
  const gear=r.stats.gears.find(g=>g.type===r.gear),boxes=world.collectables?.boxes;
  const candidate=gear&&boxes&&[...boxes.values()].filter(b=>b.hash!==session.harvest?.hash&&!require('./booty').type(b)&&(r.gear===5?b.oreType!==undefined:b.oreType===undefined||b.oreType===8)&&(!b.expires||b.expires>=now)&&maps.dist(p,b)<=gear.range*r.stats.effects.radarMultiplier).sort((a,b)=>maps.dist(r,a)-maps.dist(r,b))[0];
  if(candidate){target=candidate;movePet(world,r,target,elapsed);if(maps.dist(r,candidate)<=180){if(world.collectables.collect(session,{itemHash:candidate.hash},r))send(world,{_:'PetHarvestEffectCommand'});}save(world);return;}
 }
 if(r.gear===2||r.gear===12||r.gear===16){
  const npc=combat.npcs.get(session.attacking)||[...combat.npcs.values()].find(n=>n.aggro===session);
  if(npc&&npc.hp>0&&!maps.nearPeaceArea(world)&&r.stats.laserCount){
   target=npc;movePet(world,r,target,elapsed);
   if(combat.npcProtected(npc)){combat.missed(npc.id);save(world);return;}
   if(maps.dist(r,npc)<=600&&now>=(r.nextLaserAt||0)&&!(p.ammo==='ammunition_laser_rsb-75'&&now<(r.nextRsb||0))){const user={...p,stats:{...p.stats,laserCount:r.stats.laserCount}};if(require('./ammo').consume(user)){
    r.nextLaserAt=now+LASER_INTERVAL_MS;
    if(p.ammo==='ammunition_laser_rsb-75')r.nextRsb=now+(combat.cfg.rsbCooldownMs??3000);
    r.ammo=p.ammo;const balance=require('./combat-balance'),damage=require('./modern-lasers').rollDamage(r,npc,now,{cfg:combat.cfg,range:maps.dist(r,npc),multiplier:r.stats.effects.alienDamageMultiplier*require('./laser-ammo').multiplier(r,npc,now)*require('./pet-link').damageMultiplier(world,now)}),hit=combat.rollHit(balance.hitChance('laser',combat.cfg,{accuracy:r.stats.effects.accuracy})),applied=hit?combat.applyLaserDamage(r,npc,damage,p.ammo):0;require('./laser-ammo').fired(r,hit,now);npc.lastHit=now;npc.aggro=session;r.lastCombat=now;
    if(!session.attacking)npc.petAggro=petId(p.userId);
    const effect=combat.laserRun(petId(p.userId),npc.id);effect.laserColor=combat.laserRun(p.userId,npc.id).laserColor;
    combat.broadcast(effect);if(applied>0)combat.hit(petId(p.userId),npc.id,npc,applied);else combat.missed(npc.id);if(npc.hp<=0)combat.kill(session,npc);
   }}save(world);return;
  }
 }
 // G-REP1 cannot repair during combat. Ten seconds is the existing local PET
 // out-of-combat window, also used for shield regeneration; its exact original
 // server delay has not been recovered. Mode changes retain lastCombat.
 if(r.gear===9&&now-(r.lastCombat||0)>10000){const gear=r.stats.gears.find(g=>g.type===9);r.hitpoints=Math.min(r.stats.hitMax,r.hitpoints+Math.round(gear.repair*elapsed));send(world,{_:'PetHitpointsUpdateCommand',hitpointsNow:r.hitpoints,hitpointsMax:r.stats.hitMax,useRepairGear:true});}
 movePet(world,r,target,elapsed);save(world);
}
function awardExperience(world,amount){
 const r=world.petRuntime;if(!r?.active||!Number.isFinite(amount)||amount<=0)return;
 const before=r.level,earned=amount*0.05*require('./boosters').petExperienceMultiplier(world.player.userId);
 // Preserve fractional5% awards instead of manufacturing at least1EP on every
 // tiny owner reward. PET protocol experience fields support native doubles.
 r.experience=Math.round((r.experience+earned)*1000000)/1000000;
 while(r.level<20&&r.experience>=levelThreshold(r.level))r.level++;
 save(world);send(world,{_:'PetExperiencePointsUpdateCommand',currentExperiencePoints:r.experience,maxExperiencePoints:levelThreshold(r.level)});
 if(r.level!==before){r.stats=stats(world.player);send(world,{_:'PetLevelUpdateCommand',petLevel:r.level,petExperiencePointsUntilNextLevel:levelThreshold(r.level),designId:appearance(world.player).type,expansionStage:0});send(world,status(world,r));}
}
function rename(world,name){if(typeof name!=='string'||name.trim().length<1||name.trim().length>24||/[<>\x00-\x1f]/.test(name)||!owned(world.player.userId))return false;name=name.trim();open().prepare('UPDATE pets SET name=? WHERE player_id=?').run(name,world.player.userId);if(world.petRuntime){world.petRuntime.name=name;send(world,status(world));}return true;}
function damage(world,npc,amount,combat,now=Date.now()){
 const r=world.petRuntime;if(!r?.active||npc.petAggro!==petId(world.player.userId))return false;
 // Auto collectors and the absent trader cannot be attacked by NPCs. Clear
 // stale guard aggro rather than letting a previous mode bypass immunity.
 if([4,5].includes(r.gear)||r.tradeIdle){npc.petAggro=null;return false;}
 // The NPC AI calls this every world tick. Share its ordinary shot deadline,
 // so a PET target cannot multiply attack frequency or reset it by docking.
 if(now<(npc.nextLaserAt||0))return true;npc.nextLaserAt=now+LASER_INTERVAL_MS;
 // Local combo shield policy: probabilistic full deflection, not a constant
 // percentage damage reduction. Original shield activation timing is unknown.
 const combo=r.stats.gears.find(g=>g.type===r.gear&&[11,12].includes(g.type));
 if(combo&&combat.rollHit(combo.deflectionChance)){combat.missed(petId(world.player.userId));return true;}
 if(!combat.rollHit((combat.cfg.npcHitChance??1)-r.stats.effects.evasion)){combat.missed(petId(world.player.userId));return true;}
 const state={get hp(){return r.hitpoints;},set hp(v){r.hitpoints=v;},get shield(){return r.shield;},set shield(v){r.shield=v;}};
 combat.applyDamage(state,amount,r.stats.shieldAbsorb);r.lastCombat=now;combat.broadcast(combat.laserRun(npc.id,petId(world.player.userId)));combat.hit(npc.id,petId(world.player.userId),state,amount);
 send(world,{_:'PetHitpointsUpdateCommand',hitpointsNow:r.hitpoints,hitpointsMax:r.stats.hitMax,useRepairGear:false});send(world,{_:'PetShieldUpdateCommand',petShieldNow:r.shield,petShieldMax:r.stats.shieldMax});save(world);
 if(r.hitpoints<=0)special.destroy(world);else special.arm(world,npc,now);
 return true;
}
module.exports={GEARS,SLOTS,MAX_FUEL,owned,addOwned,addFuel,assignments,clearConfig,statItems,stats,accepts,equipmentConfigs,move,view,decoratePortal,petId,typeFor,appearance,buildInit,sync,launch,stop,save,refresh,purchased,selectGear,repair,repairCost,buyFuel,tick,awardExperience,rename,damage,send,movePet};
