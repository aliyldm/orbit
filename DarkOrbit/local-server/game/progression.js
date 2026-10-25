'use strict';
// Local progression/balance: thresholds double from 10,000 EP for level 2.
// Combat/spawn/reward tuning remains configurable emulation, not live formulas.
function levelFor(ep) { let level = 1; while (level < 32 && ep >= 10000 * 2 ** (level - 1)) level++; return level; }
function grant(world, send, session, reward) {
  reward = require('./boosters').applyReward(world.player.userId, reward);
  const p = world.player; const before = { ep: p.ep, honourPoints: p.honourPoints, credits: p.credits, uridium: p.uridium, level: p.level };
  p.ep += reward.ep || 0; p.honourPoints += reward.honour || 0; p.credits += reward.credits || 0; p.uridium += reward.uridium || 0;
  p.level = Math.max(p.level, levelFor(p.ep));
  try { world.save(); } catch (e) { Object.assign(p, before); throw e; }
  for (const [key,field,code] of [['ep','ep','EP'],['honour','honourPoints','HON'],['credits','credits','CRE'],['uridium','uridium','URI']]) {
    if (reward[key]) send(session, { _: 'LegacyModule', message: `0|LM|ST|${code}|${reward[key]}|${p[field]}${key === 'ep' ? `|${p.level}` : ''}` });
  }
  if (p.level > before.level) send(session, { _: 'LegacyModule', message: `0|A|LUP|${p.level}|${p.ep}` });
  return reward;
}
function event(session, data) { require('./handlers/systems').recordEvent(session, data); }
module.exports = { levelFor, grant, event };
