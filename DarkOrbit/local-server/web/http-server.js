'use strict';
// Launcher'ın açtığı web katmanı: login sayfası, oyun sayfası, statik
// istemci dosyaları. Bilinmeyen her istek logs/http-requests.log'a yazılır;
// böylece Flash istemcisinin hangi dosya/endpoint'leri istediği görülür.

const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { createCdnCache } = require('./cdn-cache');
const { createBootApi } = require('./boot-api');

const PUBLIC_DIR = path.join(__dirname, 'public');
const CLIENT_DIR = path.join(__dirname, '..', 'client');

const MIME = {
  '.html': 'text/html; charset=utf-8', '.js': 'application/javascript',
  '.css': 'text/css', '.swf': 'application/x-shockwave-flash',
  '.xml': 'text/xml', '.json': 'application/json', '.png': 'image/png',
  '.jpg': 'image/jpeg', '.gif': 'image/gif', '.mp3': 'audio/mpeg',
  '.ico': 'image/x-icon', '.txt': 'text/plain', '.jpeg': 'image/jpeg', '.webp': 'image/webp',
  '.svg': 'image/svg+xml', '.woff': 'font/woff', '.woff2': 'font/woff2', '.ttf': 'font/ttf', '.otf': 'font/otf',
  '.ogg': 'audio/ogg', '.mp4': 'video/mp4'
};

const auth = require('../game/auth');
const players = require('../game/db/players');
const portal = require('./portal/render');
const economy = require('../game/economy');
const World = require('../game/world');
const inventoryApi = require('./inventory-api');

// Oyuncu oyundaysa bellekteki güncel kopya, değilse DB'deki hali.
function currentPlayer(playerId) {
  const w = World.current();
  return (w && w.livePlayer(playerId)) || players.loadPlayer(playerId);
}

const START_PAGE = '/indexInternal.es?action=internalStart';
const CHOOSE_PAGE = '/indexInternal.es?action=internalCompanyChoose';

function parseCookies(req) {
  const out = Object.create(null);
  (req.headers.cookie || '').split(';').forEach(p => {
    const i = p.indexOf('=');
    if (i > 0) {
      try { out[p.slice(0, i).trim()] = decodeURIComponent(p.slice(i + 1).trim()); }
      catch { /* An invalid cookie is not a valid session. */ }
    }
  });
  return out;
}

function readBody(req, maxBytes = 256 * 1024) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    let bytes = 0;
    let failed = false;
    req.on('data', c => {
      bytes += Buffer.byteLength(c);
      if (bytes > maxBytes) {
        if (!failed) reject(Object.assign(new Error('İstek gövdesi çok büyük.'), { statusCode: 413 }));
        failed = true;
        chunks.length = 0;
      } else if (!failed) chunks.push(Buffer.from(c));
    });
    req.on('end', () => { if (!failed) resolve(new URLSearchParams(Buffer.concat(chunks).toString('utf8'))); });
    req.on('error', reject);
    req.on('aborted', () => reject(Object.assign(new Error('İstek iptal edildi.'), { statusCode: 400 })));
  });
}

function fill(template, vars) {
  return template.replace(/\{(\w+)\}/g, (m, k) => (k in vars ? String(vars[k]) : m));
}

function sendFile(res, file) {
  fs.readFile(file, (err, buf) => {
    if (err) return notFound(res);
    res.writeHead(200, { 'Content-Type': MIME[path.extname(file).toLowerCase()] || 'application/octet-stream' });
    res.end(buf);
  });
}

function notFound(res) {
  res.writeHead(404, { 'Content-Type': 'text/plain' });
  res.end('not found');
}

function safeJoin(root, urlPath) {
  if (urlPath.includes('\0')) return null;
  const relative = urlPath.replace(/^\/+/, '');
  if (path.isAbsolute(relative) || path.win32.isAbsolute(relative)) return null;
  const p = path.resolve(root, relative);
  const rel = path.relative(root, p);
  return rel === '' || (!rel.startsWith('..' + path.sep) && rel !== '..' && !path.isAbsolute(rel)) ? p : null;
}

function createHandler(config, logDir) {
  const logFile = path.join(logDir, 'http-requests.log');
  let httpBase = `http://${config.http.host}:${config.http.port}`;
  // HCSFP32.dll kök SWF'yi http üzerinden reddediyor ("Root Movie Blocked"); SWF'ler https'ten sunulur.
  let httpsBase = config.https ? `https://${config.http.host}:${config.https.port}` : httpBase;

  function log(req, status, note) {
    if (req.method === 'HEAD') return; // sağlık kontrolü yoklamaları
    const cleanUrl = req.url.replace(/([?&](?:sid|dosid|sessionID|token|auth|key)=)[^&]*/gi, '$1REDACTED');
    const line = `${new Date().toISOString()} ${status} ${req.method} ${cleanUrl} ua="${(req.headers['user-agent'] || '').replace(/[\r\n]/g, '')}"${note ? ' ' + note : ''}\n`;
    fs.appendFile(logFile, line, () => {});
    process.stdout.write('[http] ' + line);
  }

  const cdnCache = createCdnCache(config.cdnCache || { enabled: false, upstream: '' },
    msg => { const line = `${new Date().toISOString()} ${msg}
`; fs.appendFile(logFile, line, () => {}); process.stdout.write('[cdn] ' + line); });

  let bootApi = createBootApi(config, httpBase);
  // Oyun sunucusu (host) kökündeki statik dosyalar (ör. /eurostileFonts.swf) için aynı öğrenen önbellek.
  const HOST_DIR = path.join(CLIENT_DIR, '_host');
  const hostCache = createCdnCache(config.hostCache || { enabled: false, upstream: '' },
    msg => { const line = `${new Date().toISOString()} host-${msg}
`; fs.appendFile(logFile, line, () => {}); process.stdout.write('[host] ' + line); });

  function gamePage(sessionId, playerId) {
    const player = currentPlayer(playerId);
    const vars = {
      userId: playerId, sessionId, lang: config.player.lang,
      gameHost: config.game.host, gamePort: config.game.port, httpBase, httpsBase, mapId: player.mapId
    };
    const flashvars = Object.entries(config.client.flashvars)
      .filter(([k]) => !k.startsWith('_'))
      .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(k === 'mapID' ? player.mapId : k === 'display2d' ? require('../game/client-view').mode(playerId, config) : fill(String(v), vars))}`)
      .join('&');
    const tpl = fs.readFileSync(path.join(PUBLIC_DIR, 'game.html'), 'utf8');
    return fill(tpl, {
      swf: fill(config.client.swf, vars), width: config.client.width, height: config.client.height,
      flashvars, userId: playerId, instanceId: config.player.instanceId, displayMode: require('../game/client-view').mode(playerId, config)
    });
  }

  async function handler(req, res) {
    const actualBase = `http://${config.http.host}:${config.http.port}`;
    if (actualBase !== httpBase) {
      httpBase = actualBase;
      httpsBase = config.https ? `https://${config.http.host}:${config.https.port}` : httpBase;
      bootApi = createBootApi(config, httpBase);
    }
    const url = new URL(req.url, httpBase);
    let pathname;
    try { pathname = decodeURIComponent(url.pathname); }
    catch { throw Object.assign(new Error('Geçersiz URL kodlaması.'), { statusCode: 400 }); }
    // Route matching remains on the URL object; file paths are decoded exactly once below.
    const cookies = parseCookies(req);
    const sessionId = auth.get(cookies.dosid) ? cookies.dosid : null;
    const sess = auth.get(sessionId);
    const redirect = (to, note, extra = {}) => { log(req, 302, note); res.writeHead(302, { Location: to, ...extra }); res.end(); };

    if (url.pathname === '/health') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ service: 'darkorbit-local', status: 'ok', mode: 'solo', gamePort: config.game.port }));
    }
    if(url.pathname==='/ajax/upgrade-bulk.php'){
      if(req.method!=='POST'){res.writeHead(405,{'Content-Type':'application/json',Allow:'POST'});return res.end(JSON.stringify({ok:false,message:'POST gerekli.'}));}
      if(!sess?.playerId){res.writeHead(401,{'Content-Type':'application/json'});return res.end(JSON.stringify({ok:false,message:'Giriş gerekli.'}));}
      const origin=req.headers.origin;
      if(origin&&origin!==httpBase&&origin!==httpsBase){res.writeHead(403,{'Content-Type':'application/json'});return res.end(JSON.stringify({ok:false,message:'Geçersiz kaynak.'}));}
      const result=require('./upgrade-bulk-api').handle(sess.playerId,await readBody(req,4096));
      // Flash URLLoader reports HTTP 4xx as an I/O failure without exposing
      // the business error JSON to its COMPLETE listener.
      log(req,200,result.ok?'UPGRADE-BULK':'UPGRADE-BULK rejected');res.writeHead(200,{'Content-Type':'application/json'});return res.end(JSON.stringify(result));
    }
    if (url.pathname === '/api/client-view' && req.method === 'GET') {
      res.writeHead(sess?.playerId ? 200 : 401, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' });
      return res.end(JSON.stringify(sess?.playerId ? { display2d: require('../game/client-view').mode(sess.playerId, config) } : { error: 'Giriş gerekli.' }));
    }

    // Ana sayfa: oturum yoksa login, oyuncu yoksa fraksiyon seçimi, varsa oyun.
    if (url.pathname === '/') {
      return redirect(!sess ? '/login' : sess.playerId ? START_PAGE : CHOOSE_PAGE);
    }

    if (url.pathname === '/login' && req.method === 'GET') {
      log(req, 200);
      return sendFile(res, path.join(PUBLIC_DIR, 'login.html'));
    }

    // Giriş: hesap yoksa oluşturulur, varsa şifre doğrulanır. Şifre loglanmaz.
    if (url.pathname === '/login' && req.method === 'POST') {
      const body = await readBody(req);
      const username = (body.get('username') || '').trim();
      const password = body.get('password') || '';
      if (!/^[\p{L}\p{N}_ .\-]{3,20}$/u.test(username) || password.length < 4 || password.length > 256) return redirect('/login?error=invalid', 'login invalid');
      let account = players.findAccount(username);
      if (!account) {
        players.createAccount(username, password);
        account = players.findAccount(username);
        log(req, 201, `hesap oluşturuldu user="${username}"`);
      } else if (!players.checkPassword(password, account.password_hash)) {
        return redirect('/login?error=password', `login wrong-password user="${username}"`);
      }
      const playerId = players.playerForAccount(account.id);
      if (sessionId) auth.destroy(sessionId);
      const sid = auth.create(account.id, playerId);
      return redirect(playerId ? START_PAGE : CHOOSE_PAGE, `login user="${username}"`, { 'Set-Cookie': `dosid=${sid}; Path=/; HttpOnly; SameSite=Lax` });
    }

    if (url.pathname === '/logout') {
      auth.destroy(sessionId);
      return redirect('/login', null, { 'Set-Cookie': 'dosid=; Path=/; Max-Age=0' });
    }

    // İlk girişte fraksiyon seçimi; oyuncu ve başlangıç paketi oluşturulur.
    if (url.pathname === '/faction') {
      if (!sess) return redirect('/login', 'no session');
      if (sess.playerId) return redirect('/game');
      if (req.method === 'POST') {
        const factionId = Number((await readBody(req)).get('faction'));
        if (![1, 2, 3].includes(factionId)) return redirect('/faction', 'faction invalid');
        const account = require('../game/db').open().prepare('SELECT username FROM accounts WHERE id = ?').get(sess.accountId);
        auth.setPlayer(sessionId, players.createPlayer(sess.accountId, account.username, factionId, config.starter));
        return redirect('/game', `oyuncu oluşturuldu faction=${factionId}`);
      }
      log(req, 200);
      return sendFile(res, path.join(PUBLIC_DIR, 'faction.html'));
    }

    // Portal: canlıdan kaydedilen sayfalar (web/portal), oyuncunun DB değerleriyle.
    if (url.pathname === '/indexInternal.es' || url.pathname === '/index.es') {
      if (!sess) return redirect('/login', 'no session');
      const action = url.searchParams.get('action') || 'internalStart';
      const tpl = url.searchParams.get('tpl');
      if (action === 'externalLogout') {
        auth.destroy(sessionId);
        return redirect('/login', 'logout', { 'Set-Cookie': 'dosid=; Path=/; Max-Age=0' });
      }
      // Şirket seçimi: canlıda XHR ({"status":"OK"}) ya da bağlantı olarak çağrılıyor.
      if (action === 'internalCompanyChoose' && url.searchParams.get('subaction') === 'factionChoose') {
        const factionId = Number(url.searchParams.get('factionID'));
        if (!sess.playerId && [1, 2, 3].includes(factionId)) {
          const account = require('../game/db').open().prepare('SELECT username FROM accounts WHERE id = ?').get(sess.accountId);
          auth.setPlayer(sessionId, players.createPlayer(sess.accountId, account.username, factionId, config.starter));
          log(req, 200, `oyuncu oluşturuldu faction=${factionId}`);
        }
        if (req.headers['x-requested-with'] === 'XMLHttpRequest') {
          res.writeHead(200, { 'Content-Type': 'application/json' });
          return res.end(JSON.stringify({ status: 'OK' }));
        }
        return redirect(START_PAGE);
      }
      if (!sess.playerId) {
        log(req, 200, 'company-choose');
        res.writeHead(200, { 'Content-Type': MIME['.html'] });
        return res.end(portal.renderPage('internalCompanyChoose', null, null, httpBase));
      }
      // Oyun istemcisi: canlıdaki "Start" bu sayfayı yeni pencerede açar.
      if (action === 'internalMapRevolution') {
        log(req, 200, 'game');
        res.writeHead(200, { 'Content-Type': MIME['.html'] });
        return res.end(gamePage(sessionId, sess.playerId));
      }
      if (action === 'internalItemUpgrade') {
        const api = require('./upgrade-api');
        const params = req.method === 'POST' ? await readBody(req) : new URLSearchParams();
        const result = api.handle(sess.playerId, params);
        res.writeHead(result.ok ? 200 : 400, { 'Content-Type': MIME['.html'], 'Cache-Control': 'no-store' });
        log(req, result.ok ? 200 : 400, `UPGRADE ${params.get('subaction') || 'view'}`);
        return res.end(api.render(currentPlayer(sess.playerId), { result }));
      }
      if (action === 'internalPaymentEvents') {
        const api=require('../game/payment-events');
        const params=req.method==='POST'?await readBody(req):new URLSearchParams();
        const result=api.handle(sess.playerId,params);
        log(req,result.ok?200:400,`PAYMENT-EVENT ${params.get('subaction')||'view'}`);
        res.writeHead(result.ok?200:400,{'Content-Type':MIME['.html'],'Cache-Control':'no-store'});
        return res.end(api.render(currentPlayer(sess.playerId),result));
      }
      if (action === 'internalAssembly') {
        const api=require('./assembly-api'),params=req.method==='POST'?await readBody(req):new URLSearchParams(),result=api.handle(sess.playerId,params);
        log(req,result.ok?200:400,`ASSEMBLY ${params.get('subaction')||'view'}`);
        res.writeHead(result.ok?200:400,{'Content-Type':MIME['.html'],'Cache-Control':'no-store'});
        return res.end(api.render(currentPlayer(sess.playerId),result));
      }
      if (action === 'internalCompanyChoose' || !portal.hasPage(action, tpl)) {
        return redirect(START_PAGE, `portal sayfası yok: ${action}${tpl ? '~' + tpl : ''}`);
      }
      if (action === 'internalSkylab') {
        const params = new URLSearchParams(url.searchParams);
        if (req.method === 'POST') for (const [k, v] of await readBody(req)) params.set(k, v);
        const api = require('./skylab-api');
        const result = api.handle(sess.playerId, params);
        const player = currentPlayer(sess.playerId);
        const html = api.render(player, portal.renderPage(action, tpl, player, httpBase), { state: result.state, message: result.message });
        log(req, result.status || 200, `SKYLAB ${params.get('subaction') || 'view'}`);
        res.writeHead(result.status || 200, { 'Content-Type': MIME['.html'] });
        return res.end(html);
      }
      log(req, 200, 'PORTAL');
      res.writeHead(200, { 'Content-Type': MIME['.html'] });
      return res.end(portal.renderPage(action, tpl, currentPlayer(sess.playerId), httpBase));
    }

    // Native header hangar expansion; mutations are POST/XHR only, independent
    // from ship purchases and inventory.swf's original ship-based hangar ids.
    if(url.pathname==='/ajax/hangar.php'){
      res.setHeader('Content-Type','application/json; charset=utf-8');res.setHeader('Cache-Control','no-store');
      if(!sess?.playerId){res.writeHead(401);return res.end(JSON.stringify({result:'error',message:'Giriş gerekli.'}));}
      if(!['GET','POST'].includes(req.method)){res.writeHead(405);return res.end(JSON.stringify({result:'error',message:'Geçersiz yöntem.'}));}
      const api=require('./hangar-api');
      if(req.method==='GET'){res.writeHead(200);return res.end(JSON.stringify({result:'success',state:api.state(sess.playerId)}));}
      if(String(req.headers['x-requested-with']||'').toLowerCase()!=='xmlhttprequest'){res.writeHead(403);return res.end(JSON.stringify({result:'error',message:'Hangar işlemini oyun sayfasından başlat.'}));}
      const body=await readBody(req),out=api.handle(sess.playerId,body);log(req,200,'HANGAR '+body.get('action')+' -> '+out.result);
      res.writeHead(200);return res.end(JSON.stringify(out));
    }

    // Dükkan: satın alma ve otomatik takma (resources/js/shop.js: action=purchase|equipItems).
    if (url.pathname === '/ajax/shop.php' && req.method === 'POST' && sess && sess.playerId) {
      const body = await readBody(req);
      const action = body.get('action');
      let out;
      if (action === 'purchase') out = economy.purchase(sess.playerId, body.get('itemId'), body.get('amount'), body.get('category'),body.get('level'));
      else if (action === 'equipItems') out = economy.equip(sess.playerId, body.get('itemId'), body.get('amount'));
      else out = { result: 'error', message: `Desteklenmeyen işlem: ${action}` };
      log(req, 200, `SHOP ${action} ${body.get('itemId')} x${body.get('amount')} -> ${out.result}`);
      res.writeHead(200, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify(out));
    }

    // Portalın ajax/flashAPI uçları: kayıtlı cevaplar (kişiselleştirilmiş).
    if (sess && sess.playerId && /^\/(ajax|flashAPI)\/\w+\.php$/.test(url.pathname) && !bootApi.has(url.pathname)) {
      const body = req.method === 'POST' ? await readBody(req) : url.searchParams;
      const sub = body.get('action') || body.get('command') || '';
      const skillsOut = require('./skills-api').handle(sess.playerId, url.pathname, body);
      if (skillsOut) {
        log(req, 200, `SKILLS ${sub}`);
        res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
        return res.end(JSON.stringify(skillsOut));
      }
      let detail = '';
      if (body.get('params')) {
        try { detail = JSON.parse(Buffer.from(body.get('params'), 'base64').toString()).params?.lootId || ''; } catch { /* yok */ }
      }
      // Hangar: DB'den üretilen cevaplar (web/inventory-api.js).
      const db = url.pathname === '/flashAPI/inventory.php' && inventoryApi.handle(sess.playerId, body);
      if (db) {
        log(req, 200, `INVENTORY ${sub} ${detail}`);
        res.writeHead(200, { 'Content-Type': db.contentType });
        return res.end(db.body);
      }
      const out = portal.renderAjax([url.pathname, sub, detail].filter(Boolean).join('|'), currentPlayer(sess.playerId))
        || portal.renderAjax([url.pathname, sub].filter(Boolean).join('|'), currentPlayer(sess.playerId));
      if (out) {
        log(req, 200, `PORTAL-AJAX ${sub} ${detail}`);
        res.writeHead(200, { 'Content-Type': out.contentType });
        return res.end(out.body);
      }
      // Karşılığı olmayan eylem: istemciye hata mesajı (genel "bilinmeyen hata" yerine) ve log.
      log(req, 200, `UNHANDLED-AJAX ${sub} ${detail}`);
      if (url.pathname === '/flashAPI/inventory.php') {
        res.writeHead(200, { 'Content-Type': 'text/html' });
        return res.end(Buffer.from(JSON.stringify({ isError: 1, error: { message: `Local sunucu bu işlemi henüz desteklemiyor: ${sub}` } })).toString('base64'));
      }
      res.writeHead(200, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ result: 'error', isError: 1, message: `Local sunucu bu işlemi henüz desteklemiyor: ${sub}` }));
    }

    if (url.pathname === '/game') {
      if (!sess) return redirect('/login', 'no session');
      if (!sess.playerId) return redirect('/faction');
      log(req, 200);
      res.writeHead(200, { 'Content-Type': MIME['.html'] });
      return res.end(gamePage(sessionId, sess.playerId));
    }

    // Açılış endpoint'leri (maps.php, profile.xml, flashAPI/*).
    if (bootApi.handle(url.pathname, req, res, {playerId: sess?.playerId})) {
      log(req, 200, 'BOOT-API');
      return;
    }

    // Flash istemci dosyaları: local-server/client/ altına konur.
    if (url.pathname.startsWith('/client/')) {
      const relPath = pathname.slice('/client/'.length);
      const file = safeJoin(CLIENT_DIR, relPath);
      if (file && fs.existsSync(file) && fs.statSync(file).isFile()) {
        log(req, 200);
        return sendFile(res, file);
      }
      // Öğrenen önbellek: eksik dosyayı CDN'den bir kez indirip kaydet.
      if (file && relPath && await cdnCache.fetchMissing(relPath, file)) {
        log(req, 200, 'FETCHED-FROM-CDN');
        return sendFile(res, file);
      }
      log(req, 404, 'MISSING-CLIENT-FILE');
      return notFound(res);
    }

    // Flash HTTP cross-domain policy.
    if (url.pathname === '/crossdomain.xml') {
      log(req, 200);
      res.writeHead(200, { 'Content-Type': 'text/xml' });
      return res.end('<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" /></cross-domain-policy>');
    }

    // Statik dosyalar (login.html için js/css vb.)
    const pub = safeJoin(PUBLIC_DIR, pathname);
    if (pub && fs.existsSync(pub) && fs.statSync(pub).isFile()) {
      log(req, 200);
      return sendFile(res, pub);
    }

    // Host kökündeki statik varlıklar: client/_host/ altında önbelleklenir.
    // Sunucunun sorguya göre ürettiği yazı resimleri (.esg): sorgu özetiyle ayrı dosyalarda önbelleklenir.
    if (/\.esg$/i.test(url.pathname)) {
      const relPath = pathname.replace(/^\/+/, '');
      const query = url.search.slice(1);
      const file = safeJoin(HOST_DIR, `${relPath}.${crypto.createHash('sha1').update(query).digest('hex').slice(0, 12)}.png`);
      if (file && (fs.existsSync(file) || await hostCache.fetchMissing(relPath, file, query))) {
        log(req, 200, 'HOST-ESG');
        return sendFile(res, file);
      }
    }

    if (/\.(swf|xml|png|jpe?g|gif|mp3|js|css|svg|ico|woff2?|ttf|otf)$/i.test(url.pathname)) {
      const relPath = pathname.replace(/^\/+/, '');
      const file = safeJoin(HOST_DIR, relPath);
      if (file && (fs.existsSync(file) || await hostCache.fetchMissing(relPath, file))) {
        log(req, 200, 'HOST-STATIC');
        return sendFile(res, file);
      }
    }

    // Henüz uygulanmamış endpoint: kaydet, istemcinin ne beklediğini buradan çıkar.
    log(req, 404, 'UNHANDLED');
    notFound(res);
  }

  return function safeHandler(req, res) {
    res.setHeader?.('X-Content-Type-Options', 'nosniff');
    res.setHeader?.('Cache-Control', 'no-store');
    return Promise.resolve().then(() => handler(req, res)).catch(err => {
      const status = err.statusCode || 500;
      log(req, status, status === 500 ? 'REQUEST-ERROR' : err.message);
      if (status === 500) console.error('[http] İstek işlenemedi:', err.message);
      if (res.headersSent) { res.destroy?.(); return; }
      res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ result: 'error', isError: 1, message: status === 500 ? 'İşlem tamamlanamadı.' : err.message }));
    });
  };
}

function start(config, logDir) {
  const handler = createHandler(config, logDir);
  const server = http.createServer(handler);
  server.requestTimeout = 15_000;
  server.headersTimeout = 10_000;
  server.on('error', err => console.error('[http]', err.message));
  server.listen(config.http.port, config.http.host, () => {
    config.http.port = server.address().port;
    console.log(`[http] http://${config.http.host}:${server.address().port} dinleniyor`);
  });

  if (config.https) {
    const certDir = path.join(__dirname, '..', 'certs');
    const tls = { key: fs.readFileSync(path.join(certDir, 'key.pem')), cert: fs.readFileSync(path.join(certDir, 'cert.pem')) };
    const tlsServer = https.createServer(tls, handler);
    tlsServer.on('error', err => console.error('[https]', err.message));
    tlsServer.listen(config.https.port, config.http.host, () => {
      console.log(`[https] https://${config.http.host}:${config.https.port} dinleniyor`);
    });
    server.tlsServer = tlsServer;
  }
  return server;
}

module.exports = { start, createHandler, parseCookies, safeJoin, readBody };
