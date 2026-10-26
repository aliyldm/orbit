// Launcher'ın enjekte ettiği "jshelper" betiği jQuery ($) bekliyor.
// Tamamen offline kalmak için yalnızca o betiğin kullandığı metotları sağlayan küçük bir shim.
(function () {
  function Q(nodes) { this.nodes = nodes; this.length = nodes.length; }
  Q.prototype.each = function (fn) { this.nodes.forEach(function (n, i) { fn.call(n, i, n); }); return this; };
  Q.prototype.on = function (events, fn) {
    var self = this;
    events.split(/\s+/).forEach(function (ev) { self.nodes.forEach(function (n) { n.addEventListener(ev, fn); }); });
    return this;
  };
  Q.prototype.bind = Q.prototype.on;
  ['blur', 'click', 'change', 'submit'].forEach(function (ev) {
    Q.prototype[ev] = function (fn) { return this.on(ev, fn); };
  });
  Q.prototype.val = function (v) {
    if (v === undefined) return this.nodes[0] ? this.nodes[0].value : undefined;
    this.nodes.forEach(function (n) { n.value = v; });
    return this;
  };
  Q.prototype.offset = function () {
    var n = this.nodes[0]; if (!n) return { top: 0, left: 0 };
    var r = n.getBoundingClientRect();
    return { top: r.top + window.scrollY, left: r.left + window.scrollX };
  };
  Q.prototype.width = function () { return this.nodes[0] ? this.nodes[0].clientWidth : 0; };

  window.$ = window.jQuery = function (sel) {
    if (typeof sel === 'string') return new Q(Array.prototype.slice.call(document.querySelectorAll(sel)));
    if (sel && sel.nodeType) return new Q([sel]);
    return new Q([]);
  };
})();
