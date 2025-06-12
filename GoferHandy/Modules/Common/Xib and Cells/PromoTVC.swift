//
//  PromoTVC.swift
//  GoferHandy
//
//  Created by Trioangle on 18/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class PromoTVC: UITableViewCell {
    
    @IBOutlet weak var holderView: SecondaryView!
    @IBOutlet weak var promoLbl: SecondaryDescLabel!
    @IBOutlet weak var addBtn: primaryBgButton!
    @IBOutlet weak var removeBtn: errorBgButton!
    @IBOutlet weak var removeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        self.themeChange()
        self.promoLbl.textAlignment = isRTLLanguage ? .right : .left
    }
    
    func themeChange() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.holderView.customColorsUpdate()
        self.promoLbl.customColorsUpdate()
        self.addBtn.customColorsUpdate()
        self.addBtn.cornerRadius = 10
        self.removeBtn.customColorsUpdate()
        self.removeBtn.cornerRadius = 10
        self.addBtn.elevate(4)
        self.removeBtn.elevate(4)
        self.addBtn.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.removeBtn.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
