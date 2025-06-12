//
//  SignUpTypes.swift
//  Gofer
//
//  Created by trioangle on 03/12/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

enum SignUpType{
    case email
    case google(id : String)
    case facebook(id : String)
    case apple(id : String,email : String?)
    case notDetermined
}
extension SignUpType {
    var getParamValueForType : [String: Any]{
        
        
        switch self {
        case .email:
            return ["auth_type" : "email"]
        case .google(id: let id):
            return ["auth_type" : "google",
                    "auth_id" : "\(id)"]
        case .facebook(id: let id):
            return ["auth_type" : "facebook",
                    "auth_id" : "\(id)"]
        case .apple(id: let id, email: let email):
            var data : [String : Any] = ["auth_type" : "apple",
                                         "auth_id" : "\(id)"]
            if let _email = email,!_email.isEmpty{
                data["email_id"] = _email
            }
            return data
        default:
            return [:]
        }
        
    }
}
