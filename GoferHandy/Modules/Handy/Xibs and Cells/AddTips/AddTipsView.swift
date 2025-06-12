//
//  AddTipsView.swift
//  GoferHandy
//
//  Created by trioangle on 26/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class AddTipsView: UIView {
    
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var tipCloseImageView: UIImageView!
    @IBOutlet weak var tipsLbl: SecondaryRegularLabel!
    
    func ThemeUpdate() {
        self.tipsLbl.customColorsUpdate()
    }
    
    func updateTipAmountView(riderGivenTripAmount:Double?, curr_sym:String){
        
        if let tip = riderGivenTripAmount{
            self.tipCloseImageView.image = UIImage(named:"tip_cancel")?.withRenderingMode(.alwaysTemplate)
            self.tipsLbl.text = "\(LangCommon.tip) \(curr_sym) \(String(format: "%.2f",tip)) \(LangCommon.driver.capitalized)"
            self.tipsView.backgroundColor = .PromoColor
        }else{
            self.tipCloseImageView.image = UIImage(named:"tip_icon")?.withRenderingMode(.alwaysTemplate)
            self.tipsLbl.text = LangCommon.addTip.capitalized
            self.tipsView.backgroundColor = .TertiaryColor
        }
        self.ThemeUpdate()
        self.tipCloseImageView.tintColor = .black
    }
    
    class func CreateView(_ cgrect:CGRect) -> AddTipsView {
           let nib = UINib(nibName: "AddTipsView", bundle: nil)
           let view = nib.instantiate(withOwner: nil, options: nil)[0] as! AddTipsView
           view.frame = cgrect
            view.ThemeUpdate()
           return view
       }

}
