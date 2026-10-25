'use strict';
// Oyun soketine komut gönderme yardımcıları (protocol.js ve diğer modüller ortak kullanır).
// Sunucu -> istemci çerçevesi: [uint24 BE uzunluk][gövde]; gövde codec ile üretilir.

const codec = require('./codec/codec');

function frameBody(body) {
  const out = Buffer.alloc(3 + body.length);
  out.writeUIntBE(body.length, 0, 3);
  body.copy(out, 3);
  return out;
}

// The compact balance update has signed int32 fields, unlike the initial
// ship/inventory doubles and Hero's Number wallet. The captured legacy C
// handler accepts exact Number/parseFloat totals without changing the SWF.
// Keep ordinary wire packets intact; never send a wrapped/clamped fake balance.
function walletCommand(obj) {
  if (obj?._ !== 'AttributeCreditsUpdateCommand') return obj;
  const credits=Number(obj.credits??0),uridium=Number(obj.uridium??0);
  if (![credits,uridium].every(n=>Number.isFinite(n)&&Math.abs(n)<=Number.MAX_SAFE_INTEGER)) throw new RangeError('Wallet exceeds exact native Number range');
  if ([credits,uridium].every(n=>Number.isInteger(n)&&n>=-2147483648&&n<=2147483647)) return obj;
  // Legacy C updates only the wallet. Jackpot remains the value initialized
  // with ShipInitialization or updated by its separate reward protocol.
  return {_:'LegacyModule',message:`0|A|C|${credits}|${uridium}`};
}

// sendCmd(session, { _: 'SınıfAdı', alan: değer })
function sendCmd(session, obj) { session.send(frameBody(codec.encode(walletCommand(obj)))); }

module.exports = { frameBody, sendCmd, walletCommand };
