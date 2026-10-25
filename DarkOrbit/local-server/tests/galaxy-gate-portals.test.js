'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),path=require('path');
const database=require('../game/db'),players=require('../game/db/players'),gates=require('../game/galaxy-gates'),codec=require('../game/codec/codec');
test('all ten classicGG entrances use distinct original2D/3D portal assets and standardreturn',()=>{
 database.close();const db=database.open(':memory:');try{
  const acc=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run('portal-assets-qa','test'),pid=players.createPlayer(Number(acc.lastInsertRowid),'portal-assets-qa',1,require('../config.json').starter),p=players.loadPlayer(pid),world={player:p,gatesDb:db};
  const xml=fs.readFileSync(path.join(__dirname,'../decompiled/portal-patterns/portals.xml'),'utf8'),seen=new Set();
  for(const [id,g]of Object.entries(gates.DEFINITIONS))db.prepare("INSERT INTO galaxy_gate_runs(player_id,gate_id,map_id,home_map,state,lives,wave,wave_count,rewards_json,created_at)VALUES(?,?,?,?, 'active',3,1,1,'{}',0)").run(pid,Number(id),g.map,p.mapId);
  const entries=gates.portalRows(world);assert.equal(entries.length,11);
  for(const row of entries){const run=db.prepare('SELECT gate_id FROM galaxy_gate_runs WHERE id=?').get(row.gateRunId),design=gates.PORTAL_DESIGNS[run.gate_id];assert.equal(row.design_id,design);seen.add(design);
   const block=new RegExp(`<asset id="${design}"[^>]*>[\\s\\S]*?<\\/asset>`).exec(xml)?.[0];assert.ok(block,`${run.gate_id} missingembeddedasset`);
   const atlas=/atlasKey="([^"]+)"/.exec(block)[1];assert.ok(fs.existsSync(path.join(__dirname,`../client/spacemap/graphics/portals/${atlas}.xml`)),atlas);
   const geometry=/<mesh[^>]*geometry="([^"]+)"/.exec(block)?.[1];assert.ok(geometry);assert.ok(fs.existsSync(path.join(__dirname,`../client/spacemap/3d/meshes/${geometry}.awd`)),geometry);
  }
  assert.equal(seen.size,11);for(const c of gates.portals(world))assert.equal(codec.decode(codec.encode(c)).obj._,c._);
  p.mapId=gates.DEFINITIONS[6].map;assert.equal(gates.portalRows(world).length,0,'no exit during an active major wave');
  db.prepare('UPDATE galaxy_gate_runs SET waiting_next_wave=1 WHERE player_id=? AND gate_id=6').run(pid);
  const checkpoint=gates.portalRows(world);assert.equal(checkpoint.length,2);assert.equal(checkpoint.find(row=>row.gateAction==='home').design_id,1);assert.equal(checkpoint.find(row=>row.gateAction==='continue').design_id,gates.PORTAL_DESIGNS[6]);assert.ok(checkpoint[0].x<checkpoint[1].x);
 }finally{database.close();}
});
