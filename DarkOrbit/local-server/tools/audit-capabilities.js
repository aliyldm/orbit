'use strict';
// Registration means a handler exists; it does not certify complete game behavior.
const fs = require('node:fs');
const path = require('node:path');
const codec = require('../game/codec/codec');
const { registeredCommands } = require('../game/protocol');
const { inventory, ROOT } = require('./asset-manifest');
function audit() {
  const registered = registeredCommands(), implemented = new Set(registered), observed = new Map();
  const evidence = [], failures = [];
  for (const file of fs.readdirSync(path.join(ROOT, 'logs')).filter(f => /^session-.*\.json$/.test(f)).sort()) {
    const packets = JSON.parse(fs.readFileSync(path.join(ROOT, 'logs', file), 'utf8'));
    let count = 0;
    for (const packet of packets) if (packet.dir === 'C->S') {
      count++;
      try {
        const { obj, rest } = codec.decode(Buffer.from(packet.hex, 'hex'));
        if (rest) throw new Error('Trailing bytes');
        observed.set(obj._, (observed.get(obj._) || 0) + 1);
      } catch (error) { failures.push({ file, seq: packet.seq, error: error.message }); }
    }
    if (count) evidence.push({ file, clientPackets: count });
  }
  const assets = inventory();
  return { generatedAt: new Date().toISOString(), evidence, registeredCount: registered.length, registered,
    observedCount: observed.size, observed: Object.fromEntries([...observed].sort()),
    observedUnhandled: Object.fromEntries([...observed].filter(([name]) => !implemented.has(name)).sort()),
    decodeFailures: failures, assets: { ...assets, missing: undefined },
    limits: ['Handler registration is not feature completeness.', 'Resource manifests do not list every portal image or dynamically loaded file.',
      'An existing asset is counted by presence and size; CDN hash values are not assumed to be file checksums.'] };
}
if (require.main === module) {
  const report = audit();
  const at = process.argv.indexOf('--json');
  if (at >= 0) fs.writeFileSync(path.resolve(ROOT, process.argv[at + 1] || 'docs/capability-audit.json'), JSON.stringify(report, null, 2) + '\n');
  console.log(JSON.stringify(report, null, 2));
  if (report.decodeFailures.length) process.exitCode = 1;
}
module.exports = { audit };
