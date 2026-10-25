'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const auth = require('../game/auth');

test('web sessions only authenticate their own player and logout closes sockets', () => {
  const sid = auth.create(1, 7);
  let closed = 0;
  const connection = { close() { closed++; } };
  assert.equal(auth.verifyGame(sid, 7), true);
  assert.equal(auth.verifyGame(sid, 8), false);
  assert.equal(auth.verifyGame('wrong', 7), false);
  assert.equal(auth.bind(sid, connection), true);
  auth.destroy(sid);
  assert.equal(closed, 1);
  assert.equal(auth.verifyGame(sid, 7), false);
});

test('expired sessions and detached connections are cleaned up', () => {
  const sid = auth.create(1, 7);
  let closed = 0;
  const connection = { close() { closed++; } };
  auth.bind(sid, connection);
  auth.unbind(connection);
  auth.get(sid).expiresAt = 0;
  assert.equal(auth.get(sid), null);
  assert.equal(closed, 0);
});
