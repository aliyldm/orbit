'use strict';
// Native rows generated with System.Xml from shipped resources; see docs/normal-map-layout.md.
const MAP_ROWS = [
  [1,"1-1",1],
  [2,"1-2",1],
  [3,"1-3",1],
  [4,"1-4",1],
  [5,"2-1",1],
  [6,"2-2",1],
  [7,"2-3",1],
  [8,"2-4",1],
  [9,"3-1",1],
  [10,"3-2",1],
  [11,"3-3",1],
  [12,"3-4",1],
  [13,"4-1",1],
  [14,"4-2",1],
  [15,"4-3",1],
  [16,"4-4",2],
  [17,"1-5",1],
  [18,"1-6",1],
  [19,"1-7",1],
  [20,"1-8",1],
  [21,"2-5",1],
  [22,"2-6",1],
  [23,"2-7",1],
  [24,"2-8",1],
  [25,"3-5",1],
  [26,"3-6",1],
  [27,"3-7",1],
  [28,"3-8",1],
  [29,"4-5",2],
  [91,"5-1",2],
  [92,"5-2",1],
  [93,"5-3",2],
];
// nativeKey, sourceMap, targetMap, tooltipX, tooltipY, faction, tooltipOwnFactionOnly
const ROUTE_ROWS = [
  [1,1,2,293,177,1,false],
  [2,2,1,31,30,1,false],
  [3,2,3,293,30,1,false],
  [5,2,4,293,177,1,false],
  [4,3,2,31,177,1,false],
  [27,3,4,293,177,1,false],
  [7,3,7,293,30,1,false],
  [6,4,2,31,30,1,false],
  [28,4,3,293,30,1,false],
  [11,4,12,293,177,1,false],
  [31,4,13,301,92,1,false],
  [16,5,6,31,177,2,false],
  [15,6,5,293,30,2,false],
  [10,6,7,31,177,2,false],
  [17,6,8,293,177,2,false],
  [8,7,3,31,177,2,false],
  [9,7,6,293,30,2,false],
  [25,7,8,293,177,2,false],
  [18,8,6,31,30,2,false],
  [26,8,7,293,30,2,false],
  [19,8,11,31,177,2,false],
  [33,8,14,158,184,2,false],
  [24,9,10,31,30,3,false],
  [23,10,9,293,177,3,false],
  [22,10,11,293,30,3,false],
  [14,10,12,31,30,3,false],
  [20,11,8,31,30,3,false],
  [21,11,10,293,177,3,false],
  [30,11,12,31,177,3,false],
  [12,12,4,31,30,3,false],
  [13,12,10,293,177,3,false],
  [29,12,11,293,30,3,false],
  [35,12,15,158,23,3,false],
  [32,13,4,23,92,0,false],
  [37,13,14,293,30,0,false],
  [42,13,15,293,177,0,false],
  [43,13,16,166,104,0,false],
  [34,14,8,158,23,0,false],
  [38,14,13,31,177,0,false],
  [39,14,15,293,177,0,false],
  [45,14,16,166,104,0,false],
  [36,15,12,301,92,0,false],
  [41,15,13,31,177,0,false],
  [40,15,14,31,30,0,false],
  [47,15,16,166,104,0,false],
  [44,16,13,152,104,0,false],
  [46,16,14,173,91,0,false],
  [48,16,15,173,112,0,false],
  [49,16,17,55,104,1,false],
  [59,16,21,222,10,2,false],
  [69,16,25,222,193,3,false],
  [50,17,16,301,92,1,false],
  [51,17,18,31,30,1,false],
  [53,17,19,31,177,1,false],
  [79,17,29,158,184,1,false],
  [52,18,17,293,177,1,false],
  [55,18,20,31,177,1,false],
  [54,19,17,293,30,1,false],
  [57,19,20,31,30,1,false],
  [56,20,18,293,30,1,false],
  [58,20,19,293,177,1,false],
  [60,21,16,31,177,2,false],
  [61,21,22,31,30,2,false],
  [63,21,23,293,30,2,false],
  [81,21,29,293,177,2,false],
  [62,22,21,31,177,2,false],
  [65,22,24,293,30,2,false],
  [64,23,21,31,177,2,false],
  [67,23,24,293,30,2,false],
  [66,24,22,31,177,2,false],
  [68,24,23,293,177,2,false],
  [70,25,16,31,30,3,false],
  [71,25,26,31,177,3,false],
  [73,25,27,293,177,3,false],
  [83,25,29,261,23,3,false],
  [72,26,25,31,30,3,false],
  [75,26,28,293,177,3,false],
  [74,27,25,31,177,3,false],
  [77,27,28,293,177,3,false],
  [76,28,26,31,177,3,false],
  [78,28,27,31,30,3,false],
  [80,29,17,55,104,1,false],
  [82,29,21,222,10,2,false],
  [84,29,25,222,197,3,false],
  [29911,29,91,96,102,1,false],
  [29912,29,91,198,48,2,false],
  [29913,29,91,198,159,3,false],
  [91921,91,92,41,158,1,true],
  [91922,91,92,22,104,2,true],
  [91923,91,92,41,52,3,true],
  [92931,92,93,44,167,1,true],
  [92932,92,93,20,104,2,true],
  [92933,92,93,44,55,3,true],
  [920038,93,16,15,73,1,true],
  [920040,93,16,15,104,2,true],
  [920042,93,16,15,134,3,true],
];
const SOURCES = Object.freeze({
  topology: 'client/spacemap/graphics/spacemap-config.xml',
  topologySha256: 'EC662D3E3E931F43489379BE89E0236C640D124262046B0C3CD07F8E0B1171F3',
  visualMaps: 'client/spacemap/graphics/maps-config.xml',
  visualMapsSha256: '9D154F543410997D41D7081D39DE5EB639D0D7CAF70DF099986BBFC6AB87E6EE',
  levels: 'https://board-en.darkorbit.com/threads/levels-faq.843/',
  directRoutes: 'https://board-de.darkorbit.com/threads/faq-erfahrungspunkte.2886/',
  pirates: 'https://board-en.darkorbit.com/threads/pirate-map-faq.1013/',
  stations: 'https://board-en.darkorbit.com/threads/how-to-sell-cargo.2058/'
});
const clone = value => JSON.parse(JSON.stringify(value));
const maps = MAP_ROWS.map(([id,name,scale]) => ({ id,name,scale,
  faction_id: /^[123]-/.test(name) ? Number(name[0]) : 0,
  is_start: /^[123]-1$/.test(name) ? 1 : 0,
  width: 21000 * scale, height: 13100 * scale,
  start_x: ({ 1:3267,5:19200,9:19200 })[id] || 1000,
  start_y: ({ 1:2635,5:1800,9:11300 })[id] || 1000,
  kind: id >= 91 ? 'pirate' : id >= 13 && id <= 16 || id === 29 ? 'battle' : 'company'
}));
const byId = new Map(maps.map(map => [map.id,map]));

// XML coordinates are explicitly tooltip pixels, not server-world positions.
// This local affine projection is calibrated to captured 31/30 -> 2000/2000,
// 293/177 -> 18500/11500, and follows native double-sized map bounds.
function projectTooltip(mapId, x, y) {
  const map = byId.get(Number(mapId));
  if (!map) throw new Error('Normal map layout missing');
  return { x: Math.round((2000 + (x - 31) * 16500 / 262) * map.scale),
    y: Math.round((2000 + (y - 30) * 9500 / 147) * map.scale) };
}
function accessLevel(mapId, factionId) {
  const map = byId.get(Number(mapId));
  if (!map || ![1,2,3].includes(Number(factionId))) return Infinity;
  if (map.kind === 'pirate' || map.id === 29) return 12;
  if (map.id >= 13 && map.id <= 15) return 8;
  if (map.id === 16) return 9;
  const stage = Number(map.name.split('-')[1]), own = map.faction_id === Number(factionId);
  const levels = own ? { 1:1,2:1,3:2,4:2,5:10,6:11,7:11,8:12 }
    : { 1:16,2:13,3:5,4:5,5:14,6:15,7:15,8:17 };
  return levels[stage] ?? Infinity;
}
function portalAccessLevel(portal, factionId) {
  const from = byId.get(Number(portal?.map_id)), to = byId.get(Number(portal?.target_map));
  const base = accessLevel(to?.id,factionId);
  if (from?.faction_id && from.faction_id === to?.faction_id &&
      ['3:4','4:3'].includes(`${from.name.split('-')[1]}:${to.name.split('-')[1]}`))
    return Math.max(base, to.faction_id === Number(factionId) ? 3 : 6);
  return base;
}
const portals = ROUTE_ROWS.map(([nativeKey,map_id,target_map,tooltipX,tooltipY,factionId,ownOnly]) => ({
  id: 150000167 + nativeKey, nativeKey, map_id, target_map,
  ...projectTooltip(map_id,tooltipX,tooltipY),
  tooltipX,tooltipY,factionId,faction_id:factionId,ownOnly,
  min_level: Math.min(...[1,2,3].map(faction => portalAccessLevel({ map_id,target_map },faction))),
  design_id:1, coordinateSource: [1,2,3,5].includes(nativeKey) ? 'capture' : 'local-tooltip-projection',
  topologySource: SOURCES.topology
}));
for (const portal of portals) {
  portal.arrivalSource = [1,2].includes(portal.nativeKey) ? 'capture' : 'local-arrival';
  const target = byId.get(portal.target_map);
  const reverse = portals.find(other => other.map_id === portal.target_map && other.target_map === portal.map_id);
  if (portal.nativeKey === 1) { portal.target_x = 2300; portal.target_y = 2300; }
  else if (portal.nativeKey === 2) { portal.target_x = 18100; portal.target_y = 11100; }
  else if (reverse) {
    portal.target_x = reverse.x + (reverse.x < target.width / 2 ? 400 : -400);
    portal.target_y = reverse.y + (reverse.y < target.height / 2 ? 400 : -400);
  } else if (portal.target_map === 16) {
    // The official pirate FAQ describes arrival at the top of 4-4; exact
    // server coordinates were not captured. Keep three arrivals separated.
    portal.target_x = target.width / 2 + (portal.factionId - 2) * 1000;
    portal.target_y = 2000;
  } else {
    // Pirate corridor has no return gates. Local arrivals are on its right,
    // opposite the source-described left-side company exit gates.
    portal.target_x = target.width - 2500;
    portal.target_y = Math.round(target.height * ({ 1:.75,2:.5,3:.25 }[portal.factionId] || .5));
  }
}
// Only map 1's station world anchor is captured. Other anchors retain the
// established local mirror policy; upper bases and pirate trader are local.
const stations = [
  [1,1,2000,2000,'home','capture'], [5,2,19000,2000,'home','local-mirror'], [9,3,19000,11100,'home','local-mirror'],
  [20,1,2000,2000,'upper','local-anchor'], [24,2,19000,2000,'upper','local-anchor'], [28,3,19000,11100,'upper','local-anchor'],
  [92,0,10500,6550,'pirate-trade','local-anchor']
].map(([mapId,factionId,x,y,kind,coordinateSource]) => ({ map_id:mapId,mapId,faction_id:factionId,factionId,x,y,radius:1800,kind,coordinateSource }));
function station(mapId) { const row = stations.find(row => row.map_id === Number(mapId)); return row ? clone(row) : null; }
function getMap(mapId) { const map = byId.get(Number(mapId)); return map ? clone(map) : null; }
function portalVisible(portal, factionId) { return !portal.ownOnly || portal.factionId === Number(factionId); }
function portalsFor(mapId, factionId) { return portals.filter(p => p.map_id === Number(mapId) && (factionId === undefined || portalVisible(p,factionId))).map(clone); }
module.exports = { maps,portals,stations,station,getMap,accessLevel,portalAccessLevel,projectTooltip,portalVisible,portalsFor,SOURCES };
