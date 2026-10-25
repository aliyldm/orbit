'use strict';
// Çözülmüş oturumu (logs/session-*.json) şema ile adlandırılmış komutlara çevirir.
// Kullanım: node tools/dump-session.js logs/session-6101-1.json [--from N] [--to N] [--only Sınıf1,Sınıf2] [--json]

const fs = require('fs');
const { decode } = require('../game/codec/codec');

const args = process.argv.slice(2);
const opt = k => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : null; };
const from = Number(opt('--from') ?? 0), to = Number(opt('--to') ?? Infinity);
const only = opt('--only') ? new Set(opt('--only').split(',')) : null;
const asJson = args.includes('--json');

const packets = JSON.parse(fs.readFileSync(args[0], 'utf8')).filter(p => p.hex && p.seq >= from && p.seq < to);
const out = [];
for (const p of packets) {
  const { obj } = decode(Buffer.from(p.hex, 'hex'));
  if (only && !only.has(obj && obj._)) continue;
  out.push({ seq: p.seq, time: p.time, dir: p.dir, cmd: obj });
}

if (asJson) { console.log(JSON.stringify(out, null, 1)); process.exit(0); }
const short = v => JSON.stringify(v, (k, x) => (k === '_' ? undefined : x)).slice(0, 160);
for (const e of out) console.log(`${String(e.seq).padStart(5)} ${e.time.slice(11, 23)} ${e.dir} ${(e.cmd && e.cmd._) || 'null'} ${short(e.cmd)}`);
