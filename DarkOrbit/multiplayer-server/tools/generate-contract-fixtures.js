'use strict';
// Cross-language oracle: expected bytes/objects come from the existing JS codec.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const codec=require('../../local-server/game/codec/codec');
const root=path.resolve(__dirname,'..');
let seed=0x64d03991;
const random=()=>{seed^=seed<<13;seed^=seed>>>17;seed^=seed<<5;return seed>>>0;};
function prim(type,variant){switch(type){case'int':return variant===0?0:variant===1?-2147483648:random()|0;case'short':return variant===0?0:variant===1?-32768:(random()<<16)>>16;case'byte':return variant===0?0:variant===1?-128:(random()<<24)>>24;case'bool':return variant!==0;case'utf':return variant===0?'':variant===1?'Türkçe 🚀\0':'native-'+random();case'double':return variant===0?0:variant===1?49945312383.5:-12345678.125;case'float':return variant===0?0:variant===1?-123.125:Math.fround(random()/999);default:throw Error(type);}}
function fields(cls,obj,variant){for(const f of cls.fields){if(f.type==='super'){fields(codec.schema[f.cls],obj,variant);continue;}if(f.type==='skipShort')continue;if(f.type==='module')obj[f.name]=variant===2?{_:'PetGearTypeModule',typeValue:4}:null;else if(f.type==='vector')obj[f.name]=variant===0?[]:Array.from({length:variant+1},()=>f.elem.type==='module'?{_:'PetGearTypeModule',typeValue:4}:prim(f.elem.type,variant));else obj[f.name]=prim(f.type,variant);}}
const cases=[];
for(const cls of Object.values(codec.schema)){if(cls.id===null||cls.id===0)continue;for(let variant=0;variant<3;variant++){const obj={_:cls.name};fields(cls,obj,variant);const bytes=codec.encode(obj),decoded=codec.decode(bytes);if(decoded.rest)throw Error(cls.name);cases.push({name:cls.name+'#'+variant,hex:bytes.toString('hex'),expected:decoded.obj});}}
const schema=fs.readFileSync(path.join(root,'../local-server/game/codec/schema.json'));
fs.mkdirSync(path.join(root,'artifacts'),{recursive:true});
fs.writeFileSync(path.join(root,'artifacts/protocol-contract.json'),JSON.stringify({schemaSha256:crypto.createHash('sha256').update(schema).digest('hex'),classCount:Object.keys(codec.schema).length,cases}));
console.log(`PASS generated ${cases.length} native codec oracle cases from ${Object.keys(codec.schema).length} classes`);
