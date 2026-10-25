'use strict';
const assert=require('node:assert/strict'),proof=require('../../decompiled/multi-launcher-patch/evidence.json');
const sound=require('../../decompiled/laser-sound-cadence-patch/evidence.json');
// Every earlier patch test verifies that its final known artifact is exactly
// the input to the current compiled patch, before comparing the installed SWF.
exports.after=prior=>{assert.equal(proof.beforeSha256,prior);assert.equal(sound.beforeSha256,proof.afterSha256);const repeat=require('../../decompiled/repeatable-equipment-patch/evidence.json'),rhythm=require('../../decompiled/laser-rhythm-patch/evidence.json'),native=require('../../decompiled/native-laser-sound-patch/evidence.json'),visual=require('../../decompiled/native-laser-visuals-patch/evidence.json');assert.equal(repeat.beforeSha256,sound.afterSha256);assert.equal(rhythm.beforeSha256,repeat.afterSha256);assert.equal(native.beforeSha256,rhythm.afterSha256);assert.equal(visual.beforeSha256,native.afterSha256);const camera=require('../../decompiled/ship-motion-patch/evidence.json');assert.equal(camera.beforeSha256,visual.afterSha256);return camera.afterSha256;};
