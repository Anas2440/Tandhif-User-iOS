//
//  UIImage+extension.swift
//  GoferDeliverAll
//
//  Created by trioangle on 20/03/21.
//  Copyright © 2021 Balajibabu. All rights reserved.
//

import Foundation
import UIKit

import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

extension NSNotification {
    func getKeyboardHeight() -> CGFloat? {
        guard let keyboardFrame: NSValue = self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
        let keyboardRectangle = keyboardFrame.cgRectValue
        return keyboardRectangle.height
        
    }
}
