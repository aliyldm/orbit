'use strict';
const {open,tx}=require('./db'),maps=require('./maps');
const KEY='game.shipAbilityCooldowns';
// IDs/effect percentages are client sourced; timings are official FAQ sourced.
// Sources/edition details: docs/combat-balance-audit.md. Config overrides remain.
const DEFINITIONS=[
 {name:'solace',ship:'ship_solace',id:1,group:36,duration:0,cooldown:90000},
 {name:'diminisher',ship:'ship_diminisher',id:2,group:37,duration:15000,cooldown:90000,target:true},
 {name:'spectrum',ship:'ship_spectrum',id:3,group:38,duration:10000,cooldown:180000},
 {name:'sentinel',ship:'ship_sentinel',id:4,group:39,duration:35000,cooldown:180000},
 {name:'venom',ship:'ship_venom',id:5,group:40,duration:35000,cooldown:120000,target:true},
 {name:'lightning',ship:'ship_v-lightning',id:6,group:41,duration:5000,cooldown:180000}
].map(d=>({...d,menu:'ability_'+d.name}));
const templates=new Map();(function walk(v){if(!v||typeof v!=='object')return;if(v._==='MenuItemStatusCommand'&&v.menuItemId.startsWith('ability_'))templates.set(v.menuItemId,v);for(const x of Object.values(v))if(x&&typeof x==='object')walk(x);})(require('./templates/init.json'));
function owned(p){return open().prepare('SELECT s.loot_id FROM ships s JOIN players p ON p.active_ship_id=s.id WHERE s.id=? AND s.player_id=? AND p.id=?').get(p.shipId,p.userId,p.userId)?.loot_id;}
function definition(p){const ship=owned(p);return DEFINITIONS.find(d=>d.ship===ship);}
function recognizes(id){return DEFINITIONS.some(d=>d.menu===id)||require('./ship-abilities-expanded').recognizes(id);}
function read(p){try{return JSON.parse(open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,KEY)?.value||'{}');}catch{return{};}}
function send(w,command){const fn=w.combat?.send||require('./net').sendCmd;w.broadcast(s=>fn(s,command));}
function menu(w,d,now){const p=w.player,yes=definition(p)===d,active=w.shipAbility?.def===d;return{...structuredClone(templates.get(d.menu)),visible:yes,available:yes,activatable:yes&&!p.dead&&!active&&now>=(read(p)[d.name]||0),selected:!!active,blocked:false};}
function timer(d,until,now,state=2){return{_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:state},cooldownType:{_:'CooldownTypeModule',typeValue:d.group},time:Math.max(0,until-now),maxTime:Math.max(0,until-now)};}
function buildInit(w,now=Date.now()){
 if(!w.player)return[];const out=[...templates].map(([id,t])=>{const d=DEFINITIONS.find(d=>d.menu===id);return d?menu(w,d,now):require('./ship-abilities-expanded').status(w,id,t,now)||{...structuredClone(t),visible:false,available:false,activatable:false,selected:false,blocked:false};}),d=definition(w.player),until=d&&read(w.player)[d.name];
 out.push(...require('./ship-abilities-expanded').timers(w,now));
 out.push(...require('./ship-abilities-expanded').resume(w,now));
 // Resume may restore a persistent toggle after a map reload.
 for(let i=0;i<out.length;i++)if(out[i]._==='MenuItemStatusCommand'&&require('./ship-abilities-expanded').recognizes(out[i].menuItemId))out[i]=require('./ship-abilities-expanded').status(w,out[i].menuItemId,templates.get(out[i].menuItemId),now)||out[i];
 if(until>now)out.push(timer(d,until,now));return out;
}
function effect(w,d,on,target){
 // Classic AbilityEffectActivation's default assembly has no classic cases.
 // SkillsAssembly's actual legacy branch instantiates AbilityNames effects.
 const p=w.player;send(w,{_:on?'AbilityStartCommand':'AbilityStopCommand',selectedAbilityId:d.id,activatorId:p.userId,...(on?{noStopCommand:!d.duration}:{targetIds:target?[target.id]:[]})});
 send(w,{_:'LegacyModule',message:on?`0|n|SD|A|${d.id}|${d.duration?1:2}|${p.userId}${target?'|'+target.id:''}`:`0|n|SD|D|${d.id}|${p.userId}${target?'|'+target.id:''}`});
}
function speed(w,run,on,now){
 require('./player-speed').set(w,'lightning',on?1.3:1,now);
}
function stop(w,{natural=false,now=Date.now()}={}){
 const expanded=require('./ship-abilities-expanded').stop(w,now),run=w.shipAbility;if(!run)return expanded;w.shipAbility=null;const p=w.player;
 if(!p||p!==run.player)return true;
 if(run.def.name==='lightning')speed(w,run,false,now);
 if(natural&&run.def.name==='diminisher'){
  // The FAQ describes a 30% own-shield drawback after the ability expires.
  // Its precise shield-pool semantics remain a documented local policy.
  p.shield=Math.round(p.shield*.7);send(w,{_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});
 }
 effect(w,run.def,false,run.target);send(w,menu(w,run.def,now));return true;
}
function action(session,cmd,now=Date.now()){
 if(require('./ship-abilities-expanded').recognizes(cmd.menuItemId))return require('./ship-abilities-expanded').action(session,cmd,now,templates.get(cmd.menuItemId));
 const w=session.world,p=w.player;
 if(!w.active(session)||p.dead||session.jumping||cmd.actionType!==1)return false;
 const d=definition(p);if(!d||d.menu!==cmd.menuItemId||w.shipAbility||now<(read(p)[d.name]||0))return false;
 let target;if(d.target){w.updatePosition(now);target=w.combat?.npcs.get(session.selected);if(!target||target.hp<=0||maps.nearStation(w))return false;w.combat.updateNpc(target,now);if(maps.dist(p,target)>(w.config.combat?.shipAbilities?.range??700))return false;}
 if(d.name==='venom'&&w.combat.npcProtected(target)){w.combat.missed(target.id,0);return false;}
 if(d.name==='solace'&&p.hitPoints>=p.hitMax)return false;
 const cfg=w.config.combat?.shipAbilities?.[d.name]||{},duration=cfg.durationMs??d.duration,cooldown=cfg.cooldownMs??d.cooldown;
 const until=now+Math.max(0,Math.round(cooldown*Math.max(.25,require('./boosters').abilityCooldownMultiplier(p.userId)-(p.stats.abilityCooldownReduction||0)))),cooldowns={...read(p),[d.name]:until};
 const healed=d.name==='solace'?Math.min(p.hitMax,p.hitPoints+Math.round(p.hitMax*.35)):p.hitPoints;
 tx(db=>{
  db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,KEY,JSON.stringify(cooldowns));
  if(d.name==='solace')db.prepare('UPDATE ships SET hitpoints=? WHERE id=? AND player_id=?').run(healed,p.shipId,p.userId);
 });
 const run={def:d,player:p,session,shipId:p.shipId,mapId:p.mapId,target,until:now+duration,nextTick:now+1000,ticks:0};
 if(duration)w.shipAbility=run;
 effect(w,d,true,target);send(w,timer(d,until,now));
 if(duration)send(w,{_:'MenuItemTimerCommand',menuItemId:d.menu,timerState:{_:'TimerStateModule',timerStateValue:1},time:duration,maxTime:duration,activatable:false});
 if(d.name==='solace'){p.hitPoints=healed;send(w,{_:'HitpointInfoCommand',hitpoints:p.hitPoints,hitpointsMax:p.hitMax,nanoHull:p.nanoHull||0,nanoHullMax:p.maxNanoHull||0});}
 if(d.name==='lightning')speed(w,run,true,now);
 send(w,menu(w,d,now));return true;
}
function tick(w,combat,now=Date.now()){
 require('./ship-abilities-expanded').tick(w,combat,now,templates);
 const r=w.shipAbility,p=w.player;
 if(r){
  if(!p||p!==r.player||p.dead||!w.active(r.session)||r.session.jumping||p.shipId!==r.shipId||p.mapId!==r.mapId||definition(p)!==r.def)return stop(w,{now});
  if(r.target&&(combat.npcs.get(r.target.id)!==r.target||r.target.hp<=0||maps.dist(p,r.target)>(w.config.combat?.shipAbilities?.breakRange??1500)))return stop(w,{now});
  if(r.def.name==='venom'&&combat.npcProtected(r.target)){r.nextTick=now+1000;combat.missed(r.target.id,0);if(now>=r.until)stop(w,{natural:true,now});return;}
  if(r.def.name==='venom')while(r.nextTick<=now&&r.nextTick<=r.until){
   const damage=Math.min(8500,1500+200*r.ticks++);r.nextTick+=1000;
   const previousHp=r.target.hp;
   r.target.hp=Math.max(0,r.target.hp-damage);r.target.lastHit=now;r.target.aggro=r.session;p.lastCombat=now;
   if(r.target.hp<=0){
    try{combat.kill(r.session,r.target,()=>combat.hit(p.userId,r.target.id,r.target,damage,0));}
    catch(error){r.target.hp=previousHp;r.nextTick-=1000;r.ticks--;throw error;}
    stop(w,{now});return;
   }
   combat.hit(p.userId,r.target.id,r.target,damage,0);
  }
  if(now>=r.until)return stop(w,{natural:true,now});
  if(r.def.name==='lightning')speed(w,r,true,now);
 }
 // Send a single ready update when a persisted cooldown crosses its deadline.
 if(!p)return;const signature=DEFINITIONS.map(d=>`${d.name}:${now<(read(p)[d.name]||0)}`).join(',')+':'+(w.shipAbility?.def.name||'')+':'+p.shipId;
 if(w.shipAbilityMenuSignature!==signature){w.shipAbilityMenuSignature=signature;for(const d of DEFINITIONS)send(w,menu(w,d,now));}
}
function outgoing(w,damage){return require('./ship-abilities-expanded').outgoing(w,Math.round(damage*(w.shipAbility?.def.name==='spectrum'?.75:1)));}
function shieldBonus(w,target){return w.shipAbility?.def.name==='diminisher'&&w.shipAbility.target===target?1.5:1;}
function incoming(w,state,damage,absorb,attackType=1,now=Date.now()){
 damage=require('./ship-abilities-expanded').incoming(w,damage,attackType);
 if(attackType===1&&w.shipAbility?.def.name==='spectrum')damage=Math.round(damage*.1);
 const shieldPart=Math.min(state.shield,Math.round(damage*Math.max(0,Math.min(1,absorb||0)))),factor=attackType===1&&w.shipAbility?.def.name==='sentinel'?.7:1;
 state.shield-=Math.round(shieldPart*factor);const hull=damage-shieldPart,redirected=require('./pet-link').redirect(w,hull,now);require('./nano-hull').damageHull(state,hull-redirected);return Math.round(hull-redirected+shieldPart*factor);
}
module.exports={DEFINITIONS,definition,recognizes,buildInit,action,tick,stop,outgoing,shieldBonus,incoming};
