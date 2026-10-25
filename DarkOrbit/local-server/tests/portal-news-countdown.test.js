'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm');
const dbModule=require('../game/db'),players=require('../game/db/players'),portal=require('../web/portal/render');
let id;before(()=>{dbModule.close();dbModule.open(':memory:');const a=players.createAccount('news-timer-qa','testpass');id=players.createPlayer(a,'News QA',1,require('../config.json').starter);});after(()=>dbModule.close());
function run(html){const timers=[],nodes={},state={reloads:0};const context=vm.createContext({reloadInitiated:false,window:{setInterval:fn=>{timers.push(fn);return timers.length;}},location:{reload:()=>state.reloads++},document:{getElementById:id=>nodes[id]??={innerHTML:''}},Date:{now:()=>new Date('2026-10-21T09:00:00Z').getTime()}});
 for(const match of html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script>/gi))if(/function printTime\(secondsLeft\)/.test(match[1])||/^\s*var newsTimer[\da-f]+Timer/.test(match[1]))vm.runInContext(match[1],context);
 for(let i=0;i<5;i++)for(const fn of timers)fn();return{state,timers,nodes,context};}
test('historical home news reproduces the reload loop while rendered news stays on the same page',()=>{
 const raw=fs.readFileSync(require('node:path').join(__dirname,'../web/portal/pages/internalStart.html'),'utf8'),original=run(raw);assert.ok(original.timers.length>0);assert.equal(original.state.reloads,1,'every fresh original page would reload again on its first expired timer');
 const current=run(portal.renderPage('internalStart',undefined,players.loadPlayer(id)));assert.equal(current.timers.length,original.timers.length);assert.equal(current.state.reloads,0);assert.ok(Object.values(current.nodes).some(n=>n.innerHTML==='00:00:00'));assert.equal(current.context.printTime(3661),'Kalan Süre: 01:01:01');
});
