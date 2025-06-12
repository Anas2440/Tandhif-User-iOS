//
//  UIButton+Extension.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func setActive(_ active : Bool){
        if active{
            self.alpha = 1
            self.isUserInteractionEnabled = true
        }else{
            self.alpha = 0.5
            self.isUserInteractionEnabled = false
        }
    }
    
    func setMainActive(_ active : Bool) {
        self.isUserInteractionEnabled = active
        self.backgroundColor = active ? .PrimaryColor : .TertiaryColor
    }
    
}
