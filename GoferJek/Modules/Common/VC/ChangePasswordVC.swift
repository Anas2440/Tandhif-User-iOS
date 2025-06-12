//
//  ChangePasswordVC.swift
//  GoferHandy
//
//  Created by Trioangle on 09/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class ChangePasswordVC: BaseViewController {
    var changePasswordView:ChangePasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordView = self.view as? ChangePasswordView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    class func initWithStory() -> ChangePasswordVC {
        return UIStoryboard.gojekAccount.instantiateViewController()
    }
    
    func wsToSetNewPassword(param: JSON) {
        let accountData = AccountViewModel()
        Shared.instance.showLoaderInWindow()
        accountData.updatePasswordApi(params: param) { (result) in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    self.changePasswordView.alertCreater(Title: appName,
                                                         Messasage: LangCommon.successFullyUpdated)
                } else {
                    self.view.endEditing(true)
                    AppDelegate.shared.createToastMessage(response.statusMessage)
                }
                Shared.instance.removeLoaderInWindow()
            case .failure(let error):
                print("\(error.localizedDescription)")
                Shared.instance.removeLoaderInWindow()
//                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.changePasswordView.ThemeChange()
    }
}
