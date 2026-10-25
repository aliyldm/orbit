'use strict';
// Recover numeric PET visuals used by PetHeroActivationCommand.shipType.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.join(__dirname,'..'),file='decompiled/pet-patterns/game.xml';
const source=fs.readFileSync(path.join(root,file),'utf8'),xml=source.replace(/<!--[\s\S]*?-->/g,'');
const metadata=require('../docs/client-map.items.json').items;
const normalize=s=>s.toLowerCase().replace(/designs?|pet|p\.e\.t\.|lvl\s*\d+|level\s*[\d-]+/g,'').replace(/[^a-z0-9]+/g,' ').trim().split(/\s+/).filter(Boolean).sort().join('-');
const definitions=[];
function add(attributes){
 const type=/\btype="([^"]+)"/.exec(attributes)?.[1],comment=/\bcomment="([^"]+)"/.exec(attributes)?.[1];
 if(/^\d+$/.test(type||'')&&comment&&!definitions.some(d=>d.type===+type))definitions.push({type:+type,comment,key:normalize(comment)});
}
for(const block of xml.matchAll(/<ship\b([^>]*\bclass="pet"[^>]*)>([\s\S]*?)<\/ship>/g)){
 add(block[1]);for(const match of block[2].matchAll(/<(?:ship|design)\b([^>]*)/g))add(match[1]);
}
for(const match of xml.matchAll(/<(?:ship|design)\b([^>]*\bclass="pet"[^>]*)/g))add(match[1]);
const appearances={},unresolved=[];
for(const [id,row]of Object.entries(metadata).filter(([,row])=>/PetCustomizationType$/.test(row.typeClass||''))){
 const keys=[normalize(id.replace(/^pet_designs_/,'')),normalize(row.typeValue)];
 if(id==='pet_designs_pet-goliath-x-regular')keys.push(normalize('Pet Goliath X'));
 const matches=definitions.filter(d=>keys.includes(d.key));
 if(matches.length===1)appearances[id]={type:matches[0].type,comment:matches[0].comment};else unresolved.push(id);
}
if(unresolved.length)throw Error('Unresolved PET appearance: '+unresolved.join(', '));
const output={source:file,sha256:crypto.createHash('sha256').update(source).digest('hex'),appearances};
fs.writeFileSync(path.join(root,'game/data/pet-appearances.json'),JSON.stringify(output,null,2)+'\n');
console.log(`Recovered ${Object.keys(appearances).length} PET appearances.`);
