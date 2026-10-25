'use strict';
// Render the actual portal and static routes in an isolated memory DB/browser.
// Never connects to the user's Qt window or production game/account database.
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),http=require('node:http'),{spawn}=require('node:child_process'),{once}=require('node:events');
const database=require('../game/db');
async function main(){
 const laserMode=process.argv.includes('--laser'),directory=path.resolve(__dirname,laserMode?'../logs/laser-cards-preview':'../logs/ship-cards-preview');fs.mkdirSync(directory,{recursive:true});
 database.open(':memory:');
 const players=require('../game/db/players'),account=players.createAccount('ship-cards-preview','test-pass'),id=players.createPlayer(account,'Preview',1,require('../config').starter),player=players.loadPlayer(id);
 const config=structuredClone(require('../config.json'));config.http.port=0;config.https=null;config.cdnCache.enabled=false;config.hostCache.enabled=false;
 const handler=require('../web/http-server').createHandler(config,directory);let base;
 const inspect=`<script id="qa_ship_cards">window.addEventListener('load',function(){setTimeout(function(){${laserMode?"Library.get('itemList').stop(true,true);jQuery.fx.off=true;Shop.Itemlist.scrollToItem('equipment_weapon_laser_lf-4');Shop.Itemlist.selectItem('equipment_weapon_laser_lf-4');document.body.setAttribute('data-selection-immediate',JSON.stringify({id:Shop.Item.getId(),top:Shop.Itemlist.getCurrentTopRow()}));":''}var cards=Array.from(document.querySelectorAll('#item_list > .item'));Promise.all(cards.map(function(card){return new Promise(function(resolve){var image=new Image;image.onload=function(){resolve(image.naturalWidth>0)};image.onerror=function(){resolve(false)};image.src=getComputedStyle(card.querySelector('.itemList_singleItem')).backgroundImage.slice(5,-2);});})).then(function(images){var first=cards[0],caption=first.querySelector('.localShipName'),price=first.querySelector('.itemList_singlePrice');document.body.setAttribute('data-ship-cards',JSON.stringify({count:cards.length,loadedImages:images.filter(Boolean).length,captionHeight:caption.getBoundingClientRect().height,cardHeight:first.getBoundingClientRect().height,priceHeight:price.getBoundingClientRect().height,priceText:price.textContent,selectedItem:Shop.Item.getId(),currentTopRow:Shop.Itemlist.getCurrentTopRow(),numRows:Shop.Itemlist.getNumRows(),lf4Index:Shop.Itemlist.getItemLinkIndex('equipment_weapon_laser_lf-4'),rowStep:cards[2].getBoundingClientRect().top-first.getBoundingClientRect().top}));});},1000);});</script>`;
 const server=http.createServer((req,res)=>{
  if(req.url==='/__qa/ship-shop'){
   let html=require('../web/portal/render').renderPage('internalDock',laserMode?'internalDockLaser':'internalDockShips',player,base).replace('</body>',inspect+'</body>');
   res.writeHead(200,{'Content-Type':'text/html; charset=utf-8'});return res.end(html);
  }
  handler(req,res);
 });
 server.listen(0,'127.0.0.1');await once(server,'listening');base='http://127.0.0.1:'+server.address().port;
 try{
  const browser=process.env.SHOP_PREVIEW_BROWSER||'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
  const child=spawn(browser,['--headless','--disable-gpu','--disable-background-networking','--no-first-run','--no-default-browser-check','--user-data-dir='+path.join(directory,'browser-profile'),'--window-size=1200,1000','--virtual-time-budget=5000','--screenshot='+path.join(directory,'shop.png'),'--dump-dom',base+'/__qa/ship-shop'],{windowsHide:true,stdio:['ignore','pipe','pipe']});
  let dom='',errors='';child.stdout.on('data',chunk=>dom+=chunk);child.stderr.on('data',chunk=>errors+=chunk);
  const [code]=await once(child,'exit');fs.writeFileSync(path.join(directory,'dom.html'),dom);fs.writeFileSync(path.join(directory,'browser.log'),errors);assert.equal(code,0);
  const match=/data-ship-cards="([^"]+)"/.exec(dom);assert.ok(match,'Browser did not finish the portal/asset inspection');
  const report=JSON.parse(match[1].replaceAll('&quot;','"'));fs.writeFileSync(path.join(directory,'report.json'),JSON.stringify(report,null,2)+'\n');
  if(laserMode)assert.equal(report.selectedItem,'equipment_weapon_laser_lf-4');assert.equal(report.count,laserMode?11:80);assert.equal(report.loadedImages,laserMode?11:80);assert.equal(report.captionHeight,13);assert.equal(report.cardHeight,100);assert.equal(report.priceHeight,13);assert.equal(report.priceText,laserMode?'10.000 C.':'0 C.');assert.equal(report.rowStep,105);
  console.log('PASS ship card browser rendering: '+JSON.stringify(report));
 }finally{server.close();await once(server,'close');database.close();}
}
if(require.main===module)main().catch(error=>{console.error(error.stack);process.exitCode=1;});
