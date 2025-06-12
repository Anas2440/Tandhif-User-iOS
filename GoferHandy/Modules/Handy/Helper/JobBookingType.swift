//
//  JobBookingType.swift
//  GoferHandy
//
//  Created by trioangle on 15/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


enum JobBookingType{
    case bookLater(date: String, time : DayElement)
    case bookNow
    
    ///returns json params for API request
    var getParams : JSON{
        switch self {
        case .bookNow:
            return ["booking_type":"book_now"]
            
        case .bookLater(date: let date, time: let time):
            return [
                "booking_type":"book_later",
                "date":date,
                "time":time.time
            ]
        }
    }
}

