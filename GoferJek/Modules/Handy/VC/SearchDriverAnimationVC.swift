    //
    //  SearchDriverAnimationVC.swift
    //  GoferHandy
    //
    //  Created by Maroofff  on 07/11/24.
    //  Copyright © 2024 Vignesh Palanivel. All rights reserved.
    //

import UIKit
import AVFAudio
import Lottie

class SearchDriverAnimationVC: BaseViewController {
    
        //MARK:- Outlets
    @IBOutlet weak var holderView : UIView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var rippleIV : UIImageView!
    @IBOutlet weak var close : UIButton!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var mapIconHolderView: UIView!
    
    var bookingVM : HandyJobBookingVM?
    var isCloseActive : Bool = false
    var service_list = [SelectedService]()
    var serviceAtUserLocation : Bool!
    var player: AVAudioPlayer?
    static var requestID : Int? = nil
    var audioTimer : Timer? = nil
    var promoId:Int = 0
    var providers = [Provider]()
    var completionHandler: (([Provider],[Int]) -> Void)? = nil
    var failureHandler: ((Error) -> Void)? = nil
    var soundStopHandler: (() -> Void)? = nil
    var location: CLLocation?
    
        //MARK:- Actions
    @IBAction func backAction(_ sender : UIButton){
        guard !Shared.instance.isLoading(in: self.view) else {
            return
        }
        
        self.soundStopHandler?()
        self.soundStopHandler = nil
        self.audioTimer?.invalidate()
        self.animationView?.stop()
        
        self.presentAlertWithTitle(
            title: appName,
            message:  LangCommon.areYouSureYouWantToCancel,
            options: LangCommon.yes+"ð",LangCommon.no) { (option) in
                if option == 0{
                    self.dismiss(animated: true)
                }
            }
    }
    
        //MARK:- variables
    var animationView : AnimationView?
        //MAKR:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.initView()
        }
        self.initLanguage()
        self.darkModeChange()
        self.onCallTimer()
        audioTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.onCallTimer()
        }
        
        audioTimer?.fire()
        self.initNotification()
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.call_api()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
        //MARK: - initializers
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
    
    func initView(){
        self.close.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                  left: 10,
                                                  bottom: 0,
                                                  right: 10)
        self.mapIcon.image = UIImage(named: "map_marker")?.withRenderingMode(.alwaysTemplate)
        self.mapIcon.tintColor = .PrimaryTextColor
        self.mapIconHolderView.isRounded = true
        self.mapIconHolderView.backgroundColor = UIColor.PrimaryColor.withAlphaComponent(0.3)
        let rippleAnimation = self.createLottieView()
        self.animationView = rippleAnimation
            //        self.addSubview(rippleAnimation)
        self.holderView.insertSubview(rippleAnimation, at: 0)
        rippleAnimation.anchor(toView: self.holderView,
                               leading: 0,
                               trailing: 0,
                               top: 0,
                               bottom: 0)
        self.close.clipsToBounds = true
        self.close.cornerRadius = 12
        
            //        let image = UIImage.gifImageWithName("ripple")
            //        self.rippleIV.image = image
            //        self.onCallTimer()
    }
    func initLanguage(){
        self.titleLbl.text = LangCommon.requesting
        self.close.setTitle(LangCommon.cancel.capitalized, for: .normal)
    }
    
    func darkModeChange() {
        self.view.backgroundColor = self.view.isDarkStyle ? UIColor.DarkModeBackground.withAlphaComponent(0.9) : UIColor.SecondaryColor.withAlphaComponent(0.9)
        self.close.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.set(Status: isCloseActive)
    }
    
    func set(Status:Bool) {
        self.close.backgroundColor = Status ? self.view.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor : .TertiaryColor
        self.close.setTitleColor(Status ? self.view.isDarkStyle ? .DarkModeBackground : .SecondaryColor : .InactiveTextColor, for: .normal)
        self.close.isUserInteractionEnabled = Status
    }
    
        //MARK:- UDF
    @objc func beforeExitActions(){
        self.audioTimer?.invalidate()
        self.player?.stop()
    }
    @objc
    func requestCancelled(){
        self.beforeExitActions()
        self.exitScreen(animated: true)
    }
    @objc func onCallTimer(){
        playSound("ub__reminder")
    }
    
    
    func exitScreen(){
        self.beforeExitActions()
        self.backAction(self.close)
    }
    
    func createLottieView() -> AnimationView{
        
        let animationView = AnimationView.init(name: "request2")
        
        animationView.frame = self.view.bounds
        
            // 3. Set animation content mode
        
        animationView.contentMode = .scaleAspectFit
        
            // 4. Set animation loop mode
        
        animationView.loopMode = .loop
        
            // 5. Adjust animation speed
        
        animationView.animationSpeed = 0.5
        
            // Special Function For Background Behaviour
        
        animationView.backgroundBehavior = .pauseAndRestore
        
            // 6. Play animation
        
        animationView.play()
        return animationView
    }
    
        // set the request sound
    func playSound(_ fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            self.soundStopHandler = {
                player.stop()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func call_api() {
        self.bookingVM?.GetFilteredProvidersList(for: self.service_list, with: self.location, { (result) in
            self.soundStopHandler?()
            self.soundStopHandler = nil
            self.audioTimer?.invalidate()
            self.animationView?.stop()
            print(result)
                switch result {
                case .success(let response):
                        self.providers.removeAll()
                        print(response.providers)
                        self.providers = response.providers
                        print(self.providers)
                        self.dismiss(animated: true)
                        var cat_ids: [Int] = []
                        self.service_list.forEach({ service in
                            let catIds = service.selectedCategories.map { $0.categoryID }
                            cat_ids.append(contentsOf: catIds)
                        })
                        self.completionHandler?(self.providers,cat_ids)
                case .failure(let error):
                    self.providers.removeAll()
                        self.dismiss(animated: true)
                        self.failureHandler?(error)
                }
        })
    }
}
