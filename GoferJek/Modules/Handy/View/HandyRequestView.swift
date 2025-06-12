//
//  HandyRequestView.swift
//  GoferHandy
//
//  Created by trioangle on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

class HandyRequestView: BaseView {
    
    var requestVC : HandyRequestVC!
    
    
    //MARK:- Outlets
    @IBOutlet weak var holderView : UIView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var rippleIV : UIImageView!
    @IBOutlet weak var close : UIButton!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var mapIconHolderView: UIView!
    
    var isCloseActive : Bool = false
    
    //MARK:- Actions
    @IBAction
    override func backAction(_ sender : UIButton){
        guard !Shared.instance.isLoading(in: self) else {
            return
        }
        
        self.requestVC
            .presentAlertWithTitle(
                title: appName,
                message:  LangCommon.areYouSureYouWantToCancel,
                options: LangCommon.yes+"ð",LangCommon.no) { (option) in
                if option == 0{
                    self.requestVC.wsToCancelRequest()
                }
            }
    }
    
    //MARK:- variables
    
    var player: AVAudioPlayer?
    var animationView : AnimationView?
    //MAKR:- Life Cycle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.requestVC = baseVC as? HandyRequestVC
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.initView()
        }
        self.initLanguage()
        self.darkModeChange()
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    //MARK:- initializers
    
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
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = self.isDarkStyle ? UIColor.DarkModeBackground.withAlphaComponent(0.9) : UIColor.SecondaryColor.withAlphaComponent(0.9)
        self.close.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.set(Status: isCloseActive)
    }
    
    func set(Status:Bool) {
        self.close.backgroundColor = Status ? self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor : .TertiaryColor
        self.close.setTitleColor(Status ? self.isDarkStyle ? .DarkModeBackground : .SecondaryColor : .InactiveTextColor, for: .normal)
        self.close.isUserInteractionEnabled = Status
    }
    
    //MARK:- UDF
    func exitScreen(){
        self.requestVC.beforeExitActions()
        super.backAction(self.close)
    }
    func createLottieView() -> AnimationView{
        
        let animationView = AnimationView.init(name: "request2")
        
        animationView.frame = self.bounds
        
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
    
}
