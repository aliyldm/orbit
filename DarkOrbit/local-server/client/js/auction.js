var scrollPane;

jQuery(document).ready(function() {
    scrollPane = jQuery('.auction_item_wrapper').jScrollPane(
        {showArrows: true}
    );
});

function updateScrollbars()
{
    var scrollAPI = scrollPane.data('jsp');
    scrollAPI.reinitialise();
}

// prerender must be activated for the elements tooltip
function updateToolTip(Elem, newValue)
{
    var qApi = Elem.qtip('api').updateContent(newValue);
}

var Auction = {
    auctionType: 'hour',
    subAuctionType: 'current',
    bidButton: null,
    buyButton: null,
    clickedOnce: false,
    hourHistoryLoaded: false,

    init: function()
    {
        Tools.Text.Initialize();
        Tools.Popup.Initialize();
        Tools.ErrorHandler.Initialize();

        this.checkForCaptcha();
        this.setButtons();
        this.checkForQuickBuy();
        this.checkForShipEquipEvent();
        this.setEvents();
        this.setMyBidHint();

        var self = this;
        counter_hour = window.setInterval(function() {self.setCounter('countdown_hour');}, 1000);
        counter_hour = window.setInterval(function() {self.setCounter('countdown_day');}, 1000);
        counter_hour = window.setInterval(function() {self.setCounter('countdown_week');}, 1000);

        if ('day' == requestedTab || 'week' == requestedTab) {
            this.switchToTab(requestedTab);
        }
    },

    checkForCaptcha: function()
    {
        if (true != showCaptcha) {
            return null;
        }

        jQuery('#captchaScriptContainer').replaceWith(reCaptcha);
        var captchaContent = jQuery('#captchaContainer').html();

        jQuery('#captchaContainer').remove();

        Tools.Popup.Presets.showErrorDialog (
            captchaContent, {
                textIdentifier  : 'messaging_reCaptcha_msg_button_send',
                callback        : Auction.sendCaptcha
            }, {
                textIdentifier  : 'messaging_reCaptcha_msg_button_cancel'
            }
        );
    },

    sendCaptcha: function()
    {
        jQuery('#captchaCheckForm').submit();
    },

    setButtons: function()
    {
        this.bidButton = jQuery('#auction_place_bid');
        this.buyButton = jQuery('#auction_instant_buy');
    },

    checkForQuickBuy: function()
    {
        if (true != mayEquip.showHint) {
            return false;
        }

        Tools.Popup.Presets.showSuccessDialog(mayEquip.msg, {
            textIdentifier  : 'btn_to_inventory'
        }, {
            textIdentifier  : 'btn_auto_equip',
            callback        : Auction.equipItem
        });
    },

    equipItem: function()
    {
        jQuery.ajax({
            type        : 'POST',
            url         : '/ajax/shop.php',
            dataType    : 'json',
            data        : {
                action          : 'equipItems',
                category        : mayEquip.category,
                itemId          : mayEquip.itemId,
                amount          : mayEquip.amount,
                level           : 1,
                selectedName    : ''
            },
            beforeSend  : function() {
                Tools.Popup.showLoadingDialog();
            },
            complete    : function() {
                Tools.Popup.hideLoadingDialog();
            }
        });
    },

    checkForShipEquipEvent: function()
    {
        if (true !== equipShip) {
            return false;
        }

        Tools.Popup.Presets.showQuestionDialog(
            shipEquipText,
            {
                textIdentifier: 'yes',
                callback        : function () {
                    Auction.equipShip();
                }
            },
            {
                textIdentifier: 'bettingGame_no',
                callback        : function () {
                    Auction.dontEquipShip();
                }
            }
        );
    },

    equipShip: function()
    {
        Tools.Popup.showLoadingDialog();

        jQuery.ajax({
            type: 'POST',
            url: '/ajax/dock.php',
            dataType: 'json',
            data: {'command': 'equipLastShip'},

            complete: function() {
                window.document.location.reload();
            }
        });
    },

    dontEquipShip: function()
    {
        jQuery.ajax({
            type: 'POST',
            url: '/ajax/dock.php',
            dataType: 'json',
            data: {'command': 'dontEquip'},

            complete: function() {}
        });
    },

    setEvents: function()
    {
        jQuery('.auction_tab_main').click(function () {
            var curTab = jQuery(this);

            if (curTab.hasClass('auction_tab_active')) {
                return null;
            }

            var newType = curTab.attr('id').replace('tab_', '');
            var reqTab = $('auction_display_' + Auction.subAuctionType + '_' + newType);
            if (reqTab !== null) {
                Auction.switchToTab(newType);
            }
            else {
                Auction.ajaxGetTab(newType, Auction.subAuctionType);
            }
        });

        jQuery('.auction_subtab').click(function() {
            var curTab = jQuery(this);

            if (curTab.hasClass('auction_subtab_active')) {
                return null;
            }
            var subId = curTab.attr('id').replace('auction_', '');
            var reqTab = $('auction_display_' + subId + '_' + Auction.auctionType);
            if (reqTab !== null) {
                Auction.switchToSubTab(subId);
            }
            else{
                Auction.ajaxGetTab(Auction.auctionType, subId);
            }
        });

        //jQuery('#auction_item_descr').bind('mouseover', function() {
        jQuery('#auction_item_descr').bind('click', function() {
            var descr = jQuery(this).html();

            if ('' == descr) {
                return false;
            }
            descr = "<div id='auctionDescrClose' onclick='jQuery(this).parent().hide()'></div>" + descr;
            jQuery('#auction_descr_ttip').html(descr);
            jQuery('#auction_descr_ttip').show();
        });
        //jQuery('#auction_item_descr').bind('mouseout', function() {
        jQuery('#auction_descr_ttip').bind('click', function() {
            jQuery('#auction_descr_ttip').html('');
            jQuery('#auction_descr_ttip').hide();
        });
    },

    ajaxGetTab: function (type, subType)
    {
        jQuery.ajax({
            type        : 'POST',
            url         : '/ajax/auction.php',
            dataType    : 'json',
            data        : {
                'command'          : 'getAuctionList',
                'category'        : type,
                'list'             : subType
            },
            success: function(response) {
                Auction.hourHistoryLoaded = true;
                jQuery('#auction_'+subType+'_container_'+type).html(response.code);
                if (type == Auction.auctionType)
                    Auction.switchToSubTab(subType);
                else
                    Auction.switchToTab(type);
            }
        });

    },

    switchToTab: function(auctionType)
    {
        jQuery('#auction_descr_ttip').hide();
        jQuery('.auction_tab_main').removeClass('auction_tab_active');
        jQuery('#tab_' + auctionType).addClass('auction_tab_active');

        this.setAuctionType(auctionType);
        AuctionFilter.filterItems('all');
        AuctionFilter.updateFilterGroups();
        AuctionFilter.resetHistoryFilter();

        jQuery('.auction_content_sub').hide();
        jQuery('#auction_content_' + auctionType).show();

        this.resetItemInfo();

        jQuery('.countdown_item').hide();
        jQuery('#countdown_' + auctionType).show();

        scrollPane = jQuery('.auction_item_wrapper').jScrollPane({showArrows: true});
        //updateScrollbars();
    },

    setAuctionType: function(auctionType)
    {
        this.auctionType = auctionType;
    },

    setAuctionSubType: function(subAuctionType)
    {
        this.subAuctionType = subAuctionType;
    },

    showItem: function(elem)
    {
        var itemId = jQuery(elem).attr('itemKey');

        var itemImage  = jQuery('#' + itemId + '_image').val();
        var itemDescr  = jQuery('#' + itemId + '_descr').val();
        var itemCuBid  = jQuery('#' + itemId + '_bid').val();
        var itemBuyPr  = jQuery('#' + itemId + '_buyPrice').val();
        var itemLootId = jQuery('#' + itemId + '_lootId').val();
        var itemInstant = jQuery('#' + itemId + '_instantBuy').val();

        var newBidPrice = parseInt(itemCuBid) + 10000;

        var idSplit = itemId.split(/_/);

        jQuery('#auction_descr_ttip').hide();
        jQuery('#auction_item_image').show();
        jQuery('#auction_item_image').attr('src', itemImage);
        jQuery('#auction_item_descr').html(itemDescr);
        jQuery('#auction_item_buy input[name="auctionType"]').val(idSplit[1]);
        jQuery('#auction_item_buy').show();
        jQuery('#auction_item_buy input[name="credits"]').val(newBidPrice);
        jQuery('#auction_item_buy input[name="instant"]').val(itemBuyPr);
        jQuery('#auction_item_buy input[name="lootId"]').val(itemLootId);
        jQuery('#auction_item_buy input[name="itemId"]').val(itemId);

        updateToolTip(
            this.buyButton, Tools.Text.get('auction_ttip_buy')
        );
        updateToolTip(
            this.bidButton, Tools.Text.get('auction_ttip_bid')
        );

        jQuery('#auction_instant_buy').removeClass('disabled');
        if (itemInstant != '1') {
            jQuery('#auction_instant_buy').addClass('disabled');
            updateToolTip(
                this.buyButton, Tools.Text.get('auction_ttip_buy_permitted')
            );
        }

        this.bidButton.removeClass('disabled');

        jQuery('tr.auctionItemRow').removeClass('auctionItemRow_highlight');
        jQuery(elem).addClass('auctionItemRow_highlight');
    },

    resetItemInfo: function()
    {
        jQuery('tr.auctionItemRow').removeClass('auctionItemRow_highlight');

        jQuery('#auction_item_image').hide();
        jQuery('#auction_item_image').attr('src', '');
        jQuery('#auction_item_descr').html('');
        jQuery('#auction_item_buy input[name="auctionType"]').val('hour');

        jQuery('#auction_item_buy input[name="credits"]').val(0);
        jQuery('#auction_item_buy input[name="instant"]').val(0);
        jQuery('#auction_item_buy input[name="lootId"]').val('');
        jQuery('#auction_item_buy input[name="itemId"]').val('');
        this.buyButton.addClass('disabled');
        this.bidButton.addClass('disabled');

        // both updates cause problems after a bit at the daily and weekly tab.
        //updateToolTip(this.buyButton, Tools.Text.get('auction_ttip_buy_disabled'));
        //updateToolTip(this.bidButton, Tools.Text.get('auction_ttip_bid_disabled'));
    },

    switchToSubTab: function(subId)
    {
        var tabId = 'auction_' + subId;
        var containerClass = 'auction_list_' + subId;

        jQuery('#auction_descr_ttip').hide();
        jQuery('.auction_subtab').removeClass('auction_subtab_active');
        jQuery('#' + tabId).addClass('auction_subtab_active');

        this.resetItemInfo();
        this.setAuctionSubType(subId);
        AuctionFilter.filterItems('all');

        jQuery('.auctionList').hide();
        jQuery('.' + containerClass).show();

        jQuery('#auction_content').removeClass('auction_deco_1');
        jQuery('#auction_content').removeClass('auction_deco_2');
        if ('history' == subId) {
            jQuery('#auction_content').addClass('auction_deco_2');
            jQuery('#auction_history_dropdown').show();
            jQuery('#auction_countdown').hide();
            jQuery('#auction_item_buy').hide();
            jQuery('#auction_item_info').hide();
        } else {
            jQuery('#auction_content').addClass('auction_deco_1');
            jQuery('#auction_history_dropdown').hide();
            jQuery('#auction_countdown').show();
            jQuery('#auction_item_buy').show();
            jQuery('#auction_item_info').show();
        }

        scrollPane = jQuery('.auction_item_wrapper').jScrollPane({showArrows: true});
        updateScrollbars();
    },

    setMyBidHint: function()
    {
        var bidCount = myBidCount.hour;
        if (0 < bidCount) {
            jQuery('#myBid_hintbox_hour').hide();
        }

        bidCount = myBidCount.day;
        if (0 < bidCount) {
            jQuery('#myBid_hintbox_day').hide();
        }

        bidCount = myBidCount.week;
        if (0 < bidCount) {
            jQuery('#myBid_hintbox_week').hide();
        }
    },

    instantBuy: function()
    {
        if (jQuery('#auction_instant_buy').hasClass('disabled')) {
            return null;
        }

        var itemId = jQuery('#auction_item_buy input[name="itemId"]').val();
        var itemName = jQuery('tr[itemKey="' + itemId + '"] .auction_item_name_col').html();
        var itemPrice = jQuery('#auction_item_buy input[name="instant"]').val();
        var confirmPlain = 'items_shop_buy_confirm_s';

        var rurl = '/indexInternal.es?action=internalAuction&subAction=buy';
        rurl += '&lootId=' + jQuery('#auction_item_buy input[name="lootId"]').val();
        rurl += '&reloadToken=' + reloadToken;

        var replacementCost   = {
                '%VALUE%'   : itemPrice
        };
        var priceString             = Tools.Text.getWithReplacements('pricetag_uridium_compact', replacementCost);

        var replacementDictionary   = {
            '%ITEMNAME%'    : itemName,
            '%ITEMPRICE%'   : priceString
        };
        var confirmationText        = Tools.Text.getWithReplacements(confirmPlain, replacementDictionary);

        Tools.Popup.Presets.showQuestionDialog(confirmationText, {
            callback    : function() {
                redirect(rurl);
            }
        });

    },

    checkForm: function()
    {
        if (this.bidButton.hasClass('disabled')) {
            return false;
        }

        if (true == this.clickedOnce) {
            return false;
        }

        this.clickedOnce = true;

        return true;
    },

    setCounter: function(target) {
        if('countdown_hour' == target) {
            counterHour.second--;
            if (counterHour.second<0) { counterHour.second=59; counterHour.minute--; }
            if (counterHour.minute<0) { counterHour.minute=59; counterHour.hour--; }
            var _s = ""+counterHour.second; if (_s.length == 1) _s = '0'+_s;
            var _m = ""+counterHour.minute; if (_m.length == 1) _m = '0'+_m;
            jQuery('#' + target).text(_m + ':' + _s);
        }

        if('countdown_day' == target) {
            counterDay.second--;
            if (counterDay.second<0) { counterDay.second=59; counterDay.minute--; }
            if (counterDay.minute<0) { counterDay.minute=59; counterDay.hour--; }
            if (counterDay.hour<0) { counterDay.hour=23; counterDay.day--; }
            var _s = ""+counterDay.second; if (_s.length == 1) _s = '0'+_s;
            var _m = ""+counterDay.minute; if (_m.length == 1) _m = '0'+_m;
            var _h = ""+counterDay.hour; if (_h.length == 1) _h = '0'+_h;
            jQuery('#' + target).text(_h + ':' + _m + ':' + _s);
        }
        if('countdown_week' == target) {
            counterWeek.second--;
            if (counterWeek.second<0) { counterWeek.second=59; counterWeek.minute--; }
            if (counterWeek.minute<0) { counterWeek.minute=59; counterWeek.hour--; }
            if (counterWeek.hour<0) { counterWeek.hour=59; counterWeek.day--; }
            if (counterWeek.day<0) { counterWeek.day=23; counterWeek.week--; }
            var _s = ""+counterWeek.second; if (_s.length == 1) _s = '0'+_s;
            var _m = ""+counterWeek.minute; if (_m.length == 1) _m = '0'+_m;
            var _h = ""+counterWeek.hour; if (_h.length == 1) _h = '0'+_h;
            var _d = ""+counterWeek.day; if (_d.length == 1) _d = '0'+_d;
            jQuery('#' + target).text(_d + ':' + _h + ':' + _m + ':' + _s);
        }
    }
};

var AuctionFilter = {
    init: function()
    {
        this.updateFilterGroups();
        this.makeClickable();
    },

    makeClickable: function()
    {
        jQuery('#auction_filter_selector').click(function() {
            AuctionFilter.toggleFilter();
        });

        jQuery('#auction_filter_selection .filter_item').click(function() {
            var groupItem = jQuery(this).attr('id').replace('filter_', '');

            jQuery('#auction_filter_selector').text(
                jQuery(this).text()
            );

            AuctionFilter.filterItems(groupItem);
            AuctionFilter.toggleFilter();
        });

        jQuery('#auction_history_selector').click(function() {
            AuctionFilter.toggleHistory();
        });

        jQuery('#auction_history_dropdown .filter_item').click(function () {
            var hisId = jQuery(this).attr('id');
            jQuery('#auction_history_selector').text(
                jQuery(this).text()
            );

            AuctionFilter.filterHistory(hisId);
            AuctionFilter.toggleHistory();
        });
    },

    toggleFilter: function()
    {
        var selBox = jQuery('#auction_filter_selection');

        if (selBox.hasClass('filter_up')) {
            selBox.slideUp();
            selBox.removeClass('filter_up');
        } else {
            selBox.slideDown(400);
            selBox.addClass('filter_up');
        }
    },

    toggleHistory: function()
    {
        var selBox = jQuery('#auction_history_selection_' + Auction.auctionType);
        if (selBox.hasClass('filter_up')) {
            selBox.slideUp();
            selBox.removeClass('filter_up');
        } else {
            selBox.slideDown(400);
            selBox.addClass('filter_up');
        }
        scrollPane = jQuery('.auction_item_wrapper').jScrollPane(
            {showArrows: true}
        );
        updateScrollbars();
    },

    hideOpenHistory: function()
    {
        jQuery('#auction_history_dropdown .filter_selection').hide().removeClass('filter_up');
    },

    updateFilterGroups: function()
    {
        if (!filterGroups[Auction.auctionType]) {
            return null;
        }

        var curFilters = filterGroups[Auction.auctionType];
        jQuery('#auction_filter_selection .filter_item').show();

        jQuery('#auction_filter_selection .filter_item').each(function() {
            var groupItem = jQuery(this).attr('id').replace('filter_', '');

            var keepItem = false;
            for (var i = 0; i < curFilters.length; i++) {
                if (
                    curFilters[i] == groupItem ||
                    'all' == groupItem
                ) {
                    keepItem = true;
                }
            }

            if (false === keepItem) {
                jQuery(this).hide();
            }
        });
    },

    filterItems: function(filterGroup)
    {
        jQuery('.auctionItemRow').show();

        if ('all' != filterGroup) {
            jQuery('.auctionItemRow').each(function() {
                var itemGroup = jQuery(this).attr('itemGroup');

                if (filterGroup != itemGroup) {
                    jQuery(this).hide();
                }
            });
        } else {
            jQuery('#auction_filter_selector').text(
                Tools.Text.get('auction_filter')
            );
        }

        updateScrollbars();
    },

    filterHistory: function(hisId)
    {
        jQuery('#auction_content_' + Auction.auctionType + ' .auction_history_wrapper').hide();
        jQuery('#auction_' + hisId).show();

        updateScrollbars();
    },

    resetHistoryFilter: function()
    {
        this.hideOpenHistory();

        jQuery('#auction_history_selector').text(
            Tools.Text.get('auction_filter_history')
        );

        updateScrollbars();
    }
};

var AuctionMessages = {
    init: function() {
        jQuery('#auction_mail_receive').click(function() {
            AuctionMessages.toggleSelected();
        });

        //AuctionMessages.getMessageReceiveState();
    },
    toggleSelected: function() {
        if (jQuery('#auction_mail_receive').hasClass('button-singleCheckbox-checked')){
            Tools.Popup.Presets.showQuestionDialog(Tools.Text.get('auction_disable_mail'), {
                callback: function() {
                    AuctionMessages.setMessageReceivedState('disable');
                    jQuery('#auction_mail_receive').removeClass('button-singleCheckbox-checked');
                }
            });

        } else {
            Tools.Popup.Presets.showQuestionDialog(Tools.Text.get('auction_enable_mail'), {
                callback: function() {
                    AuctionMessages.setMessageReceivedState('enable');
                    jQuery('#auction_mail_receive').addClass('button-singleCheckbox-checked');
                }
            });
        }
    },
    getMessageReceiveState: function() {
        jQuery.ajax({
            type: 'POST',
            url: '/ajax/auction.php',
            dataType: 'json',
            data: {'command': 'getState'},
            success: function(response) {
                if (response.result == 'OK') {
                    if (response.receiveMails != false) {
                        jQuery('#auction_mail_receive').addClass('button-singleCheckbox-checked');
                    } else {
                        jQuery('#auction_mail_receive').removeClass('button-singleCheckbox-checked');
                    }
                } else {
                    //DoMessaging.getInstance().systemError();
                }
            },
            error: function(){}//'' //DoMessaging.getInstance().systemError
        });
    },
    setMessageReceivedState: function(newState) {
        jQuery.ajax({
            type: 'POST',
            url: '/ajax/auction.php',
            dataType: 'json',
            data: {'command': 'setState', 'state': newState},
            success: function(response) {
                if (response.result == 'OK') {
                    if (response.receiveMails != false) {
                        jQuery('#auction_mail_receive').addClass('button-singleCheckbox-checked');
                    } else {
                        jQuery('#auction_mail_receive').removeClass('button-singleCheckbox-checked');
                    }
                } else {
                    //DoMessaging.getInstance().systemError();
                }
            },
            error: function(){}//'' //DoMessaging.getInstance().systemError
        });

    }
};

jQuery(document).ready(function () {
    Auction.init();
    AuctionFilter.init();
    AuctionMessages.init();

    jQuery('#auction_uri').qtip({
        content: header_ttips.uri,
        style: 'dohdr',
        position: {target: 'mouse'}
    });
    jQuery('#auction_crd').qtip({
        content: header_ttips.cdt,
        style: 'dohdr',
        position: {target: 'mouse'}
    });

    Auction.bidButton.qtip({
        content: {
            text: Tools.Text.get('auction_ttip_bid_disabled'),
            prerender: true
        },
        style:'dohdr',
        position:{
            target:'mouse'
        }
    });
    Auction.buyButton.qtip({
        content: {
            text: Tools.Text.get('auction_ttip_buy_disabled'),
            prerender: true
        },
        style:'dohdr',
        position:{
            target:'mouse'
        }
    });
});
