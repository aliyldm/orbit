'use strict';
// Uçtan uca senaryo istemcisi: web girişi (hesap oluşturma + portal şirket seçimi) -> oyun sayfasından
// flashvars -> oyun soketinde VersionRequest/LoginRequest -> bir NPC'ye saldırı.
// Kullanım: node tools/test-client.js [kullanıcı] [şifre] [fraksiyon=1] [saniye=8]

const net = require('net');
const path = require('path');
const config = require(path.join(__dirname, '..', 'config.json'));
const codec = require('../game/codec/codec');

const [user = `test${Date.now() % 100000}`, pass = 'testpass', faction = '1', secs = '8'] = process.argv.slice(2);
const base = `http://${config.http.host}:${config.http.port}`;

async function web() {
  let cookie = '';
  const req = async (p, body) => {
    const r = await fetch(base + p, {
      method: body ? 'POST' : 'GET', redirect: 'manual',
      headers: { cookie, ...(body ? { 'content-type': 'application/x-www-form-urlencoded' } : {}) },
      body: body ? new URLSearchParams(body) : undefined
    });
    const set = r.headers.get('set-cookie');
    if (set) cookie = set.split(';')[0];
    return r;
  };
  const login = await req('/login', { username: user, password: pass });
  console.log('login ->', login.status, login.headers.get('location'));
  if (/internalCompanyChoose/.test(login.headers.get('location') || '')) {
    const f = await req(`/indexInternal.es?action=internalCompanyChoose&subaction=factionChoose&factionID=${faction}`);
    console.log('şirket seçimi ->', f.status, f.headers.get('location'));
  }
  const html = await (await req('/indexInternal.es?action=internalMapRevolution')).text();
  const fv = new URLSearchParams(html.match(/name="flashvars" value="([^"]+)"/)[1].replace(/&amp;/g, '&'));
  return { userId: Number(fv.get('userID')), sessionId: fv.get('sessionID') };
}

function frame(obj, first) {
  const b = codec.encode(obj);
  const h = Buffer.alloc(first ? 4 : 3);
  first ? h.writeUInt32BE(b.length) : h.writeUIntBE(b.length, 0, 3);
  return Buffer.concat([h, b]);
}

function play({ userId, sessionId }, seconds) {
  return new Promise(resolve => {
    const s = net.connect(config.game.port, config.game.host);
    const seen = [];
    let buf = Buffer.alloc(0), target = null;
    s.on('connect', () => {
      s.write(frame({ _: 'VersionRequest', version: 'bd171f1aac49f58dde9ed1e00e539553' }, true));
      setTimeout(() => s.write(frame({ _: 'LoginRequest', userID: userId, factionID: 0, sessionID: sessionId, version: 'do-lz4-block-v3', instanceId: 502, isMiniClient: true })), 100);
    });
    s.on('data', d => {
      buf = Buffer.concat([buf, d]);
      let len;
      while (buf.length >= 3 && buf.length >= 3 + (len = buf.readUIntBE(0, 3))) {
        const { obj } = codec.decode(buf.subarray(3, 3 + len));
        buf = buf.subarray(3 + len);
        seen.push(obj);
        if (obj._ === 'ShipCreateCommand' && !target) {
          target = obj;
          setTimeout(() => {
            s.write(frame({ _: 'ShipSelectRequest', targetId: target.userId, targetX: target.x, targetY: target.y, posX: 0, posY: 0, clickX: 0, clickY: 0, radius: 50 }));
            s.write(frame({ _: 'AttackLaserRequest', targetId: target.userId, targetX: target.x, targetY: target.y }));
          }, 300);
        }
      }
    });
    s.on('close', () => resolve(seen));
    setTimeout(() => { s.destroy(); resolve(seen); }, seconds * 1000);
  });
}

async function main() {
  const auth = await web();
  console.log('oyun oturumu:', auth.userId, auth.sessionId.slice(0, 6) + '…');
  const seen = await play(auth, Number(secs));
  const pick = n => seen.filter(o => o._ === n);
  const ship = pick('ShipInitializationCommand')[0];
  console.log('gemi:', ship && JSON.stringify({ userName: ship.userName, typeId: ship.typeId, mapId: ship.mapId, x: ship.x, y: ship.y, hp: ship.hitPoints, shield: ship.shieldMax, speed: ship.speed, credits: ship.credits, factionId: ship.factionId }));
  console.log('NPC:', pick('ShipCreateCommand').map(o => o.userName).reduce((a, n) => (a[n] = (a[n] || 0) + 1, a), {}));
  for (const h of pick('AttackHitCommand').slice(0, 6)) console.log(`  vuruş ${h.attackerId} -> ${h.victimId} hasar ${h.damage} can ${h.victimHitpoints} kalkan ${h.victimShield}`);
  console.log('ölüm:', pick('ShipDestroyedCommand').length);

  const bad = await play({ userId: auth.userId, sessionId: 'x'.repeat(32) }, 2);
  console.log('geçersiz oturumla giriş:', bad.some(o => o._ === 'ShipInitializationCommand') ? 'KABUL EDİLDİ (hata)' : 'reddedildi');
}

module.exports = { web, play, frame, main };
if (require.main === module && !process.env.NODE_TEST_CONTEXT) main().catch(error => {
  console.error(error.message);
  process.exitCode = 1;
});
