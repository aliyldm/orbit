'use strict';
// Shared reference adapter, always called with an explicitly supplied SQLite
// copy or :memory: DB. Never opens the live player's DB implicitly.
const path=require('node:path'),legacy=path.resolve(__dirname,'../../local-server');
function capture(db,playerId,shipId,config,now){
 const ship=db.prepare('SELECT s.*,t.hitpoints base_hp,t.speed base_speed,t.cargo base_cargo FROM ships s JOIN ship_types t ON t.loot_id=s.loot_id WHERE s.id=? AND s.player_id=?').get(shipId,playerId);
 if(!ship)throw Error('Reference ship absent');
 const inv=require(path.join(legacy,'game/inventory')),dr=require(path.join(legacy,'game/drones'));
 const rawDrones=dr.owned(db,playerId),droneEquipment=dr.equipped(db,shipId,config);
 const skillLevels=Object.fromEntries(db.prepare('SELECT skill_id,level FROM player_skills WHERE player_id=?').all(playerId).map(s=>[s.skill_id,s.level]));
 const oreBuffs=db.prepare('SELECT * FROM player_ore_buffs WHERE player_id=?').all(playerId);
 const boosters=db.prepare('SELECT * FROM player_boosters WHERE player_id=? AND expires_at>? ORDER BY loot_id').all(playerId,now);
 return{ship,type:db.prepare('SELECT * FROM ship_types WHERE loot_id=?').get(ship.loot_id),equipped:inv.equipped(db,shipId,config),drones:rawDrones,droneEquipment,formationId:dr.formation(playerId),skillLevels,oreBuffs,boosters,now};
}
function expected(db,playerId,shipId,config,now){
 const inv=require(path.join(legacy,'game/inventory')),ship=db.prepare('SELECT * FROM ships WHERE id=?').get(shipId),type=db.prepare('SELECT * FROM ship_types WHERE loot_id=?').get(ship.loot_id);
 // Drone applyStats deliberately reads the active hull/config from players.
 db.prepare('UPDATE players SET active_ship_id=? WHERE id=?').run(shipId,playerId);db.prepare('UPDATE ships SET active_config=? WHERE id=?').run(config,shipId);
 let stats=require(path.join(legacy,'game/stats')).computeStats(type,inv.statItems(db,shipId,config));
 stats=require(path.join(legacy,'game/ship-passives')).applyStats(ship.loot_id,stats);
 stats=require(path.join(legacy,'game/drones')).applyStats(playerId,stats);
 stats=require(path.join(legacy,'game/skills')).applyStats(playerId,stats);
 stats=require(path.join(legacy,'game/handlers/lab')).applyStats(playerId,stats,{db,now});
 return require(path.join(legacy,'game/boosters')).applyStats(playerId,stats,{db,now});
}
module.exports={capture,expected};
