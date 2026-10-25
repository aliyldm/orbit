'use strict';
// Explicit local admin grant, applied in the running server's SQLite transaction
// and live wallet together. Stable request key makes a retry safe.
const assert=require('node:assert/strict'),path=require('node:path');
async function main(){
 const [pidText,name,amountText,key]=process.argv.slice(2),pid=Number(pidText),amount=Number(amountText);
 assert.ok(Number.isInteger(pid)&&pid>0&&pid!==process.pid&&name&&Number.isSafeInteger(amount)&&amount>0&&key,'Usage: node tools/grant-live.js PID account amount request-key');
 process._debugProcess(pid);
 let target;for(let n=0;n<20;n++){try{target=(await(await fetch('http://127.0.0.1:9229/json/list',{signal:AbortSignal.timeout(500)})).json()).find(t=>t.type==='node');if(target)break;}catch{}await new Promise(r=>setTimeout(r,100));}
 assert.ok(target?.webSocketDebuggerUrl,'No inspector; grant was not attempted.');
 const socket=new WebSocket(target.webSocketDebuggerUrl);await new Promise((resolve,reject)=>{socket.onopen=resolve;socket.onerror=reject;});let serial=0;const pending=new Map();
 socket.onmessage=e=>{const m=JSON.parse(e.data),p=pending.get(m.id);if(p){pending.delete(m.id);clearTimeout(p.timer);m.error?p.reject(Error(m.error.message)):p.resolve(m.result);}};
 function evaluate(expression){return new Promise((resolve,reject)=>{const id=++serial,timer=setTimeout(()=>{pending.delete(id);reject(Error('Inspector timeout; retry ONLY with the same request key.'));},5000);pending.set(id,{resolve,reject,timer});socket.send(JSON.stringify({id,method:'Runtime.evaluate',params:{expression,returnByValue:true}}));});}
 try{
  const identity=JSON.parse((await evaluate('JSON.stringify({pid:process.pid,cwd:process.cwd(),entry:process.argv[1]})')).result.value);
  assert.equal(identity.pid,pid);assert.equal(path.resolve(identity.cwd,identity.entry).toLowerCase(),path.resolve(__dirname,'../server.js').toLowerCase(),'Wrong server; grant refused.');
  const script=`(()=>{const req=process.getBuiltinModule('module').createRequire(process.cwd()+'/server.js');return JSON.stringify(req('./game/admin-wallet').grantUridium(${JSON.stringify(name)},${amount},${JSON.stringify(key)}));})()`;
  const result=await evaluate(script);if(result.exceptionDetails)throw Error(result.exceptionDetails.exception?.description||result.exceptionDetails.text);console.log(result.result.value);
 }finally{socket.close();}
}
main().catch(e=>{console.error(e.message);process.exitCode=1;});
