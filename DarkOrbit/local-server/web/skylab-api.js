'use strict';
const skylab = require('../game/skylab');
const escape = value => String(value).replace(/[&<>"']/g, character => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[character]);
const number = value => Math.floor(value).toLocaleString('tr-TR');
function replaceInner(html, id, transform) {
  const match = new RegExp(`<div\\b[^>]*\\bid="${id}"[^>]*>`, 'i').exec(html);
  if (!match) return html;
  const start = match.index + match[0].length, tags = /<\/?div\b[^>]*>/gi;
  tags.lastIndex = start;
  let depth = 1, tag;
  while ((tag = tags.exec(html))) {
    depth += /^<\//.test(tag[0]) ? -1 : 1;
    if (!depth) return html.slice(0, start) + (typeof transform === 'function' ? transform(html.slice(start, tag.index)) : transform) + html.slice(tag.index);
  }
  return html;
}
const BROWSER_SCRIPT = `(function(){
function byId(id){return document.getElementById(id);}
window.Skylab={
 showModule:function(name){document.querySelectorAll('#modules .module_large').forEach(function(el){el.style.display='none';});var el=byId('module_'+name+'_large');if(el)el.style.display='block';},
 changeToTab:function(tab,name){var root=byId('module_infobox_'+name+'_content');if(!root)return;root.querySelectorAll('.tabContent').forEach(function(el){el.style.display='none';});var ids={first:'overview',second:'upgrade',third:'productivity'};var el=byId('module_infobox_'+name+'_'+ids[tab]+'_large');if(el)el.style.display='block';},
 sendTransport:function(mode,message){if(mode==='fast'&&!confirm(message||'1250 Uridium karşılığında hemen gönderilsin mi?'))return false;var form=byId('sendTransport');if(form){form.elements.mode.value=mode;form.submit();}return false;}
};
document.addEventListener('DOMContentLoaded',function(){document.querySelectorAll('.skylab_module_close').forEach(function(el){el.addEventListener('click',function(){el.closest('.module_large').style.display='none';});});});
setInterval(function(){document.querySelectorAll('[data-skylab-until]').forEach(function(el){var seconds=Math.max(0,Math.ceil((Number(el.getAttribute('data-skylab-until'))-Date.now())/1000));el.textContent=seconds?Math.floor(seconds/3600)+':'+String(Math.floor(seconds/60)%60).padStart(2,'0')+':'+String(seconds%60).padStart(2,'0'):'Süre doldu; yenile';});},1000);
})();`;
function url(state, action, module) {
  return 'indexInternal.es?action=internalSkylab&subaction=' + action + '&construction=' + module + '&reloadToken=' + state.token;
}
function upgradeContent(state, name) {
  const module = state.modules[name], offer = module.nextCost;
  if (module.upgrade_until) return `<p>Seviye ${module.target_level} geliştiriliyor.</p><p data-skylab-until="${module.upgrade_until}">${escape(new Date(module.upgrade_until).toLocaleString('tr-TR'))}</p><a href="indexInternal.es?action=internalSkylab">Yenile</a>`;
  if (!offer) return '<div class="upgrade_container_max">Azami seviyeye ulaşıldı.</div>';
  const duration = Math.ceil(offer.duration / 60000);
  let html = `<table class="module_infobox_upgrade"><tr><td></td><td>Hemen</td><td>Normal</td></tr>`;
  for (const [label, instant, normal] of [['Uridium', offer.uridium, 0], ['Credits', offer.credits, offer.credits],
    ...offer.ores.map(([type, amount]) => [skylab.ORES[type], amount, amount])])
    html += `<tr><td class="firstRow">${label}</td><td class="secondRow">${number(instant)}</td><td class="thirdRow">${number(normal)}</td></tr>`;
  html += `<tr><td>Zaman</td><td>0:00</td><td>${Math.floor(duration / 60)}:${String(duration % 60).padStart(2, '0')}</td></tr></table>`;
  html += `<p><a href="${escape(url(state, 'instantUpgrade', name))}">hemen inşa et</a> &nbsp; <a href="${escape(url(state, 'upgrade', name))}">inşa et</a></p>`;
  return html;
}
function transportContent(state) {
  if (state.transport) {
    const payload = JSON.parse(state.transport.payload_json);
    return `<p>Skylab → Gemi</p><p>${Object.entries(payload).map(([type, amount]) => `${escape(skylab.ORES[type])}: ${number(amount)}`).join(', ')}</p>` +
      `<p data-skylab-until="${state.transport.arrive_at}">${state.transport.arrive_at <= state.now ? 'Gemi kargosunda yer açılması bekleniyor.' : 'Transport yolda.'}</p><a href="indexInternal.es?action=internalSkylab">Yenile</a>`;
  }
  return `<p>Skylab → Gemi. Boş kargo: ${number(Math.max(0, state.cargoCapacity - state.cargoUsed))}</p>` +
    `<form id="sendTransport" name="sendTransport" method="post" action="indexInternal.es"><input type="hidden" name="action" value="internalSkylab"><input type="hidden" name="subaction" value="startTransport"><input type="hidden" name="construction" value="TRANSPORT_MODULE"><input type="hidden" name="reloadToken" value="${state.token}"><input type="hidden" name="mode" id="mode" value="normal"><table class="module_infobox_transportModule">` +
    skylab.ORES.map((ore, type) => `<tr><td><label for="count_${ore}">${ore}</label></td><td><input id="count_${ore}" name="count_${ore}" type="text" value="0" size="8" autocomplete="off"></td><td>${number(state.resources[type])}</td></tr>`).join('') +
    `</table><p><a href="javascript:Skylab.sendTransport('normal')">yolla</a> &nbsp; <a href="javascript:Skylab.sendTransport('fast')">hemen yolla (1250 U.)</a></p></form>`;
}
function render(player, html, options = {}) {
  const id = typeof player === 'number' ? player : player.userId ?? player.id;
  const state = options.state || skylab.state(id, options);
  html = html.replace(/<script\b[^>]*src="[^\"]*\/js\/skylab\.js[^\"]*"[^>]*><\/script>/i, `<script>${BROWSER_SCRIPT}</script>`);
  html = html.replace(/currentTime\s*=\s*\d+;/, `currentTime = ${Math.floor(state.now / 1000)};`)
    .replace(/var userCredits = '[^']*';/, `var userCredits = '${number(state.credits)}';`)
    .replace(/var userUridium = '[^']*';/, `var userUridium = '${number(state.uridium)}';`);
  for (const [type, ore] of skylab.ORES.entries()) {
    html = replaceInner(html, 'view_' + ore + '_stock', `<span class="ore_${ore}">${ore}:</span><br>${number(state.resources[type])}`);
    const percent = Math.min(100, state.resources[type] / state.capacities[type] * 100);
    html = replaceInner(html, 'view_' + ore + '_maximal', `<div class="view_generally_maximal_bg" style="width:${percent}%;"></div><div class="view_generally_maximal_number">${number(state.capacities[type])}</div>`);
  }
  for (const [name, definition] of Object.entries(skylab.MODULES)) {
    const module = state.modules[name];
    html = replaceInner(html, `module_${name}_small`, inner => inner.replace(/(<div class="level skylab_font_level">)[^<]*(<\/div>)/, `$1${module.level}$2`));
    html = replaceInner(html, `module_infobox_${name}_upgrade_large`, upgradeContent(state, name));
    let overview;
    if (name === 'baseModule') overview = '<table>' + Object.entries(skylab.MODULES).map(([key, value]) => `<tr><td>${value.label}</td><td>${state.modules[key].level}</td></tr>`).join('') + '</table>';
    else if (name === 'storageModule') overview = '<table>' + skylab.ORES.map((ore, type) => `<tr><td>${ore}</td><td>${number(state.resources[type])} / ${number(state.capacities[type])}</td></tr>`).join('') + '</table>';
    else if (name === 'transportModule') overview = transportContent(state);
    else if (name === 'solarModule') overview = `<p>Seviye: ${module.level}</p><p>Enerji: ${number(state.power.used)} / ${number(state.power.available)}</p><p>Verimlilik: ${Math.round(state.power.efficiency * 100)}%</p>`;
    else overview = `<p>Seviye: ${module.level}</p><p>Durum: ${module.upgrade_until ? 'Geliştiriliyor' : module.active && module.level ? 'Etkin' : 'Etkin değil'}</p><p>Üretim: ${number((definition.rate || 0) * module.level ** 2 * state.power.efficiency)} / saat</p>`;
    html = replaceInner(html, `module_infobox_${name}_overview_large`, overview);
    html = replaceInner(html, `module_infobox_${name}_productivity_large`, `<p>Enerji verimliliği: ${Math.round(state.power.efficiency * 100)}%</p><p>Üretim ve stok sunucuda hesaplanır.</p>`);
    const toggle = module.level && !['baseModule', 'solarModule', 'storageModule'].includes(name) ? `<a href="${escape(url(state, module.active ? 'setInactive' : 'setActive', name))}">${module.active ? 'Devre dışı bırak' : 'Etkinleştir'}</a>` : '';
    html = replaceInner(html, `module_infobox_${name}_footer`, `<div class="module_info_level module_infobox_info"><div class="level_icon">${module.level}</div></div><div class="module_info_active_state module_infobox_info">${toggle}</div>`);
  }
  // Original counters are page HTML, and may have been personalized before mutation.
  html = html.replace(/(<div id="header_credits"[^>]*>)\s*[^<]*(<\/div>)/, `$1${number(state.credits)}$2`);
  html = html.replace(/(<a id="header_uri"[^>]*>)\s*[^<]*(<\/a>)/, `$1${number(state.uridium)}$2`);
  html = html.replace(/reloadToken=REDACTED/g, 'reloadToken=' + state.token).replace(/name="reloadToken" value="REDACTED"/g, `name="reloadToken" value="${state.token}"`);
  if (options.message) html = html.replace('<div id="skylab">', `<div role="status" style="padding:12px;color:white;background:#1b3144">${escape(options.message)}</div><div id="skylab">`);
  return html;
}
function handle(playerId, params, options = {}) {
  try {
    const state = params.get('subaction') ? skylab.operate(playerId, params, options) : skylab.state(playerId, options);
    return { ok: true, status: 200, message: params.get('subaction') ? 'Skylab işlemi tamamlandı.' : '', state };
  } catch (error) { return { ok: false, status: 400, message: error.message }; }
}
module.exports = { handle, render, replaceInner, BROWSER_SCRIPT };
