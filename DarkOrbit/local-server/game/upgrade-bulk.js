'use strict';
const crypto=require('node:crypto'),{open,tx}=require('./db'),assembly=require('./assembly'),policy=require('./module-policy'),META=require('../docs/client-map.items.json').items;
const quotes=new Map(),TTL=120000,MAX=2000;
const classes={weapons:new Set(['LaserType','HellstormLauncherType','CannonType','DriveType']),shields:new Set(['ShieldType','CannonShieldType','LensType'])};
function categories(input){const values=Array.isArray(input)?input:String(input||'').split(',');if(!values.length||values.length>2||values.some(c=>!classes[c])||new Set(values).size!==values.length)throw Error('Silah veya kalkan grubunu seç.');return values.slice().sort();}
function selection(playerId,groups,now){
 const db=open(),busy=new Set(db.prepare('SELECT target_id FROM assembly_jobs WHERE player_id=? AND target_id<>0').all(playerId).map(r=>r.target_id));
 const recipes=new Map();for(const[id,r]of Object.entries(assembly.RECIPES))if(r.result?.[0]?.lootID==='upgrade_item-upgrade'&&!assembly.unsupportedReason(id)&&assembly.visible(db,playerId,id))for(const target of r.targets||[])recipes.set(target,{id,r});
 const result=[];let excludedBusy=0;
 for(const i of db.prepare('SELECT id,loot_id,upgrade_level FROM items WHERE player_id=? AND amount=1 ORDER BY id').all(playerId)){
  const type=META[i.loot_id]?.typeClass?.split('.').at(-1);if(!groups.some(g=>classes[g].has(type)))continue;
  const recipe=recipes.get(i.loot_id);if(!recipe)continue;const max=Math.max(...recipe.r.costs.map(c=>c.level));if(i.upgrade_level>=max)continue;
  if(busy.has(i.id)){excludedBusy++;continue;}
  const steps=recipe.r.costs.filter(c=>c.level>i.upgrade_level&&c.level<=max),parts=steps.flatMap(c=>c.parts);
  if(parts.some(p=>p.lootID!==policy.UPGRADE))throw Error('Toplu geliştirme modül politikası eşleşmiyor.');
  result.push({targetId:i.id,lootId:i.loot_id,from:i.upgrade_level,to:max,recipe:recipe.id,modules:parts.reduce((n,p)=>n+p.ammount,0),durationMs:steps.reduce((n,c)=>n+c.buildTimeSec,0)*1000});
 }
 if(result.length>MAX)throw Error(`Bir işlemde en fazla ${MAX} eşya geliştirilebilir.`);
 return{items:result,excludedBusy};
}
function quote(playerId,input,now=Date.now()){
 for(const[token,q]of quotes)if(q.expiresAt<now)quotes.delete(token);
 // Only the latest quote for this player is actionable; tabs can refresh freely.
 for(const[token,q]of quotes)if(q.playerId===playerId)quotes.delete(token);
 const groups=categories(input),{items,excludedBusy}=selection(playerId,groups,now),totalModules=items.reduce((n,i)=>n+i.modules,0),availableModules=assembly.count(open(),playerId,policy.UPGRADE),token=crypto.randomBytes(24).toString('hex');
 if(!Number.isSafeInteger(totalModules))throw Error('Toplam modül miktarı sınırı aşıldı.');
 const q={playerId,groups,items,totalModules,expiresAt:now+TTL};quotes.set(token,q);
 return{ok:true,token,totalModules,availableModules,itemCount:items.length,excludedBusy,canBuild:items.length>0&&availableModules>=totalModules,expiresAt:q.expiresAt,message:items.length?'':excludedBusy?'Uygun eşyaların geliştirmesi zaten devam ediyor.':'Geliştirilebilen eşya yok veya hepsi azami seviyede.'};
}
function build(playerId,token,now=Date.now()){
 if(typeof token!=='string'||!/^\w{48}$/.test(token))throw Error('Geçersiz toplu geliştirme teklifi.');
 const db=open(),key='upgrade_bulk_'+token,previous=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(playerId,key);
 if(previous)return{...JSON.parse(previous.value),replayed:true};
 const q=quotes.get(token);if(!q||q.playerId!==playerId||q.expiresAt<now)throw Error('Teklifin süresi doldu; listeyi yenile.');
 let receipt;
 tx(conn=>{
  const current=selection(playerId,q.groups,now);
  if(JSON.stringify(current.items)!==JSON.stringify(q.items))throw Error('Eşyalar veya geliştirme durumu değişti; listeyi yenile.');
  if(!q.items.length)throw Error('Geliştirilebilen eşya yok.');
  if(assembly.count(conn,playerId,policy.UPGRADE)<q.totalModules)throw Error('Yeterli Upgrade Module yok.');
  for(const item of q.items)assembly.build(playerId,item.recipe,item.to,item.targetId,now);
  receipt={ok:true,itemCount:q.items.length,totalModules:q.totalModules,replayed:false,message:`${q.items.length} eşya için azami seviyeye geliştirme başladı. Süre bitince teslim al.`,targets:q.items.map(i=>({recipeLootId:i.recipe,targetItemId:i.targetId}))};
  conn.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?)').run(playerId,key,JSON.stringify(receipt));
 });
 quotes.delete(token);return receipt;
}
module.exports={quote,build,selection,categories,TTL};
