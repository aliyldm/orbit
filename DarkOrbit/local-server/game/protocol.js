'use strict';
// Oyun soketi protokolü. Çerçeve yapısı canlı oturum kaydından doğrulandı
// (tools/analyze-relay.js: iki yön de son bayta kadar hizalanıyor):
//   istemci->sunucu: ilk paket [uint32 BE uzunluk], sonrakiler [uint24 BE uzunluk]
//   sunucu->istemci: [uint24 BE uzunluk]
//   gövde: [uint16 BE paket ID][alanlar...]; dizeler [uint16 BE uzunluk][UTF-8]
// Sunucu girişten sonra gövdeleri "\xff\xffDOB3" imzalı LZ4 bloklarıyla gönderebilir
// (istemci girişte "do-lz4-block-v3" talep ediyor); henüz uygulanmadı.

const { buildInit } = require('./init');
const codec = require('./codec/codec');
const { frameBody, sendCmd } = require('./net');
const Combat = require('./combat');
const auth = require('./auth');

const handlers = new Map();
const handlerNames = new Map();
const MAX_FRAME = 1024 * 1024;

const ID = {
  VERSION_REQUEST: 666,  // 0x029a: [string sürüm hash'i]
  VERSION_RESPONSE: 667, // 0x029b: [string sürüm hash'i][bool uygun]
  LOGIN_REQUEST: 7       // 0x0007: [int][string oturum][string sıkıştırma]...
};

// session.firstFrameRead: ilk istemci paketinin 4 baytlık uzunluk önekini ayırt eder.
function readFrame(buf, session) {
  const lenBytes = session.firstFrameRead ? 3 : 4;
  if (buf.length < lenBytes) return null;
  const len = lenBytes === 4 ? buf.readUInt32BE(0) : buf.readUIntBE(0, 3);
  if (len < 2 || len > MAX_FRAME) throw new RangeError('Geçersiz oyun çerçevesi uzunluğu');
  if (buf.length < lenBytes + len) return null;
  session.firstFrameRead = true;
  const body = buf.subarray(lenBytes, lenBytes + len);
  const packet = {
    id: body.readInt16BE(0),
    payload: body.subarray(2),
    raw: body
  };
  return { packet, consumed: lenBytes + len };
}

function writeFrame(id, payload = Buffer.alloc(0)) {
  const len = 2 + payload.length;
  const out = Buffer.alloc(3 + len);
  out.writeUIntBE(len, 0, 3);
  out.writeUInt16BE(id & 0xffff, 3);
  payload.copy(out, 5);
  return out;
}


// Basit alan okuyucu/yazıcı.
class Reader {
  constructor(buf) { this.buf = buf; this.off = 0; }
  u8() { return this.buf.readUInt8(this.off++); }
  bool() { return this.u8() !== 0; }
  i32() { const v = this.buf.readInt32BE(this.off); this.off += 4; return v; }
  str() { const n = this.buf.readUInt16BE(this.off); this.off += 2; const s = this.buf.toString('utf8', this.off, this.off + n); this.off += n; return s; }
}

function str(s) {
  const b = Buffer.from(s, 'utf8');
  const out = Buffer.alloc(2 + b.length);
  out.writeUInt16BE(b.length, 0);
  b.copy(out, 2);
  return out;
}

function on(id, fn, name) {
  const signedId = (id << 16) >> 16;
  handlers.set(signedId, fn);
  handlerNames.set(signedId, name || codec.byId.get(signedId)?.name || String(id));
}
// Sınıf adıyla işleyici kaydı: onCmd('MoveRequest', (session, cmd) => ...)
function onCmd(name, fn) {
  if (!codec.schema[name]) throw new Error(`Bilinmeyen komut işleyicisi: ${name}`);
  on(codec.schema[name].id, (session, packet) => fn(session, packet.cmd), name);
}

// Dünya başına tek savaş/NPC yöneticisi.
const combats = new WeakMap();
function combatFor(world) {
  if (!combats.has(world)) combats.set(world, new Combat(world, sendCmd));
  world.combat = combats.get(world);
  return world.combat;
}

// Gövdeyi şema ile çözer (game/codec); işleyiciler packet.cmd ile adlandırılmış alanlara erişir.
function handle(session, packet) {
  const decoded = codec.decode(packet.raw);
  if (!decoded.obj || decoded.rest !== 0) throw new Error('Eksik veya fazla oyun paketi alanı');
  packet.cmd = decoded.obj;
  packet.id = codec.schema[decoded.obj._].id;
  if (packet.id !== ID.VERSION_REQUEST && packet.id !== ID.LOGIN_REQUEST) {
    if (!session.player || !session.world.sessions.has(session) || session.world.player !== session.player ||
      !auth.verifyGame(session.authSid, session.player.userId)) {
      session.close();
      return false;
    }
  }
  const fn = handlers.get(packet.id);
  if (fn) return fn(session, packet);
  const name = packet.cmd._;
  session.unsupported ||= new Set();
  if (!session.unsupported.has(name)) {
    session.unsupported.add(name);
    console.log(`[proto] #${session.id} işlenmeyen ${name}`);
  }
  return false;
}


// Sürüm kontrolü: canlı sunucu aynı hash'i ve 1 (uygun) döndürüyor.
on(ID.VERSION_REQUEST, (session, packet) => {
  const { version } = packet.cmd;
  console.log(`[proto] #${session.id} VersionRequest ${version}`);
  sendCmd(session, { _: 'VersionCommand', version, equal: true });
});

// LoginRequest: userID, factionID, sessionID, version (sıkıştırma adı), instanceId, isMiniClient.
// Oturum anahtarı web girişinde üretilir (game/auth.js) ve flashvars ile istemciye verilir.
on(ID.LOGIN_REQUEST, (session, packet) => {
  const { userID: userId, sessionID, version, instanceId } = packet.cmd;
  if (session.player || !auth.verifyGame(sessionID, userId)) {
    console.warn(`[proto] #${session.id} LoginRequest reddedildi: geçersiz oturum (userId=${userId})`);
    session.close();
    return;
  }
  console.log(`[proto] #${session.id} LoginRequest userId=${userId} instance=${instanceId} sıkıştırma=${version}`);
  session.world.login(session, userId);
  if (!session.player || !auth.bind(sessionID, session)) { session.close(); return; }
  session.rendererMode = require('./client-view').mode(userId, session.world.config);
  session.world.rendererMode = session.rendererMode;
  // Açılış komutları oyuncu durumundan üretilir (game/init.js). Sıkıştırmasız düz çerçeve
  // gönderilir; canlı sunucu da ilk paketi (VersionCommand) düz gönderiyor.
  const init = buildInit(session.world);
  for (const cmd of init) sendCmd(session, cmd);
  console.log(`[proto] #${session.id} açılış: ${init.length} komut gönderildi`);
  const combat = combatFor(session.world);
  if (combat.timer) combat.sendAll(session);
  combat.start();
});

// Oyuncu kendi gemisini yerel hareket ettirir; sunucu konumu takip eder (NPC'ler ve kayıt için).
onCmd('MoveRequest', (session, cmd) => {
  session.world.move(session, cmd);
});
onCmd('ShipSelectRequest', (session, cmd) => combatFor(session.world).select(session, cmd.targetId));
onCmd('AttackLaserRequest', (session, cmd) => combatFor(session.world).attack(session, cmd.targetId));
onCmd('AttackAbortLaserRequest', session => combatFor(session.world).abort(session));
// Eylem çubuğu: lazer cephanesi seçimi (diğer menü eylemleri sonraki aşamalarda).
onCmd('MenuActionRequest', (session, cmd) => {
  if (/^ammunition_laser_/.test(cmd.menuItemId) && require('./ammo').select(session.world.player, cmd.menuItemId)) {
    console.log(`[proto] #${session.id} cephane: ${cmd.menuItemId}`);
    require('./gameplay').menuAction(session, cmd);
    return;
  }
  if (/^drone_formation_/.test(cmd.menuItemId)) {
    try {
      require('./drones').selectFormation(session.player.userId, cmd.menuItemId);
      for (const c of require('./drones').buildCommands(session.player)) sendCmd(session, c);
      sendCmd(session, require('./handlers/core').menu(session.player));
    } catch (err) { console.warn('[drones]', err.message);sendCmd(session,{_:'LegacyModule',message:'0|A|STD|'+err.message}); }
    return;
  }
  require('./gameplay').menuAction(session, cmd);
});
onCmd('KeepAlive', () => {});

function registeredCommands() { return [...handlerNames.values()].sort(); }

const services = { sendCmd, combatFor, buildInit };
require('./handlers/core').register(onCmd, services);
require('./handlers/inventory').register(onCmd, services);
require('./handlers/shop').register(onCmd, services);
require('./handlers/drones').register(onCmd, services);
require('./handlers/systems').register(onCmd, services);
require('./handlers/skills').register(onCmd, services);
require('./handlers/lab').register(onCmd, services);
require('./handlers/pet').register(onCmd, services);
require('./handlers/assembly').register(onCmd, services);
require('./gameplay').register(onCmd, services);
require('./ship-warp').register(onCmd);

module.exports = { ID, MAX_FRAME, readFrame, writeFrame, frameBody, sendCmd, Reader, str, on, onCmd, handle, combatFor, registeredCommands };
