// Aşama 1 web kaydedici: canlı launcher'ın DevTools portuna tarayıcı seviyesinde bağlanır,
// *.darkorbit.com isteklerini (sayfa HTML'i, XHR/Fetch, flashAPI/ajax, form POST, yönlendirme,
// cevap gövdesi) maskeleyerek istek başına JSON olarak yazar. CDN (*.bpsecure.com) için yalnızca
// URL listesi tutulur. Yeni açılan sekme/pencerelere otomatik bağlanır.
//
// Maskeleme: Cookie/Set-Cookie hiç yazılmaz; sid/dosid/session/token/hash/auth/pass/secret/key/
// signature adlı değerler REDACTED olur; çerez değerleri (dosid vb.) tüm metinde tam eşleşmeyle
// maskelenir; login POST gövdesi hiç yazılmaz.
//
// Kullanım: node tools/web-recorder.mjs [--port 9333] [--host 127.0.0.1] [--out logs/web] [--duration sn]
//           node tools/web-recorder.mjs --self-test
// Ayrıntı: docs/web-recorder.md

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

// ---------------------------------------------------------------- maskeleme

export const SECRET_KEY = /(sid|dosid|session|token|hash|auth|pass|secret|key|signature)/i;
const DROP_HEADERS = /^(cookie|set-cookie|set-cookie2|authorization|proxy-authorization)$/i;
const KEEP_HEADERS = /^(content-type|location|x-requested-with|referer|content-length)$/i;
const LOGIN_FIELD = /(pass|username|^user$|login|e-?mail)/i;
const LOGIN_URL = /(login|signin|sign_in|authenticat)/i;

const isSecretKey = k => { try { return SECRET_KEY.test(decodeURIComponent(k)); } catch { return SECRET_KEY.test(k); } };

// Bilinen gizli değerler (çerez değerleri). Tam eşleşmeyle ve URL-encoded halleriyle maskelenir.
export function createSecrets() {
  const set = new Set();
  return {
    add(v) { if (typeof v === 'string' && v.length >= 6) set.add(v); },
    get size() { return set.size; },
    apply(s) {
      if (!s) return s;
      for (const v of set) {
        for (const form of new Set([v, encodeURIComponent(v)])) {
          if (s.includes(form)) s = s.split(form).join('REDACTED_COOKIE');
        }
      }
      return s;
    },
  };
}

export function maskText(s, secrets) {
  if (s == null || s === '') return s;
  s = String(s);
  if (secrets) s = secrets.apply(s);
  return s
    // key=value (sorgu, form, flashvars; &amp; ayracı ';' ile yakalanır)
    .replace(/([?&;]|^)([^=&;\s"'<>]+)=([^&;\s"'<>]*)/g, (m, p, k) => (isSecretKey(k) ? `${p}${k}=REDACTED` : m))
    // JSON / JS  "key": "value"  'key':'value'  key: "value"
    .replace(/((["']?)([\w$.-]+)\2\s*:\s*)(["'])((?:\\.|(?!\4).)*)\4/g, (m, pre, _q, k, q) => (isSecretKey(k) ? `${pre}${q}REDACTED${q}` : m))
    // JSON sayısal değer  "sid": 123456
    .replace(/(("([\w$.-]+)")\s*:\s*)(\d{4,})/g, (m, pre, _qk, k) => (isSecretKey(k) ? `${pre}"REDACTED"` : m))
    // JS atama  var SID = '...';  sessionId = "..."
    .replace(/(\b([\w$.]+)\s*=\s*)(["'])([^"'\n]*)\3/g, (m, pre, k, q) => (isSecretKey(k) ? `${pre}${q}REDACTED${q}` : m))
    // HTML/XML öznitelik  sid="..."  data-token='...'
    .replace(/(\s([\w:-]+)\s*=\s*)(["'])([^"']*)\3/g, (m, pre, k, q) => (isSecretKey(k) ? `${pre}${q}REDACTED${q}` : m))
    // <input name="sid" value="...">  (name hangi sırada olursa olsun)
    .replace(/<(input|param|meta)\b[^>]*>/gi, tag => {
      const nm = /\s(?:name|id|property)\s*=\s*["']([^"']*)["']/i.exec(tag);
      if (!nm || !isSecretKey(nm[1])) return tag;
      return tag.replace(/(\s(?:value|content)\s*=\s*)(["'])[^"']*\2/gi, '$1$2REDACTED$2');
    })
    // XML <key>value</key>
    .replace(/<([\w:-]+)>([^<]*)<\/\1>/g, (m, k) => (isSecretKey(k) ? `<${k}>REDACTED</${k}>` : m))
    // 32+ hane hex (oturum kimlikleri bu biçimde)
    .replace(/\b[a-f0-9]{32,}\b/gi, 'REDACTED_HEX')
    // URL-kodlu iç içe değerler (ör. flashvars'taki supporturl=...authUser%3D..%26token%3D.., boardLink=...%3Ftoken%3D..)
    .replace(/((?:token|authUser|sid|dosid|session|hash|auth|key|signature)(?:%3D|%253D))[A-Za-z0-9_\-.]+/gi,
      (m, k) => (/^(REDACTED|REDACTED_HEX)$/.test(m.slice(k.length)) ? m : `${k}REDACTED`));
}

export function maskUrl(u, secrets) {
  if (!u) return u;
  if (secrets) u = secrets.apply(u);
  try {
    const url = new URL(u);
    for (const k of [...url.searchParams.keys()]) if (isSecretKey(k)) url.searchParams.set(k, 'REDACTED');
    if (url.username || url.password) { url.username = ''; url.password = ''; }
    url.hash = maskText(url.hash, secrets);
    return url.toString();
  } catch { return maskText(u, secrets); }
}

export function maskHeaders(h, secrets) {
  const out = {};
  for (const [k, v] of Object.entries(h || {})) {
    if (DROP_HEADERS.test(k) || !KEEP_HEADERS.test(k)) continue;
    out[k.toLowerCase()] = /^(location|referer)$/i.test(k) ? maskUrl(String(v), secrets) : maskText(String(v), secrets);
  }
  return out;
}

export function formFieldNames(body, contentType = '') {
  if (!body) return [];
  if (/json/i.test(contentType) || /^\s*[{[]/.test(body)) {
    try { const j = JSON.parse(body); return j && typeof j === 'object' && !Array.isArray(j) ? Object.keys(j) : []; } catch { /* düz metin */ }
  }
  if (/multipart/i.test(contentType)) return [...body.matchAll(/name="([^"]+)"/g)].map(m => m[1]);
  return body.split('&').filter(Boolean).map(p => { try { return decodeURIComponent(p.split('=')[0].replace(/\+/g, ' ')); } catch { return p.split('=')[0]; } });
}

export function isLoginPost(method, url, body, contentType) {
  if (method !== 'POST') return false;
  if (LOGIN_URL.test(url)) return true;
  return formFieldNames(body, contentType).some(f => LOGIN_FIELD.test(f));
}

// POST gövdesi: login ise hiç yazılmaz; değilse maskelenir.
export function maskPostData(method, url, body, contentType, secrets) {
  if (body == null) return null;
  if (isLoginPost(method, url, body, contentType)) return '[LOGIN POST GÖVDESİ KAYDEDİLMEDİ]';
  return maskText(body, secrets);
}

export function parseSetCookie(lines) {
  const out = [];
  for (const line of String(lines || '').split(/\n/)) {
    const m = /^\s*([^=;\s]+)=([^;]*)/.exec(line);
    if (m) out.push({ name: m[1], value: m[2] });
  }
  return out;
}

// ---------------------------------------------------------------- yardımcılar

const isGameHost = h => h === 'darkorbit.com' || h.endsWith('.darkorbit.com');
const isCdnHost = h => h.endsWith('.bpsecure.com');
const hostOf = u => { try { return new URL(u).hostname.toLowerCase(); } catch { return ''; } };
const TEXT_TYPE = /(text|json|xml|javascript|ecmascript|html|css|x-www-form-urlencoded|svg)/i;

// "gb1.darkorbit.com/indexInternal.es?action=internalDock" biçiminde sayfa anahtarı
export function pageKey(u) {
  try {
    const url = new URL(u);
    const action = url.searchParams.get('action');
    return `${url.host}${url.pathname}${action ? `?action=${action}` : ''}`;
  } catch { return u || '(bilinmiyor)'; }
}

function stamp(d = new Date()) {
  const p = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}${p(d.getMonth() + 1)}${p(d.getDate())}-${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
}

function parseArgs(argv) {
  const a = { port: 9333, host: '127.0.0.1', out: path.join(path.dirname(fileURLToPath(import.meta.url)), '..', 'logs', 'web'), duration: 0, selfTest: false };
  for (let i = 0; i < argv.length; i++) {
    const k = argv[i];
    if (k === '--self-test') a.selfTest = true;
    else if (k === '--port') a.port = Number(argv[++i]);
    else if (k === '--host') a.host = argv[++i];
    else if (k === '--out') a.out = argv[++i];
    else if (k === '--duration') a.duration = Number(argv[++i]);
    else if (/^\d+$/.test(k)) a.port = Number(k);
    else { console.error(`bilinmeyen argüman: ${k}`); process.exit(2); }
  }
  return a;
}

// ---------------------------------------------------------------- kaydedici

async function record(opts) {
  const ver = await (await fetch(`http://${opts.host}:${opts.port}/json/version`)).json();
  const outDir = path.join(opts.out, stamp());
  fs.mkdirSync(path.join(outDir, 'bin'), { recursive: true });
  console.log(`bağlanıldı: ${ver.Browser || '?'} → ${outDir}`);

  const ws = new WebSocket(ver.webSocketDebuggerUrl);
  await new Promise((res, rej) => { ws.addEventListener('open', res); ws.addEventListener('error', rej); });

  let nextId = 0;
  const pending = new Map();
  const send = (method, params = {}, sessionId) => new Promise(resolve => {
    const msg = { id: ++nextId, method, params };
    if (sessionId) msg.sessionId = sessionId;
    pending.set(msg.id, resolve);
    ws.send(JSON.stringify(msg));
  });

  const secrets = createSecrets();
  const attachedTargets = new Set();
  const sessions = new Map(); // sessionId -> { targetId, type, url }
  const reqs = new Map(); // `${sessionId}:${requestId}` -> kayıt
  const inflight = new Set();
  const index = { started: new Date().toISOString(), browser: ver.Browser, pages: {}, cdn: {}, otherHosts: {} };
  let seq = 0;

  const learnCookies = cookies => {
    for (const c of cookies || []) {
      const dom = String(c.domain || '').replace(/^\./, '');
      if (isGameHost(dom) || /bpsecure|bigpoint/i.test(dom) || /dosid|sid|session/i.test(c.name)) secrets.add(c.value);
    }
  };
  const refreshCookies = async () => {
    const r = await send('Storage.getCookies', {});
    if (r.result) learnCookies(r.result.cookies);
  };

  async function onAttached(sessionId, info, waiting) {
    sessions.set(sessionId, { targetId: info.targetId, type: info.type, url: info.url });
    await send('Network.enable', { maxPostDataSize: 1 << 20, maxResourceBufferSize: 64 << 20, maxTotalBufferSize: 256 << 20 }, sessionId);
    await send('Target.setAutoAttach', { autoAttach: true, waitForDebuggerOnStart: true, flatten: true }, sessionId);
    if (waiting) await send('Runtime.runIfWaitingForDebugger', {}, sessionId);
    console.log(`bağlandı [${info.type}] ${maskUrl(info.url, secrets)}`);
  }

  async function attach(info) {
    if (attachedTargets.has(info.targetId) || !['page', 'iframe', 'other'].includes(info.type)) return;
    attachedTargets.add(info.targetId);
    const r = await send('Target.attachToTarget', { targetId: info.targetId, flatten: true });
    if (r.result?.sessionId && !sessions.has(r.result.sessionId)) await onAttached(r.result.sessionId, info, false);
  }

  const touchPage = page => (index.pages[page] ??= { firstSeen: new Date().toISOString(), documents: 0, endpoints: {}, formPosts: {}, files: [] });

  function noteIndex(rec) {
    const pg = touchPage(rec.page);
    if (rec.type === 'Document' && pageKey(rec.url) === rec.page) pg.documents++;
    const u = new URL(rec.url);
    const ep = `${rec.method} ${u.host}${u.pathname}`;
    pg.endpoints[ep] = (pg.endpoints[ep] || 0) + 1;
    if (rec.method === 'POST' && rec.formFields?.length) {
      const set = new Set([...(pg.formPosts[ep] || []), ...rec.formFields]);
      pg.formPosts[ep] = [...set];
    }
    pg.files.push(rec.file);
  }

  let indexTimer = null;
  const writeIndex = () => {
    clearTimeout(indexTimer); indexTimer = null;
    index.updated = new Date().toISOString();
    index.requestCount = seq;
    fs.writeFileSync(path.join(outDir, 'index.json'), JSON.stringify(index, null, 2));
  };
  const scheduleIndex = () => { indexTimer ??= setTimeout(writeIndex, 1000); };

  async function finish(key, sessionId, requestId, failed) {
    const rec = reqs.get(key);
    if (!rec) return;
    reqs.delete(key);
    rec.seq = ++seq;
    const base = `${String(rec.seq).padStart(4, '0')}_${rec.method}_${new URL(rec.url).pathname.split('/').pop().replace(/[^\w.-]+/g, '_') || 'root'}`;
    rec.file = `${base}.json`;
    if (failed) rec.error = failed;
    else if (!rec.redirect) {
      const b = await send('Network.getResponseBody', { requestId }, sessionId);
      if (b.result) {
        if (!b.result.base64Encoded) rec.responseBody = maskText(b.result.body, secrets);
        else {
          const buf = Buffer.from(b.result.body, 'base64');
          const textual = TEXT_TYPE.test(rec.contentType || '');
          if (textual) rec.responseBody = maskText(buf.toString('utf8'), secrets);
          else {
            const ext = (/\/([\w.+-]+)/.exec(rec.contentType || '')?.[1] || 'bin').replace(/[^\w]/g, '');
            rec.responseBodyFile = `bin/${base}.${ext}`;
            rec.responseBodyBytes = buf.length;
            fs.writeFileSync(path.join(outDir, rec.responseBodyFile), buf);
          }
        }
      } else rec.responseBodyError = b.error?.message;
    }
    delete rec._contentType;
    fs.writeFileSync(path.join(outDir, rec.file), JSON.stringify(rec, null, 2));
    noteIndex(rec);
    scheduleIndex();
    console.log(`${String(rec.seq).padStart(4)} ${rec.status ?? '---'} ${rec.method.padEnd(4)} ${rec.type?.padEnd(9) || ''} ${rec.url.slice(0, 140)}`);
  }

  const track = p => { const t = p().catch(e => console.error('hata:', e.message)).finally(() => inflight.delete(t)); inflight.add(t); };

  function newRecord(sessionId, p) {
    const req = p.request;
    const ct = Object.entries(req.headers || {}).find(([k]) => /^content-type$/i.test(k))?.[1] || '';
    const rec = {
      seq: 0,
      time: new Date((p.wallTime || Date.now() / 1000) * 1000).toISOString(),
      page: pageKey(maskUrl(p.documentURL || sessions.get(sessionId)?.url, secrets)),
      pageUrl: maskUrl(p.documentURL, secrets),
      type: p.type,
      method: req.method,
      url: maskUrl(req.url, secrets),
      requestHeaders: maskHeaders(req.headers, secrets),
      requestBody: null,
      status: null,
      contentType: null,
    };
    if (req.hasPostData || req.postData != null) {
      rec._contentType = ct;
      rec.loginPost = isLoginPost(req.method, req.url, req.postData || '', ct);
      rec.formFields = rec.loginPost ? [] : formFieldNames(req.postData || '', ct);
      rec.requestBody = maskPostData(req.method, req.url, req.postData ?? '', ct, secrets);
      if (req.postData == null && req.hasPostData && !rec.loginPost) {
        track(async () => {
          const r = await send('Network.getRequestPostData', { requestId: p.requestId }, sessionId);
          if (r.result?.postData != null) {
            rec.loginPost = isLoginPost(req.method, req.url, r.result.postData, ct);
            rec.formFields = rec.loginPost ? [] : formFieldNames(r.result.postData, ct);
            rec.requestBody = maskPostData(req.method, req.url, r.result.postData, ct, secrets);
          }
        });
      }
    }
    return rec;
  }

  ws.addEventListener('message', ev => {
    const m = JSON.parse(ev.data);
    if (m.id && pending.has(m.id)) { pending.get(m.id)(m); pending.delete(m.id); return; }
    const p = m.params || {};
    const sid = m.sessionId;
    switch (m.method) {
      case 'Target.targetCreated':
      case 'Target.targetInfoChanged':
        if (p.targetInfo.type === 'page') track(() => attach(p.targetInfo));
        for (const s of sessions.values()) if (s.targetId === p.targetInfo.targetId) s.url = p.targetInfo.url;
        break;
      case 'Target.attachedToTarget':
        attachedTargets.add(p.targetInfo.targetId);
        track(() => onAttached(p.sessionId, p.targetInfo, p.waitingForDebugger));
        break;
      case 'Target.detachedFromTarget':
        sessions.delete(p.sessionId);
        break;
      case 'Network.requestWillBeSentExtraInfo':
        learnCookies((p.associatedCookies || []).map(c => c.cookie));
        break;
      case 'Network.responseReceivedExtraInfo': {
        const sc = Object.entries(p.headers || {}).filter(([k]) => /^set-cookie$/i.test(k)).map(([, v]) => v).join('\n');
        for (const c of parseSetCookie(sc)) secrets.add(c.value);
        break;
      }
      case 'Network.requestWillBeSent': {
        const host = hostOf(p.request.url);
        const key = `${sid}:${p.requestId}`;
        if (p.redirectResponse && reqs.has(key)) {
          // önceki atlama 30x ile bitti: ayrı kayıt olarak yaz
          const prev = reqs.get(key);
          prev.status = p.redirectResponse.status;
          prev.contentType = p.redirectResponse.mimeType;
          prev.responseHeaders = maskHeaders(p.redirectResponse.headers, secrets);
          prev.redirect = maskUrl(p.request.url, secrets);
          track(() => finish(key, sid, p.requestId));
        }
        if (isCdnHost(host)) {
          const u = maskUrl(p.request.url, secrets).replace(/\?.*$/, '');
          const e = (index.cdn[u] ??= { type: p.type, count: 0 });
          e.count++;
          scheduleIndex();
          break;
        }
        if (!isGameHost(host)) {
          if (host) index.otherHosts[host] = (index.otherHosts[host] || 0) + 1;
          break;
        }
        if (p.type === 'Document' && sessions.has(sid) && p.frameId === sessions.get(sid).targetId) sessions.get(sid).url = p.request.url;
        // redirect sonrası yeni atlama yeni kayıt olarak başlar
        const rec = newRecord(sid, p);
        reqs.set(key, rec);
        break;
      }
      case 'Network.responseReceived': {
        const rec = reqs.get(`${sid}:${p.requestId}`);
        if (!rec) break;
        rec.status = p.response.status;
        rec.contentType = p.response.mimeType;
        rec.responseHeaders = maskHeaders(p.response.headers, secrets);
        rec.fromCache = !!(p.response.fromDiskCache || p.response.fromServiceWorker);
        break;
      }
      case 'Network.loadingFinished':
        if (reqs.has(`${sid}:${p.requestId}`)) track(() => finish(`${sid}:${p.requestId}`, sid, p.requestId));
        break;
      case 'Network.loadingFailed':
        if (reqs.has(`${sid}:${p.requestId}`)) track(() => finish(`${sid}:${p.requestId}`, sid, p.requestId, p.errorText || 'failed'));
        break;
    }
  });

  await refreshCookies();
  const cookieTimer = setInterval(() => track(refreshCookies), 5000);
  await send('Target.setDiscoverTargets', { discover: true });
  await send('Target.setAutoAttach', { autoAttach: true, waitForDebuggerOnStart: true, flatten: true });
  const t = await send('Target.getTargets');
  for (const info of t.result?.targetInfos || []) await attach(info);
  writeIndex();
  console.log(`kayıt başladı (${secrets.size} çerez değeri maskeleniyor). Durdurmak için Ctrl+C.`);

  let stopping = false;
  const stop = async why => {
    if (stopping) return;
    stopping = true;
    console.log(`durduruluyor (${why})...`);
    clearInterval(cookieTimer);
    await Promise.race([Promise.allSettled([...inflight]), new Promise(r => setTimeout(r, 5000))]);
    writeIndex();
    console.log(`${seq} istek kaydedildi → ${outDir}`);
    process.exit(0);
  };
  process.on('SIGINT', () => stop('Ctrl+C'));
  ws.addEventListener('close', () => stop('DevTools bağlantısı kapandı'));
  if (opts.duration > 0) setTimeout(() => stop('süre doldu'), opts.duration * 1000);
}

// ---------------------------------------------------------------- birim testi

function selfTest() {
  const results = [];
  const check = (name, cond) => { results.push([name, !!cond]); };
  const DOSID = 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6';
  const sec = createSecrets();
  for (const c of parseSetCookie(`dosid=${DOSID}; path=/; domain=.darkorbit.com; HttpOnly\nlang=en; path=/`)) sec.add(c.value);

  // çerez başlıkları
  const h = maskHeaders({ Cookie: `dosid=${DOSID}`, 'Set-Cookie': `dosid=${DOSID}`, 'Content-Type': 'text/html', Location: `/indexInternal.es?action=internalStart&dosid=${DOSID}` }, sec);
  check('Cookie başlığı yazılmıyor', !('cookie' in h));
  check('Set-Cookie başlığı yazılmıyor', !('set-cookie' in h));
  check('Location içindeki dosid maskeli', h.location.includes('dosid=REDACTED') && !h.location.includes(DOSID));
  check('Content-Type korunuyor', h['content-type'] === 'text/html');

  // dosid tam eşleşme (anahtar adı olmadan geçse bile)
  const html = `<script>var x = "${DOSID}"; loadGame('${DOSID}');</script><a href="x?y=1">`;
  check('dosid değeri gövdede tam eşleşmeyle maskeli', !maskText(html, sec).includes(DOSID));
  const sec2 = createSecrets(); sec2.add('Zq9-kL_Pw7');
  check('hex olmayan çerez değeri de maskeli', maskText('foo Zq9-kL_Pw7 bar Zq9-kL_Pw7', sec2) === 'foo REDACTED_COOKIE bar REDACTED_COOKIE');

  // token parametresi ve benzerleri
  const u = maskUrl('https://gb1.darkorbit.com/flashAPI/dailyLogin.php?token=abc123&userID=42&authKey=zz&sig=1&signature=qq', sec);
  check('URL token maskeli', u.includes('token=REDACTED') && !u.includes('abc123'));
  check('URL authKey/signature maskeli', u.includes('authKey=REDACTED') && u.includes('signature=REDACTED'));
  check('URL zararsız parametre korunuyor', u.includes('userID=42'));
  check('form gövdesinde token maskeli', maskText('a=1&reloadToken=xyz&b=2', sec) === 'a=1&reloadToken=REDACTED&b=2');
  check('JSON içinde sessionID maskeli', maskText('{"sessionID":"s3cr3t","credits":100}', sec) === '{"sessionID":"REDACTED","credits":100}');
  check('JS objesinde hash maskeli', !maskText(`{ hash: 'deadbeef', ok: 'x' }`, sec).includes('deadbeef'));
  check('JS atamasında SID maskeli', !maskText(`var SID = 'qwerty123';`, sec).includes('qwerty123'));
  check('HTML input name=sid value maskeli', !maskText('<input type="hidden" value="qwe987" name="sid">', sec).includes('qwe987'));
  check('HTML data-token özniteliği maskeli', !maskText('<div data-token="tk555">', sec).includes('tk555'));
  check('flashvars &amp; içinde sessionID maskeli', !maskText('<param name="flashvars" value="lang=en&amp;sessionID=abc999&amp;pid=502">', sec).includes('abc999'));
  check('XML <sid> maskeli', maskText('<r><sid>zzz</sid><n>1</n></r>', sec) === '<r><sid>REDACTED</sid><n>1</n></r>');
  check('zararsız metin değişmiyor', maskText('<a href="indexInternal.es?action=internalDock">Hangar</a>', sec) === '<a href="indexInternal.es?action=internalDock">Hangar</a>');

  // login POST
  const login = 'loginForm_default_username=pilot&loginForm_default_password=hunter2&loginForm_default_login_submit=Login';
  check('login POST tanınıyor', isLoginPost('POST', 'https://www.darkorbit.com/?interstitialRedirect=1', login, 'application/x-www-form-urlencoded'));
  const lb = maskPostData('POST', 'https://www.darkorbit.com/', login, 'application/x-www-form-urlencoded', sec);
  check('login POST gövdesi yazılmıyor', !lb.includes('pilot') && !lb.includes('hunter2') && /KAYDEDİLMEDİ/.test(lb));
  check('JSON login POST tanınıyor', isLoginPost('POST', 'https://x.darkorbit.com/api', '{"username":"a","password":"b"}', 'application/json'));
  check('login URL POST tanınıyor', isLoginPost('POST', 'https://sas.bpsecure.com/Sas/Authentication/Bigpoint?authUser=1', 'x=1', ''));
  check('normal POST login sayılmıyor', !isLoginPost('POST', 'https://gb1.darkorbit.com/ajax/shop.php', 'action=buy&itemId=12&amount=1&userID=5', ''));
  check('normal POST maskelenip korunuyor', maskPostData('POST', 'https://gb1.darkorbit.com/ajax/shop.php', 'action=buy&itemId=12&sid=99', '', sec) === 'action=buy&itemId=12&sid=REDACTED');

  check('pageKey action', pageKey('https://gb1.darkorbit.com/indexInternal.es?action=internalDock&sid=REDACTED') === 'gb1.darkorbit.com/indexInternal.es?action=internalDock');

  let fail = 0;
  for (const [n, ok] of results) { console.log(`${ok ? 'OK  ' : 'FAIL'} ${n}`); if (!ok) fail++; }
  console.log(`${results.length - fail}/${results.length} geçti`);
  process.exit(fail ? 1 : 0);
}

// ---------------------------------------------------------------- giriş

if (process.argv[1] && import.meta.url === pathToFileURL(path.resolve(process.argv[1])).href) {
  const opts = parseArgs(process.argv.slice(2));
  if (opts.selfTest) selfTest();
  else record(opts).catch(e => { console.error(`bağlanılamadı (${opts.host}:${opts.port}): ${e.message}`); process.exit(1); });
}
