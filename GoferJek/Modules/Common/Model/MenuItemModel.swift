//
//  MenuItemModel.swift
//  Gofer
//
//  Created by trioangle on 12/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

class MenuItemModel{
    var title : String
    var imgName : String?
    var viewController : UIViewController?
    init(withTitle title :String,image : String? = nil,VC : UIViewController? ){
        self.title = title
        self.imgName = image
        self.viewController = VC    
    }
}
class CellMenus: UITableViewCell
{
    @IBOutlet var lblName: UILabel?
}
