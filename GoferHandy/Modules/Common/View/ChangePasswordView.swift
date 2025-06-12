//
//  ChangePasswordView.swift
//  GoferHandy
//
//  Created by Trioangle on 09/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit


class ChangePasswordView: BaseView {
    var changePasswordVC: ChangePasswordVC!
    var keyboardHight : CGFloat?
    
    var newPassword:String?
    var oldPassword:String?
    var conformPassword:String?
    var isUserPasswordMatched:Bool = false
    var oldPasswordVisibleState:Bool = false
    var newPasswordVisibleState:Bool = false
    var conformPasswordVisibleState:Bool = false
    
    // outlets
    @IBOutlet weak var oldPasswordBgView: SecondaryBorderedView!
    
    @IBOutlet weak var newPasswordBGView: SecondaryBorderedView!
    
    @IBOutlet weak var confirmPasswordBGView: SecondaryBorderedView!
    
    @IBOutlet weak var changePasswordBGView: SecondaryView!
    @IBOutlet weak var oldPasswordTF: commonTextField!
    @IBOutlet weak var oldPasswordVisibleIV: PrimaryImageView!
    @IBOutlet weak var newPasswordTF: commonTextField!
    @IBOutlet weak var newPasswordVisibleIV: PrimaryImageView!
    @IBOutlet weak var conformPasswordTF: commonTextField!
    @IBOutlet weak var conformPasswordVisibleIV: PrimaryImageView!
    @IBOutlet weak var conformBtn: PrimaryButton!
    @IBOutlet weak var cancelBtn: SecondaryButton!
    @IBOutlet weak var TitleLbl: SecondaryHeaderLabel!
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.changePasswordVC = baseVC as? ChangePasswordVC
        self.initView()
        self.initGesture()
        self.setupObserver()
        self.ThemeChange()
    }
    
    func ThemeChange() {
        self.TitleLbl.customColorsUpdate()
        self.oldPasswordBgView.customColorsUpdate()
        self.newPasswordBGView.customColorsUpdate()
        self.confirmPasswordBGView.customColorsUpdate()
        self.changePasswordBGView.customColorsUpdate()
        self.oldPasswordTF.customColorsUpdate()
        self.newPasswordTF.customColorsUpdate()
        self.conformPasswordTF.customColorsUpdate()
        self.oldPasswordVisibleIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.newPasswordVisibleIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.conformPasswordVisibleIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.cancelBtn.customColorsUpdate()
    }
    
    func initView() {
        
        // Main View Customisation
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.newPasswordVisibleIV.image = UIImage(named: "visible")
        self.oldPasswordVisibleIV.image = UIImage(named: "visible")
        self.conformPasswordVisibleIV.image = UIImage(named: "visible")
        self.TitleLbl.text = LangCommon.changePassword.capitalized
        if isRTLLanguage {
            self.oldPasswordTF.textAlignment = NSTextAlignment.right
            self.newPasswordTF.textAlignment = NSTextAlignment.right
            self.conformPasswordTF.textAlignment = NSTextAlignment.right
        } else {
            self.oldPasswordTF.textAlignment = NSTextAlignment.left
            self.newPasswordTF.textAlignment = NSTextAlignment.left
            self.conformPasswordTF.textAlignment = NSTextAlignment.left
        }
        
        // Background View Customisation
        
        self.changePasswordBGView.clipsToBounds = true
        self.changePasswordBGView.layer.cornerRadius = 15
        
        
        
        
        //Old Password Text Field Customisation
        self.oldPasswordTF.adjustsFontSizeToFitWidth = true
        self.oldPasswordTF.isSecureTextEntry = true
        self.oldPasswordTF.placeholder = LangCommon.enterYourOldPassword
        self.oldPasswordTF.delegate = self
        self.oldPasswordTF.addTarget(self, action: #selector(oldPasswordTFEnteredValues(_:)), for: .editingChanged)
        
        
        //New Password Text Field Customisation
        self.newPasswordTF.adjustsFontSizeToFitWidth = true
        self.newPasswordTF.isSecureTextEntry = true
        self.newPasswordTF.placeholder = LangCommon.enterYourNewPassword
        self.newPasswordTF.delegate = self
        self.newPasswordTF.addTarget(self, action: #selector(newPasswordTFEnteredValues(_:)), for: .editingChanged)
        
        
        
        //Conform Password Text Field Customisation
        self.conformPasswordTF.adjustsFontSizeToFitWidth = true
        self.conformPasswordTF.isSecureTextEntry = true
        self.conformPasswordTF.placeholder = LangCommon.enterYourConformPassword
        self.conformPasswordTF.delegate = self
        self.conformPasswordTF.addTarget(self, action: #selector(conformPasswordTFEnteredValues(_:)), for: .editingChanged)
        
        
        //Cancel Button Customisation
        self.cancelBtn.clipsToBounds = true
        self.cancelBtn.cornerRadius = 15
        self.cancelBtn.elevate(2)
        self.cancelBtn.setTitle(LangCommon.cancel.capitalized, for: .normal)
        
        //Conform Button Customisation
        self.conformBtn.clipsToBounds = true
        self.conformBtn.setTitle(LangCommon.confirm.capitalized, for: .normal)
    }
    
    func initGesture() {
        self.addAction(for: .tap) {
            self.changePasswordVC.exitScreen(animated: true)
        }
        
        oldPasswordVisibleIV.addAction(for: .tap) {
            self.oldPasswordVisibleChangeImageViewPressed(self.oldPasswordVisibleIV)
        }
        
        newPasswordVisibleIV.addAction(for: .tap) {
            self.newPasswordVisibleChangeImageViewPressed(self.newPasswordVisibleIV)
        }
        
        conformPasswordVisibleIV.addAction(for: .tap) {
            self.conformPasswordVisibleChangeImageViewPressed(self.conformPasswordVisibleIV)
        }
        
        changePasswordBGView.addTap {
            debug(print: "I Cant't Allow to Leave")
        }
    }
    
    
    func oldPasswordVisibleChangeImageViewPressed(_ sender: UIImageView) {
        self.oldPasswordVisibleIV.image = self.oldPasswordVisibleState ? UIImage(named: "visible") : UIImage(named: "invisible")
        self.oldPasswordTF.isSecureTextEntry = self.oldPasswordVisibleState
        self.oldPasswordVisibleState = !self.oldPasswordVisibleState
    }
    func newPasswordVisibleChangeImageViewPressed(_ sender: UIImageView) {
        self.newPasswordVisibleIV.image = self.newPasswordVisibleState ? UIImage(named: "visible") : UIImage(named: "invisible")
        self.newPasswordTF.isSecureTextEntry = self.newPasswordVisibleState
        self.newPasswordVisibleState = !self.newPasswordVisibleState
    }
    
    func conformPasswordVisibleChangeImageViewPressed(_ sender: UIImageView) {
        self.conformPasswordVisibleIV.image = self.conformPasswordVisibleState ? UIImage(named: "visible") : UIImage(named: "invisible")
        self.conformPasswordTF.isSecureTextEntry = self.conformPasswordVisibleState
        self.conformPasswordVisibleState = !self.conformPasswordVisibleState
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(whenKeyboardApper(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    
    @IBAction func conformBtnPressed(_ sender: UIButton) {
        // Conform Button Operation takes Place Here
        self.endEditing(true)
        if let newPassword = newPassword,
           let oldPassword = oldPassword,
           let conformPassword = conformPassword {
            
            // Validation Message
            
            if newPassword.count < 5 || conformPassword.count < 5 {
                self.alertCreater(Title: appName,
                                  Messasage: LangCommon.passwordValidationMsg)
                return
            }
            
            if newPassword != conformPassword {
                self.alertCreater(Title: appName,
                                  Messasage: LangCommon.passwordMismatch)
                return
            }
            
            isUserPasswordMatched = (newPassword == conformPassword)
            debug(print: "--------> Password Update Status: \(isUserPasswordMatched)")
            
            if isUserPasswordMatched {
                self.resignFirstResponder()
                debug(print: "--------> Password Ready to Update")
                var parm = JSON()
                parm["old_password"] = String(format:"%@",oldPassword)
                parm["password"] = String(format:"%@",newPassword)
                self.changePasswordVC.wsToSetNewPassword(param: parm)
            }
        } else {
            // Empty Validation Message
            
            if let text = self.oldPasswordTF.text,
               text.isEmpty {
                self.alertCreater(Title: appName,
                                  Messasage: LangCommon.pleaseEnterYourOldPassword)
                return
            }
            
            if let text = self.newPasswordTF.text,
               text.isEmpty  {
                self.alertCreater(Title: appName,
                                  Messasage: LangCommon.pleaseEnterYourNewPassword)
                return
            }
            
            if let text = self.conformPasswordTF.text,
               text.isEmpty  {
                self.alertCreater(Title: appName,
                                  Messasage: LangCommon.pleaseEnterYourConfirmPassword)
                return
            }
        }
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.changePasswordVC.exitScreen(animated: true)
    }
    
    @objc func whenKeyboardApper(_ sender:Notification){
        if let userInfo = sender.userInfo {
            if let frame = userInfo["UIKeyboardFrameBeginUserInfoKey"] as? CGRect {
                keyboardHight = frame.height
            }
        }
    }
    
    @objc func oldPasswordTFEnteredValues(_ sender: UITextField) {
        if let text = sender.text {
            self.oldPassword = text
        }
    }
    
    @objc func newPasswordTFEnteredValues(_ sender: UITextField) {
        if let text = sender.text {
            self.newPassword = text
        }
    }
    
    @objc func conformPasswordTFEnteredValues(_ sender: UITextField) {
        if let text = sender.text {
            self.conformPassword = text
        }
    }
    
    func alertCreater(Title:String?,
                      Messasage:String?) {
        self.changePasswordVC.commonAlert.setupAlert(alert: Title ?? "",
                                                     alertDescription: Messasage,
                                                     okAction: LangCommon.ok)
        self.changePasswordVC.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            if Messasage == LangCommon.successFullyUpdated {
                debug(print: "-----> Success Fully Updated")
                self.changePasswordVC.exitScreen(animated: true)
            }
        }
        
    }
}

extension ChangePasswordView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let height = keyboardHight {
            debug(print: "--------> Height of the KeyBoard : \(height)")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
