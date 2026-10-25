'use strict';
// İstemciye gömülü eşya kataloğundan (docs/client-map.items.json; main.swf'den çıkarıldı)
// sunucunun kullandığı alt kümeyi game/db/catalog.json'a yazar. game/db/seed.js bunu ship_types ve
// item_types tablolarına işler (katalog, tohumdaki yaklaşık değerlerden önceliklidir).
// Kullanım: node tools/import-catalog.js [docs/client-map.items.json]

const fs = require('fs');
const path = require('path');

const src = process.argv[2] || path.join(__dirname, '..', 'docs', 'client-map.items.json');
const items = JSON.parse(fs.readFileSync(src, 'utf8')).items;
const cls = v => (v.typeClass || '').split('.').pop();
const price = v => ({ credits: Number(v.credits) || 0, uridium: Number(v.uridium) || 0 });

const ships = [], equipment = [];
for (const v of Object.values(items)) {
  if (v.kind === 'Ship' && cls(v) === 'ShipType') {
    ships.push({
      lootId: v.lootId, name: v.typeValue, hitpoints: v.maxHitPoints || 0, speed: v.speed || 0, cargo: v.maxSpace || 0,
      laserSlots: v.maxLaser || 0, generatorSlots: v.maxGen || 0, extraSlots: v.maxSpecials || 0, ...price(v)
    });
    continue;
  }
  if (v.kind === 'Ship' || !v.lootId) continue; // gemi tasarımları vb.
  let category = 'other', damage = 0, shield = 0, absorb = 0, speed = 0, multiplier = 1;
  if (v.kind === 'Weapon' && cls(v) === 'LaserType') { category = 'laser'; damage = v.damage || 0; }
  else if (v.kind === 'Weapon') category = 'rocket_launcher';
  else if (v.kind === 'Generator' && v.category === 'SHIELD') { category = 'shield_generator'; shield = v.output || 0; absorb = (v.spread || 0) / 100; }
  else if (v.kind === 'Generator' && v.category === 'ENGINE') { category = 'speed_generator'; speed = v.output || 0; }
  else if (v.kind === 'Ammunition' && v.weaponType === 'LASER') {
    category = 'ammo_laser';
    const m = /^X(\d+)$/.exec(v.typeValue || '');
    multiplier = m ? Number(m[1]) : 1; // özel cephanelerin (SAB, RSB...) etkileri henüz modellenmedi
  }
  else if (v.kind === 'Ammunition') category = 'ammo_rocket';
  else if (v.kind === 'Booster') category = 'booster';
  else if (v.kind === 'CPUs') category = 'cpu';
  equipment.push({ lootId: v.lootId, name: v.typeValue || v.lootId, category, damage, shield, absorb, speed, multiplier, ...price(v) });
}

const out = path.join(__dirname, '..', 'game', 'db', 'catalog.json');
fs.writeFileSync(out, JSON.stringify({ _source: path.basename(src), ships, items: equipment }));
const by = equipment.reduce((a, i) => (a[i.category] = (a[i.category] || 0) + 1, a), {});
console.log(`${ships.length} gemi, ${equipment.length} eşya ->`, out, by);
