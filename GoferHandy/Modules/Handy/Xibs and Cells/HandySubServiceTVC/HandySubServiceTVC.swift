//
//  HandySubServiceTVC.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandySubServiceTVC: GroupTableViewCell {

    @IBOutlet weak var nameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var descriptionLbl : SecondaryRegularLabel!
    @IBOutlet weak var priceLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var bookBtn : PrimaryButton!
    @IBOutlet weak var bookBtnView : PrimaryView!
    @IBOutlet weak var bookBtnImg : UIImageView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.selectionStyle = .none
        self.ThemeUpdate()
    }
    
    func ThemeUpdate() {
        self.contentView.backgroundColor = isDarkStyle ?
            .DarkModeBackground :
            .SecondaryColor
        self.bgView.backgroundColor = isDarkStyle ?
            .DarkModeBackground :
            .SecondaryColor
        self.nameLbl.customColorsUpdate()
        self.nameLbl.font = AppTheme.Fontlight(size: 16).font
        self.descriptionLbl.customColorsUpdate()
        self.priceLbl.customColorsUpdate()
        self.bookBtnView.customColorsUpdate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func populate(with serviceItem : ServiceItem){
        self.nameLbl.text = serviceItem.itemName
        self.descriptionLbl.text = serviceItem.itemDescription
        self.bgView.layer.cornerRadius = 10
//        self.priceLbl.text = serviceItem.baseFare.description
        self.priceLbl.text = String(format: "%.2f", serviceItem.baseFare)
    }
    
}
