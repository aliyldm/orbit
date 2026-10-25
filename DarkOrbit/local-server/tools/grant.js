'use strict';
// Test/geliştirme için bir hesaba kredi ve uridyum ekler.
// Sunucu çalışırken kullanılabilir; oyuncu o an oyundaysa değişiklik bir sonraki girişte görünür
// (oyun içi bellek kopyası çıkışta DB'ye yazılır, bu yüzden oyundan çıkmışken kullanın).
// Kullanım: node tools/grant.js <kullanıcı> <kredi> [uridyum]

const { open } = require('../game/db');
const [name, credits = '0', uridium = '0'] = process.argv.slice(2);
if (!name) { console.error('kullanım: node tools/grant.js <kullanıcı> <kredi> [uridyum]'); process.exit(1); }
const db = open();
const p = db.prepare('SELECT p.id FROM players p JOIN accounts a ON a.id = p.account_id WHERE a.username = ?').get(name);
if (!p) { console.error('oyuncu yok:', name); process.exit(1); }
db.prepare('UPDATE players SET credits = credits + ?, uridium = uridium + ? WHERE id = ?').run(Number(credits), Number(uridium), p.id);
console.log(db.prepare('SELECT name, credits, uridium FROM players WHERE id = ?').get(p.id));
