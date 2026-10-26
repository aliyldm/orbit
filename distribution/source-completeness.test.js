'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),{execFileSync}=require('node:child_process');
test('every .NET source and embedded game catalog is included in Git distribution',()=>{
 const root=path.resolve(__dirname,'..');
 const tracked=new Set(execFileSync('git',['ls-files','-z'],{cwd:root,maxBuffer:8*1024*1024}).toString('utf8').split('\0'));
 const files=[];
 const walk=dir=>{for(const entry of fs.readdirSync(path.join(root,dir),{withFileTypes:true})){
  if(['bin','obj','.local','artifacts'].includes(entry.name))continue;
  const name=dir+'/'+entry.name;
  if(entry.isDirectory())walk(name);else if(/\.(cs|csproj|slnx)$/.test(name)||name.endsWith('/world-content.json')||name.endsWith('/equipment-content.json'))files.push(name);
 }};
 walk('DarkOrbit/multiplayer-server');
 assert(files.some(name=>name.endsWith('/Runtime/MapActor.cs')),'test includes the actual map actor');
 assert(files.some(name=>name.endsWith('/Equipment/equipment-content.json')),'test includes the actual equipment catalog');
 assert.deepEqual(files.filter(name=>!tracked.has(name)),[],'missing .NET source in clean downloads');
});
test('legacy parity inventory stays current with source registrations and schema names',()=>{
 const root=path.resolve(__dirname,'..');
 execFileSync(process.execPath,['tools/audit-legacy-parity.js','--check'],{cwd:path.join(root,'DarkOrbit/multiplayer-server'),maxBuffer:1024*1024});
});
