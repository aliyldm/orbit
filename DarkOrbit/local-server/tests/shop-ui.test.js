'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const path = require('path');
const vm = require('vm');
function shop(data, balance = 100000) {
  const elements = new Map();
  const element = key => {
    if (!elements.has(key)) elements.set(key, { length: 1, classes: new Set(), value: '',
      val(v) { if (v !== undefined) this.value = v; return this; },
      addClass(k) { this.classes.add(k); return this; }, removeClass(k) { this.classes.delete(k); return this; },
      text(v) { this.value = v; return this; }, after() { return this; } });
    return elements.get(key);
  };
  const jq = key => element(key);
  jq.each = (object, fn) => Object.entries(object).forEach(([k, v]) => fn(k, v));
  const context = vm.createContext({ jQuery: jq, Library: { get: element },
    User: { getDiscountFactor: () => 1, getBalanceByCurrencyType: () => balance,
      Ship: { getLaserAmmunitionSpace: () => 1e9, getRocketSpace: () => 1e9 }, Pet: { hasPet: false } } });
  for (const file of ['shop.js', 'shop/item.js', 'shop/amountSelector.js'])
    vm.runInContext(fs.readFileSync(path.join(__dirname, '../client/resources/js', file), 'utf8'), context);
  const s = context.Shop;
  s.Parameters = { itemData: { product: data } };
  s.Item.setId('product'); s.Item.updatePrice = () => {};
  s.Item.isOwned = () => false; s.Item.notBuyable = () => false;
  return { s, elements };
}
const laser = { category: 'weapon', price: 10000, currency: 'virtual', maxAmount: 0, isAmountSetable: true,
  isConsumingCargoSpace: false, isActiveEventItem: false, isPaymentItem: false, isWeapon: true, salePrice: null };
test('legacy maxAmount0 permits affordable lasers rather than disabling all equipment', () => {
  const { s, elements } = shop(laser, 302800);
  s.AmountSelector.resetSelector(); s.updateBuyButton();
  assert.equal(s.AmountSelector.getMaxAmount(), 30);
  assert.equal(s.AmountSelector.getSelectedAmount(), 1);
  assert.equal(elements.get('#buy_button').classes.has('inactive'), false);
});
test('explicit exhausted daily limit remains enforced', () => {
  const { s, elements } = shop({ ...laser, dailyLimitRemaining: 0 });
  s.AmountSelector.resetSelector(); s.updateBuyButton();
  assert.equal(s.AmountSelector.getMaxAmount(), 0);
  assert.equal(elements.get('#buy_button').classes.has('inactive'), true);
});
test('unaffordable HST1 displays one full-price item and explains insufficient credits', () => {
  const { s, elements } = shop({ ...laser, price: 500000 }, 302800);
  s.AmountSelector.resetSelector(); s.updateBuyButton();
  assert.equal(s.AmountSelector.getSelectedAmount(), 1);
  assert.equal(s.isUserBalanceSufficient(), false);
  assert.match(elements.get('#local_shop_balance_hint').value, /yeterli kredin yok/);
});
