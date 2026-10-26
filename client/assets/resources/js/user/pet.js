User.Pet = {
    hasPet : false,

    getParameters : function () {
        return User.get('pet');
    },

    get : function (parameterName) {
        var parameters      = User.Pet.getParameters(),
            parameterValue  = parameters[parameterName];

        if ('undefined' === typeof parameterValue) {
            Tools.ErrorHandler.Events.onTypeUndefined('User.Pet.' + parameterName);
        };

        return parameterValue;
    },

    set : function (parameterName, parameterValue) {
        // Make sure the 'pet' parameter exists.
        if ('undefined' === typeof User.Parameters.pet) {
            User.Parameters.pet = {};
        }

        User.Parameters.pet[parameterName] = parameterValue;
    },

    updateParameters : function (parameters) {
        if ('undefined' !== typeof parameters.level) {
            User.Pet.setLevel(parameters.level);
        };

        if ('undefined' !== typeof parameters.fuel) {
            User.Pet.setFuel(parameters.fuel);
        };

        if ('undefined' !== typeof parameters.maxFuel) {
            User.Pet.setMaxFuel(parameters.maxFuel);
        };

        this.hasPet = true;
    },

    getLevel : function () {
        return User.Pet.get('level');
    },

    setLevel : function (level) {
        User.Pet.set('level', level);
    },

    getFuel : function () {
        return User.Pet.get('fuel');
    },

    setFuel : function (fuel) {
        User.Pet.set('fuel', fuel);
    },

    getMaxFuel : function () {
        return User.Pet.get('maxFuel');
    },

    setMaxFuel : function (maxFuel) {
        User.Pet.set('maxFuel', maxFuel);
    }
};