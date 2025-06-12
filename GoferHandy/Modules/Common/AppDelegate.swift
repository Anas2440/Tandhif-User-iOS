/**
 * AppDelegate.swift
 *
 * @package Gofer
 * @author Trioangle Product Team
 *
 * @link http://trioangle.com
 */

import UIKit
import SocialLoginsIntegration
import PaymentHelper
import GoogleMaps
import UserNotifications
import Firebase
//import FirebaseInstanceID
import FirebaseMessaging
import CoreData
import BackgroundTasks
import StripeApplePay
 

@UIApplicationMain
class AppDelegate: UIResponder {
    
    var notificationJSOS:JSON?
    var window: UIWindow?
    var isFirstTime : Bool = false
    let userDefaults = UserDefaults.standard
    var isMainMap : Bool = false
    var paymentMethod = ""
    var iswallect = ""
    var option = ""
    var amount = ""
    var locationHandler : LocationHandlerProtocol? = LocationHandler.default()
    var nSelectedIndex : Int = 0
    let center = UNUserNotificationCenter.current()
    //MARK: - PushNotification Manager Declaration
    var pushManager : PushNotificationManager!
    
    fileprivate var backGroundThread : UIBackgroundTaskIdentifier = .invalid
    // MARK Create a FBSDK
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GoferHandy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                /*var tripCache = TripCache()
                 tripCache.removeTripDataFromLocale(UserDefaults.value(for: .cache_location_trip_id) ?? "")*/
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
}

// MARK: - Application Delegate Handling
extension AppDelegate : UIApplicationDelegate {
    //MAKR: When a app is Launch to front in mobile
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        FirebaseApp.configure()
        StripeAPI.defaultPublishableKey = "pk_test_51MtSMPEEorQv8b5cZZRVeocpafOH7wpZlu5ob86RsQIadBi57fbeB0k7RGJhXpx31nTiYR5A6oXKKF4I7wTzIMoX00oV1xD140"
        
        //Thread.sleep(forTimeInterval: 5.0)
        
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.trioangle.goferhandy.refresh",
                                            using: .global()) { (task) in
                print("My backgroundTask is executed NOW!")
                task.expirationHandler = {
                    task.setTaskCompleted(success: true)
                }
            }
        }
        let pre = Locale.preferredLanguages[0]
        _ = pre.components(separatedBy: "-")
        
        if let options = launchOptions,
           let jsons = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            self.notificationJSOS = jsons
            self.perform(#selector(self.didReceiveNotificationHandler), with: nil, afterDelay: 1)
        }
        
        //PUSHNOTIFICATION Manager
        DispatchQueue.main.async {
            self.pushManager = PushNotificationManager(application)
            self.initPushNotification()
        }
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        UIApplication.shared.applicationIconBadgeNumber = 0;
        SocialLoginsHandler.shared.handleFacebookDidFinish(application: application,
                                                           options: launchOptions)
        UIApplication.shared.isIdleTimerDisabled = true
        //background notification
        application.beginBackgroundTask(withName: "showNotification",
                                        expirationHandler: nil)
        application.setMinimumBackgroundFetchInterval(1800)
        self.initModules()
        //        registerForRemoteNotification()
        self.makeSplashView(isFirstTime: true)
        self.updateLanguage()// Update language and initialize paypal;
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                     sourceApplication: String,
                     annotation: AnyObject?) -> Bool {
        if let scheme = url.scheme,
           scheme.localizedCaseInsensitiveCompare(RideriTunes().appName) == .orderedSame { return true }
        if SocialLoginsHandler.shared.handleGoogle(url: url as URL) {return true}
        if SocialLoginsHandler.shared.handleFacebook(application: application,
                                                     url: url as URL,
                                                     sourceApplication: sourceApplication,
                                                     annotation: annotation ?? "0") { return true }
        return true
    }
    
    internal func application(_ application: UIApplication,
                              open url: URL,
                              sourceApplication: String?,
                              annotation: Any) -> Bool {
        let urlOpen = url.absoluteString
        var version = Bundle.main.infoDictionary?["FacebookAppID"] as? String
        version = String(format:"fb%@",version!)
        if StripeHandler.isStripeHandleURL(url){
            return true
        } else if (urlOpen as NSString).range(of:version!).location != NSNotFound {
            return SocialLoginsHandler.shared.handleFacebook(application: application,
                                                             url: url,
                                                             sourceApplication: sourceApplication,
                                                             annotation: annotation)
        } else {
            return SocialLoginsHandler.shared.handleGoogle(url: url)
        }
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // fetch data from internet now
        if let trip_id : Int = UserDefaults.value(for: .current_trip_id) {
            ChatInteractor.instance.initialize(withTrip: trip_id.description,
                                               type: .u2d)
            ChatInteractor.instance.observeTripChat(true,
                                                    view: nil)
        }
    }
    
    //MARK: Social login KEYS update
    @available(iOS 9.0, *)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let urlOpen = url.absoluteString
        var version = Bundle.main.infoDictionary?["FacebookAppID"] as? String
        version = String(format:"fb%@",version!)
        if let scheme = url.scheme,
           scheme.localizedCaseInsensitiveCompare(RideriTunes().appName) == .orderedSame { return true }
        if BrainTreeHandler.isBrainTreeHandleURL(url, options: options) {
            return true
        } else if StripeHandler.isStripeHandleURL(url) {
            return true
        } else if (urlOpen as NSString).range(of:version!).location != NSNotFound {
            return SocialLoginsHandler.shared.handleFacebookOptions(application: app,
                                                                    url: url,
                                                                    options: options)
        } else {
            return SocialLoginsHandler.shared.handleGoogle(url: url)
        }
    }
    
    private
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                return StripeHandler.isStripeHandleURL(url)
            }
        }
        return false
    }
    
    // MARK: Application Life cycle delegate methods
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        self.pushManager.stopObservingUser()

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
        _ = PipeLine.fireEvent(withKey: PipeLineKey.app_entered_foreground)
        
      // Force Location Handling When User try to stop when in the trip And setting work location
      // Gofer Splitup Start
      let topmostController = application.topViewController()
        // Handy Splitup Start
        switch AppWebConstants.businessType {
        case .Services:
            if topmostController?.isKind(of: HandyRouteVC.self) ?? false || topmostController?.isKind(of: HandySetLocationVC.self) ?? false || topmostController?.isKind(of: HandyHomeVC.self) ?? false {
                locationHandler?.startListening(toLocationChanges: true)
            }else{
                print("Nothing To Show")
            }
        default:
            break
        }
        // Gofer Splitup end
        // Handy Splitup End
       // self.pushManager.startObservingUser()

      
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let pre = Locale.preferredLanguages[0]
        _ = pre.components(separatedBy: "-")
        
        self.updateLanguage()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
        SocialLoginsHandler.shared.activateFacebookActivities()
        NotificationCenter.default.post(name: .ChatRefresh, object: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CallManager.instance.deinitialize()
        self.pushManager.stopObservingUser()
        self.backGroundThread = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let welf = self,welf.backGroundThread == .invalid else{ return }
            CallManager.instance.deinitialize()
            welf.terminateBackgroundThread()
        }
        assert(backGroundThread != .invalid)
    }
    
    // MARK: - Remote Notification Methods // <= iOS 9.x
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        CallManager.instance.registerForPushNotificaiton(token: deviceToken,
                                                         forApplicaiton: application)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
        debug(print: error)
    }
}

//MARK: - Local Functions
extension AppDelegate {
    
    func initModules() {
//        if UserDefaults.isNull(for: .default_language_option){
//            Language.default.saveLanguage()
//        }666
        GMSServices.provideAPIKey("AIzaSyCo3sNydTaMlsMFkKyOpvXx25D3TcmHubM"/*GoogleAPIKey*/)
        NetworkManager.instance.observeReachability(true)
        let userCurrency = userDefaults.value(forKey: "user_currency_symbol_org") as? String
        if (userCurrency == nil || userCurrency == "")
        {
            userDefaults.set("", forKey: "user_currency_symbol_org")
        }
        let userdialcode = userDefaults.value(forKey: "dial_code") as? String
        if (userdialcode == nil || userdialcode == "")
        {
            userDefaults.set("", forKey: "dial_code")
        }
        let userCountryCode = userDefaults.value(forKey: "user_country_code") as? String
        if (userCountryCode == nil || userCountryCode == "")
        {
            userDefaults.set("", forKey: "user_country_code")
        }
        
        let userDeviceToken = userDefaults.value(forKey: "device_token") as? String
        if (userDeviceToken == nil || userDeviceToken == "")
        {
            userDefaults.set("", forKey: "device_token")
        }
//        PayPalHandler.initPaypalModule()
        userDefaults.synchronize()
        guard let stripe : String = UserDefaults.value(for: .stripe_publish_key) else { return }
        StripeHandler.initStripeModule(key: stripe)
        
        //Listen to firebase chat if user is in ride !
     
    }
    
    
    // MARK:  Display Splash Screen when startup app
    func makeSplashView(isFirstTime:Bool) {
        let splashView = SplashVC.initWithStory()
        splashView.isFirstTimeLaunch = isFirstTime
        window!.rootViewController = splashView
        window!.makeKeyAndVisible()    }
    
    
    func initPushNotification() {
        DispatchQueue.main.async {
            self.pushManager.registerForRemoteNotification()
        }
    }
    
    
    
    // MARK: for killed state pushnotification Handler
    @objc
    func didReceiveNotificationHandler() {
        if let  dict = self.notificationJSOS {
            self.pushManager.handleHandyPushNotifications(userInfo: dict,
                                                          isFrom: "didReceive")
            self.pushManager.handleCommonPushNotification(userInfo: dict,
                                                          generateLocalNotification: false)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.didReceiveNotificationHandler()
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - Local Notification Creation
extension AppDelegate {
    func scheduleNotification(title: String,
                              message: String) {
        let sender_name = UserDefaults.standard.string(forKey: "trip_driver_name") ?? "driver"
        let content = UNMutableNotificationContent()
        content.title = sender_name
        content.body = message
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let identifier = "Chat Notification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                debug(print: error)
            }
        }
    }
}


//MARK: - Toast Creation
extension AppDelegate {
    /// Display Toast Message
    func createToastMessage(_ strMessage:String,
                            bgColor: UIColor = .PrimaryColor,
                            textColor: UIColor = .PrimaryTextColor) {
        if #available(iOS 13.0, *) {
            guard let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive || $0.activationState == .background || $0.activationState == .foregroundInactive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first else { return }
            let lblMessage=UILabel(frame: CGRect(x: 0,
                                                 y: keyWindow.frame.height + 70,
                                                 width: keyWindow.frame.size.width,
                                                 height: 70))
            lblMessage.tag = 500
            lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : CommonError.connection.localizedDescription
            lblMessage.textColor = ToastTheme.MessageText.color
            lblMessage.backgroundColor = ToastTheme.Background.color
            lblMessage.font = ToastTheme.MessageText.font
            lblMessage.textAlignment = NSTextAlignment.center
            lblMessage.numberOfLines = 0
            lblMessage.layer.shadowColor = ToastTheme.Background.color.cgColor;
            lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
            lblMessage.layer.shadowOpacity = 0.5;
            lblMessage.layer.shadowRadius = 1.0;
            moveLabelToYposition(lblMessage,
                                 win: keyWindow)
            keyWindow.addSubview(lblMessage)
        } else {
            guard let window = UIApplication.shared.keyWindow else{return}
            let lblMessage=UILabel(frame: CGRect(x: 0,
                                                 y: window.frame.size.height + 70,
                                                 width: window.frame.size.width,
                                                 height: 70))
            lblMessage.tag = 500
            lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : CommonError.connection.localizedDescription
            lblMessage.textColor = ToastTheme.MessageText.color
            lblMessage.backgroundColor = ToastTheme.Background.color
            lblMessage.font = ToastTheme.MessageText.font
            lblMessage.textAlignment = NSTextAlignment.center
            lblMessage.numberOfLines = 0
            lblMessage.layer.shadowColor = ToastTheme.Background.color.cgColor;
            lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
            lblMessage.layer.shadowOpacity = 0.5;
            lblMessage.layer.shadowRadius = 1.0;
            moveLabelToYposition(lblMessage,
                                 win: window)
            window.addSubview(lblMessage)
        }
    }
    
    func createToastMessageForAlamofire(_ strMessage : String,
                                        bgColor: UIColor = .PrimaryColor,
                                        textColor: UIColor = .PrimaryTextColor,
                                        forView:UIView) {
        let lblMessage=UILabel(frame: CGRect(x: 0,
                                             y: (forView.frame.size.height)+70,
                                             width: (forView.frame.size.width),
                                             height: 70))
        lblMessage.tag = 500
        lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : CommonError.connection.localizedDescription
        lblMessage.textColor = ToastTheme.MessageText.color
        lblMessage.backgroundColor = ToastTheme.Background.color
        lblMessage.font = ToastTheme.MessageText.font
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
        lblMessage.layer.shadowColor = ToastTheme.Background.color.cgColor;
        lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
        lblMessage.layer.shadowOpacity = 0.5;
        lblMessage.layer.shadowRadius = 1.0;
        downTheToast(lblView: lblMessage,
                     forView: forView)
        UIApplication.shared.keyWindow?.addSubview(lblMessage)
    }
    
    func downTheToast(lblView:UILabel,
                      forView:UIView) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut ,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (forView.frame.size.height)-70,
                                   width: (forView.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            self.closeTheToast(lblView,
                               forView: forView)
        })
    }
    
    func closeTheToast(_ lblView:UILabel,
                       forView:UIView) {
        UIView.animate(withDuration: 0.3,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (forView.frame.size.height)+70,
                                   width: (forView.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            lblView.removeFromSuperview()
        })
    }
    /// Show the Animation
    func moveLabelToYposition(_ lblView:UILabel,
                              win: UIWindow) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (win.frame.size.height)-70,
                                   width: win.frame.size.width,
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            self.onCloseAnimation(lblView,
                                  win: win)
        })
    }
    // MARK: - close the Animation
    func onCloseAnimation(_ lblView:UILabel,
                          win: UIWindow) {
        UIView.animate(withDuration: 0.3,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (win.frame.size.height)+70,
                                   width: (win.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            lblView.removeFromSuperview()
        })
    }
}

// MARK: - Navigation When App Open
extension AppDelegate {
    // Setting Main Root ViewController
    func onSetRootViewController(viewCtrl:UIViewController?,
                                 caller : String = #function) {
        debug(print: caller)
        let getMainPage =  userDefaults.object(forKey: "getmainpage") as? NSString
        UIView.appearance().semanticContentAttribute =  isRTLLanguage ? .forceRightToLeft : .forceLeftToRight
        switch AppWebConstants.businessType {
        case .Services:
            self.setHandyHomeScreen()
        default:
            break
        }
        PushNotificationManager.shared?.startObservingUser()
//        if getMainPage == "rider" {
//
//        } else {
//            self.showAuthenticationScreen()
//        }
    }
    
    // MARK: Goto Main View after user loggedin
   
    func setHandyHomeScreen() {
        let handyHomeVC = HandyHomeVC.initWithStory()
        handyHomeVC.isSingleCategory = AppWebConstants.isSingleCatagoryApplication
        if AppWebConstants.isSingleCatagoryApplication {
            handyHomeVC.selectCatagoryID = AppWebConstants.isSingleCatagoryID
        }
        let navigationController = UINavigationController(rootViewController: handyHomeVC)
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController;
        window?.makeKeyAndVisible()
    }
    
    // MARK: Display Login View
    func showAuthenticationScreen() {
        let authenticationVC  = WelcomeVC.initWithStory()
        let navigationController = UINavigationController(rootViewController: authenticationVC)
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController;
        window?.makeKeyAndVisible()
    }
   
}

// MARK: - Device Token and language update
extension AppDelegate {
    func sendDeviceTokenToServer(strToken: String) {
        var devicetoken = strToken
        if devicetoken.isEmpty {
            devicetoken = UserDefaults.standard.string(forKey: "access_token") ?? ""
        }
        Constants().STOREVALUE(value: strToken, keyname: "device_token")
        //        guard (self.userDefaults.value(forKey: "access_token") as? String) != nil else { return }
        guard !devicetoken.isEmpty else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.tokenRefreshNotification()
            }
            return
        }
        if !Constants().GETVALUE(keyname: "access_token").isEmpty {
            var dicts = JSON()
            dicts["token"] = Constants().GETVALUE(keyname: "access_token")
            dicts["device_id"] = String(format:"%@",strToken)
            ConnectionHandler.shared
                .getRequest(
                    for: APIEnums.updateDeviceToken,
                       params: dicts
                ).responseDecode(to: CommonModel.self, { response in
                    if !response.isSuccess {
                        self.tokenRefreshNotification()
                        debug(print: response.statusMessage)
                    }
                })
                .responseFailure({ (error) in
                    self.tokenRefreshNotification()
                    debug(print: error)
                })
        }
        
    }
    
    func updateLanguage() {
        let token = Constants().GETVALUE(keyname: "access_token")
        guard !token.isEmpty else{return}
        var dicts = JSON()
        dicts["token"] = token
        if let language : String = UserDefaults.value(for: .default_language_option) {
            dicts["language"] = language
        }
        ConnectionHandler.shared
            .getRequest(
                for: APIEnums.updateLanguage,
                   params: dicts)
            .responseDecode(to: CommonModel.self, { (response) in
                if !response.isSuccess {
                    debug(print: response.statusMessage)
                }
            })
            .responseFailure({ (error) in
                debug(print: error)
            })
        DispatchQueue.main.async {
            guard let stripe : String = UserDefaults.value(for: .stripe_publish_key) else { return }
            StripeHandler.initStripeModule(key: stripe)
        }
    }
    // Enable hockey app sdk for tracking crashes

    // MARK: Get Token Refersh
    func tokenRefreshNotification() {
        // NOTE: It can be nil here
    }
    // Get FCM Token
    func connectToFcm() {
    }
}

//MARK: - Background task
extension AppDelegate{
    
    fileprivate func terminateBackgroundThread() {
        print("Background task ended.")
        guard backGroundThread != .invalid else{return}
        UIApplication.shared.endBackgroundTask(backGroundThread)
        self.backGroundThread = .invalid
    }

    
}
extension AppDelegate{
    static var shared : AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
}


