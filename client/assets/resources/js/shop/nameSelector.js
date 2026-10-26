Shop.NameSelector = {
    Properties : {
        minLength                   : 1,
        maxLength                   : 16,
        regularExpressionToMatch    : /^[^@\+\?'&;<>%"\x5c]*$/
    },
    
    Initialize : function () {
        Shop.NameSelector.fetchElements();
    },
    
    fetchElements : function () {
        var nameSelector    = jQuery('#nameSelector');
        
        Library.set('nameSelector', nameSelector);

        Library.set('selectedName', nameSelector.find('#itemName'));
    },
    
    doesNameMatchRegularExpression : function () {
        var selectedName                = Shop.NameSelector.getName(),
            regularExpressionToMatch    = Shop.NameSelector.getRegularExpressionToMatch(),
            doesNameMatch               = regularExpressionToMatch.test(selectedName);

        return doesNameMatch;
    },

    getRegularExpressionToMatch : function () {
        return Shop.NameSelector.Properties.regularExpressionToMatch;
    },

    doesNameHaveCorrectLength : function () {
        var selectedName        = Shop.NameSelector.getName(),
            textLength          = selectedName.length,
            hasMinLength        = Shop.NameSelector.getMinLength() <= textLength,
            hasMaxLength        = Shop.NameSelector.getMaxLength() >= textLength,
            doesMatchTextLength = hasMinLength && hasMaxLength;
        
        return doesMatchTextLength;
    },

    getMinLength : function () {
        return Shop.NameSelector.Properties.minLength;
    },

    getMaxLength : function () {
        return Shop.NameSelector.Properties.maxLength;
    },

    getName : function () {
        var nameInput       = Library.get('selectedName'),
            selectedName    = nameInput.val(),
            nameTrimmed     = jQuery.trim(selectedName);
        
        return nameTrimmed;
    },

    isValidName : function () {
        var matchesExpression   = Shop.NameSelector.doesNameMatchRegularExpression(),
            hasValidLength      = Shop.NameSelector.doesNameHaveCorrectLength(),
            isValidName         = matchesExpression && hasValidLength;
        
        return isValidName;
    },

    /**
     * Checks wether the selected name meets the requirements.
     * Displays a warning popup if that is not the case.
     * 
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    displayWarningPopup : function () {
        var matchesExpression   = Shop.NameSelector.doesNameMatchRegularExpression(),
            hasValidLength      = Shop.NameSelector.doesNameHaveCorrectLength(),
            warningResourceKey,
            warningMessage,
            // Function to call after the popup has been 'aborted'.
            abortionCallback    = Shop.NameSelector.focusInput;
        
        if (!matchesExpression) {
            warningResourceKey  = 'error_pet_name_char';
        } else if (!hasValidLength) {
            warningResourceKey  = 'error_pet_name_length';
        }

        if ('undefined' !== typeof warningResourceKey) {
            /**
             * Display the warning popup if the warning resource key is not empty
             * (= when an error occurred).
             */
            warningMessage = Tools.Text.get(warningResourceKey);

            Tools.Popup.Presets.showErrorDialog(warningMessage, abortionCallback);
        }
    },

    show : function () {
        Library.get('nameSelector').show();
    },

    hide : function () {
        Library.get('nameSelector').hide();
    },

    resetSelector : function () {
        Shop.NameSelector.focusInput();
    },

    /**
     * Focusses the input field.
     * 
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    focusInput : function () {
        Library.get('selectedName').focus();
    }
};