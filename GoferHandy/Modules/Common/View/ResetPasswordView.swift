//
//  ResetPasswordView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class ResetPasswordView: BaseView,UITextFieldDelegate{
    
    
    // MARK: - Outlets
    @IBOutlet weak var btnSignIn: PrimaryFontButton!
    @IBOutlet weak var txtFldPassword: commonTextField!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var passwordVisibleIV: SecondaryTintImageView!
    @IBOutlet weak var txtFldConfirmPassword: commonTextField!
    @IBOutlet weak var confirmPasswordVisibleIV: SecondaryTintImageView!
    @IBOutlet weak var viewObjHolder: TopCurvedView!
    @IBOutlet weak var lblErrorMsg: ErrorLabel!
    @IBOutlet weak var closeButtonOutlet: SecondaryTintButton!
    @IBOutlet weak var resetTitleLabel: SecondaryHeaderLabel!
    @IBOutlet weak var passwordBGView: SecondaryBorderedView!
    @IBOutlet weak var confirmPasswordView: SecondaryBorderedView!
    @IBOutlet weak var passwordFieldErrLblHolderView: UIView!
    @IBOutlet weak var passwordFieldErrLbl: ErrorLabel!
    @IBOutlet weak var confirmPasswordFieldErrLblHolderView: UIView!
    @IBOutlet weak var confirmPasswordFieldErrLbl: ErrorLabel!
    @IBOutlet weak var cancelPopUpView : TopCurvedView!
    @IBOutlet weak var cancelForgetPasswordTitleLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var yourAccountNotSavedLbl : SecondaryRegularLabel!
    @IBOutlet weak var cancelBtn : PrimaryButton!
    @IBOutlet weak var confirmBtn : SecondaryButton!
    
    // MARK: - Class Variables
    var viewController:ResetPasswordVC!
    var spinnerView = JTMaterialSpinner()
    var passwordVisibleState:Bool = false
    var confirmPasswordVisibleState:Bool = false
    //MARK:- Life Cycle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? ResetPasswordVC
        self.txtFldPassword.delegate = self
        self.txtFldConfirmPassword.delegate = self
        self.initView()
        self.initGesture()
        if isRTLLanguage {
            self.btnSignIn.setTitle("e", for: .normal)
        }else{
            self.btnSignIn.setTitle("I", for: .normal)
        }
        if #available(iOS 10.0, *) {
            txtFldPassword.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            txtFldPassword.keyboardType = .asciiCapable
        }
        
        //        if appDelegate.language == "ja" {
        //            closeButtonOutlet.setTitle("CLOSE".localize, for: .normal)
        //            resetTitleLabel.text = "RESET PASSWORD".localize
        //            txtFldPassword.placeholder = "PASSWORD".localize
        //            txtFldConfirmPassword.placeholder = "CONFIRM PASSWORD".localize
        //
        //        }
        //   self.appDelegate.registerForRemoteNotification()
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.viewController.navigationController?.isNavigationBarHidden = true
        btnSignIn.layer.cornerRadius = btnSignIn.frame.size.width / 2
        
        //
        lblErrorMsg.isHidden = true
        txtFldConfirmPassword.setLeftPaddingPoints(10)
        txtFldConfirmPassword.setRightPaddingPoints(10)
        
        txtFldPassword.setLeftPaddingPoints(10)
        txtFldPassword.setRightPaddingPoints(10)
        txtFldPassword.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.initLanguage()
        self.checkNextButtonStatus()
        self.ThemeChange()
    }
    
    override func willAppear(baseVC : BaseViewController) {
        super.willAppear(baseVC: baseVC)
    }
    override func didAppear(baseVC : BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    //MARK:- init Language
    func initLanguage(){
        resetTitleLabel.text = LangCommon.resetPassword.capitalized
        txtFldPassword.placeholder = LangCommon.enterYourNewPassword.capitalized
        txtFldConfirmPassword.placeholder = LangCommon.enterYourConformPassword.capitalized
        passwordFieldErrLbl.text = LangCommon.passwordValidationMsg
        confirmPasswordFieldErrLbl.text = LangCommon.passwordValidationMsg
        self.cancelForgetPasswordTitleLbl.text = LangCommon.cancel
            + " "
            + LangCommon.resetPassword
        self.yourAccountNotSavedLbl.text = LangCommon.infoNotSaved
        self.cancelBtn.setTitle(LangCommon.cancel.uppercased(), for: .normal)
        self.confirmBtn.setTitle(LangCommon.confirm.uppercased(), for: .normal)
    }
    func ThemeChange() {
        self.darkModeChange()
        self.headerView.customColorsUpdate()
        self.resetTitleLabel.customColorsUpdate()
        self.viewObjHolder.customColorsUpdate()
        self.passwordBGView.customColorsUpdate()
        self.txtFldPassword.customColorsUpdate()
        self.passwordVisibleIV.customColorsUpdate()
        self.confirmPasswordView.customColorsUpdate()
        self.txtFldConfirmPassword.customColorsUpdate()
        self.confirmPasswordVisibleIV.customColorsUpdate()
        self.lblErrorMsg.customColorsUpdate()
        self.passwordFieldErrLbl.customColorsUpdate()
        self.confirmPasswordFieldErrLbl.customColorsUpdate()
        self.cancelPopUpView.customColorsUpdate()
        self.yourAccountNotSavedLbl.customColorsUpdate()
        self.cancelForgetPasswordTitleLbl.customColorsUpdate()
        self.cancelBtn.customColorsUpdate()
        self.confirmBtn.customColorsUpdate()
        self.confirmBtn.cornerRadius = 15
        self.confirmBtn.elevate(2)
    }
    func initView() {
        self.txtFldPassword.textAlignment = isRTLLanguage ? .right : .left
        self.txtFldConfirmPassword.textAlignment = isRTLLanguage ? .right : .left
        self.passwordVisibleIV.image = UIImage(named: "visible")
        self.confirmPasswordVisibleIV.image = UIImage(named: "visible")
        self.passwordFieldErrLblHolderView.isHidden = true
        self.confirmPasswordFieldErrLblHolderView.isHidden = true
    }
    
    func initGesture() {
        self.passwordVisibleIV.addAction(for: .tap) {
            self.passwordVisibleImageViewPressed(self.passwordVisibleIV)
        }
        self.confirmPasswordVisibleIV.addAction(for: .tap) {
            self.confirmPasswordVisibleImageViewPressed(self.confirmPasswordVisibleIV)
        }
    }
    
    func passwordVisibleImageViewPressed(_ sender:UIImageView) {
        if passwordVisibleState {
            self.passwordVisibleIV.image = UIImage(named: "visible")?.withRenderingMode(.alwaysTemplate)
            self.txtFldPassword.isSecureTextEntry = true
            self.passwordVisibleState = false
        } else {
            self.passwordVisibleIV.image = UIImage(named: "invisible")?.withRenderingMode(.alwaysTemplate)
            self.txtFldPassword.isSecureTextEntry = false
            self.passwordVisibleState = true
        }
    }
    
    @objc func confirmPasswordVisibleImageViewPressed(_ sender:UIImageView) {
        if confirmPasswordVisibleState {
            self.confirmPasswordVisibleIV.image = UIImage(named: "visible")
            self.txtFldConfirmPassword.isSecureTextEntry = true
            self.confirmPasswordVisibleState = false
        } else {
            self.confirmPasswordVisibleIV.image = UIImage(named: "invisible")
            self.txtFldConfirmPassword.isSecureTextEntry = false
            self.confirmPasswordVisibleState = true
        }
    }
    
    
    //Dissmiss the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        UberSupport().keyboardWillShowOrHide(keyboarHeight: keyboardFrame.size.height, btnView: btnSignIn)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
//        UberSupport().keyboardWillShowOrHide(keyboarHeight: 0, btnView: btnSignIn)
    }
    
    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField) {
        self.lblErrorMsg.isHidden = true
        if textField.tag == 1 {
            self.passwordFieldErrLblHolderView.isHidden = (txtFldPassword.text?.count)!>5 || textField.text?.count == 0
        } else if textField.tag == 2 {
            self.confirmPasswordFieldErrLblHolderView.isHidden = (txtFldConfirmPassword.text?.count)!>5 || textField.text?.count == 0
        } else {
            
        }
        self.checkNextButtonStatus()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
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
    // MARK: - Checking Next Button status
    /*
     new & confirm Password filled or not
     and making user interaction enable/disable
     */
    func checkNextButtonStatus() {
        let isActive = (txtFldConfirmPassword.text?.count)!>5 && (txtFldPassword.text?.count)!>5
        btnSignIn.backgroundColor = isActive ? .PrimaryColor : .TertiaryColor
        btnSignIn.isUserInteractionEnabled = isActive
    }
    
    // MARK: API CALLING - UDPATE NEW PASSWORD
    /*
     After filled new & confirm Password
     */
    @IBAction func onSignInTapped(_ sender:UIButton!)
    {
        
        self.endEditing(true)
        if txtFldConfirmPassword.text != txtFldPassword.text {
            self.viewController.presentAlertWithTitle(title: LangCommon.passwordMismatch.capitalized,
                                                      message: "",
                                                      options: LangCommon.ok.capitalized) { (finished) in
                
            }
            return
        }
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
                self.viewController.commonAlert.setupAlert(alert: LangCommon.message,
                                                           alertDescription: LangCommon.pleaseEnablePushNotification,
                                                           okAction: LangCommon.ok)
                self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                    AppDelegate.shared.pushManager.registerForRemoteNotification()
                }
                
                return
            }
        }
        addProgress()
        spinnerView.beginRefreshing()
        
        var dicts = JSON()
        dicts["mobile_number"] = String(format:"%@",viewController.strMobileNo)
        dicts["country_code"] = self.viewController.countryModel.country_code//String(format:"%@",Constants().GETVALUE(keyname: USER_COUNTRY_CODE))
        dicts["password"] = String(format:"%@",txtFldPassword.text!)
        self.viewController.resetPasswordApiCall(params: dicts)
    }
    
    func showPage(){
        UserDefaults.standard.set("rider", forKey:"getmainpage")
        AppDelegate.shared.onSetRootViewController(viewCtrl: self.viewController)
    }
    
    // NAVIGATE TO DOCUMENT PAGE
    /*
     IF USER NOT UPLODING DOCUMENT
     */
    func gotoDocumentPage()
    {
        
    }
    
    // NAVIGATE TO ADD VEHICLE DETAILS PAGE
    /*
     IF USER NOT UPDATING HIS VEHICLE DETAILS
     */
    func gotoVehicleDetailPage(arrCarDetails:NSArray)
    {
        
    }
    
    func addProgress() {
        lblErrorMsg.isHidden = true
        self.btnSignIn.isUserInteractionEnabled = false
        btnSignIn.titleLabel?.text = ""
        btnSignIn.setTitle("", for: .normal)
        self.btnSignIn.addSubview(spinnerView)
        self.spinnerView.anchor(toView: self.btnSignIn,
                                trailing: -15)
        self.spinnerView.setEqualHightWidthAnchor(toView: self.spinnerView,
                                                  height: 25)
        self.spinnerView.setCenterXYAncher(toView: self.btnSignIn,
                                           centerY: true)
        self.btnSignIn.bringSubviewToFront(spinnerView)
        self.spinnerView.circleLayer.lineWidth = 3.0
        self.spinnerView.circleLayer.strokeColor =  UIColor.PrimaryTextColor.cgColor
        self.spinnerView.beginRefreshing()
    }
    
    func removeProgress()
    {
        self.btnSignIn.isUserInteractionEnabled = true
        btnSignIn.titleLabel?.text = "I"
        btnSignIn.setTitle("I", for: .normal)
        spinnerView.endRefreshing()
        spinnerView.removeFromSuperview()
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.endEditing(true)
        self.addSubview(cancelPopUpView)
        self.setUpCancelPopup()
        self.cancelPopUpAnimation(isBegin: true)
        self.bringSubviewToFront(cancelPopUpView)
    }
    
    @IBAction func cancelBtnPressed(_ sender:UIButton!) {
        self.cancelPopUpAnimation(isBegin: false)
    }
    
    @IBAction func confirmBtnPressed(_ sender:UIButton!) {
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    func cancelPopUpAnimation(isBegin: Bool) {
        self.cancelPopUpView.frame.origin.y = isBegin ? self.frame.maxY : self.cancelPopUpView.frame.minY
        UIView.animate(withDuration: 0.7) {
            self.cancelPopUpView.frame.origin.y = isBegin ? self.frame.maxY - 200 : self.frame.maxY + 200
        } completion: { (completedTheAnimation) in
            self.set(UserInteraction: !isBegin)
            if !isBegin { self.cancelPopUpView.removeFromSuperview() }
        }
    }
    
    func set(UserInteraction : Bool) {
        self.txtFldPassword.isUserInteractionEnabled = UserInteraction
        self.txtFldConfirmPassword.isUserInteractionEnabled = UserInteraction
        self.backBtn?.isUserInteractionEnabled = UserInteraction
    }
    
    func setUpCancelPopup() {
        self.cancelPopUpView.translatesAutoresizingMaskIntoConstraints = false
        self.cancelPopUpView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.cancelPopUpView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.cancelPopUpView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.cancelPopUpView.heightAnchor.constraint(equalToConstant: 210).isActive = true
    }
}
