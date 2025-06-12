//
//  WelcomeView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import SocialLoginsIntegration
import AuthenticationServices
import GoogleSignIn

class WelcomeView: BaseView {
    
    //-----------------------------
    // MARK: - Outlets
    //-----------------------------
    
    @IBOutlet weak var welcomeBackLbl: SecondaryExtraLargeLabel!
    @IBOutlet weak var loginToGoLbl: SecondaryLargeLabel!
    @IBOutlet weak var appLogoIV : UIImageView!
    @IBOutlet weak var btnSignIn: PrimaryButton!
    @IBOutlet weak var btnSignUp: SecondaryBorderedButton!
    @IBOutlet weak var langView: UIView!
    @IBOutlet weak var langValueLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currencyLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var languageDropArrowIV: SecondaryTintImageView!
    @IBOutlet weak var currencyDropArrowIV: SecondaryTintImageView!
    @IBOutlet weak var viewHolder: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var facebookHolder: UIView!
    @IBOutlet weak var appleHolder: UIView!
    @IBOutlet weak var googleHolder: UIView!
    @IBOutlet weak var bgIV: UIImageView!
    
    //----------------------------------
    // MARK: - Local Variables
    //----------------------------------
    
    var pushManager : PushNotificationManager!
    var viewController:WelcomeVC!
    var fullWidth = false
    lazy var appleButton : ImageButton = {
        return ImageButton.initWithNib()
    }()
    lazy var facebookButton : ImageButton = {
        return ImageButton.initWithNib()
    }()
    lazy var googleButton : ImageButton = {
        return ImageButton.initWithNib()
    }()
    
    //-----------------------------
    // MARK:- Life Cycle
    //-----------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? WelcomeVC
        AppUtilities().cornerRadiusWithShadow(view: self.bottomView)
        self.initView()
        self.bgIV.image = UIImage(named: "welcome_bg")
//        self.appLogoIV.image = UIImage(named: "Welcome_icon")
        self.makeMenuAnimation()
        self.initGestures()
        self.setCountryInfo()
        self.initLanguage()
        self.initLayers()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) { [weak self] in
            self?.initButtons()
        }
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
//        self.bottomView.customColorsUpdate()
        self.bottomView.backgroundColor = .clear
//        self.bottomView.backgroundColor = .DarkModeBackground
        self.btnSignIn.customColorsUpdate()
        self.welcomeBackLbl.customColorsUpdate()
//        self.welcomeBackLbl.textColor = .SecondaryColor
        self.loginToGoLbl.customColorsUpdate()
//        self.loginToGoLbl.textColor = .SecondaryColor
        self.btnSignUp.customColorsUpdate()
//        self.btnSignUp.backgroundColor = .DarkModeBackground
//        self.btnSignUp.setTitleColor(.DarkModeTextColor, for: .normal)
        self.currencyLbl.customColorsUpdate()
//        self.currencyLbl.textColor = .SecondaryColor
        self.langValueLbl.customColorsUpdate()
//        self.langValueLbl.textColor = .SecondaryColor
        self.languageDropArrowIV.customColorsUpdate()
//        self.languageDropArrowIV.tintColor = .SecondaryColor
        self.currencyDropArrowIV.customColorsUpdate()
//        self.currencyDropArrowIV.tintColor = .SecondaryColor
        self.appleButton.customColorsUpdate()
        self.facebookButton.customColorsUpdate()
        self.googleButton.customColorsUpdate()
    }
    
    override
    func willAppear(baseVC : BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.btnSignIn.isExclusiveTouch = true
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.darkModeChange()
    }
    
    override
    func didAppear(baseVC : BaseViewController) {
        super.didAppear(baseVC: baseVC)
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0.015,
                                options: [.layoutSubviews],
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1,
                               animations: {
                self.layoutIfNeeded()
            })
        }, completion: { (_) in })
    }
    
    //-----------------------------
    // MARK:- initButtons
    //-----------------------------
    
    func initButtons() {
        self.appleHolder.isHidden = true
        self.googleHolder.isHidden = true
        self.facebookHolder.isHidden = true
        self.fullWidth = Shared.instance.facebookLogin && Shared.instance.googleLogin
        if Shared.instance.appleLogin {
            if #available(iOS 13.0, *) {
                self.setupAppleButton()
                self.appleHolder.isHidden = false
            }else{
                self.appleHolder.isHidden = true
            }
        }
        if Shared.instance.facebookLogin {
            self.setupFacebookButton()
            self.facebookHolder.isHidden = false
        }
        if Shared.instance.googleLogin{
            self.setupGoogleButton()
            self.googleHolder.isHidden = false
        }
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    //-----------------------------------------
    // MARK: Setup Apple Button
    //-----------------------------------------
    
    func setupAppleButton() {
        guard #available(iOS 13.0, *) else{
            self.appleHolder.isHidden = true
            return
        }
        self.appleHolder.isHidden = false
//        appleButton.frame = CGRect(x: 0,
//                                   y: 0,
//                                   width: self.appleHolder.frame.width,
//                                   height: 45)
        appleButton.setTitle(LangCommon.signInWith + " Apple")
        appleButton.centerIV.setImage(image: "apple",
                                      mode: .template)
        appleButton.customColorsUpdate()
        appleButton.titleLabel.setFont(size: 13,
                                       weight: .bold)
        appleButton.cornerRadius = 5
        appleButton.elevate(2)
        appleButton.addAction(for: .tap) { [weak self] in
            self?.handleLogInWithAppleIDButtonPress()
        }
        appleButton.removeFromSuperview()
        self.appleHolder.addSubview(appleButton)
        self.appleButton.anchor(toView: self.appleHolder, leading: 0, trailing: 0, top: 0, bottom: 0)
    }
    
    //-----------------------------------------
    // MARK: Setup Facebook Button
    //-----------------------------------------
    
    func setupFacebookButton() {
        let x = isRTLLanguage ? self.facebookHolder.frame.origin.x : self.googleHolder.frame.origin.x
        let y = isRTLLanguage ? self.facebookHolder.frame.origin.y : self.googleHolder.frame.origin.y
        let width = self.fullWidth ? (self.frame.width - 50)/2 : 100
//        facebookButton.frame = CGRect(x: x,
//                                      y: y,
//                                      width: width,
//                                      height: 45)
        facebookButton.setTitle(LangCommon.faceBook)
        facebookButton.setCenterImage("facebook")
        facebookButton.customColorsUpdate()
        facebookButton.titleLabel.setFont(size: 13,
                                          weight: .bold)
        facebookButton.cornerRadius = 20
        facebookButton.elevate(2)
        facebookButton.addAction(for: .tap) { [weak self] in
            self?.doFacebookLogin()
        }
        facebookButton.removeFromSuperview()
        self.facebookHolder.addSubview(facebookButton)
        self.facebookButton.anchor(toView: self.facebookHolder, leading: 0, trailing: 0, top: 0, bottom: 0)
    }

    //-----------------------------------------
    // MARK: Setup Google Button
    //-----------------------------------------
    
    func setupGoogleButton() {
        let width = self.fullWidth ? (self.frame.width - 50)/2 : 100
        let x = isRTLLanguage ? self.facebookHolder.frame.origin.x : self.googleHolder.frame.origin.x
        let y = isRTLLanguage ? self.facebookHolder.frame.origin.y : self.googleHolder.frame.origin.y
//        googleButton.frame = CGRect(x: x,
//                                    y: y,
//                                    width: width,
//                                    height: 45)
        googleButton.setTitle(LangCommon.google)
        googleButton.setCenterImage("google")
        googleButton.customColorsUpdate()
        googleButton.titleLabel.setFont(size: 13,
                                        weight: .bold)
        googleButton.cornerRadius = 20
        googleButton.elevate(2)
        googleButton.addAction(for: .tap) { [weak self] in
            self?.doGoogleLogin()
        }
        googleButton.removeFromSuperview()
        self.googleHolder.addSubview(googleButton)
        self.googleButton.anchor(toView: self.googleHolder, leading: 0, trailing: 0, top: 0, bottom: 0)
    }
    
    //-----------------------------------------
    // MARK: Facebook Response handling
    //-----------------------------------------
    
    func doFacebookLogin() {
        SocialLoginsHandler.shared.doFacebookLogin(permissions: viewController.facebookReadPermissions,
                                                   ViewController: viewController) { result in
            switch result {
            case .success(let fbResult):
                if fbResult.doFacebookImagePermissionCheck() {
                    let width = 1024
                    let height = width
                    SocialLoginsHandler.shared.doGetFacebookUserDetails(graphPath: "me",
                                                                        parameters: ["fields": "id, name, first_name, last_name, birthday, email, picture.width(\(width)).height(\(height))"]) { response in
                        switch response {
                        case .success(let facebookResult):
                            debug(print: "facebookResult : \(facebookResult.userDetails)")
                            let userdetails = facebookResult.userDetails
                            let email = userdetails.string("email")
                            let firstName = userdetails.string("first_name")
                            let lastName = userdetails.string("last_name")
                            let fbID = userdetails.int("id")
                            let fbImage = ((userdetails["picture"]as? JSON)?["data"] as? JSON)?.string("url")
                            Constants().STOREVALUE(value: facebookResult.accessToken,
                                                   keyname: "FBAcessToken")
                            // Store Details
                            Constants().STOREVALUE(value: firstName,
                                                   keyname: "first_name")
                            Constants().STOREVALUE(value: lastName,
                                                   keyname: "last_name")
                            Constants().STOREVALUE(value: fbID.description,
                                                   keyname: "user_fbid")
                            Constants().STOREVALUE(value: fbImage ?? "",
                                                   keyname: "user_image")
                            let dict : [String : Any] = ["email" : email,
                                                         "first_name" : firstName,
                                                         "last_name": lastName,
                                                         "fb_id" : fbID,
                                                         "user_image" : fbImage ?? ""]
                            self.viewController.checkSocialMediaId(userData: dict,
                                                                   signUpType: .facebook(id: fbID.description))
                            SocialLoginsHandler.shared.doFacebookLogout()
                        case .failure(let error):
                            SocialLoginsHandler.shared.doFacebookLogout()
                            AppDelegate.shared.createToastMessage(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                SocialLoginsHandler.shared.doFacebookLogout()
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
    }
    
    //----------------------------------------------------------
    // MARK: - Google Response Handling
    //----------------------------------------------------------
//    func doGoogleLogin(VC: UIViewController,
//                       clientID : String,
//                       completion: @escaping (Result<GIDGoogleUser,Error>) -> Void) {
//        let config : GIDConfiguration = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.signIn(with: config,
//                                        presenting: VC) { user, error in
//            if error != nil || user == nil {
//                guard let error = error else { return }
//                completion(.failure(error))
//            } else {
//                guard let user = user else { return }
//                completion(.success(user))
//            }
//        }
//    }
    
    func doGoogleLogin(VC: UIViewController,
                       clientID: String,
                       completion: @escaping (Result<GIDGoogleUser, Error>) -> Void) {
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: VC) { signInResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = signInResult?.user {
                completion(.success(user))
            } else {
                // Edge case: no error, but also no user
                let unknownError = NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                completion(.failure(unknownError))
            }
        }
    }


    
    func doGoogleLogin() {
        guard  let googlePlist = PlistReader<GooglePlistKeys>(),
               let clinetId : String = googlePlist.value(for: .clientId) else {
                   print("Google Client ID Missing")
                   return }
        self.doGoogleLogin(VC: self.viewController,
                                                 clientID: "345840437810-jnftr7kua6k7d7rj9kmmiks9d9pl3o52.apps.googleusercontent.com") { result in
            switch result {
            case .success(let user):
                if let userID = user.userID,
                   let profile = user.profile {
                    let givenName = profile.givenName
                    let familyName = profile.familyName
                    let email = profile.email
                    var dicts = [String: Any]()
                    dicts["email"] = email
                    dicts["password"] = ""
                    dicts["first_name"] = givenName
                    dicts["last_name"] = familyName
                    if SocialLoginsHandler.shared.doGoogleHasProfile() {
                        let dimension = round(120 * UIScreen.main.scale)
                        let imageURL = profile.imageURL(withDimension: UInt(dimension))
                        dicts["user_image"] = imageURL?.absoluteString
                    }
                    self.viewController.checkSocialMediaId(userData: dicts,
                                                           signUpType: .google(id: userID))
                    SocialLoginsHandler.shared.doGoogleSignOut()
                } else {
                    print("Data Missing")
                }
            case .failure(let error):
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
    }
    
    //---------------------------
    // MARK:- Local Functions
    //---------------------------
    
    func handleLogInWithAppleIDButtonPress() {
        guard #available(iOS 13.0, *) else{return}
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName,
                                   .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = viewController
        authorizationController.presentationContextProvider = viewController
        authorizationController.performRequests()
    }

    //---------------------------
    // MARK: - Initializers
    //---------------------------
    
    func initView() {
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.btnSignIn.isExclusiveTouch = true
        startAnimation()
        let userCurrencyCode = Constants().GETVALUE(keyname: "user_currency_org")
        self.currencyLbl.text = userCurrencyCode.description
    }
    
    func initLayers() {
        self.currencyView.cornerRadius = 15
        self.langView.cornerRadius = 15
        self.appLogoIV.cornerRadius = 30
    }
    
    func initGestures() {
        self.langView.addAction(for: .tap) { [weak self] in
            let vc = SelectLanguageVC.initWithStory()
            self?.viewController.presentVC(vc,
                                           style: .overCurrentContext,
                                           completion: nil)
        }
        self.currencyView.addAction(for: .tap) { [weak self] in
            print("------> currency Changing Process Take Place Here")
            let vc = CurrencyPopupVC.initWithStory()
            self?.viewController.presentVC(vc,
                                           style: .overCurrentContext,
                                           completion: nil)
            vc.callback = {(str) in
                self?.currencyLbl.text = str
            }
        }
    }
    
    func initLanguage() {
        self.btnSignIn.setTitle(LangCommon.signIn.capitalized,
                                for: .normal)
        self.btnSignUp.setTitle(LangCommon.register.capitalized,
                                for: .normal)
        self.langValueLbl.text = currentLanguage.lang
//        self.appLogoIV.setImage(image: appLogo)
        self.welcomeBackLbl.text = LangCommon.welcomeBack
        self.loginToGoLbl.text = LangCommon.loginToContinue
    }
    
    //---------------------------------------------------------------
    // MARK:- Getting Country Dial Code and Flag from plist file
    //---------------------------------------------------------------
    
    func setCountryInfo() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let flag = CountryModel(withCountry: countryCode)
            flag.store()
        }
    }
    
    //----------------------------------------------------------
    // MARK: - Button Actions
    //----------------------------------------------------------
    
    @IBAction
    func registerBtnAction(_ sender: Any) {
        self.viewController.navigateToRegisterVC()
    }
    
    @IBAction
    func loginBtnAction(_ sender: UIButton?) {
        self.viewController.navigateToLoginVC()
    }
    
    @IBAction
    func languageBtnAction(_ sender: Any) {
        let view = SelectLanguageVC.initWithStory()
        view.modalPresentationStyle = .overCurrentContext
        self.viewController.present(view,
                                    animated: true,
                                    completion: nil)
    }
    
    @IBAction
    func currencyBtnClicked(_ sender: Any) {
        let view = CurrencyPopupVC.initWithStory()
        view.modalPresentationStyle = .overCurrentContext
        self.viewController.present(view,
                                    animated: true,
                                    completion: nil)
        view.callback = {(str) in
            self.currencyLbl.text = str
        }
    }
    
    //----------------------------------------------------------
    // MARK: - Parrallax effect for Image
    //----------------------------------------------------------
    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(
            keyPath: "center.x",
            type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(
            keyPath: "center.y",
            type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal,
                               vertical]
        vw.addMotionEffect(group)
    }
    
    //----------------------------------------------------------
    // MARK: - Show aimation
    //----------------------------------------------------------
    
    func setupShareAppViewAnimationWithView(_ view:UIView,deleyTime:Double) {
        view.transform = CGAffineTransform(
            translationX: 0,
            y: self.viewHolder.frame.size.height)
        UIView.animate(
            withDuration: 1.0,
            delay: deleyTime,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: UIView.AnimationOptions.allowUserInteraction,
            animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1.0;
            }, completion: nil)
    }
    
    func startAnimation() {
        let animation = CircularRevealAnimation(from: CGPoint(x: self.bounds.width / 2,
                                                              y: self.bounds.height / 2),
                                                to: self.viewController.view.bounds)
        self.layer.mask = animation.shape()
        self.alpha = 1
        animation.commit(duration: 0.5,
                         expand: true,
                         completionBlock: {
            self.layer.mask = nil
        })
    }
    
    //----------------------------------------------------------
    // MARK: - Making spring damn animation
    //----------------------------------------------------------
    
    func makeMenuAnimation() {
        let initialDelay = 0.5;
        var i = 0.0;
        for view in viewHolder.subviews {
            setupShareAppViewAnimationWithView(view,
                                               deleyTime: initialDelay + i)
            i=i + 0.1;
        }
    }
    
}


