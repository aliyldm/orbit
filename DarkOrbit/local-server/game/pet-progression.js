'use strict';
const {open,tx}=require('./db');
const KEY='pet.unlockedSlots',BASE=Object.freeze({laser:6,generator:12,gear:6,protocol:12,visual:1,heat:0});
// Existing local grants remain owned. New slots above those grants are paid.
// Exact table: official PET FAQ attachment6072 and Level Update120879.
const COMMON=[0,0,3000,5000,7000,11000,14000,19000,23000,29000,34000,40000,48000];
const PRICES={laser:COMMON,generator:[...COMMON,52000,58000,64000,70000,88000,98000,110000,124000,140000,158000],protocol:COMMON,gear:[0,0,10000,20000,30000,40000,50000]};
function unlocked(playerId,db=open()){
 const saved=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(playerId,KEY);
 let values={};try{values=JSON.parse(saved?.value||'{}');}catch{throw Error('P.E.T. yuva kaydı geçersiz.');}
 return Object.fromEntries(Object.entries(BASE).map(([slot,min])=>[slot,Math.max(min,Number.isInteger(values[slot])?values[slot]:0)]));
}
function maximum(pet,db=open()){
 const owned=unlocked(pet.player_id,db),levels=require('./pet-catalog').slotsAtLevel(pet.level);
 return Object.fromEntries(Object.keys(BASE).map(slot=>[slot,Math.max(owned[slot],Math.min(levels[slot],(PRICES[slot]?.length||1)-1))]));
}
function price(slot,next){return PRICES[slot]?.[next];}
function live(playerId){const w=require('./world').current();return w?.livePlayer(playerId)?w:null;}
function debit(db,playerId,cost){
 const world=live(playerId),p=world?.player||db.prepare('SELECT * FROM players WHERE id=?').get(playerId);
 if(!p||!Number.isFinite(cost)||cost<=0||p.uridium<cost)throw Error('Yetersiz Uridyum.');
 db.prepare('UPDATE players SET uridium=? WHERE id=?').run(p.uridium-cost,playerId);
 return{world,balance:p.uridium-cost};
}
function notify(playerId,payment){
 if(!payment.world)return;
 const w=payment.world;w.player.uridium=payment.balance;
 require('./pet').refresh(w);
 require('./pet').send(w,{_:'AttributeCreditsUpdateCommand',credits:w.player.credits,uridium:w.player.uridium,jackpot:w.player.jackpot||0});
}
function unlock(playerId,request){
 const slot=({lasers:'laser',generators:'generator',gears:'gear',protocols:'protocol'})[request.slotset];
 if(request.target!=='pet'||!slot)throw Error('Geçersiz P.E.T. yuvası.');
 let payment;tx(db=>{
  const pet=require('./pet').owned(playerId,db);if(!pet)throw Error('P.E.T. sahibi değilsin.');
  const slots=unlocked(playerId,db),next=slots[slot]+1,cost=price(slot,next);
  if(next>maximum(pet,db)[slot]||!cost)throw Error('Bu yuva için P.E.T. seviyen yetersiz veya bütün yuvalar açık.');
  if(request.slotPrice!==undefined&&Number(request.slotPrice)!==cost)throw Error('Yuva fiyatı değişti; hangarı yenile.');
  payment=debit(db,playerId,cost);slots[slot]=next;
  db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(playerId,KEY,JSON.stringify(slots));
 });notify(playerId,payment);return 1;
}
const hpLevel=id=>/^pet_hp-upgrade-(\d+)$/.test(id)?Number(id.slice('pet_hp-upgrade-'.length)):null;
function hpOffer(playerId){
 if(!playerId)return null;const p=require('./pet').owned(playerId);if(!p)return null;
 const next=p.hp_upgrade_level+1;if(next>p.level||next>20)return null;
 return{id:'pet_hp-upgrade-'+next,name:'P.E.T. Darbe Puanı Geliştirmesi',category:'petGear',price:Math.min(50000,next*5000),currency:'real',isPaymentItem:false,level:next};
}
function buyHp(playerId,id,amount){
 if(Number(amount)!==1)return{result:'error',message:'Darbe puanı kademeleri sırayla satın alınır.'};
 let payment,level;try{tx(db=>{
  const offer=hpOffer(playerId);if(!offer||offer.id!==id)throw Error('Bu kademe alınmış veya P.E.T. seviyesi yetersiz. Dükkânı yenile.');
  payment=debit(db,playerId,offer.price);level=offer.level;
  if(!db.prepare('UPDATE pets SET hp_upgrade_level=? WHERE player_id=? AND hp_upgrade_level=? AND level>=?').run(level,playerId,level-1,level).changes)throw Error('P.E.T. geliştirme kaydı değişti.');
 });notify(playerId,payment);return{result:'success',message:'P.E.T. can sınırı 10.000 artırıldı. Sonraki kademe için dükkânı yenile.',userBalance:{uridium:payment.balance,credits:(payment.world?.player||require('./db/players').loadPlayer(playerId)).credits},itemId:id,petHpUpgrade:level};
 }catch(error){return{result:'error',message:error.message};}
}
module.exports={BASE,PRICES,unlocked,maximum,price,unlock,hpLevel,hpOffer,buyHp};
