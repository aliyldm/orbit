'use strict';
// Explicit isolated visual-QA host for the patched launcher's fixed localhost URL.
// Production accounts/database are never opened. Stop with Ctrl+C.
const { start } = require('../server');
const dbm = require('../game/db');
async function main() {
  const config = structuredClone(require('../config.json'));
  config.http.port = 8097; config.game.port = 8098;
  config.cdnCache.enabled = config.hostCache.enabled = false;
  config.starter.credits = config.starter.uridium = 100000000;
  dbm.open(':memory:');
  const players = require('../game/db/players');
  const account = players.createAccount('local-ui-qa', 'local-ui-qa');
  const id = players.createPlayer(account, 'Local QA', 1, config.starter);
  require('../game/skills').state(id);
  dbm.open().prepare('UPDATE skill_accounts SET earned_points=50 WHERE player_id=?').run(id);
  require('../game/skylab').state(id);
  dbm.open().prepare('UPDATE skylab_resources SET amount=100000 WHERE player_id=? AND ore_type=7').run(id);
  const runtime = await start(config, { dbFile: ':memory:', logDir: require('node:path').resolve(__dirname, '../logs/ui-qa') });
  console.log('VISUAL QA ONLY: in-memory local-ui-qa / local-ui-qa, external caches disabled.');
  for (const signal of ['SIGINT', 'SIGTERM', 'SIGBREAK']) process.once(signal, () => runtime.close().then(() => process.exit(0)));
}
if (require.main === module) main().catch(error => { console.error(error.stack); process.exitCode = 1; });
