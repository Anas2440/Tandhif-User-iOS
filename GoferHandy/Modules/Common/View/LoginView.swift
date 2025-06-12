//
//  LoginView.swift
//  Handyman
//
//  Created by trioangle1 on 14/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import UIKit

class LoginView: BaseView {
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    @IBOutlet weak var navicationView: SecondaryView!
    @IBOutlet weak var bgCurvedView: TopCurvedView!
    @IBOutlet weak var CountryCodeBGView: SecondaryBorderedView!
    @IBOutlet weak var phoneNumberBgView: SecondaryBorderedView!
    @IBOutlet weak var passwordBgView: SecondaryBorderedView!
    @IBOutlet weak var signInBtn: PrimaryButton!
    @IBOutlet weak var phnTextField: commonTextField!
    @IBOutlet weak var passwordTextField: commonTextField!
    @IBOutlet weak var forgotPasswordBtn: SecondaryTransperentIndicatorButton!
    @IBOutlet weak var dialCodelbl: SecondaryTextFieldLabel!
    @IBOutlet weak var flagIV: UIImageView!
    @IBOutlet weak var backButton: SecondaryBackButton!
    @IBOutlet weak var pageTitle: SecondaryHeaderLabel!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var noAccountBtn: PrimaryTextButton!
    @IBOutlet weak var phoneNumberUpdateBtn: UIButton!
    @IBOutlet weak var socialView : UIView!
    @IBOutlet weak var socialLbl : UILabel!
    @IBOutlet weak var passwordVisibleIV: SecondaryTintImageView!
    @IBOutlet weak var mobileStackHolderView: UIStackView!
    @IBOutlet weak var passwordStackHolderView: UIStackView!
    
    //---------------------------------------
    // MARK: - Class Variables
    //---------------------------------------
    
    var strPhoneNo = ""
    var strLastName = ""
    var visibleState:Bool = false
    var isFromProfile:Bool = false
    var isFromForgotPage:Bool = false
    var spinnerView = JTMaterialSpinner()
    var selectedCountry : CountryModel?
    var viewcontroller:LoginVC!
    
    //---------------------------------------
    // MARK: - Life Cycles
    //---------------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewcontroller = baseVC as? LoginVC
        self.initView()
        self.initGestures()
        self.initNotification()
        self.initLanguage()
        self.darkModeChange()
    }
    
    override
    func willAppear(baseVC : BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.checkNextButtonStatus()
        passwordTextField.textAlignment = isRTLLanguage ? .right : .left
        phnTextField.textAlignment = isRTLLanguage ? .right : .left
        self.initLanguage()
        let support = UberSupport()
        support.showProgressInWindow(showAnimation: true)
        DispatchQueue.main.async{ [weak self] in
            self?.setCountryFlatAndDialCode()
            support.removeProgressInWindow()
        }
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.forgotPasswordBtn.customColorsUpdate()
        self.forgotPasswordBtn.titleLabel?.font = AppTheme.Fontlight(size: 15).font
        self.passwordVisibleIV.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.dialCodelbl.customColorsUpdate()
        self.dialCodelbl.font = AppTheme.Fontlight(size: 15).font
        self.CountryCodeBGView.customColorsUpdate()
        self.phnTextField.customColorsUpdate()
        self.phnTextField.font = AppTheme.Fontlight(size: 15).font
        self.phoneNumberBgView.customColorsUpdate()
        self.passwordTextField.customColorsUpdate()
        self.passwordTextField.font = AppTheme.Fontlight(size: 15).font
        self.passwordBgView.customColorsUpdate()
        self.navicationView.customColorsUpdate()
        self.backButton.customColorsUpdate()
        self.bgCurvedView.customColorsUpdate()
        self.noAccountBtn.customColorsUpdate()
    }
    
    //---------------------------------------
    // MARK: - Initializers
    //---------------------------------------
    
    func initNotification() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(self.keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(self.keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
    }
    
    func initLanguage() {
        let noAccountString = NSMutableAttributedString()
            .attributedString(LangCommon.dontHaveAcc,
                              foregroundColor: .PrimaryColor,
                              fontWeight: .bold,
                              fontSize: 14,
                              underLineColor: .PrimaryColor,
                              underLineNeed: true)
        self.noAccountBtn.setAttributedTitle(noAccountString,
                                             for: .normal)
        self.forgotPasswordBtn.setTitle(LangCommon.forgotPassword.capitalized,
                                        for: .normal)
        self.signInBtn.setTitle(LangCommon.login.capitalized,
                                for: .normal)
        self.phnTextField.placeholder = LangCommon.phoneNumber.capitalized
        self.passwordTextField.placeholder = LangCommon.password.lowercased().capitalized
        self.pageTitle.text = LangCommon.signIn.capitalized
        self.phnTextField.setTextAlignment()
        self.passwordTextField.setTextAlignment()
    }
    
    func initView() {
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.viewcontroller.navigationController?.isNavigationBarHidden = true
        if strPhoneNo.count > 0 {
            self.phnTextField.text = strPhoneNo
        }
        self.phnTextField.becomeFirstResponder()
        self.passwordVisibleIV.image = UIImage(named: "visible")
        self.phnTextField.delegate = self
        self.passwordTextField.delegate = self
        if #available(iOS 10.0, *) {
            phnTextField.keyboardType = .asciiCapableNumberPad
            passwordTextField.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            phnTextField.keyboardType = .numberPad
            passwordTextField.keyboardType = .default
        }
    }
    
    func initGestures(){
        self.socialView.addAction(for: .tap) { [weak self] in
            guard let welf = self else{return}
            welf.viewcontroller.navigationController?.popViewController(animated: false)
            welf.viewcontroller.welcomeNavigation?.navigateToSocailSignUp()
        }
        self.passwordVisibleIV.addAction(for: .tap) {
            self.visiblePasswordIconClicked(self.passwordVisibleIV)
        }
    }
    
    
    
    
    //-----------------------------------------------------------------
    // MARK: - Getting Country Dial Code and Flag from plist file
    //-----------------------------------------------------------------
    
    func setCountryFlatAndDialCode() {
        _ = Constants().GETVALUE(keyname: "dial_code")
        let strCountryCode = Constants().GETVALUE(keyname: "user_country_code")
        let country = CountryModel(forDialCode: nil, withCountry: strCountryCode)
        self.flagIV.image = country.flag
        self.dialCodelbl.text = country.dial_code
        self.selectedCountry = country
        
        var rect = dialCodelbl.frame
        rect.size.width = UberSupport().onGetStringWidth(dialCodelbl.frame.size.width, strContent: dialCodelbl.text! as NSString, font: dialCodelbl.font)
        self.dialCodelbl.frame = rect
        if currentLanguage.key == "en" {
            var rectTxtFld = phnTextField.frame
            rectTxtFld.origin.x = dialCodelbl.frame.origin.x + dialCodelbl.frame.size.width + 5
            rectTxtFld.size.width = self.frame.size.width - rectTxtFld.origin.x - 20
        }
    }
    
    //----------------------------------------------------------------------------
    // MARK: - visible of invisible Password Option Operations Takes place Here
    //----------------------------------------------------------------------------
    
    func visiblePasswordIconClicked(_ sender: UIImageView) {
        self.passwordVisibleIV.image = self.visibleState ?
            UIImage(named: "visible")?.withRenderingMode(.alwaysTemplate) :
            UIImage(named: "invisible")?.withRenderingMode(.alwaysTemplate)
        self.passwordTextField.isSecureTextEntry = self.visibleState
        self.visibleState = !self.visibleState
    }
    
    
    
    //----------------------------------------------------------------------------
    // MARK: - Present the keyboard
    //----------------------------------------------------------------------------
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        
    }
    
    //----------------------------------------------------------------------------
    // MARK:- Dissmiss the keyboard
    //----------------------------------------------------------------------------
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        
    }
    
    
    
    //----------------------------------------------------------------------------
    // MARK: - Button Actions
    //----------------------------------------------------------------------------
    
    @IBAction
    func changeFlagAction(_ sender: UIButton) {
        let propertyView = CountryListVC.initWithStory()
        propertyView.delegate = self
        self.viewcontroller.navigationController?.pushViewController(propertyView,
                                                                     animated: true)
    }
    
    @IBAction
    func forgotPasswordBtnAction(_ sender: Any) {
        self.endEditing(true)
        let mobileValidationVC = MobileValidationVC.initWithStory(usign: self,
                                                                  for: .forgotPassword)
        self.viewcontroller.presentInFullScreen(mobileValidationVC,
                                                animated: true,
                                                completion: nil)
    }
    
    @IBAction
    func dontHaveAcountAction(_ sender: Any) {
        self.endEditing(true)
        self.viewcontroller.navigationController?.popViewController(animated: false)
        self.viewcontroller.welcomeNavigation?.navigateToRegisterVC()
    }
    
    @IBAction
    func loginBtnAction(_ sender: Any) {
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
                self.viewcontroller
                    .commonAlert
                    .setupAlert(alert: LangCommon.message,
                                alertDescription: LangCommon.pleaseEnablePushNotification,
                                okAction: LangCommon.ok)
                self.viewcontroller
                    .commonAlert
                    .addAdditionalOkAction(isForSingleOption: true) {
                        AppDelegate.shared.pushManager.registerForRemoteNotification()
                    }
                return
            }
        }
        self.addProgress()
        self.endEditing(true)
        let country : CountryModel
        if let _selectedCountry = self.selectedCountry {
            country = _selectedCountry
        } else {
            country = CountryModel(forDialCode: self.dialCodelbl.text ?? "+1", withCountry: nil)
        }
        var dicts = JSON()
        dicts["country_code"] = country.country_code
        dicts["mobile_number"] = String(format:"%@",phnTextField.text!)
        dicts["password"] = String(format:"%@",passwordTextField.text!)
        self.viewcontroller.callLoginAPI(parms: dicts)
    }
    
    @IBAction
    func backBtnAction(_ sender: Any) {
        self.viewcontroller.navigationController?.popViewController(animated: true)
    }
    
    //----------------------------------------------------------------------------
    // MARK: - Local Functions
    //----------------------------------------------------------------------------
    
    func showPage() {
        AppDelegate.shared.onSetRootViewController(viewCtrl: self.viewcontroller)
    }
    
    //----------------------------------------------------------------------------
    // MARK: - DISPLAY PROGRESS WHEN API CALLING
    //----------------------------------------------------------------------------
    
    func addProgress() {
        self.signInBtn.isUserInteractionEnabled = false
        signInBtn.addSubview(spinnerView)
        spinnerView.anchor(toView: self.signInBtn,
                           trailing: -15)
        spinnerView.setEqualHightWidthAnchor(toView: self.spinnerView,
                                             height: 25)
        spinnerView.setCenterXYAncher(toView: signInBtn,
                                      centerY: true)
        spinnerView.circleLayer.lineWidth = 3.0
        spinnerView.circleLayer.strokeColor =  UIColor.PrimaryTextColor.cgColor
        spinnerView.beginRefreshing()
    }
    
    //----------------------------------------------------------------------------
    // MARK: - REMOVE PROGRESS WHEN API CALL DONE
    //----------------------------------------------------------------------------
    
    func removeProgress() {
        self.signInBtn.isUserInteractionEnabled = true
        spinnerView.endRefreshing()
        spinnerView.removeFromSuperview()
    }
    
    
    
    //----------------------------------------------------------------------------
    // MARK: - Checking Next Button status
    //----------------------------------------------------------------------------
    /*
     USER NAME & PASSWORD IS FILLED
     */
    
    func checkNextButtonStatus() {
        if let number = self.phnTextField.text,
           let password = self.passwordTextField.text {
            let isActive = number.count > 5 && password.count > 5
            self.signInBtn.backgroundColor = isActive ? .PrimaryColor : .TertiaryColor
            self.signInBtn.isUserInteractionEnabled = isActive
        } else {
            self.signInBtn.backgroundColor = .TertiaryColor
            self.signInBtn.isUserInteractionEnabled = false
        }
    }
    
    
    
    
    
}

//----------------------------------------------------------------------------
// MARK: - Mobile Number Valiadation Protocol
//----------------------------------------------------------------------------

extension LoginView : MobileNumberValiadationProtocol{
    func verified(number: MobileNumber) {
        let otpView = ResetPasswordVC.initWithStory()
        otpView.strMobileNo = number.number
        otpView.countryModel = number.flag
        self.viewcontroller.navigationController?.pushViewController(otpView,
                                                                     animated: true)
    }
}

//----------------------------------------------------------------------------
// MARK: - CHANGE DIAL CODE DELEGATE METHOD
//----------------------------------------------------------------------------

extension LoginView : CountryListDelegate {
    /*
     IF USER CHANGED THE COUNTRY CODE
     */
    internal func countryCodeChanged(countryCode:String, dialCode:String, flagImg:UIImage) {
        dialCodelbl.text = "\(dialCode)"
        self.selectedCountry = CountryModel(forDialCode: nil, withCountry: countryCode)
        flagIV.image = flagImg
        Constants().STOREVALUE(value: dialCode, keyname: "dial_code")
        Constants().STOREVALUE(value: countryCode, keyname: "user_country_code")
        
        var rect = dialCodelbl.frame
        rect.size.width = UberSupport().onGetStringWidth(dialCodelbl.frame.size.width, strContent: dialCode as NSString, font: dialCodelbl.font)
        dialCodelbl.frame = rect
    }
}

//----------------------------------------------------------------------------
// MARK: - TextField Delegate Method
//----------------------------------------------------------------------------

extension LoginView : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction
    private func textFieldDidChange(textField: UITextField) {
        self.checkNextButtonStatus()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == phnTextField {
            let ACCEPTABLE_CHARACTERS = "1234567890"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        } else if (string == " ") {
            return false
        } else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
