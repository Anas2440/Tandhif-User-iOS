//
//  CellCountryTVC.swift
//  GoferHandy
//
//  Created by trioangle on 30/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class CellCountry : UITableViewCell
{
    @IBOutlet weak var lblTitle: SecondarySmallBoldLabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var holderView: UIView!
    
    func populateCell(with flag : CountryModel){
        self.ThemeChange()
        self.lblTitle?.text = flag.name
        self.imgFlag.image = flag.flag
    }
    
    func ThemeChange() {
        self.contentView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground :
            .SecondaryColor
        self.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground :
            .SecondaryColor
        self.lblTitle.customColorsUpdate()
        self.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
}
