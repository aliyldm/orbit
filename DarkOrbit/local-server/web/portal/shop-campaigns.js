'use strict';
// Reuse captured product tiles and the original shop selection/quantity view.
// Only navigation and membership change; SKUs and delivery manifests stay intact.
const fs=require('node:fs'),path=require('node:path');
const TEMPLATE='internalDockOffers';
const DATA=/itemData\s*:\s*(\{[^\r\n]*\})(,\s*\r?\n\s*numItems)/;
const TILE=/<div class="item"[^>]*>\s*<div class="itemList_singleItem"[^>]*>\s*<a id="([^"]+)"[\s\S]*?<\/a>\s*<\/div>\s*(?:<div\b[^>]*>[^<]*<\/div>\s*)+<\/div>/g;
let catalog;
function captures(){
 if(catalog)return catalog;
 catalog={rows:{},tiles:{}};
 const payment=require('../../game/payment');
 for(const file of fs.readdirSync(path.join(__dirname,'pages')).filter(f=>/^internalDock~/.test(f)).sort()){
  const html=fs.readFileSync(path.join(__dirname,'pages',file),'utf8'),match=DATA.exec(html);if(!match)continue;
  const rows=JSON.parse(match[1]);
  for(const tile of html.matchAll(TILE))if(payment.entry(tile[1])){
   catalog.rows[tile[1]]=rows[tile[1]];catalog.tiles[tile[1]]=tile[0];
  }
 }
 return catalog;
}
function replaceTiles(html,content){
 // The list contains nested divs. Count tags rather than matching its first end.
 const start=html.indexOf('<div id="item_list">');if(start<0)throw Error('Shop item list missing');
 const body=start+'<div id="item_list">'.length;
 const tags=/<\/?div\b[^>]*>/g;tags.lastIndex=body;let depth=1,tag;
 while((tag=tags.exec(html))){depth+=tag[0].startsWith('</')?-1:1;if(depth===0)return html.slice(0,body)+content+html.slice(tag.index);}
 throw Error('Unclosed shop item list');
}
function prepare(html,special=false){
 const match=DATA.exec(html);if(!match)return html;
 const payment=require('../../game/payment'),source=JSON.parse(match[1]);
 const rows=special?structuredClone(captures().rows):Object.fromEntries(Object.entries(source).filter(([id])=>!payment.entry(id)));
 const policy=require('../../game/equipment-policy');for(const[id,row]of Object.entries(rows))if(policy.removed(row.imageVars?.loot_id)||policy.offerRemoved(id,{localPayment:!!payment.entry(id),paymentSku:id}))delete rows[id];
 const tiles=special?Object.entries(captures().tiles).filter(([id])=>Object.hasOwn(rows,id)).map(([,tile])=>tile).join('\n'):[...html.matchAll(TILE)].filter(m=>Object.hasOwn(rows,m[1])).map(m=>m[0]).join('\n');
 html=replaceTiles(html,tiles);
 html=html.replace(DATA,(_,json,after)=>'itemData        : '+JSON.stringify(rows)+after)
  .replace(/(numItems\s*:\s*)\d+/,'$1'+Object.keys(rows).length)
  .replace(/(startupItemId\s*:\s*)'[^']*'/,(_,prefix)=>prefix+JSON.stringify(Object.keys(rows)[0]||''));
 if(special)html=html.replace(/(id="subNavExtras"[\s\S]*?)(?=\s*<div id="subNavPetGears")/,section=>section.replace(/subNavButtonActive/g,'subNavButtonInactive').replace(/subNavTextActiveExtras/g,'subNavTextInactiveExtras'));
 const button=`<div id="subNavSpecialOffers" class="subNavButtonExtras ${special?'subNavButtonActive':'subNavButtonInactive'}" onmouseover="subNavRollover('subNavSpecialOffers')" onmouseout="subNavRollover('subNavSpecialOffers')"><a href="indexInternal.es?action=internalDock&amp;tpl=${TEMPLATE}"><span class="localSpecialOffersLabel">ÖZEL FIRSATLAR</span></a></div>`;
 // Append to the existing vertical category strip, not outside the shop window.
 const marker=/<div\s+id="subNavCustomization"[\s\S]*?<\/a>\s*(?:<div class="subNavEventIcon"><\/div>\s*)?<\/div>/;
 if(!marker.test(html))throw Error('Shop category strip missing');
 html=html.replace(marker,section=>section+'\n'+button);
 html=html.replace('</body>','<script id="local_shop_navigation">(function(){var nav=document.getElementById("subNavTop"),active=nav&&nav.querySelector(".subNavButtonActive");if(active&&active.offsetTop+active.offsetHeight>nav.clientHeight)nav.scrollTop=active.offsetTop+active.offsetHeight-nav.clientHeight+8;})();</script></body>');
 return html.replace('</head>','<link rel="stylesheet" href="/client/css/local-shop.css?v=20261023shipcards2" /></head>');
}
module.exports={TEMPLATE,TILE,captures,prepare,replaceTiles};
