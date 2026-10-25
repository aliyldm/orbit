'use strict';
const { test, before, after, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { EventEmitter } = require('events');
const database = require('../game/db');
const players = require('../game/db/players');
const auth = require('../game/auth');
const World = require('../game/world');
const protocol = require('../game/protocol');
const codec = require('../game/codec/codec');
const { createHandler, safeJoin } = require('../web/http-server');
const config = structuredClone(require('../config.json'));
config.cdnCache.enabled = false; config.hostCache.enabled = false;
config.starter.credits = 1000000;
let db, handler, logDir, serial = 0;
const world = World.instance(config);
before(() => {
  db = database.open(':memory:');
  logDir = fs.mkdtempSync(path.join(os.tmpdir(), 'darkorbit-http-test-'));
  handler = createHandler(config, logDir);
});
afterEach(() => { for (const s of [...world.sessions]) s.close(); });
after(async () => {
  database.close();
  // appendFile logging callbacks finish before the temporary directory is removed.
  await new Promise(resolve => setTimeout(resolve, 50));
  for (const file of fs.readdirSync(logDir)) fs.unlinkSync(path.join(logDir, file));
  fs.rmdirSync(logDir);
});

function request(url, { method = 'GET', cookie = '', body } = {}) {
  return new Promise((resolve, reject) => {
    const req = new EventEmitter();
    Object.assign(req, { url, method, headers: { cookie } });
    const res = { headers: {}, headersSent: false,
      setHeader(k, v) { this.headers[k] = v; },
      writeHead(status, headers) { this.status = status; Object.assign(this.headers, headers); this.headersSent = true; },
      end(data) { resolve({ status: this.status, headers: this.headers, body: String(data || '') }); },
      destroy() { reject(new Error('Unexpected response destruction')); }
    };
    handler(req, res).catch(reject);
    setImmediate(() => { if (body) req.emit('data', Buffer.from(body)); req.emit('end'); });
  });
}
async function account(faction = 1) {
  const login = await request('/login', { method: 'POST', body: new URLSearchParams({ username: `integration${++serial}`, password: 'testpass' }).toString() });
  assert.equal(login.status, 302);
  const cookie = login.headers['Set-Cookie'].split(';')[0];
  await request(`/indexInternal.es?action=internalCompanyChoose&subaction=factionChoose&factionID=${faction}`, { cookie });
  const page = await request('/indexInternal.es?action=internalMapRevolution', { cookie });
  assert.equal(page.status, 200);
  const vars = new URLSearchParams(page.body.match(/name="flashvars" value="([^"]+)"/)[1]);
  return { cookie, userId: Number(vars.get('userID')), sid: vars.get('sessionID'), vars };
}
function session() {
  const commands = [];
  const s = { id: ++serial, world, commands, closeCount: 0,
    send(buf) {
      const size = buf.readUIntBE(0, 3);
      assert.equal(size, buf.length - 3);
      const decoded = codec.decode(buf.subarray(3));
      assert.equal(decoded.rest, 0);
      commands.push(decoded.obj);
    },
    close() { this.closeCount++; auth.unbind(this); world.removeSession(this); }
  };
  return s;
}
function dispatch(s, cmd) { return protocol.handle(s, { raw: codec.encode(cmd) }); }
function login(s, a) {
  dispatch(s, { _: 'LoginRequest', userID: a.userId, sessionID: a.sid, factionID: 1, version: 'do-lz4-block-v3', instanceId: 502, isMiniClient: true });
}

test('invalid cookies and URL encoding cannot escape the HTTP error boundary', async () => {
  assert.equal((await request('/login', { cookie: 'dosid=%ZZ' })).status, 200);
  assert.equal((await request('/client/%ZZ')).status, 400);
  assert.equal((await request('/health')).status, 200);
  const base = path.resolve('client');
  assert.equal(safeJoin(base, '../client-other/private.xml'), null);
  assert.equal(safeJoin(base, '../data/darkorbit.db'), null);
  assert.equal(safeJoin(base, 'C:\\Windows\\win.ini'), null);
});

test('oversized form bodies are rejected before account creation', async () => {
  const before = db.prepare('SELECT COUNT(*) n FROM accounts').get().n;
  const response = await request('/login', { method: 'POST', body: 'username=toolarge&password=' + 'x'.repeat(300000) });
  assert.equal(response.status, 413);
  assert.equal(db.prepare('SELECT COUNT(*) n FROM accounts').get().n, before);
});

test('complete web -> authenticated protocol -> owned DB initialization works for all factions', async () => {
  for (const faction of [1, 2, 3]) {
    const a = await account(faction), s = session();
    assert.equal(Number(a.vars.get('mapID')), (faction - 1) * 4 + 1);
    login(s, a);
    const init = s.commands.find(c => c._ === 'ShipInitializationCommand');
    assert.equal(init.userId, a.userId);
    assert.equal(init.factionId, faction);
    assert.equal(init.mapId, (faction - 1) * 4 + 1);
    assert.ok(init.cargoSpace > 0, 'fresh ship has free cargo');
    assert.ok(s.commands.some(c => c._ === 'JumpgateCreateCommand'));
    assert.equal(s.commands.filter(c => c._ === 'UserSettingsCommand').length, 1);
    assert.equal(s.commands.filter(c => c._ === 'HangarShipsCommand').length, 1);
    for (const type of ['ChatParamCommand', 'MiniClientRewardInfoCommand', 'UpdateSpaceSearchKeyCommand'])
      assert.equal(s.commands.some(c => c._ === type), false, `fresh local account must not inherit ${type}`);
    const events=s.commands.filter(c=>c._==='EventUpdateCommand');assert.equal(events.length,1);
    assert.ok(events[0].activeCommands.every(c=>c.type.startsWith('BE_local_')),'only generated local notices are active');
    const moduleBadges=s.commands.filter(c=>c._==='ShipUpgradeModuleUpdateCommand');assert.equal(moduleBadges.length,1);assert.equal(moduleBadges[0].uid,init.userId);assert.deepEqual(moduleBadges[0].moduleTypeIds,[]);
    const boosters = s.commands.find(c => c._ === 'AttributeBoosterUpdateCommand');
    assert.ok(boosters.boostedAttributes.every(c => c.value === 0));
    assert.deepEqual(boosters.boostedDetailsUpdate, []);
    const menu = s.commands.find(c => c._ === 'MenuInitializationCommand');
    const extras = [];
    const walk = value => { if (!value || typeof value !== 'object') return; if (value._ === 'MenuItemStatusCommand' && value.menuItemId.startsWith('equipment_extra_')) extras.push(value); for (const child of Object.values(value)) walk(child); };
    walk(menu);
    assert.equal(extras.find(c => c.menuItemId === 'equipment_extra_cpu_jp').counterValue, 0);
    assert.equal(extras.find(c => c.menuItemId === 'equipment_extra_repbot_rep').available, false);
    const inventory = s.commands.find(c => c._ === 'HangarShipsCommand');
    assert.ok(inventory.ships.every(ship => db.prepare('SELECT 1 FROM ships WHERE id=? AND player_id=?').get(ship.shipId, a.userId)));
    s.close(); auth.destroy(a.sid);
  }
});

test('pre-login commands cannot move the active player or perform mutations', async () => {
  const a = await account(), s = session(); login(s, a);
  const before = [world.player.x, world.player.y];
  const intruder = session();
  dispatch(intruder, { _: 'MoveRequest', positionX: 12345, positionY: 6789, targetX: 20000, targetY: 10000 });
  assert.equal(intruder.closeCount, 1);
  assert.deepEqual([world.player.x, world.player.y], before);
});

test('last disconnect allows real ship activation and rejects inherited API actions', async () => {
  const a = await account(), s = session(); login(s, a);
  const shipId = world.player.shipId;
  s.close();
  assert.equal(world.livePlayer(a.userId), null);
  const activation = await request('/flashAPI/inventory.php', { cookie: a.cookie, method: 'POST',
    body: new URLSearchParams({ action: 'activateShip', params: Buffer.from(JSON.stringify({ params: { hangarId: shipId } })).toString('base64') }).toString() });
  assert.equal(JSON.parse(Buffer.from(activation.body, 'base64').toString()).isError, 0);
  const malformed = await request('/flashAPI/inventory.php', { cookie: a.cookie, method: 'POST', body: 'action=__proto__' });
  assert.equal(malformed.status, 200);
  assert.equal(JSON.parse(Buffer.from(malformed.body, 'base64').toString()).isError, 1);
});

test('second login detaches old socket and web logout invalidates the current game', async () => {
  const a = await account(), b = await account(2), first = session(), second = session();
  login(first, a); login(second, b);
  assert.equal(world.sessions.size, 1);
  assert.equal(first.closeCount, 1);
  assert.equal(world.player.userId, b.userId);
  await request('/logout', { cookie: b.cookie });
  assert.equal(world.sessions.size, 0);
  assert.equal(world.player, null);
  assert.equal(auth.verifyGame(b.sid, b.userId), false);
});

test('authenticated news feed replaces captured offers and serves offline-compatible native links',async()=>{
 const a=await account(),reply=await request('/flashAPI/brNews.php',{cookie:a.cookie}),cc=require('../game/command-center');
 assert.equal(reply.status,200);assert.match(reply.headers['Content-Type'],/text\/xml.*utf-8/);assert.equal(reply.headers['Cache-Control'],'no-store');
 assert.equal(reply.body,cc.feed());assert.equal((reply.body.match(/<layer /g)||[]).length,cc.NEWS.length);
 assert.doesNotMatch(reply.body,/<payment|Ts1HappyHour|REDACTED|category="sales"|countdown="1"/);
 const fs=require('node:fs'),path=require('node:path'),manifest=fs.readFileSync(path.join(__dirname,'../client/resources/resource_command_center.xml'),'utf8');
 for(const n of cc.NEWS){assert.match(reply.body,new RegExp('name="'+n.id+'"'));assert.equal((await request(n.href,{cookie:a.cookie})).status,200);}
 for(const m of reply.body.matchAll(/assetID="([^"]+)"/g)){
  const asset=m[1],id=asset.replace(/\.[^.]+$/,'');assert.ok(manifest.includes('id="'+id+'"'));assert.ok(fs.statSync(path.join(__dirname,'../client/do_img/new/bg',asset)).size>0);
 }
 const game=await request('/game',{cookie:a.cookie}),vm=require('node:vm'),opened=[];
 const window={location:{href:'http://localhost:8095/game',origin:'http://localhost:8095'},open:(...args)=>opened.push(args)};
 const script=game.body.match(/<script>\s*([\s\S]*?)<\/script>/)[1];vm.runInNewContext(script,{window,URL});
 for(const n of cc.NEWS)assert.equal(window.InternalMapRevolution.referOpenerToUrl(n.href),true);
 assert.equal(opened.length,cc.NEWS.length);assert.ok(opened.every(args=>args[1]==='darkorbit_portal'));
 assert.equal(window.InternalMapRevolution.referOpenerToUrl('https://other.invalid/indexInternal.es?action=internalDock'),false);
 assert.equal(window.InternalMapRevolution.referOpenerToUrl('javascript:alert(1)'),false);assert.equal(opened.length,cc.NEWS.length);
 let focused=0;window.opener={closed:false,location:{},focus(){focused++;}};
 assert.equal(window.InternalMapRevolution.referOpenerToUrl(cc.NEWS[0].href),true);assert.equal(focused,1);assert.equal(opened.length,cc.NEWS.length);
});

test('negative command IDs dispatch after login and owned key bindings persist', async () => {
  const a = await account(), s = session(); login(s, a);
  dispatch(s, { _: 'CommandCenterUpdateDontShowRequest', inspected: true });
  dispatch(s, { _: 'CommandCenterGetDontShowRequest' });
  assert.equal(s.commands.at(-1).inspected, true);
  assert.ok(protocol.registeredCommands().includes('QuestAcceptRequest'));
  assert.ok(protocol.registeredCommands().includes('JumpRequest'));
});

test('game packet capture masks a login without changing identity fields', () => {
  const { redactLogin } = require('../game/game-server');
  const command = { _: 'LoginRequest', userID: 123, sessionID: 'a'.repeat(32), version: 'do-lz4-block-v3', instanceId: 502, factionID: 1, isMiniClient: true };
  const clean = codec.decode(redactLogin(codec.encode(command))).obj;
  assert.equal(clean.sessionID, '*'.repeat(32));
  assert.equal(clean.userID, command.userID);
});

test('native C key legacy command switches and persists both configurations through the authenticated session',async()=>{
 const a=await account(),s=session();login(s,a);
 const shipId=world.player.shipId;
 for(const preset of [2,1]){
  dispatch(s,{_:'LegacyModule',message:`S|CFG|${preset}|999999|untrusted-payload`});
  assert.equal(world.player.activeConfig,preset);
  assert.equal(db.prepare('SELECT active_config FROM ships WHERE id=?').get(shipId).active_config,preset);
  assert.equal(s.commands.at(-1).message,`0|S|CFG|${preset}`);
 }
 for(const preset of ['0','3','2junk'])dispatch(s,{_:'LegacyModule',message:`S|CFG|${preset}`});
 assert.equal(world.player.activeConfig,1);
 world.player.dead=true;dispatch(s,{_:'LegacyModule',message:'S|CFG|2'});assert.equal(world.player.activeConfig,1);world.player.dead=false;
});

test('saving 2D/3D changes the next game flashvar and logout countdown completes without destroying web login', async () => {
  const a = await account(), s = session(); login(s, a);
  const display = structuredClone(require('../game/handlers/systems-evidence.json').defaults.UserSettingsCommand.displaySettingsModule);
  delete display.notSet; display._ = 'DisplaySettingsRequest'; display.displayUse2d = true;
  dispatch(s, display);
  const next = await request('/game', { cookie: a.cookie });
  assert.match(next.body, /display2d=2(?:&|\")/);
  const info = await request('/api/client-view', { cookie: a.cookie });
  assert.equal(JSON.parse(info.body).display2d, 2);
  assert.equal((await request('/api/client-view')).status, 401);
  world.config.gameplay ||= {}; const old = world.config.gameplay.logoutDelayMs; world.config.gameplay.logoutDelayMs = 5;
  try {
    dispatch(s, { _: 'UIButtonTriggerRequest', itemId: 'logout' });
    await new Promise(resolve => setTimeout(resolve, 15));
    assert.ok(s.commands.some(c => c._ === 'LegacyModule' && c.message === '0|l'));
    assert.equal(world.player, null); assert.ok(auth.verifyGame(a.sid, a.userId));
    display.displayUse2d = false;
    const s2 = session(); login(s2, a); dispatch(s2, display);
    assert.match((await request('/game', { cookie: a.cookie })).body, /display2d=1(?:&|\")/);
    dispatch(s2, { _: 'UIButtonTriggerRequest', itemId: 'logout' });
    dispatch(s2, { _: 'LogoutCancelRequest' });
    await new Promise(resolve => setTimeout(resolve, 15));
    assert.equal(world.player.userId, a.userId);
    assert.ok(s2.commands.some(c => c._ === 'LegacyModule' && c.message === '0|t'));
  } finally { if (old === undefined) delete world.config.gameplay.logoutDelayMs; else world.config.gameplay.logoutDelayMs = old; }
});
