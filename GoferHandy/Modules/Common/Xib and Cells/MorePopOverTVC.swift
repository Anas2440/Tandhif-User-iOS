//
//  MorePopOverTVC.swift
//  GoferHandy
//
//  Created by trioangle on 18/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit



class MorePopOverTVC: UITableViewCell {

    @IBOutlet weak var textLbl: SecondarySubHeaderLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTheme()
        self.selectionStyle = .none
        // Initialization code
    }

    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor  = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.textLbl.customColorsUpdate()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
