//
//  CommonErrorView.swift
//  CommonErrorView
//
//  Created by Trioangle on 09/09/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class CommonErrorView : UIView {
    
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: SecondaryHeaderLabel!
    
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.label.customColorsUpdate()
    }
    
    func setDetails(image: UIImage?,
                    title: String) {
        self.imageView.image = image
        self.label.text = title
    }
    
}
