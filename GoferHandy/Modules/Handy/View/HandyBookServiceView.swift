//
//  HandyBookServiceView.swift
//  GoferHandy
//
//  Created by trioangle on 27/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyBookServiceView: BaseView {
    @IBOutlet weak var specialInstructionTextView: UITextView!
    @IBOutlet weak var addItemBtn: PrimaryButton!
    @IBOutlet weak var servicePriceLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var removeCartLbl: ErrorLabel!
    @IBOutlet weak var estimatedChargeTitleLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var estimatedChargePriceLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var hourlyChargePriceLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var hourlyChargeTitleLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var serviceChargeLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var baseFareView : UIView!
    @IBOutlet weak var baseFarePriceLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var baseFareTitleLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var maxCharLabel: ErrorLabel!
    @IBOutlet weak var topCurevedView: TopCurvedView!
    @IBOutlet weak var bottCurevedView: TopCurvedView!
    @IBOutlet weak var noteLbl : SecondaryRegularLabel!
    var bookServiceVC :  HandyBookServiceVC!
    var priceType:PriceType = .fixed
    var itemCount: Int = 1
      
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var estimatedChargeView: UIView!
    @IBOutlet weak var hourlyChargeView: UIView!
    @IBOutlet weak var serviceChargeView: UIView!
    @IBOutlet weak var viewMoreBtn : UIButton!
    //MARK:- Outlets
    @IBOutlet weak var countHolderView: PrimaryView!
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var specialInstructionTItleLbl: SecondarySmallLabel!
    @IBOutlet weak var serviceTypeDescriptionLbl: SecondaryRegularLabel!
    @IBOutlet weak var serviceTypeTitleLbl: SecondarySubHeaderLabel!
      
    @IBOutlet weak var itemCountLbl: PrimaryButtonLabel!
    @IBOutlet weak var minusBtn: PrimaryTextButton!
    @IBOutlet weak var plusBtn: PrimaryTextButton!
     @IBOutlet weak var ItemCountViewHeightConstraint: NSLayoutConstraint! // 40
    
    override
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.specialInstructionTextView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        super.darkModeChange()
        self.titleLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.bottCurevedView.customColorsUpdate()
        self.topCurevedView.customColorsUpdate()
        self.estimatedChargeTitleLbl.customColorsUpdate()
        self.estimatedChargePriceLbl.customColorsUpdate()
        self.hourlyChargePriceLbl.customColorsUpdate()
        self.hourlyChargeTitleLbl.customColorsUpdate()
        self.serviceChargeLbl.customColorsUpdate()
        self.servicePriceLbl.customColorsUpdate()
        self.baseFarePriceLbl.customColorsUpdate()
        self.baseFareTitleLbl.customColorsUpdate()
        self.noteLbl.customColorsUpdate()
        self.serviceTypeDescriptionLbl.customColorsUpdate()
        self.serviceTypeTitleLbl.customColorsUpdate()
        self.specialInstructionTItleLbl.customColorsUpdate()
        self.minusBtn.customColorsUpdate()
        self.plusBtn.customColorsUpdate()
        self.minusBtn.tintColor = .PrimaryColor
        self.plusBtn.tintColor = .PrimaryColor
    }
      //MARK:- Actions
    @IBAction
    override func backAction(_ sender : UIButton){
        super.backAction(sender)
    }
    @IBAction
    func addServiceAction(_ sender : UIButton?){
        guard let model = self.bookServiceVC.serviceItem else {
            return
        }
        
        model.specialServiceDescription = self.specialInstructionTextView.text
        model.selectedQuantity = itemCount
        self.bookServiceVC.updateOriginalData()
        
        self.bookServiceVC.navigationController?.popViewController(animated: true)
    }
    @IBAction
    func viewMoreAction(_ sender : UIButton){
     
    }
    @objc func onTappedPlusBtn(_ sender:UIButton) {
        self.itemCountChange(addOrRemoveItem: true)
    }
    
    @objc func onTappedMinusBtn(_ sender:UIButton) {
        self.itemCountChange(addOrRemoveItem: false)
    }
    
      //MAKR:- life cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.bookServiceVC = baseVC as? HandyBookServiceVC
        self.priceType = self.bookServiceVC.serviceItem.priceType
        self.initView()
        self.initLanguage()
        self.initGesture()
        darkModeChange()
    }
      
      //MARK:- initializers
      
    func initView() {
        self.titleLbl.setTextAlignment()
        self.plusBtn.setTitle(nil, for: .normal)
        self.plusBtn.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.plusBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.minusBtn.setTitle(nil, for: .normal)
        self.minusBtn.setImage(UIImage(named: "Minus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.minusBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.maxCharLabel.text = LangCommon.maxChar
        self.specialInstructionTextView.delegate = self
        if self.bookServiceVC.serviceItem.isSelected {
            let model = self.bookServiceVC.serviceItem!
            self.itemCount = model.selectedQuantity
            self.titleLbl.text = LangHandy.editCart
            self.removeCartLbl.text = LangHandy.removeItem
            self.addItemBtn.setTitle(LangHandy.editCart, for: .normal)
            self.specialInstructionTextView.text = model.specialServiceDescription
        } else {
            self.addItemBtn.setTitle(LangCommon.addItem, for: .normal)
            self.removeCartLbl.text = ""
            self.titleLbl.text = LangCommon.addItem
        }
        self.specialInstructionTextView.border(width: 1, color: .TertiaryColor)
        self.specialInstructionTextView.isClippedCorner = true
        self.serviceTypeTitleLbl.text = self.bookServiceVC.serviceItem.itemName
        serviceTypeDescriptionLbl.numberOfLines = 0
        if let description = self.bookServiceVC.serviceItem.itemDescription, !description.isEmpty{
            self.serviceTypeDescriptionLbl.text = description
            //            self.serviceTypeDescriptionLbl.numberOfLines = 1
            self.viewMoreBtn.isHidden = false
        }else {
            self.serviceTypeDescriptionLbl.text = ""
            self.viewMoreBtn.isHidden = true
        }
        
        
        
        self.viewMoreBtn.isHidden = true
        
        self.specialInstructionTItleLbl.text = LangHandy.addSpecialInfoBelow
        self.serviceChargeLbl.text = LangHandy.serviceCharge
        
        
        let minHours = self.bookServiceVC.serviceItem.minimumHours
        let baseFare = self.bookServiceVC.serviceItem.baseFare
        let baseFareStr = String(format: "%.2f", baseFare)
        let calculatedAmountStr = String(format: "%.2f", self.bookServiceVC.serviceItem.calculatedAmount)
        let perKM = self.bookServiceVC.serviceItem.perKilometer
        let perMin = self.bookServiceVC.serviceItem.perMins
        let minFare = self.bookServiceVC.serviceItem.minimumFare
        let currency = self.bookServiceVC.serviceItem.currencySymbol
        
        //        self.servicePriceLbl.text = "\(currency) \(self.bookServiceVC.serviceItem.baseFare.description)"
        self.servicePriceLbl.text = "\(currency)\(baseFareStr)"
        
        if self.priceType == PriceType.fixed && Int(self.bookServiceVC.serviceItem.maximumQuantity) ?? 0 > 1 {
            //            self.ItemCountViewHeightConstraint.constant = 40
            self.countHolderView.isHidden = false
        }else {
            //            self.ItemCountViewHeightConstraint.constant = 0
            self.countHolderView.isHidden = true
        }
        
        self.checkButtonStatus()
        
        
        switch self.priceType {
        case .fixed:
            self.hourlyChargeView.isHidden = true
            self.estimatedChargeView.isHidden = true
            self.lineLbl.isHidden = true
            self.baseFareView.isHidden = true
            self.noteLbl.isHidden = true
        case .hourly:
            self.hourlyChargeView.isHidden = false
            self.estimatedChargeView.isHidden = false
            self.lineLbl.isHidden = false
            self.baseFareView.isHidden = true
            
            
            self.baseFarePriceLbl.text = "\(currency)\(baseFareStr)"
            self.baseFareTitleLbl.text = LangCommon.baseFare.capitalized
            self.serviceChargeLbl.text = LangHandy.serviceChargePerHour.capitalized
            self.servicePriceLbl.text = "\(currency)\(baseFareStr)"
            self.estimatedChargeTitleLbl.text = LangCommon.fareEstimation.capitalized + "\n" + "(\(LangHandy.priceMayVaryBasedOnHours))"
            self.estimatedChargePriceLbl.text = "\(currency)\(calculatedAmountStr)"
            self.hourlyChargeTitleLbl.text = LangCommon.minimumHour
            self.hourlyChargePriceLbl.text = minHours.description
            self.noteLbl.isHidden = true
            self.noteLbl.text = "[ \(LangCommon.note.capitalized): \(LangHandy.fareWillVaryBasedOnHours) ]"
        case .distance:
            self.hourlyChargeView.isHidden = false
            self.estimatedChargeView.isHidden = false
            self.lineLbl.isHidden = true
            self.baseFareView.isHidden = false
            
            self.baseFarePriceLbl.text = "\(currency)\(baseFareStr)"
            self.baseFareTitleLbl.text = LangCommon.baseFare.capitalized
            self.serviceChargeLbl.text = LangCommon.minFare.capitalized
            self.servicePriceLbl.text = String(format: "\(currency)%.2f", minFare)
            self.estimatedChargeTitleLbl.text = LangCommon.perKM.capitalized
            self.estimatedChargePriceLbl.text = String(format: "\(currency)%.2f", perKM)
            
            self.hourlyChargeTitleLbl.text = LangCommon.perMin.capitalized
            self.hourlyChargePriceLbl.text = String(format: "\(currency)%.2f", perMin)
            
            
            self.noteLbl.isHidden = true
            self.noteLbl.text = "[ \(LangCommon.note.capitalized): \(LangHandy.fareWillVaryBasedOnDistance) ]"
        case .none:
            self.noteLbl.isHidden = true
            
        }
        
        self.specialInstructionTextView.text = self.bookServiceVC.serviceItem.specialServiceDescription.capitalized
        
    }

        func initLanguage(){
            
            self.viewMoreBtn.setTitle(LangCommon.viewLess, for: .selected)
            self.viewMoreBtn.setTitle(LangCommon.viewMore, for: .normal)
            
        }
    func initGesture(){
        self.plusBtn.addTarget(self, action: #selector(self.onTappedPlusBtn(_:)), for: .touchUpInside)
        self.minusBtn.addTarget(self, action: #selector(self.onTappedMinusBtn(_:)), for: .touchUpInside)
        self.viewMoreBtn.addAction(for: .tap) { [weak self] in
            guard let welf = self else{return}
            welf.viewMoreBtn.isSelected = !welf.viewMoreBtn.isSelected
            if welf.viewMoreBtn.isSelected{
                welf.viewMoreBtn.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
//                welf.serviceTypeDescriptionLbl.numberOfLines = 0
            }else{
                welf.viewMoreBtn.imageView?.transform = .identity
//                welf.serviceTypeDescriptionLbl.numberOfLines = 1
            }
        }
        
        self.removeCartLbl.addTap {
            self.bookServiceVC.serviceItem.specialServiceDescription = ""
            self.bookServiceVC.serviceItem.isSelected = false
            self.bookServiceVC.updateOriginalData()
            self.bookServiceVC.exitScreen(animated: true)
        }
    }

    //MARK:- UDF

    func checkButtonStatus(){
        //enable -ve when count is not 1
        self.minusBtn.setActive(itemCount != 1)
        
       //enable +ve when count is not max
       self.plusBtn.setActive(itemCount != Int(self.bookServiceVC.serviceItem.maximumQuantity))
    
        self.itemCountLbl.text = self.itemCount.description
    }
    ///true = add , false = remove
    private func itemCountChange(addOrRemoveItem : Bool) {
        if addOrRemoveItem{
            if itemCount < Int(self.bookServiceVC.serviceItem.maximumQuantity) ?? 0 {
                itemCount += 1
            }
        }else{
            if itemCount > 1{
                itemCount -= 1
            }
        }
        self.checkButtonStatus()
    
        let totalPrice = Double(itemCount) * (Double(self.bookServiceVC.serviceItem.baseFare) ?? 0 )
        let totalPriceDescription = String(format: "%.2f", totalPrice)
        self.servicePriceLbl.text = "\(self.bookServiceVC.serviceItem.currencySymbol)\(totalPriceDescription)"
    }
    
    
}


extension HandyBookServiceView : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        let newLength = textView.text.count + (text.count - range.length)
        if newLength < 250{
            return true
        }
        return false
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
