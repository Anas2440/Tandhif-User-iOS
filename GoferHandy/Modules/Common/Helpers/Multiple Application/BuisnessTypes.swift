//
//  BuisnessTypes.swift
//  GoferHandy
//
//  Created by trioangle on 04/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

enum BusinessType : Int,Codable,CaseIterable{
    case Services = 1
    case Delivery = 2
    case DeliveryAll = 3
    case Ride = 4
    case Gojek = 5

    var userTitle : String{
        switch self {
        case .Services:
            return LangHandy.user
        default:
            return ""
        }
    }
    
//    var APIBaseURL : String {
//        switch self {
//        case .Services:
//            return AppWebConstants.APIBaseUrl
//        case .Ride:
//            return "http://gofer.trioangledemo.com/api/"
//        case .Delivery:
//            return "https://goferdelivery.trioangledemo.com/api/"
//        case .DeliveryAll:
//            return "https://goferdeliveryall.trioangledemo.com/api/"
//        }
//    }
    
    var LocalToken : String {
        switch self {
        case .Services:
            return ""
        case .Ride:
            return ""
        case .Delivery:
            return ""
        case .DeliveryAll:
            return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2dvZmVyZGVsaXZlcnlhbGwudHJpb2FuZ2xlZGVtby5jb20vYXBpL3JlZ2lzdGVyIiwiaWF0IjoxNjIyNzgwNTc2LCJleHAiOjE2MjU0MDg1NzYsIm5iZiI6MTYyMjc4MDU3NiwianRpIjoiNURVc2NLeExHaDFKZ3djaSIsInN1YiI6MTAwNDAsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.LGs09q9oQsba25hAscCNkrJF2rTh5lTN0Gqs5W5rZzw"
        case .Gojek:
            return ""
        }
    }
    
    var LocalizedString: String {
        switch self {
        case .Services:
            return "Services"
        case .Ride:
            return "Ride"
        case .Delivery:
            return "Delivery"
        case .DeliveryAll:
            return "DeliveryAll"
        case .Gojek:
            return "Gojek"
        }
    }
}
