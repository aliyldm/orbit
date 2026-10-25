'use strict';
const assert=require('node:assert/strict'),path=require('node:path');
async function main(){
 const [pidText,account,key]=process.argv.slice(2),pid=Number(pidText);assert.ok(Number.isInteger(pid)&&pid>0&&pid!==process.pid&&account&&key,'Usage: node tools/grant-drone-designs-live.js PID account request-key');
 process._debugProcess(pid);let target;
 for(let n=0;n<20;n++){try{target=(await(await fetch('http://127.0.0.1:9229/json/list',{signal:AbortSignal.timeout(500)})).json()).find(t=>t.type==='node');if(target)break;}catch{}await new Promise(r=>setTimeout(r,100));}
 assert.ok(target?.webSocketDebuggerUrl,'Inspector unavailable; no gift attempted.');
 const ws=new WebSocket(target.webSocketDebuggerUrl);await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});let serial=0;const pending=new Map();
 ws.onmessage=e=>{const m=JSON.parse(e.data),p=pending.get(m.id);if(p){pending.delete(m.id);clearTimeout(p.timer);m.error?p.reject(Error(m.error.message)):p.resolve(m.result);}};
 const evaluate=expression=>new Promise((resolve,reject)=>{const id=++serial,timer=setTimeout(()=>reject(Error('Timeout: retry with the same key only.')),5000);pending.set(id,{resolve,reject,timer});ws.send(JSON.stringify({id,method:'Runtime.evaluate',params:{expression,returnByValue:true}}));});
 try{
  const identity=JSON.parse((await evaluate('JSON.stringify({pid:process.pid,cwd:process.cwd(),entry:process.argv[1]})')).result.value);assert.equal(identity.pid,pid);assert.equal(path.resolve(identity.cwd,identity.entry).toLowerCase(),path.resolve(__dirname,'../server.js').toLowerCase());
  const result=await evaluate(`(()=>{
   const req=process.getBuiltinModule('module').createRequire(process.cwd()+'/server.js'),database=req('./game/db'),db=database.open(),world=req('./game/world').current();
   const account=${JSON.stringify(account)},key=${JSON.stringify('admin_designs_'+key)},ids=['drone_designs_havoc','drone_designs_hercules','drone_designs_spartan','drone_designs_demon-epic'];
   const player=db.prepare('SELECT p.id FROM players p JOIN accounts a ON a.id=p.account_id WHERE a.username=?').get(account);if(!player)throw Error('Account missing');
   const old=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(player.id,key);if(old)return JSON.stringify({replayed:true,...JSON.parse(old.value)});
   const count=id=>db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(player.id,id).n;let receipt;
   database.tx(conn=>{const before=Object.fromEntries(ids.map(id=>[id,count(id)]));for(const id of ids)req('./game/loot-rewards').item(conn,player.id,id,10);receipt={playerId:player.id,account,addedEach:10,before,after:Object.fromEntries(ids.map(id=>[id,count(id)])),at:Date.now()};conn.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?)').run(player.id,key,JSON.stringify(receipt));});
   const live=world?.livePlayer(player.id);if(live){world.broadcast(s=>req('./game/net').sendCmd(s,req('./game/inventory').buildInit(live)));req('./game/assembly').refreshInventory(world);}
   return JSON.stringify({replayed:false,...receipt});
  })()`);
  if(result.exceptionDetails)throw Error(result.exceptionDetails.exception?.description||result.exceptionDetails.text);console.log(result.result.value);
 }finally{ws.close();}
}
main().catch(e=>{console.error(e.message);process.exitCode=1;});
