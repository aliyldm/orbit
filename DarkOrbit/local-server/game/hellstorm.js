'use strict';
// HST contracts: RocketLauncherAssembly.as, HellstormAttackHandler.as,
// AmmunitionTypeModule.as and ItemDataProvider.as. Official Hellstorm FAQ:
// one round per second, three seconds after a salvo before loading again.
const {open,tx}=require('./db');
const inventory=require('./inventory');
const META=require('../docs/client-map.items.json').items;
const maps=require('./maps');
const launchersHardware=require('./launcher-hardware');
const ROOT='equipment_weapon_rocketlauncher_hst',CPU='equipment_extra_cpu_rllb-x';
const TYPES={HELLSTORM:[21,7],UBER_ROCKET:[22,8],ECO_ROCKET:[23,9],SAR01:[24,12],SAR02:[25,13],CBR:[39,14],BDR1212:[42,16],PIR_100:[46,19],OBR_100:[48,27]};
const AMMO=Object.fromEntries(Object.entries(META).filter(([id,m])=>id.startsWith('ammunition_rocketlauncher_')&&TYPES[m.typeValue]).map(([id,m])=>[id,{...m,module:TYPES[m.typeValue][0],visual:TYPES[m.typeValue][1]}]));
// September2026 official Galactic Strife FAQ: OBR has90% hit chance.
AMMO['ammunition_rocketlauncher_obr-100'].hitChance=.9;
const TEMPLATES=new Map();
(function walk(v){if(!v||typeof v!=='object')return;if(v._==='MenuItemStatusCommand')TEMPLATES.set(v.menuItemId,v);for(const x of Object.values(v))if(x&&typeof x==='object')walk(x);})(require('./templates/init.json'));
function count(p,id){return open().prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').get(p.userId,id).n;}
function hardware(p){
 const config=inventory.activeConfig(open(),p.shipId),eq=inventory.equipped(open(),p.shipId,config);
 const launchers=launchersHardware.equipped(eq).sort((a,b)=>a.slot_index-b.slot_index||a.id-b.id);
 const rounds=[],types=[];let cooldown=0;
 for(const item of launchers){const d=launchersHardware.definition(item.loot_id),upgrade=META[item.loot_id]?.upgradable;
  const mult=(upgrade?.upgradeType==='ROCKETLAUNCHER_DAMAGE_UPGRADE'?1+(item.upgrade_level||0)*upgrade.bonusPerLevel/100:1)+(d.launcherDamage||0);
  types.push(d.type);cooldown=Math.max(cooldown,d.cooldown);for(let i=0;i<d.capacity;i++)rounds.push(mult);
 }
 return {signature:`${p.shipId}:${config}:${launchers.map(i=>`${i.id}.${i.upgrade_level||0}`).join(',')}`,types,type:types[0]||0,capacity:rounds.length,cooldown:cooldown||3000,roundMultipliers:rounds,upgradeMultiplier:rounds.length?rounds.reduce((n,x)=>n+x,0)/rounds.length:1,cpu:eq.some(i=>i.loot_id===CPU&&i.slot==='extra')};
}
function state(world){
 const p=world.player;if(!p)return null;const hw=hardware(p);
 let s=world.launcherState;
 if(!s||s.owner!==p.userId||s.signature!==hw.signature){cancelWake(world,s);s={owner:p.userId,signature:hw.signature,ammo:p.launcherAmmo||'ammunition_rocketlauncher_eco-10',loaded:0,reloadAt:0,nextFire:s?.owner===p.userId?s.nextFire:0,pending:null,auto:false};world.launcherState=s;}
 Object.assign(s,hw);s.auto=hw.cpu&&!!require('./cpu').read(p)['rllb-x'];
 if(!count(p,s.ammo)){
  const fallback=require('./automation').launcherAmmo(p,s.ammo);
  if(fallback!==s.ammo){cancelWake(world,s);s.ammo=p.launcherAmmo=fallback;s.loaded=0;s.reloadAt=0;s.pending=null;}
 }
 s.loaded=Math.min(s.loaded,hw.capacity,count(p,s.ammo));return s;
}
function sender(world,session,cmd){(world.combat?.send||require('./net').sendCmd)(session,cmd);}
function broadcast(world,cmd){world.broadcast(s=>sender(world,s,cmd));}
function cancelWake(world,s){if(s?.wake){clearTimeout(s.wake);world.scheduled.delete(s.wake);s.wake=null;s.wakeAt=0;}}
// A dedicated deadline prevents0.75s/1.33s formation reload intervals from
// being rounded to the next one-second NPC tick. Never replace the NPC timer.
function wake(world,s,at){
 if(!at||!Number.isFinite(at)){cancelWake(world,s);return;}
 if(s.wake&&s.wakeAt===at)return;cancelWake(world,s);s.wakeAt=at;
 s.wake=world.schedule(()=>{s.wake=null;s.wakeAt=0;if(world.launcherState===s&&world.combat)tick(world,world.combat,Date.now());},Math.max(1,at-Date.now()));
}
function menu(id,changes){const source=TEMPLATES.get(id);return source?{...JSON.parse(JSON.stringify(source)),visible:true,...changes}:null;}
// Ammo notifications and full-menu refreshes must use the same live selection
// as RL status; captured template highlights are another account's state.
function menuStatus(p,c){
 const w=require('./world').current(),s=w?.livePlayer(p.userId)===p?state(w):null,hw=s||hardware(p),id=c.menuItemId;
 const stock=AMMO[id]?count(p,id):0,available=id===CPU?hw.cpu:!!hw.capacity&&(id===ROOT||stock>0);
 const selected=id===CPU?hw.cpu&&!!require('./cpu').read(p)['rllb-x']:id===ROOT?!!s?.reloadAt:id===(s?.ammo||p.launcherAmmo||'ammunition_rocketlauncher_eco-10');
 return {...c,visible:true,available,activatable:available,blocked:false,selected,
  ...(id===ROOT?{counterValue:s?.loaded||0,maxCounterValue:hw.capacity}:AMMO[id]?{counterValue:stock}:{})};
}
function buildInit(world){
 const p=world.player;if(!p)return[];const s=state(world),a=AMMO[s.ammo];
 const cmds=[{_:'LegacyModule',message:`0|RL|S|${s.types.join(',')||0}|${a?.visual||9}|${s.loaded}`},{_:'CPUInfoAutoRocketLauncherCommand',active:s.auto}];
 const root=menu(ROOT,{available:!!s.capacity,activatable:!!s.capacity&&count(p,s.ammo)>0,counterValue:s.loaded,maxCounterValue:s.capacity,selected:!!s.reloadAt,blocked:false});if(root)cmds.push(root);
 for(const id of Object.keys(AMMO)){const amount=count(p,id),command=menu(id,{available:!!s.capacity&&amount>0,activatable:!!s.capacity&&amount>0,counterValue:amount,selected:s.ammo===id,blocked:false});if(command)cmds.push(command);}
 const cpu=menu(CPU,{available:s.cpu,activatable:s.cpu,selected:s.auto,blocked:false});if(cpu)cmds.push(cpu);
 return cmds;
}
function notify(world){for(const c of buildInit(world))broadcast(world,c);}
function reload(world,now=Date.now()){
 const p=world.player,s=state(world);if(!s?.capacity||p.dead)return false;
 const stock=count(p,s.ammo),desired=Math.min(s.capacity,stock);
 if(!desired||now<s.nextFire)return false;if(s.loaded>=desired)return true;
 if(rapidFill(world,s,now))return true;
 if(!s.reloadAt)s.reloadAt=now+roundTime(world,p);
 broadcast(world,{_:'MenuItemTimerCommand',menuItemId:ROOT,timerState:{_:'TimerStateModule',timerStateValue:1},maxTime:roundTime(world,p)*(desired-s.loaded),time:roundTime(world,p)*(desired-s.loaded),activatable:true});notify(world);wake(world,s,s.reloadAt);return true;
}
function roundTime(world,p){return Math.max(50,Math.round((world.config.combat?.launcherReloadRoundMs??1000)*(p.stats.formation?.launcherCooldown??1)));}
function rapid(world,now){return require('./ship-abilities-expanded').launcher(world,now);}
function rapidFill(world,s,now){
 if(!rapid(world,now)||now<s.nextFire)return false;
 const desired=Math.min(s.capacity,count(world.player,s.ammo)),changed=s.loaded!==desired||!!s.reloadAt;
 s.loaded=desired;s.reloadAt=0;if(changed)notify(world);return true;
}
function rapidStart(world,now=Date.now()){
 const s=state(world);if(!s)return;cancelWake(world,s);s.nextFire=now;rapidFill(world,s,now);
 wake(world,s,s.auto?now+1:0);
}
function select(session,id,activate=false){
 const w=session.world,p=w.player;if(!w.active(session)||p.dead||!AMMO[id])return false;
 const s=state(w);if(s.ammo!==id){s.ammo=id;p.launcherAmmo=id;s.loaded=0;s.reloadAt=0;s.pending=null;}
 notify(w);if(!s.capacity)return false;
 if(activate)return fire(session,session.selected);
 return reload(w);
}
function consume(p,id,quantity){
 return tx(db=>{
  const rows=db.prepare('SELECT id,amount FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id').all(p.userId,id);
  if(rows.reduce((n,r)=>n+r.amount,0)<quantity)return false;
  let left=quantity;for(const row of rows){const take=Math.min(left,row.amount);db.prepare('UPDATE items SET amount=amount-? WHERE id=?').run(take,row.id);left-=take;if(!left)break;}return true;
 });
}
function fire(session,targetId,now=Date.now()){
 const w=session.world,p=w.updatePosition(),s=state(w),combat=w.combat;
 if(!w.active(session)||p.dead||session.jumping||!s.capacity||!combat||now<s.nextFire)return false;
 const npc=combat.npcs.get(targetId),a=AMMO[s.ammo];if(!npc||npc.hp<=0||!a||maps.nearPeaceArea(w))return false;
 combat.updateNpc(npc,now);
 if(maps.dist(p,npc)>a.range){sender(w,session,{_:'AttackRangeExceededCommand',uid:npc.id,maxRange:a.range,type:2});return false;}
 if(combat.npcProtected(npc)){combat.missed(npc.id,0);return false;}
 rapidFill(w,s,now);
 if(!s.loaded){if(reload(w,now))s.pending=targetId;return false;}
 const quantity=s.loaded;if(!consume(p,s.ammo,quantity)){s.loaded=0;s.reloadAt=0;s.pending=null;notify(w);return false;}
 s.loaded=0;s.reloadAt=0;s.pending=null;require('./cpu').breakCloak(w);
 const active=rapid(w,now),cooldown=active?.cooldown??Math.max(0,Math.round((w.config.combat?.launcherCooldownMs??s.cooldown)*(p.stats.formation?.launcherCooldown??1)*(p.stats.droneDesigns?.launcherCooldown??1)));s.nextFire=now+cooldown;
 p.lastCombat=now;p.repairing=false;
 // The Plus passive supplies one free extra round per successful 20% roll,
 // including when the last owned round is fired. Only paid rounds are debited.
 const extra=require('./ship-passives').hull(p,open())==='ship_tartarus-plus'&&Math.random()<.2?1:0,load=quantity+extra;
 const multiplier=(p.stats.rocketMultiplier??1)*(active?.damage||1)*(s.roundMultipliers.slice(0,quantity).reduce((n,x)=>n+x,0)+(extra?s.roundMultipliers[0]:0));
 const hit=combat.rollHit(require('./combat-balance').itemHitChance('launcher',a,w.config.combat,{accuracy:(p.stats.skills?.rocketAccuracy||0)+(p.stats.rocketHitBonus||0)}));
 broadcast(w,{_:'HellstormAttackCommand',attackerId:p.userId,targetId:npc.id,hit,currentLoad:load,rocketType:{_:'AmmunitionTypeModule',typeValue:a.module}});
 combat.scheduleImpact(session,npc,()=>{if(hit&&!combat.npcProtected(npc)){
  const leech=Math.min(npc.shield,Math.round((a.shieldLeechDamage||0)*multiplier));npc.shield-=leech;p.shield=Math.min(p.shieldMax,p.shield+leech);
  const damage=Math.round(a.damage*multiplier);if(damage)combat.applyDamage(npc,damage,combat.npcAbsorb(npc));
  npc.lastHit=Date.now();npc.aggro=session;if(damage+leech>0)combat.hit(p.userId,npc.id,npc,damage+leech,0);else combat.missed(npc.id,0);
  if(leech)sender(w,session,{_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});
  if(npc.hp<=0)combat.kill(session,npc);
 }else combat.missed(npc.id,0);},{rounds:load,airstrike:true});
 broadcast(w,{_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:11},maxTime:cooldown,time:cooldown});
 notify(w);wake(w,s,s.auto?s.nextFire:0);return true;
}
function tick(world,combat,now=Date.now()){
 const p=world.player;if(!p||p.dead)return;const s=state(world),session=[...world.sessions].find(s=>world.active(s));if(!s.capacity||!session||session.jumping)return;
 const stock=count(p,s.ammo),desired=Math.min(stock,s.capacity);
 rapidFill(world,s,now);
 if(s.pending&&!combat.npcs.has(s.pending))s.pending=null;
 if(s.reloadAt&&now>=s.reloadAt){
  const rounds=1+Math.floor((now-s.reloadAt)/roundTime(world,p));s.loaded=Math.min(desired,s.loaded+rounds);
  s.reloadAt=s.loaded<desired?s.reloadAt+rounds*roundTime(world,p):0;notify(world);
 }
 if(s.pending&&s.loaded>=desired&&!s.reloadAt&&now>=s.nextFire)fire(session,s.pending,now);
 if(s.auto){if(!s.reloadAt&&s.loaded<desired)reload(world,now);if(session.attacking&&s.loaded&&s.loaded>=desired&&!s.reloadAt&&now>=s.nextFire)fire(session,session.attacking,now);}
 wake(world,s,s.reloadAt||(s.auto&&s.loaded<desired&&s.nextFire>now?s.nextFire:0));
}
function recognizes(id){return id===ROOT||id===CPU||!!AMMO[id];}
function action(session,cmd){
 if(!session.world.active(session)||session.player.dead||session.jumping)return false;const w=session.world,s=state(w);
 if(cmd.menuItemId===CPU){if(!s.cpu)return false;s.auto=!s.auto;require('./cpu').write(w.player,{...require('./cpu').read(w.player),'rllb-x':s.auto});notify(w);if(s.auto)reload(w);return true;}
 if(AMMO[cmd.menuItemId])return select(session,cmd.menuItemId,cmd.actionType===1);
 if(cmd.menuItemId===ROOT){if(s.loaded)return fire(session,session.selected);const ok=reload(w);if(ok&&cmd.actionType===1&&session.selected)s.pending=session.selected;return ok;}
 return false;
}
function legacy(session,message){
 if(!session.world.active(session)||session.player.dead||session.jumping)return false;
 const parts=String(message).split('|');if(parts[0]==='0')parts.shift();if(parts[0]!=='RL')return false;
 if(parts[1]==='L')return reload(session.world);
 if(parts[1]==='A')return fire(session,Number(parts[2])||session.selected);
 if(parts[1]==='SEL'){const id=Object.keys(AMMO).find(id=>AMMO[id].visual===Number(parts[2])||AMMO[id].module===Number(parts[2]));return id?select(session,id):false;}
 return false;
}
function stop(world){cancelWake(world,world.launcherState);world.launcherState=null;}
module.exports={ROOT,CPU,AMMO,hardware,state,count,menuStatus,buildInit,notify,reload,select,fire,tick,recognizes,action,legacy,stop,rapidStart};
