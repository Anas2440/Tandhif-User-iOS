//
//  AccountViewModel.swift
//  GoferHandy
//
//  Created by trioangle on 04/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias NumberValidationResponse = (otp : String?,verified : Bool,message : String?)

class AccountViewModel: BaseViewModel {
//    var profileModel : ProfileModel? = nil{
//        didSet{ }
//    }
    var jobRequest: JobRequestModel? = nil
    override init() {
        super.init()
    }
    func LoginApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        print(params)
        guard NetworkManager.instance.isNetworkReachable else {return}
        ConnectionHandler.shared.getRequest(for: APIEnums.login,
                                            params: params)
            .responseJSON({ (json) in
                let loginData = LoginModel(json)
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure(loginData.status_message)))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    
    func GuestLoginApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
//        guard let params = parms as? JSON else{
////            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
//            return
//        }
        print(parms)
        guard NetworkManager.instance.isNetworkReachable else {return}
        ConnectionHandler.shared.getRequest(for: APIEnums.guest_login,
                                            params: parms as? JSON ?? [:])
            .responseJSON({ (json) in
                let loginData = LoginModel(json)
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure(loginData.status_message)))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    
    func SocialInfoApiCall(parms: [AnyHashable: Any],completionHandler : @escaping (Result<String,Error>) -> Void){
        guard let parameters = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
       
        Shared.instance.showLoaderInWindow()
        ConnectionHandler.shared.getRequest(for: APIEnums.signUp,params: parameters
        ).responseJSON({ (json) in
            Shared.instance.removeLoaderInWindow()
            let user = LoginModel(json)
            if json.isSuccess{
                completionHandler(.success(user.status_message))

            }else{
                completionHandler(.failure(CommonError.failure(user.status_message)))

            }
           

        }).responseFailure({ (error) in
        Shared.instance.removeLoaderInWindow()
            completionHandler(.failure(CommonError.failure(error)))
        })
            
       
    }
    
    func updatePasswordApi(params:JSON,
                           completionHandler: @escaping (Result<CommonModel,Error>) -> Void) {
      ConnectionHandler.shared
        .getRequest(for: APIEnums.updateNewPassword,
                    params: params)
        .responseDecode(to: CommonModel.self, { response in
            completionHandler(.success(response))
        })
        .responseFailure({ (error) in
            completionHandler(.failure(CommonError.failure(error)))
      })
    }
  
  
    func resetPasswordApi(parms: [AnyHashable: Any],completionHandler : @escaping (Result<Bool,Error>) -> Void){
        guard let parameters = parms as? JSON else{
                   AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
                   return
               }
        ConnectionHandler.shared.getRequest(for: APIEnums.updatePassword, params: parameters)
              .responseJSON({ (json) in
                  let loginData = LoginModel(json)
                  if json.isSuccess{
//                      self.showPage()
//                    completionHandler(true,loginData.status_message)
                    completionHandler(.success(true))
                  }else{
//                      self.lblErrorMsg.isHidden = false
//                      self.lblErrorMsg.text = loginData.status_message
//                    completionHandler(false,loginData.status_message)
                    completionHandler(.failure(CommonError.failure(loginData.status_message)))
                  }
//                  self.removeProgress()
              }).responseFailure({ (error) in

//                  self.removeProgress()
//                  AppDelegate.shared.createToastMessage(error)
                completionHandler(.failure(CommonError.failure(error)))
              })

    }
    func wsToVerifyOTP(parms: JSON,completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        
        ConnectionHandler.shared.getRequest(for: .otpVerification, params: parms).responseJSON { (json) in
            if json.isSuccess {
                completionHandler(.success(json.bool("status")))
            } else {
                completionHandler(.success(json.bool("status")))
            }
        }.responseFailure ({ (error) in
            completionHandler(.failure(CommonError.failure(error)))
        })
    }
    func wsToVerifyNumberApiCall(parms: [AnyHashable: Any],completionHandler : @escaping (Result<NumberValidationResponse,Error>) -> Void){
        guard let parameters = parms as? JSON else{
                           AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
                           return
                       }
        //        let result = Result<NumberValidationResponse,Error>()

     ConnectionHandler.shared.getRequest(for: APIEnums.validateNumber, params: parameters).responseJSON({ (json) in
         UberSupport.shared.removeProgressInWindow()
         if json.isSuccess{
             let isValid = json.isSuccess
             let otp = json.string("otp")
             let message = json.status_message
             UberSupport.shared.removeProgressInWindow()
             if isValid{
//                 if self.viewController.mobileValidationView.currentScreenState  != .OTP{//if already not in otp screen
//                     self.viewController.mobileValidationView.aniamateView(for: .OTP)
//                 }
//                 self.viewController.mobileValidationView.otpFromAPI = otp
//                 print("otp\(self.viewController.mobileValidationView.otpFromAPI ?? "")")
//
//                 appDelegate.createToastMessage("OTP \(otp)")
//                 self.viewController.mobileValidationView.removeProgress()
//                completionHandler(true,message,isValid,otp)
                let response = NumberValidationResponse(otp : otp,verified : isValid,message: message)

                completionHandler(.success(response))
             }else{
//                 self.viewController.mobileValidationView.otpFromAPI = nil
//                 self.viewController.mobileValidationView.showError(message)
//                 self.viewController.mobileValidationView.removeProgress()
//                completionHandler(false,message,isValid,"")
                completionHandler(.failure(CommonError.failure(message)))

             }

         }else{
//             UberSupport.shared.removeProgressInWindow()
//         AppDelegate.shared.createToastMessage(json.status_message)
//             self.viewController.mobileValidationView.removeProgress()
//            completionHandler(false,json.status_message,false,"")
            completionHandler(.failure(CommonError.failure(json.status_message)))
         }
     }).responseFailure({ (error) in
//         UberSupport.shared.removeProgressInWindow()
//         AppDelegate.shared.createToastMessage(error)
        completionHandler(.failure(CommonError.failure(error)))
     })
    }
    
    func profileVCApiCall(parms: [AnyHashable: Any],
                          completionHandler : @escaping (Result<JSON,Error>) -> Void){
        guard let parameters = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        Shared.instance.showLoaderInWindow()
        ConnectionHandler.shared
                     .getRequest(
                         for: APIEnums.updateRiderProfile,
                         params: parameters)
                     .responseJSON({ (json) in
                        Shared.instance.removeLoaderInWindow()
                        completionHandler(.success(json))
                     }).responseFailure({ (error) in
                        Shared.instance.removeLoaderInWindow()
                        completionHandler(.failure(CommonError.failure(error)))
                     })
    }
    func getPaymentList(withWallet : Bool = false ,_ response : @escaping Closure<Result<PaymentList,Error>>){
        
        self.connectionHandler?
            .getRequest(for: .getPaymentOptions,
                        params: ["is_wallet": withWallet ? "1" : "0"])
            .responseDecode(to: PaymentList.self, { (result) in
                response(.success(result))
            }).responseFailure({ (error) in
                response(.failure(CommonError.failure(error)))
            })
    }
    func getUserProfile(userProfile : @escaping Closure<Result<ProfileModel,Error>>){
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym

        self.connectionHandler?
            .getRequest(for: .riderProfile, params: param)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    let profileModel = ProfileModel(json)
                    profileModel.store()
                    let currency_code = json.string("currency_code")
                    let currency_symbol = json.string("currency_symbol")
                    Constants().STOREVALUE(value: currency_symbol, keyname: USER_CURRENCY_SYMBOL_ORG)
                    Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG)
//                    Constants().STOREVALUE(value: currency_symbol, keyname: USER_CURRENCY_SYMBOL_ORG)
//                    Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG)
//                    self.profileModel = profileModel
                    userProfile(.success(profileModel))
                }else{
                    userProfile(.failure(CommonError.failure(json.status_message)))
                }
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                userProfile(.failure(CommonError.failure(error)))
            })
    }
    func updateHomeWorkLocation(_ dicts: [AnyHashable: Any],latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationName: String,result : @escaping Closure<Bool>) {
        guard let parameter = dicts as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.connectionHandler?
            .getRequest(
                for: APIEnums.updateRiderLocation,
                        params: parameter
        ).responseJSON({ (json) in
            if json.isSuccess{
                result(true)
            }else{
                result(false)
                AppDelegate.shared.createToastMessage(json.status_message)
            }
            UberSupport.shared.removeProgressInWindow()
        }).responseFailure({ (error) in
            result(false)
//            AppDelegate.shared.createToastMessage(error)
            UberSupport.shared.removeProgressInWindow()
        })
        
        
    }
    
    func checkVersion(param: JSON,
                      result : @escaping (Result<JSON,Error>) -> Void) {
        ConnectionHandler.shared
            .getRequest(for: .force_update,
                           params: param)
            .responseJSON({ response in
                result(.success(response))
            })
            .responseFailure({ error in
                result(.failure(CommonError.failure(error)))
            })
    }
    
    func updateCurrentLocation(_ location : MyLocationModel,
                               result : @escaping Closure<Bool>){
        guard let address = location.getAddress() else{
            location.getAddress { (_) in
                self.updateCurrentLocation(location, result: result)
            }
              return
          }
        let params : JSON = [
            "address" : address,
            "current_latitude" : location.coordinate.latitude,
            "current_longitude" : location.coordinate.longitude
        ]
          UberSupport.shared.showProgressInWindow(showAnimation: true)
          self.connectionHandler?
              .getRequest(
                  for: APIEnums.updateCurrentLocation,
                          params: params
          ).responseJSON({ (json) in
              if json.isSuccess{
                  result(true)
              }else{
                  result(false)
                  AppDelegate.shared.createToastMessage(json.status_message)
              }
              UberSupport.shared.removeProgressInWindow()
          }).responseFailure({ (error) in
              result(false)
              UberSupport.shared.removeProgressInWindow()
          })
          
          
      }
    func onPromoCode(_ result : @escaping Closure<Bool>) {
        // Handy Splitup Start
        let param : JSON = ["business_id" : AppWebConstants.businessType.rawValue] // [:]
        // Handy Splitup End
           self.connectionHandler?
            .getRequest(for: .getPromoDetails,
                        params: param)
               .responseDecode(
                   to: PromoContainerModel.self,
                   { (container) in
                       result(true)
                    
                    if let code: String = UserDefaults.value(for: .promo_applied_code),
                       container.promos.isEmpty || container.promos.filter({$0.code == code}).isEmpty {
                        UserDefaults.set(0, for: .promo_id)
                    }
                    
               }).responseFailure({ (error) in
                result(false)
               })
           
           
       }
    //MARK:- ReferalVC
    func getReferal(_ result : @escaping Closure<(Result<(referal : String,
                    totalEarning : String,
                    maxReferal : String,
                    incomplete : [ReferalModel],
                    complete :[ReferalModel],
                    appLink: String),Error>)>){
        
         Shared.instance.showLoaderInWindow()
        self.connectionHandler?
         .getRequest(for: .getReferals, params: [:])
            .responseJSON({ (json) in
                Shared.instance.removeLoaderInWindow()
                let referalCode = json.string("referral_code")
                let refAppLink = json.string("referral_link")
                let total_earning = json.string("total_earning")
                let max_referal = json.string("referral_amount")
                let inCompleteReferals = json.array("pending_referrals")
                    .compactMap({ReferalModel.init(withJSON: $0)})
                let completedReferals = json.array("completed_referrals")
                    .compactMap({ReferalModel.init(withJSON: $0)})
                result(.success((referal: referalCode,
                                 totalEarning: total_earning,
                                 maxReferal: max_referal,
                                 incomplete: inCompleteReferals,
                                 complete: completedReferals,
                                 appLink: refAppLink)))
            }).responseFailure({ (error) in
                Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
    // MARK: LOGOUT API CALL
    /*
     */
    func callLogoutAPI(_ completionHandler: @escaping (Result<Bool,Error>) -> Void) {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        self.connectionHandler?
            .getRequest(
                for: .logout, params: [:] )
            .responseDecode(to: CommonModel.self, { response in
                if response.isSuccess {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set("", forKey:"getmainpage")
                    userDefaults.synchronize()
                    self.resetUserLocations()
                    Global_UserProfile = nil
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    UserDefaults.set(false,for: .InitiatedTheme)
                    // Service Splitup Start
                    // Handy Splitup Start
                    // Delivery Splitup Start

                    if AppWebConstants.businessType == .Services {
                        // Handy Splitup End
                        Shared.instance.currentBookingType = .bookNow
                        // Handy Splitup Start
                    }
                    // Delivery Splitup End
                    if !isSingleApplication {
                        AppWebConstants.businessType = .Gojek
                    }
                    // Handy Splitup End
                    UserDefaults.set(false,for: .is_from_social_login)
                    userDefaults.removeObject(forKey: USER_CARD_BRAND)
                    userDefaults.removeObject(forKey: USER_CARD_LAST4)
                    userDefaults.removeObject(forKey: USER_ACCESS_TOKEN)
                    PushNotificationManager.shared?.stopObservingUser()
                    PaymentOptions.cash.setAsDefault()
                    UserDefaults.clearAllKeyValues()
                    Constants().STOREVALUE(value: "No" , keyname: USER_SELECT_WALLET)
                    AppDelegate.shared.option = ""
                    AppDelegate.shared.amount = ""
                    do{
                        try CallManager.instance.should(waitForCall: false)
                        CallManager.instance.wipeUserData()
                        CallManager.instance.deinitialize()
                    }catch{
                    }
                    AppDelegate.shared.onSetRootViewController(viewCtrl:nil)
                    completionHandler(.success(true))
                } else {
                    AppDelegate.shared.createToastMessage(response.statusMessage)
                    completionHandler(.success(false))
                }
                UberSupport.shared.removeProgressInWindow()
            })
            .responseFailure({ (error) in
                debug(print: error)
                UberSupport.shared.removeProgressInWindow()
                completionHandler(.failure(CommonError.failure(error)))
            })
        
    }
    
    func getPromoDetailsAPI(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        // Handy Splitup Start
        var params = param
        params["business_id"] = AppWebConstants.businessType.rawValue
        // Handy Splitup Start
        self.connectionHandler?.getRequest(for: .getPromoDetails,
                                              params: [:])
            .responseJSON({ (json) in
                if json.isSuccess {
                    result(.success(json))
                } else {
                    result(.failure(CommonError.failure(json.status_message)))
                }
            }).responseFailure({ (error) in
                result(.failure(CommonError.failure(error)))
            })
    }
    func addPromoCode(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler?.getRequest(for: .addPromoCode, params: param).responseJSON({ (json) in
            if json.isSuccess {
                result(.success(json))
            } else {
                result(.failure(CommonError.failure(json.status_message)))
            }
        }).responseFailure({ (error) in
            result(.failure(CommonError.failure(error)))
        })
    }
    
    func checkPromoValidation(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler?.getRequest(for: .checkUserPromo, params: param).responseJSON({ (json) in
            if json.isSuccess {
                result(.success(json))
            } else {
                result(.failure(CommonError.failure(json.status_message)))
            }
        }).responseFailure({ (error) in
            result(.failure(CommonError.failure(error)))
        })
    }
    
    func wsToUpdateLocation(param: JSON,
                            _ result: @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler?.getRequest(for: .updateCurrentLocation, params: param).responseJSON({ json in
            result(.success(json))
        }).responseFailure({ error in
            result(.failure(CommonError.failure(error)))
        })
    }
    
    //MARK:- SettingsVC
    
    func getRiderProfile(onComplete : @escaping ()->()){
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var param = JSON()
       let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
       let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
       param["currency_code"] = userCurrencyCode
       param["currency_symbol"] = userCurrencySym
        self.connectionHandler?
            .getRequest(for: .riderProfile,params: param)
            .responseJSON({ (json) in
                //let _ = DriverDetailModel(jsonForRiderProfile: json)
                if json.isSuccess{
                    onComplete()
                    
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
                UberSupport.shared.removeProgressInWindow()
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
//                AppDelegate.shared.createToastMessage(error)
            })
    }
    func updateUserLocation(forHomeOrWork : Bool,name : String,
                            latitude : Double,longitude : Double,
                            onSuccess : @escaping ()->()){
        var dicts = JSON()
        dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["latitude"] = String(format:"%f",latitude)
        dicts["longitude"] = String(format:"%f",longitude)
        
        if forHomeOrWork{
            dicts["home"] = name
        }else{
            dicts["work"] = name
        }
        
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.connectionHandler?
            .getRequest(
                for: APIEnums.updateRiderLocation,
                        params: dicts
        ).responseJSON({ (json) in
            if json.isSuccess{
                onSuccess()
            }else{
                AppDelegate.shared.createToastMessage(json.status_message)
            }
            UberSupport.shared.removeProgressInWindow()
        }).responseFailure({ (error) in
//            AppDelegate.shared.createToastMessage(error)
            UberSupport.shared.removeProgressInWindow()
        })
    }
    //MARK:- Reset
    private func resetUserLocations()
    {
        Constants().STOREVALUE(value: "", keyname: USER_HOME_LOCATION)
        Constants().STOREVALUE(value: "", keyname: USER_HOME_LATITUDE)
        Constants().STOREVALUE(value: "", keyname: USER_HOME_LONGITUDE)
        
        Constants().STOREVALUE(value: "", keyname: USER_WORK_LOCATION)
        Constants().STOREVALUE(value: "", keyname: USER_WORK_LATITUDE)
        Constants().STOREVALUE(value: "", keyname: USER_WORK_LONGITUDE)
    }
    
    
    //MARK: SOCIAL LOGIN
    
    func checkSocialLogin(params: JSON, accountDetails : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler?.getRequest(for: .socialSignup, params: params).responseJSON({ (response) in
        
            accountDetails(.success(response))
        }).responseFailure({ (error) in
            accountDetails(.failure(CommonError.failure(error)))
        })
    }
    
    func showMenuScreen(_ viewController:UIViewController&MenuResponseProtocol){
        viewController.view.endEditing(true)
        let menuVc = MenuVC.initWithStory(viewController,
                                          accountViewModel: self)
        menuVc.modalPresentationStyle = .overCurrentContext
        viewController.present(menuVc, animated: false, completion: nil)
        return
    }

    func getJobRequestApi(parms: [AnyHashable: Any],completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        
        self.connectionHandler?.getRequest(for: APIEnums.getJobRequest, params: params)
            .responseDecode(to: JobRequestModel.self) { (response) in
                self.jobRequest = response
                completionHandler(.success(true))
        }
        .responseFailure { (error) in
            print(error)
            completionHandler(.failure(CommonError.failure(error)))
        }
        
    }
}
