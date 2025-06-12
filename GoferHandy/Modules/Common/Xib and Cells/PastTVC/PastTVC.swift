//
//  PendingTripTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PastTVC: BaseTableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var jobId: SecondarySmallBoldLabel!
    @IBOutlet weak var jobDateTime: InactiveSmallLabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var jobLocationText: SecondarySmallLabel!
    @IBOutlet weak var jobLocation: SecondarySmallMediumLabel!
    @IBOutlet weak var pickupImg: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var jobStatusTitleLbl: SecondarySmallLabel!
//    @IBOutlet weak var jobStatusValueLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var dropImg: UIImageView!
    @IBOutlet weak var dropLocationText: SecondarySmallLabel!
    @IBOutlet weak var cancelBooking: PrimaryButton!
    @IBOutlet weak var requestedServicesBtn: TeritaryButton!
    //@IBOutlet weak var declinedServicesBtn: UIButton!
    @IBOutlet weak var dropLocation: SecondarySmallMediumLabel!
    @IBOutlet weak var pickupLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var editTimeBtn: UIButton!
    @IBOutlet weak var statusHolderView: UIView!
    @IBOutlet weak var dropLocationHolderStack: UIStackView!
    @IBOutlet weak var buttonHolderStack: UIStackView!
    @IBOutlet weak var reqServiceStack: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.editTimeBtn.cornerRadius = 15
        self.hideBottom()
        self.hideDropLocation(isShow: false)
        self.hideEditTime()
        self.ThemeChange()
    }

    func ThemeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lineView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        self.editTimeBtn.titleLabel?.font = AppTheme.Fontmedium(size: 15).font
        self.editTimeBtn.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        self.editTimeBtn.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                       for: .normal)
        self.dropLocation.customColorsUpdate()
        self.cancelBooking.customColorsUpdate()
        self.requestedServicesBtn.customColorsUpdate()
        self.dropLocationText.customColorsUpdate()
        self.jobId.customColorsUpdate()
        self.jobDateTime.customColorsUpdate()
        self.jobLocationText.customColorsUpdate()
        self.jobLocation.customColorsUpdate()
        self.jobStatusTitleLbl.customColorsUpdate()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func populateCell(){
        print("afdsfds")
    }
    func hideDropLocation(isShow : Bool){
        self.dropLocationHolderStack.isHidden = !isShow
        self.dropImg.isHidden = !isShow
        self.dropLocationText.isHidden = !isShow
        self.dropLocation.isHidden = !isShow
    }
    
    func showEditTime() {
        self.editTimeBtn.isHidden = false
    }
    func hideEditTime() {
        self.editTimeBtn.isHidden = true
    }
    func hideBottom(){
        self.buttonHolderStack.isHidden = true
        self.cancelBooking.isHidden = true
        self.requestedServicesBtn.isHidden = true
    }
    func showBottom(){
        self.buttonHolderStack.isHidden = false
        self.cancelBooking.isHidden = false
        self.requestedServicesBtn.isHidden = true
    }
    func hideStatus(){
        self.statusHolderView.isHidden = true
    }
    class func getNib() -> UINib{
        return UINib(nibName: "PastTVC", bundle: nil)
    }
}

