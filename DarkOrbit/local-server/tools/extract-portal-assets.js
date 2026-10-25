'use strict';
// Symbol binding: UberAssetsLib_LIB_PORTALS_XML.as embeds SWF binary character176.
const fs=require('fs'),path=require('path'),zlib=require('zlib'),crypto=require('crypto');
const source=path.resolve(process.argv[2]||'client/spacemap/main.swf'),output=path.resolve(process.argv[3]||'decompiled/portal-patterns/portals.xml');
const raw=fs.readFileSync(source),b=raw.toString('ascii',0,3)==='CWS'?Buffer.concat([Buffer.from('FWS'),raw.subarray(3,8),zlib.inflateSync(raw.subarray(8))]):raw;
if(b.toString('ascii',0,3)!=='FWS')throw Error('Expected FWS/CWS artifact');
let off=8+Math.ceil((5+4*(b[8]>>3))/8)+4,found;
while(off<b.length){if(off+2>b.length)throw Error('Truncated SWF tag');const h=b.readUInt16LE(off);off+=2;let n=h&63;if(n===63){if(off+4>b.length)throw Error('Truncated long SWF tag');n=b.readUInt32LE(off);off+=4;}if(off+n>b.length)throw Error('Truncated SWF tag body');if((h>>6)===87&&n>=6&&b.readUInt16LE(off)===176){found=b.subarray(off+6,off+n);break;}off+=n;}
if(!found||!found.toString('utf8',0,20).includes('<assets>'))throw Error('Expected embedded portal XML character176');
fs.mkdirSync(path.dirname(output),{recursive:true});fs.writeFileSync(output,found);
const sha=x=>crypto.createHash('sha256').update(x).digest('hex');console.log(JSON.stringify({source,sourceSha256:sha(raw),characterId:176,output,xmlSha256:sha(found),bytes:found.length},null,2));
