//
//  SelectLanguageVC.swift
//  GoferDriver
//
//  Created by trioangle on 20/04/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit


class SelectLanguageVC: BaseViewController {
    
    //----------------------------------------
    //MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet var selectLanguageView: SelectLanguageView!
    @IBOutlet weak var hoverViewHeightCons: NSLayoutConstraint!
    
    //----------------------------------------
    //MARK: - Local Variables
    //----------------------------------------
    
    var isFirstTime:Bool = false
    
    //----------------------------------------
    //MARK: - Life Cycle or Override Functions
    //----------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //----------------------------------------
    //MARK: - initalisation of Storyboard
    //----------------------------------------
    
    class func initWithStory() -> SelectLanguageVC {
        return UIStoryboard.gojekCommon.instantiateViewController()
    }
    
    //----------------------------------------
    //MARK: - ws functions
    //----------------------------------------
    
    func update(language : Language) {
        let support = UberSupport()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        support.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(for: .updateLanguage,
                        params: [ "language" : language.key ]
        ).responseJSON({ (response) in
            support.removeProgressInWindow()
            if response.isSuccess{
                language.saveLanguage()
                appDelegate?.makeSplashView(isFirstTime: false)
            }
        }).responseFailure({ (error) in
            support.removeProgressInWindow()
//            appDelegate?.createToastMessage(error)
        })
    }
}




