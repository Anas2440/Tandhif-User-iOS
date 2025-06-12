//
//  HandyCalendarCVC.swift
//  GoferHandy
//
//  Created by trioangle on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyCalendarCVC: UICollectionViewCell {
    @IBOutlet weak var dateLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var dayLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var holderView : UIView!
    @IBOutlet weak var dateBGView: SecondaryView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeChange()
        self.holderView.cornerRadius = 10
        self.dateBGView.cornerRadius = 12
        // Initialization code
    }
    func ThemeChange() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.dateBGView.customColorsUpdate()
        self.dayLbl.customColorsUpdate()
        self.dateLbl.customColorsUpdate()
    }
    
}
