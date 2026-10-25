'use strict';
// Public checksums only: no account rows, credentials, session tokens or wallet.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.resolve(__dirname,'..'),legacy=path.resolve(root,'../local-server');
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const files=['server.js','config.json','package.json','game/codec/schema.json'];
function walk(dir){for(const e of fs.readdirSync(path.join(legacy,dir),{withFileTypes:true})){const name=path.posix.join(dir,e.name);if(e.isDirectory())walk(name);else if(/\.(?:js|json|sql)$/.test(name))files.push(name);}}
for(const dir of ['game','web'])walk(dir);
for(const name of ['client/spacemap/main.swf','client/swf_global/inventory/inventory.swf'])files.push(name);
const manifest={capturedAt:new Date().toISOString(),scope:'Legacy source/assets/config preservation baseline. Existing game remains authoritative during the port.',files:Object.fromEntries([...new Set(files)].sort().map(name=>[name,hash(path.join(legacy,name))]))};
fs.mkdirSync(path.join(root,'artifacts'),{recursive:true});
const target=path.join(root,'artifacts/legacy-compatibility-baseline.json');
if(fs.existsSync(target)){
 const original=JSON.parse(fs.readFileSync(target,'utf8'));if(JSON.stringify(original.files)!==JSON.stringify(manifest.files))throw Error('Legacy compatibility baseline changed: inspect differences before accepting');
 console.log(`PASS legacy preservation: ${Object.keys(manifest.files).length} source/config/asset files unchanged`);
}else{fs.writeFileSync(target,JSON.stringify(manifest,null,2)+'\n');console.log(`Captured ${Object.keys(manifest.files).length} legacy source/config/asset checksums`);}
