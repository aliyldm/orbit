'use strict';
const {open}=require('./db');
const delivered=new WeakMap();
function maxed(playerId,skillId){return open().prepare('SELECT level FROM player_skills WHERE player_id=? AND skill_id=?').get(playerId,skillId)?.level===5;}
function engineering(playerId){return maxed(playerId,'17');}
function mechanics(playerId){return maxed(playerId,'8');}
function charged(player){return !!player&&!player.dead&&player.shield>0;}
function attribute(player){return{_:'AttributeSkillShieldUpdateCommand',shieldSkillId:charged(player)&&engineering(player.userId)?1:0,minSkinShieldTwinkle:10,maxSkinShieldTwinkle:100};}
function buildInit(player){const command=attribute(player);delivered.set(player,command.shieldSkillId);return[command];}
function refresh(world,sendCmd=require('./net').sendCmd){
 const player=world.player;if(!player)return false;const command=attribute(player);
 if(delivered.get(player)===command.shieldSkillId)return false;
 delivered.set(player,command.shieldSkillId);world.broadcast(s=>sendCmd(s,command));return true;
}
function target(world,targetId){
 const player=world.player;
 // This solo world has one real pilot. NPC/PET IDs never inherit hero skills.
 if(player?.userId!==targetId||!charged(player))return{bubble:false,impact:false};
 return{bubble:engineering(player.userId),impact:mechanics(player.userId)};
}
module.exports={engineering,mechanics,charged,attribute,buildInit,refresh,target};
