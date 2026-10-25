'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),pet=require('../game/pet'),link=require('../game/pet-link'),special=require('../game/pet-special'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),codec=require('../game/codec/codec'),ranks=require('../game/ranks'),bosses=require('../game/hades-bosses');
let db,f;
beforeEach(()=>{
 database.close();db=database.open(':memory:');const id=players.createPlayer(players.createAccount('new-modules','testpass'),'QA',1,require('../config').starter);pet.addOwned(db,id);pet.addFuel(db,id,10000);
 const world=new World(require('../config')),commands=[],session={world,send(){},close(){}};world.login(session,id);world.petSend=(s,c)=>{codec.encode(c);commands.push(c);};const combat=new Combat(world,world.petSend);combat.map=maps.getMap(1);Object.assign(world.player,{x:6000,y:6000});
 const item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_petgear_g-hpl1',1)").run(id).lastInsertRowid);pet.move(id,{hangarId:world.player.shipId,from:{target:'inventory',items:[item],configId:1},to:{target:'pet',slotset:'gears',configId:1}});pet.launch(world);f={world,session,combat,commands,id,p:world.player};
});
afterEach(()=>{f?.world.removeSession(f.session);database.close();});
test('HP Link resolves shield normally and transfers only hull damage, bypassing PET shields',()=>{
 const {world,p}=f;assert.equal(pet.selectGear(world,16),true);const r=world.petRuntime;r.shield=5000;const hp=r.hitpoints;
 const state={hp:100000,shield:10000};require('../game/ship-abilities').incoming(world,state,10000,.8);
 assert.equal(state.shield,2000);assert.equal(state.hp,100000);assert.equal(r.hitpoints,hp-2000);assert.equal(r.shield,5000);assert.equal(link.damageMultiplier(world),1.25);
 assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===86&&c.attribute===p.userId&&c.activated));
});
test('PET death releases link and excess hull damage reaches the owner without losing cooldown',()=>{
 const {world}=f;pet.selectGear(world,16);world.petRuntime.hitpoints=500;const state={hp:100000,shield:0};require('../game/ship-abilities').incoming(world,state,2000,0);
 assert.equal(state.hp,98500);assert.equal(world.petRuntime,null);assert.equal(pet.owned(f.id).hitpoints,0);assert.ok(special.cooldown(f.id,16)>239000);
});
test('docking/relaunch and an explicit mode change cannot reset or renew HP Link',()=>{
 const {world}=f;pet.selectGear(world,16);assert.equal(pet.selectGear(world,16),false);assert.equal(pet.selectGear(world,2),true);assert.equal(world.petRuntime.hpLink,undefined);
 assert.ok(special.cooldown(f.id,16)>239000);pet.stop(world);pet.launch(world);assert.equal(pet.selectGear(world,16),false);assert.ok(special.cooldownCommands(f.id).some(c=>c.effectId===9));
});
test('HP Link expires at20 seconds even if the next damage arrives before the PET tick',()=>{
 const {world}=f;pet.selectGear(world,16);const until=world.petRuntime.hpLink.until;assert.equal(link.redirect(world,100,until),0);assert.equal(world.petRuntime.gear,2);assert.ok(special.cooldown(f.id,16,until)>239000);
});
test('corrected NPC points and all28 Kronos variants are explicit, without guessed emperor/Kuiper points',()=>{
 assert.equal(ranks.npcPoints({key:'epsilon-convict'}).points,32);assert.equal(ranks.npcPoints({key:'ravager'}).points,32);
 for(const key of Object.keys(require('../game/kronos').STATS))assert.deepEqual(ranks.npcPoints({key:'kronos-'+key}),{key:'kronos-'+key,points:0,known:true});
 assert.equal(ranks.npcPoints({key:'emperor-kristallon'}).known,false);assert.equal(ranks.npcPoints({key:'streuner-soldier'}).known,false);
});
function hades(key){f.p.mapId=203;f.combat.map=maps.getMap(203);const n=f.combat.spawn({...require('../game/npc-catalog').get(key),gateRunId:987},{x:6000,y:6000});return n;}
test('Sibelon shield depletion creates native beacons, travels and applies a bounded buff',()=>{
 const n=hades('emperor-sibelon');n.shield=0;bosses.beforeAi(f.combat,n,1000);assert.ok(n.hades.destination);assert.equal(f.commands.filter(c=>c._==='AssetCreateCommand'&&c.type.typeValue===45).length,3);
 Object.assign(n,{x:n.hades.destination.x,y:n.hades.destination.y});bosses.beforeAi(f.combat,n,2000);assert.equal(n.hades.destination,null);assert.equal(bosses.outgoing(f.combat,n,1000,2000),1100);assert.equal(bosses.playerDamage(f.combat,1000,2000),900);
 bosses.beforeAi(f.combat,n,32000);assert.equal(bosses.outgoing(f.combat,n,1000,32000),1000);
});
test('Lordakium decoys never create rewards, gate claims, NPC rank or drone progression',()=>{
 const n=hades('emperor-lordakium');bosses.beforeAi(f.combat,n,1000);n.hp-=bosses.DEFAULTS.cloneHullStep;bosses.beforeAi(f.combat,n,2000);
 assert.equal(n.hades.clones.length,2);const ids=[...n.hades.clones],before=db.prepare('SELECT COUNT(*) n FROM rank_npc_claims').get().n;
 for(const id of ids){const clone=f.combat.npcs.get(id);assert.equal(clone.hp,1);clone.hp=0;f.combat.kill(f.session,clone);assert.equal(f.combat.npcs.has(id),false);}
 assert.equal(db.prepare('SELECT COUNT(*) n FROM rank_npc_claims').get().n,before);assert.equal(db.prepare('SELECT COUNT(*) n FROM galaxy_gate_kill_claims').get().n,0);
});
test('Kristallon bomb warns, preserves fuse and can be escaped; cleanup removes delayed damage',()=>{
 const n=hades('emperor-kristallon');const calls=[];f.combat.damagePlayer=(npc,amount)=>calls.push(amount);bosses.beforeAi(f.combat,n,1000);bosses.beforeAi(f.combat,n,16000);assert.ok(n.hades.bomb);assert.deepEqual(calls,[]);
 f.p.x+=1000;bosses.beforeAi(f.combat,n,19000);assert.deepEqual(calls,[]);bosses.beforeAi(f.combat,n,31000);bosses.beforeAi(f.combat,n,34000);assert.deepEqual(calls,[300000]);
 bosses.cleanup(f.combat,n);assert.equal(n.hades,undefined);assert.ok(f.commands.some(c=>c._==='VisualModifierCommand'&&c.modifier===43&&!c.activated));
});
test('Hades death offers a real native raid repair for30seconds, spends one life only, then allows base return',()=>{
 const {world,p,session,combat}=f,gates=require('../game/galaxy-gates'),respawn=require('../game/respawn');
 require('../game/handlers/systems').gateInfo(p,db);db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=13').run(JSON.stringify(Array.from({length:45},(_,i)=>i+1)),p.userId);assert.equal(gates.setup(session,13).errorCode,0);
 p.mapId=203;combat.map=maps.getMap(203);combat.killPlayer({def:{name:'Emperor'}});const d=respawn.context(world),run=()=>db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=? AND gate_id=13').get(p.userId);
 assert.equal(run().lives,2);let screen=respawn.command(world,'Emperor',d.at);assert.deepEqual(screen.options.map(o=>o.repairType.repairTypeValue),[7,1]);assert.deepEqual(screen.options.map(o=>o.cooldownTime),[30,30]);assert.equal(screen.options[0].price.amount,0);assert.equal(screen.options[1].affordableForPlayer,false);
 const services={sendCmd:world.petSend,changeMap(s,mapId,x,y){Object.assign(p,{mapId,x,y});if(mapId===203)gates.spawnWave(world,combat);return true;}},request=type=>({selection:{repairTypeValue:type}});
 assert.equal(respawn.repair(session,request(1),services,d.at+29999),false);assert.equal(respawn.repair(session,request(7),services,d.at+10000),true);assert.equal(p.mapId,203);assert.equal(run().lives,2);assert.equal(respawn.repair(session,request(7),services,d.at+10000),false);
 combat.killPlayer({def:{name:'Emperor'}});const again=respawn.context(world);assert.equal(run().lives,1);assert.equal(respawn.repair(session,request(7),services,again.at+30000),false);assert.equal(respawn.repair(session,request(1),services,again.at+30000),true);assert.equal(p.mapId,1);assert.equal(run().lives,1);
});
test('HP Link persistence failure cannot activate a free link or charge fuel',()=>{
 const before=pet.owned(f.id).fuel;db.exec("CREATE TRIGGER fail_link BEFORE INSERT ON pet_gear_state BEGIN SELECT RAISE(ABORT,'link storage');END");
 assert.throws(()=>pet.selectGear(f.world,16),/link storage/);assert.equal(f.world.petRuntime.hpLink,undefined);assert.equal(pet.owned(f.id).fuel,before);assert.equal(pet.owned(f.id).gear,1);db.exec('DROP TRIGGER fail_link');
});
