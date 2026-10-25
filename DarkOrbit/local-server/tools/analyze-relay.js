'use strict';
// relay-*.log dosyasından iki yönlü bayt akışını yeniden kurar ve çerçeve hipotezini sınar:
//   istemci->sunucu: ilk paket 4 bayt uzunluk, sonrakiler 3 bayt uzunluk
//   sunucu->istemci: 3 bayt uzunluk
// Her çerçevenin ilk 2 baytı paket ID'si kabul edilir; "DOB3" imzalı gövdeler ayrıca sayılır.
// Kullanım: node tools/analyze-relay.js logs/relay-6101-1.log

const fs = require('fs');

const text = fs.readFileSync(process.argv[2], 'utf8');
const streams = { 'C->S': [], 'S->C': [] };
let dir = null;
for (const line of text.split('\n')) {
  const head = line.match(/^\S+Z (C->S|S->C) \d+ bytes/);
  if (head) { dir = head[1]; continue; }
  const row = line.match(/^[0-9a-f]{6}  ((?:[0-9a-f]{2} ?)+)/);
  if (row && dir) streams[dir].push(...row[1].trim().split(' ').map(h => parseInt(h, 16)));
}

function frames(bytes, firstLen4) {
  const buf = Buffer.from(bytes);
  const out = [];
  let off = 0, first = true;
  while (off < buf.length) {
    const lenBytes = first && firstLen4 ? 4 : 3;
    if (off + lenBytes > buf.length) break;
    const len = lenBytes === 4 ? buf.readUInt32BE(off) : buf.readUIntBE(off, 3);
    if (off + lenBytes + len > buf.length) { out.push({ truncated: true, off, len }); break; }
    const body = buf.subarray(off + lenBytes, off + lenBytes + len);
    out.push({ off, len, body });
    off += lenBytes + len;
    first = false;
  }
  return { out, consumed: off, total: buf.length };
}

for (const [d, firstLen4] of [['C->S', true], ['S->C', false]]) {
  const r = frames(streams[d], firstLen4);
  const ids = new Map();
  let dob3 = 0;
  for (const f of r.out) {
    if (!f.body) continue;
    if (f.body.length >= 6 && f.body.readUInt16BE(0) === 0xffff && f.body.toString('latin1', 2, 6) === 'DOB3') { dob3++; continue; }
    const id = f.body.length >= 2 ? f.body.readUInt16BE(0) : -1;
    ids.set(id, (ids.get(id) || 0) + 1);
  }
  console.log(`\n== ${d}: ${r.total} bayt, ${r.out.length} çerçeve, ${r.consumed} bayt hizalandı${r.out.some(f => f.truncated) ? ' (son çerçeve eksik)' : ''}`);
  console.log(`   DOB3 sıkıştırılmış çerçeve: ${dob3}`);
  console.log('   paket ID sıklığı (ilk 25):', [...ids.entries()].sort((a, b) => b[1] - a[1]).slice(0, 25)
    .map(([id, n]) => `${id}(0x${id.toString(16)})x${n}`).join(' '));
  console.log('   ilk 8 çerçeve:', r.out.slice(0, 8).map(f => f.body ? `len=${f.len} id=0x${f.body.readUInt16BE(0).toString(16)}` : 'eksik').join(' | '));
}
