/**
 * Object to repeatedly call a function.
 * Decreases timeout milliseconds after first function call.
 * 
 * @author  Wolfgang Timme <w.timme@bigpoint.net>
 */
Tools.RepeatCaller = {
    Properties : {
        millisecondsToWaitBeforeActivation  : 500,
        timeout                             : null,
        numberOfFunctionCalls               : 0,
        functionToCall                      : null,
        isRunning                           : false
    },
    
    start : function (functionToCall) {
        if ('function' !== typeof functionToCall) {
            alert('RepeatCaller: functionToCall is not a function!');
        } else {
            Tools.RepeatCaller.Properties.isRunning = true;

            Tools.RepeatCaller.setNumberOfFunctionCalls(0);
            Tools.RepeatCaller.setFunctionToCall(functionToCall);
            
            Tools.RepeatCaller.performCall();
        }
    },
    
    stop : function () {
        Tools.RepeatCaller.Properties.isRunning = false;

        clearTimeout(Tools.RepeatCaller.Properties.timeout);
    },
    
    performCall : function () {
        var milliseconds = Tools.RepeatCaller.getMillisecondsBetweenFunctionCalls();

        if (Tools.RepeatCaller.isRunning()) {
            // Call the actuall function
            Tools.RepeatCaller.getFunctionToCall()();
            
            Tools.RepeatCaller.increaseNumberOfFunctionCalls();
            
            Tools.RepeatCaller.Properties.timeout = setTimeout(Tools.RepeatCaller.performCall, milliseconds);
        };
    },

    /**
     * Determines the number of milliseconds to wait between the function calls.
     * 
     * @param   void
     * @return  number
     * @author  Wolfgang Timme <w.timme@bigpoint.net>
     */
    getMillisecondsBetweenFunctionCalls : function () {
        var numberOfFunctionCalls   = Tools.RepeatCaller.getNumberOfFunctionCalls(),
            milliseconds;

        if (0 === numberOfFunctionCalls) {
            milliseconds    = Tools.RepeatCaller.Properties.millisecondsToWaitBeforeActivation;
        } else if (10 > numberOfFunctionCalls) {
            milliseconds    = 150;
        } else if (50 > numberOfFunctionCalls) {
            milliseconds    = 75;
        } else if (100 > numberOfFunctionCalls) {
            milliseconds    = 50;
        } else {
            milliseconds    = 25;
        };

        return milliseconds;
    },


    isRunning : function () {
        return Tools.RepeatCaller.Properties.isRunning;
    },
    
    increaseNumberOfFunctionCalls : function () {
        var numberOfFunctionCalls       = Tools.RepeatCaller.getNumberOfFunctionCalls(),
            newNumberOfFunctionCalls    = numberOfFunctionCalls + 1;
        
        Tools.RepeatCaller.setNumberOfFunctionCalls(newNumberOfFunctionCalls);
    },
    
    getNumberOfFunctionCalls : function () {
        return Tools.RepeatCaller.Properties.numberOfFunctionCalls;
    },
    
    setNumberOfFunctionCalls : function (newNumberOfFunctionCalls) {
        Tools.RepeatCaller.Properties.numberOfFunctionCalls = newNumberOfFunctionCalls;
    },
    
    getFunctionToCall : function () {
        return Tools.RepeatCaller.Properties.functionToCall;
    },
    
    setFunctionToCall : function (newFunctionToCall) {
        Tools.RepeatCaller.Properties.functionToCall = newFunctionToCall;
    }
};