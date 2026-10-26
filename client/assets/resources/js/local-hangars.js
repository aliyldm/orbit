/* Native header hangar slots. The inventory SWF still receives its original
   zero-based ships-array index, never a purchased slot number or a renamed id. */
(function (window, $) {
    'use strict';
    if (!$ || !window.LocalHangarsState) return;
    var state = window.LocalHangarsState, busy = false, expanded = false, bridgeTimer = null;
    // Opening Hangar normally must leave the native ship browser on screen.
    // Only an explicit header-slot/assignment link requests its equipment view.
    var openEquipment = /(?:^|[?&])hangarSlot=\d+(?:&|$)/.test(window.location.search || '');
    function popup() { return window.Tools && window.Tools.Popup && window.Tools.Popup.library && window.Tools.Popup; }
    function message(text) { $('#local_hangar_message').text(text || ''); $('#local_hangar_panel').show(); }
    function fail(text) { var p = popup(); if (p) p.Presets.showErrorDialog(text); else message(text); }
    function request(action, values, done) {
        if (busy) return; busy = true;
        $.ajax({url: '/ajax/hangar.php', type: 'POST', dataType: 'json', headers: {'X-Requested-With': 'XMLHttpRequest'},
            data: $.extend({action: action}, values),
            success: function (response) {
                busy = false;
                if (response.result !== 'success') { fail(response.message || 'Hangar işlemi tamamlanamadı.'); return; }
                state = response.state; window.LocalHangarsState = state;
                if (done) done(response);
            },
            error: function () { busy = false; fail('Hangar isteği tamamlanamadı. Aynı isteği yeniden deneyebilirsin.'); }
        });
    }
    function dock() { window.location.href = '/indexInternal.es?action=internalDock&hangarSlot=' + state.selectedSlot; }
    function choose(slot) {
        if (Number(slot) === state.selectedSlot) { dock(); return; }
        request('select', {slot: slot}, dock);
    }
    function buy() {
        if (busy || !state.nextSlot) return;
        var slot = state.nextSlot, token = state.purchaseToken, p = popup();
        var text = 'Hangar ' + slot + ' için 250.000 Uridyum ödemek istiyor musun? Yeni hangar boş olarak açılır.';
        function confirmed() {
            if (p) p.hide();
            request('purchase', {slot: slot, requestId: token}, function () { window.location.reload(); });
        }
        if (p) p.Presets.showQuestionDialog(text, {callback: confirmed});
        else if (window.confirm(text)) confirmed();
    }
    function toggle() {
        expanded = !expanded;
        $('#header_hangar_slots').toggleClass('local_hangars_expanded', expanded);
        $('.header_hangar_slot').each(function () { $(this).toggle(expanded || $(this).hasClass('current_slot')); });
        $('.header_hangar_slot_getNext').toggle(expanded);
        $('#header_hangar_arrow').toggleClass('active_arrow', expanded);
        $('#local_hangar_panel').css('top',(expanded ? 46+$('#header_hangar_slots').outerHeight() : 46)+'px');
        $('#local_hangar_panel').toggle(expanded);
    }
    function movie() { return window.document.getElementById('inventory'); }
    function refreshActive() {
        $.ajax({url:'/ajax/hangar.php',type:'GET',dataType:'json',success:function (response) {
            if (response.result !== 'success') return;
            var s=response.state;
            $('#local_hangar_active').text('Aktif gemi: '+s.activeShipName+' ('+(s.activeSlot?'Hangar '+s.activeSlot:'hangara atanmamış')+')');
        }});
    }
    var selected = false;
    function flashReady() {
        if (!openEquipment) return;
        var swf = movie();
        if (!selected && state.selectedIndex >= 0 && swf && typeof swf.changeHangarSlot === 'function') {
            selected = true;
            try { swf.changeHangarSlot(state.selectedIndex); } catch (error) { selected = false; return; }
            if (bridgeTimer) window.clearInterval(bridgeTimer);
        }
    }
    var previousFlashReady = window.flashInitFinished;
    window.flashInitFinished = function () { if (typeof previousFlashReady === 'function') previousFlashReady(); flashReady(); };
    $(function () {
        // Captured Shop's old handler selects an absent `hangar_slot` row.
        if (window.Shop && window.Shop.Events) $('.header_hangar_slot_getNext').off('click', window.Shop.Events.onBtnGetNextHangarClick);
        $('.header_hangar_slot_getNext').on('click.localHangars', function (event) { event.preventDefault(); event.stopImmediatePropagation(); buy(); });
        $('.header_hangar_slot').on('click.localHangars', function (event) { event.preventDefault(); choose($(this).attr('data-hangar-slot')); });
        if (window.HeaderFunc) window.HeaderFunc.hangarSlotMachine = toggle;
        $('#local_hangar_assign').on('click', function () {
            var ship = $('#local_hangar_ship').val(); if (!ship) { message('Önce sahip olduğun bir gemi seç.'); return; }
            request('assign', {slot: state.selectedSlot, ship: ship}, dock);
        });
        $('#local_hangar_assign').prop('disabled', state.online);
        var slot = state.slots.filter(function (s) { return s.selected; })[0];
        if ($('#equipment_container').length) {
            // The native SWF releases this suspension flag after server actions,
            // including activation in its original ship browser. Refresh only
            // the active-ship label; the chosen header view remains distinct.
            var previousHangarBar = window.setHangarBarActive, refreshTimer;
            window.setHangarBarActive = function (active) {
                if (typeof previousHangarBar === 'function') previousHangarBar(active);
                if (active) { window.clearTimeout(refreshTimer); refreshTimer=window.setTimeout(refreshActive,200); }
            };
            if (openEquipment && !slot.shipId) { $('#equipment_container').hide(); $('#local_hangar_equipment').hide(); message('Bu hangar boş. Sahip olduğun bir gemiyi buraya atayabilirsin.'); }
            else if (openEquipment) {
                // isReady is a callback trigger, not a boolean-returning API.
                var attempts = 0;
                bridgeTimer = window.setInterval(function () {
                    var swf = movie(); if (swf && typeof swf.isReady === 'function') swf.isReady();
                    if (++attempts >= 60) window.clearInterval(bridgeTimer);
                }, 500);
            }
        }
        $('#local_hangar_title').on('click', function () { $('#local_hangar_panel').hide(); });
    });
    window.LocalHangars = {buy: buy, choose: choose, flashReady: flashReady, toggle: toggle};
})(window, window.jQuery);
