//
//  HandyPromoTVC.swift
//  GoferHandy
//
//  Created by trioangle on 28/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyPromoTVC: UITableViewCell {

    
    @IBOutlet weak var BGView: SecondaryView!
    
    @IBOutlet weak var promoImageView: UIImageView!
    

    @IBOutlet weak var addPromoButton: primaryBgButton!
    @IBOutlet weak var promoStatusLabel: SecondaryDescLabel!
    
    @IBOutlet weak var removePromo: errorBgButton!
    @IBOutlet weak var removeView: UIView!
    
    func ThemeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.BGView.customColorsUpdate()
        promoStatusLabel.customColorsUpdate()
        removePromo.customColorsUpdate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        self.ThemeUpdate()
        self.addPromoButton.cornerRadius = 10
        self.addPromoButton.elevate(2)
        self.removePromo.cornerRadius = 10
        self.removePromo.elevate(2)
        self.addPromoButton.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.removePromo.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
