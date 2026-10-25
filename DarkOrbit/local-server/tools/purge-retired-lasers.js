'use strict';
// Explicit admin operation requested by the user. Requires an online SQLite
// snapshot and both production listeners stopped; deletion is one transaction.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),net=require('node:net'),{DatabaseSync}=require('node:sqlite'),policy=require('../game/equipment-policy');
const root=path.resolve(__dirname,'..'),config=require('../config.json'),quote=s=>'"'+s.replaceAll('"','""')+'"';
function listening(port){return new Promise((resolve,reject)=>{const socket=net.createConnection({host:'127.0.0.1',port});socket.setTimeout(1500);socket.once('connect',()=>{socket.destroy();resolve(true);});socket.once('timeout',()=>{socket.destroy();reject(Error('Port state unknown'));});socket.once('error',e=>e.code==='ECONNREFUSED'?resolve(false):reject(e));});}
async function main(){
 if(process.argv[2]!=='--apply'||!process.argv[3])throw Error('Usage: node tools/purge-retired-lasers.js --apply backups/<snapshot>.db');
 const snapshot=path.resolve(root,process.argv[3]);assert.ok(snapshot.startsWith(path.join(root,'backups')+path.sep));assert.ok(fs.existsSync(snapshot));
 assert.equal(await listening(config.http.port),false,'Stop and save production HTTP first');assert.equal(await listening(config.game.port),false,'Stop and save production TCP first');
 const db=new DatabaseSync(path.join(root,'data/darkorbit.db')),old=new DatabaseSync(snapshot,{readOnly:true});db.exec('PRAGMA foreign_keys=ON; PRAGMA busy_timeout=5000;');
 const tables=old.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all().map(r=>r.name),rows=(conn,t)=>conn.prepare('SELECT * FROM '+quote(t)).all().map(r=>JSON.stringify(r)).sort(),before=new Map();
 try{for(const t of tables){const data=rows(db,t);assert.deepEqual(data,rows(old,t),'Snapshot no longer matches '+t);before.set(t,data);}db.exec('BEGIN IMMEDIATE');const removed=policy.purge(db);const allowed=new Set(['items','equipment_config2','drone_equipment','pet_equipment','equipment_saved','assembly_jobs']);for(const t of tables)if(!allowed.has(t))assert.deepEqual(rows(db,t),before.get(t),'Unexpected mutation '+t);assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(),[]);assert.equal(db.prepare('PRAGMA integrity_check').get().integrity_check,'ok');db.exec('COMMIT');
 const changed=tables.filter(t=>JSON.stringify(rows(db,t))!==JSON.stringify(before.get(t))),report={time:new Date().toISOString(),backup:path.relative(root,snapshot),removedRows:removed.rows.length,removedJobs:removed.jobs.length,changedLayouts:removed.layouts,changedTables:changed,removed};const out=path.join(root,'logs/retired-lasers-removal.json');fs.writeFileSync(out,JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify({...report,removed:undefined,report:out}));
 }catch(e){if(db.isTransaction)db.exec('ROLLBACK');throw e;}finally{db.close();old.close();}
}
main().catch(e=>{console.error(e.stack);process.exitCode=1;});
