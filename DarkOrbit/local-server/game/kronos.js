'use strict';
const META=require('../docs/client-map.items.json').items;
const PARTS={alpha:4,beta:3,gamma:1,delta:1,epsilon:4,zeta:1,kappa:2,lambda:5};
const loot=name=>'resource_gatepart_gg-part-kronos-'+name;
function progress(db,playerId){return Object.entries(PARTS).map(([name,total])=>({_: 'GalaxyGateBuilderMultiGateProgressModule',name:name[0].toUpperCase()+name.slice(1),total,current:Math.min(total,db.prepare('SELECT COALESCE(SUM(amount),0) n FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').get(playerId,loot(name)).n)}));}
function consume(db,playerId){
 if(progress(db,playerId).some(p=>p.current<p.total))return false;
 for(const [name,total]of Object.entries(PARTS)){let remaining=total;for(const r of db.prepare('SELECT id,amount FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id').all(playerId,loot(name))){const n=Math.min(remaining,r.amount);db.prepare('UPDATE items SET amount=amount-? WHERE id=? AND amount>=?').run(n,r.id,n);remaining-=n;if(!remaining)break;}}
 return true;
}
// Primary official Kronos FAQ: ordered batches, not one mixed simultaneous wave.
const WAVES=[
 [['phoenix',10],['yamato',15],['yamato',15]],
 [['defcom',10],['defcom',10],['liberator',15],['liberator',15]],
 [['nostromo',10],['piranha',15],['piranha',15],['nostromo',10]],
 [['bigboy',10],['bigboy',5],['bigboy',10],['bigboy',5]],
 [['vengeance',5],['vengeance',5],['vengeance',5],['goliath',8]],
 [['leonov',5],['leonov',5],['leonov',5],['leonov',5]],
 [['venom',5],['sentinel',5],['spectrum',5],['diminisher',5],['solace',5]],
 [['revenge',5],['revenge',5],['enforcer',5],['enforcer',5],['enforcer',5]],
 [['lightning',6],['avenger',6],['lightning',6],['avenger',6],['lightning',6]],
 [['bastion',6],['enforcer',6],['bastion',6]],
 [['spearhead',10],['citadel',5],['aegis',8],['goliath',10]],
 [['crimson',8],['jade',8],['sapphire',8]],
 [['evil',1],['evil-iris',8]]
];
// HP, shield, low/high damage, speed, EP, honour, credits, Uridium.
// Numeric source: docs/evidence/kronos-official-npc.txt (official ES Alien FAQ).
const STATS={phoenix:[4000,10000,100,1000,320,100,1,400,5],yamato:[8000,20000,300,400,260,200,2,800,7],
 defcom:[12000,50000,300,1400,340,800,8,1600,9],liberator:[16000,60000,600,900,330,1600,16,3200,12],
 nostromo:[64000,80000,600,900,340,6400,64,6400,18],piranha:[64000,80000,600,900,360,3200,64,6400,15],
 bigboy:[128000,150000,1000,3500,260,25600,256,12800,56],vengeance:[180000,100000,2200,3000,380,12800,128,25600,28],
 goliath:[256000,150000,5000,7000,300,51200,512,45000,100],leonov:[160000,60000,3800,5000,360,12800,65,25600,25],
 venom:[256000,150000,6200,8500,300,51200,512,45000,100],sentinel:[256000,150000,5300,6800,300,51200,512,45000,100],
 spectrum:[256000,150000,5300,7000,300,51200,512,45000,100],diminisher:[256000,150000,6400,13000,300,51200,512,45000,100],solace:[256000,150000,5300,7000,300,51200,512,45000,100],
 revenge:[180000,100000,3400,4500,380,12800,128,25600,28],enforcer:[256000,150000,6500,8400,300,51200,512,45000,100],
 lightning:[180000,100000,2200,3000,380,12800,128,25600,28],avenger:[180000,200000,2300,3000,380,12800,128,25600,28],
 bastion:[256000,250000,5300,7000,300,51200,512,45000,100],spearhead:[100000,120000,500,700,370,7500,75,20000,20],
 citadel:[550000,200000,3300,6500,240,120000,1200,80000,175],aegis:[275000,150000,3700,5000,300,25000,250,50000,56],
 crimson:[256000,150000,5300,6800,300,51200,512,45000,100],jade:[256000,150000,5200,7000,300,51200,512,45000,100],sapphire:[256000,150000,5300,7000,300,51200,512,45000,100],
 evil:[750000,500000,25000,35000,null,250000,2000,150000,500],'evil-iris':[60000,50000,1000,1400,null,6400,32,12800,16]};
const SHIPS={revenge:'ship_v-revenge',lightning:'ship_v-lightning',avenger:'ship_v-avenger',bastion:'ship_g-bastion',enforcer:'ship_g-enforcer',crimson:'ship_goliath_design_crimson',jade:'ship_goliath_design_jade',sapphire:'ship_goliath_design_sapphire','evil-iris':'108'};
function definition(key,player={}){
 const [hitpoints,shield,damageMin,damageMax,speed,ep,honour,credits,uridium]=STATS[key];
 const typeId=key==='evil'?(player.typeId||'ship_goliath'):SHIPS[key]||'ship_'+key;
 if(key!=='evil-iris'&&!META[typeId])throw Error('Kronos appearance unavailable: '+typeId);
 return{key:'kronos-'+key,typeId,name:key==='evil'?'Evil '+(player.userName||player.name||'You'):key==='evil-iris'?'Evil Iris':'Saturn '+key[0].toUpperCase()+key.slice(1),
  hitpoints,shield,damageMin,damageMax,speed:speed??player.speed??300,shieldAbsorb:.5,aggressive:true,respawnMs:0,reward:{ep,honour,credits,uridium}};
}
function build(player={},options={}){
 let slot=0;const phases=WAVES.flatMap((wave,major)=>wave.map(([key,count])=>({major:major+1,slots:Array.from({length:count},()=>({slot:slot++,key:'kronos-'+key,def:definition(key,player)}))})));
 phases.forEach((phase,i)=>phase.slots.forEach(s=>s.phase=i+1));
 const chance=options.kronosSaturnChance??.1;if(!Number.isFinite(chance)||chance<0||chance>1)throw Error('Invalid local Saturn chance');
 return{version:'official-kronos-2026-10-23',gateId:12,phases,rewards:{credits:0,ep:12000000,honour:450000,uridium:25000,ammunition:25000,energy:250,
  items:{'ammunition_rocketlauncher_ubr-100':500,'ammunition_laser_rsb-75':5000,resource_logfile:15,'resource_booty-key':10},
  completionPolicy:'classic-rare-2026-10-20-v1',rare:{kind:'saturn',chance,chanceSource:'local-unpublished'}}};
}
module.exports={PARTS,loot,progress,consume,WAVES,STATS,SHIPS,definition,build};
