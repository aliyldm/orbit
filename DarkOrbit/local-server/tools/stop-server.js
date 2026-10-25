'use strict';
// Gracefully stop ONLY this project's already-running Node entry point.
// On Windows a forced process kill skips the save handlers. Node's own debugger
// activation lets us emit the registered SIGINT handler after verifying identity.
const assert = require('node:assert/strict');
const path = require('node:path');
const expected = path.resolve(__dirname, '../server.js');
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));
async function main() {
  const pid = Number(process.argv[2]);
  if (!Number.isInteger(pid) || pid < 1 || pid === process.pid) throw new Error('Usage: node tools/stop-server.js <PID> [--check]');
  process._debugProcess(pid);
  let targets;
  for (let n = 0; n < 20; n++) {
    try { targets = await (await fetch('http://127.0.0.1:9229/json/list', { signal: AbortSignal.timeout(500) })).json(); if (targets.length) break; } catch { /* Wait for debugger startup. */ }
    await delay(100);
  }
  const target = targets?.find(t => t.type === 'node');
  if (!target?.webSocketDebuggerUrl) throw new Error('Node debugger could not be reached; no stop requested.');
  const socket = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((resolve, reject) => { socket.onopen = resolve; socket.onerror = reject; });
  let serial = 0; const waiting = new Map();
  socket.onmessage = event => {
    const message = JSON.parse(event.data), waiter = waiting.get(message.id);
    if (waiter) { waiting.delete(message.id); clearTimeout(waiter.timer); message.error ? waiter.reject(new Error(message.error.message)) : waiter.resolve(message.result); }
  };
  function evaluate(expression) {
    return new Promise((resolve, reject) => {
      const id = ++serial, timer = setTimeout(() => { waiting.delete(id); reject(new Error('Debugger request timed out.')); }, 3000);
      waiting.set(id, { resolve, reject, timer });
      socket.send(JSON.stringify({ id, method: 'Runtime.evaluate', params: { expression, returnByValue: true } }));
    });
  }
  try {
    const response = await evaluate('JSON.stringify({pid:process.pid,cwd:process.cwd(),entry:process.argv[1],handlers:process.listenerCount("SIGINT")})');
    const identity = JSON.parse(response.result.value);
    assert.equal(identity.pid, pid, 'Debugger belongs to another process; refusing to stop.');
    assert.equal(path.resolve(identity.cwd, identity.entry).toLowerCase(), expected.toLowerCase(), 'Entry point is outside this project; refusing to stop.');
    assert.ok(identity.handlers > 0, 'No graceful SIGINT save handler; refusing a forced stop.');
    console.log(`Verified project server PID ${pid}: ${expected}`);
    if (process.argv.includes('--check')) return;
    await evaluate('process.emit("SIGINT")');
    console.log('Graceful save-and-shutdown handler requested.');
  } finally { socket.close(); }
}
if (require.main === module) main().catch(error => { console.error(error.message); process.exitCode = 1; });
