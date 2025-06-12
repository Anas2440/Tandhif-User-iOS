//
//  ProfilePromoView.swift
//  GoferHandy
//
//  Created by trioangle on 30/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation


protocol PaymentPromoProtocal {
    func promoUpdate(promoId:Int)
}

class ProfilePromoView: BaseView {

    
    var promoCodeVC:ProfilePromoCodeViewController!
    
 
    @IBOutlet var promoview: UIView!
    //@IBOutlet var promoviewheightconst: NSLayoutConstraint!
    
    @IBOutlet weak var headerView:HeaderView!
    @IBOutlet weak var titleLabel:SecondaryHeaderLabel!
    @IBOutlet weak var topCurvedView:TopCurvedView!
    @IBOutlet weak var promoTFHolderView: SecondaryView!
    @IBOutlet weak var promoAlertImageView:
    ThemeColorTintImageView!
    
    @IBOutlet weak var promoCodeView: TeritaryBackgroundView!
    @IBOutlet weak var promoCodeTF: commonTextField!
    @IBOutlet weak var applyPromoButtonOutlet: InvertedButton!
    @IBOutlet weak var promoDetailTableView: CommonTableView!
    @IBOutlet var promoCodeAlertView: SecondaryView!
    
   // @IBOutlet weak var promoCodeBottomCOnst: NSLayoutConstraint!
   // @IBOutlet weak var promoTableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var promoCodeAlertButtonOutlet: SecondaryButton!
    @IBOutlet weak var promoCodeAlertLabel: SecondarySubHeaderLabel!
    @IBOutlet var promoscrollheight: NSLayoutConstraint!
    @IBOutlet var backScrollview: UIScrollView!
    @IBOutlet var topview: SecondaryView!
    
    var overlayView = UIView()
    var reloadfrom = true
    var isLoading : Bool = true
    
    //MAKR:- Life Cycle
    override func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.titleLabel.customColorsUpdate()
        self.titleLabel.text = LangCommon.promotions.capitalized
        self.topCurvedView.customColorsUpdate()
        self.promoTFHolderView.customColorsUpdate()
        self.promoAlertImageView.customColorsUpdate()
        self.promoCodeView.customColorsUpdate()
        self.promoCodeTF.customColorsUpdate()
        self.promoCodeTF.setTextAlignment()
        self.promoCodeView.layer.cornerRadius = 8
        self.promoCodeTF.backgroundColor = .clear
        self.applyPromoButtonOutlet.customColorsUpdate()
        self.promoDetailTableView.customColorsUpdate()
        self.promoCodeAlertView.customColorsUpdate()
        self.promoCodeAlertButtonOutlet.customColorsUpdate()
        self.promoCodeAlertLabel.customColorsUpdate()
        self.topview.customColorsUpdate()
        self.promoDetailTableView.reloadData()
        
    }
    
    override func didLoad(baseVC: BaseViewController) {
        self.promoCodeVC = baseVC as? ProfilePromoCodeViewController
        super.didLoad(baseVC: baseVC)
        
        self.darkModeChange()
        self.initView()
    }
    override func willAppear(baseVC: BaseViewController) {
        self.initView()
        super.willAppear(baseVC: baseVC)
    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    
    func initView(){
        self.backScrollview.contentSize = CGSize(width: self.frame.width, height:200)
        self.promoscrollheight.constant = self.backScrollview.contentSize.height
        applyPromoButtonOutlet.elevate(2)
        applyPromoButtonOutlet.cornerRadius = 8
        if self.promoCodeVC.isFromMenu {
            applyPromoButtonOutlet.setTitle(" " + LangCommon.add + " ", for: .normal)
        } else {
            applyPromoButtonOutlet.setTitle(" " + LangCommon.apply + " ", for: .normal)
        }
        promoCodeAlertButtonOutlet.addTopBorderWithColor(color: UIColor.PrimaryColor, width: 1.0)
        promoCodeAlertButtonOutlet.setTitle(LangCommon.ok.uppercased(), for: .normal)
      
        self.promoAlertImageView.addAppImageColor(.alert, color: UIColor.PrimaryColor)
        self.promoCodeTF.placeholder = LangCommon.enterPromoCode
        self.promoCodeTF.setLeftPaddingPoints(10)
        self.promoCodeTF.setRightPaddingPoints(10)
        if promoCodeTF.text == "" {
            applyPromoButtonOutlet.alpha = 0.5
            applyPromoButtonOutlet.isUserInteractionEnabled = false
        } else {
            applyPromoButtonOutlet.alpha = 1.0
            applyPromoButtonOutlet.isUserInteractionEnabled = true
        }
        promoCodeTF.delegate = self
        self.promoDetailTableView.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.promoDetailTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    func loadData(){
        self.promoCodeAlertView.layer.cornerRadius = 25
        self.promoCodeAlertView.clipsToBounds = true
        self.promoCodeAlertView.elevate(5.0,shadowColor: .darkGray)
        
        
        self.topview.layer.cornerRadius = 25
        
        self.topview.clipsToBounds = true
        self.topview.elevate(5.0,shadowColor: .darkGray)
        

        
        self.promoCodeView.isRounded = true
        self.promoCodeView.border(width: 1,
                                  color: UIColor.IndicatorColor)
    }
    func reloadData() {
        self.promoDetailTableView.reloadData()
    }
    
    @IBAction func applyPromoButtonAction(_ sender: Any) {
        guard promoCodeTF.hasText else { return }
        self.endEditing(true)
        self.promoCodeVC.addPromoCode()
    }
    func addPromoHandle(_ responseDict:JSON){
        self.promoCodeTF.text = ""
        self.promoCodeTF.resignFirstResponder()
        if (responseDict.status_code) == 0 {
            self.applyPromoButtonOutlet.alpha = 0.5
            self.applyPromoButtonOutlet.isUserInteractionEnabled = false
            self.overlayView.frame = CGRect(x:0, y: 0, width:self.frame.width, height:self.frame.height)
            self.overlayView.backgroundColor = UIColor.black
            self.overlayView.alpha = CGFloat(0.5)
            _ = responseDict["status_message"] as? String
            self.promoCodeAlertLabel.text = LangCommon.invalidCode
            self.addSubview(self.overlayView)
            self.addSubview(self.promoCodeAlertView)
            self.promoCodeAlertView.center = self.overlayView.center
            self.overlayView.alpha = CGFloat(0.5)
            self.promoCodeView.alpha = CGFloat(1.0)
            appDelegate.createToastMessage(responseDict.status_message)
        } else {
            print(responseDict)
            if let promoDetails = responseDict["promo_details"] as? [[String : Any]] {
                self.promoCodeVC.promoValueDictArray.removeAll()
                // Handy Splitup Start
                if self.promoCodeVC.isFromPayment == true{
                    self.promoCodeVC.promoValueDictArray = promoDetails.filter({$0["business_id"] as! Int == AppWebConstants.businessType.rawValue})
                }else{
                    // Handy Splitup End
                    self.promoCodeVC.promoValueDictArray = promoDetails
                    // Handy Splitup Start
                }
                // Handy Splitup End
//                self.promoCodeVC.promoValueDictArray = promoDetails
                self.reloadfrom = true
                self.reloadData()
                self.applyPromoButtonOutlet.alpha = 0.5
                self.applyPromoButtonOutlet.isUserInteractionEnabled = false
            }
        }
    }
    
    @IBAction
    func promoBackAction(_ sender:Any) {
        self.promoCodeVC.exitScreen(animated: true) {
            self.promoCodeVC.delegate?.reloadPromo()
        }
    }
}


extension ProfilePromoView: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.hasText && textField.text?.count == 1 && string.count == 0 {
            applyPromoButtonOutlet.alpha = 0.5
            applyPromoButtonOutlet.isUserInteractionEnabled = false
        }
        else {
            applyPromoButtonOutlet.alpha = 1.0
            applyPromoButtonOutlet.isUserInteractionEnabled = true
        }
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func alertOKButtonAction(_ sender: Any) {
        
        overlayView.removeFromSuperview()
        promoCodeAlertView.removeFromSuperview()
        applyPromoButtonOutlet.alpha = 0.5
        applyPromoButtonOutlet.isUserInteractionEnabled = false
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.promoCodeVC.promoValueDictArray.count
        if count == 0 && !(self.isLoading) {
            let lbl = SecondaryRegularLabel()
            lbl.customColorsUpdate()
            lbl.text = LangCommon.noDataFound
            lbl.setTextAlignment(aligned: .center)
            tableView.backgroundView = lbl
        } else {
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promoDetailTVC", for: indexPath) as! PromoDetailTVC
        let data = self.promoCodeVC.promoValueDictArray[indexPath.row]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            cell.backgroundColor = .clear
        }
        if self.promoCodeVC.promoValueDictArray[indexPath.row].int("type") == 0 {
            cell.offerDetailLabel.text = data.string("description")
            cell.offerDescriptionLabel.text = LangCommon.expiresOn + " " + data.string("expire_date")
        } else {
            cell.offerDetailLabel.text = data.string("description")
            cell.offerDescriptionLabel.text = LangCommon.expiresOn + " " + data.string("expire_date")
        }
        if !self.promoCodeVC.isFromMenu {
            cell.imageAppliedPromoIcon.isHidden = false
            if let id:Int = self.promoCodeVC.isFromPayment == true ?  self.promoCodeVC.payment_promo :  UserDefaults.value(for: .promo_id) {
                let id1 = self.promoCodeVC.promoValueDictArray[indexPath.row].int("id")
                //            cell.imageAppliedPromoIcon.isHidden = !(id == id1)
                cell.imageAppliedPromoIcon.image = id == id1 ? UIImage(named: "checkbox_selected")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "checkbox_unselected")?.withRenderingMode(.alwaysTemplate)
            } else {
                cell.imageAppliedPromoIcon.image = UIImage(named: "checkbox_unselected")?.withRenderingMode(.alwaysTemplate)
            }
        }
        cell.updateDesign()
        return cell
    }
    
    override
    func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if reloadfrom {
        promoDetailTableView.layer.removeAllAnimations()
        
        print("self.promoDetailTableView.contentSize.height",
              self.promoDetailTableView.contentSize.height)
               self.backScrollview.contentSize = CGSize(width: self.frame.width, height: self.promoDetailTableView.contentSize.height + 200)
               self.promoscrollheight.constant = self.backScrollview.contentSize.height
            UIView.animate(withDuration: 0.5) {
                self.updateConstraints()
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.promoCodeVC.isFromMenu {
            let selectedPromo = self.promoCodeVC.promoValueDictArray[indexPath.row]
            if !self.sharedVariable.isNonUser {
                if let id:Int = self.promoCodeVC.isFromPayment == true ?  self.promoCodeVC.payment_promo :  UserDefaults.value(for: .promo_id) {
                    let id1 = selectedPromo.int("id")
                    if id == id1{
                       // if self.promoCodeVC.isFromPayment == true{
                        self.promoCodeVC.exitScreen(animated: true) {
                        self.promoCodeVC.delegate?.promoUpdate(promoId: 0)
                      //  }else{
//                        UserDefaults.set(0, for: .promo_id)
                        UserDefaults.removeValue(for: .promo_applied_code)
                        UserDefaults.removeValue(for: .promo_expirey_date)
                        UserDefaults.removeValue(for: .promo_type)
                        UserDefaults.removeValue(for: .promo_applied_amount)
                        UserDefaults.removeValue(for: .promo_applied_percent)
                        UserDefaults.removeValue(for: .max_price)
                        self.promoCodeVC.delegate?.reloadPromo()
                        }
                        }else {
                            self.promoCodeVC.checkAvailablePromo(promoId: self.promoCodeVC.promoValueDictArray[indexPath.row].int("id"), index: indexPath.row, promoCode: self.promoCodeVC.promoValueDictArray[indexPath.row].string("code"))
                        }
                       // }
                    } else {
                        self.promoCodeVC.checkAvailablePromo(promoId: self.promoCodeVC.promoValueDictArray[indexPath.row].int("id"), index: indexPath.row, promoCode: self.promoCodeVC.promoValueDictArray[indexPath.row].string("code"))
                    }
                }else{
                    self.promoCodeVC.checkAvailablePromo(promoId: self.promoCodeVC.promoValueDictArray[indexPath.row].int("id"), index: indexPath.row, promoCode: self.promoCodeVC.promoValueDictArray[indexPath.row].string("code"))
                }
                self.reloadfrom = false
                self.reloadData()
                
            }
        }
    
    func setSavedPromo(_ promo:JSON) {
     //   UserDefaults.set(promo.int("id"), for: .promo_id)
        UserDefaults.set(promo.string("price"), for: .promo_applied_amount)
        UserDefaults.set(promo.string("code"), for: .promo_applied_code)
        UserDefaults.set(promo.string("expire_date"), for: .promo_expirey_date)
        UserDefaults.set(promo.int("type"), for: .promo_type)
        UserDefaults.set(promo.string("percentage"), for: .promo_applied_percent)
        UserDefaults.set(promo.string("max_price"), for: .max_price)
    }
    
}


