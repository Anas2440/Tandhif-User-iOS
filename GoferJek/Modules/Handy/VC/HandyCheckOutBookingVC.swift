//
//  HandyCheckOutBookingVC.swift
//  GoferHandy
//
//  Created by trioangle on 27/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyCheckOutBookingVC: BaseViewController {
    
    
    var provider : Provider!
    var distanceBetweenUserAndProvider : Double!
    @IBOutlet weak var checkOutBookingView : HandyCheckOutBookingView!
    
    var bookingVM : HandyJobBookingVM?
    var accountVM : AccountViewModel?
    
    var atProviderLoc = false
    var serviceItemDataSource = [ServiceItem]()
//    var popOverView : SuccessPopUpView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wsToGetPromo()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.generateDataSource()
        self.checkOutBookingView.setupBookLaterLbl()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //MARK:- intiWithStory
    class func initWithStory(for provider : Provider,
                             distanceBetweenUserAndProvider : Double?,
                             accountVM : AccountViewModel,
                             bookingVM: HandyJobBookingVM) -> HandyCheckOutBookingVC{
        let vc : HandyCheckOutBookingVC =  UIStoryboard.gojekHandyBooking.instantiateViewController()
        vc.provider = provider
        vc.distanceBetweenUserAndProvider = distanceBetweenUserAndProvider
        vc.bookingVM = bookingVM
        vc.accountVM = accountVM
        return vc
        
    }
    //MARK:- UDF
    func generateDataSource(){
        defer {
            self.checkOutBookingView.chekOutTable.reloadData()
        }
        self.serviceItemDataSource.removeAll()
        self.serviceItemDataSource.append(contentsOf: self.provider.bookedItems)
        guard self.serviceItemDataSource.isNotEmpty else{return}
        var editingTotal = self.serviceItemDataSource.compactMap({$0.calculatedAmount}).reduce(0, {$0 + $1})
        if
            //let promoId:Int = UserDefaults.value(for: .promo_id),
            checkOutBookingView.promoid != 0,
           let type:Int = UserDefaults.value(for: .promo_type) {
            if type == 1 {
                if let promoPercent : String = UserDefaults.value(for: .promo_applied_percent),
                   let maxAmountStr : String = UserDefaults.value(for: .max_price),
                   let maxAmount = Double(maxAmountStr) {
                    var promoDoubleAmount = self.calculatePercentage(value: editingTotal, percentageVal: promoPercent.toDouble())
                    if promoDoubleAmount > editingTotal {
                        promoDoubleAmount = editingTotal
                    }
                    if promoDoubleAmount > maxAmount {
                        promoDoubleAmount = maxAmount
                    }
                    editingTotal -= promoDoubleAmount
                    let item = ServiceItem(customWithName: "Promo",
                                           amount:  promoDoubleAmount.isZero
                                           ? "0.0".toDouble()
                                           : "-\(promoDoubleAmount)".toDouble(), priceType: .none,color: UIColor.ThemeTextColor)
                    self.serviceItemDataSource.append(item)
                }
            } else {
                if let promoAmount :String = UserDefaults.value(for: .promo_applied_amount){
                    var promoDoubleAmount = promoAmount.toDouble()
                    if promoDoubleAmount > editingTotal {
                        promoDoubleAmount = editingTotal
                    }
                    editingTotal -= promoDoubleAmount
                    let item = ServiceItem(customWithName: "Promo",
                                           amount:  promoDoubleAmount.isZero
                                           ? "0.0".toDouble()
                                           : "-\(promoDoubleAmount)".toDouble(), priceType: .none,color: UIColor.ThemeTextColor)
                    self.serviceItemDataSource.append(item)
                }
            }
        }
        
        
        if Constants().GETVALUE(keyname: USER_SELECT_WALLET) == "Yes",
           let walletAmount : String = UserDefaults.value(for: .wallet_amount){
            var walletDoubleAmount = walletAmount.toDouble()
            if !walletDoubleAmount.isZero {
                if walletDoubleAmount > editingTotal {
                    walletDoubleAmount = editingTotal
                }
                let item = ServiceItem(customWithName: "Wallet Amount",
                                       amount: walletDoubleAmount.isZero
                                       ? "0.0".toDouble()
                                       : "-\(walletDoubleAmount)".toDouble(),
                                       priceType: .none,
                                       color: .ThemeTextColor)
                self.serviceItemDataSource.append(item)
            }
            
        }
        if self.serviceItemDataSource.first?.priceType != .distance{
            let total = self.serviceItemDataSource.compactMap({$0.calculatedAmount}).reduce(0, {$0 + $1})
            let item = ServiceItem(customWithName: LangCommon.fareEstimation, amount: total,priceType: self.serviceItemDataSource.first?.priceType ?? .none,color: UIColor.black)
            self.serviceItemDataSource.append(item)
        }
    }
   func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    //MARK:- navigate
    func navigateToCalendar(){
//        self.navigationController?.pushViewController(HandyCalendarVC.initWithStory(),
//                                                      animated: true)
    }
    func navigateToSetLocation(){
        self.navigationController?.pushViewController(HandySetLocationVC
            .initWithStory(using: accountVM!,
                           with: self, showBookingType: false),
                                                      animated: true)
    }
    
    func navigateToCovid(bookingType: BookingType) {
        let vc = CovidAlertVC.initWithStory(self, bookingType: bookingType)
        self.present(vc, animated: true) {
            print("Success Fully Covid Alert Presented")
        }
    }
    
    func navigateToRequest(){
        let vc = HandyRequestVC
            .initWithStory(for: provider,
                           serivceAtUser: !self.atProviderLoc,
                           bookingVM: self.bookingVM!,
                           accountVM: self.accountVM!)
        vc .promoId = self.checkOutBookingView.promoid
        self.present(vc,
                     animated: false,
                     completion: nil)
    }
    func navigateToChangePayment(){
        let tripView = SelectPaymentMethodVC.initWithStory(showingPaymentMethods: true,
                                                           wallet: true,
                                                           promotions: false)
          tripView.paymentSelectionDelegate = self as paymentMethodSelection
          self.navigationController?.pushViewController(tripView, animated: true)
    }
  
  func navicateToBooking() {
    let calenderVC = HandyCalendarVC.initWithStory(for: self.provider, with: bookingVM!)
    self.navigationController?.pushViewController(calenderVC, animated: true)
  }
    //MARK:- WebServices
    func wsToGetPromo(){
        self.accountVM?.onPromoCode({ (result) in
            if result{self.checkOutBookingView.onPromoCode()}
            self.generateDataSource()
        })
        self.accountVM?.getPaymentList({ (result) in
            self.checkOutBookingView.initPaymentView()
        })
    }
    func wsToRequest(){
        Shared.instance.showLoader(in: self.view)
         self.bookingVM?
             .wsToBook(provider: self.provider,
                       atUserLocation: !self.atProviderLoc, promoId: self.checkOutBookingView.promoid) { (result) in
                        Shared.instance.removeLoader(in: self.view)
                        switch result{
                        case .success(let json):
                            print(json.description)
                            //TRVicky
                            if json.isSuccess{
                                self.commonAlert.setupAlert(alert: LangHandy.bookingRequested, alertDescription: json.status_message, okAction: LangCommon.ok, cancelAction: json.isSuccess ? " \(LangHandy.viewOnGoingJob) " : nil  , userImage: "tick_round")
                            } else {
                                self.commonAlert.setupAlert(alert: LangHandy.bookingRequested, alertDescription: json.status_message, okAction: LangCommon.ok, cancelAction: json.isSuccess ? " \(LangHandy.viewOnGoingJob) " : nil)
                            }
                            
                            if json.isSuccess {
                                self.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                                    self.setRootVC()
                                }
                                self.commonAlert.addAdditionalCancelAction {
                                    NotificationCenter.default
                                        .post(name: .HandyMoveToJobHistory,
                                              object: nil)
                                }
                            }
                           
//                            self.popOverView = SuccessPopUpView.getView(using: self.view)
//                            self.popOverView?.set(title: self.checkOutBookingView.language.bookingRequested,
//                                                  description: json.status_message)
//                            if json.isSuccess{
//
//                                self.popOverView?.addCancel(withTitle: self.checkOutBookingView.language.ok) {
//                                    self.navigationController?.popToRootViewController(animated: true)
//                                }
//                                self.popOverView?.addSuccess(withTitle: self.checkOutBookingView.language.viewOnGoingJob) {
//                                    NotificationCenter.default
//                                        .post(name: .HandyMoveToJobHistory,
//                                              object: nil)
//                                }
//
//                            }else{
//
//                                self.popOverView?.addCancel(withTitle: self.checkOutBookingView.language.ok) {
//                                }
//                            }
                            
                        case .failure(let error):
                            self.presentAlertWithTitle(
                                title: appName,
                                message: error.localizedDescription,
                                options: LangCommon.ok) { (_) in
                            }
                            
                        }
        }
     }
    
}
extension HandyCheckOutBookingVC : paymentMethodSelection{
    func selectedPayment(method: PaymentOptions) {
        
    }
    func reloadWallet() {
        
    }
    func updateContent() {
        
    }
    
    
}
extension HandyCheckOutBookingVC : HandySetLocationDelegate{
    func handySetLocation(didSetLocation location: MyLocationModel) {
        
        self.wsToUpdate(userLocation: location)
    }
    
    func handySetLocationDidCancel() {
        
    }
    
    func wsToUpdate(userLocation : MyLocationModel) {
        self.accountVM?
            .updateCurrentLocation(userLocation,
                                   result: { (updated) in
                guard updated else{ return }
                Global_UserProfile.address = userLocation.getAddress() ?? ""
                Global_UserProfile.currentLatitude = userLocation.coordinate.latitude.description
                Global_UserProfile.currentLongitude = userLocation.coordinate.longitude.description
                self.checkOutBookingView.chekOutTable.reloadData()
            })
    }
}


extension HandyCheckOutBookingVC : CovidDelegate {
    func wsToBookNow() {
        self.navigateToRequest()
    }
    
    func wsToBookLater() {
        self.wsToRequest()
    }
    
    func covidAlertCancelled() {
        print("Covid Alert Cancelled")
    }
}
