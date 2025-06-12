//
//  SelectPaymentMethodVC.swift
//  Gofer
//
//  Created by Trioangle on 27/11/18.
//  Copyright © 2018 Trioangle Technologies. All rights reserved.
//

import UIKit


protocol paymentMethodSelection : UpdateContentProtocol {
    func selectedPayment(method : PaymentOptions)
    func reloadWallet()
}


class SelectPaymentMethodVC: BaseViewController {
    
    //--------------------------------------
    // MARK: - Outlets
    //--------------------------------------
    @IBOutlet var selectPaymentMethodView: SelectPaymentMethodView!
    
    
    //--------------------------------------
    // MARK: - Local Variables
    //--------------------------------------
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let preference = UserDefaults.standard
    var paymentSelectionDelegate : paymentMethodSelection?
    var isFromWallect:Bool = false
    var canShowPaymentMethods = true
    var canShowWallet = true
    var canShowPromotion = true
    var isFromPlaceOrderPage = Bool()
    var isFromPaymentPage = false
    var isFromWallet : Bool {
        return self.canShowPaymentMethods && !self.canShowWallet && !canShowPromotion
    }
    
    //-------------------------------------------
    //MARK: view life cycle and Overide Functions
    //-------------------------------------------
    
    override
    var stopSwipeExitFromThisScreen: Bool?{
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Shared.instance.isBackFromPayment = true
    }
    override
    var preferredStatusBarStyle: UIStatusBarStyle{
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //--------------------------------------
    //MARK: - initWith Story
    //--------------------------------------
    
    class func initWithStory(showingPaymentMethods : Bool = true,
                             wallet : Bool = true,
                             promotions : Bool = false) -> SelectPaymentMethodVC{
        let view : SelectPaymentMethodVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.canShowPaymentMethods = showingPaymentMethods
        view.canShowWallet = wallet
        view.canShowPromotion = promotions
        return view
    }
    
    //--------------------------------------
    //MARK: - ws Funtions
    //--------------------------------------
    
    func onAPIComplete(_ response: ResponseEnum, for API: APIEnums) {
        
    }
    
    func wsToGetOptionList() {
        let uberLoader = UberSupport()
        uberLoader.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(for: .getPaymentOptions,
                           params: ["is_wallet":self.isFromWallet ? "1" : "0"])
            .responseDecode(to: PaymentList.self, { (paymentList) in
                uberLoader.removeProgressInWindow()
                self.selectPaymentMethodView.generateTableDataSource(with: paymentList)
            })
            .responseFailure({ (error) in
                uberLoader.removeProgressInWindow()
                debug(print: error)
            })
    }
    
    func updateApi() {
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym
        ConnectionHandler.shared
            .getRequest(for: .riderProfile,
                           params: param)
            .responseJSON({ (json) in
                if json.isSuccess {
                    self.wsToGetOptionList()
                } else {
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            }).responseFailure({ (error) in
                debug(print: error)
            })
    }
    
    //--------------------------------------
    // MARK: CALL API TO VIEW THE PROMO CODE
    //--------------------------------------
    
    func viewPromoCode() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        // Handy Splitup Start
        let param : JSON = ["business_id" : AppWebConstants.businessType.rawValue] // [:]
        // Handy Splitup End
        ConnectionHandler.shared
            .getRequest(for: .getPromoDetails,
                           params: param)
            .responseDecode(to: PromoContainerModel.self, { (container) in
                if let code: String = UserDefaults.value(for: .promo_applied_code),
                   container.promos.isEmpty || container.promos.filter({$0.code == code}).isEmpty {
                    UserDefaults.set(0, for: .promo_id)
                }
                UberSupport.shared.removeProgressInWindow()
            })
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                debug(print: error)
            })
    }
    //--------------------------------------
    // MARK: CALL API TO ADD THE PROMO CODE
    //--------------------------------------
    
    func onPromoCode(enteredPromo : String) {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.selectPaymentMethodView.addButton.isUserInteractionEnabled = false
        ConnectionHandler.shared
            .getRequest(for: APIEnums.addPromoCode,
                           params: ["code" : enteredPromo])
            .responseJSON({ (json) in
                if json.isSuccess{
                    print("Sucess")
                    self.selectPaymentMethodView.promoTxtField.text = ""
                    self.selectPaymentMethodView.addPromoView.isHidden = true
                    self.viewWillAppear(true)
                    self.selectPaymentMethodView.paymentTableView.reloadData()
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
                self.selectPaymentMethodView.addButton.isUserInteractionEnabled = true
                UberSupport.shared.removeProgressInWindow()
            })
            .responseFailure({ (error) in
                self.selectPaymentMethodView.addButton.isUserInteractionEnabled = true
                UberSupport.shared.removeProgressInWindow()
            })
    }
}





