'use strict';
const fs=require('node:fs'),{DatabaseSync}=require('node:sqlite');
require('./capture-legacy-baseline');
const snapshot=JSON.parse(fs.readFileSync(require('node:path').join(__dirname,'../artifacts/private/legacy-snapshot.json'),'utf8'));
const db=new DatabaseSync(snapshot.source,{readOnly:true});
const quote=s=>'"'+s.replaceAll('"','""')+'"';
function cell(v){if(v===null)return{kind:'null'};if(typeof v==='bigint')return{kind:'integer',value:String(v)};if(typeof v==='number')return{kind:'real',value:String(v)};if(typeof v==='string')return{kind:'text',value:v};if(v instanceof Uint8Array)return{kind:'blob',value:Buffer.from(v).toString('base64')};throw Error('Unknown type');}
try{
 db.exec('BEGIN');
 const tables=db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all();
 if(JSON.stringify(tables.map(t=>t.name))!==JSON.stringify(snapshot.tables.map(t=>t.name)))throw Error('Legacy table list changed');
 for(const table of snapshot.tables){
  const columns=db.prepare('PRAGMA table_info('+quote(table.name)+')').all();
  if(JSON.stringify(columns)!==JSON.stringify(table.columns))throw Error('Source schema changed: '+table.name);
  const statement=db.prepare('SELECT * FROM '+quote(table.name));statement.setReadBigInts(true);
  const actual=statement.all().map(row=>JSON.stringify(columns.map(c=>cell(row[c.name])))).sort();
  const expected=table.rows.map(row=>JSON.stringify(row)).sort();
  if(JSON.stringify(actual)!==JSON.stringify(expected))throw Error('Source data changed since snapshot (may include legitimate live play): '+table.name);
 }
 if(db.prepare('PRAGMA integrity_check').get().integrity_check!=='ok'||db.prepare('PRAGMA foreign_key_check').all().length)throw Error('Source integrity failed');
 db.exec('COMMIT');console.log(`PASS source SQLite: all ${tables.length} table definitions/values unchanged; integrity OK, foreign keys OK`);
}finally{db.close();}
