'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db'), players = require('../game/db/players'), boosters = require('../game/boosters'), codec = require('../game/codec/codec');
let db, p, other, now;
const options = () => ({ db, now });
beforeEach(() => {
  database.close(); db = database.open(':memory:'); now = Date.now();
  const add = name => {
    const account = db.prepare('INSERT INTO accounts(username,password_hash,created_at) VALUES(?,?,0)').run(name, 'test');
    const id = players.createPlayer(Number(account.lastInsertRowid), name, 1, require('../config.json').starter);
    db.prepare('UPDATE players SET credits=100000000,uridium=100000000 WHERE id=?').run(id); return players.loadPlayer(id);
  };
  p = add('booster-one'); other = add('booster-two');
});
afterEach(() => database.close());
const grant = (loot, amount = 1, id = p.userId) => database.tx(db => boosters.addOwned(db, id, loot, amount, options()));
const row = (loot, id = p.userId) => db.prepare('SELECT * FROM player_boosters WHERE player_id=? AND loot_id=?').get(id, loot);
const roundTrip = command => { const decoded = codec.decode(codec.encode(command)); assert.equal(decoded.rest, 0); assert.deepEqual(decoded.obj, command); };

test('source metadata supplies ordinary booster durations and owner percentages', () => {
  assert.equal(boosters.definitions['booster_dmg-b01'].hours, 10);
  assert.deepEqual(boosters.definitions['booster_dmg-b01'].boostList.map(boost => [boost.type, boost.factor]), [['DAMAGE', 10]]);
  assert.equal(boosters.definitions['booster_shd-b01'].boostList[0].factor, 25);
  assert.equal(boosters.definitions['booster_ep-50'].hours, 24);
});
test('new players receive zero real effects and no recorded daily-login booster', () => {
  const command = boosters.buildInit(p, options())[0]; roundTrip(command);
  assert.equal(command.boostedDetailsUpdate.length, 0);
  assert.ok(command.boostedAttributes.every(effect => effect.value === 0));
  assert.ok(command.boostedDetailsRemove.some(detail => detail.lootId === 'booster_ep-dlb'));
});

test('initial empty booster tick and initialized active booster do not interrupt movement', () => {
  let refreshes = 0;
  const world = { player: p, refreshStats() { refreshes++; } };
  assert.equal(boosters.tick(world, options()), false); assert.equal(refreshes, 0);
  grant('booster_hp-b01'); delete p.boosterSignature;
  boosters.buildInit(p, options());
  assert.equal(boosters.tick(world, options()), false); assert.equal(refreshes, 0);
});
test('same booster extends duration without multiplying its effect or leaking ownership', () => {
  grant('booster_ep-b01'); assert.equal(row('booster_ep-b01').expires_at, now + 10 * 3600000);
  now += 3600000; grant('booster_ep-b01', 2);
  assert.equal(row('booster_ep-b01').expires_at, now + 29 * 3600000);
  assert.equal(boosters.effects(p.userId, options()).EXPERIENCE_POINTS, 10);
  assert.equal(boosters.effects(other.userId, options()).EXPERIENCE_POINTS, 0);
});
test('expired boosters remain expired offline and a new purchase starts a fresh catalog duration', () => {
  grant('booster_hp-b01'); const until = row('booster_hp-b01').expires_at;
  now = until; assert.equal(boosters.active(p.userId, options()).length, 0);
  assert.equal(boosters.multiplier(p.userId, 'HITPOINTS', options()), 1);
  now += 3600000; grant('booster_hp-b01'); assert.equal(row('booster_hp-b01').expires_at, now + 10 * 3600000);
});
test('different owned types combine personal percentages, excluding unowned shared-area effects', () => {
  grant('booster_ep-b01'); grant('booster_ep-b02'); grant('booster_ep-dlb');
  assert.equal(boosters.effects(p.userId, options()).EXPERIENCE_POINTS, 45);
  assert.equal(boosters.effects(other.userId, options()).EXPERIENCE_POINTS, 0);
  const command = boosters.buildInit(p, options())[0]; roundTrip(command);
  assert.equal(command.boostedDetailsUpdate.length, 3); assert.equal(command.boostedDetailsUpdate[0].secondsLeft, 36000);
  assert.ok(!command.boostedDetailsUpdate.some(detail => detail._ === 'BoosterSharedDetailModule'));
});
test('stats preserve existing skills/drone/ore fields and apply each supported attribute once', () => {
  for (const loot of ['booster_dmg-b01', 'booster_npc-b01', 'booster_hp-b01', 'booster_shd-b01', 'booster_rep-b01', 'booster_sreg-b01']) grant(loot);
  const skills = { repairMultiplier: 1.3 }, original = { hitMax: 100000, shieldMax: 10000, laserDamage: 2000, laserCount: 4, speed: 450, cargoMax: 1000,
    npcLaserMultiplier: 1.12, rocketMultiplier: 1.15, repairMultiplier: 1.05, shieldRegenMultiplier: 1.2, skills };
  const result = boosters.applyStats(p.userId, original, options());
  assert.equal(result.hitMax, 110000); assert.equal(result.shieldMax, 12500); assert.equal(result.laserDamage, 2200);
  assert.ok(Math.abs(result.npcLaserMultiplier - 1.232) < 1e-9);
  assert.ok(Math.abs(result.rocketMultiplier - 1.3915) < 1e-9);
  assert.ok(Math.abs(result.repairMultiplier - 1.155) < 1e-9); assert.equal(result.shieldRegenMultiplier, 1.5);
  assert.equal(result.skills, skills); assert.equal(result.speed, original.speed); assert.equal(result.cargoMax, original.cargoMax);
  assert.equal(original.hitMax, 100000);
});
test('EP and honour rewards use owner percentages without changing credits or uridium', () => {
  grant('booster_ep-b01'); grant('booster_hon-b01');
  assert.deepEqual(boosters.applyReward(p.userId, { ep: 1000, honour: 10, credits: 500, uridium: 2 }, options()), { ep: 1100, honour: 11, credits: 500, uridium: 2 });
  assert.deepEqual(boosters.applyReward(other.userId, { ep: 1000, honour: 10 }, options()), { ep: 1000, honour: 10 });
});
test('resource and bonus-box effects stay scoped to owned catalog categories', () => {
  grant('booster_res-b01'); grant('booster_bb-01');
  assert.equal(boosters.collectionMultiplier(p.userId, 'ore', options()), 1.25);
  assert.equal(boosters.collectionMultiplier(p.userId, 'bonusBox', options()), 2.5);
  assert.equal(boosters.collectionMultiplier(other.userId, 'bonusBox', options()), 1);
});

test('gameplay reward grants compose the current hull and boosters once, preserving wallet rewards', () => {
  db.prepare('UPDATE ships SET loot_id=? WHERE id=? AND player_id=?').run('ship_g-surgeon', p.shipId, p.userId);
  grant('booster_ep-b01'); grant('booster_hon-b01');
  const progression = require('../game/progression'), commands = [];
  const world = { player: p, save() {} }, session = { player: p };
  const reward = progression.grant(world, (_, command) => commands.push(command), session,
    { ep: 10000, honour: 10000, credits: 500, uridium: 2 });
  assert.deepEqual(reward, { ep: 11660, honour: 11660, credits: 500, uridium: 2 });
  assert.ok(commands.some(command => command.message.startsWith('0|LM|ST|EP|11660|')));
  db.prepare('UPDATE ships SET loot_id=? WHERE id=? AND player_id=?').run('ship_goliath', p.shipId, p.userId);
  assert.deepEqual(boosters.applyReward(p.userId, { ep: 10000, honour: 10000 }, options()), { ep: 11000, honour: 11000 });
});
test('PvP and unimplemented event-drop products reject without storing fake activation', () => {
  for (const loot of ['booster_dmg-pvp01', 'booster_dropch-b01']) {
    assert.equal(boosters.isSupported(loot), false); assert.throws(() => grant(loot), /desteklenmiyor/); assert.equal(row(loot), undefined);
  }
  assert.throws(() => grant('booster_unknown'), /katalogda/);
});

test('source-backed accuracy, cooldown and PET experience boosters apply and expire', () => {
  for (const id of ['booster_dmg-h01','booster_cd-b01','booster_cd-b02','booster_p-ep-b01']) grant(id);
  const stats=boosters.applyStats(p.userId,{laserDamage:1000,hitMax:1000,shieldMax:1000},options());
  assert.equal(stats.laserDamage,1020);assert.equal(stats.laserHitBonus,.08);assert.equal(stats.rocketHitBonus,.08);
  assert.equal(boosters.abilityCooldownMultiplier(p.userId,options()),.5);
  assert.equal(boosters.petExperienceMultiplier(p.userId,options()),1.05);
  now+=10*3600000;
  assert.equal(boosters.abilityCooldownMultiplier(p.userId,options()),1);
  assert.equal(boosters.petExperienceMultiplier(p.userId,options()),1);
  assert.equal(boosters.applyStats(p.userId,{laserDamage:1000},options()).laserHitBonus,0);
});

test('explicit captured bundle hours grant the actual partial duration and reject invalid time', () => {
  database.tx(db=>boosters.addOwned(db,p.userId,'booster_shd-b02',1,{...options(),hours:5}));
  assert.equal(row('booster_shd-b02').expires_at,now+5*3600000);
  for(const hours of [0,-1,NaN,Infinity,1e20])assert.throws(()=>database.tx(db=>boosters.addOwned(db,p.userId,'booster_shd-b02',1,{...options(),hours})));
  assert.equal(row('booster_shd-b02').expires_at,now+5*3600000);
});
test('duration overflow and invalid quantities do not change a previously active booster', () => {
  grant('booster_dmg-b01'); const before = row('booster_dmg-b01').expires_at;
  for (const amount of [0, -1, 1.5, NaN, Infinity, 1000000]) assert.throws(() => grant('booster_dmg-b01', amount));
  assert.equal(row('booster_dmg-b01').expires_at, before);
});
test('ledger insertion failure rolls back currency and never changes cached live stats', () => {
  const before = p.uridium;
  db.exec("CREATE TRIGGER booster_failure BEFORE INSERT ON player_boosters BEGIN SELECT RAISE(ABORT,'booster storage failure'); END");
  assert.throws(() => database.tx(db => {
    db.prepare('UPDATE players SET uridium=uridium-10000 WHERE id=?').run(p.userId);
    boosters.addOwned(db, p.userId, 'booster_dmg-b01', 1, options());
  }), /booster storage failure/);
  assert.equal(p.uridium, before); assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(p.userId).uridium, before);
  assert.equal(row('booster_dmg-b01'), undefined);
});
test('live refresh publishes real packet details after commit and removes expired stats once', () => {
  const commands = [], base = { hitMax: 10000, shieldMax: 1000, laserDamage: 100 }, player = { userId: p.userId };
  let refreshed = 0;
  const world = { player, refreshStats() { player.stats = boosters.applyStats(player.userId, base, options()); refreshed++; }, broadcast(fn) { fn({ player }); } };
  const sendCmd = (session, command) => { roundTrip(command); commands.push(command); };
  grant('booster_hp-b01'); boosters.purchased(world, { ...options(), sendCmd });
  assert.equal(player.stats.hitMax, 11000); assert.equal(commands.at(-1).boostedDetailsUpdate.length, 1);
  assert.equal(boosters.tick(world, { ...options(), sendCmd }), false); assert.equal(refreshed, 1);
  now += 10 * 3600000; assert.equal(boosters.tick(world, { ...options(), sendCmd }), true);
  assert.equal(player.stats.hitMax, 10000); assert.equal(commands.at(-1).boostedDetailsUpdate.length, 0);
  assert.ok(commands.at(-1).boostedDetailsRemove.some(detail => detail.lootId === 'booster_hp-b01'));
});
test('legacy paid inventory adoption is transactional and cannot activate the same item twice', () => {
  db.prepare('INSERT INTO items(player_id,loot_id,amount) VALUES(?,?,2)').run(p.userId, 'booster_dmg-b01');
  assert.equal(database.tx(db => boosters.adoptInventory(db, p.userId, options())), 2);
  assert.equal(database.tx(db => boosters.adoptInventory(db, p.userId, options())), 0);
  assert.equal(row('booster_dmg-b01').expires_at, now + 20 * 3600000);
  assert.equal(db.prepare("SELECT count(*) AS n FROM items WHERE player_id=? AND loot_id='booster_dmg-b01'").get(p.userId).n, 0);
});
