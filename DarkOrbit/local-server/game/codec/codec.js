'use strict';
// schema.json (tools/gen-codec.js ile istemci kodundan üretilir) kullanarak paket gövdelerini
// adlandırılmış nesnelere çözer ve nesnelerden gövde üretir.
// Gövde: [int16 modül ID][alanlar...]. read() tarafındaki dönüşümler çözerken uygulanır,
// yazarken tersleri uygulanır.

const fs = require('fs');
const path = require('path');

const schema = JSON.parse(fs.readFileSync(path.join(__dirname, 'schema.json'), 'utf8')).classes;
const byId = new Map();
for (const c of Object.values(schema)) if (c.id !== null) byId.set(c.id, c);

function rot(v, dir, n, w) {
  n %= w;
  if (w === 32) return dir === 'l' ? ((v << n) | (v >>> (32 - n))) | 0 : ((v >>> n) | (v << (32 - n))) | 0;
  const mask = w === 16 ? 0xffff : 0xff;
  v &= mask;
  return (dir === 'l' ? ((v << n) | (v >>> (w - n))) : ((v >>> n) | (v << (w - n)))) & mask;
}

function applyTx(v, tx = []) {
  for (const t of tx) {
    if (t.rot) v = rot(v, t.rot, t.n, t.w);
    else if (t.sign === 16) v = v > 32767 ? v - 65536 : v;
    else if (t.sign === 8) v = v > 127 ? v - 256 : v;
  }
  return v;
}

function invertTx(v, tx = []) {
  for (const t of [...tx].reverse()) {
    if (t.rot) v = rot(v, t.rot === 'l' ? 'r' : 'l', t.n, t.w);
    else if (t.sign === 16) v &= 0xffff;
    else if (t.sign === 8) v &= 0xff;
  }
  return v;
}

class Reader {
  constructor(buf) { this.buf = buf; this.off = 0; this.depth = 0; }
  need(n) { if (!Number.isSafeInteger(n) || n < 0 || this.off + n > this.buf.length) throw new RangeError('Truncated protocol field'); }
  int() { this.need(4); const v = this.buf.readInt32BE(this.off); this.off += 4; return v; }
  short() { this.need(2); const v = this.buf.readUInt16BE(this.off); this.off += 2; return v; }
  byte() { this.need(1); return this.buf.readUInt8(this.off++); }
  bool() { return this.byte() !== 0; }
  double() { this.need(8); const v = this.buf.readDoubleBE(this.off); this.off += 8; return v; }
  float() { this.need(4); const v = this.buf.readFloatBE(this.off); this.off += 4; return v; }
  utf() { const n = this.short(); this.need(n); const s = this.buf.toString('utf8', this.off, this.off + n); this.off += n; return s; }
}

// AS3 readShort/readByte işaretli döner; ham değer üzerine dönüşümler uygulanır.
function readPrim(r, type) {
  switch (type) {
    case 'int': return r.int();
    case 'short': { const v = r.short(); return v > 32767 ? v - 65536 : v; }
    case 'byte': { const v = r.byte(); return v > 127 ? v - 256 : v; }
    case 'bool': return r.bool();
    case 'double': return r.double();
    case 'float': return r.float();
    case 'utf': return r.utf();
  }
  throw new Error(`bilinmeyen tip ${type}`);
}

function readFields(r, cls, out) {
  for (const f of cls.fields) {
    if (f.type === 'skipShort') { r.short(); continue; }
    if (f.type === 'super') { readFields(r, schema[f.cls], out); continue; }
    if (f.type === 'module') { out[f.name] = readModule(r); continue; }
    if (f.type === 'vector') {
      const len = applyTx(readPrim(r, f.lenType), f.lenTx);
      if (!Number.isSafeInteger(len) || len < 0 || len > 65536 || len > r.buf.length - r.off) throw new RangeError('Invalid protocol vector length');
      const arr = [];
      for (let i = 0; i < len; i++) arr.push(f.elem.type === 'module' ? readModule(r) : applyTx(readPrim(r, f.elem.type), f.elem.tx));
      out[f.name] = arr;
      continue;
    }
    out[f.name] = applyTx(readPrim(r, f.type), f.tx);
  }
}

function readModule(r) {
  if (++r.depth > 64) throw new RangeError('Protocol nesting limit');
  try {
  let id = r.short();
  if (id > 32767) id -= 65536; // modül ID'leri işaretli short
  if (id === 0) return null; // ModuleFactory boş modül
  const cls = byId.get(id);
  if (!cls) throw new Error(`bilinmeyen modül ID ${id}`);
  const out = { _: cls.name };
  readFields(r, cls, out);
  return out;
  } finally { r.depth--; }
}

// Bir paket gövdesini çözer; kalan bayt sayısını da döndürür (doğrulama için).
function decode(body) {
  const r = new Reader(body);
  const obj = readModule(r);
  return { obj, rest: body.length - r.off };
}

class Writer {
  constructor() { this.parts = []; }
  push(b) { this.parts.push(b); }
  int(v) { const b = Buffer.alloc(4); b.writeInt32BE(v | 0); this.push(b); }
  short(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); this.push(b); }
  byte(v) { this.push(Buffer.from([v & 0xff])); }
  bool(v) { this.push(Buffer.from([v ? 1 : 0])); }
  double(v) { const b = Buffer.alloc(8); b.writeDoubleBE(v); this.push(b); }
  float(v) { const b = Buffer.alloc(4); b.writeFloatBE(v); this.push(b); }
  utf(s) { const b = Buffer.from(s || '', 'utf8'); if (b.length > 65535) throw new RangeError('Protocol string too long'); this.short(b.length); this.push(b); }
  done() { return Buffer.concat(this.parts); }
}

function writePrim(w, type, v) {
  switch (type) {
    case 'int': return w.int(v);
    case 'short': return w.short(v);
    case 'byte': return w.byte(v);
    case 'bool': return w.bool(v);
    case 'double': return w.double(v);
    case 'float': return w.float(v);
    case 'utf': return w.utf(v);
  }
  throw new Error(`bilinmeyen tip ${type}`);
}

function writeFields(w, cls, obj) {
  for (const f of cls.fields) {
    if (f.type === 'skipShort') { w.short(schema[cls.parent].id); continue; }
    if (f.type === 'super') { writeFields(w, schema[f.cls], obj); continue; }
    if (f.type === 'module') { writeModule(w, obj[f.name]); continue; }
    if (f.type === 'vector') {
      const arr = obj[f.name] || [];
      writePrim(w, f.lenType, invertTx(arr.length, f.lenTx));
      for (const v of arr) f.elem.type === 'module' ? writeModule(w, v) : writePrim(w, f.elem.type, invertTx(v, f.elem.tx));
      continue;
    }
    const v = obj[f.name] ?? (f.type === 'utf' ? '' : f.type === 'bool' ? false : 0);
    writePrim(w, f.type, ['int', 'short', 'byte'].includes(f.type) ? invertTx(v, f.tx) : v);
  }
}

function writeModule(w, obj) {
  if (!obj) { w.short(0); return; }
  const cls = schema[obj._];
  if (!cls) throw new Error(`bilinmeyen sınıf ${obj._}`);
  w.short(cls.id);
  writeFields(w, cls, obj);
}

// { _: 'SınıfAdı', alan: değer, ... } -> paket gövdesi
function encode(obj) {
  const w = new Writer();
  writeModule(w, obj);
  return w.done();
}

module.exports = { schema, byId, decode, encode };
