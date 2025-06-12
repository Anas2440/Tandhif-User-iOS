//
//  Ex + UIImageView.swift
//  Goferjek
//
//  Created by Trioangle on 03/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit
import Foundation

public
enum Redering {
    case orginal
    case template
}

extension UIImageView {
    open
    func setImage(image: String,
                  mode: Redering = .orginal) {
        self.image = UIImage(named: image)?.withRenderingMode(mode == .template ? .alwaysTemplate : .alwaysOriginal)
    }
}
