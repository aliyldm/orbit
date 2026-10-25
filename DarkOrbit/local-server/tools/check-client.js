'use strict';
// Reproducible verification of the previously analysed launcher/Flash patches.
// This tool never modifies executable files or launches them.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const root = path.resolve(__dirname, '..', '..');
const expected = {
  'DarkOrbit.exe': 'c411adf3089a40fbef39cca360683673312340e29651df933b6039293dbcb9b4',
  'HCSFP32.dll': 'ea298dc33d3de089709475d3dd63128ac0a334fdd6ff1e172e22b392da007f73'
};
let failed = false;
for (const [name, sha] of Object.entries(expected)) {
  const original = fs.readFileSync(path.join(root, name + '.orig'));
  const current = fs.readFileSync(path.join(root, name));
  const actual = crypto.createHash('sha256').update(original).digest('hex');
  const proposed = Buffer.from(original);
  if (name === 'DarkOrbit.exe') {
    const oldURL = Buffer.from('https://darkorbit.com');
    const newURL = Buffer.from('http://127.0.0.1:8095');
    const marker = original.indexOf(Buffer.from('<GameURL>https://darkorbit.com</GameURL>'));
    if (marker < 0 || oldURL.length !== newURL.length) throw new Error('Launcher patch context differs');
    newURL.copy(proposed, marker + Buffer.byteLength('<GameURL>'));
  } else {
    if (original[0x68e0e] !== 0x75) throw new Error('Flash patch context differs');
    proposed[0x68e0e] = 0xeb;
  }
  const ok = sha === actual && proposed.equals(current);
  failed ||= !ok;
  console.log(`${ok ? 'OK' : 'FAIL'} ${name}: original identity + exact expected patch`);
}
for (const relative of ['client/spacemap/preloader.swf', 'client/spacemap/main.swf']) {
  const exists = fs.existsSync(path.resolve(__dirname, '..', relative));
  console.log(`${exists ? 'OK' : 'FAIL'} ${relative}`);
  failed ||= !exists;
}
process.exitCode = failed ? 1 : 0;
