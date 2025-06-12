//
//  InfoPlistKeys.swift
//  GoferHandy
//
//  Created by trioangle on 27/01/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

enum InfoPlistKeys : String{
    case Google_API_keys
    case Google_Places_keys
    case App_URL
    case RedirectionLink_user
    case iTunesData_user
    case iTunesData_provider
    case ThemeColors
    case ReleaseVersion
    case UserType
}
extension InfoPlistKeys : PlistKeys{
    var key: String{
        return self.rawValue
    }
    
    static var fileName: String {
        return "Info"
    }
    
    
}
