'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs'), path = require('node:path'), crypto = require('node:crypto');
const layout = require('../game/normal-map-layout');
const root = path.join(__dirname,'..'), allowed = new Set([...Array.from({length:29},(_,i)=>i+1),91,92,93]);
const nativeXml = fs.readFileSync(path.join(root,layout.SOURCES.topology),'utf8');
const nativeRoutes = [...nativeXml.match(/<jumpgates>([\s\S]*?)<\/jumpgates>/)[1].matchAll(/<jumpgate key="(\d+)" ref="(\d+)">([\s\S]*?)<\/jumpgate>/g)]
  .map(m => ({ key:+m[1], source:+m[2], target:+m[3].match(/<leadsToMap>(\d+)/)[1] })).filter(r => allowed.has(r.source) && allowed.has(r.target));
const portal = (from,to) => layout.portals.find(p => p.map_id===from && p.target_map===to);

test('all32 native map identities/scales and source hashes match the shipped artifacts', () => {
  assert.deepEqual(new Set(layout.maps.map(m=>m.id)),allowed);
  for (const [file,hash] of [[layout.SOURCES.topology,layout.SOURCES.topologySha256],[layout.SOURCES.visualMaps,layout.SOURCES.visualMapsSha256]])
    assert.equal(crypto.createHash('sha256').update(fs.readFileSync(path.join(root,file))).digest('hex').toUpperCase(),hash);
  const visual = fs.readFileSync(path.join(root,layout.SOURCES.visualMaps),'utf8');
  for (const map of layout.maps) {
    const tag = visual.match(new RegExp(`<map id="${map.id}"[^>]*>`))[0];
    assert.ok(tag.includes(`name="${map.name}"`));
    const scale = +(tag.match(/scaleFactor="(\d+)"/)?.[1] || 1);
    assert.equal(map.width,21000*scale); assert.equal(map.height,13100*scale);
  }
  assert.deepEqual(layout.maps.filter(m=>m.scale===2).map(m=>m.id),[16,29,91,93]);
});

test('all96 native routes are represented exactly once without inventing BL/event/GG exits', () => {
  assert.equal(layout.portals.length,96); assert.equal(nativeRoutes.length,96);
  assert.equal(new Set(layout.portals.map(p=>p.id)).size,96);
  assert.equal(new Set(layout.portals.map(p=>p.nativeKey)).size,96);
  for (const route of nativeRoutes) {
    const p = layout.portals.find(p=>p.nativeKey===route.key);
    assert.equal(p?.map_id,route.source); assert.equal(p?.target_map,route.target);
    assert.equal(p.id,150000167+route.key);
  }
  for (const id of [0,30,51,203,300,306,307,308]) assert.equal(layout.getMap(id),null);
});

test('captured1/2 gate coordinates and live roundtrip arrival points remain exact', () => {
  const expected = [[1,150000168,18500,11500],[2,150000169,2000,2000],[3,150000170,18500,2000],[5,150000172,18500,11500]];
  for (const [key,id,x,y] of expected) {
    const p=layout.portals.find(p=>p.nativeKey===key); assert.equal(p.id,id); assert.equal(p.x,x); assert.equal(p.y,y); assert.equal(p.coordinateSource,'capture');
  }
  assert.deepEqual([portal(1,2).target_x,portal(1,2).target_y],[2300,2300]);
  assert.deepEqual([portal(2,1).target_x,portal(2,1).target_y],[18100,11100]);
  assert.deepEqual([layout.getMap(1).start_x,layout.getMap(1).start_y],[3267,2635]);
});

test('every portal, arrival, spawn and station stays inside its native map dimensions', () => {
  const inside=(mapId,x,y)=>{const map=layout.getMap(mapId);assert.ok(Number.isInteger(x)&&x>=0&&x<=map.width,`${mapId} x${x}`);assert.ok(Number.isInteger(y)&&y>=0&&y<=map.height,`${mapId} y${y}`);};
  for(const map of layout.maps)inside(map.id,map.start_x,map.start_y);
  for(const p of layout.portals){inside(p.map_id,p.x,p.y);inside(p.target_map,p.target_x,p.target_y);}
  for(const station of layout.stations)inside(station.map_id,station.x,station.y);
});

test('all84 classic normal directed routes have reciprocal counterparts including company crossings', () => {
  const classic=layout.portals.filter(p=>p.map_id<=29&&p.target_map<=29);
  assert.equal(classic.length,84);
  for(const p of classic)assert.ok(portal(p.target_map,p.map_id),`${p.map_id}->${p.target_map}`);
  assert.ok(portal(3,7));assert.ok(portal(4,12));assert.ok(portal(8,11));
  for(const id of [17,21,25]){assert.ok(portal(16,id));assert.ok(portal(29,id));}
});

test('pirate corridor preserves12 company paths with no fabricated reverse gates', () => {
  const pirate=layout.portals.filter(p=>p.map_id>=91||p.target_map>=91);
  assert.equal(pirate.length,12);
  assert.deepEqual(new Set(pirate.map(p=>`${p.map_id}:${p.target_map}`)),new Set(['29:91','91:92','92:93','93:16']));
  for(const p of pirate)assert.equal(portal(p.target_map,p.map_id),undefined);
  for(const faction of [1,2,3])for(const map of [91,92,93]) {
    const visible=layout.portalsFor(map,faction);assert.equal(visible.length,1);assert.equal(visible[0].factionId,faction);assert.equal(visible[0].ownOnly,true);
  }
});

test('every map is reachable from each home atlevel17 with all three faction-specific pirate exits', () => {
  for(const [faction,home] of [[1,1],[2,5],[3,9]]) {
    const reached=new Set([home]),queue=[home];
    while(queue.length)for(const p of layout.portalsFor(queue.shift(),faction)) {
      if(layout.portalAccessLevel(p,faction)<=17&&!reached.has(p.target_map)){reached.add(p.target_map);queue.push(p.target_map);}
    }
    assert.deepEqual(reached,allowed);
  }
});

test('source faction-dependent level access distinguishes lower, upper and battle destinations', () => {
  for(const faction of [1,2,3]) {
    const own=layout.maps.filter(m=>m.faction_id===faction);
    for(const map of own)assert.equal(layout.accessLevel(map.id,faction),({1:1,2:1,3:2,4:2,5:10,6:11,7:11,8:12})[map.name.split('-')[1]]);
    for(const map of own)assert.equal(layout.accessLevel(map.id,faction%3+1),({1:16,2:13,3:5,4:5,5:14,6:15,7:15,8:17})[map.name.split('-')[1]]);
    for(const id of [13,14,15])assert.equal(layout.accessLevel(id,faction),8);
    assert.equal(layout.accessLevel(16,faction),9);
    for(const id of [29,91,92,93])assert.equal(layout.accessLevel(id,faction),12);
  }
  assert.equal(layout.accessLevel(51,1),Infinity);assert.equal(layout.accessLevel(1,0),Infinity);
});

test('direct x3/x4 links require level3 own or6 enemy without blocking own level2 x2/x4 entry', () => {
  assert.equal(layout.accessLevel(4,1),2);
  assert.equal(layout.portalAccessLevel(portal(2,4),1),2);
  assert.equal(layout.portalAccessLevel(portal(3,4),1),3);
  assert.equal(layout.portalAccessLevel(portal(4,3),2),6);
  assert.equal(layout.portalAccessLevel(portal(3,7),1),5);
  assert.equal(portal(3,4).min_level,3);
});

test('home/upper/pirate stations remain distinct and only actual home maps are respawn starts', () => {
  assert.equal(layout.stations.length,7);assert.deepEqual(layout.maps.filter(m=>m.is_start).map(m=>m.id),[1,5,9]);
  assert.equal(layout.station(1).coordinateSource,'capture');assert.equal(layout.station(20).kind,'upper');
  assert.equal(layout.station(92).kind,'pirate-trade');assert.equal(layout.station(92).factionId,0);
  assert.equal(layout.station(2),null);
  const copied=layout.station(1);copied.x=999;assert.equal(layout.station(1).x,2000);
});
