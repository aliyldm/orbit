'use strict';
// Wire condition/type IDs are from the shipped QuestConditionModule and
// QuestTypeModule. 20005/20006 reconstruct the next starter steps; 900xxx are
// explicitly authored local missions, not a purported original quest catalog.
const source = 'https://board-en.darkorbit.com/threads/nyx-mission-faq.102728/';
const emptyCase = () => ({ _: 'QuestCaseModule', id: 0, active: false, mandatory: false, ordered: false, mandatoryCount: 0, modifier: [] });
const condition = (type, targetValue, matches = [], maps) => ({ type, targetValue, matches, maps });
const kill = (id, count, maps) => condition(6, count, [String(id)], maps);
const ore = (id, count) => condition(67, count, ['resource_ore_' + id]);
const visit = map => condition(34, 1, [map]);
const home = () => condition(62, 1, ['HOME']);
const loot = (lootId, amount) => ({ _: 'LootModule', lootId, amount, modifier: '' });
const credits = n => loot('currency_credits', n), ep = n => loot('currency_experience', n), uri = n => loot('currency_uridium', n);
function quest(id, minLevel, prerequisite, objectives, rewards, options = {}) {
  const constraints = {};
  const rootId = id * 100;
  const modifier = objectives.map((objective, i) => {
    const { maps, ...fields } = objective, conditionId = rootId + i + 1;
    if (maps) constraints[conditionId] = { maps };
    return { _: 'QuestElementModule', questCase: emptyCase(), condition: { _: 'QuestConditionModule', id: conditionId,
      ...fields, displayType: fields.type, mandatory: true,
      state: { _: 'QuestConditionStateModule', currentValue: 0, active: false, completed: false }, subConditions: [] } };
  });
  const types = [{ _: 'QuestTypeModule', type: options.starter ? 1 : 2 }], textKeyFoundation = '';
  return { minLevel, prerequisite, constraints,
    provenance: options.starter ? { kind: 'reconstructed-starter', source } : { kind: 'local', version: 1 },
    title: options.title, description: options.description,
    definition: { _: 'QuestDefinitionModule', id, types, rootCase: { ...emptyCase(), id: rootId, mandatory: true,
      ordered: !!options.ordered, mandatoryCount: modifier.length, modifier }, rewards,
      icons: [{ _: 'QuestIconModule', icon: 0 }], textKeyFoundation, portraitId: '', star: 0 },
    slim: { _: 'QuestSlimInfoModule', questId: id, rootCaseId: rootId, minLevel, priority: options.starter ? 0 : 100,
      types, icon: { _: 'QuestIconModule', icon: 0 }, acceptabilityStatus: { _: 'QuestAcceptabilityStatusModule', type: 0 },
      missingAcceptRequirements: [], textKeyFoundation, portraitId: '', star: 0 } };
}
const missions = [
  quest(20005, 0, 20004, [condition(55, 3), home()], [loot('equipment_generator_shield_sg3n-b02', 1), loot('ammunition_laser_mcb-50', 1000)], { starter: true, ordered: true }),
  quest(20006, 0, 20005, [condition(70, 1, ['standardSlotBar', 'ammunition_laser_mcb-50']), visit('own:2'), kill(2, 5, ['own:2']), visit('own:1'), home()],
    [loot('ammunition_rocket_plt-2021', 100), loot('equipment_generator_speed_g3n-3310', 1), credits(100000), loot('equipment_weapon_laser_lf-3', 1)], { starter: true, ordered: true }),
  quest(900001, 1, 20005, [ore('prometium', 50), ore('endurium', 25), ore('terbium', 10)], [credits(10000), ep(2000), uri(10)],
    { title: 'Maden tedariki', description: '50 Prometium, 25 Endurium ve 10 Terbium topla. Yerel görev; özgün görev kataloğunun parçası değildir.' }),
  quest(900002, 2, 20005, [kill(2, 10, ['own:2']), home()], [credits(16000), ep(4000), uri(20)],
    { ordered: true, title: 'Lordakia devriyesi', description: 'Kendi şirketinin x-2 haritasında 10 normal Lordakia yok et, sonra ana üs görev merkezine dön.' }),
  quest(900003, 2, 20005, [condition(51, 10)], [credits(12000), ep(3000), loot('resource_repairvoucher', 1)],
    { title: 'Enkaz kurtarma', description: 'Yok edilen gemilerden kalan 10 kargo kutusunu topla. Boş veya toplanamayan kutular sayılmaz.' }),
  quest(900004, 3, 20005, [visit('own:2'), visit('own:3'), visit('own:4'), home()], [credits(20000), ep(5000), uri(25)],
    { ordered: true, title: 'Sektör keşfi', description: 'Sırayla kendi şirketinin x-2, x-3 ve x-4 haritalarını ziyaret et, ardından ana üs görev merkezine dön.' }),
  quest(900005, 3, 900002, [kill(6, 20, ['own:3'])], [credits(32000), ep(8000), uri(30)],
    { title: 'Saimon temizliği', description: 'Kendi şirketinin x-3 haritasında 20 normal Saimon yok et. Boss ve Uber türleri bu göreve sayılmaz.' }),
  quest(900006, 3, 900002, [kill(14, 1, ['own:2']), kill(15, 1, ['own:2'])], [credits(30000), ep(6000), loot('resource_logfile', 1)],
    { title: 'Lider avı', description: 'Kendi şirketinin x-2 haritasında bir Boss Streuner ve bir Boss Lordakia yok et.' }),
  quest(900007, 2, 900001, [condition(52, 100, ['1'])], [credits(15000), ep(3000), uri(15)],
    { title: 'Ticaret sevkiyatı', description: 'Uzay istasyonuna 100 Prometium sat. Satış geliri ayrıca hesabına eklenir.' }),
  quest(900008, 5, 900005, [kill(5, 1, ['own:4'])], [credits(50000), ep(16000), uri(40)],
    { title: 'Sibelon tehdidi', description: 'Kendi şirketinin x-4 haritasında bir normal Sibelon yok et.' }),
  quest(900009, 11, 900008, [kill(9, 10, ['own:6', 'own:7'])], [credits(100000), ep(32000), uri(80)],
    { title: 'Kristallin nöbeti', description: 'Kendi şirketinin x-6 veya x-7 haritasında 10 normal Kristallin yok et.' }),
  quest(900010, 12, 900008, [kill(58, 10, [91, 93])], [credits(125000), ep(40000), uri(100)],
    { title: 'Korsan yolu', description: '5-1 veya 5-3 haritasında 10 normal Interceptor yok et. Ana gemilerin çağırdığı normal Interceptor da sayılır.' }),
  quest(900011, 6, 20005, [condition(79, 1, ['1', '51'])], [credits(100000), ep(25000), uri(100)],
    { title: 'Alpha seferi', description: 'Alpha kapısının bütün dalgalarını tamamla. Bu ödül, kapının kendi bitirme ödülüne ek bir yerel görev ödülüdür.' }),
  quest(900012, 2, 20005, [condition(55, 20)], [credits(15000), ep(3000), loot('ammunition_laser_mcb-25', 500)],
    { title: 'Bonus arayıcısı', description: '20 normal bonus kutusu topla. Korsan kutuları ve NPC kargoları bu göreve sayılmaz.' })
];
missions.push(...require('./quests-original').make({quest,condition,loot,uri,ep,credits}));
function ownMap(faction, sector) { return sector <= 4 ? (faction - 1) * 4 + sector : 17 + (faction - 1) * 4 + sector - 5; }
function resolve(value, faction) {
  if (typeof value === 'string' && /^own:[1-8]$/.test(value)) return String(ownMap(faction, Number(value.slice(4))));
  if (Array.isArray(value)) return value.map(child => resolve(child, faction));
  if (value && typeof value === 'object') return Object.fromEntries(Object.entries(value).map(([key, child]) => [key, resolve(child, faction)]));
  return value;
}
module.exports = { missions, ownMap, resolve, source };
