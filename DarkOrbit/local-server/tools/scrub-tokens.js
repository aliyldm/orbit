'use strict';
// Kayıt ve şablonlarda URL-kodlu kalmış oturum/erişim belirteçlerini maskeler
// (ör. flashvars içindeki boardLink=...%3Ftoken%3D<değer>, supporturl=...authUser%3D..%26token%3D..).
// Kullanım: node tools/scrub-tokens.js <dosya|klasör> [...]

const fs = require('fs');
const path = require('path');

// anahtar + (= | %3D | %253D) + değer; değer harf/rakam/_-. dizisi.
const RE = /((?:token|authUser|sid|dosid|session|hash|auth|key|signature)(?:=|%3D|%253D))[A-Za-z0-9_\-.]+/gi;
const SAFE = /^(REDACTED|REDACTED_HEX|REDACTED_COOKIE|REDACTED_TOKEN)$/;

function scrub(text) {
  let n = 0;
  const out = text.replace(RE, (m, k) => {
    const v = m.slice(k.length);
    if (SAFE.test(v)) return m;
    n++;
    return k + 'REDACTED';
  });
  return { out, n };
}

function walk(p, files = []) {
  const st = fs.statSync(p);
  if (st.isDirectory()) for (const f of fs.readdirSync(p)) walk(path.join(p, f), files);
  else if (/\.(json|html|txt|log)$/i.test(p)) files.push(p);
  return files;
}

if (require.main === module) {
  let total = 0;
  for (const f of process.argv.slice(2).flatMap(a => walk(a))) {
    const s = fs.readFileSync(f, 'utf8');
    const { out, n } = scrub(s);
    if (n) { fs.writeFileSync(f, out); total += n; console.log(`${n}\t${f}`); }
  }
  console.log(`toplam maskelenen: ${total}`);
}

module.exports = { scrub };
