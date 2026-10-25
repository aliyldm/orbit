'use strict';
// Recover the original 25 skill IDs, prices and AND/summed-group prerequisites
// from the supplied recorded getInternalProfilPage response. No live request.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const source = '/ajax/pilotprofil.php|getInternalProfilPage';
const html = JSON.parse(require('../web/portal/ajax.json')[source].body).code;
const skills = [];
for (const match of html.matchAll(/<div id="skill_([\w]+)_info"[\s\S]*?(?=<div id="skill_[\w]+_info"|$)/g)) {
  const block = match[0], costs = {};
  for (const row of block.matchAll(/<td>(Kredi:|Seprom:)<\/td>\s*<td><span[^>]*>([\d,]+)/g))
    costs[row[1] === 'Kredi:' ? 'credits' : 'seprom'] = Number(row[2].replace(/,/g, ''));
  const headings = [...block.matchAll(/<span[^>]*>(\d+) ([^<]*Araştırma Puanı[^<]*)<\/span>/g)];
  const requirements = headings.map((heading, i) => {
    const part = block.slice(heading.index + heading[0].length, headings[i + 1]?.index);
    return { points: Number(heading[1]), each: heading[2].includes('her birinde'),
      skills: [...part.matchAll(/id="skill_small_([\w]+)"/g)].map(m => m[1]) };
  });
  skills.push({ id: match[1], name: block.match(/<strong class="skilltree_font_info">([^<]*)/)[1].trim(),
    max: Number(block.match(/Seviye:[\s\S]*?0\/(\d+)/)[1]), costs, requirements });
}
if (skills.length !== 25 || skills.find(s => s.id === '22b').max !== 3) throw new Error('Skill capture contract changed');
const out = { source: 'web/portal/ajax.json|' + source, sha256: crypto.createHash('sha256').update(html).digest('hex'), skills };
fs.writeFileSync(path.join(root, 'game/skill-tree-data.json'), JSON.stringify(out, null, 2) + '\n');
console.log(`${skills.length} source skill definitions extracted`);
