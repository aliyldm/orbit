'use strict';
const fs=require('node:fs'),path=require('node:path'),{spawn}=require('node:child_process');
const {startBridge}=require('./bridge/client-bridge');
async function main(){
 const file=path.join(__dirname,'connection.json');
 if(!fs.existsSync(file))throw Error('connection.example.json dosyasini connection.json olarak kopyalayip sunucunun Localer adresini yazin.');
 const config=JSON.parse(fs.readFileSync(file,'utf8'));
 if(config.mode!=='remote'||config.requireMultiplayerReady===false)throw Error('Bu istemci ortak sunucu icindir. mode=remote ve requireMultiplayerReady=true olmali.');
 const exe=path.join(__dirname,'runtime/DarkOrbit.exe');
 if(!fs.existsSync(exe))throw Error('Qt/Flash istemcisi eksik. Tam Windows istemci paketini indirin.');
 const bridge=await startBridge({...config,requireMultiplayerReady:true});
 const child=spawn(exe,[],{cwd:path.dirname(exe),windowsHide:false,stdio:'ignore'});
 let closing=false;
 async function close(){if(closing)return;closing=true;await bridge.close();}
 child.once('error',async e=>{console.error('Istemci acilamadi: '+e.message);process.exitCode=1;await close();});
 child.once('exit',async()=>{await close();});
 process.once('SIGINT',async()=>{child.kill();await close();});
 console.log('Sunucu baglantisi hazir. Oyun aciliyor.');
}
main().catch(e=>{console.error(e.message);process.exitCode=1;});
