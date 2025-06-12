//
//  AppImages.swift
//  GoferEats
//
//  Created by trioangle on 14/09/19.
//  Copyright © 2019 Balajibabu. All rights reserved.
//

import Foundation
import UIKit


enum AppImage: String,CustomStringConvertible {
  
    
    var description: String {
        return self.rawValue
    }
    
    case checked
//    case location
    case thumbDownNormal = "thumbs_down_normal"
    case orderIcon = "order_icon unselect"
    case accountSettings = "account_setting"
    case supportIcon = "SupportIcon"
    case addPayment = "addPaymentCard"
    case addPromocode = "offer"
    case alert
    case cash = "ic_cash"
    case promoIcon = "promo_icon"
    case promoOffer = "ic_promo_offer"
    case tipsIcon = "ic_tips"
    case card = "credit-card"
    case promoSymbol = "offerSymbl"
    case calendar = "calendar"
    case timer = "load"
    case ic_timer
    case location = "pinOne"
    case navigation
    case home = "homeOnes"
    case work = "workones"
    case clock
    case scheduleOrder
    case door = "Enter"
    case deliveryCar = "del_car"
    case filledNote
    case emptyNote
    case vegImage = "veg_image"
    case Close
    case destinationDot = "dest_dot"
    case driverIcon = "driver_icon"
    case editIcon
    case favSelected = "favSelected"
    case favUnselected = "favUnselected"
    case filterRecommended = "filter_recommended"
    case filterMostPopular = "filter_mostPopular"
    case filterRating = "filter_rating"
    case filterTime = "filter_time"
    case greenDot = "green_dot"
    case minus
    case plus
    case orderIconHD = "order_iconHD"
    case Payment
    case pickUpDot = "pickup_dot"
    case rounded_close_black
    case roundedTick
    case thumbLike
    case thumbUnlike
    case thumbs_down_selected
    case thumbs_up_normal
    case thumbs_up_selected
    case wallerGray = "wallet_grey"
    case like
    case emptyStar = "star0.0"
    case BackButton = "back" 
    case StarNew
    case rightArrow = "ic_right_arrow"
    case phone
    case message
    case vegiterianAddons
    case rounded_close_red
    case roundCancel = "Roundcancel"
    case failure_heart = "no favourites"
    case favwhite
    case unfavwhite
    case check
    case checkem
    case uncheck
    case check1
    case doc1
    case doc2
    case doc3
    case secure
    case security
    case cameraicon
    case eighteenplus
    
}


extension UIImageView {
    
    func addAppImageColor(_ imageName:AppImage,color:UIColor = UIColor.PrimaryColor) {
        if color == .clear {
            self.image = UIImage(named: imageName.description)    
        }else {
            self.image = UIImage(named: imageName.description)?.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }
    }
    
    func addAppImageColorForImage(_ image:UIImage,color:UIColor = UIColor.PrimaryColor) {
        if color == .clear {
            self.image = image
        }else {
            self.image = image.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }
    }
    
    
}


extension UIButton {
    func addAppImageColor(_ imageName:AppImage,color:UIColor = UIColor.PrimaryColor ) {
//        self.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        if color == .clear {
           self.setImage(UIImage(named: imageName.description), for: .normal)
        } else {
            self.setImage(UIImage(named: imageName.description)?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.tintColor = color
        }
        
    }
    
    
     func appThemeBackground(_ color:UIColor = UIColor.PrimaryColor)
    {
        self.backgroundColor = color
        self.setTitleColor(UIColor.SecondaryColor, for: .normal)
    }
}

extension UIView {
    func themeBGColor(_ color:UIColor = UIColor.IndicatorColor)
    {
        self.backgroundColor = color
        self.subviews.forEach { (tempView) in
            if let label = tempView as? UILabel {
                label.textColor = UIColor.SecondaryColor
            }
            if let view = tempView as UIView? {
                view.themeBGColor()
            } 
        }
//        self.setTitleColor(UIColor.SecondaryColor, for: .normal)
    }
}

extension UIViewController {

    func addAppImageColor(_ imageName:AppImage)-> UIImage {
        return (UIImage(named: imageName.description)?.withRenderingMode(.alwaysTemplate))!
       
    }
}
