'use strict';
// Versioned world content is applied once; normal NPCs use named canonical
// definitions while custom/unkeyed map_spawns retain their database tuning.
const VERSION='normal-world-2026-10-20-v1';
const POPULATION_VERSION='normal-population-2026-10-23-v3';
const catalog=require('./npc-catalog');
function definition(key, behavior={}) {
  const base=catalog.definitions[key];
  if(!base)throw Error(`Normal NPC catalogue key missing: ${key}`);
  const classic=/^(?:(?:boss|uber)-)?(?:streuner|lordakia|saimon|mordon|devolarium|sibelon|sibelonit|lordakium|kristallin|kristallon|streuner-upper)$/.test(key);
  const defaultBehavior={aggression:'passive',acquisitionRadius:900,retainRadius:2500,attackRange:600,chaseDistance:450,roam:true,
    ...(classic?{fleeAt:.1,fleeToCorner:true}:{}),
    ...(key==='cubikon'?{canAttack:false,chase:false}:{}),...behavior};
  if(key==='interceptor')defaultBehavior.speedFromPlayerOffset=-20;
  const def={...base,reward:{...base.reward},behavior:defaultBehavior};
  if(key==='barracuda'){def.speed=430;def.localSpeed=false;}
  if(key==='annihilator'){def.speed=350;def.localSpeed=false;}
  // Normal maps use Combat.npcAbsorb's configured .8 fallback, not gate .5.
  const cargo=require('./normal-npc-cargo.json')[key];if(cargo)def.cargo=structuredClone(cargo);
  return def;
}
function spawnRows(db,mapId){
  const rows=db.prepare('SELECT s.id spawn_id,s.catalog_key,s.behavior_json,s.count,s.respawn_ms,t.* FROM map_spawns s JOIN npc_types t ON t.type_id=s.npc_type WHERE s.map_id=? ORDER BY s.id').all(mapId);
  return rows.map(r=>({spawnId:r.spawn_id,count:r.count,def:r.catalog_key?{...definition(r.catalog_key,JSON.parse(r.behavior_json||'{}')),respawnMs:r.respawn_ms}:
    {typeId:r.type_id,name:r.name,hitpoints:r.hitpoints,shield:r.shield,speed:r.speed,damageMin:r.damage_min,damageMax:r.damage_max,respawnMs:r.respawn_ms,
      reward:{ep:r.reward_ep,honour:r.reward_honour,credits:r.reward_credits,uridium:r.reward_uridium}}}));
}
function spawnBehavior(row,rows){
  const behavior={aggression:row.aggressive?'aggressive':'passive'};
  const supports=rows.filter(r=>r.dependentOn===row.key).map(r=>({key:r.key,count:r.count,activation:r.spawnTrigger==='parent-attacked'?'damaged':'always',respawnMs:5000,
    ...(row.key==='battleray'?{protectionThreshold:Math.floor(r.count/2),healEveryMs:10000,healFraction:.1}:{})}));
  if(supports.length)behavior.supports=supports;
  return behavior;
}
function install(db){
  if(db.prepare('SELECT 1 FROM normal_world_versions WHERE version=?').get(VERSION))return false;
  const layout=require('./normal-map-layout'), profiles=require('./normal-map-spawns');
  const mapIds=layout.maps.map(m=>m.id), prior={maps:[],portals:[],spawns:[]};
  for(const id of mapIds){
    const row=db.prepare('SELECT * FROM maps WHERE id=?').get(id);if(row)prior.maps.push(row);
    prior.portals.push(...db.prepare('SELECT * FROM portals WHERE map_id=?').all(id));
    prior.spawns.push(...db.prepare('SELECT * FROM map_spawns WHERE map_id=?').all(id));
  }
  const upsert=db.prepare('INSERT INTO maps(id,name,faction_id,is_start,width,height,start_x,start_y)VALUES(?,?,?,?,?,?,?,?) ON CONFLICT(id)DO UPDATE SET name=excluded.name,faction_id=excluded.faction_id,is_start=excluded.is_start,width=excluded.width,height=excluded.height,start_x=excluded.start_x,start_y=excluded.start_y');
  for(const m of layout.maps)upsert.run(m.id,m.name,m.faction_id,m.is_start,m.width,m.height,m.start_x,m.start_y);
  for(const id of mapIds){db.prepare('DELETE FROM portals WHERE map_id=?').run(id);db.prepare('DELETE FROM map_spawns WHERE map_id=?').run(id);}
  const portal=db.prepare('INSERT INTO portals(id,map_id,x,y,target_map,target_x,target_y,min_level,design_id)VALUES(?,?,?,?,?,?,?,?,?)');
  for(const p of layout.portals)portal.run(p.id,p.map_id,p.x,p.y,p.target_map,p.target_x,p.target_y,p.min_level??1,p.design_id??1);
  const add=db.prepare('INSERT INTO map_spawns(map_id,npc_type,count,respawn_ms,catalog_key,behavior_json)VALUES(?,?,?,?,?,?)');
  for(const m of layout.maps){
    const rows=profiles.get(m.name);
    for(const row of rows.filter(r=>!r.dependentOn)){
      const def=definition(row.key),behavior=spawnBehavior(row,rows);
      add.run(m.id,def.typeId,row.count,row.respawnMs,row.key,JSON.stringify(behavior));
    }
  }
  db.prepare('INSERT INTO normal_world_versions(version,installed_at,previous_content_json)VALUES(?,?,?)').run(VERSION,Date.now(),JSON.stringify(prior));
  return true;
}
function seed(db){
  db.exec('SAVEPOINT normal_world_install');
  try{let result=install(db);
    if(!db.prepare('SELECT 1 FROM normal_world_versions WHERE version=?').get(POPULATION_VERSION)){
      const prior=[],profiles=require('./normal-map-spawns'),layout=require('./normal-map-layout');
      // Update existing profile IDs in place: deleting/recreating map_spawns
      // would cascade into pilot health, kill generations and respawn timers.
      for(const m of layout.maps){const profile=profiles.get(m.name);for(const row of profile.filter(r=>!r.dependentOn)){
        const rows=db.prepare('SELECT * FROM map_spawns WHERE map_id=? AND catalog_key=?').all(m.id,row.key);prior.push(...rows);
        if(rows.length)db.prepare('UPDATE map_spawns SET count=? WHERE map_id=? AND catalog_key=?').run(row.count,m.id,row.key);
        else db.prepare('INSERT INTO map_spawns(map_id,npc_type,count,respawn_ms,catalog_key,behavior_json)VALUES(?,?,?,?,?,?)').run(m.id,definition(row.key).typeId,row.count,row.respawnMs,row.key,JSON.stringify(spawnBehavior(row,profile)));
      }}
      db.prepare('INSERT INTO normal_world_versions(version,installed_at,previous_content_json)VALUES(?,?,?)').run(POPULATION_VERSION,Date.now(),JSON.stringify({spawns:prior}));result=true;
    }
    db.exec('RELEASE normal_world_install');return result;}
  catch(error){db.exec('ROLLBACK TO normal_world_install; RELEASE normal_world_install');throw error;}
}
module.exports={VERSION,POPULATION_VERSION,definition,spawnRows,seed};
