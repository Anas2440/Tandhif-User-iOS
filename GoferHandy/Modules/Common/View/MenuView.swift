    //
    //  MenuView.swift
    //  GoferHandy
    //
    //  Created by trioangle on 07/09/20.
    //  Copyright © 2020 Trioangle Technologies. All rights reserved.
    //

import Foundation
import UIKit


class MenuView : BaseView{
    
    var menuVC :  MenuVC!
        //MARK: Outlets
    @IBOutlet weak var sideMenuHolderView : UIView!
    @IBOutlet weak var closeBtn: SecondaryButton!
    @IBOutlet weak var settingIV : UIButton!
    @IBOutlet weak var profileHeaderView : SecondaryView!
    @IBOutlet weak var avatarImage : UIImageView!
    @IBOutlet weak var avatarName : SecondaryHeaderLabel!
    
    @IBOutlet weak var walletBalanceLbl: SecondaryRegularLabel!
    @IBOutlet weak var menuTable : CommonTableView!
    
    @IBOutlet weak var logoutLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var bottomView : UIView!
    
    @IBOutlet weak var logoutIV: SecondaryImageView!
    @IBOutlet weak var bottomContentView: PrimaryView!
    @IBOutlet weak var contentBgView: SecondaryView!
    @IBOutlet weak var helloLbl: InactiveSubHeaderLabel!
    @IBOutlet weak var headerView : UIView!
    
        //MARK:- Actions
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.hideMenuAndDismiss()
    }
    
    
    
        //MARK:- life cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.menuVC = baseVC as? MenuVC
        self.initView()
        self.initGestures()
        self.ThemeUpdate()
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.showMenu()
    }
        //MARK:- initializers
    func initView(){
        self.bottomContentView.cornerRadius = 15
        self.logoutLbl.text = userDefaults.string(forKey: "user_id") == "10086" ? LangCommon.signIn : LangCommon.logout
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.avatarImage.isCurvedCorner = true
        }
        self.menuTable.tableHeaderView = self.headerView
        self.menuTable.tableFooterView = self.bottomView
        self.menuTable.layoutIfNeeded()
    }
    
    func ThemeUpdate() {
        self.menuTable.customColorsUpdate()
        self.darkModeChange()
        self.logoutIV.customColorsUpdate()
        self.logoutIV.tintColor = .PrimaryTextColor
        self.logoutLbl.customColorsUpdate()
        self.logoutLbl.textColor = .PrimaryTextColor
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.profileHeaderView.customColorsUpdate()
        self.avatarName.customColorsUpdate()
        self.helloLbl.customColorsUpdate()
        self.helloLbl.text = LangCommon.hello
        self.helloLbl.font = self.isDarkStyle ?
        AppTheme.Fontlight(size: 16).font :
        AppTheme.Fontbold(size: 16).font
        self.walletBalanceLbl.customColorsUpdate()
        self.bottomContentView.customColorsUpdate()
        self.menuVC.commonAlert.ThemeChange()
        self.menuTable.reloadData()
        self.contentBgView.customColorsUpdate()
        self.closeBtn.customColorsUpdate()
        self.headerView.backgroundColor = .green
    }
    
    @IBAction func topSettAct(_ sender:UIButton){
        print("Sett")
        let _selectedItem = self.menuVC.menuItems[5]
        self.menuVC.menuDelegate?.routeToView(_selectedItem.viewController!)
        self.menuVC.dismiss(animated: false, completion: nil)
    }
    
    func initGestures(){
        self.profileHeaderView.addAction(for: .tap) {
        }
        self.sideMenuHolderView.addAction(for: .tap) {
            self.hideMenuAndDismiss()
        }
        self.bottomContentView.addAction(for: .tap) {
            if userDefaults.string(forKey: "user_id") == "10086" {
                self.menuVC.sharedAppdelegate.showAuthenticationScreen()
            } else {
                self.menuVC.presentAlertWithTitle(title: appName, message: LangCommon.rUSureToLogOut, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                    (optionss) in
                    switch optionss {
                        case 0:
                            self.menuVC.callLogoutAPI()
                        case 1:
                            self.hideMenuAndDismiss()
                                //self.menuVC.dismiss(animated: false, completion: nil)
                        default:
                            break
                    }
                })
            }
        }
            //        self.settingIV.addAction(for: .tap) {
            //            let _selectedItem = self.menuVC.menuItems[7]
            //            self.menuVC.menuDelegate?.routeToView(_selectedItem.viewController!)
            //            self.menuVC.dismiss(animated: false, completion: nil)
            //        }
            //        self.settingIV.isHidden = true
        
            // MARK: ---------->  Views Having Same Guesture Menu Fun <-------
        let views = [avatarImage,
                     avatarName,
                     walletBalanceLbl]
        views.forEach { (view) in
            if let view = view {
                view.addAction(for: .tap) {
                    if userDefaults.string(forKey: "user_id") == "10086" {
                        self.menuVC.presentAlertWithTitle(title: appName, message: LangCommon.login, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                            (optionss) in
                            switch optionss {
                                case 0:
                                    self.menuVC.sharedAppdelegate.showAuthenticationScreen()
                                case 1:
                                    self.menuVC.dismiss(animated: true)
                                        //self.menuVC.dismiss(animated: false, completion: nil)
                                default:
                                    break
                            }
                        })
                    } else {
                        guard let model = self.menuVC.accountViewModel else {return}
                        let propertyView : ViewProfileVC  = .initWithStory(accountVM: model)
                        
                        self.menuVC.menuDelegate?.routeToView(propertyView)
                        
                        self.menuVC.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleMenuPan(_:)))
        self.sideMenuHolderView.addGestureRecognizer(panGesture)
        self.sideMenuHolderView.isUserInteractionEnabled = true
    }
        //MARK: UDF, gestures  and animations
    
    private var animationDuration : Double = 1.0
    private let aniamteionWaitTime : TimeInterval = 0.15
    private let animationVelocity : CGFloat = 5.0
    private let animationDampning : CGFloat = 2.0
    private let viewOpacity : CGFloat = 0.3
    func showMenu(){
        let isRTL = isRTLLanguage
        let rtlValue : CGFloat = isRTL ? 1 : -1
        let width = self.frame.width
        self.sideMenuHolderView.transform = CGAffineTransform(translationX: rtlValue * width,
                                                              y: 0)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
            self.sideMenuHolderView.transform = .identity
            self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
        }, completion: nil)
    }
    
    func hideMenuAndDismiss(){
        let isRTL = isRTLLanguage
        let rtlValue : CGFloat = isRTL ? 1 : -1
        let width = self.frame.width
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
            self.sideMenuHolderView.transform = CGAffineTransform(translationX: width * rtlValue,
                                                                  y: 0)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (val) in
            
            self.menuVC.dismiss(animated: false, completion: nil)
        }
        
        
    }
    @objc func handleMenuPan(_ gesture : UIPanGestureRecognizer){
        let isRTL = isRTLLanguage
        let _ : CGFloat = isRTL ? 1 : -1
        let translation = gesture.translation(in: self.sideMenuHolderView)
        let xMovement = translation.x
            //        guard abs(xMovement) < self.view.frame.width/2 else{return}
        var opacity = viewOpacity * (abs(xMovement * 2)/(self.frame.width))
        opacity = (1 - opacity) - (self.viewOpacity * 2)
        print("~opcaity : ",opacity)
        switch gesture.state {
            case .began,.changed:
                guard (isRTL && xMovement > 0) || (!isRTL && xMovement < 0) else {return}
                self.sideMenuHolderView.transform = CGAffineTransform(translationX: xMovement, y: 0)
                self.backgroundColor = UIColor.black.withAlphaComponent(opacity)
            default:
                let velocity = gesture.velocity(in: self.sideMenuHolderView).x
                self.animationDuration = Double(velocity)
                if abs(xMovement) <= self.frame.width * 0.25{//show
                    self.sideMenuHolderView.transform = .identity
                    self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
                }else{//hide
                    self.hideMenuAndDismiss()
                }
                
        }
    }
}
extension MenuView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.menuVC.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:MenuTCell.identifier ) as! MenuTCell
        guard let item = self.menuVC.menuItems.value(atSafe: indexPath.row) else{return cell}
        cell.ThemeUpdate()
        cell.lblName?.text = item.title
        if let image = item.imgName {
            cell.menuIcon?.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            cell.menuIcon?.clipsToBounds = true
            cell.menuIcon?.contentMode = .scaleAspectFit
        }else{
            cell.menuIcon?.image = nil
        }
        cell.menuIcon?.isHidden = true
        cell.lblName?.textAlignment = isRTLLanguage ? .right : .left
            // Handy Splitup Start
            // Delivery Splitup Start
        
        let selectedService = AppWebConstants.availableBusinessType.filter({$0.busineesType == AppWebConstants.businessType}).first
            // Handy Splitup End
            // Delivery Splitup End
        
        cell.contentView.addAction(for: .tap) {
            
            self.menuVC.dismiss(animated: false, completion: {
                let _selectedItem = self.menuVC.menuItems[indexPath.row]
                self.menuVC.dismiss(animated: false, completion: {
                    if let vc = _selectedItem.viewController {
                        if _selectedItem.title == LangCommon.settings {
                            self.menuVC.menuDelegate?.routeToView(vc)
                        } else {
                            if userDefaults.string(forKey: "user_id") == "10086" {
                                self.menuVC.presentAlertWithTitle(title: appName, message: LangCommon.loginToContinue, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                                    (optionss) in
                                    switch optionss {
                                        case 0:
                                            self.menuVC.sharedAppdelegate.showAuthenticationScreen()
                                        case 1:
                                            self.menuVC.dismiss(animated: true)
                                                //self.menuVC.dismiss(animated: false, completion: nil)
                                        default:
                                            break
                                    }
                                })
                            } else {
                                self.menuVC.menuDelegate?.routeToView(vc)
                            }
                        }
                    }else{
                        if cell.lblName?.text == LangCommon.manualBooking {
                            self.menuVC.menuDelegate?.callAdminForManualBooking()
                        } else if cell.lblName?.text == LangCommon.font {
                            self.menuVC.menuDelegate?.changeFont()
                        } else {
                            self.menuVC.menuDelegate?.openThemeActionSheet()
                        }
                        
                    }
                })
            })
            
        }
        cell.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuTCell else {return}
        cell.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        cell.holderView.cornerRadius = 15
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuTCell else {return}
        cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        cell.holderView.cornerRadius = 15
    }
    
}

