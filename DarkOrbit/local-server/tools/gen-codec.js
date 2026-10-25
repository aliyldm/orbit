'use strict';
// JPEXS ile decompile edilmiş istemci paket sınıflarından (com/module/*.as) protokol şeması üretir.
// Her sınıfın getLibcomModuleId() değeri ve read() metodundaki alan sırası/dönüşümleri
// game/codec/schema.json dosyasına yazılır. game/codec/codec.js bu şemayla paketleri çözer/üretir.
// Verilen kök altında getLibcomModuleId() tanımlayan tüm .as dosyaları taranır (alt klasörler dahil).
// Kullanım: node tools/gen-codec.js <decompiled/main/scripts>

const fs = require('fs');
const path = require('path');

const dir = process.argv[2];

function walk(d, out = []) {
  for (const e of fs.readdirSync(d, { withFileTypes: true })) {
    const p = path.join(d, e.name);
    if (e.isDirectory()) walk(p, out);
    else if (e.name.endsWith('.as')) out.push(p);
  }
  return out;
}
const files = walk(dir).filter(p => /function getLibcomModuleId\(\) : int/.test(fs.readFileSync(p, 'utf8')));

const READ_TYPES = { readInt: 'int', readShort: 'short', readByte: 'byte', readBoolean: 'bool', readUTF: 'utf', readDouble: 'double', readFloat: 'float' };

function readBody(src) {
  const start = src.search(/public function read\(param1:IDataInput\)/);
  if (start < 0) return null;
  const open = src.indexOf('{', start);
  let depth = 0;
  for (let i = open; i < src.length; i++) {
    if (src[i] === '{') depth++;
    else if (src[i] === '}' && --depth === 0) return src.slice(open + 1, i);
  }
  return null;
}

// Dönüşüm satırı: [rotasyon yönü, miktar, bit genişliği] veya işaret düzeltmesi.
function parseTransform(line, v) {
  const e = v.replace(/[.$]/g, '\\$&');
  let m;
  if ((m = line.match(new RegExp(`^${e} = ${e} << (\\d+) % 32 \\| ${e} >>> 32 - \\d+ % 32;$`)))) return { rot: 'l', n: +m[1], w: 32 };
  if ((m = line.match(new RegExp(`^${e} = ${e} >>> (\\d+) % 32 \\| ${e} << 32 - \\d+ % 32;$`)))) return { rot: 'r', n: +m[1], w: 32 };
  if ((m = line.match(new RegExp(`^${e} = 0xFFFF & \\(\\(0xFFFF & ${e}\\) << (\\d+) % 16`)))) return { rot: 'l', n: +m[1], w: 16 };
  if ((m = line.match(new RegExp(`^${e} = 0xFFFF & \\(\\(0xFFFF & ${e}\\) >>> (\\d+) % 16`)))) return { rot: 'r', n: +m[1], w: 16 };
  if ((m = line.match(new RegExp(`^${e} = 0xFF & \\(\\(0xFF & ${e}\\) << (\\d+) % 8`)))) return { rot: 'l', n: +m[1], w: 8 };
  if ((m = line.match(new RegExp(`^${e} = 0xFF & \\(\\(0xFF & ${e}\\) >>> (\\d+) % 8`)))) return { rot: 'r', n: +m[1], w: 8 };
  if (line.match(new RegExp(`^${e} = ${e} > 32767 \\? int\\(${e} - 65536\\) : ${e};$`))) return { sign: 16 };
  if (line.match(new RegExp(`^${e} = ${e} > 127 \\? int\\(${e} - 256\\) : ${e};$`))) return { sign: 8 };
  return null;
}

function parseClass(name, src) {
  const idM = src.match(/getLibcomModuleId\(\) : int\s*\{\s*return (-?\d+);/);
  const extM = src.match(/public class \w+ extends (\w+)/);
  const body = readBody(src);
  const cls = { name, id: idM ? +idM[1] : null, parent: extM ? extM[1] : null, fields: [], unparsed: [] };
  if (body === null) return cls;

  const lines = body.split('\n').map(l => l.trim()).filter(l => l && l !== '{' && l !== '}' && !/^var _loc\d+_:/.test(l));
  const locals = {}; // _locN_ -> {kind, ...}
  let loop = null;   // açık while döngüsü: {lenVar, field, elem}

  for (let i = 0; i < lines.length; i++) {
    const l = lines[i];
    let m;
    if (l === 'param1.readShort();') { cls.fields.push({ type: 'skipShort' }); continue; }
    if (l === 'super.read(param1);') { cls.fields.push({ type: 'super', cls: cls.parent }); continue; }
    if (/^_loc\d+_ = 0;$/.test(l) || /^_loc\d+_\+\+;$/.test(l)) continue;
    if (/^while\(this\.\w+\.length > 0\)$/.test(l)) { i++; continue; } // vektörü temizleme: sonraki satır pop()
    if (/^this\.\w+\.pop\(\);$/.test(l)) continue;
    if (/^if\(null != (this\.\w+|_loc\d+_)\)$/.test(l)) continue;
    if (/^(this\.\w+|_loc\d+_)\.read\(param1\);$/.test(l)) continue;

    // tek alt modül
    if ((m = l.match(/^this\.(\w+) = (\w+)\(ModuleFactory\.get\(\)\.createInstance\(param1\.readShort\(\)\)\);$/))) {
      cls.fields.push({ name: m[1], type: 'module', cls: m[2] }); continue;
    }
    // ilkel alan
    if ((m = l.match(/^this\.(\w+) = param1\.(read\w+)\(\);$/)) && READ_TYPES[m[2]]) {
      cls.fields.push({ name: m[1], type: READ_TYPES[m[2]] }); continue;
    }
    // alan dönüşümü
    if ((m = l.match(/^(this\.\w+) = /))) {
      const t = parseTransform(l, m[1]);
      const last = cls.fields[cls.fields.length - 1];
      if (t && last && last.name === m[1].slice(5)) { (last.tx = last.tx || []).push(t); continue; }
    }
    // döngü uzunluğu
    if ((m = l.match(/^(_loc\d+_) = param1\.(read\w+)\(\);$/)) && READ_TYPES[m[2]] && !loop) {
      locals[m[1]] = { lenType: READ_TYPES[m[2]], tx: [] }; continue;
    }
    if ((m = l.match(/^(_loc\d+_) = /)) && locals[m[1]] && !loop) {
      const t = parseTransform(l, m[1]);
      if (t) { locals[m[1]].tx.push(t); continue; }
    }
    if ((m = l.match(/^while\(_loc\d+_ < (_loc\d+_)\)$/)) && locals[m[1]]) {
      loop = { len: locals[m[1]], elem: null, elemVar: null }; continue;
    }
    if (loop) {
      if ((m = l.match(/^(_loc\d+_) = (\w+)\(ModuleFactory\.get\(\)\.createInstance\(param1\.readShort\(\)\)\);$/))) { loop.elem = { type: 'module', cls: m[2] }; loop.elemVar = m[1]; continue; }
      if ((m = l.match(/^(_loc\d+_) = param1\.(read\w+)\(\);$/)) && READ_TYPES[m[2]]) { loop.elem = { type: READ_TYPES[m[2]] }; loop.elemVar = m[1]; continue; }
      if (loop.elemVar && (m = l.match(/^(_loc\d+_) = /)) && m[1] === loop.elemVar) {
        const t = parseTransform(l, m[1]);
        if (t) { (loop.elem.tx = loop.elem.tx || []).push(t); continue; }
      }
      if ((m = l.match(/^this\.(\w+)\.push\((_loc\d+_)\);$/)) && m[2] === loop.elemVar) {
        cls.fields.push({ name: m[1], type: 'vector', lenType: loop.len.lenType, lenTx: loop.len.tx, elem: loop.elem }); loop = null; continue;
      }
      if ((m = l.match(/^this\.(\w+)\.push\(param1\.(read\w+)\(\)\);$/)) && READ_TYPES[m[2]]) {
        cls.fields.push({ name: m[1], type: 'vector', lenType: loop.len.lenType, lenTx: loop.len.tx, elem: { type: READ_TYPES[m[2]] } }); loop = null; continue;
      }
    }
    cls.unparsed.push(l);
  }
  return cls;
}

const classes = {};
const nameClash = [];
for (const p of files) {
  const name = path.basename(p, '.as');
  if (classes[name]) nameClash.push(name);
  classes[name] = parseClass(name, fs.readFileSync(p, 'utf8'));
}
if (nameClash.length) console.log('aynı adlı sınıflar (sonuncusu kullanıldı):', nameClash.slice(0, 10));

const byId = {};
for (const c of Object.values(classes)) if (c.id !== null) (byId[c.id] = byId[c.id] || []).push(c.name);
const dupes = Object.entries(byId).filter(([, v]) => v.length > 1);
const withUnparsed = Object.values(classes).filter(c => c.unparsed.length);

const dest = path.join(__dirname, '..', 'game', 'codec', 'schema.json');
fs.mkdirSync(path.dirname(dest), { recursive: true });
fs.writeFileSync(dest, JSON.stringify({ _source: 'JPEXS decompile of spacemap/main.swf', classes }, null, 1));

console.log(`${Object.keys(classes).length} sınıf, ${Object.keys(byId).length} ID; çakışan ID: ${dupes.length}; çözülemeyen satırı olan sınıf: ${withUnparsed.length}`);
if (dupes.length) console.log('çakışmalar:', dupes.slice(0, 5));
for (const c of withUnparsed.slice(0, 8)) console.log(`  ${c.name}:`, c.unparsed.slice(0, 3));
console.log(`-> ${dest}`);
