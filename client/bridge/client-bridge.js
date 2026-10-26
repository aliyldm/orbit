'use strict';
// Keep the existing Qt/Flash client unchanged: its localhost endpoints are
// bridged to configurable overlay-IP or proxy endpoints. No packet contents log.
const http=require('node:http'),https=require('node:https'),net=require('node:net');
const HOP=new Set(['connection','keep-alive','proxy-authenticate','proxy-authorization','te','trailer','transfer-encoding','upgrade']);
function headers(input){const skip=new Set([...HOP,...String(input.connection||'').split(',').map(s=>s.trim().toLowerCase())]);return Object.fromEntries(Object.entries(input).filter(([k])=>!skip.has(k.toLowerCase())));}
async function startBridge(config,local={httpPort:8095,gamePort:8096}){
 const target=new URL(config.portalUrl);
 if(!['http:','https:'].includes(target.protocol)||target.username||target.password||target.search||target.hash||target.pathname!=='/')throw Error('portalUrl yalnızca http(s) sunucu adresi olmalı.');
 if(typeof config.gameHost!=='string'||!config.gameHost||!Number.isInteger(config.gamePort)||config.gamePort<1||config.gamePort>65535)throw Error('Geçerli oyun adresi ve portu gerekli.');
 if(config.requireMultiplayerReady!==false){const response=await fetch(new URL('/ready',target),{signal:AbortSignal.timeout(5000),redirect:'error'});if(!response.ok||(await response.json()).ready!==true)throw Error('Çok oyunculu sunucu henüz hazır değil. Geçiş durumu için MIGRATION.md dosyasına bakın.');}
 const sockets=new Set(),upstreams=new Set();
 const web=http.createServer((request,response)=>{
  // Never let an absolute-form request turn this into an open forward proxy.
  if(!request.url.startsWith('/')||request.url.startsWith('//')){response.writeHead(400);response.end();return;}
  const destination=new URL(target);destination.pathname=request.url.split('?')[0];destination.search=request.url.includes('?')?request.url.slice(request.url.indexOf('?')):'';
  const outgoing=headers(request.headers);outgoing.host=target.host;
  // Qt posts to the loopback bridge. Preserve its same-origin relationship
  // when forwarding to the real Localer portal; unrelated origins stay intact.
  const loopbackOrigins=new Set(['http://127.0.0.1:'+web.address().port,'http://localhost:'+web.address().port]);
  if(outgoing.origin&&loopbackOrigins.has(outgoing.origin))outgoing.origin=target.origin;
  if(outgoing.referer){try{const ref=new URL(outgoing.referer);if(loopbackOrigins.has(ref.origin)){ref.protocol=target.protocol;ref.host=target.host;outgoing.referer=ref.href;}}catch{}}
  const proxy=(target.protocol==='https:'?https:http).request(destination,{method:request.method,headers:outgoing,timeout:15000},upstream=>{
   const incoming=headers(upstream.headers);
   // Redirects under the upstream portal stay in the local Qt origin.
   if(incoming.location&&String(incoming.location).startsWith(target.origin+'/'))incoming.location=String(incoming.location).slice(target.origin.length);
   response.writeHead(upstream.statusCode,incoming);upstream.pipe(response);
  });
  upstreams.add(proxy);proxy.once('close',()=>upstreams.delete(proxy));proxy.on('timeout',()=>proxy.destroy());proxy.on('error',()=>{if(!response.headersSent)response.writeHead(502);response.end('Sunucu bağlantısı kurulamadı.');});request.once('aborted',()=>proxy.destroy());response.once('close',()=>{if(!response.writableEnded)proxy.destroy();});request.pipe(proxy);
 });
 const game=net.createServer(client=>{
  const remote=net.connect({host:config.gameHost,port:config.gamePort});sockets.add(remote);client.setNoDelay(true);remote.setNoDelay(true);
  client.pause();remote.setTimeout(10000,()=>{if(remote.connecting)remote.destroy();});remote.on('connect',()=>{remote.setTimeout(0);client.pipe(remote);remote.pipe(client);client.resume();});
  client.on('error',()=>remote.destroy());remote.on('error',()=>client.destroy());client.on('close',()=>remote.destroy());remote.on('close',()=>{sockets.delete(remote);client.destroy();});
 });
 for(const server of[web,game])server.on('connection',socket=>{sockets.add(socket);socket.once('close',()=>sockets.delete(socket));});
 const listen=(server,port)=>new Promise((resolve,reject)=>{server.once('error',reject);server.listen(port,'127.0.0.1',()=>{server.off('error',reject);resolve();});});
 async function close(){for(const request of upstreams)request.destroy();for(const socket of sockets)socket.destroy();await Promise.all([web,game].map(s=>new Promise(resolve=>s.listening?s.close(resolve):resolve())));}
 try{await listen(web,local.httpPort);await listen(game,local.gamePort);}catch(e){await close();throw e;}
 return{webPort:web.address().port,gamePort:game.address().port,close};
}
module.exports={startBridge};
