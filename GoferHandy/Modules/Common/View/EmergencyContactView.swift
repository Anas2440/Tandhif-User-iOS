//
//  EmergencyView.swift
//  GoferHandy
//
//  Created by trioangle on 21/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI

class EmergencyContactView: BaseView {
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contactListTableView: CommonTableView!
    @IBOutlet weak var travelSaferLbl : SecondarySmallLabel?
    @IBOutlet weak var alertDearOnceLbl : InactiveSmallLabel?
    @IBOutlet weak var addUpToLbl : SecondaryRegularLabel?
    @IBOutlet weak var removeContactLbl : SecondaryRegularLabel?
    @IBOutlet weak var emergencyCntctLbl : SecondaryHeaderLabel?
    @IBOutlet weak var addCntctBtn : PrimaryButton?
    @IBOutlet weak var confirmContactHolderView : UIView!
    @IBOutlet weak var confirmContactLbl : SecondaryHeaderLabel!
    @IBOutlet weak var confirmNameTF : commonTextField!
    @IBOutlet weak var confirmNumberHolderView : UIView!
    @IBOutlet weak var confirmContactBtn : PrimaryButton!
    @IBOutlet weak var cancelContactBtn : PrimaryBorderedButton!
    @IBOutlet weak var pleaseAddThemToYourEmergencyContactLbl: SecondarySmallLabel!
    @IBOutlet weak var placeHolderView: SecondaryView!
    @IBOutlet weak var placeHolderTitleLbl: InactiveRegularLabel!
    @IBOutlet weak var placeHolderDescriptionLbl: SecondaryRegularLabel!
    @IBOutlet weak var AlertView: SecondaryView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var ContectBGView: TopCurvedView!
    @IBOutlet weak var contectHolderView: SecondaryView!
    @IBOutlet weak var contactButtonBGView: SecondaryView!
    
    lazy var mobileNumberView : MobileNumberView = {
        let mnView = MobileNumberView.getView(with: self.confirmNumberHolderView.bounds)
        mnView.countryHolderView.addAction(for: .tap, Action: {
            self.pushToCountryVC()
        })
        return mnView
    }()
    lazy var toolBar : UIToolbar = {
        let tool = UIToolbar(frame: CGRect(origin: CGPoint.zero,
                                              size: CGSize(width: self.frame.width,
                                                           height: 30)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done,
                                   target: self,
                                   action: #selector(self.doneAction))
        tool.setItems([space,done], animated: true)
        tool.tintColor = .PrimaryColor
        tool.sizeToFit()
        return tool
    }()
    
    var selectedCountry : CountryModel? = nil
    var emergencyContactVC : EmergencyContactViewController!
    var contactDictArray = [[String:Any]]()
    var contactDict = [String:Any]()
    let contactCount = 5
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.addUpToLbl?.customColorsUpdate()
        self.removeContactLbl?.customColorsUpdate()
        self.emergencyCntctLbl?.customColorsUpdate()
        self.confirmNameTF.customColorsUpdate()
        self.confirmNameTF.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.confirmNameTF.border(width: 1,
                                  color: .TertiaryColor)
        self.confirmNameTF.border(width: 1, color: .TertiaryColor)
        self.confirmContactLbl.customColorsUpdate()
        self.contactListTableView.customColorsUpdate()
        self.travelSaferLbl?.customColorsUpdate()
        self.alertDearOnceLbl?.customColorsUpdate()
        self.placeHolderView.customColorsUpdate()
        self.placeHolderTitleLbl.customColorsUpdate()
        self.placeHolderDescriptionLbl.customColorsUpdate()
        self.cancelContactBtn.customColorsUpdate()
        self.pleaseAddThemToYourEmergencyContactLbl.customColorsUpdate()
        self.contectHolderView.customColorsUpdate()
        self.ContectBGView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.AlertView.customColorsUpdate()
        self.contactButtonBGView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.mobileNumberView.ThemeChange()
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contactListTableView.reloadData()
        
    }
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.emergencyContactVC = baseVC as? EmergencyContactViewController
        self.initView()
        self.initLanguage()
        self.emergencyContactVC.wsToGetSOS()
        self.setUptheContactTableViewHolder()
        self.isRTLCheck()
        self.darkModeChange()
    }
    
    func initLanguage() {
        self.pleaseAddThemToYourEmergencyContactLbl.text = LangCommon.pleaseAddThemToYourEmergencyContact
        self.travelSaferLbl?.text =  LangHandy.makeJobSafe
        self.alertDearOnceLbl?.text = LangCommon.sendAlert
        self.placeHolderTitleLbl.text = LangHandy.ensureSaferJob
        self.placeHolderDescriptionLbl.text = LangCommon.alertUrDears
        self.addUpToLbl?.text = LangCommon.youCanAddC
        self.removeContactLbl?.text = LangCommon.removeContact
        self.addCntctBtn?.setTitle(LangCommon.addContacts, for: .normal)
        self.emergencyCntctLbl?.text = LangCommon.emergencyContacts
    }
    
    func initView() {
        self.contactListTableView.isHidden = true
        self.contactListTableView.delegate = self
        self.contactListTableView.dataSource = self
        self.contactListTableView.separatorStyle = .none
        self.contactListTableView.tableFooterView = UIView()
        self.confirmNameTF.cornerRadius = 15
        self.confirmNameTF.setRightPaddingPoints(15)
        self.confirmNameTF.setLeftPaddingPoints(15)
    }
    
    func initContactConfimationView(){
        self.addSubview(self.confirmContactHolderView)
        self.confirmContactHolderView.translatesAutoresizingMaskIntoConstraints = false
        let leading = self.confirmContactHolderView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = self.confirmContactHolderView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = self.confirmContactHolderView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = self.confirmContactHolderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.bringSubviewToFront(self.confirmContactHolderView)
        NSLayoutConstraint.activate([leading,trailing,top,bottom])
        self.layoutIfNeeded()
        
//        self.cancelContactBtn.border(1, .ThemeMain)
        self.cancelContactBtn.border(width: 1,
                                     color: .PrimaryColor)
//        self.confirmContactBtn.backgroundColor = .ThemeMain
        self.confirmContactBtn.setTitle(LangCommon.confirm.uppercased(), for: .normal)
        self.cancelContactBtn.setTitle(LangCommon.cancel.uppercased(), for: .normal)
        self.confirmContactLbl.text = LangCommon.confirmContact.capitalized
        
        self.confirmNumberHolderView.addSubview(self.mobileNumberView)
        self.mobileNumberView.anchor(toView: self.confirmNumberHolderView,
                                     leading: 0,
                                     trailing: 0,
                                     top: 0,
                                     bottom: 0)
        self.confirmNumberHolderView.bringSubviewToFront(self.mobileNumberView)
        self.mobileNumberView.ThemeChange()
        self.mobileNumberView.numberTF.inputAccessoryView = self.toolBar
        self.confirmNameTF.inputAccessoryView = self.toolBar
        self.hideContactView(with: 0.0)
    }
    
    func showAddBtn() {
        self.addCntctBtn?.isHidden = false
        self.removeContactLbl?.isHidden = true
    }
    
    func hideAddBtn() {
        self.addCntctBtn?.isHidden = true
        self.removeContactLbl?.isHidden = false
    }
    
    @IBAction func contactBtnAction(_ sender : UIButton){
        
        self.endEditing(true)
        if sender == self.confirmContactBtn{
            guard let name = self.confirmNameTF.text,
                let number = self.mobileNumberView.number,
                let country = self.selectedCountry else{
                    appDelegate.createToastMessage(LangCommon.enterValidData)
                    return
            }
            self.emergencyContactVC.addContact(withName: name,
                                               number: number,
                                               country: country)
        }else if sender == self.cancelContactBtn{
            self.hideContactView()
        }
    }

    @IBAction func addContactButtonAction(_ sender: Any) {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPicker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count == 1")
        contactPicker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
        self.emergencyContactVC.present(contactPicker, animated: true, completion: nil)
    }
    
    func isRTLCheck() {
        self.confirmNameTF.setTextAlignment()
    }
    
    func setUptheContactTableViewHolder() {
      self.confirmContactHolderView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    @objc
    func doneAction(){
        self.endEditing(true)
    }
}
extension EmergencyContactView : CountryListDelegate {
    func pushToCountryVC(){
        let propertyView = CountryListVC.initWithStory()
        propertyView.delegate = self
        self.emergencyContactVC.presentInFullScreen(propertyView, animated: true, completion: nil)
    }
    func countryCodeChanged(countryCode: String, dialCode: String, flagImg: UIImage) {
        let country = CountryModel(forDialCode: dialCode, withCountry: countryCode)
        if !country.isAccurate{
            country.country_code = countryCode
            country.dial_code = dialCode
            country.flag = flagImg
        }
        self.selectedCountry = country
        self.mobileNumberView.countryIV.image = country.flag
        self.mobileNumberView.countyCodeLbl.text = country.dial_code
    }
    

    func displayContactView(for contact : CNContactProperty){
        self.confirmNameTF.text = ""
        self.confirmNameTF.placeholder = LangCommon.firstName
    
        guard let number = (contact.value as? CNPhoneNumber)?.stringValue else{
                return
        }
        let country = CountryModel(withCountry: UserDefaults.standard.string(forKey: "user_country_code") ?? "US")
        self.selectedCountry = country
        self.confirmContactHolderView.backgroundColor = .clear
        
        UIView.animateKeyframes(
            withDuration: 1.2,
            delay: 0.2,
            options: UIView.KeyframeAnimationOptions.beginFromCurrentState,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                    self.confirmContactHolderView.transform = .identity
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.6) {
                    self.confirmContactHolderView.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.25)
                    self.confirmNameTF.text = contact.contact.givenName
                    self.mobileNumberView.numberTF.text = number
                    self.mobileNumberView.countryIV.image = country.flag
                    self.mobileNumberView.countyCodeLbl.text = country.dial_code
                }
        }) { (completed) in
            
        }
        self.emergencyContactVC.listen2Keyboard(withView: self.confirmContactHolderView)
    }
    func hideContactView(with duration : TimeInterval = 0.6){
        UIView.animate(withDuration: duration) {
            self.confirmContactHolderView.backgroundColor = .clear
            self.confirmContactHolderView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        }
        self.selectedCountry = nil
        self.emergencyContactVC.ignore2Keyboard()
    }
}

extension EmergencyContactView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     let count = contactDictArray.count
     
     if count == 0 {
       self.placeHolderView.isHidden = false
       return count
     } else {
       self.placeHolderView.isHidden = true
       return count
     }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell  = contactListTableView.dequeueReusableCell(withIdentifier: "AddedContactsTVC") as! AddedContactsTVC
       cell.contactNameLabel.text = contactDictArray[indexPath.row]["name"] as? String
       cell.deleteContactBtn.tag = indexPath.row
        cell.deleteContactBtn.addTarget(self, action: #selector(self.deleteContactBtnisPressed(_:)), for: .touchUpInside)
       cell.contactNumberLabel.text = contactDictArray[indexPath.row]["mobile_number"] as? String
       cell.ThemeChange()
       return cell
    }
    
    @objc
    func deleteContactBtnisPressed(_ sender:UIButton) {
        print("------------>  This Delete Button Was Pressed  \(sender.tag)")
        self.emergencyContactVC.wsToDeleteContact(sender: sender)
    }
}

extension EmergencyContactView : UITableViewDelegate {
    
}


extension EmergencyContactView : CNContactPickerDelegate {
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        var number = String()
        if let phoneNo = contactProperty.value as? CNPhoneNumber {
            number = phoneNo.stringValue
        } else {
            number = "NO NUMBER"
        }
        print(contactProperty.contact.phoneNumbers)
        contactDict["name"] = contactProperty.contact.givenName
        contactDict["mobile_number"] = number
        for contact in contactDictArray {
            if (contact["mobile_number"] as? String ?? String()) == (contactDict["mobile_number"] as? String ?? String()) {
                //TRVicky
                self.emergencyContactVC.commonAlert.setupAlert(alert: LangCommon.message,alertDescription: LangCommon.contactAlreadyAdded, okAction: LangCommon.ok,cancelAction: LangCommon.cancel)
            }
            
        }
        self.displayContactView(for: contactProperty)
        /*
        
   */
    }
}
