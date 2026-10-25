'use strict';
// Kaydedilmiş portal şablonlarını (tools/build-portal.js) oyuncunun DB değerleriyle doldurur.
// Değiştirilen yerler canlı sayfanın sabit işaretlemelerinden seçildi:
//   kayıttaki ad/kimlik (her yerde), başlık çubuğu (header_top_level/hnr/exp, header_credits, header_uri),
//   pilot kartı "Sv:", rütbe resmi rank_N, şirket logosu companyLogo*_<mmo|eic|vru>, sunucu saati.
// Sayfa içeriğinin geri kalanı (dükkan listeleri, haberler) kayıttaki haliyle sunulur.

const fs = require('fs');
const path = require('path');

const DIR = __dirname;
const meta = () => JSON.parse(fs.readFileSync(path.join(DIR, 'meta.json'), 'utf8'));
const FACTION = { 1: 'mmo', 2: 'eic', 3: 'vru' };

const esc = s => String(s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
// Canlı portal sayıları Türkçe biçimde gösteriyor (1.234.567).
const num = n => Math.floor(Number(n) || 0).toLocaleString('tr-TR');
// HTML parses </script> before JavaScript parses a JSON string. Ship descriptions
// contain their own scripts; ordinary JSON.stringify would close the outer tag.
const inlineJson = value => JSON.stringify(value).replace(/</g, '\\u003c').replace(/\u2028/g, '\\u2028').replace(/\u2029/g, '\\u2029');

function shopListPrices(html, rows) {
  // The captured shop has bare styled price divs, whereas the original helper
  // expects .itemList_singlePrice/strong. Supply its class and current DB price.
  return html.replace(require('./shop-campaigns').TILE,(tile,rowId)=>{
    const row=rows[rowId];if(!row?.cost)return tile;
    // Some products place a daily-limit div before the actual price.
    return tile.replace(/(<div\b[^>]*>)(\s*(?:[\d.,]+\s+(?:C\.|U\.)|Payment)\s*)(<\/div>)/g,(_,tag,text,end)=>{
      const priceTag=/\bclass=/.test(tag)?tag.replace(/class="([^"]*)"/,'class="$1 itemList_singlePrice"'):tag.replace('<div','<div class="itemList_singlePrice"');
      return priceTag+esc(row.cost)+end;
    });
  });
}

function pageFile(action, tpl) {
  if(action==='internalHallofFame')return path.join(DIR,'pages','internalStart.html');
  if(action==='internalDock'&&tpl===require('./shop-campaigns').TEMPLATE)tpl='internalDockSpecials';
  if (!/^[a-zA-Z0-9_-]+$/.test(action) || (tpl && !/^[a-zA-Z0-9_-]+$/.test(tpl))) return null;
  const withTpl = tpl && path.join(DIR, 'pages', `${action}~${tpl}.html`);
  if (withTpl && fs.existsSync(withTpl)) return withTpl;
  const plain = path.join(DIR, 'pages', `${action}.html`);
  return fs.existsSync(plain) ? plain : null;
}

function hasPage(action, tpl) { return !!pageFile(action, tpl); }

function setSpan(html, id, value) {
  return html.replace(new RegExp(`(id="${id}"[\\s\\S]*?<span>)[^<]*(</span>)`), `$1${value}$2`);
}

function personalize(html, p) {
  const m = meta();
  // Recorded campaign deadlines are historical. Refreshing this static capture
  // cannot fetch a new campaign and otherwise causes a one-second reload loop.
  html=html.replace(/if \(reloadInitiated == false && secondsLeft < -1\)\s*\{\s*reloadInitiated = true;\s*location\.reload\(\);\s*\}/,'reloadInitiated = true;');
  html=html.replace(/(src="\/client\/resources\/js\/main\.js\?[^"\s]*)(")/g,'$1&local=20261021reset$2');
  html=html.replace(/(\/client\/swf_global\/inventory\/inventory\.swf\?[^"'\s]+)/g,'$1&local=20261025sales');
  if (m.recordedName) html = html.split(m.recordedName).join(esc(p.userName));
  if (m.recordedId) html = html.split(String(m.recordedId)).join(String(p.userId));
  html = setSpan(html, 'header_top_level', p.level);
  html = setSpan(html, 'header_top_hnr', num(p.honourPoints));
  html = setSpan(html, 'header_top_exp', num(p.ep));
  html = html.replace(/(<div id="header_credits"[^>]*>)\s*[^<]*?\s*(<\/div>)/, `$1\n\t\t${num(p.credits)}\n\t$2`);
  html = html.replace(/(<a id="header_uri"[^>]*>)\s*[^<]*?\s*(<\/a>)/, `$1\n\t\t${num(p.uridium)}\n\t$2`);
  html = html.replace(/(<label>Sv:<\/label>)\s*\d+/g, `$1 ${p.level}`);
  // Dükkan sayfalarındaki JS bakiyesi (User.balance).
  html = html.replace(/"balance":\{"uridium":[\d.]+,"credits":[\d.]+\}/g,
    `"balance":{"uridium":${Number(p.uridium)},"credits":${Number(p.credits)}}`);
  if(html.includes('Shop.Parameters')) {
    const db=require('../../game/db').open(),drones=require('../../game/drones');
    const states=drones.shopState(db,p.userId);
    const pet=require('../../game/pet').owned(p.userId),fuelProduct=require('./shop-pet-fuel');
    const petGearPage=/<body class="internalDockShop_petGear"/.test(html);
    const hpProduct=require('./shop-pet-hp'),hpOffer=petGearPage&&require('../../game/pet-progression').hpOffer(p.userId);
    const shipPage=/<body class="internalDockShop_ship"/.test(html);
    const shipProducts=require('./shop-ships');
    const laserPage=/<body class="internalDockShop_laser"/.test(html),laserProducts=require('./shop-lasers');
    const petModules=require('./shop-pet-modules');
    const sepromProduct=require('./shop-seprom');
    const moduleProducts=require('./shop-modules');
    const extrasPage=html.includes('id="'+sepromProduct.SOURCE+'"');
    let shopRows;
    // Recorded itemData is one JSON line; preserve its numeric DOM row keys.
    html=html.replace(/(itemData\s*:\s*)(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/,(_,before,json,after)=>{
      const rows=JSON.parse(json);
      shopRows=rows;
      if(shipPage)shipProducts.populate(rows,db);
      if(laserPage)laserProducts.populate(rows);
      if(petGearPage&&!rows[fuelProduct.ID])rows[fuelProduct.ID]=fuelProduct.row(rows.pet_pet10,pet);
      if(petGearPage&&!rows[petModules.ID])rows[petModules.ID]=petModules.row(rows.pet_pet10,pet);
      if(hpOffer)rows[hpOffer.id]=hpProduct.row(rows.pet_pet10,hpOffer);
      if(extrasPage&&!rows[sepromProduct.ID])rows[sepromProduct.ID]=sepromProduct.row(rows[sepromProduct.SOURCE]);
      if(extrasPage)require('./shop-ship-modules').populate(rows);
      if(extrasPage)for(const definition of moduleProducts.definitions())if(!rows[definition.id])rows[definition.id]=moduleProducts.row(rows[moduleProducts.SOURCE],definition);
      for(const [sku,item] of Object.entries(rows)){
        if(require('../../game/payment').entry(sku)){require('../../game/payment').rewriteRow(item,sku);require('../../game/shop-product-audit').decorateRow(item,sku);continue;}
        const petEntry=require('../../game/pet-shop').offers()[item.imageVars?.loot_id];
        if(petEntry){const petCatalog=require('../../game/pet-catalog'),owned=require('../../game/pet').owned(p.userId),maximum=Math.max(1,...Object.keys(petEntry.levels).map(Number).filter(l=>(owned?.level||0)>=petCatalog.minimumPetLevel(l)));item.maxLevel=maximum;item.isBuyable=!!owned;item.notBuyable=!owned;
          if(item.isPetProtocol&&petEntry.levels[4]){
            const effect=petCatalog.protocol(item.imageVars.loot_id,4),labels={salvage:'Ganimet',cargo:'Kargo',alienDamage:'NPC hasarı',evasion:'Kaçınma',accuracy:'İsabet',fuelReduction:'Yakıt tasarrufu',hitpoints:'Darbe puanı',laserDamage:'Lazer hasarı',radar:'Radar menzili',shield:'Kalkan'};
            item.levelItemShopData[4]={...item.levelItemShopData[3],price:1000000,cost:'1.000.000 U.',isPaymentItem:false,localFixedPrice:true,description:`${labels[effect.effect]||'Etki'}: %${(effect.bonus*100).toLocaleString('tr-TR')}. Gereken: P.E.T. Seviye20.`};
          }
        }
        else if(item.isPetGear||item.isPetProtocol)item.notBuyable=true;
        const state=states[item.imageVars?.loot_id];if(state){
          item.price=state.price;item.salePrice=state.price;item.notBuyable=state.notBuyable;
          item.cost=num(state.price)+(item.currency==='virtual'?' C.':' U.');item.imageVars.price_plain=item.cost;
        }
        require('../../game/shop-product-audit').decorateRow(item,sku);
      }
      return before+inlineJson(rows)+after;
    });
    if(petGearPage&&shopRows?.[fuelProduct.ID]){
      html=fuelProduct.tile(html,shopRows[fuelProduct.ID]);
      html=petModules.tile(html,shopRows[petModules.ID]);
      if(hpOffer)html=hpProduct.tile(html,shopRows[hpOffer.id]);
      html=html.replace(/(numItems\s*:\s*)\d+/,(_,prefix)=>prefix+Object.keys(shopRows).length);
    }
    if(shipPage&&shopRows)html=shipProducts.tiles(html,shopRows);
    if(laserPage&&shopRows)html=laserProducts.tiles(html,shopRows);
    if(extrasPage&&shopRows?.[sepromProduct.ID]){
      html=sepromProduct.tile(html);
      html=moduleProducts.tiles(html);
      html=require('./shop-ship-modules').append(html,shopRows);
      html=html.replace(/(numItems\s*:\s*)\d+/,(_,prefix)=>prefix+Object.keys(shopRows).length);
    }
    if(shopRows){
      html=shopListPrices(html,shopRows);html=require('./shop-sort').sort(html,shopRows);
      html=html.replace(/(numItems\s*:\s*)\d+/,(_,prefix)=>prefix+Object.keys(shopRows).length);
      const first=[...html.matchAll(/<a id="([^"]+)"/g)].map(m=>m[1]).find(id=>Object.hasOwn(shopRows,id))||'';
      html=html.replace(/(startupItemId\s*:\s*)(?:'[^']*'|"[^"]*")/,(_,prefix)=>prefix+inlineJson(first));
    }
    html=html.replace(/(User\.Parameters\s*=\s*)(\{[^\r\n]*\})(;)/,(_,prefix,json,end)=>{
      const data=JSON.parse(json);data.pet={hasPet:!!pet,level:pet?.level||0,fuel:pet?.fuel||0,maxFuel:require('../../game/pet').MAX_FUEL};
      return prefix+inlineJson(data)+end;
    });
    html=html.replace(/(userDroneAmount\s*:\s*)\d+/,(_,prefix)=>prefix+drones.owned(db,p.userId).filter(d=>['drone_flax','drone_iris'].includes(d.loot_id)).length);
    html=html.replace(/>Payment<\/div>/g,'>1.000.000 U.</div>');
    html=html.replace(/<\/body>/i,require('../../game/payment').portalScript+'</body>');
    // Refresh changed shop helpers even when the captured CDN hash was cached.
    html=html.replace(/(src="\/client\/resources\/js\/shop(?:\/itemlist)?\.js[^"?]*\?[^"\s]*)(")/g,'$1&local=20261023currency$2');
  }
  html = html.replace(/(\/ranks\/rank_)\d+(\.png)/g, `$1${p.dailyRank || 1}$2`);
  html = html.replace(/(companyLogo\w*_)(mmo|eic|vru)\b/g, `$1${FACTION[p.factionId] || 'mmo'}`);
  const now = new Date();
  html = html.replace(/var serverTime = '[^']*';/, `var serverTime = '${now.toTimeString().slice(0, 5)}';`)
    .replace(/var serverDate = '[^']*';/, `var serverDate = '${now.toLocaleDateString('tr-TR')}';`);
  html=html.replace(/\/\?action=internalPaymentProxy&req=[^'"\s<>]+/g,'/indexInternal.es?action=internalPayment');
  return require('../hangar-api').decorate(html,p.userId);
}

// Oyuncusu olmayan hesap için (şirket seçimi) kişiselleştirme yapılmaz.
// host: local sunucu adresi (http://127.0.0.1:8095); kayıttaki tam host yer tutucusu ({{HOST}}) bununla değişir.
function renderPage(action, tpl, player, host = '') {
  // A dedicated category in the original shop contains all local campaign SKUs.
  if(action==='internalPayment'&&player){action='internalDock';tpl=require('./shop-campaigns').TEMPLATE;}
  const file = pageFile(action, tpl);
  if (!file) return null;
  let html = fs.readFileSync(file, 'utf8').split('{{HOST}}').join(host);
  if(player&&html.includes('Shop.Parameters'))html=require('./shop-campaigns').prepare(html,tpl===require('./shop-campaigns').TEMPLATE);
  if(!player)return html;
  html=personalize(html,player);
  if(action==='internalStart'||action==='internalHallofFame')html=require('./rankings').decorate(html,player,{hall:action==='internalHallofFame'});
  return html;
}

// Kayıtlı ajax/flashAPI cevabı. inventory.php cevapları base64 JSON; içleri de kişiselleştirilir.
function renderAjax(key, player) {
  const ajax = JSON.parse(fs.readFileSync(path.join(DIR, 'ajax.json'), 'utf8'));
  const hit = ajax[key];
  if (!hit) return null;
  let body = hit.body;
  const m = meta();
  const swap = s => {
    if (m.recordedName) s = s.split(m.recordedName).join(player.userName);
    if (m.recordedId) s = s.split(String(m.recordedId)).join(String(player.userId));
    return s;
  };
  if (/^[A-Za-z0-9+/=\s]+$/.test(body) && body.length > 16) {
    body = Buffer.from(swap(Buffer.from(body, 'base64').toString('utf8')), 'utf8').toString('base64');
  } else {
    body = swap(body);
  }
  return { contentType: hit.contentType, body };
}

module.exports = { renderPage, renderAjax, hasPage };
