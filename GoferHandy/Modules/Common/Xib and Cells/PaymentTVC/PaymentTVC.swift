//
//  PaymentTVC.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PaymentTVC: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var rate: SecondaryHeaderLabel!
    @IBOutlet weak var currencySymbol: SecondaryHeaderLabel!
    @IBOutlet weak var serviceItem: SecondaryLargeLabel!
    @IBOutlet weak var dropDownImg: SecondaryTintImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ThemeUpdate()
        // Initialization code
    }

    func ThemeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.outerView.backgroundColor = UIColor.clear
        self.rate.customColorsUpdate()
        self.currencySymbol.customColorsUpdate()
        self.serviceItem.customColorsUpdate()
        self.borderView.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
