//
//  CellCurrency.swift
//  GoferHandy
//
//  Created by trioangle on 30/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class CellCurrency: UITableViewCell
{
    @IBOutlet var lblCurrency: SecondarySubHeaderLabel?
    @IBOutlet var imgTickMark: PrimaryBorderedImageView?
    
    func ThemeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lblCurrency?.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
}
