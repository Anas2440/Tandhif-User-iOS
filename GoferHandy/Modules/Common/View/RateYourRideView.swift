//
//  RateYourRideView.swift
//  GoferHandy
//
//  Created by trioangle on 13/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class RateYourRideView: BaseView {
    
    //----------------------------------------------------
    // MARK: - outlets
    //----------------------------------------------------
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var btnSubmit: PrimaryButton!
    @IBOutlet weak var lblPlaceHolder: SecondaryRegularLabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtComments: commonTextView!
    @IBOutlet weak var lblPageTitle: SecondaryHeaderLabel!
    @IBOutlet weak var providerNameLbl : SecondaryLargeLabel!
    @IBOutlet weak var topCurvedView : TopCurvedView!
    @IBOutlet weak var covidNotesLbl: SecondaryRegularLabel!
    @IBOutlet weak var headerView:HeaderView!
    @IBOutlet weak var skipBtn: SecondaryButton!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var contentHolderView: SecondaryView!
    
    //----------------------------------------------------
    // MARK: - Local Variable
    //----------------------------------------------------
    
    var rateYourRideVC : RateYourRideVC!
    
    //----------------------------------------------------
    // MARK: - ViewController Methods
    //----------------------------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.rateYourRideVC = baseVC as? RateYourRideVC
        self.initView()
        self.initLanguage()
        self.initLayer()
        self.setDisplayData()
        self.initNotification()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.skipBtn.customColorsUpdate()
        self.covidNotesLbl.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.lblPageTitle.customColorsUpdate()
        self.topCurvedView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.lblPlaceHolder.customColorsUpdate()
        self.txtComments.customColorsUpdate()
        if self.txtComments.text == LangCommon.writeYourComment.capitalized {
            self.txtComments.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
        self.providerNameLbl.customColorsUpdate()
    }
    
    //----------------------------------------------------
    // MARK:- When User Press Submit Button
    //----------------------------------------------------
    
    @IBAction func onSubmitTapped(_ sender:UIButton!) {
        self.endEditing(true)
        if Int(self.floatRatingView.rating) == 0 {
            //TRVicky
            self.rateYourRideVC.commonAlert
                .setupAlert(
                    alert: LangCommon.message,
                    alertDescription: LangCommon.pleaseGiveRating,
                    okAction: LangCommon.ok)
            return
        }
        if txtComments.text == LangCommon.writeYourComment.capitalized {
            txtComments.text = nil
        }
        self.rateYourRideVC.updateRatingToApi(comment: self.txtComments.text,
                                              rating: Int(self.floatRatingView.rating))
    }
    
    //----------------------------------------------------
    // MARK: When User Press Back Button
    //----------------------------------------------------
    
    @IBAction func onBackTapped(_ sender:UIButton!){
        Shared.instance.resumeTripHitCount = 1
        Shared.instance.resumeTripHitCountDelivery = 1
        // Handy Splitup Start
        switch AppWebConstants.businessType {
        case .Services:
            if self.rateYourRideVC.navigationController?.viewControllers.anySatisfy({$0 is HandyRouteVC || $0 is HandyPaymentVC}) ?? true {
                appDelegate.onSetRootViewController(viewCtrl: self.rateYourRideVC)
            } else {
                self.rateYourRideVC.navigationController?.popViewController(animated: true)
            }
        default :
            break
        }
        // Handy Splitup End
        self.endEditing(true)
    }
    
    //----------------------------------------------------
    // MARK:- initializers
    //----------------------------------------------------
    
    func initView() {
        self.covidNotesLbl.isHidden = !Shared.instance.isCovidEnabled
        self.floatRatingView.delegate = self
        self.floatRatingView.tintColor = UIColor(hex: "F9CA33")
        self.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.rating = 0.0
        self.floatRatingView.editable = true
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(self.doneButtonAction))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        self.txtComments.inputAccessoryView = toolbarDone
        var lblFrame = self.lblPlaceHolder.frame
        lblFrame.origin.y = txtComments.frame.origin.y+8
        lblFrame.origin.x = txtComments.frame.origin.x+5
        self.lblPlaceHolder.frame = lblFrame
        self.lblPlaceHolder.isHidden = true
        self.imgUser.layer.cornerRadius = 8
        self.imgUser.clipsToBounds = true
        self.txtComments.setTextAlignment()
    }
    
    func initLayer() {
        self.txtComments.border(width: 1, color: UIColor.TertiaryColor.withAlphaComponent(0.3))
        self.txtComments.layer.borderWidth = 2.0
        self.txtComments.layer.cornerRadius = 8
        self.btnSubmit.layer.cornerRadius = 18
    }
    
    func initLanguage() {
        self.covidNotesLbl.text = LangCommon.covidRating
        self.txtComments.text = LangCommon.writeYourComment.capitalized
        self.skipBtn.setTitle(LangCommon.skip.capitalized, for: .normal)
        self.lblPageTitle.text = LangHandy.rateYourJob
        self.btnSubmit.setTitle(LangCommon.submit.uppercased(), for: .normal)
        self.lblPlaceHolder.text = LangCommon.writeYourComment.capitalized
    }
    
    func initNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //----------------------------------------------------
    // MARK:- skipButton
    //----------------------------------------------------
    
    @IBAction func skipBtnClicked(_ sender: Any) {
        AppDelegate.shared.onSetRootViewController(viewCtrl: self.rateYourRideVC)
    }
    
    //----------------------------------------------------
    // MARK:- Show Notification keyboard
    //----------------------------------------------------
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let height = notification.getKeyboardHeight(){
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.transform = CGAffineTransform(translationX: 0, y: -(height - (UIDevice.current.hasNotch ? 39 : 0)))
            } completion: { isComplted in }
        }
    }
    
    //----------------------------------------------------
    // MARK:- Hide Notification keyboard
    //----------------------------------------------------
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.transform = .identity
        } completion: { isComplted in }
    }
   
    @objc
    func doneButtonAction() {
        self.txtComments.resignFirstResponder()
    }
    
    func setDisplayData(){
        if let userName = self.rateYourRideVC.userName {
            self.providerNameLbl.text = userName
        } else {
            debug(print: "userName Missing")
        }
        if let profileImg = self.rateYourRideVC.userImage_thumb {
            let str = profileImg
            let url = URL(string: str)
            imgUser.sd_setImage(with: url,
                                placeholderImage:UIImage(named:"user_dummy"))
        } else {
            debug(print: "userImage_thumb Missing")
        }
    }

}

//----------------------------------------------------
// MARK:- FloatRatingViewDelegate
//----------------------------------------------------

extension RateYourRideView : FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.endEditing(true)

    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        let strRating = NSString(format: "%.2f", self.floatRatingView.rating) as String
        floatRatingView.rating = Float(strRating)!
    }
}

//----------------------------------------------------
// MARK: - TEXTVIEW DELEGATE METHOD
//----------------------------------------------------

extension RateYourRideView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LangCommon.writeYourComment.capitalized {
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LangCommon.writeYourComment.capitalized
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
//        lblPlaceHolder.isHidden = (txtComments.text.count > 0)
        if textView.text == LangCommon.writeYourComment.capitalized {
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        } else {
            textView.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        } else if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
