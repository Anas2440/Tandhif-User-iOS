//
//  SetTipsView.swift
//  GoferHandy
//
//  Created by trioangle on 26/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class SetTipsView: UIView {

    @IBOutlet weak var closeTipViewBtn: PrimaryTintButton!
    @IBOutlet weak var enterTipsTF: commonTextField!
    @IBOutlet weak var setTipBtn: PrimaryButton!
    @IBOutlet weak var currencySymbolLbl: SecondaryTextFieldLabel!
    @IBOutlet weak var tipsHolderView: TopCurvedView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func ThemeUpdate() {
        self.enterTipsTF.customColorsUpdate()
        self.currencySymbolLbl.customColorsUpdate()
        self.tipsHolderView.customColorsUpdate()
    }
    
    class func CreateView(_ cgrect:CGRect) -> SetTipsView {
        let nib = UINib(nibName: "SetTipsView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! SetTipsView
        view.frame = cgrect
        return view
    }
    
    

}
