'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { DatabaseSync } = require('node:sqlite');
const database = require('../game/db');
const players = require('../game/db/players');
const systems = require('../game/handlers/systems');
const content = require('../game/quests-content');
const codec = require('../game/codec/codec');
let db, session, sent, handlers, services;
beforeEach(() => {
  database.close(); db = database.open(':memory:');
  const a = db.prepare("INSERT INTO accounts(username,password_hash,created_at) VALUES('quest-pilot','test',0)").run();
  const id = players.createPlayer(Number(a.lastInsertRowid), 'quest-pilot', 1, require('../config.json').starter);
  session = { player: players.loadPlayer(id), id: 1 }; session.world = { player: session.player };
  sent = []; handlers = new Map(); services = { db, sendCmd: (s, command) => {
    const result = codec.decode(codec.encode(command)); assert.equal(result.rest, 0); assert.deepEqual(result.obj, command); sent.push(command);
  } };
  systems.register((name, fn) => handlers.set(name, fn), services);
  systems.questList(session.player, db);
});
afterEach(() => database.close());
const request = (name, fields = {}) => handlers.get(name)(session, { _: name, ...fields });
const state = id => db.prepare('SELECT * FROM player_quests WHERE player_id=? AND quest_id=?').get(session.player.userId, id);
const accept = id => request('QuestAcceptRequest', { questId: id });
const event = data => systems.recordEvent(session, data, services);
const count = loot => db.prepare('SELECT coalesce(sum(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(session.player.userId, loot).n;
function level(n) { session.player.level = n; db.prepare('UPDATE players SET level=? WHERE id=?').run(n, session.player.userId); }
function prerequisite(id) {
  db.prepare("INSERT INTO player_quests(player_id,quest_id,status,accepted_at,completed_at) VALUES(?,?,'completed',1,2) ON CONFLICT(player_id,quest_id) DO UPDATE SET status='completed'").run(session.player.userId, id);
}
function home() {
  const p = session.player; p.mapId = content.ownMap(p.factionId, 1); p.x = p.factionId === 1 ? 2000 : 19000; p.y = p.factionId === 3 ? 11100 : 2000;
  request('QuestGiverApproachedRequest', { questGiverId: 150000000 });
}
function leaves(root) { return root.modifier.flatMap(e => e.questCase.id ? leaves(e.questCase) : [e.condition]); }

test('all enabled quests use native codec structures and every added title resolves in Flash resources', () => {
  const list = systems.questList(session.player, db); assert.equal(list.list.length, 53);
  const text = fs.readFileSync(path.join(__dirname, '../client/spacemap/templates/tr/resource_quest.xml'), 'utf8');
  for (const quest of content.missions) {
    const id = quest.definition.id;
    assert.ok(text.includes(`name="quest_title_${id}"`), `title ${id}`);
    if (quest.provenance.kind === 'local') assert.match(text, new RegExp(`quest_title_${id}"[^>]*><!\\[CDATA\\[\\[Yerel\\]`));
    request('QuestInfoRequest', { questId: id });
    assert.ok(sent.at(-1).definition);
  }
  services.sendCmd(session, list);
});

test('next starter collects actual bonus boxes, returns home and grants shield/ammo exactly once', () => {
  prerequisite(20004); accept(20005);
  const before = count('ammunition_laser_mcb-50'), shields = count('equipment_generator_shield_sg3n-b02');
  event({ type: 'cargo', amount: 3 }); event({ type: 'collectLoot', lootId: 'resource_ore_prometium', amount: 30 }); home();
  assert.equal(state(20005).progress_json, '{}');
  event({ type: 'collectLoot', lootId: 'bonus_box', amount: 3 }); assert.equal(state(20005).status, 'running');
  home(); assert.equal(state(20005).status, 'completed');
  assert.equal(count('ammunition_laser_mcb-50'), before + 1000); assert.equal(count('equipment_generator_shield_sg3n-b02'), shields + 1);
  home(); accept(20005); assert.equal(count('ammunition_laser_mcb-50'), before + 1000);
  assert.equal(db.prepare('SELECT count(*) n FROM quest_reward_claims').get().n, 1);
  assert.equal(systems.questList(session.player, db).onlyStarter, false);
});

test('starter20006 follows hotbar, ownx2, logical Lordakia kills, ownx1 and hand-in in order', () => {
  prerequisite(20005); accept(20006);
  const initial = () => JSON.parse(state(20006).progress_json);
  event({ type: 'mapVisit', mapId: 2 }); event({ type: 'npcKill', npcKey: 'lordakia', amount: 5, mapId: 2 }); assert.deepEqual(initial(), {});
  event({ type: 'slotItem', lootId: 'ammunition_laser_mcb-50', slotBarId: 'premiumSlotBar' }); assert.deepEqual(initial(), {});
  event({ type: 'slotItem', lootId: 'ammunition_laser_mcb-50', slotBarId: 'standardSlotBar' });
  event({ type: 'mapVisit', mapId: 6 }); event({ type: 'npcKill', npcKey: 'lordakia', amount: 5, mapId: 2 });
  assert.equal(initial()[2000603], undefined);
  event({ type: 'mapVisit', mapId: 2 }); event({ type: 'npcKill', npcType: 71, amount: 5, mapId: 2 }); home();
  assert.equal(state(20006).status, 'running');
  event({ type: 'mapVisit', mapId: 1 }); home(); assert.equal(state(20006).status, 'completed');
  assert.equal(count('equipment_weapon_laser_lf-3'), 1);
});

test('already placed standard-bar ammo initializes the starter objective from owned persisted slots', () => {
  prerequisite(20005);
  db.prepare('INSERT INTO settings VALUES(?,?,?)').run(session.player.userId, 'hotbar.slots', JSON.stringify({ standardSlotBar: { 2: 'ammunition_laser_mcb-50' } }));
  accept(20006); assert.equal(JSON.parse(state(20006).progress_json)[2000601], 1);
  const restored = systems.buildInit(session.player, { db }).find(c => c._ === 'QuestInitializationCommand');
  assert.equal(leaves(restored.quest.rootCase)[1].state.active, true);
});

test('native npcId mapping distinguishes normal Lordakia, Boss, Uber and every ship visual', () => {
  level(3); prerequisite(20005); accept(900002);
  event({ type: 'npcKill', npcType: 24, mapId: 2 }); event({ type: 'npcKill', npcType: 37, mapId: 2 });
  assert.deepEqual(JSON.parse(state(900002).progress_json), {});
  event({ type: 'npcKill', npcType: 71, mapId: 2 }); event({ type: 'npcKill', npcId: 2, npcType: 999, mapId: 2 });
  assert.equal(JSON.parse(state(900002).progress_json)[90000201], 2);
  const source = fs.readFileSync(path.join(__dirname, '../decompiled/pet-patterns/game.xml'), 'utf8');
  const extracted = require('../game/quests-npc-ids.json');
  assert.equal(require('node:crypto').createHash('sha256').update(source).digest('hex'), extracted.sha256);
  assert.equal(extracted.visualToNpcId[74], 5); assert.equal(extracted.visualToNpcId[78], 9); assert.equal(extracted.visualToNpcId[111], 58);
});

test('faction-resolved map limits reject enemy maps and gate copies of normal NPCs', () => {
  level(3); prerequisite(20005); session.player.factionId = 2; accept(900002);
  const snap = JSON.parse(state(900002).snapshot_json); assert.deepEqual(snap.constraints[90000201].maps, ['6']);
  event({ type: 'npcKill', npcKey: 'lordakia', mapId: 2, amount: 10 }); event({ type: 'npcKill', npcKey: 'lordakia', mapId: 51, amount: 10 });
  assert.deepEqual(JSON.parse(state(900002).progress_json), {});
  session.player.mapId = 6; event({ type: 'npcKill', npcKey: 'lordakia', amount: 10 }); home();
  assert.equal(state(900002).status, 'completed');
  assert.equal(content.ownMap(3, 7), 27);
});

test('ordered stages never reuse one action for a newly unlocked identical objective', () => {
  level(3); prerequisite(20005); const row = db.prepare('SELECT definition_json FROM quest_definitions WHERE id=900004').get();
  const definition = JSON.parse(row.definition_json); definition.rootCase.modifier[1].condition.matches = ['own:2'];
  db.prepare('UPDATE quest_definitions SET definition_json=? WHERE id=900004').run(JSON.stringify(definition));
  accept(900004); event({ type: 'mapVisit', mapId: 2 });
  let progress = JSON.parse(state(900004).progress_json); assert.equal(progress[90000401], 1); assert.equal(progress[90000402], undefined);
  event({ type: 'mapVisit', mapId: 2 }); progress = JSON.parse(state(900004).progress_json); assert.equal(progress[90000402], 1);
});

test('accepted objectives, maps and rewards remain pinned when the live catalog changes', () => {
  level(3); prerequisite(20005); accept(900002);
  const original = db.prepare('SELECT definition_json FROM quest_definitions WHERE id=900002').get();
  const updated = JSON.parse(original.definition_json); updated.rewards = [{ _: 'LootModule', lootId: 'currency_credits', amount: 999999, modifier: '' }];
  updated.rootCase.modifier[0].condition.targetValue = 999;
  db.prepare('UPDATE quest_definitions SET definition_json=?,constraints_json=? WHERE id=900002').run(JSON.stringify(updated), '{}');
  const before = session.player.credits;
  event({ type: 'npcKill', npcKey: 'lordakia', mapId: 2, amount: 10 }); home();
  assert.equal(state(900002).status, 'completed'); assert.equal(session.player.credits - before, 16000);
});

test('unique authoritative event receipts prevent a duplicate action and rollback with failed reward storage', () => {
  level(2); prerequisite(20005); accept(900012);
  event({ type: 'collectLoot', lootId: 'bonus_box', amount: 1, eventId: 'box-one' });
  event({ type: 'collectLoot', lootId: 'bonus_box', amount: 1, eventId: 'box-one' });
  assert.equal(JSON.parse(state(900012).progress_json)[90001201], 1);
  db.exec("CREATE TRIGGER quest_fail BEFORE UPDATE ON players BEGIN SELECT RAISE(ABORT,'quest failure'); END");
  assert.throws(() => event({ type: 'collectLoot', lootId: 'bonus_box', amount: 19, eventId: 'box-two' }), /quest failure/);
  assert.equal(JSON.parse(state(900012).progress_json)[90001201], 1);
  assert.equal(db.prepare('SELECT count(*) n FROM quest_reward_claims').get().n, 0);
  assert.equal(db.prepare('SELECT count(*) n FROM quest_event_receipts').get().n, 1);
  db.exec('DROP TRIGGER quest_fail'); event({ type: 'collectLoot', lootId: 'bonus_box', amount: 19, eventId: 'box-two' });
  assert.equal(state(900012).status, 'completed'); assert.equal(db.prepare('SELECT count(*) n FROM quest_reward_claims').get().n, 1);
});

test('running limit exposes native unmet requirement and cancelled attempts reset their owned snapshot', () => {
  level(12); prerequisite(20005); prerequisite(900002); prerequisite(900008);
  for (const id of [900001, 900003, 900004, 900006, 900009]) accept(id);
  accept(900010); assert.equal(state(900010), undefined);
  const locked = systems.questList(session.player, db).list.find(q => q.questId === 900010);
  assert.equal(locked.acceptabilityStatus.type, 0); assert.ok(locked.missingAcceptRequirements.some(r => r.requirementType === 1));
  request('QuestCancelRequest', { questId: 900003 }); accept(900010); assert.equal(state(900010).status, 'running');
  event({ type: 'npcKill', npcKey: 'interceptor', mapId: 91 }); request('QuestCancelRequest', { questId: 900010 }); accept(900010);
  assert.equal(state(900010).progress_json, '{}'); assert.ok(state(900010).snapshot_json);
});

test('prerequisite reasons render native quest titles and unknown/client condition updates cannot advance quests', () => {
  const locked = systems.questList(session.player, db).list.find(q => q.questId === 20005);
  assert.equal(locked.missingAcceptRequirements[0].requirementType, 3);
  assert.equal(locked.missingAcceptRequirements[0].missingMatches[0].questId, 20004);
  accept(20000); event({ type: 'QuestConditionUpdateCommand', amount: 999 }); event({ type: 'npcKill', amount: -1 });
  assert.equal(state(20000).progress_json, '{}'); assert.equal(handlers.has('QuestConditionUpdateCommand'), false);
  event.call(null, { type: 'visitQuestGiver', amount: 0 }); assert.equal(state(20000).status, 'running');
});

test('completed details preserve counters with inactive objectives and a paid quest cannot be reopened', () => {
  level(2); prerequisite(20005); accept(900012); event({ type: 'collectLoot', lootId: 'bonus_box', amount: 20 });
  request('QuestInfoRequest', { questId: 900012 }); const leaf = leaves(sent.at(-1).definition.rootCase)[0];
  assert.deepEqual(leaf.state, { _: 'QuestConditionStateModule', currentValue: 20, active: false, completed: true });
  db.prepare("UPDATE player_quests SET status='cancelled' WHERE quest_id=900012").run(); accept(900012);
  assert.equal(state(900012).status, 'cancelled');
});

test('Alpha mission only advances from authoritative Alpha completion, not entering or another gate', () => {
  level(6); prerequisite(20005); accept(900011);
  event({ type: 'mapVisit', mapId: 51 }); event({ type: 'gateComplete', mapId: 52, gateId: 2 });
  assert.equal(state(900011).progress_json, '{}');
  event({ type: 'gateComplete', mapId: 51, gateId: 1, eventId: 'run:123' });
  assert.equal(state(900011).status, 'completed');
  event({ type: 'gateComplete', mapId: 51, gateId: 1, eventId: 'run:123' });
  assert.equal(db.prepare('SELECT count(*) n FROM quest_reward_claims').get().n, 1);
});

test('all12 authored missions have reachable supported objectives, real catalog rewards and one claim', () => {
  level(20); prerequisite(20005);
  const keys = require('../game/npc-catalog').definitions;
  const visualIds = require('../game/quests-npc-ids.json').visualToNpcId;
  for (const mission of content.missions.filter(q => q.provenance.kind === 'local')) {
    if (mission.prerequisite) prerequisite(mission.prerequisite);
    const id = mission.definition.id; if (state(id)?.status === 'completed') db.prepare('DELETE FROM player_quests WHERE player_id=? AND quest_id=?').run(session.player.userId, id);
    accept(id); assert.equal(state(id).status, 'running', `accept ${id}`);
    const snapshot = JSON.parse(state(id).snapshot_json);
    for (const condition of leaves(snapshot.definition.rootCase)) {
      const map = Number(snapshot.constraints[condition.id]?.maps[0] ?? session.player.mapId);
      const eventData = { amount: condition.targetValue, mapId: map };
      if (condition.type === 6) Object.assign(eventData, { type: 'npcKill', npcKey: Object.keys(keys).find(k => visualIds[keys[k].typeId] === Number(condition.matches[0])) });
      if (condition.type === 67) Object.assign(eventData, { type: 'collectLoot', lootId: condition.matches[0] });
      if (condition.type === 55) Object.assign(eventData, { type: 'collectLoot', lootId: 'bonus_box' });
      if (condition.type === 51) eventData.type = 'cargo';
      if (condition.type === 52) Object.assign(eventData, { type: 'sellOre', match: condition.matches[0] });
      if (condition.type === 34) Object.assign(eventData, { type: 'mapVisit', mapId: Number(condition.matches[0]) });
      if (condition.type === 79) Object.assign(eventData, { type: 'gateComplete', mapId: Number(condition.matches[1]) });
      if (condition.type === 62) home(); else event(eventData);
    }
    assert.equal(state(id).status, 'completed', `finish ${id}`);
    assert.equal(db.prepare('SELECT count(*) n FROM quest_reward_claims WHERE quest_id=?').get(id).n, 1);
  }
});

test('migration018 preserves running/cancelled/completed legacy progress and records existing paid completion', () => {
  const legacy = new DatabaseSync(':memory:'); legacy.exec('PRAGMA foreign_keys=ON');
  try {
    const folder = path.join(__dirname, '../game/db/migrations');
    for (const name of fs.readdirSync(folder).filter(n => n.endsWith('.sql') && Number(n.slice(0, 3)) < 18).sort()) legacy.exec(fs.readFileSync(path.join(folder, name), 'utf8'));
    legacy.prepare("INSERT INTO accounts(id,username,password_hash,created_at) VALUES(1,'old','test',0)").run();
    const playerFields = db.prepare('SELECT * FROM players WHERE id=?').get(session.player.userId);
    const fields = Object.keys(playerFields); legacy.prepare(`INSERT INTO players(${fields.join(',')}) VALUES(${fields.map(() => '?').join(',')})`).run(...Object.values(playerFields));
    for (const [id, status] of [[1, 'running'], [2, 'cancelled'], [3, 'completed']]) {
      legacy.prepare('INSERT INTO quest_definitions(id,definition_json,slim_json) VALUES(?,?,?)').run(id, JSON.stringify({ rewards: [{ lootId: 'currency_credits', amount: 1 }] }), '{}');
      legacy.prepare('INSERT INTO player_quests(player_id,quest_id,status,progress_json,accepted_at,completed_at) VALUES(1,?,?,?,?,?)').run(id, status, '{"condition":7}', 123, status === 'completed' ? 456 : null);
    }
    legacy.exec(fs.readFileSync(path.join(folder, '018-quests.sql'), 'utf8'));
    assert.deepEqual({ ...legacy.prepare('SELECT status,progress_json,accepted_at,completed_at FROM player_quests WHERE quest_id=1').get() }, { status: 'running', progress_json: '{"condition":7}', accepted_at: 123, completed_at: null });
    assert.ok(JSON.parse(legacy.prepare('SELECT snapshot_json FROM player_quests WHERE quest_id=1').get().snapshot_json).definition.rewards);
    assert.equal(legacy.prepare('SELECT count(*) n FROM quest_reward_claims').get().n, 1);
    assert.equal(legacy.prepare('SELECT claimed_at FROM quest_reward_claims').get().claimed_at, 456);
    assert.equal(legacy.prepare('PRAGMA foreign_key_check').all().length, 0);
  } finally { legacy.close(); }
});
