//
//  HandyDeliveryParcelTypeTVC.swift
//  GoferHandy
//
//  Created by trioangle on 07/11/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HandyDeliveryParcelTypeTVC: UITableViewCell {

    @IBOutlet weak var selectedImgView: PrimaryImageView!
    @IBOutlet weak var titleLbl: SecondaryRegularLabel!
    @IBOutlet weak var holderView: SecondaryView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTheme()
    }

    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        
        self.holderView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.selectedImgView.customColorsUpdate()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
