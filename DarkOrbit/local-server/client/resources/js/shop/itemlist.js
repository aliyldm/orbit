/**
 * DarkOrbit Shop - Itemlist
 *
 * @author  Wolfgang Timme <w.timme@bigpoint.net>
 */
Shop.Itemlist = {
    Attributes : {
        // The amount of rows
        numRows                     : -1,
        // Number of rows displayed at a time
        rowsPerPage                 : 3,
        // Index of the row currently at the top (starts with 0)
        currentTopRow               : 0,
        // Duration of the scrolling animation in ms
        scrollAnimationDuration     : 500,
        // Height of an item in pixels
        itemHeight                  : 105,
        // Array with the IDs of the item links
        itemLinkIds                 : [],
        // Number of rows to scroll
        numRowsToScroll             : 3,
        // Number of rows to scroll when mouse wheel is used
        numRowsToScrollOnMousewheel : 1
    },

    Initialize : function () {
        Shop.Itemlist.fetchObjects();
        Shop.Itemlist.initializeEventListeners();
        Shop.Itemlist.updateScrollButtonStates();

        // Update the item_border elements.
        Shop.Itemlist.updateItemBorders();
    },

    fetchObjects : function () {
        Library.set('btnScrollUp',          jQuery('#item_scroll_up'));
        Library.set('btnScrollDown',        jQuery('#item_scroll_down'));
        Library.set('btnScrollTop',         jQuery('#item_scroll_top'));
        Library.set('btnScrollBottom',      jQuery('#item_scroll_bottom'));
        Library.set('itemList',             jQuery('#item_list'));
        Library.set('itemContainer',        jQuery('#item_container'));
        Library.set('itemContainerOverlay', jQuery('#item_container_overlay'));

        Shop.Itemlist.fetchItemLinkObjects();
    },

    fetchItemLinkObjects : function () {
        Library.set('itemLinks',            jQuery('.itemList_singleItem').find('a'));
    },

    initializeEventListeners : function () {
        var scrollUp        = Library.get('btnScrollUp'),
            scrollTop       = Library.get('btnScrollTop'),
            scrollDown      = Library.get('btnScrollDown'),
            scrollBottom    = Library.get('btnScrollBottom'),
            itemList        = Library.get('itemList'),
            itemLinks       = Library.get('itemLinks');

        scrollUp.on('mouseover',      Shop.Itemlist.Events.onBtnScrollUpMouseOver);
        scrollUp.on('mouseout',       Shop.Itemlist.Events.onBtnScrollUpMouseOut);
        scrollUp.on('click',          Shop.Itemlist.Events.onBtnScrollUpClick);
        scrollUp.on('mousedown',      Shop.Itemlist.Events.onBtnScrollUpMouseDown);

        scrollTop.on('mouseover',     Shop.Itemlist.Events.onBtnScrollTopMouseOver);
        scrollTop.on('mouseout',      Shop.Itemlist.Events.onBtnScrollTopMouseOut);
        scrollTop.on('click',         Shop.Itemlist.Events.onBtnScrollTopClick);
        scrollTop.on('mousedown',     Shop.Itemlist.Events.onBtnScrollTopMouseDown);

        scrollDown.on('mouseover',    Shop.Itemlist.Events.onBtnScrollDownMouseOver);
        scrollDown.on('mouseout',     Shop.Itemlist.Events.onBtnScrollDownMouseOut);
        scrollDown.on('click',        Shop.Itemlist.Events.onBtnScrollDownClick);
        scrollDown.on('mousedown',    Shop.Itemlist.Events.onBtnScrollDownMouseDown);

        scrollBottom.on('mouseover',  Shop.Itemlist.Events.onBtnScrollBottomMouseOver);
        scrollBottom.on('mouseout',   Shop.Itemlist.Events.onBtnScrollBottomMouseOut);
        scrollBottom.on('click',      Shop.Itemlist.Events.onBtnScrollBottomClick);
        scrollBottom.on('mousedown',  Shop.Itemlist.Events.onBtnScrollBottomMouseDown);

        itemList.on('mousewheel',     Shop.Itemlist.Events.onItemListMouseWheel);

        itemLinks.on('click',         Shop.Itemlist.Events.onItemClick);
        itemLinks.on('mouseover',     Shop.Itemlist.Events.onItemMouseOver);
        itemLinks.on('mouseout',      Shop.Itemlist.Events.onItemMouseOut);
        itemLinks.on('focus',         Shop.Itemlist.Events.onItemFocus);
    },

    getNumRows : function () {
        if (-1 == Shop.Itemlist.Attributes.numRows) {
            // Calculate the value
            Shop.Itemlist.Attributes.numRows = Shop.Itemlist.getNumRowsByItemCount();
        }

        return Shop.Itemlist.Attributes.numRows;
    },

    getNumRowsByItemCount : function () {
        return Math.ceil(Shop.getNumItems() / 2);
    },

    getRowsPerPage : function () {
        return Shop.Itemlist.Attributes.rowsPerPage;
    },

    getCurrentTopRow : function () {
        return Shop.Itemlist.Attributes.currentTopRow;
    },

    setCurrentTopRow : function (newTopRow) {
        Shop.Itemlist.Attributes.currentTopRow = newTopRow;
    },

    getScrollAnimationDuration : function () {
        return Shop.Itemlist.Attributes.scrollAnimationDuration;
    },

    getItemHeight : function () {
        return Shop.Itemlist.Attributes.itemHeight;
    },

    getNumRowsToScroll : function () {
        return this.Attributes.numRowsToScroll;
    },

    getNumRowsToScrollOnMousewheel : function (){
        return this.Attributes.numRowsToScrollOnMousewheel;
    },

    /**
     * Removes an item from the list and updates the necessary attributes/objects.
     *
     * @param   String  itemId  ID of the item to delete
     * @return  void
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    removeItem : function (itemId) {
        var itemContainer   = Shop.Itemlist.getItemContainerById(itemId);

        // Remove the container from DOM.
        itemContainer.remove();

        // Remove the item's id from the itemLinkIds Array.
        Shop.Itemlist.removeItemLinkId(itemId);
    },

    /**
     * Gets the container of the item specified by the given itemId.
     *
     * @param   String  itemId  ID of the item to delete
     * @return  void
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getItemContainerById : function (itemId) {
        var itemLink        = jQuery('a#' + itemId),
            itemContainer   = itemLink.parent().parent();

        return itemContainer;
    },

    /**
     * Returns the amount of rows to come (rows that are not visible and
     * below the rows currently visible).
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getRowsToCome : function () {
        return Shop.Itemlist.getNumRows() - Shop.Itemlist.getRowsPerPage() - Shop.Itemlist.getCurrentTopRow();
    },

    /**
     * Determines if there are rows left to show at the bottom.
     *
     * @author Wolfgang Timme <w.timme@bigpoint.net>
     */
    canScrollDown : function () {
        return 0 < Shop.Itemlist.getRowsToCome();
    },

    canScrollUp : function () {
        return 0 < Shop.Itemlist.getCurrentTopRow();
    },

    /**
     * Returns the number of rows the list scrolls up.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getRowsToScrollDown : function () {
        var rowsToCome          = Shop.Itemlist.getRowsToCome(),
            numRowsToScroll     = this.getNumRowsToScroll(),
            rowsToScrollDown    = (rowsToCome < numRowsToScroll) ? rowsToCome : numRowsToScroll;

        return rowsToScrollDown;
    },

    /**
     * Returns the number of rows the list scrolls up.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getRowsToScrollUp : function () {
        var currentTopRow   = Shop.Itemlist.getCurrentTopRow(),
            rowsToCome      = currentTopRow,
            numRowsToScroll = this.getNumRowsToScroll(),
            rowsToScrollUp  = (rowsToCome < numRowsToScroll) ? rowsToCome : numRowsToScroll;

        return rowsToScrollUp;
    },

    /**
     * Returns true when the list is currently animated (= scrolling) and false,
     * if not.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    isItemListAnimationRunning : function () {
        return Library.get('itemList').is(':animated');
    },

    scrollListToRow : function (newTopRow) {
        var newMarginTop    = newTopRow * Shop.Itemlist.getItemHeight() * -1,
            direction       = (newTopRow < Shop.Itemlist.getCurrentTopRow()) ? 'up' : 'down',
            canScroll       = ('up' == direction && Shop.Itemlist.canScrollUp()) || ('down' == direction && Shop.Itemlist.canScrollDown()),
            activeItemId    = Shop.Item.getId(),
            activeItemLink  = Shop.Itemlist.getLinkElementByItemId(activeItemId),
            activeItemRow   = Shop.Itemlist.getRowNumberForItem(activeItemId);

        if (canScroll && !Shop.Itemlist.isItemListAnimationRunning()) {
            // Mark active item as active when its row is going to be visible.
            // A out-of-bounds check is performed after the scroll animation.
            if (newTopRow <= activeItemRow && (newTopRow + 2) >= activeItemRow) {
                activeItemLink.addClass('active');
            }

            Library.get('itemContainerOverlay').show();
            Library.get('itemList').animate({
                    marginTop   : newMarginTop
                },
                Shop.Itemlist.getScrollAnimationDuration(),
                Shop.Itemlist.Events.onScrollAnimationFinished
            );

            Shop.Itemlist.setCurrentTopRow(newTopRow);
        }

        Shop.Itemlist.updateScrollButtonStates();
    },

    scrollUp : function (numRowsToScroll) {
        var numRowsToScroll = ('number' === typeof numRowsToScroll) ? numRowsToScroll : Shop.Itemlist.getRowsToScrollUp(),
            newTopRow       = Shop.Itemlist.getCurrentTopRow() - numRowsToScroll;

        Shop.Itemlist.scrollListToRow(newTopRow);
    },

    scrollDown : function (numRowsToScroll) {
        var numRowsToScroll = ('number' === typeof numRowsToScroll) ? numRowsToScroll : Shop.Itemlist.getRowsToScrollDown(),
            newTopRow       = Shop.Itemlist.getCurrentTopRow() + numRowsToScroll;

        Shop.Itemlist.scrollListToRow(newTopRow);
    },

    updateScrollButtonStates : function () {
        var btnScrollUp     = Library.get('btnScrollUp'),
            btnScrollTop    = Library.get('btnScrollTop'),
            btnScrollDown   = Library.get('btnScrollDown'),
            btnScrollBottom = Library.get('btnScrollBottom');

        if (Shop.Itemlist.canScrollUp()) {
            btnScrollUp.addClass('enabled');
            btnScrollTop.addClass('enabled');
        } else {
            btnScrollUp.removeClass('enabled').removeClass('mouseDown');
            btnScrollTop.removeClass('enabled').removeClass('mouseDown');
        }

        if (Shop.Itemlist.canScrollDown()) {
            btnScrollDown.addClass('enabled');
            btnScrollBottom.addClass('enabled');
        } else {
            btnScrollDown.removeClass('enabled').removeClass('mouseDown');
            btnScrollBottom.removeClass('enabled').removeClass('mouseDown');
        }
    },

    /**
     * Checks wether the current scroll position of the list is still valid.
     * Is used to prevent wrong offsets when updating the list, e. g. after
     * deleting an item from the list.
     *
     * @param   void
     * @return  void
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    checkListScrollState : function () {
        var numRows         = Shop.Itemlist.getNumRowsByItemCount(),
            currentTopRow   = Shop.Itemlist.getCurrentTopRow(),
            numRows         = Shop.Itemlist.getNumRows(),
            lastValidTopRow = numRows - 2;

        if (numRows !== Shop.Itemlist.getNumRows()) {
            // The number of rows has changed.
            Shop.Itemlist.Attributes.numRows = numRows;

            if (currentTopRow > lastValidTopRow) {
                // Scroll list to the last valid top row.
                Shop.Itemlist.scrollListToRow(lastValidTopRow);
            }

            // Update the states of the scroll buttons.
            Shop.Itemlist.updateScrollButtonStates();
        };
    },

    /**
     * Updates the costs displayed for the given itemId with the given newCost.
     *
     * @param   String  itemId  id of the item to update
     * @param   String  newCost updated cost string
     * @return  void
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updateItemCost : function (itemId, newCost) {
        var itemContainer   = Shop.Itemlist.getItemContainerById(itemId),
            costContainer   = itemContainer.find('.itemList_singlePrice'),
            costElement;

        // Recorded pages use a bare final price div; older pages wrap strong.
        if (!costContainer.length) {
            costContainer = itemContainer.children('div').last().addClass('itemList_singlePrice');
        }
        costElement = costContainer.find('strong');

        // Update the cost element's HTML
        if (costElement.length) costElement.text(newCost);
        else costContainer.text(newCost);
    },

    getItemLinkIds : function (forceReload) {
        var forceReload = ('undefined' !== typeof forceReload && true === forceReload),
            itemLinkIds = Shop.Itemlist.Attributes.itemLinkIds,
            numIds      = itemLinkIds.length;

        if (0 === numIds || forceReload) {
            // Get item link ids from DOM.
            itemLinkIds = Shop.Itemlist.getItemLinkIdsFromDom();

            // Store them locally
            Shop.Itemlist.Attributes.itemLinkIds = itemLinkIds;
        }

        return itemLinkIds;
    },

    getItemLinkIdsFromDom : function () {
        var itemLinks       = jQuery('.itemList_singleItem').find('a'),
            itemLinkIds     = [],
            linkElement,
            linkId;

        jQuery.each(itemLinks, function (i, linkHtml) {
            // Create jQuery object for this link
            linkElement = jQuery(linkHtml);

            // Store the link's id
            linkId      = linkElement.attr('id');
            itemLinkIds.push(linkId);
        });

        return itemLinkIds;
    },

    isItemVisible : function (itemId) {
        var linkIdIndex     = Shop.Itemlist.getItemLinkIndex(itemId),
            currentTopRow   = Shop.Itemlist.getCurrentTopRow();

        return (currentTopRow * 2 <= linkIdIndex && (currentTopRow * 2 + 6) > linkIdIndex);
    },

    isItemActive : function (itemId) {
        return Shop.Item.getId() == itemId;
    },

    getItemLinkIndex : function (itemId) {
        var itemLinkIds     = Shop.Itemlist.getItemLinkIds(),
            linkIdIndex     = itemLinkIds.indexOf(itemId);

        return linkIdIndex;
    },

    removeItemLinkId : function (itemId) {
        var itemLinkIndex = Shop.Itemlist.getItemLinkIndex(itemId);

        Shop.Itemlist.getItemLinkIds().splice(itemLinkIndex, 1);
    },

    /**
     * Returns the number of the row in which the item
     * specified by the given itemId is on.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getRowNumberForItem : function (itemId) {
        var itemLinkIndex   = Shop.Itemlist.getItemLinkIndex(itemId),
            firstItemInRow  = (0 === (itemLinkIndex % 2)) ? itemLinkIndex : itemLinkIndex - 1,
            rowIndex        = (firstItemInRow + 2) / 2 - 1;

        return rowIndex;
    },

    scrollToItem : function (itemId) {
        var rowToScrollTo   = this.getRowNumberForItem(itemId),
            // Empty rows that would show up if we the itemRow would be most top.
            numEmptyRows    = rowToScrollTo - Shop.Itemlist.getNumRows() + 3;

        if (-1 < rowToScrollTo) {
            // The row number is valid. Check if we can scroll to it.
            if (0 < numEmptyRows) {
                rowToScrollTo -= numEmptyRows;
            }

            this.scrollListToRow(rowToScrollTo);
        }
    },

    getLinkElementByItemId : function (itemId) {
        var itemLinks   = Library.get('itemLinks'),
            linkIndex   = Shop.Itemlist.getItemLinkIndex(itemId),
            linkHtml    = itemLinks[linkIndex],
            linkElement = jQuery(linkHtml);

        return linkElement;
    },

    /**
     * Updates the display state of the item_border elements according to the
     * current conditions.
     *
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    updateItemBorders : function () {
        var activeItemId    = Shop.Item.getId(),
            activeItemLink  = Shop.Itemlist.getLinkElementByItemId(activeItemId);

        // Check wether the item is visible.
        if (Shop.Itemlist.isItemVisible(activeItemId)) {
            activeItemLink.addClass('active');
        } else {
            activeItemLink.removeClass('active');
        }
    },

    /**
     * Selects the item specified by the given itemId.
     *
     * @param   int itemId  ID of the item to select
     * @return  void
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    selectItem : function (itemId) {
        var itemLinks   = Library.get('itemLinks');

        if (Shop.Itemlist.isItemVisible(itemId)) {
            if (!Shop.Itemlist.isItemActive(itemId)) {
                // Remove 'active' class from all item links
                itemLinks.removeClass('active');

                // Remove 'mouseOver' class from all item links
                itemLinks.removeClass('mouseOver');

                // Show this item's 'item_active' element
                Shop.Itemlist.getLinkElementByItemId(itemId).addClass('active');
            }

            Shop.Item.Events.onItemClick(itemId);
        }
    },

    /**
     * Selects the first item in the list. This 'emulates' the user click
     * on the first item in the list.
     *
     * @return  void
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    selectFirstItemInList : function () {
        var itemLinkIds = Shop.Itemlist.getItemLinkIds(),
            firstItemId = itemLinkIds[0];

        Shop.Itemlist.selectItem(firstItemId);
    },

    Events : {
        onBtnScrollDownMouseOver : function (event) {
            if (Shop.Itemlist.canScrollDown()) {
                Library.get('btnScrollDown').addClass('hover');
            }

            Shop.Itemlist.updateScrollButtonStates();
        },

        onBtnScrollDownMouseOut : function (event) {
            Library.get('btnScrollDown').removeClass('hover').removeClass('mouseDown');

            Shop.Itemlist.updateScrollButtonStates();
        },

        onBtnScrollDownMouseDown : function (event) {
            if (Shop.Itemlist.canScrollDown()) {
                Library.get('btnScrollDown').removeClass('hover').addClass('mouseDown');
            }
        },

        onBtnScrollDownClick : function (event) {
            Shop.Itemlist.scrollDown();
        },

        onBtnScrollBottomMouseOver : function (event) {
            if (Shop.Itemlist.canScrollDown()) {
                Library.get('btnScrollBottom').addClass('hover');
            }
        },

        onBtnScrollBottomMouseOut : function (event) {
            Library.get('btnScrollBottom').removeClass('hover').removeClass('mouseDown');

            Shop.Itemlist.updateScrollButtonStates();
        },

        onBtnScrollBottomClick : function (event) {
            var newTopRow = Shop.Itemlist.getNumRows() - Shop.Itemlist.getRowsPerPage();

            Shop.Itemlist.scrollListToRow(newTopRow);
        },

        onBtnScrollBottomMouseDown : function (event) {
            if (Shop.Itemlist.canScrollDown()) {
                Library.get('btnScrollBottom').removeClass('hover').addClass('mouseDown');
            }
        },

        onBtnScrollUpMouseOver : function (event) {
            if (Shop.Itemlist.canScrollUp()) {
                Library.get('btnScrollUp').addClass('hover');
            }

            Shop.Itemlist.updateScrollButtonStates();
        },

        onBtnScrollUpMouseOut : function (event) {
            Library.get('btnScrollUp').removeClass('hover').removeClass('mouseDown');

            Shop.Itemlist.updateScrollButtonStates();
        },

        onBtnScrollUpClick : function (event) {
            Shop.Itemlist.scrollUp();
        },

        onBtnScrollUpMouseDown : function (event) {
            if (Shop.Itemlist.canScrollUp()) {
                Library.get('btnScrollUp').removeClass('hover').addClass('mouseDown');
            }
        },

        onItemListMouseWheel : function (event, delta) {
            var direction       = (0 < delta) ? 'up' : 'down',
                numRowsToScroll = Shop.Itemlist.getNumRowsToScrollOnMousewheel();

            if ('up' == direction) {
                Shop.Itemlist.scrollUp(numRowsToScroll);
            } else if ('down' == direction) {
                Shop.Itemlist.scrollDown(numRowsToScroll);
            }

            event.preventDefault();
        },

        onBtnScrollTopMouseOver : function (event) {
            if (Shop.Itemlist.canScrollUp()) {
                Library.get('btnScrollTop').addClass('hover');
            }
        },

        onBtnScrollTopMouseOut : function (event) {
            Library.get('btnScrollTop').removeClass('hover').removeClass('mouseDown');

            Shop.Itemlist.updateScrollButtonStates();
        },

        onBtnScrollTopClick : function (event) {
            var newTopRow = 0;

            Shop.Itemlist.scrollListToRow(newTopRow);
        },

        onBtnScrollTopMouseDown : function (event) {
            if (Shop.Itemlist.canScrollUp()) {
                Library.get('btnScrollTop').removeClass('hover').addClass('mouseDown');
            }
        },

        onScrollAnimationFinished : function () {
            Library.get('itemContainerOverlay').hide();

            // The active item might be out of bounds; update the item borders.
            Shop.Itemlist.updateItemBorders();
        },

        onItemMouseOver : function (event) {
            var linkElement = jQuery(this),
                itemId      = linkElement.attr('id');

            if (Shop.Itemlist.isItemVisible(itemId) && !Shop.Itemlist.isItemActive(itemId)) {
                linkElement.addClass('mouseOver');
            }
        },

        onItemMouseOut : function (event) {
            jQuery(this).removeClass('mouseOver').removeClass('mouseDown');
        },

        onItemClick : function(event) {
            var linkElement = jQuery(this),
                itemId      = linkElement.attr('id');

            Shop.Itemlist.selectItem(itemId);

            event.preventDefault();
        },

        /**
         * Don't let the user 'focus' the item in order to prevent
         * the dotted border.
         *
         * @author  Wolfgang Timme <w.timme@bigpoint.net>
         */
        onItemFocus : function (event) {
            jQuery(this).on("blur");
        },

        /**
         * Is executed after items have been removed from the list.
         *
         * @author  Wolfgang Timme <w.timme@bigpoint.net>
         */
        afterItemRemoval : function () {
            var numRows     = Shop.Itemlist.getNumRowsByItemCount(),
                itemLinkIds = Shop.Itemlist.getItemLinkIdsFromDom();

            // Set new number of rows.
            Shop.Itemlist.Attributes.numRows        = numRows;

            // Set new array with item link ids.
            Shop.Itemlist.Attributes.itemLinkIds    = itemLinkIds;

            // Check the scroll state of the list.
            Shop.Itemlist.checkListScrollState();

            // Re-fetch item link objects
            Shop.Itemlist.fetchItemLinkObjects();
        }
    }
};
