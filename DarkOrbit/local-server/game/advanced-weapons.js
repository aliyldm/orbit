'use strict';
// Source-backed base equipment + documented solo rules where private formulas
// aren't supplied by the client/FAQ. Never alias these weapons to normal lasers.
const {open,tx}=require('./db'),inventory=require('./inventory'),maps=require('./maps'),META=require('../docs/client-map.items.json').items;
const UPGRADE=require('./modern-lasers').upgraded,KEY='game.advancedWeapons';
const SR5='ammunition_specialammo_sr-5',K300M='ammunition_specialammo_k-300m';
const DEBUFF={'ammunition_specialammo_pld-8':{key:'pld',field:'pldUntil',group:7,visual:5},'ammunition_specialammo_dcr-250':{key:'dcr',field:'dcrUntil',group:8,visual:10}};
const SLUG=/^ammunition_slug_(ths|cos|els)-(?:[dcba])0([1234])$/;
const SPOOL={'ammunition_spool_gsp-30':1,'ammunition_spool_gsp-75':2,'ammunition_spool_gsp-150':3,'ammunition_spool_gsp-300':4};
const TYPES={ths:0,cos:1,els:2},NAMES=['helios','nidhogg','indra'];
function eq(p,slot){return inventory.equipped(open(),p.shipId,inventory.activeConfig(open(),p.shipId)).filter(i=>i.slot===slot&&i.amount>0);}
function state(p){if(!p.advancedWeapons){try{p.advancedWeapons=JSON.parse(open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,KEY)?.value||'{}');}catch{p.advancedWeapons={};}}return p.advancedWeapons;}
function save(p,s,db=open(),publish=true){db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,KEY,JSON.stringify(s));if(publish)p.advancedWeapons=s;}
function send(w,c){w.broadcast(s=>(w.combat?.send||require('./net').sendCmd)(s,c));}
function count(p,id){return require('./ammo').count(p,id);}
function consume(db,p,id,amount){const rows=db.prepare('SELECT id,amount FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id').all(p.userId,id);if(rows.reduce((n,r)=>n+r.amount,0)<amount)return false;let left=amount;for(const row of rows){const n=Math.min(left,row.amount);db.prepare('UPDATE items SET amount=amount-? WHERE id=?').run(n,row.id);left-=n;if(!left)break;}return true;}
function cooldown(w,group,type,ms,now,id,amount){const p=w.player,s=state(p);if(now<(s[group]||0))return false;const next={...s,[group]:now+ms};const ok=tx(db=>{if(!consume(db,p,id,amount))return false;save(p,next,db,false);return true;});if(!ok)return false;p.advancedWeapons=next;
 send(w,{_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:type},maxTime:ms,time:ms});require('./ammo').notify(p,{world:w,sendCmd:w.combat?.send});require('./cpu').breakCloak(w);p.lastCombat=now;p.repairing=false;return true;}
function cannonType(id){return NAMES.findIndex(name=>id.includes('-'+name));}
function cannon(p,type){return eq(p,'cannon').find(i=>cannonType(i.loot_id)===type);}
function defenseDamage(damage,defense,penetration=0){return Math.max(0,Math.round(damage*1000/(1000+Math.max(0,(defense||0)-(penetration||0)))));}
function driveStats(p,distance=0){const drives=eq(p,'drive'),apex=drives.filter(i=>i.loot_id.endsWith('igd-l02')).length,prime=drives.filter(i=>i.loot_id.endsWith('igd-p')).length;const bonus=n=>n>=8?1.5:n>=7?1.4:n>=5?1.3:n===4?1.2:n===3?1.1:1,eligible=drives.filter(i=>distance<=600||i.loot_id.endsWith('igd-p')&&prime>=6&&distance<=900);
 return{count:eligible.length,range:prime>=6?900:600,damage:eligible.reduce((n,i)=>n+UPGRADE({...i,damage:META[i.loot_id]?.damage||0})*(i.loot_id.endsWith('igd-p')?bonus(prime):i.loot_id.endsWith('igd-l02')?bonus(apex):1),0)};}
function recognizes(id){return id===SR5||id===K300M||!!DEBUFF[id]||!!SPOOL[id]||SLUG.test(id);}
function menuStatus(p,c){const id=c.menuItemId;if(!recognizes(id))return c;const n=count(p,id),slug=SLUG.exec(id),hardware=slug?!!cannon(p,TYPES[slug[1]]):SPOOL[id]?driveStats(p).count>0:true;return{...c,available:n>0&&hardware,activatable:n>0&&hardware,counterValue:n,selected:!!SPOOL[id]?id===(state(p).spool||'ammunition_spool_gsp-30'):slug?id===(state(p).slug||'ammunition_slug_ths-d01'):false};}
function target(s,range){const w=s.world,p=w.updatePosition(),combat=w.combat,npc=combat?.npcs.get(s.selected);if(!w.active(s)||p.dead||s.jumping||!npc||npc.hp<=0||maps.nearPeaceArea(w)||combat.npcProtected(npc))return null;combat.updateNpc(npc);if(maps.dist(p,npc)>range)return null;return npc;}
function action(s,c,now=Date.now()){
 const id=c.menuItemId;if(!recognizes(id)||!s.world.active(s)||s.world.player.dead||s.jumping)return false;
 const p=s.world.player,slug=SLUG.exec(id);if(slug||SPOOL[id]){if(!menuStatus(p,c).available)return false;save(p,{...state(p),[slug?'slug':'spool']:id});if(c.actionType!==1){require('./ammo').notify(p,{world:s.world,sendCmd:s.world.combat?.send});return true;}return slug?fireCannon(s,id,now):fireDrive(s,id,now);}
 if(c.actionType!==1)return false;return specialRocket(s,id,now);
}
function apply(w,combat,s,npc,damage,type,cannonType=0){if(combat.npcs.get(npc.id)!==npc||npc.hp<=0||combat.npcProtected(npc))return 0;const actual=Math.min(npc.hp+Math.min(npc.shield,Math.round(damage*combat.npcAbsorb(npc))),damage);combat.applyDamage(npc,damage,combat.npcAbsorb(npc));npc.lastHit=Date.now();npc.aggro=s;
 send(w,{_:'AttackHitCommand',attackType:{_:'AttackTypeModule',attackTypeValue:type},attackerId:w.player.userId,victimId:npc.id,victimHitpoints:Math.round(npc.hp),victimShield:Math.round(npc.shield),victimNanoHull:0,damage:Math.round(actual),skilled:false,strike:false,cannonType});if(npc.hp<=0)combat.kill(s,npc);return actual;}
function fireCannon(s,id=state(s.world.player).slug||'ammunition_slug_ths-d01',now=Date.now()){
 const match=SLUG.exec(id);if(!match)return false;const w=s.world,p=w.player,combat=w.combat,type=TYPES[match[1]],item=cannon(p,type),npc=item&&target(s,600);if(!npc)return false;
 if(!cooldown(w,'cannon',60,4000,now,id,1))return false;
 const hit=combat.rollHit(.8),crit=Math.random()<.1,shipId=open().prepare('SELECT loot_id FROM ships WHERE id=?').get(p.shipId)?.loot_id;
 const suffix=item.loot_id.slice('equipment_weapon_cannon_'.length).replace(/^(?:c|uc|r|ep|ma|leg|ul)-(?:helios|nidhogg|indra)-?/,'');
 const shipBonus=META[item.loot_id]?.cannonDamageOfShip||0,exclusive=suffix?shipId==='ship_'+suffix:false;
 let damage=UPGRADE({...item,damage:META[item.loot_id]?.damage||0})*Number(match[2])*(exclusive?1+shipBonus:1)*(.75+Math.random()*.25)*(crit?1.15:1);
 if(type===1&&npc.corrosion?.until>now)damage*=1+.05*npc.corrosion.stacks;
 combat.broadcast({_:'CannonAttackCommand',cannonType:type,hit,attackerId:p.userId,attackedId:npc.id});
 combat.scheduleImpact(s,npc,()=>{if(!hit){combat.missed(npc.id,21);return;}const origin={x:npc.x,y:npc.y},splash=type===0?[...combat.npcs.values()].filter(n=>n!==npc&&n.hp>0&&maps.dist(n,origin)<=275).sort((a,b)=>maps.dist(a,origin)-maps.dist(b,origin)).slice(0,5):[];
 if(type===1){const current=npc.corrosion?.until>Date.now()?npc.corrosion.stacks:0;npc.corrosion={stacks:Math.min(5,current+1),until:Date.now()+20000};send(w,{_:'VisualModifierCommand',userId:npc.id,modifier:146,attribute:0,additionalAttribute:'',count:npc.corrosion.stacks,activated:true});}
 const chain=[];if(type===2){const visited=new Set([npc.id]);let current=npc;for(let index=0;index<6;index++){const next=[...combat.npcs.values()].filter(n=>!visited.has(n.id)&&n.hp>0&&!combat.npcProtected(n)&&maps.dist(n,current)<=275).sort((a,b)=>maps.dist(a,current)-maps.dist(b,current))[0];if(!next)break;visited.add(next.id);chain.push(next);current=next;}}
 const dealt=(n,m=1)=>defenseDamage(damage*m,n.def.cannonDefense?.[['t','c','e'][type]]||0);
 apply(w,combat,s,npc,dealt(npc),21,type);for(const n of splash)apply(w,combat,s,n,dealt(n,.4),21,type);for(const [index,n]of chain.entries()){send(w,{_:'PlayVisualEffectCommand',visualEffect:9,activatorId:index?chain[index-1].id:npc.id,targetIds:[n.id]});apply(w,combat,s,n,dealt(n,Math.pow(.85,index+1)),21,type);}
 });return true;
}
function fireDrive(s,id=state(s.world.player).spool||'ammunition_spool_gsp-30',now=Date.now()){
 const mult=SPOOL[id];if(!mult)return false;const w=s.world,p=w.player,combat=w.combat,hardware=driveStats(p),npc=hardware.count&&target(s,hardware.range);if(!npc)return false;const stats=driveStats(p,maps.dist(p,npc));
 if(!cooldown(w,'drive',61,w.config.combat?.driveCooldownMs??12000,now,id,stats.count))return false;
 const hit=combat.rollHit(.85),origin={x:npc.x,y:npc.y},damage=stats.damage*mult;
 send(w,{_:'PlayVisualEffectCommand',visualEffect:17,activatorId:p.userId,targetIds:[npc.id]});
 // The source defines a stationary 8s zone but not its tick rate. Local: one
 // pulse per second (8 pulses), with the opening hit rolled once per cast.
 if(hit)(w.driveAreas||=[]).push({origin,damage,s,mapId:p.mapId,epoch:w.epoch,next:now+1000,until:now+8000});else combat.missed(npc.id,22);
 return true;
}
function specialRocket(s,id,now=Date.now()){
 if(DEBUFF[id])return debuffRocket(s,id,now);
 const w=s.world,p=w.player,combat=w.combat,npc=target(s,525);if(!npc)return false;const sr=id===SR5,ms=sr?240000:15000;
 if(!cooldown(w,sr?'sr5':'k300m',sr?14:15,ms,now,id,1))return false;
 const hit=sr||combat.rollHit(.75);if(sr){p.sr5SlowUntil=now+3000;require('./player-speed').set(w,'sr5',.75,now);send(w,{_:'PlayVisualEffectCommand',visualEffect:7,activatorId:p.userId,targetIds:[npc.id]});}
 else combat.broadcast({_:'LegacyModule',message:`0|v|${p.userId}|${npc.id}|${hit?'H':'M'}|4|0|0`});
 combat.scheduleImpact(s,npc,()=>{if(!hit||combat.npcProtected(npc)){combat.missed(npc.id,0);return;}if(sr){const drained=Math.min(npc.shield,80000);npc.shield-=drained;p.shield=Math.min(p.shieldMax,p.shield+Math.round(drained*.5));npc.lastHit=Date.now();npc.aggro=s;combat.hit(p.userId,npc.id,npc,drained,0);send(w,{_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});}else{const move=npc.movement;npc.k300mUntil=Date.now()+2000;if(move)combat.moveNpc(npc,move.targetX,move.targetY);apply(w,combat,s,npc,Math.round(12000*(p.stats.rocketMultiplier||1)),0);}});return true;
}
function debuffRocket(s,id,now){const d=DEBUFF[id],w=s.world,p=w.player,combat=w.combat,npc=target(s,525);if(!npc)return false;const ms=w.config.combat?.[d.key+'CooldownMs']??30000;
 if(!cooldown(w,d.key,d.group,ms,now,id,1))return false;const hit=combat.rollHit(w.config.combat?.specialRocketHitChance??1);combat.broadcast({_:'LegacyModule',message:`0|v|${p.userId}|${npc.id}|${hit?'H':'M'}|${d.visual}|0|0`});
 combat.scheduleImpact(s,npc,()=>{if(!hit||combat.npcProtected(npc)){combat.missed(npc.id,0);return;}const move=npc.movement;npc[d.field]=Date.now()+5000;npc.lastHit=Date.now();npc.aggro=s;if(move&&d.key==='dcr')combat.moveNpc(npc,move.targetX,move.targetY);});return true;}
function tick(w,combat,now=Date.now()){
 const p=w.player;if(p.sr5SlowUntil&&now>=p.sr5SlowUntil){delete p.sr5SlowUntil;require('./player-speed').set(w,'sr5',null,now);}
 for(const n of combat.npcs.values())if(n.corrosion?.until<=now){delete n.corrosion;send(w,{_:'VisualModifierCommand',userId:n.id,modifier:146,attribute:0,additionalAttribute:'',count:0,activated:false});}
 for(const n of combat.npcs.values())for(const field of ['dcrUntil','k300mUntil'])if(n[field]&&n[field]<=now){delete n[field];const move=n.movement;if(move)combat.moveNpc(n,move.targetX,move.targetY,now);}
 for(const area of w.driveAreas||[]){
  if(area.epoch!==w.epoch||area.mapId!==p.mapId||p.dead||!w.active(area.s)){area.until=0;continue;}
  while(area.next<=now&&area.next<=area.until){for(const npc of [...combat.npcs.values()]){combat.updateNpc(npc,area.next);if(npc.hp>0&&maps.dist(npc,area.origin)<=150)apply(w,combat,area.s,npc,defenseDamage(area.damage,npc.def.driveDefense||0),22);}area.next+=1000;}
 }
 w.driveAreas=(w.driveAreas||[]).filter(a=>a.until>now);
}
function stop(w){w.driveAreas=[];if(w.player){delete w.player.sr5SlowUntil;require('./player-speed').set(w,'sr5',null);require('./modern-lasers').reset(w.player);}}
function buildInit(w){const p=w.player,s=state(p),now=Date.now();return[['cannon',60],['drive',61],['sr5',14],['k300m',15],['pld',7],['dcr',8]].filter(([key])=>s[key]>now).map(([key,type])=>({_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:type},maxTime:s[key]-now,time:s[key]-now}));}
module.exports={SR5,K300M,DEBUFF,SPOOL,SLUG,recognizes,action,menuStatus,fireCannon,fireDrive,specialRocket,driveStats,defenseDamage,cannonType,state,eq,buildInit,tick,stop};
