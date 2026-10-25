'use strict';
// Solo socket: bounded frames, authenticated dispatch, opt-in redacted capture.
const net = require('net');
const fs = require('fs');
const path = require('path');
const { policyXml } = require('./policy-server');
const protocol = require('./protocol');
const codec = require('./codec/codec');
const auth = require('./auth');
const World = require('./world');
const POLICY = Buffer.from('<policy-file-request/>\0');
const MAX_PENDING = 2 * 1024 * 1024;
function hexdump(buf) {
  const lines = [];
  for (let i = 0; i < buf.length; i += 16) {
    const chunk = buf.subarray(i, i + 16);
    const hex = [...chunk].map(b => b.toString(16).padStart(2, '0')).join(' ');
    const ascii = [...chunk].map(b => b >= 0x20 && b < 0x7f ? String.fromCharCode(b) : '.').join('');
    lines.push(`${i.toString(16).padStart(6, '0')}  ${hex.padEnd(47)}  ${ascii}`);
  }
  return lines.join('\n');
}
function redactLogin(body) {
  try {
    const { obj } = codec.decode(body);
    if (obj?._ === 'LoginRequest') return codec.encode({ ...obj, sessionID: '*'.repeat(Buffer.byteLength(obj.sessionID, 'utf8')) });
  } catch { /* Invalid frames are rejected by protocol.handle. */ }
  return body;
}
function start(config, logDir) {
  const world = World.instance(config);
  let connCount = 0;
  const sockets = new Set();
  const server = net.createServer(sock => {
    const id = ++connCount;
    sockets.add(sock);
    let closed = false;
    const capture = config.game.packetLog ? fs.createWriteStream(path.join(logDir, `game-${Date.now()}-${process.pid}-${id}.log`), { flags: 'a' }) : null;
    capture?.on('error', err => console.warn('[game] packet log:', err.message));
    let logBytes = 0;
    const log = (dir, buf) => {
      if (!capture || capture.destroyed || logBytes > (config.game.maxLogBytes || 16 * 1024 * 1024)) return;
      const entry = `\n${new Date().toISOString()} ${dir} ${buf.length} bytes\n${hexdump(buf)}\n`;
      logBytes += Buffer.byteLength(entry);
      if (capture.writableLength < 1024 * 1024) capture.write(entry);
    };
    const detach = () => {
      if (closed) return;
      closed = true;
      auth.unbind(session);
      try { world.removeSession(session); }
      catch (error) { console.error(`[game] #${id} oturum kaydı başarısız:`, error); }
    };
    const session = {
      id, world,
      send(buf) {
        if (closed || sock.destroyed || !sock.writable) return;
        if (sock.writableLength > MAX_PENDING) { this.close(); return; }
        log('S->C', buf); sock.write(buf);
      },
      close() { detach(); sock.end(); sock.setTimeout(1000, () => sock.destroy()); }
    };
    let pending = Buffer.alloc(0);
    sock.setNoDelay(true);
    sock.setTimeout(config.game.idleTimeoutMs || 120_000, () => session.close());
    console.log(`[game] #${id} bağlandı`);
    sock.on('data', buf => {
      if (closed) return;
      if (pending.length + buf.length > MAX_PENDING) { session.close(); return; }
      pending = Buffer.concat([pending, buf]);
      try {
        if (!session.firstFrameRead && pending[0] === POLICY[0]) {
          const prefix = POLICY.subarray(0, Math.min(pending.length, POLICY.length - 1));
          if (!pending.subarray(0, prefix.length).equals(prefix)) { session.close(); return; }
          if (pending.length < POLICY.length - 1) return;
          sock.end(policyXml(config)); return;
        }
        let frame;
        while (!closed && (frame = protocol.readFrame(pending, session))) {
          pending = pending.subarray(frame.consumed);
          log('C->S', protocol.frameBody(redactLogin(frame.packet.raw)));
          protocol.handle(session, frame.packet);
        }
      } catch (err) {
        console.warn(`[game] #${id} paket reddedildi: ${err.message}`);
        session.close();
      }
    });
    sock.on('close', () => {
      detach(); sockets.delete(sock); capture?.end();
      console.log(`[game] #${id} kapandı`);
    });
    sock.on('error', err => { detach(); console.warn(`[game] #${id} ${err.message}`); });
  });
  server.on('error', err => console.error('[game]', err.message));
  server.world = world;
  server.shutdown = () => {
    for (const s of [...world.sessions]) s.close();
    for (const sock of sockets) sock.destroy();
    world.combat?.stop();
    return new Promise(resolve => server.close(resolve));
  };
  server.listen(config.game.port, config.game.host, () => {
    config.game.port = server.address().port;
    console.log(`[game] ${config.game.host}:${config.game.port} dinleniyor`);
  });
  return server;
}
module.exports = { start, redactLogin };
