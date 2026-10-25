'use strict';
const skills = require('../game/skills');
const { open } = require('../game/db');
const source = JSON.parse(require('./portal/ajax.json')['/ajax/pilotprofil.php|getInternalProfilPage'].body).code;
const escape = s => String(s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
function innerRange(html, id) {
  const match = new RegExp(`<div\\b[^>]*\\bid="${id}"[^>]*>`, 'i').exec(html);
  if (!match) return null;
  const start = match.index + match[0].length;
  const tags = /<\/?div\b[^>]*>/gi; tags.lastIndex = start;
  let depth = 1, tag;
  while ((tag = tags.exec(html))) { depth += /^<\/div/i.test(tag[0]) ? -1 : 1; if (!depth) return [start, tag.index]; }
  return null;
}
function inner(html, id) { const range = innerRange(html, id); return range ? html.slice(...range) : ''; }
function replaceInner(html, id, value) { const range = innerRange(html, id); return range ? html.slice(0, range[0]) + value + html.slice(range[1]) : html; }
function balance(playerId) {
  const p = require('../game/world').current()?.livePlayer(playerId);
  return p || open().prepare('SELECT credits,uridium FROM players WHERE id=?').get(playerId);
}
function render(playerId) {
  const st = skills.state(playerId), money = balance(playerId);
  let html = source;
  for (const [id, count] of [['logFileUpdated', st.logFiles], ['requiredForNextPoints', st.required], ['researchpoints', st.available]])
    html = html.replace(new RegExp(`(id="${id}">)[^<]*`), '$1' + count);
  html = html.replace(/(<div id="skill_([\w]+)" class="skill")([\s\S]*?)(?=<div id="skill_[\w]+" class="skill"|<div id="researchPointUsage")/g,
    (all, start, id, rest) => {
      const def = skills.byId.get(id); if (!def) return all;
      const level = st.levels[id] || 0, cost = skills.costs(def, level);
      // Unlocking follows the branch prerequisites. Affordability must not
      // turn an unlocked branch back into a visually locked skill.
      const unlocked = skills.prerequisites(def, st.levels);
      const allowed = level < def.max && st.available > 0 && unlocked;
      rest = rest.replace(/0\/\d+/, `${level}/${def.max}`)
        .replace(/skill_effect(?:_inactive)?/, level===def.max ? 'skill_effect_max' : level || unlocked ? 'skill_effect' : 'skill_effect_inactive');
      if (allowed) rest = rest.replace(/^\s*>/, ` onclick="pilotSheet.sendSkillTreeUpdate('${id}',this)">`).replace(/\bnoCursor\b/, '');
      if (level === def.max) rest = rest.replace(/skilltree_font_fail_skillPoints/, 'skilltree_font_info');
      return start + ` data-unlocked="${unlocked ? 1 : 0}"` + rest;
    });
  const usage = `${st.used} / ${st.earned_points} ArGe puanı dağıtıldı. Boş puan: ${st.available}. Seprom gerekmez.`;
  html = replaceInner(html, 'researchPointUsage', escape(usage));
  const resetReason=!st.used?'Dağıtılmış ArGe puanın yok.':money.uridium<st.resetPrice?'Sıfırlama için 300.000 Uridyum gerekli.':'Dağıtılan puanlar geri verilir; kazanılmış ArGe puanların korunur.';
  const resetButton=`<style>#local_skill_reset{background-image:linear-gradient(#254959,#0b202b 48%,#143e51);border:1px solid #428caa;border-radius:3px;color:#d0edf8;box-shadow:inset 0 1px #6b9db0,0 0 5px #06131e;font-family:Arial,sans-serif;padding:0}#local_skill_reset:hover:not(:disabled){filter:brightness(1.25);box-shadow:0 0 7px #41a1cb}#local_skill_reset:disabled{opacity:.5;cursor:default}#local_skill_reset .label{line-height:13px}</style><button id="local_skill_reset" class="skillResetButton" type="button" title="${escape(resetReason)}"${!st.used||money.uridium<st.resetPrice?' disabled':''} onclick="if(window.confirm('300.000 Uridyum karşılığında dağıtılmış ArGe puanların geri verilsin mi?'))Main.resetSkillTree()"><span class="label">ArGe Sıfırla<br>300.000 U.</span></button>`;
  html = replaceInner(html, 'skillResetButtonContainer', resetButton);
  if (st.required && st.logFiles >= st.required) {
    html = html.replace(/researchPoints_button_0/g, 'researchPoints_button_1').replace(/arrow_logfile_0/g, 'arrow_logfile_1').replace(/researchPoints_arrow_0/g, 'researchPoints_arrow_1')
      .replace(/<span class="font_inactive"><strong>DEĞİŞTİR<\/strong><\/span>/, '<a href="javascript:void(0)" onclick="pilotSheet.handleSkilltree(\'convertPoints\',\'DEĞİŞTİR\')"><strong>DEĞİŞTİR</strong></a>');
  }
  const tips = skills.definitions.map(def => {
    const level = st.levels[def.id] || 0, cost = skills.costs(def, level);
    const benefit=skills.benefitSummary(def.id,st.levels);
    const benefitHtml=`<div class="skilltree_font_info" data-skill-benefit="${escape(def.id)}">Mevcut etkin bonus: ${escape(benefit.current.text)}${benefit.current.id!==def.id?` (${escape(skills.byId.get(benefit.current.id).name)})`:''}<br>${benefit.next?`Sonraki kazanım: ${escape(benefit.next.text)}`:'En yüksek kazanıma ulaştın.'}</div>${benefit.replaces?`<div class="skilltree_font">II. aşamadaki değer toplam etkidir; I. aşamanın üzerine ayrıca eklenmez.</div>`:''}${benefit.scope?`<div class="skilltree_font">${escape(benefit.scope)}</div>`:''}${benefit.visual?`<div class="skilltree_font">${escape(benefit.visual)}</div>`:''}`;
    const unlocked=skills.prerequisites(def,st.levels);
    const requirements = def.requirements.map(r => `${r.each ? 'Her birinde' : 'Toplam'} ${r.points} puan: ${r.skills.map(id => `${skills.byId.get(id).name} (${st.levels[id]||0}/${skills.byId.get(id).max})`).join(', ')}`).join('<br>');
    const missing=level===def.max?'En yüksek seviye':!unlocked?'Önce aşağıdaki dal koşullarını tamamla.':st.available<1?'Boş ArGe puanı yok.':money.credits<cost.credits?'Kredi yetersiz.':'Bu yetenek geliştirilebilir.';
    return `<div id="skill_${def.id}_info" class="skill_tooltip" style="display:none"><div class="tooltip_header"></div><div class="tooltip_content skilltree_font"><strong>${escape(def.name)}</strong><br>Seviye: ${level}/${def.max}<br>${benefitHtml}${escape(missing)}<br>${level === def.max ? '' : `Geliştirme bedeli: 1 ArGe puanı, ${cost.credits.toLocaleString('tr-TR')} kredi. Seprom gerekmez.`}<br>${escape(requirements).replace(/&lt;br&gt;/g, '<br>')}</div><div class="tooltip_footer skilltree_font"></div></div>`;
  }).join('');
  html = replaceInner(html, 'skill_tooltip_container', tips);
  return { code: html, html_skills: inner(html, 'skillContainer'), html_tooltips: tips,
    skillResetButtonContainer: inner(html, 'skillResetButtonContainer'), researchPointUsage: usage, footerText: usage,
    newResearchPoints: st.available, researchpoints: st.available, logFileUpdated: st.logFiles, requiredForNextPoints: st.required,
    hasEnoughLogfiles: st.required && st.logFiles >= st.required ? 'yes' : 'no',
    researchPoints_teaser_text: 'Günlük dosyalarını ArGe puanına çevirip yeteneklerini geliştir.', researchPoints_teaser_image: '' };
}
function handle(playerId, pathname, body) {
  const command = body.get('command'), type = body.get('type');
  if (pathname === '/ajax/pilotprofil.php' && !(command === 'getInternalProfilPage' && ['showSkilltree', 'convertPoints'].includes(type))) return null;
  if (!['/ajax/skillTree.php', '/ajax/pilotprofil.php'].includes(pathname)) return null;
  try {
    if (command === 'skillTreePurchaseLevelUp') skills.upgrade(playerId, body.get('skillId'));
    else if (command === 'reset') skills.reset(playerId);
    else if (type === 'convertPoints' || command === 'convertPoints') skills.convert(playerId);
    else if (!(type === 'showSkilltree' || command === 'getSkillTree')) return { result: 'error', message: 'Bilinmeyen yetenek işlemi.' };
    return { result: 'OK', message: 'Yetenek ağacı güncellendi.', ...render(playerId) };
  } catch (error) { return { result: 'error', message: error.message }; }
}
module.exports = { handle, render, innerRange };
