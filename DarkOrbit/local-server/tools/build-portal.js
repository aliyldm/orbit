'use strict';
// Kaydedilmiş canlı portal sayfalarından (logs/web/*) local portal şablonları üretir.
//   web/portal/pages/<action>[~<tpl>].html  — sayfa HTML'i (adresler local'e çevrilmiş, izleme betikleri çıkarılmış)
//   web/portal/ajax.json                     — ajax/flashAPI cevapları (uç + action/command anahtarıyla)
//   web/portal/meta.json                     — kayıttaki hesap kimliği/adı (çalışma anında değiştirilir)
// Aynı sayfa birden çok kez kaydedildiyse en son 200 cevabı kullanılır.
// Kullanım: node tools/build-portal.js logs/web/<klasör1> [logs/web/<klasör2> ...] --user <kayıttaki ad> --id <kayıttaki kimlik>

const fs = require('fs');
const path = require('path');
const { scrub } = require('./scrub-tokens');

const args = process.argv.slice(2);
const opt = k => { const i = args.indexOf(k); return i >= 0 ? args.splice(i, 2)[1] : null; };
const recordedName = opt('--user');
const recordedId = opt('--id');
const dirs = args;

const OUT = path.join(__dirname, '..', 'web', 'portal');
fs.mkdirSync(path.join(OUT, 'pages'), { recursive: true });

// Oyun/CDN dışındaki hostlar: reklam, izleme, çerez onayı, captcha.
const OWN_HOST = /(^|\.)(darkorbit\.com|bpsecure\.com)$/i;

function localizeUrls(s) {
  return scrub(s).out
    .replace(/https?:\/\/darkorbit-22\.bpsecure\.com\//g, '/client/')
    .replace(/https?:\\\/\\\/darkorbit-22\.bpsecure\.com\\\//g, '\\/client\\/') // JSON içinde kaçışlı hali
    .replace(/(https?:)?\/\/(gbl?\d+|gb\d+|www)\.darkorbit\.com\//g, '/')
    // Sonda / olmadan kullanılan tam host (ör. flashvars dynamicHost): görüntülemede local adres yazılır.
    .replace(/https?:\/\/(gbl?\d+|gb\d+|www)\.darkorbit\.com(?=["'&\\])/g, '{{HOST}}');
}

function stripForeign(html) {
  return html
    // dış kaynaklı script/iframe/link etiketleri
    .replace(/<script\b[^>]*\bsrc=["'](https?:)?\/\/([^/"']+)[^"']*["'][^>]*>\s*<\/script>/gi, (m, p, host) => (OWN_HOST.test(host) ? m : ''))
    .replace(/<iframe\b[^>]*\bsrc=["'](https?:)?\/\/([^/"']+)[^>]*>[\s\S]*?<\/iframe>/gi, (m, p, host) => (OWN_HOST.test(host) ? m : ''))
    .replace(/<link\b[^>]*\bhref=["'](https?:)?\/\/([^/"']+)[^>]*>/gi, (m, p, host) => (OWN_HOST.test(host) ? m : ''))
    // satır içi izleme/çerez onayı betikleri
    .replace(/<script\b[^>]*>(?:(?!<\/script>)[\s\S])*?(googletagmanager|gtag\(|dataLayer|__tcfapi|inmobi|quantserve|_qevents|bat\.bing|uetq|hcaptcha)(?:(?!<\/script>)[\s\S])*<\/script>/gi, '');
}

function pageKey(url) {
  const u = new URL(url);
  const action = u.searchParams.get('action');
  if (!action) return null;
  const tpl = u.searchParams.get('tpl');
  return tpl ? `${action}~${tpl}` : action;
}

function ajaxKey(r) {
  const u = new URL(r.url);
  const body = new URLSearchParams(r.requestBody || '');
  const sub = body.get('action') || body.get('command') || u.searchParams.get('subaction') || '';
  let detail = '';
  // inventory.php getShipDetails: gemi türüne göre ayrı cevap.
  if (body.get('params')) {
    try { const p = JSON.parse(Buffer.from(body.get('params'), 'base64').toString()); detail = p.params?.lootId || ''; } catch { /* yok */ }
  }
  return [u.pathname, sub, detail].filter(Boolean).join('|');
}

const pages = {}, ajax = {};
for (const dir of dirs) {
  for (const f of fs.readdirSync(dir).filter(f => /^\d+_.*\.json$/.test(f)).sort()) {
    const r = JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8'));
    if (r.status !== 200 || !r.responseBody) continue;
    if (r.type === 'Document' && /indexInternal\.es/.test(r.url)) {
      const key = pageKey(r.url);
      if (key) pages[key] = r.responseBody;
    } else if (/\/(flashAPI|ajax)\/[^/]+\.php/.test(r.url) || /subaction=/.test(r.url)) {
      ajax[ajaxKey(r)] = { contentType: r.contentType || 'text/html', body: r.responseBody };
    }
  }
}

for (const [key, html] of Object.entries(pages)) {
  fs.writeFileSync(path.join(OUT, 'pages', `${key}.html`), stripForeign(localizeUrls(html)));
}
for (const v of Object.values(ajax)) v.body = localizeUrls(v.body);

// Dükkan sayfalarındaki "itemData : {...}" nesnesi: eşya → kategori, fiyat, para birimi.
// /ajax/shop.php satın alma işlemi fiyatı buradan alır (katalogdaki bazı fiyatlar işaretçi değer).
function extractItemData(html) {
  const at = html.indexOf('itemData');
  if (at < 0) return {};
  const start = html.indexOf('{', at);
  let depth = 0, inStr = false;
  for (let i = start; i < html.length; i++) {
    const ch = html[i];
    if (inStr) { if (ch === '\\') i++; else if (ch === '"') inStr = false; continue; }
    if (ch === '"') inStr = true;
    else if (ch === '{') depth++;
    else if (ch === '}' && --depth === 0) {
      try { return JSON.parse(html.slice(start, i + 1)); } catch { return {}; }
    }
  }
  return {};
}
const shop = {};
for (const [key, html] of Object.entries(pages)) {
  if (!key.startsWith('internalDock~')) continue;
  for (const [id, it] of Object.entries(extractItemData(html))) {
    shop[id] = { category: it.category, name: it.name, price: it.price, currency: it.currency, page: key, isPaymentItem: !!it.isPaymentItem };
  }
}
fs.writeFileSync(path.join(OUT, 'shop.json'), JSON.stringify(shop, null, 1));
console.log(`${Object.keys(shop).length} dükkan ürünü; para birimleri:`, Object.values(shop).reduce((a, s) => (a[s.currency] = (a[s.currency] || 0) + 1, a), {}));
fs.writeFileSync(path.join(OUT, 'ajax.json'), JSON.stringify(ajax, null, 1));
fs.writeFileSync(path.join(OUT, 'meta.json'), JSON.stringify({ recordedName, recordedId, sources: dirs.map(d => path.basename(d)) }, null, 1));

console.log(`${Object.keys(pages).length} sayfa: ${Object.keys(pages).sort().join(', ')}`);
console.log(`${Object.keys(ajax).length} ajax cevabı: ${Object.keys(ajax).sort().join(', ')}`);
