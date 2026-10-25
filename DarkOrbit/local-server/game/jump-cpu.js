'use strict';
const {open,tx}=require('./db'),maps=require('./maps'),cpu=require('./cpu');
const AJP='ajp-01',VOUCHER='resource_jumpvoucher',CAST_MS=10000,COOLDOWN_MS=90000,QUIET_MS=20000,deliveredVouchers=new WeakMap();
function emit(s,c){(s.world.combat?.send||require('./net').sendCmd)(s,c);}
function send(s,message){(s.world.combat?.send||require('./net').sendCmd)(s,{_:'LegacyModule',message});}
function normal(id){const m=require('./normal-map-layout').getMap(id);return m&&!m.name.startsWith('5-')?m:null;}
function access(p,m){if(!normal(m?.id)||m.id===p.mapId||m.is_start&&m.faction_id!==p.factionId)return false;return p.level>=require('./normal-map-layout').accessLevel(m.id,p.factionId);}
function destinations(p){return open().prepare('SELECT * FROM maps ORDER BY id').all().filter(m=>normal(m.id));}
function distance(from,to,p){const queue=[[from,0]],seen=new Set([from]);while(queue.length){const [id,n]=queue.shift();if(id===to)return n;for(const g of maps.portals(id,p.factionId)){if(normal(g.target_map)&&!seen.has(g.target_map)){seen.add(g.target_map);queue.push([g.target_map,n+1]);}}}return 10;}
// The original price-chart images are not available as server data. This is a
// deliberately named local tariff, never a claim of exact live-server pricing.
function price(p,id){return 100*distance(p.mapId,id,p);}
function ready(s,now=Date.now()){const w=s.world,p=w.player;return w.active(s)&&!p.dead&&!s.jumping&&!s.cpuJump&&!s.shipWarp&&normal(p.mapId)&&now-(p.lastCombat||0)>=QUIET_MS&&!s.attacking&&now>=(cpu.read(p).jumpUntil||0);}
function failure(s,key){send(s,`0|A|STD|${key}`);return false;}
function voucherCount(p,db=open()){return Math.max(0,db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0').get(p.userId,VOUCHER).n);}
function voucherCommand(p){const n=voucherCount(p);deliveredVouchers.set(p,n);return{_:'LegacyModule',message:`0|A|JV|${n}`};}
function listCommand(p){
 if(!normal(p.mapId))return{_:'LegacyModule',message:'0|A|JCPU|I'};
 const grouped=new Map(),locked=[],poor=[],free=voucherCount(p)>0;for(const m of destinations(p)){if(!access(p,m)){locked.push(m.id);continue;}const cost=price(p,m.id);if(!free&&cost>p.uridium)poor.push(m.id);else{if(!grouped.has(cost))grouped.set(cost,[]);grouped.get(cost).push(m.id);}}
 const fields=['0','A','JCPU','I','-1',locked.join(';')+';','-2',poor.join(';')+';'];for(const [cost,ids]of grouped)fields.push(String(cost),ids.join(';')+';');return{_:'LegacyModule',message:fields.join('|')};
}
function initialCommands(p){return[voucherCommand(p),...(cpu.has(p,AJP)?[listCommand(p)]:[])];}
function list(s){const p=s.world.player;if(!s.world.active(s)||p.dead||!cpu.has(p,AJP))return false;for(const c of initialCommands(p))emit(s,c);return true;}
function select(s,id){const p=s.world.player,m=maps.getMap(Number(id));if(!s.world.active(s)||p.dead||!cpu.has(p,AJP))return false;
 emit(s,voucherCommand(p));if(!normal(p.mapId)||!access(p,m)){delete s.cpuJumpTarget;send(s,`0|A|JCPU|C|${Number(id)||0}|0|0`);return false;}
 s.cpuJumpTarget=m.id;const cost=price(p,m.id);send(s,`0|A|JCPU|C|${m.id}|${cost}|${voucherCount(p)>0||cost<=p.uridium?1:0}`);return true;}
function targetLocation(m){return {x:Math.round(1000+Math.random()*Math.max(0,m.width-2000)),y:Math.round(1000+Math.random()*Math.max(0,m.height-2000))};}
function begin(s,target,{item=null,cost=0,useVoucher=false,cast=CAST_MS,now=Date.now()}={}){
 const w=s.world,p=w.updatePosition();if(!ready(s,now)||w.movement)return failure(s,'jump_cpu_failed_attack');
 const start={x:p.x,y:p.y,map:p.mapId,combat:p.lastCombat||0,requested:now,target,item,cost,useVoucher};s.cpuJump=start;
 if(cast)send(s,`0|A|JCPU|S|${cast/1000}|${cost}`);
 const complete=()=>{if(s.cpuJump!==start)return false;s.cpuJump=null;send(s,'0|A|JCPU|S|-1|0');
  if(!w.active(s)||p.dead||p.mapId!==start.map||w.movement||maps.dist(p,start)>1||(p.lastCombat||0)>start.combat||s.attacking)return false;
  if(item&&!cpu.equipment(p).some(i=>i.id===item.id)||!item&&!cpu.has(p,AJP))return false;
  const m=maps.getMap(target);if(!m||!item&&!access(p,m))return false;
  const old=cpu.read(p);const ok=tx(db=>{if((cpu.read(p).jumpUntil||0)>Date.now())return false;if(item&&!cpu.consume(item,db))return false;
   if(useVoucher){const row=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id LIMIT 1').get(p.userId,VOUCHER);if(!row||!db.prepare('UPDATE items SET amount=amount-1 WHERE id=? AND amount>0').run(row.id).changes)throw Error('Atlama kuponu kalmadı.');}
   db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits,p.uridium,p.userId);
   if(cost&&!db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(cost,p.userId,cost).changes)throw new Error('Yetersiz Uridyum');
   cpu.write(p,{...old,jumpUntil:Date.now()+COOLDOWN_MS},db);return true;});if(!ok)return false;
  p.uridium-=cost;const xy=item?{x:m.start_x,y:m.start_y}:targetLocation(m);w.combat?.cancelProjectiles();w.combat?.abort(s);s.jumping=true;
  const moved=require('./gameplay').changeMap(s,m.id,xy.x,xy.y);cpu.notify(w);emit(s,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});return moved;
 };
 if(!cast)return complete();w.schedule(()=>{try{complete();}catch(error){failure(s,error.message);}},cast);return true;
}
function home(s){const p=s.world.player,item=cpu.charged(p,['jp-02','jp-01']);if(!item)return false;const m=maps.getMap(p.mapId),lower=item.loot_id.endsWith('01');
 if(!normal(m?.id)||lower&&(!/^[123]-[1-4]$/.test(m.name)))return failure(s,'jump_cpu_failed_map');const target=maps.home(s.world);if(!target||target.id===p.mapId)return false;return begin(s,target.id,{item,cast:0});}
function jump(s){const p=s.world.player,id=s.cpuJumpTarget,m=maps.getMap(id);if(!cpu.has(p,AJP)||!normal(p.mapId)||!access(p,m))return false;const useVoucher=voucherCount(p)>0,cost=useVoucher?0:price(p,id);if(p.uridium<cost)return failure(s,'jump_cpu_failed_uridium');return begin(s,id,{cost,useVoucher});}
function tick(w,now=Date.now()){const p=w.player;if(!p)return;let n,changed=false;if(now>=(w.jumpVoucherNext||0)){w.jumpVoucherNext=now+1000;n=voucherCount(p);changed=deliveredVouchers.get(p)!==n;if(changed)deliveredVouchers.set(p,n);}
 for(const s of w.sessions){if(changed){send(s,`0|A|JV|${n}`);if(cpu.has(p,AJP)){emit(s,listCommand(p));if(s.cpuJumpTarget)select(s,s.cpuJumpTarget);}}const job=s.cpuJump;if(!job)continue;w.updatePosition();if(p.dead||w.movement||p.mapId!==job.map||maps.dist(p,job)>1||(p.lastCombat||0)>job.combat||s.attacking){s.cpuJump=null;send(s,'0|A|JCPU|S|-1|0');}}}
function legacy(s,message){const parts=String(message).split('|');if(parts[0]==='0')parts.shift();if(parts[0]!=='JCPU')return false;if(parts[1]==='GET')return list(s);if(parts[1]==='S')return select(s,Number(parts[2]));if(parts[1]==='J')return jump(s);return false;}
module.exports={VOUCHER,CAST_MS,COOLDOWN_MS,QUIET_MS,normal,access,price,distance,voucherCount,initialCommands,list,select,home,jump,begin,tick,legacy};
