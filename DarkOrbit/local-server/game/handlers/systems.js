'use strict';

// Packet shapes/defaults come from the supplied client and relay recordings.
// Server balance choices and the supported subset are documented in docs/systems.md.
const codec = require('../codec/codec');
const evidence = require('./systems-evidence.json');
const clone = value => JSON.parse(JSON.stringify(value));
const seeded = new WeakSet();
const senders = new WeakMap();
const BINDING_KEY = 'UserKeyBindingsUpdate';
const SETTINGS = ['Audio', 'Display', 'Gameplay', 'Quality', 'Quest'];
const GATES = { 1: ['alpha', 34], 2: ['beta', 48], 3: ['gamma', 82], 4: ['delta', 128],
  5: ['epsilon', 99], 6: ['zeta', 111], 7: ['kappa', 120], 8: ['lambda', 45],
  12:['kronos',21],13: ['hades', 45], 19: ['streuner', 100] };
const SPINS = [1, 5, 10, 100];
const ENERGY_COST = 85; // Recorded discounted builder price, configurable local balance.
const ITEM_META = require('../../docs/client-map.items.json').items;
// All six captured categories, including the original 4% NanoHull category.
// Individual amounts/tiers beyond the captured 280 MCB-25 are local balance.
const GATE_PROBABILITIES = [[1, 67], [2, 12], [3, 3], [4, 13], [5, 4], [6, 1]];
const gateRewards = require('../gate-builder-rewards');
const questsContent = require('../quests-content');
const npcIds = require('../quests-npc-ids.json').visualToNpcId;

function conn(services = {}) { return services.db || require('../db').open(); }
function atomic(db, fn) {
  db.exec('SAVEPOINT local_systems');
  try { const result = fn(); db.exec('RELEASE local_systems'); return result; }
  catch (error) { db.exec('ROLLBACK TO local_systems; RELEASE local_systems'); throw error; }
}
function seed(db) {
  if (seeded.has(db)) return;
  const insert = db.prepare('INSERT OR IGNORE INTO quest_definitions (id,min_level,prerequisite,enabled,definition_json,slim_json,constraints_json) VALUES (?,?,?,?,?,?,?)');
  atomic(db, () => {
    for (const quest of evidence.quests) {
      const id = quest.definition.id;
      insert.run(id, quest.slim?.minLevel || 0, id > 20000 && id <= 20004 ? id - 1 : null,
        id === 2 || id >= 20000 && id <= 20004 ? 1 : 0, JSON.stringify(quest.definition), JSON.stringify(quest.slim), '{}');
    }
    for (const quest of questsContent.missions) insert.run(quest.definition.id, quest.minLevel, quest.prerequisite, 1,
      JSON.stringify(quest.definition), JSON.stringify(quest.slim), JSON.stringify(quest.constraints));
    db.prepare('UPDATE quest_definitions SET enabled=1 WHERE id=2').run();
  });
  seeded.add(db);
}
function setting(db, id, key, fallback = null) {
  const row = db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(id, key);
  if (!row) return clone(fallback);
  try { return JSON.parse(row.value); } catch { return clone(fallback); }
}
function saveSetting(db, id, key, value) {
  db.prepare('INSERT INTO settings (player_id,key,value) VALUES (?,?,?) ON CONFLICT(player_id,key) DO UPDATE SET value=excluded.value')
    .run(id, key, JSON.stringify(value));
}
function clean(name, value) {
  const result = { _: name };
  for (const field of codec.schema[name].fields) {
    if (!field.name) continue;
    const valueAt = value[field.name];
    if (field.type === 'bool') {
      if (typeof valueAt !== 'boolean') throw new Error(`Invalid ${name}.${field.name}`);
    } else if (field.type === 'utf') {
      if (typeof valueAt !== 'string' || Buffer.byteLength(valueAt) > 4096) throw new Error(`Invalid ${name}.${field.name}`);
    } else if (['int', 'short', 'byte'].includes(field.type)) {
      if (!Number.isInteger(valueAt)) throw new Error(`Invalid ${name}.${field.name}`);
    } else if (field.type === 'vector') {
      if (!Array.isArray(valueAt) || valueAt.length > (field.lenType === 'byte' ? 255 : 1024)) throw new Error(`Invalid ${name}.${field.name}`);
    }
    result[field.name] = clone(valueAt);
  }
  // Validate wire types and nested module shapes without trusting arbitrary keys.
  codec.encode(result);
  return result;
}
function userSettings(player, db) {
  const command = clone(evidence.defaults.UserSettingsCommand);
  for (const type of SETTINGS) {
    const field = type[0].toLowerCase() + type.slice(1) + 'SettingsModule';
    Object.assign(command[field], setting(db, player.userId, type + 'SettingsModule', {}));
  }
  // The general drone checkbox is the master switch. A historical saved
  // own=true must not leave the player's models visible when it is off.
  if (!command.displaySettingsModule.displayDrones) command.displaySettingsModule.displayMyDrones = false;
  const windows = setting(db, player.userId, 'WindowSettingsRequest');
  if (windows) Object.assign(command.windowSettingsModule, {
    minmapScale: windows.minimapScale, barStatus: windows.barStatus, hideAllWindows: windows.hideAllWindows
  });
  return command;
}
function questRows(db) { seed(db); return db.prepare('SELECT * FROM quest_definitions ORDER BY id').all(); }
function questState(db, id, questId) { return db.prepare('SELECT * FROM player_quests WHERE player_id=? AND quest_id=?').get(id, questId); }
function status(db, player, row) {
  const state = questState(db, player.userId, row.id);
  if (state?.status === 'completed') return 3;
  if (state?.status === 'running') return 2;
  if (!row.enabled) return 4;
  if (player.level < row.min_level || row.prerequisite && questState(db, player.userId, row.prerequisite)?.status !== 'completed') return 0;
  if (db.prepare("SELECT count(*) n FROM player_quests WHERE player_id=? AND status='running'").get(player.userId).n >= 5) return 0;
  return 1;
}
function slim(db, player, row) {
  const value = JSON.parse(row.slim_json);
  value.acceptabilityStatus.type = status(db, player, row);
  value.missingAcceptRequirements = [];
  if (player.level < row.min_level) value.missingAcceptRequirements.push({ _: 'QuestRequirementModule', requirementType: 0,
    minValue: row.min_level, maxValue: 0, matches: [], missingMatches: [] });
  if (row.prerequisite && questState(db, player.userId, row.prerequisite)?.status !== 'completed') {
    const prior = questRows(db).find(q => q.id === row.prerequisite);
    const localization = { _: 'QuestLocalizationModule', questId: row.prerequisite,
      textKeyFoundation: prior ? JSON.parse(prior.slim_json).textKeyFoundation : '' };
    value.missingAcceptRequirements.push({ _: 'QuestRequirementModule', requirementType: 3,
      minValue: 1, maxValue: 0, matches: [localization], missingMatches: [localization] });
  }
  if (status(db, player, row) === 0 && db.prepare("SELECT count(*) n FROM player_quests WHERE player_id=? AND status='running'").get(player.userId).n >= 5)
    value.missingAcceptRequirements.push({ _: 'QuestRequirementModule', requirementType: 1, minValue: 0, maxValue: 5, matches: [], missingMatches: [] });
  return value;
}
function questList(player, db) {
  return { _: 'QuestListCommand', list: questRows(db).filter(q => q.enabled).map(q => slim(db, player, q)),
    onlyStarter: player.level < 6 && questState(db, player.userId, 20005)?.status !== 'completed', maxQuests: 5, maxEventQuests: 1 };
}
function questSnapshot(player, row, state) {
  if (state?.snapshot_json) return JSON.parse(state.snapshot_json);
  return questsContent.resolve({ definition: JSON.parse(row.definition_json), constraints: JSON.parse(row.constraints_json || '{}') }, player.factionId);
}
function definition(db, player, row) {
  const state = questState(db, player.userId, row.id);
  const value = questSnapshot(player, row, state).definition;
  const progress = state ? JSON.parse(state.progress_json) : {};
  projectCase(value.rootCase, progress, state?.status === 'running');
  return value;
}
// Project nested ordered cases. Only the first unfinished element is active in
// ordered cases; later conditions cannot collect progress before their turn.
function projectCase(node, progress, active, event = null, changed = [], constraints = {}, beforeProgress = progress) {
  node.active = !!active;
  let completed = 0;
  let mandatoryComplete = true;
  let previousComplete = true;
  for (const element of node.modifier) {
    const enabled = active && (!node.ordered || previousComplete);
    let done = false;
    const priorDone = element.questCase.id ? caseComplete(element.questCase, beforeProgress)
      : (beforeProgress[element.condition.id] || 0) >= element.condition.targetValue;
    if (element.questCase.id) done = projectCase(element.questCase, progress, enabled, event, changed, constraints, beforeProgress);
    else if (element.condition.id) {
      const condition = element.condition;
      const before = progress[condition.id] || 0;
      let value = before;
      if (enabled && event && matchesEvent(condition, event, constraints[condition.id])) value = Math.min(condition.targetValue, before + event.amount);
      if (value !== before) { progress[condition.id] = value; changed.push(condition.id); }
      done = value >= condition.targetValue;
      condition.state = { _: 'QuestConditionStateModule', currentValue: value, active: !!enabled && !done, completed: done };
    }
    if (done) completed++;
    const mandatory = element.questCase.id ? element.questCase.mandatory : element.condition.mandatory;
    if (mandatory && !done) mandatoryComplete = false;
    // One action cannot also satisfy the next ordered objective just unlocked
    // by that same action (e.g. two consecutive Streuner kill objectives).
    previousComplete = previousComplete && (event ? priorDone : done);
  }
  return node.modifier.length > 0 && mandatoryComplete && completed >= Math.min(node.mandatoryCount || node.modifier.length, node.modifier.length);
}
function caseComplete(node, progress) { return projectCase(clone(node), progress, false); }
function activeHome(node) { return node.modifier.some(element => element.questCase.id ? activeHome(element.questCase)
  : element.condition.type===62 && element.condition.state?.active && !element.condition.state.completed && element.condition.matches.includes('HOME')); }
function matchesEvent(condition, event, constraint = {}) {
  const types = { npcKill: 6, cargo: 51, collectLoot: 67, sellOre: 52, visitQuestGiver: 62, skylabUpgrade: 76,
    mapVisit: 34, gateComplete: 79, slotItem: 70 };
  if (condition.type === 55) return event.type === 'collectLoot' && event.lootId === 'bonus_box';
  if (types[event.type] !== condition.type) return false;
  if (constraint.maps?.length && !constraint.maps.map(Number).includes(Number(event.mapId))) return false;
  if (event.type === 'slotItem') return condition.matches.at(-1) === event.lootId && (!event.slotBarId || condition.matches[0] === event.slotBarId);
  if (event.type === 'gateComplete') return Number(condition.matches[1]) === Number(event.mapId);
  let match = event.match ?? event.lootId ?? event.npcType;
  if (event.type === 'mapVisit') match = event.mapId;
  // Supplied logical IDs take priority. Legacy events carry ship visuals, while
  // the quest UI translates logical npcId, a different namespace.
  if (event.type === 'npcKill') match = event.npcId ?? (event.npcKey ? logicalNpcId(event.npcKey) : null) ?? npcIds[match] ?? match;
  return !condition.matches.length || condition.matches.includes(String(match));
}
function logicalNpcId(key) {
  const npc = require('../npc-catalog').definitions[key];
  return npc && npcIds[npc.typeId];
}
function reward(db, player, rewards) {
  const fields = { currency_credits: 'credits', currency_uridium: 'uridium', currency_experience: 'ep', currency_honour: 'honour' };
  for (const item of rewards) {
    if (!Number.isSafeInteger(item.amount) || item.amount <= 0) throw new Error('Invalid quest reward');
    const field = fields[item.lootId];
    let amount = item.amount;
    if (item.lootId === 'currency_experience') amount = require('../boosters').applyReward(player.userId, { ep: amount }, { db }).ep;
    if (item.lootId === 'currency_honour') amount = require('../boosters').applyReward(player.userId, { honour: amount }, { db }).honour;
    if (field) db.prepare(`UPDATE players SET ${field}=${field}+? WHERE id=?`).run(amount, player.userId);
    else grantItem(db, player.userId, item.lootId, item.amount);
  }
  const current = db.prepare('SELECT level,ep FROM players WHERE id=?').get(player.userId);
  db.prepare('UPDATE players SET level=? WHERE id=?').run(Math.max(current.level, require('../progression').levelFor(current.ep)), player.userId);
}
function grantItem(db, id, lootId, amount) {
  const type = db.prepare('SELECT category FROM item_types WHERE loot_id=?').get(lootId);
  if (!type) throw new Error(`Missing reward catalog entry: ${lootId}`);
  const stack = !!ITEM_META[lootId]?.stackable || /^(ammo_|resource)/.test(type.category);
  const row = stack && db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL ORDER BY id LIMIT 1').get(id, lootId);
  if (row) db.prepare('UPDATE items SET amount=amount+? WHERE id=?').run(amount, row.id);
  else if (stack) db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,?)').run(id, lootId, amount);
  else for (let i = 0; i < amount; i++) db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,1)').run(id, lootId);
}
function syncBalances(db, player) {
  const row = db.prepare('SELECT credits,uridium,ep,honour,level FROM players WHERE id=?').get(player.userId);
  if (row) Object.assign(player, { credits: row.credits, uridium: row.uridium, ep: row.ep, honourPoints: row.honour, level: row.level });
}
function emit(session, command, services = {}) {
  (services.sendCmd || senders.get(session.world) || session.world?.combat?.send || require('../net').sendCmd)(session, command);
}
function recordEvent(session, event, services = {}) {
  const player = session.player;
  if (!player || session.world && session.world.player !== player || session.world?.active && !session.world.active(session)) return [];
  if (!event || !Number.isSafeInteger(event.amount ?? 1) || (event.amount ?? 1) < 1) return [];
  event = { ...event, mapId: event.mapId ?? player.mapId, amount: event.amount ?? 1 };
  const db = conn(services);
  const events=require('../payment-events');
  const nativeBefore=Object.fromEntries(events.MISSIONS.filter(m=>m.event===event.type&&(!m.lootId||m.lootId===event.lootId)).map(m=>[m.key,require('../native-rewards').missionProgress(db,player.userId,m)?.progress||0]));
  const eventChanged=atomic(db,()=>{
    // Combat/gate rewards may still be pending in the live player. Preserve
    // those before the capped season-point overflow credits actual honour.
    db.prepare('UPDATE players SET honour=? WHERE id=?').run(player.honourPoints,player.userId);
    return events.record(db,player.userId,event);
  });
  if(eventChanged){
    player.honourPoints=db.prepare('SELECT honour FROM players WHERE id=?').get(player.userId).honour;
    for(const c of events.commands(db,player.userId).slice(0,2))emit(session,c,services);
  }
  for(const c of require('../native-rewards').progressCommands(db,player.userId,event,undefined,nativeBefore))emit(session,c,services);
  const previousLevel = player.level;
  const previousExperience=player.ep;
  const rows = questRows(db).filter(row => questState(db, player.userId, row.id)?.status === 'running' && (services.onlyQuestId===undefined || row.id===services.onlyQuestId));
  if (!rows.length) return [];
  const messages = atomic(db, () => {
    const output = [];
    if (event.eventId !== undefined) {
      if (typeof event.eventId !== 'string' || !event.eventId || event.eventId.length > 200) return output;
      if (!db.prepare('INSERT OR IGNORE INTO quest_event_receipts(player_id,event_type,event_id,recorded_at) VALUES(?,?,?,?)')
        .run(player.userId, event.type, event.eventId, Date.now()).changes) return output;
    }
    for (const row of rows) {
      const state = questState(db, player.userId, row.id);
      if (state?.status !== 'running') continue;
      const progress = JSON.parse(state.progress_json);
      const snapshot = questSnapshot(player, row, state), quest = snapshot.definition;
      const changed = [];
      const done = projectCase(quest.rootCase, progress, true, event, changed, snapshot.constraints, { ...progress });
      if (!changed.length) continue;
      projectCase(quest.rootCase, progress, true);
      db.prepare('UPDATE player_quests SET progress_json=?,snapshot_json=? WHERE player_id=? AND quest_id=?')
        .run(JSON.stringify(progress), JSON.stringify(snapshot), player.userId, row.id);
      function updates(node) {
        for (const element of node.modifier) {
          if (element.questCase.id) updates(element.questCase);
          if (element.condition.id) output.push({ _: 'QuestConditionUpdateCommand', questConditionId: element.condition.id, state: element.condition.state });
        }
      }
      updates(quest.rootCase);
      if (done) {
        const claimedAt = Date.now();
        const claim = db.prepare('INSERT OR IGNORE INTO quest_reward_claims(player_id,quest_id,reward_json,claimed_at) VALUES(?,?,?,?)')
          .run(player.userId, row.id, JSON.stringify(quest.rewards), claimedAt);
        const completed = db.prepare("UPDATE player_quests SET status='completed',completed_at=? WHERE player_id=? AND quest_id=? AND status='running'")
          .run(claimedAt, player.userId, row.id);
        if (claim.changes && completed.changes) reward(db, player, quest.rewards);
        output.push({ _: 'QuestCompletedCommand', id: row.id, rating: 0 });
      }
    }
    return output;
  });
  syncBalances(db, player);
  if(player.ep>previousExperience&&session.world?.player===player)require('../pet').awardExperience(session.world,player.ep-previousExperience);
  for (const message of messages) emit(session, message, services);
  if (messages.some(message => message._ === 'QuestCompletedCommand')) {
    require('../ammo').notify(player);
    emit(session, questList(player, db), services);
    for (const message of [`0|LM|ST|CRE|0|${player.credits}`, `0|LM|ST|URI|0|${player.uridium}`,
      `0|LM|ST|EP|0|${player.ep}|${player.level}`, `0|LM|ST|HON|0|${player.honourPoints}`]) emit(session, { _: 'LegacyModule', message }, services);
    if (player.level > previousLevel) emit(session, { _: 'LegacyModule', message: `0|A|LUP|${player.level}|${player.ep}` }, services);
  }
  return messages;
}

function gateAccount(db, player) {
  db.prepare('INSERT OR IGNORE INTO galaxy_gate_accounts(player_id) VALUES(?)').run(player.userId);
  return db.prepare('SELECT * FROM galaxy_gate_accounts WHERE player_id=?').get(player.userId);
}
function gateState(db, player, id) {
  db.prepare('INSERT OR IGNORE INTO galaxy_gate_progress(player_id,gate_id) VALUES(?,?)').run(player.userId, id);
  return db.prepare('SELECT * FROM galaxy_gate_progress WHERE player_id=? AND gate_id=?').get(player.userId, id);
}
function gateInfo(player, db) {
  const account = gateAccount(db, player);
  const info = clone(evidence.gateInfo);
  Object.assign(info, { samples: account.energy, money: player.uridium, spinamount_selected: account.spin_amount,
    bonusRewardsDay: false, galaxyGateDay: false, energy_cost: ENERGY_COST, spinOnSale: true });
  info.gates = [...new Map(info.gates.filter(gate => GATES[gate.id]).map(gate => [gate.id, gate])).values()].map(gate => {
    const state = gateState(db, player, gate.id), parts = JSON.parse(state.parts_json),kronos=gate.id===12?require('../kronos').progress(db,player.userId):null;
    const currPart=kronos?kronos.reduce((n,p)=>n+p.current,0):parts.length;
    return { ...gate, currPart,...(kronos?{multiGateProgressModules:kronos}:{}),multiplier: state.multiplier, currWave: state.wave,
      livesLeft: state.lives, lifePrice: state.lives >= 0 ? 10000 : -1,
      state: currPart >= GATES[gate.id][1] ? 1 : 0,
      probabilityModules: GATE_PROBABILITIES.map(([category, percentage]) => ({ _: 'GalaxyGateBuilderProbabilityModule', category, percentage })) };
  });
  return info;
}
function spin(player, request, db, rng = Math.random, rewardTierWeights = require('../../config.json').galaxyGates?.builderRewardTierWeights) {
  const gate = GATES[request.gateId], account = gateAccount(db, player);
  const state = gate ? gateState(db, player, request.gateId) : null;
  const response = { _: 'GalaxyGateBuilderMultiEnergyCommand', gatePartIds: [], items: [],
    spinamount_selected: request.spinAmount, errorCode: 2, money: player.uridium,
    multiplier: state?.multiplier || 0, gateMode: gate?.[0] || '', samples: account.energy };
  if (!gate || request.gateId===12 || !SPINS.includes(request.spinAmount) || state.active) return response;
  const amount = request.spinAmount, free = Math.min(amount, account.energy), price = (amount - free) * ENERGY_COST;
  const balance = db.prepare('SELECT uridium FROM players WHERE id=?').get(player.userId).uridium;
  if (balance < price) return { ...response, money: balance, errorCode: 1 };
  const result = atomic(db, () => {
    const nano=require('../nano-hull'),shipId=player.shipId??db.prepare('SELECT active_ship_id FROM players WHERE id=?').get(player.userId)?.active_ship_id;
    // Preserve combat changes newer than the last periodic world save.
    if(player.shipId===shipId&&Number.isSafeInteger(player.nanoHull)&&Number.isFinite(player.hitPoints))db.prepare('UPDATE ships SET nano_hull=?,hitpoints=? WHERE id=? AND player_id=?').run(Math.max(0,player.nanoHull),Math.max(0,Math.round(player.hitPoints)),shipId,player.userId);
    const debit = db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(price, player.userId, price);
    if (!debit.changes) throw new Error('Gate balance changed');
    db.prepare('UPDATE galaxy_gate_accounts SET energy=energy-?,spin_amount=? WHERE player_id=?').run(free, amount, player.userId);
    let parts = JSON.parse(state.parts_json), multiplier = state.multiplier;
    const items = [];
    const draw = () => {
      const value = rng();
      if (!Number.isFinite(value) || value < 0 || value >= 1) throw new Error('Invalid gate random value');
      return value;
    };
    for (let n = 0; n < amount; n++) {
      const use = n === 0 && request.useMultiplier === true ? multiplier : 0;
      if (use) multiplier = 0;
      const factor = use + 1;
      const categoryRoll = draw();
      const nanoShip=nano.ship(db,player.userId,shipId);
      if(categoryRoll>=.29&&categoryRoll<.33&&nanoShip?.hitpoints>0&&nanoShip.nano_hull<nano.maximum(nanoShip.loot_id)){
        const base=require('../../config.json').galaxyGates?.nanoHullPerSpin??2000;
        const amount=nano.grant(db,player.userId,shipId,base*factor),unmultiplied=Math.min(base,amount);
        items.push({_:'GalaxyGateBuilderLootItemModule',type:7,date:Date.now(),multiplier_used:use?factor:0,item_id:0,spins:1,multiplier_amount:Math.max(0,amount-unmultiplied),amount});
        continue;
      }
      if (categoryRoll < 0.13 && parts.length < gate[1]) {
        for (let copy = 0; copy < factor; copy++) {
          const part = Math.floor(draw() * gate[1]) + 1, duplicate = parts.includes(part);
          if (duplicate) multiplier = Math.min(5, multiplier + 1);
          else parts.push(part);
          items.push({ _: 'GalaxyGateBuilderPartItemModule', type: 6, date: Date.now(), livesLeft: -1,
            gate_id: request.gateId, state: parts.length >= gate[1] ? 1 : 0, multiplier_used: use ? factor : 0,
            current: parts.length, part_id: part, duplicate, lifePrice: -1 });
        }
      } else {
        const category = categoryRoll >= 0.13 && categoryRoll < 0.25 ? 'ore'
          : categoryRoll >= 0.25 && categoryRoll < 0.28 ? 'voucher'
          : categoryRoll >= 0.28 && categoryRoll < 0.29 ? 'logfile' : 'ammo';
        const selected = gateRewards.choose(category, draw(), rewardTierWeights);
        for (const entry of selected.rewards) {
          const { lootId: loot, type, itemId, amount: base } = entry, amount = base * factor;
          if (type === 4) db.prepare('INSERT INTO player_resources(player_id,ore_type,amount) VALUES(?,3,?) ON CONFLICT(player_id,ore_type) DO UPDATE SET amount=amount+excluded.amount').run(player.userId, amount);
          else grantItem(db, player.userId, loot, amount);
          items.push({ _: type === 1 ? 'GalaxyGateBuilderBatteryItemModule' : 'GalaxyGateBuilderLootItemModule',
            type, date: Date.now(), multiplier_used: use ? factor : 0, item_id: itemId, spins: 1,
            multiplier_amount: amount - base, amount, ...(type === 1 ? { defaultOutput: false } : {}) });
        }
      }
    }
    parts.sort((a, b) => a - b);
    db.prepare('UPDATE galaxy_gate_progress SET parts_json=?,multiplier=? WHERE player_id=? AND gate_id=?')
      .run(JSON.stringify(parts), multiplier, player.userId, request.gateId);
    return { ...response, gatePartIds: parts, items: gateRewards.aggregate(items), money: balance - price, samples: account.energy - free, multiplier, errorCode: 0 };
  });
  player.uridium = result.money;
  require('../nano-hull').refresh(player,db);
  return result;
}

function buildInit(player, services = {}) {
  const db = conn(services);
  const bindings=setting(db,player.userId,BINDING_KEY,evidence.defaults[BINDING_KEY]);
  if(require('../pet').owned(player.userId,db)){
    const used=new Set(bindings.changedKeyBindings.flatMap(b=>b.keyCodes).filter(k=>k>0));
    for(const type of [4,5,13])if(!bindings.changedKeyBindings.some(b=>b.actionType===type&&b.parameter===0)){
      const def=evidence.defaults[BINDING_KEY].changedKeyBindings.find(b=>b.actionType===type);
      if(def&&!def.keyCodes.some(k=>used.has(k))){bindings.changedKeyBindings.push(clone(def));for(const k of def.keyCodes)used.add(k);}
    }
  }
  const messages = [userSettings(player, db),
    bindings, questList(player, db)];
  const windows = setting(db, player.userId, 'UIWindowSettingsCommand');
  if (windows) messages.push(windows);
  for (const row of questRows(db)) if (questState(db, player.userId, row.id)?.status === 'running')
    messages.push({ _: 'QuestInitializationCommand', quest: definition(db, player, row) });
  messages.push(...require('../payment-events').commands(db,player.userId));
  return messages;
}
function applyInit(player, commands, services = {}) {
  const db = conn(services), saved = setting(db, player.userId, 'WindowSettingsRequest');
  const windowLayout = setting(db, player.userId, 'UIWindowUpdateRequest', {});
  function restoreWindows(value) {
    if (Array.isArray(value)) return value.map(restoreWindows);
    if (!value || typeof value !== 'object') return value;
    const result = Object.fromEntries(Object.entries(value).map(([key, child]) => [key, restoreWindows(child)]));
    if (result._ === 'WindowItemCommand' && windowLayout[result.itemId]) {
      const layout = windowLayout[result.itemId];
      for (const field of ['posX', 'posY', 'width', 'height', 'maximized']) result[field] = layout[field];
    }
    if(result._==='WindowItemCommand'&&result.itemId==='pet'&&require('../pet').owned(player.userId,db)){
      result.visible=true;
      if(!windowLayout.pet)result.maximized=true;
    }
    return result;
  }
  // Info initializes the Flash builder and appends static tab lists. Send it
  // only in reply to its first InfoRequest, never in hero/map initialization.
  return commands.filter(command => !['GalaxyGateBuilderInfoCommand', 'GalaxyGateBuilderGetGatePartsCommand'].includes(command._)).map(original => {
    const command = restoreWindows(original);
    if (!saved) return command;
    if (command._ === 'MenuInitializationCommand') {
      command.itemBarPosition = saved.mainmenuPosition;
      const fields = { standardSlotBar: ['slotmenuPosition', 'slotMenuOrder'], premiumSlotBar: ['slotmenuPremiumPosition', 'slotMenuPremiumOrder'],
        proActionBar: ['slotmenuProActionPosition', 'slotMenuProActionOrder'] };
      for (const bar of command.slotBars) {
        const keys = fields[bar.slotBarId];
        if (keys) { bar.slotBarPosition = saved[keys[0]]; bar.slotBarOrder = saved[keys[1]]; }
      }
    } else if (command._ === 'UIFeatureBarCommand') {
      const prefix = command.featureBarType === 1 ? 'gameFeatureMenu' : 'genericFeatureMenu';
      command.featureBarPosition = saved[prefix + 'Position']; command.featureBarOrder = saved[prefix + 'Order'];
    }
    return command;
  });
}
function register(onCmd, services = {}) {
  const dbFor = () => conn(services);
  function on(name, handler) {
    onCmd(name, (session, request) => {
      const player = session.player;
      if (!player || session.world && session.world.player !== player) return;
      if (session.world && services.sendCmd) senders.set(session.world, services.sendCmd);
      return handler(session, request, player, dbFor());
    });
  }
  require('../native-rewards').register(on,services);
  on('SeasonPassRewardClaimRequest',(s,r,p,db)=>{
    if(!Number.isSafeInteger(r.level)||r.level<0||r.level>=90)return;
    const events=require('../payment-events');
    const track=r.extGoldPass?'extra':r.goldPass?'gold':'free';let claimed=false;
    try{atomic(db,()=>{events.persistEconomy(db,p);events.claim(db,p.userId,track,r.level+1);});claimed=true;}catch{/* server rejects locked or already claimed rewards */}
    const already=!!db.prepare('SELECT 1 FROM payment_event_claims WHERE player_id=? AND track=? AND level=?').get(p.userId,track,r.level+1);
    emit(s,{_:'SeasonPassRewardClaimCommand',level:r.level,goldPass:!!r.goldPass,extGoldPass:!!r.extGoldPass,claimed:already},services);
    if(claimed){for(const c of events.refreshRuntime(db,p,s.world))emit(s,c,services);require('../ammo').notify(p);}
  });
  on('SeasonPassRewardClaimAllRequest',(s,r,p,db)=>{
    const events=require('../payment-events');let success=false;
    try{atomic(db,()=>{events.persistEconomy(db,p);events.claimAll(db,p.userId);});success=true;}catch{/* no debit or partial grants on failure */}
    for(const c of success?events.refreshRuntime(db,p,s.world):events.commands(db,p.userId))emit(s,c,services);
    if(success)require('../ammo').notify(p);
  });
  on('SeasonPassLevelPurchaseRequest',(s,r,p,db)=>{
    let success=false;
    try{
      atomic(db,()=>{db.prepare('UPDATE players SET uridium=? WHERE id=?').run(p.uridium,p.userId);require('../payment-events').buyLevels(db,p.userId,r.amount);});
      p.uridium=db.prepare('SELECT uridium FROM players WHERE id=?').get(p.userId).uridium;
      success=true;
    }catch{/* invalid amount, cap and insufficient funds preserve balance */}
    for(const c of require('../payment-events').commands(db,p.userId).slice(0,2))emit(s,c,services);
    emit(s,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0},services);
    emit(s,{_:'SeasonPassLevelPurchaseCommand',success},services);
  });
  for (const type of SETTINGS) on(type + 'SettingsRequest', (session, request, player, db) => {
    const value = clean(type + 'SettingsRequest', request);
    if (type === 'Audio') for (const field of ['sound', 'music', 'voice']) value[field] = Math.max(0, Math.min(100, value[field]));
    if (type === 'Display') {
      for (const field of Object.keys(value).filter(key => key.startsWith('displaySetting3D'))) value[field] = Math.max(0, Math.min(4, value[field]));
      const previous=setting(db,player.userId,'DisplaySettingsModule',evidence.defaults.UserSettingsCommand.displaySettingsModule);
      // Turning the master switch back on must restore the own models which
      // turning it off disabled. A separate own-only toggle still works while
      // the master remains on.
      if(value.displayDrones&&!previous.displayDrones)value.displayMyDrones=true;
      if (!value.displayDrones) value.displayMyDrones = false;
    }
    if (type === 'Quality') for (const field of Object.keys(value).filter(key => key.startsWith('quality') && typeof value[key] === 'number')) value[field] = Math.max(0, Math.min(3, value[field]));
    const name = type + 'SettingsModule';
    const saved={ ...value, _: name, ...(type === 'Quest' ? {} : { notSet: false }) };
    saveSetting(db, player.userId, name, saved);
    // These modules have direct native handlers. Echo the committed tab rather
    // than replaying UserSettingsCommand (which recreates/resets unrelated UI).
    emit(session,saved,services);
  });
  on('WindowSettingsRequest', (s, r, p, db) => saveSetting(db, p.userId, r._, clean(r._, r)));
  on('UIWindowUpdateRequest', (s, r, p, db) => {
    const layout = clean(r._, r);
    if (!/^[a-zA-Z0-9_-]{1,100}$/.test(layout.itemId)) return;
    if (layout.width < 0 || layout.height < 0 || layout.width > 10000 || layout.height > 10000) return;
    const windows = setting(db, p.userId, r._, {});
    if (!Object.hasOwn(windows, layout.itemId) && Object.keys(windows).length >= 255) return;
    windows[layout.itemId] = layout;
    saveSetting(db, p.userId, r._, windows);
  });
  on('UIWindowSettingsRequest', (s, r, p, db) => {
    const command = clean(r._, r); command._ = 'UIWindowSettingsCommand';
    // Updates contain changed windows, not necessarily the entire layout.
    const old = setting(db, p.userId, command._, { windowSettings: [] });
    const windows = new Map(old.windowSettings.map(window => [JSON.stringify(window.windowID), window]));
    for (const window of command.windowSettings) windows.set(JSON.stringify(window.windowID), window);
    if (windows.size > 255) throw new Error('Too many window settings');
    command.windowSettings = [...windows.values()]; saveSetting(db, p.userId, command._, command);
  });
  on(BINDING_KEY, (s, r, p, db) => {
    const request = clean(BINDING_KEY, r);
    const old = setting(db, p.userId, BINDING_KEY, evidence.defaults[BINDING_KEY]);
    const bindings = new Map(old.changedKeyBindings.map(binding => [`${binding.actionType}:${binding.parameter}`, binding]));
    for (const binding of request.changedKeyBindings) {
      const key = `${binding.actionType}:${binding.parameter}`;
      bindings.set(key, { ...binding, keyCodes: request.remove ? [-1] : binding.keyCodes });
    }
    if (bindings.size > 255) throw new Error('Too many key bindings');
    saveSetting(db, p.userId, BINDING_KEY, { _: BINDING_KEY, changedKeyBindings: [...bindings.values()], remove: false });
  });
  on('ResetSettingsRequest', (s, r, p, db) => {
    atomic(db, () => {
      for (const key of [...SETTINGS.map(type => type + 'SettingsModule'), 'WindowSettingsRequest', 'UIWindowSettingsCommand', 'UIWindowUpdateRequest', BINDING_KEY, 'hotbar.slots'])
        db.prepare('DELETE FROM settings WHERE player_id=? AND key=?').run(p.userId, key);
    });
    for (const command of buildInit(p, { db }).filter(c => /Settings|KeyBindings/.test(c._))) emit(s, command, services);
  });
  on('QuestListRequest', (s, r, p, db) => emit(s, questList(p, db), services));
  on('QuestInfoRequest', (s, r, p, db) => {
    const row = questRows(db).find(q => q.id === r.questId && (q.enabled || questState(db, p.userId, q.id)));
    if (row) emit(s, { _: 'QuestInfoCommand', definition: definition(db, p, row), ratings: [],
      playersRating: { _: 'QuestChallengeRatingModule', name: '', epppLink: '', rank: 0, rating: 0, diffToFirst: 0 } }, services);
  });
  on('QuestAcceptRequest', (s, r, p, db) => {
    const row = questRows(db).find(q => q.id === r.questId);
    const accepted = atomic(db, () => {
      if (!row || status(db, p, row) !== 1 || db.prepare('SELECT 1 FROM quest_reward_claims WHERE player_id=? AND quest_id=?').get(p.userId, row.id)) return false;
      const snapshot = questSnapshot(p, row);
      db.prepare("INSERT INTO player_quests(player_id,quest_id,status,progress_json,accepted_at,snapshot_json) VALUES(?,?,'running','{}',?,?) ON CONFLICT(player_id,quest_id) DO UPDATE SET status='running',progress_json='{}',accepted_at=excluded.accepted_at,completed_at=NULL,snapshot_json=excluded.snapshot_json")
        .run(p.userId, row.id, Date.now(), JSON.stringify(snapshot));
      return true;
    });
    if (!accepted) { emit(s, questList(p, db), services); return; }
    const acceptedDefinition=definition(db,p,row);
    emit(s, { _: 'QuestInitializationCommand', quest: acceptedDefinition }, services);
    emit(s, questList(p, db), services);
    if(activeHome(acceptedDefinition.rootCase)&&require('../quest-station').current(s,db))
      recordEvent(s,{type:'visitQuestGiver',match:'HOME',amount:1},{...services,db,onlyQuestId:row.id});
    if (row.id === 2) {
      const lab = require('../skylab').state(p.userId, { db, notify: false });
      recordEvent(s, { type: 'skylabUpgrade', match: 'PROMETIUM_COLLECTOR', amount: lab.modules.prometiumCollector.level }, { ...services, db });
    }
    if (row.id === 20006) {
      const slots = require('../hotbar').load(p.userId, db).standardSlotBar || {};
      if (Object.values(slots).includes('ammunition_laser_mcb-50'))
        recordEvent(s, { type: 'slotItem', lootId: 'ammunition_laser_mcb-50', slotBarId: 'standardSlotBar' }, { ...services, db });
    }
  });
  on('QuestCancelRequest', (s, r, p, db) => {
    const result = db.prepare("UPDATE player_quests SET status='cancelled',progress_json='{}' WHERE player_id=? AND quest_id=? AND status='running'").run(p.userId, r.questId);
    if (result.changes) { emit(s, { _: 'QuestCancelledCommand', id: r.questId }, services); emit(s, questList(p, db), services); }
  });
  on('QuestGiverApproachedRequest', (s, r, p, db) => {
    if(!require('../quest-station').approach(s,r,db))return;
    recordEvent(s, { type: 'visitQuestGiver', match: 'HOME', amount: 1 }, { ...services, db });
    emit(s, questList(p, db), services);
  });
  on('QuestGiverWindowClosedRequest', s => {s.questGiverWindow=null;});
  on('GalaxyGateBuilderInfoRequest', (s, r, p, db) => {
    if (s.gateBuilderInfoPlayer === p.userId) return;
    emit(s, gateInfo(p, db), services); s.gateBuilderInfoPlayer = p.userId;
  });
  on('GalaxyGateBuilderGetGatePartsRequest', (s, r, p, db) => emit(s, {
    _: 'GalaxyGateBuilderGetGatePartsCommand', gateId: r.gateId,
    gatePartIds: GATES[r.gateId] ? JSON.parse(gateState(db, p, r.gateId).parts_json) : [], errorCode: GATES[r.gateId] ? 0 : 1
  }, services));
  on('GalaxyGateBuilderSaveSpinAmountRequest', (s, r, p, db) => {
    if (!SPINS.includes(r.spinAmount)) return;
    gateAccount(db, p); db.prepare('UPDATE galaxy_gate_accounts SET spin_amount=? WHERE player_id=?').run(r.spinAmount, p.userId);
  });
  on('GalaxyGateBuilderMultiEnergyRequest', (s, r, p, db) => {
    const response = spin(p, r, db, services.rng);
    emit(s, response, services);
    if (!response.errorCode) {
      require('../ammo').notify(p);
      if(response.items.some(item=>item.type===7))emit(s,require('../nano-hull').command(p),services);
      if (response.items.some(item => item.type === 4)) for (const command of require('../collectables').resourceCommands(p)) emit(s, command, services);
      emit(s, { _: 'LegacyModule', message: `0|LM|ST|URI|0|${p.uridium}` }, services);
    }
  });
  on('GalaxyGateBuilderSetupGateRequest', (s, r, p, db) => {
    const gates = require('../galaxy-gates');
    const response = gates.setup(s, r.gateId, { ...services, db });
    emit(s, response, services);
    if (!response.errorCode) for (const command of gates.portals(s.world)) emit(s, command, services);
  });
  on('GalaxyGateBuilderBuyLifeRequest', (s, r, p, db) => {
    const response = require('../galaxy-gates').buyLife(s, r.gateId, { ...services, db });
    emit(s, response, services);
    if (!response.errorCode) emit(s, { _: 'LegacyModule', message: `0|LM|ST|URI|0|${p.uridium}` }, services);
  });
}

module.exports = { register, buildInit, applyInit, recordEvent, questList, gateInfo, spin, GATES, ENERGY_COST };
