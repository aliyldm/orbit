'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.resolve(__dirname,'..');
function xmlTree(s){const root={attrs:{},children:[]},stack=[root];for(const m of s.matchAll(/<(\/?)(\w+)\b([^>]*?)(\/?)>/g)){if(m[1]){const n=stack.pop();assert.equal(n.tag,m[2]);continue;}const n={tag:m[2],attrs:Object.fromEntries([...m[3].matchAll(/([\w.]+)="([^"]*)"/g)].map(a=>[a[1],a[2]])),children:[]};stack.at(-1).children.push(n);if(!m[4])stack.push(n);}assert.equal(stack.length,1);return root;}
function find(root,name){if(root.attrs.name===name)return root;for(const c of root.children){const n=find(c,name);if(n)return n;}}
function footerBounds(xml){const root=xmlTree(xml),standard=find(root,'standardViewContainer'),footer=find(root,'upgradeContainer');let top=Number(standard.attrs.marginTop||0);for(const n of standard.children){top+=Number(n.attrs.marginTop||0);if(n===footer)break;top+=Number(n.attrs.height||2)+Number(n.attrs.marginBottom||0)+Number(standard.attrs.gap??5);}const bottom=top+Math.max(Number(footer.attrs.height),...footer.children.map(c=>Number(c.attrs.marginTop||0)+Number(c.attrs.height||2)));return{root,standard,footer,top,bottom};}
test('actual native vertical-flow bounds keep every footer state inside450px, unlike the captured overflowing layout',()=>{
 const original=footerBounds(fs.readFileSync(path.join(root,'decompiled/upgrade-footer-layout/upgradeWindowUI-before.xml'),'utf8')),xml=fs.readFileSync(path.join(root,'client/spacemap/graphics/ui/windows/crafting/upgrade/upgradeWindowUI.xml'),'utf8'),after=footerBounds(xml);
 assert.equal(original.top,325);assert.equal(original.bottom,490);assert.ok(original.bottom>450,'reproduces screenshot clipping including default native5px gaps and141px children');
 assert.ok(after.top<original.top);assert.ok(after.bottom<=430,'entire footer including out-of-parent children leaves at least20px bottom clearance');
 assert.equal(Number(after.standard.attrs.marginTop)+Number(after.standard.attrs.height),450);
 const actions=find(after.footer,'actions'),actionTop=after.top+Number(actions.attrs.marginTop);for(const name of ['build','collect','building','not_possible']){const template=find(after.root,name);assert.ok(actionTop+Number(template.attrs.height)<=450,name);}
 const buff=find(after.footer,'buffList');assert.ok(Number(buff.attrs.height)>=2*42+5,'both drone damage/shield bonus rows fit');
 for(const name of ['buffListContainer','ingredientListContainer','skipIngredientsListContainer']){const n=find(after.footer,name);assert.ok(Number(n.attrs.marginTop)+Number(n.attrs.height)<=Number(after.footer.attrs.height),name);}
 const viewport=find(after.root,'upgradeItemsGrid'),holder=find(after.root,'itemGridContainer');assert.equal(holder.attrs.autoSizeHeight,'false');assert.equal(viewport.attrs.autoSizeHeight,'false');assert.ok(Number(viewport.attrs.marginTop)+Number(viewport.attrs.height)<=Number(holder.attrs.height),'scrolling inventory cannot grow into footer');
 const resources=fs.readFileSync(path.join(root,'client/spacemap/xml/resources.xml'),'utf8'),md5=crypto.createHash('md5').update(xml).digest('hex');assert.match(resources,new RegExp('<file[^>]*hash="'+md5+'"[^>]*id="upgradeWindowUI"'));
});

test('real owned module passes the full native mediator/context filter chain with original uppercase entities',()=>{
 const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),current=World.current;database.close();const db=database.open(':memory:');World.current=()=>null;
 try{
  const id=players.createPlayer(players.createAccount('module-visibility','test'),'Module',1,{...require('../config').starter,ship:'ship_pusat-plus',uridium:10000000}),p=players.loadPlayer(id),economy=require('../game/economy');
  assert.equal(economy.purchase(id,'equipment_shipupgrade_dmg-vp01',1).result,'success');
  const api=require('../web/inventory-api'),reply=JSON.parse(Buffer.from(api.handle(id,new URLSearchParams({action:'getHangarList'})).body,'base64')),ret=reply.data.ret,item=ret.items.find(i=>reply.data.map.lootIds[i.L]==='equipment_shipupgrade_dmg-vp01'),info=ret.itemInfo.find(i=>i.L===item.L);
  const dir=path.join(root,'decompiled/module-visibility-check/scripts/net/bigpoint/darkorbit/equipment'),native=fs.readFileSync(path.join(dir,'view/components/items/GridComponent.as'),'utf8'),identifiers=fs.readFileSync(path.join(dir,'events/ActionIdentifiers.as'),'utf8'),ship=/SHIP:String = "([^"]+)"/.exec(identifiers)[1],expression=/_loc14_ = ([^;]+);/.exec(native)[1],accept=new Function('_loc13_','param4','return '+expression);
  const mediator=fs.readFileSync(path.join(root,'decompiled/inventory-compact-capacity/before/scripts/net/bigpoint/darkorbit/equipment/view/mediators/InventoryViewMediator.as'),'utf8');
  const normalization=/_loc7_ = (_loc7_\.toUpperCase\(\));/.exec(mediator);assert.ok(normalization,'installed mediator normalizes before calling filterByContext');
  const context=new Function('_loc7_','return '+normalization[1])(ship);
  assert.equal(accept({getEquipByOnly:()=>['ship']},context),false,'reproduces previous compact-view regression');assert.equal(accept({getEquipByOnly:()=>info.EB},context),true);
  assert.equal(info.T,12);assert.ok(ret.filters.ship_upgrades.includes(info.T));assert.ok(item.SUS.split(',').includes('ship_pusat'));assert.equal(item.SUS.split(',').includes('ship_pusat-plus'),false);assert.equal(Object.hasOwn(item,'EQH'),false);
  const move=hangarId=>require('../game/inventory').move(id,{hangarId,from:{target:'inventory',items:[item.I],configId:1},to:{target:'ship',slotset:'ship_upgrades',configId:1}});
  assert.throws(()=>move(p.shipId),/modül.*gemiye|gemiye.*modül/);const h=Number(db.prepare("INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,'ship_pusat',10000)").run(id).lastInsertRowid);move(h);assert.equal(db.prepare('SELECT ship_id FROM items WHERE id=?').get(item.I).ship_id,h);
 }finally{World.current=current;database.close();}
});
