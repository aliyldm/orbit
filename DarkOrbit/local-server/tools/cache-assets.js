'use strict';
// Populate assets declared by the actual client XML. Existing files are preserved.
const fs = require('node:fs');
const path = require('node:path');
const { inventory, CLIENT, ROOT } = require('./asset-manifest');
const { createCdnCache } = require('../web/cdn-cache');
async function main() {
  const config = require('../config.json');
  const only2d = !process.argv.includes('--all');
  const assets = inventory({ only2d });
  const limitAt = process.argv.indexOf('--limit');
  const limit = limitAt >= 0 ? Number(process.argv[limitAt + 1]) : assets.missing.length;
  if (!Number.isInteger(limit) || limit < 0) throw new Error('--limit must be a nonnegative integer');
  const results = { startedAt: new Date().toISOString(), mode: only2d ? '2d' : 'all', queued: Math.min(limit, assets.missing.length), saved: 0, failures: [] };
  const messages = [];
  const cache = createCdnCache({ ...config.cdnCache, enabled: true }, message => { messages.push(message); });
  const todo = assets.missing.slice(0, limit);
  console.log(`Caching ${todo.length} missing ${results.mode} resources from ${config.cdnCache.upstream}`);
  let index = 0, done = 0;
  const checkpoint = () => {
    results.updatedAt = new Date().toISOString();
    fs.writeFileSync(path.join(ROOT, 'docs/asset-cache-result.json'), JSON.stringify(results, null, 2) + '\n');
  };
  await Promise.all(Array.from({ length: 6 }, async () => {
    while (index < todo.length) {
      const entry = todo[index++];
      const ok = await cache.fetchMissing(entry.path, path.join(CLIENT, entry.path));
      if (ok) results.saved++;
      else results.failures.push({ path: entry.path, error: messages.filter(m => m.includes(entry.path)).at(-1) || 'Download failed' });
      done++; messages.length = 0;
      if (done % 100 === 0) { checkpoint(); console.log(`${done}/${todo.length}: saved=${results.saved}, failed=${results.failures.length}`); }
    }
  }));
  results.finishedAt = new Date().toISOString(); checkpoint();
  console.log(`Finished: saved=${results.saved}, failed=${results.failures.length}, report=docs/asset-cache-result.json`);
  if (results.failures.length) process.exitCode = 1;
}
if (require.main === module) main().catch(error => { console.error(error.message); process.exitCode = 1; });
