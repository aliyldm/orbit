'use strict';
// Transitional compatibility projection. Evaluate existing derived stats/init on
// an online SQLite BACKUP, never on the user's database. Not a new stats engine.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),{DatabaseSync,backup}=require('node:sqlite');
const root=path.resolve(__dirname,'..'),legacy=path.resolve(root,'../local-server');
async function main(){
 const privateDir=path.join(root,'artifacts/private');fs.mkdirSync(privateDir,{recursive:true});
 const baseline=JSON.parse(fs.readFileSync(path.join(privateDir,'legacy-snapshot.json'),'utf8'));
 const temporary=path.join(privateDir,'native-export-'+crypto.randomBytes(8).toString('hex')+'.db');
 const source=new DatabaseSync(baseline.source,{readOnly:true});try{await backup(source,temporary);}finally{source.close();}
 const database=require('../../local-server/game/db');
 const worlds=[];
 try{
  const db=database.open(temporary),players=require('../../local-server/game/db/players'),World=require('../../local-server/game/world'),codec=require('../../local-server/game/codec/codec'),config=require('../../local-server/config');
  // Projection must belong to the SAME snapshot as the PostgreSQL archive.
  for(const t of baseline.tables){const q='"'+t.name.replaceAll('"','""')+'"',statement=db.prepare('SELECT * FROM '+q);statement.setReadBigInts(true);
   const cell=v=>v===null?{kind:'null'}:typeof v==='bigint'?{kind:'integer',value:String(v)}:typeof v==='number'?{kind:'real',value:String(v)}:typeof v==='string'?{kind:'text',value:v}:{kind:'blob',value:Buffer.from(v).toString('base64')};
   const actual=statement.all().map(r=>JSON.stringify(t.columns.map(c=>cell(r[c.name])))).sort();
   if(JSON.stringify(actual)!==JSON.stringify(t.rows.map(r=>JSON.stringify(r)).sort()))throw Error('Snapshot changed; create a fresh archive first: '+t.name);
  }
  const profiles=[];
  for(const row of db.prepare('SELECT id,account_id FROM players ORDER BY id').all()){
   const world=new World(config);worlds.push(world);const session={world,send(){},close(){}};world.login(session,row.id);
   const commands=require('../../local-server/game/init').buildInit(world);
   profiles.push({playerId:row.id,accountId:row.account_id,profile:world.player,commands,bodies:commands.map(c=>codec.encode(c).toString('base64'))});
  }
  const result={format:1,sourceSnapshotSha256:crypto.createHash('sha256').update(fs.readFileSync(path.join(privateDir,'legacy-snapshot.json'))).digest('hex'),privateMapIds:db.prepare('SELECT id FROM maps').all().filter(m=>require('../../local-server/game/galaxy-gates').isGateMap(m.id)).map(m=>m.id),profiles};
  fs.writeFileSync(path.join(privateDir,'native-profiles.json'),JSON.stringify(result),{mode:0o600});
  const report={profiles:profiles.length,initializationCommands:profiles.map(p=>({playerId:p.playerId,commands:p.commands.length,bytes:p.bodies.reduce((n,b)=>n+Buffer.from(b,'base64').length,0)})),sourceUnmodified:true,derivedStatsPorted:false};
  fs.writeFileSync(path.join(root,'artifacts/native-profile-export.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
 }finally{for(const w of worlds){w.cancelScheduled();w.collectables?.clear();w.combat?.stop();}database.close();for(const suffix of['','-wal','-shm'])fs.rmSync(temporary+suffix,{force:true});}
}
main().catch(e=>{console.error(e.message);process.exitCode=1;});
