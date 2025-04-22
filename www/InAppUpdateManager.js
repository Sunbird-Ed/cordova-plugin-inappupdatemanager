var exec = require('cordova/exec');

exports.checkForImmediateUpdate = function( success, error ) {
    exec(success, error, "InAppUpdateManager", "immediate");
};

exports.isUpdateAvailable = function( success, error) {
exec(success, error, "InAppUpdateManager", "isUpdateAvailable");
}