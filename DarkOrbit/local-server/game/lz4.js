'use strict';
// LZ4 blok formatı (çerçevesiz) için çözücü ve "yalnızca literal" kodlayıcı.
// Kodlayıcı sıkıştırma yapmaz ama geçerli bir LZ4 bloğu üretir; local sunucu için yeterli.

function decompressBlock(src, expectedSize) {
  const out = Buffer.alloc(expectedSize);
  let s = 0, d = 0;
  while (s < src.length) {
    const token = src[s++];
    let litLen = token >>> 4;
    if (litLen === 15) {
      let b;
      do { b = src[s++]; litLen += b; } while (b === 255);
    }
    src.copy(out, d, s, s + litLen);
    s += litLen; d += litLen;
    if (s >= src.length) break; // son dizi yalnızca literal içerir
    const offset = src[s] | (src[s + 1] << 8);
    s += 2;
    if (offset === 0 || offset > d) throw new Error(`geçersiz LZ4 offset ${offset} @${d}`);
    let matchLen = (token & 15);
    if (matchLen === 15) {
      let b;
      do { b = src[s++]; matchLen += b; } while (b === 255);
    }
    matchLen += 4;
    for (let i = 0; i < matchLen; i++, d++) out[d] = out[d - offset]; // örtüşen kopyaya izin verir
  }
  if (d !== expectedSize) throw new Error(`LZ4 boyut uyuşmazlığı: ${d} != ${expectedSize}`);
  return out;
}

function literalBlock(data) {
  const parts = [];
  let n = data.length;
  if (n < 15) parts.push(Buffer.from([n << 4]));
  else {
    const ext = [];
    n -= 15;
    while (n >= 255) { ext.push(255); n -= 255; }
    ext.push(n);
    parts.push(Buffer.from([0xf0, ...ext]));
  }
  parts.push(data);
  return Buffer.concat(parts);
}

module.exports = { decompressBlock, literalBlock };
