'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto');
async function main(){
 const root=path.join(__dirname,'..'),base=require('../config').cdnCache.upstream,folder=path.join(root,'client/do_img/global/ranks');fs.mkdirSync(folder,{recursive:true});
 const proof=[];for(let start=1;start<=20;start+=4){const results=await Promise.allSettled(Array.from({length:Math.min(4,21-start)},(_,i)=>start+i).map(async id=>{
  const file=path.join(folder,'rank_'+id+'.png');let data;if(fs.existsSync(file))data=fs.readFileSync(file);else{const url=base+'/do_img/global/ranks/rank_'+id+'.png',response=await fetch(url,{signal:AbortSignal.timeout(15000)});if(!response.ok)throw Error('Rank '+id+' HTTP '+response.status);data=Buffer.from(await response.arrayBuffer());if(data.length>1000000||data.toString('hex',0,8)!=='89504e470d0a1a0a')throw Error('Invalid rank PNG '+id);fs.writeFileSync(file,data);}return{id,sha256:crypto.createHash('sha256').update(data).digest('hex')};}));for(const r of results)if(r.status==='fulfilled')proof.push(r.value);else throw r.reason;}
 fs.writeFileSync(path.join(root,'docs/evidence/rank-icons.json'),JSON.stringify({upstream:base,icons:proof},null,2));console.log('PASS '+proof.length+' original local rank PNG assets');
}
main().catch(e=>{console.error(e.message);process.exitCode=1;});
