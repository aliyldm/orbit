Shop.AmountSelector = {
    Properties : {
        maxAmount       : -1,
        selectedAmount  : 1,
        steps           : 1,
        boughtAmount    : 1
    },
    
    presets : {
        'five'      : 5,
        'ten'       : 10,
        'twenty'    : 20,
        'hundred'   : 100,
        'thousand'  : 1000
    },
    
    Initialize : function () {
        Shop.AmountSelector.fetchElements();
        Shop.AmountSelector.initializeEventListeners();
    },
    
    fetchElements : function () {
        var amountChooser   = jQuery('#amountSelector'),
            stepper         = amountChooser.find('#stepper');
        
        Library.set('amountChooser',            amountChooser);
        
        Library.set('amountPresets',            amountChooser.find('.amountPreset'));
        Library.set('amountPreset_five',        amountChooser.find('#five'));
        Library.set('amountPreset_ten',         amountChooser.find('#ten'));
        Library.set('amountPreset_twenty',      amountChooser.find('#twenty')),
        Library.set('amountPreset_hundred',     amountChooser.find('#hundred'));
        Library.set('amountPreset_thousand',    amountChooser.find('#thousand'));
        Library.set('amountPreset_max',         amountChooser.find('#max'));
        
        Library.set('stepper',                  stepper);
        Library.set('stepperControls',          stepper.find('.control'));
        Library.set('stepper_plus',             stepper.find('#plus'));
        Library.set('stepper_minus',            stepper.find('#minus'));
        Library.set('stepper_selectedAmount',   stepper.find('#selectedAmount'));
    },
    
    initializeEventListeners : function () {
        var amountPresets   = Library.get('amountPresets'),
            stepperControls = Library.get('stepperControls'),
            stepperPlus     = Library.get('stepper_plus'),
            stepperMinus    = Library.get('stepper_minus'),
            selectedAmount  = Library.get('stepper_selectedAmount');
        
        amountPresets.on('mouseover', Shop.AmountSelector.Events.onPresetMouseOver);
        amountPresets.on('mouseout',  Shop.AmountSelector.Events.onPresetMouseOut);
        amountPresets.on('mousedown', Shop.AmountSelector.Events.onPresetMouseDown);
        amountPresets.on('mouseup',   Shop.AmountSelector.Events.onPresetMouseUp);
        amountPresets.on('click',     Shop.AmountSelector.Events.onPresetClick);
        
        
        stepperControls.on('mouseover',   Shop.AmountSelector.Events.onStepperControlMouseOver);
        stepperControls.on('mouseout',    Shop.AmountSelector.Events.onStepperControlMouseOut);
        stepperControls.on('mousedown',   Shop.AmountSelector.Events.onStepperControlMouseDown);
        stepperControls.on('mouseup',     Shop.AmountSelector.Events.onStepperControlMouseUp);
        
        stepperPlus.on('mousedown',       Shop.AmountSelector.Events.onStepperPlusMouseDown);
        stepperPlus.on('mouseup',         Shop.AmountSelector.Events.onStepperPlusMouseUp);
        stepperMinus.on('mousedown',      Shop.AmountSelector.Events.onStepperMinusMouseDown);
        stepperMinus.on('mouseup',        Shop.AmountSelector.Events.onStepperMinusMouseUp);
        
        selectedAmount.on('blur', Shop.AmountSelector.Events.onSelectedAmountBlur);
        selectedAmount.on('keydown',  Shop.AmountSelector.Events.onSelectedAmountKeyDown);
        selectedAmount.on('keyup',  Shop.AmountSelector.Events.onSelectedAmountKeyUp);
    },

    show : function () {
        Library.get('amountChooser').show();
    },

    hide : function () {
        Library.get('amountChooser').hide();
    },
    
    getPresets : function () {
        return Shop.AmountSelector.presets;
    },
    
    getSelectedAmount : function () {
        return Shop.AmountSelector.Properties.selectedAmount;
    },

    getBoughtAmount : function () {
        return Shop.AmountSelector.Properties.boughtAmount;
    },
    
    setSelectedAmount : function (newAmount) {
        Shop.AmountSelector.Properties.selectedAmount = newAmount;
    },

    setBoughtAmount : function (newAmount) {
        Shop.AmountSelector.Properties.boughtAmount = newAmount;
    },
    
    getMaxAmount : function () {
        return Shop.AmountSelector.Properties.maxAmount;
    },
    
    setMaxAmount : function (newMaxAmount) {
        Shop.AmountSelector.Properties.maxAmount = newMaxAmount;
    },
    
    isValidAmount : function (amountToCheck) {
        return 0 < amountToCheck && Shop.AmountSelector.getMaxAmount() >= amountToCheck;
    },

    getSteps : function () {
        return Shop.AmountSelector.Properties.steps;
    },

    setSteps : function (steps) {
        Shop.AmountSelector.Properties.steps = steps;
    },
    
    updateButtonStates : function () {
        var presetButtons   = Library.get('amountPresets'),
            maxButton       = Library.get('amountPreset_max'),
            presets         = Shop.AmountSelector.getPresets(),
            stepperControls = Library.get('stepperControls'),
            buttonLibraryKey,
            button;
        
        if (Shop.Item.isAmountSetable()) {
            jQuery.each(presets, function (buttonId, presetValue) {
                buttonLibraryKey    = 'amountPreset_' + buttonId;
                button              = Library.get(buttonLibraryKey);
                
                if (Shop.AmountSelector.isValidAmount(presetValue)) {
                    button.addClass('enabled');
                } else {
                    button.removeClass('enabled');
                }
            });
            
            if (Shop.AmountSelector.getMaxAmount() > 0) {
                maxButton.addClass('enabled');
                stepperControls.addClass('enabled');
            } else {
                maxButton.removeClass('enabled');
                stepperControls.removeClass('enabled');
            }
        } else {
            presetButtons.removeClass('enabled');
            stepperControls.removeClass('enabled');
        }
        
        Shop.AmountSelector.updateStepperButtonStates();
    },
    
    updateStepperButtonStates : function () {
        var stepperControls = Library.get('stepperControls'),
            btnPlus         = Library.get('stepper_plus'),
            btnMinus        = Library.get('stepper_minus');
        
        if (Shop.Item.isAmountSetable()) {
            if (Shop.AmountSelector.getMaxAmount() > Shop.AmountSelector.getSelectedAmount()) {
                btnPlus.addClass('enabled');
            } else {
                btnPlus.removeClass('enabled');
            }
            
            if (Shop.AmountSelector.getSelectedAmount() > 1) {
                btnMinus.addClass('enabled');
            } else {
                btnMinus.removeClass('enabled');
            }
        } else {
            stepperControls.removeClass('enabled');
        }
    },
    
    updateSelectedAmount : function (newAmount, overrideSetable) {
        var override    = ('undefined' === typeof overrideSetable) ? false : true,
            setable     = Shop.Item.isAmountSetable() || override;

        // Set amount to 1 if the specified amount is invalid.
        if (!Shop.AmountSelector.isValidAmount(newAmount)) {
            // Show the unit price even when balance cannot cover one item.
            newAmount = 1;
        }

        if (setable) {
            Shop.AmountSelector.setSelectedAmount(newAmount);
            Library.get('stepper_selectedAmount').val(newAmount);
            Shop.AmountSelector.updateStepperButtonStates();

            Shop.Item.updatePrice();
        }
    },
    
    /**
     * Used to get the preset's value from its id.
     * 
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getAmountByPresetId : function (presetId) {
        var presets = Shop.AmountSelector.getPresets(),
            amount;
        
        if ('max' === presetId) {
            amount = Shop.AmountSelector.getMaxAmount();
        } else if ('undefined' === typeof presets[presetId]) {
            alert('Error: Value for preset "' + presetId + '" not found!');
        } else {
            amount = presets[presetId];
        }
        
        return amount;
    },
    
    resetSelector : function () {
        var calculatedMaxAmount = Shop.Item.getCalculatedMaxAmount();
        // Recorded portal data uses maxAmount=0 for unlimited equipment.
        // Explicit dailyLimitRemaining=0 is the separate exhausted-limit case.
        var limit = Number(Shop.Item.getMaxAmount()),
            dailyRemaining = Shop.Item.getDailyLimitRemaining(),
            newMaxAmount = limit > 0 ? Math.min(limit, calculatedMaxAmount) : calculatedMaxAmount;
        if (typeof dailyRemaining !== 'undefined' && dailyRemaining !== null) {
            newMaxAmount = Math.min(newMaxAmount, Math.max(0, Number(dailyRemaining)));
        }

        var
            steps           = Shop.AmountSelector.getSteps(),
            initialAmount   = steps;

        Shop.AmountSelector.setMaxAmount(newMaxAmount);
        Shop.AmountSelector.setSteps(steps);
        Shop.AmountSelector.updateSelectedAmount(initialAmount, true);
        Shop.AmountSelector.updateButtonStates();
        Shop.Item.updatePrice();
    },
    
    increaseAmount : function () {
        var selectedAmount  = Shop.AmountSelector.getSelectedAmount(),
            steps           = Shop.AmountSelector.getSteps(),
            newAmount       = selectedAmount + steps;

        if (Shop.AmountSelector.isValidAmount(newAmount)) {
            Shop.AmountSelector.updateSelectedAmount(newAmount);
        }
    },
    
    decreaseAmount : function () {
        var selectedAmount  = Shop.AmountSelector.getSelectedAmount(),
            steps           = Shop.AmountSelector.getSteps(),
            newAmount       = selectedAmount - steps;
        
        Shop.AmountSelector.updateSelectedAmount(newAmount);
    },
    
    Events : {
        onPresetMouseOver : function (event) {
            jQuery(this).addClass('mouseOver');
        },
        
        onPresetMouseOut : function (event) {
            jQuery(this).removeClass('mouseDown').removeClass('mouseOver');
        },
        
        onPresetMouseDown : function (event) {            
            jQuery(this).removeClass('mouseOver').addClass('mouseDown');
        },
        
        onPresetMouseUp : function (event) {
            jQuery(this).removeClass('mouseDown').addClass('mouseOver');
        },
        
        onPresetClick : function (event) {
            var btnPreset       = jQuery(this),
                presetId        = btnPreset.attr('id'),
                isEnabled       = btnPreset.hasClass('enabled'),
                presetAmount    = Shop.AmountSelector.getAmountByPresetId(presetId);
            
            if (isEnabled) {
                Shop.AmountSelector.updateSelectedAmount(presetAmount);

                // Focus the 'selectedAmount' input field.
                Library.get('stepper_selectedAmount').focus();
            };
        },
        
        /**
         * Stepper
         */
        onStepperControlMouseOver : function (event) {
            jQuery(this).addClass('mouseOver');
        },
        
        onStepperControlMouseOut : function (event) {
            jQuery(this).removeClass('mouseDown').removeClass('mouseOver');

            // Stop RepeatCaller
            Tools.RepeatCaller.stop();
        },
        
        onStepperControlMouseDown : function (event) {
            jQuery(this).removeClass('mouseOver').addClass('mouseDown');
        },
        
        onStepperControlMouseUp : function (event) {
            jQuery(this).removeClass('mouseDown').addClass('mouseOver');

            // Focus the 'selectedAmount' input field.
            Library.get('stepper_selectedAmount').focus();
        },
        
        onStepperPlusMouseDown : function (event) {
            var functionToCall = Shop.AmountSelector.increaseAmount;
            
            Tools.RepeatCaller.start(functionToCall);
        },
        
        onStepperPlusMouseUp : function (event) {
            Tools.RepeatCaller.stop();
        },
        
        onStepperMinusMouseDown : function (event) {
            var functionToCall = Shop.AmountSelector.decreaseAmount;
            
            Tools.RepeatCaller.start(functionToCall);
        },
        
        onStepperMinusMouseUp : function (event) {
            Tools.RepeatCaller.stop();
        },
        
        onSelectedAmountBlur : function (event) {
            var selectedAmountInput = jQuery(this),
                enteredValue        = selectedAmountInput.val(),
                enteredValueAsInt   = parseInt(enteredValue),
                isSetable           = Shop.Item.isAmountSetable(),
                isNumeric           = Tools.isNumeric(enteredValue),
                isValidAmount       = Shop.AmountSelector.isValidAmount(enteredValueAsInt),
                maxAmount           = Shop.AmountSelector.getMaxAmount(),
                newAmount           = 1;

            if (isSetable && isNumeric) {
                if (isValidAmount) {
                    newAmount   = enteredValueAsInt;
                } else if (maxAmount < enteredValueAsInt) {
                    newAmount   = maxAmount;
                }
            }
            
            Shop.AmountSelector.updateSelectedAmount(newAmount, true);
        },

        /**
         * Is called when the 'selectedAmount' input is focused and the user presses
         * a key down. Starts the Tools.RepeatCaller depending on which button
         * the user presses.
         * 
         * @param   object
         * @return  void
         * @author  Wolfgang Timme <w.timme@bigpoint.net>
         */
        onSelectedAmountKeyDown : function (event) {
            var functionToCall;

            if (107 === event.keyCode) {
                // +
                functionToCall = Shop.AmountSelector.increaseAmount;
            } else if (109 === event.keyCode) {
                // -
                functionToCall = Shop.AmountSelector.decreaseAmount;
            };

            if ('function' === typeof functionToCall) {
                if (!Tools.RepeatCaller.isRunning()) {
                    Tools.RepeatCaller.start(functionToCall);
                };

                event.preventDefault();
            };
        },

        onSelectedAmountKeyUp : function (event) {
            Tools.RepeatCaller.stop();
        }
    }
};
