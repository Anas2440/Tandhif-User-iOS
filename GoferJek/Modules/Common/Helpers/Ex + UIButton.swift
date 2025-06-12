//
//  Ex + UIButton.swift
//  Goferjek
//
//  Created by Trioangle on 06/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
extension UIButton {
    open
    func setTextAlignment(aligned: NSTextAlignment = .left) {
        switch aligned {
        case .right:
            self.contentHorizontalAlignment = isRTLLanguage ? .left : .right
        case .left:
            self.contentHorizontalAlignment = isRTLLanguage ? .right : .left
        default:
            self.contentHorizontalAlignment = .center
        }
    }
}
