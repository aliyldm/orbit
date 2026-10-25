'use strict';
const assert=require('node:assert/strict');
exports.verify=async({world,a,frame,db,base,cookie})=>{
 const p=world.player,mark=a.commands.length;
 a.socket.write(frame({_:'TrinityTrialsUIRequest',optionalType:1}));a.socket.write(frame({_:'VoyagersUIRequest'}));a.socket.write(frame({_:'DailyLoginRewardDayRequest'}));
 await a.until(commands=>['TrinityTrialsPassCommand','VoyagersPassCommand','DailyLoginRewardDayCommand'].every(type=>commands.slice(mark).some(c=>c._===type)));
 const native=require('../game/native-rewards');for(const event of ['trinity','voyagers']){const type=event==='trinity'?'TrinityTrialsPassCommand':'VoyagersPassCommand';assert.deepEqual(a.commands.slice(mark).find(c=>c._===type),native.passCommand(db,p.userId,event));}
 const view=await fetch(base+'/flashAPI/dailyLogin.php',{headers:{cookie}});assert.equal(view.status,200);assert.ok(Array.isArray((await view.json()).rewards));
 assert.equal((await fetch(base+'/flashAPI/dailyLogin.php')).status,401);
 const claim=()=>fetch(base+'/flashAPI/dailyLogin.php?doBook=1',{method:'POST',headers:{cookie,origin:base}});
 let booked=await claim();assert.equal(booked.status,200);assert.match(booked.headers.get('content-type'),/image\/gif/);assert.equal(Buffer.from(await booked.arrayBuffer()).toString('ascii',0,6),'GIF89a');
 const receipts=()=>db.prepare('SELECT COUNT(*) n FROM daily_login_claims WHERE player_id=?').get(p.userId).n;assert.equal(receipts(),1);booked=await claim();assert.equal(booked.status,200);assert.equal(receipts(),1);
 const dailyMark=a.commands.length;a.socket.write(frame({_:'DailyLoginClaimTodayRequest'}));await a.until(commands=>commands.slice(dailyMark).some(c=>c._==='DailyLoginClaimTodayCommand'&&c.claimed));assert.equal(receipts(),1);
 const hall=await fetch(base+'/indexInternal.es?action=internalHallofFame',{headers:{cookie}});assert.equal(hall.status,200);const html=await hall.text();assert.match(html,/ŞEREF SALONU/);assert.ok(html.includes(p.userName));
 // Isolated QA DB only: create a second favourite hull and use the real socket.
 const target=Number(db.prepare("INSERT INTO ships(player_id,loot_id,hitpoints,favorite)VALUES(?,'ship_goliath',356000,1)").run(p.userId).lastInsertRowid);
 world.stopMovement();Object.assign(p,{x:6000,y:6000,lastCombat:Date.now()-11000});for(const s of world.sessions)world.combat.abort(s);const before={map:p.mapId,x:p.x,y:p.y,uri:p.uridium,vouchers:require('../game/jump-cpu').voucherCount(p)},listMark=a.commands.length;
 a.socket.write(frame({_:'UIButtonTriggerRequest',itemId:'ship_warp'}));await a.until(commands=>commands.slice(listMark).some(c=>c._==='ShipWarpWindowCommand'&&c.ships.some(x=>x.shipId===target)));
 const warpMark=a.commands.length;a.socket.write(frame({_:'ShipWarpRequest',shipId:target}));await a.until(commands=>commands.slice(warpMark).some(c=>c._==='ShipWarpCompletedCommand'),15000);
 assert.equal(p.shipId,target);assert.equal(world.player,p);assert.deepEqual([p.mapId,p.x,p.y],[before.map,before.x,before.y]);assert.equal(p.uridium,before.uri-(before.vouchers?0:200));assert.equal(db.prepare('SELECT active_ship_id FROM players WHERE id=?').get(p.userId).active_ship_id,target);
 assert.equal(require('../game/jump-cpu').voucherCount(p),Math.max(0,before.vouchers-1));
};
