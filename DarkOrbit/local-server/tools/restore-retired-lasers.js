'use strict';
// User-authorized selective restitution, guarded by a fresh complete snapshot
// and stopped production listeners. No current progress is overwritten.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),net=require('node:net'),{DatabaseSync}=require('node:sqlite');
const root=path.resolve(__dirname,'..'),config=require('../config.json'),quote=s=>'"'+s.replaceAll('"','""')+'"';
function listening(port){return new Promise((resolve,reject)=>{const socket=net.createConnection({host:'127.0.0.1',port});socket.setTimeout(1500);socket.once('connect',()=>{socket.destroy();resolve(true);});socket.once('timeout',()=>{socket.destroy();reject(Error('Port state unknown'));});socket.once('error',e=>e.code==='ECONNREFUSED'?resolve(false):reject(e));});}
async function main(){
 if(process.argv[2]!=='--apply'||!process.argv[3])throw Error('Usage: node tools/restore-retired-lasers.js --apply backups/<fresh-snapshot>.db');
 const snapshot=path.resolve(root,process.argv[3]);assert.ok(snapshot.startsWith(path.join(root,'backups')+path.sep));
 assert.equal(await listening(config.http.port),false,'Stop and save production HTTP first');assert.equal(await listening(config.game.port),false,'Stop and save production TCP first');
 const receipt=require('../logs/retired-lasers-removal.json'),source=new DatabaseSync(path.resolve(root,receipt.backup),{readOnly:true}),before=new DatabaseSync(snapshot,{readOnly:true}),db=new DatabaseSync(path.join(root,'data/darkorbit.db'));
 db.exec('PRAGMA foreign_keys=ON; PRAGMA busy_timeout=5000;');
 const tables=before.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all().map(r=>r.name),rows=(conn,t)=>conn.prepare('SELECT * FROM '+quote(t)).all().map(r=>JSON.stringify(r)).sort();
 try{
  db.exec('BEGIN IMMEDIATE');for(const t of tables)assert.deepEqual(rows(db,t),rows(before,t),'Fresh snapshot differs: '+t);
  const restored=require('../game/restore-lasers').restore(db,source,receipt),allowed=new Set(['items','assembly_jobs','settings']);
  for(const t of tables){const old=rows(before,t),now=rows(db,t);if(!allowed.has(t))assert.deepEqual(now,old,'Unexpected change '+t);else for(const r of old)assert.ok(now.includes(r),'Current row changed in '+t);}
  assert.equal(db.prepare('PRAGMA integrity_check').get().integrity_check,'ok');assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(),[]);
  const changed=tables.filter(t=>JSON.stringify(rows(db,t))!==JSON.stringify(rows(before,t)));
  const report={at:new Date().toISOString(),backup:path.relative(root,snapshot),restored,changedTables:changed,tableCount:tables.length,integrity:'ok',foreignKeys:0};
  db.exec('COMMIT');fs.writeFileSync(path.join(root,'logs/lasers-restored.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
 }catch(e){if(db.isTransaction)db.exec('ROLLBACK');throw e;}finally{db.close();source.close();before.close();}
}
main().catch(e=>{console.error(e.stack);process.exitCode=1;});
