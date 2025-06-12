//
//  HandyHourlyTVC.swift
//  GoferHandy
//
//  Created by trioangle on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyHourlyTVC: UITableViewCell {

    @IBOutlet weak var timeBGView: SecondaryView!
    @IBOutlet weak var timeLbl : SecondarySmallBoldLabel!
    @IBOutlet weak var radioIV : PrimaryImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.timeBGView.cornerRadius = 19
        self.timeBGView.elevate(3)
        self.ThemeChange()
        // Initialization code
    }

    func ThemeChange() {
        self.timeBGView.customColorsUpdate()
        self.timeLbl.customColorsUpdate()
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
