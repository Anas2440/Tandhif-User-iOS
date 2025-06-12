//
//  LocalStorage.swift
//  PassUp
//
//  Created by trioangle on 11/12/19.
//  Copyright © 2019 Six square. All rights reserved.
//

import Foundation
import UIKit

class LocalStorage {
    
    enum LocalValue:String {
        case k_isShowOTP
        case plist_isLive
        case plist_URL
        case plist_APIKey
        case plist_GoogleAPIKey
        case G_clientID
        
        case clientSecret = "intent_client_secret"
        case selectedCurrency = "default_currency_code"
        case selectedCurrencySymbol = "default_currency_symbol"
        case selectedPaymentOption = "selected_payment_option"
        case nonUserDeliveryType
        case user_token
    }
    
    static var shared = LocalStorage()
    
    func set<T>(_ value : T, for key : LocalValue){
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    func value<T>(for key : LocalValue ) -> T?{
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func setSting(_ key:LocalValue,text:String = "" ){
        UserDefaults.standard.set(text, forKey: key.rawValue)
    }
    
    func setInt(_ key:LocalValue,value:Int = 0) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func setBool(_ key :LocalValue,value:Bool = false) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func setDouble(_ key :LocalValue,value:Double = 0.0) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func setPlistKey(_ key :LocalValue,value:[String:String]) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    
    func getPlistDict(key:LocalValue)->[String:String]{
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setSting(key)
        }
        if let result = UserDefaults.standard.value(forKey: key.rawValue) as? [String : String]{
            return result
        }
        return  [String:String]()
    }
   
    func getString(key:LocalValue)->String {
      
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setSting(key)
        }
        if let result = UserDefaults.standard.string(forKey: key.rawValue) {
            return result
        }
        return  ""
    }
    
    func getInt(key:LocalValue)->Int{
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setInt(key)
        }
        let result = UserDefaults.standard.integer(forKey: key.rawValue)
        return result
    }
    
    func getBool(key:LocalValue)->Bool {
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setBool(key)
        }
        let result = UserDefaults.standard.bool(forKey: key.rawValue)
        return result
    }
    func getDouble(key:LocalValue)->Double {
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setDouble(key)
        }
        let result = UserDefaults.standard.double(forKey: key.rawValue)
        return result
    }
    

}


extension Array {
    
    func localize()->[Element] {
        if Languages.RTL.instance == .forceRightToLeft {
            
            return self.reversed()
        }else {
            return self
        }
        
    }
}




