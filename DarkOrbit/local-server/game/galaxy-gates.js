'use strict';
// Client contracts plus pinned official classic gate content. Runtime snapshots
// isolate active runs from future catalog/balance updates; see docs/gate-content.md.
const content = require('./galaxy-gate-content');
const DEFINITIONS = {
  1: { map: 51, name: 'alpha', parts: 34, waves: 40 },
  2: { map: 52, name: 'beta', parts: 48, waves: 40 },
  3: { map: 53, name: 'gamma', parts: 82, waves: 40 },
  4: { map: 55, name: 'delta', parts: 128, waves: 29 },
  5: { map: 70, name: 'epsilon', parts: 99, waves: 30 },
  6: { map: 73, name: 'zeta', parts: 111, waves: 46 },
  7: { map: 74, name: 'kappa', parts: 120, waves: 29 },
  8: { map: 75, name: 'lambda', parts: 45, waves: 21 },
  12: { map: 76, name: 'kronos', parts: 21, waves: 50 },
  13: { map: 203, name: 'hades', parts: 45, waves: 12 },
  19: { map: 300, name: 'streuner', parts: 100, waves: 54 }
};
const MAPS = new Set(Object.values(DEFINITIONS).map(gate => gate.map));
const LIFE_PRICE = 10000;
// SWF DefineBinaryData176, UberAssetsLib_LIB_PORTALS_XML. These are asset IDs,
// not builder IDs/map IDs; 1 is only the ordinary return portal.
const PORTAL_DESIGNS={1:2,2:3,3:4,4:5,5:53,6:54,7:70,8:71,12:72,13:74,19:82};
function dbFor(world, services = {}) { return services.db || world?.gatesDb || require('./db').open(); }
function tx(db, fn) {
  db.exec('SAVEPOINT galaxy_runtime');
  try { const result = fn(); db.exec('RELEASE galaxy_runtime'); return result; }
  catch (error) { db.exec('ROLLBACK TO galaxy_runtime; RELEASE galaxy_runtime'); throw error; }
}
function isGateMap(mapId) { return MAPS.has(Number(mapId)); }
function ownedRun(world, db = dbFor(world)) {
  const p = world.player;
  if (!p) return null;
  return db.prepare("SELECT * FROM galaxy_gate_runs WHERE player_id=? AND map_id=? AND state='active' ORDER BY id DESC LIMIT 1").get(p.userId, p.mapId) || null;
}
function canEnter(world, mapId) {
  if (!isGateMap(mapId)) return true;
  if (entryRestriction(world,mapId)) return false;
  const p = world.player;
  return !!p && !!dbFor(world).prepare("SELECT 1 FROM galaxy_gate_runs WHERE player_id=? AND map_id=? AND state='active' AND lives>0").get(p.userId, mapId);
}
// The original Hades is a4–8pilot group instance. There is no group-instance
// service in this solo runtime yet: owning a gate alone must not bypass entry.
// Do not accept client-supplied member counts or a configuration-only fake group.
function entryRestriction(world,mapId){
  return Number(mapId)===203?'Hades Kapısı için 4–8 kişilik bir grup gereklidir. Bu solo sunucuda grup sistemi henüz etkin değil.':null;
}
function evacuateUnadmitted(world){
  const p=world.player;if(!p||!entryRestriction(world,p.mapId))return false;
  const home=homeFor(dbFor(world),p);if(!home)return true;
  const owner=p.userId,map=p.mapId;
  const leave=()=>{if(world.player?.userId===owner&&world.player.mapId===map)returnHome(world,{home_map:home.id});};
  if(world.schedule)world.schedule(leave,0);else leave();
  return true;
}
function send(world, session, command, services = {}) {
  (services.sendCmd || world.combat?.send || require('./net').sendCmd)(session, command);
}
function broadcast(world, command) { for (const session of world.sessions) send(world, session, command); }
function homeFor(db, p) { return db.prepare('SELECT * FROM maps WHERE faction_id=? AND is_start=1').get(p.factionId); }
function rewardPolicy(world, waves) {
  const configured = world.config?.galaxyGates?.completionReward;
  const reward = configured || { credits: waves * 1000, uridium: waves * 100, ep: waves * 1000, honour: waves * 100, ammunition: waves * 100 };
  for (const key of ['credits', 'uridium', 'ep', 'honour', 'ammunition'])
    if (!Number.isSafeInteger(reward[key] ?? 0) || (reward[key] ?? 0) < 0 || (reward[key] ?? 0) > 1000000000) throw new Error('Invalid galaxy gate reward policy');
  return reward;
}
function oldDefinition(db, type) {
  const npc = db.prepare('SELECT * FROM npc_types WHERE type_id=?').get(type);
  if (!npc) throw new Error(`Legacy galaxy gate NPC missing: ${type}`);
  return { typeId: npc.type_id, name: npc.name, hitpoints: npc.hitpoints, shield: npc.shield, speed: npc.speed,
    damageMin: npc.damage_min, damageMax: npc.damage_max, shieldAbsorb: .5, aggressive: true, respawnMs: 0,
    reward: { ep: 0, honour: 0, credits: 0, uridium: 0 } };
}
function newPlan(world, gateId, db) {
  const config = world.config?.galaxyGates || {};
  if (config.waveCount === undefined && config.npcsPerWave === undefined) {
    if(gateId===12)return require('./kronos').build(world.player,config);
    const plan = content.build(gateId);
    if (gateId === 19 && config.kuiperShipChance !== undefined) {
      if (!Number.isFinite(config.kuiperShipChance) || config.kuiperShipChance < 0 || config.kuiperShipChance > 1) throw new Error('Invalid local Kuiper ship chance');
      plan.rewards.rare.chance = config.kuiperShipChance;
    }
    if (gateId === 13 && config.hadesLf4Chance !== undefined) {
      if (!Number.isFinite(config.hadesLf4Chance) || config.hadesLf4Chance < 0 || config.hadesLf4Chance > 1) throw new Error('Invalid local Hades LF4 chance');
      plan.rewards.rare.chance = config.hadesLf4Chance;
    }
    if (config.completionReward) plan.rewards = rewardPolicy(world, plan.phases.length);
    return plan;
  }
  // Explicit isolated QA overrides, never the production fallback.
  const waves = config.waveCount ?? DEFINITIONS[gateId].waves, count = config.npcsPerWave ?? 2;
  if (!Number.isInteger(waves) || waves < 1 || waves > 100 || !Number.isInteger(count) || count < 1 || count > 50) throw new Error('Invalid galaxy gate QA override');
  const def = oldDefinition(db, 84);
  return { version: 'test-override', gateId, rewards: rewardPolicy(world, waves), phases: Array.from({ length: waves }, (_, i) => ({ major: i + 1,
    slots: Array.from({ length: count }, (_, slot) => ({ slot: i * 1000 + slot, phase: i + 1, def })) })) };
}
function legacyPlan(world, run, db) {
  return { version: 'legacy-local-snapshot', gateId: run.gate_id, rewards: JSON.parse(run.rewards_json),
    phases: Array.from({ length: run.wave_count }, (_, i) => {
      const prior = i + 1 === run.wave && run.remaining_json ? JSON.parse(run.remaining_json) : null;
      const count = world.config?.galaxyGates?.npcsPerWave ?? Math.min(6, 2 + Math.floor(i / 10));
      const slots = prior || Array.from({ length: count }, (_, slot) => ({ slot, type: [84,71,119][Math.floor(i / 4) % 3] }));
      return { major: i + 1, slots: slots.map(s => ({ slot: s.slot, phase: i + 1, def: oldDefinition(db, s.type) })) };
    }) };
}
function planFor(world, run, db) {
  if (world.gatePlanCache?.id === run.id && world.gatePlanCache.json === run.plan_json) return world.gatePlanCache.plan;
  let plan;
  if (run.plan_json) plan = JSON.parse(run.plan_json);
  else {
    // Ready-but-never-entered gates adopt real content without consuming parts
    // or resetting lives. Started legacy runs preserve their current content.
    const untouched = run.wave === 1 && run.remaining_json === null && !run.death_pending;
    plan = untouched ? newPlan(world, run.gate_id, db) : legacyPlan(world, run, db);
    run.plan_json = JSON.stringify(plan); run.wave_count = plan.phases.length;
    run.rewards_json = JSON.stringify(plan.rewards); run.released_wave = run.remaining_json ? run.wave : 0;
    db.prepare('UPDATE galaxy_gate_runs SET plan_json=?,wave_count=?,rewards_json=?,released_wave=? WHERE id=?')
      .run(run.plan_json, run.wave_count, run.rewards_json, run.released_wave, run.id);
  }
  world.gatePlanCache = { id: run.id, json: run.plan_json, plan };
  return plan;
}
function setup(session, gateId, services = {}) {
  const world = session.world, p = session.player, gate = DEFINITIONS[gateId];
  const failure = { _: 'GalaxyGateBuilderSetupGateCommand', id: gateId, livesLeft: -1, lifePrice: -1, errorCode: 1 };
  if (!p || world.player !== p || p.dead || !gate) return failure;
  const db = dbFor(world, services), home = homeFor(db, p);
  if (!home) return failure;
  return tx(db, () => {
    const state = db.prepare('SELECT * FROM galaxy_gate_progress WHERE player_id=? AND gate_id=?').get(p.userId, gateId);
    if (!state || state.active || db.prepare("SELECT 1 FROM galaxy_gate_runs WHERE player_id=? AND gate_id=? AND state='active'").get(p.userId, gateId)) return failure;
    const parts = JSON.parse(state.parts_json);
    if (gateId===12) {if(!require('./kronos').consume(db,p.userId))return failure;}
    else if (new Set(parts).size !== gate.parts || parts.some(part => !Number.isInteger(part) || part < 1 || part > gate.parts)) return failure;
    const plan = newPlan(world, gateId, db), waves = plan.phases.length;
    db.prepare("INSERT INTO galaxy_gate_runs(player_id,gate_id,map_id,home_map,state,lives,wave,wave_count,rewards_json,created_at,plan_json) VALUES(?,?,?,?,'active',3,1,?,?,?,?)")
      .run(p.userId, gateId, gate.map, home.id, waves, JSON.stringify(plan.rewards), Date.now(), JSON.stringify(plan));
    db.prepare('UPDATE galaxy_gate_progress SET parts_json=\'[]\',multiplier=0,lives=3,wave=1,active=1 WHERE player_id=? AND gate_id=?').run(p.userId, gateId);
    return { ...failure, livesLeft: 3, lifePrice: LIFE_PRICE, errorCode: 0 };
  });
}
function buyLife(session, gateId, services = {}) {
  const world = session.world, p = session.player, db = dbFor(world, services);
  const energy = p ? db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(p.userId)?.energy || 0 : 0;
  const response = { _: 'GalaxyGateBuilderBuyLifeCommand', gateId, livesLeft: -1, lifePrice: LIFE_PRICE, errorCode: 2,
    samples: energy, multiplier: 0, money: p?.uridium || 0, gateMode: DEFINITIONS[gateId]?.name || '' };
  if (!p || world.player !== p || p.dead || !DEFINITIONS[gateId]) return response;
  const result = tx(db, () => {
    const run = db.prepare("SELECT * FROM galaxy_gate_runs WHERE player_id=? AND gate_id=? AND state='active'").get(p.userId, gateId);
    if (!run || run.lives <= 0 || run.lives >= 10) return response;
    const debit = db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(LIFE_PRICE, p.userId, LIFE_PRICE);
    if (!debit.changes) return { ...response, livesLeft: run.lives, errorCode: 1 };
    db.prepare('UPDATE galaxy_gate_runs SET lives=lives+1 WHERE id=?').run(run.id);
    db.prepare('UPDATE galaxy_gate_progress SET lives=lives+1 WHERE player_id=? AND gate_id=?').run(p.userId, gateId);
    const money = db.prepare('SELECT uridium FROM players WHERE id=?').get(p.userId).uridium;
    return { ...response, livesLeft: run.lives + 1, money, errorCode: 0 };
  });
  if (!result.errorCode) p.uridium = result.money;
  return result;
}
function portalRows(world) {
  const p = world.player;
  if (!p) return [];
  const db = dbFor(world);
  const runs = db.prepare("SELECT * FROM galaxy_gate_runs WHERE player_id=? AND state='active' AND lives>0 ORDER BY gate_id").all(p.userId);
  const rows = [];
  for (const run of runs) {
    const home = db.prepare('SELECT * FROM maps WHERE id=?').get(run.home_map);
    if (p.mapId === run.home_map) {
      const signX = home.faction_id === 1 ? 1 : -1, signY = home.faction_id === 3 ? -1 : 1;
      const sx = signX === 1 ? 2000 : home.width - 2000, sy = signY === 1 ? 2000 : home.height - 2000;
      rows.push({ id: 160000000 + run.id, map_id: p.mapId, x: sx + signX * (2200 + run.gate_id % 5 * 600),
        y: sy + signY * (2200 + Math.floor(run.gate_id / 5) * 700), target_map: run.map_id, target_x: 10500, target_y: 6550,
        min_level: 1, design_id: PORTAL_DESIGNS[run.gate_id]||1, gateRunId: run.id, gateAction: 'enter' });
    } else if (p.mapId === run.map_id && run.waiting_next_wave) {
      // Original major-wave checkpoint: left continues, right returns home.
      // Sub-batches within a major wave continue automatically.
      const map = db.prepare('SELECT * FROM maps WHERE id=?').get(run.map_id);
      const cx = (map?.width || 21000) / 2, cy = (map?.height || 13100) / 2;
      rows.push({ id: 180000000 + run.id, map_id: p.mapId, x: cx - 1500, y: cy,
        target_map: run.map_id, target_x: cx, target_y: cy, min_level: 1,
        design_id: PORTAL_DESIGNS[run.gate_id]||1, gateRunId: run.id, gateAction: 'continue' });
      rows.push({ id: 170000000 + run.id, map_id: p.mapId, x: cx + 1500, y: cy,
        target_map: home.id, target_x: home.start_x, target_y: home.start_y, min_level: 1,
        design_id: 1, gateRunId: run.id, gateAction: 'home' });
    }
  }
  return rows;
}
function prepareTransition(world, portal) {
  if (!portal?.gateRunId) return true;
  // Revalidate after the jump delay: cancelled/stale requests cannot skip a wave.
  const current = portalRows(world).find(row => row.id === portal.id && row.gateRunId === portal.gateRunId && row.target_map === portal.target_map);
  if (!current || world.player.dead) return false;
  if (current.gateAction === 'continue' || current.gateAction === 'enter')
    dbFor(world).prepare("UPDATE galaxy_gate_runs SET waiting_next_wave=0 WHERE id=? AND player_id=? AND state='active'")
      .run(current.gateRunId, world.player.userId);
  return true;
}
function nearestPortal(world) {
  const p = world.updatePosition ? world.updatePosition() : world.player;
  if (!p || p.dead) return null;
  return portalRows(world).filter(gate => Math.hypot(p.x - gate.x, p.y - gate.y) <= 750)
    .sort((a, b) => Math.hypot(p.x - a.x, p.y - a.y) - Math.hypot(p.x - b.x, p.y - b.y))[0] || null;
}
function portals(world) {
  const commands = [], p = world.player;
  for (const portal of portalRows(world)) {
    commands.push({ _: 'JumpgateCreateCommand', gateId: portal.id, factionId: 0, designId: portal.design_id,
      x: portal.x, y: portal.y, isVisibleOnMinimap: true, showBubble: true, decoratorAssetTypes: [] });
    const available = !p.dead && !entryRestriction(world,portal.target_map) && Math.hypot(p.x - portal.x, p.y - portal.y) <= 750;
    commands.push({ _: 'MapAssetActionAvailableCommand', mapAssetId: portal.id, state: available ? 0 : 1, activatable: available,
      toolTip: { _: 'MessageKeyListWildcardCommand', commandList: [] }, additionalInformation: { _: 'AssetInformationModule' } });
  }
  return commands;
}
function defer(world, fn) {
  const owner = world.player?.userId, map = world.player?.mapId;
  const callback = () => { if (world.player?.userId === owner && world.player?.mapId === map) fn(); };
  if (world.schedule) world.schedule(callback, world.config?.galaxyGates?.waveDelayMs ?? 2000);
  else { const timer = setTimeout(callback, 0); timer.unref?.(); }
}
function returnHome(world, run) {
  const session = [...world.sessions].find(s => s.player === world.player);
  if (!session) return;
  const home = dbFor(world).prepare('SELECT * FROM maps WHERE id=?').get(run.home_map);
  if (!home) return;
  if (world.gatesChangeMap) world.gatesChangeMap(session, home.id, home.start_x, home.start_y);
  else require('./gameplay').changeMap(session, home.id, home.start_x, home.start_y);
}
function spawnWave(world, combat) {
  const p = world.player;
  if (!p || !isGateMap(p.mapId)) return false;
  const db = dbFor(world), run = ownedRun(world, db);
  if (p.dead) return true;
  if (!run || run.lives <= 0) {
    const old = db.prepare('SELECT * FROM galaxy_gate_runs WHERE player_id=? AND map_id=? ORDER BY id DESC LIMIT 1').get(p.userId, p.mapId);
    if (old) defer(world, () => returnHome(world, old));
    return true;
  }
  const plan = planFor(world, run, db);
  if (run.waiting_next_wave) return true;
  let remaining = run.remaining_json ? JSON.parse(run.remaining_json) : null;
  if (!remaining || run.released_wave < run.wave) {
    const added = plan.phases[run.wave - 1].slots.map(s => ({ slot: s.slot, phase: s.phase }));
    remaining = [...(remaining || []), ...added]; run.released_wave = run.wave;
    db.prepare('UPDATE galaxy_gate_runs SET remaining_json=?,released_wave=?,death_pending=0 WHERE id=?').run(JSON.stringify(remaining), run.wave, run.id);
  } else if (plan.version === 'legacy-local-snapshot' && remaining.some(s => !s.phase)) {
    remaining = remaining.map(s => ({ slot: s.slot, phase: run.wave }));
    db.prepare('UPDATE galaxy_gate_runs SET remaining_json=?,death_pending=0 WHERE id=?').run(JSON.stringify(remaining), run.id);
  } else if (run.death_pending) db.prepare('UPDATE galaxy_gate_runs SET death_pending=0 WHERE id=?').run(run.id);
  const session = [...world.sessions].find(s => s.player === p);
  const existing = new Set([...world.npcs.values()].filter(n => n.def.gateRunId === run.id).map(n => `${n.def.gateWave}:${n.def.gateSlot}`));
  for (const slot of remaining) {
    if (existing.has(`${slot.phase}:${slot.slot}`)) continue;
    const entry = plan.phases[slot.phase - 1]?.slots.find(s => s.slot === slot.slot);
    if (!entry) throw new Error('Galaxy gate snapshot slot missing');
    combat.spawn({ ...entry.def, respawnMs: 0, reward: { ep: 0, honour: 0, credits: 0, uridium: 0 },
      gateRunId: run.id, gateWave: slot.phase, gateSlot: slot.slot, gateProtectedBy: entry.protectedBy || [] });
  }
  refreshProtection(world, combat);
  if (session) send(world, session, { _: 'GalaxyGateBuilderGateWaveUpdateCommand', gateId: run.gate_id, currWave: run.wave });
  return true;
}
function awardCompletion(db, run) {
  if (db.prepare('SELECT 1 FROM galaxy_gate_completion_claims WHERE run_id=?').get(run.id)) throw new Error('Gate completion already claimed');
  const completion = require('./gate-completion-rewards');
  const rewards = require('./boosters').applyReward(run.player_id, completion.resolve(db, run), { db });
  if(rewards.energy){db.prepare('INSERT OR IGNORE INTO galaxy_gate_accounts(player_id)VALUES(?)').run(run.player_id);db.prepare('UPDATE galaxy_gate_accounts SET energy=energy+? WHERE player_id=?').run(rewards.energy,run.player_id);}
  db.prepare('UPDATE players SET credits=credits+?,uridium=uridium+?,ep=ep+?,honour=honour+? WHERE id=?')
    .run(rewards.credits || 0, rewards.uridium || 0, rewards.ep || 0, rewards.honour || 0, run.player_id);
  const player = db.prepare('SELECT * FROM players WHERE id=?').get(run.player_id);
  const level = Math.max(player.level, require('./progression').levelFor(player.ep));
  db.prepare('UPDATE players SET level=? WHERE id=?').run(level, run.player_id);
  if (rewards.ammunition) {
    const row = db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='ammunition_laser_ucb-100' AND ship_id IS NULL ORDER BY id LIMIT 1").get(run.player_id);
    if (row) db.prepare('UPDATE items SET amount=amount+? WHERE id=?').run(rewards.ammunition, row.id);
    else db.prepare("INSERT INTO items(player_id,loot_id,amount) VALUES(?,'ammunition_laser_ucb-100',?)").run(run.player_id, rewards.ammunition);
  }
  rewards.deliveredItems = completion.deliverItems(db,run.player_id,rewards);
  db.prepare('INSERT INTO galaxy_gate_completion_claims(run_id,reward_json,claimed_at) VALUES(?,?,?)')
    .run(run.id,JSON.stringify(rewards),Date.now());
  const galaxy_gates_done = require('./gate-rings').sync(db, run.player_id);
  return { rewards, player: { ...player, level, galaxy_gates_done } };
}
function isProtected(world, npc) {
  if (!npc?.def?.gateProtectedBy?.length || !world?.player) return false;
  const run = dbFor(world).prepare("SELECT remaining_json,released_wave FROM galaxy_gate_runs WHERE id=? AND player_id=? AND state='active'").get(npc.def.gateRunId, world.player.userId);
  if (!run) return false;
  const alive = new Set(JSON.parse(run.remaining_json || '[]').map(s => `${s.phase}:${s.slot}`));
  return npc.def.gateProtectedBy.some(s => s.phase > run.released_wave || alive.has(`${s.phase}:${s.slot}`));
}
function refreshProtection(world, combat = world.combat, now = Date.now()) {
  if (!world?.player || !isGateMap(world.player.mapId)) return;
  for (const npc of world.npcs.values()) {
    const protectedNow = isProtected(world, npc);
    if (protectedNow && (!npc.gateShieldShown || now - npc.gateShieldShown >= 2000)) {
      npc.gateShieldShown = now;
      for (const session of world.sessions) send(world, session, { _: 'LegacyModule', message: `0|n|ISH|${npc.id}` }, { sendCmd: combat?.send });
    } else if (!protectedNow) npc.gateShieldShown = 0;
  }
}
function npcReward(db, run, entry, world) {
  const skill = require('./skills').effects(run.player_id), formation = world.player.stats?.formation || {}, base = entry.def.reward;
  const reward = require('./boosters').applyReward(run.player_id, { ...base,
    ep: Math.round((base.ep || 0) * (skill.npcEpMultiplier ?? 1) * (formation.ep ?? 1)),
    credits: Math.round((base.credits || 0) * (skill.npcCreditsMultiplier ?? 1)),
    honour: Math.round((base.honour || 0) * (skill.honourMultiplier ?? 1) * (formation.honour ?? 1)) }, { db });
  const claim = db.prepare('INSERT OR IGNORE INTO galaxy_gate_kill_claims(run_id,phase,slot,reward_json,claimed_at) VALUES(?,?,?,?,?)')
    .run(run.id, entry.phase, entry.slot, JSON.stringify(reward), Date.now());
  if (!claim.changes) return null;
  db.prepare('UPDATE players SET credits=credits+?,uridium=uridium+?,ep=ep+?,honour=honour+? WHERE id=?')
    .run(reward.credits || 0, reward.uridium || 0, reward.ep || 0, reward.honour || 0, run.player_id);
  const row = db.prepare('SELECT ep,level FROM players WHERE id=?').get(run.player_id);
  db.prepare('UPDATE players SET level=? WHERE id=?').run(Math.max(row.level, require('./progression').levelFor(row.ep)), run.player_id);
  return reward;
}
function publishReward(world, session, reward) {
  const p = world.player;
  for (const [key, field, code] of [['credits','credits','CRE'],['uridium','uridium','URI'],['ep','ep','EP'],['honour','honourPoints','HON']])
    if (reward[key]) send(world, session, { _: 'LegacyModule', message: `0|LM|ST|${code}|${reward[key]}|${p[field]}${key === 'ep' ? `|${p.level}` : ''}` });
}
function onNpcKilled(world, npc, session) {
  const p = world.player;
  if (!p || !isGateMap(p.mapId) || !npc.def.gateRunId) return false;
  npc.gateKillRewardClaimed = false;
  const db = dbFor(world), run = ownedRun(world, db);
  if (!run || npc.def.gateRunId !== run.id || isProtected(world, npc)) return false;
  const plan = planFor(world, run, db);
  const remaining = JSON.parse(run.remaining_json || '[]');
  if (!remaining.some(slot => slot.slot === npc.def.gateSlot && slot.phase === npc.def.gateWave)) return false;
  const entry = plan.phases[npc.def.gateWave - 1].slots.find(slot => slot.slot === npc.def.gateSlot);
  const next = remaining.filter(slot => !(slot.slot === npc.def.gateSlot && slot.phase === npc.def.gateWave));
  const currentMajor = plan.phases[run.wave - 1].major;
  const sameMajor = run.wave < run.wave_count && plan.phases[run.wave].major === currentMajor;
  const releaseNext = sameMajor && (!next.length || next.every(slot => plan.phases[slot.phase - 1].slots.find(s => s.slot === slot.slot)?.protectedBoss));
  const checkpoint = run.wave < run.wave_count && !sameMajor && !next.length;
  let completed, earned;
  tx(db, () => {
    earned = npcReward(db, run, entry, world);
    if (releaseNext || checkpoint) {
      db.prepare('UPDATE galaxy_gate_runs SET wave=wave+1,remaining_json=?,waiting_next_wave=? WHERE id=?').run(next.length ? JSON.stringify(next) : null, checkpoint ? 1 : 0, run.id);
      db.prepare('UPDATE galaxy_gate_progress SET wave=wave+1 WHERE player_id=? AND gate_id=?').run(p.userId, run.gate_id);
    } else if (next.length) db.prepare('UPDATE galaxy_gate_runs SET remaining_json=? WHERE id=?').run(JSON.stringify(next), run.id);
    else {
      completed = awardCompletion(db, run);
      db.prepare("UPDATE galaxy_gate_runs SET state='won',remaining_json='[]',finished_at=? WHERE id=?").run(Date.now(), run.id);
      db.prepare('UPDATE galaxy_gate_progress SET active=0,lives=-1,wave=0 WHERE player_id=? AND gate_id=?').run(p.userId, run.gate_id);
    }
  });
  npc.gateKillRewardClaimed = !!earned;
  const oldLevel = p.level, balance = completed?.player || db.prepare('SELECT * FROM players WHERE id=?').get(p.userId);
  Object.assign(p, { credits: balance.credits, uridium: balance.uridium, ep: balance.ep, honourPoints: balance.honour, level: balance.level, galaxyGatesDone: balance.galaxy_gates_done });
  if (earned) { publishReward(world, session, earned); if (earned.ep) require('./pet').awardExperience(world, earned.ep); }
  if (p.level > oldLevel) send(world, session, { _: 'LegacyModule', message: `0|A|LUP|${p.level}|${p.ep}` });
  refreshProtection(world);
  if (completed) {
    const rewards = completed.rewards;
    if(rewards.ep)require('./pet').awardExperience(world,rewards.ep);
    require('./progression').event(session,{type:'gateComplete',gateId:run.gate_id,mapId:p.mapId,eventId:`gate-run:${run.id}`,amount:1});
    require('./ammo').notify(p);
    if (rewards.deliveredItems?.['booster_kappa-b01']) {
      p.boosterSignature = undefined; world.refreshStats?.();
      for (const command of require('./boosters').buildInit(p,{db})) send(world,session,command);
    }
    if (rewards.deliveredItems?.['resource_booty-key'])
      for (const command of require('./booty').buildInit(p,db)) send(world,session,command);
    const special = rewards.outcome?.lootId;
    const specialNames = { 'equipment_weapon_laser_lf-4':'LF-4', drone_designs_havoc:'Havoc',
      drone_designs_hercules:'Hercules', 'booster_kappa-b01':'Kappa çoklu güçlendirici', 'ship_a-elite':'Aegis Elite',
      'ship_c-elite':'Citadel Elite','ship_s-elite':'Spearhead Elite',ship_venom:'Venom',ship_pusat:'Pusat' };
    if (special && !rewards.outcome.compensation && !rewards.outcome.alreadyOwned) send(world,session,{_:'LegacyModule',message:`0|A|STD|Kapı ek ödülü: ${specialNames[special] || (special==='ship_g-saturn'?'Saturn':'Özel eşya')} ×1.`});
    if (rewards.outcome?.compensation) send(world,session,{_:'LegacyModule',message:`0|A|STD|Kapı gemisi zaten mevcut: ${rewards.outcome.compensation} Uridium karşılığı verildi.`});
    for (const [key, field, code] of [['credits', 'credits', 'CRE'], ['uridium', 'uridium', 'URI'], ['ep', 'ep', 'EP'], ['honour', 'honourPoints', 'HON']])
      if (rewards[key]) send(world, session, { _: 'LegacyModule', message: `0|LM|ST|${code}|${rewards[key]}|${p[field]}${key === 'ep' ? `|${p.level}` : ''}` });
    broadcast(world, { _: 'GalaxyGateBuilderGateCompleteCommand', gateId: run.gate_id, currPart: 0 });
    defer(world, () => returnHome(world, run));
  } else if (checkpoint) {
    for (const command of portals(world)) broadcast(world, command);
    broadcast(world, { _: 'LegacyModule', message: '0|A|STD|Dalga tamamlandı. Sol portal: devam et. Sağ portal: üsse dön; kapı ilerlemen korunur.' });
  } else if (releaseNext) defer(world, () => spawnWave(world, world.combat));
  return true;
}
function onPlayerDeath(world) {
  const p = world.player;
  if (!p || !p.dead || !isGateMap(p.mapId)) return false;
  const db = dbFor(world), run = ownedRun(world, db);
  if (!run || run.death_pending) return false;
  const lives = Math.max(0, run.lives - 1);
  const plan = planFor(world, run, db), major = plan.phases[run.wave - 1].major;
  const restart = ['official-classic-2026-10-20','official-kronos-2026-10-23'].includes(plan.version) ? plan.phases.findIndex(phase => phase.major === major) + 1 : run.wave;
  tx(db, () => {
    db.prepare("UPDATE galaxy_gate_runs SET lives=?,death_pending=1,waiting_next_wave=0,remaining_json=NULL,wave=?,released_wave=?,state=?,finished_at=? WHERE id=?")
      .run(lives, restart, restart - 1, lives ? 'active' : 'failed', lives ? null : Date.now(), run.id);
    db.prepare('UPDATE galaxy_gate_progress SET lives=?,active=?,wave=? WHERE player_id=? AND gate_id=?').run(lives, lives ? 1 : 0, restart, p.userId, run.gate_id);
  });
  broadcast(world, { _: 'GalaxyGateBuilderGateLifeLostCommand', gateId: run.gate_id, livesLeft: lives });
  return true;
}
module.exports = { DEFINITIONS, PORTAL_DESIGNS, LIFE_PRICE, setup, buyLife, portals, portalRows, nearestPortal, prepareTransition,entryRestriction,evacuateUnadmitted,
  isGateMap, canEnter, spawnWave, onNpcKilled, onPlayerDeath, isProtected, isNpcProtected: isProtected, refreshProtection };
