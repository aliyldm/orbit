'use strict';
// İstemcinin açılışta oyun sunucusundan (host) istediği endpoint'lerin local taklitleri.
// Cevap yapıları canlı sunucudan maskelenerek kaydedildi (docs/live-observation.md);
// stubs/ altındaki dosyalar o kayıtlardan üretildi.

const fs = require('fs');
const path = require('path');

const STUBS = path.join(__dirname, 'stubs');
const readStub = name => fs.readFileSync(path.join(STUBS, name), 'utf8');

function createBootApi(config, httpBase) {
  const cdn = `${httpBase}/client/`;
  const mapIds = JSON.parse(readStub('map-ids.json'));

  function send(res, status, type, body) {
    res.writeHead(status, { 'Content-Type': type, 'Cache-Control': 'no-store' });
    res.end(body);
  }

  // Tüm haritalar local oyun soketine yönlendirilir (canlıda gameserver-502-0N...:610N).
  function mapsXml() {
    const server = `${config.game.host}:${config.game.port}`;
    const maps = mapIds.map(id => ` <map id="${id}">\n  <gameserverIP>${server}</gameserverIP>\n </map>`).join('\n');
    return `<maps>\n${maps}\n</maps>`;
  }

  const routes = {
    '/spacemap/xml/maps.php': (req, res) => send(res, 200, 'text/xml;charset=UTF-8', mapsXml()),
    '/spacemap/xml/profile.xml': (req, res) => send(res, 200, 'application/xml', readStub('profile.xml')),
    '/flashAPI/dailyLogin.php': (req, res, context) => {
      if (!context?.playerId) return send(res, 401, 'application/json', JSON.stringify({ isError: 1, message: 'Giriş gerekli.' }));
      const db = require('../game/db').open(), rewards = require('../game/native-rewards'), events = require('../game/payment-events');
      const url = new URL(req.url, httpBase);
      if (url.searchParams.get('doBook') === '1') {
        if (req.method !== 'POST') return send(res, 405, 'application/json', JSON.stringify({ isError: 1, message: 'POST gerekli.' }));
        const origin = req.headers?.origin;
        if (origin && origin !== httpBase && origin !== httpBase.replace(/^http:/, 'https:')) return send(res, 403, 'application/json', JSON.stringify({ isError: 1, message: 'Geçersiz kaynak.' }));
        try {
          db.exec('SAVEPOINT daily_http');
          let result;
          try { events.preserveLive(db, context.playerId); result = rewards.dailyClaim(db, context.playerId); db.exec('RELEASE daily_http'); }
          catch (error) { db.exec('ROLLBACK TO daily_http; RELEASE daily_http'); throw error; }
          if (!result.repeated) events.notify(context.playerId);
          // The supplied LoginBonusBookCommand uses flash.display.Loader,
          // not URLLoader. JSON is an invalid image and raises a decode error.
          return send(res, 200, 'image/gif', Buffer.from('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7','base64'));
        } catch (error) { return send(res, 200, 'application/json', JSON.stringify({ isError: 1, message: error.message })); }
      }
      send(res, 200, 'application/json', JSON.stringify(rewards.dailyJson(db, context.playerId, cdn)));
    },
    // Canlıda POST action=setClientBrowserConfig; cevap her zaman başarı.
    '/flashAPI/loadingScreen.php': (req, res) =>
      send(res, 200, 'text/html; charset=UTF-8', JSON.stringify({ isError: 0, data: { ret: '{"result": "success"}' } })),
    // Native CommandCenter loads this separately from its TCP event activation.
    '/flashAPI/brNews.php': (req, res, context) => {
      if (!context?.playerId) return send(res, 401, 'text/xml; charset=utf-8', '<root/>');
      send(res, 200, 'text/xml; charset=utf-8', require('../game/command-center').feed());
    }
  };

  // Eşleşen bir route varsa cevaplar ve true döner.
  function handle(pathname, req, res, context = {}) {
    const route = routes[pathname];
    if (!route) return false;
    route(req, res, context);
    return true;
  }

  return { handle, has: pathname => pathname in routes };
}

module.exports = { createBootApi };
