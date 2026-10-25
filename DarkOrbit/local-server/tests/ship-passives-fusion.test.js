'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs');
const dbModule=require('../game/db'),players=require('../game/db/players'),passives=require('../game/ship-passives'),fusion=require('../game/fusion-shields'),{computeStats}=require('../game/stats'),META=require('../docs/client-map.items.json').items;
let db,index=0;before(()=>{dbModule.close();db=dbModule.open(':memory:');});after(()=>dbModule.close());
function fixture(loot){const a=Number(db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run('passive-'+(++index),'test').lastInsertRowid),id=players.createPlayer(a,'passive'+index,1,require('../config.json').starter);const ship=Number(db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints,shield)VALUES(?,?,1,0)').run(id,loot).lastInsertRowid);db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(ship,id);return {id,ship};}
const base={hitMax:1000,shieldMax:1000,laserDamage:100,rocketMultiplier:2,speed:300};
test('captured classic hull passives affect laser/rocket damage and shield without changing unrelated stats',()=>{
 for(const id of ['ship_g-enforcer','ship_diminisher','ship_venom','ship_v-lightning']){const out=passives.applyStats(id,base);assert.equal(out.laserDamage,105,id);assert.equal(out.rocketMultiplier,2.1,id);assert.equal(out.shieldMax,1000);assert.equal(out.speed,300);}
 for(const id of ['ship_g-bastion','ship_solace','ship_sentinel'])assert.equal(passives.applyStats(id,base).shieldMax,1100,id);
 assert.equal(passives.applyStats('ship_spectrum',base).shieldMax,1250,'captured edition explicitly25%, not historical10%');assert.deepEqual(base,{hitMax:1000,shieldMax:1000,laserDamage:100,rocketMultiplier:2,speed:300});
 assert.equal(passives.applyStats('ship_goliath_design_amber',base).laserDamage,100,'cosmetic is never another hull bonus');
});
test('real player load applies hull passive to equipment and reload/switch cannot accumulate bonuses',()=>{
 const {id,ship}=fixture('ship_g-bastion');db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index)VALUES(?,'equipment_generator_shield_sg3n-b02',1,?,'generator',0)").run(id,ship);
 const max=META['equipment_generator_shield_sg3n-b02'].output;assert.equal(players.loadPlayer(id).shieldMax,Math.round(max*1.1));assert.equal(players.loadPlayer(id).shieldMax,Math.round(max*1.1));
 db.prepare("UPDATE ships SET loot_id='ship_goliath' WHERE id=?").run(ship);assert.equal(players.loadPlayer(id).shieldMax,max);
});
test('XP/honour reward helper follows currently active owned hull and preserves other grants and penalties',()=>{
 const {id,ship}=fixture('ship_g-veteran'),reward={ep:100,honour:20,credits:300,uridium:4,items:{x:1}};
 assert.deepEqual(passives.applyReward(id,reward,{db}),{...reward,ep:110});db.prepare("UPDATE ships SET loot_id='ship_g-exalted' WHERE id=?").run(ship);assert.deepEqual(passives.applyReward({userId:id},reward,{db}),{...reward,honour:22});
 assert.equal(passives.applyReward(id,{honour:-20},{db}).honour,-20);assert.equal(reward.ep,100);
});
test('simple variant passives are tied to explicit source hull IDs',()=>{
 assert.equal(passives.applyStats('ship_g-centaur',base).hitMax,1100);assert.equal(passives.applyStats('ship_g-saturn',base).hitMax,1200);assert.equal(passives.applyStats('ship_a-elite',base).laserDamage,105);
 const html=fs.readFileSync(require('node:path').join(__dirname,'../web/portal/pages/internalDock~internalDockShips.html'),'utf8'),rows=JSON.parse(/itemData\s*:\s*(\{[^\r\n]*\}),\s*\r?\n\s*numItems/.exec(html)[1]);
 for(const id of Object.keys(passives.DEFINITIONS))if(rows[id])assert.match(rows[id].description,/%\s*(5|6|10|20|25)/,id);
});
test('Fusion shields add6.25% each in the active equipment pool, without boosting max shield',()=>{
 const ship={hitpoints:1000,speed:300,cargo:100},shield=id=>({loot_id:id,amount:1,category:'shield_generator',shield:META[id].output,shield_absorb:META[id].spread/100}),a=shield('equipment_generator_shield_fs-01'),b={...shield('equipment_generator_shield_fs-02'),drone_id:1},normal=shield('equipment_generator_shield_sg3n-b02');
 assert.equal(fusion.multiplier([]),1);assert.equal(fusion.multiplier([a,b]),1.125);assert.equal(fusion.multiplier([{...a,amount:0}]),1);
 const stats=computeStats(ship,[a,b,normal]);assert.equal(stats.shieldRegenMultiplier,1.125);assert.equal(stats.shieldMax,a.shield+b.shield+normal.shield);
});
test('Fusion composes with a real regeneration booster instead of being overwritten',()=>{
 const {id}=fixture('ship_goliath');require('../game/boosters').addOwned(db,id,'booster_sreg-b01',1,{now:1000});const stats=require('../game/boosters').applyStats(id,{...base,shieldRegenMultiplier:1.125},{db,now:1001});
 const factor=1+META['booster_sreg-b01'].boostList.find(x=>x.type==='SHIELD_REGENERATION').factor/100;assert.equal(stats.shieldRegenMultiplier,1.125*factor);
});
