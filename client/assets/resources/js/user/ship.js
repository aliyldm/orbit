User.Ship = {
    getParameters : function () {
        return User.get('ship');
    },

    get : function (parameterName) {
        var parameters      = User.Ship.getParameters(),
            parameterValue  = parameters[parameterName];

        if ('undefined' === typeof parameterValue) {
            Tools.ErrorHandler.onTypeUndefined('User.Ship.' + parameterName);
        };

        return parameterValue;
    },

    set : function (parameterName, parameterValue) {
        User.Parameters.ship[parameterName] = parameterValue;
    },

    updateParameters : function (parameters) {
        if ('undefined' !== typeof parameters.laserAmmunitionSpace) {
            User.Ship.setLaserAmmunitionSpace(parameters.laserAmmunitionSpace);
        };

        if ('undefined' !== typeof parameters.rocketSpace) {
            User.Ship.setRocketSpace(parameters.rocketSpace);
        };
    },

    getLaserAmmunitionSpace : function () {
        return User.Ship.get('laserAmmunitionSpace');
    },

    setLaserAmmunitionSpace : function (newValue) {
        User.Ship.set('laserAmmunitionSpace', newValue);
    },

    getRocketSpace : function () {
        return User.Ship.get('rocketSpace');
    },

    setRocketSpace : function (newValue) {
        User.Ship.set('rocketSpace', newValue);
    }
};