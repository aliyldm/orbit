'use strict';
// Flash Player, bir TCP soketi açmadan önce <policy-file-request/> gönderir
// (önce 843'e, sonra hedef porta). Bu modül cevabı üretir ve 843'ü dinler.

const net = require('net');

const POLICY_REQUEST = '<policy-file-request/>';

function policyXml(config) {
  return '<?xml version="1.0"?><cross-domain-policy>' +
    `<allow-access-from domain="*" to-ports="${config.game.port}" />` +
    '</cross-domain-policy>\0';
}

function isPolicyRequest(buf) {
  return buf.length >= POLICY_REQUEST.length && buf.toString('latin1', 0, POLICY_REQUEST.length) === POLICY_REQUEST;
}

function start(config) {
  if (!config.policy.enabled) return;
  const server = net.createServer(sock => {
    sock.once('data', buf => {
      if (isPolicyRequest(buf)) {
        console.log('[policy] 843 policy isteği cevaplandı');
        sock.end(policyXml(config));
      } else {
        sock.destroy();
      }
    });
    sock.on('error', () => {});
  });
  server.on('error', err => console.warn(`[policy] ${config.policy.port} açılamadı: ${err.message} (oyun portundaki policy cevabı yine çalışır)`));
  server.listen(config.policy.port, config.game.host, () => console.log(`[policy] ${config.game.host}:${config.policy.port} dinleniyor`));
  return server;
}

module.exports = { start, isPolicyRequest, policyXml };
