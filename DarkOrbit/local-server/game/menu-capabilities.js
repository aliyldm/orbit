'use strict';
// Every original action-bar row is audited against a real local dispatcher.
// A captured enabled flag is not proof that the local server implements it.
const TEMPLATE=require('./templates/init.json').commands.find(c=>c._==='MenuInitializationCommand');
const QUICK_OFFERS=require('../web/portal/shop.json');let techModule;
function techs(){if(techModule!==undefined)return techModule;try{return techModule=require('./techs');}catch(e){if(e.code==='MODULE_NOT_FOUND'&&e.message.includes("'./techs'"))return techModule=null;throw e;}}
function capability(id){
 if(require('./laser-ammo').supported(id))return{status:id==='ammunition_laser_pib-100'?'partial':'implemented',handler:'laser',reason:id==='ammunition_laser_pib-100'?'Temel hasar çalışır; enfeksiyon etkisi henüz uygulanmadı.':''};
 if(require('./advanced-weapons').recognizes(id))return{status:'implemented',handler:'advanced-weapons'};
 if(require('./rocket-types')[id])return{status:'implemented',handler:'rocket'};
 if(require('./hellstorm').recognizes(id))return{status:'implemented',handler:'hellstorm'};
 if(require('./combat-utilities').recognizes(id))return{status:'implemented',handler:'combat-utilities'};
 if(require('./cpu').recognizes(id)||id==='equipment_extra_repbot_rep')return{status:'implemented',handler:'cpu'};
 if(require('./ship-abilities').recognizes(id))return{status:'implemented',handler:'ship-abilities'};
 if(require('./drones').formationIds[id]!==undefined)return{status:'implemented',handler:'drones'};
 if(id.startsWith('equipment_petgear_')&&require('./pet-catalog').gear(id)?.supported)return{status:'implemented',handler:'pet'};
 if(/^buy_ammunition_(?:laser_(?:lcb-10|mcb-25|mcb-50|sab-50)|rocket_(?:r-310|plt-2026|plt-2021|plt-3030))$/.test(id))return{status:'implemented',handler:'quick-buy'};
 if(techs()?.recognizes(id))return{status:'implemented',handler:'techs'};
 return{status:'unsupported',handler:null,reason:'Bu işlemin yerel oyun işlevi henüz uygulanmadı; kullanım kapalı.'};
}
function entries(){return TEMPLATE.categories.flatMap(c=>c.menuItems.map(i=>({category:c.categoryId,id:i.status.menuItemId,...capability(i.status.menuItemId)})));}
function stock(p,id){return require('./ammo').count(p,id);}
function hint(c,text){if(!text)return c;const line={_:'MessageKeyListWildcardModule',wildCardReplacements:[],baseKey:text,baseKeyType:{_:'ReplacementTypeModule',typeValue:0},textStyle:0};for(const key of ['toolTipSlotBar','toolTipItemBar'])if(c[key])c[key]={...c[key],commandList:[...c[key].commandList,line]};return c;}
function status(p,c){const id=c.menuItemId,entry=capability(id),n=stock(p,id);
 if(entry.status==='unsupported')return hint({...c,visible:n>0,available:false,activatable:false,selected:false,blocked:false,counterValue:n},entry.reason);
 if(entry.handler==='laser')return hint({...c,visible:true,available:n>0&&p.stats.laserCount>0,activatable:n>0&&p.stats.laserCount>0,blocked:false},entry.reason);
 if(entry.handler==='advanced-weapons')return {...require('./advanced-weapons').menuStatus(p,c),visible:true};
 if(entry.handler==='rocket')return{...c,visible:true};
 if(entry.handler==='combat-utilities'){const command=require('./combat-utilities').buildInit({player:p}).find(x=>x._==='MenuItemStatusCommand'&&x.menuItemId===id);return{...c,...command,visible:true};}
 if(entry.handler==='hellstorm')return require('./hellstorm').menuStatus(p,c);
 if(entry.handler==='quick-buy'){const offer=QUICK_OFFERS[id.slice(4)],currency=offer?.currency==='real'?'uridium':'credits';return{...c,visible:true,available:!!offer,activatable:!!offer&&p[currency]>=offer.price,selected:false,counterValue:0,blocked:false};}
 if(entry.handler==='techs')return techs().menuStatus(p,c);
 if(entry.handler==='pet'){const s=require('./pet').stats(p),gear=require('./pet-catalog').gear(id),yes=!!s?.gears.some(g=>g.type===gear.type);return{...c,visible:yes,available:yes,activatable:yes,selected:yes&&require('./pet').owned(p.userId)?.gear===gear.type,counterValue:0,blocked:false};}
 return c;
}
function action(session,c){const p=session.world.player,entry=capability(c.menuItemId);if(!session.world.active(session)||p.dead||session.jumping)return false;
 if(entry.handler==='pet'){const gear=require('./pet-catalog').gear(c.menuItemId);return require('./pet').selectGear(session.world,gear.type);}
 if(entry.handler==='quick-buy'){const id=c.menuItemId.slice(4),offer=require('./economy').offers(p.userId)[id];if(!offer||offer.localPayment)return false;const result=require('./economy').purchase(p.userId,id,1);return result.result==='success';}
 return false;
}
module.exports={capability,entries,status,action};
