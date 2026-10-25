'use strict';
const players = require('./db/players');
const { sendCmd } = require('./net');
let current = null;
class World {
  static instance(config) { if (!current) current = new World(config); return current; }
  static current() { return current; }
  constructor(config, services = {}) {
    this.config = config;
    this.players = services.players || players;
    this.now = services.now || Date.now;
    this.sessions = new Set(); this.player = null; this.npcs = new Map();
    this.scheduled = new Set(); this.movement = null; this.epoch = 0;
  }
  login(session, playerId) {
    // Detach before close: an old socket's delayed close cannot save the new player.
    for (const old of [...this.sessions]) {
      this.removeSession(old);
      if (old !== session && typeof old.close === 'function') old.close();
    }
    const player = this.players.loadPlayer(playerId);
    if (!player) throw new Error('Oyuncu bulunamadı');
    this.player = player; player.dead = player.hitPoints <= 0;
    this.sessions.add(session); session.player = player;
    session.selected = session.attacking = null;
    return player;
  }
  active(session) { return !!this.player && session.player === this.player && this.sessions.has(session); }
  livePlayer(playerId) { return this.player && this.sessions.size && this.player.userId === playerId ? this.player : null; }
  updatePosition(now = this.now()) {
    if (!this.player) return this.player;
    if (!this.movement) { require('./pirate-fields').apply(this); return this.player; }
    const previous={x:this.player.x,y:this.player.y};
    const m = this.movement;
    const ratio = Math.max(0, Math.min(1, (now - m.start) / m.duration));
    this.player.x = m.x + (m.targetX - m.x) * ratio;
    this.player.y = m.y + (m.targetY - m.y) * ratio;
    if (ratio === 1) this.movement = null;
    require('./pirate-fields').apply(this,previous);
    return this.player;
  }
  stopMovement() { this.updatePosition(); this.movement = null; }
  move(session, cmd) {
    if (!this.active(session) || this.player.dead || session.jumping || this.player.speed<=0) return false;
    if (![cmd.positionX, cmd.positionY, cmd.targetX, cmd.targetY].every(Number.isFinite)) return false;
    require('./ship-warp').cancel(session);
    const p = this.updatePosition(); const map = require('./maps').getMap(p.mapId);
    if (!map) return false;
    const target={x:Math.max(0,Math.min(map.width,cmd.targetX)),y:Math.max(0,Math.min(map.height,cmd.targetY))};
    // EventManager queues movement for up to 200ms. A nearby collect callback
    // can reach us before that final approach request. Keep that harvest alive;
    // a real destination change must still cancel the beam (including booty).
    const box=session.harvest&&this.collectables?.boxes.get(session.harvest.hash);
    const arrival=box&&(Math.hypot(target.x-p.x,target.y-p.y)<=2||Math.hypot(target.x-box.x,target.y-box.y)<=2);
    if(!arrival)this.collectables?.cancelHarvest(session);
    const targetX=target.x,targetY=target.y;
    // Client position is observational. Only the destination is accepted.
    const duration = Math.hypot(targetX - p.x, targetY - p.y) / Math.max(1, p.speed) * 1000;
    this.movement = duration ? { x: p.x, y: p.y, targetX, targetY, start: this.now(), duration } : null;
    session.target = { x: targetX, y: targetY }; p.repairing = false;
    return true;
  }
  schedule(fn, delay) {
    const epoch = this.epoch;
    const timer = setTimeout(() => {
      this.scheduled.delete(timer);
      if (epoch !== this.epoch || !this.player || !this.sessions.size) return;
      try { fn(); }
      catch (error) {
        // Delayed harvest/jump/impact work runs outside packet dispatch's error
        // boundary. Retire its session rather than crashing the whole server or
        // continuing a partly completed map/action. Never retry a reward here.
        console.error('[world] Gecikmeli işlem başarısız:', error);
        for (const session of [...this.sessions]) {
          try { this.removeSession(session); }
          catch (saveError) { console.error('[world] Oturum kaydedilemedi:', saveError); }
          try { session.close?.(); }
          catch (closeError) { console.error('[world] Oturum kapatılamadı:', closeError); }
        }
      }
    }, delay);
    timer.unref?.(); this.scheduled.add(timer); return timer;
  }
  cancelScheduled() { this.epoch++; for (const t of this.scheduled) clearTimeout(t); this.scheduled.clear(); }
  save() { if (this.player) { this.updatePosition(); this.players.savePlayer(this.player); require('./pet').save(this); } }
  refreshStats() {
    const p = this.player; if (!p) return;
    this.stopMovement(); const fresh = this.players.loadPlayer(p.userId), previousExpansion = p.expansionStage;
    Object.assign(p, { stats: fresh.stats, shipId: fresh.shipId, typeId: fresh.typeId, speed: fresh.speed,
      hitMax: fresh.hitMax, shieldMax: fresh.shieldMax, maxNanoHull:fresh.maxNanoHull,nanoHull:Math.min(p.nanoHull||0,fresh.maxNanoHull),cargoSpaceMax: fresh.cargoSpaceMax, cargoSpace: fresh.cargoSpace, expansionStage: fresh.expansionStage,
      hitPoints: Math.min(p.hitPoints, fresh.hitMax), shield: Math.min(p.shield, fresh.shieldMax) });
    require('./player-speed').refresh(this,this.now(),{baseSpeed:fresh.speed,notify:false});
    if(p.ultimateCloaked){p.ultimateShield=Math.min(p.ultimateShield||0,p.shieldMax);p.shield=0;}
    require('./ship-abilities-expanded').configurationChanged(this,this.now());
    this.broadcast(s => {
      if (previousExpansion !== p.expansionStage) sendCmd(s, { _: 'ShipExtensionsCommand', userId: p.userId, extensionStage: p.expansionStage });
      sendCmd(s, { _: 'AttributeShipSpeedUpdateCommand', newSpeed: p.speed, displaySpeed: p.speed });
      sendCmd(s, { _: 'AttributeShieldUpdateCommand', shieldNow: p.shield, shieldMax: p.shieldMax });
      sendCmd(s, require('./nano-hull').command(p));
      sendCmd(s, require('./ship-modules').command(p));
    });
    require('./shield-visuals').refresh(this);
    require('./pet').refresh(this);
    require('./hellstorm').notify(this);
    for(const c of require('./combat-utilities').buildInit(this))this.broadcast(s=>sendCmd(s,c));
  }
  removeSession(session) {
    if (!this.sessions.has(session)) return false;
    require('./ship-warp').cancel(session,false);
    this.stopMovement(); this.sessions.delete(session);
    session.attacking = session.selected = null; session.player = null;
    if (!this.sessions.size) {
      // A failed SQLite save must still release this old world's timers and
      // references. Propagate the first failure after all cleanup was attempted.
      let failure;
      const attempt = fn => { try { fn(); } catch (error) { failure ||= error; } };
      attempt(() => require('./pet').stop(this,{notify:false}));
      attempt(() => this.combat?.stop());
      this.cancelScheduled();
      attempt(() => this.save());
      this.player = null; this.petRuntime = null; this.petResume = false;
      attempt(() => this.collectables?.clear()); this.collectables = null;
      if (failure) throw failure;
    }
    return true;
  }
  broadcast(fn) { for (const s of this.sessions) fn(s); }
}
module.exports = World;
