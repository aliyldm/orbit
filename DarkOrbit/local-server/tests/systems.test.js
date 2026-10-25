'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db');
const players = require('../game/db/players');
const systems = require('../game/handlers/systems');
const codec = require('../game/codec/codec');
const evidence = require('../game/handlers/systems-evidence.json');
let db, session, other, handlers, sent, services;
beforeEach(() => {
  database.close(); db = database.open(':memory:');
  const add = name => {
    const account = db.prepare('INSERT INTO accounts(username,password_hash,created_at) VALUES(?,?,0)').run(name, 'test');
    const id = players.createPlayer(Number(account.lastInsertRowid), name, 1, require('../config.json').starter);
    db.prepare('UPDATE players SET uridium=100000 WHERE id=?').run(id);
    return players.loadPlayer(id);
  };
  const player = add('systems-one'); other = add('systems-two');
  session = { player, world: { player }, id: 1 };
  sent = []; handlers = new Map(); services = { db, sendCmd: (s, command) => {
    const bytes = codec.encode(command), decoded = codec.decode(bytes);
    assert.equal(decoded.rest, 0);
    assert.deepEqual(decoded.obj, command);
    sent.push(command);
  } };
  systems.register((name, fn) => handlers.set(name, fn), services);
});
afterEach(() => database.close());
const request = (name, fields = {}, target = session) => handlers.get(name)(target, { _: name, ...fields });
const state = id => db.prepare('SELECT * FROM player_quests WHERE player_id=? AND quest_id=?').get(session.player.userId, id);
const count = (loot, id = session.player.userId) => db.prepare('SELECT coalesce(sum(amount),0) AS n FROM items WHERE player_id=? AND loot_id=?').get(id, loot).n;
const accept = id => request('QuestAcceptRequest', { questId: id });
const event = data => systems.recordEvent(session, data, services);
const home = () => { session.player.x = 2000; session.player.y = 2000; request('QuestGiverApproachedRequest', { questGiverId: 150000000 }); };
const finishFirst = () => { accept(20000); home(); };

test('all settings modules persist per player and survive reconstruction', () => {
  for (const type of ['Audio', 'Display', 'Gameplay', 'Quality', 'Quest']) {
    const module = evidence.defaults.UserSettingsCommand[type[0].toLowerCase() + type.slice(1) + 'SettingsModule'];
    const fields = { ...module }; delete fields.notSet;
    if (type === 'Audio') fields.sound = 22;
    request(type + 'SettingsRequest', fields);
  }
  const init = systems.buildInit(session.player, { db });
  assert.equal(init[0].audioSettingsModule.sound, 22);
  assert.equal(systems.buildInit(other, { db })[0].audioSettingsModule.sound, 50);
  for (const command of init) services.sendCmd(session, command);
});
test('audio values are bounded, reset removes only this player settings', () => {
  request('AudioSettingsRequest', { sound: 999, music: -100, voice: 40, playCombatMusic: false });
  assert.equal(systems.buildInit(session.player, { db })[0].audioSettingsModule.sound, 100);
  assert.equal(systems.buildInit(session.player, { db })[0].audioSettingsModule.music, 0);
  db.prepare('INSERT INTO settings VALUES(?,?,?)').run(other.userId, 'AudioSettingsModule', '{"sound":12}');
  request('ResetSettingsRequest');
  assert.equal(systems.buildInit(session.player, { db })[0].audioSettingsModule.sound, 50);
  assert.equal(systems.buildInit(other, { db })[0].audioSettingsModule.sound, 12);
});
test('anonymous and stale sessions cannot persist settings or accept quests', () => {
  request('QuestAcceptRequest', { questId: 20000 }, { world: session.world });
  request('AudioSettingsRequest', {}, { player: other, world: session.world });
  assert.equal(db.prepare('SELECT count(*) AS n FROM settings').get().n, 0);
  assert.equal(db.prepare('SELECT count(*) AS n FROM player_quests').get().n, 0);
});
test('keybinding deltas preserve unrelated keys and unassigned actions across reconnect', () => {
  request('UserKeyBindingsUpdate', { remove: false, changedKeyBindings: [{ _: 'UserKeyBindingsModule', actionType: 0, keyCodes: [75], parameter: 0, charCode: 0 }] });
  request('UserKeyBindingsUpdate', { remove: true, changedKeyBindings: [{ _: 'UserKeyBindingsModule', actionType: 2, keyCodes: [17], parameter: 0, charCode: 0 }] });
  const command = systems.buildInit(session.player, { db }).find(c => c._ === 'UserKeyBindingsUpdate');
  assert.equal(command.changedKeyBindings.length, evidence.defaults.UserKeyBindingsUpdate.changedKeyBindings.length);
  assert.deepEqual(command.changedKeyBindings.find(c => c.actionType === 0).keyCodes, [75]);
  assert.deepEqual(command.changedKeyBindings.find(c => c.actionType === 2).keyCodes, [-1]);
  services.sendCmd(session, command);
});
test('window positions merge deltas and restore request/module spelling differences', () => {
  const fields = Object.fromEntries(codec.schema.WindowSettingsRequest.fields.map(f => [f.name, f.type === 'utf' ? '' : f.type === 'bool' ? false : 9]));
  Object.assign(fields, { mainmenuPosition: '10,20', slotmenuPosition: '30,40', slotMenuOrder: '1', minimapScale: 7 });
  request('WindowSettingsRequest', fields);
  const window = x => ({ _: 'UIWindowSettingModule', windowID: { _: 'WindowIDModule', windowID: 1 }, x, y: 200, maximized: true });
  // Window ID field name follows the generated schema, rather than UI labels.
  const idField = codec.schema.WindowIDModule.fields.find(f => f.name).name;
  const w = window(100); w.windowID = { _: 'WindowIDModule', [idField]: 1 };
  request('UIWindowSettingsRequest', { windowSettings: [w] });
  request('UIWindowSettingsRequest', { windowSettings: [{ ...w, x: 250 }] });
  const init = systems.buildInit(session.player, { db });
  assert.equal(init[0].windowSettingsModule.minmapScale, 7);
  assert.equal(init.find(c => c._ === 'UIWindowSettingsCommand').windowSettings[0].x, 250);
  const menu = systems.applyInit(session.player, [{ _: 'MenuInitializationCommand', itemBarPosition: '', slotBars: [
    { slotBarId: 'standardSlotBar', slotBarPosition: '', slotBarOrder: '' }
  ] }], { db })[0];
  assert.equal(menu.itemBarPosition, '10,20'); assert.equal(menu.slotBars[0].slotBarPosition, '30,40');
});
test('quest starter chain uses owned progress, prerequisites, and actual captured rewards', () => {
  const list = systems.questList(session.player, db);
  assert.equal(list.list.find(q => q.questId === 20000).acceptabilityStatus.type, 1);
  assert.equal(list.list.find(q => q.questId === 20001).acceptabilityStatus.type, 0);
  accept(20001); assert.equal(state(20001), undefined);
  const before = count('ammunition_laser_lcb-10');
  finishFirst();
  assert.equal(state(20000).status, 'completed');
  assert.equal(count('ammunition_laser_lcb-10'), before + 500);
  assert.equal(state.call(null, 20001), undefined);
  assert.equal(db.prepare('SELECT count(*) AS n FROM player_quests WHERE player_id=?').get(other.userId).n, 0);
  accept(20000); home(); assert.equal(count('ammunition_laser_lcb-10'), before + 500);
});
test('feature window positions and sizes restore nested WindowItemCommand records', () => {
  request('UIWindowUpdateRequest', { itemId: 'quests', posX: 12, posY: 30, width: 350, height: 400, maximized: true });
  const commands = [{ _: 'UIFeatureBarCommand', featureBarItems: [{ _: 'WindowItemCommand', itemId: 'quests', posX: 0, posY: 0, width: 200, height: 200, maximized: false }] }];
  const restored = systems.applyInit(session.player, commands, { db });
  assert.equal(restored[0].featureBarItems[0].posX, 12);
  assert.equal(restored[0].featureBarItems[0].height, 400);
  assert.equal(systems.applyInit(other, commands, { db })[0].featureBarItems[0].posX, 0);
  assert.equal(commands[0].featureBarItems[0].posX, 0);
});

test('owned PET with no fuel has a visible discoverable window and fills only missing free default shortcuts',()=>{
 require('../game/pet').addOwned(db,session.player.userId);
 const old=structuredClone(evidence.defaults.UserKeyBindingsUpdate);old.changedKeyBindings=old.changedKeyBindings.filter(b=>![4,5,13].includes(b.actionType));
 db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?)').run(session.player.userId,'UserKeyBindingsUpdate',JSON.stringify(old));
 const bindings=systems.buildInit(session.player,{db}).find(c=>c._==='UserKeyBindingsUpdate');
 assert.deepEqual(bindings.changedKeyBindings.find(b=>b.actionType===4).keyCodes,[69]);
 assert.deepEqual(bindings.changedKeyBindings.find(b=>b.actionType===5).keyCodes,[82]);
 assert.deepEqual(bindings.changedKeyBindings.filter(b=>![4,5,13].includes(b.actionType)),old.changedKeyBindings);
 const commands=[{_:'UIFeatureBarCommand',featureBarItems:[{_:'WindowItemCommand',itemId:'pet',posX:0,posY:63,width:260,height:130,visible:false,maximized:false}]}];
 const restored=systems.applyInit(session.player,commands,{db})[0].featureBarItems[0];assert.equal(restored.visible,true);assert.equal(restored.maximized,true);
 request('UIWindowUpdateRequest',{itemId:'pet',posX:14,posY:20,width:260,height:130,maximized:false});
 const closed=systems.applyInit(session.player,commands,{db})[0].featureBarItems[0];assert.equal(closed.visible,true);assert.equal(closed.maximized,false);assert.equal(closed.posX,14);
 assert.equal(require('../game/pet').owned(session.player.userId).fuel,0);
});

test('PET shortcut repair preserves an explicitly disabled action and other user key assignments',()=>{
 require('../game/pet').addOwned(db,session.player.userId);
 const old={_:'UserKeyBindingsUpdate',remove:false,changedKeyBindings:[{_:'UserKeyBindingsModule',actionType:4,keyCodes:[-1],parameter:0,charCode:0},{_:'UserKeyBindingsModule',actionType:7,keyCodes:[82],parameter:0,charCode:0}]};
 db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?)').run(session.player.userId,'UserKeyBindingsUpdate',JSON.stringify(old));
 const out=systems.buildInit(session.player,{db}).find(c=>c._==='UserKeyBindingsUpdate');
 assert.deepEqual(out.changedKeyBindings.find(b=>b.actionType===4).keyCodes,[-1]);assert.equal(out.changedKeyBindings.some(b=>b.actionType===5),false);
 assert.deepEqual(out.changedKeyBindings.find(b=>b.actionType===7).keyCodes,[82]);
});
test('quest giver visits require the actual home station and correct map object', () => {
  accept(20000); session.player.x = 18000; session.player.y = 11000;
  request('QuestGiverApproachedRequest', { questGiverId: 150000000 });
  assert.equal(state(20000).status, 'running');
  session.player.x = 2000; session.player.y = 2000;
  request('QuestGiverApproachedRequest', { questGiverId: 1 });
  assert.equal(state(20000).status, 'running'); home();
  assert.equal(state(20000).status, 'completed');
});
test('ordered quest progress rejects early hand-in and restores active conditions after reconnect', () => {
  finishFirst(); accept(20001); home();
  event({ type: 'npcKill', npcType: 71 });
  event({ type: 'npcKill', npcType: 84, amount: 2 });
  assert.equal(state(20001).status, 'running');
  event({ type: 'cargo', amount: 2 });
  assert.equal(state(20001).status, 'running');
  const quest = systems.buildInit(session.player, { db }).find(c => c._ === 'QuestInitializationCommand').quest;
  assert.equal(quest.rootCase.modifier[1].condition.state.active, true);
  assert.equal(quest.rootCase.modifier[0].questCase.modifier[0].condition.state.currentValue, 2);
  home(); assert.equal(state(20001).status, 'completed');
  assert.equal(count('equipment_generator_speed_g3n-3310'), 1);
  assert.equal(count('ammunition_rocket_r-310') >= 100, true);
});
test('all captured starter objectives complete with exactly once DB item and money rewards', () => {
  finishFirst(); accept(20001); event({ type: 'npcKill', npcType: 84, amount: 2 }); event({ type: 'cargo', amount: 2 }); home();
  accept(20002); event({ type: 'npcKill', npcType: 84, amount: 4 }); home();
  assert.equal(state(20002).status, 'completed');
  accept(20003);
  event({ type: 'sellOre', match: '1', amount: 10 });
  event({ type: 'collectLoot', lootId: 'resource_ore_prometium', amount: 10 });
  home(); assert.equal(state(20003).status, 'running');
  event({ type: 'sellOre', match: '1', amount: 10 });
  assert.equal(state(20003).status, 'running');
  home(); assert.equal(state(20003).status, 'completed');
  accept(20004); event({ type: 'npcKill', npcType: 84, amount: 2 }); event({ type: 'cargo', amount: 2 });
  event({ type: 'collectLoot', lootId: 'resource_ore_prometium', amount: 20 });
  event({ type: 'collectLoot', lootId: 'resource_ore_endurium', amount: 10 });
  assert.equal(state(20004).status, 'running'); home(); assert.equal(state(20004).status, 'completed');
  assert.equal(count('equipment_weapon_laser_lf-2'), 2);
  assert.equal(db.prepare('SELECT ep FROM players WHERE id=?').get(session.player.userId).ep, 10000);
  assert.equal(db.prepare('SELECT ep FROM players WHERE id=?').get(other.userId).ep, 0);
});
test('reward storage failure rolls back completion, progress, and currency without sending success', () => {
  accept(20000);
  db.exec("CREATE TRIGGER systems_reward_failure BEFORE UPDATE ON items BEGIN SELECT RAISE(ABORT,'injected quest reward failure'); END");
  sent.length = 0;
  assert.throws(home, /injected quest reward failure/);
  assert.equal(state(20000).status, 'running'); assert.equal(state(20000).progress_json, '{}');
  assert.equal(sent.length, 0);
  db.exec('DROP TRIGGER systems_reward_failure'); home(); assert.equal(state(20000).status, 'completed');
});
test('cancel clears owned quest progress and permits a fresh attempt without touching completed chain', () => {
  finishFirst(); accept(20001); event({ type: 'npcKill', npcType: 84 });
  request('QuestCancelRequest', { questId: 20001 }); assert.equal(state(20001).status, 'cancelled');
  accept(20001); assert.equal(state(20001).progress_json, '{}'); assert.equal(state(20000).status, 'completed');
  request('QuestCancelRequest', { questId: 20000 }); assert.equal(state(20000).status, 'completed');
});

test('quest rewards apply owned experience booster exactly once inside completion', () => {
  const boosters = require('../game/boosters');
  database.tx(db => { boosters.addOwned(db, session.player.userId, 'booster_ep-b01'); boosters.addOwned(db, session.player.userId, 'booster_hon-b01'); });
  finishFirst(); accept(20001); event({ type: 'npcKill', npcType: 84, amount: 2 }); event({ type: 'cargo', amount: 2 }); home();
  accept(20002); event({ type: 'npcKill', npcType: 84, amount: 4 }); home(); accept(20003);
  const before = db.prepare('SELECT ep,honour FROM players WHERE id=?').get(session.player.userId);
  event({ type: 'collectLoot', lootId: 'resource_ore_prometium', amount: 10 }); event({ type: 'sellOre', match: '1', amount: 10 }); home();
  assert.equal(state(20003).status, 'completed');
  const after = db.prepare('SELECT ep,honour FROM players WHERE id=?').get(session.player.userId);
  const rewards = evidence.quests.find(q => q.definition.id === 20003).definition.rewards;
  for (const [loot, field] of [['currency_experience', 'ep'], ['currency_honour', 'honour']]) {
    const base = rewards.find(item => item.lootId === loot)?.amount || 0;
    assert.equal(after[field] - before[field], Math.round(base * 1.1));
  }
  home(); assert.deepEqual(db.prepare('SELECT ep,honour FROM players WHERE id=?').get(session.player.userId), after);
});
test('builder initializes with this player money and no captured account energy', () => {
  const command = systems.gateInfo(session.player, db);
  assert.equal(command.samples, 0); assert.equal(command.money, session.player.uridium);
  assert.equal(command.gates.length, 11); assert.equal(command.gates.find(g=>g.id===12).currPart,0);
  services.sendCmd(session, command);
  request('GalaxyGateBuilderSaveSpinAmountRequest', { spinAmount: 5 });
  assert.equal(systems.gateInfo(session.player, db).spinamount_selected, 5);
  assert.equal(systems.gateInfo(other, db).spinamount_selected, 1);
});
test('builder spends free energy first, debits money once and persists granted ammo', () => {
  systems.gateInfo(session.player, db);
  db.prepare('UPDATE galaxy_gate_accounts SET energy=2 WHERE player_id=?').run(session.player.userId);
  const before = session.player.uridium, ammoBefore = count('ammunition_laser_mcb-25');
  let roll = 0;
  const command = systems.spin(session.player, { gateId: 1, spinAmount: 5, useMultiplier: false }, db, () => ++roll % 2 ? 0.5 : 0);
  assert.equal(command.errorCode, 0); assert.equal(command.money, before - 3 * systems.ENERGY_COST); assert.equal(command.samples, 0);
  assert.equal(count('ammunition_laser_mcb-25'), ammoBefore + 5 * 280);
  assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(session.player.userId).uridium, command.money);
  services.sendCmd(session, command);
});
test('gate parts and duplicates persist independently of player and gate selection', () => {
  systems.gateInfo(session.player, db);
  const roll = () => 0;
  const one = systems.spin(session.player, { gateId: 1, spinAmount: 1, useMultiplier: false }, db, roll);
  const two = systems.spin(session.player, { gateId: 1, spinAmount: 1, useMultiplier: false }, db, roll);
  assert.deepEqual(one.gatePartIds, [1]); assert.deepEqual(two.gatePartIds, [1]); assert.equal(two.multiplier, 1);
  assert.equal(two.items[0].duplicate, true); services.sendCmd(session, two);
  const info = systems.gateInfo(session.player, db);
  assert.equal(info.gates.find(g => g.id === 1).currPart, 1); assert.equal(info.gates.find(g => g.id === 2).currPart, 0);
  assert.equal(systems.gateInfo(other, db).gates.find(g => g.id === 1).currPart, 0);
});

test('hero/map initialization cannot initialize builder twice or append duplicate tabs', () => {
  assert.ok(!systems.buildInit(session.player, { db }).some(c => c._.startsWith('GalaxyGateBuilder')));
  assert.deepEqual(systems.applyInit(session.player, [evidence.gateInfo, { _: 'GalaxyGateBuilderGetGatePartsCommand' }], { db }), []);
  request('GalaxyGateBuilderInfoRequest'); request('GalaxyGateBuilderInfoRequest');
  assert.equal(sent.filter(c => c._ === 'GalaxyGateBuilderInfoCommand').length, 1);
  assert.equal(new Set(sent[0].gates.map(g => g.id)).size, sent[0].gates.length);
  systems.buildInit(session.player, { db }); request('GalaxyGateBuilderInfoRequest');
  assert.equal(sent.length, 1);
  request('GalaxyGateBuilderInfoRequest', {}, { player: other, world: { player: other } });
  assert.equal(sent.length, 2);
});

test('all source reward types write actual owned balances and roundtrip through the codec', () => {
  const cases = [
    [0.5, 0.00, 'ammunition_laser_mcb-25', 1, 2, 280],
    [0.5, 0.18, 'ammunition_laser_mcb-50', 1, 3, 100],
    [0.5, 0.35, 'ammunition_laser_ucb-100', 1, 4, 50],
    [0.5, 0.51, 'ammunition_laser_sab-50', 1, 5, 100],
    [0.5, 0.68, 'ammunition_rocket_plt-2021', 2, 3, 40],
    [0.5, 0.84, 'ammunition_mine_acm-01', 3, 11, 3],
    [0.26, 0, 'resource_repairvoucher', 5, 0, 1],
    [0.285, 0, 'resource_logfile', 8, 0, 1]
  ];
  for (const [category, tier, loot, type, itemId, amount] of cases) {
    const before = count(loot), rolls = [category, tier];
    const result = systems.spin(session.player, { gateId: 1, spinAmount: 1 }, db, () => rolls.shift());
    assert.equal(result.errorCode, 0); assert.equal(result.items[0].type, type); assert.equal(result.items[0].item_id, itemId);
    assert.equal(count(loot), before + amount); assert.equal(count(loot, other.userId), 0);
    services.sendCmd(session, result);
  }
  const before = db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(session.player.userId)?.amount || 0;
  const result = systems.spin(session.player, { gateId: 1, spinAmount: 1 }, db, () => 0.2);
  assert.equal(result.items[0].type, 4); assert.equal(result.items[0].amount, 10); services.sendCmd(session, result);
  assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(session.player.userId).amount, before + 10);
});

test('duplicates bank visible x2 through x6; unchecked preserves bank and checked consumes once', () => {
  systems.gateInfo(session.player, db);
  const id = session.player.userId;
  db.prepare('UPDATE galaxy_gate_progress SET parts_json=\'[1]\' WHERE player_id=? AND gate_id=1').run(id);
  for (let n = 1; n <= 7; n++) {
    const duplicate = systems.spin(session.player, { gateId: 1, spinAmount: 1, useMultiplier: false }, db, () => 0);
    assert.equal(duplicate.multiplier, Math.min(5, n));
  }
  let roll = 0;
  const unchecked = systems.spin(session.player, { gateId: 1, spinAmount: 1, useMultiplier: false }, db, () => ++roll % 2 ? 0.5 : 0);
  assert.equal(unchecked.multiplier, 5); assert.equal(unchecked.items[0].amount, 280); assert.equal(unchecked.items[0].multiplier_used, 0);
  roll = 0;
  const used = systems.spin(session.player, { gateId: 1, spinAmount: 5, useMultiplier: true }, db, () => ++roll % 2 ? 0.5 : 0);
  assert.equal(used.multiplier, 0); assert.deepEqual(used.items.map(i => i.amount), [1680, 1120]);
  assert.deepEqual(used.items.map(i => i.multiplier_used), [6, 0]);
  assert.deepEqual(used.items.map(i => i.spins), [1, 4]);
  assert.equal(used.items[0].multiplier_amount, 1400); services.sendCmd(session, used);
  assert.equal(systems.gateInfo(session.player, db).gates.find(g => g.id === 1).multiplier, 0);
});

test('selected multiplier applies to new parts, ore, vouchers and logfiles as actual granted amount', () => {
  systems.gateInfo(session.player, db);
  for (const roll of [0.2, 0.26, 0.285]) {
    db.prepare('UPDATE galaxy_gate_progress SET multiplier=2 WHERE player_id=? AND gate_id=1').run(session.player.userId);
    const result = systems.spin(session.player, { gateId: 1, spinAmount: 1, useMultiplier: true }, db, () => roll);
    assert.equal(result.multiplier, 0); assert.equal(result.items[0].multiplier_used, 3);
    assert.equal(result.items[0].amount, roll === 0.2 ? 30 : 3); services.sendCmd(session, result);
  }
  db.prepare('UPDATE galaxy_gate_progress SET multiplier=2 WHERE player_id=? AND gate_id=1').run(session.player.userId);
  const values = [0, 0, 0.03, 0.06];
  const result = systems.spin(session.player, { gateId: 1, spinAmount: 1, useMultiplier: true }, db, () => values.shift());
  assert.deepEqual(result.gatePartIds, [1, 2, 3]); assert.equal(result.multiplier, 0);
  assert.ok(result.items.every(i => i.multiplier_used === 3)); services.sendCmd(session, result);
});

test('reward storage failure restores the selected multiplier as well as money and energy', () => {
  systems.gateInfo(session.player, db);
  db.prepare('UPDATE galaxy_gate_progress SET multiplier=4 WHERE player_id=? AND gate_id=1').run(session.player.userId);
  db.prepare('UPDATE galaxy_gate_accounts SET energy=1 WHERE player_id=?').run(session.player.userId);
  const before = session.player.uridium;
  db.exec("CREATE TRIGGER gate_logfile_failure BEFORE INSERT ON items WHEN NEW.loot_id='resource_logfile' BEGIN SELECT RAISE(ABORT,'gate reward failure'); END");
  assert.throws(() => systems.spin(session.player, { gateId: 1, spinAmount: 1, useMultiplier: true }, db, () => 0.285), /gate reward failure/);
  assert.equal(systems.gateInfo(session.player, db).samples, 1); assert.equal(session.player.uridium, before);
  assert.equal(systems.gateInfo(session.player, db).gates.find(g => g.id === 1).multiplier, 4);
  assert.equal(count('resource_logfile'), 0);
});
test('builder rejects invalid spins and insufficient funds without consuming energy or items', () => {
  db.prepare('UPDATE players SET uridium=0 WHERE id=?').run(session.player.userId); session.player.uridium = 0;
  const before = count('ammunition_laser_mcb-25');
  assert.equal(systems.spin(session.player, { gateId: 1, spinAmount: 1 }, db).errorCode, 1);
  assert.equal(systems.spin(session.player, { gateId: 1, spinAmount: -1 }, db).errorCode, 2);
  assert.equal(systems.spin(session.player, { gateId: 99, spinAmount: 1 }, db).errorCode, 2);
  assert.equal(count('ammunition_laser_mcb-25'), before);
});
test('builder reward failure rolls back money, energy, parts, and live balance', () => {
  systems.gateInfo(session.player, db);
  db.prepare('UPDATE galaxy_gate_accounts SET energy=2 WHERE player_id=?').run(session.player.userId);
  const before = session.player.uridium;
  db.exec("CREATE TRIGGER systems_spin_failure BEFORE INSERT ON items BEGIN SELECT RAISE(ABORT,'injected spin failure'); END");
  assert.throws(() => systems.spin(session.player, { gateId: 1, spinAmount: 5 }, db, () => 0.5), /injected spin failure/);
  assert.equal(session.player.uridium, before); assert.equal(systems.gateInfo(session.player, db).samples, 2);
  assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(session.player.userId).uridium, before);
});
test('incomplete gates reject setup; complete gates activate a real owned run', () => {
  systems.gateInfo(session.player, db);
  request('GalaxyGateBuilderSetupGateRequest', { gateId: 1 }); assert.equal(sent.at(-1).errorCode, 1);
  db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=1').run(JSON.stringify(Array.from({ length: 34 }, (_, i) => i + 1)), session.player.userId);
  request('GalaxyGateBuilderSetupGateRequest', { gateId: 1 });
  assert.equal(sent.findLast(c => c._ === 'GalaxyGateBuilderSetupGateCommand').errorCode, 0);
  request('GalaxyGateBuilderBuyLifeRequest', { gateId: 1 });
  assert.equal(sent.findLast(c => c._ === 'GalaxyGateBuilderBuyLifeCommand').errorCode, 0);
  const gate = systems.gateInfo(session.player, db).gates.find(g => g.id === 1);
  assert.equal(gate.currPart, 0); assert.equal(gate.livesLeft, 4);
});
