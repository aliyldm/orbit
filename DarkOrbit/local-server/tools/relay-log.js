'use strict';
// relay-*.log dosyasını iki yönlü bayt akışına ve çerçevelere ayırır (analiz araçları için ortak).
const fs = require('fs');

function readStreams(file) {
  const text = fs.readFileSync(file, 'utf8');
  const streams = { 'C->S': [], 'S->C': [] };
  const events = []; // {dir, time, start, end} — akış içindeki bayt aralıkları
  let dir = null, time = null;
  for (const line of text.split('\n')) {
    const head = line.match(/^(\S+Z) (C->S|S->C) \d+ bytes/);
    if (head) { time = head[1]; dir = head[2]; events.push({ dir, time, start: streams[dir].length }); continue; }
    const row = line.match(/^[0-9a-f]{6}  ((?:[0-9a-f]{2} ?)+)/);
    if (row && dir) streams[dir].push(...row[1].trim().split(' ').map(h => parseInt(h, 16)));
  }
  return { 'C->S': Buffer.from(streams['C->S']), 'S->C': Buffer.from(streams['S->C']), events };
}

// firstLen4: ilk çerçeve 4 baytlık uzunluk kullanır (istemci->sunucu).
function splitFrames(buf, firstLen4) {
  const out = [];
  let off = 0, first = true;
  while (off < buf.length) {
    const lenBytes = first && firstLen4 ? 4 : 3;
    if (off + lenBytes > buf.length) break;
    const len = lenBytes === 4 ? buf.readUInt32BE(off) : buf.readUIntBE(off, 3);
    if (off + lenBytes + len > buf.length) break;
    out.push({ off, body: buf.subarray(off + lenBytes, off + lenBytes + len) });
    off += lenBytes + len;
    first = false;
  }
  return out;
}

const isDob3 = b => b.length >= 6 && b[0] === 0xff && b[1] === 0xff && b.toString('latin1', 2, 6) === 'DOB3';

module.exports = { readStreams, splitFrames, isDob3 };
