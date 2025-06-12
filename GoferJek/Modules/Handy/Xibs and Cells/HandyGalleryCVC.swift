//
//  HandyGalleryCVC.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyGalleryCVC: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var galleryIV : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ThemeUpdate()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    func populate(with galleryItem : GalleryImage){
        self.galleryIV.backgroundColor = .PrimaryColor
        self.galleryIV.sd_setImage(with: URL(string: galleryItem.image), completed: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.galleryIV.contentMode = .scaleAspectFill
            self.galleryIV.clipsToBounds = true
        }
    }
}
