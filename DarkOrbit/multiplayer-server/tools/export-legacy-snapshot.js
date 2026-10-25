'use strict';
// Read-only consistent SQLite transaction. Does not run legacy migrations/seeds.
// PRIVATE output contains password hashes and all player progress. Never publish.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),{DatabaseSync}=require('node:sqlite');
const root=path.resolve(__dirname,'..');
const source=path.resolve(process.argv[2]||path.join(root,'../local-server/data/darkorbit.db'));
const output=path.resolve(process.argv[3]||path.join(root,'artifacts/private/legacy-snapshot.json'));
const quote=s=>'"'+s.replaceAll('"','""')+'"';
function value(v){if(v===null)return{kind:'null'};if(typeof v==='bigint')return{kind:'integer',value:v.toString()};if(typeof v==='number'){if(!Number.isFinite(v))throw Error('Nonfinite database value');return{kind:'real',value:String(v)};}if(typeof v==='string')return{kind:'text',value:v};if(v instanceof Uint8Array)return{kind:'blob',value:Buffer.from(v).toString('base64')};throw Error('Unknown SQLite storage class');}
function exportSnapshot(){
 const db=new DatabaseSync(source,{readOnly:true});
 try{
  db.exec('BEGIN');if(db.prepare('PRAGMA integrity_check').get().integrity_check!=='ok')throw Error('SQLite integrity failed');if(db.prepare('PRAGMA foreign_key_check').all().length)throw Error('SQLite foreign keys failed');
  const tables=db.prepare("SELECT name,sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all().map(({name,sql})=>{
   const statement=db.prepare('SELECT * FROM '+quote(name));statement.setReadBigInts(true);
   const columns=db.prepare('PRAGMA table_info('+quote(name)+')').all();
   return{name,sql,columns,foreignKeys:db.prepare('PRAGMA foreign_key_list('+quote(name)+')').all(),indexes:db.prepare('PRAGMA index_list('+quote(name)+')').all().map(i=>({...i,columns:db.prepare('PRAGMA index_info('+quote(i.name)+')').all(),sql:db.prepare('SELECT sql FROM sqlite_master WHERE type=\'index\' AND name=?').get(i.name)?.sql??null})),rows:statement.all().map(row=>columns.map(c=>value(row[c.name])))};
  });
  const manifest={format:1,createdAt:new Date().toISOString(),source,tables};const bytes=JSON.stringify(manifest);fs.mkdirSync(path.dirname(output),{recursive:true});fs.writeFileSync(output,bytes,{mode:0o600});
  const report={snapshotSha256:crypto.createHash('sha256').update(bytes).digest('hex'),tableCount:tables.length,rowCount:tables.reduce((n,t)=>n+t.rows.length,0),tables:tables.map(t=>({name:t.name,rows:t.rows.length,columns:t.columns.length}))};
  fs.writeFileSync(output+'.manifest.json',JSON.stringify(report,null,2)+'\n');db.exec('COMMIT');console.log(`PASS readonly export: ${report.tableCount} tables / ${report.rowCount} rows; private snapshot saved`);
 }finally{db.close();}
}
exportSnapshot();
