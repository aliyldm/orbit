'use strict';
// Offline administrative account copy. No HTTP endpoint and no embedded password.
// CLI: node tools/clone-test-account.js SOURCE TARGET < password-on-stdin
const assert=require('node:assert/strict'),database=require('../game/db'),players=require('../game/db/players');
const q=name=>'"'+name.replaceAll('"','""')+'"';
function schema(db){return db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all().map(({name})=>({name,columns:db.prepare(`PRAGMA table_info(${q(name)})`).all(),fks:db.prepare(`PRAGMA foreign_key_list(${q(name)})`).all()}));}
function insert(db,table,row){const keys=Object.keys(row);return db.prepare(`INSERT INTO ${q(table)}(${keys.map(q).join(',')})VALUES(${keys.map(()=>'?').join(',')})`).run(...keys.map(k=>row[k]));}
function cloneTestAccount(db,{sourceUsername,username,password,now=Date.now()}){
 assert.equal(database.open(),db,'Use the project connection so password creation shares the transaction');
 assert.ok(typeof username==='string'&&/^[a-zA-Z0-9_-]{1,32}$/.test(username));assert.ok(typeof password==='string'&&password.length>=6);
 const sourceAccount=players.findAccount(sourceUsername);assert.ok(sourceAccount,'Source account missing');assert.ok(!players.findAccount(username),'Target account already exists; refusing to overwrite');
 const source=db.prepare('SELECT * FROM players WHERE account_id=?').get(sourceAccount.id);assert.ok(source);assert.ok(source.level>=2,'Source must qualify for rank by level');
 const meta=schema(db),owned=new Set(['players']);let discovered=true;while(discovered){discovered=false;for(const t of meta)if(!owned.has(t.name)&&t.fks.some(f=>owned.has(f.table))){owned.add(t.name);discovered=true;}}
 return database.tx(()=>{
  const accountId=players.createAccount(username,password);
  // Test fixture age meets the real rank calculator's four-week requirement.
  db.prepare('UPDATE accounts SET created_at=? WHERE id=?').run(now-require('../game/ranks').AGE-86400000,accountId);
  const p={...source,account_id:accountId,name:username,active_ship_id:null,created_at:now};delete p.id;
  const playerId=Number(insert(db,'players',p).lastInsertRowid),maps={players:new Map([[source.id,playerId]])},counts={players:1};
  function mapped(table,id){if(id==null)return id;assert.ok(maps[table]?.has(id),`Unowned/unmapped ${table} reference ${id}`);return maps[table].get(id);}
  function targetId(id){if(!id)return id;if(id>=2000000000)return 2000000000+mapped('ships',id-2000000000);if(id>=1000000000)return 1000000000+mapped('drones',id-1000000000);return mapped('items',id);}
  function json(text,{layout=false,assembly=false}={}){
   if(text==null)return text;
   const refs={playerId:'players',userId:'players',activeShipId:'ships',shipId:'ships',itemId:'items',droneId:'drones',runId:'galaxy_gate_runs'};
   function visit(v,key=''){
    if(Array.isArray(v))return v.map(x=>{const table={droneIds:'drones',itemIds:'items',shipIds:'ships'}[key];return table&&maps[table]?.has(x)?mapped(table,x):visit(x);});
    if(v&&typeof v==='object')return Object.fromEntries(Object.entries(v).map(([k,x])=>[k,layout&&k==='id'?mapped('items',x):assembly&&k==='targetId'?targetId(x):visit(x,k)]));
    if(refs[key]&&maps[refs[key]]?.has(v))return mapped(refs[key],v);
    if(['name','username','userName'].includes(key)&&v===source.name)return username;
    return v;
   }
   return JSON.stringify(visit(JSON.parse(text)));
  }
  const pending=meta.filter(t=>owned.has(t.name)&&t.name!=='players'),done=new Set(['players']);
  const hidden={assembly_jobs:['items','drones','ships'],equipment_saved:['items','drones'],settings:['items','drones','ships','galaxy_gate_runs'],local_repairs:['drones','items','ships'],rank_npc_claims:['galaxy_gate_runs']};
  while(pending.length){let copied=false;
   for(let i=0;i<pending.length;i++){
    const t=pending[i],deps=[...t.fks.filter(f=>owned.has(f.table)).map(f=>f.table),...(hidden[t.name]||[])];if(deps.some(n=>!done.has(n)))continue;
    const refs=t.fks.filter(f=>owned.has(f.table)),direct=t.columns.some(c=>c.name==='player_id');
    const rows=direct?db.prepare(`SELECT * FROM ${q(t.name)} WHERE player_id=?`).all(source.id):db.prepare(`SELECT * FROM ${q(t.name)}`).all().filter(row=>refs.some(f=>maps[f.table]?.has(row[f.from])));
    maps[t.name]=new Map();counts[t.name]=rows.length;
    const pk=t.columns.filter(c=>c.pk),generated=pk.length===1&&pk[0].name==='id'&&pk[0].type==='INTEGER';
    for(const row of rows){const next={...row};for(const f of refs)next[f.from]=mapped(f.table,row[f.from]);
     if(generated)delete next.id;
     if(t.name==='local_repairs'){next.id=`clone:${playerId}:${row.id}`;next.details=json(row.details);}
     if(t.name==='loot_claims')next.box_hash=`clone:${playerId}:${row.box_hash}`;
     if(t.name==='equipment_saved')next.layout=json(row.layout,{layout:true});
     if(t.name==='assembly_jobs'){next.target_id=targetId(row.target_id);next.result_json=json(row.result_json,{assembly:true});}
     if(t.name==='settings')next.value=json(row.value);
     if(t.name==='rank_npc_claims')next.event_key=row.event_key.replace(/^gate:(\d+):/,(_m,id)=>`gate:${mapped('galaxy_gate_runs',Number(id))}:`);
     const result=insert(db,t.name,next);if(pk.length===1)maps[t.name].set(row[pk[0].name],generated?Number(result.lastInsertRowid):next[pk[0].name]);
    }
    done.add(t.name);pending.splice(i--,1);copied=true;
   }
   assert.ok(copied,'Unresolved ownership dependency: '+pending.map(t=>t.name).join(','));
  }
  db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(mapped('ships',source.active_ship_id),playerId);
  const gates=require('../game/galaxy-gates'),completed=[];
  for(const [id,gate]of Object.entries(gates.DEFINITIONS)){
   const gateId=Number(id);let run=db.prepare("SELECT * FROM galaxy_gate_runs WHERE player_id=? AND gate_id=? ORDER BY state='active' DESC,id DESC LIMIT 1").get(playerId,gateId);
   if(!run){const plan=gateId===12?require('../game/kronos').build({userName:username,typeId:db.prepare('SELECT loot_id FROM ships WHERE id=?').get(mapped('ships',source.active_ship_id)).loot_id}):require('../game/galaxy-gate-content').build(gateId);
    const id=Number(insert(db,'galaxy_gate_runs',{player_id:playerId,gate_id:gateId,map_id:gate.map,home_map:({1:1,2:5,3:9})[source.faction_id],state:'won',lives:3,wave:plan.phases.length,wave_count:plan.phases.length,remaining_json:'[]',death_pending:0,rewards_json:JSON.stringify(plan.rewards),created_at:now,finished_at:now,plan_json:JSON.stringify(plan),released_wave:plan.phases.length,waiting_next_wave:0}).lastInsertRowid);run={id};
   }
   db.prepare("UPDATE galaxy_gate_runs SET state='won',wave=wave_count,remaining_json='[]',death_pending=0,finished_at=COALESCE(finished_at,?),waiting_next_wave=0,released_wave=wave_count WHERE player_id=? AND gate_id=? AND state='active'").run(now,playerId,gateId);
   if(!db.prepare("SELECT 1 FROM galaxy_gate_runs WHERE id=? AND state='won'").get(run.id))db.prepare("UPDATE galaxy_gate_runs SET state='won',finished_at=?,remaining_json='[]',death_pending=0,waiting_next_wave=0 WHERE id=?").run(now,run.id);
   // Administrative completion evidence, never a second payout of copied loot.
   db.prepare('INSERT OR IGNORE INTO galaxy_gate_completion_claims(run_id,reward_json,claimed_at)VALUES(?,?,?)').run(run.id,JSON.stringify({adminCompletion:true,source:'test-account-clone',delivered:false}),now);
   db.prepare("INSERT INTO galaxy_gate_progress(player_id,gate_id,active,lives,wave)VALUES(?,?,0,-1,0) ON CONFLICT(player_id,gate_id)DO UPDATE SET active=0,lives=-1,wave=0").run(playerId,gateId);completed.push({id:gateId,name:gate.name});
  }
  if(gates.isGateMap(source.map_id)){const home=db.prepare('SELECT * FROM maps WHERE faction_id=? AND is_start=1').get(source.faction_id);db.prepare('UPDATE players SET map_id=?,x=?,y=? WHERE id=?').run(home.id,home.start_x,home.start_y,playerId);}
  const mask=require('../game/gate-rings').sync(db,playerId),ranks=require('../game/ranks');
  const highest=Math.max(0,...db.prepare('SELECT id FROM players WHERE id<>?').all(playerId).map(p=>ranks.calculate(db,p.id,now).points)),initial=ranks.calculate(db,playerId,now);
  const honour=Math.max(source.honour,Math.ceil((highest+1000000-(initial.points-initial.breakdown.honour))*100));assert.ok(Number.isSafeInteger(honour));db.prepare('UPDATE players SET honour=? WHERE id=?').run(honour,playerId);
  // Do not inherit the source pilot's already-cached daily badge.
  db.prepare('DELETE FROM rank_daily WHERE player_id=? AND day=?').run(playerId,ranks.dayKey(now));ranks.refreshDaily(db,now);
  const rank=ranks.current(db,playerId,now);assert.ok(rank.points>highest);assert.equal(rank.dailyRank,20);
  const report={sourcePlayerId:source.id,playerId,username,createdAt:now,counts,completedGates:completed,gateMask:mask,rank:{points:rank.points,badge:rank.dailyRank,honour,accountAgeDays:rank.days},remaps:Object.fromEntries(Object.entries(maps).filter(([n])=>['players','ships','items','drones','galaxy_gate_runs','skylab_transports'].includes(n)).map(([n,m])=>[n,Object.fromEntries(m)]))};
  insert(db,'settings',{player_id:playerId,key:'admin.clone-test-account',value:JSON.stringify(report)});
  assert.deepEqual(db.prepare('PRAGMA foreign_key_check').all(),[]);assert.equal(players.loadPlayer(playerId).userName,username);
  return report;
 });
}
module.exports={cloneTestAccount,schema};
if(require.main===module){const fs=require('node:fs');try{const password=fs.readFileSync(0,'utf8').trim();const result=cloneTestAccount(database.open(),{sourceUsername:process.argv[2],username:process.argv[3],password});console.log(JSON.stringify(result,null,2));}catch(e){console.error(e.message);process.exitCode=1;}finally{database.close();}}
