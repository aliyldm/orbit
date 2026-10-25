/**
 * Object to store and process item information.
 *
 * @author  Wolfgang Timme <w.timme@bigpoint.net>
 */
Shop.Item = {
    /**
     * 'Properties' are values that have been calculated.
     * Store them here so we don't have to re-calculate them.
     */
    Properties : {
        id          : null,
        priceAsText : '',
        eliteIconUrl : '/do_img/global/hangar/eliteicon.png',
        limitedIconUrl : '/do_img/global/hangar/limitedicon.png',
        serverExclusiveIconUrl : '/do_img/global/header/buttons/icon_server_exclusive.png'
    },

    getData : function () {
        var selectedItemId  = Shop.Item.getId(),
            itemData        = Shop.getItemDataById(selectedItemId);

        if ('undefined' === typeof itemData) {
            Tools.ErrorHandler.Events.onTypeUndefined('itemData');
        }

        return itemData;
    },

    get : function (key) {
        var itemData = Shop.Item.getData(),
            value;

        if ('undefined' === typeof key) {
            Tools.ErrorHandler.Events.onGeneralError('Shop.Item.get: No parameter "key" found!');
        }

        value = itemData[key];

        return value;
    },

    getId : function () {
        return Shop.Item.Properties.id;
    },

    setId : function (newId) {
        Shop.Item.Properties.id = newId;
    },

    getCategory : function () {
        var category = Shop.Item.get('category');

        // Warning for legacy data objects since 'category' is now mandatory
        if ('undefined' === typeof category) {
            alert('ATTENTION: No category set for item #' + Shop.Item.getId() + '!');
        }

        return category;
    },

    getName : function () {
        return Shop.Item.get('name');
    },
    
    getCode : function () {
        return Shop.Item.get('code');
    },

    /**
     * Gets the item name with the level appended, e. g.
     * "Schild-Management-Protokoll (Level: 1)".
     *
     * @param   void
     * @return  String
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getNameWithLevel : function () {
        var levelSelected       = Shop.LevelSelector.getSelectedLevel(),
            itemName            = Shop.Item.getName(),
            itemNameWithLevel   = Tools.Text.getWithReplacements('shop_itemNameWithLevel', {
                '%ITEMNAME%'    : itemName,
                '%LEVEL%'       : levelSelected
            });

        return itemNameWithLevel;
    },

    getNameShort : function () {
        return Shop.Item.get('nameShort');
    },

    /**
     * Appends ' (level: xy)' to the shortName of the item and returns
     * the resulting string.
     * Used as 'item_caption' in Flash for PetGear
     * for which the level can be set.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getNameShortForSelectedLevel : function () {
        var nameShort           = Shop.Item.getNameShort(),
            level               = Shop.LevelSelector.getSelectedLevel(),
            nameShortWithLevel  = nameShort + ' ' + level;

        return nameShortWithLevel;
    },

    getDescription : function () {
        return Shop.Item.get('description');
    },

    getPaymentUrl : function () {
        return Shop.Item.get('paymentUrl');
    },

    getImageData : function () {
        return Shop.Item.get('imageVars');
    },

    /**
     * Returns the Flashvars for the active item.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getFlashConfiguration : function () {
        var flashData   = Shop.Item.getFlashData(),
            variables   = flashData.variables;

        return variables;
    },

    getNameBackgroundImageUrl : function () {
        return Shop.Item.get('nameBackgroundImageUrl');
    },

    isAttributeTrue : function (attributeName) {
        return ('undefined' !== typeof Shop.Item.get(attributeName) && true === Shop.Item.get(attributeName));
    },

    setAttributeTrue : function (attributeName) {
        Shop.Item.set()
    },

    isPaymentItem : function () {
        return Shop.Item.isAttributeTrue('isPaymentItem');
    },

    getSaleRemainingTime : function () {
        return Shop.Item.get('saleRemainingTime');
    },

    isAmountSetable : function () {
        return Shop.Item.isAttributeTrue('isAmountSetable');
    },

    getAmountsSelectable : function() {
        return Shop.Item.get('amountsSelectable');
    },

    isActiveEventItem : function () {
        return Shop.Item.isAttributeTrue('isActiveEventItem');
    },

    canBeSubscribedTo : function () {
        return Shop.Item.isAttributeTrue('canBeSubscribedTo');
    },

    isSubscriptionRunning : function () {
        return Shop.Item.isAttributeTrue('isSubscriptionRunning');
    },

    isSubscriptionPaused : function () {
        return Shop.Item.isAttributeTrue('isSubscriptionPaused');
    },

    hasUserBoosterPackage : function () {
        return Shop.Item.isAttributeTrue('userHasBoosterPackage');
    },

    isShip : function () {
        return Shop.Item.isAttributeTrue('isShip');
    },

    isShipModel : function () {
        return Shop.Item.isAttributeTrue('isShipModel');
    },

    isOwned : function () {
        return Shop.Item.isAttributeTrue('isOwned');
    },

    notBuyable: function() {
        return Shop.Item.isAttributeTrue('notBuyable');
    },

    isTechFactoryDrone : function () {
        return Shop.Item.isAttributeTrue('isTechFactoryDrone');
    },

    isNameSetable : function () {
        return Shop.Item.isAttributeTrue('isNameSetable');
    },

    isPetFuel : function () {
        return Shop.Item.isAttributeTrue('isPetFuel');
    },

    isPetGear : function () {
        return Shop.Item.isAttributeTrue('isPetGear');
    },

    isPetGearLevel : function () {
        return Shop.Item.isAttributeTrue('isPetGearLevel');
    },

    isBattery : function () {
        return Shop.Item.isAttributeTrue('isBattery');
    },

    isRocket : function () {
        return Shop.Item.isAttributeTrue('isRocket');
    },

    isWeapon : function () {
        return Shop.Item.isAttributeTrue('isWeapon');
    },

    isHangar : function () {
        return Shop.Item.isAttributeTrue('isHangar');
    },

    isLevelSetable : function () {
        return Shop.Item.isAttributeTrue('isLevelSetable');
    },

    getMaxLevel : function () {
        return Shop.Item.get('maxLevel');
    },

    isConsumingCargoSpace : function () {
        return ('undefined' !== typeof Shop.Item.get('isConsumingCargoSpace') && true === Shop.Item.get('isConsumingCargoSpace'));
    },

    getWeight : function () {
        return ('undefined' === typeof Shop.Item.get('weight')) ? 1 : Shop.Item.get('weight');
    },

    getDiscount : function () {
        return ('undefined' === typeof Shop.Item.get('discountPercent')) ? 1 : Shop.Item.get('discountPercent');
    },

    /**
     * Returns the shopData for the selected level.
     */
    getShopDataForSelectedLevel : function () {
        var level               = Shop.LevelSelector.getSelectedLevel(),
            levelItemShopData   = Shop.Item.getLevelItemShopData(),
            shopData            = levelItemShopData[level];
        return shopData;
    },

    getCostForSelectedLevel : function () {
        var shopDataForSelectedLevel    = Shop.Item.getShopDataForSelectedLevel(),
            totalCostFormatted      = Tools.Text.getFormattedNumber(shopDataForSelectedLevel.price),
            currency                = Shop.Item.getCurrency(),
            currencyTextIdentifier  = ('virtual' === currency) ? 'pricetag_credits_compact' : 'pricetag_uridium_compact',
            replacementDictionary   = {
            '%VALUE%'   : totalCostFormatted
        },
        priceAsText             = Tools.Text.getWithReplacements(currencyTextIdentifier, replacementDictionary);

        return priceAsText;
    },

    getFullCostForSelectedLevel : function () {
        return Shop.Item.getShopDataForSelectedLevel().cost;
    },

    getMaxAmount : function () {
        return Shop.Item.get('maxAmount');
    },

    getMaxAmountByUserBalance : function () {
        var currencyType        = Shop.Item.getCurrency(),
            balance             = User.getBalanceByCurrencyType(currencyType),
            price               = Shop.Item.getPrice(),
            priceWithDiscount   = price * User.getDiscountFactor(),
            maxAmount           = Math.floor(balance / priceWithDiscount);

        return maxAmount;
    },

    getMaxAmountBySpaceAvailable : function () {
        var weight                  = Shop.Item.getWeight(),
            rocketSpaceAvailable    = User.Ship.getRocketSpace(),
            laserSpaceAvailable     = User.Ship.getLaserAmmunitionSpace(),
            space                   = (Shop.Item.isRocket()) ? rocketSpaceAvailable : laserSpaceAvailable,
            maxAmount               = Math.floor(space / weight);

        return maxAmount;
    },

    getCalculatedMaxAmount : function () {
        var maxAmountByUserBalance      = Shop.Item.getMaxAmountByUserBalance(),
            maxAmountBySpaceAvailable   = Shop.Item.getMaxAmountBySpaceAvailable(),
            isActiveEventItem           = Shop.Item.isActiveEventItem(),
            isConsumingCargoSpace       = Shop.Item.isConsumingCargoSpace(),
            isPetFuel                   = Shop.Item.isPetFuel(),
            petFuel,
            petMaxFuel,
            maxFuelToBuy,
            maxAmount;

        if (isActiveEventItem || !isConsumingCargoSpace || maxAmountByUserBalance < maxAmountBySpaceAvailable) {
            maxAmount   = maxAmountByUserBalance;
        } else {
            maxAmount   = maxAmountBySpaceAvailable;
        };

        if (isPetFuel && true === User.Pet.hasPet) {
            // PET fuel can only until the maxFuel amount has been reached.
            petFuel         = User.Pet.getFuel();
            petMaxFuel      = User.Pet.getMaxFuel();
            maxFuelToBuy    = petMaxFuel - petFuel;

            if (maxAmount > maxFuelToBuy) {
                maxAmount   = maxFuelToBuy;
            }
        } else if (isPetFuel && false === User.Pet.hasPet) {
            maxAmount = 0;
        }

        return maxAmount;
    },

    setMaxAmount : function (newMaxAmount) {
        Shop.updateItemDataField(Shop.Item.getId(), {
            key     : 'maxAmount',
            value   : newMaxAmount
        });
    },

    getDailyLimitRemaining : function () {
        return Shop.Item.get('dailyLimitRemaining');
    },

    getDailyLimitMax : function () {
        return Shop.Item.get('dailyLimitMax');
    },

    setDailyLimitRemaining : function (value) {
        Shop.updateItemDataField(Shop.Item.getId(), {
            key     : 'dailyLimitRemaining',
            value   : value
        });
    },

    getSelectedAmount : function () {
        return (Shop.Item.isAmountSetable()) ? Shop.AmountSelector.getSelectedAmount() : 1;
    },

    /**
     * Determines wether the given/selected amount is valid.
     *
     * @param   void
     * @return  boolean
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    isValidAmount : function (amount) {
        var selectedAmount  = ('undefined' !== typeof amount) ? amount : Shop.Item.getSelectedAmount(),
            maxAmount       = Shop.Item.getCalculatedMaxAmount();

        if (Shop.Item.isWeapon()) {
            // No space limitation for these items.
            return true;
        } else {
            return selectedAmount <= maxAmount;
        };
    },

    getPrice : function () {
        return (Shop.Item.isLevelSetable()) ? Shop.Item.getPriceForSelectedLevel() : Shop.Item.get('price');
    },

    getSelectedLevel : function () {
        return Shop.LevelSelector.getSelectedLevel();
    },

    isValidLevelSelected : function () {
        var petLevel            = User.Pet.getLevel(),
            petLevelRequired    = Shop.Item.getPetLevelRequired();

        return petLevel >= petLevelRequired;
    },

    /**
     * Determines the P.E.T. level that is required for the selected
     * petGear level (grade).
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getPetLevelRequired : function () {
        var selectedLevel       = Shop.Item.getSelectedLevel(),
            petLevelRequired;

        if (1 === selectedLevel) {
            petLevelRequired    = 0;
        } else if (2 === selectedLevel) {
            petLevelRequired    = 4;
        } else {
            petLevelRequired    = 8;
        }

        return petLevelRequired;
    },

    getPriceBySelectedAmount : function () {
        var selectedAmount          = Shop.Item.getSelectedAmount(),
            price                   = Shop.Item.getPrice(),
            priceBySelectedAmount   = selectedAmount * price;

        return priceBySelectedAmount;
    },

    getPriceForSelectedLevel : function () {
        var shopData    = Shop.Item.getShopDataForSelectedLevel(),
            price       = shopData.price;

        return price;
    },

    getCurrency : function () {
        return (Shop.Item.isLevelSetable()) ? Shop.Item.getCurrencyForSelectedLevel() : Shop.Item.get('currency');
    },

    getCurrencyForSelectedLevel : function () {
        var shopData    = Shop.Item.getShopDataForSelectedLevel(),
            currency    = shopData.currency;

        return currency;
    },

    getCountdown : function () {
        return 'undefined' !== typeof Shop.Item.get('countdown') ? Shop.Item.get('countdown') : '';
    },

    getNextBooking : function () {
        return 'undefined' !== typeof Shop.Item.get('nextBooking') ? Shop.Item.get('nextBooking') : '';
    },
    
    getSubscriptionText : function () {
        return 'undefined' !== typeof Shop.Item.get('subscriptionText') ? Shop.Item.get('subscriptionText') : '';
    },

    getSelectedName : function () {
        return Shop.Item.isNameSetable() ? Shop.NameSelector.getName() : '';
    },

    getLevelItemShopData : function () {
        return Shop.Item.get('levelItemShopData');
    },

    isOnlyForShow : function () {
        return Shop.Item.isAttributeTrue('isOnlyForShow');
    },

    getSaleRemainingTime : function () {
        return Shop.Item.get('saleRemainingTime');
    },

    getSalePrice : function () {
        return Shop.Item.get('salePrice');
    },

    setSalePrice : function (salePrice)  {
        Shop.updateItemDataField(Shop.Item.getId(), {
            key     : 'salePrice',
            value   : salePrice
        });
    },

    /**
     * Determines wether this item needs the active hangar not to be empty.
     *
     * @return  bool
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    requiresShipInActiveHangar : function () {
        return this.isAttributeTrue('requiresShipInActiveHangar');
    },

    getPriceAsText : function () {
    	var priceAsText = '';

    	if (!Shop.Item.isPetGear()) {
	        var amount    = (Shop.Item.isAmountSetable()) ? Shop.AmountSelector.getSelectedAmount() : 1,
	            totalCost = Math.round(amount * Shop.Item.getPrice() * 100) / 100;

	        priceAsText = Tools.Text.getWithReplacements(
	        	('virtual' === Shop.Item.getCurrency()) ? 'pricetag_credits_compact' : 'pricetag_uridium_compact',
	        	{
		            '%VALUE%' : Tools.Text.getFormattedNumber(totalCost)
		        }
	        );
    	}
        // The cost for pet gear level depends on the level selected
    	else {
            priceAsText = Shop.Item.getCostForSelectedLevel();
        }

        return priceAsText;
    },

    /**
     * Sets a new price and updates all necessary page elements.
     *
     * @param   float   the new price
     * @return  void
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    setPrice : function (newPrice, onlyFieldUpdate) {
        var itemId      = Shop.Item.getId(),
            priceAsText;

        // Update price in the item's data.
        Shop.updateItemDataField(itemId, {
            key     : 'price',
            value   : newPrice
        });

        // Update the sell price input field.
        Shop.Item.updatePrice();

        if (!onlyFieldUpdate) { // Update the cost displayed in the itemlist.
            priceAsText = Shop.Item.getPriceAsText();
            Shop.Itemlist.updateItemCost(itemId, priceAsText);

            // Update the cost displayed in the preview image.
            this.resizeText(priceAsText, 'previewPrice');
        }
    },

    /**
     * Updates the 'sellPrice' form field (below the amount/level chooser).
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updatePrice : function () {
        var priceAsText = (
            Shop.Item.isPaymentItem() || Shop.Item.isOwned() || Shop.Item.notBuyable()
        ) ? '' : Shop.Item.getPriceAsText();

        Shop.updateSellPriceInput(priceAsText);
    },

    /**
     * Updates the url of the 'name' background image.
     * The name is displayed above the amount/level chooser.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updateNameBackgroundImageUrl : function () {
        var nameContainer      = Library.get('itemName');

        nameContainer.html(Shop.Item.getCode());
    },

    updatePreviewImage : function (config) {
        var configs = Shop.Item.getImageData();

        this.resizeText(configs.item_name, 'previewName');
        this.resizeText(configs.item_caption, 'previewCaption');
        this.updateItemImage(configs.imageUrl);
        this.resizeText(configs.price_plain, 'previewPrice');
        this.updatePreviewIcon(configs);
        if(configs.item_prefix == 'booster') {
            this.updatePreviewBoosterIcon(configs.loot_id);
        }
    },

    updateItemImage : function (imageUrl) {
        jQuery('#previewImage').css("background-image", "url(" + imageUrl + ")");
    },

    updatePreviewIcon : function (iconConfig) {
        if (iconConfig.serverExclusive) {
            jQuery('#previewIcon').css("background-image", "url(" + Shop.Item.Properties.serverExclusiveIconUrl + ")");
        } else if (iconConfig.event_item_enabled) {
            jQuery('#previewIcon').css("background-image", "url(" + Shop.Item.Properties.limitedIconUrl + ")");
        } else if (iconConfig.elite) {
            jQuery('#previewIcon').css("background-image", "url(" + Shop.Item.Properties.eliteIconUrl + ")");
        } else {
            jQuery('#previewIcon').css("background-image", "none");
        }
    },

    updatePreviewBoosterIcon : function (lootId) {
        var path = 'do_img/global/items/' + lootId.split("_").join("/") + "_icon.png";
        jQuery('#previewBoosterIcon').css("background-image", "url(" + path + ")");
    },

    resizeText : function (content, divId) {
        var id = '#' + divId;
        jQuery(id).html('<span>' + content + '</span>');

        jQuery.getScript('/resources/js/tools/jquery.textfill.js', function() {
            jQuery(id).textfill({ maxFontPixels: 30 });
        });
    },

    /**
     * Updates the item's name above the description.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updateDiscount : function () {
        jQuery('#discount').html(Shop.Item.getDiscount());
        jQuery('#discount').show();
    },

    /**
     * Updates the item's name above the description.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    /*
    updateFullName : function (name) {
        var name            = 'undefined' === typeof name ? Shop.Item.getName() : name,
            nameContainer   = Library.get('itemFullName');

        if ('ship' === Shop.getCategory() && !this.isHangar()) {
            // Do not show name for ships.
            nameContainer.hide();
        } else {
            Library.get('itemFullName').html(name);
            nameContainer.show();
        }
    },
    */
    
    /**
     * Updates the item's name above the description.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updateDiscount : function () {
        jQuery('#discount').html(Shop.Item.getDiscount());
        jQuery('#discount').show();
    },

    /**
     * Updates the description below the Flash 'preview' movie.
     * Checks for running subscriptions and adds subscription information
     * to description.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updateDescription : function (description) {
        var description             = 'undefined' !== typeof description ? description : Shop.Item.getDescription(),
            userHasBoosterPackage   = Shop.Item.hasUserBoosterPackage(),
            isSubscriptionRunning   = Shop.Item.isSubscriptionRunning(),
            isSubscriptionPaused    = Shop.Item.isSubscriptionPaused(),
            nextBooking             = Shop.Item.getNextBooking(),
            countdown               = Shop.Item.getCountdown(),
            subscriptionText 		= Shop.Item.getSubscriptionText(),
            isOnlyForShow           = Shop.Item.isOnlyForShow(),
            subscriptionStatusText  = '';

        if (userHasBoosterPackage) {
            if (isSubscriptionRunning) {
                subscriptionStatusText  = subscriptionText;

                if (!isSubscriptionPaused) {
                    subscriptionStatusText  += '<br />' + nextBooking;
                }
            } else {
                subscriptionStatusText  = countdown;
            }

            description = subscriptionStatusText + '<br /><br />' + description;

        }

        Shop.getScrollPane().html(description);
    },

    /**
     * Updates the label of the subscription button (using CSS classes)
     * and automatically shows/hides the button when the item cannot be
     * subscribed to.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updateSubscriptionButton : function () {
        var btnSubscription = Library.get('btnSubscription'),
            runningClass    = 'running';

        if (Shop.Item.isSubscriptionRunning()) {
            btnSubscription.addClass(runningClass);
        } else {
            btnSubscription.removeClass(runningClass);
        }

        Shop.toggleSubscriptionButtonVisiblity();
    },

    checkBuyFunctionality : function () {

        if(Shop.Item.isOnlyForShow()) {
            //jQuery('#buy_button').css('display','none');
            Library.get('btnBuy').hide();
            jQuery('#buy_price').css('display','none');
        } else {
            //jQuery('#buy_button').css('display','block');
            Library.get('btnBuy').show();
            jQuery('#buy_price').css('display','block');
        }

        if (Shop.Item.isLevelSetable()) {
            Shop.Item.updateInfoForLevelItem();
        }

    },

    /**
     * Updates the info for the currently selected item.
     */
    updateInfo : function () {
        // Setup all selectors.
        Shop.setupSelectors();
        var selectedItemId  = Shop.Item.getId();

        if (Shop.Item.isLevelSetable()) {
            /**
             * Information for items the user can select the level for
             * is handled differently.
             */
            Shop.Item.updateInfoForLevelItem();
        } else {
            // Update preview movie
            Shop.Item.updatePreviewImage();

            // Update description
            Shop.Item.updateDescription();

            // Update fullname (above description)
            //Shop.Item.updateFullName();

            if (Shop.Item.isTechFactoryDrone()) {
                Shop.showTechfactoryButton();

                // Empty the sell price input field.
                Shop.updateSellPriceInput('');
            } else {
                Shop.showBuyButton();

                // Update price
                Shop.Item.updatePrice();
            }

            // Update discount
            Shop.Item.updateDiscount();

            Shop.Item.updateAmountSelectorVisibility();
        }

        // Toggle visibility of subscription button.
        Shop.toggleSubscriptionButtonVisiblity();

        Shop.Item.updateNameBackgroundImageUrl();

        Shop.Item.checkBuyFunctionality();

        Shop.checkSaleCounter(selectedItemId);
        Shop.saleTimerInitiated = false;
    },

    updateAmountSelectorVisibility : function()
    {
        if(Shop.Item.isAmountSetable()) {
            Shop.AmountSelector.show();
        } else {
            Shop.AmountSelector.hide();
        }
    },

    updateInfoForLevelItem : function (hasLevelBeenChanged) {
        var hasLevelBeenChanged         = ('undefined' !== typeof hasLevelBeenChanged && true === hasLevelBeenChanged),
            shopData                    = Shop.Item.getShopDataForSelectedLevel(),
            levelSelected               = Shop.LevelSelector.getSelectedLevel(),
            itemNameWithLevel           = Shop.Item.getNameWithLevel(),
            itemName                    = Shop.Item.getName(),
            description                 = shopData.description,
            cost                        = Shop.Item.getCostForSelectedLevel(),
            flashConfiguration          = Shop.Item.getImageData(),
            itemCaptionWithLevel        = itemName + ' ' + levelSelected,
            isElite                     = ('undefined' !== typeof shopData.isElite && true === shopData.isElite);

        // Update name
        //Shop.Item.updateFullName(itemNameWithLevel);

        // Update description
        Shop.Item.updateDescription(description);

        // Update sell price input field
        Shop.updateSellPriceInput(cost);

        // Update preview movie properties only if the level has been changed,
        // e. g. when the user clicked on the Shop.LevelSelector.
        if (hasLevelBeenChanged) {
            this.resizeText(Shop.Item.getFullCostForSelectedLevel(), 'previewPrice');
            this.resizeText(itemCaptionWithLevel, 'previewCaption');
        } else {
            // Set item caption and add level
            flashConfiguration.item_caption = itemCaptionWithLevel;

            // Set elite icon
            flashConfiguration.elite = (isElite) ? 1 : 0;

            Shop.Item.updatePreviewImage(flashConfiguration);
        }

        // Update discount
        Shop.Item.updateDiscount();
        jQuery('#sale_newPrice').html(cost);
    },

    Events : {
        /**
         * Is called when the user clicks on an item in the shop's item list.
         *
         * @author  Wolfgang Timme <w.timme@bigpoint.net>
         */
        onItemClick : function (itemId) {

            if (Shop.Item.getId() !== itemId) {
                Shop.Item.setId(itemId);

                Shop.Item.updateInfo();
                Shop.updateBuyButton();
            };
        }
    }
};
