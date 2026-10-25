'use strict';
const assembly=require('../assembly'),{open}=require('../db');
const META=require('../../docs/client-map.items.json').items;
function ids(playerId){return open().prepare('SELECT id FROM items WHERE player_id=? AND amount>0').all(playerId).map(i=>i.id);}
function active(s){return !!s.player&&(!s.world||typeof s.world.active!=='function'||s.world.active(s));}
function refresh(world,targets=[],options={}){
 const p=world?.player||options.player;if(!p)return[];
 const send=options.sendCmd||require('../net').sendCmd,inventory=assembly.inventoryCommand(p.userId),present=new Set(inventory.inventoryItemModules.map(i=>i.itemId)),commands=[];
 for(const id of options.previousIds||[])if(!present.has(id))commands.push({_:'InventoryItemRemovedCommand',itemId:id});
 // Only newly acquired target instances need recipe content. Never replay the
 // entire crafting catalogue for an ordinary inventory mutation.
 const previous=new Set(options.previousIds||[]),newTargets=inventory.inventoryItemModules.filter(i=>i.itemId>0&&(!previous.has(i.itemId)||options.targetRecipes)&&META[i.lootId]?.upgradable),recipes=[];
 if(options.previousIds||options.targetRecipes)for(const[id,r]of Object.entries(assembly.RECIPES))if(r.targets?.length&&!assembly.unsupportedReason(id))for(const item of newTargets)if(r.targets.includes(item.lootId))recipes.push({_:'AssemblyRecipeModule',recipeLootId:id,targetItemId:item.itemId,type:{_:'AssemblyRecipeRegularTypeModule'},status:assembly.status(p.userId,id,item.itemId)});
 if(recipes.length)commands.push({_:'AssemblyRecipeContentModule',recipes});
 const seen=new Set();for(const t of targets){const key=t.recipeLootId+':'+(t.targetItemId||0);if(seen.has(key))continue;seen.add(key);commands.push(assembly.updateCommand(p.userId,t.recipeLootId,t.targetItemId||0));}
 commands.push(inventory,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});
 const result=options.results||[],parts=result.flatMap(r=>r.parts||[]),lootIds=new Set(parts.map(i=>i.lootID));
 if([...lootIds].some(id=>id.startsWith('ammunition_')))for(const c of require('../ammo').buildAmmoCommands(p))if(lootIds.has(c.menuItemId))commands.push(c);
 if([...lootIds].some(id=>id.startsWith('resource_ore_')))commands.push(...require('../collectables').resourceCommands(p));
 const sessions=options.session?[options.session]:world?.sessions||[];for(const s of sessions)for(const c of commands)send(s,c);
 if(world&&result.length){
  if(result.some(r=>r.upgrade)||parts.some(part=>META[part.lootID]?.kind==='Booster'))world.refreshStats?.();
  if([...lootIds].some(id=>/^resource_booty-key/.test(id)))require('../booty').notify(world);
  if([...lootIds].some(id=>id==='pet_pet10'||id==='resource_pet-fuel'||META[id]?.typeClass?.includes('.pet.')))require('../pet').purchased(world,'resource_pet-fuel');
  if(parts.some(part=>META[part.lootID]?.kind==='Booster'))require('../boosters').purchased(world);
 }
 return commands;
}
function register(onCmd,{sendCmd}){
 const error=(s,e)=>sendCmd(s,{_:'LegacyModule',message:`0|A|STD|${String(e.message).replace(/[|\r\n]/g,' ')}`});
 const unsupported=(s,feature)=>{if(!active(s))return false;error(s,new Error(assembly.capabilities()[feature].reason));return false;};
 for(const name of ['UnstableModuleRerollRequest','UnstableModuleRestabiliseRequest','UnstableModuleRecycleRequest'])onCmd(name,s=>unsupported(s,'restabilize'));
 onCmd('QuantumFluidCoreRequest',s=>unsupported(s,'hyperforge'));
 function mutate(s,requests,operation){
  if(!active(s))return;const previousIds=ids(s.player.userId),changed=[],results=[];
  for(const r of requests){try{
   if(operation==='collect'){const row=open().prepare('SELECT result_json FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=? AND target_id=?').get(s.player.userId,r.recipeLootId,r.targetItemId||0);const cmd=assembly.collect(s.player.userId,r.recipeLootId,r.targetItemId||0,Date.now(),{notify:false});if(row)results.push(JSON.parse(row.result_json));changed.push({recipeLootId:r.recipeLootId,targetItemId:cmd.targetItemId||0});}
   else{const cmd=operation==='skip'?assembly.skip(s.player.userId,r.recipeLootId,r.targetItemId||0):assembly.build(s.player.userId,r.recipeLootId,r.amount,r.targetItemId||0);changed.push({recipeLootId:r.recipeLootId,targetItemId:cmd.targetItemId||0});}
  }catch(e){error(s,e);}}
  if(changed.length)refresh(s.world,changed,{previousIds,results,player:s.player,session:s,sendCmd});
 }
 onCmd('AssemblyBuildRequest',(s,c)=>mutate(s,[c],'build'));
 onCmd('DisassemblyRequest',(s,c)=>mutate(s,[{recipeLootId:c.recipeLootId,targetItemId:c.itemId,amount:1}],'build'));
 onCmd('AssemblyCollectRequest',(s,c)=>mutate(s,[c],'collect'));
 onCmd('AssemblySkipRequest',(s,c)=>mutate(s,[c],'skip'));
 onCmd('AssemblyCollectAllRequest',(s,c)=>{if(!Array.isArray(c.allRequests)||c.allRequests.length>2000)return;mutate(s,c.allRequests,'collect');});
 onCmd('AssemblyRecipeSelectRequest',(s,c)=>{if(active(s)&&assembly.visible(open(),s.player.userId,c.recipeLootId))sendCmd(s,assembly.updateCommand(s.player.userId,c.recipeLootId));});
 onCmd('AssemblySetFilterRequest',(s,c)=>{
  if(!active(s))return;const settings=c.assemblyWindowSettingsModule,type=[0,1,2].includes(c.filterType)?c.filterType:settings?.filterType;
  if(!settings||![0,1,2].includes(type)||!Array.isArray(settings.assemblyItemFilters)||settings.assemblyItemFilters.length>64||settings.assemblyItemFilters.some(v=>typeof v!=='string'||v.length>80))return;
  open().prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(s.player.userId,`assembly_filters_${type}`,JSON.stringify({...settings,filterType:type}));
  // Filter already applied locally. Echoing it invalidates the native list.
 });
}
module.exports={register,refresh,ids};
