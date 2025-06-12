//
//  CellCurrencyTVC.swift
//  GoferHandy
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
class CellCurrencyTVC : UITableViewCell
{
    @IBOutlet var lblTitle: SecondarySmallBoldLabel?
    @IBOutlet var selectedLabel: SecondarySmallBoldLabel?
    @IBOutlet var lblIconName: UILabel?
    @IBOutlet weak var imgLogo : UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgLogo?.isHidden = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgLogo?.isHidden = true
    }
    func ThemeChange() {
        self.lblTitle?.customColorsUpdate()
        self.selectedLabel?.customColorsUpdate()
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
}
