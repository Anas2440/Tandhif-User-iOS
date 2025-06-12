//
//  SelectLanguageView.swift
//  GoferHandy
//
//  Created by trioangle on 05/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class SelectLanguageView: BaseView {
    
    //----------------------------------------
    //MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet weak var dismissView : UIView!
    @IBOutlet weak var hoverView : TopCurvedView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var languageTable : CommonTableView!
    
    //----------------------------------------
    //MARK: - Local Variables
    //----------------------------------------
    
    var selectLanguageVC : SelectLanguageVC!
    var maxYForView: CGFloat?
    var oldOrgin : CGPoint = .zero
    var oldSize : CGSize = .zero
    var currentState : SwipeState = .middle
    var currentSwipe : TypeOfSwipe = .none
    
    //----------------------------------------
    //MARK: - View Controllers life Cycle
    //----------------------------------------
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.languageTable.customColorsUpdate()
        self.hoverView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.languageTable.reloadData()
    }
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.selectLanguageVC = baseVC as? SelectLanguageVC
        self.initView()
        self.initLanguage()
        self.setupGesture()
        self.initLayer()
        self.darkModeChange()
        self.currentState = .middle
        self.stateBasedAnimation(state: self.currentState)
    }
    
    override
    func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
        maxYForView = self.frame.maxY
        oldOrgin = self.hoverView.frame.origin
        oldSize = self.hoverView.frame.size
    }
    
    //----------------------------------------
    //MARK: - View's Initalisation
    //----------------------------------------
    
    func initView(){
        self.languageTable.dataSource = self
        self.languageTable.delegate = self
        self.dismissView.addAction(for: .tap) { [weak self] in
            self?.selectLanguageVC.dismiss(animated: true, completion: nil)
        }
    }
    
    //----------------------------------------
    //MARK: - Layer's Initalisation
    //----------------------------------------
    
    func initLayer(){
        self.hoverView.isClippedCorner = true
        self.hoverView.elevate(2)
    }
    
    //----------------------------------------
    //MARK: - Language's Initalisation
    //----------------------------------------
    
    func initLanguage(){
        // It Need To Show the Title of the Page Not Selected Language
        // Commented By Karuppasamy
        self.titleLbl.text = LangCommon.selectLanguage//self.langugage.currentLangage()?.lang
    }
    
    //----------------------------------------
    //MARK: - Gestures's Initalisation
    //----------------------------------------
    
    func setupGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.hoverView.addGestureRecognizer(swipeDown)
    }
    
    //----------------------------------------
    //MARK: - Local Function
    //----------------------------------------
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
      if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
        case .right:
          print("Swiped right")
          self.currentSwipe = .right
        case .down:
          print("Swiped down")
          self.currentSwipe = .down
        case .left:
          print("Swiped left")
          self.currentSwipe = .left
        case .up:
          print("Swiped up")
          self.currentSwipe = .up
        default:
          break
        }
        self.swipe(state: self.currentState,
                   swipe: self.currentSwipe)
      }
    }
    
    func swipe(state: SwipeState,
               swipe: TypeOfSwipe) {
      switch state {
      case .full:
        switch swipe {
        case .down:
          self.currentState = .middle
        default:
          print("\(swipe) not Handled")
        }
      case .middle:
        switch swipe {
        case .down:
          self.currentState = .dismiss
        case .up:
          self.currentState = .full
        default:
          print("\(swipe) not Handled")
        }
      default:
        print("\(state) not Handled")
      }
      self.stateBasedAnimation(state: self.currentState)
    }
    
    func stateBasedAnimation(state: SwipeState) {
      UIView.animate(withDuration: 0.7) {
        switch state {
        case .full:
          self.hoverView.transform = .identity
          self.hoverView.frame.size.height = self.frame.height + 30
          self.hoverView.removeSpecificCorner()
        case .middle:
          self.hoverView.transform = CGAffineTransform(translationX: 0, y: self.frame.midY)
          self.hoverView.frame.size.height = (self.frame.height/2) + 30
          self.hoverView.customColorsUpdate()
        case .dismiss:
          self.hoverView.transform = CGAffineTransform(translationX: 0, y: self.frame.maxY)
          self.hoverView.frame.size.height = 30
          self.hoverView.customColorsUpdate()
        }
      } completion: { (isCompleted) in
        if isCompleted && state == .dismiss {
          self.selectLanguageVC.dismiss(animated: true) {
            print("Select Lanaguage is Completely Dismissed")
          }
        }
      }
    }
    
}

//----------------------------------------
//MARK: - languageTable Data Source
//----------------------------------------

extension SelectLanguageView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableLanguages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height * 0.115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LanguageTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let data = availableLanguages.value(atSafe: indexPath.row) else{return cell}
        cell.populate(with: data)
        cell.ThemeChange()
        return cell
    }
}

//----------------------------------------
//MARK: - languageTable Delegate
//----------------------------------------

extension SelectLanguageView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedLang = availableLanguages.value(atSafe: indexPath.row),
            let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        if selectedLang == currentLanguage {
            self.selectLanguageVC.dismiss(animated: true,
                                          completion: nil)
        } else {
            if let _ = UserDefaults.standard.string(forKey: "access_token"){
                self.selectLanguageVC.update(language: selectedLang)
            }else{
                selectedLang.saveLanguage()
                appDelegate.makeSplashView(isFirstTime: false)
            }
        }
    }
}

//----------------------------------------
//MARK: - languageTable cell
//----------------------------------------

class LanguageTVC : UITableViewCell {
    
    //----------------------------------------
    //MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet weak var nameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var radioBtn : PrimaryTintButton!
    
    //----------------------------------------
    //MARK: - view initalisation
    //----------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.radioBtn.isUserInteractionEnabled = false
        self.radioBtn.imageView?.contentMode = .scaleAspectFit
        self.ThemeChange()
    }
    
    func ThemeChange() {
        self.nameLbl.customColorsUpdate()
        self.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
    }
    
    //----------------------------------------
    //MARK: - languageTable Data Source
    //----------------------------------------
    
    func populate(with language : Language){
        self.nameLbl.text = language.lang
        let image = UIImage(named: language.key == UserDefaults.value(for: .default_language_option) ? "Radio_btn_selected" : "Radio_btn_unselected")?
            .withRenderingMode(.alwaysTemplate)
        self.radioBtn.setImage(image,
                               for: .normal)
    }
}
