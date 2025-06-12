//
//  RegisterView.swift
//  Handyman
//
//  Created by trioangle1 on 14/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Alamofire

class RegisterView: BaseView,UITextFieldDelegate,CountryListDelegate{
    
    // MARK: - Outlets
    
    @IBOutlet weak var contentBgCurveView: TopCurvedView!
    @IBOutlet weak var scrollViewHolderView: UIView!
    @IBOutlet weak var navicationView: SecondaryView!
    @IBOutlet weak var holderView: SecondaryView!
    @IBOutlet weak var firstNameHolderView: SecondaryBorderedView!
    @IBOutlet weak var lastNameHolderView: SecondaryBorderedView!
    @IBOutlet weak var emailHolderView: SecondaryBorderedView!
    @IBOutlet weak var countryHolderView: SecondaryBorderedView!
    @IBOutlet weak var phoneNumberHolderView: SecondaryBorderedView!
    @IBOutlet weak var passwordHolderView: SecondaryBorderedView!
    @IBOutlet weak var referalHolderView: SecondaryBorderedView!
    @IBOutlet weak var backButton: SecondaryTintButton!
    @IBOutlet weak var passwordWarningLbl: ErrorLabel!
    @IBOutlet weak var registerUrInfo : SecondaryHeaderLabel!
    @IBOutlet weak var scrollObjHolder: UIScrollView!
    @IBOutlet weak var txtFldFirstName: commonTextField!
    @IBOutlet weak var txtFldLastName: commonTextField!
    @IBOutlet weak var txtFldEmail: commonTextField!
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var lblDialCode: SecondaryTextFieldLabel!
    @IBOutlet weak var txtFldPhoneNo: commonTextField!
    @IBOutlet weak var txtFldPassword: commonTextField!
    @IBOutlet weak var txtFieldReferal : commonTextField!
    @IBOutlet weak var checkImgView: PrimaryImageView!
    @IBOutlet weak var loginBtn: PrimaryButton!
    @IBOutlet weak var noAccBtn: UIButton!
    @IBOutlet weak var terms_and_condition: TTTAttributedLabel!
    @IBOutlet weak var countryStack: UIStackView!
    @IBOutlet weak var referalStack: UIStackView!
    @IBOutlet weak var checkImgBtn: UIButton!
    @IBOutlet weak var socialView : UIView!
    @IBOutlet weak var socialLbl : UILabel!
    @IBOutlet weak var passwordVisibleIV: SecondaryTintImageView!
    @IBOutlet weak var passwordStack : UIStackView!
    @IBOutlet weak var errorEmailLbl: ErrorLabel!
    // MARK: - Class Variables
    
    var spinnerView = JTMaterialSpinner()
    var fieldCollection  = [UITextField]()
    let bottomViewHeight : CGFloat = 80
    var controller:RegisterVC!
    var checkTOC = false
    var visibleState:Bool = false
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.controller = baseVC as? RegisterVC
        self.initView()
        self.initGestures()
        if !self.controller.dictParms.isEmpty{
            self.setUserInfo(fromDict: self.controller.dictParms)
        }
    }
    override func willAppear(baseVC : BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.checkImgView.image =  self.checkTOC ?
            UIImage(for: .radioSelected) :
            UIImage(for: .radioUnselected)
        // Password Stack is Only Visible When You are Not Signin using without Social Logins
        self.passwordStack.isHidden = UserDefaults.standard.bool(forKey: "is_from_social_login")
        self.checkNextButtonStatus()
    }
    override func didAppear(baseVC : BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    
    //----------------------------------------------
    // MARK: - Initializers
    //----------------------------------------------
    
    func initView() {
        self.checkNextButtonStatus()
        self.errorEmailLbl.isHidden = true
        self.errorEmailLbl.text = LangCommon.enterValidEmailID
        self.passwordWarningLbl.isHidden = true
        self.passwordVisibleIV.image = UIImage(named: "visible")
        self.txtFldFirstName.delegate = self
        self.txtFldLastName.delegate = self
        self.txtFldPassword.delegate = self
        self.txtFieldReferal.delegate = self
        self.txtFldEmail.delegate = self
        self.txtFldPhoneNo.delegate = self
        self.loginBtn.isUserInteractionEnabled = false
        self.terms_and_condition.delegate = self
        self.registerUrInfo.textAlignment = .natural
        self.txtFldPassword.addTarget(self,
                                      action: #selector(passwordValidationError(_:)),
                                      for: .editingChanged)
        self.txtFldFirstName.setTextAlignment()
        self.txtFldLastName.setTextAlignment()
        self.txtFldPassword.setTextAlignment()
        self.txtFieldReferal.setTextAlignment()
        self.txtFldEmail.setTextAlignment()
        self.txtFldPhoneNo.setTextAlignment()
        self.terms_and_condition.setTextAlignment()
        self.loginBtn.setTitle(LangCommon.common1Continue.capitalized,
                               for: .normal)
        self.registerUrInfo.text = LangCommon.register.capitalized
        self.txtFldFirstName.placeholder = LangCommon.firstName
        self.txtFldLastName.placeholder = LangCommon.lastName
        self.txtFldPassword.placeholder = LangCommon.password.lowercased().capitalized
        self.txtFieldReferal.placeholder = LangCommon.refCode
        self.txtFldEmail.placeholder = LangCommon.placehodlerMail
        
        if #available(iOS 10.0, *) {
            txtFldFirstName.keyboardType = .asciiCapable
            txtFldLastName.keyboardType = .asciiCapable
            txtFldPassword.keyboardType = .asciiCapable
            txtFldEmail.keyboardType = .emailAddress
            txtFldPhoneNo.keyboardType = .asciiCapableNumberPad
            txtFieldReferal.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            txtFldFirstName.keyboardType = .default
            txtFldLastName.keyboardType = .default
            txtFldPassword.keyboardType = .default
            txtFldEmail.keyboardType = .emailAddress
            txtFldPhoneNo.keyboardType = .numberPad
            txtFieldReferal.keyboardType = .default
        }
        self.txtFieldReferal.isSecureTextEntry = false
        self.setCountryFlatAndDialCode()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)
        self.setUserInfo()
        self.setHyperLink()
        if !Shared.instance.isReferralEnabled(){
            self.txtFieldReferal.isHidden = true
            self.referalStack.isHidden = true
        }
        self.ThemeUpdate()
    }
    
    func ThemeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setHyperLink()
        self.navicationView.customColorsUpdate()
        self.controller.commonAlert.ThemeChange()
        self.lblDialCode.customColorsUpdate()
        self.terms_and_condition.textColor = self.isDarkStyle ?
            .DarkModeTextColor : .SecondaryTextColor
        self.darkModeChange()
        self.contentBgCurveView.customColorsUpdate()
        self.passwordVisibleIV.customColorsUpdate()
        self.registerUrInfo.customColorsUpdate()
        self.holderView.customColorsUpdate()
        self.firstNameHolderView.customColorsUpdate()
        self.txtFldFirstName.customColorsUpdate()
        self.txtFldLastName.customColorsUpdate()
        self.txtFldEmail.customColorsUpdate()
        self.txtFldPassword.customColorsUpdate()
        self.txtFieldReferal.customColorsUpdate()
        self.txtFldPhoneNo.customColorsUpdate()
        self.lastNameHolderView.customColorsUpdate()
        self.emailHolderView.customColorsUpdate()
        self.countryHolderView.customColorsUpdate()
        self.phoneNumberHolderView.customColorsUpdate()
        self.passwordHolderView.customColorsUpdate()
        self.referalHolderView.customColorsUpdate()
        self.setupNoAccountBtn()
    }
    
    func setupNoAccountBtn() {
        self.noAccBtn.isHidden = false
        let haveAccount : NSMutableAttributedString = NSMutableAttributedString()
            .attributedString(LangCommon.haveAnAccount + " ",
                              foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                              fontWeight: .regular,
                              fontSize: 14)
            .attributedString(LangCommon.login,
                              foregroundColor: .ThemeTextColor,
                              fontWeight: .bold,
                              fontSize: 14,
                              underLineColor: .PrimaryColor,
                              underLineNeed: true)
        self.noAccBtn.setAttributedTitle(haveAccount, for: .normal)
    }
    
    func passwordVisibleImageViewPressed(_ sender:UIImageView) {
        if visibleState {
            self.passwordVisibleIV.image = UIImage(named: "visible")
            self.txtFldPassword.isSecureTextEntry = true
            self.visibleState = false
        } else {
            self.passwordVisibleIV.image = UIImage(named: "invisible")
            self.txtFldPassword.isSecureTextEntry = false
            self.visibleState = true
        }
    }
    
    
    func initGestures(){
        self.socialView.addAction(for: .tap) {  [weak self] in
            guard let welf = self else{return}
            welf.controller.navigationController?.popToRootViewController(animated: false)
            welf.controller.welcomeNavigation?.navigateToSocailSignUp()
        }
        self.passwordVisibleIV.addAction(for: .tap) {
            self.passwordVisibleImageViewPressed(self.passwordVisibleIV)
        }
        
    }
    // MARK: - Buttons Actions And TextField delegate methods
    
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        if textField.tag == 3 {
            if let text = textField.text , text.count > 0 {
                self.errorEmailLbl.isHidden = UberSupport().isValidEmail(testStr: text)
            } else {
                self.errorEmailLbl.isHidden = true
            }
        }
        self.checkNextButtonStatus()
    }
    
    
    @IBAction func checkImgBtnAction(_ sender: Any) {
        self.checkTOC = !checkTOC
        
        self.checkImgView.image =  self.checkTOC ? UIImage(for: .radioSelected)?.withRenderingMode(.alwaysTemplate) : UIImage(for: .radioUnselected)?.withRenderingMode(.alwaysTemplate)
        self.checkNextButtonStatus()
    }
    
    //-----------------------------------------------------
    // MARK: When User Press Back Button
    //-----------------------------------------------------
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.backAlert()
    }
    
    func backAlert()  {
        self.controller.commonAlert
            .setupAlert(alert: LangCommon.areYouSureYouWantToExit,
                        okAction: LangCommon.ok,
                        cancelAction: LangCommon.cancel.capitalized)
        self.controller.commonAlert
            .addAdditionalOkAction(isForSingleOption: false) {
                self.controller.exitScreen(animated: true)
            }
    }
    
    @IBAction func onNextTapped(_ sender:UIButton!) {
        if(!checkTOC){
            AppUtilities().customCommonAlertView(titleString: "",
                                                 messageString: LangCommon.agreeTermsAndPrivacyPolicyContent)
        }else{
            addProgress()
            self.endEditing(true)
            self.loginBtn.isUserInteractionEnabled = false
            var params = self.controller.dictParms
            
            self.controller.signUpType.getParamValueForType.forEach { (item) in
                params[item.key] = item.value
            }
            params["first_name"]    = txtFldFirstName.text!
            params["last_name"]    = txtFldLastName.text!
            
            /// only upload the password is not from the social login
            /// we are uploading empty field for the social login error
            //            if !self.controller.isFromSocialLogin {
            params["password"]    = txtFldPassword.text!
            //            }
            
            params["mobile_number"]    = txtFldPhoneNo.text!
            params["email_id"]    = txtFldEmail.text!
            params["referral_code"] = txtFieldReferal.text
            let strDeviceType = "1"
            let strDeviceToken = Utilities.sharedInstance.getDeviceToken()
            let strUserType = "Driver"
            params["new_user"] = "1"
            params["device_id"] = strDeviceToken
            params["device_type"] = strDeviceType
            params["user_type"] = strUserType
            params["country_code"] = self.controller.country.country_code
            params["language"] = currentLanguage.key 
            self.controller.callSocialSignUpAPI(parms: params)
        }
    }
    @objc func passwordValidationError(_ sender:UITextField) {
        if let count = sender.text?.count {
            if count < 6 && count > 0 {
                self.passwordWarningLbl.isHidden = false
                self.passwordWarningLbl.text = LangCommon.passwordValidationMsg.capitalized
            } else {
                self.passwordWarningLbl.isHidden = true
            }
        }
    }
    @IBAction func gotoLoginPage(_ sender: UIButton!)
    {
        self.endEditing(true)
        self.controller.navigationController?.popToRootViewController(animated: false)
        self.controller.welcomeNavigation?.navigateToLoginVC()
        
    }
    //MARK:- UDF
    
    func getNextBtnText() -> String{
        return isRTLLanguage ? "e" : "I"
    }
    // setting social loggedin user infomation
    func setUserInfo(fromDict dictParms : [String : Any]){
        txtFldFirstName.text = dictParms["first_name"] as? String
        txtFldLastName.text = dictParms["last_name"] as? String
        txtFldEmail.text = dictParms["email"] as? String
        txtFldPhoneNo.text = dictParms["mobile_number"] as? String
        txtFldPhoneNo.isUserInteractionEnabled = false
        let code = dictParms["country_code"] as? String ?? String()
        let flag = CountryModel(withCountry: code)
        self.imgCountryFlag.image = flag.flag
        self.selectedFlag = flag
        self.lblDialCode.text = flag.dial_code
        if case SignUpType.apple(id: _, email: let email) = self.controller.signUpType,
           let _email = email,
           !_email.isEmpty{
            txtFldEmail.text = _email
            self.txtFldEmail.isUserInteractionEnabled = false
        }else{
            self.txtFldEmail.isUserInteractionEnabled = true
        }
    }
    func setUserInfo()
    {
        txtFldPhoneNo.isUserInteractionEnabled = false
        let flag = self.controller.country!
        txtFldPhoneNo.text = self.controller.verified_mobile_number
        self.imgCountryFlag.image = flag.flag
        self.imgCountryFlag.contentMode = .scaleToFill
        self.imgCountryFlag.clipsToBounds = true
        self.lblDialCode.text = flag.dial_code
        
    }
    var selectedFlag : CountryModel?
    // GETTING USER CURRENT COUNTRY CODE AND FLAG IMAGE
    func setCountryFlatAndDialCode()
    {
        //return
        
        
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let flag = CountryModel(withCountry: countryCode)
            imgCountryFlag.image = flag.flag
            lblDialCode.text = flag.dial_code
        }
        
        var rect = lblDialCode.frame
        rect.size.width = UberSupport().onGetStringWidth(lblDialCode.frame.size.width, strContent: lblDialCode.text! as NSString, font: lblDialCode.font)
        lblDialCode.frame = rect
    }
    //Show the keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //        let info = notification.userInfo!
        //        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //        // UberSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: viewNextHolder)
        //        scrollObjHolder.contentSize = CGSize(width: scrollObjHolder.frame.size.width, height:  scrollObjHolder.frame.size.height+keyboardFrame.size.height - 10)
    }
    //Hide the keyboard
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        //        scrollObjHolder.contentSize = CGSize(width: scrollObjHolder.frame.size.width, height:  txtFldPassword.frame.origin.y + 100)
    }
    
    
    
    
    // MARK: - TextField Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        if textField.tag == 3 {
            if textField.text == "" {
                self.errorEmailLbl.isHidden = true
            }
        }
        /*if textField.tag == 1   // FIRST NAME
         {
         scrollObjHolder.setContentOffset(CGPoint(x: 0,y :10), animated: true)
         }
         else if textField.tag == 2   // LAST NAME
         {
         scrollObjHolder.setContentOffset(CGPoint(x: 0,y :10), animated: true)
         }
         else if textField.tag == 3   // EMAIL ID
         {
         scrollObjHolder.setContentOffset(CGPoint(x: 0,y :50), animated: true)
         }
         else if textField.tag == 4   // PHONE NO
         {
         scrollObjHolder.setContentOffset(CGPoint(x: 0,y :200), animated: true)
         }
         else if textField.tag == 5   // PASSWORD
         {
         scrollObjHolder.setContentOffset(CGPoint(x: 0,y :230), animated: true)
         }
         else if textField.tag == 6 //Referral
         {
         scrollObjHolder.setContentOffset(CGPoint(x: 0, y: 260), animated: true)
         }
         else if textField.tag == 7 //City
         {
         scrollObjHolder.setContentOffset(CGPoint(x: 0, y: 290), animated: true)
         }*/
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtFieldReferal{
            let ACCEPTABLE_CHARACTERS = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == " ") {
            return false
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
    
    // MARK: - Checking Next Button status
    /*
     Checking all textfield values exist
     and making next button interaction enable/disable
     */
    func checkNextButtonStatus() {
        if ((txtFldFirstName.text?.count)!>0 &&
                (txtFldLastName.text?.count)!>0 &&
                ((txtFldEmail.text?.count)!>0 &&
                    UberSupport().isValidEmail(testStr: txtFldEmail.text!)) &&
            (txtFldPhoneNo.text?.count)!>5 && checkTOC)  {
            if UserDefaults.standard.bool(forKey: "is_from_social_login") {
                loginBtn.isUserInteractionEnabled = true
                loginBtn.backgroundColor = .PrimaryColor
            } else {
                if (txtFldPassword.text?.count)!>5 {
                    loginBtn.isUserInteractionEnabled = true
                    loginBtn.backgroundColor = .PrimaryColor
                }
            }
        } else {
            loginBtn.isUserInteractionEnabled = false
            loginBtn.backgroundColor = .TertiaryColor
        }
    }
    @IBAction func onChangeDialCodeTapped(_ sender:UIButton!) {
        let propertyView = CountryListVC.initWithStory()
        propertyView.delegate = self
        self.controller.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    // CountryListVC Delegate Method
    internal func countryCodeChanged(countryCode:String, dialCode:String, flagImg:UIImage) {
        lblDialCode.text = "\(dialCode)"
        imgCountryFlag.image = flagImg
        
        Constants().STOREVALUE(value: dialCode, keyname: "dial_code")
        Constants().STOREVALUE(value: countryCode, keyname: "user_country_code")
        
        var rect = lblDialCode.frame
        rect.size.width = UberSupport().onGetStringWidth(lblDialCode.frame.size.width, strContent: dialCode as NSString, font: lblDialCode.font)
        lblDialCode.frame = rect
        if !isRTLLanguage {
            var rectTxtFld = txtFldPhoneNo.frame
            rectTxtFld.origin.x = lblDialCode.frame.origin.x + lblDialCode.frame.size.width + 5
            rectTxtFld.size.width = self.frame.size.width - rectTxtFld.origin.x - 20
            txtFldPhoneNo.frame = rectTxtFld
        }
    }
    
    // MARK: Navigating to Main Map Page
    /*
     After filled all user details validating api will call
     */
    
    // Add progress View
    func addProgress() {
        self.loginBtn.addSubview(spinnerView)
        spinnerView.anchor(toView: self.loginBtn,
                           trailing: -15)
        spinnerView.setEqualHightWidthAnchor(toView: self.spinnerView,
                                             height: 25)
        spinnerView.setCenterXYAncher(toView: loginBtn,
                                      centerY: true)
        spinnerView.circleLayer.lineWidth = 3.0
        spinnerView.circleLayer.strokeColor =  UIColor.PrimaryTextColor.cgColor
        spinnerView.beginRefreshing()
    }
    //Remove Progress View
    func removeProgress() {
        spinnerView.endRefreshing()
        spinnerView.removeFromSuperview()
    }
    
}

//MARK:  Hyper link Attribute text
extension RegisterView : TTTAttributedLabelDelegate{
    func setHyperLink(){
        
        let full_text = "\(LangCommon.iAgreeToThe) \(LangCommon.termsConditions) \(LangCommon.and) \(LangCommon.privacyPolicy)"
        let terms_text = LangCommon.termsConditions
        let privacy_text = LangCommon.privacyPolicy
        self.terms_and_condition.setText(full_text, withLinks: [
            HyperLinkModel(url: URL(string: "\(APIBaseUrl)term_conditions")!, string: terms_text),
            HyperLinkModel(url: URL(string: "\(APIBaseUrl)privacy_policy")!, string: privacy_text)
        ])
        
        
    }
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}


