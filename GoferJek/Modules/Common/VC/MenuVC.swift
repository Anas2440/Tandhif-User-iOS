//
//  MenuVC.swift
//  Gofer
//
//  Created by trioangle on 12/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

protocol MenuResponseProtocol {
    func routeToView(_ view : UIViewController)
    func callAdminForManualBooking()
    func openThemeActionSheet()
    func changeFont()
}
extension MenuResponseProtocol where Self : UIViewController{
    func callAdminForManualBooking() {
        self.checkMobileNumeber()
    }
    func openThemeActionSheet(){
        self.openThemeSheet()
    }
    func routeToView(_ view: UIViewController) {
        self.navigationController?.pushViewController(view, animated: true)
    }
    func changeFont() {
        self.openChangeFontSheet()
    }
}

class MenuVC: BaseViewController, PromoValuePassedProtocol {
    func promoCodeName(code: String) {
        
    }
    
    func promoUpdate(promoId: Int) {
        print("")
    }
    
    func promoDetailId(id: Int) {
    }
    
    func reloadPromo() {
    }
    
  
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    func onFailure(error: String,for API : APIEnums) {
        print(error)
    }
    
    @IBOutlet weak var menuView : MenuView!

    
    
    var menuItems = [MenuItemModel]()
    var menuDelegate : MenuResponseProtocol?
    var accountViewModel : AccountViewModel?
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableDataSources()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setprofileInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
   
    
    func initTableDataSources(){
        self.menuItems = self.getMenuItems()
        self.menuView.menuTable.reloadData()
    }
    func getGoferMenuItems() -> [MenuItemModel]{
        var goferItems = [MenuItemModel]()
        let paymentItem = MenuItemModel(withTitle: LangCommon.paymentStatus.capitalized, VC: SelectPaymentMethodVC.initWithStory())
        
        let tripView = HandyTripHistoryVC.initWithStory()
        //mainStory.instantiateViewController(withIdentifier: "TripsVC") as! TripsVC
        let listTripsItem = MenuItemModel(withTitle: LangCommon.yourBooking.capitalized, VC: tripView)
        
        let walletItem = MenuItemModel(withTitle: LangCommon.wallet, VC: WalletVC.initWithStory())
        
        let referralItem = MenuItemModel(withTitle: LangCommon.referral, VC: ReferalVC.initWithStory())
        
        let settingsView = SettingsVC.initWithStory(accountViewModel: self.accountViewModel!)
        settingsView.delegate = self
        let settingItem = MenuItemModel(withTitle: LangCommon.settings, VC:settingsView )
        
        let emergencyContactsView = EmergencyContactViewController.initWithStory()
        let emergencyContactItem  = MenuItemModel(withTitle: LangCommon.emergencyContacts, VC: emergencyContactsView)
        
        let contactAdmin = MenuItemModel(withTitle: LangCommon.manualBooking, VC: nil)
        let promoView = ProfilePromoCodeViewController.initWithStory(self)
        promoView.isFromMenu = true
        let promoItem = MenuItemModel(withTitle: LangCommon.promotions, VC: promoView)
      
        goferItems.append(paymentItem)
        goferItems.append(listTripsItem)
        goferItems.append(walletItem)
        goferItems.append(promoItem)
        goferItems.append(referralItem)
        goferItems.append(settingItem)
        goferItems.append(emergencyContactItem)
        goferItems.append(contactAdmin)
        
    
        return goferItems
    }
    
    func getMenuItems() -> [MenuItemModel] {
        var handyItems = [MenuItemModel]()
        
        let profileItem = MenuItemModel(withTitle: LangCommon.myProfile.capitalized,
                                        image: "profile-icon-select",
                                        VC: ViewProfileVC.initWithStory(accountVM: accountViewModel ?? AccountViewModel()))
        
        let paymentItem = MenuItemModel(withTitle: LangCommon.paymentStatus.capitalized,
                                        image: "Payment",
                                        VC: SelectPaymentMethodVC.initWithStory())
        
        let tripView = HandyTripHistoryVC.initWithStory()
//        tripView.newTap = .completed
        
        let listTripsItem = MenuItemModel(withTitle: LangCommon.yourBooking.capitalized,
                                          image: "Your Bookings",
                                          VC: tripView)
        
        let walletItem = MenuItemModel(withTitle: LangCommon.wallet,
                                       image: "wallet-icon-select",
                                       VC: WalletVC.initWithStory())
        
        let referralItem = MenuItemModel(withTitle: LangCommon.referral,
                                         image: "Invite Friends",
                                         VC: ReferalVC.initWithStory())
        
        let settingsView = SettingsVC.initWithStory(accountViewModel: self.accountViewModel ?? AccountViewModel())
        settingsView.delegate = self
        let settingItem = MenuItemModel(withTitle: LangCommon.settings,
                                        image: "settings_icon",
                                        VC: settingsView)
        
        let emergencyContactsView = EmergencyContactViewController.initWithStory()
        let emergencyContactItem  = MenuItemModel(withTitle: LangCommon.emergencyContacts,
                                                  image: "Emergency Contact",
                                                  VC: emergencyContactsView)
        
        let fontCheck = MenuItemModel(withTitle: LangCommon.font,
                                      image: "supportIcon",
                                      VC: nil)
        
        let themes = MenuItemModel(withTitle: LangCommon.theme,
                                   image: "supportIcon",
                                   VC: nil)
        let gojekHome = MenuItemModel(withTitle: LangCommon.backToHome,
                                      image: "home_location",
                                      VC: nil)
        
        if !isSingleApplication {
            handyItems.append(gojekHome)
        }
        
        let supportView = SupportVC.initWithStory()
        let supportItem = MenuItemModel(withTitle: LangCommon.support,
                                        image: "Support",
                                        VC: supportView)
        let promoView = ProfilePromoCodeViewController.initWithStory(self)
        promoView.isFromMenu = true
        let promoItem = MenuItemModel(withTitle: LangCommon.promotions , VC: promoView)
        
        // Handy Splitup Start
        // Delivery Splitup Start
        let selectedService = AppWebConstants.availableBusinessType.filter({$0.busineesType == AppWebConstants.businessType}).first
        
        let backToDeliveryAll = MenuItemModel(withTitle: "\(LangCommon.backTo) \(selectedService?.name ?? AppWebConstants.serviceName)",
                                              image: "home",
                                              VC: nil)
        
        if AppWebConstants.businessType == .DeliveryAll && !AppWebConstants.isDeliveryAllServicePage && !AppWebConstants.isSingleCatagoryApplication {
            handyItems.append(backToDeliveryAll)
        }
        // Delivery Splitup End
        // Handy Splitup End
        // Common Pages
        handyItems.append(profileItem)
        handyItems.append(listTripsItem)
        handyItems.append(paymentItem)
        handyItems.append(walletItem)
        handyItems.append(promoItem)
        handyItems.append(emergencyContactItem)
        handyItems.append(referralItem)
       
        // Handy Splitup Start
        if AppWebConstants.businessType != .DeliveryAll {
            // Handy Splitup End
            let contactAdmin = MenuItemModel(withTitle: LangCommon.manualBooking,
                                             image: "supportIcon",
                                             VC: nil)
            handyItems.append(contactAdmin)
            // Handy Splitup Start
        }
        // Handy Splitup End        handyItems.append(settingItem)
        if !Env.isLive() {
            handyItems.append(themes)
            handyItems.append(fontCheck)
        }
        handyItems.append(settingItem)
        
        if Shared.instance.supportArray?.count != 0 {
            handyItems.append(supportItem)
        }

        return handyItems
    }
    
    //MARK:- initWithStory
    class func initWithStory(_ delegate : MenuResponseProtocol,
                             accountViewModel : AccountViewModel?)-> MenuVC{
        
        let view : MenuVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.menuDelegate = delegate
        view.accountViewModel = accountViewModel
        
        return view
    }
    
  
    // MARK: LOGOUT API CALL
    /*
     */
    func callLogoutAPI() {
        self.accountViewModel?.callLogoutAPI() { result in
            switch result {
            case .success(_):
                self.removeAllNotication()
            case .failure(_):
                break
            }
        }
    }
    
    func removeAllNotication() {
        for observer in Shared.instance.notifObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        Shared.instance.notifObservers.removeAll()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.menuView.ThemeUpdate()
    }
    // AFTER USER LOGOUT, WE SHOULD RESET WORK/HOME LOCATION DETAILS

    func callDriverApp(){
  
        let instagramUrl = URL(string: "\(DriveriTunes().appName)://")
        if UIApplication.shared.canOpenURL(instagramUrl!)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"\(DriveriTunes().appName)://")!)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string:"\(DriveriTunes().appName)://")!)
            }
        } else {
            if let url = URL(string: "https://itunes.apple.com/us/app/\(DriveriTunes().appStoreDisplayName)/\(DriveriTunes().appID)?mt=8")
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    
}
extension MenuVC : SettingProfileDelegate,EditProfileDelegate{
    //MARK:- SettingProfileDelegate
    func setprofileInfo() {
        if Global_UserProfile != nil {
            self.menuView.avatarImage.sd_setImage(with: URL(string: Global_UserProfile.profileImage),
                                                  placeholderImage: UIImage(named:"user_dummy"))
            let walletAmount = UserDefaults.value(for: .wallet_amount) ?? ""
            let formattedWalletAmount = String(format: "%.2f", walletAmount.toDouble())
            
            self.menuView.walletBalanceLbl.text = "\(LangHandy.walletBalance.capitalized) " + Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG) + " \(formattedWalletAmount)"
            
            self.menuView.avatarName.text = Global_UserProfile.userName
        } else {
            self.menuView.avatarImage.image = UIImage(named:"user_dummy")
            self.menuView.avatarName.text = "Guest User"
        }
    }
}
