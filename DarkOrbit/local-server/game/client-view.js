'use strict';
// FlashVarsParser: USER_TYPE_2D=2, USER_TYPE_3D=1. The server request field is
// displayUse2d; a constant flashvar of 1 always restarted into 3D.
function mode(playerId, config, db = require('./db').open()) {
  const row = db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(playerId, 'DisplaySettingsModule');
  if (row) {
    try { const value = JSON.parse(row.value); if (typeof value.displayUse2d === 'boolean') return value.displayUse2d ? 2 : 1; }
    catch { /* Fall back to the configured renderer. */ }
  }
  return Number(config.client.flashvars.display2d) === 2 ? 2 : 1;
}
module.exports = { mode };
