'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),Combat=require('../game/combat'),maps=require('../game/maps'),laser=require('../game/modern-lasers'),payment=require('../game/payment'),economy=require('../game/economy'),inv=require('../game/inventory'),codec=require('../game/codec/codec');
let db,w,p,s,c,sent;const originalCurrent=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;const id=players.createPlayer(players.createAccount('special-lasers','testpass'),'Laser QA',1,{...require('../config').starter,ship:'ship_goliath',uridium:20000000});
 w=new World(structuredClone(require('../config')));s={send(){}};p=w.login(s,id);Object.assign(p,{x:6000,y:6000});sent=[];c=new Combat(w,(s,cmd)=>sent.push(codec.decode(codec.encode(cmd)).obj));c.map=maps.getMap(1);
});
afterEach(()=>{w.removeSession(s);World.current=originalCurrent;database.close();});
function model(ids){const profile=ids.map((id,i)=>({id:i+100,lootId:'equipment_weapon_laser_'+id,ship:true,damage:require('../docs/client-map.items.json').items['equipment_weapon_laser_'+id].damage}));return {stats:{laserProfiles:profile,laserDamage:profile.reduce((n,i)=>n+i.damage,0)}};}
function equipPurchase(sku,id,amount){const before=p.uridium;assert.equal(economy.purchase(p.userId,sku,amount).result,'success');assert.equal(players.loadPlayer(p.userId).uridium,before-1000000*amount);p.uridium=before-1000000*amount;
 const rows=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? ORDER BY id DESC LIMIT ?').all(p.userId,'equipment_weapon_laser_'+id,amount);assert.equal(rows.length,amount);
 inv.move(p.userId,{hangarId:p.shipId,from:{target:'inventory',items:rows.map(r=>r.id),configId:1},to:{target:'ship',slotset:'lasers',configId:1}});w.refreshStats();
}
test('every campaign containing a laser describes its actual numeric special ability in the original shop row',()=>{
 let offers=0;for(const entry of Object.values(payment.captures))if(Object.keys(entry.contents?.items||{}).some(id=>id.startsWith('equipment_weapon_laser_'))){const row={description:entry.description,imageVars:{}};payment.rewriteRow(row,entry.sku);assert.match(row.description,/data-laser-effect=/,entry.sku);assert.ok(/Taban hasar|128–220/.test(row.description),entry.sku);assert.equal(row.price,1000000);offers++;}
 assert.equal(offers,24);const anchor=laser.details('equipment_weapon_laser_lf-5-al').text;assert.match(anchor,/NPC hasarını artırmaz/);assert.match(anchor,/%15\/20\/55/);
});
test('unstable LF4 keeps128to220 bounds without an additional normal variance and composes with ordinary lasers and ammo',()=>{
 const p=model(['lf-4-unstable']);for(const value of [0,1])assert.equal(laser.rollDamage(p,null,100,{random:()=>value}),value?220:128);
 assert.equal(laser.rollDamage(p,null,100,{random:()=>0,multiplier:4}),512);assert.equal(laser.rollDamage(p,null,100,{random:()=>1,multiplier:4}),880);
 const mixed=model(['lf-4-unstable','lf-4']);assert.equal(laser.rollDamage(mixed,null,100,{random:()=>0}),278);assert.equal(laser.rollDamage(mixed,null,100,{random:()=>1}),420);
 const boosted=model(['lf-4-unstable']);boosted.stats.laserDamage*=1.5;assert.equal(laser.rollDamage(boosted,null,100,{random:()=>0}),192);
});
test('Anchorlock applies tier-specific slowing only after a successful ship-laser hit, returns speed on expiry and adds no NPC damage',()=>{
 for(const [count,chance,factor,duration]of [[2,0,1,0],[3,.1,.85,1000],[10,.2,.8,2000],[15,.25,.45,2000]]){
  const p=model(Array(count).fill('lf-5-al')),npc=c.spawn({typeId:84,name:'QA',speed:200,hitpoints:100000,shield:0},{x:7000,y:6000}),now=100000;
  assert.equal(laser.maxDamage(p,npc,now),count*245);c.moveNpc(npc,7400,6000,now);
  assert.equal(laser.onHit(c,p,npc,now,()=>chance),false);assert.equal(laser.onHit(c,p,npc,now,()=>0),count>=3);
  if(count>=3){assert.equal(npc.anchorlockUntil,now+duration);assert.equal(npc.anchorlockFactor,factor);assert.ok(Math.abs(npc.movement.duration-400/(200*factor)*1000)<=1);laser.tick(w,c,now+duration);assert.equal(npc.anchorlockUntil,undefined);assert.equal(npc.anchorlockFactor,undefined);}
  p.stats.laserProfiles.forEach(i=>i.ship=false);assert.equal(laser.onHit(c,p,npc,now,()=>0),false);c.npcs.delete(npc.id);
 }
});
test('Asmodeus and Mortifer campaign requests reject without charging under the laser sales restriction',()=>{for(const [sku,id]of [['package_event-deal-laser-aml','am-l'],['package_event-deal-laser-lf5mf','lf-5-mf']]){const before=players.loadPlayer(p.userId).uridium;assert.equal(economy.purchase(p.userId,sku,3).result,'error');assert.equal(players.loadPlayer(p.userId).uridium,before);assert.ok(db.prepare('SELECT count(*) n FROM items WHERE player_id=? AND loot_id=?').get(p.userId,'equipment_weapon_laser_'+id).n===0);}});
test('actual classic LF4 salvo has ordinary hit flags and no modern critical or fervor effect',()=>{const id=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount)VALUES(?,'equipment_weapon_laser_lf-4',1)").run(p.userId).lastInsertRowid);inv.move(p.userId,{hangarId:p.shipId,from:{target:'inventory',items:[id],configId:1},to:{target:'ship',slotset:'lasers',configId:1}});w.refreshStats();const npc=c.spawn({typeId:84,name:'QA',hitpoints:100000,shield:0,speed:0,reward:{},respawnMs:50000},{x:6400,y:6000});c.rollHit=()=>true;assert.equal(c.attack(s,npc.id),true);assert.equal(sent.findLast(x=>x._==='AttackHitCommand'&&x.attackerId===p.userId).strike,false);assert.equal(p.modernLaserState?.fervor||0,0);});
