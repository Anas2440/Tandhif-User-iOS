//
//  UIAlertController+Extension.swift
//  GoferHandy
//
//  Created by trioangle on 21/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    func addColorInTitleAndMessage(titleColor:UIColor,
                                   messageColor:UIColor,
                                   titleFontSize:CGFloat = 18,
                                   messageFontSize:CGFloat = 13){
        let attributesTitle =  [NSAttributedString.Key.foregroundColor:titleColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: titleFontSize)]
        let attributesMessage = [NSAttributedString.Key.foregroundColor:messageColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: messageFontSize)]
        let attributedTitleText = NSAttributedString(string: self.title ?? "", attributes: attributesTitle)
        let attributedMessageText = NSAttributedString(string: self.message ?? "", attributes: attributesMessage)
        self.setValue(attributedTitleText, forKey: "attributedTitle")
        self.setValue(attributedMessageText, forKey: "attributedMessage")
        
    }
    
}



