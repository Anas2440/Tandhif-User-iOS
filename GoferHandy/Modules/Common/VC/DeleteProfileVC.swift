//
//  DeleteProfileVC.swift
//  GoferHandy
//
//  Created by trioangle on 13/09/22.
//  Copyright © 2022 Vignesh Palanivel. All rights reserved.
//

import UIKit
import OTPFieldView

class DeleteProfileVC: UIViewController,OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        print("OTPString: \(otp)")
        self.enteredOTP = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        print("Has entered all OTP? \(hasEnteredAll)")
        self.enableButton = hasEnteredAll
        if self.enableButton {
            self.submitBtn.isHidden = false
        } else {
            self.submitBtn.isHidden = true
        }
        return false
    }
    @IBOutlet var otpTextFieldView: OTPFieldView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var enterOTPLbl: UILabel!
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet var resendOTPLbl: UILabel!
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBAction func backBtn(_ sender: Any) {
    }
    
    var enableButton: Bool = false
    var enteredOTP = ""
    var recievedOTP = ""
    var counter = 15
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOtpView()
        self.submitBtn.isHidden = true
        
        self.resendOTPLbl.addTap {
//            self.resendOTPLbl.text = self.language.goferDeliveryAll.resendotp
            self.resendOTPLbl.text = "resendotp"
            self.wsToResendOTP()

       
    }
    

  
}
   
//    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func deleteAccountAction(_ sender: Any) {
        
        if recievedOTP == enteredOTP {
            self.wsToDeleteAccount()
        } else {
//            Utilities.showAlertMessage(message: self.language.goferDeliveryAll.otpmismatch, onView: self)
            Utilities.showAlertMessage(message: "otpmismatch", onView: self)
        }
    }
    func ThemeChange() {
        
        self.headerView.customColorsUpdate()
    }
    @objc func updateCounter() {
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            if counter == 1 {
                self.countDownLabel.text = "Resend OTP"
            } else {
                self.countDownLabel.text = "Resend OTP in \(counter) Second"
            }
            
            counter -= 1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.submitBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupOtpView()
        self.submitBtn.isHidden = true
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
   
    
    
    func setupOtpView(){
//        self.enterOTPLbl.text = self.language.goferDeliveryAll.otptitle
        self.enterOTPLbl.text = "An OTP is sent to the email , Enter the OTP for verification"
            self.otpTextFieldView.fieldsCount = 4
            self.otpTextFieldView.fieldBorderWidth = 2
            self.otpTextFieldView.defaultBorderColor = UIColor.lightGray
            self.otpTextFieldView.filledBorderColor = UIColor(hex:"#006600")
            self.otpTextFieldView.cursorColor = UIColor.red
            self.otpTextFieldView.displayType = .square
            self.otpTextFieldView.fieldSize = 40
            self.otpTextFieldView.separatorSpace = 8
            self.otpTextFieldView.shouldAllowIntermediateEditing = false
            self.otpTextFieldView.delegate = self
            self.otpTextFieldView.initializeUI()
        }
    
//    func setNavigationBar()
//    {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationController?.navigationBar.barTintColor = AppPrimaryColor
//        self.navigationController?.navigationBar.isHidden = false
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.7, height: 30))
//        label.text = "Delete Account"
//        label.tintColor = AppPrimaryDarkTextColor
//        label.font = UIFont(name: k_ApplicationFontBold, size: 18)!
//        label.textColor = AppPrimaryLightTextColor
//        if Constants.instance.language?.isRTLLanguage() ?? false{
//            label.textAlignment = .right
//        }else{
//            label.textAlignment = .left
//        }
//        label.isUserInteractionEnabled = true
//        self.navigationController?.navigationBar.alpha = 1.0
//        self.navigationItem.titleView = label
//        self.navigationController?.navigationBar.tintColor = AppPrimaryColor
//        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
//        navigationController?.navigationBar.isTranslucent = false
//        let backBtn = UIButton(type: .custom)
//        backBtn.addAppImageColor(.BackButton, color: AppPrimaryLightTextColor)
//        backBtn.addTarget(self, action:  #selector(self.backSelected), for: .touchUpInside)
//        self.addBackButton(backBtn)
//    }
//
    @objc func backSelected(_:Any) {
            self.navigationController?.popViewController(animated: true)
    //        self.navigationController?.dismiss(animated: false, completion: nil)
        }
    
    
     func deleteUserMoveToLogin() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(false, forKey: "isLogin")
         //iswarya
         ConnectionHandler.shared.doLogoutActions()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let initVC = WelcomeVC.initWithStory()
        self.navigationController?.pushViewController(initVC, animated: true)
    }
    
    func wsToDeleteAccount() {
        var paramDict = [String:Any]()
        paramDict["token"] = Constants().GETVALUE(keyname: "access_token")
        if let language : String = UserDefaults.value(for: .default_language_option){
            paramDict["language"] = language
            
        }else{
            paramDict["language"] = "en"
        }
        paramDict["user_type"] = "user"
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"delete_account", paramDict: paramDict, viewController:self, isToShowProgress:true, isToStopInteraction:false,complete: { (response) in
            
            
            if response["status_code"] as? String == "1" {
                let alert = UIAlertController(title: "GoferHandy", message: response.status_message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.deleteUserMoveToLogin()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                Utilities.showAlertMessage(message: response.status_message, onView: self)
            }
        }){(error) in
            
        }
    }
    
    func wsToResendOTP() {
        var paramDict = [String:Any]()
        paramDict["token"] = Constants().GETVALUE(keyname: "access_token")
        if let language : String = UserDefaults.value(for: .default_language_option){
            paramDict["language"] = language
            paramDict["isNeedOtp"] = "true"
        
        
        }else{
            paramDict["language"] = "en"
        }
        paramDict["user_type"] = "user"
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"delete_verification", paramDict: paramDict, viewController:self, isToShowProgress:true, isToStopInteraction:false,complete: { (response) in
        
            
            if response["status_code"] as? String == "1" {
                Utilities.showAlertMessage(message: "OTP sent successfully", onView: self)
                self.recievedOTP = response.otpStatus
            } else {
                Utilities.showAlertMessage(message: response.status_message, onView: self)
            }
        }){(error) in
            
        }
    }
    
    
   
//    MARK:- initWithStory
    class func initWithStory() -> DeleteProfileVC{
        return UIStoryboard.init(name: "GoJek_Account", bundle: nil).instantiateViewController(withIdentifier: "DeleteProfileVC") as! DeleteProfileVC
    }
    
    
}
