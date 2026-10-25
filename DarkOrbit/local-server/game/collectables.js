'use strict';
const crypto = require('crypto');
const { open, tx } = require('./db');
const maps = require('./maps');
const progression = require('./progression');
const ORES = ['prometium','endurium','terbium','xenomit','prometid','duranium','promerium','seprom','palladium'];
// Native trade supports Seprom (750 base credits); zero disables its stepper.
const PRICES = Object.freeze([10,15,25,0,200,200,500,750,0]);
const oreCount = (type,count) => ({ _: 'OreCountModule', oreType: { _: 'OreTypeModule', typeValue: type }, count });
function resourceCommands(p) {
  const rows = open().prepare('SELECT ore_type, amount FROM player_resources WHERE player_id = ?').all(p.userId);
  const counts = new Map(rows.map(r => [r.ore_type,r.amount]));
  const used = rows.reduce((a,r)=>a+(r.ore_type===3?0:r.amount),0); p.cargoSpace = Math.max(0,p.cargoSpaceMax-used);
  return [{ _: 'AttributeOreCountUpdateCommand', oreCountList: ORES.map((_,i) => oreCount(i,counts.get(i)||0)) }];
}
class Collectables {
  constructor(world, send) { this.world = world; this.send = send; this.boxes = new Map(); this.mapId = world.player.mapId; }
  command(box) { return box.oreType === undefined ? { _: 'AddBoxCommand', hash: box.hash, x: box.x, y: box.y, boxType: box.boxType } : { _: 'AddOreCommand', hash: box.hash, x: box.x, y: box.y, oreType: { _: 'OreTypeModule', typeValue: box.oreType } }; }
  add(box, broadcast = true) {
    const entity = { hash: crypto.randomBytes(12).toString('hex'), ...box };
    if(entity.pirateField&&!require('./pirate-fields').contains(this.mapId,entity))Object.assign(entity,require('./pirate-fields').point(require('./pirate-fields').FIELDS[this.mapId]));
    this.boxes.set(entity.hash,entity);
    if (broadcast) this.world.broadcast(s => this.send(s,this.command(entity)));
    return entity;
  }
  populate() {
    const m = maps.getMap(this.mapId);
    if(require('./galaxy-gates').isGateMap(this.mapId))return;
    for (let i=0;i<24;i++) this.add({ x: Math.round(800+Math.random()*(m.width-1600)), y: Math.round(800+Math.random()*(m.height-1600)), boxType:'BONUS_BOX', bonus:true, respawnMs:30000 },false);
    for (let i=0;i<36;i++) this.add({ x: Math.round(800+Math.random()*(m.width-1600)), y: Math.round(800+Math.random()*(m.height-1600)), oreType:i%3, amount:10, respawnMs:15000 },false);
    require('./pirate-fields').populate(this);
    require('./booty').populate(this);
  }
  commands() { return [...this.boxes.values()].map(b => this.command(b)); }
  cargoFull(session) {
    for(const c of resourceCommands(session.player))this.send(session,c);
    // ConnectionManager's native CARGO_FULL branch localizes "loadfull".
    this.send(session,{_:'LegacyModule',message:'0|f'});
  }
  cancelHarvest(session, notify=true) {
    if(!session.harvest)return;
    const harvest=session.harvest,box=this.boxes.get(harvest.hash);
    clearTimeout(harvest.timer);this.world.scheduled.delete(harvest.timer);session.harvest=null;
    if(box?.opening===harvest)delete box.opening;
    if(notify&&this.world.active(session))this.send(session,{_:'LegacyModule',message:harvest.booty?'0|y|SLC':`0|A|SLC|0|${session.player.userId}`});
  }
  beginHarvest(session,cmd,oreOnly=false) {
    const w=this.world,p=w.updatePosition(),box=this.boxes.get(cmd.itemHash);
    if(!w.active(session)||p.dead||session.jumping||!box||box.expires<Date.now()||maps.dist(p,box)>180||((box.oreType!==undefined)!==oreOnly))return false;
    if(session.harvest?.hash===box.hash)return false;
    const ores=box.remainingOres||box.ores||(box.oreType===undefined?[]:[{type:box.oreType,amount:box.amount}]);
    if(ores.length&&!ores.some(o=>o.type===3&&o.amount>0)) {
      resourceCommands(p);
      if(p.cargoSpace<=0){this.cargoFull(session);return false;}
    }
    const booty=!!require('./booty').type(box);
    if(booty&&!require('./booty').canOpen(w,box)&&!require('./automation').ensureBootyKey(w,box)){this.send(session,{_:'LegacyModule',message:'0|A|STD|Bu kutu için uygun korsan anahtarın yok.'});return false;}
    require('./ship-abilities-expanded').breakUltimate(w);
    this.cancelHarvest(session);w.stopMovement();if(!booty)w.combat?.abort(session);
    const delay=booty?Math.max(1000,w.config.booty?.openingMs??5000):(w.config.gameplay?.harvestDelayMs??500);
    this.send(session,{_:'LegacyModule',message:booty?`0|y|SLA|${Math.ceil(delay/1000)}`:`0|A|SLA|0|${p.userId}`});
    const harvest={hash:box.hash,booty,player:p,readyAt:Date.now()+delay};session.harvest=harvest;if(booty)box.opening=harvest;
    harvest.timer=w.schedule(()=>{
      if(session.harvest!==harvest)return;
      session.harvest=null;
      try{if(!this.collect(session,{itemHash:box.hash},null,harvest))this.send(session,{_:'LegacyModule',message:booty?'0|y|SLC':`0|A|SLC|0|${p.userId}`});}
      finally{if(box.opening===harvest)delete box.opening;}
    },delay);
    return true;
  }
  cargo(npc) {
    const ores=require('./npc-cargo').resolve(npc.def,{player:this.world.player,mapId:this.mapId})??npc.def.cargo;
    if(!ores?.length)return null;
    const box = this.add({ x:Math.round(npc.x),y:Math.round(npc.y),boxType:'FROM_SHIP', ores:structuredClone(ores), expires:Date.now()+120000 });
    this.world.schedule(() => { if(this.boxes.delete(box.hash)) this.world.broadcast(s=>this.send(s,{_:'RemoveCollectableCommand',hash:box.hash,collected:false})); },120000);
    return box;
  }
  collect(session,cmd,collector=null,opening=null) {
    const w = this.world,p = w.updatePosition();
    if (!w.active(session)||p.dead||session.jumping||p.mapId!==this.mapId) return false;
    const box=this.boxes.get(cmd.itemHash);
    if(collector&&(collector!==w.petRuntime||!collector.active))return false;
    // Do not let the auto-looter remove a box during the player's beam.
    if(collector&&[...w.sessions].some(s=>s.harvest?.hash===cmd.itemHash))return false;
    if(!box||box.expires<Date.now()||maps.dist(collector||p,box)>180) return false;
    const booty=require('./booty'),bootyType=booty.type(box);
    if(bootyType&&(collector||!opening||box.opening!==opening||opening.player!==p||Date.now()<opening.readyAt))return false;
    if(!collector)require('./ship-abilities-expanded').breakUltimate(w);
    const skills=p.stats.skills||require('./skills').effects(p.userId);
    let ores=box.ores || (box.oreType===undefined ? [] : [{type:box.oreType,amount:box.amount}]);
    const oreFactor = require('./boosters').collectionMultiplier(p.userId, 'ore');
    const salvage=collector&&box.ores?collector.stats.effects.salvageMultiplier:1;
    // Once a cargo box is partially collected, retain its already adjusted
    // remaining contents. Reopening must not apply skill/PET bonuses again.
    ores=box.remainingOres?structuredClone(box.remainingOres):ores.map(o=>({...o,amount:Math.round(o.amount*oreFactor*(box.ores?(skills.cargoLootMultiplier??1):1))*salvage})).map(o=>({...o,amount:Math.round(o.amount)}));
    let remaining=[];
    if (ores.length) {
      const used=open().prepare('SELECT COALESCE(SUM(amount),0) n FROM player_resources WHERE player_id=? AND ore_type<>3').get(p.userId).n;
      let free=Math.max(0,p.cargoSpaceMax-used);
      const available=ores;
      ores=ores.map(o=>{const amount=o.type===3?o.amount:Math.min(free,o.amount);if(o.type!==3)free-=amount;return {...o,amount};}).filter(o=>o.amount>0);
      if(!ores.length){if(!collector)this.cargoFull(session);return false;}
      tx(db=>{const insert=db.prepare('INSERT INTO player_resources(player_id,ore_type,amount) VALUES(?,?,?) ON CONFLICT(player_id,ore_type) DO UPDATE SET amount=amount+excluded.amount');for(const o of ores)insert.run(p.userId,o.type,o.amount);});
      remaining=available.map(o=>({...o,amount:o.amount-(ores.find(g=>g.type===o.type)?.amount||0)})).filter(o=>o.amount>0);
    } else if(box.reward||box.bonus||bootyType) {
      // Draw once for this box; a failed SQL commit does not reroll its prize.
      box.pendingReward ||= structuredClone(box.reward||(bootyType?booty.roll(box,p):require('./bonus-boxes').roll(p.mapId)));
      const reward=structuredClone(box.pendingReward);
      const bonusFactor = require('./boosters').collectionMultiplier(p.userId, 'bonusBox')*(collector?collector.stats.effects.salvageMultiplier:1);
      if(!bootyType){
        if(reward.credits)reward.credits=Math.round(reward.credits*(skills.bonusLootMultiplier??1)*bonusFactor);
        if(reward.uridium)reward.uridium=Math.round(reward.uridium*(skills.bonusLootMultiplier??1)*(skills.bonusUridiumMultiplier??1)*bonusFactor);
        for(const id of Object.keys(reward.items||{}))reward.items[id]=Math.round(reward.items[id]*(skills.bonusLootMultiplier??1)*bonusFactor);
        if(reward.energy)reward.energy=Math.round(reward.energy*(skills.bonusLootMultiplier??1)*bonusFactor);
      }
      if(!require('./loot-rewards').grant(w,box,reward,{key:bootyType?.key,profile:bootyType?booty.PROVENANCE:require('./bonus-boxes').PROVENANCE}))return false;
      box.grantedReward=reward;
    }
    if(remaining.length){
      box.remainingOres=remaining;
      if(!collector)this.send(session,{_:'LegacyModule',message:`0|A|SLC|0|${p.userId}`});
    }else{
      this.boxes.delete(box.hash);
      w.broadcast(s=>this.send(s,{_:'RemoveCollectableCommand',hash:box.hash,collected:true}));
    }
    if(box.grantedReward){require('./loot-rewards').notify(w,session,this.send,box.grantedReward);if(bootyType)for(const c of booty.buildInit(p))this.send(session,c);}
    if(ores.length) {
      require('./automation').tick(w,Date.now(),true);
      for(const c of resourceCommands(p))this.send(session,c);
      if(remaining.length&&!collector&&p.cargoSpace<=0)this.cargoFull(session);
      this.send(session,{_:'LMCollectResourcesCommand',priorityMode:{_:'LogMessengerPriorityModule',priorityModeValue:0},contentList:ores.map(o=>oreCount(o.type,o.amount))});
      for(const o of ores)progression.event(session,{type:'collectLoot',lootId:`resource_ore_${ORES[o.type]}`,amount:o.amount});
      if(box.ores&&!box.cargoClaimed){progression.event(session,{type:'cargo',amount:1});box.cargoClaimed=true;}
    }
    if(box.reward||box.bonus)progression.event(session,{type:'collectLoot',lootId:'bonus_box',amount:1});
    if(!remaining.length&&box.respawnMs){const next={...box};for(const field of ['hash','pendingReward','grantedReward','opening','remainingOres','cargoClaimed'])delete next[field];w.schedule(()=>this.add(require('./pirate-fields').respawn(this.mapId,next)),box.respawnMs);}
    return true;
  }
  clear() { for(const s of this.world.sessions)this.cancelHarvest(s);this.boxes.clear(); }
}
function sell(session,cmd,send) {
  const w=session.world,p=w.updatePosition(),s=maps.station(w);
  if(w.petRuntime?.active&&w.petRuntime.gear===8)return require('./pet-special').sell(session,cmd,send);
  if(session.cpuTradeItem)return require('./cpu').sellOre(session,cmd,send);
  const type=cmd.toSell?.oreType?.typeValue,amount=cmd.toSell?.count;
  if(!w.active(session)||p.dead||session.jumping||!s||s.factionId!==p.factionId||maps.dist(p,s)>1800||!Number.isInteger(type)||!PRICES[type]||!Number.isSafeInteger(amount)||amount<=0)return false;
  const credits=amount*PRICES[type];if(!Number.isSafeInteger(p.credits+credits))return false;
  tx(db=>{
    const changed=db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=? AND amount>=?').run(amount,p.userId,type,amount);
    if(!changed.changes)throw new Error('Yetersiz cevher');
    db.prepare('UPDATE players SET credits=? WHERE id=?').run(p.credits+credits,p.userId);
  });
  p.credits+=credits;for(const c of resourceCommands(p))send(session,c);
  send(session,{_:'LegacyModule',message:`0|LM|ST|CRE|${credits}|${p.credits}`});
  progression.event(session,{type:'sellOre',match:String(type+1),amount});return true;
}
function tradeInfo(world) { return { _:'OreTradeInfoCommand',type:maps.station(world||{})?.kind==='pirate-trade'?5:1,remainingCharges:0,prometiumPrice:PRICES[0],enduriumPrice:PRICES[1],terbiumPrice:PRICES[2],prometidPrice:PRICES[4],duraniumPrice:PRICES[5],promeriumPrice:PRICES[6],sepromPrice:PRICES[7],palladiumExchangeRate:15,osmiumPrice:0 }; }
function exchangePalladium(session,raw,send){
  const w=session.world,p=w.updatePosition(),s=maps.station(w),amount=Number(raw);
  if(!w.active(session)||p.dead||session.jumping||s?.kind!=='pirate-trade'||!maps.nearStation(w)||!Number.isSafeInteger(amount)||amount<=0||amount%15!==0||amount>2147483640)return false;
  const energy=amount/15;
  const ok=tx(db=>{
    db.prepare('INSERT OR IGNORE INTO galaxy_gate_accounts(player_id)VALUES(?)').run(p.userId);
    if(!db.prepare('SELECT 1 FROM galaxy_gate_accounts WHERE player_id=? AND energy<=?').get(p.userId,2147483647-energy))return false;
    if(!db.prepare('UPDATE player_resources SET amount=amount-? WHERE player_id=? AND ore_type=8 AND amount>=?').run(amount,p.userId,amount).changes)return false;
    db.prepare('UPDATE galaxy_gate_accounts SET energy=energy+? WHERE player_id=?').run(energy,p.userId);return true;
  });
  if(ok){for(const c of resourceCommands(p))send(session,c);send(session,{_: 'LegacyModule',message:`0|A|STD|${amount} Palladium karşılığında ${energy} ekstra enerji alındı.`});}
  return ok;
}
module.exports={Collectables,resourceCommands,sell,tradeInfo,exchangePalladium,ORES,PRICES};
