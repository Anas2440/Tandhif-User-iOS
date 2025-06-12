//
//  HandySearchLocationTVC.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandySearchLocationTVC: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var lblTitle: SecondaryRegularLabel!
    @IBOutlet weak var lblSubTitle: InactiveRegularLabel!
    @IBOutlet weak var lblIcon: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.ThemeUpdate()
    }

    func ThemeUpdate() {
        lblTitle.customColorsUpdate()
        lblSubTitle.customColorsUpdate()
        self.lblIcon.textColor = self.isDarkStyle ? .DarkModeTextColor : .IndicatorColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
