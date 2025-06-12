//
//  DesignableTextField.swift
//  GoferHandy
//
//  Created by trioangle on 05/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class DesiganableTextFiled: UITextField {
    
    @IBInspectable var leftImage : UIImage?
        {
        didSet{
            updateViewDesign()
        }
    }
    
    @IBInspectable var rightImage : UIImage?
        {
        didSet{
            updateViewDesign()
        }
    }
    
    func updateViewDesign()
    {
        if let image = leftImage{
            leftViewMode = .always
            let imageView = UIImageView(frame:CGRect(x: 5, y: 10, width: 14, height: 13))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            view.addSubview(imageView)
            
            leftView = view
        }
        else if let image = rightImage{
            rightViewMode = .always
            let imageView = UIImageView(frame:CGRect(x: 5, y: 10, width: 14, height: 13))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            view.addSubview(imageView)
            
            rightView = view
        }
        else
        {
            leftViewMode = .never
            rightViewMode = .never
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
