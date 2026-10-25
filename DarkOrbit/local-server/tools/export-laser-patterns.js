'use strict';
// Read the existing embedded game.xml extraction; do not rewrite the SWF.
const fs = require('node:fs'), path = require('node:path'), crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const source = fs.readFileSync(path.join(root, 'decompiled/pet-patterns/game.xml'));
const xml = source.toString('utf8').replace(/<!--[\s\S]*?-->/g, '');
const attrs = value => Object.fromEntries([...value.matchAll(/([\w-]+)="([^"]*)"/g)].map(m => [m[1], m[2]]));
const expansions = {}, ships = {};
const section = xml.match(/<expansions>([\s\S]*?)<\/expansions>/)?.[1];
if (!section) throw Error('Expansion section missing');
for (const match of section.matchAll(/<expansion\b([^>]*)>([\s\S]*?)<\/expansion>/g)) {
  const key = attrs(match[1]).class, stages = {};
  for (const stage of match[2].matchAll(/<stage\b([^>]*)>([\s\S]*?)<\/stage>/g)) {
    const id = Number(attrs(stage[1]).id);
    stages[id] = [...stage[2].matchAll(/<salvo\b([^>]*)\/>/g)].map(s => (attrs(s[1]).laser || '').split(',').filter(Boolean));
  }
  expansions[key] = stages;
}
const shipSection = xml.match(/<ships>([\s\S]*?)<\/ships>/)?.[1];
if (!shipSection) throw Error('Ship section missing');
for (const match of shipSection.matchAll(/<ship\b([^>]*?)(?:\/>|>([\s\S]*?)<\/ship>)/g)) {
  const base = attrs(match[1]);
  if (base.type && base.expansionClassID) ships[base.type] = base.expansionClassID;
  for (const design of (match[2] || '').matchAll(/<design\b([^>]*)/g)) {
    const a = attrs(design[1]);
    if (a.type && (a.expansionClassID || base.expansionClassID)) ships[a.type] = a.expansionClassID || base.expansionClassID;
  }
}
if (ships.ship_diminisher !== 'ship_diminisher' || !expansions.ship_liberator?.[2]) throw Error('Classic ship patterns missing');
const out = { source: 'decompiled/pet-patterns/game.xml', sha256: crypto.createHash('sha256').update(source).digest('hex'), ships, expansions };
fs.writeFileSync(path.join(root, 'game/laser-patterns.json'), JSON.stringify(out, null, 2) + '\n');
console.log(`${Object.keys(ships).length} ship appearances, ${Object.keys(expansions).length} expansion classes`);
