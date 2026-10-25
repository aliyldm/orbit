'use strict';
const { test, beforeEach, after } = require('node:test');
const assert = require('node:assert/strict');
const dbm = require('../game/db');
const players = require('../game/db/players');
const skills = require('../game/skills');
const codec = require('../game/codec/codec');
const api = require('../web/skills-api');
let db, playerId;
beforeEach(() => {
  dbm.close(); db = dbm.open(':memory:');
  const account = players.createAccount('skills-test', 'testpass');
  playerId = players.createPlayer(account, 'skills-test', 1, { ...require('../config.json').starter, credits: 100000000, uridium: 10000000 });
  skills.state(playerId);
  db.prepare('UPDATE skill_accounts SET earned_points=50 WHERE player_id=?').run(playerId);
  if (db.prepare("SELECT 1 FROM sqlite_master WHERE name='skylab_resources'").get()) {
    require('../game/skylab').state(playerId);
    db.prepare('INSERT INTO skylab_resources(player_id,ore_type,amount)VALUES(?,7,100000) ON CONFLICT(player_id,ore_type)DO UPDATE SET amount=100000').run(playerId);
  } else db.prepare('INSERT INTO player_resources(player_id,ore_type,amount)VALUES(?,7,100000)').run(playerId);
});
after(() => dbm.close());
function set(id, n) { for (let i = 0; i < n; i++) skills.upgrade(playerId, id); }
test('source skill IDs, AND prerequisites and prices are preserved', () => {
  assert.equal(skills.definitions.length, 25);
  assert.equal(skills.byId.get('22b').max, 3);
  assert.equal(skills.byId.get('18b').requirements.length, 2);
  assert.equal(skills.byId.get('11').requirements[0].each, true);
  assert.throws(() => skills.upgrade(playerId, '22b'), /gerekli/);
  assert.throws(() => skills.upgrade(playerId, '__proto__'), /bulunamadı/);
});
test('thick lasers unlock at Bounty Hunter II rank3 rather than a global23-point threshold', () => {
  for (const [id, n] of [['18a', 2], ['13', 1], ['17', 2], ['22a', 2], ['18b', 3], ['8', 5], ['19', 3]]) set(id, n);
  assert.equal(skills.state(playerId).used, 18);
  assert.equal(skills.hasThickLasers(playerId), false);
  set('22b', 2); assert.equal(skills.hasThickLasers(playerId), false);
  set('22b', 1);
  assert.equal(skills.state(playerId).used, 21);
  assert.equal(skills.hasThickLasers(playerId), true);
  const fresh = players.loadPlayer(playerId);
  assert.equal(fresh.hitMax, require('../config.json').starter.ship === 'ship_liberator' ? 166000 : fresh.hitMax);
  assert.equal(fresh.stats.skills.pvpLaserMultiplier, 1.12);
  assert.equal(fresh.stats.skills.npcLaserMultiplier, 1, 'bounty bonus must not boost NPC damage');
});
test('many unrelated spent points cannot activate the thick laser effect', () => {
  for (const [id, n] of [['18a', 2], ['2', 5], ['5a', 2], ['13', 5], ['1', 5], ['17', 5]]) set(id, n);
  assert.equal(skills.state(playerId).used, 24);
  assert.equal(skills.hasThickLasers(playerId), false);
});
test('research conversion consumes the exact logs from multiple stacks, is owned and capped', () => {
  db.prepare('UPDATE skill_accounts SET earned_points=0 WHERE player_id=?').run(playerId);
  const insert = db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)');
  insert.run(playerId, skills.LOGFILE, 10); insert.run(playerId, skills.LOGFILE, 23);
  const st = skills.convert(playerId);
  assert.equal(st.earned_points, 1); assert.equal(st.available, 1); assert.equal(st.logFiles, 3); assert.equal(st.required, 33);
  assert.throws(() => skills.convert(playerId), /günlük/);
  db.prepare('UPDATE skill_accounts SET earned_points=50 WHERE player_id=?').run(playerId);
  assert.throws(() => skills.convert(playerId), /50/);
});
test('database failure rolls back money, Seprom, and learned skill together', () => {
  set('18a', 1);
  const before = db.prepare('SELECT credits FROM players WHERE id=?').get(playerId).credits;
  db.exec("CREATE TRIGGER fail_skill BEFORE INSERT ON player_skills BEGIN SELECT RAISE(ABORT,'simulated failure'); END;");
  assert.throws(() => skills.upgrade(playerId, '13'), /simulated/);
  assert.equal(db.prepare('SELECT credits FROM players WHERE id=?').get(playerId).credits, before);
  assert.equal(skills.state(playerId).levels['13'], undefined);
});
test('reset refunds allocated points, persists earned count, and clears visual qualification', () => {
  db.prepare("INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,'22a',2),(?,'22b',3)").run(playerId, playerId);
  assert.equal(skills.hasThickLasers(playerId), true);
  const st = skills.reset(playerId);
  assert.equal(st.available, 50); assert.equal(st.reset_count, 1); assert.equal(st.resetPrice, 300000);
  assert.equal(skills.hasThickLasers(playerId), false);
});

test('research reset costs fixed 300000 each time, refunds all allocated points and exposes a themed button',()=>{
 const before=db.prepare('SELECT uridium FROM players WHERE id=?').get(playerId).uridium;
 set('18a',2);const page=api.render(playerId);assert.match(page.skillResetButtonContainer,/class="skillResetButton"/);assert.match(page.skillResetButtonContainer,/300\.000 U\./);assert.match(page.skillResetButtonContainer,/Main\.resetSkillTree/);
 assert.equal(skills.listCommand(players.loadPlayer(playerId)).resetPrice,300000);
 const first=skills.reset(playerId);assert.equal(first.available,50);assert.equal(first.used,0);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(playerId).uridium,before-300000);
 assert.match(api.render(playerId).skillResetButtonContainer,/ disabled/);
 set('18a',1);const second=skills.reset(playerId);assert.equal(second.resetPrice,300000);assert.equal(second.reset_count,2);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(playerId).uridium,before-600000);
});

test('insufficient reset funds and reset storage failure preserve every skill, earned point and currency',()=>{
 set('18a',2);db.prepare('UPDATE players SET uridium=299999 WHERE id=?').run(playerId);
 const before=skills.state(playerId);assert.throws(()=>skills.reset(playerId),/yeterli uridyum/);assert.deepEqual(skills.state(playerId),before);
 db.prepare('UPDATE players SET uridium=300000 WHERE id=?').run(playerId);
 db.exec("CREATE TRIGGER fail_research_reset BEFORE DELETE ON player_skills BEGIN SELECT RAISE(ABORT,'reset storage failure');END");
 assert.throws(()=>skills.reset(playerId),/reset storage failure/);assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(playerId).uridium,300000);assert.equal(skills.state(playerId).used,2);assert.equal(skills.state(playerId).reset_count,0);
});
test('web skill tree renders owned values and the real learned/clickable nodes', () => {
  const before = api.render(playerId);
  assert.ok(before.html_skills.includes('id="skill_18a"'));
  assert.ok(before.html_skills.includes("sendSkillTreeUpdate('18a',this)"));
  assert.ok(!before.html_skills.includes("sendSkillTreeUpdate('22b',this)"));
  const response = api.handle(playerId, '/ajax/skillTree.php', new URLSearchParams({ command: 'skillTreePurchaseLevelUp', skillId: '18a' }));
  assert.equal(response.result, 'OK'); assert.equal(response.newResearchPoints, 49);
  assert.match(response.html_skills, /1\/2/);
  const fail = api.handle(playerId, '/ajax/skillTree.php', new URLSearchParams({ command: 'skillTreePurchaseLevelUp', skillId: '22b' }));
  assert.equal(fail.result, 'error');
  const player = players.loadPlayer(playerId);
  for (const command of skills.buildInit(player)) assert.equal(codec.decode(codec.encode(command)).rest, 0);
});

test('branch unlock works with zero Seprom and research never invokes or consumes Skylab',()=>{
 for(const [id,n]of [['18a',2],['13',2],['17',5],['20',5]])set(id,n);
 db.prepare('UPDATE skylab_resources SET amount=0 WHERE player_id=? AND ore_type=7').run(playerId);
 const before=skills.state(playerId),response=api.render(playerId);
 const skill=response.html_skills.match(/id="skill_22a"[\s\S]*?(?=<div id="skill_|$)/)[0];
 assert.match(skill,/data-unlocked="1"/);assert.match(skill,/sendSkillTreeUpdate\('22a',this\)/);assert.match(skill,/class="skill_effect\s/);
 const locked=response.html_skills.match(/id="skill_22b"[\s\S]*?(?=<div id="skill_|$)/)[0];assert.match(locked,/data-unlocked="0"/);assert.match(locked,/skill_effect_inactive/);
 assert.match(response.html_tooltips,/Seprom gerekmez/);assert.match(response.footerText,/Seprom gerekmez/);
 const skylab=require('../game/skylab'),originalState=skylab.state;skylab.state=()=>{throw Error('Skylab must not be called');};
 try{assert.equal(api.render(playerId).newResearchPoints,before.available);assert.equal(api.handle(playerId,'/ajax/skillTree.php',new URLSearchParams({command:'skillTreePurchaseLevelUp',skillId:'22a'})).result,'OK');}finally{skylab.state=originalState;}
 assert.equal(skills.state(playerId).levels['22a'],1);assert.equal(skills.state(playerId).used,before.used+1);
 assert.equal(db.prepare('SELECT amount FROM skylab_resources WHERE player_id=? AND ore_type=7').get(playerId).amount,0);
 assert.ok(skills.definitions.every(def=>skills.costs(def,0).seprom===0));
});

test('all 25 source branch rules honor each required group rather than total unrelated spent points',()=>{
 for(const def of skills.definitions){
  const levels={};for(const group of def.requirements)for(const id of group.skills)levels[id]=Math.max(levels[id]||0,group.points);
  assert.equal(skills.prerequisites(def,levels),true,def.id);
  for(const group of def.requirements){const blocked={...levels};for(const id of group.skills)blocked[id]=0;
   if(group.each)for(const id of group.skills.slice(1))blocked[id]=group.points;
   else blocked[group.skills[0]]=group.points-1;
   assert.equal(skills.prerequisites(def,blocked),false,`${def.id}: ${group.skills}`);
  }
 }
});
