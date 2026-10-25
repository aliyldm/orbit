'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const path = require('path');
const codec = require('../game/codec/codec');
const protocol = require('../game/protocol');

test('captured client/server packets preserve every byte', () => {
  const packets = JSON.parse(fs.readFileSync(path.join(__dirname, '../logs/session-6182-2.json')));
  assert.ok(packets.length > 10000);
  for (const packet of packets) {
    const raw = Buffer.from(packet.hex, 'hex');
    const { obj, rest } = codec.decode(raw);
    assert.equal(rest, 0, `packet ${packet.seq}`);
    assert.ok(codec.encode(obj).equals(raw), `packet ${packet.seq}: ${obj._}`);
  }
});

test('truncated fields, oversized frames and overlong strings are rejected', () => {
  assert.throws(() => codec.decode(Buffer.from([2, 154, 0, 8, 65])), /Truncated/);
  assert.throws(() => codec.encode({ _: 'VersionRequest', version: 'x'.repeat(65536) }), /too long/);
  const invalid = Buffer.alloc(4); invalid.writeUInt32BE(0x7fffffff);
  assert.throws(() => protocol.readFrame(invalid, {}), /uzunluğu/);
  assert.throws(() => protocol.readFrame(Buffer.alloc(4), {}), /uzunluğu/);
});

test('first and subsequent frames handle fragmentation and signed module IDs', () => {
  const body = codec.encode({ _: 'CommandCenterGetDontShowRequest' });
  const header = Buffer.alloc(4); header.writeUInt32BE(body.length);
  const full = Buffer.concat([header, body]);
  const session = {};
  assert.equal(protocol.readFrame(full.subarray(0, 3), session), null);
  const frame = protocol.readFrame(full, session);
  assert.equal(frame.packet.id, codec.schema.CommandCenterGetDontShowRequest.id);
  assert.equal(session.firstFrameRead, true);
  const next = protocol.writeFrame(2);
  assert.equal(protocol.readFrame(next, session).packet.id, 2);
});
