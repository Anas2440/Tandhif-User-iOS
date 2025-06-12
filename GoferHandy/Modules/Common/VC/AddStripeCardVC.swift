//
//  AddStripeCardVC.swift
//  Gofer
//
//  Created by Trioangle Technologies on 03/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Stripe

class AddStripeCardVC: BaseViewController{
   
    @IBOutlet var addStripeCardView: AddStripeCardView!
    
    
    let paymentVM  = PaymentViewModel()
    
    let appDelegate = AppDelegate()
    var updateDelegate : UpdateContentProtocol?
    let preference = UserDefaults.standard
    var isToChangeCard = false
 
    //MARK: View life cycles
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
    }
   
    

    //MARK: initialize VC
    class func initWithStory(_ delegate : UpdateContentProtocol) -> AddStripeCardVC{
        let view : AddStripeCardVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.updateDelegate = delegate
        return view
    }
    
    //MARK: Actions
    func wsToGetStripeCard(_ cardTF:STPPaymentCardTextField) {
        UberSupport().showProgressInWindow(showAnimation: true)
        self.paymentVM.getStripeCardAPI { (result) in
            switch result {
            
            case .success(let json):
                if json.isSuccess {
                    let stripeClientKey = json.string("intent_client_secret")
                    UberSupport().removeProgressInWindow()
                    self.createIntent(using: cardTF, forClient: stripeClientKey)
                } else {
                    UberSupport().removeProgressInWindow()
                }
                
                print("å::  Card's Status Code \(json.int("status_code"))")
//                if json.isSuccess{
//                    let stripeClientKey = json.string("intent_client_secret")
//                    UberSupport().removeProgressInWindow()
//                    self.createIntent(using: cardTF, forClient: stripeClientKey)
//                }
            case .failure(let error):
                UberSupport().removeProgressInWindow()
                debug(print: error)
            }
        }
    }
    
    
    func createIntent(using card : STPPaymentCardTextField,
                      forClient secret : String) {
        UberSupport().showProgressInWindow(showAnimation: true)
        self.addStripeCardView.stripeHandler?
            .setUpCard(textField: card,
                       secret: secret,
                       completion: { (result) in
                switch result{
                case .success(let token):
                    self.wsToUpdateCard(token: token)
                case .failure(let error):
                    debug(print: error.localizedDescription)
                    UberSupport().removeProgressInWindow()
                }
            })
    }
    
    func wsToUpdateCard(token : String){
        
        
        self.paymentVM.addStripeCardAPI(params: ["intent_id":token]) { (result) in
            UberSupport().removeProgressInWindow()
            switch result {
            
            case .success(let json):
                if json.isSuccess {
                    let data = try! NSKeyedArchiver.archivedData(withRootObject: json, requiringSecureCoding: false)
                    self.preference.set(json.string("last4"), forKey: "user_credit_card_sufix")
                    self.preference.set(json.string("brand"), forKey: "user_credit_card_brand")
                    
                    UserDefaults.set(json.string("last4"), for: .card_last_4)
                    UserDefaults.set(json.string("brand"), for: .card_brand_name)
                    UserDefaults.standard.set(data, forKey: "CardDetails")
                    
                    //                UserDefaults.standard.set(responseDict, forKey: "CardDetails")
                    
                    let outData = UserDefaults.standard.data(forKey: "CardDetails")
                    let dict = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(outData!) as! [String:Any]
                    //let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! [String:Any]
                    print(dict)
                    //                                                                SharedVariables.sharedInstance.cardDetailsDict = dict
                    
                    self.updateDelegate?.updateContent()
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print("∂",json.status_message)
                    self.appDelegate.createToastMessage(json.status_message, bgColor: UIColor.black, textColor: UIColor.white)
                }
            case .failure(let error):
                print("\(error.localizedDescription)")

//                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }

    }
}

extension UIViewController{
    func getCardImage(forBrand brand : String) -> UIImage{
        switch brand.capitalized{
        case "Visa".capitalized:
            return UIImage(named: "card_visa") ?? #imageLiteral(resourceName: "card_basic")
        case "MasterCard".capitalized:
            return UIImage(named: "card_master") ?? #imageLiteral(resourceName: "card_basic")
        case "Discover".capitalized:
            return UIImage(named: "card_discover") ?? #imageLiteral(resourceName: "card_basic")
        case "Amex".capitalized,"American Express".capitalized:
            return UIImage(named: "card_amex") ?? #imageLiteral(resourceName: "card_basic")
        case "JCB".capitalized,"JCP".capitalized:
            return UIImage(named: "card_jcp") ?? #imageLiteral(resourceName: "card_basic")
        case "Diner".capitalized,"Diners".capitalized,"Diners Club".capitalized:
            return UIImage(named: "card_diner") ?? #imageLiteral(resourceName: "card_basic")
        case "Union".capitalized,"UnionPay".capitalized:
            return UIImage(named: "card_unionpay") ?? #imageLiteral(resourceName: "card_basic")
        default:
            return UIImage(named: "card_basic") ?? #imageLiteral(resourceName: "card_basic")
        }
    }
}
extension UIView{
    func getCardImage(forBrand brand : String) -> UIImage{
        switch brand{
        case "Visa":
            return UIImage(named: "card_visa") ?? #imageLiteral(resourceName: "card_basic")
        case "MasterCard":
            return UIImage(named: "card_master") ?? #imageLiteral(resourceName: "card_basic")
        case "Discover":
            return UIImage(named: "card_visa") ?? #imageLiteral(resourceName: "card_basic")
        case "Amex","American Express":
            return UIImage(named: "card_visa") ?? #imageLiteral(resourceName: "card_basic")
        case "JCB","JCP":
            return UIImage(named: "card_master") ?? #imageLiteral(resourceName: "card_basic")
        case "Diner","Diners","Diners Club":
            return UIImage(named: "card_visa") ?? #imageLiteral(resourceName: "card_basic")
        case "Union","UnionPay":
            return UIImage(named: "card_master") ?? #imageLiteral(resourceName: "card_basic")
        default:
            return UIImage(named: "card_basic") ?? #imageLiteral(resourceName: "card_basic")
        }
    }
        
//
//                cardNumberLabel.text = "**** \(String(describing: getCardDetailDict["last4"]!))"
//                cardDetailsButtonOutlet.setTitle("Change", for: .normal)
//                addMoneyButtonOutlet.isUserInteractionEnabled = true
//                addMoneyButtonOutlet.alpha = 1.0
        
    
}
