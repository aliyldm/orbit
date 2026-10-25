'use strict';
// Lazer cephanesi: seçim (MenuActionRequest menuItemId="ammunition_laser_*") ve atış başına tüketim.
// Her atış takılı lazer sayısı kadar cephane harcar; çarpan item_types.multiplier'dan (LCB-10=1 … UCB-100=4).
// Not: istemcinin eylem çubuğundaki cephane sayaçları henüz sunucudan güncellenmiyor.

const { open, tx } = require('./db');

const DEFAULT_AMMO = 'ammunition_laser_lcb-10';
const RSB_AMMO = 'ammunition_laser_rsb-75';
const delivered = new WeakMap();

function select(p, lootId) {
  const t = require('./laser-ammo').supported(lootId)&&open().prepare("SELECT * FROM item_types WHERE loot_id = ?").get(lootId);
  if (!t) return false;
  if (lootId !== RSB_AMMO) p.previousLaserAmmo = lootId;
  else if (p.ammo && p.ammo !== RSB_AMMO) p.previousLaserAmmo = p.ammo;
  if ((p.ammo || DEFAULT_AMMO) === lootId && p.ammoMultiplier === t.multiplier) return true;
  p.ammo = lootId;
  p.ammoMultiplier = require('./laser-ammo').multiplier({...p,ammo:lootId},null);
  notify(p);
  return true;
}

// RSB is a single salvo; return to the last regular selection after resolving
// its damage/effect. Keep the independent RSB cooldown on the player.
function finishSalvo(p) {
  if (p.ammo !== RSB_AMMO) return false;
  return select(p, p.previousLaserAmmo || DEFAULT_AMMO);
}

// Bir atışlık cephaneyi depodan düşer; yetmiyorsa false.
function consume(p) {
  if (!p.ammo) select(p, DEFAULT_AMMO);
  const need = p.stats.laserCount;
  if (!Number.isSafeInteger(need) || need <= 0) return false;
  require('./automation').laserAmmo(p,need);
  const result=tx(db => {
    const rows=db.prepare('SELECT id,amount FROM items WHERE player_id=? AND loot_id=? AND ship_id IS NULL AND amount>0 ORDER BY id').all(p.userId,p.ammo);
    if (rows.reduce((sum,r)=>sum+r.amount,0)<need) return false;
    let left=need;
    for (const row of rows) {
      const take=Math.min(left,row.amount);
      db.prepare('UPDATE items SET amount=amount-? WHERE id=?').run(take,row.id);
      left-=take;
      if (!left) break;
    }
    return true;
  });
  if(result) notify(p);
  return result;
}

function count(p, lootId = p.ammo || DEFAULT_AMMO) {
  return open().prepare('SELECT COALESCE(SUM(amount), 0) AS n FROM items WHERE player_id = ? AND loot_id = ? AND ship_id IS NULL').get(p.userId, lootId).n;
}

let templates;
function buildAmmoCommands(p) {
  if(!templates) {
    templates=new Map();
    const walk=v=>{
      if(!v||typeof v!=='object')return;
      if(v._==='MenuItemStatusCommand' && /^ammunition_/.test(v.menuItemId))templates.set(v.menuItemId,v);
      for(const x of Object.values(v)) if(x&&typeof x==='object')walk(x);
    };
    walk(require('./templates/init.json'));
  }
  const quantities=new Map(open().prepare(`SELECT loot_id,SUM(amount) AS n FROM items WHERE player_id=? GROUP BY loot_id`).all(p.userId).map(i=>[i.loot_id,i.n]));
  return [...templates].map(([id,source])=>{
    const cmd=JSON.parse(JSON.stringify(source));
    const n=quantities.get(id)||0;
    cmd.counterValue=n;cmd.available=n>0;cmd.activatable=n>0;
    if(id.startsWith('ammunition_laser_'))cmd.selected=id===(p.ammo||DEFAULT_AMMO);
    if(id.startsWith('ammunition_rocket_'))cmd.selected=id===(p.rocket||'ammunition_rocket_r-310');
    Object.assign(cmd,require('./advanced-weapons').menuStatus(p,cmd));
    Object.assign(cmd,require('./menu-capabilities').status(p,cmd));
    const replace=v=>{
      if(!v||typeof v!=='object')return;
      if(v.wildcard==='%COUNT%')v.replacement=String(n);
      for(const x of Object.values(v))if(x&&typeof x==='object')replace(x);
    };
    replace(cmd);
    return cmd;
  });
}
function remember(p, commands) {
  delivered.set(p, new Map(commands.map(command => [command.menuItemId, JSON.stringify(command)])));
}
function notify(p, options = {}) {
  const world=options.world || require('./world').current();
  if(!world || !world.livePlayer(p.userId))return;
  const sendCmd=options.sendCmd || require('./net').sendCmd;
  const commands=buildAmmoCommands(p);
  const previous = delivered.get(p) || new Map(), changed = [];
  for (const command of commands) {
    const serialized = JSON.stringify(command);
    if (previous.get(command.menuItemId) !== serialized) changed.push(command);
    previous.set(command.menuItemId, serialized);
  }
  delivered.set(p, previous);
  if (changed.length) world.broadcast(s=>{for(const cmd of changed)sendCmd(s,cmd);});
  return changed.length;
}
module.exports = { select, consume, count, DEFAULT_AMMO, RSB_AMMO, finishSalvo, buildAmmoCommands, remember, notify };
