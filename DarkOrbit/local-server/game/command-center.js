'use strict';
// Only local announcements are activated. Captured BE_* / seasonal events must
// never advertise rewards or payment offers that this server cannot deliver.
const NEWS = Object.freeze([
  Object.freeze({ id: 'local_offers_v1', eventId: 900001, title: 'Özel Fırsatlar',
    text: 'Özel ürünler dükkânın Özel Fırsatlar bölümünde. Fiyatı ve paket içeriğini satın almadan önce inceleyebilirsin.',
    href: '/indexInternal.es?action=internalDock&tpl=internalDockOffers' }),
  Object.freeze({ id: 'local_pet_v1', eventId: 900002, title: 'P.E.T. donanımları',
    text: 'P.E.T. yakıtı ve modülleri P.E.T./Modüller bölümünde. Satın aldığın modülleri hangarda P.E.T. üzerine takabilirsin.',
    href: '/indexInternal.es?action=internalDock&tpl=internalDockPetGear' })
]);
const escape = value => String(value).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&apos;' })[c]);
function feed() {
  return '<?xml version="1.0" encoding="UTF-8"?><root>' + NEWS.map((n, i) =>
    `<layer name="${n.id}" prio="${i}" countdown="0" category="news"><config/><assignments>` +
    '<background assetID="breaking_news_newdawn2024.jpg"/>' +
    `<label text="${escape(n.title)}" position="half_headline" style="headline"/>` +
    `<label text="${escape(n.text)}" position="half_maintext_with_headline" style="default"/>` +
    '</assignments><actions><button style="defaultButton" text="bn_hh_button" position="default_button">' +
    `<onclick><link href="${escape(n.href)}"/></onclick></button></actions></layer>`).join('') + '</root>';
}
function events(now = Date.now()) {
  // Non-countdown, static notices remain available throughout a play session.
  return { _: 'EventUpdateCommand', timestamp: now, utcTimeOffset: 0,
    activeCommands: NEWS.map(n => ({ _: 'EventModule', type: 'BE_' + n.id, id: n.eventId, timeLeft: 31536000, lang: 'all' })) };
}
function valid(c) { return NEWS.some(n => n.id === c?.newsId && n.eventId === c?.eventId); }
function entries() { return NEWS.map(n => ({ newsId: n.id, eventId: n.eventId })); }
module.exports = { NEWS, feed, events, valid, entries };
