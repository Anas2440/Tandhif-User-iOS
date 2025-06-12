//
//  ChangePaymentMethod.swift
//  Gofer
//
//  Created by Trioangle on 12/10/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
class ChangePaymentMethod: UIView {
    
    @IBOutlet weak var paymentBGView: SecondaryView!
    @IBOutlet weak var promoImg: UIImageView!
    @IBOutlet weak var cashLbl: SecondaryRegularLabel!
    @IBOutlet weak var cashImgHolderView: UIView!
    @IBOutlet weak var promolbl: SecondaryExtraSmallLabel!
    @IBOutlet weak var walletImgHolderView: UIView!
    @IBOutlet weak var promoStack: UIStackView!
    @IBOutlet weak var cashImg: UIImageView!
    @IBOutlet weak var walletImg : UIImageView!
    @IBOutlet weak var promoImgHolderView: UIView!
    @IBOutlet weak var promoAndWalletHolder: UIStackView!
    @IBOutlet weak var changeBtn : PrimaryButton!
    @IBOutlet weak var walletStack: UIStackView!
    @IBOutlet weak var walletLbl: SecondaryExtraSmallLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.changeBtn.cornerRadius = 8
        self.promoStack.isHidden = true
        self.walletStack.isHidden = true
        self.cashLbl.setTextAlignment()
        self.walletLbl.setTextAlignment()
        self.promolbl.setTextAlignment()
        self.ThemeChange()
    }
    func ThemeChange() {
        self.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
        self.walletImg.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.cashImg.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.promoImg.image = UIImage(named: "Promo")
        self.promoImg.tintColor = .init(hex: "2BCB7B")
        self.promolbl.text = LangCommon.promoApplied
        self.walletImg.image = UIImage(named: "wallet")
        self.walletImg.tintColor = .init(hex: "2BCB7B")
        self.walletLbl.text = LangCommon.wallet
        self.paymentBGView.customColorsUpdate()
        self.cashLbl.customColorsUpdate()
        self.walletLbl.customColorsUpdate()
        self.promolbl.customColorsUpdate()
    }
    func setFrame(_ parentFrame: CGRect) -> CGRect{
        let frame = CGRect(x: 0, y: 0, width: parentFrame.width, height:  parentFrame.height)
        return frame
    }
  
    class func initViewFromXib()-> ChangePaymentMethod{
        let nib = UINib(nibName: "ChangePaymentMethod", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! ChangePaymentMethod
        return view
    }
    
    
    
}

