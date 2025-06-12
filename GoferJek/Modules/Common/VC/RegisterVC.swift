//
//  NewRegisterVC.swift
//  GoferDriver
//
//  Created by trioangle on 15/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class RegisterVC: BaseViewController {
    
    @IBOutlet var registerView: RegisterView!
    var accViewModel : AccountViewModel!
    var verified_mobile_number : String!
    var country : CountryModel!
    
    var dictParms = [String: Any]()
    var signUpType : SignUpType = .notDetermined
    var welcomeNavigation : WelcomeNavigationProtocol?
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:-init with story
    
    
    class func initWithStory(using method : SignUpType,verifiedNumber : MobileNumber,params : [String:Any],navigaiton : WelcomeNavigationProtocol) -> RegisterVC{
        let vc : RegisterVC =  UIStoryboard.gojekAccount.instantiateViewController()
        vc.accViewModel = AccountViewModel()
        vc.verified_mobile_number = verifiedNumber.number
        vc.country = verifiedNumber.flag
        vc.signUpType = method
        vc.dictParms = params
        vc.welcomeNavigation = navigaiton
        return vc
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.registerView.ThemeUpdate()
    }
    
    func updateLocation() {
        self.accViewModel
            .getCurrentLocation { model in
                self.accViewModel
                    .updateCurrentLocation(model) { result in
                        if result {
                            AppDelegate.shared.onSetRootViewController(viewCtrl: self)
                        } else {
                            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
                        }
                    }
            }
    }
    
    
    func callSocialSignUpAPI(parms: [AnyHashable: Any]){
        self.accViewModel
            .SocialInfoApiCall(parms: parms){ (result) in
                switch result {
                case .success(let msg):
                    AppDelegate.shared.createToastMessage(msg)
                    if case SignUpType.email = self.signUpType {
                        UserDefaults.set(false,for: .is_from_social_login)
                    } else {
                        UserDefaults.set(true,for: .is_from_social_login)
                    }
                    let flag = self.country!
                    flag.store()
                    let userDefaults = UserDefaults.standard
                    userDefaults.set("rider", forKey:"getmainpage")
                    self.updateLocation()
                case .failure(let error):
                    AppDelegate.shared.createToastMessage(error.localizedDescription)
                    self.registerView.removeProgress()
                    self.registerView.loginBtn.isUserInteractionEnabled = true
                    UserDefaults.set(false,for: .is_from_social_login)
                }
            }
    }
    
}
