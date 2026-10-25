'use strict';
const crypto=require('crypto'),hangars=require('../game/hangars');
const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const json=value=>JSON.stringify(value).replace(/</g,'\\u003c').replace(/\u2028/g,'\\u2028').replace(/\u2029/g,'\\u2029');
function state(playerId){return {...hangars.state(playerId),purchaseToken:crypto.randomBytes(20).toString('hex')};}
function handle(playerId,params){
 try{let out;switch(params.get('action')){
  case 'purchase':out=hangars.purchase(playerId,params.get('slot'),params.get('requestId'));break;
  case 'select':hangars.select(playerId,params.get('slot'));break;
  case 'assign':hangars.assign(playerId,params.get('slot'),params.get('ship'));break;
  case 'state':break;
  default:throw Error('Geçersiz hangar işlemi.');
 }return {result:'success',replayed:!!out?.replayed,state:state(playerId)};
 }catch(error){return {result:'error',message:error.message};}
}
function header(playerId){
 const data=state(playerId),s=data.slots.find(x=>x.selected),options=data.ships.filter(ship=>!ship.slot||ship.slot===data.selectedSlot).map(ship=>'<option value="'+ship.id+'"'+(ship.id===s.shipId?' selected':'')+'>'+esc(ship.name)+'</option>').join('');
 const slots=data.slots.map(s=>'<a class="header_hangar_slot'+(s.selected?' current_slot':'')+'" data-hangar-slot="'+s.number+'" href="/indexInternal.es?action=internalDock&amp;hangarSlot='+s.number+'" title="'+(s.selected?'Görüntülenen: ':'')+'Hangar '+s.number+' — '+esc(s.shipName||'Boş')+'">'+s.number+'</a>').join('');
 const plus=data.nextSlot?'<a class="header_hangar_slot_getNext" href="#" title="Yeni hangar: 250.000 U." aria-label="Yeni hangar satın al">+</a>':'';
 const html='<div id="header_hangar_slots">'+slots+plus+'<div id="header_hangar_arrow"></div></div>';
 const panel='<div id="local_hangar_panel" class="local_hangar_panel" style="display:none"><strong id="local_hangar_title">Görüntülenen: Hangar '+data.selectedSlot+' — '+esc(s.shipName||'Boş')+'</strong><p id="local_hangar_active">Aktif gemi: '+esc(data.activeShipName)+' ('+(data.activeSlot?'Hangar '+data.activeSlot:'hangara atanmamış')+')</p><p id="local_hangar_message" role="status"></p><label for="local_hangar_ship">Sahip olduğun gemi</label><select id="local_hangar_ship"><option value="">Gemi seç</option>'+options+'</select><button id="local_hangar_assign" type="button">Hangara ata</button><a id="local_hangar_equipment" href="/indexInternal.es?action=internalDock">Ekipman</a></div>';
 return {html,panel,scripts:'<link rel="stylesheet" href="/client/css/local-hangars.css?v=20261021"><script>window.LocalHangarsState='+json(data)+';</script><script src="/client/resources/js/local-hangars.js?v=20261023-browser"></script>'};
}
function decorate(html,playerId){if(!html.includes('id="header_hangar_slots"'))return html;const h=header(playerId);html=html.replace(/<div id="header_hangar_slots">[\s\S]*?<\/div>\s*<div id="hangar_slot_current">/,h.html+h.panel+'<div id="hangar_slot_current">');return html.replace(/<\/body>/i,h.scripts+'</body>');}
module.exports={state,handle,header,decorate};
