'use strict';
// Explicit local admin grants. Stable receipts prevent duplicate grants after
// inspector timeouts, and a live player's pending rewards are preserved.
function grantUridium(account,amount,requestKey){
 if(typeof account!=='string'||!account||!Number.isSafeInteger(amount)||amount<=0||typeof requestKey!=='string'||!requestKey||requestKey.length>180)throw Error('Invalid account, amount or request key');
 const database=require('./db'),world=require('./world').current(),net=require('./net'),db=database.open();
 if(typeof net.walletCommand!=='function')throw Error('Server restart required for large-wallet protocol support');
 const row=db.prepare('SELECT p.* FROM players p JOIN accounts a ON a.id=p.account_id WHERE a.username=?').get(account);
 if(!row)throw Error('Account not found');
 const key='admin_wallet_'+requestKey,existing=db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(row.id,key);
 if(existing){const receipt=JSON.parse(existing.value);if(receipt.amount!==amount||receipt.account!==account)throw Error('Request key was already used for a different grant');return {replayed:true,...receipt};}
 const live=world?.livePlayer(row.id);let receipt;
 database.tx(conn=>{
  if(live)conn.prepare('UPDATE players SET credits=?,uridium=? WHERE id=?').run(live.credits,live.uridium,row.id);
  const before=conn.prepare('SELECT uridium FROM players WHERE id=?').get(row.id).uridium,after=before+amount;
  if(!Number.isFinite(before)||before<0||!Number.isFinite(after)||after>Number.MAX_SAFE_INTEGER||after-amount!==before)throw Error('Wallet exact Number range exceeded');
  net.walletCommand({_:'AttributeCreditsUpdateCommand',credits:live?.credits??row.credits,uridium:after});
  conn.prepare('UPDATE players SET uridium=? WHERE id=?').run(after,row.id);
  receipt={playerId:row.id,account,amount,before,after,at:Date.now()};
  conn.prepare('INSERT INTO settings(player_id,key,value)VALUES(?,?,?)').run(row.id,key,JSON.stringify(receipt));
 });
 if(live){live.uridium=receipt.after;world.broadcast(session=>net.sendCmd(session,{_:'AttributeCreditsUpdateCommand',credits:live.credits,uridium:live.uridium,jackpot:live.jackpot||0}));}
 return {replayed:false,...receipt};
}
module.exports={grantUridium};
