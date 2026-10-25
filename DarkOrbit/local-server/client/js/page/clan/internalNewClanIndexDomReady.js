jQuery('docuemnt').ready(function(){


    jQuery('ul.clan_items').eq(1).find('li:even').addClass('even');
    jQuery('li.application_item:last').addClass('last_application_item');

    // accordion toogle for application list on clan list page
    jQuery('#wrapper ul li.application_toogle').unbind('click');
    jQuery('#wrapper ul li.application_toogle').bind('click', function(evt){
        evt.preventDefault();

        var element = jQuery(this);
        var applications = jQuery('li.application_item');
        var active = element.hasClass('active');
        
        var startInterval = 250;
        var delay = 100;

        applications.each(function(index, value){
            var element = jQuery(value);
            if(false === active) {
                element.slideUp(startInterval);
            } else {
                element.slideDown(startInterval);
            }
            startInterval = startInterval + delay;
        });

        if(false === active) {
            element.addClass('active');
        } else {
            element.removeClass('active');
        };
    });

    // search form handling on the clan list page
    jQuery('#searchClanList input[name=reset]').unbind('click');
    jQuery('#searchClanList input[name=reset]').bind('click', function(e){
        jQuery('#searchClanList').find('input[name=lookup]').val('');
        jQuery('#searchClanList').find('input[name="filterMembers"]').val('all');
        jQuery('#searchClanList').find('input[name="filterRank"]').val('all');
        jQuery('#searchClanList').find('input[name="filterFaction"]').val('all');
        jQuery('#searchClanList').find('input[name="filterStatus"]').val('all');
        jQuery('#searchClanList').find('input[name=submit]').trigger('click');
    });

    // after application deletion message
    if (jQuery('#delAppSuccessMsg').length > 0 || jQuery('#delAppErrorMsg').length > 0) {
        Tools.Popup.Initialize();

        if (jQuery('#delAppSuccessMsg').length > 0) {
            var successMsg = jQuery('#delAppSuccessMsg').val();
            Tools.Popup.Presets.showSuccessDialog(successMsg);
        } else {
            var errorMsg = jQuery('#delAppErrorMsg').val();
            Tools.Popup.Presets.showErrorDialog(errorMsg);
        }
    }


    // pending onclick event
    if (jQuery('.status.pending').length > 0) {
        Tools.Popup.Initialize();

        jQuery('.status.pending a').unbind('click');
        jQuery('.status.pending a').bind('click', function(e) {
            e.preventDefault();

            var element  = jQuery(this),
                question = element.attr('rel'),
                target   = element.attr('href');

            Tools.Popup.Presets.showQuestionDialog (
                question, 
                {
                    textIdentifier: 'ok',
                    callback: function() {
                        location.href = target;
                    }
                }
            );
        });
    }

    // input field replacement
    jQuery('input[type="text"], textarea').each(function() {
        var element = jQuery(this),
            title = element.attr('title'),
            value = element.val();

        if('' == value){
            element.val(title);
        }
    });

    jQuery('input[type="text"], textarea').unbind('focus');
    jQuery('input[type="text"], textarea').bind('focus', function() {
        var element = jQuery(this),
            title = element.attr('title'),
            value = element.val();

        if (value == title) {
            element.val('');
        }
    });

    jQuery('input[type="text"], textarea').unbind('blur');
    jQuery('input[type="text"], textarea').bind('blur', function() {
        var element = jQuery(this),
            title = element.attr('title'),
            value = element.val();

        if ('' == value) {
            element.val(title);
        }
    });

    // jsScrollpain at least!
    jQuery('.js-scroll-pane').jScrollPane({autoReinitialise: false, showArrows: true});


});

// @todo - used or not this is the question.

function cleanClanFoundForm()
{
    jQuery('input[type="text"], textarea').each(function() {
        var inpValue = jQuery(this).val();
        var inpTitle = jQuery(this).attr('title');

        if (inpValue == inpTitle) {
            jQuery(this).val('');
        }
    });
}

var filterInitialized = false;

function showFilterLayer()
{
    var filterContent   = jQuery('#filterLayerBody').html();
    var filterHead      = '<div id="filterLayerHead">';
    filterHead          += jQuery('#filterLayerHead').html();
    filterHead          += '</div>';

    Tools.Popup.Initialize();
    Tools.Popup.Presets.showSuccessDialog('filterLayer', {
        textIdentifier: 'clan_input_search',
        callback: function () {
            // empty text field if not filled out
            var textField = jQuery('#searchClanList').find('input[name="lookup"]');
            var textVal = textField.val();
            var textDef = textField.attr('title');
            if (textVal == textDef) {
                textField.val('');
            }

            // trigger form
            jQuery('#searchClanList').find('input[type="submit"]').trigger('click');
        }
    });

    // override popup content with filter content if not already done
    if (!filterInitialized) {
        jQuery('#popup .body').html(filterContent);
        var popUpHead = jQuery('#popup .header').html();
        jQuery('#popup .header').html(filterHead + popUpHead);

        addFilterListeners();

        // delete original content to prevent fckd up js behaviour
        jQuery('#filterLayerBody').html('');
        filterInitialized = true;
    }
}

function addFilterListeners()
{
    // make select clickable
    jQuery('.filterCritSelect').click(function() {
        var selectId = jQuery(this).attr('id');
        var selLayer = jQuery('#' + selectId + 'Layer');

        jQuery('#' + selectId + 'Layer').toggleClass('hidden');
    });

    // make select options clickable and save value
    jQuery('.filterCritSelectLayer div').click(function() {
        var originId    = jQuery(this).attr('id');
        var curText     = jQuery(this).text();
        var splitter    = originId.split('_');
        var layerId     = splitter[0] + 'Layer';
        var inputId     = splitter[0].replace(/By/, '');

        jQuery('input[name="' + inputId + '"]').val(splitter[1]);
        jQuery('#' + splitter[0]).html(curText);
        jQuery('#' + layerId).addClass('hidden');
    });


}