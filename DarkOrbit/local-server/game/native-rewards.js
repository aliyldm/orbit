'use strict';
// Native packet contracts are recovered from the supplied client. Local season
// missions and the classic-GG event bridge keep the same authoritative web ledger.
const calendar = require('../web/stubs/dailyLogin.json');
const META = require('../docs/client-map.items.json').items;
const events = () => require('./payment-events');
const MISSION_ID = 930001;
function atomic(db, fn) {
 db.exec('SAVEPOINT native_rewards');
 try { const result = fn(); db.exec('RELEASE native_rewards'); return result; }
 catch (error) { db.exec('ROLLBACK TO native_rewards; RELEASE native_rewards'); throw error; }
}
function dailyState(db, playerId, now = Date.now()) {
 events().account(db, playerId);
 const period = events().periodKey('daily', now), month = period.slice(0, 7);
 const rows = db.prepare('SELECT * FROM daily_login_claims WHERE player_id=? AND month=? ORDER BY reward_day').all(playerId, month);
 const today = rows.find(r => r.period === period), count = rows.length;
 const [year, m] = month.split('-').map(Number);
 // Same local reset boundary as the season: 05:30 Europe/Istanbul (02:30 UTC).
 const nextMonth = Date.UTC(year, m, 1, 2, 30);
 return { period, month, rows, today, count, day: today?.reward_day || Math.min(count + 1, 25),
  claimable: !today && count < 25, remainingSeconds: Math.max(0, Math.ceil((nextMonth - now) / 1000)) };
}
function calendarReward(day, premium) {
 const reward = { items: {}, boosterHours: {} };
 for (const item of calendar.rewards[day - 1]) {
  if (item.premium && !premium) continue;
  if (item.lootId === 'resource_extra-energy') reward.energy = (reward.energy || 0) + item.amount;
  else if (META[item.lootId]?.kind === 'Booster') reward.boosterHours[item.lootId] = item.amount;
  else reward.items[item.lootId] = (reward.items[item.lootId] || 0) + item.amount;
 }
 return reward;
}
function dailyClaim(db, playerId, now = Date.now()) {
 return atomic(db, () => {
  const state = dailyState(db, playerId, now);
  if (!state.claimable) return { claimed: !!state.today, repeated: true, day: state.day };
  const premium = !!db.prepare('SELECT premium FROM players WHERE id=?').get(playerId).premium;
  const reward = calendarReward(state.day, premium);
  require('./payment').fulfil(db, playerId, { contents: reward });
  db.prepare('INSERT INTO daily_login_claims(player_id,period,month,reward_day,premium,reward_json,claimed_at) VALUES(?,?,?,?,?,?,?)')
   .run(playerId, state.period, state.month, state.day, Number(premium), JSON.stringify(reward), now);
  return { claimed: true, repeated: false, day: state.day, reward };
 });
}
function dailyJson(db, playerId, cdn, now = Date.now()) {
 const state = dailyState(db, playerId, now), premium = !!db.prepare('SELECT premium FROM players WHERE id=?').get(playerId).premium;
 return { theme: calendar.theme.replace('{cdn}', cdn), remainingSeconds: state.remainingSeconds, isPremium: premium,
  rewards: calendar.rewards.map((items, index) => items.map(item => ({ ...item,
   lootImage: item.lootImage.replace('{cdn}', cdn), booked: index < state.count,
   next: state.claimable && index === state.count, special: [7, 15, 23, 25].includes(index + 1) }))) };
}
function dailyCommand(db, playerId, now) {
 const s = dailyState(db, playerId, now);
 return { _: 'DailyLoginRewardDayCommand', claimed: !!s.today, month: Number(s.month.slice(5)), end: s.count >= 25,
  nextMonthSeconds: s.remainingSeconds, day: s.day };
}
function passCommand(db, playerId, event, choice = 'thermal') {
 const api = events(), a = api.account(db, playerId), max = event === 'trinity' ? 40 : 30, level = api.levelOf(a, event);
 const claims = new Set(db.prepare('SELECT track,level FROM payment_event_claims WHERE player_id=?').all(playerId).map(r => `${r.track}:${r.level}`));
 const list = vip => Array.from({ length: max }, (_, i) => {
  const n = i + 1, track = `${event}-${vip ? 'vip' : 'free'}`, [[lootId, amount]] = Object.entries(api.eventReward(event, n, vip, choice).items);
  return { _: 'PassItemModule', level: n, lootId, amount,
   statusType: claims.has(`${track}:${n}`) ? 1 : vip && !a[event] ? 0 : n > level ? 3 : 2 };
 });
 return { _: event === 'trinity' ? 'TrinityTrialsPassCommand' : 'VoyagersPassCommand', isVip: !!a[event], normalItemList: list(false), vipItemList: list(true),
  currentLevel: level, vipParams: [10, 20], remainSeconds: 31536000,
  currentExp: a[`${event}_points`], nextLevelExp: level === max ? 0 : api.threshold(level + 1, event) };
}
function missionProgress(db, playerId, mission, now = Date.now()) {
 return db.prepare('SELECT * FROM payment_event_progress WHERE player_id=? AND mission=? AND period=?')
  .get(playerId, mission.key, events().periodKey(mission.period, now));
}
function missionDefinition(db, playerId, mission, index, now = Date.now(), battle = false) {
 const row = missionProgress(db, playerId, mission, now), completed = (row?.progress || 0) >= mission.goal;
 const id = MISSION_ID + index, conditionId = id * 100 + 1;
 const empty = { _: 'QuestCaseModule', id: 0, active: false, mandatory: false, ordered: false, mandatoryCount: 0, modifier: [] };
 const type = mission.event === 'npcKill' ? 6 : mission.event === 'collectLoot' ? 55 : 79;
 return { _: 'QuestDefinitionModule', id, types: [{ _: 'QuestTypeModule', type: battle ? 7 : mission.period === 'daily' ? 3 : mission.period === 'weekly' ? 6 : 9 }],
  rootCase: { ...empty, id: id * 100, active: true, mandatory: true, mandatoryCount: 1,
   modifier: [{ _: 'QuestElementModule', questCase: empty, condition: { _: 'QuestConditionModule', id: conditionId, type, displayType: type,
    matches: [], targetValue: mission.goal, mandatory: true, subConditions: [],
    state: { _: 'QuestConditionStateModule', currentValue: row?.progress || 0, active: !completed, completed } } }] },
  rewards: [{ _: 'LootModule', lootId: battle ? 'resource_battle-pass-key' : 'resource_season-pass-point',
   amount: battle ? mission.period === 'daily' ? 1 : mission.period === 'weekly' ? 2 : 5 : mission.points, modifier: '' }],
  icons: [], textKeyFoundation: '', portraitId: '', star: 0 };
}
function missionCommand(db, playerId, now) {
 return { _: 'SeasonPassMissionInfoCommand', missionInfoType: 0,
  refreshInfo: { _: 'RefreshQuestInfo', nextDailyUridium: 0, nextWeeklyUridium: 0, dailyCount: 0, weeklyCount: 0, dailyLeft: 0, weeklyLeft: 0 },
  missionItems: events().MISSIONS.map((m, i) => ({ _: 'SeasonPassMissionModule',
   missionStatus: { _: 'SeasonPassMissionStatusModule', type: (missionProgress(db, playerId, m, now)?.progress || 0) >= m.goal ? 3 : 0 },
   questDefinitionModule: missionDefinition(db, playerId, m, i, now) })) };
}
function battleStatus(db, playerId, now) {
 const a = events().account(db, playerId);
 return { _: 'BattlePassUpdateStatusCommand', purchased: !!a.battlepass,
  questsToCollectReward: a.battlepass ? events().MISSIONS.flatMap((m, i) => { const r = missionProgress(db, playerId, m, now); return r?.progress >= m.goal && !r.battle_claimed ? [MISSION_ID + i] : []; }) : [] };
}
function exchangeCount(db, playerId, key) {
 return db.prepare('SELECT claim_count FROM payment_event_exchanges WHERE player_id=? AND recipe=?').get(playerId, key)?.claim_count || 0;
}
function battleExchange(db, playerId) {
 return { _: 'BattlePassKeyExchangeInfoCommand', numOfKeys: events().count ? events().count(db, playerId, 'resource_battle-pass-key') : require('./loot-rewards').count(db, playerId, 'resource_battle-pass-key'), exchangeType: 0,
  rewardList: Object.entries(events().EXCHANGES).filter(([, r]) => r.cost['resource_battle-pass-key']).map(([key, r], i) => ({
   _: 'BattlePassKeyExchangeRewardModule', cost: r.cost['resource_battle-pass-key'], limit: 2147483647, exchangeReward: key,
   listOfloot: Object.entries(r.reward.items).map(([lootId, amount]) => ({ _: 'BattlePassKeyExchangeLootModule', lootId, amount })),
   priority: i, isSpecial: false, claimCount: exchangeCount(db, playerId, key) })) };
}
function commands(db, playerId, now) {
 return [missionCommand(db, playerId, now), passCommand(db, playerId, 'trinity'), passCommand(db, playerId, 'voyagers'),
  { _: 'BattlePassInfoCommand', filename: 'pass_local.xml', statusCommand: battleStatus(db, playerId, now),
   battlePassQuestModuleList: events().MISSIONS.map((m, i) => ({ _: 'BattlePassQuestModule',
    acceptabilityStatus: { _: 'QuestAcceptabilityStatusModule', type: (missionProgress(db, playerId, m, now)?.progress || 0) >= m.goal ? 3 : 2 },
    questDefinition: missionDefinition(db, playerId, m, i, now, true) })) }, battleExchange(db, playerId),
  { _: 'BattlePassWindowSettingsModule', battlePassItemFilters: read(db, playerId, 'battlePass.filters', ['special', 'standard']) }];
}
function read(db, playerId, key, fallback) { try { return JSON.parse(db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(playerId, key)?.value) ?? fallback; } catch { return fallback; } }
function save(db, playerId, key, value) { db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(playerId, key, JSON.stringify(value)); }
function progressCommands(db, playerId, event, now, before = {}) {
 if(!events().MISSIONS.some(m=>m.event===event.type&&(!m.lootId||m.lootId===event.lootId)))return [];
 const out = [];
 events().MISSIONS.forEach((m, i) => { if (m.event !== event.type || m.lootId && m.lootId !== event.lootId) return;
  const r = missionProgress(db, playerId, m, now), completed = (r?.progress || 0) >= m.goal;
  if(Object.hasOwn(before,m.key)&&before[m.key]===(r?.progress||0))return;
  out.push({ _: 'QuestConditionUpdateCommand', questConditionId: (MISSION_ID + i) * 100 + 1,
   state: { _: 'QuestConditionStateModule', currentValue: r?.progress || 0, active: !completed, completed } });
  if (completed&&(before[m.key]||0)<m.goal) out.push({ _: 'QuestCompletedCommand', id: MISSION_ID + i, rating: 0 });
 });
 if(out.length)out.push(battleStatus(db, playerId, now));
 if (event.type === 'gateComplete') out.push(passCommand(db, playerId, 'trinity'), passCommand(db, playerId, 'voyagers'));
 return out;
}
function register(on, services = {}) {
 const send = (s, c) => (services.sendCmd || require('./net').sendCmd)(s, c);
 const refresh = (s, db, p) => { for (const c of events().refreshRuntime(db, p, s.world)) send(s, c); require('./ammo').notify(p); };
 function mutation(s, p, db, action) { try { atomic(db, () => { events().persistEconomy(db, p); action(); }); refresh(s, db, p); return true; }
  catch (error) { send(s, { _: 'LegacyModule', message: `0|A|STD|${error.message}` }); return false; } }
 for (const event of ['trinity', 'voyagers']) {
  const prefix = event === 'trinity' ? 'TrinityTrials' : 'Voyagers';
  on(prefix + 'UIRequest', (s, r, p, db) => {
   if (event === 'trinity' && ![0, 1].includes(r.optionalType)) return send(s, { _: 'LegacyModule', message: '0|A|STD|Özgün Trinity etkinlik kapısı ve düşüş geliştirmesi henüz yerelde yok. Bilet ödülleri klasik kapılardan ilerler.' });
   send(s, passCommand(db, p.userId, event));
  });
  on(prefix + 'ClaimPassRewardRequest', (s, r, p, db) => {
   if (typeof r.isVip !== 'boolean' || !Number.isSafeInteger(r.rewardLevel) || r.rewardLevel < 1 || r.rewardLevel > (event === 'trinity' ? 40 : 30)) return;
   mutation(s, p, db, () => events().claim(db, p.userId, `${event}-${r.isVip ? 'vip' : 'free'}`, r.rewardLevel));
   send(s, passCommand(db, p.userId, event));
  });
  on(prefix + 'GateEnterRequest', (s) => send(s, { _: 'LegacyModule', message: '0|A|STD|Bu etkinliğin özgün haritası henüz uygulanmadı. Bilet ilerlemesi klasik galaksi kapılarındadır.' }));
 }
 on('BattlePassCollectRequest', (s, r, p, db) => mutation(s, p, db, () => {
  if (!events().account(db, p.userId).battlepass) throw Error('Önce Battle Pass biletini etkinleştir.');
  for (const m of events().MISSIONS) { const row = missionProgress(db, p.userId, m); if (row?.progress >= m.goal && !row.battle_claimed) events().claimBattle(db, p.userId, m.key); }
 }));
 on('BattlePassKeyExchangeRequest', (s, r, p, db) => {
  if (!events().EXCHANGES[r.exchangeReward]?.cost['resource_battle-pass-key']) return;
  mutation(s, p, db, () => events().exchange(db, p.userId, r.exchangeReward));
  send(s, battleExchange(db, p.userId));
 });
 on('BattlePassSetFilterRequest', (s, r, p, db) => {
  const filters = r.battlePassWindowSettingsModule?.battlePassItemFilters;
  if (!Array.isArray(filters) || filters.length > 2 || filters.some(f => !['standard', 'special'].includes(f))) return;
  save(db, p.userId, 'battlePass.filters', [...new Set(filters)]);
 });
 on('SeasonPassRefreshRequest', (s) => send(s, { _: 'LegacyModule', message: '0|A|STD|Yerel sezonun görevleri sabittir; günlük ve haftalık görevler dönem başında yenilenir.' }));
 on('DailyLoginRewardDayRequest', (s, r, p, db) => send(s, dailyCommand(db, p.userId)));
 on('DailyLoginClaimTodayRequest', (s, r, p, db) => {
  let result, err = '';
  try { atomic(db, () => { events().persistEconomy(db, p); result = dailyClaim(db, p.userId); }); if (!result.repeated) refresh(s, db, p); }
  catch (error) { err = error.message; }
  send(s, { _: 'DailyLoginClaimTodayCommand', err, claimed: !!result?.claimed, day: result?.day || dailyState(db, p.userId).day });
  send(s, dailyCommand(db, p.userId));
 });
}
module.exports = { MISSION_ID, dailyState, calendarReward, dailyClaim, dailyJson, dailyCommand, passCommand, missionCommand, missionDefinition, missionProgress, battleStatus, battleExchange, progressCommands, commands, register };
