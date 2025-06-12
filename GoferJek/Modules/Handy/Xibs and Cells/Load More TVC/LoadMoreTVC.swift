//
//  LoadMoreTVC.swift
//  GoferHandy
//
//  Created by trioangle on 09/03/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class LoadMoreTVC: UITableViewCell {
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var loadMoreBtn: PrimaryTextButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeUpdate()
        // Initialization code
    }

    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.bgView.customColorsUpdate()
        self.loadMoreBtn.customColorsUpdate()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
