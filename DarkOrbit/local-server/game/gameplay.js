'use strict';
const { sendCmd: defaultSend } = require('./net');
const maps = require('./maps');
const loot = require('./collectables');
const { open } = require('./db');
let services = { sendCmd: defaultSend };
function deathCommand(world,killerName='') {
  return require('./respawn').command(world,killerName);
}
function initialize(world) {
  if(!world.player)return [];
  if(!world.collectables||world.collectables.mapId!==world.player.mapId) {
    world.collectables?.clear();world.collectables=new loot.Collectables(world,services.sendCmd);world.collectables.populate();
  }
  const out=[...maps.commands(world),...loot.resourceCommands(world.player),...world.collectables.commands(),maps.beacon(world),...require('./respawn').buildInit(world)];
  if(world.player.dead)out.push(deathCommand(world));
  return out;
}
function changeMap(session,map,x,y,portal) {
  const world=session.world,p=world.player;
  require('./ship-warp').cancel(session,false);
  const gates=require('./galaxy-gates');
  if(gates.isGateMap(map) && !gates.canEnter(world,map)){session.jumping=false;return false;}
  if(portal && !gates.prepareTransition(world,portal)){session.jumping=false;return false;}
  require('./pet').stop(world,{notify:true,resume:true});
  world.combat?.stop();world.cancelScheduled();world.stopMovement();
  world.collectables?.clear();world.collectables=null;
  Object.assign(p,{mapId:map,x,y,repairing:false});
  session.jumping=false;world.save();
  services.sendCmd(session,{_:'JumpToServerCommand'});
  for(const c of services.buildInit(world))services.sendCmd(session,c);
  if(world.petResume){world.petResume=false;require('./pet').launch(world);}
  services.combatFor(world).start();
  require('./progression').event(session,{type:'mapVisit',mapId:map,amount:1});
  return true;
}
function jump(session,gateId) {
  const world=session.world,p=world.updatePosition();
  if(!world.active(session)||p.dead||session.jumping)return false;
  const gate=maps.nearestPortal(world) || require('./galaxy-gates').nearestPortal(world);
  if(!gate||(gateId!==undefined&&gate.id!==gateId))return false;
  if(require('./galaxy-gates').isGateMap(gate.target_map)&&!require('./galaxy-gates').canEnter(world,gate.target_map)){
    const reason=require('./galaxy-gates').entryRestriction(world,gate.target_map);
    if(reason)services.sendCmd(session,{_:'LegacyModule',message:`0|A|STD|${reason}`});return false;
  }
  const requiredLevel=maps.portalAccessLevel(gate,p);
  if(p.level<requiredLevel){
    services.sendCmd(session,{_:'JumpDeniedCommand',mandatoryLevel:requiredLevel});
    // This client ships the module but has no JumpDeniedCommand handler.
    // Its native standard-message channel makes the actual restriction visible.
    const target=maps.getMap(gate.target_map);
    services.sendCmd(session,{_:'LegacyModule',message:`0|A|STD|${target?.name||'Hedef harita'} için en az ${requiredLevel}. seviye gerekli.`});
    return false;
  }
  if(!maps.getMap(gate.target_map))return false;
  world.stopMovement();session.jumping=true;
  world.combat?.cancelProjectiles();
  world.combat?.abort(session);
  services.sendCmd(session,{_:'JumpInitiatedCommand',mapId:gate.target_map,gateId:gate.id});
  world.schedule(()=>{if(world.active(session))changeMap(session,gate.target_map,gate.target_x,gate.target_y,gate);},world.config.gameplay?.jumpDelayMs??2000);
  return true;
}
function repair(session,cmd) {
  return require('./respawn').repair(session,cmd,{changeMap,sendCmd:services.sendCmd});
}
function instantRepair(session,cmd) {
  const w=session.world,p=w.updatePosition(),s=maps.station(w);
  if(!w.active(session)||p.dead||session.jumping||!s||s.factionId!==p.factionId||cmd.repairAssetId!==150000021)return false;
  const dock={x:s.x,y:s.y+(s.factionId===3?1080:-1080)};
  if(maps.dist(p,dock)>350)return false;
  p.hitPoints=p.hitMax;p.shield=p.shieldMax;w.save();
  services.sendCmd(session,{_:'HitpointInfoCommand',hitpoints:p.hitPoints,hitpointsMax:p.hitMax,nanoHull:p.nanoHull||0,nanoHullMax:p.maxNanoHull||0});
  services.sendCmd(session,{_:'AttributeShieldUpdateCommand',shieldNow:p.shield,shieldMax:p.shieldMax});return true;
}
function menuAction(session,cmd) {
  const localAction=require('./menu-capabilities').capability(cmd.menuItemId);
  if(localAction.handler==='pet'||localAction.handler==='quick-buy')return require('./menu-capabilities').action(session,cmd);
  if(localAction.handler==='techs')return require('./techs').action(session,cmd);
  if(require('./advanced-weapons').recognizes(cmd.menuItemId))return require('./advanced-weapons').action(session,cmd);
  if(require('./cpu').recognizes(cmd.menuItemId))return require('./cpu').action(session,cmd);
  if(require('./ship-abilities').recognizes(cmd.menuItemId))return require('./ship-abilities').action(session,cmd);
  if(require('./combat-utilities').recognizes(cmd.menuItemId)){
    try{return require('./combat-utilities').action(session,cmd);}catch(error){console.warn('[utilities]',error.message);services.sendCmd(session,{_:'LegacyModule',message:'0|A|STD|Yetersiz kaynak veya işlem kaydedilemedi.'});return false;}
  }
  if(require('./hellstorm').recognizes(cmd.menuItemId))return require('./hellstorm').action(session,cmd);
  if(/^ammunition_laser_/.test(cmd.menuItemId)) {
    if(cmd.actionType!==1)return false;
    return services.combatFor(session.world).attack(session,session.selected);
  }
  if(require('./rocket-types')[cmd.menuItemId]) {
    const p=session.world.player;if(!session.world.active(session)||p.dead)return false;
    if(!open().prepare('SELECT 1 FROM items WHERE player_id=? AND loot_id=? AND amount>0 AND ship_id IS NULL').get(p.userId,cmd.menuItemId))return false;
    p.rocket=cmd.menuItemId;
    for(const c of require('./ammo').buildAmmoCommands(p))services.sendCmd(session,c);
    if(cmd.actionType===1)return services.combatFor(session.world).rocket(session,{targetId:session.selected});
    return true;
  }
  if(!/^equipment_extra_repbot_/.test(cmd.menuItemId))return false;
  const w=session.world,p=w.updatePosition();if(!w.active(session)||p.dead||session.jumping)return false;
  const inventory=require('./inventory');
  const item=inventory.equipped(open(),p.shipId,inventory.activeConfig(open(),p.shipId)).find(i=>i.slot==='extra'&&(i.loot_id===cmd.menuItemId||(cmd.menuItemId==='equipment_extra_repbot_rep'&&i.loot_id.startsWith('equipment_extra_repbot_'))));
  if(!item||w.movement||Date.now()-(p.lastCombat||0)<10000)return false;
  p.repairRobotLootId=item.loot_id;p.repairing=!p.repairing;services.sendCmd(session,maps.beacon(w));return true;
}
function activate(session,cmd) {
  if(!session.world.active(session)||session.player.dead||session.jumping)return false;
  if([...maps.portals(session.player.mapId,session.player.factionId),...require('./galaxy-gates').portalRows(session.world)].some(g=>g.id===cmd.mapAssetId))return jump(session,cmd.mapAssetId);
  const w=session.world,s=maps.station(w);if(!s||!maps.nearStation(w))return false;
  if(s.kind==='pirate-trade'&&cmd.mapAssetId===150000022&&maps.dist(w.updatePosition(),s)<=350){services.sendCmd(session,loot.tradeInfo(w));return true;}
  const sign=s.factionId===1?1:-1;
  if(cmd.mapAssetId===150000022&&maps.dist(w.updatePosition(),{x:s.x-1080*sign,y:s.y})<=350){services.sendCmd(session,loot.tradeInfo(w));return true;}
  return false;
}
function trade(session) {
  const w=session.world;
  if(!w.active(session)||session.player.dead||session.jumping)return false;
  w.updatePosition();
  for(const command of loot.resourceCommands(session.player))services.sendCmd(session,command);
  if(maps.nearStation(w)){
    delete session.cpuTradeItem;
    services.sendCmd(session,loot.tradeInfo(w));return true;
  }
  if(require('./cpu').tradeWindow(session))return true;
  services.sendCmd(session,{_:'LegacyModule',message:'0|A|STD|Ham madde satmak için ticaret istasyonuna yaklaş.'});
  return false;
}
function register(onCmd,dependencies) {
  services={...services,...dependencies};
  onCmd('JumpRequest',session=>jump(session));
  onCmd('JumpCPUUpdateRequest',session=>require('./jump-cpu').list(session));
  onCmd('JumpCPUSelectRequest',(session,cmd)=>require('./jump-cpu').select(session,cmd.mapId));
  onCmd('ActivationRequest',(session,cmd)=>{const id=({5:'equipment_extra_cpu_cl04k',9:'equipment_extra_cpu_jp',10:'equipment_extra_cpu_ajp-01'})[cmd.activationTypeValue];if(id)return menuAction(session,{menuItemId:id,actionType:1});});
  onCmd('AttackRocketRequest',(session,cmd)=>services.combatFor(session.world).rocket(session,cmd));
  onCmd('MapAssetActivationRequest',activate);
  onCmd('CollectBoxRequest',(session,cmd)=>session.world.collectables?.beginHarvest(session,cmd));
  onCmd('HarvestRequest',(session,cmd)=>session.world.collectables?.beginHarvest(session,cmd,true));
  onCmd('TradeSellOreRequest',(session,cmd)=>loot.sell(session,cmd,services.sendCmd));
  onCmd('TradeRequest',trade);
  onCmd('KillScreenRepairRequest',repair);
  onCmd('InstantRepairRequest',instantRepair);
}
module.exports={register,initialize,deathCommand,jump,changeMap,repair,instantRepair,menuAction,trade};
