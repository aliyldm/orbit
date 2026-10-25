'use strict';
// Run after exporting DefineBinaryData character 187 from main.swf with JPEXS.
const fs=require('fs');
const path=require('path');
const source=process.argv[2]||path.join(__dirname,'../decompiled/pet-patterns/game.xml');
const xml=fs.readFileSync(source,'utf8').replace(/<!--[\s\S]*?-->/g,'');
const section=xml.match(/<drones[ >][\s\S]*?<\/drones>/)?.[0];
if(!section)throw new Error('patterns.drones section missing');
const designs={};
for(const row of section.matchAll(/<design\s+id="(\d+)"\s+assetId="([^"]+)"/g))designs[row[2]]=Number(row[1]);
const itemSource=fs.readFileSync(path.join(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit/items/ItemDataProvider.as'),'utf8');
const upgrades={};let previous=0;
for(const row of itemSource.matchAll(/_loc33_\.put\("([^"]+)",/g)){
 const drone=/^(drone_(?:flax|iris|apis|zeus))([0-5])$/.exec(row[1]);
 if(drone){const values={};for(const match of itemSource.slice(previous,row.index).matchAll(/\.upgradeType = "(DRONE_[^"]+)";[\s\S]*?\.bonusPerLevel = ([\d.]+);/g))values[match[1]]=Number(match[2]);(upgrades[drone[1]] ||= {})[drone[2]]=values;}
 previous=row.index;
}
const output=path.join(__dirname,'../game/data/drone-patterns.json');
fs.mkdirSync(path.dirname(output),{recursive:true});
fs.writeFileSync(output,JSON.stringify({_source:'main.swf DefineBinaryData 187 / patterns.drones.designs + ItemDataProvider drone tier UpgradableTrait values',designs,upgrades},null,2));
console.log(`${Object.keys(designs).length} drone mappings: ${output}`);
