//
//  Ex + UILabel.swift
//  Goferjek
//
//  Created by Trioangle on 03/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

public
enum Weight {
    case regular
    case medium
    case bold
}

extension UILabel {
    open
    func setFont(size: CGFloat,
                 weight: Weight = .regular) {
        switch weight {
        case .regular:
            self.font = AppTheme.Fontlight(size: size).font
        case .medium:
            self.font = AppTheme.Fontmedium(size: size).font
        case .bold:
            self.font = AppTheme.Fontbold(size: size).font
        }
    }
    
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
