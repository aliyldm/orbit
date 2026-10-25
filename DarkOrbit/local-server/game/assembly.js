'use strict';
// Contracts: AssemblyWindowMediator, TargetItemRecipeModel.collectSteps and the
// exact Recipe/BuildPart fields extracted from ItemDataProvider.initialize.
const {open,tx}=require('./db');
const META=require('../docs/client-map.items.json').items;
const RECIPES=require('./module-policy').transformRecipes(META);
const DRONE_OFFSET=1000000000,SHIP_OFFSET=2000000000;
const ORES=['prometium','endurium','terbium','xenomit','prometid','duranium','promerium','seprom','palladium'];
function ore(id){return id.startsWith('resource_ore_')?ORES.indexOf(id.slice(13)):-1;}
const fail=message=>{throw new Error(message);};
function number(n,max=10000000){if(!Number.isSafeInteger(n)||n<1||n>max)fail('Geçersiz üretim miktarı.');return n;}
function live(playerId){return require('./world').current()?.livePlayer(playerId);}
function syncBefore(db,playerId){const p=live(playerId);if(p)db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits,p.uridium,playerId);}
function syncAfter(playerId){const p=live(playerId);if(p){const r=open().prepare('SELECT credits,uridium FROM players WHERE id=?').get(playerId);p.credits=r.credits;p.uridium=r.uridium;}}
function count(db,playerId,id){
 if(id==='currency_credits'||id==='currency_uridium')return db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(playerId)?.[id.slice(9)]||0;
 if(META[id]?.typeClass?.endsWith('.ShipType'))return db.prepare('SELECT COUNT(*) n FROM ships WHERE player_id=? AND loot_id=?').get(playerId,id).n;
 if(META[id]?.kind==='Drone')return db.prepare('SELECT COUNT(*) n FROM drones WHERE player_id=? AND loot_id=?').get(playerId,id).n;
 if(META[id]?.typeClass?.endsWith('.ShipDesignType'))return db.prepare('SELECT COUNT(*) n FROM ship_designs WHERE player_id=? AND loot_id=?').get(playerId,id).n;
 if(ore(id)>=0)return db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=?').get(playerId,ore(id))?.amount||0;
 if(id==='resource_pet-fuel')return db.prepare('SELECT fuel FROM pets WHERE player_id=?').get(playerId)?.fuel||0;
 if(id==='resource_extra-energy')return db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(playerId)?.energy||0;
 return db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,id).n;
}
function visible(db,playerId,id){
 const r=RECIPES[id];if(!r)return false;
 if(r.targets?.length&&!['upgrade_item-upgrade','upgrade_drone-upgrade','disassemble_item-disassemble'].includes(r.result[0]?.lootID))return false;
 if(r.visibility==='ALWAYS_VISIBLE')return true;
 if(r.visibility==='ONLY_WHEN_OWNED')return count(db,playerId,id)>0;
 const config=require('./world').current()?.config?.assembly||require('../config.json').assembly||{};
 return !!config.enableAllScheduled||(config.enabledRecipes||[]).includes(id);
}
function unsupportedReason(id){
 const r=RECIPES[id];if(!r)return 'Tarif bulunamadı.';
 if((r.result||[]).some(p=>require('./equipment-policy').removed(p.lootID)))return require('./equipment-policy').REASON;
 if(r.targets?.length&&!['upgrade_item-upgrade','upgrade_drone-upgrade','disassemble_item-disassemble'].includes(r.result[0]?.lootID))return 'Klan savaş istasyonu sistemi bu yerel sürümde etkin değil.';
 if(!r.targets?.length)for(const p of r.result||[]){
  if(!META[p.lootID]&&!['currency_credits','currency_uridium'].includes(p.lootID))return `Sonuç istemci kataloğunda eksik: ${p.lootID}.`;
  if(META[p.lootID]?.kind==='Booster'){const why=require('./boosters').unsupportedReason(p.lootID);if(why)return why;}
  if(META[p.lootID]?.typeClass?.endsWith('.ShipUpgradeType')&&!require('./ship-modules').definition(p.lootID))return 'Bu kararsız veya doğrulanmamış gemi modülünün bonusları henüz uygulanmadı.';
 }
 for(const step of r.costs||[])for(const p of step.parts||[])if(!META[p.lootID]&&!['currency_credits','currency_uridium'].includes(p.lootID))return `Malzeme istemci kataloğunda eksik: ${p.lootID}.`;
 return null;
}
function targetFor(db,playerId,id,r){
 const drone=id>=DRONE_OFFSET&&id<SHIP_OFFSET;
 const row=drone?db.prepare('SELECT * FROM drones WHERE id=? AND player_id=?').get(id-DRONE_OFFSET,playerId):db.prepare('SELECT * FROM items WHERE id=? AND player_id=? AND amount=1').get(id,playerId);
 if(!row||!r.targets?.includes(row.loot_id))fail('Üretim hedefi bulunamadı veya tarif bu eşyaya uymuyor.');
 if(require('./equipment-policy').removed(row.loot_id))fail(require('./equipment-policy').REASON);
 return {row,drone,level:row.upgrade_level};
}
function freeItems(db,playerId,id){return db.prepare(`SELECT i.* FROM items i WHERE i.player_id=? AND i.loot_id=? AND i.ship_id IS NULL AND i.amount>0
 AND NOT EXISTS(SELECT 1 FROM equipment_config2 e WHERE e.item_id=i.id)
 AND NOT EXISTS(SELECT 1 FROM drone_equipment e WHERE e.item_id=i.id)
 AND NOT EXISTS(SELECT 1 FROM pet_equipment e WHERE e.item_id=i.id)
 AND NOT EXISTS(SELECT 1 FROM assembly_jobs j WHERE j.player_id=i.player_id AND j.target_id=i.id) ORDER BY i.id`).all(playerId,id);}
function consume(db,playerId,id,amount){
 if(!Number.isFinite(amount)||amount<=0||amount>Number.MAX_SAFE_INTEGER)fail('Geçersiz tarif maliyeti.');
 if(id==='currency_credits'||id==='currency_uridium'){
  const field=id.slice(9);if(!db.prepare(`UPDATE players SET ${field}=${field}-? WHERE id=? AND ${field}>=?`).run(amount,playerId,amount).changes)fail('Üretim için bakiye yetersiz.');return;
 }
 if(ore(id)>=0){if(!db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=? AND amount>=?').run(amount,playerId,ore(id),amount).changes)fail('Üretim için maden yetersiz.');return;}
 if(id==='resource_pet-fuel'){if(!db.prepare('UPDATE pets SET fuel=fuel-? WHERE player_id=? AND fuel>=?').run(amount,playerId,amount).changes)fail('Üretim için PET yakıtı yetersiz.');return;}
 if(id==='resource_extra-energy'){if(!db.prepare('UPDATE galaxy_gate_accounts SET energy=energy-? WHERE player_id=? AND energy>=?').run(amount,playerId,amount).changes)fail('Üretim için ekstra enerji yetersiz.');return;}
 if(META[id]?.typeClass?.endsWith('.ShipType')){
  if(live(playerId))fail('Gemi dönüşümü için önce oyundan çık.');
  const ships=db.prepare('SELECT id FROM ships WHERE player_id=? AND loot_id=? AND id<>(SELECT active_ship_id FROM players WHERE id=?) ORDER BY id').all(playerId,id,playerId);
  if(!Number.isSafeInteger(amount)||ships.length<amount)fail('Tarif için aktif olmayan yeterli gemi yok.');
  for(const s of ships.slice(0,amount)){
   db.prepare('UPDATE items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE ship_id=?').run(s.id);
   db.prepare('DELETE FROM ships WHERE id=?').run(s.id);
  }
  return;
 }
 const rows=freeItems(db,playerId,id);
 if(!Number.isSafeInteger(amount)||rows.reduce((n,r)=>n+r.amount,0)<amount)fail('Üretim için depodaki malzeme yetersiz.');
 let left=amount;for(const row of rows){const take=Math.min(left,row.amount);db.prepare('UPDATE items SET amount=amount-? WHERE id=?').run(take,row.id);left-=take;if(!left)break;}
}
function combine(parts){const out=new Map();for(const p of parts){if(!Number.isFinite(p.ammount)||p.ammount<=0)fail('Tarif maliyeti tanınmıyor.');out.set(p.lootID,(out.get(p.lootID)||0)+p.ammount);}return [...out].map(([lootID,ammount])=>({lootID,ammount}));}
function status(playerId,id,targetId=0,now=Date.now()){
 const db=open(),job=db.prepare('SELECT * FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=? AND target_id=?').get(playerId,id,targetId);
 const uses=db.prepare('SELECT uses FROM assembly_usage WHERE player_id=? AND recipe_loot_id=?').get(playerId,id)?.uses||0;
 return statusValue(RECIPES[id],job,uses,now);
}
function statusValue(r,job,uses,now){
 if(job)return job.due_at>now?{_: 'AssemblyRecipeBuildStatusModule',buildAmount:job.amount,remainingTimeMillis:job.due_at-now,prevBuildCount:uses}:{_: 'AssemblyRecipeReadyToCollectStatusModule',buildAmount:job.amount,prevBuildCount:uses};
 if(!r)fail('Tarif bulunamadı.');
 const max=r.usingStrategy==='USABLE_ONCE'?1:r.maxUses;
 if(!r.targets?.length&&uses>=max)return {_: 'AssemblyRecipeUnavailableStatusModule',type:1};
 return {_: 'AssemblyRecipeAvailableStatusModule',currentBuildCount:uses,isNew:false};
}
function updateCommand(playerId,id,target=0,now=Date.now()){return {_: 'AssemblyRecipeStatusUpdateCommand',lootId:id,targetItemId:target,status:status(playerId,id,target,now)};}
function build(playerId,id,amount,targetId=0,now=Date.now()){
 number(amount);if(!Number.isSafeInteger(targetId)||targetId<0)fail('Geçersiz üretim hedefi.');
 tx(db=>{
  const r=RECIPES[id];if(!r||!visible(db,playerId,id))fail('Bu tarif kullanılamıyor.');
  const why=unsupportedReason(id);if(why)fail(why);
  if(db.prepare('SELECT 1 FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=? AND target_id=?').get(playerId,id,targetId))fail('Bu üretim zaten devam ediyor.');
  let steps,result,multiplier=amount,refund=[];
  if(r.targets?.length){
   const t=targetFor(db,playerId,targetId,r),max=Math.max(...r.costs.map(c=>c.level));
   if(db.prepare('SELECT 1 FROM assembly_jobs WHERE player_id=? AND target_id=?').get(playerId,targetId))fail('Bu eşya başka bir üretimde kilitli.');
   if(r.result[0]?.lootID==='disassemble_item-disassemble'){
    if(t.drone||amount!==1||t.level<1||t.level>max||!freeItems(db,playerId,t.row.loot_id).some(i=>i.id===targetId))fail('Söküm için yükseltilmiş ve takılı olmayan bir eşya seç.');
    steps=r.costs.filter(c=>c.level===t.level).map(c=>({...c,parts:(c.parts||[]).filter(p=>p.ammount>0)}));
    refund=r.costs.find(c=>c.level===t.level).parts.filter(p=>p.ammount<0).map(p=>({...p,ammount:-p.ammount}));multiplier=1;
    result={disassemble:{targetId,level:t.level,lootId:t.row.loot_id},parts:refund};
   }else{
    if(amount<=t.level||amount>max)fail('Geçersiz yükseltme seviyesi.');
    steps=r.costs.filter(c=>c.level>t.level&&c.level<=amount);multiplier=1;
    result={upgrade:{targetId,from:t.level,to:amount,drone:t.drone,lootId:t.row.loot_id}};
   }
  }else{
   if(targetId!==0||(!r.stackable&&amount!==1))fail('Bu tarif bu miktarla üretilemez.');
   const current=status(playerId,id,0,now);if(current._!=='AssemblyRecipeAvailableStatusModule')fail('Bu tarifin kullanım sınırına ulaştın.');
   const max=r.usingStrategy==='USABLE_ONCE'?1:r.maxUses;
   if(current.currentBuildCount+amount>max)fail('Tarifin kullanım sınırı aşılıyor.');
   steps=r.costs.filter(c=>c.level===0);if(!steps.length)fail('Tarif maliyeti bulunamadı.');
   result={parts:r.result.map(p=>({lootID:p.lootID,ammount:p.ammount*amount}))};
   for(const p of result.parts){if(!META[p.lootID]&&!p.lootID.startsWith('currency_'))fail('Tarif sonucu katalogda yok.');if(META[p.lootID]?.maxQuantity>0&&count(db,playerId,p.lootID)+p.ammount>META[p.lootID].maxQuantity)fail('Azami eşya sayısı aşılır.');}
  }
  if(!r.targets?.length&&r.costScalingFactor!==1){const used=status(playerId,id,0,now).currentBuildCount,f=r.costScalingFactor;multiplier=(Math.pow(f,used+amount)-Math.pow(f,used))/(f-1);}
  const costs=combine(steps.flatMap(c=>c.parts||[]).map(p=>({...p,ammount:Math.round(p.ammount*multiplier)}))),skip=combine(steps.flatMap(c=>c.skipCosts||[]));
  const duration=steps.reduce((n,c)=>n+c.buildTimeSec,0)*1000*(r.targets?.length?1:amount);
  if(!Number.isSafeInteger(duration)||duration<0)fail('Geçersiz üretim süresi.');
  syncBefore(db,playerId);for(const c of costs)consume(db,playerId,c.lootID,c.ammount);
  db.prepare('INSERT INTO assembly_jobs(player_id,recipe_loot_id,target_id,amount,started_at,due_at,result_json,skip_json)VALUES(?,?,?,?,?,?,?,?)').run(playerId,id,targetId,amount,now,now+duration,JSON.stringify(result),JSON.stringify(skip));
  if(!r.targets?.length)db.prepare('INSERT INTO assembly_usage(player_id,recipe_loot_id,uses)VALUES(?,?,?) ON CONFLICT(player_id,recipe_loot_id)DO UPDATE SET uses=uses+excluded.uses').run(playerId,id,amount);
 });
 syncAfter(playerId);return updateCommand(playerId,id,targetId,now);
}
function award(db,playerId,id,amount){
 if(require('./equipment-policy').removed(id))return;
 number(amount);const m=META[id];
 if(id==='currency_credits'||id==='currency_uridium'){db.prepare(`UPDATE players SET ${id.slice(9)}=${id.slice(9)}+? WHERE id=?`).run(amount,playerId);return;}
 if(m?.kind==='Drone'){for(let n=0;n<amount;n++)require('./drones').addOwned(db,playerId,id);return;}
 if(m?.typeClass?.endsWith('.ShipDesignType')){if(amount!==1)fail('Birden fazla aynı tasarım üretilemez.');require('./inventory').addDesign(db,playerId,id);return;}
 if(m?.typeClass?.endsWith('.ShipType')){const type=db.prepare('SELECT hitpoints FROM ship_types WHERE loot_id=?').get(id);if(!type)fail('Gemi katalogda yok.');for(let n=0;n<amount;n++)db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,?)').run(playerId,id,type.hitpoints);return;}
 if(id==='pet_pet10'){require('./pet').addOwned(db,playerId,amount);return;}
 if(id==='resource_pet-fuel'){require('./pet').addFuel(db,playerId,amount);return;}
 if(ore(id)>=0){db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=amount+excluded.amount').run(playerId,ore(id),amount);return;}
 if(id==='resource_extra-energy'){db.prepare('INSERT OR IGNORE INTO galaxy_gate_accounts(player_id)VALUES(?)').run(playerId);if(!db.prepare('UPDATE galaxy_gate_accounts SET energy=energy+? WHERE player_id=? AND energy<=?').run(amount,playerId,2147483647-amount).changes)fail('Ekstra enerji kapasitesi aşıldı.');return;}
 if(m?.kind==='Booster'){require('./boosters').addOwned(db,playerId,id,amount);return;}
 const item=db.prepare('SELECT * FROM item_types WHERE loot_id=?').get(id);if(!item)fail('Üretim sonucu katalogda yok.');
 if(m.maxQuantity>0&&count(db,playerId,id)+amount>m.maxQuantity)fail('Azami eşya sayısı aşılır.');
 if(m.stackable){const row=freeItems(db,playerId,id)[0];if(row)db.prepare('UPDATE items SET amount=amount+? WHERE id=?').run(amount,row.id);else db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(playerId,id,amount);}
 else{if(amount>10000)fail('Bir işlemde fazla ekipman üretilemez.');for(let n=0;n<amount;n++)db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,1)').run(playerId,id);}
}
function collect(playerId,id,targetId=0,now=Date.now(),options={}){
 tx(db=>{
  const job=db.prepare('SELECT * FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=? AND target_id=?').get(playerId,id,targetId);
  if(!job||job.due_at>now)fail('Toplanacak tamamlanmış üretim yok.');
  syncBefore(db,playerId);
  const result=JSON.parse(job.result_json);
  if(result.disassemble){const t=targetFor(db,playerId,targetId,RECIPES[id]);if(t.level!==result.disassemble.level||t.row.loot_id!==result.disassemble.lootId||t.row.ship_id!==null||db.prepare('SELECT 1 FROM equipment_config2 WHERE item_id=? UNION ALL SELECT 1 FROM drone_equipment WHERE item_id=? UNION ALL SELECT 1 FROM pet_equipment WHERE item_id=?').get(targetId,targetId,targetId))fail('Söküm hedefi değişti veya gemiye takıldı.');db.prepare('UPDATE items SET amount=0 WHERE id=? AND player_id=?').run(targetId,playerId);}
  if(result.upgrade){const t=targetFor(db,playerId,targetId,RECIPES[id]);if(t.level!==result.upgrade.from)fail('Yükseltme hedefi değişti.');db.prepare(`UPDATE ${t.drone?'drones':'items'} SET upgrade_level=? WHERE id=?`).run(result.upgrade.to,t.row.id);}
  else for(const p of result.parts)award(db,playerId,p.lootID,p.ammount);
  db.prepare('DELETE FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=? AND target_id=?').run(playerId,id,targetId);
 });
 syncAfter(playerId);const w=require('./world').current();if(options.notify!==false&&w?.livePlayer(playerId)){w.refreshStats();require('./booty').notify(w);if(require('./pet').owned(playerId))require('./pet').purchased(w,'resource_pet-fuel');require('./boosters').purchased(w);}
 return updateCommand(playerId,id,targetId,now);
}
function skip(playerId,id,targetId=0,now=Date.now()){
 tx(db=>{
  const job=db.prepare('SELECT * FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=? AND target_id=?').get(playerId,id,targetId);
  if(!job||job.due_at<=now)fail('Atlanacak üretim yok.');
  const result=JSON.parse(job.result_json),r=RECIPES[id];
  // Previously paid jobs keep their result and deadline; a new skip request
  // uses today's module policy rather than a saved obsolete ore/currency fee.
  const costs=result.upgrade?combine(r.costs.filter(c=>c.level>result.upgrade.from&&c.level<=result.upgrade.to).flatMap(c=>c.skipCosts||[])):!r.targets?.length?combine(r.costs.flatMap(c=>c.skipCosts||[])):JSON.parse(job.skip_json);
  if(!costs.length)fail('Bu tarifin süre atlama maliyeti tanımlı değil.');
  syncBefore(db,playerId);for(const c of costs)consume(db,playerId,c.lootID,c.ammount);
  db.prepare('UPDATE assembly_jobs SET due_at=?,notified=0 WHERE player_id=? AND recipe_loot_id=? AND target_id=?').run(now,playerId,id,targetId);
 });syncAfter(playerId);return updateCommand(playerId,id,targetId,now);
}
function inventoryCommand(playerId){
 const db=open(),rows=db.prepare('SELECT * FROM items WHERE player_id=? AND amount>0 ORDER BY id').all(playerId),player=db.prepare('SELECT * FROM players WHERE id=?').get(playerId);
 const wallet=live(playerId)||player;
 const bindings=new Map();for(const table of ['equipment_config2','drone_equipment','pet_equipment'])for(const row of db.prepare(`SELECT e.item_id,e.ship_id FROM ${table} e JOIN items i ON i.id=e.item_id WHERE i.player_id=?`).all(playerId))if(!bindings.has(row.item_id))bindings.set(row.item_id,row.ship_id);
 // Native ItemVO.isEquipped is hangarId!=0. Include every equipment owner,
 // otherwise Disassembly presents second-config/drone/PET items as unequipped.
 const items=rows.map(i=>({_: 'InventoryItemModule',lootId:i.loot_id,itemId:i.id,amount:i.amount,upgradeLevel:i.upgrade_level,hangarId:i.ship_id||bindings.get(i.id)||0,extAttributes:[],inventoryItemAttributes:[]}));
 for(const d of require('./drones').owned(db,playerId))items.push({_: 'InventoryItemModule',lootId:d.loot_id,itemId:DRONE_OFFSET+d.id,amount:1,upgradeLevel:d.upgrade_level,extAttributes:[],inventoryItemAttributes:[{_:'InventoryItemAttributeModule',key:1,value:String(d.level+1)}]});
 for(const s of db.prepare('SELECT * FROM ships WHERE player_id=?').all(playerId))items.push({_: 'InventoryItemModule',lootId:s.loot_id,itemId:SHIP_OFFSET+s.id,amount:1,hangarId:s.id});
 for(const [id,field,key]of [[-1,'credits','currency_credits'],[-2,'uridium','currency_uridium']])items.push({_: 'InventoryItemModule',lootId:key,itemId:id,amount:wallet[field]});
 for(let index=0;index<ORES.length;index++)items.push({_: 'InventoryItemModule',lootId:`resource_ore_${ORES[index]}`,itemId:-20-index,amount:count(db,playerId,`resource_ore_${ORES[index]}`)});
 for(const [id,key]of [[-11,'resource_pet-fuel'],[-12,'resource_extra-energy']])items.push({_: 'InventoryItemModule',lootId:key,itemId:id,amount:count(db,playerId,key)});
 return {_: 'UserInventoryModule',inventoryItemModules:items,activePremiumDiscount:0,activeRebateSubDiscount:0,activeHappyUpgradeDiscount:0};
}
function recipeModules(player,now=Date.now(),targetsOnly=false){
 const db=open(),recipes=[],ownedItems=db.prepare('SELECT id,loot_id FROM items WHERE player_id=? AND amount=1').all(player.userId),ownedDrones=require('./drones').owned(db,player.userId);
 const jobs=new Map(db.prepare('SELECT * FROM assembly_jobs WHERE player_id=?').all(player.userId).map(j=>[j.recipe_loot_id+':'+j.target_id,j]));
 const usage=new Map(db.prepare('SELECT recipe_loot_id,uses FROM assembly_usage WHERE player_id=?').all(player.userId).map(r=>[r.recipe_loot_id,r.uses]));
 for(const [id,r]of Object.entries(RECIPES)){
  if(targetsOnly&&!r.targets?.length)continue;
  if(!visible(db,player.userId,id)||unsupportedReason(id))continue;
  // UpgradeTypeModel.filterEmpty requires a generic recipe state (target=0)
  // in addition to owned target rows. Per-item states alone leave its recipes
  // vector empty and hide every Upgrade/Disassembly type in the shipped client.
  const targets=r.targets?.length?[0,...ownedItems.filter(i=>r.targets.includes(i.loot_id)).map(i=>i.id),...ownedDrones.filter(i=>r.targets.includes(i.loot_id)).map(i=>DRONE_OFFSET+i.id)]:[0];
  for(const targetItemId of targets)recipes.push({_: 'AssemblyRecipeModule',recipeLootId:id,targetItemId,type:{_: 'AssemblyRecipeRegularTypeModule'},status:statusValue(r,jobs.get(id+':'+targetItemId),usage.get(id)||0,now)});
 }
 return recipes;
}
function refreshInventory(world,sendCmd=require('./net').sendCmd,now=Date.now()){
 const p=world?.player;if(!p)return[];
 // Reuse the native bootstrap dependency order, but do not resend hundreds of
 // unrelated ordinary crafting recipes for a shop purchase/equipment update.
 const commands=[{_:'AssemblyRecipeContentModule',recipes:recipeModules(p,now,true)},inventoryCommand(p.userId)];
 world.broadcast(session=>{for(const command of commands)sendCmd(session,command);});return commands;
}
function buildInit(player,now=Date.now()){
 const db=open(),recipes=recipeModules(player,now);
 const defaults=['ships_and_designs','ammunition','weapons','pet','generators','drones','extras','boosters','hardware','modules','techs'];
 const filters=[0,1,2].map(filterType=>{
  const row=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(player.userId,`assembly_filters_${filterType}`)||db.prepare("SELECT value FROM settings WHERE player_id=? AND key='assembly_filters'").get(player.userId);
  let saved;try{saved=row&&JSON.parse(row.value);}catch{}
  return {_: 'AssemblyWindowSettingsModule',filterType,assemblyItemFilters:saved?.filterType===filterType&&Array.isArray(saved.assemblyItemFilters)?saved.assemblyItemFilters:defaults};
 });
 // RecipeContent triggers InitAssemblyWindowProxyCommand, which registers the
 // DiscountProxy used unconditionally by UserInventoryHandler. Sending inventory
 // first throws before InventoryModel.isInitialized and leaves the native window
 // behind its in-progress overlay forever on a fresh client.
 return [{_: 'AssemblyRecipeContentModule',recipes},inventoryCommand(player.userId),...filters];
}
function tick(world,sendCmd,now=Date.now()){
 const p=world.player;if(!p)return;
 const jobs=open().prepare('SELECT * FROM assembly_jobs WHERE player_id=? AND due_at<=? AND notified=0').all(p.userId,now);
 for(const j of jobs){const cmd=updateCommand(p.userId,j.recipe_loot_id,j.target_id,now);world.broadcast(s=>sendCmd(s,cmd));open().prepare('UPDATE assembly_jobs SET notified=1 WHERE player_id=? AND recipe_loot_id=? AND target_id=?').run(p.userId,j.recipe_loot_id,j.target_id);}
}
function capabilities(){return{assembly:{supported:true},upgrade:{supported:true,sourceRecipeClasses:Object.keys(RECIPES).filter(id=>id.startsWith('upgrade_')&&!unsupportedReason(id))},disassembly:{supported:true,sourceRecipeClasses:Object.keys(RECIPES).filter(id=>id.startsWith('disassemble_')&&!unsupportedReason(id))},restabilize:{supported:false,reason:'Stabilize: eşya başına özgün rastgele bonuslar, geçerli gemiler ve yeniden dengeleme maliyet verisi bu yerel sürümde henüz yok.'},hyperforge:{supported:false,reason:'Hyperforge: kuantum çekirdeği başına özgün nitelik, kalite, geliştirme maliyeti ve geri dönüşüm verisi bu yerel sürümde henüz yok.'}};}
module.exports={RECIPES,DRONE_OFFSET,count,visible,unsupportedReason,status,updateCommand,build,collect,skip,award,inventoryCommand,buildInit,refreshInventory,tick,capabilities};
