'use strict';
// Stock and cooldowns are real account data. Parameters/evidence: docs/techs-local.md.
const {open,tx}=require('./db'),maps=require('./maps');
const KEY='game.techCooldowns';
const DEFINITIONS={
 'tech_energy-leech':{duration:900000,cooldown:1800000,group:18,visual:59,kind:'leech'},
 'tech_chain-impulse':{duration:0,cooldown:60000,group:19,kind:'chain'},
 'tech_precision-targeter':{duration:900000,cooldown:300000,group:20,kind:'precision'},
 'tech_backup-shields':{duration:0,cooldown:120000,group:21,kind:'shield',shield:75000},
 'tech_battle-repair-bot':{duration:10000,cooldown:120000,group:23,visual:60,kind:'repair',hp:10000,shield:0},
 'tech_battle-repair-bot2':{duration:10000,cooldown:1200000,cooldownAfter:true,visual:61,kind:'repair',hp:20000,shield:35000},
 'tech_shield-backup2':{duration:0,cooldown:1200000,kind:'shield',shield:450000},
 'tech_npc-nuke':{duration:60000,cooldown:1200000,cooldownAfter:true,kind:'nuke'},
 'tech_anti-ai-emergency-reserves':{duration:10000,cooldown:1800000,kind:'reserves'}
};
const UNSUPPORTED={
 'tech_explosive-charging-blob':'Yalnızca düşman oyuncu hedefler; yerel solo sürümde PvP hedefi yok.',
 'tech_burning-trail':'Yalnızca düşman oyunculara hasar verir; yerel solo sürümde PvP hedefi yok.',
 'tech_versus-laser-overdrive':'Açgözlülük Girdabı haritası ve PvP etkisi bu yerel sürümde yok.',
 'tech_speed-burst':'Kesin süre/hız ve bekleme süresi birincil kaynakla henüz tamamlanmadı.',
 'tech_frost-field':'Kesin hasar, menzil, yavaşlatma oranı ve bekleme süresi henüz doğrulanmadı.',
 'tech_anti-mine-transmitter':'Düşman oyuncu ve IceMine tetikleme sistemi henüz yerel sürümde yok.'
};
const TEMPLATES=new Map();(function walk(v){if(!v||typeof v!=='object')return;if(v._==='MenuItemStatusCommand'&&v.menuItemId.startsWith('tech_'))TEMPLATES.set(v.menuItemId,v);for(const x of Object.values(v))if(x&&typeof x==='object')walk(x);})(require('./templates/init.json'));
function recognizes(id){return !!DEFINITIONS[id];}
function read(p){if(!p.techCooldowns){try{p.techCooldowns=JSON.parse(open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,KEY)?.value||'{}');}catch{p.techCooldowns={};}}return p.techCooldowns;}
function quantities(p){return new Map(open().prepare("SELECT loot_id,SUM(amount)n FROM items WHERE player_id=? AND loot_id LIKE 'tech_%' AND ship_id IS NULL GROUP BY loot_id").all(p.userId).map(r=>[r.loot_id,r.n]));}
function active(p,id,now=Date.now()){const run=p.techActive?.[id];return run&&run.until>now&&run.shipId===p.shipId&&run.mapId===p.mapId?run:null;}
function send(w,command){const fn=w.combat?.send||require('./net').sendCmd;w.broadcast(s=>fn(s,command));}
function status(p,command,now=Date.now(),counts=quantities(p)){
 const id=command.menuItemId,definition=DEFINITIONS[id],n=counts.get(id)||0,run=active(p,id,now),ready=!!definition&&n>0&&!run&&now>=(read(p)[id]||0);
 return {...structuredClone(command),visible:n>0||!!run,available:!!definition&&(n>0||!!run),activatable:ready,selected:!!run,blocked:false,counterValue:n,buyable:false};
}
function menuStatus(p,command,now=Date.now()){return status(p,command,now);}
function timer(id,until,max,now,state){return{_:'MenuItemTimerCommand',menuItemId:id,timerState:{_:'TimerStateModule',timerStateValue:state},time:Math.max(0,until-now),maxTime:max,activatable:false};}
function timers(p,id,now){const d=DEFINITIONS[id],out=[],until=read(p)[id]||0,run=active(p,id,now);if(run)out.push(timer(id,run.until,d.duration,now,1));else if(!d.group&&until>now)out.push(timer(id,until,d.cooldown,now,2));
 if(d.group&&until>now)out.push({_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:d.group},time:until-now,maxTime:d.cooldown});return out;}
function buildInit(input,now=Date.now()){const p=input?.player||input;if(!p?.userId)return[];const counts=quantities(p),out=[...TEMPLATES.values()].map(c=>status(p,c,now,counts));for(const id of Object.keys(DEFINITIONS))out.push(...timers(p,id,now));return out;}
function notify(w,now=Date.now()){for(const command of buildInit(w,now))send(w,command);}
function visual(w,d,on){if(d.visual)send(w,{_:'VisualModifierCommand',userId:w.player.userId,modifier:d.visual,attribute:0,additionalAttribute:'',count:1,activated:on});}
function hp(w){send(w,require('./nano-hull').command(w.player));}
function shield(w){send(w,{_:'AttributeShieldUpdateCommand',shieldNow:w.player.shield,shieldMax:w.player.shieldMax});}
function heal(w,amount,shieldAmount=0){const p=w.player,before=p.hitPoints,oldShield=p.shield;p.hitPoints=Math.min(p.hitMax,p.hitPoints+amount);p.shield=Math.min(p.shieldMax,p.shield+shieldAmount);if(p.hitPoints!==before)hp(w);if(p.shield!==oldShield)shield(w);return p.hitPoints-before;}
function consume(db,p,id){const row=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id LIMIT 1').get(p.userId,id);if(!row||!db.prepare('UPDATE items SET amount=amount-1 WHERE id=? AND amount>0').run(row.id).changes)throw Error('Yetersiz teknoloji stoku.');}
function targets(w,combat,range,now){const p=w.updatePosition(now);return [...combat.npcs.values()].filter(n=>{combat.updateNpc(n,now);return n.hp>0&&!combat.npcProtected(n)&&maps.dist(p,n)<=range;});}
function chainTargets(w,session,now){const combat=w.combat,range=w.config.combat?.techs?.chainRange??500,all=targets(w,combat,range,now),first=all.find(n=>n.id===session.selected);if(!first)return[];
 const result=[first],left=new Set(all.filter(n=>n!==first));while(result.length<7&&left.size){const last=result.at(-1),next=[...left].filter(n=>maps.dist(last,n)<=range).sort((a,b)=>maps.dist(last,a)-maps.dist(last,b))[0];if(!next)break;result.push(next);left.delete(next);}return result;}
function damage(w,combat,n,amount,session,now,{direct=false,type=0}={}){const before=n.hp+n.shield;if(direct)n.hp=Math.max(0,n.hp-amount);else combat.applyDamage(n,amount,combat.npcAbsorb(n));const actual=Math.max(0,before-n.hp-n.shield);if(!actual)return;n.lastHit=now;n.aggro=session;w.player.lastCombat=now;combat.hit(w.player.userId,n.id,n,actual,type);if(n.hp<=0)combat.kill(session,n);}
function nuke(w,combat,run,now){for(const target of targets(w,combat,w.config.combat?.techs?.nukeRange??500,now))damage(w,combat,target,100000,run.session,now);}
function action(session,command,now=Date.now()){
 const w=session.world,p=w.player,id=command.menuItemId,d=DEFINITIONS[id];if(!d||command.actionType!==1||!p||p.dead||session.jumping||!w.active(session)||!w.combat)return false;
 if(active(p,id,now)||now<(read(p)[id]||0))return false;
 if((quantities(p).get(id)||0)<1)return false;
 // Three simultaneous techs is the classic interface limit; instant techs do not occupy a lasting slot.
 if(d.duration&&Object.values(p.techActive||{}).filter(r=>r.until>now).length>=3)return false;
 let chain;if(d.kind==='chain'){if(maps.nearPeaceArea(w)||(chain=chainTargets(w,session,now)).length===0)return false;}
 if(d.kind==='nuke'&&maps.nearPeaceArea(w))return false;
 if(d.kind==='shield'&&p.shield>=p.shieldMax)return false;
 if(d.kind==='repair'&&p.hitPoints>=p.hitMax&&(!d.shield||p.shield>=p.shieldMax))return false;
 const next={...read(p),[id]:now+d.cooldown+(d.cooldownAfter?d.duration:0)};
 tx(db=>{consume(db,p,id);db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,KEY,JSON.stringify(next));});p.techCooldowns=next;
 const run={id,def:d,session,player:p,shipId:p.shipId,mapId:p.mapId,until:now+d.duration,nextTick:now+1000};
 if(d.duration){p.techActive??={};p.techActive[id]=run;}visual(w,d,true);
 if(d.kind==='shield'){heal(w,0,d.shield);send(w,{_:'LegacyModule',message:`0|TX|A|0|${id==='tech_shield-backup2'?'SBU2':'SBU'}|${p.userId}`});}
 if(d.kind==='chain'){require('./cpu').breakCloak(w);send(w,{_:'LegacyModule',message:`0|TX|ECI|1|${p.userId}|${chain.map(n=>n.id).join('|')}`});for(const target of chain)damage(w,w.combat,target,10000,session,now,{direct:true,type:5});}
 if(d.kind==='nuke'){require('./cpu').breakCloak(w);nuke(w,w.combat,run,now);run.nextTick=now+10000;}
 notify(w,now);return true;
}
function laserHit(w,damageDealt,ammoId,now=Date.now()){const p=w.player;if(!p||p.dead||!active(p,'tech_energy-leech',now)||['ammunition_laser_sab-50','ammunition_laser_rsb-75'].includes(ammoId)||!Number.isFinite(damageDealt)||damageDealt<=0)return 0;return heal(w,Math.floor(damageDealt*.1));}
function rocketChance(w,ammoId,chance,now=Date.now()){return w.player&&active(w.player,'tech_precision-targeter',now)&&/^ammunition_rocket_(r-310|plt-2026|plt-2021|plt-3030)$/.test(ammoId)?1:chance;}
function protect(w,state,now=Date.now()){if(w.player&&!w.player.dead&&active(w.player,'tech_anti-ai-emergency-reserves',now)&&state.hp<1){state.hp=1;return true;}return false;}
function stopRun(w,id){const p=w.player,run=p?.techActive?.[id];if(!run)return;delete p.techActive[id];visual(w,run.def,false);}
function stop(w){for(const id of Object.keys(w.player?.techActive||{}))stopRun(w,id);if(w.player)w.player.techMenuSignature=null;}
function tick(w,combat,now=Date.now()){
 const p=w.player;if(!p)return;for(const [id,run]of Object.entries(p.techActive||{})){
  if(p.dead||p!==run.player||!w.active(run.session)||run.session.jumping||p.shipId!==run.shipId||p.mapId!==run.mapId){stopRun(w,id);continue;}
  if(run.def.kind==='repair')while(run.nextTick<=now&&run.nextTick<=run.until){heal(w,run.def.hp,run.def.shield);run.nextTick+=1000;}
  if(run.def.kind==='nuke')while(run.nextTick<=now&&run.nextTick<run.until){nuke(w,combat,run,now);run.nextTick+=10000;}
  if(now>=run.until)stopRun(w,id);
 }
 const counts=quantities(p),signature=JSON.stringify([...TEMPLATES.keys()].map(id=>[id,counts.get(id)||0,!!active(p,id,now),now<(read(p)[id]||0)]));
 if(signature!==p.techMenuSignature){p.techMenuSignature=signature;notify(w,now);}
}
module.exports={KEY,DEFINITIONS,UNSUPPORTED,recognizes,read,quantities,active,menuStatus,buildInit,action,tick,stop,laserHit,rocketChance,protect};
