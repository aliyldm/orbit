'use strict';
const test = require('node:test'), assert = require('node:assert/strict');
const catalog = require('../game/npc-catalog');
const { open } = require('../game/db'), db = open(':memory:');
const fs = require('node:fs'), path = require('node:path');
test('gate catalogue uses canonical native client visual types, including Zeta icon bindings', () => {
  const xml = fs.readFileSync(path.join(__dirname, '../decompiled/pet-patterns/game.xml'), 'utf8').replace(/<!--[\s\S]*?-->/g, '');
  const types = new Set([...xml.matchAll(/<ship\b[^>]*\btype="(\d+)"/g)].map(m=>Number(m[1])));
  for (const def of Object.values(catalog.definitions)) {
    assert.ok(types.has(def.typeId), `${def.key} must have a real client ship pattern`);
    for (const field of ['hitpoints','shield','speed','damageMin','damageMax']) assert.ok(Number.isFinite(def[field]) && def[field] >= 0, `${def.key}:${field}`);
    assert.ok(def.hitpoints > 0 && def.damageMax >= def.damageMin);
  }
  const iconSource = fs.readFileSync(path.join(__dirname, '../decompiled/main/scripts/net/bigpoint/darkorbit/InGameCatalog.as'),'utf8');
  for (const [key,id] of [['infernal',100],['scorcher',99],['melter',102],['devourer',105]]) {
    assert.equal(catalog.get(key).typeId,id);
    assert.match(iconSource,new RegExp(`SHIPICON_IFREET_${key.toUpperCase()}[^;]*iconShip${id}`));
  }
});
test('classic Beta/Gamma multipliers scale hull, shields, damage and rewards, but not movement speed', () => {
  const a = catalog.get('kristallon'), b = catalog.get('kristallon',2), g = catalog.get('kristallon',3);
  assert.equal(a.hitpoints,400000); assert.equal(a.shield,300000);
  assert.deepEqual([b.hitpoints,b.shield,b.damageMin,b.damageMax],[800000,600000,8100,9976]);
  assert.deepEqual([g.hitpoints,g.shield,g.damageMin,g.damageMax],[1200000,900000,12150,14964]);
  assert.equal(g.speed,a.speed); assert.equal(g.reward.uridium,384); assert.equal(g.shieldAbsorb,.5);
  b.reward.uridium=0; assert.equal(catalog.get('kristallon',2).reward.uridium,256);
  assert.throws(()=>catalog.get('unknown'),/missing/); assert.throws(()=>catalog.get('streuner',NaN),/scale/);
});
test('Hades and Kuiper stats use recovered official values and preserve stationary turrets', () => {
  const h = catalog.get('emperor-kristallon');
  assert.equal(h.hitpoints,14080000); assert.equal(h.shield,11100000); assert.equal(h.damageMax,45000);
  assert.equal(catalog.get('streuner-soldier').hitpoints,150000);
  assert.equal(catalog.get('streuner-specialist').shield,300000);
  assert.equal(catalog.get('streuner-turret').speed,0);
  assert.equal(catalog.get('streuner-turret').localSpeed,false);
  assert.equal(catalog.get('emperor-sibelon').localSpeed,true);
});
test('catalogue seeds new NPC rows without overwriting existing local map tuning or adding new spawns', () => {
  const before = db.prepare('SELECT * FROM npc_types WHERE type_id=71').get();
  const spawns = db.prepare('SELECT COUNT(*) n FROM map_spawns').get().n;
  catalog.seed(db); catalog.seed(db);
  assert.deepEqual(db.prepare('SELECT * FROM npc_types WHERE type_id=71').get(), before);
  assert.equal(db.prepare('SELECT COUNT(*) n FROM map_spawns').get().n,spawns);
  assert.equal(db.prepare('SELECT hitpoints FROM npc_types WHERE type_id=79').get().hitpoints,400000);
  assert.equal(db.prepare('PRAGMA foreign_key_check').all().length,0);
});

test('Kappa variants preserve gate-specific hull, damage and movement rather than invasion or group stats', () => {
  for (const [key,hp,shield,speed,min,max] of [
    ['kappa-kucurbium',320000,1200000,200,5000,7000],
    ['kappa-boss-kucurbium',640000,480000,200,30000,40000],
    ['kappa-century-falcon',800000,600000,100,19000,25000],
    ['kappa-demaner',512000,256000,300,3500,5000]
  ]) {
    const d=catalog.get(key);
    assert.deepEqual([d.hitpoints,d.shield,d.speed,d.damageMin,d.damageMax],[hp,shield,speed,min,max]);
    assert.equal(d.localSpeed,false);
  }
  assert.equal(catalog.get('uber-streuner').reward.uridium,8);
});

test('Epsilon EN edition uses dedicated pirate stats without replacing Kappa general variants', () => {
  const e=catalog.get('epsilon-vagrant'), k=catalog.get('vagrant');
  assert.equal(e.hitpoints,60000); assert.equal(k.hitpoints,40000);
  assert.deepEqual(e.reward,{ep:4000,honour:4,credits:15000,uridium:8});
  assert.equal(e.localSpeed,true);
  const last=catalog.get('epsilon-convict');
  assert.equal(last.hitpoints,450000); assert.equal(last.shield,300000); assert.equal(last.reward.uridium,150);
});
