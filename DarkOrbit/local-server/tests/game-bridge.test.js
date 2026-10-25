'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
function bridge(mode, nextMode) {
  let reloaded = 0, closed = 0;
  const location = { reload() { reloaded++; }, href: '/game' };
  const window = { location, close() { closed++; }, closed: false };
  const context = vm.createContext({ window, fetch: async () => ({ json: async () => ({ display2d: nextMode }) }) });
  const html = fs.readFileSync(path.join(__dirname, '../web/public/game.html'), 'utf8').replaceAll('{displayMode}', String(mode));
  const source = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m => m[1]).join('\n');
  vm.runInContext(source, context);
  return { window, reloaded: () => reloaded, closed: () => closed };
}
test('the Flash bpCloseWindow bridge reloads on a saved 3D-to-2D or 2D-to-3D change', async () => {
  for (const [from, to] of [[1, 2], [2, 1]]) {
    const ui = bridge(from, to); await ui.window.bpCloseWindow();
    assert.equal(ui.reloaded(), 1); assert.equal(ui.closed(), 0);
  }
});
test('ordinary game logout closes the game window or returns it to the portal', async () => {
  const ui = bridge(2, 2); await ui.window.bpCloseWindow();
  assert.equal(ui.reloaded(), 0); assert.equal(ui.closed(), 1);
  assert.equal(ui.window.location.href, '/indexInternal.es?action=internalStart');
});
