/**
 * SplashVC.swift
 *
 * @package Gofer
 * @author Trioangle Product Team
 *
 * @link http://trioangle.com
 */

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire

enum ForceUpdate : String {
  case skipUpdate = "skip_update"
  case noUpdate = "no_update"
  case forceUpdate = "force_update"
}


class SplashVC: BaseViewController {
  
  //----------------------------------------------
  //MARK: - Outlets
  //----------------------------------------------
  
  @IBOutlet var splashView: SplashView!
  
  //----------------------------------------------
  //MARK: - Local Variables
  //----------------------------------------------
  
  var window = UIWindow()
  var isFirstTimeLaunch : Bool = false
  var transitionDelegate: UIViewControllerTransitioningDelegate?
  lazy var manager = CLLocationManager()
  
  var accViewModel : AccountViewModel!
  
  //----------------------------------------------
  // MARK: - Splashscreen launch
  //----------------------------------------------
  
  override
  func viewDidLoad() {
    super.viewDidLoad()
    if isFirstTimeLaunch {
//      self.initLocationCheck()
    }
    accViewModel = AccountViewModel()
  }
  
  override
  func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  //----------------------------------------------
  //MARK:- initWithStory
  //----------------------------------------------
  
  class func initWithStory() -> SplashVC {
    let splash : SplashVC = UIStoryboard.gojekCommon.instantiateViewController()
    return splash
  }
  
  //----------------------------------------------
  //MARK:- Language update flow
  //----------------------------------------------
  
  func wsToFetchLanguage() {
    var param = JSON()
    if let lang : String = UserDefaults.value(for: .default_language_option){
      param["language"] = lang
    }
    wsToGetLanguage(params: param) { result in
      switch result {
      case .success(_):
        DispatchQueue.main.async {
          self.splashView.initView()
        }
      case .failure(let error):
        debug(print: error)
        AppDelegate.shared.createToastMessage(error.localizedDescription)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          self.wsToFetchLanguage()
        }
      }
    }
  }
  
  //----------------------------------------------
  //MARK: - Onapplicaiton start
  //----------------------------------------------
  
  func onStart() {
    guard let appVersion = forceUpdateVersion else {return}
    var params = Parameters()
    params["version"] = appVersion
    ConnectionHandler.shared
      .getRequest(
        for: APIEnums.force_update,
           params: params)
      .responseJSON { (json) in
        if json.isSuccess {
          let shouldForceUpdate = json.string("force_update")
          let should = ForceUpdate(rawValue: shouldForceUpdate) ?? .skipUpdate
          let enableReferral = json.bool("enable_referral")
          let currency_code = json.string("default_curreny_code")
          let curreny_symbol = json.string("default_curreny_symbol")
          let userCurrencyCode = Constants().GETVALUE(keyname: "user_currency_org")
          let userCurrencySym = Constants().GETVALUE(keyname: "user_currency_symbol_org")
          if userCurrencyCode == "" || userCurrencySym == "" {
            Constants().STOREVALUE(value: curreny_symbol,
                                   keyname: "user_currency_symbol_org")
            Constants().STOREVALUE(value: currency_code,
                                   keyname: "user_currency_org")
          }
          // Handy Splitup Start
          let singleService = json.bool("single_service")
          let singleSubService = json.bool("single_sub_service")
          let businessType = BusinessType.init(rawValue: json.int("business_id")) ?? .Gojek
          let categoryID = json.int("category_id")
          let is18PlusVerification = json.bool("is_18_plus_req")
          let serviceName = json.string("service_name").isEmpty ? "Delivery All" : json.string("service_name")
          let reciptImageReq = json.bool("receipt_image_req")
          isSingleApplication = true // Single Application Set True
          if singleService {
            AppWebConstants.businessType = businessType
            AppWebConstants.isSingleCatagoryApplication = singleSubService
            AppWebConstants.isSingleCatagoryID = singleSubService ? categoryID : 0
            AppWebConstants.serviceName = serviceName
            AppWebConstants.is18plusVerificationRequired = singleSubService ? is18PlusVerification : false
            AppWebConstants.isReciptImageRequired = singleSubService ? reciptImageReq : false
          }
          // Handy Splitup End
          let appleLogin = json.bool("apple_login")
          let facebookLogin = json.bool("facebook_login")
          let googleLogin = json.bool("google_login")
          let otpEnabled = json.bool("otp_enabled")
          let supportArray = json.array("support")
          let support = supportArray.compactMap({Support.init($0)})
          Shared.instance.socialLoginSupport(appleLogin: appleLogin, facebookLogin: facebookLogin, googleLogin: googleLogin, otpEnabled: otpEnabled, supportArr: support )
          Shared.instance.enableReferral(enableReferral)
          self.splashView.shouldForceUpdate(should)
        } else {
          debug(print: "something went wrong in check version")
        }
      }.responseFailure { (error) in
        debug(print: "something went wrong in check version")
        //                AppDelegate.shared.createToastMessage(error)
      }
  }
  
  func callGuestLoginAPI(parms: [AnyHashable: Any]){
    self.accViewModel
      .GuestLoginApicall(parms: parms){(result) in
        switch result{
          case .success:
            let userDefaults = UserDefaults.standard
            userDefaults.set("rider", forKey:"getmainpage")
            UserDefaults.standard.synchronize()
            AppDelegate.shared.onSetRootViewController(viewCtrl: self)
          case .failure(let error):
            print(error.localizedDescription)
            AppDelegate.shared.createToastMessage(error.localizedDescription)
        }
      }
  }
}


extension SplashVC : CLLocationManagerDelegate {
  
  func initLocationCheck() {
    self.manager.delegate = self
    self.manager.requestAlwaysAuthorization()
    self.manager.requestWhenInUseAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    guard let _location = locations.last else { return }
    _location.getCountry({ country in
      if country.isFrance() {
        manager.stopUpdatingLocation()
        self.FranceHomeScreen()
      } else if country.isDubai() {
        manager.stopUpdatingLocation()
        self.DubaiHomeScreen()
      } else {
        self.commonAlert.setupAlert(alert: appName, alertDescription: "Sorry This Application Not Available in Your Country", okAction: LangCommon.ok, cancelAction: nil, userImage: nil)
        self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
          
        }
      }
    })
  }
  
  func DubaiHomeScreen() {
    
  }
  
  func FranceHomeScreen() {
    
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
      case .notDetermined:
          self.forceEnableLocation()
      case .restricted:
          self.forceEnableLocation()
      case .denied:
          self.forceEnableLocation()
      case .authorizedAlways:
          self.locationUpdate(start: true)
      case .authorizedWhenInUse:
          self.locationUpdate(start: true)
      case .authorized:
          self.locationUpdate(start: true)
      @unknown default:
          fatalError()
      }
  }
  
  func locationUpdate(start: Bool) {
      if start {
          self.manager.startUpdatingLocation()
      } else {
          self.manager.stopUpdatingLocation()
      }
  }
  
  func forceEnableLocation() {
    let alert = CommonAlert()
    alert.setupAlert(alert: "Please Enable Location", alertDescription: "Location is to Important Provide Special Service", okAction: "Enable", cancelAction: "Cancel", userImage: nil)
    alert.addAdditionalOkAction(isForSingleOption: false) {
      
    }
    alert.addAdditionalCancelAction {
      
    }
  }
}


extension CLLocation {
    func getCountry(_ address : @escaping Closure<String>){
        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        aGMSGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(self.coordinate.latitude,
                                                                         self.coordinate.longitude)) { (response, error) in
            if error == nil && response != nil {
                if let gmsAddress: GMSAddress = response?.firstResult(),
                   let country = gmsAddress.country { address(country) }
                else { address("") }
            } else { address("") }
        }
    }
}

extension String {
    func isFrance() -> Bool { return self.lowercased().contains("france") }
    func isDubai() -> Bool { return self.lowercased().contains("dubai") }
}
