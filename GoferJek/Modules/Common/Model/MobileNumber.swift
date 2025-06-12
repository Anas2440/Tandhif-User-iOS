//
//  MobileNumber.swift
//  Gofer
//
//  Created by trioangle on 11/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
/**
 Model for mobile number
 - Author: Abishek Robin
 - Note: class has Mobile number and flag(CountryCode,FlagImage,DialCode)
 */
struct MobileNumber {
    let number : String
    let flag : CountryModel
}
