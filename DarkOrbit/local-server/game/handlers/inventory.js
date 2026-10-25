'use strict';
// Packet fields/result=1 follow the decompiled porting.hangar modules and
// WarpControlsProxy.shipsItemMove; no recorded account inventory is replayed.
const inventory=require('../inventory');
const {open}=require('../db');
const {computeStats}=require('../stats');

function register(onCmd,{sendCmd}) {
  const player=session=>{
    if(!session.player) throw new Error('Oturum açılmadı.');
    return session.player;
  };
  const attempt=(session,command,field,work)=>{
    let result=0;
    try { work(player(session)); result=1; } catch(e) { console.warn(`[inventory] ${e.message}`); }
    sendCmd(session,{_:command,[field]:result,errorMessage:null});
  };
  onCmd('HangarListRequest',session=>sendCmd(session,inventory.buildInit(player(session))));
  onCmd('HangarShipEquipmentRequest',(session,cmd)=>{
    const p=player(session);
    try { sendCmd(session,inventory.equipmentCommand(p.userId,cmd.shipId)); } catch(e) { console.warn(`[inventory] ${e.message}`); }
  });
  onCmd('HangarShipDetailRequest',(session,cmd)=>{
    const p=player(session),db=open();
    try {
      const s=inventory.shipFor(db,p.userId,cmd.shipId);
      const eq=inventory.statItems(db,s.id,inventory.activeConfig(db,s.id));
      const stats=require('../ship-passives').applyStats(s.loot_id,computeStats({loot_id:s.loot_id,hitpoints:s.hit_max,speed:s.speed,cargo:s.cargo},eq));
      const count=category=>db.prepare('SELECT COALESCE(SUM(i.amount),0) AS n FROM items i JOIN item_types t ON t.loot_id=i.loot_id WHERE i.player_id=? AND t.category=?').get(p.userId,category).n;
      sendCmd(session,{_: 'HangarShipDetailCommand',shipId:s.id,lootId:s.loot_id,curDesignLootId:inventory.shipAppearance(db,s),designList:inventory.availableDesigns(db,s),
        hp:s.id===p.shipId?p.hitPoints:s.hitpoints,maxHp:stats.hitMax,shield:s.id===p.shipId?p.shield:s.shield,
        maxSpeed:stats.speed,laserCount:stats.laserCount,speedGenerators:eq.filter(i=>i.category==='speed_generator').length,
        shieldGenerators:eq.filter(i=>i.category==='shield_generator').length,laserAmmo:count('ammo_laser'),rockets:count('ammo_rocket'),isActive:s.id===p.shipId,isFavorite:!!s.favorite});
    } catch(e) { console.warn(`[inventory] ${e.message}`); }
  });
  onCmd('HangarShipMoveItemsRequest',(session,c)=>attempt(session,'HangarShipMoveItemsCommand','result',p=>{
    const request={hangarId:c.hangarId,from:{target:c.source,items:c.items,configId:c.configId,slotset:c.slotSet,droneId:c.droneId},to:{target:c.destination,configId:c.configId,slotset:c.slotSet,index:c.index,droneId:c.droneId}};
    return c.source==='pet'||c.destination==='pet'?require('../pet').move(p.userId,request):c.source==='drone'||c.destination==='drone'?require('../drones').move(p.userId,request):inventory.move(p.userId,request);
  }));
  onCmd('HangarShipFavouriteRequest',(s,c)=>attempt(s,'HangarShipFavouriteCommand','resultId',p=>inventory.favourite(p.userId,c.shipId,c.favourite===1)));
  onCmd('HangarShipChangeShipModelRequest',(s,c)=>attempt(s,'HangarShipChangeShipModelCommand','resultId',p=>inventory.changeDesign(p.userId,c.shipId,c.lootId)));
  onCmd('HangarShipImportConfigRequest',(s,c)=>{
    let resultId=0;try{inventory.importConfig(player(s).userId,c.originShipId,c.targetShipId);resultId=1;}catch(e){console.warn(`[inventory] ${e.message}`);}
    sendCmd(s,{_: 'HangarShipImportConfigCommand',resultId,shipId:c.targetShipId,errorMessage:null});
  });
  onCmd('HangarShipClearConfigRequest',(s,c)=>attempt(s,'HangarShipClearConfigCommand','resultId',p=>inventory.clear(p.userId,c.shipId,c.configId)));
  onCmd('HangarShipSaveConfigRequest',(s,c)=>attempt(s,'HangarShipSaveConfigCommand','resultId',p=>inventory.saveLayout(p.userId,c.shipId)));
  onCmd('HangarShipLoadConfigRequest',(s,c)=>{
    let result=0;
    try { result=inventory.loadLayout(player(s).userId,c.shipId)?1:2; } catch(e) { console.warn(`[inventory] ${e.message}`); }
    sendCmd(s,{_: 'HangarShipLoadConfigCommand',resultId:result,title:null,description:null});
  });
}
module.exports={register};
