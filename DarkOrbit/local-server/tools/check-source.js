'use strict';
const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');
const root = path.resolve(__dirname, '..');
const files = ['server.js'];
function walk(dir) {
  for (const entry of fs.readdirSync(path.join(root, dir), { withFileTypes: true })) {
    const file = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(file);
    else if (/\.(js|mjs)$/.test(file)) files.push(file);
  }
}
for (const dir of ['game', 'web', 'tools', 'tests', 'client/resources/js']) if (fs.existsSync(path.join(root, dir))) walk(dir);
let failed = 0;
for (const file of files) {
  const result = spawnSync(process.execPath, ['--check', path.join(root, file)], { encoding: 'utf8' });
  if (result.status !== 0) { failed++; console.error(file, result.stderr); }
}
console.log(`${files.length} JavaScript files, ${failed} syntax errors`);
process.exitCode = failed ? 1 : 0;
