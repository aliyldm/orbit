'use strict';
// Öğrenen önbellek: client/ altında olmayan bir dosya istendiğinde onu bir kez
// yapılandırılmış CDN'den indirip aynı yola kaydeder; sonraki istekler local'den sunulur.
// Sorgu dizesi (?__cv=...) yok sayılır; dosya yolu anahtardır.

const fs = require('fs');
const path = require('path');

function createCdnCache(options, log, services = {}) {
  const upstream = options.upstream.replace(/\/+$/, '');
  const userAgent = options.userAgent || 'BigpointClient/1.6.9';
  const inFlight = new Map(); // relPath -> Promise<boolean>
  const misses = new Set();   // CDN'de de bulunamayan yollar (bu çalışma süresince)
  const fetchFile = services.fetch || globalThis.fetch;
  const maxBytes = options.maxFileBytes || 32 * 1024 * 1024;
  const concurrency = Math.max(1, Math.min(16, options.concurrency || 6));
  const pending = [];
  let active = 0, serial = 0;
  function schedule(task) {
    if (pending.length >= 512) return Promise.resolve(false);
    return new Promise((resolve, reject) => {
      pending.push({ task, resolve, reject }); pump();
    });
  }
  function pump() {
    while (active < concurrency && pending.length) {
      const next = pending.shift(); active++;
      Promise.resolve().then(next.task).then(next.resolve, next.reject).finally(() => { active--; pump(); });
    }
  }

  async function download(relPath, file, query) {
    const url = `${upstream}/${relPath.split('/').map(encodeURIComponent).join('/')}${query ? '?' + query : ''}`;
    const res = await fetchFile(url, { headers: { 'User-Agent': userAgent }, signal: AbortSignal.timeout(options.timeoutMs || 25000) });
    if (!res.ok) {
      log(`CDN ${res.status} ${relPath}`);
      if (res.status === 404 || res.status === 403) misses.add(query ? `${relPath}?${query}` : relPath);
      await res.body?.cancel();
      return false;
    }
    // fetch, Content-Encoding: gzip gövdesini otomatik açar; diske açık hali yazılır.
    const chunks = []; let size = 0;
    if (!res.body) throw new Error('Boş CDN yanıtı');
    for await (const chunk of res.body) {
      size += chunk.length;
      if (size > maxBytes) throw new Error('CDN dosya boyutu sınırı aşıldı');
      chunks.push(Buffer.from(chunk));
    }
    const buf = Buffer.concat(chunks, size);
    if (!size || (!/\.html?$/i.test(relPath) && /<(?:!doctype\s+html|html)\b/i.test(buf.subarray(0, 512).toString())))
      throw new Error('Beklenen dosya yerine boş/HTML CDN yanıtı');
    fs.mkdirSync(path.dirname(file), { recursive: true });
    const tmp = `${file}.part-${process.pid}-${++serial}`;
    try { fs.writeFileSync(tmp, buf); fs.renameSync(tmp, file); }
    finally { if (fs.existsSync(tmp)) fs.unlinkSync(tmp); }
    log(`CDN 200 ${relPath} (${buf.length} bytes) kaydedildi`);
    return true;
  }

  // Dosyayı local'e getirmeyi dener; başarılıysa true döner.
  // query: sorguya göre içerik üreten uçlar (ör. .esg yazı resimleri) için; dosya adı çağıranda ayrılır.
  function fetchMissing(relPath, file, query = '') {
    const key = query ? `${relPath}?${query}` : relPath;
    if (!options.enabled || misses.has(key)) return Promise.resolve(false);
    if (!inFlight.has(key)) {
      const p = schedule(() => download(relPath, file, query))
        .catch(err => { log(`CDN hata ${relPath}: ${err.message}`); return false; })
        .finally(() => inFlight.delete(key));
      inFlight.set(key, p);
    }
    return inFlight.get(key);
  }

  return { fetchMissing };
}

module.exports = { createCdnCache };
