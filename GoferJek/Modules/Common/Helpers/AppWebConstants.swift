//
//  ProjectConfig.swift
//  Gofer
//
//  Created by trioangle on 11/05/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

final class AppWebConstants : NSObject  {
    
    // Common initalisation for object
    private override init() { super.init() }
    /**
     Shared Variable For Appwebconstants
     - note : use to access the Values inside the Appwebconstants
     */
    static let instance = AppWebConstants()
    
    // Delivery Splitup Start
    // Handy Splitup Start
    // MARK: - Business Type Details
    /**
     BusinessType are used to define the Current Application Behaviour
     -  note : Current Project Values are Stored in businessType
     - warning : if you need Single Application Start Don't For get Set 'true' in isSingleApplication
     */
    static var businessType : BusinessType = .Services
    /**
     availableBusinessType are used to hold the All Service List available in the project
     -  note : availableBusinessType is Useful for Filter Function
     - warning : Need to Have Value for Mutiple Application otherWise filter option won't work
     */
    static var availableBusinessType : [GojekService] = []
    // Delivery Splitup End
    // Handy Splitup End
    
    static var isSingleCatagoryApplication : Bool = false
    
    static var isSingleCatagoryID : Int = 0
    
    static var is18plusVerificationRequired : Bool = false
    
    static var isReciptImageRequired : Bool = false
    
    static var isDeliveryAllServicePage : Bool = false
    
    static var serviceName : String = ""
}

