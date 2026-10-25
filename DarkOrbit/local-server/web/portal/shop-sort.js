'use strict';
// Credits precede Uridium; compare unit prices only within each currency.
function price(row){const n=Number(row?.price);return row&&Number.isFinite(n)&&n>=0?n:Infinity;}
function currency(row){return row?.currency==='virtual'?0:row?.currency==='real'?1:2;}
function compare(a,b){return currency(a)-currency(b)||price(a)-price(b);}
function sort(html,rows){
 const pattern=/<div class="item"[^>]*>\s*<div class="itemList_singleItem"[^>]*>\s*<a id="([^"]+)"[\s\S]*?<\/a>\s*<\/div>\s*(?:<div\b[^>]*>[^<]*<\/div>\s*)+<\/div>/g;
 const tiles=[...html.matchAll(pattern)].map((m,index)=>({html:m[0],index,row:rows[m[1]]}));
 tiles.sort((a,b)=>compare(a.row,b.row)||a.index-b.index);
 let index=0;return html.replace(pattern,()=>tiles[index++].html);
}
module.exports={sort,price,currency,compare};
