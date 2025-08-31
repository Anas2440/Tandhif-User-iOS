/**
* SettingsVC.swift
*
* @package Gofer
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import AVFoundation
import CoreLocation

protocol SettingProfileDelegate
{
    func setprofileInfo()
}


class SettingsVC : BaseViewController,
                   addLocationDelegate,
                   EditProfileDelegate,
                   currencyListDelegate{
 
    
    @IBOutlet weak var settingsView : SettingsView!
    var delegate: SettingProfileDelegate?
    var strCurrency : String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var accountViewModel : AccountViewModel!
    let arrTitle = [
        LangCommon.addHome,
        LangCommon.addWork
    ]
    var isHomeTapped : Bool = false
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsView.lblPhoneNo.text = String(format:"%@ %@",Constants().GETVALUE(keyname: "dial_code"), Constants().GETVALUE(keyname: "phonenumber"))
        self.navigationController?.isNavigationBarHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK:- initWithStory
    class func initWithStory(accountViewModel : AccountViewModel) -> SettingsVC{
        
        let settings : SettingsVC = UIStoryboard.gojekAccount.instantiateViewController()
        settings.accountViewModel = accountViewModel
        return settings
    }
    // EDIT PROFILE VC DELEGATE METHOD
    internal func setprofileInfo()
    {
        delegate?.setprofileInfo()
        self.settingsView.imgUserThumb.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: "user_image")),
                                                   placeholderImage: UIImage(named: "user_dummy"),
                                                   options: .highPriority,
                                                   context: nil)
        settingsView.lblUserName.text = Constants().GETVALUE(keyname: "full_name")
        settingsView.lblEmailId.text = Constants().GETVALUE(keyname: "user_email_id")
        settingsView.lblPhoneNo.text = String(format:"%@ %@",Constants().GETVALUE(keyname: "dial_code"), Constants().GETVALUE(keyname: "phonenumber"))

        settingsView.tblPayment.reloadData()
    }
    func updateApi() {
        self.settingsView.lblUserName.text = Global_UserProfile.userName
            self.settingsView.lblPhoneNo.text = String(format:"%@ %@",Global_UserProfile.countryModel.dial_code,Global_UserProfile.mobileNumber)
            self.settingsView.lblEmailId.text = Global_UserProfile.emailID
            let strUserImg = Global_UserProfile.profileImage
            self.settingsView.imgUserThumb.sd_setImage(with: NSURL(string: strUserImg)! as URL,
                                                       placeholderImage:UIImage(named:"user_dummy"))
    }
    
    func navigationToSupportVC() {
        let nextViewController = SupportVC.initWithStory()
        nextViewController.modalPresentationStyle = .overCurrentContext
        nextViewController.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }

    override
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.settingsView.ThemeChange()
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    internal func onCurrencyChanged(currency: String) {
        let str = currency.components(separatedBy: " | ")
        strCurrency = String(format:"%@ %@", str[1],str[0])
        Constants().STOREVALUE(value: str[1] as String? ?? String(), keyname: "user_currency_symbol_org")// code
        Constants().STOREVALUE(value: str[0] as String? ?? String(), keyname: "user_currency_org")//symbal

        let indexPath = IndexPath(row: 1, section: 0)
        settingsView.tblPayment.reloadRows(at: [indexPath], with: .none)
        settingsView.tblPayment.reloadData()
    }
    
    
    //MARK: ***** Edit Profile Table view Datasource Methods *****
    /*
     Settings List View Table Datasource & Delegates
     */
    
   
    // Add Location Delegate method
    internal func onLocationAdded(latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationName: String)
    {
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: "access_token")
        dicts["latitude"] = String(format:"%f",latitude)
        dicts["longitude"] = String(format:"%f",longitude)
        
        if isHomeTapped
        {
            dicts["home"] = locationName
        }
        else
        {
            dicts["work"] = locationName
        }
        self.callUpdateLocationAPI(forHomeOrWork: isHomeTapped,latitude: latitude, longitude: longitude, locationName: locationName)
    }

    // STORING WORK/HOME LOCATION AFTER API DONE
    func setLocationName(latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationName: String)
    {
        if isHomeTapped
        {
            Constants().STOREVALUE(value: locationName, keyname: "home_loc")
            Constants().STOREVALUE(value: String(format:"%f",latitude), keyname: "home_latitude")
            Constants().STOREVALUE(value: String(format:"%f",longitude), keyname: "home_longitude")
        }
        else
        {
            Constants().STOREVALUE(value: locationName, keyname: "work_loc")
            Constants().STOREVALUE(value: String(format:"%f",latitude), keyname: "work_latitude")
            Constants().STOREVALUE(value: String(format:"%f",longitude), keyname: "work_longitude")
        }
    }
    
    // MARK: - API CALL -> UPDATE WORK/HOME LOCATION
    /*
        HERE WE STORING LOCATION NAME, LATITUDE & LONGIDUDE
     */
    func callUpdateLocationAPI(forHomeOrWork : Bool,latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationName: String)
    {
       
        self.accountViewModel.updateUserLocation(forHomeOrWork: forHomeOrWork,
                                                 name: locationName,
                                                 latitude: latitude,
                                                 longitude: longitude) {
            self.setLocationName(latitude: latitude, longitude: longitude, locationName: locationName)
            self.settingsView.tblPayment.reloadData()
        }
      
        
        
    }
    
    // MARK: LOGOUT API CALL
    /*
     */
    func callLogoutAPI() {
        self.accountViewModel.callLogoutAPI() { result in
            switch result {
            case .success(true):
                self.removeAllNotication()
            case .success(false):
                break
            case .failure(_):
                break
            }
        }
     
    }
    func deleteAccountVerification() {
        var paramDict = [String:Any]()
        paramDict["token"] = Constants().GETVALUE(keyname: "access_token")
        paramDict["user_type"] = "user"
        paramDict["isNeedOtp"] = "false"
       
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"delete_verification", paramDict: paramDict, viewController:self, isToShowProgress:true, isToStopInteraction:false,complete: { (response) in
         
            
            if response["status_code"] as? String == "1" {
                
                let alert = UIAlertController(title: "Do you want to delete your account", message: "",  preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
//                if (isNeedOtp == true){
//                    let supportVC = DeleteProfileVC.initWithStory()
//                    supportVC.recievedOTP = responseDict.otpStatus
//                    self.tabBarController?.tabBar.isHidden = true
//                        self.navigationController?.pushViewController(supportVC, animated: false)
//                    }
                    
                    self.deleteVerificationOTP()
                    
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
                
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                Utilities.showAlertMessage(message: response.status_message, onView: self)
            }
            
        }){(error) in
            
        }
                                                       }
    
    func deleteVerificationOTP() {
        var paramDict = [String:Any]()
        paramDict["token"] = Constants().GETVALUE(keyname: "access_token")
        paramDict["user_type"] = "user"
        paramDict["isNeedOtp"] = "true"
       
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"delete_verification", paramDict: paramDict, viewController:self, isToShowProgress:true, isToStopInteraction:false,complete: { (response) in
            
            
            if response["status_code"] as? String == "1" {
                
                let supportVC = DeleteProfileVC.initWithStory()
          
                supportVC.recievedOTP = response.otpStatus
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(supportVC, animated: false)
            }
            
        }){(error) in
            
        }
    }
    
    func removeAllNotication() {
        for observer in Shared.instance.notifObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        Shared.instance.notifObservers.removeAll()
    }
    
    // AFTER USER LOGOUT, WE SHOULD RESET WORK/HOME LOCATION DETAILS
    func resetUserLocations() {
        Constants().STOREVALUE(value: "", keyname: "home_loc")
        Constants().STOREVALUE(value: "", keyname: "home_latitude")
        Constants().STOREVALUE(value: "", keyname: "home_longitude")
        
        Constants().STOREVALUE(value: "", keyname: "work_loc")
        Constants().STOREVALUE(value: "", keyname: "work_latitude")
        Constants().STOREVALUE(value: "", keyname: "work_longitude")
    }
    

   
}
