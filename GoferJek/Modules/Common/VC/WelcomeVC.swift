//
//  WelcomeVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Social
import AuthenticationServices

/**
__WelcomeVC__ Handle all the Navigation, view model and network Call  in __WelcomeView__
 ```
 // initialization
 let vc = WelcomeVC.initWithStory()
 // Accessing Viewcontroller's functions from View
 vc.navigateToRegisterVC()
 ```
 - note: handled View models _AccountViewModel_
 - warning : view model contain all the business logic, Change the details with precaution
 */
class WelcomeVC: BaseViewController {
    
    //-----------------------------
    // MARK: - Outlets
    //-----------------------------
    
    /**
    __welcomeView__ is a Quick instance from the Interface builder to access __WelcomeView__
     ```
     // Not Recommended
     welcomeView.welcomeBackLbl.text = ""
     // Recommended
     welcomeView.updateValues()
     ```
     - note: hanlded View's in Welcome View
     */
    @IBOutlet var welcomeView: WelcomeView!
    
    //----------------------------------
    // MARK: - Local Variables
    //----------------------------------
    
    /**
    __accViewModel__ is a Quick instance from the Interface builder to access __AccountViewModel__
     ```
     // initialization
     let accViewModel = AccountViewModel()
     // Accessing Networking Functions
     accViewModel.checkSocialLogin(params: parameters){}
     ```
     - note: view model handled the network handling, model handling and business logic
     */
    var accViewModel : AccountViewModel!
    
    /**
    __facebookReadPermissions__ is a Constant , Used to Get the Details of the User from Facebook
     ```
     // initialization
     let facebookReadPermissions = ["public_profile"]
     // Usage
     SocialLoginsHandler.shared.doFacebookLogin(permissions: viewController.facebookReadPermissions
     ```
     - warning: Without notify the facebook developers never change the values
     */
    let facebookReadPermissions = ["public_profile",
                                   "email"]
    /**
    __userDataFromSocialLogin__ is used to store the details from socilal Logins
     - note: type of Social Login Used ( Google, Facebook , Apple )
     */
    var userDataFromSocialLogin : [String:Any]?
    /**
    __signUpType__ is used to identify the Current socilal Login Type
     ```
     // Usage
     signUpType = .facebook(id: "Some ID")
     ```
     - note: ( Google, Facebook , Apple )
     */
    var signUpType : SignUpType = .notDetermined
    
    //-----------------------------
    // MARK:- Life Cycle
    //-----------------------------
    
    /**
     _viewDidLoad_ is override function from view controller, Used to handle the views during loading time
     - note: Call when page Loading for first time
    */
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    /**
     _viewDidAppear_ is override function from view controller, Used to handle the views during Appear time
     - note: Call when page appers
    */
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userDataFromSocialLogin = nil
    }
    /**
     _preferredStatusBarStyle_ is override variable is used to change the status bar style
    */
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //-----------------------------
    // MARK:- Connection
    //-----------------------------
    /**
     _initWithStory_  method is used to Create instance of the Specific VC
     - note : this initWithStory Create _WelcomeVC_ instance
    */
    class
    func initWithStory() -> WelcomeVC {
        let vc : WelcomeVC = UIStoryboard.gojekAccount.instantiateViewController()
        vc.accViewModel = AccountViewModel()
        return vc
    }
    
    //-----------------------------
    // MARK:- WS Functions
    //-----------------------------
    
    func checkSocialMediaId(userData: [String: Any],
                            signUpType: SignUpType) {
        if case SignUpType.email = signUpType {
            UserDefaults.set(false,
                             for: .is_from_social_login)
        } else {
            UserDefaults.set(true,
                             for: .is_from_social_login)
        }
        var parameters = [String:Any]()
        for item in signUpType.getParamValueForType {
            parameters[item.key] = item.value
        }
        self.accViewModel.checkSocialLogin(params: parameters) { (result) in
            switch result {
            case.success(let response):
                if response.status_code == 2 { // New User
                    self.verifyMobileNumberAK(params: userData,
                                              signUpType: signUpType)
                } else if response.status_code == 1 { // Existing User
                    let loginData = UserProfileDataModel(response)
                    loginData.storeRiderBasicDetail()
                    loginData.storeRiderImprotantData()
                    self.userIsAuthenticatedGoToHome()
                }else {
                    AppDelegate.shared.createToastMessage(response.status_message)
                }
                break
            case .failure(let error):
                debug(print: error.localizedDescription)
                break
            }
        }
    }
    
    //-----------------------------
    // MARK:- Local Functions
    //-----------------------------
    
    func userIsAuthenticatedGoToHome() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("rider",
                         forKey:"getmainpage")
        userDefaults.synchronize()
        AppDelegate.shared.onSetRootViewController(viewCtrl: self)
    }
    
    func verifyMobileNumberAK(params : [String:Any],
                              signUpType : SignUpType){
        //mobile_number
        self.signUpType = signUpType
        self.userDataFromSocialLogin = params
        let mobileValidationVC = MobileValidationVC.initWithStory(usign: self,
                                                                  for: .register)
        self.presentInFullScreen(mobileValidationVC,
                                 animated: true,
                                 completion: nil)
        
    }
}

//--------------------------------------------------
// MARK:- Welcome Navigation Protocol
//--------------------------------------------------

extension WelcomeVC : WelcomeNavigationProtocol {
    
    func navigateToSocailSignUp() {
        // Please Add a Screen For Social Login
        //        let socialVC = SocialLoginVC.initWithStory(navigation: self)
        //        self.navigationController?.pushViewController(socialVC, animated: true)
    }
    
    func navigateToLoginVC() {
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        print("currency \(userCurrencySym)")
        let vc = LoginVC.initWithStory(self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRegisterVC() {
        let mobileValidationVC = MobileValidationVC.initWithStory(usign: self,
                                                                  for: .register)
        self.presentInFullScreen(mobileValidationVC,
                                 animated: true,
                                 completion: nil)
    }
    
    func verifyMobileNumberAPI(number: MobileNumber){
        var parms = [String:Any]()
        if self.userDataFromSocialLogin != nil {
            parms = self.userDataFromSocialLogin!
        }else{
            self.signUpType = .email
        }
        parms["mobile_number"] = number.number
        parms["country_code"] = number.flag.country_code
        let registerVC = RegisterVC
            .initWithStory(using: self.signUpType,
                           verifiedNumber: number,
                           params: parms,
                           navigaiton: self)
        switch self.signUpType {
        case .email:
            UserDefaults.set(false,for: .is_from_social_login)
        case .google(id: _):
            UserDefaults.set(true,for: .is_from_social_login)
        case .facebook(id: _):
            UserDefaults.set(true,for: .is_from_social_login)
        case .apple(id: _, email: _):
            UserDefaults.set(true,for: .is_from_social_login)
        case .notDetermined:
            UserDefaults.set(false,for: .is_from_social_login)
        }
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

//--------------------------------------------------
// MARK:- Mobile Number Valiadation Protocol
//--------------------------------------------------

extension WelcomeVC : MobileNumberValiadationProtocol{
    func verified(number: MobileNumber) {
        self.verifyMobileNumberAPI(number: number)
    }
}

//--------------------------------------------------
// MARK:-  AS Authorization Controller Delegate
//--------------------------------------------------

extension WelcomeVC : ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            self.handleAppleData(forSuccess: appleIDCredential)
            //Show Home View Controller
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print(username,password,
                  separator: "|",
                  terminator: ".")
            // For the purpose of this demo app, show the password credential as an alert.
        }
    }
    
    @available(iOS 13.0, *)
    func handleAppleData(forSuccess appleIDCredential : ASAuthorizationAppleIDCredential){
        let email : String?
        if let appleEmail = appleIDCredential.email {
            email = appleEmail
            KeychainItem.currentUserEmail = appleEmail
        }else{
            email = KeychainItem.currentUserEmail
        }
        var userData = [String : Any]()
        if let fullName = appleIDCredential.fullName,
           let givenName = fullName.givenName,
           let familyName = fullName.familyName{
            userData["first_name"] = givenName
            userData["last_name"] = familyName
            KeychainItem.currentUserFirstName = givenName
            KeychainItem.currentUserLastName = familyName
        }else{
            userData["first_name"] = KeychainItem.currentUserFirstName
            userData["last_name"] = KeychainItem.currentUserLastName
        }
        guard let validEmai = email else {
            AppDelegate.shared.createToastMessage(CommonError.server.localizedDescription)
            return
        }
        userData["email"] = validEmai
        self.checkSocialMediaId(userData: userData,
                                signUpType: .apple(id: appleIDCredential.user,
                                                   email: validEmai))
        if let identityTokenData = appleIDCredential.identityToken,
           let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
            debug(print: "Identity Token \(identityTokenString)")
        }
    }
}

//-----------------------------------------------------------------------
// MARK:-  AS Authorization Controller Presentation Context Providing
//-----------------------------------------------------------------------

extension WelcomeVC : ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


