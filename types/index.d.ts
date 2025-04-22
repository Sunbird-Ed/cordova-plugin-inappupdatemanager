// Type definitions for cordova-plugin-inappupdatemanager v1.0.0
// Project: https://www.npmjs.com/package/cordova-plugin-inappupdatemanager
// Definitions by: Philipp A. Mohrenweiser <https://github.com/phiamo>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
//
// Licensed under the MIT license.

interface CordovaPlugins {
    /**
     * cordova-plugin-inappupdatemanager interface
     */
    InAppUpdateManager: InAppUpdateManager.InAppUpdateManager;
}

/**
 * Keep the type global namespace clean by using a module
 */
declare module InAppUpdateManager {
    interface InAppUpdateManager {
        /**
         * @example cordova.plugins.InAppUpdateManager.checkForImmediateUpdate()
         */
        checkForImmediateUpdate(success: Function, error: Function): void;

        isUpdateAvailable(success: Function, error: Function): void;
    }
}