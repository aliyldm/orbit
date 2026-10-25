'use strict';
const fs=require('fs');
const path=require('path');
const {open,tx}=require('./db');
const META=require('../docs/client-map.items.json').items;
const DRONE_DATA=require('./data/drone-patterns.json'),PATTERNS=DRONE_DATA.designs;
const XP=require('./data/drone-xp.json');
// Account ownership, not a static client catalogue price, determines the next
// Flax/Iris cost. Historical official FAQ: board-de.darkorbit.com/threads/faq-drohnen.2892/
const PRICES={drone_flax:[100000,200000,400000,800000,1600000,3200000,6400000,12800000],drone_iris:[15000,24000,42000,60000,84000,96000,126000,200000]};
function purchasePrice(db,playerId,lootId){
 const ladder=PRICES[lootId],m=META[lootId];
 if(!ladder)return m?.uridium||m?.credits||0;
 const count=playerId?db.prepare('SELECT COUNT(*) n FROM drones WHERE player_id=? AND loot_id=?').get(playerId,lootId).n:0;
 return ladder[Math.min(count,ladder.length-1)];
}
function shopState(db,playerId){
 const rows=owned(db,playerId),standard=rows.filter(d=>PRICES[d.loot_id]).length;
 return Object.fromEntries(Object.entries(META).filter(([,m])=>m.kind==='Drone').map(([id,m])=>[id,{price:purchasePrice(db,playerId,id),notBuyable:rows.filter(d=>d.loot_id===id).length>=m.maxQuantity||!!PRICES[id]&&standard>=8}]));
}
const formationIds={drone_formation_default:0,'drone_formation_f-3d-x':42};
const text=fs.readFileSync(path.join(__dirname,'../client/spacemap/templates/tr/resource_items.xml'),'utf8');
for(const match of text.matchAll(/name="items_(drone_formation_[^"]+)_code"><!\[CDATA\[F-(\d+)-/g))formationIds[match[1]]=Number(match[2]);
formationIds['drone_formation_f-3d-x']=42; // DroneFormation.X, distinct from the display code F-19-X.
function owned(db,playerId) {return db.prepare('SELECT * FROM drones WHERE player_id=? ORDER BY id').all(playerId);}
function droneFor(db,playerId,id) {
 const d=db.prepare('SELECT * FROM drones WHERE id=? AND player_id=?').get(Number(id),playerId);
 if(!d)throw new Error('Diroit bulunamadı.');return d;
}
function addOwned(db,playerId,lootId) {
 const m=META[lootId];if(m?.kind!=='Drone')throw new Error('Geçersiz diroit türü.');
 const list=owned(db,playerId);
 if(list.filter(d=>d.loot_id===lootId).length>=m.maxQuantity || (['drone_flax','drone_iris'].includes(lootId)&&list.filter(d=>['drone_flax','drone_iris'].includes(d.loot_id)).length>=8))throw new Error('Azami diroit sayısına ulaştın.');
 return Number(db.prepare('INSERT INTO drones(player_id,loot_id)VALUES(?,?)').run(playerId,lootId).lastInsertRowid);
}
function equipped(db,shipId,config=1) {
 return db.prepare(`SELECT i.*,e.slot AS drone_slot,e.drone_id,e.slot_index,e.ship_id,e.config_id,t.category,t.damage,t.shield,t.shield_absorb,t.speed,t.multiplier
 FROM drone_equipment e JOIN items i ON i.id=e.item_id JOIN item_types t ON t.loot_id=i.loot_id WHERE e.ship_id=? AND e.config_id=? ORDER BY e.drone_id,e.slot_index`).all(shipId,config);
}
function statItems(db,shipId,config=1) {
 const all=equipped(db,shipId,config);
 const playerId=db.prepare('SELECT player_id FROM ships WHERE id=?').get(shipId)?.player_id;
 const designs=require('./drone-designs'),designEffects=designs.effects(playerId?owned(db,playerId):[],all);
 const droneRows=new Map(db.prepare('SELECT * FROM drones WHERE id IN(SELECT drone_id FROM drone_equipment WHERE ship_id=? AND config_id=?)').all(shipId,config).map(d=>[d.id,d]));
 return all.filter(i=>i.drone_slot==='default').map(i=>{
  const bonus=designs.mounted(designEffects,i.drone_id);
  const d=droneRows.get(i.drone_id),upgrade=DRONE_DATA.upgrades[d.loot_id]?.[d.level]||{};
  return {...i,shield:i.shield*(1+d.level*.04)*bonus.shield*(1+(d.upgrade_level||0)*(upgrade.DRONE_SHIELD_UPGRADE||0)/100),
   damage:i.damage*(1+d.level*.02)*bonus.damage*(1+(d.upgrade_level||0)*(upgrade.DRONE_DAMAGE_UPGRADE||0)/100)};
 });
}
function designId(lootId) {return META[lootId]?.designId ?? PATTERNS[lootId] ?? PATTERNS[lootId?.replace(/^drone_designs_/,'')] ?? 0;}
// Apply one explicit client slot plan inside the caller's transaction. The
// native multi-drone response updates precisely these drone IDs, so never
// silently spill a single-drone request into a different client model.
function applyMove(db,playerId,r,{partial=true}={}) {
 const inv=require('./inventory'),from=r.from||{},to=r.to||{},shipId=Number(r.params?.hi||r.hangarId),config=Number(to.configId||from.configId||1);
 if(![1,2].includes(config)|| (from.configId&&Number(from.configId)!==config))throw new Error('Geçersiz konfigürasyon.');
 if(!(['inventory','drone'].includes(from.target)&&['inventory','drone'].includes(to.target))||from.target===to.target)throw new Error('Geçersiz diroit hedefi.');
 const ids=from.items;
 if(!Array.isArray(ids)||!ids.length||ids.length>100||ids.some(x=>!Number.isSafeInteger(Number(x))||Number(x)<=0)||new Set(ids.map(Number)).size!==ids.length)throw new Error('Geçersiz eşya listesi.');
  inv.shipFor(db,playerId,shipId);
  const target=to.target==='drone'?to:from;
  const d=droneFor(db,playerId,target.droneId),m=META[d.loot_id],slot=target.slotset||'default';
  if(!['default','design','visual'].includes(slot))throw new Error('Geçersiz diroit yuvası.');
  const accepts=m.slotable.slots.find(s=>s.name===slot),eq=equipped(db,shipId,config);
  const items=ids.map(id=>{
   const i=db.prepare('SELECT * FROM items WHERE id=? AND player_id=?').get(Number(id),playerId);
   if(!accepts||!i||i.amount!==1||!META[i.loot_id]?.equipable?.entities.includes('DRONE')||!accepts.accepts.includes((META[i.loot_id]?.typeClass||'').split('.').at(-1)))throw new Error('Eşya bu diroit yuvasına uymuyor.');
   return i;
  });
  if(to.target==='drone') {
   const used=new Set(eq.filter(i=>i.drone_id===d.id&&i.drone_slot===slot).map(i=>i.slot_index));
   const free=Array.from({length:accepts.size},(_,n)=>n).filter(n=>!used.has(n));
   for(const i of items) {
    const second=db.prepare('SELECT ship_id FROM equipment_config2 WHERE item_id=?').get(i.id);
    const existing=db.prepare('SELECT * FROM drone_equipment WHERE item_id=?').all(i.id);
    const pet=require('./pet').assignments(db,i.id);
    if((i.ship_id&&(config===1||i.ship_id!==shipId))||(second&&(config===2||second.ship_id!==shipId))||existing.concat(pet).some(e=>e.config_id===config||e.ship_id!==shipId))throw new Error('Eşya zaten başka bir yuvada takılı.');
   }
   if(!partial&&free.length<items.length)return false;
   items.slice(0,free.length).forEach((i,n)=>db.prepare('INSERT INTO drone_equipment(drone_id,ship_id,config_id,slot,slot_index,item_id)VALUES(?,?,?,?,?,?)').run(d.id,shipId,config,slot,free[n],i.id));
   if(free.length<items.length)return items.slice(free.length).map(i=>i.id);
  } else {
   if(items.some(i=>!eq.some(e=>e.id===i.id&&e.drone_id===d.id&&e.drone_slot===slot)))throw new Error('Eşya belirtilen diroitte takılı değil.');
   for(const i of items)db.prepare('DELETE FROM drone_equipment WHERE item_id=? AND config_id=?').run(i.id,config);
  }
  return true;
}
function move(playerId,r,options) {
 const result=tx(db=>applyMove(db,playerId,r,options));
 refresh(playerId);return result;
}
function equipMany(playerId,r) {
 const from=r.from||{},to=r.to||{},plan=from.droneItems;
 if(from.target!=='inventory'||to.target!=='drone'||!plan||typeof plan!=='object'||Array.isArray(plan))throw new Error('Geçersiz toplu diroit hedefi.');
 const groups=Object.entries(plan),ids=groups.flatMap(([,items])=>items);
 if(!groups.length||groups.length>10||groups.some(([id,items])=>!/^\d+$/.test(id)||String(Number(id))!==id||!Number.isSafeInteger(Number(id))||Number(id)<=0||!Array.isArray(items))||!ids.length||ids.length>100||ids.some(id=>!Number.isSafeInteger(Number(id))||Number(id)<=0)||new Set(ids.map(Number)).size!==ids.length)throw new Error('Geçersiz toplu eşya listesi.');
 const rejected=tx(db=>{
  const rejected=[];
  // Validate even empty target groups; one invalid group rolls back the whole
  // native request, with no partial stats or socket updates before commit.
  for(const [id,items]of groups){
   droneFor(db,playerId,Number(id));
   if(items.length){const result=applyMove(db,playerId,{...r,from:{...from,items},to:{...to,droneId:Number(id)}});if(Array.isArray(result))rejected.push(...result);}
  }
  return rejected;
 });
 refresh(playerId);return rejected.length?rejected:true;
}
function refresh(playerId) {
 const w=require('./world').current(),p=w?.livePlayer(playerId);
 if(!p)return;
 w.refreshStats();
 const {sendCmd}=require('./net'),commands=buildCommands(p);
 w.broadcast(s=>{for(const cmd of commands)sendCmd(s,cmd);sendCmd(s,{_: 'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});});
}
function views(playerId) {return owned(open(),playerId).map((d,n)=>({_: 'HangarShipDroneView',position:n,damage:d.damage,droneId:d.id,points:d.experience,level:d.level,lootId:d.loot_id,nextLevel:nextLevel(d.level),droneTypeId:META[d.loot_id].droneId}));}
function configs(playerId,shipId) {
 const db=open(),list=owned(db,playerId),active=require('./inventory').activeConfig(db,shipId);
 return [1,2].map(config=>({_: 'HangarDroneEquipmentMsg',setId:config,active:config===active,position:0,setDroneEquipment:list.map((d,n)=>{
  const eq=equipped(db,shipId,config).filter(i=>i.drone_id===d.id),m=META[d.loot_id];
  const ids=s=>eq.filter(i=>i.drone_slot===s).map(i=>i.id);
  return {_: 'SingleDroneEquipmentMsg',level:d.level,visual:ids('visual'),design:ids('design'),defaults:ids('default'),droneId:d.id,position:n,damage:d.damage,
   repairValue:String(m.repairable.baseCost),repairType:m.repairable.currency,weaponEffect:0,shieldEffect:0,weaponBouns:0,shieldBouns:0,damageUpgradeLevel:d.upgrade_level+1,shieldUpgradeLevel:d.upgrade_level+1};
 })}));
}
function available(playerId) {
 const list=open().prepare('SELECT loot_id FROM items WHERE player_id=? AND amount>0').all(playerId);
 return [0,...new Set(list.map(i=>formationIds[i.loot_id]).filter(n=>n!==undefined&&n!==0))];
}
function formation(playerId) {return open().prepare('SELECT formation_id FROM drone_settings WHERE player_id=?').get(playerId)?.formation_id||0;}
function selectFormation(playerId,value) {
 const id=typeof value==='string'&&value.startsWith('drone_')?formationIds[value]:Number(value);
 if(!Number.isSafeInteger(id)||!available(playerId).includes(id))throw new Error('Bu uçuş düzenine sahip değilsin.');
 if(id!==0&&owned(open(),playerId).length<4)throw new Error('Uçuş düzeni için en az dört diroit gerekli.');
 open().prepare('INSERT INTO drone_settings(player_id,formation_id)VALUES(?,?) ON CONFLICT(player_id)DO UPDATE SET formation_id=excluded.formation_id').run(playerId,id);
 refresh(playerId);return id;
}
function buildCommands(player) {
 const ds=owned(open(),player.userId);
 const eq=equipped(open(),player.shipId,require('./inventory').activeConfig(open(),player.shipId));
 const fields=['0','n','d',String(player.userId)];
 // DB/hangar levels are 0..5; lib_drones descriptor IDs use levels 1..6.
 // Level0 has no descriptor and triggers the client's debug turkey ship120.
 for(const d of ds)fields.push(String(META[d.loot_id].droneId),String(d.level+1),String(designId(eq.find(i=>i.drone_id===d.id&&i.drone_slot==='design')?.loot_id)),String(designId(eq.find(i=>i.drone_id===d.id&&i.drone_slot==='visual')?.loot_id)));
 return [{_: 'LegacyModule',message:fields.join('|')},{_: 'DroneFormationAvailableFormationsCommand',availableFormations:available(player.userId)},
  {_: 'DroneFormationChangeCommand',uid:player.userId,selectedFormationId:formation(player.userId)}];
}
function repair(playerId,id) {
 const result=tx(db=>{
  const d=droneFor(db,playerId,id),m=META[d.loot_id];
  if(d.damage<=0)return d;
  const w=require('./world').current(),p=w?.livePlayer(playerId),row=db.prepare('SELECT * FROM players WHERE id=?').get(playerId);
  const currency=m.repairable.currency.replace('currency_',''),cost=row.premium?m.repairable.premiumCost:m.repairable.baseCost;
  if(p)db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits,p.uridium,playerId);
  if(!db.prepare(`UPDATE players SET ${currency}=${currency}-? WHERE id=? AND ${currency}>=?`).run(cost,playerId,cost).changes)throw new Error('Diroit tamiri için bakiye yetersiz.');
  const lower=Math.max(0,d.level-1);
  db.prepare('UPDATE drones SET damage=0,level=?,experience=? WHERE id=?').run(lower,XP.thresholds[lower],d.id);
  return {currency,cost,live:p};
 });
 if(result.live)result.live[result.currency]-=result.cost;
 refresh(playerId);
 return true;
}
function sell(playerId,id) {
 let live,credit=0;
 tx(db=>{
  const d=droneFor(db,playerId,id),m=META[d.loot_id];
  if(!m.sellable)throw new Error('Bu diroit satılamaz.');
  credit=m.sellable.credits;live=require('./world').current()?.livePlayer(playerId);
  if(live)db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(live.credits,live.uridium,playerId);
  db.prepare('UPDATE players SET credits=credits+? WHERE id=?').run(credit,playerId);
  db.prepare('DELETE FROM drones WHERE id=?').run(d.id);
 });
 if(live)live.credits+=credit;
 refresh(playerId);return true;
}
// Numeric effects are documented in the bundled resource_items.xml descriptions.
const EFFECTS={
 1:{shield:1.1,laser:.925,rocket:.925},2:{laser:.97,rocket:1.2},3:{mine:1.5},
 4:{rocket:1.25,evasion:.05,launcherCooldown:1.33},5:{pvpLaser:1.03,honour:1.05,penetration:-.1},
 6:{rocket:1.3,penetration:.1,shield:.8},7:{hit:.7,regen:.01,regenMax:5000},8:{rocket:1.65,hit:.8},
 9:{hit:1.2,penetration:.2,drain:.05},10:{absorb:.2,speed:.85},11:{shield:1.2,hit:1.2,laser:.95},
 12:{npcLaser:1.05,ep:1.05,absorb:-.15},13:{npcLaser:1.08,ep:1.08,speed:.85},
 14:{shield:1.85,speed:.95,laser:.75,rocketCooldown:1.25,launcherCooldown:1.25},
 15:{laser:1.2,shield:.75,absorb:-.05,speed:.95},16:{honour:1.2,laser:.8,hit:.8,shield:.8},
 17:{shield:1.3,regen:.005,laser:.5,speed:.5,rocketCooldown:.75,launcherCooldown:.75},18:{speed:1.05,laser:.8,drain:.05},
 42:{hit:1.08,npcLaser:1.05,ep:1.05,pvpLaser:0,honour:0}
};
function effects(playerId) {return EFFECTS[formation(playerId)]||{};}
function menuStatus(playerId,c){const id=formationIds[c.menuItemId];if(id===undefined)return c;const yes=available(playerId).includes(id);return{...c,visible:yes,available:yes,activatable:yes&&(id===0||owned(open(),playerId).length>=4),selected:yes&&formation(playerId)===id,blocked:false};}
function applyStats(playerId,stats) {
 const e=effects(playerId),out={...stats};
 const db=open(),ship=db.prepare('SELECT s.id,t.hitpoints FROM players p JOIN ships s ON s.id=p.active_ship_id JOIN ship_types t ON t.loot_id=s.loot_id WHERE p.id=?').get(playerId);
 const designs=require('./drone-designs'),design=designs.effects(owned(db,playerId),ship?equipped(db,ship.id,require('./inventory').activeConfig(db,ship.id)):[]);
 out.hitMax=Math.round(out.hitMax*(1+design.hpBonus));
  if(Number.isFinite(out.speedGeneratorBonus))out.speedGeneratorBonus*=e.speed??1;
 for(const [key,prop]of [['hitMax','hit'],['shieldMax','shield'],['speed','speed'],['laserDamage','laser']])out[key]=Math.round(out[key]*(e[prop]??1));
 out.shieldAbsorb=Math.max(0,Math.min(1,out.shieldAbsorb+(e.absorb||0)));
 // Hermes HP is an additive base-hull bonus, unaffected by drone formations.
 out.hitMax+=Math.round((ship?.hitpoints||0)*design.baseHpBonus);
 out.npcLaserMultiplier=(e.npcLaser??1)*design.npcLaserMultiplier;out.rocketMultiplier=(stats.rocketMultiplier??1)*(e.rocket??1)*design.rocketMultiplier;out.shieldPenetration=Math.max(0,Math.min(1,(stats.shieldPenetration||0)+(e.penetration||0)));
 out.abilityCooldownReduction=(stats.abilityCooldownReduction||0)+design.abilityCooldownReduction;
 out.droneDesigns=designs.summary(design);
 out.formation=e;return out;
}
function tick(player,send,seconds=1) {
 if(player.dead)return;
 const e=effects(player.userId),before=player.shield;
 if(e.drain)player.shield=Math.max(0,Math.round(player.shield-player.shieldMax*e.drain*seconds));
 if(e.regen)player.shield=Math.min(player.shieldMax,Math.round(player.shield+Math.min(player.shieldMax*e.regen,e.regenMax||Infinity)*seconds));
 if(before!==player.shield)send({_: 'AttributeShieldUpdateCommand',shieldNow:player.shield,shieldMax:player.shieldMax});
}
function decoratePortal(playerId,response) {
 const {ret,map}=response.data,db=open(),list=owned(db,playerId);
 const droneGroup=map.types.includes('Drone_DroneType')?map.types.indexOf('Drone_DroneType'):map.types.push('Drone_DroneType')-1;
 for(const d of list)if(!map.lootIds.includes(d.loot_id)) {
  const m=META[d.loot_id],L=map.lootIds.push(d.loot_id)-1;
  ret.itemInfo.push({L,name:m.typeValue,T:droneGroup,C:'drone',levels:Array.from({length:6},()=>({
   slotsets:{default:{T:[0,4,7,8,9,10,11],Q:m.slots},design:{T:[18],Q:1},visual:{T:[19],Q:1}},...(m.sellable?{selling:m.sellable}:{})
  }))});
 }
 for(const h of ret.hangars) {
  h.general.drones=list.map(d=>({I:d.id,L:map.lootIds.indexOf(d.loot_id),LV:d.level,HP:`${Math.round(d.damage)}%`,EF:'',BE:{1:'',2:''},DE:'',CU:'',DL:d.upgrade_level+1,SL:d.upgrade_level+1,
   repair:META[d.loot_id].repairable.baseCost,currency:META[d.loot_id].repairable.currency}));
  for(const config of [1,2]) {
   const eq=equipped(db,Number(h.hangarID),config);
   h.config[config].drones=Object.fromEntries(list.map(d=>[String(d.id),{EQ:Object.fromEntries(['default','design','visual'].map(slot=>[slot,eq.filter(i=>i.drone_id===d.id&&i.drone_slot===slot).map(i=>i.id)]))}]));
  }
 }
 for(const item of ret.items) {
  const assignments=db.prepare('SELECT ship_id,config_id FROM drone_equipment WHERE item_id=?').all(item.I);
  if(assignments.length){item.EQH=assignments[0].ship_id;item.EQC=assignments.length===2?3:assignments[0].config_id;item.EQT='drone';}
 }
 return response;
}
function nextLevel(level){return XP.thresholds[level+1]||0;}
function levelFor(points){let level=0;while(level<5&&points>=XP.thresholds[level+1])level++;return level;}
function awardPoints(playerId,points){
 if(!Number.isSafeInteger(points)||points<0||points>1000000)throw new Error('Geçersiz diroit puanı.');
 let changed=false;
 tx(db=>{for(const d of owned(db,playerId)){
  const experience=Math.min(Number.MAX_SAFE_INTEGER,d.experience+points),level=levelFor(experience);if(level!==d.level)changed=true;
  db.prepare('UPDATE drones SET experience=?,level=? WHERE id=?').run(experience,level,d.id);
 }});
 if(changed)refresh(playerId);return changed;
}
function npcPoints(player,npc,config={}){
 const def=npc.def||npc,raw=String(def.name||npc.name||'').replace(/[^a-zA-Z0-9]/g,''),key=raw==='StreuneR'?'streuner-upper':raw.toLowerCase();
 const override=config.drones?.pointsByNpc?.[def.typeId]??def.dronePoints;
 if(Number.isSafeInteger(override)&&override>=0)return override;
 let ship=player.typeId,m=META[ship];
 if(m?.baseShipId&&m.baseShipId!==m.shipId)ship=Object.keys(META).find(id=>META[id].typeClass?.endsWith('.ShipType')&&META[id].shipId===m.baseShipId)||ship;
 let index=XP.shipOrder.indexOf(ship);
 if(index<0)index=Math.max(0,Math.min(9,Number(m?.rankingFactor||10)-1));
 if(XP.npcPoints[key])return XP.npcPoints[key][index];
 // Seasonal NPC server rules are absent from the shipped client. Local extension
 // is explicit and configurable; the historical standard NPC matrix above is exact.
 return Math.max(0,Math.min(1000000,config.drones?.unknownNpcPoints??Math.max(1,Math.floor((def.reward?.ep||0)/400))));
}
function onNpcKill(world,npc){const points=npcPoints(world.player,npc,world.config);awardPoints(world.player.userId,points);return points;}
function onPlayerDeath(world){
 tx(db=>{for(const d of owned(db,world.player.userId)){
  const damage=Math.round((d.damage+100/META[d.loot_id].durability)*1000000)/1000000;
  if(damage>=99.99999)db.prepare('DELETE FROM drones WHERE id=?').run(d.id);
  else db.prepare('UPDATE drones SET damage=? WHERE id=?').run(damage,d.id);
 }});refresh(world.player.userId);
}
module.exports={META,formationIds,owned,droneFor,addOwned,equipped,statItems,designId,move,equipMany,views,configs,available,formation,selectFormation,buildCommands,repair,sell,effects,applyStats,tick,decoratePortal,nextLevel,levelFor,awardPoints,npcPoints,onNpcKill,onPlayerDeath,purchasePrice,shopState,menuStatus};
