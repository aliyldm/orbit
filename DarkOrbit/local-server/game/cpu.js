'use strict';
const {open,tx}=require('./db'),inventory=require('./inventory'),META=require('../docs/client-map.items.json').items;
const PREFIX='equipment_extra_cpu_',KEY='game.cpus',TRADE='equipment_extra_hmd-07';
const CAPACITY={'jp-01':10,'jp-02':20,'cl04k-m':10,'cl04k-xl':50,'cl04k-xs':1,'dr-01':8,'dr-02':32,'anti-z1':1,'anti-z1-xl':10};
const TOGGLES=new Set(['aim','arol-x','alb-x','rb-x','fb-x','ags-x','rg-sl']);
function equipment(p){return inventory.equipped(open(),p.shipId,inventory.activeConfig(open(),p.shipId)).filter(i=>i.slot==='extra'&&i.amount>0);}
function has(p,suffix){return equipment(p).some(i=>i.loot_id===PREFIX+suffix);}
function read(p){try{return JSON.parse(open().prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(p.userId,KEY)?.value||'{}');}catch{return{};}}
function write(p,data,db=open()){db.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?) ON CONFLICT(player_id,key)DO UPDATE SET value=excluded.value').run(p.userId,KEY,JSON.stringify(data));}
function charges(item,db=open()){
 const max=item?.loot_id===TRADE?100:CAPACITY[item?.loot_id?.replace(PREFIX,'')];if(!max)return 0;
 db.prepare('INSERT OR IGNORE INTO cpu_charges(item_id,remaining)VALUES(?,?)').run(item.id,max);
 return db.prepare('SELECT remaining FROM cpu_charges WHERE item_id=?').get(item.id).remaining;
}
function charged(p,suffixes,db=open()){return equipment(p).filter(i=>suffixes.includes(i.loot_id.replace(PREFIX,''))).sort((a,b)=>(CAPACITY[b.loot_id.replace(PREFIX,'')]||0)-(CAPACITY[a.loot_id.replace(PREFIX,'')]||0)).find(i=>charges(i,db)>0);}
function consume(item,db=open()){charges(item,db);const used=!!db.prepare('UPDATE cpu_charges SET remaining=remaining-1 WHERE item_id=? AND remaining>0').run(item.id).changes;if(used&&item.loot_id===PREFIX+'cl04k-xs')db.prepare('DELETE FROM items WHERE id=?').run(item.id);return used;}
function send(w,c){w.broadcast(s=>(w.combat?.send||require('./net').sendCmd)(s,c));}
function isCloaked(p){return !!p.ultimateCloaked||!!read(p).cloaked&&!require('./galaxy-gates').isGateMap(p.mapId)&&!!require('./normal-map-layout').getMap(p.mapId);}
function cloakCommand(p){return{_:'LegacyModule',message:`0|n|INV|${p.userId}|${Number(isCloaked(p))}`};}
function breakCloak(w){require('./respawn').breakProtection(w);const ultimate=require('./ship-abilities-expanded').breakUltimate(w),p=w.player,state=read(p);if(!state.cloaked)return ultimate;delete state.cloaked;write(p,state);p.cloaked=false;send(w,{_:'LegacyModule',message:`0|n|INV|${p.userId}|0`});return true;}
function cloak(w){const p=w.updatePosition();if(isCloaked(p)&&!p.ultimateCloaked||require('./pirate-fields').contains(p.mapId,p)||require('./galaxy-gates').isGateMap(p.mapId))return false;const item=charged(p,['cl04k-xl','cl04k-m','cl04k-xs']);if(!item)return false;
 const ok=tx(db=>{if(!consume(item,db))return false;write(p,{...read(p),cloaked:true},db);return true;});if(!ok)return false;require('./ship-abilities-expanded').breakUltimate(w);p.cloaked=true;send(w,{_:'LegacyModule',message:`0|n|INV|${p.userId}|1`});notify(w);return true;}
function purchased(w,id){const p=w.player;if(id!==PREFIX+'cl04k-xs'||!p||p.dead||isCloaked(p)||require('./pirate-fields').contains(p.mapId,p)||require('./galaxy-gates').isGateMap(p.mapId))return false;const item=open().prepare('SELECT * FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id DESC').get(p.userId,id);if(!item)return false;
 tx(db=>{if(!consume(item,db))throw new Error('Tarn modülü kullanılamadı.');write(p,{...read(p),cloaked:true},db);});p.cloaked=true;send(w,{_:'LegacyModule',message:`0|n|INV|${p.userId}|1`});notify(w);return true;}
function available(p,id){const eq=equipment(p);if(id===PREFIX+'jp')return !!charged(p,['jp-02','jp-01']);if(id===PREFIX+'cl04k')return !!charged(p,['cl04k-xl','cl04k-m','cl04k-xs']);if(id===PREFIX+'aim')return eq.some(i=>/^equipment_extra_cpu_aim-0[12]$/.test(i.loot_id));if(id===PREFIX+'dr')return !!charged(p,['dr-02','dr-01']);if(id===PREFIX+'anti-z1')return false;return eq.some(i=>i.loot_id===id);}
function menuStatus(p,c){if(!c.menuItemId.startsWith(PREFIX))return c;
 const suffix=c.menuItemId.slice(PREFIX.length);if(!['jp','cl04k','aim','ajp-01','arol-x','alb-x','rb-x','fb-x','dr','anti-z1','rg-sl','ags-x','pa-x'].includes(suffix))return c;
 const enabled=available(p,c.menuItemId)&&!['pa-x','anti-z1','dr'].includes(suffix),state=read(p);
 let n=0;if(suffix==='jp'||suffix==='cl04k'||suffix==='dr'){const list={jp:['jp-02','jp-01'],cl04k:['cl04k-xl','cl04k-m','cl04k-xs'],dr:['dr-02','dr-01']}[suffix];const item=charged(p,list);if(item)n=charges(item);}if(suffix==='aim')n=Math.floor((open().prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(p.userId)?.amount||0)/10);
 return {...c,visible:enabled||c.visible,available:enabled,activatable:enabled,blocked:false,selected:TOGGLES.has(suffix)?!!state[suffix]:suffix==='cl04k'?isCloaked(p):false,counterValue:n};
}
function buildInit(p){const item=charged(p,['jp-02','jp-01']),cl=charged(p,['cl04k-xl','cl04k-m','cl04k-xs']),state=read(p);p.cloaked=isCloaked(p);
 if(state.cloaked&&require('./pirate-fields').contains(p.mapId,p)){delete state.cloaked;write(p,state);p.cloaked=false;}
 return [{_:'ExtraInfoCommand',droneCPU:charged(p,['dr-02','dr-01'])?1:0,diploCPU:has(p,'rd-x')?1:0,jumpCPU:item?.loot_id.endsWith('02')?2:item?1:0,ammoCPU:has(p,'alb-x')?1:0,smartBomb:has(p,'smb-01')?1:0,instaShield:has(p,'ish-01')?1:0,mineTurbo:has(p,'min-t02')?2:has(p,'min-t01')?1:0,aimCPU:has(p,'aim-02')?2:has(p,'aim-01')?1:0,arolCPU:has(p,'arol-x')?1:0,cloakCPU:cl?1:0,autoRlCPU:has(p,'rllb-x')?1:0,rocketBuyCPU:has(p,'rb-x')?1:0,specialJumpCPU:has(p,'ajp-01')?1:0},
 {_:'CPUInfoTradeDroneCommand',chargesLeft:tradeItem(p)?charges(tradeItem(p)):0},
 {_:'CPUInitializationCommand',advancedJumpCPUEquipped:has(p,'ajp-01'),radarCPUEquipped:has(p,'rd-x')||!!p.premium},
 {_:'CPUInfoHomeJumpCommand',level:item?.loot_id.endsWith('02')?2:item?1:0,homeMapId:({1:1,2:5,3:9})[p.factionId]||1,chargesLeft:item?charges(item):0},
 {_:'CPUInfoCloakCommand',cloakChargesLeft:cl?charges(cl):0},
 {_:'CPUInfoAutoRocketCommand',isActive:has(p,'arol-x')&&!!state['arol-x']},
 {_:'CPUInfoAimCommand',isActive:available(p,PREFIX+'aim')&&!!state.aim,possibleChargesLeft:Math.floor((open().prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(p.userId)?.amount||0)/10)},...require('./jump-cpu').initialCommands(p)];}
function notify(w){for(const c of buildInit(w.player))send(w,c);const menu=require('./handlers/core').menu(w.player);send(w,menu);}
function recognizes(id){return id===TRADE||id===PREFIX+'jp'||id===PREFIX+'cl04k'||id===PREFIX+'ajp-01'||TOGGLES.has(id.replace(PREFIX,''))&&id.startsWith(PREFIX);}
function action(s,c){const w=s.world,p=w.player;if(!w.active(s)||p.dead||s.jumping)return false;const key=c.menuItemId.replace(PREFIX,'');
 if(c.menuItemId===TRADE)return tradeWindow(s);if(key==='jp')return require('./jump-cpu').home(s);if(key==='ajp-01')return require('./jump-cpu').list(s);if(key==='cl04k')return cloak(w);
 if(!TOGGLES.has(key)||!available(p,c.menuItemId))return false;const state=read(p);state[key]=!state[key];write(p,state);notify(w);return true;}
function aimChance(p,base,{consume:debit=true}={}){const state=read(p);if(!state.aim)return base;const rate=has(p,'aim-02')?.5:has(p,'aim-01')?.25:0;if(!rate)return base;
 const db=open(),row=db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(p.userId);if((row?.amount||0)<10)return base;
 if(debit&&!db.prepare('UPDATE player_resources SET amount=amount-10 WHERE player_id=? AND ore_type=3 AND amount>=10').run(p.userId).changes)return base;
 return 1-(1-base)*(1-rate);}
function rocketCooldownMultiplier(p){return has(p,'rok-t01')?.5:1;}
function mineCooldownMultiplier(p){return has(p,'min-t02')?.5:has(p,'min-t01')?.75:1;}
function repairFraction(p){return 1/({'equipment_extra_repbot_rep-1':165,'equipment_extra_repbot_rep-2':120,'equipment_extra_repbot_rep-3':105,'equipment_extra_repbot_rep-4':90}[p.repairRobotLootId]||165);}
function repairDrones(w){const p=w.player;if(!p)return false;let repaired=false;
 const spent={credits:0,uridium:0};tx(db=>{db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits,p.uridium,p.userId);for(const drone of require('./drones').owned(db,p.userId)){
 const item=charged(p,['dr-02','dr-01'],db);if(!item)break;const meta=require('./drones').META[drone.loot_id],threshold=item.loot_id.endsWith('02')?100-100/meta.durability:70.000001;
 if(drone.damage+1e-6<threshold)continue;
 const currency=meta.repairable.currency.replace('currency_',''),cost=p.premium?meta.repairable.premiumCost:meta.repairable.baseCost;
 if(p[currency]-spent[currency]<cost)continue;if(!db.prepare(`UPDATE players SET ${currency}=${currency}-? WHERE id=? AND ${currency}>=?`).run(cost,p.userId,cost).changes)continue;
 if(!consume(item,db))throw new Error('CPU charge unavailable');const lower=Math.max(0,drone.level-1);db.prepare('UPDATE drones SET damage=0,level=?,experience=? WHERE id=?').run(lower,require('./drones').nextLevel(lower-1)||0,drone.id);spent[currency]+=cost;repaired=true;
 }});p.credits-=spent.credits;p.uridium-=spent.uridium;return repaired;}
function buyStock(w,id,quantity){const p=w.player,offer=require('./economy').offers(p.userId)[id];if(!/^ammunition_(?:laser|rocket|rocketlauncher)_/.test(id)||!offer||offer.isPaymentItem||!Number.isFinite(offer.price)||offer.price<=0||require('./ammo').count(p,id)+quantity>2147483647)return false;
 const currency=offer.currency==='real'?'uridium':'credits',cost=offer.price*quantity;if(!Number.isSafeInteger(cost)||p[currency]<cost)return false;
 tx(db=>{db.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(p.credits,p.uridium,p.userId);if(!db.prepare(`UPDATE players SET ${currency}=${currency}-? WHERE id=? AND ${currency}>=?`).run(cost,p.userId,cost).changes)throw new Error('CPU bakiye yetersiz.');const row=db.prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL').get(p.userId,id);if(row)db.prepare('UPDATE items SET amount=amount+? WHERE id=?').run(quantity,row.id);else db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(p.userId,id,quantity);});
 p[currency]-=cost;send(w,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});require('./ammo').notify(p,{world:w,sendCmd:w.combat?.send});return true;}
function autoUpgrade(p,now=Date.now()){const eq=equipment(p),lab=require('./handlers/lab');const hasId=id=>eq.some(i=>i.loot_id===PREFIX+id);let changed=false;
 const types=[];if(hasId('nc-awb-x')||hasId('nc-awl-x'))types.push(0);if(hasId('nc-awb-x')||hasId('nc-awr-x'))types.push(1);if(hasId('nc-agb-x'))types.push(2,3);
 tx(db=>{for(const type of types){const row=db.prepare('SELECT * FROM player_ore_buffs WHERE player_id=? AND item_type=?').get(p.userId,type);if(row&&(type<2?row.remaining>0:row.expires_at>now))continue;
 // Weapon CPUs refill the ore selected in the lab. Generator CPU explicitly
 // uses the best available ore. With no saved weapon choice use the local best.
 const allowed=type<2?[7,6,4]:type===2?[6,5]:[7,6,5],choices=type<2&&row?[row.ore_type]:allowed;
 const ore=choices.find(o=>allowed.includes(o)&&(db.prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=?').get(p.userId,o)?.amount||0)>0);if(ore===undefined)continue;
 lab.update(p,{itemToUpdate:{itemValue:type},updateWith:{oreType:{typeValue:ore},count:1}},{db,now});changed=true;}});return changed;
}
function tradeItem(p){return equipment(p).find(i=>i.loot_id===TRADE&&charges(i)>0);}
function tradeAvailable(p){return !!tradeItem(p);}
function tradeWindow(session){const w=session.world,p=w.player,item=tradeItem(p);if(!w.active(session)||p.dead||session.jumping||!item)return false;session.cpuTradeItem=item.id;const info=require('./collectables').tradeInfo(w);info.type=2;info.remainingCharges=charges(item);(w.combat?.send||require('./net').sendCmd)(session,info);return true;}
function sellOre(session,cmd,sendCmd){const w=session.world,p=w.player,item=tradeItem(p),type=cmd.toSell?.oreType?.typeValue,amount=cmd.toSell?.count,prices=require('./collectables').PRICES;
 if(!w.active(session)||p.dead||session.jumping||!item||session.cpuTradeItem!==item.id||!prices[type]||!Number.isSafeInteger(amount)||amount<1)return false;
 const credits=amount*prices[type];if(!Number.isSafeInteger(p.credits+credits))return false;
 tx(db=>{if(!db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=? AND amount>=?').run(amount,p.userId,type,amount).changes)throw new Error('Yetersiz cevher.');if(!consume(item,db))throw new Error('Ticaret şarjı kalmadı.');db.prepare('UPDATE players SET credits=? WHERE id=?').run(p.credits+credits,p.userId);});
 p.credits+=credits;for(const c of require('./collectables').resourceCommands(p))sendCmd(session,c);sendCmd(session,{_:'AttributeCreditsUpdateCommand',credits:p.credits,uridium:p.uridium,jackpot:p.jackpot||0});sendCmd(session,{_:'CPUInfoTradeDroneCommand',chargesLeft:charges(item)});require('./progression').event(session,{type:'sellOre',match:String(type+1),amount});return true;
}
function tick(w,combat,now=Date.now()){const p=w.player;if(!p)return;require('./ship-warp').tick(w);if(p.dead)return;require('./jump-cpu').tick(w,now);require('./automation').tick(w,now);if(now<(w.cpuNextTick||0))return;w.cpuNextTick=now+1000;const s=[...w.sessions].find(s=>w.active(s));if(!s||s.jumping)return;
 const state=read(p),eq=equipment(p);p.cloaked=isCloaked(p);
 if(has(p,'nc-rrb-x')&&!w.movement&&now-(p.lastCombat||0)>=10000&&p.hitPoints<p.hitMax){const bot=eq.filter(i=>i.loot_id.startsWith('equipment_extra_repbot_')).sort((a,b)=>b.loot_id.localeCompare(a.loot_id))[0];if(bot){p.repairRobotLootId=bot.loot_id;p.repairing=true;}}
 for(const [suffix,threshold,quantity]of [['alb-x',1000,10000],['rb-x',100,500]]){
  const item=state[suffix]&&eq.find(i=>i.loot_id===PREFIX+suffix),selected=item&&require('./cpu-ammo').selected(p.userId,item);
  if(selected&&require('./ammo').count(p,selected)<threshold)buyStock(w,selected,quantity);
 }
 if(state['fb-x']&&has(p,'fb-x')){const pet=require('./pet').owned(p.userId),price=open().prepare("SELECT price_uridium FROM item_types WHERE loot_id='resource_pet-fuel'").get()?.price_uridium??.25;if(pet&&pet.fuel<1000&&p.uridium>=10000*price)require('./pet').buyFuel(w,10000);}
 if(eq.some(i=>['nc-awb-x','nc-awl-x','nc-awr-x','nc-agb-x'].some(s=>i.loot_id===PREFIX+s))&&autoUpgrade(p,now)){require('./handlers/lab').refresh(w);for(const c of [...require('./handlers/lab').buildInit(p),...require('./collectables').resourceCommands(p)])send(w,c);}
 if(eq.some(i=>i.loot_id===PREFIX+'aim-01'||i.loot_id===PREFIX+'aim-02')){const amount=open().prepare('SELECT amount FROM player_resources WHERE player_id=? AND ore_type=3').get(p.userId)?.amount||0;if(amount!==w.cpuXenomit){w.cpuXenomit=amount;send(w,{_:'CPUInfoAimCommand',isActive:!!state.aim,possibleChargesLeft:Math.floor(amount/10)});for(const c of require('./collectables').resourceCommands(p))send(w,c);}}
 if(state['arol-x']&&has(p,'arol-x')&&s.attacking)combat.rocket(s,{targetId:s.attacking});
 if(state['rg-sl']&&has(p,'rg-sl')&&s.attacking){const selected=s.selected;s.selected=s.attacking;try{require('./advanced-weapons').fireCannon(s,undefined,now);}finally{s.selected=selected;}}
 if(state['ags-x']&&has(p,'ags-x')&&s.attacking){const selected=s.selected;s.selected=s.attacking;try{require('./advanced-weapons').fireDrive(s,undefined,now);}finally{s.selected=selected;}}
}
module.exports={PREFIX,TRADE,CAPACITY,equipment,has,read,write,charges,charged,consume,buildInit,menuStatus,notify,recognizes,action,isCloaked,cloakCommand,breakCloak,cloak,purchased,aimChance,rocketCooldownMultiplier,mineCooldownMultiplier,repairFraction,repairDrones,tick,autoUpgrade,tradeAvailable,tradeWindow,sellOre};
