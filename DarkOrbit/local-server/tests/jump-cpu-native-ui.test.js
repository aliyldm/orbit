'use strict';
const {test,before,after,beforeEach,afterEach}=require('node:test'),assert=require('node:assert/strict');
const database=require('../game/db'),players=require('../game/db/players'),config=require('../config'),World=require('../game/world'),Combat=require('../game/combat'),cpu=require('../game/cpu'),jump=require('../game/jump-cpu'),inventory=require('../game/inventory'),gameplay=require('../game/gameplay'),codec=require('../game/codec/codec');
let db,f,serial=0;
before(()=>{db=database.open(':memory:');});after(()=>database.close());
beforeEach(()=>{
 const id=players.createPlayer(players.createAccount('jump-native-'+ ++serial,'testpass'),'Jump QA',1,{...config.starter,ship:'ship_goliath',uridium:1000000}),world=World.instance(config),out=[],jobs=[],handlers=new Map();
 const capture=c=>{const decoded=codec.decode(codec.encode(c));assert.equal(decoded.rest,0);out.push(decoded.obj);};
 const session={world,send(buffer){const len=buffer.readUIntBE(0,3);assert.equal(len,buffer.length-3);const decoded=codec.decode(buffer.subarray(3));assert.equal(decoded.rest,0);out.push(decoded.obj);},close(){}};
 world.login(session,id);Object.assign(world.player,{x:6000,y:6000,lastCombat:0,level:18});const combat=new Combat(world,(s,c)=>capture(c));combat.map=require('../game/maps').getMap(1);
 world.schedule=fn=>{jobs.push(fn);return 1;};world.jumpVoucherNext=0;
 gameplay.register((name,fn)=>handlers.set(name,fn),{sendCmd:(s,c)=>capture(c),buildInit:w=>cpu.buildInit(w.player),combatFor:()=>({start(){}})});
 f={world,s:session,p:world.player,id,out,jobs,handlers,combat};
});
afterEach(()=>{db.exec('DROP TRIGGER IF EXISTS fail_voucher');f.world.removeSession(f.s);});
function add(id,n=1){return Number(db.prepare('INSERT INTO items(player_id,loot_id,amount)VALUES(?,?,?)').run(f.id,id,n).lastInsertRowid);}
function equip(id){const item=add(id);inventory.move(f.id,{params:{hi:f.p.shipId},from:{target:'inventory',items:[item],configId:1},to:{target:'ship',slotset:'extras',configId:1}});return item;}
function lastInit(){return f.out.findLast(c=>c._==='CPUInitializationCommand');}
function uiList(){return f.out.findLast(c=>c._==='LegacyModule'&&c.message.startsWith('0|A|JCPU|I'));}

test('live original inventory equip/removal sends actual AJP panel enable/disable; JP02 never masquerades as AJP',()=>{
 equip(cpu.PREFIX+'jp-02');assert.equal(lastInit().advancedJumpCPUEquipped,false);assert.equal(cpu.buildInit(f.p).find(c=>c._==='CPUInfoHomeJumpCommand').chargesLeft,20);
 const ajp=equip(cpu.PREFIX+'ajp-01');assert.equal(lastInit().advancedJumpCPUEquipped,true);assert.ok(uiList());assert.ok(f.out.some(c=>c.message==='0|A|JV|0'));
 inventory.move(f.id,{params:{hi:f.p.shipId},from:{target:'ship',items:[ajp],slotset:'extras',configId:1},to:{target:'inventory',configId:1}});assert.equal(lastInit().advancedJumpCPUEquipped,false);
});

test('native map selection and button packets show voucher count and complete a free AJP jump consuming exactly one',()=>{
 equip(cpu.PREFIX+'ajp-01');add(jump.VOUCHER,2);f.p.uridium=0;f.world.save();f.out.length=0;
 assert.equal(jump.legacy(f.s,'JCPU|GET'),true);assert.ok(f.out.some(c=>c.message==='0|A|JV|2'));
 const fields=uiList().message.split('|');assert.ok(!fields[fields.indexOf('-2')+1].split(';').map(Number).includes(2));
 assert.equal(jump.legacy(f.s,'JCPU|S|2'),true);assert.equal(f.out.at(-1).message,`0|A|JCPU|C|2|${jump.price(f.p,2)}|1`);
 assert.equal(jump.legacy(f.s,'JCPU|J'),true);assert.equal(f.s.cpuJump.useVoucher,true);assert.equal(f.s.cpuJump.cost,0);assert.equal(jump.voucherCount(f.p),2);assert.equal(f.p.mapId,1);
 f.jobs.shift()();assert.equal(f.p.mapId,2);assert.equal(jump.voucherCount(f.p),1);assert.equal(f.p.uridium,0);assert.equal(players.loadPlayer(f.id).mapId,2);assert.ok(cpu.read(f.p).jumpUntil>Date.now());assert.ok(f.out.some(c=>c.message==='0|A|JV|1'));
 assert.equal(jump.legacy(f.s,'JCPU|J'),false);assert.equal(jump.voucherCount(f.p),1);
});

test('voucher does not bypass map level, home-company, quiet-period or movement restrictions',()=>{
 equip(cpu.PREFIX+'ajp-01');add(jump.VOUCHER);f.p.level=7;assert.equal(jump.select(f.s,13),false);assert.equal(jump.select(f.s,5),false);f.p.level=18;assert.equal(jump.select(f.s,13),true);
 f.p.lastCombat=Date.now();assert.equal(jump.jump(f.s),false);f.p.lastCombat=0;f.world.move(f.s,{targetX:6500,targetY:6000,positionX:6000,positionY:6000});assert.equal(jump.jump(f.s),false);f.world.movement=null;assert.equal(jump.voucherCount(f.p),1);
});

test('losing a quoted free voucher during cast cannot silently charge Uri or move; atomic failure restores voucher',()=>{
 equip(cpu.PREFIX+'ajp-01');const item=add(jump.VOUCHER);const uri=f.p.uridium;jump.select(f.s,2);assert.equal(jump.jump(f.s),true);db.prepare('UPDATE items SET amount=0 WHERE id=?').run(item);f.jobs.shift()();assert.equal(f.p.mapId,1);assert.equal(f.p.uridium,uri);assert.equal(cpu.read(f.p).jumpUntil,undefined);
 db.prepare('UPDATE items SET amount=1 WHERE id=?').run(item);jump.select(f.s,2);assert.equal(jump.jump(f.s),true);
 db.exec("CREATE TRIGGER fail_voucher BEFORE INSERT ON settings WHEN NEW.key='game.cpus' BEGIN SELECT RAISE(ABORT,'voucher-storage-failure'); END");f.jobs.shift()();assert.equal(jump.voucherCount(f.p),1);assert.equal(f.p.mapId,1);assert.equal(f.p.uridium,uri);assert.equal(cpu.read(f.p).jumpUntil,undefined);
});

test('JP02 home uses its own physical charge and never consumes an AJP voucher',()=>{
 const item=equip(cpu.PREFIX+'jp-02');add(jump.VOUCHER,3);f.p.mapId=2;f.world.save();assert.equal(jump.home(f.s),true);assert.equal(f.p.mapId,1);assert.equal(cpu.charges(db.prepare('SELECT * FROM items WHERE id=?').get(item)),19);assert.equal(jump.voucherCount(f.p),3);assert.equal(lastInit().advancedJumpCPUEquipped,false);
});

test('native UI selection request matches legacy path; unsupported current map locks the actual map UI',()=>{
 equip(cpu.PREFIX+'ajp-01');const decoded=codec.decode(codec.encode({_:'JumpCPUSelectRequest',mapId:2})).obj;assert.equal(f.handlers.get('JumpCPUSelectRequest')(f.s,decoded),true);assert.equal(f.s.cpuJumpTarget,2);
 f.p.mapId=51;assert.equal(jump.list(f.s),true);assert.equal(uiList().message,'0|A|JCPU|I');assert.equal(jump.select(f.s,2),false);assert.equal(f.s.cpuJumpTarget,undefined);assert.equal(f.out.at(-1).message,'0|A|JCPU|C|2|0|0');
});

test('newly awarded voucher updates original JV count and selected-map affordability without relogin',()=>{
 equip(cpu.PREFIX+'ajp-01');f.p.uridium=0;f.world.save();jump.select(f.s,2);assert.ok(f.out.at(-1).message.endsWith('|0'));add(jump.VOUCHER,4);jump.tick(f.world,Date.now());assert.ok(f.out.some(c=>c.message==='0|A|JV|4'));assert.ok(f.out.at(-1).message.endsWith('|1'));assert.equal(f.s.cpuJumpTarget,2);
});
