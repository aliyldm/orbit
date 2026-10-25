'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { createCdnCache } = require('../web/cdn-cache');
const { parse } = require('../tools/asset-manifest');
test('manifest file paths match FileVO and reject parent traversal', () => {
  const xml = '<location id="ships" path="graphics/ships/"/><file id="pet" location="ships" name="pet10" type="swf"/>';
  assert.equal(parse(xml)[0].path, 'spacemap/graphics/ships/pet10.swf');
  assert.throws(() => parse(xml.replace('graphics/ships/', '../../')), /Unsafe/);
});
test('concurrent CDN requests deduplicate, bound downloads, and persist only complete files', async () => {
  const folder = fs.mkdtempSync(path.join(__dirname, '../data/cache-test-'));
  let active = 0, peak = 0, count = 0;
  const logs = [];
  const cache = createCdnCache({ enabled: true, upstream: 'https://assets.invalid', concurrency: 2 }, message => logs.push(message), { fetch: async () => {
    count++; active++; peak = Math.max(peak, active);
    await new Promise(resolve => setTimeout(resolve, 5)); active--;
    return new Response('CWS-test');
  } });
  try {
    const tasks = Array.from({ length: 5 }, (_, n) => cache.fetchMissing(`${n}.swf`, path.join(folder, `${n}.swf`)));
    tasks.push(cache.fetchMissing('0.swf', path.join(folder, '0.swf')));
    assert.ok((await Promise.all(tasks)).every(Boolean), logs.join('\n'));
    assert.equal(count, 5); assert.equal(peak, 2);
    assert.equal(fs.readFileSync(path.join(folder, '0.swf'), 'utf8'), 'CWS-test');
    assert.equal(fs.readdirSync(folder).length, 5);
  } finally { for (const file of fs.readdirSync(folder)) fs.unlinkSync(path.join(folder, file)); fs.rmdirSync(folder); }
});
test('oversized, interrupted and HTML responses cannot poison the offline cache', async () => {
  const folder = fs.mkdtempSync(path.join(__dirname, '../data/cache-test-'));
  try {
    for (const body of ['too-long', '<html>unavailable</html>']) {
      const cache = createCdnCache({ enabled: true, upstream: 'https://assets.invalid', maxFileBytes: body === 'too-long' ? 4 : 100 }, () => {}, { fetch: async () => new Response(body) });
      assert.equal(await cache.fetchMissing('ship.swf', path.join(folder, 'ship.swf')), false);
    }
    const cache = createCdnCache({ enabled: true, upstream: 'https://assets.invalid' }, () => {}, { fetch: async () => new Response(new ReadableStream({ start(controller) { controller.error(new Error('interrupted')); } })) });
    assert.equal(await cache.fetchMissing('ship.swf', path.join(folder, 'ship.swf')), false);
    assert.deepEqual(fs.readdirSync(folder), []);
  } finally { fs.rmdirSync(folder); }
});
