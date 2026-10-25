'use strict';
const fs = require('fs'), path = require('path');
const root = path.join(__dirname, '..');
const html = fs.readFileSync(path.join(root, 'web/portal/pages/internalSkylab.html'), 'utf8');
const result = { source: 'web/portal/pages/internalSkylab.html', upgrades: {}, recipes: {} };
const names = [...html.matchAll(/id="module_(\w+)_small"/g)].map(match => match[1]);
for (const name of names) {
  const segment = html.split(`id="module_infobox_${name}_upgrade_large"`)[1]?.split(`id="module_infobox_${name}_resourceWarning`)[0] || '';
  const rows = [...segment.matchAll(/<tr>([\s\S]*?)<\/tr>/g)].map(match => [...match[1].matchAll(/<td[^>]*>([\s\S]*?)<\/td>/g)]
    .map(cell => cell[1].replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim()));
  const values = {};
  for (const cells of rows) if (['Uridium', 'Credits', 'Zaman', 'Prometium', 'Endurium', 'Terbium'].includes(cells[0]))
    values[cells[0]] = { instant: cells[1], normal: cells[3] };
  result.upgrades[name] = values;
}
const xml = fs.readFileSync(path.join(root, 'decompiled/pet-patterns/game.xml'), 'utf8');
for (const match of xml.matchAll(/<ore\s+([^>]*\brefiner="([^"]+)"[^>]*)\/>/g)) {
  const type = /\btype="(\d+)"/.exec(match[1])[1];
  const fields = match[2].split(',').map(Number), input = {};
  for (let index = 0; index < fields.length; index += 2) input[fields[index]] = fields[index + 1];
  result.recipes[type] = input;
}
fs.writeFileSync(path.join(root, 'game/skylab-evidence.json'), JSON.stringify(result, null, 2) + '\n');
console.log(JSON.stringify(result));
