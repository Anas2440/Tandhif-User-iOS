//
//  GoferPayementEngine.swift
//  Gofer
//
//  Created by trioangle on 18/06/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
protocol PaymentType {
    var name : String { get }
    var logo : UIImage?{ get }
    
    func setUP() throws
    
    
}
