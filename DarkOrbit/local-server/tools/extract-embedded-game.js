'use strict';
// Reproducibly extract the embedded game.xml linked by
// InitPatternManagerCommand_GAME_XML_FILE.as (DefineBinaryData character 187).
const fs=require('fs'),path=require('path'),zlib=require('zlib'),crypto=require('crypto');
const source=path.resolve(process.argv[2]||'client/spacemap/main.swf');
const output=path.resolve(process.argv[3]||'decompiled/pet-patterns/game.xml');
const raw=fs.readFileSync(source);let swf=raw;
if(raw.toString('ascii',0,3)==='CWS')swf=Buffer.concat([Buffer.from('FWS'),raw.subarray(3,8),zlib.inflateSync(raw.subarray(8))]);
if(swf.toString('ascii',0,3)!=='FWS')throw new Error('Expected FWS or CWS artifact');
let off=8+Math.ceil((5+4*(swf[8]>>3))/8)+4,found;
while(off<swf.length){
 if(off+2>swf.length)throw new Error('Truncated SWF tag header');
 const header=swf.readUInt16LE(off);off+=2;const tag=header>>6;let length=header&63;
 if(length===63){if(off+4>swf.length)throw new Error('Truncated SWF tag length');length=swf.readUInt32LE(off);off+=4;}
 if(off+length>swf.length)throw new Error('Truncated SWF tag body');
 if(tag===87&&length>=6&&swf.readUInt16LE(off)===187){found=swf.subarray(off+6,off+length);break;}
 off+=length;
}
if(!found||!found.toString('utf8',0,16).includes('<game>'))throw new Error('Expected game.xml binary187 not found');
const digest=(name,b)=>crypto.createHash(name).update(b).digest('hex');
fs.mkdirSync(path.dirname(output),{recursive:true});fs.writeFileSync(output,found);
console.log(JSON.stringify({source,sourceSha256:digest('sha256',raw),characterId:187,output,bytes:found.length,xmlSha256:digest('sha256',found),xmlMd5:digest('md5',found)},null,2));
