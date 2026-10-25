'use strict';
const fs=require('node:fs'),crypto=require('node:crypto'),assert=require('node:assert/strict');
const source='decompiled/main/scripts/net/bigpoint/darkorbit/items/ItemDataProvider.as',text=fs.readFileSync(source,'utf8'),ships={};
for(const id of require('../game/ship-shop').IDS){
 const end=text.indexOf('items["'+id+'"]');assert.ok(end>=0,id);
 const header=[...text.slice(0,end).matchAll(/_loc\d+_ = new ShipAttributes\(\);/g)].at(-1);assert.ok(header,id);
 const body=text.slice(header.index,end),parts=body.split(/_loc30_ = new Ability\(\);/).slice(1),abilities=[];
 for(const part of parts){
  const type=part.match(/_loc30_\.type = "([^"]+)";/)?.[1];if(!type)continue;
  abilities.push({type,duration:Number(part.match(/_loc30_\.duration = "([^"]+)";/)?.[1]||0)*1000,cooldown:Number(part.match(/_loc30_\.cooldown = "([^"]+)";/)?.[1]||0)*1000,params:[...part.matchAll(/_loc30_\.params\.push\("([^"]+)"\);/g)].map(m=>Number.isFinite(Number(m[1]))?Number(m[1]):m[1])});
 }
 ships[id]=abilities;
}
const report={source,sha256:crypto.createHash('sha256').update(text).digest('hex'),ships};
fs.writeFileSync('game/data/ship-abilities.json',JSON.stringify(report,null,2)+'\n');console.log(`${Object.keys(ships).length} ship ability records extracted`);
