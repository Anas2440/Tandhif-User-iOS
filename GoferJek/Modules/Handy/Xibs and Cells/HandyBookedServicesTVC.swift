//
//  HandyBookedServicesTVC.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyBookedServicesTVC: UITableViewCell {
    
    @IBOutlet weak var serviceName: SecondarySubHeaderLabel!
    @IBOutlet weak var specialInstructionValueLbl: SecondaryRegularLabel!
    @IBOutlet weak var specialInstructionLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var serviceNameView: UIView!
    @IBOutlet weak var serviceBGView: UIView!
    @IBOutlet weak var serviceIconImage: PrimaryImageView!
    @IBOutlet weak var subCategoryLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var separatorLbl: UILabel!
    @IBOutlet weak var fareTypeLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var categoryLbl: SecondarySubHeaderLabel!
    @IBOutlet var TopConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var separatorLblConstraints: [NSLayoutConstraint]!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeUpdate()
        // Initialization code
    }
    
    func ThemeUpdate() {
        self.serviceBGView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.serviceName.customColorsUpdate()
        self.specialInstructionLbl.customColorsUpdate()
        self.specialInstructionValueLbl.customColorsUpdate()
        self.serviceIconImage.customColorsUpdate()
        self.serviceIconImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // self.instructionView.isHidden = true
    }
    func populate(with detail : RequestedService,expand : Bool? = nil, showQuantity : Bool,fareType : PriceType){
        self.ThemeUpdate()
        let serviceName = detail.name
        let serviceQuantityName = "( \(LangCommon.quantity) - \(detail.quantity))"
        var serviceTotalString = "\(serviceName)"
        if detail.quantity != 0 {
            serviceTotalString.append(" \(serviceQuantityName)")
        }
        //Setting attribute for quantity
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: serviceTotalString)
        attributedText.setFont(textToFind: serviceTotalString,
                               weight: .bold,
                               fontSize: 16)
        attributedText.setColorForText(textToFind: serviceName,
                                       withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
        
        if detail.quantity != 0{
            attributedText.setColorForText(textToFind: serviceQuantityName,
                                           withColor: .TertiaryColor)
        }
        
        self.serviceName.attributedText = attributedText
        
        if let _expand = expand{
            if !_expand {
                
                // MARK:- Function: Based on the RTl change the arrow Icon
                
                if isRTLLanguage {
                    self.serviceIconImage.transform = CGAffineTransform(
                        rotationAngle: .pi)
                }else{
                    self.serviceIconImage.transform = .identity
                }
                
                // MARK:- Function : Setting up the Views and Adding Details to Hide the Label
                
                self.instructionView.isHidden = true
                self.separatorLbl.isHidden = true
                self.specialInstructionValueLbl.text = nil
                self.specialInstructionLbl.text = nil
                self.separatorLbl.text = nil
                self.categoryLbl.text = nil
                self.subCategoryLbl.text = nil
                self.fareTypeLbl.text = nil
                
                // MARK:- Fucntion: Remove the Top Constraints To Setup the Unexpaned State
                
                for element in TopConstraints{
                    element.constant = 0.0
                }
                
            } else {
                
                // MARK:- Function : Setting up the Views and Adding the Details to the  Label for Showing
                
                self.serviceIconImage.isHidden = false
                self.separatorLbl.isHidden = false
                self.instructionView.isHidden = false
                self.serviceIconImage.transform = CGAffineTransform(rotationAngle: .pi/2)
                
                
                let categoryLblAttributedText = NSMutableAttributedString(
                    string: LangCommon.category
                        + " : "
                        + detail.service_name)
                categoryLblAttributedText.setFont(
                    textToFind: LangCommon.category
                        + " : "
                        + detail.service_name,
                    weight: .bold,
                    fontSize: 16)
                categoryLblAttributedText.setColorForText(
                    textToFind: LangCommon.category,
                    withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
                categoryLblAttributedText.setColorForText(
                    textToFind: detail.service_name,
                    withColor: .TertiaryColor)
                self.categoryLbl.attributedText = categoryLblAttributedText
                
                let subCategoryLblAttributedText = NSMutableAttributedString(
                    string: LangCommon.subCategory
                        + " : "
                        + detail.category_name)
                subCategoryLblAttributedText.setFont(
                    textToFind: LangCommon.subCategory
                        + " : "
                        + detail.category_name,
                    weight: .bold,
                    fontSize: 16)
                subCategoryLblAttributedText.setColorForText(
                    textToFind: LangCommon.subCategory,
                    withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
                subCategoryLblAttributedText.setColorForText(
                    textToFind: detail.category_name,
                    withColor: .TertiaryColor)
                self.subCategoryLbl.attributedText = subCategoryLblAttributedText
                
                
                let fareTypeLblAttributedText = NSMutableAttributedString(
                    string: LangCommon.fareType
                        + " : "
                        + fareType.rawValue)
                fareTypeLblAttributedText.setFont(
                    textToFind: LangCommon.fareType
                        + " : "
                        + fareType.rawValue,
                    weight: .bold,
                    fontSize: 16)
                fareTypeLblAttributedText.setColorForText(
                    textToFind: LangCommon.fareType,
                    withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
                fareTypeLblAttributedText.setColorForText(
                    textToFind: fareType.rawValue,
                    withColor: .TertiaryColor)
                self.fareTypeLbl.attributedText = fareTypeLblAttributedText
                
                // MARK:- Fucntion: Add the Top Constraints To Setup the Expaned State
                
                for element in TopConstraints{
                    element.constant = 10.0
                }
                
                // MARK:- Function : if Special instruction are presented it will Show otherwise label in hidden mode
                
                if detail.instruction.count > 0 {
                    self.specialInstructionLbl.isHidden = false
                    self.specialInstructionValueLbl.isHidden = false
                    self.specialInstructionValueLbl.text = detail.instruction
                    self.specialInstructionLbl.text = LangCommon.specialInstruction
                } else {
                    self.specialInstructionLbl.isHidden = true
                    self.specialInstructionValueLbl.isHidden = true
                }
            }
        }else{
            self.instructionView.isHidden = true
            self.specialInstructionValueLbl.text = detail.instruction
        }
        
        self.serviceBGView.border(width: 0.3,
                                  color: .TertiaryColor)
        self.serviceBGView.layer.cornerRadius = 10
        self.serviceBGView.elevate(2)
        
        
        //        AppUtilities().cornerRadiusWithShadow(view: self.serviceBGView)
        self.serviceName.setTextAlignment()
    }
    
}

