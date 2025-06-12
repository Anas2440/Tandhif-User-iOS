//
//  UILabel+Extenstion.swift
//  GoferHandy
//
//  Created by trioangle on 31/05/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addAttributeText(originalText: String,
                          attributedText: String,
                          attributedColor:UIColor,
                          isStrikeLine:Bool=false) {
        let strName = originalText
        let string_to_color2 = attributedText
        let attributedString1 = NSMutableAttributedString(string:strName)
        let range2 = (strName as NSString).range(of: string_to_color2)
        print(range2)
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor,
                                       value: attributedColor,
                                       range: range2)
        if isStrikeLine {
            attributedString1.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                           value: 2,
                                           range: range2)
        }
        
        self.attributedText = attributedString1
    }
    
    func addFontAttribute(originalText:String,
                          attrText:String,
                          font:UIFont,
                          isStrikeLine:Bool=false){
        let strName = originalText
        let string_to_color2 = attrText
        let attributedString1 = NSMutableAttributedString(string:strName)
        let range2 = (strName as NSString).range(of: string_to_color2)
        print(range2)
        attributedString1.addAttribute(NSAttributedString.Key.font, value: font, range: range2)
        if isStrikeLine {
            attributedString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range2)
        }
        self.attributedText = attributedString1
    }
}
