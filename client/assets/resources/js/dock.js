/**
 * JavaScript for internalDock.
 * 
 * @author  Wolfgang Timme <w.timme@bigpoint.net>
 */
var Dock = {
    Initialize : function () {
        this.fetchElements();
        this.initializeEventListeners();
    },

    fetchElements : function () {
        var btnActivateShip = jQuery('#buttonActivateShip'),
            hangarSlotTabs  = jQuery('.hangarSlot');

        Library.set('btnActivateShip',  btnActivateShip);
        Library.set('hangarSlotTabs',   hangarSlotTabs);
    },

    initializeEventListeners : function () {
        var btnActivateShip = Library.get('btnActivateShip'),
            hangarSlotTabs  = Library.get('hangarSlotTabs');

        // Only add event listeners to 'activate ship' button if it is present.
        if ('undefined' !== typeof btnActivateShip[0]) {
            // Add default behaviour (mouse over/down/up/out)
            Tools.addDefaultMouseEventBehaviour(btnActivateShip);
        }

        hangarSlotTabs.on('mouseover',    this.Events.onHangarTabMouseOver);
        hangarSlotTabs.on('mouseout',     this.Events.onHangarTabMouseOut);
    },

    showTooltipForSlotId : function (slotId) {
        console.log('Show tooltip for slot #' + slotId);
    },

    Events : {
        /**
         * Is called when the user places the mouse over a hangar tab button.
         */
        onHangarTabMouseOver : function (event) {
            var container   = jQuery(this),
                containerId = container.attr('id'),
                slotId      = parseInt(containerId.replace('slot_', ''));
            
            jQuery("#hangarInfoLayer").show();
        },

        /**
         * Is called when the mouse leaves a hangar tab button.
         */
        onHangarTabMouseOut : function (event) {
            jQuery("#hangarInfoLayer").hide();
        }
    }
};