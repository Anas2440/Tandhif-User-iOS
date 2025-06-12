//
//  IconNames.swift
//  GoferHandy
//
//  Created by trioangle on 04/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


enum IconName : String{
    case radioSelected = "radio_Button_checked"
    case radioUnselected = "radio_Button_unchecked"
    case phnIcon = "User_id"
    case pwdIcon = "Password"
}

extension UIImage{
    convenience init?(for image : IconName){
        self.init(named: image.rawValue)
    }
}
