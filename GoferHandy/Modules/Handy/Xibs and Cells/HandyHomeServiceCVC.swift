//
//  HandyHomeServiceCVC.swift
//  GoferHandy
//
//  Created by Trioangle on 31/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HandyHomeServiceCVC: UICollectionViewCell {

    @IBOutlet weak var contentHolderView: SecondaryView!
    @IBOutlet weak var imageHolderView: SecondaryView!
    @IBOutlet weak var serviceIV: UIImageView!
    @IBOutlet weak var serviceNameLbl: SecondaryRegularBoldLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.themeChange()
        DispatchQueue.main.async {
            self.initLayer()
        }
    }

    func initLayer() {
        self.imageHolderView.cornerRadius = 10
        self.imageHolderView.clipsToBounds = true
        self.serviceIV.cornerRadius = 10
        self.imageHolderView.elevate(2)
    }
    
    func themeChange() {
        self.contentView.backgroundColor = .clear//!self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = .clear//self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentHolderView.backgroundColor = .clear//!self.isDarkStyle ? .DarkModeBackground : .SecondaryColor//.customColorsUpdate()
//        self.imageHolderView.customColorsUpdate()
        self.serviceNameLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .LightModeTextColor//.customColorsUpdate()
    }
    
}
