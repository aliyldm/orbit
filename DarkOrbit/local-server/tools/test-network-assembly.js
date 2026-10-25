'use strict';
const assert=require('node:assert/strict');
async function verify({world,a,frame,db,base,cookie}){
 const p=world.player,assembly=require('../game/assembly'),gates=require('../game/galaxy-gates');
 const firstRecipe=a.commands.findIndex(c=>c._==='AssemblyRecipeContentModule'),firstInventory=a.commands.findIndex(c=>c._==='UserInventoryModule');
 assert.ok(firstRecipe>=0&&firstInventory>firstRecipe,'fresh native client must initialize Discount/Inventory proxies through RecipeContent before first UserInventory');
 // Only this helper's isolated in-memory account receives clock fixtures;
 // modules are bought through the real authenticated shop endpoint.
 const endpoint=base+'/indexInternal.es?action=internalAssembly';
 const page=await fetch(endpoint,{headers:{cookie}});assert.equal(page.status,200);assert.match(await page.text(),/Montaj Atölyesi/);
 async function postAction(url,body){const response=await fetch(url,{method:'POST',headers:{cookie},body:new URLSearchParams(body)}),html=await response.text();assert.equal(response.status,200,html.match(/notice[^>]*>([^<]+)/)?.[1]||html.slice(0,200));return html;}
 async function buyModules(id,amount){
  const before=assembly.count(db,p.userId,id),wallet=p.uridium;
  const response=await fetch(base+'/ajax/shop.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'purchase',itemId:id,amount:String(amount),category:'extras'})});
  const result=await response.json();assert.equal(response.status,200);assert.equal(result.result,'success',JSON.stringify(result));assert.equal(assembly.count(db,p.userId,id),before+amount);assert.equal(p.uridium,wallet-amount*10000);
 }
 async function resources(){for(const part of assembly.RECIPES['recipe_blueprint-sg3n-b02'].costs[0].parts)await buyModules(part.lootID,part.ammount);}
 const recipe='recipe_blueprint-sg3n-b02',shield='equipment_generator_shield_sg3n-b02',before=assembly.count(db,p.userId,shield);
 await resources();let mark=a.commands.length;
 await postAction(endpoint,{subaction:'build',recipe,amount:'1'});
 await a.until(cs=>cs.slice(mark).some(c=>c._==='AssemblyRecipeStatusUpdateCommand'&&c.lootId===recipe||c._==='AssemblyRecipeContentModule'&&c.recipes.some(r=>r.recipeLootId===recipe&&r.status._==='AssemblyRecipeBuildStatusModule')));
 db.prepare('UPDATE assembly_jobs SET due_at=? WHERE player_id=? AND recipe_loot_id=?').run(Date.now()-1,p.userId,recipe);
 await postAction(endpoint,{subaction:'collect',recipe});assert.equal(assembly.count(db,p.userId,shield),before+1);
 await resources();mark=a.commands.length;a.socket.write(frame({_:'AssemblyBuildRequest',recipeLootId:recipe,amount:1,targetItemId:0}));
 await a.until(cs=>cs.slice(mark).some(c=>c._==='AssemblyRecipeStatusUpdateCommand'&&c.lootId===recipe&&c.status._==='AssemblyRecipeBuildStatusModule'));
 db.prepare('UPDATE assembly_jobs SET due_at=? WHERE player_id=? AND recipe_loot_id=?').run(Date.now()-1,p.userId,recipe);mark=a.commands.length;
 a.socket.write(frame({_:'AssemblyCollectRequest',recipeLootId:recipe,targetItemId:0}));await a.until(cs=>cs.slice(mark).some(c=>c._==='AssemblyRecipeStatusUpdateCommand'&&c.lootId===recipe&&c.status._==='AssemblyRecipeAvailableStatusModule'));
 assert.equal(assembly.count(db,p.userId,shield),before+2);
 const target=db.prepare('SELECT * FROM items WHERE player_id=? AND loot_id=? AND amount=1 ORDER BY id DESC LIMIT 1').get(p.userId,shield);
 const [upgrade,r]=Object.entries(assembly.RECIPES).find(([,r])=>r.targets?.includes(shield)&&r.result[0]?.lootID==='upgrade_item-upgrade');
 for(const c of r.costs.filter(c=>c.level===1))for(const part of c.parts)await buyModules(part.lootID,part.ammount);
 const upgradeUrl=base+'/indexInternal.es?action=internalItemUpgrade',money=p.uridium;
 await postAction(upgradeUrl,{subaction:'build',recipe:upgrade,target:String(target.id),level:'2'});
 db.prepare('UPDATE assembly_jobs SET due_at=? WHERE player_id=? AND recipe_loot_id=? AND target_id=?').run(Date.now()-1,p.userId,upgrade,target.id);
 await postAction(upgradeUrl,{subaction:'collect',recipe:upgrade,target:String(target.id)});assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(target.id).upgrade_level,1);assert.ok(p.uridium<=money);
 // Every currently installed real run uses its source asset ID; unit tests
 // separately cover all10 entries and their on-disk2D/3D files.
 const rows=gates.portalRows(world),byRun=new Map(db.prepare("SELECT id,gate_id FROM galaxy_gate_runs WHERE player_id=? AND state='active'").all(p.userId).map(r=>[r.id,r.gate_id]));
 for(const row of rows)assert.equal(row.design_id,p.mapId===db.prepare('SELECT home_map FROM galaxy_gate_runs WHERE id=?').get(row.gateRunId).home_map?gates.PORTAL_DESIGNS[byRun.get(row.gateRunId)]:1);
 const commands=gates.portals(world);if(commands.length){mark=a.commands.length;const send=require('../game/net').sendCmd;world.broadcast(s=>{for(const c of commands)send(s,c);});await a.until(cs=>cs.slice(mark).some(c=>c._==='JumpgateCreateCommand'&&rows.some(r=>r.id===c.gateId&&r.design_id===c.designId)));}
 assert.equal(db.prepare('SELECT COUNT(*) n FROM assembly_jobs WHERE player_id=?').get(p.userId).n,0);
 // New native bulk bar uses the same authenticated Flash-origin POST route.
 const bulkUrl=base+'/ajax/upgrade-bulk.php';
 async function bulkPost(body,headers={cookie}){const response=await fetch(bulkUrl,{method:'POST',headers,body:new URLSearchParams(body)});return{status:response.status,body:await response.json()};}
 assert.equal((await bulkPost({action:'quote',categories:'weapons,shields'},{})).status,401);
 assert.equal((await fetch(bulkUrl,{headers:{cookie}})).status,405);
 assert.equal((await bulkPost({action:'quote',categories:'weapons'},{cookie,origin:'https://unrelated.invalid'})).status,403);
 let quote=await bulkPost({action:'quote',categories:'weapons,shields'});assert.equal(quote.status,200);assert.equal(quote.body.ok,true);assert.ok(quote.body.itemCount>0);
 // Explicit isolated test funding also verifies the 50-billion wallet protocol.
 const oldUri=p.uridium;require('../game/admin-wallet').grantUridium('networktest',50000000000,'network-bulk-wallet');assert.equal(p.uridium,oldUri+50000000000);
 const needed=quote.body.totalModules-quote.body.availableModules;if(needed>0)await buyModules('resource_upgrade-module',needed);
 quote=await bulkPost({action:'quote',categories:'weapons,shields'});assert.equal(quote.body.canBuild,true);
 const beforeModules=assembly.count(db,p.userId,'resource_upgrade-module');mark=a.commands.length;
 const started=await bulkPost({action:'build',token:quote.body.token});assert.equal(started.status,200);assert.equal(started.body.ok,true);assert.equal(started.body.itemCount,quote.body.itemCount);assert.equal(assembly.count(db,p.userId,'resource_upgrade-module'),beforeModules-quote.body.totalModules);
 await a.until(cs=>cs.slice(mark).some(c=>c._==='UserInventoryModule'));
 const replay=await bulkPost({action:'build',token:quote.body.token});assert.equal(replay.body.replayed,true);assert.equal(assembly.count(db,p.userId,'resource_upgrade-module'),beforeModules-quote.body.totalModules);
 const bulkJobs=db.prepare('SELECT * FROM assembly_jobs WHERE player_id=?').all(p.userId);assert.equal(bulkJobs.length,quote.body.itemCount);assert.equal(new Set(bulkJobs.map(j=>j.started_at)).size,1);
 db.prepare('UPDATE assembly_jobs SET due_at=0 WHERE player_id=?').run(p.userId);mark=a.commands.length;
 a.socket.write(frame({_:'AssemblyCollectAllRequest',allRequests:bulkJobs.map(j=>({_:'AssemblyCollectRequest',recipeLootId:j.recipe_loot_id,targetItemId:j.target_id}))}));
 await a.until(cs=>cs.slice(mark).some(c=>c._==='UserInventoryModule'));assert.equal(db.prepare('SELECT COUNT(*) n FROM assembly_jobs WHERE player_id=?').get(p.userId).n,0);
 for(const j of bulkJobs)assert.equal(db.prepare('SELECT upgrade_level FROM items WHERE id=?').get(j.target_id).upgrade_level,j.amount);
}
module.exports={verify};
