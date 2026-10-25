'use strict';
// Protokol öğrenme aracı: canlı oyun soketini gözlemlemek için şeffaf TCP aktarıcısı.
// Launcher'da oyun sunucusu adları 127.0.0.1'e eşlenir (--host-resolver-rules);
// bu araç aynı portları dinler, trafiği gerçek sunucuya iletir ve iki yönü de
// logs/relay-<port>-<n>.log dosyasına hex olarak yazar. İletilen veri değişmez.
//
// Maskeleme: yalnızca giriş paketindeki (ID 7) oturum anahtarı, tam eşleşmeyle ve yalnızca
// logda "*" ile değiştirilir. Diğer içerik (isimler, sıkıştırılmış bloklar) olduğu gibi kalır;
// böylece kayıt sonradan bozulmadan çözülebilir.
//
// Kullanım: node tools/relay.js gameserver-502-01-public.prod.darkorbit.com:6101 [host:port ...]

const net = require('net');
const dns = require('dns');
const fs = require('fs');
const path = require('path');

const logDir = path.join(__dirname, '..', 'logs');
fs.mkdirSync(logDir, { recursive: true });

const LOGIN_ID = 7;

function hexdump(buf) {
  const lines = [];
  for (let i = 0; i < buf.length; i += 16) {
    const chunk = buf.subarray(i, i + 16);
    const hex = [...chunk].map(b => b.toString(16).padStart(2, '0')).join(' ');
    const ascii = [...chunk].map(b => (b >= 0x20 && b < 0x7f ? String.fromCharCode(b) : '.')).join('');
    lines.push(`${i.toString(16).padStart(6, '0')}  ${hex.padEnd(47)}  ${ascii}`);
  }
  return lines.join('\n');
}

// Bir bağlantının gizli değerlerini tutar ve log kopyasında maskeler.
function createMasker() {
  const secrets = [];
  return {
    add(buf) { if (buf.length >= 8) secrets.push(buf); },
    apply(buf) {
      const out = Buffer.from(buf);
      for (const s of secrets) {
        let i = out.indexOf(s);
        while (i !== -1) { out.fill(0x2a, i, i + s.length); i = out.indexOf(s, i + s.length); }
      }
      return out;
    }
  };
}

// İstemci akışını çerçeveler (ilk paket uint32, sonrakiler uint24 uzunluk) ve giriş
// paketinden oturum anahtarını çıkarır: [id=7][int][uint16][string oturum]...
function createLoginSniffer(masker) {
  let pending = Buffer.alloc(0);
  let first = true;
  let done = false;
  return chunk => {
    if (done) return;
    pending = Buffer.concat([pending, chunk]);
    for (;;) {
      const lenBytes = first ? 4 : 3;
      if (pending.length < lenBytes) return;
      const len = lenBytes === 4 ? pending.readUInt32BE(0) : pending.readUIntBE(0, 3);
      if (pending.length < lenBytes + len) return;
      const body = pending.subarray(lenBytes, lenBytes + len);
      pending = pending.subarray(lenBytes + len);
      first = false;
      if (body.length >= 10 && body.readUInt16BE(0) === LOGIN_ID) {
        const strLen = body.readUInt16BE(8);
        masker.add(Buffer.from(body.subarray(10, 10 + strLen)));
        done = true;
        return;
      }
    }
  };
}

let connCount = 0;

function startRelay(target) {
  const [host, portStr] = target.split(':');
  const port = Number(portStr);
  net.createServer(client => {
    const id = ++connCount;
    const logFile = path.join(logDir, `relay-${port}-${id}.log`);
    const masker = createMasker();
    const sniff = createLoginSniffer(masker);
    const log = (dir, buf) => fs.appendFileSync(logFile, `\n${new Date().toISOString()} ${dir} ${buf.length} bytes\n${hexdump(masker.apply(buf))}\n`);
    // Gerçek adresi sistem DNS'i ile çöz (launcher'daki eşleme bunu etkilemez).
    dns.lookup(host, { family: 4 }, (err, address) => {
      if (err) { console.error(`[relay] ${host} çözülemedi: ${err.message}`); client.destroy(); return; }
      const upstream = net.connect(port, address, () => console.log(`[relay] #${id} ${host}:${port} (${address}) bağlandı -> ${logFile}`));
      client.on('data', d => { sniff(d); log('C->S', d); upstream.write(d); });
      upstream.on('data', d => { log('S->C', d); client.write(d); });
      const close = () => { client.destroy(); upstream.destroy(); };
      client.on('close', close); upstream.on('close', close);
      client.on('error', close); upstream.on('error', e => { console.warn(`[relay] #${id} upstream: ${e.message}`); close(); });
    });
  }).listen(port, '127.0.0.1', () => console.log(`[relay] 127.0.0.1:${port} -> ${host}:${port}`));
}

module.exports = { createMasker, createLoginSniffer };

if (require.main === module) {
  const targets = process.argv.slice(2);
  if (!targets.length) {
    console.error('kullanım: node tools/relay.js host:port [host:port ...]');
    process.exit(1);
  }
  targets.forEach(startRelay);
}
