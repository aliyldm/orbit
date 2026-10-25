'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto');const root=path.join(__dirname,'..'),proof=require('../decompiled/multi-launcher-patch/evidence.json');
const main=path.join(root,'client/spacemap/main.swf'),next=path.join(root,'decompiled/multi-launcher-patch/main-patched.swf'),sha=b=>crypto.createHash('sha256').update(b).digest('hex');
if(sha(fs.readFileSync(next))!==proof.afterSha256)throw Error('Compiled output hash mismatch');
if(![proof.beforeSha256,proof.afterSha256].includes(sha(fs.readFileSync(main))))throw Error('Installed input hash mismatch');
fs.copyFileSync(next,main);
const configPath=path.join(root,'config.json'),config=JSON.parse(fs.readFileSync(configPath,'utf8'));config.client.flashvars.gameclientHash='local-20261023-launcher-native-rewards';fs.writeFileSync(configPath,JSON.stringify(config,null,2)+'\n');
console.log('Installed verified MAIN '+proof.afterSha256);
