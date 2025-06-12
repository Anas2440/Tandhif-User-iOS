//
//  CheckUpdate.swift
//  CheckApp



import Foundation
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
    var releaseNotes: String
}

class CheckUpdate: NSObject {

    static let shared = CheckUpdate()
    
 
  

    func checkVersion(finished: @escaping(_ result:Bool) -> Void) {
        
        
        if let currentVersion = self.getBundle(key: "CFBundleShortVersionString") {
            _ = getAppInfo { (info, error) in
               // print("releaseNotes",info?.releaseNotes)
                if let appStoreAppVersion = info?.version {
                    if let error = error {
                        print("error getting app store version: ", error)
                        finished(false)

                    }

                    let versionCompare = currentVersion.compare(appStoreAppVersion, options: .numeric)
                   
                    if versionCompare == .orderedSame {
                        print("Already on the last app version: ",currentVersion,appStoreAppVersion)
                        finished(false)
                    } else if versionCompare == .orderedAscending {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
                        
                        var force_update = false

                        if let notes = info?.releaseNotes.lowercased()
                        {
                            if notes.contains("force update")
                            {
                                force_update = true
                            }
                        }
                        
                        DispatchQueue.main.async {
                            let topController: UIViewController = (UIApplication.shared.windows.first?.rootViewController)!
                            topController.showAppUpdateAlert(Version: (info?.version)!, Force: force_update, AppURL: (info?.trackViewUrl)!, currentVersion: currentVersion)
                        }
                        finished(true)

                        
                    }
                    else if versionCompare == .orderedDescending {
                        // execute if current > appStore
                        
                        print("Already on the new app version: ",currentVersion)

                        finished(false)
                    }
                    
                    
                   
                }
                else
                {
                    finished(false)

                }
            }
        }
        
    }

    func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
    
      // You should pay attention on the country that your app is located, in my case I put Brazil */br/*
      // Você deve prestar atenção em que país o app está disponível, no meu caso eu coloquei Brasil */br/*
      
        guard let identifier = self.getBundle(key: "CFBundleIdentifier"),
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
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
                    guard let info = result.results.first else {
                        throw VersionError.invalidResponse
                    }

                    completion(info, nil)
                } catch {
                    completion(nil, error)
                }
            }
        
        task.resume()
        return task

    }

    func getBundle(key: String) -> String? {

        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2 - Add the file to a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        // Check if the variable on plist exists
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in 'Info.plist'.")
        }
        return value
    }
}

extension UIViewController {
    @objc func showAppUpdateAlert( Version : String,
                                   Force: Bool,
                                   AppURL: String,
                                   currentVersion : String) {
        guard let appName = CheckUpdate.shared.getBundle(key: "CFBundleName") else { return } //Bundle.appName()

        let alertTitle = "New Version (\(Version))"
        let alertMessage = " A new \(appName) version \(Version) update is available. Please update from the version \(currentVersion)"


        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)

        if !Force {
            let notNowButton = UIAlertAction(title: "Not now",
                                             style: .default) { (action:UIAlertAction) in
                NotificationEnum.newversionApp.postNotification()
            }
            alertController.addAction(notNowButton)
        }
        
        let updateButton = UIAlertAction(title: "Update",
                                         style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
               
            } else {
                UIApplication.shared.openURL(url)
            }
            
            NotificationEnum.checkversionApp.postNotification()

        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}


