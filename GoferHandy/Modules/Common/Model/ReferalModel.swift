//
//  ReferalModel.swift
//  Gofer
//
//  Created by Trioangle on 24/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

enum ReferalStatus : String{
    case pending = "Pending"
    case expired = "Expired"
    case completed = "Completed"
    var displayText : String{
        switch self {
        case .pending:
            return LangCommon.pending.uppercased()
        case .expired:
            return LangCommon.expired.uppercased()
        case .completed:
            return LangCommon.completed.uppercased()

        }
    }
}
enum ReferalType : Int{
    case completed = 1
    case inComplete = 0
}
class ReferalModel{
    var id =  Int()
    var days =  Int()
    var name = String()
    var profile_image = String()
    var profile_image_url : URL?{
        return URL(string: self.profile_image)
    }
    var remaining_days =  Int()
    var trips =  Int()
    var remaining_trips =  Int()
    var start_date =  String()
    var end_date =  String()
    var earnable_amount =  String()
    var status = ReferalStatus.pending
    var defaultStatus = ReferalStatus.pending

    var getDesciptionText : String {
        var text = "\(self.remaining_days) "
        text.append(self.remaining_days == 1 ? LangCommon.dayLeft  : LangCommon.daysLeft )
        text.append(" \(self.remaining_trips) ")
        text.append(self.remaining_trips == 1 ? LangHandy.job : LangCommon.jobs)
        return text
    }
    init(withJSON json : JSON){
        self.id = json.int("id")
        self.name = json.string("name")
        self.profile_image = json.string("profile_image")
        self.days = json.int("days")
        self.remaining_days = json.int("remaining_days")
        self.trips = json.int("jobs")
        self.remaining_trips = json.int("remaining_jobs")
        self.start_date = json.string("start_date")
        self.earnable_amount = json.string("earnable_amount")
        self.end_date = json.string("end_date")
        self.status = ReferalStatus.init(rawValue: json.string("status")) ?? .pending
        self.defaultStatus = ReferalStatus.init(rawValue: json.string("default_status")) ?? .pending
    }
}
