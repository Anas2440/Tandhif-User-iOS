//
//  WalletVC.swift
//  Gofer
//
//  Created by Trioangle Technologies on 16/11/17.
//  Copyright © 2017 Trioangle Technologies. All rights reserved.
//

import UIKit
import PaymentHelper

class WalletVC: BaseViewController,
                UITextFieldDelegate {
    
    @IBOutlet var walletView: WalletView!
    
    
    var statusMessage : String = ""
    var resultText = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var currency = ""
    var walletAmount = ""
    var brainTree : BrainTreeProtocol?
//    var paypalHandler : PayPalHandler?
    
    
    // MARK: - ViewController Methods
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.updateApi()
    }
    
    override
    var stopSwipeExitFromThisScreen: Bool?{
        return (!self.walletView.addAmountView.isHidden)
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK: init with story
    class func initWithStory()-> WalletVC {
        let walletVC : WalletVC = UIStoryboard.gojekCommon.instantiateViewController()
        return walletVC
    }
    
    func updateApi() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: "user_currency_org")
        let userCurrencySym = Constants().GETVALUE(keyname: "user_currency_symbol_org")
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym
        getGloblalUserDetail(params: param) { result in
            switch result {
            case .success(let profile):
                if profile.statusCode == "1" {
                    Constants().STOREVALUE(value: profile.walletAmount,
                                           keyname: "wallet_amount")
                    self.viewWillAppear(true)
                } else {
                    AppDelegate.shared.createToastMessage(profile.statusMessage)
                }
                UberSupport.shared.removeProgressInWindow()
            case .failure(let error):
                debug(print: error)
                UberSupport.shared.removeProgressInWindow()
            }
        }
        
//        ConnectionHandler.shared
//            .getRequest(for: .riderProfile,
//                           params: param)
//            .responseJSON({ (json) in
//                //let _ = DriverDetailModel(jsonForRiderProfile: json)
//                if json.isSuccess{
//                    let amount = json["wallet_amount"] as? String ?? "0"
//                    Constants().STOREVALUE(value: amount, keyname: "wallet_amount")
//                    self.viewWillAppear(true)
//                }else{
//                    AppDelegate.shared.createToastMessage(json.status_message)
//                }
//                UberSupport.shared.removeProgressInWindow()
//            }).responseFailure({ (error) in
//                UberSupport.shared.removeProgressInWindow()
//            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    

    func wsMethodWalletAmount(using payKey : String?){
        var params : [String : Any] = [
            "amount":self.walletView.amountField.text ?? "",
                                        "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"
        ]
        if let key = payKey{
            params["pay_key"] = key
        }
        let amount = self.walletView.amountField.text ?? ""
        let paymentType =  PaymentOptions.default?.paramValue.lowercased() ?? "cash"
        let token = self.walletView.preference.string(forKey: "access_token")!
        var mode = ""
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            mode = isDarkStyle ? "dark" : "light"
        } else {
            // Fallback on earlier versions
            mode = "light"
        }
        let UrlString = "\(APIUrl + APIEnums.webPayment.rawValue)?amount=\(amount)&payment_type=\(paymentType)&token=\(token)&pay_for=wallet&mode=\(mode)"
        let webVC = LoadWebKitView.initWithStory()
        webVC.strWebUrl = UrlString
        webVC.isFromTrip = false
        self.navigationController?.pushViewController(webVC, animated: true)
        self.walletView.hideView("")

    }
    
    //MARK:- BrainTreePaymetn
    func methodConvetCurrency(for amount : Double) {
        Shared.instance.showLoaderInWindow()
        ConnectionHandler.shared.getRequest(for: .currencyConversion,
                                               params: ["amount": amount,
                                                        "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"])
            .responseJSON({ json in
                if json.isSuccess {
                    self.handleCurrencyConversion(response: json.double("amount"),
                                                  currency: json.string("currency_code"),
                                                  key: json.string("braintree_clientToken"))
                } else {
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
                Shared.instance.removeLoaderInWindow()
            }).responseFailure({ error in
                print(error)
                Shared.instance.removeLoaderInWindow()
            })
    }
    
    func handleCurrencyConversion(response amount: Double,
                                  currency : String?,
                                  key : String ){
        switch PaymentOptions.default {
        case .brainTree:
            self.authenticateBrainTreePayment(for: amount, using: key)
        case .paypal:
//            self.paypalHandler?.makePaypal(payentOf: amount,
//                                           currency: currency ?? "USD",
//                                           for: .wallet)
            self.authenticatePaypalPayment(for: amount,currency: currency ?? "USD",using: key)
        default:
            break
        }
    }
    func authenticateBrainTreePayment(for amount : Double,using clientId : String){
        self.brainTree = BrainTreeHandler.default
        self.brainTree?.initalizeClient(with: clientId)
        self.view.isUserInteractionEnabled = false
        self.brainTree?.authenticatePaymentUsing(self,
                                                 email : UserDefaults.value(for: .user_email_id) ?? "test@email.com",
                                                 givenName :  UserDefaults.value(for: .first_name) ?? "Albin",
                                                 surname :  UserDefaults.value(for: .last_name) ?? "MrngStar",
                                                 phoneNumber :  UserDefaults.value(for: .phonenumber) ?? "123456",
                                                 for: amount) { (result) in
            self.view.isUserInteractionEnabled = true
            switch result{
            case .success(let token):
                self.wsMethodToUpdateWalletAmount(using: token.nonce)
            case .failure(let error):
                print("\(error.localizedDescription)")

//                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
    func authenticatePaypalPayment(for amount : Double,currency: String,using clientId : String){
        self.brainTree = BrainTreeHandler.default
        self.brainTree?.initalizeClient(with: clientId)
        self.view.isUserInteractionEnabled = false
        self.brainTree?.authenticatePaypalUsing(self,for: amount, currency: currency) { (result) in
            self.view.isUserInteractionEnabled = true
            switch result{
            case .success(let token):
                self.wsMethodToUpdateWalletAmount(using: token.nonce)
            case .failure(let error):
                print("\(error.localizedDescription)")

//                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
    func wsMethodToUpdateWalletAmount(using payKey : String?){
        Shared.instance.showLoaderInWindow()
        var params : [String : Any] = [
            "amount":self.walletView.amountField.text ?? "",
                                        "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"
        ]
        if let key = payKey{
            params["pay_key"] = key
        }
        
        ConnectionHandler.shared.getRequest(for: .addAmountToWallet,
                                               params: params)
            .responseJSON({ json in
                if json.isSuccess {
                    if json.status_code == 2 {
                        let intent = json.string("two_step_id")
                        self.initiate3DSecureValidaiton(for: intent)
                    } else {
                        self.walletView.hideView("")
                        self.updateApi()
                        self.appDelegate.createToastMessage(json.status_message)
                    }
                } else {
                    self.presentAlertWithTitle(title: appName.capitalized,
                                               message: json.status_message,
                                               options: LangCommon.ok) { (_) in
                    }
                }
                Shared.instance.removeLoaderInWindow()
            })
            .responseFailure({ error in
                print(error)
                self.presentAlertWithTitle(title: appName.capitalized,
                                           message: error,
                                           options: LangCommon.ok) { (_) in
                }
                Shared.instance.removeLoaderInWindow()
            })
    }
    
    func initiate3DSecureValidaiton(for intent : String){
        self.walletView.stripeHandler?.confirmPayment(for: intent, completion: { (stResult) in
            switch stResult{
            case .success(let token):
                self.wsMethodToUpdateWalletAmount(using: token)
            case .failure(let error):
                print("\(error.localizedDescription)")

                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        })
    }
    
    //GOTO WALLECT PAGE
    func gotoWalletPage()
    {
        let propertyView = WalletVC.initWithStory()
        self.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    // HIDE THE ADDWALLECT AMOUNT

    
    
}

extension WalletVC {//PayPalHandlerDelegate
    func paypalHandler(didComplete paymentID: String) {
        self.wsMethodToUpdateWalletAmount(using: paymentID)
    }
    
    func paypalHandler(didFail error: String) {
        self.appDelegate.createToastMessage(error)
    }
    
    
}
