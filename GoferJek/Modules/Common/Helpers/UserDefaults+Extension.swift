////
////  UserDefaults+Extension.swift
////  BoilerPlate
////
////  Created by trioangle on 23/12/19.
////  Copyright © 2019 trioangle. All rights reserved.
////
//
import Foundation
//
//struct Defaults {
//    
//    static let kLanguage = "Lang"
//    static let kDeviceToken = "deviceToken"
//    static let kAppleLanguages = "AppleLanguages"
//    static let kLanguageList = "LanguageList"
//    static let kdefaultLang = "defaultLang"
//}
//
//
//
//extension UserDefaults {
//    
//    enum Key : String {
//        
//        case device_token
//        case selectedLanguage
//        case language
//        case direction_hit_count
//    }
//    
//    
//    
//    internal static var prefernce : UserDefaults{ return UserDefaults.standard}
//    
//    static func value<T>(for key : Key) -> T?{
//        return self.prefernce.value(forKey: key.rawValue) as? T
//    }
//    
//    
//    static func set<T>(_ value : T,for key : Key){
//        self.prefernce.set(value, forKey: key.rawValue)
//    }
//    
//    
//    static func removeValue(for key : Key){
//        self.prefernce.removeObject(forKey: key.rawValue)
//    }
//    
//    static func isNull(for key : Key) -> Bool{
//        return self.prefernce.value(forKey: key.rawValue) == nil
//    }
//
//    static func clearAllKeyValues(){
//        
//        self.removeValue(for: .device_token)
//
//    }
//    
//    // MARK:- Language
//        
//    var language: String{
//        get{
//            guard let languageCode = self.value(forKey: Defaults.kLanguage) as? String else {
//                return "en"
//            }
//            return languageCode
//        }
//        set{
//            self.set(newValue, forKey: Defaults.kLanguage)
//            self.synchronize()
//            k = LanguageStrings()
//        }
//    }
//    
//    var defaultLang: String{
//        get{
//            guard let lang = self.value(forKey: Defaults.kdefaultLang) as? String else {
//                return "English"
//            }
//            return lang
//        }
//        set{
//            self.set(newValue, forKey: Defaults.kdefaultLang)
//            self.synchronize()
//        }
//    }
//    
//    var preferedLanguages:[String]{
//        get{
//            guard let languages = self.value(forKey: Defaults.kLanguageList) as? [String] else {
//                return k_LanguageCodeArray
//            }
//            return languages
//        }
//        set{
//            self.set(newValue, forKey: Defaults.kLanguageList)
//            self.synchronize()
//        }
//    }
//    
//    // MARK:- Save Details
//    
//    func saveUserDetails(userDetails: UserDetails) {
//        
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(userDetails) {
//            self.set(encoded, forKey: k_UDUserDetails)
//            self.set(true, forKey: k_UDisLoggedIn)
//            SharedVariables.shared.userDetails = userDetails
//            SharedVariables.shared.token = userDetails.accessToken
//            APIManager.shared.updateLanguage { (result) in
//                print(result)
//            }
//            self.synchronize()
//        }
//    }
//    
//    // MARK:- Get Details
//    
//    func getUserDetails() -> UserDetails? {
//        
//        if let userDetailData = self.object(forKey: k_UDUserDetails) as? Data {
//            let decoder = JSONDecoder()
//            if let userDetails = try? decoder.decode(UserDetails.self, from: userDetailData) {
//                return userDetails
//            }
//            return nil
//        }
//        return nil
//    }
//    
//    
//}
//
//
//    
