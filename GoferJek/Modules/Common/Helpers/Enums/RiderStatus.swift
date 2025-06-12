//
//  RiderStatus.swift
//  Gofer
//
//  Created by trioangle on 24/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

enum UserStatus : Int{
    
    case online = 1
    case offline = 0
}
extension Bool : ExpressibleByIntegerLiteral{
    public init(integerLiteral value: Int) {
        self = value != 0
    }
}
