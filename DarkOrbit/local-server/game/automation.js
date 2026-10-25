'use strict';
// GameplaySettingsModule flags are authoritative. Automatic ammo fallback only
// handles exhaustion; it is not an RSB/cooldown macro or automatic purchasing.
const {open,tx}=require('./db');
const LASERS=['lcb-10','mcb-25','mcb-50','ucb-100'].map(id=>'ammunition_laser_'+id);
const ROCKETS=['r-310','plt-2026','plt-2021','plt-3030'].map(id=>'ammunition_rocket_'+id);
const LAUNCHERS=['eco-10','hstrm-01','ubr-100'].map(id=>'ammunition_rocketlauncher_'+id);
function settings(p,db=open()){
 const defaults=require('./handlers/systems-evidence.json').defaults.UserSettingsCommand.gameplaySettingsModule;
 const row=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,'GameplaySettingsModule');
 try{return {...defaults,...JSON.parse(row?.value||'{}')};}catch{return {...defaults};}
}
function fallback(p,current,need,ids){
 if(!Number.isSafeInteger(need)||need<1||require('./ammo').count(p,current)>=need||!settings(p).autoChangeAmmo)return current;
 return ids.find(id=>id!==current&&require('./ammo').count(p,id)>=need)||current;
}
function laserAmmo(p,need){
 const current=p.ammo||require('./ammo').DEFAULT_AMMO,id=fallback(p,current,need,LASERS);
 if(id!==current)require('./ammo').select(p,id);return id;
}
function rocketAmmo(p){
 const current=p.rocket||ROCKETS[0],id=fallback(p,current,1,ROCKETS);
 if(id!==current){p.rocket=id;require('./ammo').notify(p);}return id;
}
function launcherAmmo(p,current,need=1){return fallback(p,current,need,LAUNCHERS);}
function refine(p){
 const lab=require('./handlers/lab');let changed=false;
 tx(db=>{for(const type of [4,5,6]){
  const recipe=lab.RECIPES[type],amount=Math.min(1000000,...Object.entries(recipe).map(([ore,ratio])=>Math.floor((db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=?').get(p.userId,Number(ore))?.amount||0)/ratio)));
  if(amount>0){lab.refine(p,{toProduce:{oreType:{typeValue:type},count:amount}},{db});changed=true;}
 }});return changed;
}
function boost(p,now){
 const db=open(),lab=require('./handlers/lab');let changed=false;
 // The setting is automatic weapon enrichment, not a purchased stat booster.
 // Keep a selected, unspent ore coating; never replace it with a weaker ore.
 tx(()=>{for(const type of [0,1]){
  const old=db.prepare('SELECT * FROM player_ore_buffs WHERE player_id=? AND item_type=?').get(p.userId,type);
  if(old?.remaining>0)continue;
  const ore=[7,6,4].find(id=>(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=?').get(p.userId,id)?.amount||0)>0);
  if(ore===undefined)continue;
  lab.update(p,{itemToUpdate:{itemValue:type},updateWith:{oreType:{typeValue:ore},count:1}},{db,now});changed=true;
 }});return changed;
}
function tick(world,now=Date.now(),force=false){
 const p=world.player;if(!p||p.dead||!world.sessions?.size||[...world.sessions].every(s=>!world.active(s)||s.jumping))return false;
 if(!force&&now<(world.automationNext||0))return false;world.automationNext=now+1000;
 const flags=settings(p);let changed=false;
 if(p.premium){if(flags.autoRefinement)changed=refine(p)||changed;if(flags.autoBoost)changed=boost(p,now)||changed;}
 if(changed){
  const used=open().prepare('SELECT COALESCE(SUM(amount),0) n FROM player_resources WHERE player_id=? AND ore_type<>3').get(p.userId).n;
  p.cargoSpace=Math.max(0,p.cargoSpaceMax-used);
  const send=world.combat?.send||require('./net').sendCmd;
  const commands=[...require('./collectables').resourceCommands(p),...require('./handlers/lab').buildInit(p)];
  world.broadcast(s=>{for(const c of commands)send(s,c);});
 }return changed;
}
function ensureBootyKey(world,box){
 const p=world.player,type=require('./booty').type(box),id='resource_booty-key';
 if(!p||type?.key!==id)return false;
 if(require('./loot-rewards').count(open(),p.userId,id)>0)return true;
 if(!settings(p).autoBuyGreenBootyKeys)return false;
 const offer=require('./economy').offers(p.userId)[id];
 if(!offer||offer.currency!=='real'||offer.isPaymentItem||!Number.isFinite(offer.price)||offer.price<=0||p.uridium<offer.price)return false;
 tx(db=>{
  db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits,p.uridium,p.userId);
  if(!db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(offer.price,p.userId,offer.price).changes)throw Error('Anahtar için Uridyum yetersiz.');
  require('./loot-rewards').item(db,p.userId,id,1);
 });p.uridium-=offer.price;
 const send=world.combat?.send||require('./net').sendCmd;
 world.broadcast(s=>{send(s,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});for(const c of require('./booty').buildInit(p))send(s,c);});return true;
}
module.exports={settings,laserAmmo,rocketAmmo,launcherAmmo,refine,boost,tick,ensureBootyKey};
