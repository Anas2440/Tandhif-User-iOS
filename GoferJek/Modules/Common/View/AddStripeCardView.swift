//
//  AddStripeCardView.swift
//  GoferHandy
//
//  Created by trioangle on 30/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit
import Stripe
import PaymentHelper

class AddStripeCardView: BaseView {
    
    //MARK: Outlets
    @IBOutlet weak var doneBtn : PrimaryButton!
    @IBOutlet weak var headerVIew: HeaderView!
    @IBOutlet weak var pageTitle : SecondaryHeaderLabel!
    @IBOutlet weak var stripeCardTextField: UIView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var bottomView: TopCurvedView!
    
    
    lazy var cardTextField: STPPaymentCardTextField = {
            let cardTextField = STPPaymentCardTextField()
            return cardTextField
        }()
    
    var viewController:AddStripeCardVC!
    var stripeHandler : StripeHandler?
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? AddStripeCardVC
        self.stripeHandler = StripeHandler(self.viewController)
        self.initView()
        self.initStripeCardTextField()
        self.viewController.listen2Keyboard(withView: self.doneBtn)
        darkModeChange()
    }
    
    
    func initStripeCardTextField(){
   /*     let theme = STPTheme.default()
        view.backgroundColor = theme.primaryBackgroundColor
        stripeCardTextField.backgroundColor = theme.secondaryBackgroundColor
        stripeCardTextField.textColor = theme.primaryForegroundColor
        stripeCardTextField.placeholderColor = theme.secondaryForegroundColor
        //        cardTF.borderColor = theme.accentColor
        stripeCardTextField.borderWidth = 1.0
        stripeCardTextField.textErrorColor = theme.errorColor*/
        self.stripeCardTextField.cornerRadius = 15
        self.stripeCardTextField.clipsToBounds = true
        self.stripeCardTextField.addSubview(self.cardTextField)
        self.cardTextField.anchor(toView: self.stripeCardTextField,
                                  leading: 15,
                                  trailing: -15,
                                  top: 15,
                                  bottom: -15)
        self.cardTextField.postalCodeEntryEnabled = false
    }
    
    
    
    
    func initView(){
        self.doneBtn.setTitle(LangCommon.done, for: .normal)
      

//        self.backBtn.setTitle(nil, for: .normal)
//        self.backBtn.setImage(UIImage(named: "back"), for: .normal)
        self.addAction(for: .tap) {
            self.endEditing(true)
        }
        
        
      
        if self.viewController.isToChangeCard{
//            self.pageTitle.text = "Change Credit or Debit Card".localize
            self.pageTitle.text = LangCommon.changeCreditDebit
        }else{
//            self.pageTitle.text = "Add Credit or Debit Card".localize
            self.pageTitle.text = LangCommon.addCreditDebit
        }
    }
    
    @IBAction func cardEditing(_ sender: STPPaymentCardTextField) {
        self.doneBtn.isUserInteractionEnabled = sender.isValid
        self.doneBtn.backgroundColor = sender.isValid ? .PrimaryColor : .TertiaryColor
    }
    
    
    @IBAction func doneAct(_ sender: UIButton) {
       
        self.endEditing(true)
        guard NetworkManager.instance.isNetworkReachable else { return}
        let cardTF = cardTextField
        dump(cardTF)
        /*cardTF.cardNumber == nil || cardTF.cvc == nil || cardTF.cardNumber!.count == 0 || cardTF.cvc!.count == 0 || cardTF.expirationYear == 0 || cardTF.expirationMonth == 0 || cardTF.cvc!.count < 3 */
        guard cardTF.isValid else{
            let enter_valid_details = LangCommon.enterValidCardDetails
            self.viewController.appDelegate.createToastMessage(enter_valid_details, bgColor: .black, textColor: .white)
            return
        }
        
        print(cardTF.cardNumber!)
            print(cardTF.cvc!)
        print(cardTF.expirationYear)
        print(cardTF.expirationMonth)
        self.viewController.wsToGetStripeCard(cardTF)
        
  
      
    }
    
    override func darkModeChange() {
        super.darkModeChange()
        self.headerVIew.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.stripeCardTextField.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
    }
}
