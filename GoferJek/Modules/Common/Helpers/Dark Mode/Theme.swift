//
//  Theme.swift
//  GoferHandy
//
//  Created by trioangle on 10/02/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit


/// Theme The Application Using This Enumaration
enum AppTheme {
    /**
     - note : Use For Primary View (Main Theme)
     - warning : Don't provide equal Values to Primary view Color and Primary View Text Color
     */
    case Primary
    /**
     - note : Use For Inactive View
     - warning : Don't provide equal Values to Inactive View Color and Inactive Text Color
     */
    case Secondary
    /**
     - note : Use For Inactive View
     - warning : Don't provide equal Values to Inactive View Color and Inactive Text Color
     */
    case Inactive
    /**
     - note : Use For Background View
     - warning : Don't provide equal Values to Inactive View Color and Inactive Text Color
     */
    case Background
    /**
     - note : Use For Error Text
     */
    case Error
    case Icon
    // Fonts
    /**
     - note : Use For Paragraph and Normal Text Font
     */
    case Fontlight(size : CGFloat)
    case Fontmedium(size : CGFloat)
    case Fontbold(size : CGFloat)
    
    /**
     - note :  For font
     */
    var font : UIFont {
        switch self {
        case .Fontlight(let size):
            return UIFont(name: G_RegularFont,
                          size: size) ?? UIFont.systemFont(ofSize: size)
        case .Fontmedium(let size):
            return UIFont(name: G_MediumFont,
                          size: size) ?? UIFont.systemFont(ofSize: size)
        case .Fontbold(let size):
            return UIFont(name: G_BoldFont,
                          size: size) ?? UIFont.systemFont(ofSize: size)
        default:
            return UIFont.systemFont(ofSize: 20)
        }
    }
    var fontName : String {
        switch self {
        case .Fontlight(_):
            return "ClanPro-Book"
        case .Fontmedium(_):
            return "ClanPro-News"
        case .Fontbold(_):
            return "ClanPro-Medium"
        default:
            return ""
        }
    }
}

