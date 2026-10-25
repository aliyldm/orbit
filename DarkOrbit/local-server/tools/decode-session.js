'use strict';
// relay-*.log -> zaman sıralı, açılmış paket listesi (logs/session-<port>.json).
// DOB3 kapları açılır ve içlerindeki paketler ayrı ayrı listelenir.
// Kullanım: node tools/decode-session.js logs/relay-6101-1.log [--print N]

const fs = require('fs');
const path = require('path');
const { readStreams, splitFrames, isDob3 } = require('./relay-log');
const { decompressBlock } = require('../game/lz4');

const file = process.argv[2];
const printN = process.argv.includes('--print') ? Number(process.argv[process.argv.indexOf('--print') + 1]) : 0;
const s = readStreams(file);

function eventFor(dir, off) {
  let ev = null;
  for (const e of s.events) if (e.dir === dir && e.start <= off) ev = e;
  return ev;
}

function innerFrames(buf) {
  const out = [];
  let off = 0;
  while (off + 3 <= buf.length) {
    const len = buf.readUIntBE(off, 3);
    if (off + 3 + len > buf.length) break;
    out.push(buf.subarray(off + 3, off + 3 + len));
    off += 3 + len;
  }
  return out;
}

const packets = [];
for (const [dir, firstLen4] of [['C->S', true], ['S->C', false]]) {
  for (const f of splitFrames(s[dir], firstLen4)) {
    const ev = eventFor(dir, f.off);
    const order = s.events.indexOf(ev);
    const push = (body, container) => packets.push({
      order, time: ev.time, dir, container,
      id: body.length >= 2 ? body.readUInt16BE(0) : -1,
      len: body.length, hex: body.toString('hex')
    });
    if (dir === 'S->C' && isDob3(f.body)) {
      try {
        const out = decompressBlock(f.body.subarray(14), f.body.readUInt32BE(6));
        innerFrames(out).forEach(b => push(b, 'DOB3'));
      } catch (e) {
        packets.push({ order, time: ev.time, dir, container: 'DOB3-ERROR', error: e.message, len: f.body.length });
      }
    } else push(f.body, null);
  }
}
packets.sort((a, b) => a.order - b.order);
packets.forEach((p, i) => { p.seq = i; });

const out = path.join(path.dirname(file), `session-${path.basename(file, '.log').replace('relay-', '')}.json`);
fs.writeFileSync(out, JSON.stringify(packets, null, 1));
console.log(`${packets.length} paket -> ${out}`);
console.log(`S->C: ${packets.filter(p => p.dir === 'S->C').length}, C->S: ${packets.filter(p => p.dir === 'C->S').length}, açılamayan kap: ${packets.filter(p => p.container === 'DOB3-ERROR').length}`);

for (const p of packets.slice(0, printN)) {
  if (p.error) { console.log(`${String(p.seq).padStart(4)} ${p.dir} HATA ${p.error}`); continue; }
  const b = Buffer.from(p.hex, 'hex');
  const ascii = b.toString('latin1').replace(/[^\x20-\x7e]/g, '.').slice(2, 60);
  console.log(`${String(p.seq).padStart(4)} ${p.time.slice(11, 23)} ${p.dir} ${p.container ? 'z' : ' '} id=${String(p.id).padStart(5)} 0x${p.id.toString(16).padStart(4, '0')} len=${String(p.len).padStart(5)}  ${b.subarray(2, 18).toString('hex')}  ${ascii}`);
}
