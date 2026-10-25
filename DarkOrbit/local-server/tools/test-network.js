'use strict';
// Real HTTP + TCP integration, using an isolated in-memory database and ports.
// No production accounts or CDN endpoints are touched.
const assert = require('node:assert/strict');
const net = require('node:net');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { once } = require('node:events');
const { start } = require('../server');
const codec = require('../game/codec/codec');
const database = require('../game/db');
const config = structuredClone(require('../config.json'));
config.http.port = 0; config.game.port = 0; config.policy.enabled = false;
config.cdnCache.enabled = false; config.hostCache.enabled = false;
config.starter.credits = 1000000;
config.starter.uridium = 1000000;
config.starter.ship = 'ship_diminisher';
config.gameplay ||= {}; config.gameplay.logoutDelayMs = 20;
config.gameplay.jumpDelayMs = 20;
const timeout = ms => new Promise(resolve => setTimeout(resolve, ms));
function frame(object, first = false) {
  const body = codec.encode(object), header = Buffer.alloc(first ? 4 : 3);
  first ? header.writeUInt32BE(body.length) : header.writeUIntBE(body.length, 0, 3);
  return Buffer.concat([header, body]);
}
function client(port) {
  const socket = net.connect(port, '127.0.0.1');
  const commands = [], waiters = new Set();
  let buffer = Buffer.alloc(0), error;
  socket.on('error', err => { error = err; for (const waiter of waiters) waiter(); });
  socket.on('data', chunk => {
    buffer = Buffer.concat([buffer, chunk]);
    while (buffer.length >= 3) {
      const size = buffer.readUIntBE(0, 3);
      if (buffer.length < size + 3) break;
      const decoded = codec.decode(buffer.subarray(3, size + 3));
      assert.equal(decoded.rest, 0);
      commands.push(decoded.obj); buffer = buffer.subarray(size + 3);
    }
    for (const waiter of waiters) waiter();
  });
  function until(predicate, ms = 5000) {
    const waitingAt = new Error('Timed out waiting for client commands');
    return new Promise((resolve, reject) => {
      let timer;
      const check = () => {
        if (error) { cleanup(); reject(error); }
        else if (predicate(commands)) { cleanup(); resolve(commands); }
      };
      const cleanup = () => { clearTimeout(timer); waiters.delete(check); };
      timer = setTimeout(() => { cleanup(); reject(waitingAt); }, ms);
      waiters.add(check); check();
    });
  }
  return { socket, commands, until };
}

async function main() {
  const logDir = fs.mkdtempSync(path.join(os.tmpdir(), 'darkorbit-network-'));
  const sockets = [];
  let runtime;
  try {
    runtime = await start(config, { dbFile: ':memory:', logDir });
    const base = `http://127.0.0.1:${config.http.port}`;
    const health = await fetch(base + '/health'); assert.equal(health.status, 200);
    const audioProof=require('../decompiled/ship-motion-patch/evidence.json');
    const shippedMain=Buffer.from(await(await fetch(base+'/client/spacemap/main.swf?'+config.client.flashvars.gameclientHash)).arrayBuffer());
    assert.equal(require('node:crypto').createHash('sha256').update(shippedMain).digest('hex'),audioProof.afterSha256);
    const inventorySwf=Buffer.from(await(await fetch(base+'/client/swf_global/inventory/inventory.swf?local=20261025sales')).arrayBuffer());assert.equal(require('node:crypto').createHash('sha256').update(inventorySwf).digest('hex'),require('../decompiled/inventory-sales-selection-patch/evidence.json').afterSha256);
    const upgradeXml=await(await fetch(base+'/client/spacemap/graphics/ui/windows/crafting/upgrade/upgradeWindowUI.xml')).text();assert.match(upgradeXml,/name="itemGridContainer"[^>]*height="146"[^>]*autoSizeHeight="false"/);
    assert.match(upgradeXml,/name="standardViewContainer"[^>]*gap="0"/);assert.match(upgradeXml,/name="upgradeContainer"[^>]*marginTop="12"[^>]*height="128"/);const resourceXml=await(await fetch(base+'/client/spacemap/xml/resources.xml')).text();assert.ok(resourceXml.includes(require('node:crypto').createHash('md5').update(upgradeXml).digest('hex')));
    const login = await fetch(base + '/login', { method: 'POST', redirect: 'manual',
      body: new URLSearchParams({ username: 'networktest', password: 'testpass' }) });
    assert.equal(login.status, 302);
    const cookie = login.headers.get('set-cookie').split(';')[0];
    const post = async (url, params) => (await fetch(base + url, { method: 'POST', headers: { cookie }, body: new URLSearchParams(params) })).json();
    await fetch(base + '/indexInternal.es?action=internalCompanyChoose&subaction=factionChoose&factionID=1', { headers: { cookie }, redirect: 'manual' });
    const page = await (await fetch(base + '/game', { headers: { cookie } })).text();
    assert.ok(page.includes(base + '/client/spacemap/preloader.swf'), 'advertised HTTP port must match bound port');
    const vars = new URLSearchParams(page.match(/name="flashvars" value="([^"]+)"/)[1]);
    const a = client(config.game.port); sockets.push(a.socket); await once(a.socket, 'connect');
    const version = frame({ _: 'VersionRequest', version: 'network-test' }, true);
    a.socket.write(version.subarray(0, 2)); await timeout(10); a.socket.write(version.subarray(2));
    await a.until(commands => commands.some(c => c._ === 'VersionCommand'));
    a.socket.write(frame({ _: 'LoginRequest', userID: Number(vars.get('userID')), sessionID: vars.get('sessionID'),
      factionID: 1, version: 'do-lz4-block-v3', instanceId: 502, isMiniClient: true }));
    await a.until(commands => commands.some(c => c._ === 'ShipCreateCommand'));
    assert.ok(a.commands.some(c => c._ === 'JumpgateCreateCommand'));
    assert.ok(a.commands.some(c => c._ === 'HangarShipsCommand'));
    const localNews=require('../game/command-center'),feedReply=await fetch(base+'/flashAPI/brNews.php',{headers:{cookie}});
    assert.equal(feedReply.status,200);assert.equal(await feedReply.text(),localNews.feed());
    const notices=a.commands.find(c=>c._==='EventUpdateCommand');assert.ok(notices);assert.equal(notices.activeCommands.length,localNews.NEWS.length);
    assert.ok(notices.activeCommands.every(e=>localNews.valid({newsId:e.type.slice(3),eventId:e.id})));
    const notice=localNews.entries()[0],readStart=a.commands.length;
    a.socket.write(frame({_:'CommandCenterNewsClickedRequest',...notice}));
    await a.until(commands=>commands.slice(readStart).some(c=>c._==='CommandCenterInfoCommand'&&c.ids.some(n=>n.newsId===notice.newsId&&n.eventId===notice.eventId&&n.clickCount===1)));
    const bought = await (await fetch(base + '/ajax/shop.php', { method: 'POST', headers: { cookie },
      body: new URLSearchParams({ action: 'purchase', itemId: 'equipment_weapon_laser_lf-1', amount: '1' }) })).json();
    assert.equal(bought.result, 'success');
    const state = runtime.game.world.player;
    assert.equal(state.expansionStage, 1);
    const equippedLaser = await post('/ajax/shop.php', { action: 'equipItems', itemId: 'equipment_weapon_laser_lf-1', amount: '1' });
    assert.equal(equippedLaser.result, 'success');
    await a.until(commands => commands.some(c => c._ === 'ShipExtensionsCommand' && c.userId === state.userId && c.extensionStage === 3));
    assert.equal(state.stats.shipLaserCount, 2);
    const db = database.open();
    // Fixture resources exist only in this in-memory QA account.
    db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,?)').run(state.userId, 'resource_logfile', 30);
    const converted = await post('/ajax/pilotprofil.php', { command: 'getInternalProfilPage', type: 'convertPoints' });
    assert.equal(converted.result, 'OK'); assert.equal(converted.newResearchPoints, 1);
    const learned = await post('/ajax/skillTree.php', { command: 'skillTreePurchaseLevelUp', skillId: '18a' });
    assert.equal(learned.result, 'OK'); assert.equal(learned.newResearchPoints, 0);
    assert.equal(require('../game/skills').state(state.userId).levels['18a'], 1);
    const skylab = await fetch(base + '/indexInternal.es?action=internalSkylab', { headers: { cookie } });
    assert.equal(skylab.status, 200); assert.match(await skylab.text(), /reloadToken/);
    assert.ok(db.prepare('SELECT 1 FROM skylab_accounts WHERE player_id=?').get(state.userId));
    const hst = await post('/ajax/shop.php', { action: 'purchase', itemId: 'equipment_weapon_rocketlauncher_hst-1', amount: '1' });
    assert.equal(hst.result, 'success');
    const hstEquipped = await post('/ajax/shop.php', { action: 'equipItems', itemId: 'equipment_weapon_rocketlauncher_hst-1', amount: '1' });
    assert.equal(hstEquipped.result, 'success');
    const petPurchase = await post('/ajax/shop.php', { action: 'purchase', itemId: 'pet_pet10', amount: '1' });
    assert.equal(petPurchase.result, 'success');
    const fuel = await post('/ajax/shop.php', { action: 'purchase', itemId: 'resource_pet-fuel', amount: '100' });
    assert.equal(fuel.petFuel,100);
    const petShop=await fetch(base+'/indexInternal.es?action=internalDock&tpl=internalDockPetGear',{headers:{cookie}});
    const petShopHtml=await petShop.text();assert.equal(petShop.status,200);assert.match(petShopHtml,/id="resource_pet-fuel"/);assert.doesNotMatch(petShopHtml,/pet_fuel_form|local-pet-fuel\.js/);
    assert.equal(fuel.result, 'success');
    a.socket.write(frame({ _: 'PetRequest', petRequestType: 0 }));
    await a.until(commands => commands.some(c => c._ === 'PetHeroActivationCommand'));
    assert.equal(a.commands.find(c => c._ === 'PetHeroActivationCommand').ownerId, state.userId);
    // Original portal level argument -> persistent PET equipment -> native mode.
    assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:'equipment_petgear_g-al1',amount:'1',level:'3'})).result,'error');
    for(const [lootId,slot] of [['equipment_petgear_g-al1','gears'],['equipment_aiprotocol_ai-hp1','protocols']]){
      assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:lootId,amount:'1',level:'1'})).result,'success');
      const row=db.prepare('SELECT id,pet_level FROM items WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(state.userId,lootId);assert.equal(row.pet_level,1);
      const request={params:{hi:state.shipId},from:{target:'inventory',items:[row.id],configId:1},to:{target:'pet',slotset:slot,configId:1}};
      const moved=await(await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'move',params:Buffer.from(JSON.stringify(request)).toString('base64')})})).text();assert.equal(JSON.parse(Buffer.from(moved,'base64')).isError,0);
    }
    const petMark=a.commands.length;a.socket.write(frame({_:'PetGearActivationRequest',gearTypeToActivate:{_:'PetGearTypeModule',typeValue:4},optParam:0}));
    await a.until(commands=>commands.slice(petMark).some(c=>c._==='PetGearSelectCommand'&&c.gearType.typeValue===4));
    // Native recall clears the menu. Every re-launch must rebuild all entries
    // before restoring the selected gear; repeated cycles must not lose modes.
    const petWorld=runtime.game.world,petId=require('../game/pet').petId(state.userId),petFuelBefore=petWorld.petRuntime.fuel;
    for(let round=0;round<3;round++){
      const recallMark=a.commands.length;a.socket.write(frame({_:'PetRequest',petRequestType:1}));await a.until(cs=>cs.slice(recallMark).some(c=>c._==='PetDeactivationCommand'&&c.petId===petId));assert.equal(petWorld.petRuntime,null);
      const launchMark=a.commands.length;a.socket.write(frame({_:'PetRequest',petRequestType:0}));await a.until(cs=>cs.slice(launchMark).some(c=>c._==='PetHeroActivationCommand'&&c.petId===petId)&&cs.slice(launchMark).some(c=>c._==='PetGearSelectCommand'&&c.gearType.typeValue===4));
      const packets=a.commands.slice(launchMark);assert.deepEqual(packets.filter(c=>c._==='PetGearAddCommand').map(c=>c.gearType.typeValue),[1,2,4]);assert.ok(packets.findIndex(c=>c._==='PetGearResetCommand')<packets.findIndex(c=>c._==='PetGearAddCommand'));assert.equal(petWorld.petRuntime.gear,4);assert.ok(petWorld.petRuntime.fuel<=petFuelBefore);
    }
    const rejectedPetMark=a.commands.length;a.socket.write(frame({_:'PetGearActivationRequest',gearTypeToActivate:{_:'PetGearTypeModule',typeValue:10},optParam:0}));await a.until(cs=>cs.slice(rejectedPetMark).some(c=>c._==='PetGearSelectCommand'&&c.gearType.typeValue===4));assert.equal(petWorld.petRuntime.gear,4);
    assert.deepEqual(a.commands.slice(rejectedPetMark).filter(c=>c._==='PetGearAddCommand').map(c=>c.gearType.typeValue),[1,2,4]);
    const passiveMark=a.commands.length;a.socket.write(frame({_:'PetGearActivationRequest',gearTypeToActivate:{_:'PetGearTypeModule',typeValue:1},optParam:0}));await a.until(commands=>commands.slice(passiveMark).some(c=>c._==='PetGearSelectCommand'&&c.gearType.typeValue===1));
    assert.equal(require('../game/pet').stats(state).hitMax,50500);
    // Only the isolated QA account unlocks the next source-reconstructed starter.
    assert.equal(a.commands.find(c=>c._==='QuestListCommand').list.length,53);
    db.prepare("INSERT INTO player_quests(player_id,quest_id,status,accepted_at,completed_at)VALUES(?,20004,'completed',1,2)").run(state.userId);
    a.socket.write(frame({_:'QuestAcceptRequest',questId:20005}));await a.until(commands=>commands.some(c=>c._==='QuestInitializationCommand'&&c.quest.id===20005));
    for(let i=0;i<3;i++){const box=runtime.game.world.collectables.add({x:state.x,y:state.y,boxType:'BONUS_BOX',reward:{credits:100}});a.socket.write(frame({_:'CollectBoxRequest',itemHash:box.hash}));await a.until(commands=>commands.some(c=>c._==='RemoveCollectableCommand'&&c.hash===box.hash&&c.collected));}
    a.socket.write(frame({_:'QuestGiverApproachedRequest',questGiverId:150000000}));await a.until(commands=>commands.some(c=>c._==='QuestCompletedCommand'&&c.id===20005));
    assert.equal(db.prepare('SELECT COUNT(*) n FROM quest_reward_claims WHERE player_id=? AND quest_id=20005').get(state.userId).n,1);
    a.socket.write(frame({_:'QuestAcceptRequest',questId:20006}));await a.until(commands=>commands.some(c=>c._==='QuestInitializationCommand'&&c.quest.id===20006));
    const drone = await post('/ajax/shop.php', { action: 'purchase', itemId: 'drone_flax', amount: '1' });
    assert.equal(drone.result, 'success'); assert.equal(require('../game/drones').owned(db, state.userId).length, 1);
    // Original inventory client bulk move: exact per-drone plan in one request.
    assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:'drone_iris',amount:'1'})).result,'success');
    assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:'equipment_weapon_laser_lf-1',amount:'3'})).result,'success');
    const bulkDrones=require('../game/drones').owned(db,state.userId),bulkItems=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL ORDER BY id DESC LIMIT 3').all(state.userId,'equipment_weapon_laser_lf-1').map(r=>r.id);
    const bulkPlan={params:{hi:state.shipId},from:{target:'inventory',configId:1,droneItems:{[bulkDrones[0].id]:bulkItems.slice(0,1),[bulkDrones[1].id]:bulkItems.slice(1)}},to:{target:'drone',configId:1,slotset:'default'}};
    const bulkReply=await(await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'droneEquip',params:Buffer.from(JSON.stringify(bulkPlan)).toString('base64')})})).text();
    assert.equal(JSON.parse(Buffer.from(bulkReply,'base64')).data.ret,true);assert.equal(require('../game/drones').equipped(db,state.shipId,1).length,3);
    const booster = await post('/ajax/shop.php', { action: 'purchase', itemId: '1', amount: '1' });
    assert.equal(booster.result, 'success'); assert.ok(require('../game/boosters').active(state.userId).length > 0);
    // Source-backed ability request and effects through the actual TCP dispatcher.
    // Position changes are confined to this QA fixture, away from the station.
    Object.assign(state, { x: 6000, y: 6000 });
    const target = runtime.game.world.npcs.values().next().value;
    Object.assign(target, { x: 6400, y: 6000, movement: null, nextWander: Date.now() + 60000 });
    a.socket.write(Buffer.concat([
      frame({ _: 'ShipSelectRequest', targetId: target.id }),
      frame({ _: 'MenuActionRequest', menuItemId: 'ability_diminisher', actionType: 1 })
    ]));
    await a.until(commands => commands.some(c => c._ === 'AbilityStartCommand' && c.selectedAbilityId === 2));
    assert.ok(a.commands.some(c => c._ === 'LegacyModule' && c.message === `0|n|SD|A|2|1|${state.userId}|${target.id}`));
    a.socket.write(frame({ _: 'MenuActionRequest', menuItemId: 'ability_diminisher', actionType: 1 }));
    await timeout(20);
    assert.equal(a.commands.filter(c => c._ === 'AbilityStartCommand' && c.selectedAbilityId === 2).length, 1, 'ability cooldown rejects repeated activation');
    // Isolated learned-skill fixture and deterministic rescued rocket hit.
    for(const skillId of ['6','20'])db.prepare('INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,?,5)').run(state.userId,skillId);
    runtime.game.world.refreshStats();
    const rocketCombat=runtime.game.world.combat, oldRocketChance=rocketCombat.cfg.rocketHitChance, oldRandom=Math.random, rocketMark=a.commands.length;
    try {
      rocketCombat.cfg.rocketHitChance=.95;Math.random=()=>.975;
      a.socket.write(frame({_: 'AttackRocketRequest',targetId:target.id}));
      await a.until(commands=>commands.slice(rocketMark).some(c=>c._==='LegacyModule'&&c.message===`0|v|${state.userId}|${target.id}|H|1|1|1`));
    } finally {Math.random=oldRandom;if(oldRocketChance===undefined)delete rocketCombat.cfg.rocketHitChance;else rocketCombat.cfg.rocketHitChance=oldRocketChance;}
    a.socket.write(frame({ _: 'SlotBarConfigSetRequest', slotBarIdFrom: '', slotIdFrom: 0, slotBarIdTo: 'standardSlotBar', slotIdTo: 4, menuItemId: 'ammunition_laser_mcb-50' }));
    await a.until(commands => commands.some(c => c._ === 'MenuInitializationCommand' && c.slotBars.some(b => b.slots.some(s => s.slotId === 4 && s.menuItemId === 'ammunition_laser_mcb-50'))));
    a.socket.write(Buffer.concat([frame({ _: 'GalaxyGateBuilderInfoRequest' }), frame({ _: 'GalaxyGateBuilderInfoRequest' })]));
    await a.until(commands => commands.some(c => c._ === 'GalaxyGateBuilderInfoCommand'));
    await timeout(30);
    assert.equal(a.commands.filter(c => c._ === 'GalaxyGateBuilderInfoCommand').length, 1, 'repeated initialization must not duplicate gate tabs');
    // Fixture levels affect only this memory database; verify real shield packets.
    const world=runtime.game.world;
    assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:'equipment_generator_shield_sg3n-b02',amount:'1'})).result,'success');
    assert.equal((await post('/ajax/shop.php',{action:'equipItems',itemId:'equipment_generator_shield_sg3n-b02',amount:'1'})).result,'success');
    db.prepare('INSERT INTO player_skills(player_id,skill_id,level) VALUES(?,?,5)').run(state.userId,'17');
    db.prepare('INSERT INTO player_skills(player_id,skill_id,level) VALUES(?,?,5)').run(state.userId,'8');
    state.shield=1; world.refreshStats();
    await a.until(commands=>commands.some(c=>c._==='AttributeSkillShieldUpdateCommand'&&c.shieldSkillId===1));
    const shieldMark=a.commands.length; state.shield=0; world.refreshStats();
    await a.until(commands=>commands.slice(shieldMark).some(c=>c._==='AttributeSkillShieldUpdateCommand'&&c.shieldSkillId===0));
    state.shield=state.shieldMax;
    db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=1')
      .run(JSON.stringify(Array.from({length:34},(_,i)=>i+1)),state.userId);
    a.socket.write(frame({_: 'GalaxyGateBuilderSetupGateRequest',gateId:1}));
    await a.until(commands=>commands.some(c=>c._==='GalaxyGateBuilderSetupGateCommand'&&c.id===1&&c.errorCode===0));
    const gate=require('../game/galaxy-gates').portalRows(world)[0];
    Object.assign(state,{x:gate.x,y:gate.y});
    a.socket.write(frame({_: 'JumpRequest'}));
    await a.until(commands=>state.mapId===51&&commands.some(c=>c._==='GalaxyGateBuilderGateWaveUpdateCommand'&&c.currWave===1));
    assert.equal(world.npcs.size,10,'original Alpha first phase has ten Streuners');
    const original=world.npcs.values().next().value;
    assert.equal(original.def.typeId,84); assert.equal(original.hp,800); assert.equal(original.shield,400);
    assert.equal(original.def.shieldAbsorb,.5);
    const selectedMark=a.commands.length;
    a.socket.write(frame({_: 'ShipSelectRequest',targetId:original.id}));
    await a.until(commands=>commands.slice(selectedMark).some(c=>c._==='ShipSelectionCommand'&&c.userId===original.id&&c.hitpointsMax===800&&c.shieldMax===400));
    // A native return portal exists only after a full major wave, not while
    // its four ten-Streuner sub-batches are still fighting. Fixture kills use
    // the actual Combat kill/reward/state path in this isolated memory DB.
    const gg=require('../game/galaxy-gates'),gateSession=[...world.sessions].find(session=>world.active(session));assert.ok(gateSession);let alphaBatches=0;
    while(!gg.portalRows(world).some(row=>row.gateAction==='home')){
      assert.ok(alphaBatches++<5,'Alpha first major must reach its checkpoint');
      for(const npc of [...world.npcs.values()]){npc.hp=0;world.combat.kill(gateSession,npc);}
      await a.until(()=>world.npcs.size>0||gg.portalRows(world).some(row=>row.gateAction==='home'));
    }
    assert.equal(alphaBatches,4);assert.equal(world.npcs.size,0);
    const checkpoint=gg.portalRows(world);assert.equal(checkpoint.length,2);const homePortal=checkpoint.find(row=>row.gateAction==='home');assert.ok(checkpoint.find(row=>row.gateAction==='continue').x<homePortal.x);
    Object.assign(state,{x:homePortal.x,y:homePortal.y}); a.socket.write(frame({_: 'MapAssetActivationRequest',mapAssetId:homePortal.id}));
    await a.until(()=>state.mapId===1);
    // Traverse real native portals through upper maps,4-5 and the directed
    // pirate corridor. Position/level fixtures remain inside this memory DB.
    state.level=17;
    const scar=[...world.npcs.values()][0];scar.hp=321;scar.shield=123;
    const scarSlot=[scar.def.normalSpawnId,scar.def.normalSpawnSlot];
    async function travelTo(targetMap){
      const maps=require('../game/maps'),queue=[{map:state.mapId,path:[]}],seen=new Set([state.mapId]);let path;
      while(queue.length){const next=queue.shift();if(next.map===targetMap){path=next.path;break;}for(const gate of maps.portals(next.map,state.factionId))if(!seen.has(gate.target_map)){seen.add(gate.target_map);queue.push({map:gate.target_map,path:[...next.path,gate]});}}
      assert.ok(path,`native route to ${targetMap}`);
      for(const gate of path){const mark=a.commands.length;Object.assign(state,{x:gate.x,y:gate.y});a.socket.write(frame({_: 'JumpRequest'}));await a.until(commands=>state.mapId===gate.target_map&&commands.slice(mark).some(c=>c._==='JumpToServerCommand'));}
    }
    await travelTo(18);
    assert.ok([...world.npcs.values()].some(n=>n.def.key==='cubikon'));
    assert.ok([...world.npcs.values()].some(n=>n.def.key==='kristallon'));
    const cube=[...world.npcs.values()].find(n=>n.def.key==='cubikon'),special=require('../game/normal-npc-special'),escortMark=a.commands.length;
    Object.assign(state,{x:cube.x-400,y:cube.y});cube.shield--;cube.lastHit=Date.now();cube.aggro=gateSession;special.tick(world.combat);
    const escortIds=new Set(special.children(world.combat,cube).map(n=>n.id));assert.equal(escortIds.size,20);
    await a.until(cs=>cs.slice(escortMark).filter(c=>c._==='MoveCommand'&&escortIds.has(c.userId)).length>=20&&cs.slice(escortMark).some(c=>c.message===`0|n|s|start|${cube.id}`));
    const orbitMark=a.commands.length;for(const guard of special.children(world.combat,cube))special.steerEscort(world.combat,guard,Date.now()+1100);
    await a.until(cs=>cs.slice(orbitMark).filter(c=>c._==='MoveCommand'&&escortIds.has(c.userId)).length>=20);
    await travelTo(29);assert.ok([...world.npcs.values()].some(n=>n.def.key==='uber-kristallon'));
    await travelTo(91);
    assert.equal(a.commands.filter(c=>c._==='MapAddPOICommand'&&c.poiId?.startsWith('pirate-maze-91-')).length,0);
    await require('./test-network-pirates').verify(world,a,frame,db);
    await require('./test-network-loot').boxes(world,a,frame,db,post);
    await travelTo(92);
    const tradeMark=a.commands.length;a.socket.write(frame({_: 'TradeRequest'}));
    // The arrival point is outside the neutral base; a remote trade is rejected.
    await timeout(15);assert.ok(!a.commands.slice(tradeMark).some(c=>c._==='OreTradeInfoCommand'));
    Object.assign(state,{x:10500,y:6550});a.socket.write(frame({_: 'TradeRequest'}));
    await a.until(commands=>commands.slice(tradeMark).some(c=>c._==='OreTradeInfoCommand'&&c.type===5));
    db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,8,30) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=amount+30').run(state.userId);
    const exchangeMark=a.commands.length;a.socket.write(frame({_: 'LegacyModule',message:'XCP|30'}));
    await a.until(commands=>commands.slice(exchangeMark).some(c=>c._==='LegacyModule'&&c.message.includes('2 ekstra enerji')));
    assert.equal(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(state.userId).energy,2);
    const pirateFieldMark=a.commands.length;
    await travelTo(93);assert.ok([...world.npcs.values()].some(n=>n.def.key==='battleray'));
    assert.equal([...world.collectables.boxes.values()].filter(b=>b.oreType===8).length,480);
    await a.until(commands=>commands.slice(pirateFieldMark).filter(c=>c._==='AddOreCommand'&&c.oreType.typeValue===8).length===480);
    const mist=a.commands.slice(pirateFieldMark).find(c=>c._==='MapAddPOICommand'&&c.poiId==='pirate-mist-93');
    assert.ok(mist);assert.equal(mist.design.designValue,5);
    assert.equal(a.commands.slice(pirateFieldMark).filter(c=>c.poiId?.startsWith('pirate-maze-93-')).length,0);
    const cpu=require('../game/cpu');cpu.write(state,{...cpu.read(state),cloaked:true});state.cloaked=true;
    Object.assign(state,{x:20000,y:22000});const mistMark=a.commands.length;
    a.socket.write(frame({_:'MoveRequest',positionX:20000,positionY:22000,targetX:20100,targetY:22000}));
    await a.until(commands=>commands.slice(mistMark).some(c=>c._==='LegacyModule'&&c.message===`0|n|INV|${state.userId}|0`));
    assert.equal(cpu.isCloaked(state),false);world.stopMovement();
    await travelTo(1);
    const scarRestored=[...world.npcs.values()].find(n=>n.def.normalSpawnId===scarSlot[0]&&n.def.normalSpawnSlot===scarSlot[1]);
    assert.equal(scarRestored.hp,321,'normal NPC damage survives the full map circuit');
    await require('./test-network-inventory-trade').verify({world,a,frame,db,base,cookie});
    const scarMark=a.commands.length;a.socket.write(frame({_: 'ShipSelectRequest',targetId:scarRestored.id}));
    await a.until(commands=>commands.slice(scarMark).some(c=>c._==='ShipSelectionCommand'&&c.userId===scarRestored.id&&c.hitpoints===321));
    await require('./test-network-loot').epsilon(world,a,frame,db);
    await require('./test-network-cpus').verify({world,a,frame,db,post,base,cookie,timeout});
    await require('./test-network-payment-weapons').verify({world,a,frame,db,post,base,cookie,timeout});
    await require('./test-network-payment-events').verify({world,a,frame,db,post,base,cookie,timeout});
    await require('./test-network-assembly').verify({world,a,frame,db,post,base,cookie,timeout});
    await require('./test-network-restoration').verify({world,a,frame,db,post,base,cookie,timeout});
    const originalConfig=state.activeConfig;
    for(const preset of [originalConfig===1?2:1,originalConfig]){
      const configMark=a.commands.length;
      a.socket.write(frame({_:'LegacyModule',message:`S|CFG|${preset}|${state.userId}|${vars.get('sessionID')}`}));
      await a.until(commands=>commands.slice(configMark).some(c=>c._==='LegacyModule'&&c.message===`0|S|CFG|${preset}`));
      assert.equal(state.activeConfig,preset);
      assert.equal(db.prepare('SELECT active_config FROM ships WHERE id=?').get(state.shipId).active_config,preset);
    }
    const display = structuredClone(require('../game/handlers/systems-evidence.json').defaults.UserSettingsCommand.displaySettingsModule);
    delete display.notSet; display._ = 'DisplaySettingsRequest'; display.displayUse2d = true;display.displayMyDrones=false;display.displayDrones=true;
    const displayMark=a.commands.length;a.socket.write(frame(display));await a.until(commands=>commands.slice(displayMark).some(c=>c._==='DisplaySettingsModule'&&c.displayMyDrones===false&&c.displayDrones===true));
    const generalOffMark=a.commands.length;
    a.socket.write(frame({...display,displayDrones:false,displayMyDrones:true}));
    await a.until(commands=>commands.slice(generalOffMark).some(c=>c._==='DisplaySettingsModule'&&c.displayMyDrones===false&&c.displayDrones===false));
    const renderer = await (await fetch(base + '/api/client-view', { headers: { cookie } })).json(); assert.equal(renderer.display2d, 2);
    assert.match(await (await fetch(base + '/game', { headers: { cookie } })).text(), /display2d=2(?:&|\")/);
    const ready2dMark=a.commands.length;a.socket.write(frame({_:'ReadyRequest',readyType:0,readyTypeStr:'map2d'}));
    await a.until(cs=>cs.slice(ready2dMark).some(c=>c._==='LegacyModule'&&c.message===require('../game/cpu').cloakCommand(state).message));
    assert.equal(world.rendererMode,2);assert.equal(require('../game/projectiles').flightMs(world,{x:0,y:0},{x:100,y:0}),500);
    const qualityDefaults=require('../game/handlers/systems-evidence.json').defaults.UserSettingsCommand.qualitySettingsModule;
    const qualityFields=['qualityBackground','qualityPOIzone','qualityShip','qualityEngine','qualityExplosion','qualityCollectables'];
    const qualityPresets=[[0,0,0,0,0,0],[1,1,0,1,1,0],[2,3,3,2,1,3],[3,3,3,3,3,3]];
    for(let level=0;level<4;level++){
      const request={...qualityDefaults,_:'QualitySettingsRequest',qualityPresetting:level,qualityCustomized:false,...Object.fromEntries(qualityFields.map((key,i)=>[key,qualityPresets[level][i]]))};delete request.notSet;
      const mark=a.commands.length;a.socket.write(frame(request));await a.until(cs=>cs.slice(mark).some(c=>c._==='QualitySettingsModule'&&c.qualityPresetting===level));
      const response=a.commands.slice(mark).find(c=>c._==='QualitySettingsModule');for(const key of qualityFields)assert.equal(response[key],request[key]);
    }
    const ready3dMark=a.commands.length;a.socket.write(frame({_:'ReadyRequest',readyType:1,readyTypeStr:'map3d'}));
    await a.until(cs=>cs.slice(ready3dMark).some(c=>c._==='LegacyModule'&&c.message===require('../game/cpu').cloakCommand(state).message));assert.equal(world.rendererMode,1);
    assert.equal((await (await fetch(base+'/api/client-view',{headers:{cookie}})).json()).display2d,2,'actual3D acknowledgement does not overwrite saved2D preference');
    const upgradePage = await fetch(base + '/indexInternal.es?action=internalItemUpgrade', { headers: { cookie } });
    assert.equal(upgradePage.status, 200); assert.match(await upgradePage.text(), /Eşya Geliştirme/);
    // Real combat death -> native socket selection -> saved paid resurrection.
    for(const type of [2,3]){
      world.stopMovement();Object.assign(state,{x:6000,y:6000});const beforeUri=state.uridium,deathMark=a.commands.length;
      world.combat.killPlayer({def:{name:'QA NPC'}});
      await a.until(commands=>commands.slice(deathMark).some(c=>c._==='KillScreenPostCommand'&&c.options.some(o=>o.repairType.repairTypeValue===type&&o.price.amount===(type===2?500:2000))));
      const repairMark=a.commands.length;
      a.socket.write(frame({_:'KillScreenRepairRequest',selection:{_:'KillScreenOptionTypeModule',repairTypeValue:type},requestModule:{_:'LoginRequest',userID:state.userId,sessionID:vars.get('sessionID')}}));
      await a.until(commands=>!state.dead&&commands.slice(repairMark).some(c=>c._==='JumpToServerCommand'));
      assert.equal(state.uridium,beforeUri-(type===2?500:2000));assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(state.userId).uridium,state.uridium);
      if(type===2)assert.ok(require('../game/maps').nearestPortal(world));else{assert.deepEqual([state.x,state.y],[6000,6000]);assert.ok(require('../game/respawn').protectedNow(world));}
    }
    // Isolated fixture: verify source PET20 thresholds through real socket
    // level commands and real HTTP tier4 purchase/equipment responses.
    const petModule=require('../game/pet');if(!world.petRuntime?.active)assert.equal(petModule.launch(world),true);
    const levelMark=a.commands.length,ownerEp=state.ep;petModule.awardExperience(world,3000000000);
    await a.until(cs=>cs.slice(levelMark).some(c=>c._==='PetLevelUpdateCommand'&&c.petLevel===20));
    assert.equal(state.ep,ownerEp);assert.equal(petModule.owned(state.userId).level,20);
    state.uridium=Math.max(state.uridium,1000000);world.save();
    const tier4=await post('/ajax/shop.php',{action:'purchase',itemId:'equipment_aiprotocol_ai-lm1',amount:'1',level:'4'});assert.equal(tier4.result,'success');
    const tier4Item=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='equipment_aiprotocol_ai-lm1' AND pet_level=4 ORDER BY id DESC LIMIT 1").get(state.userId);
    const tier4Move={params:{hi:state.shipId},from:{target:'inventory',items:[tier4Item.id],configId:1},to:{target:'pet',slotset:'protocols',configId:1}};
    const tier4Response=await(await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'move',params:Buffer.from(JSON.stringify(tier4Move)).toString('base64')})})).text();assert.equal(JSON.parse(Buffer.from(tier4Response,'base64')).isError,0);
    assert.ok(petModule.stats(state).effects.laserDamageMultiplier>=1.06);
    const protocolPage=await(await fetch(base+'/indexInternal.es?action=internalDock&tpl=internalDockPetProtocols',{headers:{cookie}})).text(),protocolRows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(protocolPage)[1]);assert.equal(protocolRows['equipment_aiprotocol_ai-lm1'].maxLevel,4);assert.equal(protocolRows['equipment_aiprotocol_ai-lm1'].levelItemShopData[4].price,1000000);
    // Only Plus hulls have the500k override; both currencies retain native prices.
    const shipOffers=require('../game/ship-shop');state.uridium=2000000;world.save();
    const shipMark=a.commands.length;a.socket.write(frame({_:'ShopItemListRequest',category:'ship'}));
    await a.until(cs=>cs.slice(shipMark).some(c=>c._==='ShopItemListCommand'&&c.category==='ship'));
    const hulls=a.commands.slice(shipMark).find(c=>c._==='ShopItemListCommand'&&c.category==='ship').itemList.filter(r=>shipOffers.has(r.lootId));
    assert.equal(hulls.length,80);for(const r of hulls){const o=shipOffers.offer(r.lootId);assert.equal(r.price[0],o.price);assert.equal(r.currency,o.currency);}
    assert.equal(hulls.find(r=>r.lootId==='ship_goliath').price[0],50000);assert.equal(hulls.find(r=>r.lootId==='ship_bigboy').currency,'virtual');
    const shipsPage=await(await fetch(base+'/indexInternal.es?action=internalDock&tpl=internalDockShips',{headers:{cookie}})).text(),shipRows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(shipsPage)[1]);
    assert.equal(Object.keys(shipRows).length,80);for(const[id,r]of Object.entries(shipRows)){const o=shipOffers.offer(id);assert.equal(r.price,o.price);assert.equal(r.currency,o.currency);}assert.match(shipsPage,/local_shop_navigation/);
    const shipImages=await Promise.all(Object.values(shipRows).map(async r=>{const response=await fetch(base+r.itemListImageUrl);assert.equal(response.status,200,r.itemListImageUrl);assert.match(response.headers.get('content-type'),/image\/png/);assert.equal(Buffer.from(await response.arrayBuffer()).subarray(0,8).toString('hex'),'89504e470d0a1a0a',r.itemListImageUrl);return r.itemListImageUrl;}));assert.equal(shipImages.length,80);
    const laserPage=await(await fetch(base+'/indexInternal.es?action=internalDock&tpl=internalDockLaser',{headers:{cookie}})).text(),laserRows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(laserPage)[1]);
    for(const id of require('../game/laser-shop').IDS){assert.ok(laserRows[id],id);const image=await fetch(base+laserRows[id].itemListImageUrl);assert.equal(image.status,200,id);assert.equal(Buffer.from(await image.arrayBuffer()).subarray(0,8).toString('hex'),'89504e470d0a1a0a',id);}
    for(const id of ['ship_pusat-plus','ship_solace-plus'])assert.equal((await post('/ajax/shop.php',{action:'purchase',itemId:id,category:'ship',amount:'1'})).result,'success');
    assert.equal(state.uridium,1000000);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(state.userId).uridium,1000000);
    const shipHangar=JSON.parse(Buffer.from(await(await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'getHangarList'})})).text(),'base64'));
    for(const id of ['ship_pusat-plus','ship_solace-plus']){const row=shipHangar.data.ret.shipInfo.find(r=>r.lootId===id);assert.equal(row.owned,1);assert.equal(row.price.uridium,500000);}
    const before = [state.x, state.y];
    const intruder = client(config.game.port); sockets.push(intruder.socket); await once(intruder.socket, 'connect');
    intruder.socket.write(frame({ _: 'MoveRequest', positionX: 20000, positionY: 12000, targetX: 20000, targetY: 12000 }, true));
    await once(intruder.socket, 'close');
    assert.deepEqual([state.x, state.y], before);
    const invalidCookie = await fetch(base + '/login', { headers: { cookie: 'dosid=%ZZ' } });
    assert.equal(invalidCookie.status, 200);
    const wallet = { credits: state.credits, uridium: state.uridium };
    await require('./test-network-second-completion').verify({world,a,frame,db,base,cookie});
    await require('./test-network-classic-modules').verify({world,a,frame,db,base,cookie,post});
    await require('./test-network-solo-completion').verify({world,a,frame,db,base,cookie,post});
    await require('./test-network-modern-defense').verify({world,a,frame,db,base,cookie,post});
    Object.assign(wallet,{credits:state.credits,uridium:state.uridium});
    a.socket.write(frame({ _: 'UIButtonTriggerRequest', itemId: 'logout' }));
    if (!a.socket.destroyed) await once(a.socket, 'close');
    assert.equal(runtime.game.world.player, null);
    assert.ok(a.commands.some(c => c._ === 'LegacyModule' && c.message === '0|l'));
    assert.equal((await fetch(base + '/api/client-view', { headers: { cookie } })).status, 200, 'game restart preserves web login');
    await fetch(base + '/logout', { headers: { cookie }, redirect: 'manual' });
    assert.deepEqual({ ...db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(Number(vars.get('userID'))) }, wallet);
    const remainingFuel=require('../game/pet').owned(state.userId).fuel;
    assert.ok(remainingFuel>0&&remainingFuel<=100,'active PET may consume fuel while waiting for real projectile impacts');
    assert.equal(remainingFuel,a.commands.filter(c=>c._==='PetFuelUpdateCommand').at(-1).petFuelNow,'saved fuel matches the last amount advertised to the client');
    const relogin = await fetch(base + '/login', { method: 'POST', redirect: 'manual', body: new URLSearchParams({ username: 'networktest', password: 'testpass' }) });
    assert.equal(relogin.status, 302);
    const newCookie = relogin.headers.get('set-cookie').split(';')[0];
    const reloginTree = await (await fetch(base + '/ajax/skillTree.php', { method: 'POST', headers: { cookie: newCookie }, body: new URLSearchParams({ command: 'getSkillTree' }) })).json();
    assert.equal(reloginTree.result, 'OK'); assert.match(reloginTree.html_skills, /1\/2/);
    assert.equal(require('../game/skills').state(state.userId).levels['18a'], 1);
    // A new Flash socket must accept the policy even when its ASCII prefix is split.
    const policy = net.connect(config.game.port, '127.0.0.1'); sockets.push(policy); await once(policy, 'connect');
    let xml = ''; policy.on('data', data => { xml += data.toString(); });
    policy.write('<policy-file-'); await timeout(10); policy.write('request/>\0');
    await once(policy, 'close'); assert.match(xml, /cross-domain-policy/);
    console.log(`PASS real HTTP/TCP: ${a.commands.length} decoded commands; 26laserTypesListed/17ModernLaserSalesRestricted, stableShipModules purchase/equip/badges, mazeDisabled/cargoArrival/fullHold/partialCargo/KronosOres, fixed1m Payment drive/lens/HM7 purchase/equip, native cannon/drive/SR5 damage and ammunition, pass purchase/activation/point use/native reward claim/replay rejection/level purchase, cosmetic purchase/native PET drag/live model; remote trade charges, cloak, NanoHull, ten-second advanced JumpCPU and homeJP; four booty colors, Epsilon completion, pirate attacks, map routes/trade, equipment/abilities/visuals, Alpha waves, skills/Skylab/PET/quests/hotbar, 2D/logout, upgrade/auth/relogin and fragmented frames/policy`);
  } finally {
    for (const socket of sockets) socket.destroy();
    if (runtime) await runtime.close();
    await timeout(50);
    for (const file of fs.readdirSync(logDir)) fs.unlinkSync(path.join(logDir, file));
    fs.rmdirSync(logDir);
  }
}
main().catch(error => { console.error(error.stack || error); process.exitCode = 1; });

