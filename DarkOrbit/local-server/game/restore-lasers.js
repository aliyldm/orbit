'use strict';
// Selective, once-only restitution of the recorded laser deletion. Never roll
// back a whole database or overwrite equipment/currency/progression earned since.
const assert=require('node:assert/strict');
const KEY='admin.restore-lasers-20261024';
function restore(db,source,receipt){
 assert.ok(Array.isArray(receipt?.removed?.rows)&&Array.isArray(receipt?.removed?.jobs),'Missing deletion receipt');
 const owners=[...new Set(receipt.removed.rows.map(r=>r.player_id))],reports=[];
 db.exec('SAVEPOINT restore_lasers');
 try{
  for(const playerId of owners){
   const saved=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(playerId,KEY);
   if(saved){reports.push({...JSON.parse(saved.value),repeated:true});continue;}
   assert.ok(db.prepare('SELECT 1 FROM players WHERE id=?').get(playerId),'Original owner missing');
   const mapping={},rows=receipt.removed.rows.filter(r=>r.player_id===playerId);
   for(const row of rows){
    assert.ok(row.loot_id.startsWith('equipment_weapon_laser_'),'Non-laser in receipt');
    assert.deepEqual({...source.prepare('SELECT * FROM items WHERE id=?').get(row.id)},row,'Archive and receipt differ');
    const result=db.prepare('INSERT INTO items(player_id,loot_id,amount,upgrade_level,pet_level)VALUES(?,?,?,?,?)').run(playerId,row.loot_id,row.amount,row.upgrade_level,row.pet_level);
    mapping[row.id]=Number(result.lastInsertRowid);
   }
   let jobs=0;for(const job of receipt.removed.jobs.filter(j=>j.player_id===playerId)){
    assert.deepEqual({...source.prepare('SELECT * FROM assembly_jobs WHERE player_id=? AND recipe_loot_id=? AND target_id=?').get(playerId,job.recipe_loot_id,job.target_id)},job,'Archived job differs');
    const result=JSON.parse(job.result_json),target=mapping[job.target_id];assert.ok(target&&result.upgrade?.targetId===job.target_id,'Job does not target a restored laser');
    result.upgrade.targetId=target;
    db.prepare('INSERT INTO assembly_jobs(player_id,recipe_loot_id,target_id,amount,started_at,due_at,result_json,skip_json,notified)VALUES(?,?,?,?,?,?,?,?,0)')
     .run(playerId,job.recipe_loot_id,target,job.amount,job.started_at,job.due_at,JSON.stringify(result),job.skip_json);jobs++;
   }
   const report={playerId,restoredRows:rows.length,restoredJobs:jobs,mapping,restoredAt:new Date().toISOString()};
   db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?)').run(playerId,KEY,JSON.stringify(report));reports.push(report);
  }
  assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(),[]);db.exec('RELEASE restore_lasers');return reports;
 }catch(error){db.exec('ROLLBACK TO restore_lasers; RELEASE restore_lasers');throw error;}
}
module.exports={KEY,restore};
