'use strict';
// Temporal client contract regression: packet round trips alone cannot catch
// the fresh Flash client's proxy dependency or its loading-overlay readiness.
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),path=require('path');
const database=require('../game/db'),players=require('../game/db/players'),assembly=require('../game/assembly'),codec=require('../game/codec/codec');
let db,p;
before(()=>{database.close();db=database.open(':memory:');const a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run('native-bootstrap-qa','test'),id=players.createPlayer(Number(a.lastInsertRowid),'native-bootstrap-qa',1,require('../config.json').starter);p=players.loadPlayer(id);});
after(()=>database.close());
const read=file=>fs.readFileSync(path.join(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit',file),'utf8');

function freshClientContract(commands){
 // A small state-machine projection of the shipped handlers below, covering
 // initialization only; it does not claim to execute the Flash renderer.
 const state={discount:false,inventory:false,assembly:false,initialized:false,overlay:true,errors:[]};
 for(const c of commands){
  if(c._==='AssemblyRecipeContentModule'){
   // AssemblyRecipeContentHandler -> INIT -> synchronous first macro command
   // InitAssemblyWindowProxyCommand, before its asynchronous UI asset loads.
   state.inventory=true;state.discount=true;state.assembly=true;
  }else if(c._==='UserInventoryModule'){
   if(!state.discount){state.errors.push('UserInventoryHandler: null DiscountProxy.updateFromServer');continue;}
   state.inventory=true;state.initialized=true; // final dispatchItemChanged
  }
  // Overview's onRegister checks the flag even if inventory arrived while the
  // six XML views were still loading; no second initialization request exists.
  if(state.assembly)state.overlay=!state.initialized;
 }
 return state;
}

test('retained Flash source confirms bootstrap dependency and actual spinner gate',()=>{
 const inventory=read('net/netty/handlers/items/UserInventoryHandler.as'),init=read('mvc/crafting/assembly/control/InitAssemblyWindowProxyCommand.as'),recipe=read('net/netty/handlers/AssemblyRecipeContentHandler.as'),model=read('delete_in_eic/InventoryModel.as'),overview=read('mvc/crafting/overview/view/CraftingOverviewWindowMediator.as');
 assert.ok(inventory.indexOf('_loc3_.updateFromServer(_loc2_)')<inventory.indexOf('_loc4_.inventory.dispatchItemChanged()'));
 assert.match(init,/registerProxy\(new DiscountProxy\(\)\)/);assert.match(recipe,/sendNotification\(AssemblyNotifications.INIT\)/);
 assert.match(model,/this\.itemChanged\.addOnce\(this\.handleInitialItemChanged\)/);assert.match(model,/this\.isInitialized\.value = true/);
 assert.match(overview,/if\(_loc1_\.inventory\.isInitialized\.value\)[\s\S]*?hideInProgressOverlay/);
});

test('actual encoded freshaccount bootstrap initializes inventory before nativewindow readiness',()=>{
 const commands=assembly.buildInit(p).map(c=>codec.decode(codec.encode(c)).obj),state=freshClientContract(commands);
 assert.ok(commands[0].recipes.length>0);assert.equal(commands[0]._, 'AssemblyRecipeContentModule');assert.equal(commands[1]._, 'UserInventoryModule');
 assert.equal(state.initialized,true);assert.equal(state.overlay,false);assert.deepEqual(state.errors,[]);
 assert.ok(commands[1].inventoryItemModules.some(i=>i.lootId==='currency_uridium'));assert.equal(commands.filter(c=>c._==='AssemblyWindowSettingsModule').length,3);
});

test('the former inventoryfirst sequence reproduces permanentloading and repeated refresh recovers',()=>{
 const commands=assembly.buildInit(p),recipe=commands.find(c=>c._==='AssemblyRecipeContentModule'),inventory=commands.find(c=>c._==='UserInventoryModule');
 const broken=freshClientContract([inventory,recipe]);assert.equal(broken.initialized,false);assert.equal(broken.overlay,true);assert.equal(broken.errors.length,1);
 const fixed=freshClientContract([...commands,...commands]);assert.equal(fixed.initialized,true);assert.equal(fixed.overlay,false);assert.deepEqual(fixed.errors,[]);
});
