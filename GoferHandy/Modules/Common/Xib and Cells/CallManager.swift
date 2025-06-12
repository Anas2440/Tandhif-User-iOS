//
//  CallManager.swift
//  Gofer
//
//  Created by trioangle on 27/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

//
//import Foundation
//import Sinch
//import AVFoundation
//import AudioToolbox
//import MediaPlayer
//
//
//class CallManager : NSObject {
//    
//    //MARK:- Globals
//    enum Environment : String{
//        case live = "clientapi.sinch.com"
//        case sandbox = "sandbox.sinch.com"
//    }
//    enum SinchErrors: Error {
//        case clientNotInitialized
//        case clientNotReadyForCall
//        case clientNotReadyForListening
//        case keyNotAvailable
//        case noCall
//    }
//    enum CallState {
//        case inComming
//        case outGoing
//        case inCall
//        case ringing
//        case none
//    }
//    static let instance : CallManagerDelegate = CallManager()
//    //MARK:- SinchVaraibles
//    var sinchClient : SINClient?{
//        didSet{
//            
//        }
//    }
//    var callMaker : SINCallClient?{
//        didSet{self.callMaker?.delegate = self}
//    }
//    var activeCall : SINCall?{
//        didSet{self.activeCall?.delegate = self}
//    }
//    var audioController : SINAudioController?
//    
//    var pushManager : SINManagedPush?
//    
//    //MARK:- Varaibles
//    var ringTimer : Timer?
//    var player: AVAudioPlayer?
//    lazy var callVC : CallViewController = .initWithStory(self)
//    
//    var callEstablishTime : Date?
//    
//    var pushApplicationData : UIApplication?
//    var pushNotiToken : Data?
//    var lastNotification : [AnyHashable : Any]?
//    
//    
//    private override init(){
//        super.init()
//        
//    }
//}
//extension CallManager : CallManagerDelegate {
//    
//   
//    
//    
//    
//    //MARK:- CallManagerDelegate
//    
//    var isInitialized : Bool{
//        return self.sinchClient?.isStarted() ?? false
//    }
//    func initialize(environment: CallManager.Environment,for user : String) throws{
//        //        UserDefaults.set("c9ea329a-d57f-4cb3-b640-a183799ba839", for: .sinch_key)
//        //        UserDefaults.set("muqN5Q/zuEeZV9ZqrTTmHg==", for: .sinch_secret_key)
//        
//        guard self.sinchClient == nil || !(self.sinchClient?.isStarted() ?? false) else{return}
//        guard let key : String = UserDefaults.value(for: .sinch_key),
//            let secret : String = UserDefaults.value(for: .sinch_secret_key) else{
//                throw SinchErrors.keyNotAvailable
//        }
//        
//        self.sinchClient = try? Sinch.client(withApplicationKey: key,
//                                        environmentHost: environment.rawValue,
//                                        userId: user)
//       
//        guard self.sinchClient != nil else {throw SinchErrors.clientNotInitialized}
//        
//        self.audioController = sinchClient?.audioController()
//        
//        //Call
//        self.callMaker = self.sinchClient?.call()
//        self.callMaker?.delegate = self
//        self.sinchClient?.delegate = self
//        self.sinchClient?.setSupportPushNotifications(true)
//        
//        //Push notification
//        self.sinchClient?.unregisterPushNotificationDeviceToken()
//        self.sinchClient?.setSupportPushNotifications(CanRequestSinchNotification)
//        if CanRequestSinchNotification {
//            if let app = self.pushApplicationData,
//               let token = self.pushNotiToken {
//                let pushEnvironment : SINAPSEnvironment = callEnvironment == .live ? .production : .development
////                sinchClient?.relayRemotePushNotification(userInfo)
//
////                self.pushManager?.application(app,
////                                              didRegisterForRemoteNotificationsWithDeviceToken: token)
//            }
//            self.pushManager = Sinch.managedPush(with: .development)
//            self.sinchClient?.enableManagedPushNotifications()
//            self.pushManager?.delegate = self
//        }
//        
//        self.sinchClient?.start()
//    }
//    
//    
//    func wipeUserData() {
//        self.activeCall?.hangup()
//        self.sinchClient?.terminateGracefully()
//        
//        self.sinchClient?.setSupportPushNotifications(false)
//        self.sinchClient?.unregisterPushNotificationDeviceToken()
//        self.sinchClient?.unregisterPushNotificationDeviceToken()
//        self.sinchClient?.setSupportPushNotifications(false)
//    }
//    func deinitialize(){
//        self.activeCall?.hangup()
//        self.audioController?.stopPlayingSoundFile()
//        self.audioController = nil
//        self.sinchClient?.terminateGracefully()
//        self.sinchClient?.setSupportPushNotifications(false)
//        self.sinchClient?.delegate = nil
//        self.sinchClient = nil
//    }
//    func should(waitForCall listent : Bool) throws{
//        guard let client = self.sinchClient else{throw SinchErrors.clientNotInitialized}
//        guard client.isStarted() else{throw SinchErrors.clientNotReadyForListening}
//        if listent{
////            client.startListeningOnActiveConnection()
//            
//        }else{
////            client.stopListeningOnActiveConnection()
//        }
//    }
//    func callUser(withID id: String) throws {
//        debug(print: "Id -> \(id)")
//        guard let _ = self.sinchClient else{throw SinchErrors.clientNotReadyForCall}
//        guard let call = self.callMaker?.callUser(withId: id) else{throw SinchErrors.noCall}
//        
//        
//        self.activeCall = call
//        self.activeCall?.delegate = self//SINCallDelegate
//        self.callVC.attach(with: .fullScreen)
//        
//        self.ringTimer =  Timer.scheduledTimer(timeInterval: 3,
//                                               target: self,
//                                               selector: #selector(self.doCallAlertSounds),
//                                               userInfo: nil,
//                                               repeats: true)
//        self.ringTimer?.fire()
//    }
//    func registerForPushNotificaiton(token: Data, forApplicaiton app: UIApplication) {
//        self.pushApplicationData = app
//        self.pushNotiToken = token
//    }
//    
//    
//    func didReceivePush(notification data: [AnyHashable : Any]) {
//        debug(print: data.description)
//        
//        if !self.isInitialized{
//            self.lastNotification = data
//        }
////        self.pushManager?.application(self.pushApplicationData,
////                                      didReceiveRemoteNotification: data)
//        
//    }
//    
//}
////MARK:- Sinch Client Delegate
//extension CallManager : SINClientDelegate{
//    func clientDidStart(_ client: SINClient!) {
//        debug(print: client.userId)
//        if let lastNotificationData = self.lastNotification{
////            self.pushManager?.application(self.pushApplicationData,
////                                          didReceiveRemoteNotification: lastNotificationData)
//            self.lastNotification = nil
//        }
//        
//        do{ try CallManager.instance.should(waitForCall: true)
//        }catch let error{debug(print: error.localizedDescription)}
//        
//        if let firstName : String = UserDefaults.value(for: .first_name){
////           self.sinchClient?.setPushNotificationDisplayName(firstName)
//        }else{
////            self.sinchClient?.setPushNotificationDisplayName(LangCommon.driver)
//        }
//    }
//    
//    func clientDidFail(_ client: SINClient!, error: Error!) {
//        debug(print: client.userId)
//        
//    }
//    
//    func clientDidStop(_ client: SINClient!) {
//        debug(print: client.userId)
//        
//    }
//    func client(_ client: SINClient!, requiresRegistrationCredentials registrationCallback: SINClientRegistration!) {
//        debug(print: client.userId)
//    }
//}
//
////MARK:- OutGoing
//extension CallManager : SINCallDelegate{
//    /**
//     delegate show if the other user is available (Ringing State)
//     */
//    func callDidProgress(_ call: SINCall!) {
//        
//        self.callVC.refreshView()
//        debug(print: call.callId)
//        self.activeCall = call
//    }
//    
//    func callDidEstablish(_ call: SINCall!) {
//        let audioPermission = PermissionManager(self.callVC,
//                                                MicrophoneConfig())
//           
//        if !audioPermission.isEnabled {
//            audioPermission.forceEnableService()
//        }
//        AudioServicesPlaySystemSound(1150)//call waiting1257
//        self.disableLoudSpeaker(true)
//        MPVolumeView.setVolume(1)
//        debug(print: call.callId)
//        self.callVC.refreshView()
//        self.activeCall = call
//        self.callEstablishTime = Date()
//        self.stopCallAlertSounds()
//    }
//    func callDidEnd(_ call: SINCall!) {
//        AudioServicesPlaySystemSound(1256)//call waiting1257
//        self.callEstablishTime = nil
//        debug(print: call.callId)
//        self.stopCallAlertSounds()
//
//        self.callVC.detach()
//        self.activeCall = nil
//
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        switch call.details.endCause{
//        case .denied:
//            if call.direction == .outgoing{
//                if SharedVariables.sharedInstance.callStore {
//                    appDelegate?.createToastMessage(SharedVariables.sharedInstance.storeName + " " + LangCommon.busyTryAgain)
//                }else{
//                    appDelegate?.createToastMessage(SharedVariables.sharedInstance.driverName + " " + LangCommon.busyTryAgain)
//                }
//            }else{
//                fallthrough
//            }
//        default:
//            appDelegate?.createToastMessage(LangCommon.callEnded.capitalized)
//        }
//
//        
//    }
//    
//    
//    
//}
////MARK:- inComming
//extension CallManager : SINCallClientDelegate{
//    
//    func client(_ client: SINCallClient!, willReceiveIncomingCall call: SINCall!) {
//        debug(print: call.callId)
//        //        self.activeCall = call
//        
//    }
//    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
//        debug(print: call.callId)
//        self.activeCall = call
//        self.callMaker = client
//        
//        
//        self.ringTimer =  Timer.scheduledTimer(timeInterval: 3,
//                                               target: self,
//                                               selector: #selector(self.doCallAlertSounds),
//                                               userInfo: nil,
//                                               repeats: true)
//        self.ringTimer?.fire()
//        self.callVC.attach(with: .fullScreen)//.toast)
//        
//        
//        
//    }
////    func client(_ client: SINCallClient!, localNotificationForIncomingCall call: SINCall!) -> SINLocalNotification! {
////        debug(print: call.callId)
////        
////        self.activeCall = call
////        let notification = SINLocalNotification()
////        notification.alertAction = "Answer"
////        notification.alertBody = "Incoming call from Rider"
////        return notification
////    }
//    
//}
//extension CallManager : UICallHandlingDelegate{
//    var callerID: String? {
//        return self.activeCall?.remoteUserId
//    }
//    
//    var callDuration: String? {
//        guard let time = self.callEstablishTime else{return nil}
//        var durationStr = String()
//        let interval = abs(Int(time.timeIntervalSinceNow))
//        let timeStamp : (Int,Int,Int) = (interval / 3600,
//                                         (interval % 3600) / 60,
//                                         (interval % 3600) % 60)//hr,min,sec
//        
//        let numberFormatter = NumberFormatter()
//        numberFormatter.allowsFloats = false
//        numberFormatter.minimumIntegerDigits = 2
//        numberFormatter.maximumIntegerDigits = 2
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.minimumFractionDigits = 0
//        numberFormatter.maximumFractionDigits = 0
//        
//        if timeStamp.0 > 0{
//            durationStr.append("\(numberFormatter.string(from: NSNumber(value: timeStamp.0)) ?? "00" ) : ")
//        }
//        durationStr.append("\(numberFormatter.string(from: NSNumber(value: timeStamp.1)) ?? "00" ) : ")
//        durationStr.append("\(numberFormatter.string(from: NSNumber(value: timeStamp.2)) ?? "00" )")
//        
//        return durationStr
//    }
//    
//    
//    func accept() {
//        self.activeCall?.answer()
//        
//        self.stopCallAlertSounds()
//    }
//    func decline() {
//        self.stopCallAlertSounds()
//        if self.activeCall?.direction == SINCallDirection.incoming {
//            self.activeCall?.hangup()
//        }else{
//            self.activeCall?.hangup()
//        }
//    }
//    var callState: CallManager.CallState{
//        guard let call = self.activeCall else {
//            debug(print: "cant Determin")
//            return .none
//        }
//        if [SINCallState.progressing].contains(call.state){//progressing
//            debug(print: "incall")
//            return .ringing
//        }else if [SINCallState.established].contains(call.state){//progressing
//            debug(print: "incall")
//            return .inCall
//        }else if call.direction == .incoming{
//            debug(print: "incomming")
//            return .inComming
//        }else{
//            debug(print: "Outgoing")
//            return .outGoing
//        }
//        
//    }
//    
//    
//}
////MARK:- Push notification
//extension CallManager : SINManagedPushDelegate{
//    func managedPush(_ managedPush: SINManagedPush!, didReceiveIncomingPushWithPayload payload: [AnyHashable : Any]!, forType pushType: String!) {
////        self.sinchClient?.relayRemotePushNotification(payload)
//    }
//    
//    
//}
//extension CallManager {
//    //MARK:- UDF
//    private func playSound(_ fileName: String) {
//        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            guard let player = player else { return }
//            player.prepareToPlay()
//            player.play()
//            debug(print: fileName)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    @objc func doCallAlertSounds(){
//        debug(print: "\(self.activeCall?.direction == SINCallDirection.incoming)")
//        guard ![CallManager.CallState.none,.inCall].contains(self.callState) else {return}
//        guard self.ringTimer?.isValid ?? false else{return}
////        self.playSound("requestaccept")
//        DispatchQueue.main.async {
//            if self.activeCall?.direction == SINCallDirection.incoming{
//                AudioServicesPlaySystemSound(1304)// call ringing
//                AudioServicesPlaySystemSound(1520) // Actuate "Pop" feedback (strong boom) booms)
//            }else{
//                AudioServicesPlaySystemSound(1154)//call waiting
////                AudioServicesPlaySystemSound(1521) // Actuate "Nope" feedback (series of three weak
//            }
//        }
//    }
//    func stopCallAlertSounds(){
//        debug(print: "")
//        self.player?.stop()
//        self.ringTimer?.invalidate()
//        self.ringTimer = nil
//    }
//    func muteMic(_ mute : Bool){
//        guard let audioCtrlr = self.audioController else{return}
//        if mute{
//            audioCtrlr.mute()
//        }else{
//            audioCtrlr.unmute()
//        }
//    }
//    
//    func disableLoudSpeaker(_ disable : Bool){
//        let session = AVAudioSession.sharedInstance()
//        do{
//            if !disable{
////                try session.setCategory(AVAudioSession.Category.playback)
//                try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//            }else{
////                try session.setCategory(.playAndRecord)
//                try session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
//            }
//            try session.setActive(true, options: .notifyOthersOnDeactivation)
//            
//            
//        }catch(let error){
//            
//            debug(print: error.localizedDescription)
//        }
//    }
//}
///*
// if let call = dict["CALL"] as? [AnyHashable : Any]{
// CallManager.instance.didReceivePush(notification: call)
// return
// }else
// let sender_name = UserDefaults.standard.string(forKey: TRIP_DRIVER_NAME) ?? "Driver".localize
// let customNotification = UILocalNotification()
// customNotification.fireDate = Date(timeIntervalSinceNow: 0)
// customNotification.soundName = UILocalNotificationDefaultSoundName
// customNotification.timeZone = NSTimeZone.default
// customNotification.alertTitle = "\(sender_name) is Calling"
// customNotification.alertBody = "Answer"
// 
// customNotification.alertAction = "open"
// customNotification.hasAction = true
// customNotification.userInfo = ["CALL" : notification.request.content.userInfo]
// UIApplication.shared.scheduleLocalNotification(customNotification)
// */
//extension MPVolumeView {
//  static func setVolume(_ volume: Float) {
//    let volumeView = MPVolumeView()
//    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
//
//    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
//        slider?.setValue(volume, animated: true)
////      slider?.value = volume
//    }
//  }
//}

import Foundation
import AVFoundation
import AudioToolbox
import MediaPlayer
import CallKit
import PushKit
import UIKit

class CallManager: NSObject {
    
    // MARK: - Globals
    enum Environment: String {
        case live = "production"
        case sandbox = "development"
    }
    
    enum SinchErrors: Error {
        case clientNotInitialized
        case clientNotReadyForCall
        case clientNotReadyForListening
        case keyNotAvailable
        case noCall
    }
    
    enum CallState {
        case inComming
        case outGoing
        case inCall
        case ringing
        case none
    }
    
    static let instance: CallManagerDelegate = CallManager()
    
    // MARK: - Variables
    var ringTimer: Timer?
    var player: AVAudioPlayer?
    lazy var callVC: CallViewController = .initWithStory(self)
    var callEstablishTime: Date?
    var pushApplicationData: UIApplication?
    var pushNotiToken: Data?
    var lastNotification: [AnyHashable: Any]?
    
    // CallKit properties
    private let callController = CXCallController()
    private var provider: CXProvider?
    private var currentCallUUID: UUID?
    private var isCallOutgoing = false
    private var isCallEstablished = false
    var callerID: String?
    
    private override init() {
        super.init()
        setupProvider()
    }
    
    private func setupProvider() {
        let configuration = CXProviderConfiguration(localizedName: "Gofer")
        configuration.supportsVideo = false
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportedHandleTypes = [.generic]
        configuration.iconTemplateImageData = UIImage(named: "AppIcon")?.pngData()
        configuration.ringtoneSound = "ringtone.caf"
        
        provider = CXProvider(configuration: configuration)
        provider?.setDelegate(self, queue: nil)
    }
}

// MARK: - CallManagerDelegate
extension CallManager: CallManagerDelegate {
//    private var _clientInstanceKey = "clientInstanceKey"  // just a private key for associated object if needed
        
    var clientInstance: Any? {
        get {
            return provider
        }
        set {
                // If someone sets clientInstance externally, optionally assign to provider if it's a CXProvider
            if let newProvider = newValue as? CXProvider {
                provider = newProvider
            } else {
                    // Ignore or handle other cases if needed
                provider = nil
            }
        }
    }
    
    
    var isInitialized: Bool {
        return provider != nil
    }
    
    func initialize(environment: CallManager.Environment, for user: String) throws {
        // Initialization logic if needed
    }
    
    func wipeUserData() {
        endCall()
    }
    
    func deinitialize() {
        endCall()
        provider = nil
    }
    
    func should(waitForCall listent: Bool) throws {
        // Handle listening state if needed
    }
    
    func callUser(withID id: String) throws {
        let uuid = UUID()
        currentCallUUID = uuid
        callerID = id
        isCallOutgoing = true
        
        let handle = CXHandle(type: .generic, value: id)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error.localizedDescription)")
            } else {
                let update = CXCallUpdate()
                update.remoteHandle = handle
                update.hasVideo = false
                self.provider?.reportCall(with: uuid, updated: update)
                self.callVC.attach(with: .fullScreen)
                self.startRingTimer()
            }
        }
    }
    
    func registerForPushNotificaiton(token: Data, forApplicaiton app: UIApplication) {
        self.pushApplicationData = app
        self.pushNotiToken = token
    }
    
    func didReceivePush(notification data: [AnyHashable: Any]) {
        // Handle incoming push notification
        // For example, extract caller ID and report incoming call
        if let id = data["caller_id"] as? String {
            reportIncomingCall(id: id)
        }
    }
    
    private func reportIncomingCall(id: String) {
        let uuid = UUID()
        currentCallUUID = uuid
        callerID = id
        isCallOutgoing = false
        
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: id)
        update.hasVideo = false
        
        provider?.reportNewIncomingCall(with: uuid, update: update, completion: { error in
            if let error = error {
                print("Failed to report incoming call: \(error.localizedDescription)")
            } else {
                self.callVC.attach(with: .fullScreen)
                self.startRingTimer()
            }
        })
    }
}

// MARK: - CXProviderDelegate
extension CallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        endCall()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        configureAudioSession()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        configureAudioSession()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        endCall()
        action.fulfill()
    }
    
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    private func endCall() {
        stopCallAlertSounds()
        callVC.detach()
        currentCallUUID = nil
        callerID = nil
        isCallOutgoing = false
        isCallEstablished = false
    }
}

// MARK: - UICallHandlingDelegate
extension CallManager: UICallHandlingDelegate {
    var callerId: String? {
        return self.callerID
    }
    
    var callDuration: String? {
        guard let time = self.callEstablishTime else { return nil }
        let interval = Int(Date().timeIntervalSince(time))
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        let seconds = interval % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func accept() {
        // Accept the call
        configureAudioSession()
        stopCallAlertSounds()
    }
    
    func decline() {
        // Decline the call
        if let uuid = currentCallUUID {
            let endCallAction = CXEndCallAction(call: uuid)
            let transaction = CXTransaction(action: endCallAction)
            callController.request(transaction) { error in
                if let error = error {
                    print("Error ending call: \(error.localizedDescription)")
                }
            }
        }
        stopCallAlertSounds()
    }
    
    var callState: CallManager.CallState {
        if isCallEstablished {
            return .inCall
        } else if isCallOutgoing {
            return .outGoing
        } else if currentCallUUID != nil {
            return .inComming
        } else {
            return .none
        }
    }
}

// MARK: - Sound Management
extension CallManager {
    private func playSound(_ fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    @objc func doCallAlertSounds() {
        guard callState != .inCall else { return }
        DispatchQueue.main.async {
            AudioServicesPlaySystemSound(1304) // Ringing sound
        }
    }
    
    func stopCallAlertSounds() {
        player?.stop()
        ringTimer?.invalidate()
        ringTimer = nil
    }
    
    func muteMic(_ mute: Bool) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            if mute {
                try session.setCategory(.playAndRecord, options: [.duckOthers])
            } else {
                try session.setCategory(.playAndRecord, options: [])
            }
        } catch {
            print("Error setting mute: \(error.localizedDescription)")
        }
    }
    
    func disableLoudSpeaker(_ disable: Bool) {
        let session = AVAudioSession.sharedInstance()
        do {
            if disable {
                try session.overrideOutputAudioPort(.none)
            } else {
                try session.overrideOutputAudioPort(.speaker)
            }
            try session.setActive(true)
        } catch {
            print("Error overriding output audio port: \(error.localizedDescription)")
        }
    }
    
    private func startRingTimer() {
        ringTimer = Timer.scheduledTimer(timeInterval: 3,
                                         target: self,
                                         selector: #selector(self.doCallAlertSounds),
                                         userInfo: nil,
                                         repeats: true)
        ringTimer?.fire()
    }
}

// MARK: - MPVolumeView Extension
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                slider.setValue(volume, animated: true)
            }
        }
    }
}
