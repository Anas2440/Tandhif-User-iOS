//
//  HandyEndLocationTVC.swift
//  GoferHandy
//
//  Created by trioangle on 28/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyEndLocationTVC: UITableViewCell {

    @IBOutlet weak var addressLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var radionIconIV : PrimaryImageView!
    @IBOutlet weak var atLocationLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var locationIconIV : UIImageView!
    @IBOutlet weak var editIconIV : PrimaryImageView!
    @IBOutlet weak var bgView: UIView!
    
    func ThemeUpdate() {
        self.bgView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.locationIconIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor        
        self.addressLbl.customColorsUpdate()
        self.atLocationLbl.customColorsUpdate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.locationIconIV.image = UIImage(named: "location_pin")?.withRenderingMode(.alwaysTemplate)
        self.locationIconIV.tintColor = .black
        self.editIconIV.image = UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate)
        self.editIconIV.tintColor = .black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
