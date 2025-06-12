//
//  PushNotificationManager.swift
//  Gofer
//
//  Created by Apple on 03/06/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//


import Foundation
import Firebase
//import FirebaseInstanceID
import FirebaseMessaging
import UIKit
import UserNotifications
import AVFoundation

import FirebaseCore
import FirebaseDatabase

enum NotificationTypeEnum: String , CaseIterable{
    
    
    case EndTrip
    case ArrivedNowOrBeginTrip
    case ArrivedNowOrBeginTrips
    case cancel_trips
    case GotoHomePage1
    case RequestAccepted
    case no_cars
    case GetDriverDetails
    
    case cancel_trip
    case trip_payment
    case ShowHomePage
    case trip_payments
    case phonenochanged
    case GotoHomePage
    
    case accept_request
    case chat_notification
    case job_payment
    case arrivenow
    case begintrip
    case end_trip
    case arrive_now
    case custom_message
    case custom
    case sin
    case begin_trip
    case none
    case job_request_detail
    
    //MARK:- handyman
    //    case accept_request
    //    case arrive_now
    case begin_job
    case end_job
    case cancel_Job
    case cancel_request
    
    
    //    MARK: Delivery
    case user_cancel_request
    case cancel_schedule_job
    case accept_request_delivery
    case end_recipient
    
    case KilledStateNotification
    case RefreshInCompleteTrips
    
    //DeliveryAll
    
    case order_delivery_completed
    case order_cancelled
    case order_accepted
    case order_delivery_started
    case order_ready
    case order_picked
    
    
    
    
    
    
    
    
    init?(fromKeys keys: [String]){
        let cases = NotificationTypeEnum.allCases.compactMap({$0.rawValue})
        guard let key = Array(Set(cases).intersection(Set(keys))).first,
              let enumValue = NotificationTypeEnum(rawValue: key) else{
            return nil
        }
        self = enumValue
        
    }
}


class PushNotificationManager: NSObject,MessagingDelegate{
    //MARK: Remote Notification
    //    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
    //        print(remoteMessage.appData)
    //    }
    //
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken Users=============>", fcmToken ?? "")
        let refreshedToken = fcmToken
        print("Remote instance ID token: \(String(describing: refreshedToken))")
        print("InstanceID token: \(String(describing: refreshedToken))")
        Constants().STOREVALUE(value: refreshedToken ?? "", keyname: "device_token")
        if  !(refreshedToken?.isEmpty ?? true) {
            AppDelegate.shared.sendDeviceTokenToServer(strToken: refreshedToken ?? "")   // UPDATING DEVICE TOKEN FOR LOGGED IN USER
        } else {
            self.tokenRefreshNotification()
        }
    }
    
    var application:UIApplication
    let messaging : Messaging
    static var shared : PushNotificationManager?
    var notificationType:NotificationTypeEnum = .none
    var receivedNotificationIDs = [Int]()
    var receivedLocalNotificationIDs = [Int]()
    var window: UIWindow? {
        
        return AppDelegate.shared.window
    }
    fileprivate var firebaseReference : DatabaseReference? = nil
    fileprivate var jobReference : DatabaseReference? = nil

    init(_ application:UIApplication) {
        
        self.application = application
        
        self.messaging = Messaging.messaging()
        
        super.init()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
//        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Self.shared = self
        
    }
    
    
    // MARK: Register Push notification Class Methods
    func registerForRemoteNotification() {
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // MARK: Get Token Refersh
    func tokenRefreshNotification() {
        // NOTE: It can be nil here
        //        InstanceID.instanceID().instanceID { (result, error) in
        //            if let error = error {
        //                print("Error fetching remote instange ID: \(error)")
        //            } else if let result = result {
        //                let refreshedToken = result.token
        //                print("Remote instance ID token: \(refreshedToken)")
        //                print("InstanceID token: \(String(describing: refreshedToken))")
        //                Constants().STOREVALUE(value: refreshedToken, keyname: "device_token")
        //                if  !refreshedToken.isEmpty {
        //                    AppDelegate.shared.sendDeviceTokenToServer(strToken: refreshedToken)   // UPDATING DEVICE TOKEN FOR LOGGED IN USER
        //                }
        //                else{
        //                    self.tokenRefreshNotification()
        //                }
        //                self.connectToFcm()
        //            }
        //        }
        
    }
    // Get FCM Token
    func connectToFcm() {
        //
        //        InstanceID.instanceID().instanceID { (result, error) in
        //            if let error = error {
        //                print("Error fetching remote instange ID: \(error)")
        //                return
        //            } else if let result = result {
        //                print("Remote instance ID token: \(result.token)")
        //            }
        //        }
        //        if Messaging.messaging().isDirectChannelEstablished{
        //            print("Connected to FCM.")
        //        } else {
        //            print("Disconnected from FCM.")
        //        }
        //
    }
    func getDeviceID(deviceToken: Data){
        
    }
    
    
    func onFetchToken(_ onFetch : @escaping (String?)->Void) {
        
        //        InstanceID.instanceID().instanceID { (result, error) in
        //            if let error = error {
        //                print("Error fetching remote instange ID: \(error)")
        //                return
        //            } else if let result = result {
        //                onFetch(result.token)
        //                print("Remote instance ID token: \(result.token)")
        //            }
        //        }
        //        FIRInstanceID.FIRInstanceID ().instanceID { (result, error) in
        //            if let error = error {
        //                print("Error fetching remote instance ID: \(error)")
        //            } else if let result = result {
        //                print("Remote instance ID token: \(result.token)")
        //
        //            }
        //        }
    }
    
    
}

extension PushNotificationManager : UNUserNotificationCenterDelegate {
    // MARK: Converted a String to dictionary format
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    // MARK: UNUserNotificationCenter Delegate // >= iOS 10
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //sinch
        let dict = notification.request.content.userInfo as NSDictionary
        if dict["sin"] != nil {
            debug(print: dict.description)
            completionHandler([])
            return
        }
        //    if let uniqId = dict.value(forKey: "UUID") as? String,
        //        uniqId == "CURRENT_CHAT_TRIP_ID"{
//        if notification.request.identifier == "Chat Notification" {
//            if Shared.instance.chatVcisActive{
//                completionHandler([])
//            }else{
//                completionHandler([.alert,.sound])
////                    completionHandler([])
//            }
//            return
//        }
        
        let custom = dict[NotificationTypeEnum.custom.rawValue] as Any
        let data = convertStringToDictionary(text: custom as? String ?? String())
        let keys = data?.compactMap({$0.key}) ?? []
        if keys.contains(NotificationTypeEnum.accept_request.rawValue){
            completionHandler([])
        } // Gofer Splitup Start
        else if keys.contains(NotificationTypeEnum.job_request_detail.rawValue){
            completionHandler([])
        }// Gofer Splitup end
        else if keys.contains(NotificationTypeEnum.accept_request_delivery.rawValue){
            completionHandler([])
        }
        else if keys.contains(NotificationTypeEnum.custom_message.rawValue){
            //Admin custom_message
            completionHandler([.alert,.sound])
            return
        }else if keys.contains(NotificationTypeEnum.chat_notification.rawValue){
            //chat notification
            let subJSON = data?[NotificationTypeEnum.chat_notification.rawValue] as? JSON ?? JSON()
            
            if Shared.instance.chatVcisActive{
                if subJSON.string("job_id") == ChatVC.currentTripID{
                    completionHandler([])
                }else{
                    completionHandler([.alert,.sound])
                    //                completionHandler([])
                }
            }else{
                completionHandler([.alert,.sound])
                //            completionHandler([])
            }
            return
        }else if keys.contains(NotificationTypeEnum.order_delivery_completed.rawValue) || keys.contains(NotificationTypeEnum.order_cancelled.rawValue) || keys.contains(NotificationTypeEnum.order_accepted.rawValue) ||
            keys.contains(NotificationTypeEnum.order_delivery_started.rawValue) ||
            keys.contains(NotificationTypeEnum.order_ready.rawValue){
            
            completionHandler([.alert,.sound])
            
        }else{
            completionHandler([.sound])
        }
        
        
        
            
        
        
        guard let dictionary = data as NSDictionary? else{return}
        ///seperating based on buisness type
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            switch AppWebConstants.businessType{
//            case .Services:
//                self.handleHandyPushNotifications(userInfo: dictionary as! JSON)
//            case .Delivery:
//                self.handleHandyPushNotifications(userInfo: dictionary as! JSON)
//            case .Ride:
//                self.handleGoferPushNotifications(userInfo: dictionary)
//            case .DeliveryAll:
//                self.handleDeliveryAllPushNotifications(userInfo: dictionary as! JSON)
//            default : break
//
//            }
//        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.handleHandyPushNotifications(userInfo: dictionary as! JSON, isFrom: "willPresent")
//            switch AppWebConstants.businessType{
//            case .Services:
//                self.handleHandyPushNotifications(userInfo: dictionary as! JSON)
//            case .Delivery:
//                self.handleHandyPushNotifications(userInfo: dictionary as! JSON)
//            case .Ride:
//                self.handleGoferPushNotifications(userInfo: dictionary)
//            case .DeliveryAll:
//                self.handleDeliveryAllPushNotifications(userInfo: dictionary as! JSON, isFrom: "willPresent")
//            default : break
//
//            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo as NSDictionary
        
        //sinch
        if dict[NotificationTypeEnum.sin.rawValue] != nil{
            CallManager.instance.didReceivePush(notification: response.notification.request.content.userInfo)
            return
        }
        
//        if response.notification.request.identifier == "Chat Notification" {
//
//            let isGofer = AppWebConstants.businessType == BusinessType.Ride
//            let tripId : Int = (isGofer
//                                ? UserDefaults.standard.value(forKey: "MSG_ID") as? Int
//                                    : UserDefaults.value(for: .current_job_id)) ?? 0
//
//            if tripId.description != ChatVC.currentTripID{
//                let json = dict[NotificationTypeEnum.chat_notification.rawValue] as? JSON
//                let driverID : Int = json?.int(""user_id"") ?? UserDefaults.value(for: .driver_"user_id") ?? 0
//                let driverRating : Double? = json?.double("rating")
//                let typeOfConversation = json?.string("type_of_conversation") ?? "user_to_driver"
//                let chatVC = ChatVC.initWithStory(withTripId: json?.string(isGofer ? "trip_id" : "job_id") ?? tripId.description,
//                                                  driverRating: driverRating,
//                                                  driver_id: driverID,
//                                                  imageURL: json?.string("user_image"),
//                                                  name: json?.string("user_name"), typeCon: ConversationType(rawValue: typeOfConversation) ?? .u2d)
//                if let nav = self.window?.rootViewController as? UINavigationController{
//                    nav.pushViewController(chatVC, animated: true)
//                }else if let root = self.window?.rootViewController{
//                    root.navigationController?.pushViewController(chatVC, animated: true)
//                }
//            }
//            return
//        }
        let custom = dict[NotificationTypeEnum.custom.rawValue] as Any
        let data = convertStringToDictionary(text: custom as? String ?? String())
        let dictionary = data! as NSDictionary
        self.handleCommonPushNotification(userInfo: dictionary as! JSON,generateLocalNotification: false)
        self.handleHandyPushNotifications(userInfo: dictionary as! JSON, isFrom: "didReceive")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            switch AppWebConstants.businessType{
//            case .Services:
//                self.handleHandyPushNotifications(userInfo: dictionary as! JSON)
//            case .Delivery:
//                self.handleHandyPushNotifications(userInfo: dictionary as! JSON)
//            case .Ride:
//                self.handleGoferPushNotifications(userInfo: dictionary)
//            default : break
//
//            }
//        }
        
        completionHandler()
        
    }
    
    //MARK: HANDLE PUSH NOTIFICATION
    
    func canIHandleThisNotification(userInfo : JSON)-> Bool{
        print("ð Last Notification ID : \(String(describing: self.receivedNotificationIDs))")
        let notificationID = userInfo.int("id")
        print("ð New Notification ID : \(notificationID)")
        guard !self.receivedNotificationIDs.contains(notificationID) else{
            print("Notification \(notificationID) already handled")
            return false
        }
        self.receivedNotificationIDs.append(notificationID)
        return true
    }
    func canIHandleThisLocalNotification(userInfo : JSON)-> Bool{
        print("ð Last Notification ID : \(String(describing: self.receivedLocalNotificationIDs))")
        let notificationID = userInfo.int("id")
        print("ð New Notification ID : \(notificationID)")
        guard !self.receivedLocalNotificationIDs.contains(notificationID) else{
            print("Notification \(notificationID) already handled")
            return false
        }
        self.receivedLocalNotificationIDs.append(notificationID)
        return true
    }
    func handleGoferPushNotifications(userInfo: NSDictionary)
    {
        guard self.canIHandleThisNotification(userInfo: userInfo as! JSON) else{return}
        
        let preference = UserDefaults.standard
        print("notification data",userInfo)
        if userInfo[NotificationTypeEnum.accept_request.rawValue] != nil
        {
            
            /*
             * 2.3
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.onSetRootViewController(viewCtrl: nil)
             */
            NotificationCenter.default.post(name: .RefreshIncompleteTrips, object: nil)
            
            return
            
        }
        else if userInfo[NotificationTypeEnum.arrive_now.rawValue] != nil
        {
            
            let dictTemp = userInfo[NotificationTypeEnum.arrive_now.rawValue] as! NSDictionary
            let info: [AnyHashable: Any] = [
                "trip_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"trip_id"),
                "type" : NotificationTypeEnum.arrivenow.rawValue,
            ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.ArrivedNowOrBeginTrip.rawValue), object: self, userInfo: info)
        }
        else if userInfo[NotificationTypeEnum.begin_trip.rawValue] != nil
        {
            let dictTemp = userInfo[NotificationTypeEnum.begin_trip.rawValue] as! NSDictionary
            let info: [AnyHashable: Any] = [
                "type" : NotificationTypeEnum.begintrip,
                "trip_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"trip_id"),
            ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.ArrivedNowOrBeginTrips.rawValue), object: self, userInfo: info)
        }
        else if userInfo[NotificationTypeEnum.end_trip.rawValue] != nil
        {
            let dictTemp = userInfo[NotificationTypeEnum.end_trip.rawValue] as! NSDictionary
            let info: [AnyHashable: Any] = [
                "driver_thumb_image" : UberSupport().checkParamTypes(params:dictTemp, keys:"driver_thumb_image"),
                "trip_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"trip_id"),
            ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationTypeEnum.EndTrip.rawValue), object: self, userInfo: info)
            preference.removeObject(forKey: "trip_driver_rating")
            preference.removeObject(forKey: "trip_driver_name")
            preference.removeObject(forKey: "trip_driver_thumb_url")
        } else if userInfo[NotificationTypeEnum.no_cars.rawValue] != nil {
            _ = userInfo[NotificationTypeEnum.no_cars.rawValue] as! NSDictionary
            print("No Cars Available",userInfo)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.no_cars.rawValue),
                                            object: self,
                                            userInfo: nil)
        } else if userInfo[NotificationTypeEnum.cancel_trip.rawValue] != nil {
            print("cancel_trip data",userInfo)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.cancel_trip.rawValue), object: self, userInfo: nil)
            preference.removeObject(forKey: "trip_driver_rating")
            preference.removeObject(forKey: "trip_driver_name")
            preference.removeObject(forKey: "trip_driver_thumb_url")
        }
        
        else if userInfo[NotificationTypeEnum.trip_payment.rawValue] != nil
        {
            if let paymentData = userInfo[NotificationTypeEnum.trip_payment.rawValue] as? JSON{
                PipeLine.fireDataEvent(withName: NotificationTypeEnum.trip_payment.rawValue, data: paymentData)
                
                paymentData.string("driver_thumb_image")
                //status
                //trip_id
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trip_payment"), object: self, userInfo: nil)
                print("Cash Collected",userInfo)
            }
            
        }
        
    }
    /**
     handles only chat notifcaition
     - warning: Dont use this method inside firebase listener
     */
    func handleCommonPushNotification(userInfo: JSON,
                                      generateLocalNotification: Bool){
        
        guard userInfo[NotificationTypeEnum.chat_notification.rawValue] != nil else{return}
        // Handy Splitup Start
        let isGofer = AppWebConstants.businessType == BusinessType.Ride
        let valueJSON = userInfo[NotificationTypeEnum.chat_notification.rawValue]
        
        var tripId : Int = (isGofer
                            ? UserDefaults.standard.value(forKey: "MSG_ID") as? Int
                            : UserDefaults.value(for: .current_job_id)) ?? 0
        if  let jobID = (valueJSON as? JSON)?.int("job_id") {
            tripId = jobID
        }else {
            tripId = (isGofer ? UserDefaults.value(for: .current_trip_id) : UserDefaults.value(for: .current_job_id)) ?? 0
        }
        // Handy Splitup End
        if tripId.description != ChatVC.currentTripID {
            if generateLocalNotification {
                guard self.canIHandleThisNotification(userInfo: userInfo) else {return}
                guard self.canIHandleThisLocalNotification(userInfo: userInfo) else{return}
                
                let message = UberSupport().checkParamTypes(params:valueJSON as! NSDictionary, keys:"message_data")
                let title =  UberSupport().checkParamTypes(params:valueJSON as! NSDictionary, keys:"user_name")
                appDelegate.scheduleNotification(title: title as String, message: message as String)
            } else {
                let json = userInfo[NotificationTypeEnum.chat_notification.rawValue] as? JSON
                let driverID : Int = json?.int("user_id") ?? UserDefaults.value(for: .driver_user_id) ?? 0
                let driverRating : Double? = json?.double("rating")
                let typeOfConversation = json?.string("type_of_conversation") ?? "user_to_driver"
                let chatVC = ChatVC.initWithStory(withTripId: json?.string( "job_id") ?? tripId.description,
                                                  driverRating: driverRating,
                                                  driver_id: driverID,
                                                  imageURL: json?.string("user_image"),
                                                  name: json?.string("user_name"),
                                                  typeCon: ConversationType(rawValue: typeOfConversation) ?? .u2d)
                if let nav = self.window?.rootViewController as? UINavigationController{
                    nav.pushViewController(chatVC, animated: true)
                } else if let root = self.window?.rootViewController {
                    root.navigationController?.pushViewController(chatVC, animated: true)
                }
            }
            
        } else if userInfo[NotificationTypeEnum.custom_message.rawValue] != nil {
            print("custom_message",
                  userInfo)
        }
    }
    
//    func handleDeliveryAllPushNotifications(userInfo : JSON, isFrom:String){
//        if isFrom != "didReceive"{
//        guard self.canIHandleThisNotification(userInfo: userInfo) else{return}
//        }
//
//        guard let notification = NotificationTypeEnum(fromKeys: userInfo.compactMap({$0.key})) else{return}
//        let valueJSON = userInfo.json(notification.rawValue)
//        print(valueJSON)
//        print(notification)
//        let _ = userInfo.string("title")
//        switch notification{
//        case  .order_delivery_completed,.order_cancelled:
//           // moveTabToPast()
//        case .order_accepted,.order_delivery_started,.order_ready:
//           // moveTabToUpComing()
//        default:
//            break
//        }
//    }
//    func moveTabToUpComing(){
//        NotificationEnum.completedTripHistory.postNotification()
//    }
    func moveTabToPastandUpcoming(type:Tabs){
        //NotificationEnum.pendingTripHistory.postNotification()
        // Handy Splitup Start
        AppWebConstants.businessType = .DeliveryAll
        // Handy Splitup End
        let tripVC : HandyTripHistoryVC = HandyTripHistoryVC.initWithStory()
        tripVC.newTap = type
        if !self.topMostViewController().isKind(of: HandyTripHistoryVC.self) {
            if let nav = self.window?.rootViewController as? UINavigationController{
                nav.pushViewController(tripVC, animated: true)
            } else if let root = self.window?.rootViewController {
                root.navigationController?.pushViewController(tripVC, animated: true)
            }
        }
    }
    
    func handleHandyPushNotifications(userInfo : JSON,
                                      isFrom:String){
        if isFrom != "didReceive"{
        guard self.canIHandleThisNotification(userInfo: userInfo) else{return}
        }
        
        guard let notification = NotificationTypeEnum(fromKeys: userInfo.compactMap({$0.key})) else{return}
        let valueJSON = userInfo.json(notification.rawValue)
        print(valueJSON)
        print("Notification Name: " + notification.rawValue)
        let notificationTitle = userInfo.string("title")
        switch notification{
        case .accept_request:
        // Gofer Splitup Start
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                let jobID = valueJSON.int("delivery_id")
                UserDefaults.set(jobID, for: .current_delivery_id)
                NotificationCenter.default.post(name: .DeliveryRequestAccepted, object: jobID)
            case .Ride:
            // Gofer Splitup end
                NotificationCenter.default.post(name: .RefreshIncompleteTrips, object: valueJSON.int("job_id"))
                // Gofer Splitup Start
            default:
                // Handy Splitup End
                let jobID = valueJSON.int("job_id")
                UserDefaults.set(jobID, for: .current_job_id)
                NotificationCenter.default.post(name: .HandyJobRequestAccepted, object: jobID)
                // Handy Splitup Start
            }
            // Gofer Splitup Start
            // Handy Splitup End
        case .accept_request_delivery:
            let jobID = valueJSON.int("delivery_id")
            UserDefaults.set(jobID, for: .current_delivery_id)
            startObservingUser()
        case .cancel_request:
            var requestID = Int()
            // Gofer Splitup Start
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            default:
                // Handy Splitup End
                requestID = valueJSON.int("request_id")
                //#Gofer Handy
                _ = valueJSON.string("job_progress_status")
                // Delivery Splitup Start
                if requestID == HandyRequestVC.requestID {
                    NotificationCenter.default.post(name: .HandyRequestCancelledByProvider, object: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationCenter.default
                            .post(name: .HandyShowAlertForJobStatusChange,
                                  object: notificationTitle,
                                  userInfo: ["request_id":requestID,
                                             "reason":NotificationTypeEnum.cancel_request])
                    }
                    
                }else // Delivery Splitup End // Services Splitup Start // Handy Splitup Start
                {
                    NotificationCenter.default.post(name: .DeliveryRequestCancelledByProvider, object: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationCenter.default
                            .post(name: .DeliveryShowAlertForJobStatusChange,
                                  object: notificationTitle,
                                  userInfo: ["request_id":requestID,"reason":NotificationTypeEnum.cancel_request])
                    }
                }
                // Gofer Splitup end
              
            }
            // Handy Splitup End
        case .arrive_now:
            var jobID = Int()
            var status = String()
            jobID = valueJSON.int("job_id")
            status = valueJSON.string("job_progress_status")
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .DeliveryProviderArrived, object: nil)
                }
                NotificationCenter.default
                    .post(name: .DeliveryShowAlertForJobStatusChange,
                          object: status == "" ? notificationTitle : status ,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.arrive_now])
            case .Ride:
                let dictTemp = userInfo[NotificationTypeEnum.arrive_now.rawValue] as! NSDictionary
                let info: [AnyHashable: Any] = [
//                    "trip_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"trip_id"),
                    "job_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"job_id"),
                    "type" : NotificationTypeEnum.arrivenow.rawValue,
                ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.ArrivedNowOrBeginTrip.rawValue), object: self, userInfo: info)
            default:
                // Handy Splitup End
                if let currentJob : Int = UserDefaults.value(for: .current_job_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .HandyProviderArrived, object: nil)
                }
                NotificationCenter.default
                    .post(name: .HandyShowAlertForJobStatusChange,
                          object: status == "" ? notificationTitle : status ,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.arrive_now])
                // Handy Splitup Start
            }
            // Handy Splitup End
            NotificationEnum.completedTripHistory.postNotification()
        case .begin_job:
            var jobID = Int()
            var status = String()
            jobID = valueJSON.int("job_id")
            status = valueJSON.string("job_progress_status")
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .DeliveryProviderBegunJob, object: nil)
                }
                NotificationCenter.default
                    .post(name: .DeliveryShowAlertForJobStatusChange,
                          object: status == "" ? notificationTitle : status,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.begin_job])
            case .Ride:
                let dictTemp = valueJSON.int("job_id")
                let info: [AnyHashable: Any] = [
                    "type" : NotificationTypeEnum.begintrip,
                    "trip_id" : dictTemp,
                ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.ArrivedNowOrBeginTrips.rawValue), object: self, userInfo: info)
            default:
                // Handy Splitup End
                if let currentJob : Int = UserDefaults.value(for: .current_job_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .HandyProviderBegunJob, object: nil)
                }
                NotificationCenter.default
                    .post(name: .HandyShowAlertForJobStatusChange,
                          object: status == "" ? notificationTitle : status,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.begin_job])
                // Handy Splitup Start
            }
            // Handy Splitup End
            NotificationEnum.completedTripHistory.postNotification()
        case .end_recipient:
            var jobID = Int()
            var status = String()
            jobID = valueJSON.int("job_id")
            status = valueJSON.string("job_progress_status")
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob {
                    NotificationCenter.default.post(name: .DeliveryReceipientEnd,
                                                    object: nil,
                                                    userInfo: valueJSON)
                }
                NotificationCenter.default
                    .post(name: .DeliveryShowAlertForJobStatusChange,
                          object: status == "" ? notificationTitle : status,
                          userInfo: ["job_id":jobID,
                                     "reason":NotificationTypeEnum.end_recipient])
            default:
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .DeliveryReceipientEnd,
                                                    object: nil,
                                                    userInfo: valueJSON)
                }
                NotificationCenter.default
                    .post(name: .HandyShowAlertForJobStatusChange,
                          object: status == "" ? notificationTitle : status,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.end_recipient])
            }
            // Handy Splitup End
            NotificationEnum.completedTripHistory.postNotification()

        case .KilledStateNotification:
            _ = Notification.Name(rawValue: "KilledStateNotification")
            
        case .end_job:
            var jobID = Int()
            var status = String()
            jobID = valueJSON.int("job_id")
            status = valueJSON.string("job_progress_status")
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .DeliveryProviderEndedJob,
                                                    object: nil,
                                                    userInfo: valueJSON)
                }
//                NotificationCenter.default
//                    .post(name: .DeliveryShowAlertForJobStatusChange,
//                          object: status == "" ? notificationTitle : status,
//                          userInfo: ["job_id":jobID,
//                                     "reason":NotificationTypeEnum.end_job])
            case .Ride:
                let info: [AnyHashable: Any] = [
                    "driver_thumb_image" : valueJSON.string("provider_thumb_image"),
                    "job_id" : valueJSON.string("job_id"),
                ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationTypeEnum.EndTrip.rawValue),
                                                object: jobID,
                                                userInfo: info)
                UserDefaults.standard.removeObject(forKey: "trip_driver_rating")
                UserDefaults.standard.removeObject(forKey: "trip_driver_name")
                UserDefaults.standard.removeObject(forKey: "trip_driver_thumb_url")
            default:
                // Handy Splitup End
                if let currentJob : Int = UserDefaults.value(for: .current_job_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .HandyProviderEndedJob, object: nil,userInfo: valueJSON)
                }
                // Handy Splitup Start
//                NotificationCenter.default
//                    .post(name: .HandyShowAlertForJobStatusChange,
//                          object: status == "" ? notificationTitle : status,
//                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.end_job])
            }
            // Handy Splitup End
            NotificationEnum.completedTripHistory.postNotification()
            
        case .job_payment:
            var jobID = Int()
            var status = String()
            jobID = valueJSON.int("job_id")
            status = valueJSON.string("job_progress_status")
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .DeliveryCashCollectedByProvider, object: nil,userInfo: valueJSON)
                }
                NotificationCenter.default
                    .post(name: .DeliveryShowAlertForJobStatusChange,
                          object: status == "" ? notificationTitle : status,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.job_payment])
            case .Ride:
                if let paymentData = userInfo[NotificationTypeEnum.trip_payment.rawValue] as? JSON{
                    PipeLine.fireDataEvent(withName: NotificationTypeEnum.trip_payment.rawValue, data: paymentData)
                    
                    paymentData.string("driver_thumb_image")
                    //status
                    //trip_id
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trip_payment"), object: self, userInfo: nil)
                    print("Cash Collected",userInfo)
                }
            default:
                // Handy Splitup End
                if let currentJob : Int = UserDefaults.value(for: .current_job_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .HandyCashCollectedByProvider, object: nil,userInfo: valueJSON)
                }
                // Handy Splitup Start
//                NotificationCenter.default
//                    .post(name: .HandyShowAlertForJobStatusChange,
//                          object: status == "" ? notificationTitle : status,
//                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.job_payment])
            }
            // Handy Splitup End
           
            NotificationEnum.completedTripHistory.postNotification()
            NotificationEnum.pendingTripHistory.postNotification()
            
        case .cancel_Job:
            var jobID = Int()
            var status = String()
            print("get status \(status)")
            jobID = valueJSON.int("job_id")
            status = valueJSON.string("job_progress_status")
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .DeliveryJobCancelledByProvider, object: nil)
                }
                NotificationCenter.default
                    .post(name: .DeliveryShowAlertForJobStatusChange,
                          object: notificationTitle,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.cancel_Job])
            case .Ride:
                print("cancel_trip data",userInfo)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.cancel_trip.rawValue),
                                                object: self,
                                                userInfo: userInfo)
                UserDefaults.standard.removeObject(forKey: "trip_driver_rating")
                UserDefaults.standard.removeObject(forKey: "trip_driver_name")
                UserDefaults.standard.removeObject(forKey: "trip_driver_thumb_url")
            default:
                // Handy Splitup End
                if let currentJob : Int = UserDefaults.value(for: .current_job_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .HandyJobCancelledByProvider, object: nil)
                }
                NotificationCenter.default
                    .post(name: .HandyShowAlertForJobStatusChange,
                          object: notificationTitle,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.cancel_Job])
                // Handy Splitup Start
            }
            // Gofer Splitup Start
            // Handy Splitup End
        case .job_request_detail:
            NotificationEnum.generateNewRequestID.postNotificatinWithData(userInfo: ["is_enable_cancel":true])
        case .user_cancel_request:
            NotificationEnum.generateNewRequestID.postNotificatinWithData(userInfo: ["is_enable_cancel":true])
            // Gofer Splitup end
        case .cancel_schedule_job:
            var jobID = Int()
            var status = String()
            jobID = valueJSON.int("job_id")
            status = valueJSON.string("job_progress_status")
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                if let currentJob : Int = UserDefaults.value(for: .current_delivery_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .DeliveryJobCancelledByProvider, object: nil)
                }
                NotificationCenter.default
                    .post(name: .DeliveryShowAlertForJobStatusChange,object: status == "" ? notificationTitle : status,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.cancel_schedule_job])
            case .Ride:
                print("cancel_trip data",userInfo)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.cancel_trip.rawValue), object: self, userInfo: nil)
                UserDefaults.standard.removeObject(forKey: "trip_driver_rating")
                UserDefaults.standard.removeObject(forKey: "trip_driver_name")
                UserDefaults.standard.removeObject(forKey: "trip_driver_thumb_url")
            default:
                // Handy Splitup End
                if let currentJob : Int = UserDefaults.value(for: .current_job_id),
                   jobID == currentJob{
                    NotificationCenter.default.post(name: .HandyJobCancelledByProvider, object: nil)
                }
                NotificationCenter.default
                    .post(name: .HandyShowAlertForJobStatusChange,object: status == "" ? notificationTitle : status,
                          userInfo: ["job_id":jobID,"reason":NotificationTypeEnum.cancel_schedule_job])
                // Handy Splitup Start
            }
            // Handy Splitup End
            NotificationEnum.completedTripHistory.postNotification()
        case  .order_delivery_completed,.order_cancelled:
            NotificationEnum.completedTripHistory.postNotification()
            if isFrom != "firebase" {
                self.moveTabToPastandUpcoming(type: .pending)
            }
        case .order_accepted,.order_delivery_started,.order_ready, .order_picked:
            NotificationEnum.pendingTripHistory.postNotification()
            if isFrom != "firebase" {
                self.moveTabToPastandUpcoming(type: .completed)
            }
        case .chat_notification :
//            self.handleCommonPushNotification(userInfo: valueJSON as JSON,
//                                              generateLocalNotification: false)
            break
        case .no_cars: //Gofer
            
            _ = userInfo[NotificationTypeEnum.no_cars.rawValue] as! NSDictionary
            print("No Cars Available",userInfo)
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                NotificationEnum.noCarsFound.postNotificatinWithData(userInfo: valueJSON)
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.no_cars.rawValue),
                                                object: self,
                                                userInfo: nil)

            }
            // Handy Splitup End

        case .cancel_trip: //Gofer
            print("cancel_trip data",userInfo)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.cancel_trip.rawValue), object: self, userInfo: nil)
            UserDefaults.standard.removeObject(forKey: "trip_driver_rating")
            UserDefaults.standard.removeObject(forKey: "trip_driver_name")
            UserDefaults.standard.removeObject(forKey: "trip_driver_thumb_url")
        case .trip_payment: //Gofer
            if let paymentData = userInfo[NotificationTypeEnum.trip_payment.rawValue] as? JSON{
                PipeLine.fireDataEvent(withName: NotificationTypeEnum.trip_payment.rawValue, data: paymentData)
                
                paymentData.string("driver_thumb_image")
                //status
                //trip_id
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trip_payment"), object: self, userInfo: nil)
                print("Cash Collected",userInfo)
            }
        default:
            if notificationTitle == "No cars found" {
                NotificationEnum.noCarsFound.postNotificatinWithData(userInfo: valueJSON)
            }
            print("Not handled \(notification) With value \(valueJSON)")
        }
    }
}


//MARK:- firebase notification handler
extension PushNotificationManager {
    func startObservingUser(){
        
        self.stopObservingUser()
        guard let userID : String = UserDefaults.value(for: .user_id), userID != "" else{
            print("userId is missing")
            return
        }
        if let fireListeningKey = self.firebaseReference?.key,
           fireListeningKey == userID{
            print("Already listeneing to \(fireListeningKey)")
            return
        }
        
        print("Listening to firebase user id \(userID)")
//        guard let live = firebaseEnvironment.rawValue else {
//            print("this is causing the issue")
//        }
        self.firebaseReference = Database.database().reference()
            .child("live")
            .child("User")
            .child("\(userID)")
            .child("Notification")
        if let currentJob : Int = UserDefaults.value(for: .current_delivery_id) {
//            guard let live = firebaseEnvironment.rawValue else {
//                print("this is causing the issue")
//            }
            self.jobReference = Database.database().reference()
                .child("live")
                .child("User36")
                .child("\(currentJob)")
                .child("Notification")
        }
           
        
        self.firebaseReference?.observe(.value, with: { (snapShot) in
            guard snapShot.exists() else{return}
            Shared.instance.permissionDenied = false
            //Reomve from firebase after reading the data
           self.firebaseReference?.removeValue()
            var dict = JSON()
            var custom = JSON()
            if let dataStr = snapShot.value as? String {
                dict = self.convertStringToDictionary(text: dataStr) ?? [:]
                custom = dict[NotificationTypeEnum.custom.rawValue] as! JSON
            } else if let dataStr = snapShot.value as? [String:Any] {
                dict = dataStr
                custom = dataStr
            }
            var valueDict = custom
            if valueDict["title"] == nil{
                valueDict["title"] = dict["title"] as? String
            }

            self.handleHandyPushNotifications(userInfo: valueDict, isFrom: "firebase")
//            switch AppWebConstants.businessType{
//            case .Services:
//                self.handleHandyPushNotifications(userInfo: valueDict )
//            case .Delivery:
//                self.handleHandyPushNotifications(userInfo: valueDict )
//            case .Ride:
//                self.handleGoferPushNotifications(userInfo: valueDict as NSDictionary)
//            case .DeliveryAll:
//                self.handleDeliveryAllPushNotifications(userInfo: valueDict, isFrom: "firebaseObserver")
//            default : break
//
//            }
            self.handleCommonPushNotification(userInfo: valueDict as JSON,
                                              generateLocalNotification: true)
            
        }, withCancel: { (Error:Any) in
            Shared.instance.permissionDenied = true
            print("Error is \(Error)") //prints Error is Error Domain=com.firebase Code=1 "Permission Denied"
        })
        
        self.jobReference?.observe(.value, with: { (snapShot) in
            guard snapShot.exists() else{return}
            Shared.instance.permissionDenied = false
            //Reomve from firebase after reading the data
            self.jobReference?.removeValue()
//            let dataStr = snapShot.value as? String
//            let dict = self.convertStringToDictionary(text: dataStr  ?? String())
//            let custom = dict?[NotificationTypeEnum.custom.rawValue] as Any
//            var valueDict = custom as! JSON
            let data = snapShot.value as? JSON
            let model = HandyJobDetailModel.init(array_json: data!)
            let wrap = [
                "data" : model
            ]
            NotificationCenter.default.post(name: .DeliveryRequestAccepted, object: UserDefaults.value(for: .current_delivery_id),userInfo: wrap)
            print(dump(model))
        }, withCancel: { (Error:Any) in
            Shared.instance.permissionDenied = true
            print("Error is \(Error)") //prints Error is Error Domain=com.firebase Code=1 "Permission Denied"
        })
        
    }
    func stopObservingUser(){
        self.firebaseReference?.removeAllObservers()
        self.firebaseReference = nil
    }
}

