//
//  JobImageCVC.swift
//  GoferHandy
//
//  Created by trioangle on 22/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class JobImageCVC: UICollectionViewCell {

    @IBOutlet weak var jobIV : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeUpdate()
        // Initialization code
    }

    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
}
