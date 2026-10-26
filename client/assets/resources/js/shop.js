/**
 * JavaScript for DarkOrbit shop
 */

var Shop = {
    Attributes : {
        // URL that takes care of AJAX calls
        ajaxUrl             : '/ajax/shop.php',
        // List of Shop Selectors available
        selectorsAvailable  : ['AmountSelector', 'NameSelector', 'LevelSelector']
    },

    saleTimerArray: [],
    activeCounter: '',
    saleTimerInitiated: false,

    /**
     * Constructor
     */
    Initialize : function () {
        // Initialize Tools library
        Tools.Text.Initialize();
        Tools.Popup.Initialize();
        Tools.ErrorHandler.Initialize();

        // Initialize User object
        User.Initialize();

        // initialize pet
        User.Pet.hasPet = User.Parameters.pet.hasPet;

        // Initialize Shop helper
        Shop.AmountSelector.Initialize();
        Shop.NameSelector.Initialize();
        Shop.LevelSelector.Initialize();

        // Startup of the shop itself
        Shop.fetchElements();        
        Shop.initializeEventListeners();
        Shop.Itemlist.Initialize();
        Shop.loadStartupItem();
        if (Shop.getNumItems() > 0) Shop.applyDronePrices();
    },

    /**
     * Fetch all objects the shop needs later on
     * in order to speed up the application.
     */
    fetchElements : function () {
        var buyContainer    = jQuery('#buy_container'),
            info            = jQuery('#info'),
            btnBuy          = buyContainer.find('#buy_button'),
            btnSubscription = buyContainer.find('#subscription_button');

        // check if there a special sale on this item, then activate counter and highligthing
        jQuery.each(Shop.getParameter('itemData'), function(lootId, data) {
            if ( 0 < data.saleRemainingTime ) {
                Shop.setSaleTimer(lootId, data.saleRemainingTime)
            }
        }),

        Library.set('previewContainer',         jQuery('#previewContainer'));
        Library.set('btnBuy',                   btnBuy);
        Library.set('btnBuyText',               btnBuy.find('#buy_button_text'))
        Library.set('btnSubscription',          btnSubscription);
        Library.set('btnSubscription_start',    btnSubscription.find('#start'));
        Library.set('btnSubscription_stop',     btnSubscription.find('#stop'));
        Library.set('sellPrice',                buyContainer.find('#sellPrice'));
        Library.set('buyContainer',             buyContainer);
        Library.set('itemName',                 buyContainer.find('#buy_itemName'));
        Library.set('amountContainer',          buyContainer.find('#buy_amount'));
        Library.set('itemDescription',          info.find('#scroll-content'));
        Library.set('btnGetNextHangar',         jQuery('.header_hangar_slot_getNext'));
        Library.set('discount',         jQuery('#discount'));
    },

    /**
     * Initialize all event listeners
     */
    initializeEventListeners : function () {
        var btnBuy          = Library.get('btnBuy'),
            btnSubscription = Library.get('btnSubscription');

        Tools.addDefaultMouseEventBehaviour(btnBuy);
        Tools.addDefaultMouseEventBehaviour(btnSubscription);
        btnBuy.on('click',                            Shop.Events.onBtnBuyClick);
        btnSubscription.on('click',                   Shop.Events.onBtnSubscriptionClick);

        Library.get('btnGetNextHangar').on('click',   Shop.Events.onBtnGetNextHangarClick);

        Library.get('sellPrice').on('click',          Shop.Events.onSellPriceClick);

        // Setup tooltip for buy button
        this.setupBtnBuyTooltip();
    },

    /**
     * Sets up the tooltip for the buy button.
     */
    setupBtnBuyTooltip : function () {
        Library.get('btnBuy').qtip({
            content     : Tools.Text.get('shop_techfactory_long'),
            style       : 'dohdr',
            position    : {
                target  : 'mouse',
                adjust  : {
                    screen  : true
                }
            },
            api         : {
                beforeShow  : Shop.Events.beforeQtipShow
            }
        });
    },

    /**
     * Load the item that is supposed to be displayed first.
     */
    loadStartupItem : function () {
    	if(Shop.getParameter('numItems') == 0) {
    		jQuery('#item_container').remove();
    		jQuery('#preview_container').remove();
    		jQuery('#buy_container').remove();
    	} else {
        	var startupItemId = Shop.getStartupItemId();
        	// Scroll itemlist to this item
        	Shop.Itemlist.scrollToItem(startupItemId);
        	// Select the item
        	Shop.Itemlist.selectItem(startupItemId);
    	};
    },

    /**
     * Get the 'Shop.Parameters' object from DOM.
     */
    getParameters : function () {
        var parameters  = Shop.Parameters;

        if ('undefined' === typeof parameters) {
            Tools.ErrorHandler.Events.onGeneralError('Error: Shop parameters not found!');
        };

        return parameters;
    },

    /**
     * Get a certain parameter specified by the given parameterKey.
     */
    getParameter : function (parameterKey) {
        var parameters      = Shop.getParameters(),
            parameterValue  = parameters[parameterKey];

        if ('undefined' === typeof parameterValue) {
            Tools.ErrorHandler.Events.onGeneralError('Shop.getParameter: No parameter "' + parameterKey + '" found!');
        };

        return parameterValue;
    },

    /**
     * Getters for values from Shop.Parameter object.
     */
    getCategory : function () {
        return Shop.getParameter('category');
    },

    getPaymentLink : function () {
        return Shop.getParameter('paymentLink');
    },

    getNumItems : function () {
        return Shop.getParameter('numItems');
    },

    setNumItems : function (numItems) {
        Shop.Parameters.numItems = numItems;
    },

    getStartupItemId : function () {
        return Shop.getParameter('startupItemId');
    },

    getItemData : function () {
        return Shop.getParameter('itemData');
    },

    getMaxDroneAmount : function () {
        return Shop.getParameter('maxDroneAmount');
    },

    getLanguage : function () {
        return Shop.getParameter('language');
    },

    /**
     * Updates a single data field for the given itemId.
     */
    updateItemDataField : function (itemId, keyValuePair) {
        var key     = keyValuePair.key,
            value   = keyValuePair.value;

        if ('undefined' === typeof (Shop.Parameters.itemData[itemId])) {
            Tools.ErrorHandler.Events.onGeneralError('No data found for item ' + itemId + '.');
        } else {
            Shop.Parameters.itemData[itemId][key] = value;
        };
    },

    /**
     * Switches the text on the 'buy' button to 'Buy'.
     */
    showBuyButton : function () {
        var buttonTextIdentifier    = 'shop_buy',
            buttonTextUrl           = Shop.getTextImageUrl(buttonTextIdentifier);

        Library.get('btnBuyText').css('background-image', 'url(' + buttonTextUrl + ')');
    },

    /**
     * Switches the text on the 'buy' button to 'Tech Factory'.
     */
    showTechfactoryButton : function () {
        var buttonTextIdentifier    = 'shop_techfactory',
            buttonTextUrl           = Shop.getTextImageUrl(buttonTextIdentifier);

        Library.get('btnBuyText').css('background-image', 'url(' + buttonTextUrl + ')');
    },

    getTextImageUrl : function (textIdentifier, fontSize, fontColor, backgroundColor, font) {
        var fontSize            = ('undefined' === typeof fontSize) ? 14 : fontSize,
            fontColor           = ('undefined' === typeof fontColor) ? 'white' : fontColor,
            backgroundColor     = ('undefined' === typeof backgroundColor) ? 'grey' : backgroundColor,
            font                = ('undefined' === typeof font) ? 'eurostyle_thea' : font,
            language            = Shop.getLanguage(),
            parameters          = [
                'l='        + language,
                's='        + fontSize,
                't='        + textIdentifier,
                'f='        + font,
                'color='    + fontColor,
                'bgcolor='  + backgroundColor
            ],
            parametersAsString  = parameters.join('&'),
            url                 = '/do_img/global/text_tf.esg?' + parametersAsString;

        return url;
    },

    /**
     * Gets the itemData object for the given itemId.
     */
    getItemDataById : function (itemId) {
        return Shop.getItemData()[itemId];
    },

    /**
     * Redirects the user to the login page.
     */
    redirectToLogin : function () {
        Tools.Popup.showLoadingDialog();
        window.open('/indexInternal.es?action=externalLogout', '_self');
    },

    /**
     * Redirects the user to the tech factory page.
     */
    redirectToTechFactory : function () {
        Tools.Popup.showLoadingDialog();
        window.open('/indexInternal.es?action=internalNanoTechFactory', '_self');
    },

    /**
     * Redirects the user to the 'ship' category.
     */
    redirectToShipCategory : function () {
        Tools.Popup.showLoadingDialog();
        window.open('/indexInternal.es?action=internalDock&tpl=internalDockShips', '_self');
    },

    /**
     * Redirects the user to the hangar dock.
     */
    redirectToHangar : function () {
        Tools.Popup.showLoadingDialog();
        window.open('/indexInternal.es?action=internalDock', '_self');
    },

    quickEquipItem : function () {
        // equip items
        jQuery.ajax({
            type        : 'POST',
            url         : Shop.getAjaxUrl(),
            dataType    : 'json',
            data        : {
                action          : 'equipItems',
                category        : Shop.Item.getCategory(),
                itemId          : Shop.Item.getId(),
                amount          : Shop.AmountSelector.getBoughtAmount(),
                level           : Shop.Item.getSelectedLevel(),
                selectedName    : Shop.Item.getSelectedName()
            },
            beforeSend  : Shop.Events.onBeforeAjaxRequestSend,
            success     : Shop.Events.afterAjaxRequest,
            error       : Shop.Events.afterAjaxRequest
        });
    },

    /**
     * Reloads the Shop page.
     * Used e. g. if items are only available after purchase, in which case
     * we have to get all the items from server.
     */
    reloadPage : function () {
        // Show loading dialog
        Tools.Popup.showLoadingDialog();

        window.location = window.location;
    },

    /**
     * Returns the URL that AJAX calls are directed to.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
    */
    getAjaxUrl : function () {
        return Shop.Attributes.ajaxUrl;
    },

    getSelectorsAvailable : function () {
        return Shop.Attributes.selectorsAvailable;
    },

    /**
     * Sets up the Selectors the item currently selected uses.
     */
    setupSelectors : function () {
        var selectorsAvailable      = Shop.getSelectorsAvailable(),
            numSelectorsAvailable   = selectorsAvailable.length,
            selectorToShow,
            selector,
            i;

        if (Shop.Item.isAmountSetable()) {
            selectorToShow  = 'AmountSelector';
            jQuery.each(Shop.Item.getAmountsSelectable(), function(index, value) {
                jQuery('#' + value).show();
            });

        } else if (Shop.Item.isNameSetable()) {
            selectorToShow  = 'NameSelector';
        } else if (Shop.Item.isLevelSetable()) {
            selectorToShow  = 'LevelSelector';
        }

        for (i = 0; i < numSelectorsAvailable; i++) {
            selector = selectorsAvailable[i];

            if (selector === selectorToShow) {
                // This selector is the one the item uses; reset and show it.
                Shop[selector].resetSelector();
                Shop[selector].show();
            } else {
                // This selector is not used by the item; hide it.
                Shop[selector].hide();
            }
        }
    },

    /**
     * Sends the purchase request to the server.
     */
    processPurchase : function () {
        jQuery.ajax({
            type        : 'POST',
            url         : Shop.getAjaxUrl(),
            dataType    : 'json',
            data        : {
                action          : 'purchase',
                category        : Shop.Item.getCategory(),
                itemId          : /^\d+$/.test(String(Shop.Item.getId())) ? (Shop.Item.getImageData().loot_id || Shop.Item.getId()) : Shop.Item.getId(),
                amount          : Shop.Item.getSelectedAmount(),
                level           : Shop.Item.getSelectedLevel(),
                selectedName    : Shop.Item.getSelectedName()
            },
            beforeSend  : Shop.Events.onBeforeAjaxRequestSend,
            success     : Shop.Events.onPurchaseSuccess,
            error       : Shop.Events.onAjaxRequestError
        });
    },

    // Drone and booster templates share numeric row IDs. Keep those DOM IDs,
    // but identify products by the genuine loot ID and update account prices.
    applyDronePrices : function (states) {
        jQuery.each(Shop.getItemData(), function (rowId, item) {
            var lootId = item.imageVars && item.imageVars.loot_id;
            if (!/^drone_(flax|iris|apis|zeus)$/.test(lootId || '')) return;
            var state = states ? states[lootId] : item;
            if (!state) return;
            item.price = state.price;
            item.salePrice = state.price;
            item.notBuyable = !!state.notBuyable;
            item.cost = Tools.Text.getFormattedNumber(state.price) + (item.currency === 'virtual' ? ' C.' : ' U.');
            item.imageVars.price_plain = item.cost;
            Shop.Itemlist.updateItemCost(rowId, item.cost);
            if (String(Shop.Item.getId()) === String(rowId)) {
                Shop.Item.setPrice(state.price);
                Shop.Item.setSalePrice(state.price);
            }
        });
        Shop.sortItemsByPrice();
        Shop.updateBuyButton();
    },

    // Moving existing nodes preserves the original hover/click handlers. This
    // also keeps the order correct after the next Iris/Flax price changes.
    sortItemsByPrice : function () {
        var list = jQuery('#item_list');
        if (!list.length || !list.children) return;
        var rows = Shop.getItemData(), nodes = list.children('.item').get();
        function price(node) {
            var row = rows[jQuery(node).find('.itemList_singleItem a').attr('id')], value = row && Number(row.price);
            return row && isFinite(value) && value >= 0 ? value : Infinity;
        }
        function currency(node) {
            var row = rows[jQuery(node).find('.itemList_singleItem a').attr('id')];
            return row && row.currency === 'virtual' ? 0 : row && row.currency === 'real' ? 1 : 2;
        }
        var ordered = [];
        for (var index = 0; index < nodes.length; index++) ordered.push({node:nodes[index], index:index, currency:currency(nodes[index]), price:price(nodes[index])});
        ordered.sort(function(a,b){return a.currency-b.currency || a.price-b.price || a.index-b.index;});
        for (var i = 0; i < ordered.length; i++) list.append(ordered[i].node);
        Shop.Itemlist.Attributes.itemLinkIds = Shop.Itemlist.getItemLinkIdsFromDom();
        Shop.Itemlist.fetchItemLinkObjects();
    },

    /**
     * Sends the subscription request to the server.
     */
    toggleSubscription : function () {
        jQuery.ajax({
            type        : 'POST',
            url         : Shop.getAjaxUrl(),
            dataType    : 'json',
            data        : {
                action      : 'toggleSubscription',
                category    : Shop.getCategory(),
                itemId      : Shop.Item.getId()
            },
            beforeSend  : Shop.Events.onBeforeAjaxRequestSend,
            success     : Shop.Events.onToggleSubscriptionSuccess,
            error       : Shop.Events.onAjaxRequestError
        });
    },

    /**
     * Get the scrollpane we can inject content HTML into.
     */
    getScrollPane : function () {
        return Library.get('itemDescription');
    },

    /**
     * Opens a popup with the given paymentUrl.
     */
    openPaymentWindow : function (paymentUrl) {
        var url             = paymentUrl.replace(/\+/g,"%2B"),
            windowName      = 'paymentGlobal',
            specs           = "width=1000,height=535,left=100,top=200",
            paymentWindow   = window.open(url, windowName, specs);

        paymentWindow.focus();
    },

    /**
     * Updates the 'sellPrice' input field's value.
     */
    updateSellPriceInput : function (newValue) {
        Library.get('sellPrice').val(newValue);
    },

    /**
     * Checks wether to display the subscription button and automatically
     * hides/shows the button as well as the corresponding text container
     * within it.
     */
    toggleSubscriptionButtonVisiblity : function () {
        var subscriptionButton      = Library.get('btnSubscription');

        if (Shop.Item.canBeSubscribedTo()) {
            // Update the text on the subscription button.
            Shop.updateSubscriptionButtonText();

            subscriptionButton.show();
        } else {
            subscriptionButton.hide();
        };
    },

    updateSubscriptionButtonText : function () {
        var isSubscriptionRunning   = Shop.Item.isSubscriptionRunning(),
            textStart               = Library.get('btnSubscription_start'),
            textStop                = Library.get('btnSubscription_stop');

        // Determine which text (start/stop) to show.
        if (isSubscriptionRunning) {
            textStart.hide();
            textStop.show();
        } else {
            textStart.show();
            textStop.hide();
        }
    },

    /**
     * Removes the buyable drones from DOM and Shop.Itemlist.
     */
    removeBuyableDrones : function () {
        this.removeMultipleItemsById([1, 2]);
    },

    removeItemById : function (itemId) {
        this.removeMultipleItemsById([itemId]);
    },

    updateBuyButton : function (itemId) {
        var btn = jQuery('#buy_button');
        var localHint = jQuery('#local_shop_balance_hint');
        if (!localHint.length) {
            localHint = jQuery('<div id="local_shop_balance_hint" style="color:#ffb66a;font-size:11px;line-height:15px;margin-top:4px"></div>');
            btn.after(localHint);
        }
        var affordable = Shop.Item.isPaymentItem() || Shop.isUserBalanceSufficient();
        localHint.text(affordable ? '' : (Shop.Item.getCurrency() === 'virtual' ? 'Bu ürün için yeterli kredin yok.' : 'Bu ürün için yeterli uridyumun yok.'));

        var remaining = Shop.Item.getDailyLimitRemaining();
        if (Shop.Item.isOwned() || Shop.Item.notBuyable() ||
            (Shop.Item.isPetFuel() && Shop.AmountSelector.getMaxAmount() === 0) ||
            (Shop.Item.isAmountSetable() && remaining !== null && typeof remaining !== 'undefined' && Number(remaining) === 0)) {
            btn.addClass("inactive");
        } else {
            btn.removeClass("inactive");
        }
    },
    
    updateItemListDailyLimit : function (itemId, remaining, limitMax) {
        var el = jQuery('a#' + itemId).closest('.item').find('.daily-limit');

        if (el.length) {
            el.text('(' + remaining + '/' + limitMax + ')');
        }
    },

    /**
     * Removes multiple items from itemlist.
     */
    removeMultipleItemsById : function (itemIds) {
        var numItems            = Shop.getNumItems(),
            numItemsToRemove    = itemIds.length,
            itemIndex,
            itemId;

        for (itemIndex = 0; itemIndex < numItemsToRemove; itemIndex++) {
            itemId = itemIds[itemIndex];

            // Remove the item from list.
            Shop.Itemlist.removeItem(itemId);

            // Decrease number of overall items.
            numItems--;
        }

        // Set new number of items.
        Shop.setNumItems(numItems);

        // Select first item in list.
        Shop.Itemlist.Events.afterItemRemoval();
    	this.loadStartupItem();
    },

    /**
     * Checks wether the user's account balance is sufficient to buy the
     * item currently selected. Takes the user's dicount factor into account.
     */
    isUserBalanceSufficient : function () {
        if (Shop.Item.get('localPayment')) {
            return User.getBalanceByCurrencyType('real') >= Shop.Item.getPriceBySelectedAmount();
        }
        
        var currencyType    = Shop.Item.getCurrency(),
            balance         = User.getBalanceByCurrencyType(currencyType),            
            salePrice       = Shop.Item.getSalePrice(),
            discountFactor  = User.getDiscountFactor(),
            priceTotal      = Shop.Item.getPriceBySelectedAmount() * discountFactor,
            isBalanceSufficient = salePrice === null || salePrice > priceTotal ? balance >= priceTotal : balance >= salePrice;

        return isBalanceSufficient;
    },

    /**
     * Display a warning dialog box and informs the user that his active hangar is empty.
     */
    showActiveHangarEmptyWarning : function () {
        var message             = Tools.Text.get('active_hangar_empty'),
            additionalMessage,
            textIdentifier,
            callback;

        if (User.isShipDumpEmpty()) {
            additionalMessage   = Tools.Text.get('active_hangar_empty_buy');
            textIdentifier      = 'btn_to_shop';
            callback            = Shop.redirectToShipCategory;
        } else {
            additionalMessage   = Tools.Text.get('active_hangar_empty_equip');
            textIdentifier      = 'btn_to_hangar';
            callback            = Shop.redirectToHangar;
        }

        // Concat message
        message += '<br />' + additionalMessage;

        // Show warning dialog
        Tools.Popup.Presets.showErrorDialog(message, {}, {
            textIdentifier  : textIdentifier,
            callback        : callback
        });
    },

    checkSaleCounter : function (lootId) {
        this.deactivateSale();
        this.activeCounter = lootId;
    },

    setSaleTimer : function (lootId, seconds) {
        jQuery('#sale_' + lootId).show();
        this.saleTimerArray[lootId] = seconds;
        setInterval(function() {
                Shop.runSaleTimer(lootId)
            },
            1000
        );
    },

    runSaleTimer : function (lootId) {
        
        this.saleTimerArray[lootId] = this.saleTimerArray[lootId] - 1;
        
        if(this.saleTimerArray[lootId] > 0)
        {           
            jQuery('#' + lootId + ' div .sale_active').first().show();
        }
        else
        {
            jQuery('#' + lootId + ' div .sale_active').first().hide();
        }
        
        if (this.saleTimerArray[this.activeCounter] > 0) {
            this.updateSaleTimer(lootId, this.formateSaleTimer(this.saleTimerArray[Shop.activeCounter]));
           
            if (false === this.saleTimerInitiated) {
                this.activateSale(lootId, this.formateSaleTimer(this.saleTimerArray[Shop.activeCounter]));                
                this.saleTimerInitiated = true;
            }
        } else if (this.saleTimerArray[this.activeCounter] == 0) {
            this.deactivateSale(lootId);            
            window.location.reload();
        }
    },

    formateSaleTimer : function(seconds, lootId) {

        var _m = Math.floor(seconds / 60);
        var _s = seconds - (_m * 60);

        if (_m <= 0) _m = 0;
        if (_s <= 0) _s = 0;

        var __s = ""+_s; if (__s.length == 1) __s = '0'+__s;
        var __m = ""+_m; if (__m.length == 1) __m = '0'+__m;

        return __m + ':' + __s;
    },

    updateSaleTimer: function(lootId, timeString)
    {
        jQuery('#sale_counter').html(timeString, lootId);
    },

    activateSale : function(lootId, timeString) {
        var price                   = Tools.Text.getFormattedNumber(Shop.Item.getSalePrice()),
            currency                = Shop.Item.getCurrency(),
            currencyTextIdentifier  = ('virtual' === currency) ? 'pricetag_credits_compact' : 'pricetag_uridium_compact',
            replacementDictionary   = {
                '%VALUE%'   : price
            },
            salePriceAsText         = Tools.Text.getWithReplacements(currencyTextIdentifier, replacementDictionary);

        jQuery('#sale_counter').html(timeString, lootId);
        jQuery('#sale_' + lootId).show();
        jQuery('#sale_counter').show();
        jQuery('#sale_overlay_itemView').show();        

        jQuery('#sale_newPrice').html(salePriceAsText).show();
        jQuery('#sale_priceStrikeOut').show();
    },

    deactivateSale : function(lootId) {
        if ('undefined' !== typeof lootId) {
            jQuery('#sale_' + lootId).hide();
        }
        jQuery('#sale_newPrice').hide();
        jQuery('#sale_priceStrikeOut').hide();
        jQuery('#sale_counter').hide();
        jQuery('#sale_overlay_itemView').hide();
        jQuery('#sale_counter').html();
    },

    Events : {
        /**
         * Is called when the user clicks the '+' button to buy a new Hangar slot.
         */
        onBtnGetNextHangarClick : function (event) {
            var hangarSlotLootId    = 'hangar_slot';

            if ('ship' === Shop.getCategory()) {
                /**
                 * If the user is in the Shop 'ship' category already only
                 * select the Hangar slot.
                 */
                // Scroll list to row
                Shop.Itemlist.scrollToItem(hangarSlotLootId);

                // Select the item
                Shop.Itemlist.selectItem(hangarSlotLootId);

                // Do not follow the link.
                event.preventDefault();
            }
        },

        /**
         * Is called when the user clicks on the 'buy' button.
         * Opens a confirmation popup.
         */
        onBtnBuyClick : function (event) {
            if (Library.get("btnBuy").hasClass('inactive')) {
                return false;
            }

            var isPaymentItem           = Shop.Item.isPaymentItem(),
                isTechFactoryDrone      = Shop.Item.isTechFactoryDrone(),
                paymentUrl              = Shop.Item.getPaymentUrl(),
                amount                  = Shop.Item.getSelectedAmount(),
                itemName                = (Shop.Item.isLevelSetable()) ? Shop.Item.getNameWithLevel() : Shop.Item.getName(),
                textResourceKey         = (1 < amount) ? 'items_shop_buy_confirm_p' : 'items_shop_buy_confirm_s',
                replacementDictionary   = {
                    '%ITEMNAME%'    : itemName,
                    '%ITEMPRICE%'   : Shop.Item.getPriceAsText(),
                    '%AMOUNT%'      : Shop.Item.getSelectedAmount()
                },
                confirmationText        = Tools.Text.getWithReplacements(textResourceKey, replacementDictionary),
                isNameSetable           = Shop.Item.isNameSetable(),
                isValidName             = Shop.NameSelector.isValidName(),
                userBalanceIsSufficient = Shop.isUserBalanceSufficient(),
                balanceMsg,
                balanceMsgIdentifier    = ('virtual' === Shop.Item.getCurrency()) ? 'tf_message_not_enough_credits' : 'tf_message_not_enough_uridium',
                balanceMsgUridiumHint   = 'hint_go_to_payment',
                isAmountSetable         = Shop.Item.isAmountSetable(),
                isValidAmount           = Shop.Item.isValidAmount(),
                msgIdentifier,
                msg,
                levelMsgIdentifier      = 'pet_gear_requirement',
                levelMsg;

            if (User.isActiveHangarEmpty() && Shop.Item.requiresShipInActiveHangar()) {
                Shop.showActiveHangarEmptyWarning();
            } else if (Shop.Item.isLevelSetable() && !Shop.Item.isValidLevelSelected()) {
                levelMsg    = Tools.Text.getWithReplacements(levelMsgIdentifier, {
                    '%level%'   : Shop.Item.getPetLevelRequired()
                });

                Tools.Popup.Presets.showErrorDialog(levelMsg);
            } else if (isTechFactoryDrone) {
                // Show loading dialog
                Tools.Popup.showLoadingDialog();

                // Redirect to tech factory.
                Shop.redirectToTechFactory();
            } else if (isPaymentItem) {
                Shop.openPaymentWindow(paymentUrl);
            } else if (!userBalanceIsSufficient) {
                /**
                 * The user's balance is insufficient; show warning dialog.
                 */
                balanceMsg = Tools.Text.get(balanceMsgIdentifier);
                if ('real' === Shop.Item.getCurrency()) {
                    balanceMsg += '<br><br><a href="';
                    balanceMsg += Shop.getParameter('paymentLink') + '">' + Tools.Text.get(balanceMsgUridiumHint);
                    balanceMsg+ '</a>';
                }
                Tools.Popup.Presets.showErrorDialog(balanceMsg);
            } else if (isAmountSetable && !isValidAmount) {
                /**
                 * The user's ship does not have the necessary amount of space
                 * available.
                 */
                // Get text identifier
                if (Shop.Item.isBattery()) {
                    msgIdentifier   = 'buy_toManyBATTERY';
                } else if (Shop.Item.isRocket()) {
                    msgIdentifier   = 'buy_toManyROCKET';
                } else if (Shop.Item.isPetFuel()) {
                    msgIdentifier   = 'buy_pet_invalidFuelAmount';
                }

                msg = Tools.Text.get(msgIdentifier);
                Tools.Popup.Presets.showErrorDialog(msg);
            } else if (isNameSetable && !isValidName) {
                // Display error message if the selected name for this item
                // does not meet the requirements.
                Shop.NameSelector.displayWarningPopup();
            } else {
                Tools.Popup.Presets.showQuestionDialog(confirmationText, {
                    callback    : Shop.Events.onBuyConfirm
                });
            };
        },

        /**
         * Callback for when the user confirms the purchase.
         */
        onBuyConfirm : function (event) {
            // User confirmed buying; submit form.
            Shop.processPurchase();
        },

        /**
         * Is called after a 'purchase request' when the server
         * has processed the request.
         */
        onPurchaseSuccess : function (data, textStatus, jqXHR) {
            var popupCloseCallback;

            // Price and balance must both be current when refreshing the button.
            if ('undefined' !== typeof data.userBalance) User.setBalance(data.userBalance);

            if ('error' === data.result) {
                Tools.Popup.Presets.showErrorDialog(data.message);
            } else if ('success' === data.result){
                if ('undefined' !== typeof data.userShip) {
                    // Set new ship parameters
                    User.Ship.updateParameters(data.userShip);
                };

                if ('undefined' !== typeof data.userPet) {
                    // Set new PET parameters
                    User.Pet.updateParameters(data.userPet);
                    User.Pet.hasPet = true;
                } else if ('undefined' !== typeof data.petFuel) {
                    // The normal fuel purchase response contains the updated depot.
                    User.Pet.setFuel(data.petFuel);
                    User.Pet.hasPet = true;
                }
                if (User.Pet.hasPet && Shop.Parameters.itemData['resource_pet-fuel']) {
                    Shop.Parameters.itemData['resource_pet-fuel'].notBuyable = false;
                    Shop.Parameters.itemData['resource_pet-fuel'].isBuyable = true;
                }

                if ('undefined' !== typeof data.removeBuyableDrones && true === data.removeBuyableDrones) {
                    Shop.removeBuyableDrones();
                }
                
                if ('undefined' !== typeof data.removeItem && true === data.removeItem) {
                    Shop.removeItemById(data.itemId);
                }
                
                // Remove Hangar slot item.
                if ('undefined' !== typeof data.removeHangarSlot && true === data.removeHangarSlot) {
                    Shop.removeItemById('hangar_slot');
                }

                if ('undefined' !== typeof data.updatedPrice) {
                    // Update the item's price
                    Shop.Item.setPrice(data.updatedPrice);

                    if ('undefined' !== typeof data.updatedPriceDiscounted) {
                        Shop.Item.setPrice(data.updatedPriceDiscounted, true);
                        Shop.Item.setSalePrice(data.updatedPriceDiscounted);
                    }
                };
                if ('undefined' !== typeof data.dronePrices) Shop.applyDronePrices(data.dronePrices);

                Shop.AmountSelector.setBoughtAmount(
                    Shop.AmountSelector.getSelectedAmount()
                );

                // Update daily remaining limit from server response
                if ('undefined' !== typeof data.updatedMaxAmount) {
                    Shop.Item.setMaxAmount(data.updatedMaxAmount);
                }
                if ('undefined' !== typeof data.dailyLimitRemaining) {
                    Shop.Item.setDailyLimitRemaining(data.dailyLimitRemaining);
                    // Update the (remaining/max) text in the item list
                    Shop.updateItemListDailyLimit(Shop.Item.getId(), data.dailyLimitRemaining, data.dailyLimitMax);
                }

                if (Shop.Item.isAmountSetable()) {
                    // Reset the AmountSelector.
                    Shop.AmountSelector.resetSelector();
                };

                // Refresh buy button state (may become inactive if daily limit exhausted)
                Shop.updateBuyButton();

                if (Shop.Item.isShip()) {
                    // display go to hangar button
                    Tools.Popup.Presets.showSuccessDialog(data.message, {
                        textIdentifier:'ok'
                    }, {
                        textIdentifier:'btn_to_hangar',
                        callback: Shop.redirectToHangar
                    });
                } else if (data.showEquipOption) {
                    Tools.Popup.Presets.showSuccessDialog(data.message, {
                        textIdentifier  : 'btn_to_inventory'
                    }, {
                        textIdentifier  : 'btn_auto_equip',
                        callback        : Shop.quickEquipItem
                    });
                } else {
                    // Show message without additional buttons
                    Tools.Popup.Presets.showSuccessDialog(data.message);
                };
            };

            // Process callback, if there is one
            if ('undefined' !== typeof data.callback && 'function' === typeof Shop[data.callback]) {
                popupCloseCallback = Shop[data.callback];

                // Set callback for close button as well as green button
                // to forbid closing without executing the callback.
                Tools.Popup.setCloseButtonCallback(popupCloseCallback);
                Tools.Popup.setGreenButtonCallback(popupCloseCallback);
            };

            // Update user's balance if the request has the updated data.
            if ('undefined' !== typeof data.userBalance) {
                // Set new balance
                User.setBalance(data.userBalance);
            };

            // Update the information if the ship dump is empty (changes after ship purchase)
            if ('undefined' !== typeof data.isShipDumpEmpty) {
                User.setIsShipDumpEmpty(data.isShipDumpEmpty);
            };
        },

        /**
         * Is called when the user clicks on the 'subscription' button.
         * Opens a confirmation popup.
         */
        onBtnSubscriptionClick : function (event) {
            var isRunning   = Shop.Item.isSubscriptionRunning(),
                itemName    = Shop.Item.getName(),
                confirmationText;

            if (isRunning) {
                confirmationText = Tools.Text.getWithReplacements('items_booster_subscription_cancel_confirmation', {
                    '%BOOSTERNAME%'    : itemName
                });
            } else {
                confirmationText    = Tools.Text.getWithReplacements('items_shop_abo_confirm', {
                    '%itemName%'    : Shop.Item.getName()
                });
            };

            Tools.Popup.Presets.showQuestionDialog(confirmationText, {
                callback    : Shop.Events.onToggleSubscriptionConfirm
            });
        },

        /**
         * Callback for when the user confirms to toggle the subscription
         * status.
         */
        onToggleSubscriptionConfirm : function (event) {
            Shop.toggleSubscription();
        },

        /**
         * Is called after a 'subscription request' when the server
         * has processed the request.
         */
        onToggleSubscriptionSuccess : function (data, textStatus, jqXHR) {
            if ('error' === data.result) {
                Tools.Popup.Presets.showErrorDialog(data.message);
            } else if ('success' === data.result) {
                /**
                 * Now update the item's data if new data has been received
                 * from the server.
                 */
                if ('undefined' !== typeof data.isSubscriptionRunning) {
                    Shop.updateItemDataField(Shop.Item.getId(), {
                        key     : 'isSubscriptionRunning',
                        value   : data.isSubscriptionRunning
                    });
                };

                if ('undefined' !== typeof data.isSubscriptionPaused) {
                    Shop.updateItemDataField(Shop.Item.getId(), {
                        key     : 'isSubscriptionPaused',
                        value   : data.isSubscriptionPaused
                    });
                };

                if ('undefined' !== typeof data.userHasBoosterPackage) {
                    Shop.updateItemDataField(Shop.Item.getId(), {
                        key     : 'userHasBoosterPackage',
                        value   : data.userHasBoosterPackage
                    });
                };

                if ('undefined' !== typeof data.nextBooking) {
                    Shop.updateItemDataField(Shop.Item.getId(), {
                        key     : 'nextBooking',
                        value   : data.nextBooking
                    });
                };

                if ('undefined' !== typeof data.countdown) {
                    Shop.updateItemDataField(Shop.Item.getId(), {
                        key     : 'countdown',
                        value   : data.countdown
                    });
                };

                if ('undefined' !== typeof data.userBalance) {
                    // Update user's balance
                    User.setBalance(data.userBalance);
                };

                Shop.Item.updateDescription();

                Shop.updateSubscriptionButtonText();

                Tools.Popup.Presets.showSuccessDialog(data.message);
            };
        },

        /**
         * Is called before an AJAX request is sent to the server.
         * Opens the loading dialog.
         */
        onBeforeAjaxRequestSend : function (jqXHR, settings) {
            Tools.Popup.showLoadingDialog();
        },

        afterAjaxRequest: function() {
            Tools.Popup.hideLoadingDialog();

            Shop.AmountSelector.setBoughtAmount(1);
        },

        /**
         * Is called when an error occured during an AJAX request.
         */
        onAjaxRequestError : function (jqXHR, textStatus, errorThrown) {
            // Hide loading dialog
            Tools.Popup.hideLoadingDialog();

            Tools.ErrorHandler.Events.onAjaxRequestError(jqXHR, textStatus, errorThrown);
        },

        /**
         * Is called before the 'qTip' tooltip on buy button is being displayed.
         */
        beforeQtipShow : function (event) {
            // Only display tooltip for tech factory drones.
            return Shop.Item.isTechFactoryDrone();
        },

        /**
         * Is called when the user clicks on 'sellPrice' input field.
         * Instantly blurs the input field in order to simulate "disabled".
         */
        onSellPriceClick : function (event) {
            this.blur();
        }
    }
};
