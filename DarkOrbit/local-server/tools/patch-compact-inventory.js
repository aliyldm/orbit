'use strict';
// Re-export the installed artifact; change only compact filtering/scroll bounds.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'decompiled/compact-inventory-patch'),input=path.join(root,'client/swf_global/inventory/inventory.swf'),output=path.join(dir,'inventory-patched.swf');
const prefix='net.bigpoint.darkorbit.equipment.',classes=[prefix+'view.components.items.GridComponent',prefix+'view.components.InventoryView',prefix+'view.mediators.InventoryViewMediator',prefix+'model.VO.item.ItemInstanceVO',prefix+'view.components.items.ItemFilter'];
const sha=b=>crypto.createHash('sha256').update(b).digest('hex'),rel=c=>path.join('scripts',...c.split('.'))+'.as';
fs.mkdirSync(dir,{recursive:true});const before=fs.readFileSync(input);if(sha(before)!==require('../decompiled/drone-bulk-patch/evidence.json').patchedSha256)throw Error('Unexpected inventory artifact');fs.copyFileSync(input,path.join(dir,'inventory-before.swf'));
function run(args,log){const r=spawnSync('C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',['-jar','D:\\swfde\\ffdec.jar',...args],{cwd:root,windowsHide:true,encoding:'utf8',maxBuffer:8*1024*1024});fs.writeFileSync(path.join(dir,log),(r.stdout||'')+(r.stderr||''));if(r.error||r.status!==0)throw r.error||Error(log);}
run(['-selectclass',classes.join(','),'-export','script',path.join(dir,'before'),input],'export.log');
function change(source,a,b){if(source.split(a).length!==2)throw Error('Unexpected source: '+a);return source.replace(a,b);}
let grid=fs.readFileSync(path.join(dir,'before',rel(classes[0])),'utf8');
grid=change(grid,'this.sortedItems = _loc5_.filterByArrayOfSpecificGroups(param1,this._iconsInThisMenu).slice();','this.sortedItems = _loc5_.filterByArrayOfSpecificGroups(param1,this._iconsInThisMenu,true).slice();');
grid=change(grid,'if(!_loc13_.isEquippedInOtherHangar(_loc7_) && _loc14_)','if(!_loc13_.isEquippedInOtherHangar(_loc7_) && _loc14_ && !_loc13_.equippedInConfigs[Settings.activeConfig])');
let view=fs.readFileSync(path.join(dir,'before',rel(classes[1])),'utf8');
view=change(view,'_loc1_ = this.grid.height;','_loc1_ = this.grid.currentFilter == ItemFilter.CONTEXT_FILTER ? this.grid.lowestOfSortedItems.y + this.grid.lowestOfSortedItems.height : this.grid.height;');
// A context change must not inherit the expanded inventory scroll offset.
view=change(view,'this.currentEquippableFilterGroup = param2;','this.currentEquippableFilterGroup = param2;\r\n         this.inventoryScroller.resetAllElementsToStartingPositions();');
const files=classes.slice(0,2).map((c,i)=>{const f=path.join(dir,'source',rel(c));fs.mkdirSync(path.dirname(f),{recursive:true});fs.writeFileSync(f,[grid,view][i]);return f;});
run(['-replace',input,path.join(dir,'grid-patched.swf'),classes[0],files[0]],'grid-compile.log');
run(['-replace',path.join(dir,'grid-patched.swf'),output,classes[1],files[1]],'view-compile.log');
run(['-selectclass',[...classes,prefix+'view.components.items.DragComponent'].join(','),'-export','script',path.join(dir,'verified'),output],'verify.log');
const normalize=s=>s.replaceAll('Number(NaN)','NaN').replaceAll('Boolean(_loc7_.indexOf(DataInterchange.WORDPUZZLE_ID) != -1 && param1 != null)','_loc7_.indexOf(DataInterchange.WORDPUZZLE_ID) != -1 && param1 != null');
for(const [i,expected]of [grid,view].entries()){const actual=fs.readFileSync(path.join(dir,'verified',rel(classes[i])),'utf8');if(normalize(actual)!==normalize(expected))throw Error('Unexpected compiled differences: '+classes[i]);}
for(const c of classes.slice(2))if(fs.readFileSync(path.join(dir,'before',rel(c)),'utf8')!==fs.readFileSync(path.join(dir,'verified',rel(c)),'utf8'))throw Error('Retained class differs: '+c);
fs.writeFileSync(path.join(dir,'evidence.json'),JSON.stringify({beforeSha256:sha(before),afterSha256:sha(fs.readFileSync(output)),classes:classes.slice(0,2),scope:'Use current item configuration instead of stale icon flags; bound compact scrolling to visible items; reset scroll on context change.',limitations:['No native Flash mouse gesture or live visual playback performed.']},null,2)+'\n');console.log('Verified compact inventory patch',sha(fs.readFileSync(output)));
