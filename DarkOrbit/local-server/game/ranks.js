'use strict';
const crypto=require('crypto'),META=require('../docs/client-map.items.json').items;
const DAY=86400000,AGE=28*DAY;
const NAMES=['','Acemi Uzay Pilotu','Uzay Pilotu','Usta Uzay Pilotu','Acemi Çavuş','Çavuş','Usta Çavuş','Acemi Teğmen','Teğmen','Üsteğmen','Acemi Yüzbaşı','Yüzbaşı','Usta Yüzbaşı','Acemi Binbaşı','Binbaşı','Usta Binbaşı','Acemi Albay','Albay','Usta Albay','Acemi General','General'];
// Official DE NPC FAQ raw points; not already-halved badge points. Unknown
// modern NPCs are recorded with known=0 rather than inventing EP-derived values.
const POINTS={streuner:1,lordakia:1,saimon:2,mordon:2,devolarium:4,sibelon:5,kristallin:3,kristallon:8,sibelonit:3,lordakium:6,'streuner-upper':2,cubikon:10,protegit:3,
 vagrant:1,marauder:2,outcast:4,convict:32,hooligan:16,ravager:32,corsair:0,'century-falcon':0,demaner:0,kucurbium:32,'boss-kucurbium':128,
 interceptor:1,barracuda:2,saboteur:4,annihilator:6,battleray:16,icy:3,infernal:4,scorcher:8,melter:16,devourer:255};
const seen=new WeakSet();
function npcPoints(npc){
 const d=npc.def||npc;let key=d.key||String(d.name||'').toLowerCase().replaceAll(' ','-');
 key=key.replace(/^(?:epsilon|kappa|lambda)-/,'');
 // Official moderator answer, GI Kronos Gate (121147/#4): Saturn/Evil
 // NPCs have no kill-rank reward. EP and honour still enter calculate().
 if(key.startsWith('kronos-')&&Object.hasOwn(require('./kronos').STATS,key.slice(7)))return{key,points:0,known:true};
 if(Object.hasOwn(POINTS,key))return{key,points:POINTS[key],known:true};
 const prefix=key.match(/^(boss|uber)-(.+)$/);
 if(prefix&&Object.hasOwn(POINTS,prefix[2])&&!['interceptor','barracuda','saboteur','annihilator','battleray'].includes(prefix[2]))return{key,points:POINTS[prefix[2]]*(prefix[1]==='boss'?4:8),known:true};
 return{key,points:0,known:false};
}
function recordNpcKill(db,playerId,npc,now=Date.now()){
 if(seen.has(npc))return false;
 const d=npc.def||npc,entry=npcPoints(npc),mapId=npc.mapId??db.prepare('SELECT map_id FROM players WHERE id=?').get(playerId)?.map_id;
 if([2,6,10].includes(mapId)&&['streuner','lordakia'].includes(entry.key))entry.points=0;
 const key=d.gateRunId?`gate:${d.gateRunId}:${d.gateWave}:${d.gateSlot}`:
  d.normalSpawnId!=null&&d.normalSpawnGeneration?`normal:${d.normalSpawnId}:${d.normalSpawnSlot}:${d.normalSpawnGeneration}`:`runtime:${crypto.randomUUID()}`;
 const result=db.prepare('INSERT OR IGNORE INTO rank_npc_claims(player_id,event_key,npc_key,raw_points,known,claimed_at)VALUES(?,?,?,?,?,?)').run(playerId,key,entry.key,entry.points,Number(entry.known),now);
 seen.add(npc);return!!result.changes;
}
function recordDeath(db,playerId,{radiation=false,enemyPlayer=false}={}){
 db.prepare('INSERT OR IGNORE INTO rank_counters(player_id)VALUES(?)').run(playerId);
 const column=radiation?'radiation_deaths':enemyPlayer?'enemy_deaths':'npc_deaths';
 db.prepare(`UPDATE rank_counters SET ${column}=${column}+1 WHERE player_id=?`).run(playerId);
}
function shipFactor(id){
 const m=META[id];if(m?.rankingFactor)return m.rankingFactor;
 const base=m?.baseShipId;return base?Object.values(META).find(v=>v.kind==='Ship'&&v.shipId===base&&v.rankingFactor)?.rankingFactor||0:0;
}
function calculate(db,playerId,now=Date.now()){
 const p=db.prepare('SELECT p.*,a.created_at AS joined_at,s.loot_id FROM players p JOIN accounts a ON a.id=p.account_id LEFT JOIN ships s ON s.id=p.active_ship_id WHERE p.id=?').get(playerId);
 if(!p)return null;
 const c=db.prepare('SELECT * FROM rank_counters WHERE player_id=?').get(playerId)||{},days=Math.max(0,Math.floor((now-p.joined_at)/DAY));
 const rawNpc=db.prepare('SELECT COALESCE(SUM(raw_points),0) n FROM rank_npc_claims WHERE player_id=?').get(playerId).n;
 const quests=db.prepare("SELECT COUNT(*) n FROM player_quests WHERE player_id=? AND status='completed'").get(playerId).n;
 const breakdown={experience:p.ep/100000,honour:p.honour/100,playerKills:(c.player_kill_points||0)*3,level:p.level*100,days:days*6,ship:shipFactor(p.loot_id)*1000,npcKills:rawNpc/2,quests:quests*100,
  friendlyKills:-(c.friendly_kills||0)*100,enemyDeaths:-(c.enemy_deaths||0)*4,radiationDeaths:-(c.radiation_deaths||0)*8,phoenixKills:-(c.phoenix_kills||0)*2};
 return{playerId:p.id,name:p.name,factionId:p.faction_id,level:p.level,points:Object.values(breakdown).reduce((n,v)=>n+v,0),userPoints:p.ep/1000+p.honour/100,
  eligible:p.level>=2&&now-p.joined_at>=AGE&&p.honour>=0,days,breakdown};
}
const dayKey=now=>require('./payment-events').periodKey('daily',now);
// Ranked population is company-specific. Fractional quotas use floor; remaining
// small-population pilots receive Basic Space Pilot. The top eligible pilot is
// General even on a one-pilot local company. Tie break is stable player ID.
const QUOTAS=[[19,.0001],[18,.001],[17,.005],[16,.01],[15,.015],[14,.02],[13,.025],[12,.03],[11,.035],[10,.04],[9,.045],[8,.05],[7,.06],[6,.07],[5,.08],[4,.09],[3,.1],[2,.1229]];
function assign(rows){
 // Unranked/negative-honour pilots keep the basic icon.21 is not an
 // authenticated outlaw mapping; never award an unverified privileged badge.
 const badges=new Map(rows.map(p=>[p.playerId,1]));
 for(const faction of [1,2,3]){
  const list=rows.filter(p=>p.eligible&&p.factionId===faction).sort((a,b)=>b.points-a.points||a.playerId-b.playerId);if(!list.length)continue;
  badges.set(list[0].playerId,20);let cursor=1;
  for(const [badge,ratio]of QUOTAS)for(let n=0;n<Math.floor(list.length*ratio)&&cursor<list.length;n++)badges.set(list[cursor++].playerId,badge);
 }
 return badges;
}
function refreshDaily(db,now=Date.now(),{force=false}={}){
 const day=dayKey(now),count=db.prepare('SELECT COUNT(*) n FROM rank_daily WHERE day=?').get(day).n,players=db.prepare('SELECT id FROM players ORDER BY id').all();
 if(!force&&count===players.length)return day;
 const rows=players.map(p=>calculate(db,p.id,now)),badges=assign(rows);
 // Do not change existing assignments during the day when a new account joins.
 const insert=db.prepare(`${force?'INSERT OR REPLACE':'INSERT OR IGNORE'} INTO rank_daily(day,player_id,faction_id,badge,points,eligible,breakdown_json)VALUES(?,?,?,?,?,?,?)`);
 for(const p of rows)insert.run(day,p.playerId,p.factionId,badges.get(p.playerId),p.points,Number(p.eligible),JSON.stringify(p.breakdown));
 return day;
}
function current(db,playerId,now=Date.now()){
 const day=refreshDaily(db,now),saved=db.prepare('SELECT * FROM rank_daily WHERE day=? AND player_id=?').get(day,playerId);
 return{...calculate(db,playerId,now),dailyRank:saved?.badge||1,dailyPoints:saved?.points||0,day};
}
function leaderboard(db,now=Date.now()){
 refreshDaily(db,now);return db.prepare('SELECT id FROM players').all().map(p=>current(db,p.id,now)).sort((a,b)=>b.userPoints-a.userPoints||a.playerId-b.playerId).map((p,n)=>({...p,position:n+1}));
}
module.exports={DAY,AGE,POINTS,NAMES,npcPoints,recordNpcKill,recordDeath,shipFactor,calculate,assign,dayKey,refreshDaily,current,leaderboard};
