//
//  Ex + UITextView.swift
//  Goferjek
//
//  Created by Trioangle on 06/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

extension UITextView {
    open
    func setTextAlignment(aligned: NSTextAlignment = .left) {
        switch aligned {
        case .right:
            self.textAlignment = isRTLLanguage ? .left : .right
        case .left:
            self.textAlignment = isRTLLanguage ? .right : .left
        default:
            self.textAlignment = aligned
        }
    }
}
