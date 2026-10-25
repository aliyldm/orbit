'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict');
const dbModule=require('../game/db'),players=require('../game/db/players'),assembly=require('../game/assembly'),World=require('../game/world'),META=require('../docs/client-map.items.json').items;
let db,index=0;const originalWorld=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});after(()=>{World.current=originalWorld;dbModule.close();});
function fixture(){const name=`assembly-full-${++index}`,acc=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test'),pid=players.createPlayer(Number(acc.lastInsertRowid),name,1,require('../config.json').starter);db.prepare('UPDATE players SET uridium=1000000000000,credits=1000000000000 WHERE id=?').run(pid);return pid;}
function give(pid,id,n){
 if(id.startsWith('currency_'))return;
 if(id.startsWith('resource_ore_')){const k=['prometium','endurium','terbium','xenomit','prometid','duranium','promerium','seprom','palladium'].indexOf(id.slice(13));db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,?,?) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=amount+excluded.amount').run(pid,k,n);return;}
 if(META[id]?.typeClass?.endsWith('.ShipType')){const t=db.prepare('SELECT hitpoints FROM ship_types WHERE loot_id=?').get(id);for(let i=0;i<n;i++)db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,?)').run(pid,id,t.hitpoints);return;}
 if(id==='resource_pet-fuel'){if(!require('../game/pet').owned(pid))require('../game/pet').addOwned(db,pid,1);require('../game/pet').addFuel(db,pid,n);return;}
 if(id==='resource_extra-energy'){db.prepare('INSERT OR IGNORE INTO galaxy_gate_accounts(player_id)VALUES(?)').run(pid);db.prepare('UPDATE galaxy_gate_accounts SET energy=energy+? WHERE player_id=?').run(n,pid);return;}
 return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(pid,id,n).lastInsertRowid);
}

test('every recoverable regularsource recipe can build and deliver after exactmaterial grant',()=>{
 const failed=[],counts={passed:0,blocked:0};
 for(const [id,r]of Object.entries(assembly.RECIPES)){
  if(r.targets?.length)continue;if(assembly.unsupportedReason(id)){counts.blocked++;continue;}
  const pid=fixture();try{
   if(r.visibility==='ONLY_WHEN_OWNED')give(pid,id,1);
   for(const p of r.costs.find(c=>c.level===0)?.parts||[])give(pid,p.lootID,p.ammount);
   assembly.build(pid,id,1,0,1000);const job=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=?').get(pid,id);assembly.collect(pid,id,0,job.due_at);
   assert.equal(db.prepare('SELECT COUNT(*) n FROM assembly_jobs WHERE player_id=?').get(pid).n,0);counts.passed++;
  }catch(e){failed.push(`${id}: ${e.message}`);}
 }
 assert.deepEqual(failed,[]);assert.ok(counts.passed>=500,JSON.stringify(counts));
});

test('every sourceitem/drone upgradeclass grants exact finallevel with summedperstep cost',()=>{
 const failed=[];let count=0;
 for(const [id,r]of Object.entries(assembly.RECIPES)){
  if(!r.targets?.length||!/^upgrade_(item|drone)-upgrade$/.test(r.result[0]?.lootID))continue;
  const pid=fixture();try{
   const loot=r.targets.find(id=>!require('../game/equipment-policy').removed(id));if(!loot)continue;const drone=META[loot].kind==='Drone',physical=drone?require('../game/drones').addOwned(db,pid,loot):give(pid,loot,1),target=drone?assembly.DRONE_OFFSET+physical:physical,max=Math.max(...r.costs.map(c=>c.level)),costs=new Map();
   for(const c of r.costs)for(const p of c.parts)costs.set(p.lootID,(costs.get(p.lootID)||0)+p.ammount);
   for(const [loot,n]of costs)give(pid,loot,n);assembly.build(pid,id,max,target,1000);const job=db.prepare('SELECT due_at FROM assembly_jobs WHERE player_id=? AND target_id=?').get(pid,target);assembly.collect(pid,id,target,job.due_at);
   assert.equal(db.prepare(`SELECT upgrade_level FROM ${drone?'drones':'items'} WHERE id=?`).get(physical).upgrade_level,max);count++;
  }catch(e){failed.push(`${id}: ${e.message}`);}
 }
 assert.deepEqual(failed,[]);assert.equal(count,Object.values(assembly.RECIPES).filter(r=>r.targets?.some(id=>!require('../game/equipment-policy').removed(id))&&/^upgrade_(item|drone)-upgrade$/.test(r.result[0]?.lootID)).length);
});

test('eight disassemblyclasses use the exact singlelevel refund and destroy target once',()=>{
 let count=0;for(const [id,r]of Object.entries(assembly.RECIPES)){
  if(!id.startsWith('disassemble_'))continue;const loot=r.targets.find(id=>!require('../game/equipment-policy').removed(id));if(!loot)continue;const pid=fixture(),target=give(pid,loot,1),level=Math.max(...r.costs.map(c=>c.level));db.prepare('UPDATE items SET upgrade_level=? WHERE id=?').run(level,target);
  const parts=r.costs.find(c=>c.level===level).parts;for(const p of parts.filter(p=>p.ammount>0))give(pid,p.lootID,p.ammount);
  const before=new Map(parts.filter(p=>p.ammount<0).map(p=>[p.lootID,assembly.count(db,pid,p.lootID)]));assembly.build(pid,id,1,target,1000);assembly.collect(pid,id,target,1000);
  assert.equal(db.prepare('SELECT amount FROM items WHERE id=?').get(target).amount,0);for(const p of parts.filter(p=>p.ammount<0))assert.equal(assembly.count(db,pid,p.lootID),before.get(p.lootID)-p.ammount);assert.throws(()=>assembly.collect(pid,id,target,1000));count++;
 }assert.equal(count,Object.entries(assembly.RECIPES).filter(([id,r])=>id.startsWith('disassemble_')&&r.targets.some(t=>!require('../game/equipment-policy').removed(t))).length);
});

test('disassembly and upgrades reserve onephysicaltarget acrossrecipes; failures preserve targets',()=>{
 const pid=fixture(),target=give(pid,'equipment_weapon_laser_lf-4',1);give(pid,'resource_upgrade-module',4);assembly.build(pid,'upgrade_upgrade-class2',1,target,1000);
 assert.throws(()=>assembly.build(pid,'upgrade_upgrade-class2',2,target,1000),/devam|kilitli/);assert.throws(()=>assembly.build(pid,'disassemble_disassemble-class2',1,target,1000),/kilitli/);
});

test('repeated scheduled crafting charges fixed Convert Modules rather than former geometric costs',()=>{
 const id='recipe_blueprint-sg3n-b02',r=assembly.RECIPES[id],pid=fixture();db.prepare('INSERT INTO assembly_usage(player_id,recipe_loot_id,uses)VALUES(?,?,?)').run(pid,id,1);
 assert.equal(r.costScalingFactor,1);const parts=r.costs[0].parts;assert.deepEqual(parts.map(p=>p.lootID),['resource_convert-module']);for(const p of parts)give(pid,p.lootID,p.ammount*2);
 const before=new Map(parts.map(p=>[p.lootID,assembly.count(db,pid,p.lootID)]));assembly.build(pid,id,2,0,1000);
 for(const p of parts)assert.equal(assembly.count(db,pid,p.lootID),before.get(p.lootID)-p.ammount*2);
});

test('workbench renders reachablecraft/skip/collect and rejects missingmaterials withoutSkylab',()=>{
 const pid=fixture(),api=require('../web/assembly-api'),p=players.loadPlayer(pid),html=api.render(p);assert.match(html,/internalAssembly/);assert.match(html,/Etkinlik tarifleri yerelde sürekli/);assert.match(html,/planını/);assert.match(html,/Söküm/);
 const result=api.handle(pid,new URLSearchParams({subaction:'build',recipe:'recipe_blueprint-sg3n-b02',amount:'1'}),{now:1000});assert.equal(result.ok,false);assert.match(result.message,/malzeme/);
 give(pid,'resource_convert-module',1);assert.equal(api.handle(pid,new URLSearchParams({subaction:'build',recipe:'recipe_blueprint-sg3n-b02',amount:'1'}),{now:1000}).ok,true);assert.match(api.render(p,{}, {now:6000}),/Tamamlanan üretimi teslim al/);
});

test('nativeDisassemblyRequest connects sourceconfirmation through readycollect and consumedinventoryitem',()=>{
 const pid=fixture(),p=players.loadPlayer(pid),target=give(pid,'equipment_weapon_laser_lf-4',1),handlers={},sent=[],session={player:p};db.prepare('UPDATE items SET upgrade_level=15 WHERE id=?').run(target);
 require('../game/handlers/assembly').register((n,h)=>handlers[n]=h,{sendCmd:(s,c)=>{assert.ok(c);sent.push(c);}});
 assert.equal(typeof handlers.DisassemblyRequest,'function');handlers.DisassemblyRequest(session,{recipeLootId:'disassemble_disassemble-class2',itemId:target});
 assert.ok(sent.some(c=>c._==='AssemblyRecipeStatusUpdateCommand'&&c.status._==='AssemblyRecipeReadyToCollectStatusModule'));
 handlers.AssemblyCollectRequest(session,{recipeLootId:'disassemble_disassemble-class2',targetItemId:target});assert.equal(db.prepare('SELECT amount FROM items WHERE id=?').get(target).amount,0);assert.ok(sent.some(c=>c._==='InventoryItemRemovedCommand'&&c.itemId===target));
});
