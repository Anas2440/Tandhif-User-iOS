//
//  SelectPaymentMethodView.swift
//  GoferHandy
//
//  Created by trioangle on 29/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class SelectPaymentMethodView : BaseView {
    
    //---------------------------
    // MARK: - Outlets
    //---------------------------
    
    @IBOutlet weak var curvedContentHolderView: TopCurvedView!
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var addPromoView: UIView!
    @IBOutlet weak var paymentTableView: CommonTableView!
    @IBOutlet weak var promoTxtField: commonTextField!
    @IBOutlet weak var promoTitle: PromoLabel!
    @IBOutlet weak var addButton: PrimaryButton!
    @IBOutlet weak var cancelButton: SecondaryButton!
    @IBOutlet weak var lblPayment: SecondaryHeaderLabel!
    @IBOutlet weak var promoBGView: TopCurvedView!
    
    //---------------------------
    // MARK: - Local Variables
    //---------------------------
    
    var selectPaymentMethodVC : SelectPaymentMethodVC!
    var wallectamount = ""
    var selectedPayment = ""
    let strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
    var arrpayment = [String]()
    var arrpaymentImages = [String]()
    var paymentDataSource = [PaymentTableSection]()
    var paymentList : PaymentList?
    
    //---------------------------
    // MARK: - override Function
    //---------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.selectPaymentMethodVC = baseVC as? SelectPaymentMethodVC
        self.initView()
        self.initLanguage()
        self.initNotification()
        self.darkModeChange()
    }
    
    override
    func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.selectPaymentMethodVC.updateApi()
        self.wallectamount = Constants().GETVALUE(keyname: USER_WALLET_AMOUNT)
        self.addButton.isUserInteractionEnabled = true
    }
    
    override
    func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
//        self.selectPaymentMethodVC.wsToGetOptionList()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.lblPayment.customColorsUpdate()
        self.curvedContentHolderView.customColorsUpdate()
        self.cancelButton.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.promoTitle.customColorsUpdate()
        self.promoTxtField.customColorsUpdate()
        self.paymentTableView.customColorsUpdate()
        self.promoBGView.customColorsUpdate()
        self.paymentTableView.reloadData()
    }
    
    //---------------------------
    // MARK: - Intial Function
    //---------------------------
    
    func initView() {
        self.cancelButton.cornerRadius = 15
        self.cancelButton.elevate(2)
        self.promoTxtField.cornerRadius = 15
        self.promoTxtField.border(width: 0.5,
                                  color: UIColor.TertiaryColor.withAlphaComponent(0.5))
        self.promoTxtField.setTextAlignment()
        self.promoTxtField.setLeftPaddingPoints(15)
        self.promoTxtField.setRightPaddingPoints(15)
        if #available(iOS 10.0, *) {
            self.promoTxtField.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            self.promoTxtField.keyboardType = .default
        }
        self.arrpayment = [LangCommon.cash.capitalized,
                           LangCommon.paypal.capitalized]
        self.arrpaymentImages = ["cash",
                                 "paypalnew"]
        self.promoTxtField.setTextAlignment()
    }
    
    func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide1), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func initLanguage() {
        self.lblPayment.text = LangCommon.paymentStatus
        self.promoTxtField.placeholder = LangCommon.enterPromoCode
        self.promoTitle.text = LangCommon.enterPromoCode
        self.addButton.setTitle(LangCommon.add.uppercased(),
                                for: .normal)
        self.cancelButton.setTitle(LangCommon.cancel.uppercased(),
                                   for: .normal)
    }
    
    //---------------------------
    // MARK: - Button Actions
    //---------------------------
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.endEditing(true)
        let oldColor = addPromoView.backgroundColor
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0.15,
                                options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1.5/3, animations: {
                self.addPromoView.backgroundColor = .clear
            })
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1, animations: {
                self.addPromoView.transform = CGAffineTransform(translationX: 0,
                                                                y: self.frame.size.height)
            })
        }, completion: { (_) in
            self.addPromoView.transform = .identity
            self.addPromoView.backgroundColor = oldColor
            self.addButton.isUserInteractionEnabled = true
            self.addPromoView.removeFromSuperview()
            self.addPromoView.transform = .identity
        })
      
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if self.promoTxtField.text != "" {
            self.promoTxtField.resignFirstResponder()
            self.addSubview(self.addPromoView)
            self.bringSubviewToFront(self.addPromoView)
            let oldColor = addPromoView.backgroundColor
            UIView.animateKeyframes(withDuration: 0.8,
                                    delay: 0.15,
                                    options: [.layoutSubviews], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 1.5/3, animations: {
                    self.addPromoView.backgroundColor = .clear
                })
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 1, animations: {
                    self.addPromoView.transform = CGAffineTransform(translationX: 0,
                                                                    y: self.frame.size.height)
                })
            }, completion: { (_) in
                self.addPromoView.backgroundColor = oldColor
                self.addButton.isUserInteractionEnabled = true
                self.addPromoView.removeFromSuperview()
                self.selectPaymentMethodVC.onPromoCode(enteredPromo: self.promoTxtField.text!)
                self.addPromoView.transform = .identity
            })
        } else {
            appDelegate.createToastMessage(LangCommon.enterPromoCode)
        }
    }
    
    //---------------------------
    // MARK: - Local Function
    //---------------------------
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: self.addPromoView)
    }
    
    @objc
    func keyboardWillHide1(notification: NSNotification) {
        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: self.addPromoView)
    }
    
    func onAddNewPromoTapped(){
        self.addPromoView.frame = CGRect(x: 0,
                                         y:0,
                                         width: self.frame.size.width,
                                         height: self.frame.size.height)
        self.addPromoView.isHidden = true
        self.addSubview(addPromoView)
        self.promoTxtField.text = nil
        self.addPromoView.transform = CGAffineTransform(translationX: 0,
                                                        y: self.frame.size.height)
        let oldColor = addPromoView.backgroundColor
        self.addPromoView.backgroundColor = .clear
        self.addPromoView.isHidden = false
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0,
                                options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1, animations: {
                self.addPromoView.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 2.5/3,
                               relativeDuration: 1, animations: {
                self.addPromoView.backgroundColor = oldColor
            })
        }, completion: nil)
    }
    //----------------------------------
    //MARK: Generating TableData Source
    //----------------------------------
    func generateTableDataSource(with paymentList : PaymentList){
        self.paymentList = paymentList
        /*
         * if from wallet screen : hide cash,prmotions,wallet
         * if from car list screen : Hide promotions
         */
        self.paymentDataSource = [PaymentTableSection]()
        
        //********** Payment method seciton **************
        _ = !self.selectPaymentMethodVC.canShowWallet &&
            !self.selectPaymentMethodVC.canShowPromotion
        if self.selectPaymentMethodVC.canShowPaymentMethods {
            var paymentMethodDatas = [PaymentTableData]()
            for option in paymentList.options{
                if (self.selectPaymentMethodVC.isFromPlaceOrderPage && option.option == .cash) {continue}
                
                let data = PaymentTableData(withName: option.value)
                data.isSelected = option.isDefault
                data.imageURL =  URL(string: option.icon)
                data.key = option.key
                // Handy Split Start
                if !(self.selectPaymentMethodVC.isFromPaymentPage && option.option == .cash && AppWebConstants.businessType == .Delivery) {
                    // Handy Split End
                    if option.option != .google_pay {
                        paymentMethodDatas.append(data)
                    }
                    // Handy Split Start
                }
                // Handy Split End
            }
            self.paymentDataSource.append(PaymentTableSection(withTitle: LangCommon.paymentMethod,
                                                              datas: paymentMethodDatas))
        }
        
        //********** Wallet seciton *************
        if self.selectPaymentMethodVC.canShowWallet {
            var use_wallet = ""
            let val = LangCommon.useWallet.uppercased()
            self.wallectamount = Constants().GETVALUE(keyname: USER_WALLET_AMOUNT)
            if self.wallectamount == "" {
                use_wallet = "\(val) \(self.strCurrency) 0.00"
            } else {
                use_wallet =  "\(val) \(self.strCurrency) \(self.wallectamount)"
            }
            let walletData = PaymentTableData(withName: use_wallet)
            walletData.image = UIImage(named: "wallet-icon-select")
            walletData.isSelected = Constants().GETVALUE(keyname: USER_SELECT_WALLET) == "Yes"
            self.paymentDataSource.append(PaymentTableSection(withTitle: LangCommon.wallet,
                                                              datas: [walletData]))
        }
        
        //********** Promotion seciton **************
        if self.selectPaymentMethodVC.canShowPromotion {
            var promotionDatas = [PaymentTableData]()
            if Constants().GETVALUE(keyname: USER_PROMO_CODE) != "" &&
                Constants().GETVALUE(keyname: USER_PROMO_CODE) != "0" {
                let promotion = PaymentTableData(withName: LangCommon.promotions)
                promotion.image = UIImage(named: "Promo")
                promotionDatas.append(promotion)
            }
            let addPromotion = PaymentTableData(withName: LangCommon.addPromoGiftCode)
            promotionDatas.append(addPromotion)
            self.paymentDataSource.append(PaymentTableSection(withTitle: LangCommon.promotions,
                                                              datas: promotionDatas))
        }
        self.paymentTableView.reloadData()
    }
}


//-------------------------------------
// MARK: - paymentTableView DataSource
//-------------------------------------

extension SelectPaymentMethodView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.paymentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = AppTheme.Fontbold(size: 16).font
        label.text = self.paymentDataSource[section].title
        label.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        label.textColor = .ThemeTextColor
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentDataSource[section].datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let header = self.paymentDataSource[indexPath.section]
        let data = header.datas[indexPath.row]
        switch header.title {
        case LangCommon.paymentMethod :
            let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellPaymentMethodTVC") as! CellPaymentMethodTVC
            let defOption = PaymentOptions.default?.paramValue ?? ""
            cell.titlePaymentTxt.text = data.name
            cell.paymentImg.sd_setImage(with: data.imageURL) { image, _, _, _ in
                cell.paymentImg.image = image?.withRenderingMode(.alwaysTemplate)
            }//.image = data.image
            cell.checboxIV.image = (defOption.uppercased() == data.key.uppercased())  ? UIImage(named: "tick11")?.withRenderingMode(.alwaysTemplate) : nil
            let selectedItem = self.paymentList?.didSelect(optionNamed: data.name)
            cell.chekBoxHolderView.isHidden = selectedItem?.key == "stripe_card"
            cell.changeBtn.isHidden = !(selectedItem?.key == "stripe")
            cell.changeBtn.addTarget(self,
                                     action: #selector(navigateToStripe(_:)),
                                     for: .touchUpInside)
            cell.selectionStyle = .none
            cell.ThemeUpdate()
            cell.checboxIV.tintColor = data.isSelected ? .PrimaryColor : .TertiaryColor
            return cell
        case LangCommon.wallet:
            let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellPaymentMethodTVC") as! CellPaymentMethodTVC
            cell.titlePaymentTxt.text = data.name
            cell.paymentImg.image = data.image?.withRenderingMode(.alwaysTemplate)
            cell.checboxIV.image = data.isSelected ? UIImage(named: "tick11")?.withRenderingMode(.alwaysTemplate) : nil
            let selectedItem = self.paymentList?.didSelect(optionNamed: data.name)
            cell.changeBtn.isHidden = !(selectedItem?.key == "stripe")
            cell.selectionStyle = .none
            cell.ThemeUpdate()
            cell.checboxIV.tintColor = data.isSelected ? .PrimaryColor : .TertiaryColor
            return cell
//        case LangCommon.promotions:
//            if indexPath.row == 0 && header.datas.count > 1 {
//                let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellPromoAppliedTVC") as! CellPromoAppliedTVC
//                cell.titleLabel.text = data.name
//                cell.imgTag.image = UIImage(named: "Promo")?.withRenderingMode(.alwaysTemplate)
//                cell.promoCountLabel.text = Constants().GETVALUE(keyname: USER_PROMO_CODE)
//                cell.lblArrowPromo.transform = isRTLLanguage ? CGAffineTransform(scaleX: -1, y: 1) : .identity
//                cell.selectionStyle = .none
//                cell.ThemeUpdate()
//                return cell
//            } else {
//                fallthrough
//            }
        default://ADD PromoCode
//            let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellAddNewPromoTVC") as! CellAddNewPromoTVC
//            cell.titleLabel.text = data.name
//            cell.titleLabel.setTextAlignment(.center)
//            cell.selectionStyle = .none
//            cell.ThemeUpdate()
            return UITableViewCell()
        }
    }
    
    @objc
    func navigateToStripe(_ sender: Any) {
        let vc = AddStripeCardVC.initWithStory(self.selectPaymentMethodVC)
        self.selectPaymentMethodVC.presentInFullScreen(vc,
                                                       animated: true,
                                                       completion: {
            self.selectPaymentMethodVC.wsToGetOptionList()
        })
    }
}


//-------------------------------------
// MARK: - paymentTableView Delegate
//-------------------------------------

extension SelectPaymentMethodView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let header = self.paymentDataSource[indexPath.section]
        let data = header.datas[indexPath.row]
        
        _ = !self.selectPaymentMethodVC.canShowPromotion && !self.selectPaymentMethodVC.canShowWallet
        switch header.title {
        case LangCommon.paymentMethod :
            let selectedItem = self.paymentList?.didSelect(optionNamed: data.name)
            if selectedItem?.key == "stripe_card"{
                let vc = AddStripeCardVC.initWithStory(self.selectPaymentMethodVC)
                self.selectPaymentMethodVC.presentInFullScreen(vc,
                                                               animated: true,
                                                               completion: {
                    self.selectPaymentMethodVC.wsToGetOptionList()
                })
            }else{
                selectedItem?.option.setAsDefault()
                self.selectPaymentMethodVC.paymentSelectionDelegate?.updateContent()
                self.selectPaymentMethodVC.exitScreen(animated: true)
            }
        case LangCommon.wallet :
            if Constants().GETVALUE(keyname: USER_SELECT_WALLET) == "Yes" {
                Constants().STOREVALUE(value: "No" , keyname: USER_SELECT_WALLET)
            } else {
                Constants().STOREVALUE(value: "Yes" , keyname: USER_SELECT_WALLET)
            }
            if let list = self.paymentList {
                self.generateTableDataSource(with: list)
            }else{
                self.selectPaymentMethodVC.wsToGetOptionList()
            }
            self.selectPaymentMethodVC.paymentSelectionDelegate?.updateContent()
            self.selectPaymentMethodVC.paymentSelectionDelegate?.reloadWallet()
        case LangCommon.promotions:
            if indexPath.row == 0 && header.datas.count > 1 {
//                let propertyView = PromotionsVC.initWithStory()
//                self.selectPaymentMethodVC.navigationController?.pushViewController(propertyView, animated: true)
            } else {
                fallthrough
            }
        default://Add Promo code
            print()
            self.onAddNewPromoTapped()
        }
    }
}


//-------------------------------------
// MARK: - AddStripeCardVC Delegate
//-------------------------------------

extension SelectPaymentMethodVC : UpdateContentProtocol {
    func updateContent() {
        self.wsToGetOptionList()
    }
}


//-------------------------------------
// MARK: - TextField Delegates
//-------------------------------------

extension SelectPaymentMethodView : UITextFieldDelegate {
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        self.addButton.isUserInteractionEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addButton.isUserInteractionEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered: String = string.components(separatedBy: cs).joined(separator: "")
        return string == filtered
        
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == " ") {
            return false
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}


//-------------------------------------
// MARK: - paymentTableView Cells
//-------------------------------------

class CellPaymentMethodTVC : UITableViewCell {
    
    //-------------------------------------
    // MARK: - Outlets
    //-------------------------------------
    
    @IBOutlet weak var checboxIV: UIImageView!
    @IBOutlet weak var titlePaymentTxt: SecondarySmallBoldLabel!
    @IBOutlet weak var paymentImg: UIImageView!
    @IBOutlet weak var changeBtn: PrimaryTextButton!
    @IBOutlet weak var chekBoxHolderView: UIView!
    @IBOutlet weak var lineLbl: UILabel!
    
    //-------------------------------------
    // MARK: - init The Cell
    //-------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.checboxIV.tintColor = .PrimaryColor
        self.ThemeUpdate()
    }
    
    //-------------------------------------
    // MARK: - Dark Theme Update Function
    //-------------------------------------
    
    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.titlePaymentTxt.customColorsUpdate()
        self.changeBtn.setTextAlignment()
        self.changeBtn.setTitle(LangCommon.change.capitalized,
                                for: .normal)
        self.paymentImg.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
}

class CellPromoAppliedTVC : UITableViewCell {
    
    //-------------------------------------
    // MARK: - Outlets
    //-------------------------------------
    
    @IBOutlet weak var promoCountLabel: UILabel!
    @IBOutlet weak var titleLabel: SecondarySmallBoldLabel!
    @IBOutlet weak var promoButoon: UIButton!
    @IBOutlet weak var imgTag: UIImageView!
    @IBOutlet weak var lblArrowPromo: UILabel!
    
    //-------------------------------------
    // MARK: - init The Cell
    //-------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ThemeUpdate()
    }
    
    //-------------------------------------
    // MARK: - Dark Theme Update Function
    //-------------------------------------
    
    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.titleLabel.customColorsUpdate()
        self.imgTag.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.imgTag.backgroundColor = .clear
    }
}


class CellAddNewPromoTVC : UITableViewCell {
    
    //-------------------------------------
    // MARK: - Outlets
    //-------------------------------------
    
    @IBOutlet weak var addNewPromoButton: UIButton!
    @IBOutlet weak var titleLabel: SecondarySmallBoldLabel!
    
    //-------------------------------------
    // MARK: - init The Cell
    //-------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ThemeUpdate()
        self.titleLabel.clipsToBounds = true
        self.titleLabel.cornerRadius = 15
    }
    
    //-------------------------------------
    // MARK: - Dark Theme Update Function
    //-------------------------------------
    
    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.titleLabel.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
        self.titleLabel.customColorsUpdate()
    }
}
