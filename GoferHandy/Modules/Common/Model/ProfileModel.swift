/**
* ProfileModel.swift
*
* @package Gofer
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/


import Foundation
import UIKit
import CoreLocation

class ProfileModel : NSObject {
    
    //MARK Properties
    var status_message : String = ""
    var status_code : String = ""
    var user_name : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var user_thumb_image : String = ""
    var user_normal_image_url : String = ""
    var user_large_image_url : String = ""
    var user_small_image_url : String = ""
    var dob : String = ""
    var email_id : String = ""
    var user_location : String = ""
    var member_from : String = ""
    var about_me : String = ""
    var school : String = ""
    var gender : String = ""
    var phone : String = ""
    var work : String = ""
    var is_email_connect : String = ""
    var is_facebook_connect : String = ""
    var is_google_connect : String = ""
    var is_linkedin_connect : String = ""
    var user_id : String = ""
    var countryModel : CountryModel = .default
    var isPasswordPresented : Bool = false
    //MARK: Address
    var currentAddress : String = ""
    var currentLatitude: Double = .zero
    var currentLongitude : Double = .zero
    var currentLocaiton : String = ""
    var currencyCode = ""
    var myCurrentLocation : MyLocationModel {
        didSet {
            self.currentLocaiton = myCurrentLocation.getAddress() ?? ""
        }
    }
    var currencySymbol = ""
    var walletAmount = ""
    //MAKR:- Getter
    var currentCLLocation : CLLocation{
        return .init(latitude: self.currentLatitude, longitude: self.currentLongitude)
    }
    var getUserName : String{
        if !self.user_name.isEmpty{
            return self.user_name
        }
        return self.first_name + " " + self.last_name
    }
    var userLocaitonIsAvailable : Bool{
        return !self.currentAddress.isEmpty
    }
    init(_ json : JSON){
        self.user_name =  json.string("user_name")
        self.first_name = json.string("first_name")
        self.last_name = json.string("last_name")
        self.user_thumb_image = json.string("profile_image")
        self.user_normal_image_url = json.string("profile_image")
        self.user_large_image_url = json.string("profile_image")
        self.user_small_image_url = json.string("profile_image")
        self.email_id =  json.string("email_id")
        self.phone = json.string("mobile_number")
        self.myCurrentLocation = MyLocationModel(address: json.string("address"),
                                                 location: CLLocation(latitude: json.double("current_latitude"),
                                                                      longitude: json.double("current_longitude")))
        self.currentAddress = json.string("address")
        self.currentLatitude = json.double("current_latitude")
        self.currentLongitude = json.double("current_longitude")
        self.currencyCode = json.string("currency_code")
        self.currencySymbol = json.string("currency_symbol")

        self.walletAmount = json.string("wallet_amount")
        self.isPasswordPresented = json.bool("password")
        self.countryModel = CountryModel(forDialCode: nil,
                                         withCountry: json.string("country_code"))
      
    }
    func store(){
        if walletAmount.isEmpty {
            UserDefaults.set("0.0", for: .wallet_amount)
        }else{
            UserDefaults.set(self.walletAmount, for: .wallet_amount)
        }
        
        Constants().STOREVALUE(value: self.getUserName, keyname: "full_name")
        Constants().STOREVALUE(value: self.first_name, keyname: "first_name")
        Constants().STOREVALUE(value: self.last_name, keyname: "last_name")
        Constants().STOREVALUE(value: self.phone, keyname: "phonenumber")
        Constants().STOREVALUE(value: self.countryModel.dial_code, keyname: "dial_code")
        Constants().STOREVALUE(value: self.countryModel.country_code, keyname: "user_country_code")
        Constants().STOREVALUE(value: self.user_thumb_image, keyname: "user_image")
        Constants().STOREVALUE(value: self.email_id, keyname: "user_email_id")
        Constants().STOREVALUE(value: self.currencySymbol, keyname: "user_currency_symbol_org")
        SharedVariables.sharedInstance.currencySymbol = self.currencySymbol
        Constants().STOREVALUE(value: self.currencyCode , keyname: "user_currency_org")
    }
    //MARK: Inits
    func initiateProfileData(responseDict: NSDictionary) -> Any {
        user_name =  responseDict["user_name"] as? String ?? String()
        first_name = responseDict["first_name"] as? String ?? String()
        last_name = responseDict["last_name"] as? String ?? String()
        user_thumb_image = responseDict["profile_image"] as? String ?? String()
        user_normal_image_url = responseDict["normal_image_url"] as? String ?? String()
        user_large_image_url = responseDict["large_image_url"] as? String ?? String()
        user_small_image_url = responseDict["small_image_url"] as? String ?? String()
        email_id =  UberSupport().checkParamTypes(params: responseDict, keys:"email_id") as String
        phone = UberSupport().checkParamTypes(params: responseDict, keys:"mobile_number") as String
        return self
    }
    
    //MARK: Inits
    func initiateOtherProfileData(responseDict: NSDictionary) -> Any
    {
        user_name =  String(format:"%@ %@",responseDict["first_name"] as? String ?? String(),responseDict["last_name"] as? String ?? String()) as String
        first_name = responseDict["first_name"] as? String ?? String()
        last_name = responseDict["last_name"] as? String ?? String()
        user_thumb_image = responseDict["profile_image"] as? String ?? String()
        user_normal_image_url = responseDict["large_image"] as? String ?? String()
        user_large_image_url = responseDict["large_image"] as? String ?? String()
        user_small_image_url = responseDict["large_image"] as? String ?? String()
        user_location = responseDict["user_location"] as? String ?? String()
        member_from = UberSupport().checkParamTypes(params: responseDict, keys:"member_from") as String
        about_me = UberSupport().checkParamTypes(params: responseDict, keys:"about_me") as String
        return self
    }

    init (userDataModel : UserProfileDataModel) {
        self.user_name =  userDataModel.userName
        self.first_name = userDataModel.firstName
        self.last_name = userDataModel.lastName
        self.user_thumb_image = userDataModel.profileImage
        self.user_normal_image_url = userDataModel.profileImage
        self.user_large_image_url = userDataModel.profileImage
        self.user_small_image_url = userDataModel.profileImage
        self.email_id =  userDataModel.emailID
        self.phone = userDataModel.mobileNumber
        self.myCurrentLocation = MyLocationModel(address: userDataModel.address,
                                                 location: CLLocation(latitude: userDataModel.currentLatitude.toDouble(),
                                                                      longitude: userDataModel.currentLongitude.toDouble()))
        self.currentAddress = userDataModel.address
        self.currentLatitude = userDataModel.currentLatitude.toDouble()
        self.currentLongitude = userDataModel.currentLongitude.toDouble()
        self.currencyCode = userDataModel.currencyCode
        self.currencySymbol = userDataModel.currencySymbol

        self.walletAmount = userDataModel.walletAmount
        self.isPasswordPresented = userDataModel.password
        self.countryModel = CountryModel(forDialCode: nil,
                                         withCountry: userDataModel.countryCode)
      
    }
}
