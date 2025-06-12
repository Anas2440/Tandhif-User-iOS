//
//  Ex + NSMutableAttributedString.swift
//  Goferjek
//
//  Created by Trioangle on 03/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

extension NSMutableAttributedString {
    func attributedString(_ value:String,
                          foregroundColor : UIColor,
                          fontWeight : Weight,
                          fontSize: CGFloat = 17,
                          strikeNeed: Bool = false,
                          strikeColor : UIColor = .clear,
                          strikeStyle : NSUnderlineStyle = .single,
                          underLineColor : UIColor = .clear,
                          underLineStyle : NSUnderlineStyle = .single,
                          underLineNeed: Bool = false ) -> NSMutableAttributedString {
        var font : UIFont = .systemFont(ofSize: fontSize,
                                        weight: fontWeight == .regular ? .regular : .bold)
        switch fontWeight {
        case .regular:
            font = AppTheme.Fontlight(size: fontSize).font
        case .medium:
            font = AppTheme.Fontmedium(size: fontSize).font
        case .bold:
            font = AppTheme.Fontbold(size: fontSize).font
        }
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font,
            .foregroundColor : foregroundColor,
            .strikethroughColor : strikeNeed ? strikeColor : .clear,
            .strikethroughStyle : strikeStyle.rawValue,
            .underlineColor : underLineNeed ? underLineColor : .clear,
            .underlineStyle : underLineStyle.rawValue,
        ]
        self.append(NSAttributedString(string: value,
                                       attributes:attributes))
        return self
    }
    
    
    func setColorForText(textToFind: String,
                         withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setFont(textToFind: String,
                 weight: UIFont.Weight,
                 fontSize: CGFloat) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        switch weight {
        case .light:
            let myAttribute = [ NSAttributedString.Key.font: AppTheme.Fontlight(size: fontSize).font ]
            self.setAttributes(myAttribute, range: range)
        case .medium:
            let myAttribute = [ NSAttributedString.Key.font: AppTheme.Fontmedium(size: fontSize).font ]
            self.setAttributes(myAttribute, range: range)
        case .bold:
            let myAttribute = [ NSAttributedString.Key.font: AppTheme.Fontbold(size: fontSize).font ]
            self.setAttributes(myAttribute, range: range)
        default:
            let myAttribute = [ NSAttributedString.Key.font: AppTheme.Fontlight(size: fontSize).font ]
            self.setAttributes(myAttribute, range: range)
        }
    }
    
}
