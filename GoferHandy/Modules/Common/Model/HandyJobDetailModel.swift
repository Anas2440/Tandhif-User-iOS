//
//  HandyJobDetailModel.swift
//  GoferHandy
//
//  Created by trioangle on 18/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - JobDetailModel
class HandyJobDetailModel: Codable , Equatable {
    
    // Adding This Model To Speed Up the reloading State
    static func == (lhs: HandyJobDetailModel, rhs: HandyJobDetailModel) -> Bool {
        lhs.statusCode == rhs.statusCode &&
        lhs.statusMessage == rhs.statusMessage &&
        lhs.users == rhs.users &&
        lhs.providerID == rhs.providerID &&
        lhs.providerName == rhs.providerName &&
        lhs.mobileNumber == rhs.mobileNumber &&
        lhs.providerImage == rhs.providerImage &&
        lhs.providerRating == rhs.providerRating &&
        lhs.providerAddress == rhs.providerAddress &&
        lhs.promoDetails == rhs.promoDetails
    }
    
    let statusCode, statusMessage: String
    let users: Users
    let providerID: Int
    let providerName, mobileNumber: String
    let providerImage: String
    let providerRating: Double
    let providerAddress: String
    let promoDetails: [PromoMode]
    let poolID : Int
    let isPool : Bool
    var providerLatitude : Double
    var providerLongitude : Double
    var providerLocation : CLLocation{
        return CLLocation(latitude: self.providerLatitude, longitude: self.providerLongitude)
    }
    //MARK- getters
    var isCompletedJob : Bool{
        return [HandyJobStatus.completed,.cancelled,.rating].contains(self.users.jobStatus)
    }
    var targetJobLocation : CLLocation{
        return .init(latitude: self.users.pickupLat,
                     longitude: self.users.pickupLng)
    }
    var currentReceipientPrefered: Int?{
        get{return self.users.delivery?.id}
        set{print("Ignored Id \(String(describing: newValue))")}
    }
    
    // Gofer Splitup Start
    
    
    // Handy Splitup End
    var targetJobLocationDelivery : CLLocation{
        switch self.users.jobStatus {
        case .beginJob:
            return .init(latitude: self.users.pickupLat,
                         longitude: self.users.pickupLng)
        case .endJob:
            return .init(latitude: self.users.pickupLat,
                         longitude: self.users.pickupLng)
        default:
            return .init(latitude: self.users.pickupLat,
                         longitude: self.users.pickupLng)
        }
       
    }
    
    // Gofer Splitup end
    
    var targetUserImage : String{
        if self.users.jobAtUser{
            return self.users.image
        }else{
            return self.providerImage
        }
    }
    
    var getPayableAmount : String {
        return self.users.totalFare
    }
    var amITheTravellerDelivery : Bool{
        if users.priceType == .distance && users.jobStatus.isTripStarted {
            return false
        }else{
            return !self.users.jobAtUser
        }
    }
    var canShowLiveTrackingMapDelivery : Bool{
        
        if users.priceType == .distance {
            
                if self.users.jobAtUser{
                    return true
                }else{
                    return self.users.jobStatus.isTripStarted//!(self.getCurrentRecipient()?.status ?? .pending < .endJob) //self.users.jobStatus.isTripStarted
                }
        }else if !self.users.jobAtUser{ //job is at providers location
            return false
        }else{
            return !self.users.jobStatus.isTripStarted//(self.getCurrentRecipient()?.status ?? .pending < .endJob)//self.users.jobStatus.isTripStarted
        }
    }
    var canShowPolylineDelivery : Bool{
        ////////////////////////////////////////////////////////
        guard canShowLiveTrackingMapDelivery else{ // first map should be showing
            return false
        }
        
        //////////////////////////////////////////////////////////
        if self.users.priceType == .distance{
            if self.users.jobStatus.isTripStarted{ //!(self.getCurrentRecipient()?.status ?? .pending < .endJob) {//
                return true
            }else{
                return true
            }
        }
        
        if self.users.jobStatus.isTripStarted{//!(self.getCurrentRecipient()?.status ?? .pending < .endJob) {//self.users.jobStatus.isTripStarted{
            return false
        }
        if !self.users.jobAtUser{ //job is at providers location
            return false
        }
       
        return true
    }

    var amITheTraveller : Bool{
        if users.priceType == .distance && users.jobStatus.isTripStarted{
            return false
        }else{
            return !self.users.jobAtUser
        }
    }
    var canShowLiveTrackingMap : Bool{
        
        if users.priceType == .distance {
            
                if self.users.jobAtUser{
                    return true
                }else{
                    return self.users.jobStatus.isTripStarted
                }
        }else if !self.users.jobAtUser{ //job is at providers location
            return false
        }else{
            return !self.users.jobStatus.isTripStarted
        }
    }
    var canShowPolyline : Bool{
        ////////////////////////////////////////////////////////
        guard canShowLiveTrackingMap else{ // first map should be showing
            return false
        }
        
        //////////////////////////////////////////////////////////
        if self.users.priceType == .distance{
            if self.users.jobStatus.isTripStarted{
                return false
            }else{
                return true
            }
        }
        
        if self.users.jobStatus.isTripStarted{
            return false
        }
        if !self.users.jobAtUser{ //job is at providers location
            return false
        }
       
        return true
    }
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case users
        case providerID = "provider_id"
        case providerName = "provider_name"
        case mobileNumber = "mobile_number"
        case providerImage = "provider_image"
        case providerRating = "provider_rating"
        case providerAddress = "provider_address"
        case promoDetails = "promo_details"
        case poolID = "pool_id"
        case isPool = "is_pool"
        case providerLatitude = "provider_latitude"
        case providerLongitude = "provider_longitude"
    }
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.users = try container.decodeIfPresent(Users.self, forKey: .users) ?? Users()
        self.providerID = container.safeDecodeValue(forKey: .providerID)
        self.providerName = container.safeDecodeValue(forKey: .providerName)
        self.mobileNumber = container.safeDecodeValue(forKey: .mobileNumber)
        self.providerImage = container.safeDecodeValue(forKey: .providerImage)
        self.providerRating = container.safeDecodeValue(forKey: .providerRating)
        self.providerAddress = container.safeDecodeValue(forKey: .providerAddress)
        
        self.promoDetails = try container.decodeIfPresent([PromoMode].self, forKey: .promoDetails) ?? [PromoMode]()
        self.poolID = container.safeDecodeValue(forKey: .poolID)
        self.isPool = container.safeDecodeValue(forKey: .isPool)
        self.providerLatitude = container.safeDecodeValue(forKey: .providerLatitude)
        self.providerLongitude = container.safeDecodeValue(forKey: .providerLongitude)
    }

    init(array_json : JSON) {
        self.statusCode = array_json.string("status_code")
        self.statusMessage = array_json.string("status_message")
        let users = array_json.array("users")
        self.users = Users.init(users.first ?? [:])
        self.providerID = array_json.int("provider_id")
        self.providerName = array_json.string("provider_name")
        self.mobileNumber = array_json.string("mobile_number")
        self.providerImage = array_json.string("provider_image")
        self.providerRating = array_json.double("provider_rating")
        self.providerAddress = array_json.string("provider_address")
        let promoArr = array_json.array("promo_details")
        self.promoDetails = promoArr.compactMap({PromoMode.init($0)})
        self.poolID = array_json.int("pool_id")
        self.isPool = array_json.bool("is_pool")
        self.providerLongitude = Double(array_json.string("provider_longitude")) ?? 0.00
        self.providerLatitude = Double(array_json.string("provider_latitude")) ?? 0.00

    }

    init(json : JSON) {
        self.statusCode = json.string("status_code")
        self.statusMessage = json.string("status_message")
        let users = json.json("users")
        self.users = Users.init(users)
        self.providerID = json.int("provider_id")
        self.providerName = json.string("provider_name")
        self.mobileNumber = json.string("mobile_number")
        self.providerImage = json.string("provider_image")
        self.providerRating = json.double("provider_rating")
        self.providerAddress = json.string("provider_address")
        let promoArr = json.array("promo_details")
        self.promoDetails = promoArr.compactMap({PromoMode.init($0)})
        self.poolID = json.int("pool_id")
        self.isPool = json.bool("is_pool")
        self.providerLongitude = Double(json.string("provider_longitude")) ?? 0.00
        self.providerLatitude = Double(json.string("provider_latitude")) ?? 0.00
    }
    
}


enum PriceType: String, Codable {
    case fixed = "Fixed"
    case hourly = "Hourly"
    case distance = "Distance"
    case squareMeter = "Square Meter"
    case linearMeter = "Linear Meter"
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        self = PriceType(rawValue: rawString) ?? .none
    }
}

class JobRating:Codable , Equatable {
    static func == (lhs: JobRating, rhs: JobRating) -> Bool {
        lhs.userRating == rhs.userRating &&
        lhs.userComments == rhs.userComments &&
        lhs.providerRating == rhs.providerRating &&
        lhs.providerComments == rhs.providerComments
    }
    
    
    let userRating:Int
    let userComments: String
    let providerRating: Int
    let providerComments:String
    
    enum CodingKeys: String, CodingKey {
        case userRating = "user_rating"
        case userComments = "user_comments"
        case providerRating = "provider_rating"
        case providerComments = "provider_comments"
    }
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userRating = container.safeDecodeValue(forKey: .userRating)
        self.userComments = container.safeDecodeValue(forKey: .userComments)
        self.providerRating = container.safeDecodeValue(forKey: .providerRating)
        self.providerComments = container.safeDecodeValue(forKey: .providerComments)
    }
    init(_ json : JSON) {
        self.userRating = json.int("user_rating")
        self.userComments = json.string("user_comments")
        self.providerRating = json.int("provider_rating")
        self.providerComments = json.string("provider_comments")
    }
}

// MARK: - Users
class Users: Codable ,Equatable{
    static func == (lhs: Users, rhs: Users) -> Bool {
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.image == rhs.image &&
            lhs.mobileNumber == rhs.mobileNumber &&
            lhs.isRequiredOtp == rhs.isRequiredOtp &&
            lhs.jobAtUser == rhs.jobAtUser &&
            lhs.jobID == rhs.jobID &&
            lhs.pickup == rhs.pickup &&
            lhs.drop == rhs.drop &&
            lhs.pickupLat == rhs.pickupLat &&
            lhs.pickupLng == rhs.pickupLng &&
            lhs.dropLat == rhs.dropLat &&
            lhs.dropLng == rhs.dropLng &&
            lhs.requestID == rhs.requestID &&
            lhs.currencyCode == rhs.currencyCode &&
            lhs.currencySymbol == rhs.currencySymbol &&
            lhs.totalTime == rhs.totalTime &&
            lhs.totalkm == rhs.totalkm &&
            lhs.providerPaypalID == rhs.providerPaypalID &&
            lhs.paypalAppID == rhs.paypalAppID &&
            lhs.paypalMode == rhs.paypalMode &&
            lhs.bookingType == rhs.bookingType &&
            lhs.rating == rhs.rating &&
            lhs.paymentMode == rhs.paymentMode &&
            lhs.paymentStatus == rhs.paymentStatus &&
            lhs.totalFare == rhs.totalFare &&
            lhs.scheduleDisplayDate == rhs.scheduleDisplayDate &&
            lhs.requestedServices == rhs.requestedServices &&
            lhs.priceType == rhs.priceType &&
            lhs.jobProgress == rhs.jobProgress &&
            lhs.invoice == rhs.invoice &&
            lhs.jobStatus == rhs.jobStatus &&
            lhs.jobImage == rhs.jobImage &&
            lhs.jobRating == rhs.jobRating
    }
    
    let id: Int
    let name: String
    let image: String
    let mobileNumber, otp: String
    let isRequiredOtp : Bool
    let jobAtUser : Bool
    let jobID: Int
    let pickup, drop : String
    let pickupLat, pickupLng: Double
    let dropLat, dropLng: Double
    let requestID: Int
    let currencyCode, currencySymbol, totalTime, totalkm: String
    let providerPaypalID, paypalAppID, paypalMode: String?
    let bookingType: BookingEnum
    let rating: Int
    let paymentMode, paymentStatus, totalFare,providerEarnings: String
    let promoAdded : Bool
    let walletSelected : Bool
    let scheduleDisplayDate: String
    let requestedServices: [RequestedService]
    let priceType: PriceType
    let jobProgress: [JobProgress]
    var invoice: [Invoice]
    var jobStatus : HandyJobStatus
    var jobImage : JobImage?
    let jobRating: JobRating?
    let providerID : Int
    
    var delivery : DeliveryModel?
    let businessID : BusinessType
    var showInvoice : Bool = false
    var mapImage : String
    var vehicleName: String
    var seats: String
    var eta : String
    var vehicleNumber : String
    var waitingCharge : Double
    var waitingTime : Int
    var isPool : Bool
    let promoId : Int
    var paymentResult : String {
        get {
            var str = paymentMode
            if walletSelected { str += (promoAdded ? " , " : " & ") + LangCommon.wallet }
            if promoAdded { str +=  " & " + (LangCommon.promo.isEmpty ? "Promo" : LangCommon.promo ) }
            return str
        }
    }
    var modifiedInvoice : [Invoice] {
        if showInvoice {
            var invoice = self.invoice
            invoice.insert(Invoice.init(customWithName: LangCommon.fareDetails,
                                        value: "",
                                        bar: 0,
                                        colour: "",
                                        comment: ""),
                           at: 0)
            return invoice
        } else {
            return [Invoice.init(customWithName: LangCommon.fareDetails,
                                 value: "",
                                 bar: 0,
                                 colour: "",
                                 comment: "")]
        }
    }
    var appliedWaitingChargeDescription : String?{
        
        guard !waitingCharge.isZero && waitingTime != 0 else{return nil}
        let currency  = Constants().GETVALUE(keyname: "user_currency_symbol_org")
        let fee = ""
        let time = ""
        return "\(currency)\(self.waitingCharge)\(fee) \(self.waitingTime) \(time)"
    }
    var arrivalFromGoogle : String?

    
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case mobileNumber = "mobile_number"
        case isRequiredOtp = "is_required_otp"
        case otp
        case providerID = "provider_id"
        case jobAtUser = "job_at_user"
        case jobID = "job_id"
        case pickup, drop
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case dropLat = "drop_lat"
        case dropLng = "drop_lng"
        case requestID = "request_id"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case totalTime = "total_time"
        case totalkm = "total_km"
        case providerPaypalID = "provider_paypal_id"
        case paypalAppID = "paypal_app_id"
        case paypalMode = "paypal_mode"
        case bookingType = "booking_type"
        case rating
        case jobStatus = "job_status"
        case paymentMode = "payment_mode"
        case paymentStatus = "payment_status"
        case totalFare = "total_fare"
        case scheduleDisplayDate = "schedule_display_date"
        case requestedServices = "requested_services"
        case priceType = "price_type"
        case jobProgress = "job_progress"
        case invoice
        case jobImage = "job_image"
        case jobRating = "job_rating"
        case delivery
        case providerEarnings = "provider_earnings"
        case businessID = "business_id"
        case mapImage = "map_image"
        case vehicleName = "vehicle_name"
        case seats = "seats"
        case eta = "eta"
        case vehicleNumber = "vehicle_number"
        case waitingTime = "waiting_time"
        case waitingCharge = "waiting_charge"
        case isPool = "is_pool"
        case promoId = "promo_id"
        case promoAdded = "promo_added"
        case walletSelected = "wallet_selected"
    }
    init(_ json: JSON) {
        
        self.id = json.int("id")
        self.name = json.string("name")
        self.image = json.string("image")
        self.mobileNumber = json.string("mobile_number")
        self.isRequiredOtp = json.bool("is_required_otp")
        self.otp = json.string("otp")
        self.jobID = json.int("job_id")
        self.pickup = json.string("pickup")
        self.drop = json.string("drop")
        self.pickupLat = json.double("pickup_lat")
        self.pickupLng = json.double("pickup_lng")
        self.dropLat = json.double("drop_lat")
        self.dropLng = json.double("drop_lng")
        self.requestID = json.int("request_id")
        self.currencyCode = json.string("currency_code")
        self.currencySymbol = json.string("currency_symbol")
        self.totalTime = json.string("total_time")
        self.totalkm = json.string("total_km")
        self.providerPaypalID = json.string("provider_paypal_id")
        self.paypalAppID = json.string("paypal_app_id")
        self.paypalMode = json.string("paypal_mode")
        self.rating = json.int("rating")
        self.paymentMode = json.string("payment_mode")
        self.paymentStatus = json.string("payment_status")
        self.totalFare = json.string("total_fare")
        self.scheduleDisplayDate = json.string("schedule_display_date")
        self.requestedServices = [RequestedService]()
        self.priceType = .distance
        self.bookingType = BookingEnum(rawValue: json.string("booking_type")) ?? .auto
        self.jobStatus = HandyJobStatus(rawValue: json.string("job_status")) ?? .request

        let jobProgress = json.array("job_progress")
        self.jobProgress = jobProgress.compactMap({JobProgress.init($0)})

        let invoiceArr = json.array("invoice")
        self.invoice = invoiceArr.compactMap({Invoice.init($0)})

        let jobImage = json.json("job_image")
        self.jobImage = JobImage.init(jobImage)

        let jobRating = json.json("job_rating")
        self.jobRating = JobRating.init(jobRating)

        self.providerID = json.int("provider_id")
        
        self.businessID = BusinessType(rawValue: json.int("business_id")) ?? .Services
        self.jobAtUser = self.businessID == .Delivery ? true : json.bool("job_at_user")
        // Handy Splitup End
        let delivery = json.json("delivery")
        self.delivery = DeliveryModel.init(delivery)

        self.providerEarnings = json.string("provider_earnings")
        self.vehicleName = json.string("vehicle_name")
        self.mapImage = json.string("map_image")
        self.seats = json.string("seats")
        self.eta = json.string("eta")
        self.vehicleNumber = json.string("vehicle_number")
        self.waitingTime = json.int("waiting_time")
        self.waitingCharge = json.double("waiting_charge")
        self.isPool = json.bool("is_pool")
        self.promoId = json.int("promo_id")
        self.walletSelected = json.bool("wallet_selected")
        self.promoAdded = json.bool("promo_added")
    }
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.image = container.safeDecodeValue(forKey: .image)
        self.mobileNumber = container.safeDecodeValue(forKey: .mobileNumber)
        self.isRequiredOtp = container.safeDecodeValue(forKey: .isRequiredOtp)
        self.otp = container.safeDecodeValue(forKey: .otp)
        self.providerID = container.safeDecodeValue(forKey: .providerID)
        //self.status = container.safeDecodeValue(forKey: .status)
        self.jobID = container.safeDecodeValue(forKey: .jobID)
        self.pickup = container.safeDecodeValue(forKey: .pickup)
        self.drop = container.safeDecodeValue(forKey: .drop)
        self.pickupLat = container.safeDecodeValue(forKey: .pickupLat)
        self.pickupLng = container.safeDecodeValue(forKey: .pickupLng)
        self.dropLat = container.safeDecodeValue(forKey: .dropLat)
        self.dropLng = container.safeDecodeValue(forKey: .dropLng)
        self.requestID = container.safeDecodeValue(forKey: .requestID)
        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
        self.currencySymbol = container.safeDecodeValue(forKey: .currencySymbol)
        self.totalTime = container.safeDecodeValue(forKey: .totalTime)
        self.totalkm = container.safeDecodeValue(forKey: .totalkm)
        self.providerPaypalID = container.safeDecodeValue(forKey: .providerPaypalID)
        self.paypalAppID = container.safeDecodeValue(forKey: .paypalAppID)
        self.paypalMode = container.safeDecodeValue(forKey: .paypalMode)
        if let type = try? container.decodeIfPresent(BookingEnum.self,
                                                     forKey: .bookingType) {
            self.bookingType = type
        }else{
            self.bookingType = BookingEnum.auto
        }
        self.rating = container.safeDecodeValue(forKey: .rating)
        if let status = try? container.decodeIfPresent(HandyJobStatus.self, forKey: .jobStatus) ?? .scheduled{
            self.jobStatus = status
        }else{
            self.jobStatus = .scheduled
        }
        self.paymentMode = container.safeDecodeValue(forKey: .paymentMode)
        self.paymentStatus = container.safeDecodeValue(forKey: .paymentStatus)
        self.totalFare = container.safeDecodeValue(forKey: .totalFare)
        self.scheduleDisplayDate = container.safeDecodeValue(forKey: .scheduleDisplayDate)
        self.requestedServices = try container.decodeIfPresent([RequestedService].self, forKey: .requestedServices) ?? [RequestedService]()
        if let _priceType = try? container.decodeIfPresent(PriceType.self,
                                                           forKey: .priceType){
            self.priceType = _priceType
        }else{
            self.priceType = .distance
        }
        self.jobProgress = try container.decodeIfPresent([JobProgress].self, forKey: .jobProgress) ?? [JobProgress]()
        self.invoice = try container.decodeIfPresent([Invoice].self, forKey: .invoice) ?? [Invoice]()
        self.jobImage = try? container.decodeIfPresent(JobImage.self, forKey: .jobImage)
        self.jobRating = try container.decodeIfPresent(JobRating.self, forKey: .jobRating)
        self.providerEarnings = container.safeDecodeValue(forKey: .providerEarnings)
        self.businessID = try container.decodeIfPresent(BusinessType.self, forKey: .businessID) ?? .Services
        // Handy Splitup End
        self.delivery = try container.decodeIfPresent(DeliveryModel.self, forKey: .delivery)
        
        //self.businessID = businessType ?? .Services
        self.jobAtUser = self.businessID == .Delivery ? true : container.safeDecodeValue(forKey: .jobAtUser)
        self.vehicleName = container.safeDecodeValue(forKey: .vehicleName)
        self.mapImage = container.safeDecodeValue(forKey: .mapImage)
        self.seats = container.safeDecodeValue(forKey: .seats)
        self.eta = container.safeDecodeValue(forKey: .eta)
        self.vehicleNumber = container.safeDecodeValue(forKey: .vehicleNumber)
        self.waitingTime = container.safeDecodeValue(forKey: .waitingTime)
        self.waitingCharge = container.safeDecodeValue(forKey: .waitingCharge)
        self.isPool = container.safeDecodeValue(forKey: .isPool)
        self.promoId = container.safeDecodeValue(forKey: .promoId)
        self.walletSelected = container.safeDecodeValue(forKey: .walletSelected)
        self.promoAdded = container.safeDecodeValue(forKey: .promoAdded)
    }
    
    init() {
        
        self.jobAtUser = false
        self.id = 0
        self.name = ""
        self.image = ""
        self.mobileNumber = ""
        self.isRequiredOtp = false
        self.otp = ""
         
        //self.status = container.safeDecodeValue(forKey: .status)
        self.jobID = 0
        self.pickup = ""
        self.drop = ""
        self.pickupLat = 0
        self.pickupLng = 0
        self.dropLat = 0
        self.dropLng = 0
        self.requestID = 0
        self.currencyCode = ""
        self.currencySymbol = ""
        self.totalTime = ""
        self.totalkm = ""
        self.providerPaypalID = ""
        self.paypalAppID = ""
        self.paypalMode = ""
        self.bookingType = .auto
        self.rating = 0
        self.jobStatus = .scheduled
        self.paymentMode = ""
        self.paymentStatus = ""
        self.totalFare = ""
        self.scheduleDisplayDate = ""
        self.requestedServices = [RequestedService]()
        self.priceType = .distance
        
        self.jobProgress = [JobProgress]()
        self.invoice = [Invoice]()
        self.jobImage = nil
        self.jobRating = nil
        self.providerID = 0
        self.delivery = DeliveryModel(id: 0, otp: 0, recipientName: "", latitude: "", longitude: "", address: "", deliverySubStatus: "")
        self.providerEarnings = ""
        self.businessID = .Services
        self.mapImage = ""
        self.vehicleName = ""
        self.seats = ""
        self.eta = ""
        self.vehicleNumber = ""
        self.waitingTime = 0
        self.waitingCharge = 0.00
        self.isPool = false
        self.promoId = 0
        self.walletSelected = false
        self.promoAdded = false
    }

}

// MARK: - Invoice
class Invoice: Codable , Equatable {
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        lhs.key == rhs.key &&
        lhs.value == rhs.value &&
        lhs.bar == rhs.bar &&
        lhs.colour == rhs.colour &&
        lhs.comment == rhs.comment
    }
    
    
    let key, value: String
    let bar: Int
    let colour, comment: String
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = container.safeDecodeValue(forKey: .key)
        self.value = container.safeDecodeValue(forKey: .value)
        self.bar = container.safeDecodeValue(forKey: .bar)
        self.colour = container.safeDecodeValue(forKey: .colour)
        self.comment = container.safeDecodeValue(forKey: .comment)
    }
    init(_ json : JSON) {
        self.key = json.string("key")
        self.value = json.string("value")
        self.bar = json.int("bar")
        self.colour = json.string("colour")
        self.comment = json.string("comment")
    }
    
    init(customWithName key : String,value : String, bar : Int, colour : String, comment : String){
        self.key = key
        self.value = value
        self.bar = bar
        self.colour = colour
        self.comment = comment
    }
}

// MARK: - JobProgress
class JobProgress: Codable ,Equatable{
    static func == (lhs: JobProgress, rhs: JobProgress) -> Bool {
        lhs.jobStatusMsg == rhs.jobStatusMsg &&
        lhs.time == rhs.time &&
        lhs.status == rhs.status
    }
    
    
    let jobStatusMsg, time: String
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case jobStatusMsg = "job_status_msg"
        case time
        case status
    }

    init(jobStatusMsg: String, time: String ,status:Bool) {
        self.jobStatusMsg = jobStatusMsg
        self.time = time
        self.status = status
    }
    init(_ json : JSON) {
        self.jobStatusMsg = json.string("job_status_msg")
        self.time = json.string("time")
        self.status = json.bool("status")

    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.jobStatusMsg = container.safeDecodeValue(forKey: .jobStatusMsg)
        self.time = container.safeDecodeValue(forKey: .time)
        self.status = container.safeDecodeValue(forKey: .status)
    }
}

class JobRequestModel: Codable {
    let statusCode, statusMessage, userName, address, rating: String
    let priceType : PriceType
    let service: [RequestedService]
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case userName = "user_name"
        case address, service, rating
        case priceType = "price_type"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let service = try? container.decodeIfPresent([RequestedService].self, forKey: .service)
        self.service = service ?? [RequestedService]()
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.userName = container.safeDecodeValue(forKey: .userName)
        self.address = container.safeDecodeValue(forKey: .address)
        self.rating = container.safeDecodeValue(forKey: .rating)
        let priceTypee = try? container.decodeIfPresent(PriceType.self, forKey: .priceType)
        self.priceType = priceTypee ?? PriceType.hourly
    }
    init(_ json : JSON) {
        self.statusCode = json.string("status_code")
        self.statusMessage = json.string("status_message")
        self.userName = json.string("user_name")
        self.address = json.string("address")
        
        let sericeArr = json.array("service")
        self.service = sericeArr.compactMap({RequestedService.init($0)})

        self.rating = json.string("rating")
        self.priceType = PriceType(rawValue: json.string("price_type")) ?? .distance

    }
}

// MARK: - RequestedService
class RequestedService: Codable, Equatable {
    static func == (lhs: RequestedService, rhs: RequestedService) -> Bool {
        lhs.id == rhs.id &&
        lhs.quantity == rhs.quantity &&
        lhs.instruction == rhs.instruction &&
        lhs.service_name == rhs.service_name &&
        lhs.category_name == rhs.category_name
    }
    
    var param : String{
        let description = self.instruction
        let quantity = self.quantity
        let id = self.id
        return "{\"instruction\":\"\(description)\",\"quantity\":\"\(quantity)\",\"service_type_id\":\"\(id)\"}"
        
    }
    
    let name: String
    let id, quantity: Int
    let instruction,service_name,category_name: String

   
      required init(from decoder : Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.name = container.safeDecodeValue(forKey: .name)
          self.id = container.safeDecodeValue(forKey: .id)
          self.quantity = container.safeDecodeValue(forKey: .quantity)
          self.instruction = container.safeDecodeValue(forKey: .instruction)
            self.service_name = container.safeDecodeValue(forKey: .service_name)
            self.category_name = container.safeDecodeValue(forKey: .category_name)
      }
    init(_ json : JSON) {
        self.name = json.string("name")
        self.id = json.int("id")
        self.quantity = json.int("quantity")
        self.instruction = json.string("instruction")
          self.service_name = json.string("service_name")
          self.category_name = json.string("category_name")

    }
}

// MARK: - JobImage
class JobImage: Codable , Equatable {
        static func == (lhs: JobImage, rhs: JobImage) -> Bool {
            lhs.afterImages == rhs.afterImages &&
            lhs.beforeImages == rhs.beforeImages
        }
    
    
    let beforeImages, afterImages: [JobSnapImage]

    enum CodingKeys: String, CodingKey {
        case beforeImages = "before_images"
        case afterImages = "after_images"
    }

    init(beforeImages: [JobSnapImage], afterImages: [JobSnapImage]) {
        self.beforeImages = beforeImages
        self.afterImages = afterImages
    }
    init(_ json : JSON) {
        
        let before = json.array("before_images")
        self.beforeImages = before.compactMap({JobSnapImage.init($0)})
        let after = json.array("after_images")
        self.afterImages = after.compactMap({JobSnapImage.init($0)})

    }
}

// MARK: - JobSnapImage
class JobSnapImage: Codable, Equatable {
    static func == (lhs: JobSnapImage, rhs: JobSnapImage) -> Bool {
        lhs.image == rhs.image
    }
    
    let image: String

    init(image: String) {
        self.image = image
    }
    init(_ json : JSON) {
        self.image = json.string("image")
    }
}
class Support: NSObject {
    let id : Int
    let name : String
    var link : String
    var image : String
    override init(){
        id = 0
        name = ""
        link = ""
        image = ""
    }
    init(_ json : JSON){
        self.id = json.int("id")
        self.name = json.string("name")
        self.link = json.string("link")
        self.image = json.string("image")
    }
}
// MARK: - Delivery
class DeliveryModel: Codable {
    let id, otp: Int
    let recipientName, latitude, longitude, address: String
    let deliverySubStatus: String

    enum CodingKeys: String, CodingKey {
        case id, otp
        case recipientName = "recipient_name"
        case latitude, longitude, address
        case deliverySubStatus = "delivery_sub_status"
    }

    init(id: Int, otp: Int, recipientName: String, latitude: String, longitude: String, address: String, deliverySubStatus: String) {
        self.id = id
        self.otp = otp
        self.recipientName = recipientName
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.deliverySubStatus = deliverySubStatus
    }
    required init(from decoder : Decoder) throws{
       let container = try decoder.container(keyedBy: CodingKeys.self)
          
        self.id = container.safeDecodeValue(forKey: .id)
        self.otp = container.safeDecodeValue(forKey: .otp)
        self.recipientName = container.safeDecodeValue(forKey: .recipientName)
        self.latitude = container.safeDecodeValue(forKey: .latitude)
        self.longitude = container.safeDecodeValue(forKey: .longitude)
        self.address = container.safeDecodeValue(forKey: .address)
        self.deliverySubStatus = container.safeDecodeValue(forKey: .deliverySubStatus)

   }
   init(_ json : JSON) {
        self.id = json.int("id")
        self.otp = json.int("otp")
        self.recipientName = json.string("recipient_name")
        self.latitude = json.string("latitude")
        self.longitude = json.string("longitude")
        self.address = json.string("address")
        self.deliverySubStatus = json.string("delivery_sub_status")

   }
}
