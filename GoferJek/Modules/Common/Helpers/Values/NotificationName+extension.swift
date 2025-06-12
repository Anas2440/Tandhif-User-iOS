//
//  NotificationName+extension.swift
//  Gofer
//
//  Created by trioangle on 24/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

extension Notification.Name{
    // Appdelegate //NotificationName+extension.swift  // extension Notification.Name file //MainMapView //DriverProfileVC //CancelRideVC
    static let tripEnded =  NSNotification.Name(rawValue: "EndTrip")
    
    static let arriveBeignTrip =  NSNotification.Name(rawValue: "ArrivedNowOrBeginTrip")
    static let arriveBeignTrips =  NSNotification.Name(rawValue: "ArrivedNowOrBeginTrips")
    static let cancelTrips =  NSNotification.Name(rawValue: "cancel_trips")
    static let goToHomePage1 =  NSNotification.Name(rawValue: "GotoHomePage1")
    
   //Appdelegate //MakeRequestVC.swift // viewDidLoad // Lines 86 & 88 & 342
    static let requestAccepted =  NSNotification.Name(rawValue: "RequestAccepted")
    static let noCars =  NSNotification.Name(rawValue: "no_cars")
    static let getDriverDetails =  NSNotification.Name(rawValue: "GetDriverDetails")
   
     //Appdelegate //ChatVC.swift // func initGesture() // Lines 238
        
     static let cancel_Trip =  NSNotification.Name(rawValue: "cancel_trip")
       //MakePaymentVC.swift //func addListeneners() // Lines 220
     
       static let tripPayment =  NSNotification.Name(rawValue: "trip_payment")
       //MainMapView.swift // func initNotificaiton() //Lines  163 - 170 & 180 & 195 & // RouteVC - Lines - 499
      static let showHomePage =  NSNotification.Name(rawValue: "ShowHomePage")
      static let trip_payments =  NSNotification.Name(rawValue: "trip_payments")
       
       //EditProfileVC.swift //viewDidLoad //  func verifyToAPI  //extension EditProfileVC //Lines 108 , 269, 617
       static let phonenochanged =  NSNotification.Name(rawValue: "phonenochanged")

       //DriverProfileVC //func initNotificationObservers() // Lines 99
     static let gotoHomePage =  NSNotification.Name(rawValue: "GotoHomePage")
    
    //MARK:- HandyMan
    static let HandyShowAlertForJobStatusChange = Notification.Name(rawValue: "HandyShowAlertForJobStatusChange")
    static let HandyJobRequestAccepted = Notification.Name(rawValue: "HandyJobRequestAccepted")
    static let HandyProviderArrived = Notification.Name(rawValue: "HandyProviderArrived")
    static let HandyRequestCancelledByProvider = Notification.Name(rawValue: "HandyRequestCancelledByProvider")
    static let HandyProviderBegunJob = Notification.Name(rawValue: "HandyProviderBegunJob")
    static let HandyProviderEndedJob = Notification.Name(rawValue: "HandyProviderEndedJob")
    static let HandyMoveToJobHistory = Notification.Name(rawValue: "HandyMoveToJobHistory")
    static let HandyCashCollectedByProvider = Notification.Name(rawValue: "HandyCashCollectedByProvider")
    static let HandyJobCancelledByProvider = Notification.Name(rawValue: "HandyJobCancelledByProvider")
    static let RefreshIncompleteTrips = NSNotification.Name(rawValue: "RefreshInCompleteTrips")
    static let moveUpcoming = NSNotification.Name(rawValue: "MoveUpcoming")
    static let ThemeRefresher = Notification.Name(rawValue: "ThemeRefresher")
    
    //MARK:- Delivery
    static let DeliveryShowAlertForJobStatusChange = Notification.Name(rawValue: "DeliveryShowAlertForJobStatusChange")
    static let DeliveryRequestAccepted = Notification.Name(rawValue: "DeliveryRequestAccepted")
    static let DeliveryProviderArrived = Notification.Name(rawValue: "DeliveryProviderArrived")
    static let DeliveryRequestCancelledByProvider = Notification.Name(rawValue: "DeliveryRequestCancelledByProvider")
    static let DeliveryProviderBegunJob = Notification.Name(rawValue: "DeliveryProviderBegunJob")
    static let DeliveryProviderEndedJob = Notification.Name(rawValue: "DeliveryProviderEndedJob")
    static let DeliveryMoveToJobHistory = Notification.Name(rawValue: "DeliveryMoveToJobHistory")
    static let DeliveryCashCollectedByProvider = Notification.Name(rawValue: "DeliveryCashCollectedByProvider")
    static let DeliveryJobCancelledByProvider = Notification.Name(rawValue: "DeliveryJobCancelledByProvider")
    static let DeliveryReceipientEnd = Notification.Name(rawValue: "DeliveryReceipientEnd")
    
    
    // DeliveryAll
    
    static let RefreshPastOrder = Notification.Name(rawValue: "RefreshPastOrder")
    static let ChatRefresh = Notification.Name("ChatRefresh")
}
