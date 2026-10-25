'use strict';
const assembly = require('../game/assembly');
const { open } = require('../game/db');
const escape = value => String(value ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
const format = value => Math.ceil(Number(value) || 0).toLocaleString('tr-TR');
const URL = '/indexInternal.es?action=internalItemUpgrade';
const NAMES = { ...Object.fromEntries(require('../game/module-policy').DEFINITIONS.map(d=>[d.id,d.name])), currency_credits: 'Kredi', currency_uridium: 'Uridyum', 'resource_collectable_axion-beam-regulator': 'ABR', 'resource_collectable_isochronate': 'İzokronat' };
function name(id, offers) { return NAMES[id] || offers[id]?.name || id.replace(/^(equipment_(weapon|generator)_\w+_|resource_collectable_|resource_|drone_)/, '').toUpperCase(); }
function targets(playerId, now = Date.now()) {
  const db = open(), items = db.prepare('SELECT * FROM items WHERE player_id=? AND amount=1 ORDER BY loot_id,id').all(playerId);
  const drones = require('../game/drones').owned(db, playerId).map(row => ({ ...row, id: assembly.DRONE_OFFSET + row.id }));
  const result = [];
  for (const item of [...items, ...drones]) {
    const recipe = Object.entries(assembly.RECIPES).find(([id, r]) => r.targets?.includes(item.loot_id) && assembly.visible(db, playerId, id));
    if (!recipe) continue;
    const [recipeId, definition] = recipe, level = item.upgrade_level;
    result.push({ item, recipeId, definition, level, max: Math.max(...definition.costs.map(c => c.level)), status: assembly.status(playerId, recipeId, item.id, now) });
  }
  return result;
}
function handle(playerId, params, options = {}) {
  const operation = params.get('subaction');
  if (!operation) return { ok: true, message: '' };
  const recipe = params.get('recipe'), target = Number(params.get('target')), now = options.now ?? Date.now();
  if (!targets(playerId, now).some(t => t.recipeId === recipe && t.item.id === target)) return { ok: false, message: 'Geliştirilecek eşya bulunamadı.' };
  try {
    if (operation === 'build') assembly.build(playerId, recipe, Number(params.get('level')) - 1, target, now);
    else if (operation === 'collect') assembly.collect(playerId, recipe, target, now);
    else if (operation === 'skip') assembly.skip(playerId, recipe, target, now);
    else return { ok: false, message: 'Bilinmeyen geliştirme işlemi.' };
    return { ok: true, message: operation === 'build' ? 'Geliştirme başladı.' : operation === 'skip' ? 'Geliştirme tamamlandı. Eşyanı teslim alabilirsin.' : 'Geliştirilen eşya teslim alındı.' };
  } catch (error) { return { ok: false, message: error.message }; }
}
function form(row, operation, content) {
  return `<form method="post" action="${URL}"><input type="hidden" name="subaction" value="${operation}"><input type="hidden" name="recipe" value="${escape(row.recipeId)}"><input type="hidden" name="target" value="${row.item.id}">${content}</form>`;
}
function costs(row, target, offers) {
  const counts = new Map(), steps = row.definition.costs.filter(c => c.level > row.level && c.level <= target);
  for (const step of steps) for (const part of step.parts) counts.set(part.lootID, (counts.get(part.lootID) || 0) + part.ammount);
  return { label: [...counts].map(([id, amount]) => `${format(amount)} ${name(id, offers)}`).join(' · '), seconds: steps.reduce((sum, c) => sum + c.buildTimeSec, 0) };
}
function render(player, options = {}) {
  const offers = require('../game/economy').offers(), rows = targets(player.userId, options.now), result = options.result;
  const cards = rows.map(row => {
    let controls;
    if (row.status._ === 'AssemblyRecipeBuildStatusModule') {
      const skip = new Map();
      for (const step of row.definition.costs.filter(c => c.level > row.level && c.level <= row.status.buildAmount))
        for (const part of step.skipCosts || []) skip.set(part.lootID, (skip.get(part.lootID) || 0) + part.ammount);
      const skipLabel = [...skip].map(([id, amount]) => `${format(amount)} ${name(id, offers)}`).join(' · ');
      controls = `<p>Geliştiriliyor · ${format(row.status.remainingTimeMillis / 1000)} saniye kaldı.</p>` +
        (skip.size ? form(row, 'skip', `<button type="submit">Hemen tamamla (${escape(skipLabel)})</button>`) : '');
    } else if (row.status._ === 'AssemblyRecipeReadyToCollectStatusModule') controls = form(row, 'collect', '<button type="submit">Geliştirilen eşyayı teslim al</button>');
    else if (row.level >= row.max) controls = '<p>En yüksek seviyede.</p>';
    else {
      const first = costs(row, row.level + 1, offers);
      const choices = Array.from({ length: row.max - row.level }, (_, n) => {
        const target = row.level + n + 1, price = costs(row, target, offers);
        return `<option value="${target + 1}" data-cost="${escape(price.label)}" data-time="${price.seconds}">${target + 1}</option>`;
      }).join('');
      controls = form(row, 'build', `<label>Hedef seviye <select name="level">${choices}</select></label><p class="cost">${escape(first.label)}</p><p class="duration">${format(first.seconds)} saniye</p><button type="submit">Geliştirmeyi başlat</button>`);
    }
    const image = row.item.loot_id.replaceAll('_', '/') + '_100x100.png';
    return `<article data-item="${row.item.id}"><img src="/client/do_img/global/items/${escape(image)}" alt="" onerror="this.style.display='none'"><h2>${escape(name(row.item.loot_id, offers))}</h2><p>Seviye ${row.level + 1} / ${row.max + 1}${row.item.ship_id ? ' · Takılı' : ''}</p>${controls}</article>`;
  }).join('');
  return `<!doctype html><html lang="tr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>DarkOrbit · Eşya Geliştirme</title><style>
body{margin:0;background:#030c16;color:#d1e9f8;font:15px "Segoe UI",sans-serif}header,main{max-width:1120px;margin:auto;padding:24px}header{border-bottom:1px solid #24506b}a{color:#68caff}nav{display:flex;gap:24px;margin-bottom:24px}h1{margin:0 0 14px}h2{font-size:18px}small{color:#9ab1c4}.balance{color:#f2ce6c}.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:18px}article{background:#0c1e2d;border:1px solid #24506b;padding:18px;border-radius:5px}article img{width:64px;height:64px;object-fit:contain;float:right}button,select{padding:9px 12px;border:1px solid #4b8eac;background:#163a50;color:#e3f5ff;border-radius:3px}button{cursor:pointer}button:hover{background:#1f536f}.cost{color:#f2ce6c;font-size:13px;line-height:1.6}.notice{padding:14px;border:1px solid #4b8eac;margin-bottom:20px}.error{border-color:#c56e6e;color:#ffb4b4}
</style></head><body><header><nav><a href="/indexInternal.es?action=internalDock">Hangar</a><a href="/indexInternal.es?action=internalStart">Portal</a><a href="${URL}">Yenile</a></nav><h1>Eşya Geliştirme</h1><p>Geliştirmek istediğin eşyayı ve hedef seviyeyi seç. Biten geliştirmeyi teslim al.</p><p class="balance">${format(player.credits)} Kredi · ${format(player.uridium)} Uridyum</p><small>Aynı işlemlere oyun içindeki Montaj → Geliştirme sekmesinden de ulaşabilirsin. Diroitlerin 1–6 deneyim seviyesi bu geliştirmeden ayrıdır.</small></header><main>${result?.message ? `<div class="notice${result.ok ? '' : ' error'}">${escape(result.message)}</div>` : ''}<div class="grid">${cards || '<p>Geliştirilebilen bir eşyan henüz yok. Lazer, kalkan jeneratörü, roketatar veya diroit edindiğinde burada görünecek.</p>'}</div></main><script>document.querySelectorAll('select[name="level"]').forEach(function(select){select.addEventListener('change',function(){var option=this.options[this.selectedIndex],form=this.form;form.querySelector('.cost').textContent=option.getAttribute('data-cost');form.querySelector('.duration').textContent=option.getAttribute('data-time')+' saniye';});});</script></body></html>`;
}
module.exports = { targets, handle, render, costs };
