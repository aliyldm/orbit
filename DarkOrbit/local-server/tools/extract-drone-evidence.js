'use strict';
// Binary IDs follow UberAssetsLib_LIB_DRONES_XML / LIB_SHIPS_XML Embed paths.
// Read-only source inspection, no SWF execution and no client mutation.
const fs=require('node:fs'),path=require('node:path'),zlib=require('node:zlib'),crypto=require('node:crypto');
const source=path.resolve(process.argv[2]||'client/spacemap/main.swf'),output=path.resolve(process.argv[3]||'decompiled/drone-asset-evidence'),raw=fs.readFileSync(source);
const swf=raw.toString('ascii',0,3)==='CWS'?Buffer.concat([Buffer.from('FWS'),raw.subarray(3,8),zlib.inflateSync(raw.subarray(8))]):raw;
if(swf.toString('ascii',0,3)!=='FWS')throw Error('Expected FWS/CWS artifact');
let offset=8+Math.ceil((5+4*(swf[8]>>3))/8)+4;const blobs={};
while(offset<swf.length){const head=swf.readUInt16LE(offset);offset+=2;const tag=head>>6;let size=head&63;if(size===63){size=swf.readUInt32LE(offset);offset+=4;}if(offset+size>swf.length)throw Error('Truncated SWF tag');if(tag===87&&size>=6){const id=swf.readUInt16LE(offset);if(id===177||id===189)blobs[id]=swf.subarray(offset+6,offset+size);}offset+=size;}
if(!blobs[177]||!blobs[189])throw Error('Missing source library177/189');
const sha=b=>crypto.createHash('sha256').update(b).digest('hex'),xml=blobs[177].toString('utf8'),ships=blobs[189].toString('utf8'),debug=ships.match(/<asset\s+id="120"[^>]*>[\s\S]*?<\/asset>/)?.[0];
fs.mkdirSync(output,{recursive:true});fs.writeFileSync(path.join(output,'lib_drones.xml'),xml);fs.writeFileSync(path.join(output,'debug-ship-120.xml'),debug||'');
const descriptorIds=[...xml.matchAll(/<asset\s+id="([1-4]_standard_[0-9]+)"/g)].map(m=>m[1]);
const evidence={source,sourceSha256:sha(raw),droneBinaryId:177,droneXmlSha256:sha(blobs[177]),shipBinaryId:189,shipXmlSha256:sha(blobs[189]),standardDescriptorIds:descriptorIds,debugShip120:debug||null};
fs.writeFileSync(path.join(output,'evidence.json'),JSON.stringify(evidence,null,2));console.log(JSON.stringify({sourceSha256:evidence.sourceSha256,standardDescriptors:descriptorIds.length,debug:debug?.replace(/\s+/g,' ')}));
