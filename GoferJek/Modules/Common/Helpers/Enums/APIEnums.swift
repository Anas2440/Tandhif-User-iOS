//
//  APIEnums.swift
//  Gofer
//
//  Created by trioangle on 08/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire

enum APIEnums : String{
    
    
    case force_update = "check_version"
    case language_content = "content"
    case login = "login"
    case guest_login = "guest_login"
    case logout = "logout"
    case validateNumber = "numbervalidation"
    case getNearByDrivers = "get_nearest_vehicles"
    case otpVerification = "otp_verification"
    case currencyConversion = "currency_conversion"
    case getEssetntials = "common_data"
    case getPaymentOptions = "get_payment_list"
    case riderProfile = "get_user_profile"
    case getCallerDetails = "get_caller_detail"
    
    case cancel_reasons = "cancel_reasons"
//    case inCompleteTrips = "incomplete_trip_details"
    case getInvoice = "get_invoice"
    case afterPayment = "after_payment"
    case addAmountToWallet = "add_wallet"
    case giveRating = "trip_rating"
    case getReferals = "get_referral_details"
    case getPastTrips = "get_past_trips1"
    case getUpcomingTrips = "get_upcoming_trips1"
    case requestCars = "request_cars"
    case scheduleRide = "save_schedule_ride"
    case getJobRequest = "get_job_request"
    case addStripeCard = "add_card_details"
    case getStripeCard = "get_card_details"
    
    case getTripDetail = "get_trip_details"
    case sendMessage = "send_message"
    
    case updateLanguage = "language"
    case getPromoDetails = "promo_details"
    case addPromoCode = "add_promo_code"
    case checkUserPromo = "check_user_promo"

    
    case signUp = "register"
    case socialSignup = "socialsignup"
    case updatePassword = "forgotpassword"
    case updateRiderProfile = "update_user_profile"
    case updateRiderLocation = "update_user_location"
    case updateCurrentLocation = "update_location"
    case saveUserLocation = "save_user_location"
    case cancelTrip = "cancel_trip"
    case updateDeviceToken = "update_device"
    case getDriverLocation = "track_provider"
    case getCurrencyList = "currency_list"
    case updateUserCurrency = "update_user_currency"
    case searchCars = "search_cars"
    case uploadProfileImage = "upload_profile_image"
    case cancelScheduleRide = "schedule_ride_cancel"
    case getEarningDetail = "earning_chart"
    //MARK:- Handy
    case getServices = "get_services"
    case getServiceCategory = "get_services_category"
    case details = "details"
    case getProvidersList = "get_providers_list"
    case getProviderDetail = "providers_detail"
    case bookJob = "book_job"
    case getJobDetail = "get_job_details"
    case cancelJob = "cancel_job"
    case cancelScheduleJob = "cancel_schedule_job"
    case getSelectedService = "get-selected-service"
    
    case getPastJobs = "get_past_jobs"
    case getUpCommingJobs = "get_upcoming_jobs"
    case updateNewPassword = "update_password"
    case providersAvailability = "get_provider_availability"
    case cancelJobRequest = "cancel_job_request"
    case jobRating = "job_rating"
    
    case getHomeScreenJob = "job_status_for_homeScreen"
    
    //MARK: DELIVERY
    case newDeliveryDetails = "delivery_details"
    case getDeliveryInvoice = "get_delivery_invoice"
    case requestProvider = "request_provider"
    case recipientDetails = "recipient_details"
    case userCancelRequest = "user_cancel_request"
    case scheduleDelivery = "update_schedule"

    case none
    case sos
    case webPayment = "web_payment"
    
    
    //deliveryall
    //MARK:- Delivery All
    case addUserReview = "add_user_review"
    case userReview = "user_review"
    case serviceType = "service_type"
    case getEighteenPlusDetails = "get_eighteen_plus_details"
    case addVerification = "add_verification"
    case home = "home"
    case categories = "categories"
    case addWishList = "add_wish_list"
    case wishlist = "wishlist"
    case getPaymentMethods = "get_payment_methods"
    case appleServiceId = "apple_service_id"
    case search = "search"
    case filter = "filter"
    case getMenuAddon = "get_menu_item_addon"
    case clearCart = "clear_cart"
    case clearAllCart = "clear_all_cart"
    case getLocation = "get_location"
    case removeLocation = "remove_location"
    case defaultLocation = "default_location"
    //case saveLocation = "save_location"
    case infoWindow = "info_window"
    case newStoreDetails = "new_store_details"
    case viewCart = "view_cart"
    case placeOrder = "place_order"
    case addToCart = "add_to_cart"
    //MARK: GOJEK
    case ourService = "our_service"
}

extension APIEnums{//Return method for API
    var method : HTTPMethod{
        switch self {
        case .getEssetntials,
             .currencyConversion,
             .addAmountToWallet,
             .getPaymentOptions,
             .afterPayment,
             .addToCart,
             .requestCars,
             .scheduleRide:
            return .post
        default:
            return .get
        }
    }
    var canHandleFailureCases : Bool {
        return [APIEnums.validateNumber]
            .contains(self)
    }
    var cacheAttribute: Bool{
        switch self {
        case .getPastJobs,
             .getServices,
             .riderProfile,
             .home,
             .categories,
             .newStoreDetails,
             .serviceType,
             .search,
             .infoWindow,
             .getPromoDetails,
             .wishlist,
             .getMenuAddon,
//             .getServiceCategory,
             .getProviderDetail,
             .sos,
             .getJobDetail:
            return true
        default:
            return false
        }
    }
}

enum ResponseEnum{
   // case RiderModel(_ rider :DriverDetailModel)
    case newUserNotAuthenticatedYet
    case onAuthenticate(_ loginData : UserProfileDataModel)
    case LoggedOut
    case RatingGiven
    case number(isValid : Bool,OTP : String,message : String)
    case forceUpdate(_ ForceUpdate : ForceUpdate)
    case cancelReason(_ reasons : [CancelReason])
    case amountAddedToWallet(_ response_message : String)
    case requires3DSecureValidation(forIntent : String)
    case success
    case failure(_ error : String)
    case onReferalSuccess(referal : String,
        totalEarning : String,
        maxReferal : String,
        incomplete : [ReferalModel],
        complete :[ReferalModel],
        appLink: String)
    case onReferalFailure
    
    case callerDetails(callerName : String,image : String)
    case essentialDataReceived
    
    case liveCars(_ cars : [LiveCar])
//    case pastTrip(data: [TripDataModel],
//        totalPages: Int,
//        currentPage: Int)
//    case upCommingTrip(data: [TripDataModel],
//        totalPages: Int,
//        currentPage: Int)
    case onCurrencyConvert(amount : Double,brainTreeClientID : String,currency : String?)
//    case tripDetailData(_ data : TripDetailDataModel)
}

