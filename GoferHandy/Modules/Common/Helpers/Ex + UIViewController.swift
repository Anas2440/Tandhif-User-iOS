//
//  Ex + UIViewController.swift
//  Goferjek
//
//  Created by Trioangle on 03/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

public
typealias PresentResult = (() -> Void)?
extension UIViewController {
    
    /// Note: - Method Used to Present the Given ViewController
    public
    func presentVC(_ vc: UIViewController,
                   animated : Bool = true,
                   trans : UIModalTransitionStyle = .coverVertical,
                   style : UIModalPresentationStyle = .fullScreen,
                   completion : PresentResult) {
        vc.modalPresentationStyle = style
        vc.modalTransitionStyle = trans
        self.present(vc,
                     animated: animated,
                     completion: completion)
    }
    
    /// Note: - Method Used to Present the Given ViewController
    public
    func pushVC(_ vc: UIViewController,
                animated : Bool = true) {
        if self.isInNavigation(vc.self) {
            self.navigationController?.popToViewController(vc,
                                                           animated: animated)
        } else {
            self.navigationController?.pushViewController(vc,
                                                          animated: animated)
        }
    }
    
    /// Note: - Method Used to Check the Given ViewController is Already Present is NavigationController
    public
    func isInNavigation(_ vc: UIViewController) -> Bool {
        return self.navigationController?.viewControllers.filter({$0.isKind(of: vc.classForCoder)}).first != nil
    }
}
