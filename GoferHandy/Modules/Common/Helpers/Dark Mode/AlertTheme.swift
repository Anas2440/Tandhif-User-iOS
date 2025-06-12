//
//  AlertTheme.swift
//  GoferHandy
//
//  Created by trioangle on 11/02/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit


// Customise The Alerts In handy
enum AlertTheme {
    case Background
    case Title
    case Message
    case ButtonTitle
    case ButtonBackground
    case StatusImage
    
    var font : UIFont {
        switch self {
        case .Title:
            return UIFont(name: G_BoldFont,
                          size: 16) ?? UIFont.systemFont(ofSize: 16)
        case .Message:
            return UIFont(name: G_RegularFont,
                          size: 14) ?? UIFont.systemFont(ofSize: 14)
        case .ButtonTitle:
            return UIFont(name: G_BoldFont,
                          size: 15) ?? UIFont.systemFont(ofSize: 15)
        default:
            return UIFont.systemFont(ofSize: 15)
        }
    }
    
    var color : UIColor {
        switch self {
        case .Background:
            return .SecondaryColor
        case .Title:
            return .SecondaryTextColor
        case .Message:
            return .SecondaryTextColor
        case .ButtonTitle:
            return .PrimaryTextColor
        case .ButtonBackground:
            return .PrimaryColor
        case .StatusImage:
            return .PrimaryColor
        }
    }
}


// Customise The ToastAlerts In handy

enum ToastTheme {
    case Background
    case MessageText
    var color : UIColor {
        switch self {
        case .Background:
            return .PrimaryColor
        case .MessageText:
            return .PrimaryTextColor
        }
    }
    var font : UIFont {
        switch self {
        case .MessageText:
            return UIFont(name: G_BoldFont,
                          size: 15) ?? UIFont.systemFont(ofSize: 15)
        default:
            return UIFont.systemFont(ofSize: 15)
        }
    }
}


enum JobStatusTheme {
    case completed
    case Pending
    case cancelled

    var color : UIColor {
        switch self {
        case .completed:
            return .CompletedStatusColor
        case .cancelled:
            return .CancelledStatusColor
        default:
            return .PendingStatusColor
        }
    }
}
