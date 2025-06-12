//
//  AddServiceTVC.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyAddServiceTVC: UITableViewCell {

    //MARK:-Outlets
    @IBOutlet weak var serviceBGView: SecondaryView!
    @IBOutlet weak var serviceIV : UIImageView!
    @IBOutlet weak var serviceNameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var addSerivceBtn : SecondaryBorderedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    func ThemeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.serviceBGView.customColorsUpdate()
        self.serviceNameLbl.customColorsUpdate()
        self.addSerivceBtn.customColorsUpdate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateCell(with category : Category){
        self.serviceNameLbl.text = category.categoryName
        self.serviceIV.sd_setImage(with: URL(string: category.categoryImage),
                                   completed: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.serviceIV.contentMode = .scaleToFill
            self.serviceIV.isRounded = true
            self.serviceIV.clipsToBounds = true
        }
        self.accessibilityHint = category.categoryID.description
        let text : String
        self.ThemeChange()
        if category.isSelected{
            text = LangCommon.added.capitalized
            self.addSerivceBtn.border(width: 0,
                                      color: .clear)
            self.addSerivceBtn.setTitleColor(.PrimaryTextColor, for: .normal)
            self.addSerivceBtn.backgroundColor = .PrimaryColor
        }else{
            text = LangCommon.add.capitalized
            self.addSerivceBtn.border(width: 1,
                                      color: .DarkModeBorderColor)
            self.addSerivceBtn.setTitleColor(.DarkModeBackground, for: .normal)
            self.addSerivceBtn.customColorsUpdate()
//            self.addSerivceBtn.backgroundColor = UIColor(hex: AppWebConstants.ServiceAddButtonBackgroundColor)
        }
        self.addSerivceBtn.setTitle(text,
                                    for: .normal)
    }
}
