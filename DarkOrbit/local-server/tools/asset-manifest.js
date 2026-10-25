'use strict';
// FileCollection/FileVO.as constructs location.path + name + '.' + type.
const fs = require('node:fs');
const path = require('node:path');
const ROOT = path.resolve(__dirname, '..');
const CLIENT = path.join(ROOT, 'client');
const MANIFESTS = ['resources.xml', 'resources_3d.xml', 'resources_3d_particles.xml', 'assets_loadingScreen.xml'];
function attributes(tag) {
  return Object.fromEntries([...tag.matchAll(/([\w:.-]+)\s*=\s*"([^"]*)"/g)].map(m => [m[1], m[2]]));
}
function parse(xml, prefix = 'spacemap/') {
  const locations = new Map([...xml.matchAll(/<location\b[^>]*\/>/g)].map(m => {
    const a = attributes(m[0]); return [a.id, a.path];
  }));
  return [...xml.matchAll(/<file\b[^>]*>/g)].map(m => {
    const a = attributes(m[0]), location = locations.get(a.location);
    if (location === undefined || !a.name || !a.type) throw new Error(`Invalid file location: ${a.id}`);
    const relative = prefix + location + a.name + '.' + a.type;
    if (relative.includes('\\') || relative.includes('\0') || relative.split('/').some(s => s === '..' || s === '.') || path.isAbsolute(relative))
      throw new Error(`Unsafe resource path: ${a.id}`);
    return { id: a.id, path: relative, hash: a.hash || null, type: a.type };
  });
}
function inventory(options = {}) {
  const entries = new Map(), manifests = [];
  for (const name of MANIFESTS) {
    if (options.only2d && name.includes('_3d')) continue;
    const file = path.join(CLIENT, 'spacemap/xml', name);
    if (!fs.existsSync(file)) { manifests.push({ name, missing: true }); continue; }
    const list = parse(fs.readFileSync(file, 'utf8'));
    manifests.push({ name, files: list.length });
    for (const entry of list) if (!entries.has(entry.path)) entries.set(entry.path, { ...entry, manifest: name });
  }
  let cached = 0, bytes = 0;
  const missing = [], placeholders = [];
  for (const entry of entries.values()) {
    // The CDN returns a zero-byte body for this manifest's empty-MD5 sentinel
    // (e.g. flower.swf). It is not a downloadable/valid SWF; report it separately.
    if (entry.hash === 'd41d8cd98f00b204e9800998ecf84200') { placeholders.push(entry); continue; }
    const file = path.join(CLIENT, entry.path);
    const stat = fs.existsSync(file) ? fs.statSync(file) : null;
    if (stat?.isFile() && stat.size > 0) { cached++; bytes += stat.size; }
    else missing.push(entry);
  }
  return { manifests, total: entries.size, cached, cachedBytes: bytes, placeholderCount: placeholders.length, placeholders, missingCount: missing.length, missing };
}
if (require.main === module) {
  const report = inventory({ only2d: process.argv.includes('--2d') });
  const at = process.argv.indexOf('--json');
  if (at >= 0) fs.writeFileSync(path.resolve(ROOT, process.argv[at + 1] || 'docs/asset-audit.json'), JSON.stringify(report, null, 2) + '\n');
  console.log(JSON.stringify({ ...report, missing: report.missing.slice(0, 12) }, null, 2));
}
module.exports = { inventory, parse, CLIENT, ROOT };
