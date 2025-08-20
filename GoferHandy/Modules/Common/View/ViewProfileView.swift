//
//  ViewProfileView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import Photos
import AVFoundation

class ViewProfileView: BaseView,
                       UITextFieldDelegate,
                       UITextViewDelegate,
                       UIImagePickerControllerDelegate,
                       UINavigationControllerDelegate {
    
    
    //    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var bottomButtonView: TopCurvedView!
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var profileImg: PrimaryBorderedImageView!
    @IBOutlet weak var changeImgBtn: PrimaryTintButton!
    
    @IBOutlet weak var mobileTF: commonTextField!
    @IBOutlet weak var firstNameLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var flagImg: UIImageView!
    
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var mainBGView: TopCurvedView!
    @IBOutlet weak var countryCode: SecondaryTextFieldLabel!
    @IBOutlet weak var firstNameTF: commonTextField!
    @IBOutlet weak var lastNameLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var mobileLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var lastNameTF: commonTextField!
    @IBOutlet weak var emailLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var countryLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var emailTF: commonTextField!
    @IBOutlet weak var updateBtn: SecondaryButton!
    @IBOutlet weak var changePasswordBtn: PrimaryButton!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var topView: HeaderView!
    @IBOutlet weak var mobileStackView: UIStackView!
    @IBOutlet weak var titleText: SecondaryHeaderLabel!
    @IBOutlet weak var firstNameOuter: SecondaryView!
    @IBOutlet weak var lastNameOuter: SecondaryView!
    @IBOutlet weak var mobileOuter: SecondaryView!
    @IBOutlet weak var countryOuter: SecondaryView!
    @IBOutlet weak var emailOuter: SecondaryView!
    @IBOutlet var leadingConstraints: [NSLayoutConstraint]!
    @IBOutlet var trailingConstraints: [NSLayoutConstraint]!
    
    var arrTitle = [String]()
    var arrProfileValues = [String]()
    var arrDummyValues = [String]()
    var imagePicker = UIImagePickerController()
    var countryModel :  CountryModel?
    var strUserName = ""
    var strFirstName = ""
    var strLastName = ""
    var strMobileNumber = ""
    var strEmailId = ""
    
    var strUserImgUrl = ""
    var editingButtonState:EditingState = .editProfile
    var isPasswordNeedToShow : Bool = false
    var viewController:ViewProfileVC!
    var isUpdateButtonPressed : Bool = false
    
    //MARK:- Life Cycles
    
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? ViewProfileVC
        self.setDelegateForTF()
        self.countryModel = Global_UserProfile.countryModel
        checkSaveButtonStatus()
        self.initNotifications()
        self.initLanguage()
        self.initView()
        self.initGestures()
        self.ThemeChange()
    }
    
    override func willAppear(baseVC : BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.initLanguage()
        self.updatingFields()
        
        if isUpdateButtonPressed {
            self.updatingView(isEnabled: true,
                              borderColor: .TertiaryColor,
                              Constraint: 10.0)
        } else {
            self.updatingView(isEnabled: false, borderColor: .clear, Constraint: 0.0)
        }
        
    }
    override func didAppear(baseVC : BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    override func didLayoutSubviews(baseVC: BaseViewController){
        super.didLayoutSubviews(baseVC: baseVC)
    }
    
    func initGestures() {
        self.profileImg.addAction(for: .tap) {
            self.imageChoose()
        }
    }
    
    fileprivate func initNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateNewPhoneNo),
                                               name: NSNotification.Name.phonenochanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func initView() {
        self.profileImg.isCurvedCorner = true
        self.firstNameTF.keyboardType = .namePhonePad
        self.lastNameTF.keyboardType = .namePhonePad
        self.emailTF.keyboardType = .emailAddress
        self.firstNameOuter.cornerRadius = 15
        self.lastNameOuter.cornerRadius = 15
        self.emailOuter.cornerRadius = 15
        self.countryOuter.cornerRadius = 15
        self.mobileOuter.cornerRadius = 15
        self.updateBtn.cornerRadius = 15
        self.updateBtn.elevate(2)
        self.titleText.text = LangCommon.myProfile
        self.countryLbl.text = LangCommon.country
        self.mobileLbl.text = LangCommon.mobile.lowercased().capitalized
        self.updateBtn.setTitle(LangCommon.editProfile,
                                for: .normal)
        self.editingButtonState = .editProfile
        self.changePasswordBtn.setTitle(LangCommon.changePassword,
                                        for: .normal)
        self.changePasswordBtn.isHidden = !Global_UserProfile.password
        self.isPasswordNeedToShow = !Global_UserProfile.password
    }
    
    
    //Edit Profile
    
    func updatingView(isEnabled: Bool,
                      borderColor: UIColor,
                      Constraint: CGFloat) {
        self.firstNameTF.isUserInteractionEnabled = isEnabled
        self.lastNameTF.isUserInteractionEnabled = isEnabled
        self.emailTF.isUserInteractionEnabled = isEnabled
        self.profileImg.isUserInteractionEnabled = isEnabled
        self.mobileStackView.isUserInteractionEnabled = isEnabled
        self.changeImgBtn.isUserInteractionEnabled = isEnabled
        self.changeImgBtn.isHidden = !isEnabled

        for element in leadingConstraints{
            element.constant = Constraint
        }
        for element in trailingConstraints{
            element.constant = Constraint
        }
        self.firstNameOuter.border(width: 1, color: borderColor)
        self.lastNameOuter.border(width: 1, color: borderColor)
        self.emailOuter.border(width: 1, color: borderColor)
        self.countryOuter.border(width: 1, color: borderColor)
        self.mobileOuter.border(width: 1, color: borderColor)
    }
    //Hide keyboards
    @objc
    func keyboardWillShow(notification: NSNotification) { }
    
    @objc
    func keyboardWillHide(notification: NSNotification) { }
    // set the profile data from the api
    func setUserProfileInfo(profileModel: UserProfileDataModel) {
        //666
        self.profileImg?.sd_setImage(with: NSURL(string: profileModel.profileImage)! as URL,
                                     placeholderImage:UIImage(named:"user_dummy"))
        self.strUserName = ""
        self.strFirstName = profileModel.firstName
        self.strLastName = profileModel.lastName
        self.strMobileNumber = profileModel.mobileNumber
        self.strEmailId = profileModel.emailID
        self.strUserImgUrl = profileModel.profileImage
        self.arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber]
        self.arrDummyValues = arrProfileValues
        self.countryModel = profileModel.countryModel
    }
    //MARK:- init Language
    func initLanguage(){
        arrTitle = [
            LangCommon.firstName.capitalized,
            LangCommon.lastName.capitalized,
            LangCommon.email.capitalized,
            LangCommon.phoneNumber.capitalized,
            LangCommon.addressLineFirst.capitalized,
            LangCommon.addressLineSecond.capitalized,
            LangCommon.city.capitalized,
            LangCommon.postalCode.capitalized,
            LangCommon.state.capitalized]
        
    }
    // Update the phone no
    @objc func updateNewPhoneNo(notification: Notification)
    {
        let viewControllers: [UIViewController] = self.viewController.navigationController!.viewControllers as [UIViewController]
        for i in 0 ..< viewControllers.count {
            let obj = viewControllers[i]
            if false//obj is EditProfileVC///666
            {
                self.viewController.navigationController?.popToViewController(obj, animated: true)
                
            }
        }
        
        let str2 = notification.userInfo
        let strPhoneNo = str2?["phone_no"] as? String ?? String()
        strMobileNumber = strPhoneNo
        arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber]
        self.makeTickButton()
    }
    
    func setDelegateForTF()
    {
        self.firstNameTF.delegate = self
        self.lastNameTF.delegate = self
        self.emailTF.delegate = self
        self.mobileTF.delegate = self
        
    }
    @IBAction func updateProfileBtnAction(_ sender: Any) {
        self.endEditing(true)
        if self.editingButtonState == .editProfile {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: [.beginFromCurrentState,.layoutSubviews,.allowAnimatedContent],
                           animations: {
                self.updatingView(isEnabled: true,
                                  borderColor: .lightGray,
                                  Constraint: 10.0)
                self.titleText.text = LangCommon.editProfile
                self.updateBtn.setTitle(LangCommon.updateInfo,
                                        for: .normal)
                self.editingButtonState = .updateProfile
                self.updateBtn.setTitleColor(.PrimaryTextColor,
                                             for: .normal)
                self.updateBtn.backgroundColor = .TertiaryColor
                self.updateBtn.border(width: 1,
                                      color: .TertiaryColor)
                self.changePasswordBtn.isHidden = true
                self.updateBtn.isUserInteractionEnabled = false
                self.layoutIfNeeded()
                self.isUpdateButtonPressed = true
            }, completion: { _ in
                if self.isUpdateButtonPressed {
                    self.goToMobileValidationVC()
                }})
        }else{
            if UberSupport().isValidEmail(testStr: emailTF.text!) {
                print("------> Valid Mail")
                self.updateBtn.customColorsUpdate()
                self.onSaveProfileTapped() // Update Profile API Calling
            } else {
                AppUtilities().customCommonAlertView(titleString: "",
                                                     messageString: LangCommon.enterValidEmailID)
                print("------> InValid Mail")
            }
        }
    }
    @IBAction func changeImgBtnAction(_ sender: Any) {
        self.imageChoose()
    }
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        self.endEditing(true)
        self.viewController.navicationToChangePasswordVC()
    }
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!){
        if arrProfileValues == arrDummyValues {
            self.viewController.exitScreen(animated: true)
        }else{
            self.viewController.commonAlert.setupAlert(alert: LangCommon.message,
                                                       alertDescription:
                                                        LangCommon.discardProfile,
                                                       okAction: LangCommon.discardcontent,cancelAction: LangCommon.cancel
            )
            self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                self.viewController.exitScreen(animated: true)
            }
            self.viewController.commonAlert.addAdditionalCancelAction(customAction: {
            })
        }
    }

    // MARK: *** Updating the values for Text fields ***
    
    func updatingFields()
    {
        //        arrTitle = [
        //              LangCommon.firstName.uppercased(),LangCommon.lastName.uppercased(),LangCommon.email.uppercased(),LangCommon.phoneNumber.uppercased(),LangCommon.addressOne.uppercased(),LangCommon.addressTwo.uppercased(),LangCommon.city.uppercased(),LangCommon.postalCode.uppercased(),LangCommon.state.uppercased()]
        
        //First name and Last name
        if arrProfileValues.count > 0 {
            self.firstNameLbl.text = arrTitle[0]
            self.firstNameTF.text = arrProfileValues[0]
            self.firstNameTF.tag = 0
            self.lastNameLbl.text = arrTitle[1]
            self.lastNameTF.text = arrProfileValues[1]
            self.lastNameTF.tag = 1
            
            //mobile
            let country = self.countryModel ?? CountryModel()
            self.mobileTF.text = strMobileNumber
            self.countryCode.text = country.dial_code
            self.flagImg.image = country.flag
            
            // email
            self.emailLbl.text = arrTitle[2]
            self.emailTF.text = arrProfileValues[2]
            if isRTLLanguage {
                self.emailLbl.textAlignment = NSTextAlignment.right
                self.emailTF.textAlignment = NSTextAlignment.right
                
                self.firstNameLbl.textAlignment = NSTextAlignment.right
                self.firstNameTF.textAlignment = NSTextAlignment.right
                
                self.lastNameLbl.textAlignment = NSTextAlignment.right
                self.lastNameTF.textAlignment = NSTextAlignment.right
                
                self.mobileTF.textAlignment = NSTextAlignment.right
                self.mobileLbl.textAlignment = NSTextAlignment.right
            } else {
                self.emailLbl.textAlignment = NSTextAlignment.left
                self.emailTF.textAlignment = NSTextAlignment.left
                
                self.firstNameLbl.textAlignment = NSTextAlignment.left
                self.firstNameTF.textAlignment = NSTextAlignment.left
                
                self.lastNameLbl.textAlignment = NSTextAlignment.left
                self.lastNameTF.textAlignment = NSTextAlignment.left
                
                self.mobileTF.textAlignment = NSTextAlignment.left
                self.mobileLbl.textAlignment = NSTextAlignment.left
            }
            emailTF.tag = 2
            emailTF.isUserInteractionEnabled = true
        }
        
        
        
        
        
        //section 2
        
        //        self.serviceDescLbl.text = arrTitle[2]
        //        self.serviceDescTV.text = arrProfileValues[2]
    }
    func imageChoose() {
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.beginFromCurrentState,.layoutSubviews,.allowAnimatedContent],
                       animations: {
            self.updatingView(isEnabled: true, borderColor: .lightGray, Constraint: 10.0)
            self.titleText.text = LangCommon.editProfile
            self.updateBtn.setTitle(LangCommon.updateInfo,
                                    for: .normal)
            self.editingButtonState = .updateProfile
            self.updateBtn.setTitleColor(.PrimaryTextColor,
                                         for: .normal)
            self.updateBtn.backgroundColor = .TertiaryColor
            self.updateBtn.border(width: 1,
                                  color: .TertiaryColor)
            // commented By Karuppasamy
            //                        self.changePasswordBtn.isHidden = true
            self.updateBtn.isUserInteractionEnabled = false
            self.layoutIfNeeded()
            
        }, completion: nil)
        
        
        
        let alert = UIAlertController(title: LangCommon.selectPhoto,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LangCommon.takePhoto.capitalized,
                                      style: .default,
                                      handler: { _ in
            AVCaptureDevice.authorizeVideo(completion: { (status) in        //authorization for access camera
                if (status == AVCaptureDevice.AuthorizationStatus.justAuthorized || status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized){
                    //                    showProgress()
                    AppUtilities().updateMainQueue {
                        self.toOpenCamera()
                    }
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: LangCommon.chooseLIB.capitalized,
                                      style: .default,
                                      handler: { _ in
            PHPhotoLibrary.authorizePhotoLibrary(completion: { (status) in      //authorization for access gallery
                if (status == PHPhotoLibrary.AuthorizationStatus.justAuthorized || status == PHPhotoLibrary.AuthorizationStatus.alreadyAuthorized){
                    //                    showProgress()
                    AppUtilities().updateMainQueue {
                        self.toOpenGallery()
                    }
                }
            })
        }))
        
        alert.addAction(UIAlertAction.init(title: LangCommon.cancel.lowercased(),
                                           style: .cancel,
                                           handler: nil))
        viewController.present(alert,
                               animated: true,
                               completion: nil)
    }
    
    func goToMobileValidationVC() {
        self.mobileStackView.addAction(for: .tap) { //[weak self] in
            let mobileValidationVC = MobileValidationVC.initWithStory(usign: self,
                                                                      for: .changeNumber)
            self.viewController.presentInFullScreen(mobileValidationVC, animated: true, completion: nil)
            self.viewController.mobileValidationPurpose = .changeNumber
        }
    }
    func setupShareAppViewAnimationWithView(_ view:UIView)
    {
        //           viewMediaHoder.isHidden = false
        view.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.allowUserInteraction, animations:
                        {
                            view.transform = CGAffineTransform.identity
                            view.alpha = 1.0;
                        },  completion: { (finished: Bool) -> Void in
                        })
    }
    // MARK: - ****** Uploading Proifle Picture Operation ******
    func uploadProfileImage(displayPic:UIImage) {
        var paramDict = JSON()
        guard let imageData = displayPic.jpegData(compressionQuality: 0.1) else {return}
        paramDict["token"] = Constants().GETVALUE(keyname: "access_token")
        ConnectionHandler.shared.uploadPost(wsMethod: APIEnums.uploadProfileImage.rawValue,
                                            paramDict: paramDict,
                                            imgData: imageData ,
                                            viewController: self.viewController,
                                            isToShowProgress: true,
                                            isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                if responseDict["image_url"] != nil {
                    self.strUserImgUrl = responseDict.string("image_url")
                    self.makeTickButton()
                }
            } else {
                AppDelegate.shared.createToastMessage(LangCommon.uploadFailed,
                                                      bgColor: UIColor.black,
                                                      textColor: UIColor.white)
                self.profileImg?.sd_setImage(with: NSURL(string: self.strUserImgUrl)! as URL, placeholderImage:UIImage(named:"user_dummy"))
                AppDelegate.shared.createToastMessage(CommonError.server.localizedDescription,
                                                      bgColor: UIColor.black,
                                                      textColor: UIColor.white)
            }
            UberSupport().removeProgress(viewCtrl: self.viewController)
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.isUserInteractionEnabled = true
        }
    }
    
    func generateBoundaryString() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }
    // MARK: Profile image upload end
    
    // MARK: - TextField Delegate Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        //        else if (string == " ") {
        //            return false
        //        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        textField.keyboardType = .asciiCapable
        print(textField.tag)
        var indexPath = IndexPath(row: (textField.tag == 1) ? 0 : (textField.tag == 3) ? 2 : textField.tag, section: (textField.tag > 3) ? 1 : 0)
        print("select \(indexPath)")
        if (textField.tag == 0 || textField.tag == 1)
        {
            if textField.tag == 0   // USER NAME
            {
                strFirstName = firstNameTF.text!
            }
            else if textField.tag == 1   // USER NAME
            {
                strLastName = lastNameTF.text!
            }
            arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber]
            
            checkSaveButtonStatus()
            return
        }
        else
        {
            if (textField.tag > 3)
            {
                indexPath = IndexPath(row: textField.tag-4, section: 1)
            }
            else
            {
                let row = (textField.tag == 3) ? 2 : (textField.tag == 2) ? 1 : textField.tag
                indexPath = IndexPath(row: row, section: 0)
            }
        }
        
        if textField.tag == 2   // EMAIL ID
        {
            
            strEmailId = emailTF.text!
            
            
        }
        else if textField.tag == 3   // MOBILE NUMBER
        {
            strMobileNumber = mobileTF.text!
        }
        arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber]
        
        checkSaveButtonStatus()
    }
    
    func checkSaveButtonStatus() {
        if self.editingButtonState == .editProfile{
            updateBtn.isUserInteractionEnabled = true
            updateBtn.setTitleColor(.ThemeTextColor,
                                    for: .normal)
        } else if self.editingButtonState == .updateProfile{
            if arrProfileValues == arrDummyValues {
                updateBtn.isUserInteractionEnabled = false
                updateBtn.setTitleColor(.PrimaryTextColor,
                                        for: .normal)
                updateBtn.backgroundColor = .TertiaryColor
            } else {
                updateBtn.isUserInteractionEnabled = false
                updateBtn.setTitleColor(.PrimaryTextColor,
                                        for: .normal)
                makeTickButton()
            }
        } else {
            updateBtn.isUserInteractionEnabled = false
            updateBtn.setTitleColor(.PrimaryTextColor,
                                    for: .normal)
            makeTickButton()
        }
    }
    func makeTickButton() {
        updateBtn.isUserInteractionEnabled = true
        updateBtn.setTitleColor(.PrimaryTextColor,
                                for: .normal)
        updateBtn.backgroundColor = .PrimaryColor
    }
    
    //MARK - API CALL -> SAVE PROFILE INFORMATION
    /*
     UPDATING USER INFORMATION TO SERVER
     */
    func onSaveProfileTapped() {
        var dicts = JSON()
        dicts["token"] = Constants().GETVALUE(keyname: "access_token")
        dicts["first_name"] = arrProfileValues[0]
        dicts["last_name"] = arrProfileValues[1]
        dicts["email_id"] = arrProfileValues[2]
        dicts["mobile_number"] = arrProfileValues[3]
        let country = self.countryModel ?? CountryModel()
        dicts["country_code"] = country.country_code
        dicts["profile_image"] = strUserImgUrl
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.viewController.onSaveProfileApiCall(params: dicts)
    }
    
    // UPDATE PROFILE INFO SUCCESS
    func updateProfileModel() {
        Global_UserProfile.userName = String(format:"%@ %@", arrProfileValues[0],arrProfileValues[1])
        Global_UserProfile.firstName = arrProfileValues[0]
        Global_UserProfile.lastName = arrProfileValues[1]
        Global_UserProfile.emailID = arrProfileValues[2]
        Global_UserProfile.profileImage = strUserImgUrl
//        self.viewController.accountViewModel.profileModel = profileModel
        Global_UserProfile.storeRiderBasicDetail()
        strUserImgUrl = ""
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.beginFromCurrentState,
                                 .layoutSubviews,
                                 .allowAnimatedContent],
                       animations: {
            self.updatingView(isEnabled: false,
                              borderColor: .clear,
                              Constraint: 0.0)
            self.updateBtn.setTitle(LangCommon.editProfile,
                                    for: .normal)
            self.editingButtonState = .editProfile
            self.titleText.text = LangCommon.myProfile
            self.updateBtn.setTitleColor(.ThemeTextColor,
                                         for: .normal)
            self.updateBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.updateBtn.border(width: 1,
                                  color: .clear)
            self.changePasswordBtn.isHidden = self.isPasswordNeedToShow
            self.setUserProfileInfo(profileModel: Global_UserProfile)
            self.layoutIfNeeded()
            self.reloadInputViews()
        }, completion: nil)
        
    }
    //MARK: - UIImagePicker
    func toOpenCamera() {             // To open camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            viewController.present(imagePicker,
                                   animated: true,
                                   completion: nil)
            //               hideProgress()
        }
        else {
            //TRVicky
            self.viewController.commonAlert.setupAlert(alert: LangCommon.error.uppercased(),
                                                       alertDescription: LangCommon.deviceHasNoCamera,
                                                       okAction: LangCommon.ok.uppercased())
            self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl,
                                                  options: [:],
                                                  completionHandler: nil)
                    } else { }
                }
            }
            
            
        }
    }
    
    func ThemeChange() {
        self.darkModeChange()
        self.fieldsView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.contentHolderView.customColorsUpdate()
        self.titleText.customColorsUpdate()
        self.topView.customColorsUpdate()
        self.bottomButtonView.customColorsUpdate()
        self.firstNameOuter.customColorsUpdate()
        self.lastNameOuter.customColorsUpdate()
        self.emailOuter.customColorsUpdate()
        self.mobileOuter.customColorsUpdate()
        self.countryOuter.customColorsUpdate()
        self.countryLbl.customColorsUpdate()
        self.profileImg.customColorsUpdate()
        self.profileImg.border(color: .clear)
        self.changeImgBtn.customColorsUpdate()
        self.mobileTF.customColorsUpdate()
        self.mobileTF.font = AppTheme.Fontlight(size: 14).font
        self.firstNameLbl.customColorsUpdate()
        self.mainBGView.customColorsUpdate()
        self.countryCode.customColorsUpdate()
        self.countryCode.font = AppTheme.Fontlight(size: 14).font
        self.firstNameTF.customColorsUpdate()
        self.firstNameTF.font = AppTheme.Fontlight(size: 14).font
        self.lastNameLbl.customColorsUpdate()
        self.lastNameTF.customColorsUpdate()
        self.lastNameTF.font = AppTheme.Fontlight(size: 14).font
        self.mobileLbl.customColorsUpdate()
        self.emailLbl.customColorsUpdate()
        self.emailTF.customColorsUpdate()
        self.emailTF.font = AppTheme.Fontlight(size: 14).font
        self.updateBtn.customColorsUpdate()
        self.viewController.commonAlert.ThemeChange()
    }
    
    func toOpenGallery() {        // To open gallery
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            viewController.present(imagePicker, animated: true, completion: nil)
            //               hideProgress()
        }
        else
        {
            //TRVicky
            self.viewController.commonAlert.setupAlert(alert: LangCommon.warning.uppercased(),alertDescription: LangCommon.pleaseGivePermission, okAction: LangCommon.ok.uppercased())
            
            
        }
    }
    
    //Image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let uploadImage : UIImage? =  info[.editedImage] as? UIImage ?? (info[.originalImage] as? UIImage)
        let _ : Float = Float((uploadImage?.size.width)! / (uploadImage?.size.height)!)
        if let toImage = uploadImage {
            
            profileImg.image = toImage
            self.uploadProfileImage(displayPic:uploadImage!)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
extension ViewProfileView : MobileNumberValiadationProtocol{
    func verified(number: MobileNumber) {
        
        switch self.viewController.mobileValidationPurpose {
        case .changeNumber:
            self.countryModel = number.flag
            self.strMobileNumber = number.number
            self.arrProfileValues = [self.strFirstName, self.strLastName, self.strEmailId, self.strMobileNumber]
            self.updatingFields()
            self.makeTickButton()
        case .forgotPassword:
            let otpView = ResetPasswordVC.initWithStory()
            otpView.strMobileNo = number.number
            otpView.countryModel = number.flag
            self.viewController.navigationController?.pushViewController(otpView, animated: true)
        default:
            break
        }
        
    }
    
    
}

extension ViewProfileView : CountryListDelegate{
    func countryCodeChanged(countryCode: String, dialCode: String, flagImg: UIImage) {
        self.countryModel = CountryModel(forDialCode: nil, withCountry: countryCode)
        Constants().STOREVALUE(value: dialCode, keyname: "dial_code")
        Constants().STOREVALUE(value: countryCode, keyname: "user_country_code")
    }
    
    
}


enum EditingState {
    case editProfile
    case updateProfile
}
