'use strict';
process.env.DARKORBIT_DB=':memory:';
const fs=require('node:fs'),path=require('node:path'),root=path.resolve(__dirname,'..'),legacy=path.resolve(root,'../local-server');
const database=require(path.join(legacy,'game/db')),db=database.open(':memory:');
try{
 const players=require(path.join(legacy,'game/db/players')),reference=require('./equipment-source'),config=require(path.join(legacy,'config'));
 const pid=players.createPlayer(players.createAccount('equipment-qa','synthetic-test-only'),'equipment-qa',1,config.starter);
 const shipId=db.prepare('SELECT active_ship_id FROM players WHERE id=?').get(pid).active_ship_id;
 const hulls=db.prepare('SELECT loot_id FROM ship_types ORDER BY loot_id').all().map(r=>r.loot_id),meta=require(path.join(legacy,'docs/client-map.items.json')).items;
 const add=(id,upgrade=0)=>Number(db.prepare('INSERT INTO items(player_id,loot_id,amount,upgrade_level) VALUES(?,?,1,?)').run(pid,id,upgrade).lastInsertRowid);
 const mount=(id,slot,index,c)=>c===1?db.prepare('UPDATE items SET ship_id=?,slot=?,slot_index=? WHERE id=?').run(shipId,slot,index,id):db.prepare('INSERT INTO equipment_config2 VALUES(?,?,?,?)').run(id,shipId,slot,index);
 const sets=[['',10],['havoc',10],['havoc',9],['hercules',10],['spartan',10],['spartan',9],['hermes',10],['cerberus',10],['demon-silver',10],['hercules',1],['spartan',8],['',0]];
 const formIds=[0,...new Set(Object.values(require(path.join(legacy,'game/drones')).formationIds))];
 const benefits=require(path.join(legacy,'game/skills')).BENEFITS,boosters=require(path.join(legacy,'game/boosters'));
 const boosterIds=Object.keys(boosters.definitions).filter(id=>boosters.isSupported(id));
 const cases=[],now=1700000000000;
 for(let n=0;n<364;n++){
  const hull=hulls[n%hulls.length],type=db.prepare('SELECT * FROM ship_types WHERE loot_id=?').get(hull),c=n%2+1;
  for(const table of ['items','drones','player_skills','player_ore_buffs','player_boosters'])db.prepare(`DELETE FROM ${table} WHERE player_id=?`).run(pid);
  db.prepare('UPDATE ships SET loot_id=?,active_config=? WHERE id=?').run(hull,c,shipId);
  const laserIds=['equipment_weapon_laser_lf-3','equipment_weapon_laser_lf-4','equipment_weapon_laser_lf-4-hp','equipment_weapon_laser_lf-5-mf'];
  for(let i=0;i<Math.min(4,type.laser_slots);i++)mount(add(laserIds[(n+i)%laserIds.length],n%16),'laser',i,c);
  for(let i=0;i<Math.min(4,type.generator_slots);i++)mount(add(i%2?'equipment_generator_speed_g3n-7900':n%2?'equipment_generator_shield_fs-03':'equipment_generator_shield_sg3n-b03',n%16),'generator',i,c);
  if(type.extra_slots)mount(add('equipment_extra_cpu_g3x-crgo-x'),'extra',0,c);
  if(meta[hull]?.slotable?.slots.some(s=>s.name==='heavy_guns'&&s.size>0))mount(add(['hydra','neptune','triskelion','hst-2'][n%4].replace(/^/,'equipment_weapon_rocketlauncher_')),'heavy_gun',0,c);
  const module=Object.entries(require(path.join(legacy,'game/ship-modules')).DEFINITIONS).find(([,d])=>d.ships.includes(hull));
  if(module&&require(path.join(legacy,'game/ship-modules')).capacity(hull))mount(add(module[0]),'ship_upgrade',0,c);
  const [design,count]=sets[n%sets.length];
  for(let i=0;i<count;i++){
   const drone=Number(db.prepare('INSERT INTO drones(player_id,loot_id,level,upgrade_level) VALUES(?,?,?,?)').run(pid,i<8?'drone_iris':i===8?'drone_apis':'drone_zeus',n%6,n%16).lastInsertRowid);
   for(let slot=0;slot<2;slot++)db.prepare('INSERT INTO drone_equipment VALUES(?,?,?,?,?,?)').run(drone,shipId,c,'default',slot,add(slot?'equipment_generator_shield_sg3n-b03':laserIds[(n+i)%laserIds.length],n%16));
   if(design)db.prepare('INSERT INTO drone_equipment VALUES(?,?,?,?,?,?)').run(drone,shipId,c,'design',0,add('drone_designs_'+design));
  }
  db.prepare('INSERT OR REPLACE INTO drone_settings VALUES(?,?)').run(pid,count?formIds[(n*7)%formIds.length]:0);
  for(const [id,b]of Object.entries(benefits))if(n%3)db.prepare('INSERT INTO player_skills VALUES(?,?,?)').run(pid,id,n%3===1?1:b.values.length);
  db.prepare('INSERT INTO player_ore_buffs VALUES(?,?,?,?,?)').run(pid,2,6,0,n%3?now+60000:now-1);
  db.prepare('INSERT INTO player_ore_buffs VALUES(?,?,?,?,?)').run(pid,3,7,0,n%2?now+60000:now-1);
  for(const id of boosterIds.filter((_,i)=>i%7===n%7).slice(0,3))db.prepare('INSERT INTO player_boosters VALUES(?,?,?)').run(pid,id,n%4?now+60000:now-1);
  const expected=reference.expected(db,pid,shipId,c,now),input=reference.capture(db,pid,shipId,c,now);
  cases.push({name:`${hull}/config${c}/case${n}`,input,expected});
 }
 fs.mkdirSync(path.join(root,'artifacts'),{recursive:true});fs.writeFileSync(path.join(root,'artifacts/equipment-contract.json'),JSON.stringify({format:1,cases}));console.log(JSON.stringify({equipmentCases:cases.length,hulls:hulls.length,sourceDatabase:':memory:'}));
}finally{database.close();}
