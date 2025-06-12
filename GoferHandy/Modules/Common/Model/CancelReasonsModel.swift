//
//  CancelReasonsModel.swift
//  Gofer
//
//  Created by Trioangle on 19/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation


class CancelReason {
    let id: Int
    let reason: String
    let cancelled_by : String
    let status : String
    init(_ json:JSON){
        self.id = json.int("id")
        self.cancelled_by = json.string("cancelled_by")
        self.reason = json.string("reason")
        self.status = json.string("status")
    }
}
extension CancelReason : CustomStringConvertible{
    var description: String{
        return self.reason
    }
}
extension CancelReason : CustomDebugStringConvertible{
    var debugDescription: String{
        return "id : \(self.id), reason : \(self.reason)"
    }
}
