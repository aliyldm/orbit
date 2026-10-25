'use strict';
// Canlı oturumun açılış paketlerini çözülmüş JSON şablonuna çevirir (game/templates/).
//   init.json        — arayüz/ayar/menü komutları; oyuncuya özgü alanlar çalışma anında üzerine yazılır
//   npc-ship.json    — bir NPC'nin ShipCreateCommand örneği (yeni NPC üretmek için)
// Diğer varlıklar, hareketleri, mesajlar ve arkadaş listesi şablona alınmaz.
// Kullanım: node tools/build-init-template.js logs/session-6101-1.json <ilkSeq> <sonSeqHariç>

const fs = require('fs');
const path = require('path');
const { decode } = require('../game/codec/codec');

const [file, from, to] = process.argv.slice(2);
const packets = JSON.parse(fs.readFileSync(file, 'utf8'))
  .filter(p => p.dir === 'S->C' && p.hex && p.seq >= Number(from) && p.seq < Number(to));

// Haritadaki diğer varlıklar ve canlıya özgü kişisel veriler.
const DROP = new Set([
  'MoveCommand', 'ShipCreateCommand', 'ShipRemoveCommand', 'AttackAbortLaserCommand',
  'AttackLaserRunCommand', 'AttackHitCommand', 'UserMessageNewCommand', 'ContactListInitializationCommand',
  'DisplayOfferCommand', 'PetActivationCommand', 'PetStatusCommand'
]);

// Eski metin komutlarında başka oyunculara ait satırlar: 0|n|<tür>|<kimlik>|... (drone, ünvan, envanter, efekt).
function otherPlayerLegacy(obj, ownId) {
  if (obj._ !== 'LegacyModule') return false;
  const m = obj.message.match(/^0\|n\|(d|t|INV|e)\|(\d+)\|/);
  return !!m && Number(m[2]) !== ownId;
}

const decoded = packets.map(p => decode(Buffer.from(p.hex, 'hex')).obj).filter(Boolean);
const ship = decoded.find(o => o._ === 'ShipInitializationCommand');
const npc = decoded.find(o => o._ === 'ShipCreateCommand' && o.npc) || null;
const commands = decoded.filter(o => !DROP.has(o._) && !otherPlayerLegacy(o, ship.userId));

const dir = path.join(__dirname, '..', 'game', 'templates');
fs.mkdirSync(dir, { recursive: true });
fs.writeFileSync(path.join(dir, 'init.json'), JSON.stringify({
  _comment: 'Canlı açılıştan çözülmüş komutlar. recorded* değerleri çalışma anında local oyuncu değerleriyle değiştirilir.',
  recordedUserId: ship.userId,
  recordedUserName: ship.userName,
  commands
}, null, 1));
// NPC şablonu yalnızca yoksa yazılır (alan yapısı tüm NPC'lerde aynı).
if (npc && !fs.existsSync(path.join(dir, 'npc-ship.json'))) fs.writeFileSync(path.join(dir, 'npc-ship.json'), JSON.stringify(npc, null, 1));
console.log(`${commands.length} komut şablona alındı (${packets.length - commands.length} çıkarıldı); kayıttaki harita: ${ship.mapId}`);
