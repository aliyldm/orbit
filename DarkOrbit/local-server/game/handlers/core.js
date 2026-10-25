'use strict';
const { open } = require('../db');
const inventory = require('../inventory');
const { commands: defaults } = require('../templates/init.json');
const commandCenter = require('../command-center');
function read(player, key, fallback) {
  const value = open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(player.userId, key);
  if (!value) return fallback;
  try { return JSON.parse(value.value); } catch { return fallback; }
}
function write(player, key, value) {
  open().prepare('INSERT INTO settings(player_id,key,value) VALUES(?,?,?) ON CONFLICT(player_id,key) DO UPDATE SET value=excluded.value')
    .run(player.userId, key, JSON.stringify(value));
}
function news(player, requested) {
  const known = read(player, 'commandCenter.news', {});
  const source = requested || commandCenter.entries();
  return { _: 'CommandCenterInfoCommand', ids: source.filter(commandCenter.valid).slice(0, 100).map(c => ({ _: 'CommandCenterNewsModule',
    eventId: c.eventId, newsId: c.newsId, clickCount: known[`${c.eventId}:${c.newsId}`] || 0 })) };
}
function menu(player) {
  const command = structuredClone(defaults.find(c => c._ === 'MenuInitializationCommand'));
  const db = open(), equipped = inventory.equipped(db, player.shipId, inventory.activeConfig(db, player.shipId));
  const quantities = new Map(db.prepare('SELECT loot_id,SUM(amount) n FROM items WHERE player_id=? GROUP BY loot_id').all(player.userId).map(r => [r.loot_id, r.n]));
  function visit(value) {
    if (!value || typeof value !== 'object') return;
    if (value._ === 'MenuItemStatusCommand') {
      if (/^ammunition_/.test(value.menuItemId)) {
        value.counterValue = quantities.get(value.menuItemId) || 0;
        value.available = value.activatable = value.counterValue > 0;
        if (value.menuItemId.startsWith('ammunition_laser_')) value.selected = value.menuItemId === (player.ammo || 'ammunition_laser_lcb-10');
        if (value.menuItemId.startsWith('ammunition_rocket_')) value.selected = value.menuItemId === (player.rocket || 'ammunition_rocket_r-310');
        Object.assign(value,require('../advanced-weapons').menuStatus(player,value));
      } else if (value.menuItemId.startsWith('drone_formation_')) {
        Object.assign(value,require('../drones').menuStatus(player.userId,value));
      } else if (value.menuItemId.startsWith('equipment_extra_cpu_')) {
        Object.assign(value,require('../cpu').menuStatus(player,value));
      } else if(value.menuItemId==='equipment_extra_hmd-07'){
        value.available=value.activatable=require('../cpu').tradeAvailable(player);
      } else if (value.menuItemId === 'equipment_extra_repbot_rep') {
        value.available = value.activatable = equipped.some(i => i.slot === 'extra' && i.loot_id.startsWith('equipment_extra_repbot_'));
      }
      Object.assign(value,require('../menu-capabilities').status(player,value));
    }
    for (const item of Object.values(value)) if (item && typeof item === 'object') visit(item);
  }
  visit(command);
  return require('../hotbar').apply(player.userId, command);
}
function buildInit(player) {
  const closed = read(player, 'hints.closed', []);
  const hints = defaults.find(c => c._ === 'HintWindowListInitCommand');
  // The native mediator maximizes this window whenever inspected is false.
  // Keep the user's preference; local notices do not force a popup on each jump.
  return [menu(player), commandCenter.events(), news(player), { _: 'CommandCenterDontShowInfoCommand', inspected: !!read(player, 'commandCenter.hidden', true) },
    { _: 'HintWindowListInitCommand', windows: (hints?.windows || []).filter(w => !closed.includes(w.content)) }];
}
function register(onCmd, { sendCmd }) {
  function cancelLogout(session, notify = true) {
    if (session.logoutTimer) { clearTimeout(session.logoutTimer); session.world.scheduled?.delete(session.logoutTimer); session.logoutTimer = null; }
    if (notify) sendCmd(session, { _: 'LegacyModule', message: '0|t' });
  }
  function startLogout(session) {
    if (!session.world.active(session) || session.logoutTimer) return;
    const requested = Date.now(), startX = session.player.x, startY = session.player.y;
    const delay = session.world.config.gameplay?.logoutDelayMs ?? (session.player.premium ? 5000 : 20000);
    session.logoutTimer = session.world.schedule(() => {
      session.logoutTimer = null;
      const player = session.player;
      if (!session.world.active(session)) return;
      if ((player.lastCombat || 0) > requested || Math.hypot(player.x - startX, player.y - startY) > 64) return cancelLogout(session);
      sendCmd(session, { _: 'LegacyModule', message: '0|l' });
      session.close();
    }, delay);
  }
  onCmd('SlotBarConfigSetRequest', (session, request) => {
    if(!session.world.active(session))return;
    const moved=require('../hotbar').move(session.player.userId, request);
    if(moved&&request.slotBarIdTo)require('../progression').event(session,{type:'slotItem',lootId:request.menuItemId,slotBarId:request.slotBarIdTo,amount:1});
    sendCmd(session, menu(session.player));
    for (const command of require('../ship-abilities').buildInit(session.world)) sendCmd(session, command);
    for (const command of require('../hellstorm').buildInit(session.world)) sendCmd(session, command);
    for (const command of require('../combat-utilities').buildInit(session.world)) sendCmd(session, command);
  });
  onCmd('ReadyRequest', (s, c) => {
    if(!s.world.active(s)||![0,1,2].includes(c.readyType))return;
    (s.readyTypes ||= new Set()).add(c.readyType);
      if(c.readyType!==2){
        // Flash can fall back to 2D when the requested 3D renderer is unavailable.
        // The map-ready acknowledgement reports the renderer actually running;
        // saving a preference alone must not retime the currently open scene.
        s.rendererMode=c.readyType===0?2:1;s.world.rendererMode=s.rendererMode;
        if(!s.player.dead)sendCmd(s,require('../cpu').cloakCommand(s.player));
      }
  });
  function changeConfiguration(s, presetId) {
    if (!s.world.active(s) || s.player.dead || s.jumping || ![1, 2].includes(presetId)) return;
    inventory.switchConfig(s.player.userId, s.player.shipId, presetId);
    s.player.activeConfig = presetId;
    s.world.save();
    sendCmd(s, { _: 'LegacyModule', message: `0|S|CFG|${presetId}` });
  }
  onCmd('ConfigChangeRequest', (s, c) => changeConfiguration(s, c.presetId));
  onCmd('CommandCenterGetDontShowRequest', s => sendCmd(s, { _: 'CommandCenterDontShowInfoCommand', inspected: !!read(s.player, 'commandCenter.hidden', true) }));
  onCmd('CommandCenterUpdateDontShowRequest', (s, c) => write(s.player, 'commandCenter.hidden', c.inspected));
  onCmd('CommandCenterNewsInfoRequest', (s, c) => sendCmd(s, news(s.player, c.newsInfo)));
  onCmd('CommandCenterNewsClickedRequest', (s, c) => {
    if (!commandCenter.valid(c)) return;
    const data = read(s.player, 'commandCenter.news', {}), key = `${c.eventId}:${c.newsId}`;
    if (Object.keys(data).length >= 1000 && !Object.hasOwn(data, key)) return;
    data[key] = (data[key] || 0) + 1; write(s.player, 'commandCenter.news', data);
    sendCmd(s, news(s.player, [c]));
  });
  onCmd('HintWindowClosedRequest', (s, c) => {
    if (!c.closedWindow) return;
    const data = read(s.player, 'hints.closed', []);
    if (!data.includes(c.closedWindow.content) && data.length < 255) data.push(c.closedWindow.content);
    write(s.player, 'hints.closed', data);
  });
  onCmd('ReturneeLoginHideUIItemRequest', s => write(s.player, 'returnee.hidden', true));
  onCmd('TrackVariableRequest', (s, c) => {
    const data = read(s.player, 'client.variables', {});
    for (const item of c.data) if (item && typeof item.key === 'string' && item.key.length <= 100 && Object.keys(data).length < 100)
      data[item.key] = typeof item.value === 'string' ? item.value.slice(0, 4096) : item.value;
    write(s.player, 'client.variables', data);
  });
  // Client window toggles are local actions. Persist the last opened window for
  // diagnostics; individual systems receive their own subsequent data requests.
  onCmd('UIButtonTriggerRequest', (s, c) => {
    write(s.player, 'client.lastWindow', c.itemId);
    if (c.itemId === 'logout') startLogout(s);
    if (c.itemId === 'ship_warp') require('../ship-warp').show(s);
    // Native trade-window maximize sends TradeRequest. Do not also request
    // data here: opening it once must not duplicate replies or consume charges.
  });
  onCmd('LogoutCancelRequest', s => cancelLogout(s));
  onCmd('LegacyModule', (s, c) => {
    const [kind, argument] = c.message.split('|');
    // ChangeConfingCommand (C) uses the original text protocol, while the
    // equipment UI uses ConfigChangeRequest. Both must reach the same path.
    if (kind === 'S' && argument === 'CFG') {
      const preset = c.message.split('|')[2];
      if (preset === '1' || preset === '2') return changeConfiguration(s, Number(preset));
      return;
    }
    if (kind === 'RL') return require('../hellstorm').legacy(s, c.message);
    if (kind === 'XCP') return require('../collectables').exchangePalladium(s,argument,sendCmd);
    if (kind === 'i' && /^-?\d+$/.test(argument || '')) s.world.combat?.select(s, Number(argument));
    else if (kind === 'JCPU') return require('../jump-cpu').legacy(s,c.message);
    else if (kind === 'LF' && argument === 'w') s.legacyReady = true;
    else if (kind === 'TWC') {s.tradeWindowOpen = false;delete s.cpuTradeItem;}
  });
}
module.exports = { register, buildInit, menu };
