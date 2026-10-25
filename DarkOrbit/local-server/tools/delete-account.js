'use strict';
// Bir hesabı ve oyuncusunu (gemiler, eşyalar, ayarlar) veritabanından siler.
// Kullanım: node tools/delete-account.js <kullanıcı adı>
const { open, tx } = require('../game/db');
const name = process.argv[2];
if (!name) { console.error('kullanım: node tools/delete-account.js <kullanıcı>'); process.exit(1); }
const acc = open().prepare('SELECT id FROM accounts WHERE username = ?').get(name);
if (!acc) { console.log('hesap yok:', name); process.exit(0); }
tx(db => {
  const p = db.prepare('SELECT id FROM players WHERE account_id = ?').get(acc.id);
  if (p) {
    db.prepare('UPDATE players SET active_ship_id = NULL WHERE id = ?').run(p.id);
    for (const t of ['items', 'ships', 'settings']) db.prepare(`DELETE FROM ${t} WHERE player_id = ?`).run(p.id);
    db.prepare('DELETE FROM players WHERE id = ?').run(p.id);
  }
  db.prepare('DELETE FROM accounts WHERE id = ?').run(acc.id);
});
console.log('silindi:', name);
