//
//  CancelRideView.swift
//  GoferHandy
//
//  Created by trioangle on 01/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class CancelRideView: BaseView {
    
    //-----------------------------------------
    //MARK:- Outlets
    //-----------------------------------------
    
    @IBOutlet weak var tblCancelList: CommonTableView!
    @IBOutlet weak var btnSave: PrimaryButton!
    @IBOutlet weak var btnCanceReason: UIButton!
    @IBOutlet weak var viewHolder: SecondaryBorderedView!
    @IBOutlet weak var txtViewCancel: commonTextView!
    @IBOutlet weak var lblPlaceHolder: SecondaryRegularLabel!
    @IBOutlet weak var arrow: PrimaryImageView!
    @IBOutlet weak var lblPageTitle : SecondaryHeaderLabel!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var curvedContentHolderView: TopCurvedView!
    @IBOutlet weak var contentHolderView: SecondaryView!
    @IBOutlet weak var bottomView: TopCurvedView!
    
    //-----------------------------------------
    //MARK:- Local Variables
    //-----------------------------------------
    
    let dropImage = UIImage(named: "drop_down_filled")?.withRenderingMode(.alwaysTemplate)
    var rotatedArrow: UIImage?
    var cancelRideVC : CancelRideVC!
    var cancelReasons = [CancelReason]()
    var strCancelReason = ""
    var usertype = ""
    var cancel_reason_id : Int = 0
    
    //-----------------------------------------
    // MARK: - ViewController Methods
    //-----------------------------------------
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.lblPageTitle.customColorsUpdate()
        self.tblCancelList.customColorsUpdate()
        self.tblCancelList.reloadData()
        self.viewHolder.customColorsUpdate()
        self.txtViewCancel.customColorsUpdate()
        self.lblPlaceHolder.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.curvedContentHolderView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.arrow.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.btnCanceReason.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
    }
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.cancelRideVC = baseVC as? CancelRideVC
        self.initView()
        self.initLanguage()
        self.initNotification()
        self.checkSaveButtonStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.initLayer()
        }
        self.darkModeChange()
    }
    
    //-----------------------------------------
    //MARK:- initView
    //-----------------------------------------
    
    func initView() {
        self.btnCanceReason.setTextAlignment()
        self.btnCanceReason.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.arrow.image = self.dropImage
        self.tblCancelList.dataSource = self
        self.tblCancelList.delegate = self
        self.txtViewCancel.delegate = self
        self.rotatedArrow = self.dropImage?.rotate(radians: .pi).withRenderingMode(.alwaysTemplate)
        self.tblCancelList.isHidden = true
        self.txtViewCancel.isHidden = false
        self.btnCanceReason.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.txtViewCancel.setTextAlignment()
    }
    
    //-----------------------------------------
    //MARK:- initLayer
    //-----------------------------------------
    
    func initLayer(){
        self.viewHolder.cornerRadius = 15
        self.viewHolder.elevate(4)
        self.contentHolderView.cornerRadius = 15
        self.contentHolderView.elevate(4)
    }
    
    //-----------------------------------------
    //MARK:- initLanguage
    //-----------------------------------------
    func initLanguage(){
        // Handy Splitup start
        switch AppWebConstants.businessType.rawValue {
        case 1:
            // Handy Splitup End
            self.btnSave.setTitle(LangHandy.cancelJob,
                                  for: .normal)
            self.lblPageTitle.text = LangHandy.cancelYourJob
            // Handy Splitup start
            break
        case 2:
            self.btnSave.setTitle(LangCommon.cancel,
                                  for: .normal)
            self.lblPageTitle.text = LangCommon.cancel
            break
        case 3:
            self.btnSave.setTitle("",
                                  for: .normal)
            self.lblPageTitle.text = ""
            break
        case 4:
            self.btnSave.setTitle("",
                                  for: .normal)
            self.lblPageTitle.text = ""
            break
        case 5:
            self.btnSave.setTitle(LangCommon.cancel,
                                  for: .normal)
            self.lblPageTitle.text = LangCommon.cancel
            break
        default:
            break
        }
        // Handy Splitup End
        self.btnCanceReason.setTitle(LangCommon.cancelReason,
                                     for: .normal)
        self.lblPlaceHolder.text = LangCommon.writeYourComment
        self.lblPlaceHolder.textColor = UIColor.SecondaryTextColor.withAlphaComponent(0.5)
    }
    //-----------------------------------------
    //MARK:- initSuccess Message
    //-----------------------------------------
    func initSuccessMessage(){
        // Handy Splitup Start
        switch AppWebConstants.businessType.rawValue {
        case 3:
            AppDelegate.shared.createToastMessage("\(LangCommon.success) \(LangHandy.yourOrderCancelled)")
            break
        default:
            break
        }
        // Handy Splitup End
    }
    //-----------------------------------------
    //MARK:- initNotification
    //-----------------------------------------
    
    func initNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.gotoMainView),
                                               name: .arriveBeignTrip,
                                               object: nil)
    }
    
    //-----------------------------------------
    // MARK: When User Press Button
    //-----------------------------------------
    
    @IBAction func onCancelTripTapped(_ sender:UIButton!) {
        self.endEditing(true)
        btnSave.isUserInteractionEnabled = false
        self.cancelRideVC.wsCancelTrip(cancel_reason_id: cancel_reason_id,
                                       reason: txtViewCancel.text,
                                       usertype: usertype)
    }
    
    @IBAction func chooseCancelDropDown(_ sender:UIButton!) {
        self.endEditing(true)
        self.arrow.image = rotatedArrow?.withRenderingMode(.alwaysTemplate)
        self.tblCancelList.isHidden = !tblCancelList.isHidden
        self.txtViewCancel.isHidden = !self.txtViewCancel.isHidden
        if self.tblCancelList.isHidden {
            self.lblPlaceHolder.isHidden = self.txtViewCancel.text.count > 0
            self.arrow.image = UIImage(named: "drop_down_filled")?.withRenderingMode(.alwaysTemplate)
        } else {
            self.tblCancelList.reloadData()
            self.lblPlaceHolder.isHidden = true
        }
    }
    
    //-------------------------------------------------------
    //MARK: - WHILE GETTING PUSH NOTIFICATION FROM DRIVER
    //-------------------------------------------------------
    @objc
    func gotoMainView(notification: Notification) {
        let str2 = notification.userInfo
        let getNotificationType = str2?["type"] as? String ?? String()
        if getNotificationType != "arrivenow" {
            self.cancelRideVC.exitScreen(animated: true)
        }
    }
    
    func checkSaveButtonStatus() {
        let isActive = btnCanceReason.titleLabel?.text != LangCommon.cancelReason
        self.btnSave.isUserInteractionEnabled = isActive
        self.btnSave.backgroundColor = isActive ? .PrimaryColor : .TertiaryColor
    }
}

//----------------------------------------
//MARK: tblCancelReason DataSource
//----------------------------------------

extension CancelRideView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cancelReasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellEarnItems = tblCancelList.dequeueReusableCell(withIdentifier: "CellEarnItems")! as! CellEarnItems
        cell.lblTitle?.text = cancelReasons[indexPath.row].description
        cell.lblTitle.setTextAlignment()
        cell.checkBoxIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        cell.checkBoxIV.image = (strCancelReason == cell.lblTitle.text) ? UIImage(named: "checkbox_selected") : UIImage(named: "checkbox_unselected")
        cell.ThemeChange()
        return cell
    }
}

//----------------------------------------
// MARK: tblCancelReason Delegate
//----------------------------------------

extension CancelRideView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.strCancelReason = cancelReasons[indexPath.row].description
        self.cancel_reason_id = cancelReasons[indexPath.row].id
        self.usertype = cancelReasons[indexPath.row].cancelled_by.description
        self.btnCanceReason.setTitle(self.strCancelReason,
                                     for:.normal)
        self.btnCanceReason.titleLabel?.text = self.strCancelReason
        self.tblCancelList.isHidden = true
        self.txtViewCancel.isHidden = false
        self.lblPlaceHolder.isHidden = self.txtViewCancel.text.count > 0
        let againRotate = self.rotatedArrow?.rotate(radians: .pi)
        self.arrow.image = againRotate?.withRenderingMode(.alwaysTemplate)
        self.tblCancelList.reloadData()
        self.checkSaveButtonStatus()
    }
}

//----------------------------------------
//MARK: - TEXTVIEW DELEGATE METHOD
//----------------------------------------

extension CancelRideView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceHolder.isHidden = (txtViewCancel.text.count > 0) ? true : false
        self.checkSaveButtonStatus()
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

//----------------------------------------
//MARK: tblCancelReason Cell
//----------------------------------------

class CellEarnItems: UITableViewCell {
    @IBOutlet var lblTitle: SecondarySmallBoldLabel!
    @IBOutlet var lblAccessory: UILabel!
    @IBOutlet weak var checkBoxIV: UIImageView!
    
    func ThemeChange() {
        lblAccessory.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lblAccessory?.layer.borderColor = self.isDarkStyle ? UIColor.DarkModeTextColor.cgColor : UIColor.SecondaryTextColor.cgColor
        self.lblTitle.customColorsUpdate()
    }
}
