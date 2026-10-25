'use strict';
// Read-only catalogue audit. Never opens the player database.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const catalog=require('../game/npc-catalog'),kronos=require('../game/kronos'),content=require('../game/galaxy-gate-content'),cargo=require('../game/npc-cargo');
function record(def){const ores=cargo.resolve(def);return{key:def.key,name:def.name,status:ores===null?'unverified':ores.length?'sourced-ore':'explicit-no-ore',ores};}
const rows=[...Object.values(catalog.definitions),...Object.keys(kronos.STATS).map(k=>kronos.definition(k))].map(record);
const variants=new Map();
for(const id of Object.keys(content.lists))for(const phase of content.build(Number(id)).phases)for(const slot of phase.slots){
 const scale=slot.def.hitpoints/catalog.definitions[slot.def.key].hitpoints;if(scale===1)continue;
 const key=slot.def.key+'@'+scale;
 if(!variants.has(key))variants.set(key,{...record(slot.def),scale,gateIds:[]});
 const row=variants.get(key);if(!row.gateIds.includes(Number(id)))row.gateIds.push(Number(id));
}
const sources=['npc-de','npc-de-page2','npc-es','npc-standard-en','epsilon-en','zeta-en'].map(name=>{
 const base=path.join(__dirname,'../decompiled/gate-source-evidence',name),meta=JSON.parse(fs.readFileSync(base+'.source.json','utf8'));
 return{name,...meta,textSha256:crypto.createHash('sha256').update(fs.readFileSync(base+'.txt')).digest('hex')};
});
const report={date:'2026-10-24',total:rows.length,sourced:rows.filter(r=>r.status!=='unverified').length,explicitNoOre:rows.filter(r=>r.status==='explicit-no-ore').length,unverified:rows.filter(r=>r.status==='unverified').map(r=>r.key),scaledGateVariants:[...variants.values()],sources,rows,
 limits:['Ore base contents only; bonuses apply when collecting.','Scaled gate combat/reward multipliers do not by themselves establish ore quantities.','Missing source ore lines are unknown, not proof of zero.','Old saved gate snapshots and unkeyed custom database NPCs are not canonical catalogue facts.','Conditional assembly-material drop odds and multiplayer ownership are not established by these tables.']};
if(require.main===module){fs.writeFileSync(path.join(__dirname,'../docs/npc-cargo-audit.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify({total:report.total,sourced:report.sourced,explicitNoOre:report.explicitNoOre,unverified:report.unverified,scaledVariants:report.scaledGateVariants.length}));}
module.exports=report;
