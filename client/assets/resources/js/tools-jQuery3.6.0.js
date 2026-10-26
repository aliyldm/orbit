/**
 * Tools
 * Library with generic functions for DarkOrbit
 *
 * @author  Wolfgang Timme <w.timme@bigpoint.net>
 */
var Tools = {
    Initialize : function () {},

    /**
     * Adds 'hover' functionality to the given element.
     */
    addDefaultMouseEventBehaviour : function (element, selector = null) {
        element.on('mouseover', selector,    Tools.Events.General.onMouseOver);
        element.on('mouseout',  selector,    Tools.Events.General.onMouseOut);
        element.on('mousedown', selector,    Tools.Events.General.onMouseDown);
        element.on('mouseup',   selector,    Tools.Events.General.onMouseUp);
    },

    isNumeric : function (valueToCheck) {
        return !isNaN(valueToCheck) || 'number' === typeof valueToCheck
    },

    Events : {
        General : {
            onMouseOver : function (event) {
                jQuery(this).addClass('mouseOver');
            },

            onMouseOut : function (event) {
                jQuery(this).removeClass('mouseDown').removeClass('mouseOver');
            },

            onMouseDown : function (event) {
                jQuery(this).removeClass('mouseOver').addClass('mouseDown');
            },

            onMouseUp : function (event) {
                jQuery(this).removeClass('mouseDown').addClass('mouseOver');
            }
        }
    }
};