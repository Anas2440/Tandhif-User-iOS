//
//  AddTipTableViewCell.swift
//  Goferjek
//
//  Created by trioangle on 18/01/22.
//  Copyright © 2022 Vignesh Palanivel. All rights reserved.
//

import UIKit

class AddTipTableViewCell: UITableViewCell {

    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var tipCloseImageView: UIImageView!
    @IBOutlet weak var tipsLbl: SecondaryRegularLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
    
}
