'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),{execFileSync}=require('node:child_process');
test('every .NET source and embedded world catalog is included in Git distribution',()=>{
 const root=path.resolve(__dirname,'..');
 const tracked=new Set(execFileSync('git',['ls-files','-z'],{cwd:root,maxBuffer:8*1024*1024}).toString('utf8').split('\0'));
 const files=[];
 const walk=dir=>{for(const entry of fs.readdirSync(path.join(root,dir),{withFileTypes:true})){
  if(['bin','obj','.local','artifacts'].includes(entry.name))continue;
  const name=dir+'/'+entry.name;
  if(entry.isDirectory())walk(name);else if(/\.(cs|csproj|slnx)$/.test(name)||name.endsWith('/world-content.json'))files.push(name);
 }};
 walk('DarkOrbit/multiplayer-server');
 assert(files.some(name=>name.endsWith('/Runtime/MapActor.cs')),'test includes the actual map actor');
 assert.deepEqual(files.filter(name=>!tracked.has(name)),[],'missing .NET source in clean downloads');
});
