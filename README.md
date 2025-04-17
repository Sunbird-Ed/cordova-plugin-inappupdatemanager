# cordova-plugin-inappupdatemanager
A cordova plugin to support in-app updates in Android and IOS.

## Supported Platforms

### Android
 - devices running Android 5.0 (API level 21) or higher,
 - Play Core library 1.5.0 or higher

### IOS
 - since 11.3 

 ## Installation

 ```
 cordova plugin add https://github.com/phiamo/cordova-plugin-inappupdatemanager
 ```

 ## How to Use 

Vanilla JS
 ```
 //after device is ready
var fail = function (message) {    
    alert(message)
}
var success = function (data) {
        console.log("succes");
}
cordova.plugins.InAppUpdateManager.checkForImmediateUpdate( success, fail );
 ```

Typescript
TODO: @types

## Result

![screenshot](./screenshot/downloadplugin.gif)

_**If this plugin helps your project then don't forget to ⭐ star the repo.**_

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Credits
Initial credits go to Partha Roy whose repository and code from
https://github.com/iamparthaonline/cordova-in-app-update-android
was the basis to get this done