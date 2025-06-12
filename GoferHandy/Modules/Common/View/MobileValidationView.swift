//
//  MobileValidationView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire

class MobileValidationView: BaseView,CheckStatusProtocol{
    
    //--------------------------------------------
    // MARK: - Outlets
    //--------------------------------------------
    
    @IBOutlet weak var contentHolderView : SecondaryView!
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var headerView: SecondaryView!
    @IBOutlet weak var titleIV : UIImageView!
    @IBOutlet weak var contentCurvedView: TopCurvedView!
    @IBOutlet weak var descLbl : SecondaryLargeLabel!
    @IBOutlet weak var inputFieldHolderView : UIView!
    @IBOutlet weak var nextBtn : PrimaryButton!
    @IBOutlet weak var bottomDescLbl : SecondaryLargeLabel!
    @IBOutlet weak var bottomBtn :PrimaryTextButton!
    
    //--------------------------------------------
    // MARK: - Class Variables
    //--------------------------------------------
    
    var viewController:MobileValidationVC!
    var otpFromAPI : String? {//Otp from API
        didSet{
            guard self.otpFromAPI != nil else{return}
            self.startOTPTimer()
            /*
             *UnComment this for product live(Only for Gofer)
             if let _otp = self.otpFromAPI,
             let appDelegate = UIApplication.shared.delegate as? AppDelegate{
             appDelegate.createToastMessage("\("Your OTP is".localize) \(_otp)")
             }
             */
        }
    }
    lazy var customOtpView : CustomOtpView = {
        let _otpView = CustomOtpView.getView(with: self,
                                             using: self.inputFieldHolderView.bounds)
        return _otpView
    }()
    
    var flag : CountryModel?{ //Country flag
        didSet{
            self.mobileNumberView.flag = self.flag
        }
    }
    var currentScreenState : ScreenState{
        return otpFromAPI == nil ? .mobileNumber : .OTP
    }
    lazy var mobileNumberView : MobileNumberView = {
        let mnView = MobileNumberView.getView(with: self.inputFieldHolderView.bounds)
        mnView.countryHolderView.addAction(for: .tap, Action: {
            self.presentToCountryVC()
        })
        return mnView
    }()
    lazy var otpView : OTPView = {
        let _otpView = OTPView.getView(with: self,
                                       using: self.inputFieldHolderView.bounds)
        if isRTLLanguage {
            _otpView.rotate()
        }
        return _otpView
    }()
    lazy var toolBar : UIToolbar = {
        let tool = UIToolbar(frame: CGRect(origin: CGPoint.zero,
                                           size: CGSize(width: self.frame.width,
                                                        height: 30)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done,
                                   target: self,
                                   action: #selector(self.doneAction))
        let clear = UIBarButtonItem(barButtonSystemItem: .refresh,
                                    target: self,
                                    action: #selector(self.clearAction))
        tool.setItems([clear,space,done], animated: true)
        tool.tintColor = .PrimaryColor
        tool.sizeToFit()
        return tool
    }()
    var spinnerView = JTMaterialSpinner()
    var remainingOTPTime = 0
    
    //--------------------------------------------
    //MARK:- Life Cycle
    //--------------------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? MobileValidationVC
        self.initView()
        self.initNotification()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.contentHolderView.customColorsUpdate()
        self.contentCurvedView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.titleIV.tintColor = self.isDarkStyle ?
            .DarkModeTextColor :
            .SecondaryTextColor
        self.descLbl.customColorsUpdate()
        self.bottomDescLbl.customColorsUpdate()
//        self.otpView.ThemeChange()
        self.customOtpView.darkModeChange()
        self.mobileNumberView.ThemeChange()
    }
    
    override
    func willAppear(baseVC : BaseViewController) {
        super.willAppear(baseVC: baseVC)
        
    }
    
    override
    func didAppear(baseVC : BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    
    //--------------------------------------
    // MARK:- Actions
    //--------------------------------------
    
    @IBAction
    override func backAction(_ sender : UIButton){
        if self.currentScreenState == .mobileNumber{
            super.backAction(sender)
        } else {
            self.otpFromAPI = nil
            self.customOtpView.clear()
            self.aniamateView(for: .mobileNumber)
        }
    }
    
    @IBAction
    func nextAction(_ sender : UIButton) {
        if self.currentScreenState == .mobileNumber {
            self.nextBtn.isUserInteractionEnabled = false // disabled the user interaction because of the multiple otp generation
            self.wsToVerifyNumber()
        } else {
            if let typedOTP = self.customOtpView.otp,
               let number = self.mobileNumberView.number,
               let countryCode = self.flag?.dial_code{ //Validation completed
                self.otpVerification(enteredOTP: typedOTP,
                                     mobileNumber: number,
                                     countryCode: countryCode)
            } else { //Invalid otp
                print("Local OTP Problem")
            }
        }
    }
    
    @IBAction
    func bottomBtnAction(_ sender : UIButton) {
        if self.currentScreenState == .OTP{ //Resend OTP
            self.customOtpView.clear()
            self.endEditing(true)
            self.wsToVerifyNumber()
        }else{
            switch self.viewController.purpose{ //Currenty not using these cases
            case NumberValidationPurpose.register?:
                self.backAction(self.backBtn ?? UIButton())
            case NumberValidationPurpose.changeNumber?:
                self.backAction(self.backBtn ?? UIButton())
            case NumberValidationPurpose.forgotPassword?:
                break
            default:
                break
            }
        }
    }
    
    //--------------------------------------
    // MARK:- initializers
    //--------------------------------------
    
    func initView() {
        self.nextBtn.setTitle(LangCommon.common1Continue.capitalized,
                              for: .normal)
        self.setContentData(for: self.currentScreenState)
        if let code = UserDefaults.standard.string(forKey: "dial_code"){
            let country = UserDefaults.standard.string(forKey: "user_country_code")
            self.flag = CountryModel(forDialCode: code,
                                     withCountry: country)
        } else {
            self.flag = CountryModel()
        }
        self.customOtpView.otpField.keyboardType = .numberPad
        self.customOtpView.otpField.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.initLayers()
        }
        self.mobileNumberView.numberTF.addTarget(self,
                                                 action: #selector(numberUpdaing(_:)),
                                                 for: .editingChanged)
        self.bottomBtn.alpha =  0
        self.bottomDescLbl.alpha =  0
    }
    
    func initNotification() {
        if UIScreen.main.bounds.height <= 570 { //5s or less
            NotificationCenter.default
                .addObserver(
                    self,
                    selector: #selector(self.KeyboardShows),
                    name: UIResponder.keyboardWillShowNotification,
                    object: nil)
            NotificationCenter.default
                .addObserver(
                    self,
                    selector: #selector(self.KeyboardHiddens),
                    name: UIResponder.keyboardWillHideNotification,
                    object: nil)
        }
    }
    
    func initLayers() {
        self.checkStatus() //to change next button color
    }
    
    //--------------------------------------
    // MARK:- Local Functions
    //--------------------------------------
    
    func otpVerification(enteredOTP : String,
                         mobileNumber : String,
                         countryCode : String) {
        let param = ["otp" : enteredOTP,
                     "mobile_number":mobileNumber,
                     "country_code":countryCode]
        self.viewController.wsToVerifyOTP(param: param)
    }
    
    @objc
    func doneAction(){
        self.endEditing(true)
        self.checkStatus()
    }
    
    @objc
    func clearAction(){
        if self.currentScreenState == .mobileNumber{
            self.mobileNumberView.clear()
        } else {
            self.customOtpView.clear()
        }
    }
    
    @objc
    func numberUpdaing(_ sender : UITextField) {
        self.checkStatus()
    }
    
    @objc
    func KeyboardShows(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.15) {
            self.contentHolderView.transform = CGAffineTransform(translationX: 0,
                                                                 y: -keyboardFrame.height * 0.3)
        }
        self.darkModeChange()
    }
    
    @objc
    func KeyboardHiddens(notification: NSNotification) {
        // hide the keyboard
        UIView.animate(withDuration: 0.15) {
            self.contentHolderView.transform = .identity
        }
        self.darkModeChange()
    }
    
    //--------------------------------------
    // MARK:- Webservices
    //--------------------------------------
    
    func wsToVerifyNumber() {
        guard let number = self.mobileNumberView.number,
              let country = self.flag else{ return }
        var params = Parameters()
        params["mobile_number"] = number
        params["country_code"] = country.country_code
        params["forgotpassword"] = self.viewController.purpose == NumberValidationPurpose.forgotPassword ? 1 : 0
        if let language : String = UserDefaults.value(for: .default_language_option){
            params["language"] = language
        }
        self.viewController.wsToVerifyNumberApiCall(params: params)
        self.addProgress()
    }
    
    //--------------------------------------
    // MARK:- Animations
    //--------------------------------------

    /**
     Set Data for screen content based on states
     - Author: Abishek Robin
     - Parameters:
     - state: ScreenState(mobile/otp)
     */
    
    func setContentData(for state : ScreenState) {
        self.inputFieldHolderView.subviews.forEach({$0.removeFromSuperview()})
        let titleImage : UIImage?
        if state == .mobileNumber {
            titleImage = UIImage(named: "verification")
            self.titleLbl.text = LangCommon.mobileVerify.capitalized
            self.descLbl.text = LangCommon.enterMobileno
            self.bottomDescLbl.text = ""
            self.bottomBtn.setTitle(" ", for: .normal)
            self.inputFieldHolderView.addSubview(self.mobileNumberView)
            self.mobileNumberView.anchor(toView: self.inputFieldHolderView,
                                         leading: 0,
                                         trailing: 0,
                                         top: 0,
                                         bottom: 0)
            self.inputFieldHolderView.bringSubviewToFront(self.mobileNumberView)
            self.mobileNumberView.numberTF.inputAccessoryView = self.toolBar
        } else { //.otp
            titleImage = UIImage(named: "otp")
            self.titleLbl.text = LangCommon.enterOtp
            self.descLbl.text = LangCommon.smsMobileVerify
            self.bottomDescLbl.text = LangCommon.didntReceiveOtp
            self.bottomBtn.setTitle(LangCommon.resendOtp, for: .normal)
            self.inputFieldHolderView.insertSubview(self.customOtpView,
                                                    at: 0)//(self.otpView)
            self.customOtpView.anchor(toView: self.inputFieldHolderView,
                                      leading: 0,
                                      trailing: 0,
                                      top: 0,
                                      bottom: 0)
            self.inputFieldHolderView.bringSubviewToFront(self.customOtpView)
            self.customOtpView.setToolBar(self.toolBar)
            
        }
        self.titleIV.image = titleImage
    }
    
    func aniamateView(for state : ScreenState){
        let transformation : CGAffineTransform
        let change : CGFloat = isRTLLanguage ? -1 : 1
        if state == .OTP  {
            transformation = CGAffineTransform(
                translationX: -self.frame.width * change,
                y: 0)
        }else{
            transformation = CGAffineTransform(
                translationX: self.frame.width * change,
                y: 0)
        }
        UIView.animateKeyframes(
            withDuration: 0.8,
            delay: 0.0,
            options: [.calculationModeCubic,.calculationModeCubicPaced],
            animations: {
                self.animate(with: transformation)
            }) { (completed) in
            if completed {
                //Change data for new state when view is outside the frame
                self.setContentData(for: state)
                //Continue animating
                UIView.animateKeyframes(
                    withDuration: 0.8,
                    delay: 0.1,
                    options: [.calculationModeCubic,.calculationModeCubicPaced],
                    animations: {
                        UIView.addKeyframe(
                            withRelativeStartTime: 0,
                            relativeDuration: 0,
                            animations: {
                                self.prepareScreen(forIntermediateAniamtion: state)
                            })
                        UIView.addKeyframe(
                            withRelativeStartTime: 0.25,
                            relativeDuration: 0.75,
                            animations: {
                                self.bottomBtn.alpha = state == .OTP ? 1 : 0
                                self.bottomDescLbl.alpha = state == .OTP ? 1 : 0
                            })
                        self.animate(with: .identity)
                    }) { (completed) in
                    self.mobileNumberView.ThemeChange()
                }
            }
        }
    }
    
    func prepareScreen(forIntermediateAniamtion state : ScreenState) {
        let transformation : CGAffineTransform
        let change : CGFloat = isRTLLanguage ? -1 : 1
        if state == .OTP{
            transformation = CGAffineTransform(
                translationX: self.frame.width * change,
                y: 0)
        }else{
            transformation = CGAffineTransform(
                translationX: -self.frame.width * change,
                y: 0)
        }
        self.titleIV.transform = transformation
        self.titleLbl.transform = transformation
        self.descLbl.transform = transformation
        self.inputFieldHolderView.transform = transformation
        self.checkStatus()
    }
    
    func animate(with transformation : CGAffineTransform){
        let relativeDuration = 0.25
        UIView.addKeyframe(
            withRelativeStartTime: relativeDuration * 0,
            relativeDuration: relativeDuration,
            animations: {
                self.titleIV.transform = transformation
            })
        UIView.addKeyframe(
            withRelativeStartTime: relativeDuration * 1,
            relativeDuration: relativeDuration,
            animations: {
                self.titleLbl.transform = transformation
            })
        UIView.addKeyframe(
            withRelativeStartTime: relativeDuration * 2,
            relativeDuration: relativeDuration,
            animations: {
                self.descLbl.transform = transformation
            })
        
        UIView.addKeyframe(
            withRelativeStartTime: relativeDuration * 3,
            relativeDuration: relativeDuration,
            animations: {
                self.inputFieldHolderView.transform = transformation
            })
    }
    
    //---------------------------------
    // MARK:- OTP timers
    //---------------------------------
    
    /**
     restrict next otp request for 120 seconds
     */
    
    func startOTPTimer(){
        self.darkModeChange()
        self.remainingOTPTime = 120
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1,
                                 repeats: true) { (timer) in
                if self.currentScreenState != .OTP{//if in mobile number state
                    timer.invalidate() // Stop
                    return // and return
                }
                self.handleRemainingOTPtime()
                self.remainingOTPTime -= 1
                if self.remainingOTPTime <= 0 {//time reached
                    timer.invalidate()
                    self.canSendOTP()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func handleRemainingOTPtime() {
        self.bottomDescLbl.text = "\(LangCommon.otpAgain) \(self.remainingOTPTime) \(LangCommon.sec)"
        self.darkModeChange()
        self.bottomBtn.setTitleColor(.TertiaryColor,
                                     for: .normal)
        self.bottomBtn.isUserInteractionEnabled = false
    }
    
    func canSendOTP(){
        self.bottomDescLbl.text = LangCommon.didntReceiveOtp
        self.darkModeChange()
        self.bottomBtn.setTitleColor(.ThemeTextColor,
                                     for: .normal)
        self.bottomBtn.isUserInteractionEnabled = true
    }
    
    //---------------------------------
    //MARK:- UDF
    //---------------------------------
    
    func checkStatus() {
        let isActive : Bool
        if self.currentScreenState == .mobileNumber {
            isActive = self.mobileNumberView.number?.count ?? 0 > 5 && flag != nil
            self.bottomDescLbl.text = ""
        } else {
            if let _otp = self.customOtpView.otp {
                isActive = _otp.count > 3//_otp == self.otpView.otp
            } else {
                isActive = false
            }
        }
        self.nextBtn.backgroundColor = isActive ? .PrimaryColor : .TertiaryColor
        self.nextBtn.isUserInteractionEnabled = isActive
    }
    
    func onSuccess() {
        //On validation success
        guard let number = self.mobileNumberView.number,
              let flag = self.flag else {return}
        self.viewController.validationDelegate?
            .verified(number: MobileNumber(number: number,
                                           flag: flag))
        self.viewController.exitScreen(animated: true)
    }
    
    //---------------------------------
    // MARK: - Present country VC
    //---------------------------------
    
    func presentToCountryVC() {
        let propertyView = CountryListVC.initWithStory()
        propertyView.delegate = self
        self.viewController.presentInFullScreen(propertyView, animated: true, completion: nil)
    }
    /**
     Show error on bottom desc label with shake animation
     - Author: Abishek Robin
     - Parameters:
     - error: Error message
     - Note: error message will change to default state on interaction
     */
    func showError(_ error : String){
        self.bottomDescLbl.text = error
        self.bottomDescLbl.alpha = 1
        self.endEditing(true)
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeLinear], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                //                self.bottomDescLbl.textColor = .ThemeMain
                self.bottomDescLbl.textColor = .ErrorColor
                self.bottomDescLbl.transform =  CGAffineTransform(translationX: 0, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                self.bottomDescLbl.transform = CGAffineTransform(translationX: -5, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6, animations: {
                self.bottomDescLbl.transform = CGAffineTransform(translationX: 5, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.8, animations: {
                self.bottomDescLbl.transform = CGAffineTransform(translationX: -5, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.9, animations: {
                self.bottomDescLbl.transform = CGAffineTransform(translationX: 5, y: 0)
            })
        }) { (_) in
            self.bottomDescLbl.transform =  .identity
        }
        
    }
    
    // Add progress when api call done
    func addProgress() {
        self.nextBtn.addSubview(spinnerView)
        self.spinnerView.anchor(toView: self.nextBtn,
                                trailing: -15)
        self.spinnerView.setEqualHightWidthAnchor(toView: self.spinnerView,
                                                  height: 25)
        self.spinnerView.setCenterXYAncher(toView: self.nextBtn,
                                           centerY: true)
        self.nextBtn.bringSubviewToFront(spinnerView)
        self.spinnerView.circleLayer.lineWidth = 3.0
        self.spinnerView.circleLayer.strokeColor =  UIColor.PrimaryTextColor.cgColor
        self.spinnerView.beginRefreshing()
    }
    // Remove progress when api call done
    func removeProgress() {
        self.nextBtn.isUserInteractionEnabled = true
        spinnerView.endRefreshing()
        spinnerView.removeFromSuperview()
    }
}
extension MobileValidationView : CountryListDelegate{
    func countryCodeChanged(countryCode: String, dialCode: String, flagImg: UIImage) {
        let flag = CountryModel(forDialCode: dialCode, withCountry: countryCode)
        if !flag.isAccurate{
            flag.country_code = countryCode
            flag.dial_code = dialCode
            flag.flag = flagImg
        }
        self.flag = flag
        self.checkStatus()
    }
    
    
}

extension MobileValidationView : UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let characterCondition = allowedCharacters.isSuperset(of: characterSet)
        return characterCondition
    }
}
