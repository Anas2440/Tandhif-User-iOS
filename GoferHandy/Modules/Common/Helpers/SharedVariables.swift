//
//  SharedVariables.swift
//  GoferEats
//
//  Created by trioangle on 28/07/18.
//  Copyright © 2018 Balajibabu. All rights reserved.
//

import UIKit
import CoreLocation

class SharedVariables: NSObject {
    
    static let sharedInstance = SharedVariables()
    
    var eatsInt: Int = 1
    var isGoferEats: Bool = false
    var userDetails  = [String:Any]()
    var userToken = String()
    var isLogin:Bool = false
    //var availablePaymentOptions : PaymentDataHolder?
    var shouldShowWallet : Bool = false
    var menuItemDetailFromPlaceOrder : Bool = false
    var selectedLocation:MyLocationModel?
    var isSort = Bool()
    
    // Delivery Split Start
    
    // Handy Split End
    
    var selectedIndexPathArrayString = [String]()
    var selectedPriceArray = [String]()
    var iscartItem = Bool()
    var cardDetailsDict = [String:Any]()
    var isCashSelected = Bool()
    var searchKeywordsArray = [String]()
    var isFilter:Bool = false
    var selectedReasonDict = [Int:Any]()
    var deviceID = String()
    var isNotificationForPast = Bool()
    var currencySymbol = String()
    var cuisineType = String()
    var scrollViewHeight = CGFloat()
    var isHomeLoaded = false
    var isDeviceIDUpdated = false
    var callStore = Bool()
    var storeName = String()
    var driverName = String()
    
    enum PushnotificationRedirection
    {
        case upcomingorder
        case pastorder
        case none
    }
    
    
    var user_id = String()
    
    var isWebPayment = false
    
    var is_18_Plus_Approved = false
    
    func getUserID()->String
    {
        
        let checkData = UserDefaults.standard.data(forKey: "user_data")
        
        var uid = ""
        guard checkData != nil else { return uid }
        
        let data = KeyedUnarchiver.unarchiveObject(with: checkData!)
        print("◉ UserDefault Value",data!)
        
        if let result = data as? JSON
        {
            uid = result.string("id")
            print("◉ U_ID \(uid)")
        }
        
        return uid
    }
    
    
    var PushRedirection : PushnotificationRedirection = .none
   
    

  
    var isProfilePage = Bool()
    
    var oldUserName = String()
    var oldUserImageUrl = String()
    var oldWalletAmount = String()
    var sharedPastOrderDictArray = [[String:Any]]()
    var sharedUpcomingOrderDictArray = [[String:Any]]()
    
    
    
    //MARK: Without login
    
    var restaurantNameWithoutLogin = String()
    var restaurantOpenTimeWithoutLogin = String()
    
    
    var isNonUser = Bool()
    var isNonUserAddCustomised = Bool()
    var nonUserLocationsForSaveLocation = [String:Any]()
    var selectedIndexForWithoutLogin :Int?

}

