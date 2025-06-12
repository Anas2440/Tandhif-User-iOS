//
//  NavigationBar.swift
//  GoferHandy
//
//  Created by trioangle on 28/05/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func setNavigationBar(title:String,backtitle:String,isrequiredBackBtn:Bool) {
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: false)
        self.navigationController?.navigationBar.barTintColor = .PrimaryColor
        self.navigationController?.navigationBar.isHidden = false
        let label = UILabel()
        label.text = title
        label.tintColor = .PrimaryTextColor
        label.font = AppTheme.Fontbold(size: 18).font
        label.textColor = .PrimaryTextColor
        label.textAlignment = isRTLLanguage ? .right : .left
        label.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.alpha = 1.0
        self.navigationItem.titleView = label
        self.navigationController?.navigationBar.tintColor = .PrimaryColor
        self.navigationController?.navigationBar.setValue(true,
                                                          forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        //  self.navigationItem.setHidesBackButton(true, animated: true)
        
        if isrequiredBackBtn {
            let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
            let backButton = UIButton(type: .custom)
            backButton.setImage(backButtonImage,
                                for: .normal)
            backButton.setTitle(backtitle,
                                for: .normal)
            backButton.addTarget(self,
                                 action: #selector(self.backButtonPressed),
                                 for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }
    
    @objc
    func backButtonPressed() {
        if self.isPresented() {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension UIViewController {
    func appThemeNavigation() {
        self.navigationController?.navigationBar.barTintColor  = .PrimaryColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .PrimaryColor
        self.navigationController?.navigationBar.setValue(true,
                                                          forKey: "hidesShadow")
        
    }
    
    func settitleBar() {
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: false)
        self.navigationController?.navigationBar.barTintColor = .PrimaryColor
        self.navigationController?.navigationBar.isHidden = false
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.view.frame.width * 0.7,
                                          height: 30))
        label.text = "Your Basket"
        label.tintColor = UIColor.IndicatorColor
        label.font = AppTheme.Fontbold(size: 18).font
        label.textColor = .PrimaryTextColor
        label.textAlignment = isRTLLanguage ? .right : .left
        self.navigationController?.navigationBar.alpha = 1.0
        self.navigationItem.titleView = label
        self.navigationController?.navigationBar.tintColor = .PrimaryColor
        navigationController?.navigationBar.setValue(true,
                                                     forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
    }
}




extension UIViewController {
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
}
extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
