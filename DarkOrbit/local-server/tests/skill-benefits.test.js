'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),skills=require('../game/skills'),api=require('../web/skills-api'),World=require('../game/world'),codec=require('../game/codec/codec');
let db,index=0;const originalWorld=World.current;
before(()=>{database.close();db=database.open(':memory:');World.current=()=>null;});after(()=>{World.current=originalWorld;database.close();});
function fixture(){const n=`bio-benefit-${++index}`,a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(n,'test'),id=players.createPlayer(Number(a.lastInsertRowid),n,1,{...require('../config.json').starter,credits:100000000,uridium:1000000});skills.state(id);db.prepare('UPDATE skill_accounts SET earned_points=50 WHERE player_id=?').run(id);return id;}
function rank(pid,id,n){db.prepare('DELETE FROM player_skills WHERE player_id=?').run(pid);if(n)db.prepare('INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,?,?)').run(pid,id,n);}
// Independently pinned expected tables: official FAQ, except captured newer
// Electro-Optics edition. Test every rank, not only final all-skills fixtures.
const expected={
 '1':['mineRadiusMultiplier',[4,8,12,18,25],1],'2':['npcEpMultiplier',[2,4,6,8,12],1],'4':['cargo',[4,8,12,18,25],0],
 '5a':['mineDamageMultiplier',[7,14],1],'5b':['mineDamageMultiplier',[21,28,50],1],'6':['rocketMultiplier',[2,4,6,8,15],1],
 '8':['absorb',[2,4,6,8,12],0],'9':['npcCreditsMultiplier',[4,8,12,18,25],1],'11':['npcLaserMultiplier',[2,4,6,8,12],1],
 '13':['repairMultiplier',[5,10,15,20,30],1],'14':['cargoLootMultiplier',[1,2,3,4,6],1],'15':['bonusLootMultiplier',[2,6,10,15,20],1],
 '16a':['evasion',[2,4],0],'16b':['evasion',[6,8,12],0],'17':['shield',[4,8,12,18,25],0],
 '18a':['hull',[5000,10000],0],'18b':['hull',[15000,25000,50000],0],'19':['laserAccuracy',[5,10,15,20,25],0],
 '20':['rocketAccuracy',[1,2,4,6,10],0],'21a':['honourMultiplier',[4,8],1],'21b':['honourMultiplier',[12,18,25],1],
 '22a':['pvpLaserMultiplier',[2,4],1],'22b':['pvpLaserMultiplier',[6,8,12],1],'23a':['bonusUridiumMultiplier',[2,4],1],'23b':['bonusUridiumMultiplier',[6,8,12],1]
};

test('all25 pilot skills provide their source effect at every rank with matching currentnextbenefit',()=>{
 const pid=fixture();assert.equal(Object.keys(expected).length,25);assert.equal(Object.keys(skills.BENEFITS).length,25);
 for(const def of skills.definitions){const [field,table,base]=expected[def.id];assert.equal(table.length,def.max);
  for(let n=0;n<=def.max;n++){rank(pid,def.id,n);const effect=skills.effects(pid),amount=n?table[n-1]:0,actual=field==='hull'?amount:base+amount/100;assert.equal(effect[field],actual,`${def.id} rank${n} ${field}`);
   const summary=skills.benefitSummary(def.id,{[def.id]:n});assert.equal(summary.current.amount,amount);assert.equal(summary.next?.amount,n<def.max?table[n]:undefined);assert.ok(summary.current.text.includes(amount.toLocaleString('tr-TR')));
  }
 }
});

test('secondstage skills replace firststage total rather than adding both bonuses',()=>{
 const pid=fixture();for(const [second,b]of Object.entries(skills.BENEFITS).filter(([,b])=>b.replaces)){
  const first=b.replaces,firstMax=skills.byId.get(first).max;db.prepare('DELETE FROM player_skills WHERE player_id=?').run(pid);db.prepare('INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,?,?),(?,?,1)').run(pid,first,firstMax,pid,second);
  const [field,table,base]=expected[second];assert.equal(skills.effects(pid)[field],field==='hull'?table[0]:base+table[0]/100,second);
  const summary=skills.benefitSummary(first,{[first]:firstMax,[second]:1});assert.equal(summary.current.id,second);assert.equal(summary.current.amount,b.values[0]);
 }
 assert.throws(()=>skills.benefit('19',6),/Geçersiz/);assert.throws(()=>skills.benefit('__proto__',1),/Yetenek/);
});

test('all25 originaltheme tooltips now show concrete current and next gains and PvP scope',()=>{
 const pid=fixture(),page=api.render(pid);for(const def of skills.definitions){const block=page.html_tooltips.split(`id="skill_${def.id}_info"`)[1].split('tooltip_footer')[0];assert.ok(block.includes(`data-skill-benefit="${def.id}"`));assert.match(block,/Mevcut etkin bonus:/);assert.match(block,/Sonraki kazanım:/);assert.ok(block.includes(skills.benefit(def.id,1).amount.toLocaleString('tr-TR')));}
 assert.match(page.html_tooltips,/Yalnız PvP/);assert.match(page.html_tooltips,/NPC hasarını artırmaz/);assert.match(page.html_tooltips,/II\. aşamadaki değer toplam etkidir/);assert.match(page.skillResetButtonContainer,/300\.000 U\./);assert.match(page.footerText,/Seprom gerekmez/);
});

test('live upgrades and reset immediately update realWorld stats packets and preserve damage and pendingwallet',()=>{
 const pid=fixture(),world=new World(structuredClone(require('../config.json'))),sent=[],session={send:b=>sent.push(codec.decode(b.subarray(3)).obj)};
 const p=world.login(session,pid);World.current=()=>world;p.hitPoints-=1234;p.nanoHull=500;p.credits+=123;p.uridium+=456;const hp=p.hitPoints,hull=p.hitMax,nano=p.nanoHull,credits=p.credits;
 try{
  skills.upgrade(pid,'18a');assert.equal(p.hitMax,hull+5000);assert.equal(p.stats.skills.hull,5000);assert.equal(p.hitPoints,hp);assert.equal(p.nanoHull,nano);assert.equal(p.credits,credits-skills.costs(skills.byId.get('18a'),0).credits);assert.equal(p.uridium,1000456);
  assert.ok(sent.some(c=>c._==='HitpointInfoCommand'&&c.hitpointsMax===p.hitMax));assert.ok(sent.some(c=>c._==='SkillTreeListCommand'&&c.list.some(s=>s.id==='18a'&&s.curLevel===1)));
  skills.upgrade(pid,'13');const old=p.stats.skills.repairMultiplier;assert.equal(old,1.05);
  const beforeReset=p.uridium;skills.reset(pid);assert.equal(p.hitMax,hull);assert.equal(p.stats.skills.hull,0);assert.equal(p.stats.skills.repairMultiplier,1);assert.equal(p.hitPoints,hp);assert.equal(p.uridium,beforeReset-300000);assert.equal(skills.state(pid).available,50);assert.equal(db.prepare('SELECT credits FROM players WHERE id=?').get(pid).credits,p.credits);
 }finally{World.current=()=>null;}
});

test('TractorII20percent and Luck12percent grant actual normalbox loot and CargoI only boosts enemycargo',()=>{
 const pid=fixture(),world=new World(structuredClone(require('../config.json'))),sent=[],session={send:b=>sent.push(codec.decode(b.subarray(3)).obj)},p=world.login(session,pid);
 db.prepare('INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,?,?),(?,?,?),(?,?,?)').run(pid,'15',5,pid,'23b',3,pid,'14',5);
 World.current=()=>world;try{
  world.refreshStats();const {Collectables}=require('../game/collectables');world.collectables=new Collectables(world,require('../game/net').sendCmd);
  const before={credits:p.credits,uridium:p.uridium};const box=world.collectables.add({x:p.x,y:p.y,boxType:'BONUS_BOX',bonus:true,reward:{credits:1000,uridium:1000,energy:100},expires:Date.now()+60000});assert.equal(world.collectables.collect(session,{itemHash:box.hash}),true);
  assert.equal(p.credits-before.credits,1200);assert.equal(p.uridium-before.uridium,1344);assert.equal(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(pid).energy,120);
  const cargo=world.collectables.add({x:p.x,y:p.y,boxType:'FROM_SHIP',ores:[{type:0,amount:100}],expires:Date.now()+60000});assert.equal(world.collectables.collect(session,{itemHash:cargo.hash}),true);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=0').get(pid).amount,106);
  const ore=world.collectables.add({x:p.x,y:p.y,oreType:1,amount:100,expires:Date.now()+60000});assert.equal(world.collectables.collect(session,{itemHash:ore.hash}),true);assert.equal(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=1').get(pid).amount,100);
 }finally{World.current=()=>null;}
});

test('Bounty Hunter gives visual qualification and playerdamage scalar without extra NPC laser damage',()=>{
 const pid=fixture();db.prepare('INSERT INTO player_skills(player_id,skill_id,level)VALUES(?,?,?),(?,?,?)').run(pid,'22a',2,pid,'22b',3);const s=skills.effects(pid);assert.equal(s.pvpLaserMultiplier,1.12);assert.equal(s.npcLaserMultiplier,1);assert.equal(skills.hasThickLasers(pid),true);
});
