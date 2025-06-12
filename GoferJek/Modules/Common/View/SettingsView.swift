//
//  SettingsView.swift
//  GoferHandy
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation

class SettingsView : BaseView {
    
    //MARK:- Outlets
    @IBOutlet weak var tblPayment : CommonTableView!
    @IBOutlet weak var viewProfileHolder:SecondaryView!
    @IBOutlet weak var lblUserName:SecondaryRegularLabel!
    @IBOutlet weak var lblPhoneNo:SecondaryRegularLabel!
    @IBOutlet weak var lblEmailId:InactiveSmallLabel!
    @IBOutlet weak var imgUserThumb : UIImageView!
    @IBOutlet weak var headerBGView: UIView!
    @IBOutlet weak var curvedContentHolderView: TopCurvedView!
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblSettings: SecondaryHeaderLabel!
    @IBOutlet weak var signoutBtn: PrimaryButton!
    @IBOutlet weak var lblArrowIcon: UILabel!
    @IBOutlet weak var deleteAccBtn: PrimaryButton!
    //MARK:- Actions
    
    @IBAction func signoutAction(_ sender: Any) {
        let lang = LangCommon
        self.viewController
            .commonAlert
            .setupAlert(alert: appName,
                        alertDescription: lang.rUSureToLogOut,
                        okAction: lang.ok.capitalized,
                        cancelAction: lang.cancel.capitalized,
                        userImage: nil)
        self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            self.viewController.callLogoutAPI()
        }
    }
    @IBAction func deleteAccBtn(_ sender: Any) {
        self.viewController.deleteAccountVerification()
    }
    
    // WHEN USER PROFILE HEADER TAPPED
    @IBAction func onProfileTapped(_ sender:UIButton!) {
        if userDefaults.string(forKey: USER_ID) == "10164" {
            self.viewController.presentAlertWithTitle(title: appName, message: LangCommon.loginToContinue, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                (optionss) in
                switch optionss {
                    case 0:                                                                    self.viewController.sharedAppdelegate.showAuthenticationScreen()
                    case 1:
                        self.viewController.dismiss(animated: true)
                            //self.menuVC.dismiss(animated: false, completion: nil)
                    default:
                        break
                }
            })
        } else {
            let propertyView = ViewProfileVC.initWithStory(accountVM: self.viewController.accountViewModel!)
                //        propertyView.delegate = self
            self.viewController.navigationController?.pushViewController(propertyView, animated: true)
        }
    }
  
    //MARK:- initalizers
    var viewController : SettingsVC!
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? SettingsVC
        self.initView()
        self.ThemeChange()
    }
    //MARK:- UDF
    func initView(){
        if isRTLLanguage{
            self.lblUserName.textAlignment = .right
            self.lblPhoneNo.textAlignment = .right
            self.lblEmailId.textAlignment = .right
            self.lblArrowIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        self.lblSettings.text = LangCommon.settings
        self.signoutBtn.setTitle(LangCommon.signOut, for: .normal)
        self.deleteAccBtn.setTitle("Delete Account", for: .normal)
        let userCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
        let userCurrency1 = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)

        if (userCurrency != "") && (userCurrency1 != "")
        {
            viewController.strCurrency = "\(userCurrency) \(userCurrency1)"
            
        }
        else
        {
            viewController.strCurrency = "USD $"
        }
        imgUserThumb.layer.cornerRadius = 20
        imgUserThumb.clipsToBounds = true
        tblPayment.delegate = self
        tblPayment.dataSource = self
        self.signoutBtn.isHidden = userDefaults.string(forKey: USER_ID) == "10164"
        self.deleteAccBtn.isHidden = userDefaults.string(forKey: USER_ID) == "10164"
    }
    
    func ThemeChange() {
        self.darkModeChange()
        self.headerView.customColorsUpdate()
        self.curvedContentHolderView.customColorsUpdate()
        self.lblSettings.customColorsUpdate()
        self.headerBGView.backgroundColor = .clear
        self.tblPayment.customColorsUpdate()
        self.lblUserName.customColorsUpdate()
        self.lblPhoneNo.customColorsUpdate()
        self.lblEmailId.customColorsUpdate()
        self.viewProfileHolder.customColorsUpdate()
        self.lblArrowIcon.textColor = self.isDarkStyle ?
            .DarkModeTextColor : .SecondaryTextColor
        self.tblPayment.reloadData()
    }
}
//MARK:- UITableViewDelegate, UITableViewDataSource
extension SettingsView : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return LangCommon.favourites
        }
        return nil
    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            let label = UILabel()
//            label.text = LangCommon.favorites
//            label.font = AppTheme.Fontmedium(size: 16).font
//            label.backgroundColor = isDarkStyle ? .darkBackgroundColor : .SecondaryColor
//            label.textColor = isDarkStyle ? .darkTextColor : .SecondaryTextColor
//            return label
//        } else {
//            return nil
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ?  30 : 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 65 : 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewController.arrTitle.count : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 0 {
            let cell:CellCurrencyTVC = tblPayment.dequeueReusableCell(withIdentifier: "CellCurrencyTVC")! as! CellCurrencyTVC
            cell.lblTitle?.setTextAlignment()
            cell.selectedLabel?.textAlignment = isRTLLanguage ? .left : .right
            let isLangOrCurre = indexPath.row == 1
            cell.lblTitle?.text = isLangOrCurre ? LangCommon.language.capitalized : LangCommon.currency
            let rectTblView = cell.lblTitle?.frame
            cell.lblTitle?.frame = rectTblView!
            cell.selectedLabel?.text = isLangOrCurre ? currentLanguage.lang : viewController.strCurrency
            cell.imgLogo?.isHidden = false
            cell.imgLogo?.image = !isLangOrCurre ? UIImage(named: "Currency_new") : UIImage(named: "Language_new")
            cell.imgLogo?.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            cell.ThemeChange()
            return cell
        } else {
            let cell:CellPayment = tblPayment.dequeueReusableCell(withIdentifier: "CellPayment")! as! CellPayment
            cell.lblTitle?.text = viewController.arrTitle[indexPath.row]
            _ = isRTLLanguage
            if isRTLLanguage{
                cell.lblTitle?.textAlignment = .right
                cell.lblSubTitle?.textAlignment = .right
                cell.lblAccessory?.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            if indexPath.row == 0 && Constants().GETVALUE(keyname: USER_HOME_LOCATION).count > 0 {
                cell.lblTitle?.text = LangCommon.home
                cell.lblSubTitle?.isHidden = false
                cell.lblSubTitle?.text = Constants().GETVALUE(keyname: USER_HOME_LOCATION)
            } else if indexPath.row == 0 {
                cell.lblSubTitle?.isHidden = true
                cell.lblTitle?.text = viewController.arrTitle[indexPath.row]
            }
            
            if indexPath.row == 1 && Constants().GETVALUE(keyname: USER_WORK_LOCATION).count > 0 {
                 cell.lblTitle?.text = LangCommon.work
                cell.lblSubTitle?.isHidden = false
                cell.lblSubTitle?.text = Constants().GETVALUE(keyname: USER_WORK_LOCATION)
            } else if indexPath.row == 1 {
                cell.lblSubTitle?.isHidden = true
                cell.lblTitle?.text = viewController.arrTitle[indexPath.row]
            }
            cell.iconIV.image  = (indexPath.row == 0) ? UIImage(named: "home_location") : UIImage(named: "work_location")
            cell.iconIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            cell.lblTitle?.textColor = UIColor.black
            cell.lblIconName?.isHidden = false
            cell.lblIconName?.text = (indexPath.row == 0) ? "V" : "k"
            cell.lblAccessory?.isHidden = false
            cell.lblIconName?.layer.cornerRadius = (cell.lblIconName?.frame.size.height)! / 2
            cell.lblIconName?.clipsToBounds = true
            cell.ThemeChange()
            return cell

        }
       
    }
    
    //MARK: ---- Table View Delegate Methods ----
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            if userDefaults.string(forKey: USER_ID) == "10164" {
                self.viewController.presentAlertWithTitle(title: appName, message: LangCommon.loginToContinue, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                    (optionss) in
                    switch optionss {
                        case 0:
                            self.viewController.sharedAppdelegate.showAuthenticationScreen()
                        case 1:
                            self.viewController.dismiss(animated: true)
                                //self.menuVC.dismiss(animated: false, completion: nil)
                        default:
                            break
                    }
                })
            } else {
                let locationView = AddLocationVC.initWithStory(viewController)
                locationView.forLocation = (indexPath.row == 0) ? .Home : .Work
                viewController.isHomeTapped = (indexPath.row == 0) ? true : false
                self.viewController.navigationController?.pushViewController(locationView, animated: true)
            }
        } else {
            if indexPath.row == 0 {
                let locView = CurrencyPopupVC.initWithStory()
                locView.modalPresentationStyle = .overCurrentContext
                self.viewController.present(locView,
                                            animated: true,
                                            completion: nil)
                var _currency : String = ""
                var _symbol : String = ""
                locView.callback = { (str) in
                    if let currency = str {
                        _currency = currency
                    }
                    self.setCurrencyDetail(_symbol: _symbol, _currency: _currency)
                }
                locView.clickedSym = { (str) in
                    if let symbol = str {
                        _symbol = symbol
                        self.setCurrencyDetail(_symbol: _symbol, _currency: _currency)
                    }
                }
                
            } else {
                let view = SelectLanguageVC.initWithStory()
                view.modalPresentationStyle = .overCurrentContext
                self.viewController.present(view,
                                            animated: true,
                                            completion: nil)
            }
        }
    }
    
    func setCurrencyDetail(_symbol: String,_currency:String) {
        self.viewController.strCurrency = String(format:"%@ %@", _symbol,_currency)
        self.tblPayment.reloadData()
    }
    
}
