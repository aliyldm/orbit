'use strict';
// Girişten sonra gönderilen açılış komutlarını oyuncu durumundan üretir.
// Arayüz/ayar komutları game/templates/init.json'dan gelir; oyuncuya özgü alanlar
// (gemi, konum, kimlik, ad) world.player'dan yazılır. Kayıttaki kimlik ve ad,
// tüm komutlarda derinlemesine local değerlerle değiştirilir.

const fs = require('fs');
const path = require('path');

const TEMPLATE = path.join(__dirname, 'templates', 'init.json');

function deepReplace(v, fromId, toId, fromName, toName) {
  if (Array.isArray(v)) return v.map(x => deepReplace(x, fromId, toId, fromName, toName));
  if (v && typeof v === 'object') {
    const out = {};
    for (const [k, x] of Object.entries(v)) out[k] = deepReplace(x, fromId, toId, fromName, toName);
    return out;
  }
  if (v === fromId) return toId;
  if (typeof v === 'string') {
    let s = v;
    if (fromName && s.includes(fromName)) s = s.split(fromName).join(toName);
    // Eski metin komutları kimliği "|kimlik|" biçiminde taşır.
    if (s.includes(`|${fromId}|`) || s.endsWith(`|${fromId}`)) s = s.split(`|${fromId}`).join(`|${toId}`);
    return s;
  }
  return v;
}

// Şablonun kaydedildiği haritaya ait nesneler; oyuncu başka haritadaysa gönderilmez.
// (Portallar Aşama 4'te maps/portals tablolarından üretilecek.)
const MAP_SPECIFIC = /^(QuestGiversAvailable|Jumpgate|MapAsset|MapAddPOI|POIReady|SpaceStation|StarmapStation|RemoveMinimapMark|AddBox|AddOre|Mine|Asset|Beacon|AttributeOreCountUpdate)/;

// Şablon canlı (ilerlemiş) bir hesaptan kaydedildi. Sıfır hesap şablonu kaydedilene kadar
// hesap durumunu taşıyan eski metin komutları çıkarılır: drone listesi (0|n|d), ünvan (0|n|t),
// CPU durum mesajları (0|A|STM).
const ACCOUNT_LEGACY = /^0\|n\|(d|t|INV)\||^0\|A\|STM\||^0\|A\|(?:BK|BKR|BKB)\|/;

// Captured seasonal/live-service state belongs to the recorded account. These
// systems have no local ledger/implementation; announcing them creates phantom
// rewards, paid boosters and external chat connections on a fresh local account.
const UNSUPPORTED_LIVE_STATE = new Set([
  'ChatParamCommand', 'AttributeBoosterUpdateCommand', 'UridiumBankInfoCommand',
  'ShipUpgradeModuleUpdateCommand', 'RogueLiteRankEventInfoCommand', 'NpcEventInfoCommand',
  'RogueLiteInfoCommand', 'MiniClientRewardInfoCommand', 'ReturneeLoginRewardInfoCommand',
  'ReturneeLoginInitialRewardInfoCommand', 'ReturneeLoginBundleInfoCommand',
  'SeasonPassStatusCommand', 'BattlePassInfoCommand', 'EventUpdateCommand',
  'SeasonPassMissionInfoCommand', 'BattlePassKeyExchangeInfoCommand', 'BattlePassWindowSettingsModule',
  'MonthlyDeluxeInfoCommand', 'SeasonPointsInfoCommand', 'SeasonPassRewardInfoCommand',
  'EventUnityClientRewardQuestCommand', 'EventActivationStateCommand', 'DispatchActiveEventCommand',
  'UpdateSpaceSearchKeyCommand'
]);

function buildInit(world) {
  const t = JSON.parse(fs.readFileSync(TEMPLATE, 'utf8'));
  const p = world.player;
  p.galaxyGatesDone = require('./gate-rings').sync(world.gatesDb || require('./db').open(), p.userId);
  const systems = require('./handlers/systems');
  const inventory = require('./inventory');
  const generated = [...systems.buildInit(p), ...require('./skills').buildInit(p), ...require('./handlers/lab').buildInit(p), ...require('./boosters').buildInit(p),
    ...require('./pet').buildInit(world), ...require('./cpu').buildInit(p), ...require('./techs').buildInit(world),require('./nano-hull').command(p),require('./ship-modules').command(p), ...require('./handlers/core').buildInit(p), ...require('./ship-abilities').buildInit(world), inventory.buildInit(p),
    inventory.equipmentCommand(p.userId, p.shipId), ...require('./drones').buildCommands(p), ...require('./booty').buildInit(p), ...require('./hellstorm').buildInit(world), ...require('./advanced-weapons').buildInit(world), ...require('./combat-utilities').buildInit(world), ...require('./assembly').buildInit(p)];
  const replaced = new Set(generated.filter(c => c._ !== 'LegacyModule').map(c => c._));
  const commands = t.commands.filter(c => !MAP_SPECIFIC.test(c._) && !replaced.has(c._) && !UNSUPPORTED_LIVE_STATE.has(c._))
    .filter(c => !(c._ === 'LegacyModule' && ACCOUNT_LEGACY.test(c.message)))
    .filter(c => !/^Pet/.test(c._))
    .filter(c => !['QuestConditionUpdateCommand', 'InventoryItemUpdatedCommand', 'LabUpdateItemCommand'].includes(c._));
  const result = commands.map(c => {
    let cmd = deepReplace(c, t.recordedUserId, p.userId, t.recordedUserName, p.userName);
    if (cmd._ === 'ShipInitializationCommand') {
      // Laser expansion follows actual active equipment, not the recorded hero.
      cmd = { ...cmd, ...p, clanId: 0, clanTag: '', cloaked: require('./cpu').isCloaked(p), refreshMap: true, captainEnergy: 0, maxCaptainEnergy: 0, modifier: [] };
    } else if (cmd._ === 'BeaconCommand') {
      cmd = { ...cmd, positionX: p.x, positionY: p.y, positionAheadX: p.x, positionAheadY: p.y };
    } else if (cmd._ === 'HangarShipsCommand') {
      // Hangar listesi: oyuncunun aktif gemisi (diğer gemiler hangar aşamasında DB'den gelecek).
      const brief = cmd.ships[0] || { _: 'HangarShipBriefCommand', isFavorite: false };
      cmd = { ...cmd, ships: [{ ...brief, isActive: true, lootId: p.typeId, shipId: p.shipId }] };
    } else if (cmd._ === 'AttributeShieldUpdateCommand') {
      cmd = { ...cmd, shieldNow: p.shield, shieldMax: p.shieldMax };
    } else if (cmd._ === 'AttributeShipSpeedUpdateCommand') {
      cmd = { ...cmd, newSpeed: p.speed, displaySpeed: p.speed };
    } else if (cmd._ === 'LegacyModule' && cmd.message.startsWith('0|S|CFG|')) {
      cmd.message = `0|S|CFG|${p.activeConfig || 1}`;
    }
    return cmd;
  });
  // Preserve the client's settings-before-hero and scene-before-NPC ordering.
  const settings = generated.filter(c => ['UserSettingsCommand', 'UserKeyBindingsUpdate', 'UIWindowSettingsCommand'].includes(c._));
  const other = generated.filter(c => !settings.includes(c));
  const ammo = require('./ammo'), ammoCommands = ammo.buildAmmoCommands(p);
  ammo.remember(p, ammoCommands);
  return require('./ui-capabilities').apply(systems.applyInit(p, [...settings, ...result, ...other,
    ...ammoCommands, ...require('./gameplay').initialize(world),require('./cpu').cloakCommand(p)]));
}

module.exports = { buildInit };
