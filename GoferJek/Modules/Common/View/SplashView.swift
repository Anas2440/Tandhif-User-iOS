    //
    //  SplashView.swift
    //  GoferHandy
    //
    //  Created by trioangle on 13/07/21.
    //  Copyright © 2021 Vignesh Palanivel. All rights reserved.
    //

import Foundation
import UIKit
import FirebaseCrashlytics
import AVKit
import AVFoundation

class SplashView: BaseView {
    
        //----------------------------------------------
        // MARK: - Outlets
        //----------------------------------------------
    
    @IBOutlet weak var appLogoIV: UIImageView!
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var imgAppIcon: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bgIV: UIImageView!
    @IBOutlet weak var viewSplashVideo: UIView!
    @IBOutlet weak var oldViewWithBG: UIView!
    
        //----------------------------------------------
        // MARK: - Local Variables
        //----------------------------------------------
    
    var splashVC : SplashVC!
    var timer : Timer?
    var hasLaunchedAlready : Bool = false
    var pushManager: PushNotificationManager!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var languageLoaded : Bool {
            //languages
        guard let lang : String = UserDefaults.value(for: .default_language_option),
              isLanguageLoaded else {
            return false
        }
        return lang == currentLanguage.key
    }
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
        //----------------------------------------------
        // MARK: - View Controller Override Functions
        //----------------------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.splashVC = baseVC as? SplashVC
        self.bgIV.image = UIImage(named: "splash_bg")
        self.appLogoIV.isHidden = true
        DispatchQueue.main.async {
            self.playSplashVideo()
        }
        if self.languageLoaded { //language is ready
            DispatchQueue.main.async {
                self.initView()
            }
        } else { //fetch lanugage
            self.splashVC.wsToFetchLanguage()
        }
        if crashApplicationOnSplash {
            Crashlytics.crashlytics()
        }
        self.initlayer()
        self.darkModeChange()
    }
    override
    func darkModeChange() {
        super.darkModeChange()
    }
    
        //----------------------------------------------
        // MARK: - Initalisation Functions
        //----------------------------------------------
    
    func initlayer() {
            //  self.appLogoIV.cornerRadius = 30
        self.appLogoIV.clipsToBounds = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initView() {
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
                    //TRVicky
                self.splashVC.commonAlert.setupAlert(alert: LangCommon.message,
                                                     alertDescription: LangCommon.enPushNotifyLogin,
                                                     okAction: LangCommon.ok)
                self.splashVC.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                    AppDelegate.shared.pushManager.registerForRemoteNotification()
                }
            }
        }
        self.timer = Timer.scheduledTimer(timeInterval:1.0,
                                          target: self,
                                          selector: #selector(self.onSetRootViewController),
                                          userInfo: nil,
                                          repeats: true)
        
        _ = PipeLine.createEvent(key: PipeLineKey.app_entered_foreground) {
            self.splashVC.onStart()
        }
    }
    
        //----------------------------------------------
        // MARK: - Local Functions
        //----------------------------------------------
    
    func shouldForceUpdate(_ should : ForceUpdate) {
        switch should {
            case .forceUpdate:
                self.splashVC.presentAlertWithTitle(title: LangCommon.newVersAvail,
                                                    message: LangCommon.updateOurApp,
                                                    options: LangCommon.visitAppStore) { (option) in
                    self.goToAppStore()}
            case .noUpdate:
                self.moveOn()
            case .skipUpdate:
                self.splashVC.commonAlert.setupAlert(alert: LangCommon.newVersAvail,
                                                     alertDescription: LangCommon.forceUpdate,
                                                     okAction: LangCommon.update,
                                                     cancelAction: LangCommon.skip,
                                                     userImage: nil)
                self.splashVC.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                        // When Update Option Clicked
                    self.goToAppStore()
                }
                self.splashVC.commonAlert.addAdditionalCancelAction {
                        // When Skip Option Clicked
                    self.moveOn()
                }
        }
    }
    
        //-----------------------------------------------------------
        // MARK: -  Setting root view controller after splash showed
        //-----------------------------------------------------------
    
    @objc
    func onSetRootViewController() {
        if !isSimulator {
            guard let _ = UserDefaults.standard.value(forKey: USER_DEVICE_TOKEN) else {
                self.appDelegate.pushManager.registerForRemoteNotification()
                self.oldViewWithBG.isHidden = false
                self.viewSplashVideo.isHidden = true
                return
            }
        }
        self.timer?.invalidate()
        self.splashVC.onStart()
    }
    
        //-----------------------------------------------------------
        // MARK: - Skip the Update
        //-----------------------------------------------------------
    
    func moveOn() {
        let getMainPage =  userDefaults.object(forKey: "getmainpage") as? NSString
        UIView.appearance().semanticContentAttribute =  isRTLLanguage ? .forceRightToLeft : .forceLeftToRight
        if getMainPage == "rider" {
            guard !self.hasLaunchedAlready else {return}
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.onSetRootViewController(viewCtrl:self.splashVC)
            self.hasLaunchedAlready = true
        } else {
            self.callLoginAPI()
        }
    }
    
    //-----------------------------------------------------------
    // MARK: - Call Guest Login ad then continue
    //-----------------------------------------------------------
    
    func callLoginAPI() {
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
                self.splashVC
                    .commonAlert
                    .setupAlert(alert: LangCommon.message,
                                alertDescription: LangCommon.pleaseEnablePushNotification,
                                okAction: LangCommon.ok)
                self.splashVC
                    .commonAlert
                    .addAdditionalOkAction(isForSingleOption: true) {
                        AppDelegate.shared.pushManager.registerForRemoteNotification()
                    }
                return
            }
        }
        self.endEditing(true)
        let _ : CountryModel
//        var dicts = JSON()
//        dicts["country_code"] = "US"
//        dicts["mobile_number"] = "7017926195"
//        dicts["password"] = "123456"
//        dicts["user_type"] = "user"
//        dicts["device_type"] = "94c8a93426e12a874c8e9355da737a15db2f4a1da0d9c38de7340e8f66812b34"
//        dicts["device_id"] = "1"
//        dicts["language"] = "en"
        self.splashVC.callGuestLoginAPI(parms: [:])
    }
        //-----------------------------------------------------------
        // MARK: - Redirect to App Store
        //-----------------------------------------------------------
    
    func goToAppStore() {
        if let url = RideriTunes().appStoreLink {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
                    // Fallback on earlier versions
            }
        }
    }
    
    
        //------------------------------------------------------------
        // MARK: - Splash Video Code
        //------------------------------------------------------------
    
    private func playSplashVideo() {
        guard let videoPath = Bundle.main.path(forResource: "splash_video", ofType: "mp4") else {
            print("Video file not found.")
            
            return
        }
        
            // Create the video player
        let videoURL = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        
            // Configure player layer to fit `viewSplashVideo`
        playerLayer?.frame = viewSplashVideo.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
            // Add the player layer to the view
        if let playerLayer = playerLayer {
            viewSplashVideo.layer.addSublayer(playerLayer)
        }
        
            // Observe when the video ends
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
            // Play the video
        player?.play()
        self.oldViewWithBG.isHidden = true
        self.viewSplashVideo.isHidden = false
    }
    
    @objc private func videoDidFinishPlaying() {
            // Delay for 1 second before navigating
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.splashVC.onStart()
        }
    }
}
