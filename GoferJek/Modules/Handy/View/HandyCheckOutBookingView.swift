//
//  HandyCheckOutBooking.swift
//  GoferHandy
//
//  Created by trioangle on 27/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyCheckOutBookingView: BaseView {
    
    enum CheckOutSections{
        case serviceItems
        case coupons
        case paymentMethods
        case location
        case promoCodes
    }
    var checkOutBookingVC :  HandyCheckOutBookingVC!
    var availableCheckOutSections : [CheckOutSections] =  [.serviceItems, .promoCodes, .location ]//, .coupons,.paymentMethods
    //MARK:- Outlets
    
    
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var chekOutTable : CommonTableView!
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var bookNowBtn : PrimaryButton!
    
    @IBOutlet weak var bookLaterTimeAndDateLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var bookLaterLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var topCurveView: TopCurvedView!
    @IBOutlet weak var bookLaterBGView: SecondaryView!
    @IBOutlet weak var paymentHolderView: UIView!
    @IBOutlet weak var indicatorImage: SecondaryTintImageView!
    // MARK:- Local Variable
    var isFirstTimeOnlyCalled : Bool = false
    var isUserLoc: Bool = true
    var isProvLoc : Bool = false
    var promoid:Int = 0
    var promoCode:String = ""

    
    override func darkModeChange() {
        super.darkModeChange()
        self.topCurveView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.changePaymentView.ThemeChange()
        self.indicatorImage.customColorsUpdate()
        self.bookLaterBGView.customColorsUpdate()
        self.bookLaterLbl.customColorsUpdate()
        self.bookLaterTimeAndDateLbl.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.chekOutTable.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.chekOutTable.reloadData()
        self.indicatorImage.backgroundColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    //MARK:- Actions
    @IBAction
    override func backAction(_ sender : UIButton){
        super.backAction(sender)
    }
    @IBAction
    func bookNowAction(_ sender : UIButton?){
        if userDefaults.string(forKey: USER_ID) == "10164" {
            self.checkOutBookingVC.presentAlertWithTitle(title: appName, message: LangCommon.loginToContinue, options: LangCommon.login.capitalized,LangCommon.cancel.capitalized, completion: {
                (optionss) in
                switch optionss {
                    case 0:                                                                    self.checkOutBookingVC.sharedAppdelegate.showAuthenticationScreen()
                    case 1:
                        self.checkOutBookingVC.dismiss(animated: true)
                            //self.menuVC.dismiss(animated: false, completion: nil)
                    default:
                        break
                }
            })
        } else {
            switch Shared.instance.currentBookingType {
                case .bookNow:
                    self.bookNowBtn.setTitle(LangHandy.bookNow, for: .normal)
                    if Shared.instance.isCovidEnabled {
                        self.checkOutBookingVC.navigateToCovid(bookingType: .bookNow)
                    } else {
                        self.checkOutBookingVC.navigateToRequest()
                    }
                case .bookLater(date: _, time: _):
                    self.bookNowBtn.setTitle(LangHandy.bookLater, for: .normal)
                    if Shared.instance.isCovidEnabled {
                        self.checkOutBookingVC.navigateToCovid(bookingType: .bookLater)
                    } else {
                        self.checkOutBookingVC.wsToRequest()
                    }
            }
        }
    }
    
    func setupPayment() {
        self.initPaymentView()
        self.changePaymentView.frame = self.changePaymentView.setFrame(self.paymentHolderView.frame)
        self.paymentHolderView.addSubview(self.changePaymentView)
        self.changePaymentView.anchor(toView: self.paymentHolderView,
                                      leading: 0,
                                      trailing: 0,
                                      top: 0,
                                      bottom: 0)
    }
    
    @IBAction func changeAction(_ sender : UIButton){
        self.checkOutBookingVC
            .navigateToChangePayment()
    }
    
    @IBAction func bookLaterEditBtnPressed(_ sender: Any) {
        self.checkOutBookingVC.navicateToBooking()
    }
    
    
    //MARK:- Variables
    
    var changePaymentView = ChangePaymentMethod.initViewFromXib()
    //MAKR:- life cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.checkOutBookingVC = baseVC as? HandyCheckOutBookingVC
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.setupPayment()
        
        switch Shared.instance.currentBookingType {
        case .bookNow:
            self.bookNowBtn.setTitle(LangHandy.bookNow, for: .normal)
        case .bookLater(date: _, time: _):
            self.bookNowBtn.setTitle(LangHandy.bookLater, for: .normal)
        }
        
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.titleLbl.setTextAlignment()
        self.initPaymentView()
    }
    //MARK:- initializers
    
    func initView(){
        self.chekOutTable.delegate = self
        self.chekOutTable.dataSource = self
        self.bookLaterTimeAndDateLbl.adjustsFontSizeToFitWidth = true
        self.bookLaterLbl.adjustsFontSizeToFitWidth = true
        self.bookLaterLbl.isHidden = true
    }
    func initLanguage(){
        self.titleLbl.text = LangCommon.bookingDetails
        self.titleLbl.textAlignment = .natural
        self.bookNowBtn.setTitle(LangHandy.bookNow, for: .normal)
    }
    func initGestures(){
        
        changePaymentView.changeBtn
            .addTarget(self,
                       action: #selector(changeAction(_:)),
                       for: .touchUpInside)
        bookLaterLbl.addAction(for: .tap) {
            self.bookLaterEditBtnPressed("")
        }
    }
    //MARK:- UDF
    
    func initPaymentView(){
        self.changePaymentView.changeBtn.addTarget(self,
                                                   action: #selector(changeAction(_:)),
                                                   for: .touchUpInside)
        self.changePaymentView.changeBtn.setTitle(LangCommon.change.capitalized ,
                                                  for: .normal)
        self.changePaymentView.ThemeChange()
        switch PaymentOptions.default {
            case .cash:
                changePaymentView.cashImg.image = UIImage(named:"cash_new")!.withRenderingMode(.alwaysTemplate)
                changePaymentView.cashLbl.text = LangCommon.cash.capitalized
            case .onlinepayment:
                changePaymentView.cashImg.image = UIImage(named:"onlinePay")!.withRenderingMode(.alwaysTemplate)
                changePaymentView.cashLbl.text = LangCommon.onlinePayment.capitalized
            case .paypal:
                changePaymentView.cashImg.image = UIImage(named:"paypal")!.withRenderingMode(.alwaysTemplate)
                changePaymentView.cashLbl.text = LangCommon.paypal.capitalized
            case .brainTree:
                changePaymentView.cashImg.image = UIImage(named:"braintree")!
                changePaymentView.cashLbl.text = UserDefaults.value(for: .brain_tree_display_name) ?? LangCommon.onlinePay
            case .stripe:
                changePaymentView.cashImg.image = UIImage(named:"stripe_card_new")!.withRenderingMode(.alwaysTemplate)
                changePaymentView.cashLbl.text = LangCommon.card.capitalized
                _ = UserDefaults.standard
                if let last4 : String = UserDefaults.value(for: .card_last_4),
                   let brand : String = UserDefaults.value(for: .card_brand_name),!last4.isEmpty{
                    changePaymentView.cashLbl.text  = "**** "+last4
                    changePaymentView.cashImg.image = self.checkOutBookingVC.getCardImage(forBrand: brand)
                }
            case .apple_pay:
                changePaymentView.cashImg.image = UIImage(named: "apple-pay")!.withRenderingMode(.alwaysTemplate)
                changePaymentView.cashLbl.text = "Apple Pay"//LangCommon.apple_pay.capitalized
            default:
                changePaymentView.cashImg.image = nil
                changePaymentView.cashLbl.text = LangCommon.selectPaymentMode.capitalized
        }
        let walletAmount = UserDefaults.value(for: .wallet_amount) ?? ""
        self.changePaymentView.walletStack.isHidden = !(
            Constants().GETVALUE(keyname: USER_SELECT_WALLET) == "Yes"
                && !walletAmount.toDouble().isZero)
        print("isWallet : \(self.changePaymentView.walletStack.isHidden)",Constants().GETVALUE(keyname: USER_SELECT_WALLET))
        self.changePaymentView.promoStack.isHidden = !(
            Constants().GETVALUE(keyname: USER_PROMO_CODE) != "0"
                && Constants().GETVALUE(keyname: USER_PROMO_CODE) != "")
        self.changePaymentView.promolbl.isHidden = true
        print("payment method : \(self.changePaymentView.promoStack.isHidden)  \(String(describing: PaymentOptions.default))")
        self.changePaymentView.layoutIfNeeded()
        self.layoutIfNeeded()
        self.changePaymentView.promoStack.isHidden = true
    }
    func onPromoCode() {
        self.changePaymentView.promoStack.isHidden = true
        self.changePaymentView.promolbl.isHidden = true
    }
    
    func setupBookLaterLbl() {
        switch Shared.instance.currentBookingType {
        case .bookNow:
            self.bookLaterBGView.isHidden = true
        case .bookLater(date: let date, time: let time):
            self.bookLaterBGView.isHidden = false
            self.bookLaterTimeAndDateLbl.text = date + " , " + time.value
            
        }
        
    }
    @objc func goToPromoPage(){
        let vc = ProfilePromoCodeViewController.initWithStory(self)
        vc.isFromPayment = true
        vc.payment_promo = self.promoid
        self.checkOutBookingVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func removePromo(){
        self.promoid = 0
        self.checkOutBookingVC.wsToGetPromo()
        self.chekOutTable.reloadData()
    }

    
}
//MARK:- UITableViewDataSource
extension HandyCheckOutBookingView : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.availableCheckOutSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let checkoutSection = self.availableCheckOutSections[section]
        switch checkoutSection {
        case .serviceItems:
            return self.checkOutBookingVC.serviceItemDataSource.count
        case .coupons:
            return 1
        case .paymentMethods:
            return 0
        case .location:
            return self.checkOutBookingVC.provider.serviceAtMylocation ? 2 : 1
        case .promoCodes:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let checkoutSection = self.availableCheckOutSections[section]
        switch checkoutSection {
        case .serviceItems:
            return 0
        case .coupons:
            return 0
        case .paymentMethods:
            return 40
        case .location:
            return 40
        case .promoCodes:
            return 30
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let holderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        holderView.isClippedCorner = true
        //holderView.elevate(2)
        holderView.backgroundColor = self.backgroundColor
        let lbl = UILabel()
        lbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .LightModeTextColor
        holderView.addSubview(lbl)
        lbl.font = AppTheme.Fontlight(size: 15).font
        lbl.anchor(toView: holderView,
                   leading: 8, trailing: 8, top: 2, bottom: 2)
        let checkoutSection = self.availableCheckOutSections[section]
        switch checkoutSection {
        case .serviceItems:
            return nil
        case .coupons:
            return nil
        case .paymentMethods:
            lbl.text = LangCommon.selectPaymentMode
            return holderView
        case .location:
            lbl.text = LangCommon.selectBookingLocation
            return holderView
        case .promoCodes:
            lbl.text  = LangCommon.promotions.capitalized
            return holderView
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let checkoutSection = self.availableCheckOutSections[section]
        if checkoutSection == .paymentMethods{
            return 80
        }else if checkoutSection == .serviceItems,
                 let type = self.checkOutBookingVC.serviceItemDataSource.first?.priceType,
                 [PriceType.distance,PriceType.hourly].contains(type){
            return UITableView.automaticDimension
        } else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        
        let checkoutSection = self.availableCheckOutSections[section]
        if checkoutSection == .paymentMethods{
            return 80
        }else if checkoutSection == .serviceItems,
                 let type = self.checkOutBookingVC.serviceItemDataSource.first?.priceType,
                 [PriceType.distance,PriceType.hourly].contains(type){
            return 60
        } else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let checkoutSection = self.availableCheckOutSections[section]
        if checkoutSection == .paymentMethods{
            let holderView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: tableView.bounds.width,
                                                  height: 80))
            self.changePaymentView.frame = CGRect(x: 10,
                                                  y: 10,
                                                  width: tableView.bounds.width - 20,
                                                  height: 60)
            holderView.addSubview(self.changePaymentView)
            holderView.backgroundColor = .clear
            holderView.layoutIfNeeded()
            return holderView
        }else if checkoutSection == .serviceItems,
                 let type = self.checkOutBookingVC.serviceItemDataSource.first?.priceType{
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            if type == .distance{
                //                lbl.text = "[ Note: Fare will vary based on distance ]"
            }else if type == .hourly{
                //                lbl.text = "[ Note: Fare will vary based on hours ]"
            }
            return lbl
        }
        return nil
    }
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checkoutSection = self.availableCheckOutSections[indexPath.section]
        switch checkoutSection {
        case .promoCodes:
            let cell : HandyPromoTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.ThemeUpdate()
//            cell.removePromo.setTitle(LangCommon.remove, for: .normal)
            if
                //let promoId:Int = UserDefaults.value(for: .promo_id),
                promoid != 0{
                cell.addPromoButton.setImage(UIImage(named: "edit_delivery")?.withRenderingMode(.alwaysTemplate), for: .normal)
//                cell.addPromoButton.setTitle(LangCommon.change, for: .normal)
                cell.promoStatusLabel.textAlignment = .center
                let attributerStr : NSMutableAttributedString = NSMutableAttributedString(string: "\(LangCommon.applied_promo.capitalized) \n \n \(self.promoCode)")
                attributerStr.setColorForText(textToFind: self.promoCode, withColor: .PrimaryColor)
                cell.promoStatusLabel.attributedText =  attributerStr
                cell.removePromo.isHidden = false
                cell.removeView.isHidden = false
            }else{
                cell.addPromoButton.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
//                cell.addPromoButton.setTitle(LangCommon.add, for: .normal)
                cell.promoStatusLabel.text = LangCommon.addPromoCode.capitalized
                cell.removePromo.isHidden = true
                cell.removeView.isHidden = true
            }
            cell.promoStatusLabel.setTextAlignment()
            cell.addPromoButton.addTarget(self, action: #selector(goToPromoPage), for: .touchUpInside)
            cell.removePromo.addTarget(self, action: #selector(removePromo), for: .touchUpInside)
            return cell
        case .serviceItems:
            let cell : HandyServiceItemTVC = tableView.dequeueReusableCell(for: indexPath)
            //cell.setPosition(totalItems: self.checkOutBookingVC.serviceItemDataSource.count,forIndex: indexPath)
            guard let item = self.checkOutBookingVC.serviceItemDataSource.value(atSafe: indexPath.row) else{return cell}
            let isLast = indexPath.row == (self.checkOutBookingVC.serviceItemDataSource.count - 1)
            let isFirst = indexPath.row == 0
            cell.ThemeUpdate()
            cell.populate(with: item, checkOutBookingVC: self.checkOutBookingVC,isLast: isLast)
            cell.barView.isHidden = isFirst //|| (isLast && self.checkOutBookingVC.serviceItemDataSource.count > 1 )
            self.layoutIfNeeded()
            return cell
        case .coupons:
            let cell : HandyPromoTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.ThemeUpdate()
            return cell
        case .paymentMethods:
            let cell : HandyPaymentRadioTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .location:
            let cell : HandyEndLocationTVC = tableView.dequeueReusableCell(for: indexPath)
            
            // Force RTL Done By Karuppasamy
            
            if isRTLLanguage {
                cell.atLocationLbl.textAlignment = .right
                cell.addressLbl.textAlignment = .right
            } else {
                cell.atLocationLbl.textAlignment = .left
                cell.addressLbl.textAlignment = .left
            }
            
            cell.radionIconIV.addAction(for: .tap) {
                if self.checkOutBookingVC.provider.serviceAtMylocation {
                    self.isUserLoc = !self.isUserLoc
                    self.isProvLoc = !self.isProvLoc
                } else {
                    self.isUserLoc = true
                }
                tableView.reloadData()
            }
            
            if  indexPath.row == 0 {
                
                cell.atLocationLbl.attributedText = NSMutableAttributedString()
                    .attributedString("\(LangHandy.atUserLocation)",
                                      foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                      fontWeight: .regular)
                cell.editIconIV.isHidden = false
                //                cell.atLocationLbl.addAction(for: .tap) {
                //                    self.checkOutBookingVC.navigateToSetLocation()
                //                }
                cell.editIconIV.addAction(for: .tap) {
                    self.checkOutBookingVC.navigateToSetLocation()
                }
                cell.ThemeUpdate()
                cell.addressLbl.attributedText = NSMutableAttributedString()
                    .attributedString(Global_UserProfile.address ,
                                      foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                      fontWeight: .regular)
                isFirstTimeOnlyCalled = true
                self.checkOutBookingVC.atProviderLoc = self.isProvLoc
                cell.radionIconIV.image = self.isUserLoc ? UIImage(named: "Radio_btn_selected") : UIImage(named: "Radio_btn_unselected")
            } else {
                
                let providerLocation : CLLocation = self.checkOutBookingVC.provider.location
                let userLocation : CLLocation = Global_UserProfile.currentCLLocation
                let distanceCheck = providerLocation.distance(from: userLocation) / 1000
                let strDistanceCheck = String(format: "%.2f", distanceCheck)
                print("distance from provider \(strDistanceCheck)")
                //                let distance = self.checkOutBookingVC.distanceBetweenUserAndProvider ?? 0.0
                //                let strDistance = String(format: "%.2f", distance)
                cell.atLocationLbl.attributedText = NSMutableAttributedString()
                    .attributedString("\(LangHandy.atProviderLocation)",
                                      foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                      fontWeight: .regular)
                
                cell.editIconIV.isHidden = true
                cell.atLocationLbl.addAction(for: .tap) { }
                cell.editIconIV.addAction(for: .tap) { }
                isFirstTimeOnlyCalled = false
                cell.ThemeUpdate()
                if distanceCheck < 1{
                    cell.addressLbl.attributedText = NSMutableAttributedString()
                        .attributedString("\(checkOutBookingVC.provider.providerLocation)",
                                          foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                          fontWeight: .regular)
                        .attributedString("\n● \(LangCommon.lessThanAkm)",
                                          foregroundColor: UIColor.init(named: "Green") ?? .ThemeTextColor,
                                          fontWeight: .regular)
                } else {
                    cell.addressLbl.attributedText = NSMutableAttributedString()
                        .attributedString("\(checkOutBookingVC.provider.providerLocation)",
                                          foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                          fontWeight: .regular)
                        .attributedString("\n● \(strDistanceCheck) \(LangHandy.kilometerAway)",
                                          foregroundColor: UIColor.init(named: "Green") ?? .ThemeTextColor,
                                          fontWeight: .regular)
                }
                self.checkOutBookingVC.atProviderLoc = self.isProvLoc
                cell.radionIconIV.image = self.isProvLoc ? UIImage(named: "Radio_btn_selected") : UIImage(named: "Radio_btn_unselected")
            }
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let checkoutSection = self.availableCheckOutSections[indexPath.section]
        guard checkoutSection == .serviceItems else {return}
        guard cell is  HandyServiceItemTVC else{return}
        
        //serviceCell.setPosition(totalItems: self.checkOutBookingVC.serviceItemDataSource.count,forIndex: indexPath)
        self.layoutIfNeeded()
    }
    
    
}
//MARK:- UITableViewDelegate
extension HandyCheckOutBookingView : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checkoutSection = self.availableCheckOutSections[indexPath.section]
        switch checkoutSection {
        case .promoCodes:break
        case .serviceItems:break
        case .coupons:break
        case .paymentMethods:break
        case .location:break
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let checkoutSection = self.availableCheckOutSections[indexPath.section]
        switch checkoutSection {
        case .promoCodes:
            return 90
        case .serviceItems:
            return UITableView.automaticDimension
        case .coupons:
            return UITableView.automaticDimension
        case .paymentMethods:
            return 60
        case .location:
            return UITableView.automaticDimension
            
        }
    }
    
}

extension HandyCheckOutBookingView:  PromoValuePassedProtocol {
    func promoCodeName(code: String) {
        self.promoCode = code
    }
    
    func promoUpdate(promoId: Int) {
        self.promoid = promoId
    }
    
    func promoDetailId(id: Int) {
        
    }
    
    func reloadPromo() {
        
    }
}
