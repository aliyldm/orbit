// web-recorder.mjs kayıt klasörünü özetler: sayfa listesi (action=...), her sayfanın çağırdığı
// uçlar ve form alanları (POST gövdelerinden ve sayfa HTML'indeki <form> etiketlerinden).
// Kullanım: node tools/summarize-web.mjs logs/web/<oturum> [--json]

import fs from 'node:fs';
import path from 'node:path';

const args = process.argv.slice(2);
const dir = args.find(a => !a.startsWith('--'));
const asJson = args.includes('--json');
if (!dir || !fs.existsSync(dir)) {
  console.error('Kullanım: node tools/summarize-web.mjs logs/web/<oturum> [--json]');
  process.exit(2);
}

const recs = fs.readdirSync(dir)
  .filter(f => /^\d{4}_.*\.json$/.test(f))
  .sort()
  .map(f => { try { return JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8')); } catch { return null; } })
  .filter(Boolean);
const index = fs.existsSync(path.join(dir, 'index.json')) ? JSON.parse(fs.readFileSync(path.join(dir, 'index.json'), 'utf8')) : {};

const attr = (tag, name) => new RegExp(`\\s${name}\\s*=\\s*(["'])([^"']*)\\1`, 'i').exec(tag)?.[2];

// HTML içindeki formlar: action, method, alan adları (değerler yazılmaz)
function htmlForms(html) {
  const forms = [];
  for (const m of html.matchAll(/<form\b([^>]*)>([\s\S]*?)<\/form>/gi)) {
    const fields = new Set();
    for (const f of m[2].matchAll(/<(input|select|textarea|button)\b[^>]*>/gi)) {
      const n = attr(f[0], 'name');
      if (n) fields.add(`${n}${f[1].toLowerCase() === 'input' ? `:${attr(f[0], 'type') || 'text'}` : `:${f[1].toLowerCase()}`}`);
    }
    forms.push({ id: attr(m[0], 'id') || attr(m[0], 'name') || '', action: (attr(m[0], 'action') || '').replace(/&amp;/g, '&'), method: (attr(m[0], 'method') || 'GET').toUpperCase(), fields: [...fields] });
  }
  return forms;
}

const pages = new Map();
const pageOf = key => {
  if (!pages.has(key)) pages.set(key, { page: key, action: /[?&]action=([^&]+)/.exec(key)?.[1] || '', documents: 0, requests: 0, endpoints: new Map(), posts: new Map(), forms: new Map() });
  return pages.get(key);
};

for (const r of recs) {
  const pg = pageOf(r.page || '(bilinmiyor)');
  pg.requests++;
  let u;
  try { u = new URL(r.url); } catch { continue; }
  if (r.type === 'Document' && (r.page === `${u.host}${u.pathname}${u.searchParams.get('action') ? `?action=${u.searchParams.get('action')}` : ''}`)) pg.documents++;
  const ep = `${r.method} ${u.host}${u.pathname}`;
  const e = pg.endpoints.get(ep) || { endpoint: ep, type: r.type, count: 0, statuses: new Set(), actions: new Set() };
  e.count++;
  e.statuses.add(r.redirect ? `${r.status}→` : String(r.status ?? r.error ?? '?'));
  const a = u.searchParams.get('action') || u.searchParams.get('command');
  if (a) e.actions.add(a);
  if (r.method === 'POST' && typeof r.requestBody === 'string') {
    const pa = /(?:^|&)(?:action|command)=([^&]*)/.exec(r.requestBody)?.[1];
    if (pa) e.actions.add(decodeURIComponent(pa));
  }
  pg.endpoints.set(ep, e);
  if (r.method === 'POST') {
    const set = pg.posts.get(ep) || new Set();
    if (r.loginPost) set.add('[login: alanlar kaydedilmedi]');
    for (const f of r.formFields || []) set.add(f);
    pg.posts.set(ep, set);
  }
  if (r.type === 'Document' && typeof r.responseBody === 'string') {
    for (const f of htmlForms(r.responseBody)) pg.forms.set(`${f.method} ${f.action}|${f.id}`, f);
  }
}

const out = [...pages.values()].map(p => ({
  page: p.page, action: p.action, documents: p.documents, requests: p.requests,
  endpoints: [...p.endpoints.values()].sort((a, b) => b.count - a.count).map(e => ({ ...e, statuses: [...e.statuses], actions: [...e.actions] })),
  formPosts: Object.fromEntries([...p.posts].map(([k, v]) => [k, [...v]])),
  htmlForms: [...p.forms.values()],
}));

if (asJson) {
  console.log(JSON.stringify({ dir, requests: recs.length, pages: out, cdnFiles: Object.keys(index.cdn || {}).length, otherHosts: index.otherHosts || {} }, null, 2));
  process.exit(0);
}

function table(rows, cols) {
  if (!rows.length) return '  (yok)';
  const w = cols.map(c => Math.min(90, Math.max(c.length, ...rows.map(r => String(r[c] ?? '').length))));
  const line = r => '  ' + cols.map((c, i) => String(r[c] ?? '').slice(0, 90).padEnd(w[i])).join('  ');
  return [line(Object.fromEntries(cols.map(c => [c, c]))), '  ' + w.map(n => '-'.repeat(n)).join('  '), ...rows.map(line)].join('\n');
}

console.log(`Kayıt: ${dir}  (${recs.length} istek, ${Object.keys(index.cdn || {}).length} CDN dosyası)\n`);
console.log('SAYFALAR');
console.log(table(out.sort((a, b) => a.page.localeCompare(b.page)), ['action', 'page', 'documents', 'requests']));

for (const p of out) {
  console.log(`\n== ${p.page}`);
  console.log(table(p.endpoints.map(e => ({ ...e, statuses: e.statuses.join(','), actions: e.actions.join(',') })), ['count', 'endpoint', 'type', 'statuses', 'actions']));
  const posts = Object.entries(p.formPosts).map(([endpoint, f]) => ({ endpoint, fields: f.join(', ') }));
  if (posts.length) { console.log('  POST alanları:'); console.log(table(posts, ['endpoint', 'fields'])); }
  if (p.htmlForms.length) {
    console.log('  HTML formları:');
    console.log(table(p.htmlForms.map(f => ({ ...f, fields: f.fields.join(', ') })), ['method', 'action', 'id', 'fields']));
  }
}

const oh = Object.entries(index.otherHosts || {}).sort((a, b) => b[1] - a[1]);
if (oh.length) console.log(`\nKaydedilmeyen diğer hostlar: ${oh.map(([h, n]) => `${h} (${n})`).join(', ')}`);
