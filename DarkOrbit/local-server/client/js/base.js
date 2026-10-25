function GE(id) {
 return document.getElementById(id);
}

function setvis(id) {
   if (GE(id)) GE(id).style.display='block';
}

function setHTML(id,what) {
  if (GE(id)) GE(id).innerHTML=what;
}

function setValue(id,what) {
  if (GE(id)) GE(id).value=what;
}

function setBackgroundImage(id,what) {
    if (GE(id)) {
        GE(id).style.backgroundImage=what;
    }
}

function sethide(id) {
  if (GE(id)) GE(id).style.display='none';
}

function previewpng(filename) {
 GE('preview').innerHTML='<img src="'+CDN+''+filename+'" width="320" height="240">';
}

var cvObj = {'background_cv': "",
             'item_cv': "",
             'elite_icon_cv' : "",
             'booster_icon_cv' : "",
             'limited_icon_cv' : "",
             'limited_std_icon_cv' : "",
             'shopdetails_cv' : ""
}

function setCV(key, val) {
    cvObj[key] = val;
}

function getCV(key) {
    return cvObj[key];
}

/**
 * header functionality
 */
var HeaderFunc = {
    scrollSpeed: 5,
    scrollerWidth: 0,
    scroller: undefined,
    scrollItems: undefined,
    scrollMargin: 0,
    currentEvent: 0,
    lastEvent: 0,

    init: function() {
        this.setWpSize();
        this.triggerButtons();

        jQuery(window).resize(function() {
            HeaderFunc.setWpSize();
        });

        jQuery('#header_hangar_arrow').click(function() {
            HeaderFunc.hangarSlotMachine();
        });

        // comment away the header caused not using and lagging mini client alot
        //this.tickerNews();

        if (jQuery('.header_event_wrapper').length > 1) {
            this.lastEvent = jQuery('.header_event_wrapper').length - 1;
            window.setInterval("HeaderFunc.flipEvent()", 5000);
        }

        if (jQuery('.header_event_wrapper').length) {
            jQuery('.header_event_wrapper').eq(0).css('display', 'block');
        }

        if (jQuery('#upsell_glow').length) {
            window.setInterval("HeaderFunc.upsellEvent()", 5000);
        }
		if (jQuery('#emailHighlight').length) {
            window.setInterval("HeaderFunc.mailGlow()", 3000);
        }
        if (jQuery('#activateShipHighlight').length) {
            window.setInterval("HeaderFunc.shipActivateGlow()", 1000);
        }

        if (jQuery('#header_emailInvite_glow').css('display') == 'none') {
            jQuery('#header_emailInvite_glow').css('display', 'block');
            window.setInterval("HeaderFunc.emailInviteEvent()", 3000);
        }

        this.setTooltips();
    },

    flipEvent: function() {
        var curEvent = this.currentEvent;
        var nextEvent = this.currentEvent + 1;
        if (nextEvent > this.lastEvent) {
            nextEvent = 0;
        }

        jQuery('.header_event_wrapper').eq(curEvent).fadeOut(1000, function() {
            jQuery('.header_event_wrapper').eq(nextEvent).fadeIn(1000).css('display', 'block');
        });

        this.currentEvent = nextEvent;
    },

    mailGlow: function() {
        jQuery('#emailHighlight').fadeIn(600).delay(600).fadeOut(600);
    },
    shipActivateGlow: function() {
        jQuery('#activateShipHighlight').fadeIn(400).delay(400).fadeOut(400);
    },
	upsellEvent: function() {
        jQuery('#upsell_glow').fadeIn(400).delay(400).fadeOut(400);
    },

    emailInviteEvent: function() {
        jQuery('#header_emailInvite_glow').fadeIn(600).delay(600).fadeOut(800);
    },

    setWpSize: function() {
        var windowSize = jQuery(window).width();
        var newSize, wpPos;
        var wpSize = 1024;
       var fixValue = 0;

        if (windowSize < wpSize) {
           newSize = windowSize;
        } else {
            newSize = wpSize;
        }

        // wallpaper position
        wpPos = (newSize / 2) - (wpSize / 2) + fixValue;

        jQuery('#wallpaper_all_wrapper').css('width', newSize + 'px');
        jQuery('#wallpaper_all_wrapper').css('background-position', wpPos + 'px top');
    },

    triggerButtons: function() {
        // start button
        jQuery('#header_start_btn').click(function() {
            HeaderFunc.startClient();
            DDNA.buttonClicked({elementID: 'main_buttons', buttonID: 'play_button'});
        });

        // help button
        jQuery('#header_help_btn').click(function() {
            showHelp();
        });
    },

    startClient: function() {
        if (
            jQuery('#header_start_btn').hasClass('start_btn_inactive')
            || jQuery('#noActiveHangarShip').length > 0
        ) {
            var errorText = jQuery('#noShipClientAccess').val();
            icon = 'error';
            infoText = errorText;
            showInfoLayer('info', 0, '');
        } else {
            window.blur();
            window.focus();
            Main.openFlashClient();
        }
    },

    setTooltips: function() {
        jQuery('#profile_btn').qtip({
            content: header_ttips.pilot,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#lab_btn').qtip({
            content: header_ttips.skylab,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_top_id').qtip({
            content: header_ttips.uid,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_top_level').qtip({
            content: header_ttips.lvl,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_top_exp').qtip({
            content: header_ttips.exp,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_top_hnr').qtip({
            content: header_ttips.hnr,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_my_jackpot').qtip({
            content: header_ttips.jpt,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_friends').qtip({
            content: header_ttips.fri,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_new_mail').qtip({
            content: header_ttips.nms,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_uri').qtip({
            content: header_ttips.uri,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_credits').qtip({
            content: header_ttips.cdt,
            style: 'dohdr',
            position: {target: 'mouse'}
        });
        jQuery('#header_main_multiplier').qtip({
        	content: header_ttips.head_multiplier,
        	position: {target: 'mouse'},
            style: 'dohdr300'
        });

        jQuery('#header_button_home').qtip({
            content: header_ttips.header_home,
            position: {target: 'mouse'},
            style: 'dohdr'
        });
        jQuery('#header_button_server').qtip({
            content: header_ttips.header_server,
            position: {target: 'mouse'},
            style: 'dohdr'
        });
        jQuery('#header_button_help').qtip({
            content: header_ttips.header_help,
            position: {target: 'mouse'},
            style: 'dohdr'
        });
        jQuery('#header_button_logout').qtip({
            content: header_ttips.header_logout,
            position: {target: 'mouse'},
            style: 'dohdr'
        });
        jQuery('#header_button_account').qtip({
            content: header_ttips.header_account,
            position: {target: 'mouse'},
            style: 'dohdr'
        });

        jQuery("#header_hangar_arrow").qtip({content: header_ttips.hangarSlot_arrow_tooltip_expand, style:'dohdr', position:{target:'mouse'}});
        jQuery(".header_hangar_slot_getNext").qtip({content: header_ttips.tp_expand_hangar, style:'dohdr', position:{target:'mouse'}});

    },

    buttonChangeState: function(elm, btn, state) {
        var bgPos;
        switch (state) {
            case 'hover':
                bgPos = (btn == 1) ? '-19px' : '-22px';
                break;
            case 'select':
                //bgPos = (btn == 1) ? '-38px' : '-44px';
                bgPos = (btn == 1) ? '-19px' : '-22px';
                break;
            default: bgPos = 'top'; break;
        }

        var imgChild = jQuery(elm).children();
        imgChild.eq(0).css('background-position', 'left ' + bgPos);
        imgChild.eq(1).css('background-position', 'left ' + bgPos);
        imgChild.eq(2).css('background-position', 'right ' + bgPos);
        /*
        // change text color on select
        var curID = jQuery(elm).attr('id');

        if (state == 'select') {
            jQuery('#' + curID + '_std').css('display', 'none');
            jQuery('#' + curID + '_act').css('display', 'block');
        } else {
            jQuery('#' + curID + '_std').css('display', 'block');
            jQuery('#' + curID + '_act').css('display', 'none');
        }*/
    },

    hangarSlotMachine: function() {
        // check if to show or to hide
        jQuery('.header_hangar_slot').each(function(e) {
            if ('none' == jQuery(this).css('display')) {
                jQuery(this).css('display', 'block');
                jQuery('#header_hangar_arrow').addClass('active_arrow');
                jQuery("#header_hangar_arrow").qtip('destroy');
                jQuery("#header_hangar_arrow").qtip({content: header_ttips.hangarSlot_arrow_tooltip_collapse, style:'dohdr', position:{target:'mouse'}});

            } else {
                jQuery(this).css('display', 'none');
                jQuery('.header_hangar_slot.current_slot').css('display', 'block');
                jQuery('#header_hangar_arrow').removeClass('active_arrow');
                jQuery("#header_hangar_arrow").qtip('destroy');
                jQuery("#header_hangar_arrow").qtip({content: header_ttips.hangarSlot_arrow_tooltip_expand, style:'dohdr', position:{target:'mouse'}});
            }
        });
        jQuery('.header_hangar_slot_getNext').toggle();
    },

    tickerNews: function() {
        //this.scroller = jQuery('#header_news_ticker');

        //this.scroller.children().each(function() {
        //    HeaderFunc.scrollerWidth += jQuery(this).outerWidth(true);
        //});
        //this.scrollerWidth = this.scroller.outerWidth();

        //this.scrollTicker();

        //this.scroller.mouseover(function() {
        //    HeaderFunc.scroller.stop();
        //});
        //this.scroller.mouseout(function() {
        //    HeaderFunc.scrollMargin = parseInt(HeaderFunc.scroller.css('margin-left').replace(/px/, ''));
        //    HeaderFunc.scrollTicker();
        //});
    },

    scrollTicker: function() {
        //this.scrollItems = this.scroller.children();
        //var scrollWidth = this.scrollItems.eq(0).outerWidth(true);
        //var scrollMargin = this.scrollMargin;
        //this.scrollMargin = 0;

        //this.scroller.animate(
        //    {'margin-left': (scrollWidth * -1) + scrollMargin},
        //    scrollWidth * 100 / HeaderFunc.scrollSpeed,
        //    'linear',
        //    ScrollerChangeFirst
        //);
    },

    showNews: function(newsId) {
        showNews(newsId);
    },

    showInfluenceFactionLayer: function(factionId) {
        showBusyLayer();
        jQuery('#influenceBattle').addClass('influenceBattle_'+factionId);
        jQuery('#influenceBattle').show()
    }
};

/**
 * update credits and uri display in header
 * @param mType ('credits' | 'uridium')
 * @param amount
 * @param operator (null | 'plus' | 'minus')
 */
function updateMoneyDisplay(mType, amount, operator)
{
    var mContainer, newAmount;

    if ('uridium' == mType) {
        mContainer = jQuery('#header_uri');
    } else if ('credits' == mType) {
        mContainer = jQuery('#header_credits');
    } else {
        return false;
    }

    var currentAmount = parseInt(mContainer.text());

// TODO: add functionality to calculate with local formatted money
//    if ('plus' == operator) {
//        newAmount = currentAmount + parseInt(amount);
//    } else if ('minus' == operator) {
//        newAmount = currentAmount - amount;
//    } else {
//        newAmount = amount;
//    }
    newAmount = amount;

    mContainer.text(newAmount);
}

/**
 * news ticker helper function
 * setting first element to last position for infinite loop
 */
function ScrollerChangeFirst() {
    HeaderFunc.scroller.append(HeaderFunc.scrollItems.eq(0).remove()).css('margin-left', 0);
    HeaderFunc.scrollTicker();
}

/**
 * Only interact with jQuery if it is loaded.
 */
if ('undefined' !== typeof jQuery) {
    jQuery(document).ready(function() {
        HeaderFunc.init();
    });
};

var DDNA = {
    context: {},
    init : function (_context, _platform) {
        if(_context === '')
        {
            DDNA.context = null;
            console.log('init: _context is null');
        } else {
            DDNA.context = JSON.parse(_context);
            DDNA.context['platform'] = _platform;
        }
    },

    buttonClicked: function(params) {
        if(DDNA.context == null)
        {
            console.log('buttonClicked: DDNA.context is null');
            return;
        }
        var event = {
            eventName: 'buttonClicked',
            eventParams: params
        };
        DDNA.track(event);
    },

    track: function (event) {
        event = jQuery.extend(true, DDNA.getDefaults(), event);
        console.log("sending event " + JSON.stringify(event));
        //actually send the events
        jQuery.ajax({
            type: 'POST',
            url: DDNA.context['url'] + "/collect/api/" + DDNA.context['key'],
            data: JSON.stringify(event),
            success: function() {
                console.log('Events successfully sent');
            },
            error: function() {
                //there was an error sending the events, so we add the events back to the eventList (at the beginning).
                console.log('Error sending events, will retry on next sendEvents()', arguments)
            }
        });
    },

    //The defaults for the event
    getDefaults : function () {
        return {
            userID: DDNA.context['userID'],
            sessionID: DDNA.context['sessionID'],
            eventParams: {
                projectID: parseInt(DDNA.context['instanceID']),
                platform: DDNA.context['platform']
            }
        };
    },
};