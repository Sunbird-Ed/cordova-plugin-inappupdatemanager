import UIKit

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}

@objc(InAppUpdateManager) class InAppUpdateManager : CDVPlugin {
    @objc(immediate:)
    func immediate(command: CDVInvokedUrlCommand) {
        let pluginResult = CDVPluginResult(
          status: CDVCommandStatus_OK
        )
        
        DispatchQueue.global().async {
            self.checkVersion(force: false)
        }
        
        
        self.commandDelegate!.send(
          pluginResult,
          callbackId: command.callbackId
        )
    }
    
    private  func checkVersion(force: Bool) {
        let info = Bundle.main.infoDictionary
        if let currentVersion = info?["CFBundleShortVersionString"] as? String {
            _ = getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version{
                    if let error = error {
                        print("error getting app store version: ", error)
                    } else if appStoreAppVersion == currentVersion {
                        print("Already on the last app version: ",currentVersion)
                    } else if appStoreAppVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ", currentVersion)
                        DispatchQueue.main.async {
                            let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                            topController.showAppUpdateAlert(Version: (info?.version)!, Force: force, AppURL: (info?.trackViewUrl)!)
                        }
                    }
                    else {
                        print("Lower Version Online: \(appStoreAppVersion) ... probabaly we currently develop a new one?", currentVersion)
                    }
                }
            }
        }
    }

    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }

                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                guard let info = result.results.first else { throw VersionError.invalidResponse }

                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}

extension UIViewController {
    @objc fileprivate func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        let appName = Bundle.appName()
        print("Going to URL", AppURL)

        let alertTitle = "New Version"
        let alertMessage = "\(appName) Version \(Version) is available on AppStore."

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        if !Force {
            let notNowButton = UIAlertAction(title: "Not Now", style: .default)
            alertController.addAction(notNowButton)
        }

        let updateButton = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}
