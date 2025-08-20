//
//  PaymentOption.swift
//  Gofer
//
//  Created by trioangle on 29/01/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
enum PaymentOptions : String{
    case tips = "T"
    
    case brainTree = "B"
    case cash = "C"
    case paypal = "P"
    case stripe = "S"
    case onlinepayment = "O"
    case apple_pay = "A"
    case google_pay = "G"

    static var `default` : PaymentOptions?{
        guard let string : String = UserDefaults.value(for: .payment_method) else{return nil}
        //        let char = string?.first?.uppercased()
        return PaymentOptions(rawValue: string.uppercased())
    }

    func with(wallet : Bool,promo : Bool) -> String{
        var value = self.rawValue
        if wallet{
            value.append("W")
        }
        if promo{
            value.append("P")
        }
        return value
    }
    
    func setAsDefault(){
        UserDefaults.set(self.rawValue, for: .payment_method)
     
    }
    var paramValue : String{
        switch self {
            case .brainTree:
                return "Braintree"
            case .paypal:
                return "Paypal"
            case .stripe:
                return "Stripe"
            case .cash:
                return "Cash"
            case .onlinepayment:
                return "onlinepayment"
            case .google_pay:
                return "Google Pay"
            case .apple_pay:
                return "apple_pay"
            default:
                return ""
        }
    }
    
    
    var iCon : UIImage{
        switch self {
            case .brainTree:
                return UIImage(named: "braintree")!
            case .paypal:
                return UIImage(named: "paypalnew")!
            case .stripe:
                if let brand : String = UserDefaults.value(for: .card_brand_name),
                   let _ : String = UserDefaults.value(for: .card_last_4){
                    return self.getCardImage(forBrand: brand)
                }else{
                    fallthrough
                }
            case .cash:
                return UIImage(named:"cash")!
            case .onlinepayment:
                return UIImage(named: "onlinePay")!
            case .apple_pay:
                return UIImage(named: "apple-pay")!
            default:
                return UIImage(named:"cash")!
        }
    }
    
    init(key : String) {
        switch key.lowercased() {
            case "stripe":
                self = .stripe
            case "cash":
                self = .cash
            case "paypal":
                self = .paypal
            case "braintree":
                self = .brainTree
            case "stripe_card":
                self = .stripe
            case "onlinepayment":
                self = .onlinepayment
            case "apple_pay":
                self = .apple_pay
            case "google_pay":
                self = .google_pay
            default:
                self = .cash
        }
    }
    func getCardImage(forBrand brand : String) -> UIImage{
        switch brand.capitalized{
        case "Visa".capitalized:
            return UIImage(named: "card_visa") ?? #imageLiteral(resourceName: "card_basic")
        case "MasterCard".capitalized:
            return UIImage(named: "card_master") ?? #imageLiteral(resourceName: "card_basic")
        case "Discover".capitalized:
            return UIImage(named: "card_discover") ?? #imageLiteral(resourceName: "card_basic")
        case "Amex".capitalized,"American Express".capitalized:
            return UIImage(named: "card_amex") ?? #imageLiteral(resourceName: "card_basic")
        case "JCB".capitalized,"JCP".capitalized:
            return UIImage(named: "card_jcp") ?? #imageLiteral(resourceName: "card_basic")
        case "Diner".capitalized,"Diners".capitalized,"Diners Club".capitalized:
            return UIImage(named: "card_diner") ?? #imageLiteral(resourceName: "card_basic")
        case "Union".capitalized,"UnionPay".capitalized:
            return UIImage(named: "card_unionpay") ?? #imageLiteral(resourceName: "card_basic")
        default:
            return UIImage(named: "card_basic") ?? #imageLiteral(resourceName: "card_basic")
        }
    }
}
extension PaymentOptions : Codable{
    
}
