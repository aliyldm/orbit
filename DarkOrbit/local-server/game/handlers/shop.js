'use strict';
const economy=require('../economy');
const inventory=require('../inventory');
const {open}=require('../db');
const META=require('../../docs/client-map.items.json').items;
function matches(category,offer,id) {
 const m=META[id];
 // The portal calls its Extras page "special". In the native shop these
 // ordinary CPU/material products belong under Extras, leaving the limited
 // special list for complete campaign offers rather than duplicate aliases.
 if(category==='extras'&&offer.category==='special'&&!offer.localPayment)return true;
 if(offer.category===category)return true;
 if(category==='shipdesign')return offer.category==='model';
 if(category==='laser')return m?.kind==='Weapon';
 if(category==='ammunition')return id.startsWith('ammunition_');
 if(category==='extras')return /^resource_booty-key(?:-red|-blue)?$/.test(id)||(!!m?.typeClass?.includes('.extra.')&&!m.typeClass.endsWith('.BoosterType'));
 if(category==='petgear')return offer.category==='petGear';
 if(category==='protocol')return offer.category==='pet_protocol';
 if(category==='customization')return offer.category==='droneDesign'||offer.category==='petDesign';
 return false;
}
function list(player,category) {
 const offers=economy.offers(player.userId),db=open();
 const items=Object.entries(offers).filter(([id,o])=>matches(category,o,id)&&(category!=='special'||(o.localPayment&&!o.paymentAlias))&&(!o.disabledReason||o.disabledReason===require('../laser-sales').reason(id,o))&&(!o.localPayment||!require('../payment').reason(require('../payment').entry(o.paymentSku),db))&&(!META[id]?.typeClass?.includes('.pet.')||id==='pet_pet10'||o.levels)&&(o.localPayment||META[id]||db.prepare('SELECT 1 FROM ship_types WHERE loot_id=?').get(id)));
 items.sort((a,b)=>require('../../web/portal/shop-sort').compare(a[1],b[1]));
 return {_: 'ShopItemListCommand',category,currentShipLootId:player.typeId,promptList:['ship','shipdesign','laser','ammunition','generator','extras','booster','drone','petgear','protocol','customization','special'].map(category=>({_: 'ShopLabelPrompt',category,promptType:0})),itemList:items.slice(0,127).map(([lootId,o])=>({
  _: 'ShopItemCommand',lootId,category,price:[Number(o.price)||0],currency:o.currency||'',cost:String(o.price||0),discountPercent:'1',maxAmount:o.localPayment?o.maxAmount:META[lootId]?.kind==='Drone'||lootId.startsWith('ship_')?1:inventory.CATEGORY_SLOT[db.prepare('SELECT category FROM item_types WHERE loot_id=?').get(lootId)?.category]?1000:10000000,
  isPaymentItem:o.isPaymentItem?1:0,maxlevel:o.levels?Math.max(1,...Object.keys(o.levels).map(Number).filter(l=>(require('../pet').owned(player.userId)?.level||0)>=require('../pet-catalog').minimumPetLevel(l))):-1,buyMore:true,amountsSelectable:'',levelGrades:o.levels?Object.keys(o.levels).join(','):'',LevelDataList:o.levels?Object.values(o.levels).map(l=>({_:'ShopItemLevelDataCommand',currency:l.currency,isElite:1,discountPercent:'1',price:l.price,cost:String(l.price),isPaymentItem:0})):[],isActiveEventItem:0
 }))};
}
function register(onCmd,{sendCmd}) {
 onCmd('ShopItemListRequest',(s,c)=>{if(s.player)sendCmd(s,list(s.player,c.category));});
 onCmd('ShopItemBuyRequest',(s,c)=>{
  if(!s.player)return;
  const p=s.player,offer=economy.offers(p.userId)[c.lootId];
  const result=offer&&matches(c.category,offer,c.lootId)?economy.purchase(p.userId,c.lootId,c.amount,c.category,c.level):{result:'error'};
  const type=open().prepare('SELECT category FROM item_types WHERE loot_id=?').get(c.lootId);
  const slot=type&&inventory.slotFor({...type,loot_id:c.lootId}),config=inventory.activeConfig(open(),p.shipId);
  const empty=slot?inventory.freeSlots(open(),p.shipId,slot,config).length:0;
  const ids=result.result==='success'&&slot?open().prepare('SELECT id FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL ORDER BY id DESC LIMIT ?').all(p.userId,c.lootId,Math.min(c.amount,empty)).map(i=>i.id):[];
  sendCmd(s,{_: 'ShopItemBuyCommand',resultId:result.result==='success'?1:0,lootId:c.lootId,category:c.category,buyCategory:c.buyCategory,action:c.action,
   realBuyAmount:result.result==='success'?c.amount:0,hangarId:p.shipId,configId:config,slotSet:inventory.SLOTSET[slot]||'',hintEquipTo:slot?'ship':'',emptySlotCount:empty,canEquipItemId:ids,allowAutoEquip:empty?1:0,errorMessage:null,sucessMessage:null});
  if(result.result==='success')sendCmd(s,inventory.buildInit(p));
 });
}
module.exports={register,list};
