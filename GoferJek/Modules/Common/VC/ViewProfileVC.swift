//
//  ViewProfileVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
protocol EditProfileDelegate
{
    func setprofileInfo()
}
class ViewProfileVC: BaseViewController {
    
    var mobileValidationPurpose:  NumberValidationPurpose!
    var accountViewModel : AccountViewModel!
    @IBOutlet var viewProfileView: ViewProfileView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isProfileValueAvailable {
            self.viewProfileView.setUserProfileInfo(profileModel: Global_UserProfile)
        } else {
            self.getProfileModel()
        }
//        if let profileModel = accountViewModel.profileModel {
//            self.viewProfileView.setUserProfileInfo(profileModel: profileModel)
//        }else{
//            self.getProfileModel()
//        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    //MARK:- initWithStory
    class func initWithStory(accountVM : AccountViewModel) -> ViewProfileVC{
        let view : ViewProfileVC = UIStoryboard.gojekAccount.instantiateViewController()
        view.accountViewModel = accountVM
        return view
    }
  
  
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.viewProfileView.ThemeChange()
    }
  
    func navicationToChangePasswordVC() {
      let nextViewController = ChangePasswordVC.initWithStory()
      //  Change Password View Controller Customisation(Presenting Style)
      nextViewController.modalPresentationStyle = .overCurrentContext
      nextViewController.modalTransitionStyle = .coverVertical
      self.present(nextViewController, animated:true, completion:nil)
    }
  
    func onSaveProfileApiCall(params: [AnyHashable: Any]){
        self.accountViewModel.profileVCApiCall(parms: params){(result) in
            switch result{
            case .success(let result):
                if result.isSuccess {
                    self.viewProfileView.updateProfileModel()
                } else {
                    AppDelegate.shared.createToastMessage(result.status_message)
                }
            case .failure( _):
                UberSupport.shared.removeProgressInWindow()
            }
            
        }
    }
    
    func getProfileModel() {
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym
        getGloblalUserDetail(params: param) { result in
            switch result {
            case .success(let profile):
                self.viewProfileView.setUserProfileInfo(profileModel: profile)
                debug(print: profile.address + "____ Profile Loaded _____")
            case .failure(let error):
                debug(print: error)
            }
        }
//        self.accountViewModel.getUserProfile { (result) in
//            switch result{
//            case .success(let model):
//                self.viewProfileView.setUserProfileInfo(profileModel: model)
//            case .failure(let error):
//                print("\(error.localizedDescription)")
////                AppDelegate.shared.createToastMessage(error.localizedDescription)
//            }
//        }
    }
}
