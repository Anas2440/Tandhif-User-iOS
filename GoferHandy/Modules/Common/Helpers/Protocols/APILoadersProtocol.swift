//
//  APIProtocols.swift
//  Gofer
//
//  Created by trioangle on 23/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire


//MARK:- protocol APILoadersProtocol
/**
 api progress loading handler
 - Author: Abishek Robin
 */
protocol APILoadersProtocol{
    func shouldLoad(_ shouldLoad: Bool,function : String)
}
extension APILoadersProtocol{
    
    func shouldLoad(_ shouldLoad: Bool,function : String = #function){
        self.shouldLoad(shouldLoad, function: function)
    }
}

