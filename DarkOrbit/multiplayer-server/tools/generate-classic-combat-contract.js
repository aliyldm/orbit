'use strict';
const fs=require('node:fs'),path=require('node:path');
const root=path.resolve(__dirname,'..'),legacy=path.resolve(root,'../local-server/game');
const lasers=require(path.join(legacy,'modern-lasers')),ammo=require(path.join(legacy,'laser-ammo')),visuals=require(path.join(legacy,'laser-visuals')),balance=require(path.join(legacy,'combat-balance'));
const cases=[],npc={def:{key:'devolarium',name:'Devolarium'}};
for(const ids of [['lf-1'],['lf-2'],['lf-3'],['lf-4'],['lf-3','lf-4','lf-3','mp-1']]){
 const list=ids.map((id,i)=>({id:i+1,lootId:'equipment_weapon_laser_'+id,ship:i%2===0,damage:({'mp-1':60,'lf-1':40,'lf-2':100,'lf-3':150,'lf-4':200})[id]*(1+i*.005)}));
 for(const id of ['lcb-10','mcb-25','mcb-50','ucb-100','rsb-75'])for(const roll of [0,.5,1]){
  const profile={stats:{laserCount:list.length,laserDamage:list.reduce((n,l)=>n+l.damage,0)*1.06,laserProfiles:list,npcLaserMultiplier:1.12,skills:{laserAccuracy:.05,npcEpMultiplier:1.08,npcCreditsMultiplier:1.05,honourMultiplier:1.02},formation:{ep:.7,honour:1.5}},ammo:'ammunition_laser_'+id};
  const expected=lasers.rollDamage(structuredClone(profile),npc,10000,{random:()=>roll,multiplier:ammo.multiplier(profile,npc)*profile.stats.npcLaserMultiplier});
  cases.push({profile,ammo:profile.ammo,roll,damage:expected,chance:balance.hitChance('laser',{}, {accuracy:.05}),color:visuals.ammoType(profile.ammo)});
 }
}
fs.mkdirSync(path.join(root,'artifacts'),{recursive:true});fs.writeFileSync(path.join(root,'artifacts/classic-combat-contract.json'),JSON.stringify({cases}));
console.log(JSON.stringify({classicLegacyCases:cases.length}));
