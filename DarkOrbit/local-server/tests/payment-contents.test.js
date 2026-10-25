'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict');
const dbModule=require('../game/db'),players=require('../game/db/players'),World=require('../game/world');
const economy=require('../game/economy'),payment=require('../game/payment'),{recipes,id}=require('../game/payment-bundles');
let db,index=0;const originalWorld=World.current;
before(()=>{dbModule.close();db=dbModule.open(':memory:');World.current=()=>null;});
after(()=>{World.current=originalWorld;dbModule.close();});
function fixture(){const name=`payment-contents-${++index}`,a=db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run(name,'test');
 const playerId=players.createPlayer(Number(a.lastInsertRowid),name,1,require('../config.json').starter);db.prepare('UPDATE players SET uridium=5000000 WHERE id=?').run(playerId);return playerId;}
function count(playerId,loot){return db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=?').get(playerId,loot).n;}
function buy(playerId,sku){const record=payment.entry(sku);assert.equal(payment.reason(record,db),null,`${sku} should have a complete catalog`);const response=economy.purchase(playerId,sku,1,record.category);assert.equal(response.result,'success',response.message);return record;}

test('portal CC aliases and exact special-ammo identities preserve source loot IDs',()=>{
 assert.equal(id('CC-A'),'ammunition_laser_spacecup_group-a');assert.equal(id('CC-D'),'ammunition_laser_spacecup_group-d');
 assert.equal(id('SR-5'),'ammunition_specialammo_sr-5');assert.equal(id('K-300M'),'ammunition_specialammo_k-300m');
 assert.equal(id('K-3000M'),id('K-300M'),'Zephyr capture image disambiguates the typo');
 assert.throws(()=>id('unpublished-bundle-component'),/ambiguous or absent/);
});


test('historically paid2019 starter manifests still deliver their full unstable laser manifest',()=>{for(let i=1;i<=5;i++){const pid=fixture(),sku='package_event-deal-stellar2019-'+i;payment.fulfil(db,pid,payment.entry(sku));assert.equal(count(pid,'equipment_weapon_laser_lf-4-unstable'),recipes[sku].items['equipment_weapon_laser_lf-4-unstable']);}});
test('once-only starter receipt still rejects a second purchase even after equipment is removed',()=>{const pid=fixture(),sku='package_event-deal-stellar2019-1';db.prepare('INSERT INTO payment_purchase_receipts(player_id,sku,purchased_at)VALUES(?,?,0)').run(pid,sku);payment.fulfil(db,pid,payment.entry(sku));db.prepare('DELETE FROM items WHERE player_id=?').run(pid);const before=db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium;assert.equal(economy.purchase(pid,sku,1).result,'error');assert.equal(db.prepare('SELECT uridium FROM players WHERE id=?').get(pid).uridium,before);});
test('historically paid2022 manifests still deliver lasers and exact source ammunition',()=>{for(let i=1;i<=4;i++){const pid=fixture(),sku='package_event-deal-stellar2022-'+i;payment.fulfil(db,pid,payment.entry(sku));assert.equal(count(pid,'ammunition_laser_spacecup_group-d'),25000);}});
test('Dusklight Perseus pack follows its listed designs rather than its misleading Cyborg image',()=>{
 const playerId=fixture();buy(playerId,'package_event-deal-dusklight-fullpack');
 const designs=db.prepare('SELECT loot_id FROM ship_designs WHERE player_id=? ORDER BY loot_id').all(playerId).map(x=>x.loot_id);
 assert.deepEqual(designs,['ship_hecate_design_hecate-dusklight','ship_spectrum_design_spectrum-dusklight']);
 assert.equal(count(playerId,'resource_booty-key-perseus'),5);assert.equal(count(playerId,'ammunition_laser_ucb-100'),5000);
 assert.equal(db.prepare('SELECT energy FROM galaxy_gate_accounts WHERE player_id=?').get(playerId).energy,100);
 assert.equal(db.prepare("SELECT pet_level FROM items WHERE player_id=? AND loot_id='equipment_aiprotocol_ai-sm1'").get(playerId).pet_level,4);
});

test('new explicit cosmetic and Halloween manifests deliver complete stated quantities',()=>{
 const playerId=fixture();buy(playerId,'package_masqueChimera');assert.equal(count(playerId,'drone_designs_phantom-red'),10);assert.equal(count(playerId,'pet_designs_chimera-red'),1);
 buy(playerId,'package_event-deal-halloween-ammo-pack');assert.equal(count(playerId,'ammunition_specialammo_k-300m'),1500);assert.equal(count(playerId,'ammunition_laser_spacecup_group-a'),4000);
 assert.equal(count(playerId,'ammunition_laser_rsb-75'),4000);assert.equal(count(playerId,'ammunition_laser_sbl-100'),3500);
});

test('fiery Tartarus set is the original red ship with ten cosmetic drones and one PET appearance',()=>{
 const playerId=fixture();buy(playerId,'package_expo-tartarus');assert.ok(db.prepare("SELECT id FROM ships WHERE player_id=? AND loot_id='ship_tartarus'").get(playerId));
 assert.equal(count(playerId,'drone_designs_phantom-red'),10);assert.equal(count(playerId,'pet_designs_chimera-red'),1);
 assert.equal(db.prepare('SELECT COUNT(*) n FROM drones WHERE player_id=?').get(playerId).n,0,'cosmetics must not create free drones');
});

test('Powerup2025 timer manifest preserves twenty-, ten- and five-hour grants precisely',()=>{
 const playerId=fixture(),before=Date.now();buy(playerId,'package_event-deal-powerup-booster-25');const after=Date.now();
 for(const [loot,hours]of Object.entries({'booster_npc-b01':20,'booster_npc-b02':10,'booster_dmg-b01':10,'booster_dmg-b02':10,'booster_dmg-h01':10,'booster_shd-b02':5})){
  const row=db.prepare('SELECT expires_at FROM player_boosters WHERE player_id=? AND loot_id=?').get(playerId,loot);assert.ok(row.expires_at>=before+hours*3600000);assert.ok(row.expires_at<=after+hours*3600000);
 }
});
