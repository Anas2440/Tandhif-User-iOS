//
//  BaseView.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class BaseView: UIView {
    fileprivate var baseVC : BaseViewController?
    @IBOutlet weak var backBtn : UIButton?
    var sharedVariable: SharedVariables {
        return SharedVariables.sharedInstance
    }
    
    @IBAction
    func backAction(_ sender : UIButton){
        self.baseVC?.exitScreen(animated: true)
    }
    
//    var language : LanguageContentModel {
//        get{return Shared.instance.language!}
//    }
    
    
    
    
    func didLoad(baseVC : BaseViewController){
        self.backBtn?.setImage(UIImage(named: "back"), for: .normal)
        self.backBtn?.setTitle(nil, for: .normal)
        self.backBtn?.transform = isRTLLanguage ? CGAffineTransform(rotationAngle: .pi) : .identity
        UITextView.appearance().tintColor = .PrimaryColor
        self.baseVC = baseVC
        self.darkModeChange()
        
    }
    
    func darkModeChange(){
        UIView.animate(withDuration: 0.3) {
            self.baseVC?.setNeedsStatusBarAppearanceUpdate()
        }
//        UIApplication.shared.statusBarView?.backgroundColor = self.isDarkStyle ? .darkBackgroundColor : .SecondaryColor
        
        self.backBtn?.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backBtn?.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.backBtn?.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backBtn?.titleLabel?.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        UITextField.appearance().keyboardAppearance = self.isDarkStyle ? .dark : .light
        UISearchBar.appearance().keyboardAppearance = self.isDarkStyle ? .dark : .light
    }
    
    func willAppear(baseVC : BaseViewController){}
    func didAppear(baseVC : BaseViewController){}
    func willDisappear(baseVC : BaseViewController){}
    func didDisappear(baseVC : BaseViewController){}
    func didLayoutSubviews(baseVC: BaseViewController){}

    //MARK:- UDF
    func getPlaceholderLbl(for scrollView : UIScrollView) -> UILabel{
        let label = UILabel()
        label.textColor = .ThemeTextColor
        label.frame = scrollView.bounds
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = AppTheme.Fontmedium(size: 15).font
        return label
    }
}
