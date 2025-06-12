//
//  MobileNumberView.swift
//  Gofer
//
//  Created by trioangle on 11/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

class MobileNumberView : UIView{
    
    @IBOutlet weak var countryHolderView : SecondaryBorderedView!
    @IBOutlet weak var countryIV : UIImageView!
    @IBOutlet weak var countyCodeLbl : SecondaryTextFieldLabel!
    @IBOutlet weak var numberHolderView : SecondaryBorderedView!
    @IBOutlet weak var numberTF : commonTextField!
    
    var flag : CountryModel?{
        didSet{
            if let _flag = self.flag{
                self.setCountry(_flag)
            }
        }
    }
    
    var number : String?{return numberTF.text}
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeChange()
    }
    func ThemeChange() {
        self.numberHolderView.customColorsUpdate()
        self.countryHolderView.customColorsUpdate()
        self.countyCodeLbl.customColorsUpdate()
        self.numberTF.customColorsUpdate()
    }
    func initLayers(){
        self.numberHolderView.cornerRadius = 10
        self.countryHolderView.cornerRadius = 10
        self.numberTF.setTextAlignment()
        
    }
    func clear(){
        self.numberTF.text = ""
    }
    private func setCountry(_ flag : CountryModel){
        self.countryIV.image = flag.flag
        self.countyCodeLbl.text = flag.dial_code
    }
    static func getView(with frame : CGRect) -> MobileNumberView{
        let nib = UINib(nibName: "MobileNumberView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! MobileNumberView
        view.frame = frame
        view.initLayers()
        view.flag = CountryModel()
        return view
    }
}
