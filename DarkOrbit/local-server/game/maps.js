'use strict';
// Map 1/2 gate positions and station assets: session-6182-2 and init.json.
// Other starter factions deliberately mirror these local assets; no live parity claim.
const { open } = require('./db');
const template = require('./templates/init.json').commands;
const dist = (a,b) => Math.hypot(a.x-b.x,a.y-b.y);
function getMap(id) { return open().prepare('SELECT * FROM maps WHERE id = ?').get(id); }
function portals(mapId, factionId) {
  const layout=require('./normal-map-layout');
  return open().prepare('SELECT * FROM portals WHERE map_id = ? ORDER BY id').all(mapId).filter(row=>{
    const native=layout.portals.find(p=>p.id===row.id);
    return !native||factionId===undefined||layout.portalVisible(native,factionId);
  });
}
function portalAccessLevel(portal,player){
  const layout=require('./normal-map-layout');
  return Math.max(portal.min_level||1,layout.getMap(portal.target_map)?layout.portalAccessLevel(portal,player.factionId):1);
}
function station(world) {
  const p = world.player; if (!p) return null;
  const native=require('./normal-map-layout').station(p.mapId);if(native)return native;
  const m = getMap(p.mapId); if (!m?.is_start) return null;
  return { x: m.faction_id === 1 ? 2000 : m.width - 2000, y: m.faction_id === 3 ? m.height - 2000 : 2000, factionId: m.faction_id, radius: 1800 };
}
function home(world) { return open().prepare('SELECT * FROM maps WHERE faction_id = ? AND is_start = 1').get(world.player.factionId); }
function nearStation(world, range = 1800) { const s = station(world); return !!s && (s.factionId === 0 || s.factionId === world.player.factionId) && dist(world.updatePosition(),s) <= range; }
function tradeState(world){
 const s=station(world);if(!s)return null;
 const p=world.updatePosition(),sign=s.factionId===1?1:-1,pos=s.kind==='pirate-trade'?s:{x:s.x-1080*sign,y:s.y};
 const available=nearStation(world)&&!p.dead&&![...world.sessions||[]].some(session=>session.jumping)&&dist(p,pos)<=350;
 return{_:'MapAssetActionAvailableCommand',mapAssetId:150000022,state:available?0:1,activatable:available,
  toolTip:{_:'MessageKeyListWildcardCommand',commandList:[{_:'MessageKeyListWildcardModule',wildCardReplacements:[],baseKey:s.kind==='pirate-trade'?'Palladium takası':'Maden sat',baseKeyType:{_:'ReplacementTypeModule',typeValue:0},textStyle:0}]},additionalInformation:{_:'AssetInformationModule'}};
}
function nearestPortal(world, range = 750) { const p = world.updatePosition(); return portals(p.mapId,p.factionId).filter(g => dist(p,g) <= range).sort((a,b)=>dist(p,a)-dist(p,b))[0] || null; }
function nearPeaceArea(world) {
  if(!world.player)return false;
  if(nearStation(world))return true;
  const p=world.updatePosition(),m=getMap(p.mapId);
  // Original peacearea text is driven by Beacon.inPeaceArea, independently of
  // jump availability. Only own-company maps have permanent portal protection.
  // Radius750 is our local jump-area radius, not a recovered server constant.
  return !!m&&m.faction_id===p.factionId&&m.faction_id>0&&!!nearestPortal(world);
}
function portalState(g, available) {
  return { _: 'MapAssetActionAvailableCommand', mapAssetId: g.id, state: available ? 0 : 1, activatable: available,
    toolTip: { _: 'MessageKeyListWildcardCommand', commandList: [{ _: 'MessageKeyListWildcardModule', wildCardReplacements: [{ _: 'MessageWildcardReplacementModule', wildcard: '%MAP%', replacement: String(g.target_map), replacementType: { _: 'ReplacementTypeModule', typeValue: 6 } }], baseKey: 'ttip_jumpgate', baseKeyType: { _: 'ReplacementTypeModule', typeValue: 5 }, textStyle: 0 }] },
    additionalInformation: { _: 'AssetInformationModule' } };
}
function commands(world) {
  const p = world.player; const m = getMap(p.mapId); const out = [];
  const s = station(world);
  if (s?.kind==='pirate-trade') {
    out.push({_: 'SpaceStationCommand',id:150000023,type:6,posX:s.x,posY:s.y,peaceRadius:s.radius});
    const trade=template.find(c=>c._==='AssetCreateCommand'&&c.assetId===150000022);
    out.push({...trade,type:{_: 'AssetTypeModule',typeValue:52},modifier:[],posX:s.x,posY:s.y,factionId:0});
  } else if (s) {
    const shiftX = x => s.x + (x - 2000) * (m.faction_id === 1 ? 1 : -1);
    const shiftY = y => s.y + (y - 2000) * (m.faction_id === 3 ? -1 : 1);
    const upperTypes={46:47,48:49,50:51,53:54,55:56,57:58};
    for (const c of template.filter(c => c._ === 'AssetCreateCommand' && !(s.kind==='upper'&&c.type.typeValue===34))) {const asset={ ...c,
      type:s.kind==='upper'&&upperTypes[c.type.typeValue]?{_: 'AssetTypeModule',typeValue:upperTypes[c.type.typeValue]}:c.type,
      modifier: [], posX: shiftX(c.posX), posY: shiftY(c.posY), factionId: c.factionId ? m.faction_id : 0 };out.push(c.type.typeValue===34?require('./quest-station').appearance(asset,m.faction_id):asset);}
    out.push({ _: 'SpaceStationCommand', id: 0, type: m.faction_id, posX: s.x, posY: s.y, peaceRadius: s.radius });
    for (const c of template.filter(c => c._ === 'MapAddPOICommand')) out.push({ ...c, shapeCoordinates: c.shapeCoordinates.map((v,i) => i === 0 ? shiftX(v) : i === 1 ? shiftY(v) : v) });
  }
  out.push(...require('./quest-station').initialize(world));
  const trade=tradeState(world);if(trade)out.push(trade);
  for (const g of portals(p.mapId,p.factionId)) {
    out.push({ _: 'JumpgateCreateCommand', gateId: g.id, factionId: 0, designId: g.design_id, x: g.x, y: g.y, isVisibleOnMinimap: true, showBubble: true, decoratorAssetTypes: [] });
    out.push(portalState(g, !p.dead && dist(p,g) <= 750));
  }
  out.push(...require('./galaxy-gates').portals(world));
  out.push(...require('./pirate-fields').commands(p.mapId));
  out.push({ _: 'POIReadyCommand' });
  return out;
}
function beacon(world) {
  const p = world.updatePosition(); const t = world.movement;
  return { _: 'BeaconCommand', repairRobotActive: !!p.repairing, positionAheadX: Math.round(t?.targetX ?? p.x), positionAheadY: Math.round(t?.targetY ?? p.y), positionX: Math.round(p.x), positionY: Math.round(p.y),
    inRadiationZone: false, inStation: nearStation(world), inPeaceArea: nearPeaceArea(world), nearJumpGate: !!(nearestPortal(world) || require('./galaxy-gates').nearestPortal(world)), isAlarmEffectActive: false,
    repairRobotLootId: p.repairRobotLootId || '', repairBotSkilled: (p.stats.skills?.repairMultiplier||1)>=1.3 };
}
module.exports = { getMap, portals, portalAccessLevel, station, home, nearStation, nearPeaceArea, nearestPortal, portalState, tradeState, commands, beacon, dist };
