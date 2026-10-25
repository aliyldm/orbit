'use strict';
// Isolated QA only: authenticated HTTP/FlashAPI and real native packet checks.
const assert=require('node:assert/strict');
exports.verify=async({world,a,frame,db,base,cookie,post})=>{
 const p=world.player,inventory=require('../game/inventory'),mods=require('../game/ship-modules');p.uridium=10000000;world.save();
 const ship=db.prepare('SELECT loot_id FROM ships WHERE id=?').get(p.shipId).loot_id;assert.equal(ship,'ship_goliath');
 const baseDamage=p.stats.laserDamage,baseShield=p.shieldMax;
 for(const id of ['equipment_shipupgrade_dmg-sg01','equipment_shipupgrade_shd-gol01']){const before=p.uridium,r=await post('/ajax/shop.php',{action:'purchase',itemId:id,amount:'1'});assert.equal(r.result,'success');assert.equal(p.uridium,before-1000000);const item=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT 1').get(p.userId,id);const params={params:{hi:p.shipId},from:{target:'inventory',items:[item.id],configId:p.activeConfig},to:{target:'ship',slotset:'ship_upgrades',configId:p.activeConfig}};const response=await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'move',params:Buffer.from(JSON.stringify(params)).toString('base64')})});assert.equal(JSON.parse(Buffer.from(await response.text(),'base64')).isError,0);}
 assert.equal(p.stats.laserDamage,Math.round(baseDamage*1.05));assert.equal(p.shieldMax,Math.round(baseShield*1.05));await a.until(cs=>cs.some(c=>c._==='ShipUpgradeModuleUpdateCommand'&&c.uid===p.userId&&c.moduleTypeIds.includes(2)&&c.moduleTypeIds.includes(3)));
 const hangar=await fetch(base+'/flashAPI/inventory.php',{method:'POST',headers:{cookie},body:new URLSearchParams({action:'getHangarList'})}),data=JSON.parse(Buffer.from(await hangar.text(),'base64')).data.ret;
 const moduleItem=db.prepare("SELECT id FROM items WHERE player_id=? AND loot_id='equipment_shipupgrade_dmg-sg01'").get(p.userId);assert.ok(data.items.find(i=>i.I===moduleItem.id).SUS.includes(ship));assert.match(data.items.find(i=>i.I===moduleItem.id).SUM,/DAMAGE,5/);
 const moduleInfo=data.itemInfo.find(i=>i.L===data.items.find(i=>i.I===moduleItem.id).L);assert.ok(moduleInfo.EB.includes('SHIP'));assert.ok(!moduleInfo.EB.includes('ship'));assert.equal(moduleInfo.T,12);assert.ok(data.filters.ship_upgrades.includes(12));
 const extras=await(await fetch(base+'/indexInternal.es?action=internalDock&tpl=internalDockSpecials',{headers:{cookie}})).text(),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\})/.exec(extras)[1]);for(const id of Object.keys(mods.DEFINITIONS))assert.ok(rows[id]);
 const ids=inventory.equipped(db,p.shipId,p.activeConfig).filter(i=>i.slot==='ship_upgrade').map(i=>i.id);inventory.move(p.userId,{hangarId:p.shipId,from:{target:'ship',items:ids,slotset:'ship_upgrades',configId:p.activeConfig},to:{target:'inventory',configId:p.activeConfig}});assert.equal(p.stats.laserDamage,baseDamage);assert.equal(p.shieldMax,baseShield);
};
