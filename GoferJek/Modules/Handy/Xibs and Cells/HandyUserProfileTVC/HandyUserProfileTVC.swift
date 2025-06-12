//
//  HandyUserProfileTVC.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyUserProfileTVC: UITableViewCell {
    @IBOutlet weak var profileIV : UIImageView!
    @IBOutlet weak var nameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var ratingStack : StarStackView!
    @IBOutlet weak var descriptionLbl : SecondaryRegularLabel!
    @IBOutlet weak var dropBtn : UIButton!
    @IBOutlet weak var dropIV : PrimaryImageView!
    @IBOutlet weak var barView : UIView!
    @IBOutlet weak var imageHolderView : UIView!
    @IBOutlet weak var bgVIew: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        self.ThemeUpdate()
    }
    func ThemeUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.bgVIew.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.nameLbl.customColorsUpdate()
        self.descriptionLbl.customColorsUpdate()
    }
    override func prepareForReuse() {
           super.prepareForReuse()
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
