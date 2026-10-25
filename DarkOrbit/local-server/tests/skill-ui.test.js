'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');

function client() {
  const elements = new Map(); let request, finished = 0, errors = 0;
  const jq = id => {
    if (!elements.has(id)) elements.set(id, { value: null,
      html(value) { this.value = value; return this; }, empty() { this.value = ''; return this; }, css() { return this; } });
    return elements.get(id);
  };
  jq.ajax = options => { request = options; };
  const context = vm.createContext({ jQuery: jq,
    Tools: { Text: { get: () => '' }, Popup: { Presets: { showErrorDialog() { errors++; }, showSuccessDialog() {} } } },
    pilotSheet: { updateSkillHasFinished() { finished++; }, ajaxLoader() {} }, tooltip: { init() {} } });
  vm.runInContext(fs.readFileSync(path.join(__dirname, '../client/resources/js/main.js'), 'utf8'), context);
  return { main: context.Main, elements, request: () => request, finished: () => finished, errors: () => errors };
}
test('skill purchase refreshes teasers without an undeclared browser global', () => {
  const ui = client(); ui.main.skillTreePurchaseLevelUp('22b');
  ui.request().success({ result: 'OK', researchPoints_teaser_text: '', researchPoints_teaser_image: '' });
  assert.equal(ui.finished(), 1);
  assert.equal(ui.elements.get('#researchPoints_teaser_text').value, '');
});
test('failed skill purchases unlock the tree for retry, including HTTP failure', () => {
  const ui = client(); ui.main.skillTreePurchaseLevelUp('22b');
  ui.request().success({ result: 'error', message: 'Seprom yetersiz' });
  ui.request().error();
  assert.equal(ui.finished(), 2); assert.equal(ui.errors(), 2);
});
test('reset updates the actual teaser image container', () => {
  const ui = client(); ui.main.resetSkillTree();
  ui.request().success({ result: 'OK', researchPoints_teaser_text: 'text', researchPoints_teaser_image: '<img>' });
  assert.equal(ui.elements.get('#researchPoints_teaser_image').value, '<img>');
});
