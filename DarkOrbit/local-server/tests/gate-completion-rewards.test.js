'use strict';
const { test, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const database = require('../game/db'), players = require('../game/db/players');
const content = require('../game/galaxy-gate-content'), completion = require('../game/gate-completion-rewards');
const gates = require('../game/galaxy-gates'), systems = require('../game/handlers/systems');
let db, playerId;
beforeEach(() => {
  database.close(); db = database.open(':memory:');
  const account = db.prepare("INSERT INTO accounts(username,password_hash,created_at) VALUES('gate-reward','test',0)").run();
  playerId = players.createPlayer(Number(account.lastInsertRowid),'gate-reward',1,require('../config.json').starter);
});
afterEach(() => database.close());
function savedRun(id, rewards = content.completionReward(id), state = 'active') {
  const result = db.prepare('INSERT INTO galaxy_gate_runs(player_id,gate_id,map_id,home_map,state,lives,wave,wave_count,rewards_json,created_at) VALUES(?,?,?,1,?,3,1,1,?,0)')
    .run(playerId,id,gates.DEFINITIONS[id].map,state,JSON.stringify(rewards));
  return db.prepare('SELECT * FROM galaxy_gate_runs WHERE id=?').get(Number(result.lastInsertRowid));
}
const total = loot => db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,loot).n;
test('all ten base completion amounts match the pinned classic source table', () => {
  const expected = {
    1:[4000000,100000,20000,20000,2,2,0],2:[8000000,200000,40000,40000,4,4,0],
    3:[12000000,300000,60000,60000,10,6,0],4:[9000000,225000,45000,45000,8,5,0],
    5:[5000000,150000,25000,20000,10,0,5],6:[6000000,200000,35000,25000,50,0,25],
    7:[9000000,350000,15000,30000,10,0,5],8:[2750000,100000,15000,10000,3,0,5],
    13:[4000000,200000,20000,15000,8,0,4],19:[2000000,150000,15000,0,0,0,5]
  };
  for (const [id, row] of Object.entries(expected)) {
    const reward=content.completionReward(+id);
    assert.deepEqual([reward.ep,reward.honour,reward.uridium,reward.ammunition,reward.items.resource_logfile||0,
      reward.items.resource_repairvoucher||0,reward.items['resource_booty-key']||0],row);
    assert.equal(reward.credits,0); assert.equal(reward.items['resource_booty-key-red'],undefined);
  }
});
test('first Epsilon and Zeta manual wins guarantee the permanent reward without a roll', () => {
  for (const [id,loot] of [[5,'equipment_weapon_laser_lf-4'],[6,'drone_designs_havoc']]) {
    const reward=completion.resolve(db,savedRun(id),()=>{throw Error('first win must not roll');});
    assert.equal(reward.items[loot],1); assert.equal(reward.outcome.first,true); assert.equal(reward.outcome.roll,null);
    completion.deliverItems(db,playerId,reward); assert.equal(total(loot),1);
  }
});
test('previous won runs consume first guarantee; failed runs and other players do not', () => {
  savedRun(5,content.completionReward(5),'failed');
  const first=savedRun(5);
  assert.equal(completion.resolve(db,first,()=>.999).items['equipment_weapon_laser_lf-4'],1);
  db.prepare("UPDATE galaxy_gate_runs SET state='won' WHERE id=?").run(first.id);
  const next=savedRun(5);
  assert.equal(completion.resolve(db,next,()=>.249999).items['equipment_weapon_laser_lf-4'],1);
  assert.equal(completion.resolve(db,next,()=>.25).items['equipment_weapon_laser_lf-4'],undefined);
});
test('classic Zeta is 33 percent and local Hades default is 25 percent; RNG boundaries are exclusive', () => {
  savedRun(6,content.completionReward(6),'won'); const zeta=savedRun(6);
  assert.equal(completion.resolve(db,zeta,()=>.329999).items.drone_designs_havoc,1);
  assert.equal(completion.resolve(db,zeta,()=>.33).items.drone_designs_havoc,undefined);
  const hades=savedRun(13);
  assert.equal(JSON.parse(hades.rewards_json).rare.chanceSource,'local-unpublished');
  assert.equal(completion.resolve(db,hades,()=>.249999).items['equipment_weapon_laser_lf-4'],1);
  assert.equal(completion.resolve(db,hades,()=>.25).items['equipment_weapon_laser_lf-4'],undefined);
});
test('Kappa chooses exactly one of Hercules, LF4, multi booster or no rare reward', () => {
  const run=savedRun(7);
  for (const [roll,loot] of [[0,'drone_designs_hercules'],[.25,'equipment_weapon_laser_lf-4'],[.5,'booster_kappa-b01'],[.75,null]]) {
    const reward=completion.resolve(db,run,()=>roll); assert.equal(reward.outcome.lootId,loot);
    assert.equal(Object.keys(reward.items).filter(k=>['drone_designs_hercules','equipment_weapon_laser_lf-4','booster_kappa-b01'].includes(k)).length,loot?1:0);
  }
});
test('permanent rewards remain distinct equipable rows; Kappa booster gets actual supported effects', () => {
  completion.deliverItems(db,playerId,{items:{'equipment_weapon_laser_lf-4':2,drone_designs_havoc:2,drone_designs_hercules:1}});
  const rows=db.prepare("SELECT loot_id,amount,ship_id FROM items WHERE player_id=? AND loot_id IN('equipment_weapon_laser_lf-4','drone_designs_havoc','drone_designs_hercules')").all(playerId);
  assert.equal(rows.length,5); assert.ok(rows.every(r=>r.amount===1 && r.ship_id===null));
  completion.deliverItems(db,playerId,{items:{'booster_kappa-b01':1}},{now:1000});
  const booster=db.prepare('SELECT * FROM player_boosters WHERE player_id=?').get(playerId);
  assert.equal(booster.expires_at,18001000);
  const effects=require('../game/boosters').effects(playerId,{db,now:1001});
  assert.equal(effects.DAMAGE,5); assert.equal(effects.SHIELD,5); assert.equal(effects.EXPERIENCE_POINTS,5);
});
test('Kuiper local chance grants one of five ships, owned ship gives classic 200k only on winning roll', () => {
  const run=savedRun(19), rare=JSON.parse(run.rewards_json).rare;
  assert.equal(rare.chanceSource,'local-unpublished');
  for (let i=0;i<completion.KUIPER_SHIPS.length;i++) {
    const values=[.01,(i+.1)/5], reward=completion.resolve(db,run,()=>values.shift());
    assert.equal(reward.ship,completion.KUIPER_SHIPS[i]); assert.equal(reward.uridium,15000);
    completion.deliverItems(db,playerId,reward);
    const repeated=[.01,(i+.1)/5], owned=completion.resolve(db,run,()=>repeated.shift());
    assert.equal(owned.ship,undefined); assert.equal(owned.uridium,215000); assert.equal(owned.outcome.compensation,200000);
  }
  const miss=completion.resolve(db,run,()=>.1); assert.equal(miss.ship,undefined); assert.equal(miss.uridium,15000);
});
test('Kronos source parts are delivered to inventory and capped at shipped per-gate slot counts', () => {
  for (const [id,cap] of [[1,4],[2,3],[3,1],[4,1],[5,4],[6,1],[7,2],[8,5]]) {
    const reward=content.completionReward(id), loot=Object.keys(reward.items).find(k=>k.includes('kronos-'));
    for(let i=0;i<cap+2;i++) completion.deliverItems(db,playerId,{items:{[loot]:1}});
    assert.equal(total(loot),cap);
  }
});
test('old saved reward snapshots receive no invented random extra or Kronos parts', () => {
  const old={ep:42,uridium:7,items:{resource_logfile:1}}, run=savedRun(5,old);
  assert.deepEqual(completion.resolve(db,run,()=>{throw Error('old snapshot must not roll');}),old);
});
test('invalid RNG and unknown permanent loot reject before issuing equipment', () => {
  const hades=savedRun(13), before=total('equipment_weapon_laser_lf-4');
  for(const invalid of [-1,1,NaN,Infinity]) assert.throws(()=>completion.resolve(db,hades,()=>invalid),/Invalid gate completion roll/);
  assert.throws(()=>completion.deliverItems(db,playerId,{items:{ship_phoenix:1}}),/Unknown gate completion item/);
  assert.equal(total('equipment_weapon_laser_lf-4'),before);
});

function finalNpc(gateId,roll=.99) {
  const p=players.loadPlayer(playerId),sent=[], world={player:p,gatesDb:db,config:{},npcs:new Map(),sessions:new Set(),schedule(){}};
  world.combat={send(s,c){sent.push(c);},spawn(def){const npc={id:999,def};world.npcs.set(npc.id,npc);return npc;}};
  const session={world,player:p};world.sessions.add(session);systems.gateInfo(p,db);
  const parts=Array.from({length:gates.DEFINITIONS[gateId].parts},(_,i)=>i+1);
  db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=?').run(JSON.stringify(parts),playerId,gateId);
  assert.equal(gates.setup(session,gateId,{db}).errorCode,0);
  const run=db.prepare("SELECT * FROM galaxy_gate_runs WHERE player_id=? AND state='active'").get(playerId);
  const plan=JSON.parse(run.plan_json);plan.phases=[{major:1,slots:[{slot:0,phase:1,def:require('../game/npc-catalog').get('streuner')}]}];
  db.prepare('UPDATE galaxy_gate_runs SET wave_count=1,plan_json=? WHERE id=?').run(JSON.stringify(plan),run.id);
  p.mapId=run.map_id;gates.spawnWave(world,world.combat);
  const original=completion.resolve;completion.resolve=(db,run)=>original(db,run,()=>roll);
  return {run,world,session,npc:[...world.npcs.values()][0],sent,restore(){completion.resolve=original;}};
}
test('actual final kill atomically grants rare/base/keys, records result once and rejects replay', () => {
  const f=finalNpc(6),before=players.loadPlayer(playerId).uridium;
  try {
    assert.equal(gates.onNpcKilled(f.world,f.npc,f.session),true);
    assert.equal(total('drone_designs_havoc'),1);assert.equal(total('resource_booty-key'),25);
    const claim=db.prepare('SELECT * FROM galaxy_gate_completion_claims WHERE run_id=?').get(f.run.id);
    assert.equal(JSON.parse(claim.reward_json).deliveredItems.drone_designs_havoc,1);
    assert.equal(JSON.parse(claim.reward_json).outcome.first,true);
    assert.equal(f.world.player.uridium,before+35001);
    assert.equal(gates.onNpcKilled(f.world,f.npc,f.session),false);assert.equal(total('drone_designs_havoc'),1);
    assert.ok(f.sent.some(c=>c.message?.includes('Havoc')));
    assert.ok(f.sent.some(c=>c.message==='0|A|BK|25'));
    assert.ok(f.sent.some(c=>c.message==='0|A|BKR|0'));
    assert.ok(f.sent.some(c=>c.message==='0|A|BKB|0'));
  } finally {f.restore();}
});
test('local unpublished chances are validated and snapshotted without altering an existing ready run', () => {
  const p=players.loadPlayer(playerId),world={player:p,gatesDb:db,config:{galaxyGates:{kuiperShipChance:.75,hadesLf4Chance:.8}}},session={world,player:p};
  systems.gateInfo(p,db);
  for(const [id,chance] of [[19,.75],[13,.8]]) {
    const parts=Array.from({length:gates.DEFINITIONS[id].parts},(_,i)=>i+1);
    db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=?').run(JSON.stringify(parts),playerId,id);
    assert.equal(gates.setup(session,id,{db}).errorCode,0);
    const run=db.prepare("SELECT rewards_json,plan_json FROM galaxy_gate_runs WHERE player_id=? AND gate_id=? AND state='active'").get(playerId,id);
    assert.equal(JSON.parse(run.rewards_json).rare.chance,chance);
    assert.equal(JSON.parse(run.plan_json).rewards.rare.chance,chance);
    world.config.galaxyGates[id===19?'kuiperShipChance':'hadesLf4Chance']=.01;
    assert.equal(gates.setup(session,id,{db}).errorCode,1);
    assert.deepEqual(db.prepare("SELECT rewards_json,plan_json FROM galaxy_gate_runs WHERE player_id=? AND gate_id=? AND state='active'").get(playerId,id),run);
  }
});
test('invalid configured Kuiper or Hades chances roll back setup without consuming completed parts', () => {
  const p=players.loadPlayer(playerId),world={player:p,gatesDb:db,config:{galaxyGates:{}}},session={world,player:p};
  systems.gateInfo(p,db);
  for(const [id,key] of [[19,'kuiperShipChance'],[13,'hadesLf4Chance']]) {
    const parts=JSON.stringify(Array.from({length:gates.DEFINITIONS[id].parts},(_,i)=>i+1));
    db.prepare('UPDATE galaxy_gate_progress SET parts_json=? WHERE player_id=? AND gate_id=?').run(parts,playerId,id);
    for(const invalid of [-.01,1.01,NaN,'0.5']) {
      world.config.galaxyGates[key]=invalid;
      assert.throws(()=>gates.setup(session,id,{db}),/Invalid local/);
      assert.equal(db.prepare('SELECT parts_json FROM galaxy_gate_progress WHERE player_id=? AND gate_id=?').get(playerId,id).parts_json,parts);
      assert.equal(db.prepare('SELECT count(*) n FROM galaxy_gate_runs WHERE player_id=? AND gate_id=?').get(playerId,id).n,0);
    }
    delete world.config.galaxyGates[key];
  }
});
test('completion claim storage failure rolls back rare equipment, key delivery, kill reward and win state', () => {
  const f=finalNpc(5),before=players.loadPlayer(playerId).uridium,packets=f.sent.length;
  try {
    db.exec("CREATE TRIGGER reject_gate_completion BEFORE INSERT ON galaxy_gate_completion_claims BEGIN SELECT RAISE(ABORT,'reject completion'); END");
    assert.throws(()=>gates.onNpcKilled(f.world,f.npc,f.session),/reject completion/);
    assert.equal(total('equipment_weapon_laser_lf-4'),0);assert.equal(total('resource_booty-key'),0);
    assert.equal(f.world.player.uridium,before);assert.equal(f.sent.length,packets);
    assert.equal(db.prepare('SELECT state FROM galaxy_gate_runs WHERE id=?').get(f.run.id).state,'active');
    assert.equal(db.prepare('SELECT COUNT(*) n FROM galaxy_gate_kill_claims').get().n,0);
    db.exec('DROP TRIGGER reject_gate_completion');assert.equal(gates.onNpcKilled(f.world,f.npc,f.session),true);
    assert.equal(total('equipment_weapon_laser_lf-4'),1);
  } finally {f.restore();}
});
