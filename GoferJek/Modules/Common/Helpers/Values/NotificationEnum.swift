
//
//  NotificationEnum.swift
//  PassUp
//
//  Created by trioangle on 26/02/20.
//  Copyright © 2020 Trioangle Technology. All rights reserved.
//
import UIKit


enum NotificationEnum :String {
    case showViewBasket
    case hideViewBasket
    case updateViewBasket
    case generateNewRequestID
    case noCarsFound
    case completedTripHistory
    case pendingTripHistory
    
    
    
    case newversionApp
    case checkversionApp
    case restaurantInfo
    
    func addObserver(_ observer:Any, selector: Selector){
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func removeObserver(_ observer:Any){
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func postNotification(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func postNotificatinWithData(userInfo:JSON){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil, userInfo: userInfo)
    }
}
