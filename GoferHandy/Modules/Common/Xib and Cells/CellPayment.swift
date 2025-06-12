//
//  CellPayment.swift
//  GoferHandy
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class CellPayment : UITableViewCell {
    @IBOutlet weak var lblTitle: SecondarySmallBoldLabel?
    @IBOutlet weak var lblSubTitle: SecondarySmallLabel?
    @IBOutlet weak var lblIconName: UILabel?
    @IBOutlet weak var lblAccessory: UILabel?
    @IBOutlet weak var iconIV: UIImageView!
    
    func ThemeChange() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lblAccessory?.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.lblSubTitle?.customColorsUpdate()
        self.lblTitle?.customColorsUpdate()
    }
}


