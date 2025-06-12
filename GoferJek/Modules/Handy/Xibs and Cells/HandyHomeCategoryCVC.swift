//
//  HandyHomeCategoryCVC.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyHomeCategoryCVC: UICollectionViewCell {
    
    @IBOutlet weak var rightBorder: UILabel!
    @IBOutlet weak var BGView: SecondaryView!
    @IBOutlet weak var titleLbl : SecondarySmallLabel!
    @IBOutlet weak var imageHolderView: SecondaryView!
    @IBOutlet weak var categoryIV : UIImageView!
    
    lazy var ivBgView : UIView = {
       let view = UIView()
        view.frame = self.categoryIV.frame
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func ThemeUpdate() {
        self.titleLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.BGView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.ivBgView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundView?.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.imageHolderView.customColorsUpdate()
    }
}
