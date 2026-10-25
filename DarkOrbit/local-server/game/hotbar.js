'use strict';
// SendSlotBarConfigSetRequestCommand -> MenuInitializationCommand is the
// client's actual drag/drop request and authoritative slot reconstruction.
const { open } = require('./db');
const KEY = 'hotbar.slots';
const IDS = new Set(['standardSlotBar', 'premiumSlotBar', 'proActionBar']);
const template = require('./templates/init.json').commands.find(c => c._ === 'MenuInitializationCommand');
const items = new Set();
(function visit(value) {
  if (!value || typeof value !== 'object') return;
  if (value._ === 'MenuItemStatusCommand') items.add(value.menuItemId);
  for (const child of Object.values(value)) visit(child);
})(template);
function load(playerId, db = open()) {
  const row = db.prepare('SELECT value FROM settings WHERE player_id=? AND key=?').get(playerId, KEY);
  if (row) { try { return JSON.parse(row.value); } catch { /* Recover a corrupt old setting with source defaults. */ } }
  return Object.fromEntries(template.slotBars.map(bar => [bar.slotBarId, Object.fromEntries(bar.slots.map(slot => [slot.slotId, slot.menuItemId]))]));
}
function apply(playerId, command, db = open()) {
  const slots = load(playerId, db);
  for (const [id, values] of Object.entries(slots)) {
    if (!IDS.has(id)) continue;
    let bar = command.slotBars.find(bar => bar.slotBarId === id);
    if (!bar) {
      bar = { ...structuredClone(template.slotBars[0]), slotBarId: id, slots: [], slotBarPosition: id === 'premiumSlotBar' ? '50, 86|0,39' : '50, 79|0,39' };
      command.slotBars.push(bar);
    }
    bar.slots = Object.entries(values).filter(([slot, item]) => Number(slot) >= 1 && Number(slot) <= 10 && items.has(item))
      .map(([slotId, menuItemId]) => ({ _: 'SlotInfoCommand', slotId: Number(slotId), menuItemId })).sort((a, b) => a.slotId - b.slotId);
  }
  return command;
}
function move(playerId, request, db = open()) {
  const { slotBarIdFrom: from, slotIdFrom: source, slotBarIdTo: to, slotIdTo: target, menuItemId: item } = request;
  const valid = (bar, slot) => IDS.has(bar) && Number.isInteger(slot) && slot >= 1 && slot <= 10;
  if (!items.has(item) || (from && !valid(from, source)) || (to && !valid(to, target)) || (!from && !to)) return false;
  const slots = load(playerId, db);
  if (from && slots[from]?.[source] !== item) return false;
  if (from === to && source === target) return true;
  const previous = to && slots[to]?.[target];
  if (from) {
    if (previous) slots[from][source] = previous;
    else delete slots[from][source];
  }
  if (to) { slots[to] ||= {}; slots[to][target] = item; }
  db.prepare('INSERT INTO settings(player_id,key,value) VALUES(?,?,?) ON CONFLICT(player_id,key) DO UPDATE SET value=excluded.value').run(playerId, KEY, JSON.stringify(slots));
  return true;
}
module.exports = { apply, move, load, KEY };
