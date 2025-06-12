//
//  HandyServiceItemTVC.swift
//  GoferHandy
//
//  Created by trioangle on 27/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyServiceItemTVC: GroupTableViewCell {

    @IBOutlet weak var addRemoveItemStack : UIStackView!
    
    @IBOutlet weak var serviceNameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var servicePriceLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var itemCountTF : commonTextField!
    
    @IBOutlet weak var addItemBtn : PrimaryTextButton!
    @IBOutlet weak var removeItemBtn : PrimaryTextButton!
    
    @IBOutlet weak var barView : UIView!
    
    
    func ThemeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.addItemBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.removeItemBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.cardView?.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.serviceNameLbl.customColorsUpdate()
        self.servicePriceLbl.customColorsUpdate()
        self.itemCountTF.customColorsUpdate()
        self.addItemBtn.customColorsUpdate()
        self.addItemBtn.tintColor = .PrimaryColor
        self.removeItemBtn.customColorsUpdate()
        self.removeItemBtn.tintColor = .PrimaryColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.addItemBtn.setTitle(nil, for: .normal)
        self.addItemBtn.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.addItemBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.removeItemBtn.setTitle(nil, for: .normal)
        self.removeItemBtn.setImage(UIImage(named: "Minus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.removeItemBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.addItemBtn.isRounded = true
        self.addItemBtn.elevate(2)
        self.removeItemBtn.isRounded = true
        self.removeItemBtn.elevate(2)
        // Initialization code
        self.ThemeUpdate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(with item : ServiceItem,checkOutBookingVC : HandyCheckOutBookingVC,isLast : Bool){
        if item.priceType == .hourly && isLast{
            self.serviceNameLbl.text = item.itemName + "\n" + "(Price may vary based on hours)"
        }else{
            self.serviceNameLbl.text = item.itemName
        }
        let currencySym = UserDefaults.value(for: .user_currency_symbol_org) ?? "$"
        var amount = String(format: "%.2f", item.calculatedAmount)
        
        if amount.contains("-"){
            amount = "- " + currencySym + " " + amount.replacingOccurrences(of: "-", with: "")
        }else{
            amount =  currencySym + " " + amount
        }
        self.servicePriceLbl.text = amount
        self.serviceNameLbl.textColor = (item.color == .black) ? self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor : .ThemeTextColor
        self.servicePriceLbl.textColor = (item.color == .black) ? self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor : .ThemeTextColor
        self.itemCountTF.text = item.selectedQuantity.description
        
        self.checkButtonStatus(for: item)
        
        self.addItemBtn.addAction(for: .tap) {
            if Double(item.selectedQuantity) < Double(item.maximumQuantity) ?? 0.0 {
                item.selectedQuantity += 1
            }
            checkOutBookingVC.generateDataSource()
        }
        self.removeItemBtn.addAction(for: .tap) {
            if item.selectedQuantity > 1{
                item.selectedQuantity -= 1
            }
            checkOutBookingVC.generateDataSource()
        }
        //hide contents based on price type
        self.addRemoveItemStack.isHidden = item.priceType != .fixed || Double(item.maximumQuantity) ?? 0 == 1
        self.addItemBtn.isHidden = false
        self.removeItemBtn.isHidden = false
        switch item.priceType {
        case .distance:
            self.addRemoveItemStack.isHidden = false
            self.addItemBtn.isHidden = true
            self.removeItemBtn.isHidden = true
            self.itemCountTF.text = LangCommon.minFare.capitalized
        case .fixed:
                self.addRemoveItemStack.isHidden = Double(item.maximumQuantity) ?? 0 <= 1
        case .hourly:
            self.addRemoveItemStack.isHidden = true
        case .none:
           // self.addRemoveItemStack.isHidden = true
        break
        }
       
    }
    func checkButtonStatus(for item : ServiceItem){
        //enable -ve when count is not 1
        self.removeItemBtn.setActive(item.selectedQuantity != 1)
        
        //enable +ve when count is not max
        self.addItemBtn.setActive(item.selectedQuantity != Int(item.maximumQuantity))
    }
}
