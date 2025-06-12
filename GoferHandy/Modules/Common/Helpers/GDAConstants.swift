//
//  Constants.swift
//  GoferEats
//
//  Created by trioangle on 25/07/18.
//  Copyright © 2018 Balajibabu. All rights reserved.
//

import UIKit

// MARK: - App Type and App Name For Delivery All
let k_AppType:AppType = AppType.type
let k_AppNameType:AppNameType = .store

enum AppNameType:String {
    case store
}

enum AppType {
    case type
    var instance :String {
        return "store"
    }
    var api :String {
        return self.instance
    }
    
    var upperCase: String {
        return AppType.type.instance.uppercased()
    }
    var captalized :String  {
        return AppType.type.instance.capitalized
    }
    
}

enum AppTypeWord {
    case note
    case search
    case prepare
    case extraNotes
    case cuisine
    
    var instance :String {
        switch self {
        case .search:
            return "dish"
        case .prepare:
            return "order"
        case .extraNotes:
            return " to store"
        case .note:
            return "store"
        case .cuisine:
            return "cuisine"
        }
    }
    
}

enum CustomFont {
    case bold
    case light
    
    var instance:String {
        switch self {
        case .bold:
            return AppTheme.Fontbold(size: 0).fontName
        case .light:
            return AppTheme.Fontlight(size: 0).fontName
        
        }
    }
}


//MARK: SHARED VARIABLE CREATE FOR CHECK IMAGE
enum CheckImage:String {
    case round
    case checkBox
    var instance:[UIImage] {
        switch self {
        case .checkBox:
            return [(UIImage(named: "check_selected")?.withRenderingMode(.alwaysTemplate))!,(UIImage(named: "check_deselected")?.withRenderingMode(.alwaysTemplate))!]
        case .round:
            return [(UIImage(named: "selectedButton")?.withRenderingMode(.alwaysTemplate))!,(UIImage(named: "unSelectedButton")?.withRenderingMode(.alwaysTemplate))!]
        }
    }
}
