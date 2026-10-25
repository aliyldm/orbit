'use strict';
const{test}=require('node:test'),assert=require('node:assert/strict'),http=require('node:http'),net=require('node:net'),{once}=require('node:events'),{startBridge}=require('./client-bridge');
test('real HTTP/TCP bridge retains cookies, request paths and opaque native bytes; readiness blocks incomplete hosts',async()=>{
 let ready=false,received='';const web=http.createServer((req,res)=>{if(req.url==='/ready'){res.writeHead(ready?200:503,{'content-type':'application/json'});return res.end(JSON.stringify({ready}));}req.on('data',c=>received+=c);req.on('end',()=>{res.writeHead(302,{'set-cookie':'dosid=synthetic-test; HttpOnly; SameSite=Lax','location':'/indexInternal.es?action=internalStart'});res.end(req.headers.cookie+' '+req.url);});});
 const game=net.createServer(s=>s.pipe(s));web.listen(0,'127.0.0.1');game.listen(0,'127.0.0.1');await Promise.all([once(web,'listening'),once(game,'listening')]);
 let bridge;
 try{
  const config={portalUrl:`http://127.0.0.1:${web.address().port}`,gameHost:'127.0.0.1',gamePort:game.address().port};
  await assert.rejects(startBridge(config,{httpPort:0,gamePort:0}),/henüz hazır değil/);ready=true;bridge=await startBridge(config,{httpPort:0,gamePort:0});
  const response=await fetch(`http://127.0.0.1:${bridge.webPort}/login?test=1`,{method:'POST',headers:{cookie:'old=synthetic'},body:'username=fixture&password=not-real',redirect:'manual'});assert.equal(response.status,302);assert.match(response.headers.get('set-cookie'),/HttpOnly/);assert.equal(await response.text(),'old=synthetic /login?test=1');assert.equal(received,'username=fixture&password=not-real');
  const socket=net.connect(bridge.gamePort,'127.0.0.1');await once(socket,'connect');const data=once(socket,'data');socket.write(Buffer.from([0,255,3,13,10,0]));assert.deepEqual((await data)[0],Buffer.from([0,255,3,13,10,0]));socket.destroy();
 }finally{await bridge?.close();await Promise.all([web,game].map(s=>new Promise(resolve=>s.close(resolve))));}
});
