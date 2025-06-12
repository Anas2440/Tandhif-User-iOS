//
//  GalleryDetailCollectionViewCell.swift
//  GoferHandy
//
//  Created by trioangle on 23/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
class GalleryDetailCVC: UICollectionViewCell {
    @IBOutlet weak var detailedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.themeUpdate()
    }
    
    func themeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
}
