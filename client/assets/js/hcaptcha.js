
var PassiveCaptcha = {
	havePasscode:false,
	curPasscode:null,

	setHCField: function (response) {
		// your code can go here if updating state in your app.
		PassiveCaptcha.havePasscode = true;
		// `response` will be a text string containing the passcode
		PassiveCaptcha.curPasscode = response;
		jQuery.ajax({
			type     : 'POST',
			url      : '/ajax/captcha.php',
			dataType : 'json',
			data     : {
				command                   	: "checkHCaptchaPassive",
				'h-captcha-response'    	: response,
			},
			success  : function (response) {
				if (response.result == 'OK') {
					hideBusyLayer();
					document.getElementById('captchaScriptContainer').hidden = true;
				} else {
					do_redirect('/indexInternal.es?action=externalLogout');
				}
			}
		});
	},

	setExpired: function () {
		// set status for your app state tracking code (example)
		PassiveCaptcha.havePasscode = false;
		// get a new passcode.
		// no need to specify the widgetID if only one on a page.
		hcaptcha.execute();
	},

	onOpen: function () {
		console.log("onOpen")
	},

	onClose: function () {
		console.log("onClose")
	},
}

var onLoad = function () {
	if(jQuery('#hcaptcha').children(':visible').length == 0) {
		// get a passcode
		hcaptcha.execute();
	}
	else {
		showBusyLayer();
	}
};

var onCallback = function (response) {
	PassiveCaptcha.setHCField(response)
}

var onExpiredCallback = function (response) {
	PassiveCaptcha.setExpired()
}
