//
//  UserPreference.swift
//  Goferjek
//
//  Created by Trioangle on 06/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

enum UserPreference : String {
    case firebase_token
    case firebase_auth
    case access_token
    case Promo_Code
    case FBAcessToken
    case full_name
    case first_name
    case last_name
    case gender
    case user_image
    case user_fbid
    case user_id
    case user_email_id
    case dial_code
    case user_country_code
    case paypal_email_id
    case payment_stride_app_key
    case work_loc
    case home_loc
    case work_latitude
    case work_longitude
    case wallet_amount
    case payment_method
    case selectwallet
    case paypal_app_id
    case paypal_mode
    case home_latitude
    case home_longitude
    case device_token
    case licence_back
    case licence_front
    case licence_insurance
    case licence_rc
    case licence_permit
    case user_currency_org
    case user_currency_symbol_org
    case phonenumber
    case Rider
    case device_default_language
    case user_credit_card_sufix
    case user_credit_card_brand
    case user_paypal_default_wallet_payment
    case user_stripe_default_wallet_payment
    case trip_driver_thumb_url
    case trip_driver_name
    case trip_driver_rating
    case user_start_date
    case user_end_date
    case user_longitude
    case user_latitude
    case user_location
    case I
    
    var value : String {
        if let result = UserDefaults.standard.value(forKey: self.rawValue) as? String {
            return result
        } else {
            debug(print: "No Value Found in This Key \(self.rawValue)")
            return ""
        }
    }
    func set(newValue :String) {
        UserDefaults.standard.set(newValue,
                                  forKey: self.rawValue)
    }
}

