//
//  CovidAlertView.swift
//  GoferHandy
//
//  Created by trioangle on 09/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class CovidAlertView: BaseView {
    
    //--------------------------------------
    //MARK:- Outlets
    //--------------------------------------
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var popupView: TopCurvedView!
    @IBOutlet weak var pointThreeView: UIView!
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var subTitleLbl: SecondaryRegularLabel!
    @IBOutlet weak var pointOneView: UIView!
    @IBOutlet weak var pointTwoView: UIView!
    @IBOutlet weak var pointOneDot: UILabel!
    @IBOutlet weak var pointOneLbl: SecondaryRegularLabel!
    @IBOutlet weak var pointTwoDot: UILabel!
    @IBOutlet weak var pointTwoLbl: SecondaryRegularLabel!
    @IBOutlet weak var imageOuterView: UIView!
    @IBOutlet weak var pointThreeLbl: SecondaryRegularLabel!
    @IBOutlet weak var bottomlbl: SecondarySubHeaderLabel!
    @IBOutlet weak var pointThreeDot: UILabel!
    @IBOutlet weak var proceedBtn: PrimaryButton!
    @IBOutlet weak var cancelBtn: PrimaryBorderedButton!
    @IBOutlet weak var alertImg: UIImageView!
    
    //--------------------------------------
    //MARK:- Local Variables
    //--------------------------------------
    
    var covidAlertVC : CovidAlertVC!
    
    //--------------------------------------
    //MARK:- View Controller Cycle
    //--------------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.covidAlertVC = baseVC as? CovidAlertVC
        self.initLanguage()
        self.initGesture()
        self.initLayer()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        self.popupView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.subTitleLbl.customColorsUpdate()
        self.pointOneLbl.customColorsUpdate()
        self.pointTwoLbl.customColorsUpdate()
        self.pointThreeLbl.customColorsUpdate()
        self.bottomlbl.customColorsUpdate()
        self.cancelBtn.customColorsUpdate()
        self.proceedBtn.customColorsUpdate()
        self.pointOneDot.backgroundColor = self.isDarkStyle ? .DarkModeTextColor :
            .SecondaryTextColor
        self.pointTwoDot.backgroundColor = self.isDarkStyle ? .DarkModeTextColor :
            .SecondaryTextColor
        self.pointThreeDot.backgroundColor = self.isDarkStyle ? .DarkModeTextColor :
            .SecondaryTextColor
    }
    
    //--------------------------------------
    //MARK:- Actions
    //--------------------------------------
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.covidAlertVC.dismiss(animated: true) {
            self.covidAlertVC.delegate.covidAlertCancelled()
        }
    }
    
    @IBAction func proceedBtnAction(_ sender: Any) {
        self.covidAlertVC.dismiss(animated: true) {
            switch self.covidAlertVC.bookingType {
            case .bookNow:
                self.covidAlertVC.delegate.wsToBookNow()
            case .bookLater:
                self.covidAlertVC.delegate.wsToBookLater()
            case .none:
                self.covidAlertVC.delegate.covidAlertCancelled()
            }
        }
    }
    
    //--------------------------------------
    //MARK: - Inital Functions
    //--------------------------------------
    
    func initLanguage() {
        self.titleLbl.text = LangCommon.covidTitle
        self.subTitleLbl.text = LangCommon.covidSubtitle
        self.pointOneLbl.text = LangCommon.covidPointOne
        self.pointTwoLbl.text = LangCommon.covidPointTwo
        self.pointThreeLbl.text = LangCommon.covidPointThree
        self.bottomlbl.text = LangCommon.covidFooter
        self.alertImg.setImage(image: "covid",
                               mode: .orginal)
        self.proceedBtn.setTitle(LangCommon.proceed.capitalized, for: .normal)
        self.cancelBtn.setTitle(LangCommon.cancel.capitalized, for: .normal)
    }
    
    func initLayer() {
        self.cancelBtn.cornerRadius = 15
        self.proceedBtn.cornerRadius = 15
        self.alertImg.cornerRadius = 15
        self.pointOneDot.isRoundCorner = true
        self.pointTwoDot.isRoundCorner = true
        self.pointThreeDot.isRoundCorner = true
    }
    
    func initGesture() {
        self.parentView.addAction(for: .tap) {
            self.covidAlertVC.dismiss(animated: true, completion: nil)
        }
        self.popupView.addAction(for: .tap) {
            print("Not An OutSide Can't Leave")
        }
    }
}
