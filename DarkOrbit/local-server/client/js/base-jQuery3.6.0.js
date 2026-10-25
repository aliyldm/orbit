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
		this.triggerButtons();

		jQuery('#header_hangar_arrow').on("click", function() {
			HeaderFunc.hangarSlotMachine();
		});

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
		let curEvent = this.currentEvent;
		let nextEvent = this.currentEvent + 1;
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

	triggerButtons: function() {
		// start button
		jQuery('#header_start_btn').on('click', function() {
			HeaderFunc.startClient();
			DDNA.buttonClicked({elementID: 'main_buttons', buttonID: 'play_button'});
		});

		// help button
		jQuery('#header_help_btn').on('click', function() {
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
			position: {target: 'mouse',adjust:{x:10,y:15}}
		});
		jQuery('#lab_btn').qtip({
			content: header_ttips.skylab,
			style: 'dohdr',
			position: {target: 'mouse',adjust:{x:10,y:15}}
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
			position: {target: 'mouse',adjust:{x:10,y:15}}
		});
		jQuery('#header_uri').qtip({
			content: header_ttips.uri,
			style: 'dohdr',
			position: {target: 'mouse',adjust:{x:10,y:15}}
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
			position: {target: 'mouse',adjust:{x:10,y:15}},
			style: 'dohdr'
		});
		jQuery('#header_button_server').qtip({
			content: header_ttips.header_server,
			position: {target: 'mouse',adjust:{x:10,y:15}},
			style: 'dohdr'
		});
		jQuery('#header_button_help').qtip({
			content: header_ttips.header_help,
			position: {target: 'mouse',adjust:{x:10,y:15}},
			style: 'dohdr'
		});
		jQuery('#header_button_logout').qtip({
			content: header_ttips.header_logout,
			position: {target: 'mouse',adjust:{x:10,y:15}},
			style: 'dohdr'
		});
		jQuery('#header_button_account').qtip({
			content: header_ttips.header_account,
			position: {target: 'mouse',adjust:{x:10,y:15}},
			style: 'dohdr'
		});

		jQuery("#header_hangar_arrow").qtip({content: header_ttips.hangarSlot_arrow_tooltip_expand, style:'dohdr', position:{target:'mouse',adjust:{x:10,y:15}}});
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
 * update credits and uri display in header. Used by equipmentclient to update the value
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
	newAmount = amount;
	mContainer.text(newAmount);
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
		if(!_context)
		{
			DDNA.context = null;
			console.warn('init: DDNA context is null');
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