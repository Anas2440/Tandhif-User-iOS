//
//  HandyProviderProfileTVC.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyProviderProfileTVC: UITableViewCell {

    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var profileIV : UIImageView!
    @IBOutlet weak var nameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var kilometerLbl : SecondaryRegularLabel!
    @IBOutlet weak var ratingValueLbl : UILabel!
    @IBOutlet weak var ratingHolderView : UIView!
    @IBOutlet weak var ratingLable : UILabel!
    //@IBOutlet var ratingStack : StarStackView!
    @IBOutlet weak var moreInfoBtn : TeritaryButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.bgView.cornerRadius = 19
        self.bgView.elevate(2)
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.bgView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.moreInfoBtn.customColorsUpdated()
        self.moreInfoBtn.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
        self.ratingHolderView.backgroundColor = .clear
        self.nameLbl.customColorsUpdate()
        self.kilometerLbl.customColorsUpdate()
    }
    func populate(with provider : Provider){
        
        // RTL Update For Instant RTL Changes
        self.nameLbl.setTextAlignment()
        self.kilometerLbl.setTextAlignment()
        
        self.ratingHolderView.isHiddenInStackView = provider.rating.isZero
        self.profileIV.sd_setImage(with: URL(string: provider.profilePicture),
                                   placeholderImage: UIImage(named: "user_dummy"),
                                   options: .highPriority,
                                   context: nil)
        self.nameLbl.text = provider.name
        self.kilometerLbl.text = provider.distance < 1 ? LangCommon.lessThanAkm : provider.distance.description + " " + LangHandy.kilometerAway
        if !provider.rating.isZero {
            let textAtt = NSMutableAttributedString()
                .attributedString("★ ",
                                  foregroundColor: .ThemeYellow,
                                  fontWeight: .bold,
                                  fontSize: 14)
                .attributedString("\(provider.rating)",
                                  foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                  fontWeight: .bold,
                                  fontSize: 14)
                .attributedString(" (\(provider.ratingCount) \(LangHandy.reviews)) ",
                                  foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                  fontWeight: .regular,
                                  fontSize: 12)
            ratingLable.attributedText = textAtt
        }
        self.moreInfoBtn.setTitle(LangCommon.moreInfo,
                                  for: .normal)
        self.moreInfoBtn.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                        left: 10,
                                                        bottom: 0,
                                                        right: 10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.moreInfoBtn.cornerRadius = 10
            self.profileIV.cornerRadius = 12
            self.profileIV.clipsToBounds = true
            self.profileIV.contentMode = .scaleAspectFill
        }
    }

    
}
