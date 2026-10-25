'use strict';
const { open, tx } = require('./db');
const { skills: definitions } = require('./skill-tree-data.json');
const byId = new Map(definitions.map(skill => [skill.id, skill]));
const LOGFILE = 'resource_logfile';
// One numeric source for runtime effects and current/next portal tooltips.
// Classic tables: official Pilot BIO FAQ. Electro-Optics uses this client's
// captured newer first-rank5% edition; see docs/skill-benefit-validation.md.
const BENEFITS={
 '1':{label:'Mayın etki yarıçapı',values:[4,8,12,18,25],unit:'%',scope:'Mayınlar; akıllı bomba menzilini değiştirmez.'},
 '2':{label:'NPC imhasından deneyim',values:[2,4,6,8,12],unit:'%',scope:'NPC imha ödülü; görev ve kapı tamamlama ödüllerine uygulanmaz.'},
 '4':{label:'Kargo kapasitesi',values:[4,8,12,18,25],unit:'%'},
 '5a':{label:'Mayın hasarı',values:[7,14],unit:'%'},
 '5b':{label:'Mayın hasarı',values:[21,28,50],unit:'%',replaces:'5a'},
 '6':{label:'Roket hasarı',values:[2,4,6,8,15],unit:'%'},
 '8':{label:'Kalkan emiş oranı',values:[2,4,6,8,12],unit:'yüzde puanı',visual:'5/5 seviyesinde kalkan darbesi efekti.'},
 '9':{label:'NPC imhasından kredi',values:[4,8,12,18,25],unit:'%',scope:'NPC imha ödülü; görev veya kapı tamamlama ödülü değil.'},
 '11':{label:'NPC hedeflere lazer hasarı',values:[2,4,6,8,12],unit:'%'},
 '13':{label:'Tamir robotu hızı',values:[5,10,15,20,30],unit:'%',visual:'5/5 seviyesinde mavi tamir robotu efekti.'},
 '14':{label:'Düşman kargosundan maden',values:[1,2,3,4,6],unit:'%',scope:'Düşen düşman kargosu; haritadaki tekil madenlere uygulanmaz.'},
 '15':{label:'Bonus kutusu içeriği',values:[2,6,10,15,20],unit:'%',scope:'Normal bonus kutuları; korsan kutularının ödül havuzunu değiştirmez.'},
 '16a':{label:'Düşman lazerine karşı kaçınma',values:[2,4],unit:'yüzde puanı'},
 '16b':{label:'Düşman lazerine karşı kaçınma',values:[6,8,12],unit:'yüzde puanı',replaces:'16a'},
 '17':{label:'Kalkan kapasitesi',values:[4,8,12,18,25],unit:'%',visual:'5/5 seviyesinde baloncuk kalkan efekti.'},
 '18a':{label:'Azami darbe puanı',values:[5000,10000],unit:'DP'},
 '18b':{label:'Azami darbe puanı',values:[15000,25000,50000],unit:'DP',replaces:'18a'},
 '19':{label:'Lazer isabeti',values:[5,10,15,20,25],unit:'yüzde puanı'},
 '20':{label:'Roket isabeti',values:[1,2,4,6,10],unit:'yüzde puanı',visual:'Yetenek sayesinde isabet eden rokette kırmızı ışık efekti.'},
 '21a':{label:'İmha ödülünden şeref',values:[4,8],unit:'%',scope:'NPC/oyuncu imha ödülü; görev ve kapı tamamlama ödüllerine uygulanmaz.'},
 '21b':{label:'İmha ödülünden şeref',values:[12,18,25],unit:'%',replaces:'21a',scope:'NPC/oyuncu imha ödülü; görev ve kapı tamamlama ödüllerine uygulanmaz.'},
 '22a':{label:'Oyunculara karşı lazer hasarı',values:[2,4],unit:'%',scope:'Yalnız PvP. Yerel solo sürümde NPC hasarını artırmaz.'},
 '22b':{label:'Oyunculara karşı lazer hasarı',values:[6,8,12],unit:'%',replaces:'22a',scope:'Yalnız PvP. Yerel solo sürümde NPC hasarını artırmaz.',visual:'Kelle Avcısı I 2/2 ve II 3/3 olduğunda lazerler kalın görünür.'},
 '23a':{label:'Bonus kutusundan Uridyum',values:[2,4],unit:'%'},
 '23b':{label:'Bonus kutusundan Uridyum',values:[6,8,12],unit:'%',replaces:'23a'}
};
function benefit(rawId,rank=0){const id=String(rawId).replace(/^skill_/,''),b=BENEFITS[id];if(!Object.hasOwn(BENEFITS,id))throw Error('Yetenek bulunamadı.');if(!Number.isSafeInteger(rank)||rank<0||rank>b.values.length)throw Error('Geçersiz yetenek seviyesi.');const amount=b.values[rank-1]||0;return {...b,id,rank,max:b.values.length,amount,text:`${b.label}: +${amount.toLocaleString('tr-TR')}${b.unit==='%'?'%':` ${b.unit}`}`};}
function benefitSummary(rawId,levels={}){
 const id=String(rawId).replace(/^skill_/,''),b=BENEFITS[id];if(!Object.hasOwn(BENEFITS,id))throw Error('Yetenek bulunamadı.');
 const successor=Object.keys(BENEFITS).find(key=>BENEFITS[key].replaces===id),rank=levels[id]||0;
 const active=successor&&levels[successor]?successor:rank?id:b.replaces&&levels[b.replaces]?b.replaces:id;
 return{current:benefit(active,levels[active]||0),next:rank<b.values.length?benefit(id,rank+1):null,
  replaced:active!==id,scope:b.scope||'',visual:b.visual||'',replaces:b.replaces||null};
}
const value = (levels, id) => levels[id] || 0;
const percent = (table, rank) => (table[rank - 1] || 0) / 100;
function state(playerId, db = open()) {
  db.prepare('INSERT OR IGNORE INTO skill_accounts(player_id) VALUES(?)').run(playerId);
  const account = db.prepare('SELECT * FROM skill_accounts WHERE player_id=?').get(playerId);
  const levels = Object.fromEntries(db.prepare('SELECT skill_id,level FROM player_skills WHERE player_id=?').all(playerId).map(row => [row.skill_id, row.level]));
  const used = Object.values(levels).reduce((a, n) => a + n, 0);
  const logFiles = db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').get(playerId, LOGFILE).n;
  return { ...account, levels, used, available: account.earned_points - used, logFiles,
    required: account.earned_points < 50 ? Math.round(30 * 1.1 ** account.earned_points) : 0,
    resetPrice: 300000 };
}
function prerequisites(skill, levels) {
  return skill.requirements.every(group => group.each
    ? group.skills.every(id => value(levels, id) >= group.points)
    : group.skills.reduce((sum, id) => sum + value(levels, id), 0) >= group.points);
}
// User's local rules: pilot research uses credits + research points only.
// Keep captured original prices in definitions as evidence, without a Skylab dependency.
function costs(skill, level) { return { credits: skill.costs.credits * (level + 1), seprom: 0 }; }
function livePlayer(id) { return require('./world').current()?.livePlayer(id) || null; }
function refresh(id) {
  const w = require('./world').current(), p = w?.livePlayer(id);
  if (!p) return;
  w.refreshStats();
  const { sendCmd } = require('./net');
  const commands = buildInit(p);
  w.broadcast(s => {
    sendCmd(s, { _: 'AttributeCreditsUpdateCommand', credits: p.credits, uridium: p.uridium, jackpot: p.jackpot || 0 });
    sendCmd(s, { _: 'UpdateCargoSpaceCommand', cargoSpaceMax: p.cargoSpaceMax });
    for (const command of commands) sendCmd(s, command);
  });
}
function upgrade(playerId, rawId) {
  const id = String(rawId || '').replace(/^skill_/, ''), skill = byId.get(id);
  if (!skill) throw new Error('Yetenek bulunamadı.');
  const p = livePlayer(playerId);
  const result = tx(conn => {
    const st = state(playerId, conn), level = value(st.levels, id);
    if (level >= skill.max) throw new Error('Bu yetenek en yüksek seviyede.');
    if (!prerequisites(skill, st.levels)) throw new Error('Önce gerekli yetenekleri geliştir.');
    if (st.available < 1) throw new Error('Yeterli ArGe puanın yok. Önce günlük dosyalarını dönüştür.');
    const cost = costs(skill, level);
    if (p) conn.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits, p.uridium, playerId);
    if (!conn.prepare('UPDATE players SET credits=credits-? WHERE id=? AND credits>=?').run(cost.credits, playerId, cost.credits).changes)
      throw new Error('Yeterli kredin yok.');
    conn.prepare('INSERT INTO player_skills(player_id,skill_id,level) VALUES(?,?,?) ON CONFLICT(player_id,skill_id) DO UPDATE SET level=excluded.level').run(playerId, id, level + 1);
    return { id, level: level + 1, credits: conn.prepare('SELECT credits FROM players WHERE id=?').get(playerId).credits };
  });
  if (p) p.credits = result.credits;
  refresh(playerId);
  return result;
}
function convert(playerId) {
  tx(db => {
    const st = state(playerId, db);
    if (st.earned_points >= 50) throw new Error('En fazla 50 ArGe puanı kazanılabilir.');
    if (st.logFiles < st.required) throw new Error(`Bir sonraki puan için ${st.required} günlük dosyası gerekli.`);
    let left = st.required;
    for (const row of db.prepare('SELECT id,amount FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id').all(playerId, LOGFILE)) {
      const take = Math.min(left, row.amount); db.prepare('UPDATE items SET amount=amount-? WHERE id=?').run(take, row.id); left -= take;
      if (!left) break;
    }
    db.prepare('UPDATE skill_accounts SET earned_points=earned_points+1 WHERE player_id=?').run(playerId);
  });
  refresh(playerId);
  return state(playerId);
}
function reset(playerId) {
  const p = livePlayer(playerId);
  const money = tx(db => {
    const st = state(playerId, db);
    if (!st.used) throw new Error('Dağıtılmış ArGe puanın yok.');
    if (p) db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits, p.uridium, playerId);
    if (!db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(st.resetPrice, playerId, st.resetPrice).changes)
      throw new Error('Sıfırlama için yeterli uridyumun yok.');
    db.prepare('DELETE FROM player_skills WHERE player_id=?').run(playerId);
    db.prepare('UPDATE skill_accounts SET reset_count=reset_count+1 WHERE player_id=?').run(playerId);
    return db.prepare('SELECT uridium FROM players WHERE id=?').get(playerId).uridium;
  });
  if (p) p.uridium = money;
  refresh(playerId);
  return state(playerId);
}
function hasThickLasers(playerId) {
  const levels = state(playerId).levels;
  return value(levels, '22a') === 2 && value(levels, '22b') === 3;
}
function effects(playerId) {
  const l = state(playerId).levels, at = id => percent(BENEFITS[id].values, value(l, id));
  return {
    hull: benefit(value(l,'18b')?'18b':'18a',value(l,'18b')||value(l,'18a')).amount,
    shield: at('17'), absorb: at('8'),
    cargo: at('4'), repairMultiplier: 1 + at('13'),
    npcLaserMultiplier: 1 + at('11'), rocketMultiplier: 1 + at('6'),
    npcEpMultiplier: 1 + at('2'), npcCreditsMultiplier: 1 + at('9'),
    honourMultiplier: 1 + (value(l, '21b') ? at('21b') : at('21a')),
    bonusUridiumMultiplier: 1 + (value(l, '23b') ? at('23b') : at('23a')),
    bonusLootMultiplier: 1 + at('15'), cargoLootMultiplier: 1 + at('14'),
    pvpLaserMultiplier: 1 + (value(l, '22b') ? at('22b') : at('22a')),
    evasion: value(l, '16b') ? at('16b') : at('16a'),
    rocketAccuracy: at('20'), laserAccuracy: at('19'),
    mineDamageMultiplier: 1 + (value(l, '5b') ? at('5b') : at('5a')),
    mineRadiusMultiplier: 1 + at('1')
  };
}
function applyStats(playerId, stats) {
  const e = effects(playerId);
  return { ...stats, hitMax: stats.hitMax + e.hull, shieldMax: Math.round(stats.shieldMax * (1 + e.shield)),
    shieldAbsorb: Math.min(1, stats.shieldAbsorb + e.absorb), cargoMax: Math.round(stats.cargoMax * (1 + e.cargo)),
    npcLaserMultiplier: (stats.npcLaserMultiplier || 1) * e.npcLaserMultiplier,
    rocketMultiplier: (stats.rocketMultiplier || 1) * e.rocketMultiplier, skills: e };
}
function listCommand(player) {
  const st = state(player.userId);
  return { _: 'SkillTreeListCommand', resetPrice: st.resetPrice, list: definitions.map(s => ({ _: 'SkillTreeInfoCommand', id: s.id, curLevel: st.levels[s.id] || 0 })),
    researchPoints: st.available, resetCount: st.reset_count, logFiles: st.logFiles, required: st.required };
}
function buildInit(player) {
  return [listCommand(player), { _: 'AttributeSkillRepairUpdateCommand', repairSkillMaxed: state(player.userId).levels['13'] === 5 }, ...require('./shield-visuals').buildInit(player)];
}
module.exports = { definitions, byId, BENEFITS, benefit, benefitSummary, LOGFILE, state, prerequisites, costs, upgrade, convert, reset, hasThickLasers, effects, applyStats, buildInit, listCommand };
