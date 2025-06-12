//
//  LoginVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LoginVC: BaseViewController{
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    @IBOutlet var loginView: LoginView!
    
    //---------------------------------------
    // MARK: - Class Variables
    //---------------------------------------
    
    var welcomeNavigation : WelcomeNavigationProtocol!
    var accViewModel : AccountViewModel!
    
    //---------------------------------------
    // MARK: - Life Cycles
    //---------------------------------------
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = true
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //---------------------------------------
    // MARK: - init With Story Board
    //---------------------------------------
    
    class func initWithStory(_ delegate : WelcomeNavigationProtocol) -> LoginVC{
        let view : LoginVC = UIStoryboard.gojekAccount.instantiateViewController()
        view.accViewModel = AccountViewModel()
        view.welcomeNavigation = delegate
        return view
    }
    
    //---------------------------------------
    // MARK: - WS Function
    //---------------------------------------
    
    func callLoginAPI(parms: [AnyHashable: Any]){
        self.accViewModel
            .LoginApicall(parms: parms){(result) in
                switch result{
                    case .success:
                        self.loginView.selectedCountry?.store()
                        let userDefaults = UserDefaults.standard
                        userDefaults.set("rider", forKey:"getmainpage")
                        AppDelegate.shared.onSetRootViewController(viewCtrl: self)
                    case .failure(let error):
                        print(error.localizedDescription)
                        AppDelegate.shared.createToastMessage(error.localizedDescription)
                        self.loginView.removeProgress()
                }
            }
    }
}
