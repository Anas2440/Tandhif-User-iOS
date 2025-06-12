//
//  UIApplication+Extension.swift
//  GoferHandy
//
//  Created by trioangle on 17/11/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//


//UIApplication.shared.windows.first { $0.isKeyWindow }

import Foundation
import UIKit

extension UIApplication {
    //func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    func topViewController(_ base: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        switch (base) {
        case let controller as UINavigationController:
            return topViewController(controller.visibleViewController)
        case let controller as UITabBarController:
            return controller.selectedViewController.flatMap { topViewController($0) } ?? base
        default:
            return base?.presentedViewController.flatMap { topViewController($0) } ?? base
        }
    }
}
