'use strict';
const {test,before,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const database=require('../game/db'),players=require('../game/db/players'),World=require('../game/world'),hangars=require('../game/hangars'),api=require('../web/hangar-api'),portal=require('../web/portal/render');
let db,index=0;const original=World.current;
before(()=>{database.close();db=database.open(':memory:');World.current=()=>null;});after(()=>{World.current=original;database.close();});
function fixture(uri=1000000){const account=Number(db.prepare('INSERT INTO accounts(username,password_hash,created_at)VALUES(?,?,0)').run('hangars-'+(++index),'test').lastInsertRowid),id=players.createPlayer(account,'hangars'+index,1,{...require('../config.json').starter,uridium:uri});return {id,account,ship:players.loadPlayer(id).shipId};}
function extra(id,loot='ship_goliath'){return Number(db.prepare('INSERT INTO ships(player_id,loot_id,hitpoints)VALUES(?,?,100)').run(id,loot).lastInsertRowid);}
function money(id){return db.prepare('SELECT uridium FROM players WHERE id=?').get(id).uridium;}
function snapshot(id){return {player:db.prepare('SELECT * FROM players WHERE id=?').get(id),ships:db.prepare('SELECT * FROM ships WHERE player_id=? ORDER BY id').all(id),items:db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),slots:db.prepare('SELECT * FROM player_hangar_slots WHERE player_id=? ORDER BY slot_no').all(id),receipts:db.prepare('SELECT * FROM player_hangar_purchases WHERE player_id=? ORDER BY slot_no').all(id)};}
test('legacy slot1 maps current ship; owning other ships never grants free expansion or alters equipment',()=>{
 const {id,ship}=fixture();extra(id);extra(id,'ship_vengeance');const before=snapshot(id),s=hangars.state(id);assert.equal(s.slots.length,1);assert.equal(s.slots[0].shipId,ship);assert.equal(s.ships.length,3);assert.equal(s.ships.filter(x=>x.slot===null).length,2);assert.equal(s.nextSlot,2);assert.equal(s.price,250000);assert.equal(s.maxSlots,200);assert.equal(money(id),1000000);assert.deepEqual(snapshot(id).ships,before.ships);assert.deepEqual(snapshot(id).items,before.items);
});
test('each expansion costs exactly250k and creates a persistent empty slot without a ship',()=>{
 const {id,ship}=fixture(),before=snapshot(id);let out=hangars.purchase(id,2,'purchase_token_00000001');assert.equal(out.replayed,false);assert.equal(money(id),750000);assert.equal(out.state.slots[1].shipId,null);assert.equal(out.state.activeShipId,ship);assert.equal(out.state.selectedSlot,1);
 hangars.purchase(id,3,'purchase_token_00000002');assert.equal(money(id),500000);assert.deepEqual(hangars.state(id).slots.map(x=>x.shipId),[ship,null,null]);assert.deepEqual(snapshot(id).ships,before.ships);assert.deepEqual(snapshot(id).items,before.items);
});
test('receipt replay is idempotent; stale expected slot and a token reused for another slot cannot debit',()=>{
 const {id}=fixture();hangars.purchase(id,2,'purchase_token_00000003');const before=snapshot(id);assert.equal(hangars.purchase(id,2,'purchase_token_00000003').replayed,true);assert.deepEqual(snapshot(id),before);
 assert.throws(()=>hangars.purchase(id,2,'purchase_token_00000004'),/listesi değişti/);assert.throws(()=>hangars.purchase(id,3,'purchase_token_00000003'),/başka bir hangar/);assert.deepEqual(snapshot(id),before);
 for(const slot of [0,-1,1.5,'1e0',999999])assert.throws(()=>hangars.purchase(id,slot,'purchase_token_00000005'));
 assert.throws(()=>hangars.purchase(id,3,'short'));assert.deepEqual(snapshot(id),before);
});
test('insufficient funds and a failed receipt write roll back debit and slot creation together',()=>{
 const poor=fixture(249999);hangars.state(poor.id);const before=snapshot(poor.id);assert.throws(()=>hangars.purchase(poor.id,2,'purchase_token_00000006'),/Yeterli uridyum/);assert.deepEqual(snapshot(poor.id),before);
 const {id}=fixture();hangars.state(id);const saved=snapshot(id);db.exec("CREATE TRIGGER fail_hangar_receipt BEFORE INSERT ON player_hangar_purchases BEGIN SELECT RAISE(ABORT,'hangar-receipt-failure'); END");
 try{assert.throws(()=>hangars.purchase(id,2,'purchase_token_00000007'),/hangar-receipt-failure/);}finally{db.exec('DROP TRIGGER fail_hangar_receipt');}assert.deepEqual(snapshot(id),saved);
});
test('selecting an empty hangar preserves active ship; assigning/switching owned ships preserves both configs',()=>{
 const {id,ship}=fixture(),other=extra(id);const item=Number(db.prepare("INSERT INTO items(player_id,loot_id,amount,ship_id,slot,slot_index)VALUES(?,'equipment_weapon_laser_lf-3',1,?,'laser',0)").run(id,other).lastInsertRowid);
 db.prepare("INSERT INTO equipment_config2(ship_id,item_id,slot,slot_index)VALUES(?,?,'laser',0)").run(other,item);const equipment=db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),config=db.prepare('SELECT * FROM equipment_config2 WHERE ship_id=?').all(other);
 hangars.purchase(id,2,'purchase_token_00000008');let s=hangars.select(id,2);assert.equal(s.selectedSlot,2);assert.equal(s.activeShipId,ship);assert.equal(s.selectedIndex,-1);
 s=hangars.assign(id,2,other);assert.equal(s.activeShipId,other);assert.equal(s.selectedIndex,1);s=hangars.select(id,1);assert.equal(s.activeShipId,ship);assert.equal(s.selectedIndex,0);
 assert.deepEqual(db.prepare('SELECT * FROM items WHERE player_id=? ORDER BY id').all(id),equipment);assert.deepEqual(db.prepare('SELECT * FROM equipment_config2 WHERE ship_id=?').all(other),config);
 hangars.purchase(id,3,'purchase_token_00000009');assert.throws(()=>hangars.assign(id,3,other),/başka bir hangara/);
});
test('unowned slots/ships and online assignment/activation are rejected without account changes',()=>{
 const a=fixture(),b=fixture(),other=extra(a.id);hangars.purchase(a.id,2,'purchase_token_00000010');const before=snapshot(a.id);
 assert.throws(()=>hangars.assign(a.id,2,b.ship),/Gemi bulunamadı/);assert.throws(()=>hangars.select(a.id,3),/sahip değilsin/);assert.deepEqual(snapshot(a.id),before);
 World.current=()=>({livePlayer:id=>id===a.id?players.loadPlayer(a.id):null});
 try{assert.throws(()=>hangars.assign(a.id,2,other),/oyundan çık/);assert.throws(()=>hangars.select(a.id,1),/oyundan çık/);}finally{World.current=()=>null;}assert.deepEqual(snapshot(a.id),before);
});
test('live purchase uses current wallet and repeated response never debits it twice',()=>{
 const {id}=fixture(1),p=players.loadPlayer(id);p.uridium=500005;p.credits=123;World.current=()=>({livePlayer:pid=>pid===id?p:null,broadcast:()=>{}});
 try{hangars.purchase(id,2,'purchase_token_00000011');assert.equal(p.uridium,250005);assert.equal(money(id),250005);hangars.purchase(id,2,'purchase_token_00000011');assert.equal(p.uridium,250005);assert.equal(money(id),250005);}finally{World.current=()=>null;}
});
test('replacing an assigned hull leaves its old ship/equipment owned and unassigned',()=>{
 const {id}=fixture(),a=extra(id),b=extra(id,'ship_vengeance');hangars.purchase(id,2,'purchase_token_replace01');hangars.assign(id,2,a);const ships=snapshot(id).ships,items=snapshot(id).items;
 const state=hangars.assign(id,2,b);assert.equal(state.slots[1].shipId,b);assert.equal(state.activeShipId,b);assert.equal(state.ships.find(x=>x.id===a).slot,null);assert.equal(state.ships.find(x=>x.id===b).slot,2);assert.deepEqual(snapshot(id).ships,ships);assert.deepEqual(snapshot(id).items,items);
});
test('native inventory activation keeps viewed selection distinct and accurately reports unassigned active hull',()=>{
 const {id,ship}=fixture(),unassigned=extra(id);hangars.state(id);require('../game/inventory').activate(id,unassigned);const state=hangars.state(id);assert.equal(state.selectedSlot,1);assert.equal(state.slots[0].shipId,ship);assert.equal(state.activeShipId,unassigned);assert.equal(state.activeSlot,null);assert.equal(state.selectedIndex,0);const html=api.header(id).panel;assert.match(html,/Görüntülenen: Hangar 1/);assert.match(html,/Aktif gemi: GOLIATH \(hangara atanmamış\)/);
});
test('catalog max200 is enforced without hiding or overwriting earlier slots',()=>{
 const {id}=fixture();hangars.state(id);const insert=db.prepare('INSERT INTO player_hangar_slots(player_id,slot_no)VALUES(?,?)');for(let n=2;n<=200;n++)insert.run(id,n);const before=money(id);assert.equal(hangars.state(id).nextSlot,null);assert.throws(()=>hangars.purchase(id,201,'purchase_token_00000012'),/Azami/);assert.equal(money(id),before);
});
test('native header renders paid slots plus original sprites/classes and keeps inventory ship ids unchanged',()=>{
 const {id,ship}=fixture(),other=extra(id);hangars.purchase(id,2,'purchase_token_00000013');hangars.assign(id,2,other);
 const html=portal.renderPage('internalDock',null,players.loadPlayer(id));assert.equal((html.match(/data-hangar-slot=/g)||[]).length,2);assert.equal((html.match(/id="header_hangar_slots"/g)||[]).length,1);assert.match(html,/header_hangar_slot_getNext/);assert.match(html,/250\.000 U\./);assert.match(html,/local-hangars\.js/);
 const state=JSON.parse(/window.LocalHangarsState=(\{[^\n]*\});<\/script>/.exec(html)[1]);assert.equal(state.selectedIndex,1);assert.equal(state.slots[1].shipId,other);
 const data=JSON.parse(Buffer.from(require('../web/inventory-api').handle(id,new URLSearchParams({action:'getHangarList'})).body,'base64').toString());assert.deepEqual(data.data.ret.hangars.map(x=>Number(x.hangarID)),[ship,other]);
 assert.ok(fs.existsSync(path.join(__dirname,'../client/_host/do_img/global/header/buttons/hangar_slots_sprite.png')));
});
test('API rejects invalid commands and never trusts a client-supplied price or playerid',()=>{
 const {id}=fixture();const out=api.handle(id,new URLSearchParams({action:'purchase',slot:'2',requestId:'purchase_token_00000014',price:'1',playerId:'9999'}));assert.equal(out.result,'success');assert.equal(out.state.userBalance.uridium,750000);assert.equal(api.handle(id,new URLSearchParams({action:'unknown'})).result,'error');
});
