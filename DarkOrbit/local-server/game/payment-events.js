'use strict';
// Native pass packet shapes are recovered from the supplied SWF. The permanent
// local season and classic-GG event bridge are explicitly local rules.
const META=require('../docs/client-map.items.json').items;
const {id}=require('./payment-bundles');
const PASSES={gold:'resource_gold-pass',extra:'resource_ext-gold-pass',trinity:'resource_trinity-vip-badge',voyagers:'resource_voyagers-vip-badge',battlepass:'resource_battle-pass'};
const SEASON='Yerel Sezon — kalıcı',MAX=90,POINTS_PER_LEVEL=100,LEVEL_PRICE=10000;
const MISSIONS=[
 {key:'daily-npcs',label:'Günlük: 20 NPC yok et',event:'npcKill',goal:20,points:50,period:'daily'},
 {key:'daily-boxes',label:'Günlük: 10 bonus kutusu topla',event:'collectLoot',lootId:'bonus_box',goal:10,points:40,period:'daily'},
 {key:'weekly-npcs',label:'Haftalık: 200 NPC yok et',event:'npcKill',goal:200,points:200,period:'weekly'},
 {key:'weekly-gates',label:'Haftalık: 3 klasik galaksi kapısı tamamla',event:'gateComplete',goal:3,points:300,period:'weekly'},
 {key:'season-npcs',label:'Sezon: 2.000 NPC yok et',event:'npcKill',goal:2000,points:1500,period:'season'},
 {key:'season-gates',label:'Sezon: 20 klasik galaksi kapısı tamamla',event:'gateComplete',goal:20,points:2000,period:'season'}
];
function atomic(db,fn){db.exec('SAVEPOINT payment_events');try{const r=fn();db.exec('RELEASE payment_events');return r;}catch(e){db.exec('ROLLBACK TO payment_events; RELEASE payment_events');throw e;}}
function account(db,playerId){
 if(!Number.isSafeInteger(playerId)||!db.prepare('SELECT 1 FROM players WHERE id=?').get(playerId))throw Error('Oyuncu bulunamadı.');
 db.prepare('INSERT OR IGNORE INTO payment_event_accounts(player_id)VALUES(?)').run(playerId);
 return db.prepare('SELECT * FROM payment_event_accounts WHERE player_id=?').get(playerId);
}
function count(db,playerId,loot){return require('./loot-rewards').count(db,playerId,loot);}
function debit(db,playerId,loot,n){
 if(!Number.isSafeInteger(n)||n<1||count(db,playerId,loot)<n)throw Error(`Yetersiz kaynak: ${loot}.`);
 for(const row of db.prepare('SELECT id,amount FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id').all(playerId,loot)){
  const take=Math.min(n,row.amount);db.prepare('UPDATE items SET amount=amount-? WHERE id=? AND amount>=?').run(take,row.id,take);n-=take;if(!n)break;
 }
}
function addPoints(db,playerId,n){
 if(!Number.isSafeInteger(n)||n<1||n>2147483647)throw Error('Geçersiz sezon puanı.');
 const a=account(db,playerId),added=Math.min(MAX*POINTS_PER_LEVEL-a.season_points,n),overflow=n-added;
 db.prepare('UPDATE payment_event_accounts SET season_points=season_points+? WHERE player_id=?').run(added,playerId);
 if(overflow)db.prepare('UPDATE players SET honour=honour+? WHERE id=?').run(overflow*10,playerId);
 return added;
}
function activate(db,playerId,pass){return atomic(db,()=>{
 const a=account(db,playerId);if(!PASSES[pass])throw Error('Geçersiz bilet.');
 if(a[pass])throw Error('Bu bilet zaten etkin.');
 if(pass==='extra'&&!a.gold)throw Error('Extra Gold Pass için önce Gold Pass etkinleştir.');
 debit(db,playerId,PASSES[pass],1);
 db.prepare(`UPDATE payment_event_accounts SET ${pass}=1 WHERE player_id=?`).run(playerId);
 return account(db,playerId);
});}
function usePoints(db,playerId,n){return atomic(db,()=>{account(db,playerId);debit(db,playerId,'resource_season-pass-point',n);addPoints(db,playerId,n);return account(db,playerId);});}
function threshold(level,event){if(event==='season')return level*100;let sum=0;for(let l=1;l<=level;l++)sum+=event==='voyagers'&&l===1?0:l<=5?100:l<=10?200:l<=20?300:320;return sum;}
function levelOf(a,event){const max=event==='season'?90:event==='trinity'?40:30,points=a[event==='season'?'season_points':`${event}_points`];let level=0;while(level<max&&points>=threshold(level+1,event))level++;return level;}
function itemReward(code,n){return {items:{[id(code)]:n}};}
// These two event reward schedules come from the linked official 2026 FAQs.
// Where the FAQ offers thermal/corrosive alternatives, the caller chooses;
// default thermal is a local choice, not a recovered hidden random algorithm.
function eventReward(event,level,vip,choice='thermal'){
 const family=choice==='corrosive'?'cos':'ths',mr=choice==='corrosive'?'c':'t';
 if(event==='voyagers'){
  if(vip){if(level===1||level===30)return itemReward(level===1?'equipment_weapon_drive_igd-l01':'equipment_weapon_drive_igd-l02',1);
   if([5,15,25].includes(level))return itemReward(level===25?'equipment_lens_gl-omega':'equipment_lens_gl-chron',1);
   if([10,20].includes(level))return itemReward('CONTAINMENT_NODE',25);
   return itemReward('HORIZON_SHARD',level===19?40:level===24||level===29?50:level<=10?10:level<=20?15:20);
  }
  const special={5:['ammunition_spool_gsp-30',100],10:['ammunition_spool_gsp-30',200],15:['BEACON_CRYSTAL',20],16:['RSB-75',5000],17:['PLT-3030',5000],18:['AXION',50],19:['INDOCTRINE_ACCELERATOR',20],20:['ammunition_spool_gsp-75',200],21:['RSB-75',6000],22:['PLT-3030',6000],23:['AXION',50],24:['INDOCTRINE_ACCELERATOR',40],25:['IGNISHARD_L01',20],26:['AXION',50],27:['INDOCTRINE_ACCELERATOR',40],28:['DIAMETRION',40],29:['INDOCTRINEOIL',20],30:['equipment_weapon_drive_igd-l01',1]};
  if(special[level])return itemReward(...special[level]);
 }else if(event==='trinity'){
  if(level>=31)return itemReward(`ammunition_slug_${family}-${vip?'a04':'c02'}`,vip?300:500);
  if(vip){if(level===1)return itemReward(choice==='corrosive'?'equipment_weapon_cannon_r-nidhogg':'equipment_weapon_cannon_r-helios',1);
   const special={10:['OPTIGRAD_CHIP',300],15:[`ammunition_slug_${family}-c02`,1500],20:['OPTIGRAD_CHIP',360],25:[`ammunition_slug_${family}-b03`,1000],30:['ARMORY_TOKEN_MEGA',50]};
   if(special[level])return itemReward(...special[level]);
   const values={2:16,3:10,4:32,5:20,6:32,7:20,8:48,9:30,11:48,12:30,13:64,14:40,16:80,17:50,18:96,19:60,21:112,22:70,23:112,24:70,26:112,27:70,28:112,29:70};
   return itemReward([3,5,7,9,12,14,17,19,22,24,27,29].includes(level)?'XYRALITH':'QUANTUM_PRISM',values[level]);
  }
  const special={5:[`ammunition_slug_${family}-d01`,1000],10:[`ammunition_slug_${family}-d01`,1500],15:[`equipment_cannon_shield_mr-${mr}01`,1],16:['RSB-75',5000],17:['PLT-3030',5000],18:['AXION',100],19:['INDOCTRINE_ACCELERATOR',20],20:[`ammunition_slug_${family}-c02`,1000],21:['RSB-75',6000],22:['PLT-3030',6000],23:['AXION',200],24:['INDOCTRINE_ACCELERATOR',40],25:[`equipment_cannon_shield_mr-${mr}02`,1],26:['AXION',200],27:['INDOCTRINE_ACCELERATOR',40],28:['DIAMETRION',40],29:['INDOCTRINEOIL',20],30:[`equipment_cannon_shield_mr-${mr}03`,1]};
  if(special[level])return itemReward(...special[level]);
 }
 return itemReward(['UCB-100','RSB-75','PLT-2021','PLT-3030'][(level-1)%5],[2000,1500,2000,1500][(level-1)%5]*(level>10?2:1));
}
function seasonReward(level,track){
 // Permanent local reward schedule, intentionally not presented as an original season.
 if(track==='free')return itemReward(['MCB-50','PLT-2021','UCB-100','resource_logfile','HSTRM-01'][(level-1)%5],[2000,100,1000,5,500][(level-1)%5]);
 if(track==='gold')return itemReward(['UCB-100','RSB-75','resource_booty-key','HSTRM-01','resource_logfile'][(level-1)%5],[5000,2000,5,1000,20][(level-1)%5]);
 if(level===1)return itemReward('equipment_weapon_laser_lf-4',1);
 return itemReward(['RSB-75','UCB-100','resource_booty-key-red','SEPROM','resource_booty-key-blue'][(level-1)%5],[5000,10000,2,1000,2][(level-1)%5]);
}
function reward(track,level,choice){if(['free','gold','extra'].includes(track))return seasonReward(level,track);const m=/^(trinity|voyagers)-(free|vip)$/.exec(track);if(!m)throw Error('Geçersiz ödül yolu.');return eventReward(m[1],level,m[2]==='vip',choice);}
function eligibility(a,track,level){
 const event=track.startsWith('trinity-')?'trinity':track.startsWith('voyagers-')?'voyagers':'season';
 if(!['free','gold','extra','trinity-free','trinity-vip','voyagers-free','voyagers-vip'].includes(track)||!Number.isSafeInteger(level)||level<1||level>levelOf(a,event))return 'Bu ödülün seviyesi açılmadı.';
 if((track==='gold'||track==='extra')&&!a[track]||track.endsWith('-vip')&&!a[event])return 'Bu ödül yolu için bilet etkinleştir.';
 return null;
}
function grant(db,playerId,reward){require('./payment').fulfil(db,playerId,{contents:reward});}
function claim(db,playerId,track,level,choice){return atomic(db,()=>{
 const why=eligibility(account(db,playerId),track,level);if(why)throw Error(why);
 if(db.prepare('SELECT 1 FROM payment_event_claims WHERE player_id=? AND track=? AND level=?').get(playerId,track,level))throw Error('Bu ödül zaten alındı.');
 const r=reward(track,level,choice);grant(db,playerId,r);
 db.prepare('INSERT INTO payment_event_claims(player_id,track,level,reward_json,claimed_at)VALUES(?,?,?,?,?)').run(playerId,track,level,JSON.stringify(r),Date.now());return r;
});}
function claimAll(db,playerId){return atomic(db,()=>{const a=account(db,playerId),done=[];for(const track of ['free','gold','extra'])for(let level=1;level<=levelOf(a,'season');level++)if(!eligibility(a,track,level)&&!db.prepare('SELECT 1 FROM payment_event_claims WHERE player_id=? AND track=? AND level=?').get(playerId,track,level)){claim(db,playerId,track,level);done.push({track,level});}return done;});}
function buyLevels(db,playerId,n){return atomic(db,()=>{
 const a=account(db,playerId);if(!Number.isSafeInteger(n)||n<1||n>50||levelOf(a,'season')+n>50)throw Error('Sadece 50. seviyeye kadar seviye satın alınabilir.');
 if(!db.prepare('UPDATE players SET uridium=uridium-? WHERE id=? AND uridium>=?').run(n*LEVEL_PRICE,playerId,n*LEVEL_PRICE).changes)throw Error('Yetersiz uridyum.');
 addPoints(db,playerId,n*100);return account(db,playerId);
});}
function periodKey(kind,now=Date.now()){
 // Local server time Europe/Istanbul, daily reset at 05:30, Monday weekly reset.
 const d=new Date(now+(180-330)*60000);if(kind==='season')return 'local-permanent';
 if(kind==='weekly')d.setUTCDate(d.getUTCDate()-(d.getUTCDay()+6)%7);
 return d.toISOString().slice(0,10);
}
function record(db,playerId,event,now=Date.now()){
 if(!event||!['npcKill','collectLoot','gateComplete'].includes(event.type)||!Number.isSafeInteger(event.amount??1)||(event.amount??1)<1)return false;
 if(event.eventId!==undefined&&(typeof event.eventId!=='string'||!event.eventId||event.eventId.length>200))return false;
 return atomic(db,()=>{
  account(db,playerId);
  if(event.eventId!==undefined&&!db.prepare('INSERT OR IGNORE INTO payment_event_receipts(player_id,event_type,event_id,recorded_at)VALUES(?,?,?,?)').run(playerId,event.type,event.eventId,now).changes)return false;
  let changed=false;
  for(const m of MISSIONS){if(event.type!==m.event||m.lootId&&event.lootId!==m.lootId)continue;
   const period=periodKey(m.period,now);db.prepare('INSERT OR IGNORE INTO payment_event_progress(player_id,mission,period)VALUES(?,?,?)').run(playerId,m.key,period);
   db.prepare('UPDATE payment_event_progress SET progress=min(?,progress+?) WHERE player_id=? AND mission=? AND period=?').run(m.goal,Math.min(event.amount??1,m.goal),playerId,m.key,period);
   if(db.prepare('UPDATE payment_event_progress SET awarded=1 WHERE player_id=? AND mission=? AND period=? AND progress>=? AND awarded=0').run(playerId,m.key,period,m.goal).changes){addPoints(db,playerId,m.points);changed=true;}
  }
  // Classic GG bridge: explicitly local; original event maps are not impersonated.
  if(event.type==='gateComplete'){
   const a=account(db,playerId);db.prepare('UPDATE payment_event_accounts SET trinity_points=min(10900,trinity_points+?),voyagers_points=min(7600,voyagers_points+?) WHERE player_id=?').run(a.trinity?110:100,a.voyagers?110:100,playerId);changed=true;
  }
  return changed;
 });
}
const EXCHANGES={
 // Official Voyagers FAQ: 200 Ignishard-L01 / Beacon Crystal per basic weapon.
 'craft-igd-lite':{name:'200 Ignishard-L01 → IgniDrive Lite',cost:{IGNISHARD_L01:200},reward:itemReward('equipment_weapon_drive_igd-l01',1),source:'official-voyagers'},
 'craft-gl-chron':{name:'200 Beacon Crystal → Chronotic Graviton Lens',cost:{BEACON_CRYSTAL:200},reward:itemReward('equipment_lens_gl-chron',1),source:'official-voyagers'},
 'battle-key-ucb':{name:'1 Battle Pass anahtarı → 2.500 UCB-100',cost:{'resource_battle-pass-key':1},reward:itemReward('UCB-100',2500)},
 'battle-key-rsb':{name:'1 Battle Pass anahtarı → 500 RSB-75',cost:{'resource_battle-pass-key':1},reward:itemReward('RSB-75',500)},
 'armory-ucb':{name:'10 Armory Token → 5.000 UCB-100',cost:{ARMORY_TOKEN:10},reward:itemReward('UCB-100',5000)},
 'mega-rsb':{name:'1 Mega Armory Token → 2.000 RSB-75',cost:{ARMORY_TOKEN_MEGA:1},reward:itemReward('RSB-75',2000)},
 'candy-ammo':{name:'1.000 Candy Corn → 1.000 JOB-100',cost:{CANDY_CORN:1000},reward:itemReward('JOB-100',1000)},
 'gold-candy-key':{name:'1 Golden Candy Corn → 1 kırmızı anahtar',cost:{GOLDEN_CANDY_CORN:1},reward:itemReward('resource_booty-key-red',1)},
 'echo-green':{name:'1 yeşil Echo anahtarı → 2.000 UCB-100',cost:{'resource_echo-key-green':1},reward:itemReward('UCB-100',2000)},
 'echo-blue':{name:'1 mavi Echo anahtarı → 1.000 RSB-75',cost:{'resource_echo-key-blue':1},reward:itemReward('RSB-75',1000)},
 'echo-purple':{name:'1 mor Echo anahtarı → 3.000 RSB-75',cost:{'resource_echo-key-purple':1},reward:itemReward('RSB-75',3000)},
 'echo-red':{name:'1 kırmızı Echo anahtarı → 5.000 RSB-75',cost:{'resource_echo-key-red':1},reward:itemReward('RSB-75',5000)}
};
function exchange(db,playerId,key){return atomic(db,()=>{account(db,playerId);const r=EXCHANGES[key];if(!r)throw Error('Geçersiz takas.');for(const [code,n]of Object.entries(r.cost))debit(db,playerId,id(code),n);grant(db,playerId,r.reward);db.prepare('INSERT INTO payment_event_exchanges(player_id,recipe,claim_count)VALUES(?,?,1) ON CONFLICT(player_id,recipe)DO UPDATE SET claim_count=claim_count+1').run(playerId,key);return r.reward;});}
function claimBattle(db,playerId,key,now=Date.now()){return atomic(db,()=>{
 const a=account(db,playerId),m=MISSIONS.find(m=>m.key===key);if(!a.battlepass||!m)throw Error('Önce Battle Pass etkinleştir.');
 const period=periodKey(m.period,now),r=db.prepare('SELECT progress,battle_claimed FROM payment_event_progress WHERE player_id=? AND mission=? AND period=?').get(playerId,key,period);
 if(!r||r.progress<m.goal)throw Error('Görev henüz tamamlanmadı.');if(r.battle_claimed)throw Error('Bu görevin anahtarı zaten alındı.');
 const reward=itemReward('resource_battle-pass-key',m.period==='daily'?1:m.period==='weekly'?2:5);grant(db,playerId,reward);
 db.prepare('UPDATE payment_event_progress SET battle_claimed=1 WHERE player_id=? AND mission=? AND period=?').run(playerId,key,period);return reward;
});}
function commands(db,playerId){const a=account(db,playerId),claims=new Set(db.prepare('SELECT track,level FROM payment_event_claims WHERE player_id=?').all(playerId).map(r=>`${r.track}:${r.level}`)),out={_:'SeasonPassRewardInfoCommand',freeRewardItems:[],goldPassRewardItems:[],extGoldPassRewardItems:[]};
 for(const [track,field]of [['free','freeRewardItems'],['gold','goldPassRewardItems'],['extra','extGoldPassRewardItems']])for(let level=1;level<=90;level++){
  const r=seasonReward(level,track),[[lootId,amount]]=Object.entries(r.items);out[field].push({_:'SeasonPassRewardModule',amount,lootId,level:level-1,goldPass:track==='gold',extGoldPass:track==='extra',claimed:claims.has(`${track}:${level}`)});
 }
 return [{_:'SeasonPassStatusCommand',pointsCost:Array(90).fill(100),uridiumCost:Array(90).fill(LEVEL_PRICE),goldPass:!!a.gold,extGoldPass:!!a.extra,showTips:false,marketingImage:'',seasonName:SEASON,timeToEventEnd:31536000000},{_:'SeasonPointsInfoCommand',points:a.season_points},out,...require('./native-rewards').commands(db,playerId)];
}
function persistEconomy(db,p){db.prepare('UPDATE players SET credits=?,uridium=?,ep=?,honour=?,level=? WHERE id=?').run(p.credits,p.uridium,p.ep,p.honourPoints,p.level,p.userId);}
function refreshRuntime(db,p,world){
 const row=db.prepare('SELECT credits,uridium,ep,honour,level FROM players WHERE id=?').get(p.userId);Object.assign(p,{credits:row.credits,uridium:row.uridium,ep:row.ep,level:row.level,honourPoints:row.honour});
 const fuel=db.prepare('SELECT fuel FROM pets WHERE player_id=?').get(p.userId);if(fuel&&world?.petRuntime)world.petRuntime.fuel=fuel.fuel;
 return [...commands(db,p.userId),{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0},{_:'LegacyModule',message:`0|LM|ST|HON|0|${p.honourPoints}`},...require('./collectables').resourceCommands(p),...require('./booty').buildInit(p),require('./inventory').buildInit(p),...(fuel?[{_:'PetFuelUpdateCommand',petFuelNow:fuel.fuel,petFuelMax:require('./pet').MAX_FUEL}]:[])];
}
function notify(playerId){const World=require('./world'),w=World.current(),p=w?.livePlayer?.(playerId);if(!p)return;const db=require('./db').open(),out=refreshRuntime(db,p,w),send=require('./net').sendCmd;
 w.broadcast(s=>{for(const c of out)send(s,c);});require('./ammo').notify(p);
}
function preserveLive(db,playerId){const p=require('./world').current()?.livePlayer?.(playerId);if(p)persistEconomy(db,p);}
function handle(playerId,params){const db=require('./db').open();try{const action=params.get('subaction')||'view';let message='';if(action!=='view')atomic(db,()=>{preserveLive(db,playerId);if(action==='activate'){activate(db,playerId,params.get('pass'));message='Bilet etkinleştirildi.';}else if(action==='points'){usePoints(db,playerId,Number(params.get('amount')));message='Sezon puanları kullanıldı.';}else if(action==='claim'){claim(db,playerId,params.get('track'),Number(params.get('level')),params.get('choice'));message='Ödül teslim edildi.';}else if(action==='battleClaim'){claimBattle(db,playerId,params.get('mission'));message='Battle Pass görev anahtarı teslim edildi.';}else if(action==='claimAll'){const rows=claimAll(db,playerId);message=`${rows.length} ödül teslim edildi.`;}else if(action==='level'){buyLevels(db,playerId,Number(params.get('amount')));message='Seviye satın alındı.';}else if(action==='exchange'){exchange(db,playerId,params.get('recipe'));message='Takas tamamlandı.';}else throw Error('Geçersiz işlem.');});if(action!=='view')notify(playerId);return {ok:true,message};}catch(e){return {ok:false,message:e.message};}}
const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[c]);
function form(action,fields,label,disabled=false){return `<form method="post"><input type="hidden" name="subaction" value="${esc(action)}">${Object.entries(fields).map(([k,v])=>`<input type="hidden" name="${esc(k)}" value="${esc(v)}">`).join('')}${action==='claim'&&String(fields.track).startsWith('trinity-')?'<select name="choice"><option value="thermal">Termal</option><option value="corrosive">Korozif</option></select>':''}<button${disabled?' disabled':''}>${esc(label)}</button></form>`;}
function rewardText(r){return Object.entries(r.items||{}).map(([loot,n])=>`${n.toLocaleString('tr-TR')} × ${META[loot]?.typeValue||loot}`).join(', ');}
function render(player,result={}){const db=require('./db').open(),a=account(db,player.userId),claimed=new Set(db.prepare('SELECT track,level FROM payment_event_claims WHERE player_id=?').all(player.userId).map(r=>`${r.track}:${r.level}`));
 const passes=Object.entries(PASSES).map(([key,loot])=>`<article><h3>${esc(key.toUpperCase())}</h3><p>${a[key]?'Etkin':`Envanter: ${count(db,player.userId,loot)}`}</p>${form('activate',{pass:key},'Etkinleştir',!!a[key]||!count(db,player.userId,loot)||key==='extra'&&!a.gold)}</article>`).join('');
 const missions=MISSIONS.map(m=>{const p=db.prepare('SELECT progress,awarded,battle_claimed FROM payment_event_progress WHERE player_id=? AND mission=? AND period=?').get(player.userId,m.key,periodKey(m.period));return `<li>${esc(m.label)} — ${p?.progress||0}/${m.goal}, ${m.points} puan ${p?.awarded?'✓':''} ${form('battleClaim',{mission:m.key},p?.battle_claimed?'Anahtar alındı':'Battle Pass anahtarını al',!a.battlepass||!p||p.progress<m.goal||!!p.battle_claimed)}</li>`;}).join('');
 const sections=[['season','Yerel sezon',['free','gold','extra'],90],['trinity','Trinity ödülleri',['trinity-free','trinity-vip'],40],['voyagers','Voyagers ödülleri',['voyagers-free','voyagers-vip'],30]].map(([event,name,tracks,max])=>`<section><h2>${name}: ${levelOf(a,event)}/${max}</h2>${event!=='season'?'<p>Ödül içerikleri resmî 2026 tablosundan; ilerleme klasik galaksi kapısı başına 100 puandır (VIP: 110). Bu yerel uyarlamadır. Özgün etkinlik haritası, giriş hakkı ve haritaya özel %20 hasar henüz yok.</p>':'<p>Her seviye 100 puan. Bu kalıcı sezonun görev, fiyat ve ödül miktarları yereldir.</p>'}<div class="scroll"><table><tr><th>Seviye / gerekli toplam puan</th>${tracks.map(t=>`<th>${esc(t)}</th>`).join('')}</tr>${Array.from({length:max},(_,i)=>{const l=i+1;return `<tr><td>${l} / ${threshold(l,event)}</td>${tracks.map(track=>{const yes=claimed.has(`${track}:${l}`),why=eligibility(a,track,l),r=reward(track,l);return `<td>${esc(rewardText(r))}${yes?'<p>Alındı ✓</p>':form('claim',{track,level:l},why||'Ödülü al',!!why)}</td>`;}).join('')}</tr>`;}).join('')}</table></div></section>`).join('');
 return `<!doctype html><html lang="tr"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Yerel Sezon ve Biletler</title><style>body{background:#07151f;color:#cde2ec;font:15px Arial;margin:24px}a{color:#85d6ff;margin-right:20px}main{max-width:1200px;margin:auto}h1,h2{color:#8bdfff}article,section{background:#102a38;padding:18px;margin:18px 0;border:1px solid #33566a}p,li{line-height:1.6}.passes{display:flex;gap:16px;flex-wrap:wrap}.passes article{min-width:170px}button,input,select{padding:9px;margin:4px;background:#1a6248;color:white;border:1px solid #3d826c}button:disabled{background:#394c55;color:#9daab0}input[type=number]{width:100px}form{display:inline-block}table{border-collapse:collapse;width:100%;font-size:13px}td,th{border:1px solid #33566a;padding:10px;text-align:left}.scroll{overflow:auto}.notice{background:#27424c;padding:15px}</style><main><a href="/indexInternal.es?action=internalStart">Ana sayfa</a><a href="/indexInternal.es?action=internalPayment">Payment</a><a href="/game">Oyuna dön</a><h1>Yerel Sezon ve Biletler</h1><p class="notice">${esc(result.message||'Biletini etkinleştir; görevlerden veya satın aldığın puanlardan seviye aç ve ödüllerini al.')} Bilet etkinleştirme, puan kullanma ve takas envanterdeki gerçek kaynağı tüketir.</p><div class="passes">${passes}</div><section><h2>Sezon puanı: ${a.season_points}/9000</h2><p>Envanterde kullanılmamış puan: ${count(db,player.userId,'resource_season-pass-point')}. 9000 üzeri puan başına 10 şeref verilir.</p><form method="post"><input type="hidden" name="subaction" value="points"><input name="amount" type="number" min="1" max="2147483647" value="100"><button>Puanları kullan</button></form><form method="post"><input type="hidden" name="subaction" value="level"><input name="amount" type="number" min="1" max="50" value="1"><button>Seviye al (10.000 U. / seviye, en fazla 50)</button></form>${form('claimAll',{},'Açık sezon ödüllerinin hepsini al')}<ul>${missions}</ul><p>Günlük sıfırlama 05:30 Türkiye saati, haftalık pazartesi 05:30. Tamamlanan görev her dönem bir kez puan verir.</p></section>${sections}<section><h2>Yerel kaynak takası</h2><p>IgniDrive Lite ve GL-Chron üretimi resmî 200 parça tarifini kullanır. Diğer sabit takaslar yerel alternatiflerdir; orijinal etkinlik kutu havuzu veya şansları değildir. Battle Pass görev ödülü günlük 1, haftalık 2, sezon görevi 5 anahtardır (yerel).</p>${Object.entries(EXCHANGES).map(([key,r])=>`<p>${form('exchange',{recipe:key},r.name)}</p>`).join('')}</section></main></html>`;
}
module.exports={PASSES,MAX,MISSIONS,EXCHANGES,account,activate,usePoints,addPoints,threshold,levelOf,eventReward,seasonReward,reward,eligibility,claim,claimAll,buyLevels,periodKey,record,exchange,claimBattle,commands,persistEconomy,refreshRuntime,notify,preserveLive,handle,render};
