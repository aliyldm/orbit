'use strict';
const skills = require('../skills');
function register(onCmd, { sendCmd }) {
  onCmd('SkillTreeListRequest', s => sendCmd(s, skills.listCommand(s.player)));
  onCmd('UpLevelSkillTreeRequest', (s, c) => {
    let result, success = false;
    try { result = skills.upgrade(s.player.userId, c.id); success = true; } catch { /* Return actual failure state. */ }
    const st = skills.state(s.player.userId);
    sendCmd(s, { _: 'UpLevelSkillTreeCommand', id: c.id, researchPoints: st.available, stack: null, success, curLevel: result?.level || st.levels[c.id] || 0 });
  });
  onCmd('ConvertResearchPointsRequest', s => {
    let success = false;
    try { skills.convert(s.player.userId); success = true; } catch { /* No debit on failure. */ }
    const st = skills.state(s.player.userId);
    sendCmd(s, { _: 'ConvertResearchPointsCommand', required: st.required, success, researchPoints: st.available, logfiles: st.logFiles });
  });
  onCmd('ResetSkillTreeRequest', s => {
    let success = false;
    try { skills.reset(s.player.userId); success = true; } catch { /* No debit on failure. */ }
    const st = skills.state(s.player.userId);
    sendCmd(s, { ...skills.listCommand(s.player), _: 'ResetSkillTreeCommand', stack: null, success });
  });
}
module.exports = { register };
