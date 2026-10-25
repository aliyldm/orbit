'use strict';
// Actual client menu/visual contracts; solo NPC area effects are an explicit
// local extension because the source mine text describes player-vs-player use.
const crypto=require('crypto'),{open,tx}=require('./db'),inventory=require('./inventory'),maps=require('./maps');
const KEY='game.utilityCooldowns';
const ISH='equipment_extra_cpu_ish-01',SMBCPU='equipment_extra_cpu_smb-01',SMB='ammunition_mine_smb-01',EMP='ammunition_specialammo_emp-01';
const MINES={
 'ammunition_mine_acm-01':{type:1,kind:'normal'},
 'ammunition_mine_empm-01':{type:2,kind:'emp'},
 'ammunition_mine_sabm-01':{type:3,kind:'shield'},
 'ammunition_mine_ddm-01':{type:4,kind:'direct'},
 'ammunition_mine_slm-01':{type:7,kind:'slow'}
};
const TEMPLATES=new Map();(function walk(v){if(!v||typeof v!=='object')return;if(v._==='MenuItemStatusCommand')TEMPLATES.set(v.menuItemId,v);for(const x of Object.values(v))if(x&&typeof x==='object')walk(x);})(require('./templates/init.json'));
function cooldowns(p){if(!p.utilityCooldowns){try{p.utilityCooldowns=JSON.parse(open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,KEY)?.value||'{}');}catch{p.utilityCooldowns={};}}return p.utilityCooldowns;}
function count(p,id){return open().prepare('SELECT COALESCE(SUM(amount),0)n FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').get(p.userId,id).n;}
function cpu(p,id){return inventory.equipped(open(),p.shipId,inventory.activeConfig(open(),p.shipId)).some(i=>i.slot==='extra'&&i.loot_id===id);}
function send(w,cmd){const fn=w.combat?.send||require('./net').sendCmd;w.broadcast(s=>fn(s,cmd));}
function consume(db,p,id,amount){
 const rows=db.prepare('SELECT id,amount FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id').all(p.userId,id);
 if(rows.reduce((n,r)=>n+r.amount,0)<amount)throw new Error('Yetersiz cephane.');
 let left=amount;for(const row of rows){const n=Math.min(left,row.amount);db.prepare('UPDATE items SET amount=amount-? WHERE id=?').run(n,row.id);left-=n;if(!left)break;}
}
function commit(w,group,cost,now){
 const p=w.player,config=w.config.combat?.utilities||{},times={mine:config.mineCooldownMs??30000,smartbomb:config.smartbombCooldownMs??30000,instashield:config.instashieldCooldownMs??30000,emp:config.empCooldownMs??40000};
 times.mine=Math.round(times.mine*require('./cpu').mineCooldownMultiplier(p)*(p.stats.droneDesigns?.mineCooldown??1));times.smartbomb=Math.round(times.smartbomb*require('./cpu').mineCooldownMultiplier(p));
 const previous=cooldowns(p);if(now<(previous[group]||0))return false;
 const next={...previous,[group]:now+times[group]};
 tx(db=>{for(const [id,n]of Object.entries(cost.items||{}))consume(db,p,id,n);if(cost.xenomit&&!db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=3 AND amount>=?').run(cost.xenomit,p.userId,cost.xenomit).changes)throw new Error('Yetersiz Xenomit.');db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,KEY,JSON.stringify(next));});
 p.utilityCooldowns=next;
 const type={mine:1,smartbomb:2,instashield:3,emp:9}[group];send(w,{_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:type},maxTime:times[group],time:times[group]});
 for(const c of require('./ammo').buildAmmoCommands(p))send(w,c);
 if(cost.xenomit)for(const c of require('./collectables').resourceCommands(p))send(w,c);
 return true;
}
function mineCommand(m){return{_:'AddMineCommand',hash:m.hash,x:m.x,y:m.y,typeId:m.type,maxSkill1:m.radiusSkill,maxSkill5b:m.damageSkill};}
function buildInit(world){
 const p=world.player;if(!p)return[];const now=Date.now(),out=[];
 for(const mine of world.utilityMines?.values()||[])out.push(mineCommand(mine));
 const enabled={[ISH]:cpu(p,ISH),[SMB]:count(p,SMB)>0||cpu(p,SMBCPU),[EMP]:count(p,EMP)>0};
 for(const [id,available]of Object.entries(enabled)){const t=TEMPLATES.get(id);if(t)out.push({...JSON.parse(JSON.stringify(t)),available,activatable:available,blocked:false,counterValue:id===ISH?0:count(p,id)});}
 for(const [group,until]of Object.entries(cooldowns(p))){if(until>now)out.push({_:'MenuItemCooldownGroupTimerCommand',timerState:{_:'TimerStateModule',timerStateValue:2},cooldownType:{_:'CooldownTypeModule',typeValue:{mine:1,smartbomb:2,instashield:3,emp:9}[group]},maxTime:until-now,time:until-now});}
 return out;
}
function recognizes(id){return !!MINES[id]||id===SMB||id===ISH||id===EMP;}
function breakLock(world,npc){
 if(!npc.aggro)return;npc.aggro=null;npc.petAggro=null;send(world,{_:'AttackAbortLaserCommand',uid:npc.id});
}
function applyBlast(world,combat,origin,kind,radius,now,session,{mine=true}={}){
 const p=world.player,e=p.stats.skills||{},mult=mine?(e.mineDamageMultiplier??1)*(p.stats.formation?.mine??1):1;
 for(const npc of [...combat.npcs.values()]){
  combat.updateNpc(npc,now);if(maps.dist(origin,npc)>radius)continue;
  if(combat.npcProtected(npc)){combat.missed(npc.id,2);continue;}
  let damage=0;
  if(kind==='emp'){breakLock(world,npc);continue;}
  if(kind==='slow'){
   const target=npc.movement; npc.slowUntil=now+5000;
   if(target)combat.moveNpc(npc,target.targetX,target.targetY,now);continue;
  }
  if(kind==='shield'){damage=Math.round(npc.shield*.5);npc.shield-=damage;}
  else{damage=Math.round(npc.def.hitpoints*.2*mult);if(kind==='direct')npc.hp=Math.max(0,npc.hp-damage);else combat.applyDamage(npc,damage,combat.npcAbsorb(npc));}
  npc.lastHit=now;npc.aggro=session;if(damage>0)combat.hit(p.userId,npc.id,npc,damage,2);else combat.missed(npc.id,2);if(npc.hp<=0)combat.kill(session,npc);
 }
}
function action(session,cmd,now=Date.now()){
 const w=session.world,p=w.updatePosition(),combat=w.combat;
 if(!w.active(session)||p.dead||session.jumping||!combat)return false;
 const id=cmd.menuItemId;if(cmd.actionType!==1)return false;
 const cfg=w.config.combat?.utilities||{};
 if(id===ISH){
  if(!cpu(p,ISH))return false;
  if(!commit(w,'instashield',{items:{'ammunition_mine_acm-01':10},xenomit:100},now))return false;
  p.invulnerableUntil=now+3000;send(w,{_:'LegacyModule',message:`0|n|ISH|${p.userId}`});return true;
 }
 if(maps.nearPeaceArea(w))return false;
 if(id===EMP){
  if(!commit(w,'emp',{items:{[EMP]:1}},now))return false;
  require('./npc-special-attacks').clearSlow(w,now);
  combat.abort(session);session.selected=null;send(w,{_:'ShipDeselectionCommand'});send(w,{_:'LegacyModule',message:`0|n|EMP|${p.userId}`});
  applyBlast(w,combat,p,'emp',cfg.empRadius??1000,now,session);return true;
 }
 if(id===SMB){
  let cost;if(count(p,SMB)>0)cost={items:{[SMB]:1}};else if(cpu(p,SMBCPU))cost={items:{'ammunition_mine_acm-01':10},xenomit:100};else return false;
  if(!commit(w,'smartbomb',cost,now))return false;
  require('./respawn').breakProtection(w);
  send(w,{_:'LegacyModule',message:`0|n|SMB|${p.userId}`});applyBlast(w,combat,p,'normal',cfg.smartbombRadius??500,now,session,{mine:false});return true;
 }
 const type=MINES[id];if(!type)return false;
 w.utilityMines||=new Map();if(w.utilityMines.size>=20)return false;
 if(!commit(w,'mine',{items:{[id]:1}},now))return false;
 require('./respawn').breakProtection(w);
 const m={...type,hash:crypto.randomBytes(12).toString('hex'),x:Math.round(p.x),y:Math.round(p.y),mapId:p.mapId,armed:now+(cfg.mineArmingMs??1000),expires:now+(cfg.mineLifetimeMs??120000),radius:(cfg.mineRadius??250)*(p.stats.skills?.mineRadiusMultiplier??1),owner:p.userId,radiusSkill:(p.stats.skills?.mineRadiusMultiplier??1)>=1.25,damageSkill:(p.stats.skills?.mineDamageMultiplier??1)>=1.5};
 w.utilityMines.set(m.hash,m);send(w,mineCommand(m));return true;
}
function tick(world,combat,now=Date.now()){
 const p=world.player;if(!p)return;
 for(const npc of combat.npcs.values()){if(npc.slowUntil&&npc.slowUntil<=now){npc.slowUntil=0;const m=npc.movement;if(m)combat.moveNpc(npc,m.targetX,m.targetY,now);}}
 const session=[...world.sessions][0];if(!session)return;
 for(const m of world.utilityMines?.values()||[]){
  if(m.mapId!==p.mapId||now>=m.expires){world.utilityMines.delete(m.hash);send(world,{_:'RemoveMineCommand',hash:m.hash});continue;}
  if(p.dead||now<m.armed)continue;
  if([...combat.npcs.values()].some(n=>maps.dist(n,m)<=m.radius)){
   world.utilityMines.delete(m.hash);send(world,{_:'LegacyModule',message:`0|LM|ST|MIN|${m.hash}`});applyBlast(world,combat,m,m.kind,m.radius,now,session);
  }
 }
}
function protectedNow(world,now=Date.now()){return !!world.player&&now<(world.player.invulnerableUntil||0);}
function stop(world){world.utilityMines?.clear();world.utilityMines=null;}
module.exports={ISH,SMB,SMBCPU,EMP,MINES,cooldowns,count,cpu,buildInit,recognizes,action,tick,protectedNow,stop};
