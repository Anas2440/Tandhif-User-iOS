//
//  FIRRiderModel.swift
//  Gofer
//
//  Created by trioangle on 04/06/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

protocol FIRModel {
    var updateValue : [AnyHashable:Any]{get}

}

//class FIRRiderModel : DriverDetailModel,FIRModel{
//    
//    var updateValue: [AnyHashable:Any]{
//        return ["trip_id":self.getTripID]
//    }
//    
//    override init(withJson json: JSON) {
//        super.init(withJson: json)
//    }
//    
//}

