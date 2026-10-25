'use strict';
const {test,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),codec=require('../game/codec/codec'),net=require('../game/net'),admin=require('../game/admin-wallet');
let db,id;const previousWorld=World.current;
beforeEach(()=>{database.close();db=database.open(':memory:');World.current=()=>null;id=players.createPlayer(players.createAccount('large-wallet','testpass'),'Large Wallet',1,{...require('../config').starter,uridium:1000,credits:2000});});
afterEach(()=>{World.current=previousWorld;database.close();});
const wallet=()=>db.prepare('SELECT credits,uridium FROM players WHERE id=?').get(id);
function decoded(command){const frames=[];net.sendCmd({send:b=>frames.push(b)},command);assert.equal(frames.length,1);assert.equal(frames[0].readUIntBE(0,3),frames[0].length-3);const result=codec.decode(frames[0].subarray(3));assert.equal(result.rest,0);return result.obj;}
test('native Number parser and double initialization/inventory support53-bit wallet without SWF changes',()=>{
 const root=path.join(__dirname,'../decompiled/main/scripts/net/bigpoint/darkorbit'),read=file=>fs.readFileSync(path.join(root,file),'utf8');
 assert.match(read('Hero.as'),/uridiumAmount:Number/);assert.match(read('Hero.as'),/creditsAmount:Number/);
 assert.match(read('net/ServerCommands.as'),/CREDITS_UPDATE:String = "C"/);
 const handler=read('net/SetAttributeAssembly.as');assert.match(handler,/Hero\.creditsAmount = Number\(param1\[3\]\)/);assert.match(handler,/Hero\.uridiumAmount = parseFloat\(param1\[4\]\)/);
 const init=read('com/module/ShipInitializationCommand.as');assert.match(init,/this\.credits = param1\.readDouble\(\)/);assert.match(init,/this\.uridium = param1\.readDouble\(\)/);
 assert.match(read('com/module/InventoryItemModule.as'),/this\.amount = param1\.readDouble\(\)/);
 for(const n of [2147483648,50000000000,Number.MAX_SAFE_INTEGER]){
  const command=decoded({_:'AttributeCreditsUpdateCommand',credits:n,uridium:n});assert.equal(command._,'LegacyModule');assert.equal(command.message,`0|A|C|${n}|${n}`);
  const fields=command.message.split('|');assert.equal(Number(fields[3]),n);assert.equal(parseFloat(fields[4]),n);
  const inventory={_:'InventoryItemModule',lootId:'currency_uridium',itemId:-2,amount:n};assert.equal(codec.decode(codec.encode(inventory)).obj.amount,n);
 }
 assert.throws(()=>net.walletCommand({_:'AttributeCreditsUpdateCommand',credits:0,uridium:Number.MAX_SAFE_INTEGER+1}),/range/);
});
test('ordinary signed32 balance updates retain binary wire format and fractional wallet updates retain precision',()=>{
 const small={_:'AttributeCreditsUpdateCommand',credits:2000,uridium:2147483647,jackpot:2};assert.deepEqual(decoded(small),small);
 const fraction=decoded({...small,uridium:1000.25});assert.equal(fraction.message,'0|A|C|2000|1000.25');
 const large=decoded({...small,uridium:50000000000});assert.equal(large.message,'0|A|C|2000|50000000000');assert.doesNotMatch(large.message,/LM\|ST/,'large balance refresh must not fabricate reward logs');
});
test('explicit50b grant is atomic, replay-safe, preserves fraction and refuses mismatched retries',()=>{
 db.prepare('UPDATE players SET uridium=1000.25 WHERE id=?').run(id);
 const receipt=admin.grantUridium('large-wallet',50000000000,'fifty-billion');assert.equal(receipt.before,1000.25);assert.equal(receipt.after,50000001000.25);assert.equal(wallet().uridium,receipt.after);
 assert.equal(admin.grantUridium('large-wallet',50000000000,'fifty-billion').replayed,true);assert.equal(wallet().uridium,receipt.after);
 assert.throws(()=>admin.grantUridium('large-wallet',1,'fifty-billion'),/different grant/);assert.equal(wallet().uridium,receipt.after);
 assert.throws(()=>admin.grantUridium('large-wallet',Number.MAX_SAFE_INTEGER,'too-large'),/range/);assert.equal(wallet().uridium,receipt.after);
 db.exec("CREATE TRIGGER fail_wallet_receipt BEFORE INSERT ON settings WHEN NEW.key='admin_wallet_failure' BEGIN SELECT RAISE(ABORT,'receipt failed'); END");
 assert.throws(()=>admin.grantUridium('large-wallet',100,'failure'),/receipt failed/);assert.equal(wallet().uridium,receipt.after);
});
test('live50b grant keeps pending rewards, emits exact HUD wallet and later shop purchases/save/reload retain it',()=>{
 const frames=[],world=new World(require('../config')),session={world,send:b=>frames.push(codec.decode(b.subarray(3)).obj),close(){}};
 world.login(session,id);World.current=()=>world;world.player.uridium=1200.25;world.player.credits=2500;
 const receipt=admin.grantUridium('large-wallet',50000000000,'live-fifty-billion');assert.equal(receipt.after,50000001200.25);assert.equal(world.player.uridium,receipt.after);assert.equal(wallet().credits,2500);assert.ok(frames.some(c=>c.message==='0|A|C|2500|50000001200.25'));
 const count=frames.length;admin.grantUridium('large-wallet',50000000000,'live-fifty-billion');assert.equal(frames.length,count);
 assert.equal(require('../game/economy').purchase(id,'resource_upgrade-module',100).result,'success');assert.equal(world.player.uridium,49999001200.25);assert.equal(wallet().uridium,49999001200.25);assert.ok(frames.some(c=>c.message==='0|A|C|2500|49999001200.25'));
 const inventory=require('../game/assembly').inventoryCommand(id);assert.equal(codec.decode(codec.encode(inventory)).obj.inventoryItemModules.find(i=>i.lootId==='currency_uridium').amount,49999001200.25);
 const initial=require('../game/init').buildInit(world).find(c=>c._==='ShipInitializationCommand');assert.equal(codec.decode(codec.encode(initial)).obj.uridium,49999001200.25);
 const html=require('../web/portal/render').renderPage('internalDock','internalDockSpecials',players.loadPlayer(id));assert.match(html,/"uridium":49999001200\.25/);assert.match(html,/49\.999\.001\.200/);
 world.removeSession(session);assert.equal(players.loadPlayer(id).uridium,49999001200.25);
});
