//
//  MobileValidationVC.swift
//  Gofer
//
//  Created by trioangle on 11/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

protocol MobileNumberValiadationProtocol {
    func verified(number : MobileNumber)
}
enum NumberValidationPurpose{
      case forgotPassword
      case register
      case changeNumber
  }
/**
    MobileNumberValidation Screen States
       - States:
           - mobileNumber
           - OTP
    */
   enum ScreenState{
       case mobileNumber
       case OTP
   }
/**
 Mobile number validation using OTP
 
 - Warning: Caller must implement MobileNumberValiadationProtocol
 - Author: Abishek Robin
 */
class MobileValidationVC: BaseViewController{
    
    //MARK:- outlets
    @IBOutlet var mobileValidationView: MobileValidationView!
    var accViewModel : AccountViewModel!
    //MARK:- variables
    var validationDelegate : MobileNumberValiadationProtocol?
    var purpose : NumberValidationPurpose!
    var mobileNumberUpdated : Bool = false
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if mobileNumberUpdated {
            self.mobileNumberUpdated = true
        } else {
            self.mobileNumberUpdated = false
        }
    }
    
    /**
     Static function to initialize MobileValidationVC
     - Author: Abishek Robin
     - Parameters:
     - delegate: MobileNumberValiadationProtocol to be parsed
     - purpose: forgotPassword,register,changeNumber
     - Returns: MobileValidationVC object
     - Warning: Purpose must be parsed properly
     */
    class func initWithStory(usign delegate : MobileNumberValiadationProtocol,
                             for purpose : NumberValidationPurpose)-> MobileValidationVC{
        let view : MobileValidationVC = UIStoryboard.gojekAccount.instantiateIDViewController()
        view.purpose = purpose
        view.validationDelegate = delegate
        view.accViewModel = AccountViewModel()
        return view
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //MARK:- Webservices
    func wsToVerifyNumberApiCall(params: [AnyHashable: Any]){
        self.accViewModel.wsToVerifyNumberApiCall(parms: params){(result) in
            //            if isSuccess{
            //                if isValid{
            //                                if self.mobileValidationView.currentScreenState  != .OTP{//if already not in otp screen
            //                                    self.mobileValidationView.aniamateView(for: .OTP)
            //                                }
            //                                self.mobileValidationView.otpFromAPI = otp
            //                                print("otp\(self.mobileValidationView.otpFromAPI ?? "")")
            //
            //                                appDelegate.createToastMessage("OTP \(otp)")
            //                                self.mobileValidationView.removeProgress()
            //                            }else{
            //                                self.mobileValidationView.otpFromAPI = nil
            //                    self.mobileValidationView.showError(errorMsg!)
            //                                self.mobileValidationView.removeProgress()
            //                            }
            //            }
            //            else{
            //                UberSupport.shared.removeProgressInWindow()
            //                AppDelegate.shared.createToastMessage(errorMsg!)
            //                self.mobileValidationView.removeProgress()
            //            }
            //            self.mobileValidationView.addProgress()
            
            switch result{
            case .success(let res):
                self.mobileNumberUpdated = true
                if res.verified{
                    if Shared.instance.otpEnabled{
                        if self.mobileValidationView.currentScreenState  != .OTP{//if already not in otp screen
                            self.mobileValidationView.aniamateView(for: .OTP)
                        }
                        self.mobileValidationView.otpFromAPI = res.otp
                        print("otp\(self.mobileValidationView.otpFromAPI ?? "")")
                        if res.otp != nil {
                            ///uncomment to show otp toast
                            appDelegate.createToastMessage("OTP \(res.otp!)")
                            //
                        }
                        self.mobileValidationView.removeProgress()
                    }
                    else{
                        self.mobileValidationView.onSuccess()
                    }
                    
                } else {
                    self.mobileValidationView.otpFromAPI = nil
                    self.mobileValidationView.endEditing(true)
                    self.mobileValidationView.showError(res.message!)
                    self.mobileValidationView.removeProgress()
                }
            case .failure(let err):
                UberSupport.shared.removeProgressInWindow()
                self.mobileValidationView.endEditing(true)
                AppDelegate.shared.createToastMessage(err.localizedDescription)
                self.mobileValidationView.removeProgress()
            }
        }
    }
    func wsToVerifyOTP(param:JSON) {
        self.accViewModel.wsToVerifyOTP(parms: param) { (response) in
            switch response {
            case .success(let result):
                if result {
                    self.mobileValidationView.onSuccess()
                } else {
                    self.mobileValidationView.endEditing(true)
                    self.mobileValidationView.customOtpView.invalidOTP()
                }
            case .failure(let err):
                self.mobileValidationView.endEditing(true)
                AppDelegate.shared.createToastMessage(err.localizedDescription)
                
            }
        }
    }
}
