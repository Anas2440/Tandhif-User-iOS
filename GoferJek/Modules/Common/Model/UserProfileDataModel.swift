//
//  UserProfileDataModel.swift
//  Goferjek
//
//  Created by trioangle on 28/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userProfileDataModel = try? newJSONDecoder().decode(UserProfileDataModel.self, from: jsonData)

import Foundation

// MARK: - UserProfileDataModel
class UserProfileDataModel: Codable {
    let statusCode, statusMessage: String
    var firstName, lastName: String
    let countryCode, mobileNumber: String
    let userID: Int
    var emailID: String
    let password: Bool
    var profileImage: String
    let currencyCode, currencySymbol, home, work: String
    let homeLatitude, homeLongitude, workLatitude, workLongitude: String
    var currentLatitude, currentLongitude, address, walletAmount: String
    let promoDetails: [PromoDetail]
    let requestOptions: [RequestOption]
    let updatedAt: String
    var userName : String
    var accessToken : String
    var paypalEmailID : String
    var currentCLLocation : CLLocation { get {  return .init(latitude: Double(self.currentLatitude) ?? 0, longitude: Double(self.currentLongitude) ?? 0) } }
    var userLocaitonIsAvailable : Bool{ return !self.address.isEmpty }
    var myCurrentLocation : MyLocationModel { get { return MyLocationModel(address: self.address, location: self.currentCLLocation) } }
    var countryModel : CountryModel
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case userID = "user_id"
        case emailID = "email_id"
        case password
        case profileImage = "profile_image"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case home, work
        case homeLatitude = "home_latitude"
        case homeLongitude = "home_longitude"
        case workLatitude = "work_latitude"
        case workLongitude = "work_longitude"
        case currentLatitude = "current_latitude"
        case currentLongitude = "current_longitude"
        case address
        case walletAmount = "wallet_amount"
        case promoDetails = "promo_details"
        case requestOptions = "request_options"
        case updatedAt = "updated_at"
        case accessToken = "access_token"
        case paypalEmailID = "paypal_email_id"
    }
    required init(from decoder : Decoder) throws{
             let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.firstName = container.safeDecodeValue(forKey: .firstName)
        self.lastName = container.safeDecodeValue(forKey: .lastName)
        self.countryCode = container.safeDecodeValue(forKey: .countryCode)
        self.mobileNumber = container.safeDecodeValue(forKey: .mobileNumber)
        self.userID = container.safeDecodeValue(forKey: .userID)
        self.emailID = container.safeDecodeValue(forKey: .emailID)
        self.password = container.safeDecodeValue(forKey: .password)
        self.profileImage = container.safeDecodeValue(forKey: .profileImage)
        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
        self.currencySymbol = container.safeDecodeValue(forKey: .currencySymbol)
        self.home = container.safeDecodeValue(forKey: .home)
        self.work = container.safeDecodeValue(forKey: .work)
        self.homeLatitude = container.safeDecodeValue(forKey: .homeLatitude)
        self.homeLongitude = container.safeDecodeValue(forKey: .homeLongitude)
        self.workLatitude = container.safeDecodeValue(forKey: .workLatitude)
        self.workLongitude = container.safeDecodeValue(forKey: .workLongitude)
        self.currentLatitude = container.safeDecodeValue(forKey: .currentLatitude)
        self.currentLongitude = container.safeDecodeValue(forKey: .currentLongitude)
        self.address = container.safeDecodeValue(forKey: .address)
        self.walletAmount = container.safeDecodeValue(forKey: .walletAmount)
        self.promoDetails = try container.decodeIfPresent([PromoDetail].self, forKey: .promoDetails) ?? [PromoDetail]()
        self.requestOptions = try container.decodeIfPresent([RequestOption].self, forKey: .promoDetails) ?? [RequestOption]()
        self.updatedAt = container.safeDecodeValue(forKey: .updatedAt)
        self.userName = String(format:"%@ %@",self.firstName, self.lastName)
        let currencySymbol = (self.currencySymbol ).stringByDecodingHTMLEntities
        Constants().STOREVALUE(value: currencySymbol, keyname: USER_CURRENCY_SYMBOL_ORG)
        let currencyCode = self.currencyCode
        Constants().STOREVALUE(value: currencyCode , keyname: USER_CURRENCY_ORG)
        self.paypalEmailID = container.safeDecodeValue(forKey: .paypalEmailID)
        self.accessToken = container.safeDecodeValue(forKey: .accessToken)
        self.countryModel = CountryModel(forDialCode: nil, withCountry: self.countryCode)
    }
    init () {
        self.statusCode = ""
        self.statusMessage = ""
        self.firstName = ""
        self.lastName = ""
        self.countryCode = ""
        self.mobileNumber = ""
        self.userID = 0
        self.emailID = ""
        self.password = false
        self.profileImage = ""
        self.currencyCode = ""
        self.currencySymbol = ""
        self.home = ""
        self.work = ""
        self.homeLatitude = ""
        self.homeLongitude = ""
        self.workLatitude = ""
        self.workLongitude = ""
        self.currentLatitude = ""
        self.currentLongitude = ""
        self.address = ""
        self.walletAmount = ""
        self.promoDetails = [PromoDetail]()
        self.requestOptions = [RequestOption]()
        self.updatedAt = ""
        self.userName = ""
        self.paypalEmailID = ""
        self.accessToken = ""
        self.countryModel = .default
    }
    
    init (_ json : JSON) {
        self.statusMessage = json.string("status_message")
        self.statusCode = json.string("status_code")
        self.accessToken = json.string("access_token")
        self.firstName = json.string("first_name")
        self.lastName = json.string("last_name")
        self.mobileNumber = json.string("mobile_number")
        self.emailID = json.string("email_id")
        self.paypalEmailID = json.string("paypal_email_id")
        self.userName = String(format:"%@ %@",self.firstName, self.lastName)
        self.profileImage = json.string("user_thumb_image")
        self.profileImage = ""
        if !json.string("profile_image").isEmpty{
            self.profileImage = json.string("profile_image")
        }
        self.emailID = json.string("email_id")
        self.userID = json.int("user_id")
        self.countryCode = json.string("country_code")
        self.home = json.string("home")
        self.work = json.string("work")
        self.homeLatitude = json.string("home_latitude")
        self.homeLongitude = json.string("home_longitude")
        self.workLatitude = json.string("work_latitude")
        self.workLongitude = json.string("work_longitude")
        self.walletAmount = json.string("wallet_amount")
        self.promoDetails = json.array("promo_details")
        let currencySymbol = (json.string("currency_symbol") ).stringByDecodingHTMLEntities
        Constants().STOREVALUE(value: currencySymbol, keyname: USER_CURRENCY_SYMBOL_ORG)
        self.currencySymbol = currencySymbol
        let currencyCode = json.string("currency_code")
        Constants().STOREVALUE(value: currencyCode , keyname: USER_CURRENCY_ORG)
        self.currencyCode = currencyCode
        self.requestOptions = json.array("request_options")
        self.currentLatitude = json.string("current_latitude")
        self.currentLongitude = json.string("current_longitude")
        self.password = json.bool("password")
        self.address = json.string("address")
        self.updatedAt = json.string("updated_at")
        self.userName = String(format:"%@ %@",self.firstName, self.lastName)
        self.countryModel = CountryModel(forDialCode: nil, withCountry: json.string("country_code"))
    }
    func storeRiderBasicDetail(){
        Constants().STOREVALUE(value: self.currencySymbol, keyname: USER_CURRENCY_SYMBOL_ORG)
        Constants().STOREVALUE(value: self.currencyCode, keyname: USER_CURRENCY_ORG)
        Constants().STOREVALUE(value: self.promoDetails.count.description, keyname: USER_PROMO_CODE)
        Constants().STOREVALUE(value: self.userName, keyname: USER_FULL_NAME)
        Constants().STOREVALUE(value: self.firstName, keyname: USER_FIRST_NAME)
        Constants().STOREVALUE(value: self.lastName, keyname: USER_LAST_NAME)
        Constants().STOREVALUE(value: self.profileImage, keyname: USER_IMAGE_THUMB)
        Constants().STOREVALUE(value: self.emailID, keyname: USER_EMAIL_ID)
        Constants().STOREVALUE(value: self.mobileNumber, keyname: USER_PHONE_NUMBER)
        Constants().STOREVALUE(value: self.countryCode, keyname: USER_COUNTRY_CODE)
        Constants().STOREVALUE(value: self.home, keyname: USER_HOME_LOCATION)
        Constants().STOREVALUE(value: self.work, keyname: USER_WORK_LOCATION)
        Constants().STOREVALUE(value: self.homeLatitude, keyname: USER_HOME_LATITUDE)
        Constants().STOREVALUE(value: self.homeLongitude, keyname: USER_HOME_LONGITUDE)
        Constants().STOREVALUE(value: self.workLatitude, keyname: USER_WORK_LATITUDE)
        Constants().STOREVALUE(value: self.workLongitude, keyname: USER_WORK_LONGITUDE)
       // Constants().STOREVALUE(value: self.gender, keyname: USER_GENDER)
    }
    
    func storeRiderImprotantData(){

        if !self.accessToken.isEmpty{
            Constants().STOREVALUE(value: self.accessToken, keyname: USER_ACCESS_TOKEN)
        }
        if !(self.userID == 0){
            Constants().STOREVALUE(value: self.userID.description, keyname: USER_ID)
        }
        Constants().STOREVALUE(value: self.paypalEmailID, keyname: USER_PAYPAL_EMAIL_ID)
        Constants().STOREVALUE(value: self.walletAmount, keyname: USER_WALLET_AMOUNT)
//        Constants().STOREVALUE(value: self.paypal_app_id, keyname: USER_PAYPAL_APP_ID)
//        Constants().STOREVALUE(value: self.paypal_mode, keyname: USER_PAYPAL_MODE)
    }
    
    func update(fromData data : UserProfileDataModel){
            for index in 0 ..< data.requestOptions.count{
                self.requestOptions[index].update(fromData: data.requestOptions[index])
            }
        }
}

// MARK: - PromoDetail
class PromoDetail: Codable {
    let id, businessID: Int
    let code, price, maxPrice, expireDate: String
    let type: Int
    let percentage: Int?
    let defaultPromo: Int
    let appName, promoDetailDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case code, price
        case maxPrice = "max_price"
        case expireDate = "expire_date"
        case type, percentage
        case defaultPromo = "default_promo"
        case appName = "app_name"
        case promoDetailDescription = "description"
    }
    
    required init(from decoder : Decoder) throws{
             let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.businessID = container.safeDecodeValue(forKey: .businessID)
        self.code = container.safeDecodeValue(forKey: .code)
        self.price = container.safeDecodeValue(forKey: .price)
        self.maxPrice = container.safeDecodeValue(forKey: .maxPrice)
        self.expireDate = container.safeDecodeValue(forKey: .expireDate)
        self.type = container.safeDecodeValue(forKey: .type)
        self.percentage = container.safeDecodeValue(forKey: .percentage)
        self.defaultPromo = container.safeDecodeValue(forKey: .defaultPromo)
        self.appName = container.safeDecodeValue(forKey: .appName)
        self.promoDetailDescription = container.safeDecodeValue(forKey: .promoDetailDescription)
    }
    
    init () {
        self.id = 0
        self.businessID = 0
        self.code = ""
        self.price = ""
        self.maxPrice = ""
        self.expireDate = ""
        self.type = 0
        self.percentage = 0
        self.defaultPromo = 0
        self.appName = ""
        self.promoDetailDescription = ""
    }

}

// MARK: - RequestOption
class RequestOption: Codable {
    let id: Int
    let name: String
    var isSelected: Bool

    init(id: Int, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    
    required init(from decoder : Decoder) throws{
             let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.isSelected = container.safeDecodeValue(forKey: .isSelected)
    }
    
    init () {
        self.id = 0
        self.name = ""
        self.isSelected = false
    }
    func update(fromData data: RequestOption){
        self.isSelected = data.isSelected
    }
    
}

