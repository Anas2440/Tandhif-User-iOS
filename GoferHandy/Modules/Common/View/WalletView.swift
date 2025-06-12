//
//  WalletView.swift
//  GoferHandy
//
//  Created by trioangle on 21/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
import PaymentHelper

class WalletView: BaseView {
    
    //MARK: --> Outlets <---
    @IBOutlet weak var imgWallet: UIImageView!
    @IBOutlet weak var changePaymentView: UIStackView!
    @IBOutlet weak var mainBGView: TopCurvedView!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var lblTitle: SecondaryHeaderLabel!
    @IBOutlet weak var lbltext: SecondaryRegularLabel!
    @IBOutlet weak var lblAmount: SecondaryHeaderLabel!
    @IBOutlet weak var addAmountView: UIView!
    @IBOutlet weak var addbuttn: PrimaryButton!
    @IBOutlet weak var amountField: commonTextField!
    @IBOutlet weak var scrollHolder: UIScrollView!
    @IBOutlet weak var viewNextHolder: TopCurvedView!
    @IBOutlet weak var topView: SecondaryView!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var PaymentTypeImage: UIImageView!
    @IBOutlet weak var PaymentTypeName: SecondaryRegularLabel!
    @IBOutlet weak var ChangeButton: TransperentButton!
    @IBOutlet weak var hideViewBtn: UIButton!
    @IBOutlet weak var EnterTheAmountLbl: SecondaryHeaderLabel!
    @IBOutlet weak var AddAmountBtn: PrimaryButton!
    @IBOutlet weak var currencyLabel: SecondaryTextFieldLabel!
    
    
    var walletVC : WalletVC!
    let strCurrency = Constants().GETVALUE(keyname: "user_currency_symbol_org")
    var stripeHandler : StripeHandler?
    let preference = UserDefaults.standard
    var selectedPaymentOption : PaymentOptions? = nil
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.lblTitle.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.topView.customColorsUpdate()
        self.mainBGView.customColorsUpdate()
        self.lbltext.customColorsUpdate()
        self.lblAmount.customColorsUpdate()
        self.viewNextHolder.customColorsUpdate()
        self.EnterTheAmountLbl.customColorsUpdate()
        self.currencyLabel.customColorsUpdate()
        self.PaymentTypeName.customColorsUpdate()
        self.amountField.customColorsUpdate()
        self.PaymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.imgWallet.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.walletVC = baseVC as? WalletVC
        self.initView()
        self.initLocalization()
        self.initAddAmountView()
        self.initGestures()
        self.initNotification()
    }
    
    override
    func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        if #available(iOS 10.0, *) {
            amountField.keyboardType = .asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
            amountField.keyboardType = .numberPad
        }
        self.amountField.delegate = self
        self.currencyLabel.text = strCurrency
        lblTitle.text = LangCommon.wallet
        lbltext.text = LangCommon.walletAmountIs
        let wallectamount = Constants().GETVALUE(keyname: "wallet_amount")
        let amount:Double = (wallectamount as NSString).doubleValue
        let wall_amt = String(format: "%.2f", amount)
        print("aaa\(wall_amt)")
        if wallectamount == "" {
            lblAmount.text = "\(strCurrency) 0"
        } else {
            lblAmount.text = "\(strCurrency) \(wall_amt)"
        }
    }
    
    override
    func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
        self.selectedPayment(method: PaymentOptions.default ?? .cash)
    }
    
    //MARK: ---> initializers <---
    func initView() {
        self.amountField.keyboardType = .decimalPad
//        let paypal_app_id = Constants().GETVALUE(keyname: USER_PAYPAL_APP_ID)
//        let environmentConfig : [AnyHashable : Any]
        self.stripeHandler = StripeHandler(self.walletVC)
        self.changePaymentView.isHidden = Shared.instance.isWebPayment
        self.AddAmountBtn.cornerRadius = 15
        self.addbuttn.cornerRadius = 15
    }
    func initLocalization(){
        self.borderLabel.backgroundColor = .PrimaryColor
        self.addbuttn.setTitle(LangCommon.addMoneytoWallet.uppercased(), for: .normal)
        self.AddAmountBtn.setTitle(LangCommon.addAmount.uppercased(), for: .normal)
        self.ChangeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        self.EnterTheAmountLbl.text = LangCommon.enterAmount
    }
    func initAddAmountView(){
        self.addAmountView.frame = self.frame
        self.addSubview(self.addAmountView)
        self.bringSubviewToFront(self.topView)
        self.addAmountView.addAction(for: .tap) {
            self.addAmountView.isHidden = true
            self.amountField.text = ""
            self.addbuttn.isUserInteractionEnabled = true
        }
        self.viewNextHolder.addAction(for: .tap) {
            
        }
        self.addAmountView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        addAmountView.isHidden = true
    }
    func initGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide1), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "WalletApi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWallet(_:)), name: NSNotification.Name(rawValue: "WalletApi"), object: nil)
    }
    
    
    @objc
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing(true)
    }
    
    @objc
    func updateWallet(_ notification: NSNotification) {
        if let amount = notification.userInfo?["wallet"] as? String {
            // do something with your image
            Constants().STOREVALUE(value: amount, keyname: "wallet_amount")
        }
    }
    //Show the keyboard
    @objc
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: self.addAmountView)
    }
    //Hide the keyboard
    @objc
    func keyboardWillHide1(notification: NSNotification) {
        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: self.addAmountView)
    }
    // MARK: When User Press Add Button
    @IBAction func AddbuttonTapped(_ sender: Any) {
        self.addAmountView.isHidden = false
        addAmountView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
        let oldColor = addAmountView.backgroundColor
        addAmountView.backgroundColor = .clear
        
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.addAmountView.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 2.5/3, relativeDuration: 1, animations: {
                self.addAmountView.backgroundColor = oldColor
            })
        }, completion: nil)
    }
    // MARK: When User Press AddWallect amount button
    @IBAction func AddMonenytoWallet(_ sender: Any) {
        self.endEditing(true)
        if let text = self.amountField.text,
            let amount = Double(text){
            if Shared.instance.isWebPayment{
                self.walletVC.wsMethodWalletAmount(using: nil)
            }
            else{
                if PaymentOptions.default == .stripe{
                    self.walletVC.wsMethodToUpdateWalletAmount(using: nil)
                }else{
                    self.walletVC.methodConvetCurrency(for: amount)
                }
            }
        } else {
             appDelegate.createToastMessage(LangCommon.amountFldReq, bgColor: UIColor.black, textColor: UIColor.white)
        }
    }
    @IBAction func ChangeAction(_ sender: UIButton) {
        let paymentPickingVC = SelectPaymentMethodVC.initWithStory(showingPaymentMethods: true, wallet: false, promotions: false)
        paymentPickingVC.paymentSelectionDelegate = self
        self.walletVC.presentInFullScreen(paymentPickingVC, animated: true, completion: nil)
    }
    
    @IBAction func hideView(_ sender: Any) {
        let oldColor = addAmountView.backgroundColor
        UIView.animateKeyframes(withDuration: 0.8, delay: 0.15, options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5/3, animations: {
                self.addAmountView.backgroundColor = .clear
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.addAmountView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
            })
        }, completion: { (_) in
            self.addAmountView.transform = .identity
            self.addAmountView.backgroundColor = oldColor
            self.addbuttn.isUserInteractionEnabled = true
            self.addAmountView.isHidden = true
            self.amountField.text = ""
        })
    }
}

extension WalletView : UITextFieldDelegate {
    //TEXT FIELD DELEGATE METHODS
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newLength = string.utf16.count - range.length
        
        if let text = amountField.text {
            newLength = text.utf16.count + string.utf16.count - range.length
        }
        
        let characterSet = NSMutableCharacterSet()
        characterSet.addCharacters(in: "1234567890")
        
        if string.rangeOfCharacter(from: characterSet.inverted) != nil || newLength > 4 {
            return false
        }
        return true
    }
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        self.addbuttn.isUserInteractionEnabled = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        if (text == "") {
            return true
        }
        else if (text != "") {
            self.checkNextButtonStatus()
        }
        else if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func checkNextButtonStatus() {
        addbuttn.backgroundColor = ((amountField.text?.count)! >= 0) ? .PrimaryColor : .TertiaryColor
        addbuttn.isUserInteractionEnabled = ((amountField.text?.count)!>0) ? true : false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true;
    }
}

extension WalletView : paymentMethodSelection {
    func reloadWallet() {
        
    }
    func selectedPayment(method: PaymentOptions) {
        self.ChangeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        self.addbuttn.isUserInteractionEnabled = true
        self.addbuttn.backgroundColor = .PrimaryColor
        switch method {
        case .stripe:
            preference.set(true, forKey: "user_stripe_default_wallet_payment")
            if let brand : String = UserDefaults.value(for: .card_brand_name),
                let last4 : String = UserDefaults.value(for: .card_last_4){
                self.PaymentTypeImage.image = self.walletVC.getCardImage(forBrand: brand)
                self.PaymentTypeName.text = "**** "+last4
            }else{
                fallthrough
            }
        case .paypal:
            preference.set(false, forKey: "user_stripe_default_wallet_payment")
            self.PaymentTypeImage.image = UIImage(named: "paypal")?.withRenderingMode(.alwaysTemplate)
            self.PaymentTypeName.text = LangCommon.paypal
        case .onlinepayment:
            preference.set(false, forKey: "user_stripe_default_wallet_payment")
            self.PaymentTypeImage.image = UIImage(named: "onlinePay")?.withRenderingMode(.alwaysTemplate)
            self.PaymentTypeName.text = LangCommon.onlinePayment
        case .brainTree:
            preference.set(true, forKey: "user_stripe_default_wallet_payment")
            self.PaymentTypeImage.image = UIImage(named: "braintree")?.withRenderingMode(.alwaysOriginal)//?.withRenderingMode(.alwaysTemplate)
            self.PaymentTypeName.text = UserDefaults.value(for: .brain_tree_display_name) ?? LangCommon.onlinePay
        default:
            self.PaymentTypeImage.image = nil
            self.PaymentTypeName.text = ""
            self.ChangeButton
                .setTitle(LangCommon.choosePaymentMethod,for: .normal)
            if !Shared.instance.isWebPayment{
                self.addbuttn.isUserInteractionEnabled = false
                self.addbuttn.backgroundColor = .TertiaryColor
            }
        }
    }
    
    func updateContent() {
        self.ChangeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        self.selectedPaymentOption = PaymentOptions.default
        if selectedPaymentOption == .cash{
            selectedPaymentOption = nil
        }
        self.selectedPayment(method: selectedPaymentOption ?? .cash)
    }
    
 
}
