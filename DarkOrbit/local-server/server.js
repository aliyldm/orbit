'use strict';
// Local solo runtime: start TCP before HTTP so dynamic ports are advertised correctly.
const fs = require('fs');
const path = require('path');
const database = require('./game/db');
function listening(server) {
  if (!server) return Promise.resolve();
  return new Promise((resolve, reject) => {
    const ready = () => { server.removeListener('error', reject); resolve(); };
    server.once('listening', ready);
    server.once('error', reject);
  });
}
async function start(config = JSON.parse(fs.readFileSync(path.join(__dirname, 'config.json'), 'utf8')), options = {}) {
  const logDir = options.logDir || path.join(__dirname, 'logs');
  fs.mkdirSync(logDir, { recursive: true });
  database.open(options.dbFile || process.env.DARKORBIT_DB || database.DB_FILE);
  const runtime = { config, http: null, policy: null, game: null, closing: false };
  runtime.close = async () => {
    if (runtime.closing) return;
    runtime.closing = true;
    const closeServer = server => new Promise(resolve => {
      if (!server || !server.listening) return resolve();
      server.close(resolve); server.closeAllConnections?.();
    });
    await closeServer(runtime.http?.tlsServer);
    await closeServer(runtime.http);
    await closeServer(runtime.policy);
    if (runtime.game) await runtime.game.shutdown();
    database.close();
  };
  try {
    runtime.game = require('./game/game-server').start(config, logDir);
    await listening(runtime.game);
    runtime.http = require('./web/http-server').start(config, logDir);
    await listening(runtime.http);
    runtime.policy = require('./game/policy-server').start(config);
    // Optional port843 failure is already handled; game-port policy remains available.
    console.log(`[server] Hazır: http://${config.http.host}:${config.http.port}`);
    return runtime;
  } catch (err) { await runtime.close(); throw err; }
}
async function main() {
  const major = Number(process.versions.node.split('.')[0]);
  if (major < 26) throw new Error('Node.js 26 veya üstü gerekli.');
  const config = JSON.parse(fs.readFileSync(path.join(__dirname, 'config.json'), 'utf8'));
  try {
    const response = await fetch(`http://${config.http.host}:${config.http.port}/health`, { signal: AbortSignal.timeout(1500) });
    const health = await response.json();
    if (response.ok && health.service === 'darkorbit-local' && health.gamePort === config.game.port) {
      console.log(`[server] Zaten çalışıyor: http://${config.http.host}:${config.http.port}`);
      return;
    }
  } catch { /* No matching runtime: bind the configured ports normally. */ }
  const runtime = await start(config);
  for (const signal of ['SIGINT', 'SIGTERM', 'SIGBREAK']) process.once(signal, () => {
    runtime.close().then(() => process.exit(0), err => { console.error(err); process.exit(1); });
  });
}
module.exports = { start };
if (require.main === module) main().catch(err => { console.error('[server]', err.message); process.exitCode = 1; });
