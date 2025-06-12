//
//  SharedPreferences.swift
//  Gofer
//
//  Created by trioangle on 16/05/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

typealias GifLoaderValue = (loader:UIView,
                            count : Int)

class Shared {
    private init(){}
    static let instance = Shared()
    fileprivate let preference = UserDefaults.standard
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var notifObservers = [NSObjectProtocol]()
    // Delivery Splitup Start
    var currentBookingType : JobBookingType = .bookNow
    // Delivery Splitup End
    var appleLogin = false
    var googleLogin = false
    var facebookLogin = false
    var otpEnabled = false
    var supportArray : [Support]? = nil
    var isFromSocialLogin : Bool = false
    var resumeTripHitCount = 0
    var resumeTripHitCountDelivery = 0
    var permissionDenied = false
    var isWebPayment : Bool = false
    var isCovidEnabled : Bool = false
    var driverRadiusKM : Int = 5{
        didSet{
            if driverRadiusKM < 25{
                self.driverRadiusKM = 25
            }
        }
    }
    var pickUpLocation: CLLocation!
    var dropLocation: CLLocation!
    var isBackFromPayment = false
    var chatVcisActive = false
    var needToShowChatVC = false
    //REferral
    private var enableReferral = Bool()
    
    func enableReferral(_ on : Bool){
        self.enableReferral = on
    }
    
    func isReferralEnabled() -> Bool {
        return self.enableReferral
    }
    
    func socialLoginSupport(appleLogin : Bool,
                            facebookLogin: Bool,
                            googleLogin : Bool,
                            otpEnabled: Bool,
                            supportArr : [Support]) {
        self.appleLogin = appleLogin
        self.googleLogin = googleLogin
        self.facebookLogin = facebookLogin
        self.otpEnabled = otpEnabled
        self.supportArray = supportArr
    }
    
    fileprivate var gifLoaders : [UIView:GifLoaderValue] = [:]
    
}
//MARK:- UserDefaults property observers
extension Shared{
    var device_token : String{
        get{return preference.string(forKey: "device_token") ?? String()}
        set{preference.set(newValue, forKey: "device_token")}
    }
}
//MARK:- functions
extension Shared{
    func resetUserData(){
        preference.set("", forKey:"getmainpage")
        preference.removeObject(forKey: "user_credit_card_brand")
        preference.removeObject(forKey: "user_credit_card_sufix")
        preference.removeObject(forKey: "access_token")
        PaymentOptions.cash.setAsDefault()
        
        preference.set("No", forKey: "selectwallet")
        preference.synchronize()
    }
   
 
}

//MARK:- alert
extension Shared{
    func showLoaderInWindow(){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let window = appDelegate.window{
                self.showLoader(in: window)
            }
        }
        
    }
    func removeLoaderInWindow(){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let window = appDelegate.window{
                self.removeLoader(in: window)
            }
        }
    }
    func showLoader(in view : UIView) {
        guard Shared.instance.gifLoaders[view] == nil else{return}
        DispatchQueue.main.async {
            let gifValue : GifLoaderValue
            if let existingLoader = self.gifLoaders[view]{
                gifValue = (loader: existingLoader.loader,
                            count: existingLoader.count + 1)
            } else {
                let gif = self.getLoaderGif(forFrame: view.bounds)
                view.addSubview(gif)
                gif.frame = view.frame
                gif.center = view.center
                gifValue = (loader: gif,count: 1)
            }
            Shared.instance.gifLoaders[view] = gifValue
        }
    }
    
    func removeLoader(in view : UIView) {
        guard let existingLoader = self.gifLoaders[view] else{
            return
        }
        let newCount = existingLoader.count - 1
        if newCount == 0 {
            Shared.instance.gifLoaders[view]?.loader.removeFromSuperview()
            Shared.instance.gifLoaders.removeValue(forKey: view)
        }else{
            Shared.instance.gifLoaders[view] = (loader: existingLoader.loader,
                                                count: newCount)
        }
    }
    func getLoaderGif(forFrame parentFrame: CGRect) -> UIView {
        let jeremyGif = UIImage.gifImageWithName("loader")
        let view = UIView()
        view.backgroundColor = UIColor.PrimaryColor.withAlphaComponent(0.05)
        view.frame = parentFrame
        let imageView = UIImageView(image: jeremyGif)
        imageView.tintColor = .PrimaryColor
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.center = view.center
        view.addSubview(imageView)
        view.tag = 2596
        return view
    }
    func isLoading(in view : UIView? = nil) -> Bool{
        if let _view = view,
            let _ = self.gifLoaders[_view]{
            return true
        }
        if let window = AppDelegate.shared.window,
            let _ = self.gifLoaders[window]{
            return true
        }
        return false
    }
}
