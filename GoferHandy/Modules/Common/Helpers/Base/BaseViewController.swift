//
//  BaseViewController.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    fileprivate var _baseView : BaseView? {
        return self.view as? BaseView
    }
    fileprivate var onExit : (()->())? = nil
    
    var stopSwipeExitFromThisScreen : Bool? {
        return nil
    }
    //MARK:- life cycle
    
    lazy var commonAlert :CommonAlert =  {
        let alert = CommonAlert()
        return alert
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self._baseView?.didLoad(baseVC: self)
        // Do any additional setup after loading the view.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self._baseView?.darkModeChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._baseView?.willAppear(baseVC: self)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._baseView?.didAppear(baseVC: self)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let attribute : UISemanticContentAttribute = isRTLLanguage ? .forceRightToLeft : .forceLeftToRight
        if self.navigationController?.navigationBar.semanticContentAttribute != attribute{
            self.navigationController?.view.semanticContentAttribute = attribute
            self.navigationController?.navigationBar.semanticContentAttribute = attribute
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._baseView?.willDisappear(baseVC: self)
        
      
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self._baseView?.didDisappear(baseVC: self)
        
        if self.isMovingFromParent{
            self.willExitFromScreen()
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self._baseView?.didLayoutSubviews(baseVC: self)
    }
    
    //MARK:- UDF
    func exitScreen(animated : Bool,_ completion : (()->())? = nil){
        self.onExit = completion
        if self.isPresented(){
            self.dismiss(animated: animated) {
                completion?()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
    }
    ///called when screen will pop back
    func willExitFromScreen(){
        
    }

}

extension BaseViewController : UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = self.navigationController else {return true}
        if self.stopSwipeExitFromThisScreen ?? false{return false }
        return nav.viewControllers.count > 1
    }
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
