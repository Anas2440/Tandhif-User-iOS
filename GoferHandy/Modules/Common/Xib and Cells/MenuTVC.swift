//
//  MenuTVC.swift
//  GoferHandy
//
//  Created by trioangle on 07/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
class MenuTCell: UITableViewCell
{
    @IBOutlet weak var lblName: SecondaryRegularBoldLabel?
    @IBOutlet weak var menuIcon: PrimaryImageView?
    @IBOutlet weak var holderView: UIView!
    static let identifier = "MenuTCell"
    
    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lblName?.customColorsUpdate()
    }
}
