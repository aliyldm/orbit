'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),{Readable}=require('node:stream'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),auth=require('../game/auth'),World=require('../game/world');
let db,handler,sid,id,logDir;const original=World.current;
before(async()=>{database.close();db=database.open(':memory:');World.current=()=>null;const account=Number(db.prepare("INSERT INTO accounts(username,password_hash,created_at)VALUES('hangar-http','test',0)").run().lastInsertRowid);id=players.createPlayer(account,'hangar-http',1,{...require('../config.json').starter,uridium:1000000});sid=auth.create(account,id);
 const config=structuredClone(require('../config.json'));config.http.host='127.0.0.1';config.http.port=0;config.https=null;config.cdnCache={enabled:false,upstream:''};config.hostCache={enabled:false,upstream:''};logDir=path.join(__dirname,'../logs','hangar-http-'+Date.now());fs.mkdirSync(logDir,{recursive:true});handler=require('../web/http-server').createHandler(config,logDir);
});
after(async()=>{auth.destroy(sid);World.current=original;database.close();});
async function invoke(url,{method='GET',headers={},body=''}={}){const req=Readable.from([Buffer.from(String(body))]);Object.assign(req,{url,method,headers});const values={};let status=200,text='';const res={setHeader(k,v){values[k.toLowerCase()]=v;},writeHead(n,h={}){status=n;for(const[k,v]of Object.entries(h))values[k.toLowerCase()]=v;},end(v){text=String(v||'');}};await handler(req,res);return {status,headers:{get:k=>values[k.toLowerCase()]},json:async()=>JSON.parse(text),text:async()=>text};}
async function post(data,{authenticated=true,xhr=true}={}){return invoke('/ajax/hangar.php',{method:'POST',headers:{'content-type':'application/x-www-form-urlencoded',...(authenticated?{cookie:'dosid='+sid}:{}),...(xhr?{'x-requested-with':'XMLHttpRequest'}:{})},body:new URLSearchParams(data)});}
test('hangar endpoint requires authentication and prevents non-XHR mutation; GET never purchases',async()=>{
 assert.equal((await post({action:'purchase'} ,{authenticated:false})).status,401);assert.equal((await post({action:'purchase'},{xhr:false})).status,403);
 const get=await invoke('/ajax/hangar.php?action=purchase&slot=2',{headers:{cookie:'dosid='+sid}});assert.equal(get.status,200);const body=await get.json();assert.equal(body.state.slots.length,1);assert.equal(body.state.userBalance.uridium,1000000);assert.equal(get.headers.get('cache-control'),'no-store');
});
test('authenticated native header purchase endpoint charges250k once and replays safely',async()=>{
 const request={action:'purchase',slot:'2',requestId:'http_purchase_token_000001'};let result=await(await post(request)).json();assert.equal(result.result,'success');assert.equal(result.state.userBalance.uridium,750000);assert.equal(result.state.slots[1].shipId,null);result=await(await post(request)).json();assert.equal(result.replayed,true);assert.equal(result.state.userBalance.uridium,750000);
 const response=await invoke('/indexInternal.es?action=internalDock',{headers:{cookie:'dosid='+sid}}),html=await response.text();assert.equal(response.status,200);assert.match(html,/data-hangar-slot="2"/);assert.match(html,/local-hangars\.js/);
});
