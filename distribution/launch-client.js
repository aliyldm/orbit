'use strict';
const fs=require('node:fs'),path=require('node:path'),{spawn}=require('node:child_process');
const root=path.resolve(__dirname,'..'),configFile=path.join(root,'connection.json');
const delay=ms=>new Promise(resolve=>setTimeout(resolve,ms));
async function main(){
 if(!fs.existsSync(configFile))fs.copyFileSync(path.join(__dirname,'connection.example.json'),configFile);
 const config=JSON.parse(fs.readFileSync(configFile,'utf8'));let bridge;
 if(config.mode==='remote'){bridge=await require('./client-bridge').startBridge(config);}
 else if(config.mode==='local'){
  let healthy=false;try{const h=await(await fetch('http://127.0.0.1:8095/health',{signal:AbortSignal.timeout(1000)})).json();healthy=h.service==='darkorbit-local'&&h.status==='ok';}catch{}
  if(!healthy){
   const cwd=path.join(root,'DarkOrbit/local-server'),logs=path.join(cwd,'logs');fs.mkdirSync(logs,{recursive:true});
   const out=fs.openSync(path.join(logs,'launcher-server.log'),'a'),err=fs.openSync(path.join(logs,'launcher-server.err.log'),'a');
   const child=spawn(process.execPath,['server.js'],{cwd,detached:true,windowsHide:true,stdio:['ignore',out,err]});child.unref();fs.closeSync(out);fs.closeSync(err);if(child.pid)fs.writeFileSync(path.join(logs,'launcher-server.pid'),String(child.pid));
   for(let i=0;i<40;i++){await delay(250);try{const r=await fetch('http://127.0.0.1:8095/health',{signal:AbortSignal.timeout(500)}),h=await r.json();if(r.ok&&h.service==='darkorbit-local'&&h.status==='ok'){healthy=true;break;}}catch{}}
   if(!healthy)throw Error('Yerel sunucu başlatılamadı. DarkOrbit/local-server/logs klasörünü kontrol edin.');
  }
 }else throw Error('connection.json mode değeri local veya remote olmalı.');
 const child=spawn(path.join(root,'DarkOrbit/DarkOrbit.exe'),[],{cwd:path.join(root,'DarkOrbit'),windowsHide:false,stdio:'ignore'});
 child.once('error',async()=>{await bridge?.close();console.error('Oyun istemcisi başlatılamadı. Paket dosyalarını kontrol edin.');process.exitCode=1;});
 child.once('exit',async()=>{await bridge?.close();});
}
main().catch(e=>{console.error(e.message);process.exitCode=1;});
