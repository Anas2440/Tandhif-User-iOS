//
//  HandyRequestVC.swift
//  GoferHandy
//
//  Created by trioangle on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase

class HandyRequestVC: BaseViewController {
    
    @IBOutlet weak var requestView : HandyRequestView!
    
    var bookingViewModel : HandyJobBookingVM?
    var accountViewModel : AccountViewModel?
    
    var provider : Provider!
    var serviceAtUserLocation : Bool!
    var player: AVAudioPlayer?
    static var requestID : Int? = nil
    var audioTimer : Timer? = nil
    var promoId:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wsToRequest()
        self.onCallTimer()
        audioTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.onCallTimer()
        }
      
        audioTimer?.fire()
        self.initNotification()
        // Do any additional setup after loading the view.
    }
    
    
    func initNotification(){
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyJobRequestAccepted,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.beforeExitActions),
            name: .HandyJobRequestAccepted,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyRequestCancelledByProvider,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.requestCancelled),
            name: .HandyRequestCancelledByProvider,
            object: nil
        )
    }
    //MARK:- intiWithStory
    class func initWithStory(for provider : Provider,
                             serivceAtUser : Bool,
                             bookingVM : HandyJobBookingVM,
                             accountVM : AccountViewModel) -> HandyRequestVC{
        let view : HandyRequestVC =  UIStoryboard.gojekHandyUnique.instantiateViewController()
        view.bookingViewModel = bookingVM
        view.accountViewModel = accountVM
        view.provider = provider
        view.serviceAtUserLocation = serivceAtUser
        view.modalPresentationStyle = .overCurrentContext
        return view
    }
    //MARK:- UDF
    @objc func beforeExitActions(){
        self.audioTimer?.invalidate()
        self.player?.stop()
//        guard let jobID = ((UserDefaults.value(for: .current_job_id) ?? 0) as? Int) else { return }
//        if let vc = self.navigationController?.viewControllers.last {
//            if let presentedVC = vc.presentedViewController { presentedVC.dismiss(animated: false, completion: nil) }
//            if vc.isKind(of: HandyRouteVC.self) { guard (vc as! HandyRouteVC).jobID != jobID else { return } }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//            self.navigationController?.pushViewController(
//                HandyRouteVC.initWithStory(forJobID: jobID),
//                animated: true)
//        })
    }
    @objc
    func requestCancelled(){
//        self.beforeExitActions()
        self.exitScreen(animated: true)
    }
    @objc func onCallTimer(){
        playSound("ub__reminder")
    }
    
    // set the request sound
    func playSound(_ fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //MARK:- WebService
    func wsToRequest(){
        self.requestView.set(Status: false)
        self.requestView.isCloseActive = false
        self.bookingViewModel?
            .wsToBook(provider: self.provider,
                      atUserLocation: self.serviceAtUserLocation,
                      promoId:self.promoId) { (result) in
                switch result{
                case .success(let json):
                    guard json.isSuccess else{
                        self.requestView.set(Status: true)
                        self.requestView.isCloseActive = true
                        self.beforeExitActions()
                        self.presentAlertWithTitle(
                            title: appName,
                            message: json.status_message,
                            options: LangCommon.ok) { (_) in
                                self.exitScreen(animated: false)
                            }
                        return
                    }
                    self.requestView.set(Status: true)
                    self.requestView.isCloseActive = true
                    Self.requestID = json.int("request_id")
                    print(json.description)
                    UserDefaults.set(0, for: .promo_id)
                    let countStr : String = UserDefaults.value(for: .job_requesting_duration) ?? "30"
                    if let count = Int(countStr) {
                       let _count = count == 0 ? 30 : count
                        let requetInteval = DispatchTimeInterval.seconds(_count)
                        DispatchQueue.main.asyncAfter(deadline: .now() + requetInteval) {
                            self.beforeExitActions()
                            self.exitScreen(animated: false)
                        }
                    }
                case .failure(let error):
                    self.requestView.set(Status: true)
                    self.requestView.isCloseActive = true
                    self.beforeExitActions()
                    self.presentAlertWithTitle(
                        title: appName,
                        message: error.localizedDescription,
                        options: LangCommon.ok) { (_) in
                            self.exitScreen(animated: false)
                        }
                    
                }
            }
    }
    func wsToCancelRequest(){
        guard let _requestID = Self.requestID else{return}
        self.bookingViewModel?
            .wsTocancelJobRequest(
                _requestID,
                type: 1,
                completionHandler: { (result) in
                    switch result{
                    case .success( _):
                        self.requestView.exitScreen()
                    case .failure(let error):
                        self.presentAlertWithTitle(title: appName,
                                                   message: error.localizedDescription,
                                                   options: LangCommon.ok) { (_) in
                                                    
                        }
                    }
            })
    }
}
