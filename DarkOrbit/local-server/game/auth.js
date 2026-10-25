'use strict';
// Web ve oyun sunucusunun paylaştığı oturum deposu (aynı süreç).
// Web girişi bir oturum anahtarı üretir; oyun sayfası bunu flashvars sessionID olarak verir;
// oyun soketindeki LoginRequest bu anahtar ve userID ile doğrulanır.

const crypto = require('crypto');

const sessions = new Map();
const SESSION_MS = 24 * 60 * 60 * 1000;

function create(accountId, playerId) {
  const sid = crypto.randomBytes(16).toString('hex');
  sessions.set(sid, { accountId, playerId, expiresAt: Date.now() + SESSION_MS, connections: new Set() });
  return sid;
}

function get(sid) {
  const s = typeof sid === 'string' ? sessions.get(sid) : null;
  if (!s) return null;
  if (s.expiresAt <= Date.now()) { destroy(sid); return null; }
  return s;
}
function setPlayer(sid, playerId) { const s = get(sid); if (s) s.playerId = playerId; }
function destroy(sid) {
  const s = sessions.get(sid);
  sessions.delete(sid);
  if (s) for (const connection of [...s.connections]) {
    s.connections.delete(connection);
    connection.close();
  }
}

function bind(sid, connection) {
  const s = get(sid);
  if (!s) return false;
  unbind(connection);
  connection.authSid = sid;
  s.connections.add(connection);
  return true;
}

function unbind(connection) {
  sessions.get(connection.authSid)?.connections.delete(connection);
  connection.authSid = null;
}

// Expired sessions must also close otherwise-idle game sockets.
const cleanup = setInterval(() => {
  for (const [sid, s] of sessions) if (s.expiresAt <= Date.now()) destroy(sid);
}, 60_000);
cleanup.unref();

// Oyun soketi girişi: anahtar geçerli ve aynı oyuncuya ait olmalı.
function verifyGame(sid, playerId) {
  const s = get(sid);
  return !!s && s.playerId === playerId;
}

module.exports = { create, get, setPlayer, destroy, verifyGame, bind, unbind };
