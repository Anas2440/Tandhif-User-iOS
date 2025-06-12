//
//  PaymentDataSource.swift
//  GoferDeliverAll
//
//  Created by trioangle on 26/06/20.
//  Copyright © 2020 Balajibabu. All rights reserved.
//

import Foundation


//enum PaymentOption : String{
//    case cash
//    case paypal
//    case stripe
//    case stripe_card
//    case braintree
//    case onlinepayment
//
//    static var `default` : PaymentOption?{
//        get{
//            let string : String =  LocalStorage.shared.value(for: .selectedPaymentOption) ?? ""
//            return PaymentOption(rawValue: string)
//        }
//        set{
//            LocalStorage.shared.set(newValue?.rawValue, for: .selectedPaymentOption)
//        }
//    }
//    var paramValue : Int{
//        switch self {
//        case .cash:      return 0
//        case .stripe:    return 1
//        case .paypal:    return 2
//        case .onlinepayment: return 3
//        case .braintree: return 4
//        default:         return -99
//        }
//    }
//    init(from key : String){
//        self = Self.init(rawValue: key) ?? .cash
//    }
//}
//
//
//class PaymentData{
//    let key : String
//    let value : String
//    let icon : String
//    var isDefault : Bool
//    init(_ json : JSON) {
//        self.key = json.string("key")
//        self.value = json.string("value")
//        self.icon = json.string("icon")
//        self.isDefault = json["is_default"] as? Bool ?? false
//    }
//    var option : PaymentOption{
//        return PaymentOption(from: self.key)
//    }
//}
//class PaymentDataHolder{
//    var data : [PaymentData]
//    init(_ json : JSON){
//        self.data = json.array("payment_list").compactMap({PaymentData($0)})
//    }
//    func getAvailableOptions() -> [PaymentData]{
//        if let availableOption = PaymentOption.default{
//            var newData = [PaymentData]()
//            for option in self.data{
//                option.isDefault = option.option == availableOption
//                newData.append(option)
//            }
//            return newData
//        }
//        return self.data
//    }
//    func getSelectedOption(forWallet : Bool = false) -> PaymentData?{
//        let selected = self.getAvailableOptions().filter({$0.isDefault}).first
//        if selected?.option == .cash && forWallet{
//            return nil
//        }
//        return selected
//    }
//
//}
