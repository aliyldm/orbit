'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),http=require('node:http');
const {startBridge}=require('./client-bridge');
test('Localer bridge maps only its own loopback Origin and Referer to the real portal',async()=>{
 const received=[];const portal=http.createServer((req,res)=>{if(req.url==='/ready'){res.setHeader('Content-Type','application/json');res.end('{"ready":true}');}else{received.push(req.headers);res.end('ok');}});
 await new Promise(resolve=>portal.listen(0,'127.0.0.1',resolve));let bridge;
 try{
  const target='http://127.0.0.1:'+portal.address().port;
  bridge=await startBridge({portalUrl:target,gameHost:'127.0.0.1',gamePort:1,requireMultiplayerReady:true},{httpPort:0,gamePort:0});
  const local='http://127.0.0.1:'+bridge.webPort;
  await fetch(local+'/flashAPI/inventory.php',{method:'POST',headers:{Origin:local,Referer:local+'/indexInternal.es?action=internalDock'}});
  assert.equal(received[0].origin,target);assert.equal(received[0].referer,target+'/indexInternal.es?action=internalDock');
  await fetch(local+'/flashAPI/inventory.php',{method:'POST',headers:{Origin:'http://unrelated.example',Referer:'http://unrelated.example/page'}});
  assert.equal(received[1].origin,'http://unrelated.example');assert.equal(received[1].referer,'http://unrelated.example/page');
 }finally{await bridge?.close();await new Promise(resolve=>portal.close(resolve));}
});