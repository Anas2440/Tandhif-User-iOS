//
//  Language.swift
//  GoferHandy
//
//  Created by trioangle on 29/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LanguageContentModel
class LanguageContentModel: Codable {
    let statusCode,statusMessage,defaultLanguage,currentLanguage : String
    let language: [Language]
    let common: Common
    let handy: Handy
    
    enum CodingKeys : String,CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case defaultLanguage = "default_language_code"
        case  currentLanguage = "current_language"
        case language
        case common
        case handy = "Handy"
    }
    
    init() {
        self.statusCode = ""
        self.statusMessage = ""
        self.defaultLanguage = ""
        self.currentLanguage = ""
        self.common = Common()
        self.handy = Handy()
        self.language = [Language()]
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.defaultLanguage = container.safeDecodeValue(forKey: .defaultLanguage)
        self.currentLanguage = container.safeDecodeValue(forKey: .currentLanguage)
        
        
        let langs = try container.decodeIfPresent([Language].self, forKey: .language)
        self.language = langs ?? []
        
        let _common = try container.decode(Common.self, forKey: .common)
        self.common = _common
        let _handy = try container.decode(Handy.self, forKey: .handy)
        self.handy = _handy
        
        //some core logics
        
        ///set default language to session if none is available
        if UserDefaults.isNull(for: .default_language_option) {
            UserDefaults.set(self.defaultLanguage, for: .default_language_option)
        }
        
        
    }
    
    //MARK:- UDF
    
    
    func currentLangage() -> Language?{
        self.language
            .filter({$0.key == self.currentLanguage})
            .first
    }
    func isRTLLanguage() -> Bool{
        if let currentLanguage = self.currentLangage(){
            return currentLanguage.isRTL
        }
        return false
    }
    func getBackBtnText() -> String{
        return self.isRTLLanguage() ? "I" : "e"
    }
    func semantic() -> UISemanticContentAttribute{
        return self.isRTLLanguage() ? .forceRightToLeft : .forceLeftToRight
    }
    //MARK:- for Text Alignment
    func getTextAlignment(align : NSTextAlignment) -> NSTextAlignment{
        guard self.semantic() == .forceRightToLeft else {
            return align
        }
        switch align {
        case .left:
            return .right
        case .right:
            return .left
        case .natural:
            return .natural
        default:
            return align
        }
    }
}

// MARK: - Common
class Common: Codable {
    let promoCodes : String
    let requestedService : String
    let appName : String
    let requesting , searchLocation , selectPaymentMode , fareEstimation : String
    let of , areYouSure , pending , completed : String
    let or , getMovingWith , tryAgain , getMove : String
    let signIn , register , connectSocialAcc , password : String
    let forgotPassword , enterPassword , credentialdonTRight , login : String
    let mobileVerify , enterMobileno , enterOtp , sentCodeMob : String
    let didntRecOtp , resendOtp , otpSendAgain , termsCondition : String
    let addHome , addWork , favorites , currency : String
    let home , work , message , ok : String
    let signOut , settings , regInformation , agreeTcPolicy : String
    let privacyPolicy , confirmInfo , firstName , lastName : String
    let mobileNo , refCode , cancelAccCreation , infoNotSaved : String
    let confirm , cancel , enPushNotifyLogin , chooseAcc : String
    let faceBook , google , resetPassword , close : String
    let confirmPassword , continueSendAlert , common1Continue , sendingAlert : String
    let alertSent , useEmergency , alertEmergencyContact , locationCollectData : String
    let locationEnsure , likeToResetPass , email , mobile : String
    let contacting , nearYou , promoApplied , cash, apple_pay : String
    let paypal , card , onlinePay , request, onlinePayment : String
    let change , setUrPickUp : String
    let setPicktUpTime , normalFare , minFare , minLeft : String
    let minKM , acceptHigherFare , tryLater , fare : String
    let capacity , done , fareBreakDown , baseFare : String
    let perMin , perKM , currentLocation , noLocationFound : String
    let whereTo , setPin , enterUrLocation , enterHome : String
    let enterWork , travelSafer , alertUrDears , youCanAddC : String
    let removeContact , addContacts , emergencyContacts , delete : String
    let contactAlreadyAdded : String
    let makeTravelSafe , alertYourDear , add5_Contacts , removeContactAddone : String
    let off , from , promotions , paymentMethod : String
    let useWallet , wallet , addPromoGiftCode , enterPromoCode : String
    let addCreditDebit , changeCreditDebit , rUSureToLogOut , payment : String
    let pay , waitDriverConfirm , quantity , proceed : String
    let continueRequest , success , paymentPaidSuccess , cancelled : String
    let failed , paymentDetails , totalFare , addPayment : String
    let addMoneytoWallet , addAmount , enterAmount , walletAmountIs : String
    let walletMoneyApplied : String
    let amountFldReq , driver , typeMessage , noMsgYet : String
    let getUpto , everyFriendRides , signUpandGetPaid , referral : String
    let yourReferralCode , shareMyCode , refCopytoClip , referralCodeCopied : String
    let useMyReferral , startJourneyonGofer , noRefYet , friendsInComplete : String
    let friendsCompleted , earned , refExpired , rateYourRide : String
    let writeYourComment , schedule , tip , submit : String
    let common4Set , add , enterTipAmount , past : String
    let upComming , pullToRefresh , id , cancelReason : String
    let contacts , call , contact , enRoute : String
    let mins , restaurantDelights , toWangs , addHomeLOC : String
    let addWorkLOC , uploadFailed , enterValidEmailID , enterFirstName : String
    let enterlastName , enterEmailID , passwordMismatch , newVersAvail : String
    let updateOurApp , visitAppStore , totryAgain , sorryNoRides : String
    let contactAdmin , save , selectPhoto , takePhoto : String
    let chooseLIB , help , selectCntry , minutesToArrive : String
    let noContactFound , dial , no , yes : String
    let addTip , setTip , toDriver , pleaseEnterValidAmount : String
    let pleaseGiveRating , manualBooking , dayLeft , skip : String
    let answer , incomingCall , completedStatus , cancelledStatus : String
    let reqStatus , pendingStatus , sheduledStatus , paymentStatus : String
    let editTime , cancelRide , selectCountry , search : String
    let clientNotInitialized , jsonSerialaizationFailed , noInternetConnection , toReach : String
    let toArrive , signInWith , userCancelledAuthentication , authenticationCancelled : String
    let connecting , ringing , callEnded , placehodlerMail : String
    let enterValidOtp , locationService , tracking , camera : String
    let photoLibrary , service , services : String
    let app , pleaseEnable , requires , common6For : String
    let functionality , requestStatus , ratingStatus , scheduledStatus : String
    let microphoneSerivce , inAppCall , choose , choosePaymentMethod : String
    let min , hr , hrs , language : String
    let selectLanguage , editAccount , enterValidData , confirmContact : String
    let rejected , busyTryAgain , pleaseEnablePushNotification , address : String
    let error , deviceHasNoCamera , warning , phoneNumber : String
    let addressLineFirst , addressLineSecond , city , postalCode : String
    let state , manageServices , manageHome , loginText : String
    let addItem , welcomeLoginText , yourJob : String
    let tapToChange , dontHaveAcc , alreadyHaveAcc , tocText : String
    let logout , pleaseGivePermission , termsConditions , smsMobileVerify : String
    let didntReceiveOtp , otpAgain , credentialsDontLook , enterYourFirstName : String
    let enterYourLastName , enterYourPhoneNumber , enterYourEmail , enterYourPassword : String
    let country , myProfile , editProfile , updateInfo : String
    let changePassword , added , next , enterLocation : String
    let youAreIn , serviceAtMe , setOnMap , pleaseSetLocation : String
    let yourBooking , onGoingJobs : String
    let successFullyUpdated , enterYourOldPassword , enterYourNewPassword , enterYourConformPassword : String
    let pleaseAddThemToYourEmergencyContact , sorting , lessThanAkm , estimatedCharge : String
    let minimumHour , paymentOption , selectBookingLocation , providerArrived : String
    let calendar , bookingDetails , checkOut , remove : String
    let estimatedFee , cart , paymentSummary , jobRequestDate : String
    let discountApplied , providerFeedback , howWasTheJobDone , moreInfo : String
    let setLocationOnMap , noServiceFound , review , gallery : String
    let viewMore , viewLess , hereYouCanChangeYourMap , byClicking : String
    let googleMap , wazeMap , doYouWant , pleaseInstallGoogleMapsApp : String
    let doYouWantToAccessdirection , pleaseInstallWazeMapsApp , jobLocation , destinationLocation : String
    
    let thanksForProvidingThisService , beforeService , afterService , fareDetails : String
    let paymentCompletedFor , number : String
    let agreeTermsAndPrivacyPolicyContent , maxChar , manuallyBookedAlert , manuallyBookedReminderAlert : String
    let manualBookiingCancelledAlert , manualBookingInfoAlert , scheduledAlert , requestAlert : String
    let beginJobAlert , endJobAlert , pendingAlert , cancelledAlert : String
    let completedAlert , ratingAlert , paymentAlert , editItem : String
    let noDataFound , passwordValidationMsg , specialInstruction , provideFeedback : String
    let sendAlert , addThem , sec , paymentType : String
    let yourInviteCode , forEveryFriendJobs , internalServerError ,areYouSureYouWantToExit ,provideYourFeedback ,balance : String
    let status : String
    let areYouSureYouWantToCancel,note,aToZ,km : String
    let enterValidCardDetails : String
  
    let arriveNow:String
    let paymentCompletedSuccess: String
    let category,subCategory,fareType : String
    let welcomeToThe : String
    let goferHandyUserApp : String
    let support : String
    let notAValidData : String
    let beginJob,endJob : String
    let fromHere : String
    let locationPermissionDescription : String
    let toAccessLocation : String
    let gettingLocation : String
    let iAgreeToThe : String
    let and : String
    let daysLeft : String
    let jobs : String
    let selectCurrency : String
    let allowCamera : String
    let toAccessCamera : String
    let forceUpdate : String
    let update : String
    let covidTitle : String
    let covidSubtitle : String
    let covidPointOne : String
    let covidPointTwo : String
    let covidPointThree : String
    let covidFooter : String
    let covidRating : String
    let appleLogin : String
    let loginToContinue : String
    let welcomeBack : String
    let haveAnAccount : String
    let continueWithPhone : String
    let scheduleDisplayDate : String
    let name : String
    let ourService : String
    let addPromoCode : String
    let removePromoCode : String
    let changePromoCode : String
    let amount : String
    let font : String
    let theme : String
    let history : String
    let changeTheme : String
    let changeFont : String
    let pleaseEnterYourOldPassword : String
    let pleaseEnterYourNewPassword : String
    let pleaseEnterYourConfirmPassword : String
    let setLocation : String
    let backToHome : String
    let edit : String
    let view : String
    let favourites:String
    let hello : String
    let expired : String
    let backTo : String
    let today : String
    let tommorow : String
    let sendMessage : String
    let distance:String
    let duration: String
    let scheduleBooking : String
    let vehicleType : String
    let promo : String
    let discardProfile:String
    let discardcontent:String
    let applied_promo:String
    let endTripStatus , beginTripStatus , apply , invalidCode , expiresOn , expiredOn, pleaseSelectOption : String
    let choostYourWash,showAll,hide,bookAWashAtPosition : String
    //"choose_your_wash" = "Choose Your Wash"
//    "show_all" = "Show All"
//    "hide" = "Hide"
//    "book_a_wash_at_position" = "Book a Wash at Position"
    
    enum CodingKeys : String,CodingKey {
        case promoCodes = "promo_codes"
        case appName = "app_name",scheduleDisplayDate = "schedule_display_date"
        case forceUpdate = "force_update",update
        case requestedService = "requested_service"
        case requesting, searchLocation = "search_location", selectPaymentMode = "select_payment_mode", fareEstimation = "fare_estimation", of, areYouSure = "are_you_sure", pending, completed, or, getMovingWith = "get_moving_with", tryAgain = "try_again", getMove = "get_move", signIn = "sign_in", register, connectSocialAcc = "connect_social_acc", password, forgotPassword = "forgot_password", enterPassword = "enter_password", credentialdonTRight = "credentialdon_t_right", login, mobileVerify = "mobile_verify", enterMobileno = "enter_mobileno", enterOtp = "enter_otp", sentCodeMob = "sent_code_mobile", didntRecOtp = "didnt_rec_otp", resendOtp = "resend_otp", otpSendAgain = "otp_send_again", termsCondition = "terms_condition", addHome = "add_home", addWork = "add_work", favorites, currency, home, work, message, ok, signOut = "sign_out", settings, regInformation = "reg_information", agreeTcPolicy = "agree_tc_policy", privacyPolicy = "privacy_policy", confirmInfo = "confirm_info", firstName = "first_name", lastName = "last_name", mobileNo = "mobile_no", refCode = "ref_code", cancelAccCreation = "cancel_acc_creation", infoNotSaved = "info_not_saved", confirm, cancel, enPushNotifyLogin = "en_push_notify_login", chooseAcc = "choose_acc", faceBook = "face_book", google, resetPassword = "reset_password", close, confirmPassword = "confirm_password", continueSendAlert = "continue_send_alert", common1Continue = "continue_alert", sendingAlert = "sending_alert", alertSent = "alert_sent", useEmergency = "use_emergency", alertEmergencyContact = "alert_emergency_contact", locationCollectData = "location_collect_data", locationEnsure = "location_ensure", likeToResetPass = "like_to_reset_pass", email, mobile, contacting, nearYou = "near_you", promoApplied = "promo_applied", cash, apple_pay, paypal, card, onlinePay = "online_pay", request, change, setUrPickUp = "set_ur_pick_up", setPicktUpTime = "set_pickt_up_time", normalFare = "normal_fare", minFare = "min_fare", minLeft = "min_left", minKM = "min_km", acceptHigherFare = "accept_higher_fare", tryLater = "try_later", fare, capacity, done, fareBreakDown = "fare_break_down", baseFare = "base_fare", perMin = "per_min", perKM = "per_km", currentLocation = "current_location", noLocationFound = "no_location_found", whereTo = "where_to", setPin = "set_pin", enterUrLocation = "enter_ur_location", enterHome = "enter_home", enterWork = "enter_work", travelSafer = "travel_safer", alertUrDears = "alert_ur_dears", youCanAddC = "you_can_add_c", removeContact = "remove_contact", addContacts = "add_contacts", emergencyContacts = "emergency_contacts", delete, contactAlreadyAdded = "contact_already_added", makeTravelSafe = "make_travel_safe", alertYourDear = "alert_your_dear", add5_Contacts = "add_5_contacts", removeContactAddone = "remove_contact_addone", off, from, promotions, paymentMethod = "payment_method", useWallet = "use_wallet", wallet, addPromoGiftCode = "add_promo_gift_code", enterPromoCode = "enter_promo_code", addCreditDebit = "add_credit_debit", changeCreditDebit = "change_credit_debit", rUSureToLogOut = "r_u_sure_to_log_out", payment, pay, waitDriverConfirm = "wait_driver_confirm", quantity, proceed, continueRequest = "continue_request", success, paymentPaidSuccess = "payment_paid_success", cancelled, failed, paymentDetails = "payment_details", totalFare = "total_fare", addPayment = "add_payment", addMoneytoWallet = "add_moneyto_wallet", addAmount = "add_amount", enterAmount = "enter_amount", walletAmountIs = "wallet_amount_is", amountFldReq = "amount_fld_req", driver, typeMessage = "type_message", noMsgYet = "no_msg_yet", getUpto = "get_upto", everyFriendRides = "every_friend_rides", signUpandGetPaid = "sign_upand_get_paid", referral, yourReferralCode = "your_referral_code", shareMyCode = "share_my_code", refCopytoClip = "ref_copyto_clip", referralCodeCopied = "referral_code_copied", useMyReferral = "use_my_referral", startJourneyonGofer = "start_journeyon_gofer", noRefYet = "no_ref_yet", friendsInComplete = "friends_in_complete", friendsCompleted = "friends_completed", earned, refExpired = "ref_expired", rateYourRide = "rate_your_ride", writeYourComment = "write_your_comment", schedule, tip, submit, common4Set = "set", add, enterTipAmount = "enter_tip_amount", past, upComming = "up_comming", pullToRefresh = "pull_to_refresh", id, cancelReason = "cancel_reason", contacts, call, contact, enRoute = "en_route", mins, restaurantDelights = "restaurant_delights", toWangs = "to_wangs", addHomeLOC = "add_home_loc", addWorkLOC = "add_work_loc", uploadFailed = "upload_failed", enterValidEmailID = "enter_valid_email_id", enterFirstName = "enter_first_name", enterlastName = "enterlast_name", enterEmailID = "enter_email_id", passwordMismatch = "password_mismatch", newVersAvail = "new_vers_avail", updateOurApp = "update_our_app", visitAppStore = "visit_app_store", totryAgain = "totry_again", sorryNoRides = "sorry_no_rides", contactAdmin = "contact_admin", save, selectPhoto = "select_photo", takePhoto = "take_photo", chooseLIB = "choose_lib", help, selectCntry = "select_cntry", minutesToArrive = "minutes_to_arrive", noContactFound = "no_contact_found", dial, no, yes, addTip = "add_tip", setTip = "set_tip", toDriver = "to_driver", pleaseEnterValidAmount = "please_enter_valid_amount", pleaseGiveRating = "please_give_rating", manualBooking = "manual_booking", dayLeft = "day_left", skip, answer, incomingCall = "incoming_call", completedStatus = "completed_status", cancelledStatus = "cancelled_status", reqStatus = "req_status", pendingStatus = "pending_status", sheduledStatus = "sheduled_status", paymentStatus = "payment_status", editTime = "edit_time", cancelRide = "cancel_ride", selectCountry = "select_country", search, clientNotInitialized = "client_not_initialized", jsonSerialaizationFailed = "json_serialaization_failed", noInternetConnection = "no_internet_connection", toReach = "to_reach", toArrive = "to_arrive", signInWith = "sign_in_with", userCancelledAuthentication = "user_cancelled_authentication", authenticationCancelled = "authentication_cancelled", connecting, ringing, callEnded = "call_ended", placehodlerMail = "placehodler_mail", enterValidOtp = "enter_valid_otp", locationService = "location_service", tracking, camera, photoLibrary = "photo_library", service, services, backToHome = "back_to_home", today = "today", tommorow = "tommorow" , sendMessage = "send_message"
        
        case app, pleaseEnable = "please_enable", requires, common6For = "for", functionality, requestStatus = "request_status", ratingStatus = "rating_status", scheduledStatus = "scheduled_status", microphoneSerivce = "microphone_serivce", inAppCall = "in_app_call", choose, choosePaymentMethod = "choose_payment_method", min, hr, hrs, language, selectLanguage = "select_language", editAccount = "edit_account", enterValidData = "enter_valid_data", confirmContact = "confirm_contact", rejected, busyTryAgain = "busy_try_again", pleaseEnablePushNotification = "please_enable_push_notification", address, error, deviceHasNoCamera = "device_has_no_camera", warning, phoneNumber = "phone_number", addressLineFirst = "address_line_first", addressLineSecond = "address_line_second", city, postalCode = "postal_code", state, manageServices = "manage_services", manageHome = "manage_home", loginText = "login_text", addItem = "add_item", welcomeLoginText = "welcome_login_text", yourJob = "your_job", tapToChange = "tap_to_change", dontHaveAcc = "dont_have_acc", alreadyHaveAcc = "already_have_acc", tocText = "toc_text", logout, pleaseGivePermission = "please_give_permission", termsConditions = "terms_conditions", smsMobileVerify = "sms_mobile_verify", didntReceiveOtp = "didnt_receive_otp", otpAgain = "otp_again", credentialsDontLook = "credentials_dont_look", enterYourFirstName = "enter_your_first_name", enterYourLastName = "enter_your_last_name", enterYourPhoneNumber = "enter_your_phone_number", enterYourEmail = "enter_your_email", enterYourPassword = "enter_your_password", country, myProfile = "my_profile", editProfile = "edit_profile", updateInfo = "update_info", changePassword = "change_password", added, next, enterLocation = "enter_location", youAreIn = "you_are_in", serviceAtMe = "service_at_me", setOnMap = "set_on_map", pleaseSetLocation = "please_set_location", yourBooking = "your_booking", onGoingJobs = "on_going_jobs", successFullyUpdated = "success_fully_updated", enterYourOldPassword = "enter_your_old_password", enterYourNewPassword = "enter_your_new_password", enterYourConformPassword = "enter_your_conform_password", pleaseAddThemToYourEmergencyContact = "please_add_them_to_your_emergency_contact", sorting, lessThanAkm = "less_than_akm", estimatedCharge = "estimated_charge", minimumHour = "minimum_hour", paymentOption = "payment_option", selectBookingLocation = "select_booking_location", providerArrived = "provider_arrived", calendar, bookingDetails = "booking_details", checkOut = "check_out", remove, estimatedFee = "estimated_fee", cart, paymentSummary = "payment_summary", jobRequestDate = "job_request_date", discountApplied = "discount_applied", providerFeedback = "provider_feedback", howWasTheJobDone = "how_was_the_job_done", moreInfo = "more_info", setLocationOnMap = "set_location_on_map", noServiceFound = "no_service_found", review, gallery, viewMore = "view_more", viewLess = "view_less", hereYouCanChangeYourMap = "here_you_can_change_your_map", byClicking = "by_clicking", googleMap = "google_map", wazeMap = "waze_map", doYouWant = "do_you_want", pleaseInstallGoogleMapsApp = "please_install_google_maps_app", doYouWantToAccessdirection = "do_you_want_to_accessdirection", pleaseInstallWazeMapsApp = "please_install_waze_maps_app", jobLocation = "job_location", destinationLocation = "destination_location", thanksForProvidingThisService = "thanks_for_providing_this_service", beforeService = "before_service", afterService = "after_service", fareDetails = "fare_details", paymentCompletedFor = "payment_completed_for", number
        
        case agreeTermsAndPrivacyPolicyContent = "agree_terms_and_privacy_policy_content", maxChar = "max_char", manuallyBookedAlert = "manually_booked_alert", manuallyBookedReminderAlert = "manually_booked_reminder_alert", manualBookiingCancelledAlert = "manual_bookiing_cancelled_alert", manualBookingInfoAlert = "manual_booking_info_alert", scheduledAlert = "scheduled_alert", requestAlert = "request_alert", beginJobAlert = "begin_job_alert", endJobAlert = "end_job_alert", pendingAlert = "pending_alert", cancelledAlert = "cancelled_alert", completedAlert = "completed_alert", ratingAlert = "rating_alert", paymentAlert = "payment_alert", editItem = "edit_item", noDataFound = "no_data_found", passwordValidationMsg = "password_validation_msg", specialInstruction = "special_instruction", provideFeedback = "provide_feedback", sendAlert = "send_alert", addThem = "add_them", sec, paymentType = "payment_type", yourInviteCode = "your_invite_code", forEveryFriendJobs = "for_every_friend_jobs", internalServerError = "internal_server_error", areYouSureYouWantToExit = "are_you_sure_you_want_to_exit", provideYourFeedback = "provide_your_feedback", balance
        case status,areYouSureYouWantToCancel = "are_you_sure_you_want_to_cancel",note,aToZ = "a_to_z",km
        case enterValidCardDetails = "enter_valid_card" // "Please enter valid card details"
        case scheduleBooking = "schedule_booking"
        case arriveNow = "arrive_now" // "arrivenow"
        case paymentCompletedSuccess = "payment_completed_successfully" // "Payment Completed successfully"
        case category,subCategory = "sub_category",fareType = "fare_type"
        case welcomeToThe = "welcome_text"
        case goferHandyUserApp = "goferhandy_user_app"
        case support
        case notAValidData = "not_a_valid_data"
        case beginJob = "begin_trip",endJob = "end_trip"
        case fromHere = "from_here"
        case locationPermissionDescription = "location_permission_description"
        case toAccessLocation = "to_access_location"
        case gettingLocation = "gettinglocate"
        case iAgreeToThe = "sigin_terms1"
        case and = "sigin_terms3"
        case daysLeft = "days_left"
        case jobs
        case selectCurrency = "selectcurrency"
        case allowCamera = "camera_permission_description"
        case toAccessCamera = "to_access_camera_and_storage"
        case onlinePayment = "online_payment"
        case covidTitle = "covid_title"
        case covidSubtitle = "covid_subtitle"
        case covidPointOne = "covid_point_one"
        case covidPointTwo = "covid_point_two"
        case covidPointThree = "covid_point_three"
        case covidFooter = "covid_footer"
        case covidRating = "covid_rating"
        case appleLogin = "apple_login"
        case loginToContinue = "login_to_continue"
        case welcomeBack = "welcome_back"
        case haveAnAccount = "already_have_an_account_sign_in"
        case continueWithPhone = "continue_with_phone_number"
        case walletMoneyApplied = "wallet_money_applied"
        case name = "name"
        case ourService = "our_service"
        case addPromoCode = "add_promo_code"
        case removePromoCode = "remove_promo_code"
        case changePromoCode = "change_promo_code"
        case amount = "amount"
        case font = "font"
        case theme = "theme"
        case history = "history"
        case changeTheme = "change_theme"
        case changeFont = "change_font"
        case pleaseEnterYourOldPassword = "please_enter_old_password"
        case pleaseEnterYourNewPassword = "please_enter_new_password"
        case pleaseEnterYourConfirmPassword = "please_enter_confirm_password"
        case setLocation = "set_location"
        case edit = "edit"
        case view = "view"
        case favourites = "favourites"
        case hello = "hello"
        case expired = "expired"
        case backTo = "back_to"
        case distance = "distance"
        case duration = "duration"
        case vehicleType = "vehicle_type"
        case promo = "promo"
        case discardProfile = "discardProfile"
        case discardcontent = "discardcontent"
        case applied_promo = "applied_promo"
        case endTripStatus = "end_trip_status" , beginTripStatus = "begin_trip_status" , apply = "apply" , invalidCode = "invalid_code" , expiresOn = "expires_on" , expiredOn = "expired_on", pleaseSelectOption = "please_select_option"
        case choostYourWash = "choose_your_wash", showAll = "show_all", hide ,bookAWashAtPosition = "book_a_wash_at_position"
    }
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestedService = container.safeDecodeValue(forKey: .requestedService)
        self.appName = container.safeDecodeValue(forKey: .appName)
        self.forceUpdate = container.safeDecodeValue(forKey: .forceUpdate)
        self.update = container.safeDecodeValue(forKey: .update)
        self.requesting = container.safeDecodeValue(forKey: .requesting)
        self.searchLocation = container.safeDecodeValue(forKey: .searchLocation)
        self.selectPaymentMode = container.safeDecodeValue(forKey: .selectPaymentMode)
        self.fareEstimation = container.safeDecodeValue(forKey: .fareEstimation)
        self.of = container.safeDecodeValue(forKey: .of)
        self.areYouSure = container.safeDecodeValue(forKey: .areYouSure)
        self.pending = container.safeDecodeValue(forKey: .pending)
        self.completed = container.safeDecodeValue(forKey: .completed)
        self.or = container.safeDecodeValue(forKey: .or)
        self.getMovingWith = container.safeDecodeValue(forKey: .getMovingWith)
        self.tryAgain = container.safeDecodeValue(forKey: .tryAgain)
        self.getMove = container.safeDecodeValue(forKey: .getMove)
        self.signIn = container.safeDecodeValue(forKey: .signIn)
        self.register = container.safeDecodeValue(forKey: .register)
        self.connectSocialAcc = container.safeDecodeValue(forKey: .connectSocialAcc)
        self.password = container.safeDecodeValue(forKey: .password)
        self.forgotPassword = container.safeDecodeValue(forKey: .forgotPassword)
        self.enterPassword = container.safeDecodeValue(forKey: .enterPassword)
        self.credentialdonTRight = container.safeDecodeValue(forKey: .credentialdonTRight)
        self.login = container.safeDecodeValue(forKey: .login)
        self.mobileVerify = container.safeDecodeValue(forKey: .mobileVerify)
        self.enterMobileno = container.safeDecodeValue(forKey: .enterMobileno)
        self.enterOtp = container.safeDecodeValue(forKey: .enterOtp)
        self.sentCodeMob = container.safeDecodeValue(forKey: .sentCodeMob)
        self.didntRecOtp = container.safeDecodeValue(forKey: .didntRecOtp)
        self.resendOtp = container.safeDecodeValue(forKey: .resendOtp)
        self.otpSendAgain = container.safeDecodeValue(forKey: .otpSendAgain)
        self.termsCondition = container.safeDecodeValue(forKey: .termsCondition)
        self.addHome = container.safeDecodeValue(forKey: .addHome)
        self.addWork = container.safeDecodeValue(forKey: .addWork)
        self.favorites = container.safeDecodeValue(forKey: .favorites)
        self.currency = container.safeDecodeValue(forKey: .currency)
        self.home = container.safeDecodeValue(forKey: .home)
        self.work = container.safeDecodeValue(forKey: .work)
        self.message = container.safeDecodeValue(forKey: .message)
        self.ok = container.safeDecodeValue(forKey: .ok)
        self.signOut = container.safeDecodeValue(forKey: .signOut)
        self.settings = container.safeDecodeValue(forKey: .settings)
        self.regInformation = container.safeDecodeValue(forKey: .regInformation)
        self.agreeTcPolicy = container.safeDecodeValue(forKey: .agreeTcPolicy)
        self.privacyPolicy = container.safeDecodeValue(forKey: .privacyPolicy)
        self.confirmInfo = container.safeDecodeValue(forKey: .confirmInfo)
        self.firstName = container.safeDecodeValue(forKey: .firstName)
        self.lastName = container.safeDecodeValue(forKey: .lastName)
        self.mobileNo = container.safeDecodeValue(forKey: .mobileNo)
        self.refCode = container.safeDecodeValue(forKey: .refCode)
        self.cancelAccCreation = container.safeDecodeValue(forKey: .cancelAccCreation)
        self.infoNotSaved = container.safeDecodeValue(forKey: .infoNotSaved)
        self.confirm = container.safeDecodeValue(forKey: .confirm)
        self.cancel = container.safeDecodeValue(forKey: .cancel)
        self.enPushNotifyLogin = container.safeDecodeValue(forKey: .enPushNotifyLogin)
        self.chooseAcc = container.safeDecodeValue(forKey: .chooseAcc)
        self.faceBook = container.safeDecodeValue(forKey: .faceBook)
        self.google = container.safeDecodeValue(forKey: .google)
        self.resetPassword = container.safeDecodeValue(forKey: .resetPassword)
        self.close = container.safeDecodeValue(forKey: .close)
        self.confirmPassword = container.safeDecodeValue(forKey: .confirmPassword)
        self.continueSendAlert = container.safeDecodeValue(forKey: .continueSendAlert)
        self.common1Continue = container.safeDecodeValue(forKey: .common1Continue)
        self.sendingAlert = container.safeDecodeValue(forKey: .sendingAlert)
        self.alertSent = container.safeDecodeValue(forKey: .alertSent)
        self.useEmergency = container.safeDecodeValue(forKey: .useEmergency)
        self.alertEmergencyContact = container.safeDecodeValue(forKey: .alertEmergencyContact)
        self.locationCollectData = container.safeDecodeValue(forKey: .locationCollectData)
        self.locationEnsure = container.safeDecodeValue(forKey: .locationEnsure)
        self.likeToResetPass = container.safeDecodeValue(forKey: .likeToResetPass)
        self.email = container.safeDecodeValue(forKey: .email)
        self.mobile = container.safeDecodeValue(forKey: .mobile)
        self.contacting = container.safeDecodeValue(forKey: .contacting)
        self.nearYou = container.safeDecodeValue(forKey: .nearYou)
        self.promoApplied = container.safeDecodeValue(forKey: .promoApplied)
        self.cash = container.safeDecodeValue(forKey: .cash)
        self.apple_pay = container.safeDecodeValue(forKey: .apple_pay)
        self.paypal = container.safeDecodeValue(forKey: .paypal)
        self.card = container.safeDecodeValue(forKey: .card)
        self.onlinePay = container.safeDecodeValue(forKey: .onlinePay)
        self.request = container.safeDecodeValue(forKey: .request)
        self.change = container.safeDecodeValue(forKey: .change)
        self.setUrPickUp = container.safeDecodeValue(forKey: .setUrPickUp)
        self.setPicktUpTime = container.safeDecodeValue(forKey: .setPicktUpTime)
        self.normalFare = container.safeDecodeValue(forKey: .normalFare)
        self.minFare = container.safeDecodeValue(forKey: .minFare)
        self.minLeft = container.safeDecodeValue(forKey: .minLeft)
        self.minKM = container.safeDecodeValue(forKey: .minKM)
        self.acceptHigherFare = container.safeDecodeValue(forKey: .acceptHigherFare)
        self.tryLater = container.safeDecodeValue(forKey: .tryLater)
        self.fare = container.safeDecodeValue(forKey: .fare)
        self.capacity = container.safeDecodeValue(forKey: .capacity)
        self.done = container.safeDecodeValue(forKey: .done)
        self.fareBreakDown = container.safeDecodeValue(forKey: .fareBreakDown)
        self.baseFare = container.safeDecodeValue(forKey: .baseFare)
        self.perMin = container.safeDecodeValue(forKey: .perMin)
        self.perKM = container.safeDecodeValue(forKey: .perKM)
        self.currentLocation = container.safeDecodeValue(forKey: .currentLocation)
        self.noLocationFound = container.safeDecodeValue(forKey: .noLocationFound)
        self.whereTo = container.safeDecodeValue(forKey: .whereTo)
        self.setPin = container.safeDecodeValue(forKey: .setPin)
        self.enterUrLocation = container.safeDecodeValue(forKey: .enterUrLocation)
        self.enterHome = container.safeDecodeValue(forKey: .enterHome)
        self.enterWork = container.safeDecodeValue(forKey: .enterWork)
        self.travelSafer = container.safeDecodeValue(forKey: .travelSafer)
        self.alertUrDears = container.safeDecodeValue(forKey: .alertUrDears)
        self.youCanAddC = container.safeDecodeValue(forKey: .youCanAddC)
        self.removeContact = container.safeDecodeValue(forKey: .removeContact)
        self.addContacts = container.safeDecodeValue(forKey: .addContacts)
        self.emergencyContacts = container.safeDecodeValue(forKey: .emergencyContacts)
        self.delete = container.safeDecodeValue(forKey: .delete)
        self.contactAlreadyAdded = container.safeDecodeValue(forKey: .contactAlreadyAdded)
        self.makeTravelSafe = container.safeDecodeValue(forKey: .makeTravelSafe)
        self.alertYourDear = container.safeDecodeValue(forKey: .alertYourDear)
        self.add5_Contacts = container.safeDecodeValue(forKey: .add5_Contacts)
        self.removeContactAddone = container.safeDecodeValue(forKey: .removeContactAddone)
        self.off = container.safeDecodeValue(forKey: .off)
        self.from = container.safeDecodeValue(forKey: .from)
        self.promotions = container.safeDecodeValue(forKey: .promotions)
        self.paymentMethod = container.safeDecodeValue(forKey: .paymentMethod)
        self.useWallet = container.safeDecodeValue(forKey: .useWallet)
        self.wallet = container.safeDecodeValue(forKey: .wallet)
        self.addPromoGiftCode = container.safeDecodeValue(forKey: .addPromoGiftCode)
        self.enterPromoCode = container.safeDecodeValue(forKey: .enterPromoCode)
        self.addCreditDebit = container.safeDecodeValue(forKey: .addCreditDebit)
        self.changeCreditDebit = container.safeDecodeValue(forKey: .changeCreditDebit)
        self.rUSureToLogOut = container.safeDecodeValue(forKey: .rUSureToLogOut)
        self.payment = container.safeDecodeValue(forKey: .payment)
        self.pay = container.safeDecodeValue(forKey: .pay)
        self.waitDriverConfirm = container.safeDecodeValue(forKey: .waitDriverConfirm)
        self.quantity = container.safeDecodeValue(forKey: .quantity)
        self.proceed = container.safeDecodeValue(forKey: .proceed)
        self.continueRequest = container.safeDecodeValue(forKey: .continueRequest)
        self.success = container.safeDecodeValue(forKey: .success)
        self.paymentPaidSuccess = container.safeDecodeValue(forKey: .paymentPaidSuccess)
        self.cancelled = container.safeDecodeValue(forKey: .cancelled)
        self.failed = container.safeDecodeValue(forKey: .failed)
        self.paymentDetails = container.safeDecodeValue(forKey: .paymentDetails)
        self.totalFare = container.safeDecodeValue(forKey: .totalFare)
        self.addPayment = container.safeDecodeValue(forKey: .addPayment)
        self.addMoneytoWallet = container.safeDecodeValue(forKey: .addMoneytoWallet)
        self.addAmount = container.safeDecodeValue(forKey: .addAmount)
        self.enterAmount = container.safeDecodeValue(forKey: .enterAmount)
        self.walletAmountIs = container.safeDecodeValue(forKey: .walletAmountIs)
        self.amountFldReq = container.safeDecodeValue(forKey: .amountFldReq)
        self.driver = container.safeDecodeValue(forKey: .driver)
        self.typeMessage = container.safeDecodeValue(forKey: .typeMessage)
        self.noMsgYet = container.safeDecodeValue(forKey: .noMsgYet)
        self.getUpto = container.safeDecodeValue(forKey: .getUpto)
        self.everyFriendRides = container.safeDecodeValue(forKey: .everyFriendRides)
        self.signUpandGetPaid = container.safeDecodeValue(forKey: .signUpandGetPaid)
        self.referral = container.safeDecodeValue(forKey: .referral)
        self.yourReferralCode = container.safeDecodeValue(forKey: .yourReferralCode)
        self.shareMyCode = container.safeDecodeValue(forKey: .shareMyCode)
        self.refCopytoClip = container.safeDecodeValue(forKey: .refCopytoClip)
        self.referralCodeCopied = container.safeDecodeValue(forKey: .referralCodeCopied)
        self.useMyReferral = container.safeDecodeValue(forKey: .useMyReferral)
        self.startJourneyonGofer = container.safeDecodeValue(forKey: .startJourneyonGofer)
        self.noRefYet = container.safeDecodeValue(forKey: .noRefYet)
        self.friendsInComplete = container.safeDecodeValue(forKey: .friendsInComplete)
        self.friendsCompleted = container.safeDecodeValue(forKey: .friendsCompleted)
        self.earned = container.safeDecodeValue(forKey: .earned)
        self.refExpired = container.safeDecodeValue(forKey: .refExpired)
        self.rateYourRide = container.safeDecodeValue(forKey: .rateYourRide)
        self.writeYourComment = container.safeDecodeValue(forKey: .writeYourComment)
        self.schedule = container.safeDecodeValue(forKey: .schedule)
        self.tip = container.safeDecodeValue(forKey: .tip)
        self.submit = container.safeDecodeValue(forKey: .submit)
        self.common4Set = container.safeDecodeValue(forKey: .common4Set)
        self.add = container.safeDecodeValue(forKey: .add)
        self.enterTipAmount = container.safeDecodeValue(forKey: .enterTipAmount)
        self.past = container.safeDecodeValue(forKey: .past)
        self.upComming = container.safeDecodeValue(forKey: .upComming)
        self.pullToRefresh = container.safeDecodeValue(forKey: .pullToRefresh)
        self.id = container.safeDecodeValue(forKey: .id)
        self.cancelReason = container.safeDecodeValue(forKey: .cancelReason)
        self.contacts = container.safeDecodeValue(forKey: .contacts)
        self.call = container.safeDecodeValue(forKey: .call)
        self.contact = container.safeDecodeValue(forKey: .contact)
        self.enRoute = container.safeDecodeValue(forKey: .enRoute)
        self.mins = container.safeDecodeValue(forKey: .mins)
        self.restaurantDelights = container.safeDecodeValue(forKey: .restaurantDelights)
        self.toWangs = container.safeDecodeValue(forKey: .toWangs)
        self.addHomeLOC = container.safeDecodeValue(forKey: .addHomeLOC)
        self.addWorkLOC = container.safeDecodeValue(forKey: .addWorkLOC)
        self.uploadFailed = container.safeDecodeValue(forKey: .uploadFailed)
        self.enterValidEmailID = container.safeDecodeValue(forKey: .enterValidEmailID)
        self.enterFirstName = container.safeDecodeValue(forKey: .enterFirstName)
        self.enterlastName = container.safeDecodeValue(forKey: .enterlastName)
        self.enterEmailID = container.safeDecodeValue(forKey: .enterEmailID)
        self.passwordMismatch = container.safeDecodeValue(forKey: .passwordMismatch)
        self.newVersAvail = container.safeDecodeValue(forKey: .newVersAvail)
        self.updateOurApp = container.safeDecodeValue(forKey: .updateOurApp)
        self.visitAppStore = container.safeDecodeValue(forKey: .visitAppStore)
        self.totryAgain = container.safeDecodeValue(forKey: .totryAgain)
        self.sorryNoRides = container.safeDecodeValue(forKey: .sorryNoRides)
        self.contactAdmin = container.safeDecodeValue(forKey: .contactAdmin)
        self.save = container.safeDecodeValue(forKey: .save)
        self.selectPhoto = container.safeDecodeValue(forKey: .selectPhoto)
        self.takePhoto = container.safeDecodeValue(forKey: .takePhoto)
        self.chooseLIB = container.safeDecodeValue(forKey: .chooseLIB)
        self.help = container.safeDecodeValue(forKey: .help)
        self.selectCntry = container.safeDecodeValue(forKey: .selectCntry)
        self.minutesToArrive = container.safeDecodeValue(forKey: .minutesToArrive)
        self.noContactFound = container.safeDecodeValue(forKey: .noContactFound)
        self.dial = container.safeDecodeValue(forKey: .dial)
        self.no = container.safeDecodeValue(forKey: .no)
        self.yes = container.safeDecodeValue(forKey: .yes)
        self.addTip = container.safeDecodeValue(forKey: .addTip)
        self.setTip = container.safeDecodeValue(forKey: .setTip)
        self.toDriver = container.safeDecodeValue(forKey: .toDriver)
        self.pleaseEnterValidAmount = container.safeDecodeValue(forKey: .pleaseEnterValidAmount)
        self.pleaseGiveRating = container.safeDecodeValue(forKey: .pleaseGiveRating)
        self.manualBooking = container.safeDecodeValue(forKey: .manualBooking)
        self.dayLeft = container.safeDecodeValue(forKey: .dayLeft)
        self.skip = container.safeDecodeValue(forKey: .skip)
        self.answer = container.safeDecodeValue(forKey: .answer)
        self.incomingCall = container.safeDecodeValue(forKey: .incomingCall)
        self.completedStatus = container.safeDecodeValue(forKey: .completedStatus)
        self.cancelledStatus = container.safeDecodeValue(forKey: .cancelledStatus)
        self.reqStatus = container.safeDecodeValue(forKey: .reqStatus)
        self.pendingStatus = container.safeDecodeValue(forKey: .pendingStatus)
        self.sheduledStatus = container.safeDecodeValue(forKey: .sheduledStatus)
        self.paymentStatus = container.safeDecodeValue(forKey: .paymentStatus)
        self.editTime = container.safeDecodeValue(forKey: .editTime)
        self.cancelRide = container.safeDecodeValue(forKey: .cancelRide)
        self.selectCountry = container.safeDecodeValue(forKey: .selectCountry)
        self.search = container.safeDecodeValue(forKey: .search)
        self.clientNotInitialized = container.safeDecodeValue(forKey: .clientNotInitialized)
        self.jsonSerialaizationFailed = container.safeDecodeValue(forKey: .jsonSerialaizationFailed)
        self.noInternetConnection = container.safeDecodeValue(forKey: .noInternetConnection)
        self.toReach = container.safeDecodeValue(forKey: .toReach)
        self.toArrive = container.safeDecodeValue(forKey: .toArrive)
        self.signInWith = container.safeDecodeValue(forKey: .signInWith)
        self.userCancelledAuthentication = container.safeDecodeValue(forKey: .userCancelledAuthentication)
        self.authenticationCancelled = container.safeDecodeValue(forKey: .authenticationCancelled)
        self.connecting = container.safeDecodeValue(forKey: .connecting)
        self.ringing = container.safeDecodeValue(forKey: .ringing)
        self.callEnded = container.safeDecodeValue(forKey: .callEnded)
        self.placehodlerMail = container.safeDecodeValue(forKey: .placehodlerMail)
        self.enterValidOtp = container.safeDecodeValue(forKey: .enterValidOtp)
        self.locationService = container.safeDecodeValue(forKey: .locationService)
        self.tracking = container.safeDecodeValue(forKey: .tracking)
        self.camera = container.safeDecodeValue(forKey: .camera)
        self.photoLibrary = container.safeDecodeValue(forKey: .photoLibrary)
        self.service = container.safeDecodeValue(forKey: .service)
        self.services = container.safeDecodeValue(forKey: .services)
        self.app = container.safeDecodeValue(forKey: .app)
        self.pleaseEnable = container.safeDecodeValue(forKey: .pleaseEnable)
        self.requires = container.safeDecodeValue(forKey: .requires)
        self.common6For = container.safeDecodeValue(forKey: .common6For)
        self.functionality = container.safeDecodeValue(forKey: .functionality)
        self.requestStatus = container.safeDecodeValue(forKey: .requestStatus)
        self.ratingStatus = container.safeDecodeValue(forKey: .ratingStatus)
        self.scheduledStatus = container.safeDecodeValue(forKey: .scheduledStatus)
        self.microphoneSerivce = container.safeDecodeValue(forKey: .microphoneSerivce)
        self.inAppCall = container.safeDecodeValue(forKey: .inAppCall)
        self.choose = container.safeDecodeValue(forKey: .choose)
        self.choosePaymentMethod = container.safeDecodeValue(forKey: .choosePaymentMethod)
        self.min = container.safeDecodeValue(forKey: .min)
        self.hr = container.safeDecodeValue(forKey: .hr)
        self.hrs = container.safeDecodeValue(forKey: .hrs)
        self.language = container.safeDecodeValue(forKey: .language)
        self.selectLanguage = container.safeDecodeValue(forKey: .selectLanguage)
        self.editAccount = container.safeDecodeValue(forKey: .editAccount)
        self.enterValidData = container.safeDecodeValue(forKey: .enterValidData)
        self.confirmContact = container.safeDecodeValue(forKey: .confirmContact)
        self.rejected = container.safeDecodeValue(forKey: .rejected)
        self.busyTryAgain = container.safeDecodeValue(forKey: .busyTryAgain)
        self.pleaseEnablePushNotification = container.safeDecodeValue(forKey: .pleaseEnablePushNotification)
        self.address = container.safeDecodeValue(forKey: .address)
        self.error = container.safeDecodeValue(forKey: .error)
        self.deviceHasNoCamera = container.safeDecodeValue(forKey: .deviceHasNoCamera)
        self.warning = container.safeDecodeValue(forKey: .warning)
        self.phoneNumber = container.safeDecodeValue(forKey: .phoneNumber)
        self.addressLineFirst = container.safeDecodeValue(forKey: .addressLineFirst)
        self.addressLineSecond = container.safeDecodeValue(forKey: .addressLineSecond)
        self.city = container.safeDecodeValue(forKey: .city)
        self.postalCode = container.safeDecodeValue(forKey: .postalCode)
        self.state = container.safeDecodeValue(forKey: .state)
        self.manageServices = container.safeDecodeValue(forKey: .manageServices)
        self.manageHome = container.safeDecodeValue(forKey: .manageHome)
        self.loginText = container.safeDecodeValue(forKey: .loginText)
        self.addItem = container.safeDecodeValue(forKey: .addItem)
        self.welcomeLoginText = container.safeDecodeValue(forKey: .welcomeLoginText)
        self.yourJob = container.safeDecodeValue(forKey: .yourJob)
        self.tapToChange = container.safeDecodeValue(forKey: .tapToChange)
        self.dontHaveAcc = container.safeDecodeValue(forKey: .dontHaveAcc)
        self.alreadyHaveAcc = container.safeDecodeValue(forKey: .alreadyHaveAcc)
        self.tocText = container.safeDecodeValue(forKey: .tocText)
        self.logout = container.safeDecodeValue(forKey: .logout)
        self.pleaseGivePermission = container.safeDecodeValue(forKey: .pleaseGivePermission)
        self.termsConditions = container.safeDecodeValue(forKey: .termsConditions)
        self.smsMobileVerify = container.safeDecodeValue(forKey: .smsMobileVerify)
        self.didntReceiveOtp = container.safeDecodeValue(forKey: .didntReceiveOtp)
        self.otpAgain = container.safeDecodeValue(forKey: .otpAgain)
        self.credentialsDontLook = container.safeDecodeValue(forKey: .credentialsDontLook)
        self.enterYourFirstName = container.safeDecodeValue(forKey: .enterYourFirstName)
        self.enterYourLastName = container.safeDecodeValue(forKey: .enterYourLastName)
        self.enterYourPhoneNumber = container.safeDecodeValue(forKey: .enterYourPhoneNumber)
        self.enterYourEmail = container.safeDecodeValue(forKey: .enterYourEmail)
        self.enterYourPassword = container.safeDecodeValue(forKey: .enterYourPassword)
        self.country = container.safeDecodeValue(forKey: .country)
        self.myProfile = container.safeDecodeValue(forKey: .myProfile)
        self.editProfile = container.safeDecodeValue(forKey: .editProfile)
        self.updateInfo = container.safeDecodeValue(forKey: .updateInfo)
        self.changePassword = container.safeDecodeValue(forKey: .changePassword)
        self.added = container.safeDecodeValue(forKey: .added)
        self.next = container.safeDecodeValue(forKey: .next)
        self.enterLocation = container.safeDecodeValue(forKey: .enterLocation)
        self.youAreIn = container.safeDecodeValue(forKey: .youAreIn)
        self.serviceAtMe = container.safeDecodeValue(forKey: .serviceAtMe)
        self.setOnMap = container.safeDecodeValue(forKey: .setOnMap)
        self.pleaseSetLocation = container.safeDecodeValue(forKey: .pleaseSetLocation)
        self.yourBooking = container.safeDecodeValue(forKey: .yourBooking)
        self.onGoingJobs = container.safeDecodeValue(forKey: .onGoingJobs)
        self.successFullyUpdated = container.safeDecodeValue(forKey: .successFullyUpdated)
        self.enterYourOldPassword = container.safeDecodeValue(forKey: .enterYourOldPassword)
        self.enterYourNewPassword = container.safeDecodeValue(forKey: .enterYourNewPassword)
        self.enterYourConformPassword = container.safeDecodeValue(forKey: .enterYourConformPassword)
        self.pleaseAddThemToYourEmergencyContact = container.safeDecodeValue(forKey: .pleaseAddThemToYourEmergencyContact)
        self.sorting = container.safeDecodeValue(forKey: .sorting)
        self.lessThanAkm = container.safeDecodeValue(forKey: .lessThanAkm)
        self.estimatedCharge = container.safeDecodeValue(forKey: .estimatedCharge)
        self.minimumHour = container.safeDecodeValue(forKey: .minimumHour)
        self.paymentOption = container.safeDecodeValue(forKey: .paymentOption)
        self.selectBookingLocation = container.safeDecodeValue(forKey: .selectBookingLocation)
        self.providerArrived = container.safeDecodeValue(forKey: .providerArrived)
        self.calendar = container.safeDecodeValue(forKey: .calendar)
        self.bookingDetails = container.safeDecodeValue(forKey: .bookingDetails)
        self.checkOut = container.safeDecodeValue(forKey: .checkOut)
        self.remove = container.safeDecodeValue(forKey: .remove)
        self.estimatedFee = container.safeDecodeValue(forKey: .estimatedFee)
        self.cart = container.safeDecodeValue(forKey: .cart)
        self.paymentSummary = container.safeDecodeValue(forKey: .paymentSummary)
        self.jobRequestDate = container.safeDecodeValue(forKey: .jobRequestDate)
        self.discountApplied = container.safeDecodeValue(forKey: .discountApplied)
        self.providerFeedback = container.safeDecodeValue(forKey: .providerFeedback)
        self.howWasTheJobDone = container.safeDecodeValue(forKey: .howWasTheJobDone)
        self.moreInfo = container.safeDecodeValue(forKey: .moreInfo)
        self.setLocationOnMap = container.safeDecodeValue(forKey: .setLocationOnMap)
        self.noServiceFound = container.safeDecodeValue(forKey: .noServiceFound)
        self.review = container.safeDecodeValue(forKey: .review)
        self.gallery = container.safeDecodeValue(forKey: .gallery)
        self.viewMore = container.safeDecodeValue(forKey: .viewMore)
        self.viewLess = container.safeDecodeValue(forKey: .viewLess)
        self.hereYouCanChangeYourMap = container.safeDecodeValue(forKey: .hereYouCanChangeYourMap)
        self.byClicking = container.safeDecodeValue(forKey: .byClicking)
        self.googleMap = container.safeDecodeValue(forKey: .googleMap)
        self.wazeMap = container.safeDecodeValue(forKey: .wazeMap)
        self.doYouWant = container.safeDecodeValue(forKey: .doYouWant)
        self.pleaseInstallGoogleMapsApp = container.safeDecodeValue(forKey: .pleaseInstallGoogleMapsApp)
        self.doYouWantToAccessdirection = container.safeDecodeValue(forKey: .doYouWantToAccessdirection)
        self.pleaseInstallWazeMapsApp = container.safeDecodeValue(forKey: .pleaseInstallWazeMapsApp)
        self.jobLocation = container.safeDecodeValue(forKey: .jobLocation)
        self.destinationLocation = container.safeDecodeValue(forKey: .destinationLocation)
        self.thanksForProvidingThisService = container.safeDecodeValue(forKey: .thanksForProvidingThisService)
        self.beforeService = container.safeDecodeValue(forKey: .beforeService)
        self.afterService = container.safeDecodeValue(forKey: .afterService)
        self.fareDetails = container.safeDecodeValue(forKey: .fareDetails)
        self.paymentCompletedFor = container.safeDecodeValue(forKey: .paymentCompletedFor)
        self.number = container.safeDecodeValue(forKey: .number)
        self.agreeTermsAndPrivacyPolicyContent = container.safeDecodeValue(forKey: .agreeTermsAndPrivacyPolicyContent)
        self.maxChar = container.safeDecodeValue(forKey: .maxChar)
        self.manuallyBookedAlert = container.safeDecodeValue(forKey: .manuallyBookedAlert)
        self.manuallyBookedReminderAlert = container.safeDecodeValue(forKey: .manuallyBookedReminderAlert)
        self.manualBookiingCancelledAlert = container.safeDecodeValue(forKey: .manualBookiingCancelledAlert)
        self.manualBookingInfoAlert = container.safeDecodeValue(forKey: .manualBookingInfoAlert)
        self.scheduledAlert = container.safeDecodeValue(forKey: .scheduledAlert)
        self.requestAlert = container.safeDecodeValue(forKey: .requestAlert)
        self.beginJobAlert = container.safeDecodeValue(forKey: .beginJobAlert)
        self.endJobAlert = container.safeDecodeValue(forKey: .endJobAlert)
        self.pendingAlert = container.safeDecodeValue(forKey: .pendingAlert)
        self.cancelledAlert = container.safeDecodeValue(forKey: .cancelledAlert)
        self.completedAlert = container.safeDecodeValue(forKey: .completedAlert)
        self.ratingAlert = container.safeDecodeValue(forKey: .ratingAlert)
        self.paymentAlert = container.safeDecodeValue(forKey: .paymentAlert)
        self.editItem = container.safeDecodeValue(forKey: .editItem)
        self.noDataFound = container.safeDecodeValue(forKey: .noDataFound)
        self.passwordValidationMsg = container.safeDecodeValue(forKey: .passwordValidationMsg)
        self.specialInstruction = container.safeDecodeValue(forKey: .specialInstruction)
        self.provideFeedback = container.safeDecodeValue(forKey: .provideFeedback)
        self.sendAlert = container.safeDecodeValue(forKey: .sendAlert)
        self.addThem = container.safeDecodeValue(forKey: .addThem)
        self.sec = container.safeDecodeValue(forKey: .sec)
        self.paymentType = container.safeDecodeValue(forKey: .paymentType)
        self.yourInviteCode = container.safeDecodeValue(forKey: .yourInviteCode)
        self.forEveryFriendJobs = container.safeDecodeValue(forKey: .forEveryFriendJobs)
        self.internalServerError = container.safeDecodeValue(forKey: .internalServerError)
        self.areYouSureYouWantToExit = container.safeDecodeValue(forKey: .areYouSureYouWantToExit)
        self.provideYourFeedback = container.safeDecodeValue(forKey: .provideYourFeedback)
        self.balance = container.safeDecodeValue(forKey: .balance)
        self.status = container.safeDecodeValue(forKey: .status)
        self.areYouSureYouWantToCancel = container.safeDecodeValue(forKey: .areYouSureYouWantToCancel)
        self.note = container.safeDecodeValue(forKey: .note)
        self.aToZ = container.safeDecodeValue(forKey: .aToZ)
        self.km = container.safeDecodeValue(forKey: .km)
        self.enterValidCardDetails = container.safeDecodeValue(forKey: .enterValidCardDetails)
        self.arriveNow = container.safeDecodeValue(forKey: .arriveNow)
        self.paymentCompletedSuccess =  container.safeDecodeValue(forKey: .paymentCompletedSuccess)
        self.category = container.safeDecodeValue(forKey: .category)
        self.subCategory = container.safeDecodeValue(forKey: .subCategory)
        self.fareType = container.safeDecodeValue(forKey: .fareType)
        self.welcomeToThe = container.safeDecodeValue(forKey: .welcomeToThe)
        self.goferHandyUserApp = container.safeDecodeValue(forKey: .goferHandyUserApp)
        self.support = container.safeDecodeValue(forKey: .support)
        self.notAValidData = container.safeDecodeValue(forKey: .notAValidData)
        self.beginJob = container.safeDecodeValue(forKey: .beginJob)
        self.endJob = container.safeDecodeValue(forKey: .endJob)
        self.fromHere = container.safeDecodeValue(forKey: .fromHere)
        self.locationPermissionDescription = container.safeDecodeValue(forKey: .locationPermissionDescription)
        self.toAccessLocation = container.safeDecodeValue(forKey: .toAccessLocation)
        self.gettingLocation = container.safeDecodeValue(forKey: .gettingLocation)
        self.iAgreeToThe = container.safeDecodeValue(forKey: .iAgreeToThe)
        self.and = container.safeDecodeValue(forKey: .and)
        self.daysLeft = container.safeDecodeValue(forKey: .daysLeft)
        self.jobs = container.safeDecodeValue(forKey: .jobs)
        self.selectCurrency = container.safeDecodeValue(forKey: .selectCurrency)
        self.allowCamera = container.safeDecodeValue(forKey: .allowCamera)
        self.toAccessCamera = container.safeDecodeValue(forKey: .toAccessCamera)
        self.onlinePayment = container.safeDecodeValue(forKey: .onlinePayment)
        self.covidTitle = container.safeDecodeValue(forKey: .covidTitle)
        self.covidSubtitle = container.safeDecodeValue(forKey: .covidSubtitle)
        self.covidPointOne = container.safeDecodeValue(forKey: .covidPointOne)
        self.covidPointTwo = container.safeDecodeValue(forKey: .covidPointTwo)
        self.covidPointThree = container.safeDecodeValue(forKey: .covidPointThree)
        self.covidFooter = container.safeDecodeValue(forKey: .covidFooter)
        self.covidRating = container.safeDecodeValue(forKey: .covidRating)
        self.welcomeBack = container.safeDecodeValue(forKey: .welcomeBack)
        self.loginToContinue = container.safeDecodeValue(forKey: .loginToContinue)
        self.appleLogin = container.safeDecodeValue(forKey: .appleLogin)
        self.haveAnAccount = container.safeDecodeValue(forKey: .haveAnAccount)
        self.continueWithPhone = container.safeDecodeValue(forKey: .continueWithPhone)
        self.walletMoneyApplied = container.safeDecodeValue(forKey: .walletMoneyApplied)
        self.scheduleDisplayDate = container.safeDecodeValue(forKey: .scheduleDisplayDate)
        self.name = container.safeDecodeValue(forKey: .name)
        self.ourService = container.safeDecodeValue(forKey: .ourService)
        self.addPromoCode = container.safeDecodeValue(forKey: .addPromoCode)
        self.removePromoCode = container.safeDecodeValue(forKey: .removePromoCode)
        self.changePromoCode = container.safeDecodeValue(forKey: .changePromoCode)
        self.amount = container.safeDecodeValue(forKey: .amount)
        self.font = container.safeDecodeValue(forKey: .font)
        self.theme = container.safeDecodeValue(forKey: .theme)
        self.history = container.safeDecodeValue(forKey: .history)
        self.changeTheme = container.safeDecodeValue(forKey: .changeTheme)
        self.changeFont = container.safeDecodeValue(forKey: .changeFont)
        self.pleaseEnterYourOldPassword = container.safeDecodeValue(forKey: .pleaseEnterYourOldPassword)
        self.pleaseEnterYourNewPassword = container.safeDecodeValue(forKey: .pleaseEnterYourNewPassword)
        self.pleaseEnterYourConfirmPassword = container.safeDecodeValue(forKey: .pleaseEnterYourConfirmPassword)
        self.setLocation = container.safeDecodeValue(forKey: .setLocation)
        self.backToHome = container.safeDecodeValue(forKey: .backToHome)
        self.edit = container.safeDecodeValue(forKey: .edit)
        self.view = container.safeDecodeValue(forKey: .view)
        self.favourites = container.safeDecodeValue(forKey: .favourites)
        self.hello = container.safeDecodeValue(forKey: .hello)
        self.expired = container.safeDecodeValue(forKey: .expired)
        self.backTo = container.safeDecodeValue(forKey: .backTo)
        self.today = container.safeDecodeValue(forKey: .today)
        self.tommorow = container.safeDecodeValue(forKey: .tommorow)
        self.sendMessage = container.safeDecodeValue(forKey: .sendMessage)
        self.distance = container.safeDecodeValue(forKey: .distance)
        self.duration = container.safeDecodeValue(forKey: .duration)
        self.scheduleBooking = container.safeDecodeValue(forKey: .scheduleBooking)
        self.vehicleType = container.safeDecodeValue(forKey: .vehicleType)
        self.promoCodes = container.safeDecodeValue(forKey: .promoCodes)
        self.promo = container.safeDecodeValue(forKey: .promo)
        self.discardProfile = container.safeDecodeValue(forKey: .discardProfile)
        self.discardcontent = container.safeDecodeValue(forKey: .discardcontent)
        self.applied_promo = container.safeDecodeValue(forKey: .applied_promo)
        self.endTripStatus = container.safeDecodeValue(forKey: .endTripStatus)
        self.beginTripStatus = container.safeDecodeValue(forKey: .beginTripStatus)
        self.apply = container.safeDecodeValue(forKey: .apply)
        self.invalidCode = container.safeDecodeValue(forKey: .invalidCode)
        self.expiresOn = container.safeDecodeValue(forKey: .expiresOn)
        self.expiredOn = container.safeDecodeValue(forKey: .expiredOn)
        self.pleaseSelectOption = container.safeDecodeValue(forKey: .pleaseSelectOption)
        self.choostYourWash = container.safeDecodeValue(forKey: .choostYourWash)
        self.showAll = container.safeDecodeValue(forKey: .showAll)
        self.hide = container.safeDecodeValue(forKey: .hide)
        self.bookAWashAtPosition = container.safeDecodeValue(forKey: .bookAWashAtPosition)
    }
    
    init() {
        self.promoCodes = ""
        self.scheduleBooking = ""
        self.scheduleDisplayDate = ""
        self.appName  = ""
        self.requesting  = ""
        self.searchLocation  = ""
        self.selectPaymentMode  = ""
        self.fareEstimation  = ""
        self.of  = ""
        self.areYouSure  = ""
        self.pending  = ""
        self.completed  = ""
        self.or  = ""
        self.getMovingWith  = ""
        self.tryAgain  = ""
        self.getMove  = ""
        self.signIn  = ""
        self.register  = ""
        self.connectSocialAcc  = ""
        self.password  = ""
        self.forgotPassword  = ""
        self.enterPassword  = ""
        self.credentialdonTRight  = ""
        self.login  = ""
        self.mobileVerify  = ""
        self.enterMobileno  = ""
        self.enterOtp  = ""
        self.sentCodeMob  = ""
        self.didntRecOtp  = ""
        self.resendOtp  = ""
        self.otpSendAgain  = ""
        self.termsCondition  = ""
        self.addHome  = ""
        self.addWork  = ""
        self.favorites  = ""
        self.currency  = ""
        self.home  = ""
        self.work  = ""
        self.message  = ""
        self.ok  = ""
        self.signOut  = ""
        self.settings  = ""
        self.regInformation  = ""
        self.agreeTcPolicy  = ""
        self.privacyPolicy  = ""
        self.confirmInfo  = ""
        self.firstName  = ""
        self.lastName  = ""
        self.mobileNo  = ""
        self.refCode  = ""
        self.cancelAccCreation  = ""
        self.infoNotSaved  = ""
        self.confirm  = ""
        self.cancel  = ""
        self.enPushNotifyLogin  = ""
        self.chooseAcc  = ""
        self.faceBook  = ""
        self.google  = ""
        self.resetPassword  = ""
        self.close  = ""
        self.confirmPassword  = ""
        self.continueSendAlert  = ""
        self.common1Continue  = ""
        self.sendingAlert  = ""
        self.alertSent  = ""
        self.useEmergency  = ""
        self.alertEmergencyContact  = ""
        self.locationCollectData  = ""
        self.locationEnsure  = ""
        self.likeToResetPass  = ""
        self.email  = ""
        self.mobile  = ""
        self.contacting  = ""
        self.nearYou  = ""
        self.promoApplied  = ""
        self.cash  = ""
        self.apple_pay = ""
        self.paypal  = ""
        self.card  = ""
        self.onlinePay  = ""
        self.request  = ""
        self.change  = ""
        self.setUrPickUp  = ""
        self.setPicktUpTime  = ""
        self.normalFare  = ""
        self.minFare  = ""
        self.minLeft  = ""
        self.minKM  = ""
        self.acceptHigherFare  = ""
        self.tryLater  = ""
        self.fare  = ""
        self.capacity  = ""
        self.done  = ""
        self.fareBreakDown  = ""
        self.baseFare  = ""
        self.perMin  = ""
        self.perKM  = ""
        self.currentLocation  = ""
        self.noLocationFound  = ""
        self.whereTo  = ""
        self.setPin  = ""
        self.enterUrLocation  = ""
        self.enterHome  = ""
        self.enterWork  = ""
        self.travelSafer  = ""
        self.alertUrDears  = ""
        self.youCanAddC  = ""
        self.removeContact  = ""
        self.addContacts  = ""
        self.emergencyContacts  = ""
        self.delete  = ""
        self.contactAlreadyAdded  = ""
        self.makeTravelSafe  = ""
        self.alertYourDear  = ""
        self.add5_Contacts  = ""
        self.removeContactAddone  = ""
        self.off  = ""
        self.from  = ""
        self.promotions  = ""
        self.paymentMethod  = ""
        self.useWallet  = ""
        self.wallet  = ""
        self.addPromoGiftCode  = ""
        self.enterPromoCode  = ""
        self.addCreditDebit  = ""
        self.changeCreditDebit  = ""
        self.rUSureToLogOut  = ""
        self.payment  = ""
        self.pay  = ""
        self.waitDriverConfirm  = ""
        self.quantity  = ""
        self.proceed  = ""
        self.continueRequest  = ""
        self.success  = ""
        self.paymentPaidSuccess  = ""
        self.cancelled  = ""
        self.failed  = ""
        self.paymentDetails  = ""
        self.totalFare  = ""
        self.addPayment  = ""
        self.addMoneytoWallet  = ""
        self.addAmount  = ""
        self.enterAmount  = ""
        self.walletAmountIs  = ""
        self.amountFldReq  = ""
        self.driver  = ""
        self.typeMessage  = ""
        self.noMsgYet  = ""
        self.getUpto  = ""
        self.everyFriendRides  = ""
        self.signUpandGetPaid  = ""
        self.referral  = ""
        self.yourReferralCode  = ""
        self.shareMyCode  = ""
        self.refCopytoClip  = ""
        self.referralCodeCopied  = ""
        self.useMyReferral  = ""
        self.startJourneyonGofer  = ""
        self.noRefYet  = ""
        self.friendsInComplete  = ""
        self.friendsCompleted  = ""
        self.earned  = ""
        self.refExpired  = ""
        self.rateYourRide  = ""
        self.writeYourComment  = ""
        self.schedule  = ""
        self.tip  = ""
        self.submit  = ""
        self.common4Set  = ""
        self.add  = ""
        self.enterTipAmount  = ""
        self.past  = ""
        self.upComming  = ""
        self.pullToRefresh  = ""
        self.id  = ""
        self.cancelReason  = ""
        self.contacts  = ""
        self.call  = ""
        self.contact  = ""
        self.enRoute  = ""
        self.mins  = ""
        self.restaurantDelights  = ""
        self.toWangs  = ""
        self.addHomeLOC  = ""
        self.addWorkLOC  = ""
        self.uploadFailed  = ""
        self.enterValidEmailID  = ""
        self.enterFirstName  = ""
        self.enterlastName  = ""
        self.enterEmailID  = ""
        self.passwordMismatch  = ""
        self.newVersAvail  = ""
        self.updateOurApp  = ""
        self.visitAppStore  = ""
        self.totryAgain  = ""
        self.sorryNoRides  = ""
        self.contactAdmin  = ""
        self.save  = ""
        self.selectPhoto  = ""
        self.takePhoto  = ""
        self.chooseLIB  = ""
        self.help  = ""
        self.selectCntry  = ""
        self.minutesToArrive  = ""
        self.noContactFound  = ""
        self.dial  = ""
        self.no  = ""
        self.yes  = ""
        self.addTip  = ""
        self.setTip  = ""
        self.toDriver  = ""
        self.pleaseEnterValidAmount  = ""
        self.pleaseGiveRating  = ""
        self.manualBooking  = ""
        self.dayLeft  = ""
        self.skip  = ""
        self.answer  = ""
        self.incomingCall  = ""
        self.completedStatus  = ""
        self.cancelledStatus  = ""
        self.reqStatus  = ""
        self.pendingStatus  = ""
        self.sheduledStatus  = ""
        self.paymentStatus  = ""
        self.editTime  = ""
        self.cancelRide  = ""
        self.selectCountry  = ""
        self.search  = ""
        self.clientNotInitialized  = ""
        self.jsonSerialaizationFailed  = ""
        self.noInternetConnection  = ""
        self.toReach  = ""
        self.toArrive  = ""
        self.signInWith  = ""
        self.userCancelledAuthentication  = ""
        self.authenticationCancelled  = ""
        self.connecting  = ""
        self.ringing  = ""
        self.callEnded  = ""
        self.placehodlerMail  = ""
        self.enterValidOtp  = ""
        self.locationService  = ""
        self.tracking  = ""
        self.camera  = ""
        self.photoLibrary  = ""
        self.service  = ""
        self.services  = ""
        self.app  = ""
        self.pleaseEnable  = ""
        self.requires  = ""
        self.common6For  = ""
        self.functionality  = ""
        self.requestStatus  = ""
        self.ratingStatus  = ""
        self.scheduledStatus  = ""
        self.microphoneSerivce  = ""
        self.inAppCall  = ""
        self.choose  = ""
        self.choosePaymentMethod  = ""
        self.min  = ""
        self.hr  = ""
        self.hrs  = ""
        self.language  = ""
        self.selectLanguage  = ""
        self.editAccount  = ""
        self.enterValidData  = ""
        self.confirmContact  = ""
        self.rejected  = ""
        self.busyTryAgain  = ""
        self.pleaseEnablePushNotification  = ""
        self.address  = ""
        self.error  = ""
        self.deviceHasNoCamera  = ""
        self.warning  = ""
        self.phoneNumber  = ""
        self.addressLineFirst  = ""
        self.addressLineSecond  = ""
        self.city  = ""
        self.postalCode  = ""
        self.state  = ""
        self.manageServices  = ""
        self.manageHome  = ""
        self.loginText  = ""
        self.addItem  = ""
        self.welcomeLoginText  = ""
        self.yourJob  = ""
        self.tapToChange  = ""
        self.dontHaveAcc  = ""
        self.alreadyHaveAcc  = ""
        self.tocText  = ""
        self.logout  = ""
        self.pleaseGivePermission  = ""
        self.termsConditions  = ""
        self.smsMobileVerify  = ""
        self.didntReceiveOtp  = ""
        self.otpAgain  = ""
        self.credentialsDontLook  = ""
        self.enterYourFirstName  = ""
        self.enterYourLastName  = ""
        self.enterYourPhoneNumber  = ""
        self.enterYourEmail  = ""
        self.enterYourPassword  = ""
        self.country  = ""
        self.myProfile  = ""
        self.editProfile  = ""
        self.updateInfo  = ""
        self.changePassword  = ""
        self.added  = ""
        self.next  = ""
        self.enterLocation  = ""
        self.youAreIn  = ""
        self.serviceAtMe  = ""
        self.setOnMap  = ""
        self.pleaseSetLocation  = ""
        self.yourBooking  = ""
        self.onGoingJobs  = ""
        self.successFullyUpdated  = ""
        self.enterYourOldPassword  = ""
        self.enterYourNewPassword  = ""
        self.enterYourConformPassword  = ""
        self.pleaseAddThemToYourEmergencyContact  = ""
        self.sorting  = ""
        self.lessThanAkm  = ""
        self.estimatedCharge  = ""
        self.minimumHour  = ""
        self.paymentOption  = ""
        self.selectBookingLocation  = ""
        self.providerArrived  = ""
        self.calendar  = ""
        self.bookingDetails  = ""
        self.checkOut  = ""
        self.remove  = ""
        self.estimatedFee  = ""
        self.cart  = ""
        self.paymentSummary  = ""
        self.jobRequestDate  = ""
        self.discountApplied  = ""
        self.providerFeedback  = ""
        self.howWasTheJobDone  = ""
        self.moreInfo  = ""
        self.setLocationOnMap  = ""
        self.noServiceFound  = ""
        self.review  = ""
        self.gallery  = ""
        self.viewMore  = ""
        self.viewLess  = ""
        self.hereYouCanChangeYourMap  = ""
        self.byClicking  = ""
        self.googleMap  = ""
        self.wazeMap  = ""
        self.doYouWant  = ""
        self.pleaseInstallGoogleMapsApp  = ""
        self.doYouWantToAccessdirection  = ""
        self.pleaseInstallWazeMapsApp  = ""
        self.jobLocation  = ""
        self.destinationLocation  = ""
        self.thanksForProvidingThisService  = ""
        self.beforeService  = ""
        self.afterService  = ""
        self.fareDetails  = ""
        self.paymentCompletedFor  = ""
        self.number  = ""
        self.agreeTermsAndPrivacyPolicyContent  = ""
        self.maxChar  = ""
        self.manuallyBookedAlert  = ""
        self.manuallyBookedReminderAlert  = ""
        self.manualBookiingCancelledAlert  = ""
        self.manualBookingInfoAlert  = ""
        self.scheduledAlert  = ""
        self.requestAlert  = ""
        self.beginJobAlert  = ""
        self.endJobAlert  = ""
        self.pendingAlert  = ""
        self.cancelledAlert  = ""
        self.completedAlert  = ""
        self.ratingAlert  = ""
        self.paymentAlert  = ""
        self.editItem  = ""
        self.noDataFound  = ""
        self.passwordValidationMsg  = ""
        self.specialInstruction  = ""
        self.provideFeedback  = ""
        self.sendAlert  = ""
        self.addThem  = ""
        self.sec  = ""
        self.paymentType  = ""
        self.yourInviteCode  = ""
        self.forEveryFriendJobs  = ""
        self.internalServerError  = ""
        self.areYouSureYouWantToExit  = ""
        self.provideYourFeedback  = ""
        self.balance  = ""
        self.status  = ""
        self.areYouSureYouWantToCancel  = ""
        self.note  = ""
        self.aToZ  = ""
        self.km  = ""
        self.enterValidCardDetails  = ""
        self.arriveNow  = ""
        self.paymentCompletedSuccess  = ""
        self.category  = ""
        self.subCategory  = ""
        self.fareType  = ""
        self.welcomeToThe  = ""
        self.goferHandyUserApp  = ""
        self.support  = ""
        self.notAValidData  = ""
        self.beginJob  = ""
        self.endJob  = ""
        self.fromHere  = ""
        self.locationPermissionDescription  = ""
        self.toAccessLocation  = ""
        self.gettingLocation  = ""
        self.iAgreeToThe  = ""
        self.and  = ""
        self.daysLeft  = ""
        self.jobs  = ""
        self.selectCurrency  = ""
        self.allowCamera = ""
        self.toAccessCamera = ""
        self.onlinePayment = ""
        self.forceUpdate = ""
        self.update = ""
        self.covidTitle = "Avail Services Only If You Are Asymptomatic."
        self.covidSubtitle = "Book The Services By Following The Safety Regulations To Keep You and Your Service Provider Safe!!"
        self.covidPointOne = "Always wear a mask and maintain social distance."
        self.covidPointTwo = "Regularly Wear Face Cover and Sanitise your Hands Before And After the Services."
        self.covidPointThree =  "Don’t book for the services if you have Covid-19 or related symptoms."
        self.covidFooter = "Be Safe and Stay Healthy!!!"
        self.covidRating = "Ensure That the Services is completed safely and followed the safety protocols."
        self.appleLogin = ""
        self.loginToContinue = ""
        self.welcomeBack = ""
        self.haveAnAccount = "Have an account ?"
        self.continueWithPhone = "Continue With Phone Number"
        self.walletMoneyApplied = "Wallet Money Applied"
        self.name = ""
        self.ourService = ""
        self.addPromoCode = ""
        self.removePromoCode = ""
        self.changePromoCode = ""
        self.amount = ""
        self.font = ""
        self.theme = ""
        self.history = ""
        self.changeTheme = ""
        self.changeFont = ""
        self.pleaseEnterYourOldPassword = ""
        self.pleaseEnterYourNewPassword = ""
        self.pleaseEnterYourConfirmPassword = ""
        self.setLocation = ""
        self.backToHome = "Back to Home"
        self.view = "view".capitalized
        self.edit = "edit".capitalized
        self.favourites = ""
        self.hello = ""
        self.expired = ""
        self.backTo = ""
        self.today = ""
        self.tommorow = ""
        self.requestedService = ""
        self.sendMessage = ""
        self.duration = ""
        self.distance = ""
        self.vehicleType = ""
        self.promo = ""
        self.discardProfile = ""
        self.discardcontent = ""
        self.applied_promo = ""
        self.endTripStatus = ""
        self.beginTripStatus = ""
        self.apply = ""
        self.invalidCode = ""
        self.expiresOn = ""
        self.expiredOn = ""
        self.pleaseSelectOption = ""
        self.choostYourWash = ""
        self.showAll = ""
        self.hide = ""
        self.bookAWashAtPosition = ""
    }
}


// MARK: - Handy
class Handy: Codable {
    let rateYourJob , locationSmooth , orderFailed , yourOrderfailed : String
    let orderCancelled , yourOrderCancelled , job , yourJobs : String
    let jobDetails , user , kilometerAway , sortDistance : String
    let sortName , searchServices , book , bookNow : String
    let bookLater , categoryName , name , noProviderFound : String
    let itemsInYourCartWillBeDiscarded , youCanOnlyOneItemForThisServiceType , removeItem , noReviewsYet : String
    let bookingDate : String
    let theProviderHasNoImages , removeFromCart , editCart , addCart : String
    let addSpecialInfoBelow , serviceCharge , serviceChargePerHour , atUserLocation : String
    let setLocation : String
    let atProviderLocation , map , list , aToZ : String
    let iWantServiceAtMyCurrentLocation , jobID , liveTrack , jobProgress : String
    let navigate , requestedService , cancelBooking , liveTracking : String
    let noUpCommingJobs , noJobs , cancelJob , cancelYourJob : String
    let howWasYourJob , bookingRequested , viewOnGoingJob , freeJobUpto : String
    let priceType ,ensureSaferJob ,makeJobSafe : String
    let fareWillVaryBasedOnDistance,fareWillVaryBasedOnHours,priceMayVaryBasedOnHours : String
    let walletBalance : String
    let serviceNo : String
    let reviews : String
    let getServiceNow : String
    
    enum CodingKeys : String,CodingKey {
        case rateYourJob = "rate_your_job", locationSmooth = "location_smooth", orderFailed = "order_failed", yourOrderfailed = "your_orderfailed", orderCancelled = "order_cancelled", yourOrderCancelled = "your_order_cancelled", job, yourJobs = "your_jobs", jobDetails = "job_details", user, kilometerAway = "kilometer_away", sortDistance = "sort_distance", sortName = "sort_name", searchServices = "search_services", book, bookNow = "book_now", bookLater = "book_later", categoryName = "category_name", name, noProviderFound = "no_provider_found", itemsInYourCartWillBeDiscarded = "items_in_your_cart_will_be_discarded", youCanOnlyOneItemForThisServiceType = "you_can_only_one_item_for_this_service_type", removeItem = "remove_item", noReviewsYet = "no_reviews_yet", theProviderHasNoImages = "the_provider_has_no_images", removeFromCart = "remove_from_cart", editCart = "edit_cart", addCart = "add_cart", addSpecialInfoBelow = "add_special_info_below", serviceCharge = "service_charge", serviceChargePerHour = "service_charge_per_hour", atUserLocation = "at_user_location", atProviderLocation = "at_provider_location", map, list, aToZ = "a_to_z", iWantServiceAtMyCurrentLocation = "i_want_service_at_my_current_location", jobID = "job_id", liveTrack = "live_track", jobProgress = "job_progress", navigate, requestedService = "requested_service", cancelBooking = "cancel_booking", liveTracking = "live_tracking", noUpCommingJobs = "no_up_comming_jobs", noJobs = "no_jobs", cancelJob = "cancel_job", cancelYourJob = "cancel_your_job", howWasYourJob = "how_was_your_job", bookingRequested = "booking_requested", viewOnGoingJob = "view_on_going_job", freeJobUpto = "free_job_upto", priceType = "price_type", ensureSaferJob = "lets_ensure_safer_jobs", makeJobSafe = "make_your_job_experience_safe"
        case fareWillVaryBasedOnDistance = "fare_will_vary_based_on_distance",fareWillVaryBasedOnHours = "fare_will_vary_based_on_hours",priceMayVaryBasedOnHours = "price_may_vary_based_on_hours"
        case walletBalance = "wallet_balance"
        case serviceNo = "service_no"
        case setLocation = "set_location"
        case reviews = "reviews"
        case bookingDate = "booking_date"
        case getServiceNow = "get_service_now"
    }
    
    init() {
        self.setLocation = "Set Location"
        self.rateYourJob = ""
        self.locationSmooth = ""
        self.orderFailed = ""
        self.yourOrderfailed = ""
        self.orderCancelled = ""
        self.yourOrderCancelled = ""
        self.job = ""
        self.yourJobs = ""
        self.jobDetails = ""
        self.user = ""
        self.kilometerAway = ""
        self.sortDistance = ""
        self.sortName = ""
        self.searchServices = ""
        self.book = ""
        self.bookNow = ""
        self.bookLater = ""
        self.categoryName = ""
        self.name = ""
        self.noProviderFound = ""
        self.itemsInYourCartWillBeDiscarded = ""
        self.youCanOnlyOneItemForThisServiceType = ""
        self.removeItem = ""
        self.noReviewsYet = ""
        self.theProviderHasNoImages = ""
        self.removeFromCart = ""
        self.editCart = ""
        self.addCart = ""
        self.addSpecialInfoBelow = ""
        self.serviceCharge = ""
        self.serviceChargePerHour = ""
        self.atUserLocation = ""
        self.atProviderLocation = ""
        self.map = ""
        self.list = ""
        self.aToZ = ""
        self.iWantServiceAtMyCurrentLocation = ""
        self.jobID = ""
        self.liveTrack = ""
        self.jobProgress = ""
        self.navigate = ""
        self.requestedService = ""
        self.cancelBooking = ""
        self.liveTracking = ""
        self.noUpCommingJobs = ""
        self.noJobs = ""
        self.cancelJob = ""
        self.cancelYourJob = ""
        self.howWasYourJob = ""
        self.bookingRequested = ""
        self.viewOnGoingJob = ""
        self.freeJobUpto = ""
        self.priceType = ""
        self.ensureSaferJob = ""
        self.makeJobSafe = ""
        self.fareWillVaryBasedOnDistance = ""
        self.fareWillVaryBasedOnHours = ""
        self.priceMayVaryBasedOnHours = ""
        self.walletBalance = ""
        self.serviceNo = ""
        self.reviews = "Reviews"
        self.bookingDate = "Booking Date"
        self.getServiceNow = ""
    }
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rateYourJob = container.safeDecodeValue(forKey: .rateYourJob)
        self.locationSmooth = container.safeDecodeValue(forKey: .locationSmooth)
        self.orderFailed = container.safeDecodeValue(forKey: .orderFailed)
        self.yourOrderfailed = container.safeDecodeValue(forKey: .yourOrderfailed)
        self.orderCancelled = container.safeDecodeValue(forKey: .orderCancelled)
        self.yourOrderCancelled = container.safeDecodeValue(forKey: .yourOrderCancelled)
        self.setLocation = container.safeDecodeValue(forKey: .setLocation)
        self.job = container.safeDecodeValue(forKey: .job)
        self.yourJobs = container.safeDecodeValue(forKey: .yourJobs)
        self.jobDetails = container.safeDecodeValue(forKey: .jobDetails)
        self.user = container.safeDecodeValue(forKey: .user)
        self.kilometerAway = container.safeDecodeValue(forKey: .kilometerAway)
        self.sortDistance = container.safeDecodeValue(forKey: .sortDistance)
        self.sortName = container.safeDecodeValue(forKey: .sortName)
        self.searchServices = container.safeDecodeValue(forKey: .searchServices)
        self.book = container.safeDecodeValue(forKey: .book)
        self.bookNow = container.safeDecodeValue(forKey: .bookNow)
        self.bookLater = container.safeDecodeValue(forKey: .bookLater)
        self.categoryName = container.safeDecodeValue(forKey: .categoryName)
        self.name = container.safeDecodeValue(forKey: .name)
        self.noProviderFound = container.safeDecodeValue(forKey: .noProviderFound)
        self.itemsInYourCartWillBeDiscarded = container.safeDecodeValue(forKey: .itemsInYourCartWillBeDiscarded)
        self.youCanOnlyOneItemForThisServiceType = container.safeDecodeValue(forKey: .youCanOnlyOneItemForThisServiceType)
        self.removeItem = container.safeDecodeValue(forKey: .removeItem)
        self.noReviewsYet = container.safeDecodeValue(forKey: .noReviewsYet)
        self.theProviderHasNoImages = container.safeDecodeValue(forKey: .theProviderHasNoImages)
        self.removeFromCart = container.safeDecodeValue(forKey: .removeFromCart)
        self.editCart = container.safeDecodeValue(forKey: .editCart)
        self.addCart = container.safeDecodeValue(forKey: .addCart)
        self.addSpecialInfoBelow = container.safeDecodeValue(forKey: .addSpecialInfoBelow)
        self.serviceCharge = container.safeDecodeValue(forKey: .serviceCharge)
        self.serviceChargePerHour = container.safeDecodeValue(forKey: .serviceChargePerHour)
        self.atUserLocation = container.safeDecodeValue(forKey: .atUserLocation)
        self.atProviderLocation = container.safeDecodeValue(forKey: .atProviderLocation)
        self.map = container.safeDecodeValue(forKey: .map)
        self.list = container.safeDecodeValue(forKey: .list)
        self.aToZ = container.safeDecodeValue(forKey: .aToZ)
        self.iWantServiceAtMyCurrentLocation = container.safeDecodeValue(forKey: .iWantServiceAtMyCurrentLocation)
        self.jobID = container.safeDecodeValue(forKey: .jobID)
        self.liveTrack = container.safeDecodeValue(forKey: .liveTrack)
        self.jobProgress = container.safeDecodeValue(forKey: .jobProgress)
        self.navigate = container.safeDecodeValue(forKey: .navigate)
        self.requestedService = container.safeDecodeValue(forKey: .requestedService)
        self.cancelBooking = container.safeDecodeValue(forKey: .cancelBooking)
        self.liveTracking = container.safeDecodeValue(forKey: .liveTracking)
        self.noUpCommingJobs = container.safeDecodeValue(forKey: .noUpCommingJobs)
        self.noJobs = container.safeDecodeValue(forKey: .noJobs)
        self.cancelJob = container.safeDecodeValue(forKey: .cancelJob)
        self.cancelYourJob = container.safeDecodeValue(forKey: .cancelYourJob)
        self.howWasYourJob = container.safeDecodeValue(forKey: .howWasYourJob)
        self.bookingRequested = container.safeDecodeValue(forKey: .bookingRequested)
        self.viewOnGoingJob = container.safeDecodeValue(forKey: .viewOnGoingJob)
        self.freeJobUpto = container.safeDecodeValue(forKey: .freeJobUpto)
        self.priceType = container.safeDecodeValue(forKey: .priceType)
        self.ensureSaferJob = container.safeDecodeValue(forKey: .ensureSaferJob)
        self.makeJobSafe = container.safeDecodeValue(forKey: .makeJobSafe)
        self.fareWillVaryBasedOnDistance = container.safeDecodeValue(forKey: .fareWillVaryBasedOnDistance)
        self.fareWillVaryBasedOnHours = container.safeDecodeValue(forKey: .fareWillVaryBasedOnHours)
        self.priceMayVaryBasedOnHours = container.safeDecodeValue(forKey: .priceMayVaryBasedOnHours)
        self.walletBalance = container.safeDecodeValue(forKey: .walletBalance)
        self.serviceNo = container.safeDecodeValue(forKey: .serviceNo)
        self.reviews = container.safeDecodeValue(forKey: .reviews)
        self.bookingDate = container.safeDecodeValue(forKey: .bookingDate)
        self.getServiceNow = container.safeDecodeValue(forKey: .getServiceNow)
    }
}

// MARK: - Language
class Language: Codable {
    let key ,lang : String
    let isRTL: Bool
    
    enum CodingKeys : String,CodingKey {
        case key, lang = "Lang", isRTL = "is_rtl"
    }
    
    init() {
        self.key = "en"
        self.lang = "English"
        self.isRTL = false
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = container.safeDecodeValue(forKey: .key)
        self.lang = container.safeDecodeValue(forKey: .lang)
        self.isRTL = container.safeDecodeValue(forKey: .isRTL)
    }
    //MARK:-UDF
    func saveLanguage(){
      
        UserDefaults.set(self.key,for: .default_language_option)
        UserDefaults.standard.set(self.key, forKey:  "lang")
        UserDefaults.standard.set([self.key], forKey: "AppleLanguages")
        Bundle.setLanguage(self.key)
    }
}
// MARK: - Equatable
extension Language : Equatable{
    static func == (lhs: Language,rhs: Language) -> Bool {
        return lhs.key == rhs.key
    }
    
    
}


/*
 MARK: IF API Fails To Load Please Check the Keys
 {
   "status_code": "1",
   "status_message": "success",
   "default_language": "en",
   "language": [
     {
       "key": "en",
       "Lang": "English",
       "is_rtl": 0
     },
     {
       "key": "fa",
       "Lang": "Persian",
       "is_rtl": 0
     },
     {
       "key": "ar",
       "Lang": "Arabic",
       "is_rtl": 1
     },
     {
       "key": "es",
       "Lang": "Spanish",
       "is_rtl": 0
     },
     {
       "key": "pt",
       "Lang": "Português",
       "is_rtl": 0
     }
   ],
   "common": {
     "requesting": "Requesting",
     "search_location": "Search Location",
     "select_payment_mode": "Select Payment Mode",
     "fare_estimation": "Fare Estimation",
     "of": "OF",
     "are_you_sure": "Are You Sure",
     "pending": "Pending",
     "completed": "Completed",
     "or": "or",
     "get_moving_with": "Get moving with",
     "try_again": "Please try again",
     "get_move": "Get moving with",
     "sign_in": "SIGN IN",
     "register": "REGISTER",
     "connect_social_acc": "Connect using a social account",
     "password": "PASSWORD",
     "forgot_password": "Forgot Password?",
     "enter_password": "Please enter your password",
     "credentialdon_t_right": "Those credentials don't look right. Please try again",
     "login": "LOG IN",
     "mobile_verify": "Mobile Verification",
     "enter_mobileno": "Please enter your mobile number",
     "enter_otp": "Enter OTP",
     "sent_code_mobile": "We have sent you access code via SMS for mobile number verification",
     "didnt_rec_otp": "Didn't Receive the OTP?",
     "resend_otp": "Resend OTP",
     "otp_send_again": "You can send OTP again in",
     "terms_condition": "Terms and condition",
     "add_home": "Add Home",
     "add_work": "Add Work",
     "favorites": "Favorites",
     "currency": "Currency",
     "home": "Home",
     "work": "Work",
     "message": "Message",
     "ok": "Ok",
     "sign_out": "Sign Out",
     "settings": "Settings",
     "reg_information": "Register your information",
     "agree_tc_policy": "By continuing, I conform that i have read and agree to the Terms &amp; Conditions and Privacy Policy",
     "privacy_policy": "Privacy Policy",
     "confirm_info": "Confirm your information",
     "first_name": "First Name",
     "last_name": "Last Name",
     "mobile_no": "Mobile Number",
     "ref_code": "Referral Code (Optional)",
     "cancel_acc_creation": "Cancel account creation?",
     "info_not_saved": "Your information will not be saved.",
     "confirm": "CONFIRM",
     "cancel": "CANCEL",
     "en_push_notify_login": "Please enable Push Notification in settings for continue to login",
     "choose_acc": "Choose an account",
     "face_book": "Facebook",
     "google": "Google",
     "reset_password": "RESET PASSWORD",
     "close": "CLOSE",
     "confirm_password": "CONFIRM PASSWORD",
     "continue_send_alert": "Continue to send alert?",
     "continue": "Continue",
     "sending_alert": "Sending Alert",
     "alert_sent": "Alert Sent",
     "use_emergency": "USE IN CASE OF EMERGENCY",
     "alert_emergency_contact": "Alert your Emergency contacts",
     "location_collect_data": "collects location data during an active ride from your device including when the app is in the background. ",
     "location_ensure": "This data is used to ensure that",
     "like_to_reset_pass": "How would you like to reset your password?",
     "email": "EMAIL",
     "mobile": "MOBILE",
     "contacting": "Contacting",
     "near_you": "near you...",
     "promo_applied": "Promo Applied",
     "cash": "CASH",
     "apple_pay":"Apple Pay",
     "paypal": "PAYPAL",
     "card": "CARD",
     "online_pay": "Braintree",
     "request": "Request",
     "change": "CHANGE",
     "set_ur_pick_up": "Set Your Pickup Time",
     "set_pickt_up_time": "SET PICKUP TIME",
     "normal_fare": "THE NORMAL FARE",
     "min_fare": "MINIMUM FARE",
     "min_left": "/ MIN",
     "min_km": "/ KM",
     "accept_higher_fare": "I ACCEPT HIGHER FARE",
     "try_later": "I WILL TRY LATER",
     "fare": "Fare",
     "capacity": "Capacity",
     "done": "Done",
     "fare_break_down": "Fare Breakdown",
     "base_fare": " Base Fare",
     "per_min": "Per Min",
     "per_km": "Per Km",
     "current_location": "Current Location",
     "no_location_found": "No location found",
     "where_to": "Where to?",
     "set_pin": "Set pin location",
     "enter_ur_location": "Enter Your Location",
     "enter_home": "Enter home address",
     "enter_work": "Enter work address",
     "travel_safer": "Let's make travel safer",
     "alert_ur_dears": "Alert your dear ones in case of an emergency. Add them to your emergency contact",
     "you_can_add_c": "You can add upto 5 contacts",
     "remove_contact": "Remove any contact to add another",
     "add_contacts": "ADD CONTACTS",
     "emergency_contacts": "Emergency Contacts",
     "delete": "Delete",
     "contact_already_added": "Contact was already added",
     "make_travel_safe": "Let's make travel safer",
     "alert_your_dear": "Alert your dear ones in case of an emergency. Add them to your emergency contact",
     "add_5_contacts": "You can add upto 5 contacts",
     "remove_contact_addone": "Remove any contact to add another",
     "off": "OFF",
     "from": "from",
     "promotions": "Promotions",
     "payment_method": "Payment Methods",
     "use_wallet": "USE WALLET",
     "wallet": "Wallet",
     "add_promo_gift_code": "Add Promo/Gift code",
     "enter_promo_code": "Please enter the promo code",
     "add_credit_debit": "Add Credit or Debit Card",
     "change_credit_debit": "Change Credit or Debit Card",
     "r_u_sure_to_log_out": "Are You Sure You Want to Logout?",
     "payment": "Payment",
     "pay": "PAY",
     "wait_driver_confirm": "WAITING FOR PROVIDER CONFIRMATION",
     "quantity": "Quantity",
     "proceed": "PROCEED",
     "continue_request": "CONTINUE TO REQUEST",
     "success": "Success!!!",
     "payment_paid_success": "Payment Paid Successfully",
     "cancelled": "cancelled",
     "failed": "failed",
     "payment_details": "Payment Details",
     "total_fare": "Total Fare",
     "add_payment": "Add Payment",
     "add_moneyto_wallet": "ADD MONEY TO THE WALLET",
     "add_amount": "ADD AMOUNT",
     "enter_amount": "Enter the amount",
     "wallet_amount_is": "Your Wallet amount is",
     "amount_fld_req": "The amount field is required",
     "driver": "Provider",
     "type_message": "Type a message...",
     "no_msg_yet": "No messages, yet.",
     "get_upto": "Get upto",
     "every_friend_rides": "for every friend who rides with",
     "sign_upand_get_paid": "SignUp &amp; Get Paid For Every Referral Sign-up &amp; Much More Bonus Awaits!",
     "referral": "Referral",
     "your_referral_code": "YOUR REFERRAL CODE",
     "share_my_code": "SHARE MY CODE",
     "ref_copyto_clip": "Referral Copied to Clip Board !",
     "referral_code_copied": "Referral Code Copied",
     "use_my_referral": "Use my Referral",
     "start_journeyon_gofer": "Start Your Journey on Gofer from here",
     "no_ref_yet": "No Referrals Yet",
     "friends_in_complete": "FRIENDS - INCOMPLETE",
     "friends_completed": "FRIENDS - COMPLETED",
     "earned": "Earned :",
     "ref_expired": "Referral Expired",
     "rate_your_ride": "Rate your ride",
     "write_your_comment": "Write your comment...",
     "schedule": "Schedule",
     "tip": "Tip",
     "submit": "Submit",
     "set": "Set ",
     "add": "Add",
     "enter_tip_amount": "Enter tip amount",
     "past": "Past",
     "up_comming": "Upcoming",
     "pull_to_refresh": "Pull To Refresh",
     "id": "ID",
     "cancel_reason": "Cancel reason",
     "contacts": "Contacts",
     "call": "CALL",
     "contact": "Contact",
     "en_route": "En Route",
     "mins": "mins",
     "restaurant_delights": "Restaurant delights",
     "to_wangs": "it to Wangs",
     "add_home_loc": "Add Home Location",
     "add_work_loc": "Add Work Location",
     "upload_failed": "Upload failed. Please try again",
     "enter_valid_email_id": "Please enter valid email id",
     "enter_first_name": "Please enter your first name",
     "enterlast_name": "Please enter your last name",
     "enter_email_id": "Please enter email id",
     "password_mismatch": "Password Mismatch",
     "new_vers_avail": "New Version Available",
     "update_our_app": "Please update our app to enjoy the latest features!",
     "visit_app_store": "Visit App store",
     "totry_again": "to try again.",
     "sorry_no_rides": "Sorry, no rides available now",
     "contact_admin": "Contact admin for manual booking",
     "save": "Save",
     "select_photo": "Select a photo",
     "take_photo": "TAKE PHOTO",
     "choose_lib": "CHOOSE FROM LIBRARY",
     "help": "Help",
     "select_cntry": "Select a Country",
     "minutes_to_arrive": "Minutes to arrive",
     "no_contact_found": "No Contact Found",
     "dial": "dial",
     "no": "No",
     "yes": "Yes",
     "add_tip": "Add Tip",
     "set_tip": "Set Tip",
     "to_driver": "to Provider",
     "please_enter_valid_amount": "Please enter valid amount",
     "please_give_rating": "Please give rating",
     "manual_booking": "Manual Booking",
     "day_left": "day left | Need to Complete",
     "skip": "Skip",
     "answer": "Answer",
     "incoming_call": "Incoming call from",
     "completed_status": "Completed",
     "cancelled_status": "Cancelled",
     "req_status": "Request",
     "pending_status": "Pending",
     "sheduled_status": "Scheduled",
     "payment_status": "Payment",
     "edit_time": "EDIT TIME",
     "cancel_ride": "CANCEL RIDE",
     "select_country": "Select a Country",
     "search": "Search",
     "client_not_initialized": "Client not initialized",
     "json_serialaization_failed": "JSON serialization failed",
     "no_internet_connection": "No internet connection.",
     "to_reach": "to Reach",
     "to_arrive": "to arrive",
     "sign_in_with": "Sign in with",
     "user_cancelled_authentication": "User cancelled authentication",
     "authentication_cancelled": "Authentication cancelled",
     "connecting": "Connecting",
     "ringing": "Ringing",
     "call_ended": "Call Ended",
     "placehodler_mail": "name@example.com",
     "enter_valid_otp": "Enter valid OTP",
     "location_service": "Location Service",
     "tracking": "Tracking",
     "camera": "Camera",
     "photo_library": "Photo Library",
     "service": "Service",
     "services": "Services",
     "app": "App",
     "please_enable": "Please enable",
     "requires": "requires",
     "for": "for",
     "functionality": "functionality",
     "request_status": "Request",
     "rating_status": "Rating",
     "scheduled_status": "Scheduled",
     "microphone_serivce": "Microphone service",
     "in_app_call": "in App call",
     "choose": "Choose",
     "choose_payment_method": "Choose Payment Method",
     "min": "min",
     "hr": "hr",
     "hrs": "hrs",
     "language": "Language",
     "select_language": "Select Language",
     "edit_account": "Edit Account",
     "enter_valid_data": "Please enter valid data",
     "confirm_contact": "Confirm contact details",
     "rejected": "Rejected",
     "busy_try_again": "Busy. Please try again later.",
     "please_enable_push_notification": "Please enable Push Notification in settings for Request.",
     "address": "Address",
     "error": "Error",
     "device_has_no_camera": "Device has no camera",
     "warning": "Warning",
     "phone_number": "Phone Number",
     "address_line_first": "Address Line 1",
     "address_line_second": "Address Line 2",
     "city": "City",
     "postal_code": "PostalCode",
     "state": "State",
     "manage_services": "manage services",
     "manage_home": "manage Home",
     "login_text": "Login",
     "add_item": "Add Item",
     "welcome_text": "Welcome To \\n The",
     "welcome_login_text": "Welcome to Login",
     "your_job": "Your Job",
     "tap_to_change": "Tap to Change",
     "dont_have_acc": "Don't have an account ?",
     "already_have_acc": "Already have an account ? Sign In",
     "toc_text": "I agree to the Terms &amp; Conditions and Privacy Policy.",
     "logout": "Logout",
     "please_give_permission": "Please give permission to access photo.",
     "terms_conditions": "Terms &amp; Conditions",
     "sms_mobile_verify": "We have sent you access code via SMS for mobile number verification",
     "didnt_receive_otp": "Didn't Receive the OTP?",
     "otp_again": "You can send OTP again in",
     "credentials_dont_look": "Those credentials don't look right. Please try again",
     "enter_your_first_name": "Enter First name",
     "enter_your_last_name": "Enter Last name",
     "enter_your_phone_number": "Enter Phone Number",
     "enter_your_email": "Enter Email",
     "enter_your_password": "Enter Password",
     "country": "Country",
     "my_profile": "My Profile",
     "edit_profile": "Edit Profile",
     "update_info": "#VALUE!",
     "change_password": "Change Password",
     "added": "Added",
     "next": "Next",
     "enter_location": "Enter location",
     "you_are_in": "You are in",
     "service_at_me": "I want services at my current location",
     "set_on_map": "Set location on Map",
     "please_set_location": "Please Set Your Location",
     "your_booking": "Your Bookings",
     "on_going_jobs": "On Going Jobs",
     "success_fully_updated": "Success Fully Updated",
     "enter_your_old_password": "Enter Old Password",
     "enter_your_new_password": "Enter New Password",
     "enter_your_conform_password": "Enter Confirm Password",
     "please_add_them_to_your_emergency_contact": "Please Add Them To Your Emergency Contact",
     "sorting": "Sort",
     "less_than_akm": "Less than a Km away",
     "estimated_charge": "Fare estimation",
     "minimum_hour": "Minimum Hour",
     "payment_option": "Payment Option",
     "select_booking_location": "Select booking location",
     "provider_arrived": "Provider arrived",
     "calendar": "Calendar",
     "booking_details": "Booking Details",
     "check_out": "Checkout",
     "remove": "Remove",
     "estimated_fee": "Estimated Fee",
     "cart": "Cart",
     "payment_summary": "Payment Summary",
     "job_request_date": "Job Request Date",
     "discount_applied": "Discount Applied",
     "provider_feedback": "Provider Feedback",
     "how_was_the_job_done": "How the Job Was Done",
     "more_info": "More Info",
     "set_location_on_map": "Set Location On Map",
     "no_service_found": "No Service Found",
     "review": "Review",
     "gallery": "Gallery",
     "view_more": "View More",
     "view_less": "View Less",
     "here_you_can_change_your_map": "Here you can change your map",
     "by_clicking": "By clicking below actions",
     "google_map": "Google Map",
     "waze_map": "Waze Map",
     "do_you_want": "Do you want to access direction?",
     "please_install_google_maps_app": "Please install Google maps app , then only you get the direction for this item.",
     "do_you_want_to_accessdirection": "Do you want to access direction?",
     "pleaseInstallWazeMapsApp": "Please install Waze maps app , then only you get the direction for this item.",
     "job_location": "Job Location",
     "destination_location": "Destination Location",
     "thanks_for_providing_this_service": "Thanks For Providing This Service",
     "before_service": "Before Service",
     "after_service": "After Service",
     "fare_details": "Fare Details",
     "payment_completed_for": "Payment Completed For",
     "number": "No",
     "agree_terms_and_privacy_policy_content": "Agree the terms &amp; Conditions, Privacy Policy to continue",
     "max_char": "Maximum 250 Characters Only",
     "manually_booked_alert": "Manually Booked",
     "manually_booked_reminder_alert": "Mauall Booking Reminder",
     "manual_bookiing_cancelled_alert": "Manual Booking Cancelled",
     "manual_booking_info_alert": "Manually Booked",
     "scheduled_alert": "Scheduled",
     "request_alert": "Requested",
     "begin_job_alert": "Began",
     "end_job_alert": "Ended",
     "pending_alert": "Pending",
     "cancelled_alert": "Cancelled",
     "completed_alert": "Completed",
     "rating_alert": "Given Rating",
     "payment_alert": "Completed Payment",
     "edit_item": "Edit Item",
     "no_data_found": "No Data Found",
     "password_validation_msg": "Please enter minimum 6 characters",
     "special_instruction": "Special Instruction",
     "provide_feedback": "Provide Feedback",
     "send_alert": "Send alert to your friends/family members in case of an emergency",
     "add_them": "Please add them to your emergency contact",
     "sec": "Sec",
     "payment_type": "Payment type",
     "your_invite_code": "Your Invite Code",
     "for_every_friend_jobs": "for every friend who jobs with",
     "internal_server_error": "Internal server error, please try again.",
     "are_you_sure_you_want_to_exit": "Are You Sure You Want to Exit ? ",
     "provide_your_feedback": "Provide your feedback ",
     "balance": "Balance "
   },
   "Handy": {
     "rate_your_job": "Rate Your Job",
     "location_smooth": "users have a safe and smooth Job experiance",
     "order_failed": "Order failed",
     "your_orderfailed": "Your order failed. Touch",
     "order_cancelled": "Order canceled",
     "your_order_cancelled": "You canceled your order.",
     "job": "Job",
     "your_jobs": "Your Jobs",
     "job_details": "Job Details",
     "user": "User",
     "kilometer_away": "Kilometer away",
     "sort_distance": "Distance ( KM )",
     "sort_name": "Name ( A - Z )",
     "search_services": "Search Services",
     "book": "Book",
     "book_now": "Book Now",
     "book_later": "Book Later",
     "category_name": "Category Name",
     "name": "Name",
     "no_provider_found": "No Providers Found",
     "items_in_your_cart_will_be_discarded": "Items in your cart will be discarded !",
     "you_can_only_one_item_for_this_service_type": "You can select only one item for this Service Type",
     "remove_item": "Remove Item",
     "no_reviews_yet": "No Reviews Yet",
     "the_provider_has_no_images": "The provider hasn't uploaded any images",
     "remove_from_cart": "Remove From Cart",
     "edit_cart": "Edit Cart",
     "add_cart": "Add Cart",
     "add_special_info_below": "Add Special Instruction for Provider below.",
     "service_charge": "Service Charge",
     "service_charge_per_hour": "Service Charge per hour",
     "at_user_location": "At User Location",
     "at_provider_location": "At Provider Location",
     "map": "Map View",
     "list": "List View",
     "a_to_z": "A - Z",
     "i_want_service_at_my_current_location": "I Want Service At My Current Location",
     "job_id": "Job ID",
     "live_track": "Live Track",
     "job_progress": "Job Progress",
     "navigate": "Navigate",
     "requested_service": "Requested Service",
     "cancel_booking": "Cancel Booking",
     "live_tracking": "Live Tracking",
     "no_up_comming_jobs": "You have no upcomming Jobs",
     "no_jobs": "You have no Jobs",
     "cancel_job": "Cancel Job",
     "cancel_your_job": "Cancel Your Job",
     "how_was_your_job": "How was your job?",
     "booking_requested": "Booking Requested",
     "view_on_going_job": "View on Going Job",
     "free_job_upto": "Free job up to",
     "price_type": "Price type",
     "let’s_ensure_safer_jobs": "Let's Ensure Safer Jobs",
     "make_your_job_experience_safe": "Make Your Job Experience Safe"
   },
   "Gofer": {
     "location_smooth": "users have a safe and smooth ride experiance",
     "no_car_available": "No Cars Available in Your Area",
     "no_cabs_avail": "No Cabs Available",
     "getting_cabs": "Getting Cabs",
     "up_coming_ride": "UpComing Ride Set",
     "shedule_ur_ride": "Scheduling your ride",
     "current_fare_estimate": "Current fare estimate",
     "actual_string": "Actual estimate to be provided prior to pickup. Fares may vary due to traffic, weather and other factors.",
     "does_not_guarantee_str": "doesn't guarantee a provider will accept your ride request.",
     "peak_time_pricing": "PEAK TIME PRICING",
     "demand_is_off": "Demand is off the charts! Fares have increased to get more UBER on the road.",
     "affordable_every_ride": "Affordable, everyday rides",
     "description_fare_estimation": "The fare will be the price presented upon booking, or, if the journey changes, the fare will be based on the rates provided. Tap fare for details.",
     "description_price_break": "Your fare will be the price presented before the trip or based on the rates below and other applicable adjustments.",
     "same_pickup_drop": "The Pick up and drop location are same...",
     "free_trip_upto": "Free trip up to",
     "smooth_or_sloppy": "Smooth or Sloppy ? Rate your ride",
     "your_trips": "Your Trips",
     "you_have_no_trips": "You have no trips",
     "trip": "Trip",
     "trip_details": "Trip Details",
     "cancel_your_ride": "Cancel Your Ride",
     "cancel_trip": "CANCEL TRIP",
     "your_current_trip": "Your current trip",
     "drive_with_gofer": "Drive With Gofer",
     "your_trip_with": "Your Trip With",
     "min_arrival_till_start": "min of arrival till trip starts.",
     "drive_with": "Drive With",
     "min_waiting_applied": "/min Waiting Fee applies after",
     "my_trips": "My Trips",
     "trip_id": "Trip ID :",
     "trips": "trips",
     "rider": "Rider",
     "end_trip_status": "End Trip",
     "begin_trip_status": "Begin Trip",
     "please_select_option": "Please select an option",
     "how_many_seats": "How many seats do you need?",
     "this_fare_may_vary": "The fare is based on our estimation this will vary on the end of the trip",
     "confirm_seats": "Confirm seats",
     "pool": "Pool",
     "gender": "Gender",
     "male": "Male",
     "female": "Female",
     "make_travel_safer": "Make Your Travel Safety"
   }
 }
 */



// MARK: - TRVicky
//class TRVickyCommon: Codable {
//
//
//
//
////    Payment Type
//    enum CodingKeys : String,CodingKey {
//
//
//
//    }
//
//    required init(from decoder : Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//
//
//    }
//}

// MARK: - TRVicky
//class TRVickyHandy: Codable {
//
//    let yourJob : String
//    
//
////    Payment Type
//    enum CodingKeys : String,CodingKey {
//        case yourJob = "your_job" // "Your Job"
//       
//
//    }
//
//    required init(from decoder : Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.yourJob = container.safeDecodeValue(forKey: .yourJob)
//        
//    }
//}

// MARK: - TRVicky
//class TRVickyGofer: Codable {
//
//   
//
//    enum CodingKeys : String,CodingKey {
//       
//    }
//
//    required init(from decoder : Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//    }
//}
class GoferDeliveryAll: Codable {
    let trackYourOrder : String
    let orderDetails : String
    let confirmOrder : String
    let confirmOrderWithStore : String
    let getStartedWith : String
    let enterMobileNumber : String
    let skipForNow : String
    let enterYourMobileNumber : String
    let theMobileNumberYouEnteredIsInvalid : String
    let next : String
    let updateYourPhoneNumber : String
    let resetPassword : String
    let updatePhoneNumber : String
    let alreadyYouHaveAnAccountpleaseLogin : String
    let enterTheFourDigitCodeSentToYouAt : String
    let resendCodeIn : String
    let iDidnTReceiveACode : String
    let didYouEnterTheCorrectMobileNumber : String
    let resendTo : String
    let pleaseEnterOtp : String
    let yourOtpIsNotMatchedPleaseTryAgain : String
    let yourOtpIsMatched : String
    let cancel : String
    let resendCodeViaSms : String
    let howWouldYouLikeToReceiveYourCode : String
    let whatsYourEmailAddress : String
    let nameexamplecom : String
    let createYourAccountPassword : String
    let minimum6Characters : String
    let whatsYourName : String
    let byContinuingYouAgreeToThe : String
    let termsOfUse : String
    let privacyPolicy : String
    let updateYourFirstName : String
    let firstName : String
    let updateFirstName : String
    let updateYourSurname : String
    let surname : String
    let updateSurname : String
    let updateYourEmailAddress : String
    let updateEmailAddress : String
    let welcomeBack : String
    let enterYourPasswordToContinue : String
    let enterYourPassword : String
    let login : String
    let save : String
    let theEmailYouEnteredIsInvalid : String
    let passwordsMustBeAtLeast6Characters : String
    let passwordCredentialsIsNotMatchpleaseTryAgain : String
    let iForgotMyPassword : String
    let currentLocation : String
    let gettingAddress : String
    let failedToGettingYourCurrentAddresss : String
    let deliveryDetails : String
    let needAuthorization : String
    let pleaseEnableLocationServicesToUseYourCurrentLocation : String
    let settings : String
    let done : String
    let asap : String
    let meetAtVehicle : String
    let doorToDelivery : String
    let deliverToDoor : String
    let when : String
    let asSoonAsPossible : String
    let scheduleAnOrder : String
    let enterANewAddress : String
    let deliveryOptions : String
    let deliveryToDoor : String
    let aptsuitefloor : String
    let businessName : String
    let pickUpOutside : String
    let addDeliveryNote : String
    let removeSavedAddress : String
    let removeThisLocation : String
    let yes : String
    let no : String
    let unableToDeliverItems : String
    let theItemsInYourCartCanTBeDeliveredToYourNewAddress : String
    let clearCart : String
    let tooFarAway : String
    let close : String
    let viewSimilar : String
    let finished : String
    let continueWithYourPreviousOrder : String
    let youStillHaveItemsInYourBasketFrom : String
    let continues : String
    let scheduleDeliveryTime : String
    let setDeliveryTime : String
    let orderReceipt : String
    let today : String
    let tommorow : String
    let enterYourNote : String
    let totalAmountApi : String
    let totalApi : String
    let walletAmountApi : String
    let promoAmount : String
    let penalty : String
    let selectReason : String
    let otherReasons : String
    let cancelOrder : String
    let browseOrSearch : String
    let seeAllRestaurants : String
    let closed : String
    let currentlyUnavailable : String
    let underStoreApi : String
    let under : String
    let minutes : String
    let moreRestaurant : String
    let noMatches : String
    let tryBroadeningYourSearch : String
    let sort : String
    let price : String
    let dietary : String
    let filter : String
    let priceRange : String
    let changeMenu : String
    let vegetarian : String
    let viewInfo : String
    let locationAndHours : String
    let info : String
    let leaveANoteForTheStore : String
    let removeItemFromCart : String
    let add1ToBasket : String
    let update : String
    let toBasket : String
    let add : String
    let yourCartAlreadyContainsAnItemFrom : String
    let wouldYouLikeToClearTheCartAndAddThisItemFrom : String
    let instead : String
    let startNewBasket : String
    let newBasket : String
    let placeOrder : String
    let yourBasket : String
    let addANote : String
    let beginCheckout : String
    let thereIsnTAnythingInYourBasket : String
    let keepBrowsing : String
    let subtotal : String
    let deliveryFee : String
    let pleaseSelectAnotherItem : String
    let anItemYouSelected : String
    let isNoLongerAvailablePleaseTrySomethingEquallyDelicious : String
    let browse : String
    let deliveringToYourDoor : String
    let addADeliveryNote : String
    let store : String
    let addPromoCode : String
    let cash : String
    let apple_pay : String
    let createAnAccountOrSignInToAddAPromoCode : String
    let ifYouHaveAn : String
    let promoCodeEnterItAndSaveOnYourOrder : String
    let enterPromoCode : String
    let apply : String
    let promotions : String
    let freeUpto : String
    let on : String
    let expiredOn : String
    let off : String
    let search : String
    let restaurantOrDishName : String
    let topCategories : String
    let moreCategories : String
    let addPayment : String
    let addCreditOrDebitCard : String
    let wallet : String
    let youDonTHaveAnyFavouritesYet : String
    let remove : String
    let yourFavourites : String
    let notes : String
    let noOrdersYet : String
    let appliedPenalty : String
    let viewMenu : String
    let rateOrder : String
    let viewReceipt : String
    let editAccount : String
    let selectAPhoto : String
    let takePhoto : String
    let chooseFromLibrary : String
    let home : String
    let work : String
    let addHome : String
    let addWork : String
    let signOut : String
    let savedPlaces : String
    let enterAmount : String
    let addCard : String
    let change : String
    let yourWalletAmountIs : String
    let addAmount : String
    let pleaseEnterTheCardDetails : String
    let noResultsFound : String
    let recommended : String
    let mostPopular : String
    let rating : String
    let deliveryTime : String
    let allRestaurants : String
    let restaurants : String
    let weDidnTFindAMatchFor : String
    let trySearchingForSomethingElseInstead : String
    let payment : String
    let termsAndCondition : String
    let guest : String
    let submit : String
    let rateYourOrder : String
    let orderId : String
    let howWasIt : String
    let howWasTheDelivery : String
    let ohGreat : String
    let ohNoWhatWentWrong : String
    let addAComment : String
    let pleaseGiveFeedback : String
    let noUpcomingOrders : String
    let estimationArrival : String
    let track : String
    let yourOrderIsPreparing : String
    let estimatedArrival : String
    let preparingYourOrder : String
    let upcoming : String
    let pastOrders : String
    let viewBasket : String
    let specialInstructions : String
    let promoCode : String
    let ok : String
    let soldOut : String
    let reset : String
    let weAreHavingTroubleFetchingTheMenuPleaseTryAgain : String
    let favouriteRestaurant : String
    let popularRestaurant : String
    let newRestaurant : String
    let underRestaurant : String
    let nowUse : String
    let language : String
    let choose : String
    let first : String
    let last : String
    let error : String
    let kindlyEnableCameraAccessByClickingSettingsForUploadProfilePicture : String
    let driver : String
    let call : String
    let message : String
    let contact : String
    let pleaseSaveYourLocation : String
    let pleaseTryAgain : String
    let setupCancelledTryAgain : String
    let hour : String
    let hours : String
    let orderPlacedAt : String
    let orderScheduledAt : String
    let currency : String
    let register : String
    let orConnectWithSocialAccount : String
    let loginWith : String
    let clientNotInitialized : String
    let cancelled : String
    let pleaseSelectAPaymentOption : String
    let english : String
    let delivery : String
    let takeAway : String
    let both : String
    let addTips : String
    let editTips : String
    let chooseAnAccount : String
    let signinWithFacebook : String
    let signinWithGoogle : String
    let invalidCode : String
    let theDeliveryTypeDoesnTSupportForThisStore : String
    let setTip : String
    let confirmingOrderWithStore : String
    let orderCancelled : String
    let orderDeclined : String
    let orderDelivered : String
    let takeaway : String
    let opensAt : String
    let promoRemovedSuccessfully : String
    let logInText : String
    let password : String
    let forgotPassword : String
    let lastName : String
    let email : String
    let mobile : String
    let alreadyHaveAnAccount : String
    let validMobileNumber : String
    let siginTerms1 : String
    let siginTerms2 : String
    let errorMsgEmail : String
    let errorMsgPassword : String
    let errorMsgFirstname : String
    let errorMsgLastname : String
    let signApple : String
    let orders : String
    let profile : String
    let termsAndConditions : String
    let paymentOption : String
    let paymentMethods : String
    let networkFailure : String
    let selectcurrency : String
    let enterThe4Digit : String
    let clearCartTitle : String
    let clearCartMsg : String
    let resendCode : String
    let confirmYourPassword : String
    let retry : String
    let PasswordMismatch : String
    let InValidPassword : String
    let otpEmpty : String
    let signoutMsg : String
    let specialDiscount : String
    let help : String
    let deliverWithGofer : String
    let about : String
    let searchRestaurant : String
    let account : String
    let edit : String
    let accountInformation : String
    let youHaveNoFavourtiesList : String
    let recentlyAdded : String
    let removeSelected : String
    let useWallet : String
    let descriptCash : String
    let under20Minutes : String
    let newToGoferEats : String
    let popularNearYou : String
    let seeMoreRestaurants : String
    let addANoteExtraSauceNoOnionsEtc : String
    let yourOrder : String
    let peopleWhoOrderedThisItemAlsoOrdered : String
    let tax : String
    let total : String
    let searchForRestaurantOrDish : String
    let vegan : String
    let mins : String
    let scheduleDate : String
    let setTime : String
    let otpMismatch : String
    let enablePermission : String
    let restaurant : String
    let promoApplied : String
    let nodatafound : String
    let noUpcomingOrder : String
    let rate : String
    let navigate : String
    let pleaseEnablePermissions : String
    let pleaseEnableLocation : String
    let discount : String
    let noItemCart : String
    let addMoney : String
    let enterWalletAmount : String
    let walletAmount : String
    let checkOut : String
    let history : String
    let FoodStatusDoor : String
    let totalAmount : String
    let orderIdSymbol : String
    let editTheDeliveryNote : String
    let asapAsSoonAsPossible : String
    let deliveredToYou : String
    let changePromoCode : String
    let minNeta : String
    let locationError : String
    let clearandchange : String
    let locationError1 : String
    let scheduleOrder : String
    let continueWithOrder : String
    let hintApartment : String
    let removeItemFromBasket : String
    let ReadyToMeet : String
    let outside : String
    let title1 : String
    let msg1 : String
    let msgfirsthalf : String
    let msg2half : String
    let removeMenus : String
    let removeMenu : String
    let clearAllBasket : String
    let gettingOrderDetails : String
    let gettingRestaurants : String
    let exit : String
    let whatCouldBetter : String
    let selectLang : String
    let loginError1 : String
    let loginError2 : String
    let loginError3 : String
    let changeLanguage : String
    let changeCurrency : String
    let deliveringTo : String
    let loading : String
    let profileUpload : String
    let imageUpload : String
    let chooseGallery : String
    let addPhoto : String
    let offOn : String
    let offon : String
    let offPer : String
    let mobileAlreadyEntered : String
    let successMobileNumber : String
    let noLocation : String
    let alert : String
    let locationRemoved : String
    let enterLocation : String
    let required : String
    let requiredChooseUpto : String
    let requiredChoose : String
    let to : String
    let chooseUpto : String
    let chooseTo : String
    let onlinepayment : String
    let pay : String
    let paymentcompleted : String
    let seeMore : String
    let stripeError1 : String
    let stripeError2 : String
    let paymentFailed : String
    let addTipAmt : String
    let yourTripAmoutWas : String
    let enterTip : String
    let tips : String
    let errorTipsAmt : String
    let chooseMap : String
    let googleMap : String
    let wazeMap : String
    let googleMapNotFoundInDevice : String
    let wazeGoogleMapNotFoundInDevice : String
    let paypal : String
    let payForOrdersWithCash : String
    let menu : String
    let facebook : String
    let google : String
    let bookingFee : String
    let pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem : String
    let seeAll : String
    let pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem : String
    let new : String
    let tappedOn : String
    let userTappedOnConditionText : String
    let iConfirmThatIHaveReadAndAgreedToThe  : String
    let selectPaymentMethod : String
    let hereYouCanChangeYourMap : String
    let byClickingBelowActions : String
    let doYouWantToAccessDirection : String
    let or : String
    let name : String
    let all : String
    let s : String
    let and : String
    let layoutDirection : String
    let layoutDirectionRl : String
    let loginWithApp : String
    let pick : String
    let upTo : String
    let tipsAmountUpdatedSuccessfully : String
    let support : String
    let appName : String
    
    let submitDocToVerify18Plus : String
    let tapToAdd : String
    let eighteenPlusVerification : String
    let waitingForAdmin : String
    let verification : String
    let plsUploadIDProof : String
    
    let contactLessDelivery : String
    let contactLessDeliveryInfo : String
    let offers : String
    let viewOffers : String
    let receiptUpload : String
    let receiptImage : String
    let choosePayment : String
    let orderImg : String
    let view : String
    let yourReceipt : String
    let followBestSafetyStds : String
    let packageDeliveryImage : String
    let followsBestSafetyStandard : String
    let pleaseUploadReceiptImageOfYourOrder : String
    let pleaseEnterTipsAmount : String
    let chooseAnotherPayment : String
    let followWhoSafetyPractices : String
    let nonVegetarian : String
    let cusines : String
    let itemOutOfStock : String
    let estimatedPickup : String
    let deliveryType : String
    let storeDescription : String
    let status : String
    let expiryDate : String
    let pleaseMakeSure : String
    let idProofRejected : String
    let idProofVerified : String
    let submittedSuccessfully : String
    let orderPlacedSuccessfully : String
    let allStores : String
    let expiresOn : String
    enum CodingKeys : String,CodingKey {
        case submittedSuccessfully = "submitted_successfully"
        case idProofVerified = "id_proof_verified"
        case status = "status"
        case idProofRejected = "id_proof_rejected"
        case pleaseMakeSure = "please_make_sure"
        case expiryDate = "expiry_date"

        case storeDescription = "store_description"
        case deliveryType = "delivery_type"
        case itemOutOfStock = "item_out_of_stock"
        case trackYourOrder = "track_your_order"
        case cusines = "cusines"
        case nonVegetarian = "non_vegetarian"
        case appName = "app_name"
        case getStartedWith = "get_started_with"
        case enterMobileNumber = "enter_mobile_number"
        case skipForNow = "skip_for_now"
        case enterYourMobileNumber = "enter_your_mobile_number"
        case theMobileNumberYouEnteredIsInvalid = "the_mobile_number_you_entered_is_invalid"
        case next = "next"
        case updateYourPhoneNumber = "update_your_phone_number"
        case resetPassword = "reset_password"
        case updatePhoneNumber = "update_phone_number"
        case alreadyYouHaveAnAccountpleaseLogin = "already_you_have_an_accountplease_login"
        case enterTheFourDigitCodeSentToYouAt = "enter_the_four-digit_code_sent_to_you_at"
        case resendCodeIn = "resend_code_in"
        case iDidnTReceiveACode = "i_didnt_receive_a_code"
        case didYouEnterTheCorrectMobileNumber = "did_you_enter_the_correct_mobile_number"
        case resendTo = "resend_to"
        case pleaseEnterOtp = "please_enter_otp"
        case yourOtpIsNotMatchedPleaseTryAgain = "your_otp_is_not_matched_please_try_again"
        case yourOtpIsMatched = "your_otp_is_matched"
        case cancel = "cancel"
        case resendCodeViaSms = "resend_code_via_sms"
        case howWouldYouLikeToReceiveYourCode = "how_would_you_like_to_receive_your_code"
        case whatsYourEmailAddress = "whats_your_email_address"
        case nameexamplecom = "name_examplecom"
        case createYourAccountPassword = "create_your_account_password"
        case minimum6Characters = "minimum_6_characters"
        case whatsYourName = "whats_your_name"
        case byContinuingYouAgreeToThe = "by_continuing_you_agree_to_the"
        case termsOfUse = "terms_of_use"
        case privacyPolicy = "privacy_policy"
        case updateYourFirstName = "update_your_first_name"
        case firstName = "first_name"
        case updateFirstName = "update_first_name"
        case updateYourSurname = "update_your_surname"
        case surname = "surname"
        case updateSurname = "update_surname"
        case updateYourEmailAddress = "update_your_email_address"
        case updateEmailAddress = "update_email_address"
        case welcomeBack = "welcome_back"
        case enterYourPasswordToContinue = "enter_your_password_to_continue"
        case enterYourPassword = "enter_your_password"
        case login = "login"
        case save = "save"
        case theEmailYouEnteredIsInvalid = "the_email_you_entered_is_invalid"
        case passwordsMustBeAtLeast6Characters = "passwords_must_be_at_least_6_characters"
        case passwordCredentialsIsNotMatchpleaseTryAgain = "password_credentials_is_not_matchplease_try_again"
        case iForgotMyPassword = "i_forgot_my_password"
        case currentLocation = "current_location"
        case gettingAddress = "getting_address"
        case failedToGettingYourCurrentAddresss = "failed_to_getting_your_current_addresss"
        case deliveryDetails = "delivery_details"
        case needAuthorization = "need_authorization"
        case pleaseEnableLocationServicesToUseYourCurrentLocation = "please_enable_location_services_to_use_your_current_location"
        case settings = "settings"
        case done = "done"
        case asap = "asap"
        case meetAtVehicle = "meet_at_vehicle"
        case doorToDelivery = "door_to_delivery"
        case deliverToDoor = "deliver_to_door"
        case when = "when"
        case asSoonAsPossible = "as_soon_as_possible"
        case scheduleAnOrder = "schedule_an_order"
        case enterANewAddress = "enter_a_new_address"
        case deliveryOptions = "delivery_options"
        case deliveryToDoor = "delivery_to_door"
        case aptsuitefloor = "aptsuitefloor"
        case businessName = "business_name"
        case pickUpOutside = "pick_up_outside"
        case addDeliveryNote = "add_delivery_note"
        case removeSavedAddress = "remove_saved_address"
        case removeThisLocation = "remove_this_location"
        case yes = "yes"
        case no = "no"
        case unableToDeliverItems = "unable_to_deliver_items"
        case theItemsInYourCartCanTBeDeliveredToYourNewAddress = "the_items_in_your_cart_can't_be_delivered_to_your_new_address"
        case clearCart = "clear_cart"
        case tooFarAway = "too_far_away"
        case close = "close"
        case viewSimilar = "view_similar"
        case finished = "finished"
        case continueWithYourPreviousOrder = "continue_with_your_previous_order"
        case youStillHaveItemsInYourBasketFrom = "you_still_have_items_in_your_basket_from"
        case continues = "continue"
        case scheduleDeliveryTime = "schedule_delivery_time"
        case setDeliveryTime = "set_delivery_time"
        case orderReceipt = "order_receipt"
        case today = "today"
        case tommorow = "tommorow"
        case enterYourNote = "enter_your_note"
        case totalAmountApi = "total_amount_api"
        case totalApi = "total_api"
        case walletAmountApi = "wallet_amount_api"
        case promoAmount = "promo_amount"
        case penalty = "penalty"
        case selectReason = "select_reason"
        case otherReasons = "other_reasons"
        case cancelOrder = "cancel_order"
        case browseOrSearch = "browse_or_search"
        case seeAllRestaurants = "see_all_restaurants"
        case closed = "closed"
        case currentlyUnavailable = "currently_unavailable"
        case underStoreApi = "under_store_api"
        case under = "under"
        case minutes = "minutes"
        case moreRestaurant = "more_restaurant"
        case noMatches = "no_matches"
        case tryBroadeningYourSearch = "try_broadening_your_search"
        case sort = "sort"
        case price = "price"
        case dietary = "dietary"
        case filter = "filter"
        case priceRange = "price_range"
        case changeMenu = "change_menu"
        case vegetarian = "vegetarian"
        case viewInfo = "view_info"
        case locationAndHours = "location_and_hours"
        case info = "info"
        case leaveANoteForTheStore = "leave_a_note_for_the_store"
        case removeItemFromCart = "remove_item_from_cart"
        case add1ToBasket = "add_1_to_basket"
        case update = "update"
        case toBasket = "to_basket"
        case add = "add"
        case yourCartAlreadyContainsAnItemFrom = "your_cart_already_contains_an_item_from"
        case wouldYouLikeToClearTheCartAndAddThisItemFrom = "would_you_like_to_clear_the_cart_and_add_this_item_from"
        case instead = "instead"
        case startNewBasket = "start_new_basket"
        case newBasket = "new_basket"
        case placeOrder = "place_order"
        case yourBasket = "your_basket"
        case addANote = "add_a_note"
        case beginCheckout = "begin_checkout"
        case thereIsnTAnythingInYourBasket = "there_isnt_anything_in_your_basket"
        case keepBrowsing = "keep_browsing"
        case subtotal = "subtotal"
        case deliveryFee = "delivery_fee"
        case pleaseSelectAnotherItem = "please_select_another_item"
        case anItemYouSelected = "an_item_you_selected"
        case isNoLongerAvailablePleaseTrySomethingEquallyDelicious = "is_no_longer_available_please_try_something_equally_delicious"
        case browse = "browse"
        case deliveringToYourDoor = "delivering_to_your_door"
        case addADeliveryNote = "add_a_delivery_note"
        case store = "store"
        case addPromoCode = "add_promo_code"
        case cash = "cash"
        case apple_pay = "apple_pay"
        case createAnAccountOrSignInToAddAPromoCode = "create_an_account_or_sign_in_to_add_a_promo_code"
        case ifYouHaveAn = "if_you_have_an"
        case promoCodeEnterItAndSaveOnYourOrder = "promo_code_enter_it_and_save_on_your_order"
        case enterPromoCode = "enter_promo_code"
        case apply = "apply"
        case promotions = "promotions"
        case freeUpto = "free_upto"
        case on = "on"
        case expiredOn = "expired_on"
        case expiresOn = "expires_on"
        case off = "off"
        case search = "search"
        case restaurantOrDishName = "restaurant_or_dish_name"
        case topCategories = "top_categories"
        case moreCategories = "more_categories"
        case addPayment = "add_payment"
        case addCreditOrDebitCard = "add_credit_or_debit_card"
        case wallet = "wallet"
        case youDonTHaveAnyFavouritesYet = "you_dont_have_any_favourites_yet"
        case remove = "remove"
        case yourFavourites = "your_favourites"
        case notes = "notes"
        case noOrdersYet = "no_orders_yet"
        case appliedPenalty = "applied_penalty"
        case viewMenu = "view_menu"
        case rateOrder = "rate_order"
        case viewReceipt = "view_receipt"
        case editAccount = "edit_account"
        case selectAPhoto = "select_a_photo"
        case takePhoto = "take_photo"
        case chooseFromLibrary = "choose_from_library"
        case home = "home"
        case work = "work"
        case addHome = "add_home"
        case addWork = "add_work"
        case signOut = "sign_out"
        case savedPlaces = "saved_places"
        case enterAmount = "enter_amount"
        case addCard = "add_card"
        case change = "change"
        case yourWalletAmountIs = "your_wallet_amount_is"
        case addAmount = "add_amount"
        case pleaseEnterTheCardDetails = "please_enter_the_card_details"
        case noResultsFound = "no_results_found"
        case recommended = "recommended"
        case mostPopular = "most_popular"
        case rating = "rating"
        case deliveryTime = "delivery_time"
        case allRestaurants = "all_restaurants"
        case restaurants = "restaurants"
        case weDidnTFindAMatchFor = "we_didn't_find_a_match_for"
        case trySearchingForSomethingElseInstead = "try_searching_for_something_else_instead"
        case payment = "payment"
        case termsAndCondition = "terms_and_condition"
        case guest = "guest"
        case submit = "submit"
        case rateYourOrder = "rate_your_order"
        case orderId = "order_id"
        case howWasIt = "how_was_it"
        case howWasTheDelivery = "how_was_the_delivery"
        case ohGreat = "oh_great"
        case ohNoWhatWentWrong = "oh_no_what_went_wrong"
        case addAComment = "add_a_comment"
        case pleaseGiveFeedback = "please_give_feedback"
        case noUpcomingOrders = "no_upcoming_orders"
        case estimationArrival = "estimation_arrival"
        case track = "track"
        case yourOrderIsPreparing = "your_order_is_preparing"
        case estimatedArrival = "estimated_arrival"
        case preparingYourOrder = "preparing_your_order"
        case upcoming = "upcoming"
        case pastOrders = "past_orders"
        case viewBasket = "view_basket"
        case specialInstructions = "special_instructions"
        case promoCode = "promo_code"
        case ok = "ok"
        case soldOut = "sold_out"
        case reset = "reset"
        case weAreHavingTroubleFetchingTheMenuPleaseTryAgain = "we_are_having_trouble_fetching_the_menu_please_try_again"
        case favouriteRestaurant = "favourite_restaurant"
        case popularRestaurant = "popular_restaurant"
        case newRestaurant = "new_restaurant"
        case underRestaurant = "under_restaurant"
        case nowUse = "now_use"
        case language = "language"
        case choose = "choose"
        case first = "first"
        case last = "last"
        case error = "error"
        case kindlyEnableCameraAccessByClickingSettingsForUploadProfilePicture = "kindly_enable_camera_access_by_clicking_settings_for_upload_profile_picture"
        case driver = "driver"
        case call = "call"
        case message = "message"
        case contact = "contact"
        case pleaseSaveYourLocation = "please_save_your_location"
        case pleaseTryAgain = "please_try_again"
        case setupCancelledTryAgain = "setup_cancelled_try_again"
        case hour = "hour"
        case hours = "hours"
        case orderPlacedAt = "order_placed_at"
        case orderScheduledAt = "order_scheduled_at"
        case currency = "currency"
        case register = "register"
        case orConnectWithSocialAccount = "or_connect_with_social_account"
        case loginWith = "login_with"
        case clientNotInitialized = "client_not_initialized"
        case cancelled = "cancelled"
        case pleaseSelectAPaymentOption = "please_select_a_payment_option"
        case english = "english"
        case delivery = "delivery"
        case takeAway = "take_away"
        case both = "both"
        case addTips = "add_tips"
        case editTips = "edit_tips"
        case chooseAnAccount = "choose_an_account"
        case signinWithFacebook = "signin_with_facebook"
        case signinWithGoogle = "signin_with_google"
        case invalidCode = "invalid_code"
        case theDeliveryTypeDoesnTSupportForThisStore = "the_delivery_type_doesn't_support_for_this_store"
        case setTip = "set_tip"
        case confirmingOrderWithStore = "confirming_order_with_store"
        case orderCancelled = "order_cancelled"
        case orderDeclined = "order_declined"
        case orderDelivered = "order_delivered"
        case takeaway = "takeaway"
        case opensAt = "opens_at"
        case promoRemovedSuccessfully = "promo_removed_successfully"
        case logInText = "log_in_text"
        case password = "password"
        case forgotPassword = "forgot_password"
        case lastName = "last_name"
        case email = "email"
        case mobile = "mobile"
        case alreadyHaveAnAccount = "already_have_an_account"
        case validMobileNumber = "valid_mobile_number"
        case siginTerms1 = "sigin_terms1"
        case siginTerms2 = "sigin_terms2"
        case errorMsgEmail = "error_msg_email"
        case errorMsgPassword = "error_msg_password"
        case errorMsgFirstname = "error_msg_firstname"
        case errorMsgLastname = "error_msg_lastname"
        case signApple = "sign_apple"
        case orders = "orders"
        case profile = "profile"
        case termsAndConditions = "terms_and_conditions"
        case paymentOption = "payment_option"
        case paymentMethods = "payment_methods"
        case networkFailure = "network_failure"
        case selectcurrency = "selectcurrency"
        case enterThe4Digit = "enter_the_4_digit"
        case clearCartTitle = "clear_cart_title"
        case clearCartMsg = "clear_cart_msg"
        case resendCode = "resend_code"
        case confirmYourPassword = "confirm_your_password"
        case retry = "retry"
        case PasswordMismatch = "Password_Mismatch"
        case InValidPassword = "InValid_Password"
        case otpEmpty = "otpEmpty"
        case signoutMsg = "signout_msg"
        case specialDiscount = "special_discount"
        case help = "help"
        case deliverWithGofer = "deliver_with_gofer"
        case about = "about"
        case searchRestaurant = "search_Restaurant"
        case account = "account"
        case edit = "edit"
        case accountInformation = "account_information"
        case youHaveNoFavourtiesList = "you_have_no_favourties_list"
        case recentlyAdded = "recently_added"
        case removeSelected = "remove_selected"
        case useWallet = "use_wallet"
        case descriptCash = "descript_cash"
        case under20Minutes = "under_20_minutes"
        case newToGoferEats = "new_to_gofer_eats"
        case popularNearYou = "popular_near_you"
        case seeMoreRestaurants = "see_more_Restaurants"
        case addANoteExtraSauceNoOnionsEtc = "add_a_note_extra_sauce_no_onions_etc"
        case yourOrder = "your_order"
        case peopleWhoOrderedThisItemAlsoOrdered = "people_who_ordered_this_item_also_ordered"
        case tax = "tax"
        case total = "total"
        case searchForRestaurantOrDish = "search_for_restaurant_or_dish"
        case vegan = "vegan"
        case mins = "mins"
        case scheduleDate = "schedule_date"
        case setTime = "set_time"
        case otpMismatch = "otp_mismatch"
        case enablePermission = "enable_permission"
        case restaurant = "restaurant"
        case promoApplied = "promo_applied"
        case nodatafound = "nodatafound"
        case noUpcomingOrder = "no_upcoming_order"
        case rate = "rate"
        case navigate = "navigate"
        case pleaseEnablePermissions = "please_enable_permissions"
        case pleaseEnableLocation = "please_enable_location"
        case discount = "discount"
        case noItemCart = "no_item_cart"
        case addMoney = "add_money"
        case enterWalletAmount = "enter_wallet_amount"
        case walletAmount = "wallet_amount"
        case checkOut = "check_out"
        case history = "history"
        case FoodStatusDoor = "Food_status_door"
        case totalAmount = "total_amount"
        case orderIdSymbol = "order_id_symbol"
        case editTheDeliveryNote = "edit_the_delivery_note"
        case asapAsSoonAsPossible = "asap_as_soon_as_possible"
        case deliveredToYou = "delivered_to_you"
        case changePromoCode = "change_promo_code"
        case minNeta = "min_neta"
        case locationError = "location_error"
        case clearandchange = "clearandchange"
        case locationError1 = "location_error1"
        case scheduleOrder = "schedule_order"
        case continueWithOrder = "continue_with_order"
        case hintApartment = "hint_apartment"
        case removeItemFromBasket = "remove_item_from_basket"
        case ReadyToMeet = "Ready_to_meet"
        case outside = "outside"
        case title1 = "title1"
        case msg1 = "msg1"
        case msgfirsthalf = "msgfirsthalf"
        case msg2half = "msg2half"
        case removeMenus = "remove_menus"
        case removeMenu = "remove_menu"
        case clearAllBasket = "clear_all_basket"
        case gettingOrderDetails = "getting_order_details"
        case gettingRestaurants = "getting_restaurants"
        case exit = "exit"
        case whatCouldBetter = "what_could_better"
        case selectLang = "select_lang"
        case loginError1 = "login_error1"
        case loginError2 = "login_error_2"
        case loginError3 = "login_error3"
        case changeLanguage = "change_language"
        case changeCurrency = "change_currency"
        case deliveringTo = "delivering_to"
        case loading = "loading"
        case profileUpload = "profile_upload"
        case imageUpload = "image_upload"
        case chooseGallery = "choose_gallery"
        case addPhoto = "add_photo"
        case offOn = "off_on"
        case offon = "offon"
        case offPer = "off_per"
        case mobileAlreadyEntered = "mobile_already_entered"
        case successMobileNumber = "success_mobile_number"
        case noLocation = "no_location"
        case alert = "alert"
        case locationRemoved = "location_removed"
        case enterLocation = "enter_location"
        case required = "required"
        case requiredChooseUpto = "required_choose_upto"
        case requiredChoose = "required_choose"
        case to = "to"
        case chooseUpto = "choose_upto"
        case chooseTo = "choose_to"
        case onlinepayment = "onlinepayment"
        case pay = "pay"
        case paymentcompleted = "paymentcompleted"
        case seeMore = "see_more"
        case stripeError1 = "stripe_error_1"
        case stripeError2 = "stripe_error_2"
        case paymentFailed = "payment_failed"
        case addTipAmt = "add_tip_amt"
        case yourTripAmoutWas = "your_trip_amout_was"
        case enterTip = "enter_tip"
        case tips = "tips"
        case errorTipsAmt = "error_tips_amt"
        case chooseMap = "choose_map"
        case googleMap = "google_map"
        case wazeMap = "waze_map"
        case googleMapNotFoundInDevice = "google_map_not_found_in_device"
        case wazeGoogleMapNotFoundInDevice = "waze_google_map_not_found_in_device"
        case paypal = "paypal"
        case payForOrdersWithCash = "pay_for_orders_with_cash"
        case menu = "menu"
        case facebook = "facebook"
        case google = "google"
        case bookingFee = "booking_fee"
        case pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem = "please_install_waze_maps"
        case seeAll = "see_all"
        case pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem = "please_install_google_maps"
        case new = "new"
        case tappedOn = "tapped_on"
        case userTappedOnConditionText = "user_tapped_on_condition_text"
        case iConfirmThatIHaveReadAndAgreedToThe  = "i_confirm_that_i_have_read"
        case selectPaymentMethod = "select_payment_method"
        case hereYouCanChangeYourMap = "here_you_can_change_your_map"
        case byClickingBelowActions = "by_clicking_below_actions"
        case doYouWantToAccessDirection = "do_you_want_to_access_direction"
        case or = "or"
        case name = "name"
        case all = "all"
        case s = "s"
        case and = "and"
        case layoutDirection = "layout_direction"
        case layoutDirectionRl = "layout_direction_rl"
        case loginWithApp = "login_with_app"
        case pick = "pick"
        case upTo = "up_to"
        case tipsAmountUpdatedSuccessfully = "tips_amount_updated_successfully"
        case support = "support"
        case submitDocToVerify18Plus = "please_submit_your_document_to_verify_you_are_18"
        case tapToAdd = "taptoadd"
        case eighteenPlusVerification = "_18_verification"
        case waitingForAdmin = "waiting_for_admin_approval"
        case verification = "verfication"
        case plsUploadIDProof = "upload_image"
        
        case contactLessDelivery = "contactless_delivery"
        case contactLessDeliveryInfo = "contactless_delivery_info"
        case offers = "offers"
        case viewOffers = "view_offers"
        case receiptUpload = "receipt_upload"
        case receiptImage = "receipt_image"
        case choosePayment = "choose_payment"
        case orderImg = "order_images"
        case view = "view"
        case yourReceipt = "your_receipt"
        case followBestSafetyStds = "follows_best_safety_standards"
        case packageDeliveryImage = "package_delivered_image"
        case confirmOrder = "confirm_order"
        case orderDetails = "order_details"
        case confirmOrderWithStore = "confirm_order_with_store"
        case followsBestSafetyStandard = "follows_best_safety_standard"
        case pleaseUploadReceiptImageOfYourOrder = "please_upload_receipt_image_of_your_order"
        case pleaseEnterTipsAmount = "please_enter_tips_amount"
        case chooseAnotherPayment = "choose_another_payment"
        case followWhoSafetyPractices = "follow_who_safety_practices"
        case estimatedPickup = "estimated_pickup"
        case orderPlacedSuccessfully = "order_placed_successfully"
        case allStores = "all_stores"
    }
    init() {
        //  "Call to",
//        "Contactless Delivery",
//        "The Delivery Driver will leave your package outside the door (Applicable for online paid orders)",
//        "Choose Payment",
//        "Receipt Upload",
//        "Your Receipt",
//        "View",
//        "Camera",
//        "Camera roll",
//        "Receipt needed",
//        "18+ Verification",
//        "Expiry Date",
//        "TAP TO ADD",
//        "Follows Best Safety Standards",
//        "Cancel",
//        "verfication",
//        "Order images",
//        "Waiting For Admin Approval",
//        "Please submit your document to verify you are 18+",
//        "Rejected",
//        "We will right back once development completed, Please contact us through sales@trioangle.com for more details.",
//        "sales@trioangle.com",
//        "Receipt",
//        "Online Payment",
//        "File",
//        "Please make sure that selected file is in mobile storage",
//        "Verified",
//        "Please update our app to enjoy the latest features!",
//        "Visit play store",
//        "New version available",
//        "Please update our app to enjoy the latest features!",
//        "To use the app,download the latest version",
//        "Press back again to exit.",
//        "Store Description",
//        "Get started with",
//        "Our Site is Getting A Little Tune Up Now",
//        "Try again",
//        "Enter mobile number",
//        "Skip for now",
//        "Enter your mobile number",
//        "The Mobile Number you entered is invalid.",
//        "Next",
//        "Update your Phone number?",
//        "Reset Password",
//        "Update Phone number",
//        "Already you have an account,please login...",
//        "Enter the four-digit code sent to you at",
//        "Resend code in",
//        "I didn't receive a code",
//        "Did you enter the correct mobile number?",
//        "Resend to",
//        "Please enter OTP.",
//        "Your OTP is not Matched, Please try again.",
//        "Your OTP is Matched.",
//        "CANCEL",
//        "resend code via sms",
//        "How would you like to receive your code?",
//        "What's your email address?",
//        "name@example.com",
//        "Create your account password",
//        "Minimum 6 characters",
//        "What's your name?",
//        "and",
//        "By continuing, you agree to the",
//        "Terms of use",
//        "Privacy Policy",
//        "Update your First name?",
//        "FIRST NAME",
//        "Update First name",
//        "Update your surname?",
//        "surname",
//        "Update Surname",
//        "Update your Email address?",
//        "Update Email address",
//        "Welcome back,",
//        "Enter your password to continue",
//        "Enter your password",
//        "Login",
//        "Save",
//        "The email you entered is invalid",
//        "Passwords must be at least 6 characters",
//        "Password credentials is not match,Please try again.",
//        "I forgot my password",
//        "Current Location",
//        "Getting address...",
//        "Failed to getting your current addresss",
//        "Delivery Details",
//        "Need Authorization",
//        "Please Enable Location services to use your current location",
//        "Settings",
//        "DONE",
//        "ASAP",
//        "Meet at vehicle",
//        "Door to delivery",
//        "Deliver to door",
//        "When",
//        "As soon as possible",
//        "Schedule an order",
//        "Enter a new address",
//        "Delivery options",
//        "Delivery to door",
//        "Apt/Suite/Floor",
//        "Business Name",
//        "Pick up outside",
//        "Add delivery note",
//        "remove saved address",
//        "Remove this location?",
//        "Yes",
//        "No",
//        "Unable to deliver items",
//        "The items in your cart can't be delivered to your new address",
//        "CLEAR CART",
//        "Too Far Away",
//        "CLOSE",
//        "VIEW SIMILAR",
//        "FINISHED",
//        "Continue with your previous order",
//        "You still have items in your basket from",
//        "Continue",
//        "Schedule Delivery Time",
//        "set delivery time",
//        "Order Receipt",
//        "Today",
//        "Tommorow",
//        "Enter your note",
//        "Total amount //API",
//        "Total // API",
//        "Wallet amount //API",
//        "Promo amount",
//        "Penalty",
//        "Select reason",
//        "Other Reasons",
//        "CANCEL ORDER",
//        "see all stores",
//        "CLOSED",
//        "Currently UnAvailable",
//        "Under Store //API",
//        "Under",
//        "Minutes",
//        "More Store",
//        "No matches",
//        "Try broadening your search",
//        "Sort",
//        "Price",
//        "Dietary",
//        "Filter",
//        "Price Range",
//        "Change menu",
//        "Vegetarian",
//        "View Info",
//        "Location and hours",
//        "Info",
//        "Remove item from cart",
//        "Add 1 to basket",
//        "Update",
//        "to basket",
//        "Add",
//        "Your cart already contains an item from",
//        "Would you like to clear the cart and add this item from testtt",
//        "Instead?",
//        "Start new basket?",
//        "new basket",
//        "Place order",
//        "Your basket",
//        "Add a note (e.g. extra napkins,extra sauce)",
//        "BEGIN CHECKOUT",
//        "There isnt anything in your basket",
//        "Keep Browsing",
//        "Subtotal",
//        "Delivery Fee",
//        "Please Select Another Item",
//        "An item you selected",
//        "is no longer available. Please try something equally delicious",
//        "BROWSE",
//        "DELIVERING TO YOUR DOOR",
//        "Add a delivery note",
//        "store",
//        "Add promo code",
//        "Cash",
//        "Create an account or sign in to add a promo code",
//        "If you have an",
//        "promo code, enter it and save on your order.",
//        "Enter Promo Code",
//        "APPLY",
//        "Promotions",
//        "Free upto",
//        "on",
//        "Expired on",
//        "OFF",
//        "Search",
//        "store or dish name",
//        "Top categories",
//        "More categories",
//        "Add Credit or Debit Card",
//        "Wallet",
//        "You don't have any favourites yet",
//        "Remove",
//        "Your Favourites",
//        "NOTES",
//        "No orders yet",
//        "Applied Penalty",
//        "view menu",
//        "rate order",
//        "VIEW RECEIPT",
//        "Edit Account",
//        "select a photo",
//        "TAKE PHOTO",
//        "CHOOSE FROM LIBRARY",
//        "Home",
//        "Work",
//        "Add Home",
//        "Add Work",
//        "Sign Out",
//        "SAVED PLACES",
//        "Enter Amount",
//        "add card",
//        "Change",
//        "Your wallet amount is",
//        "Add Amount",
//        "Please enter the card details",
//        "No Results Found",
//        "Recommended",
//        "Most popular",
//        "Rating",
//        "Delivery time",
//        "All Store",
//        "Stores",
//        "We didn't find a match for",
//        "Try searching for something else instead",
//        "Payment",
//        "Terms and Condition",
//        "Guest",
//        "SUBMIT",
//        "Rate your order!",
//        "ORDER ID",
//        "How Was it",
//        "How Was the Delivery",
//        "Oh!! Great",
//        "Oh!! no, What went wrong?",
//        "Add a comment",
//        "Please give feedback!",
//        "No upcoming orders",
//        "Estimation Arrival",
//        "track",
//        "Your order is preparing",
//        "Estimated Arrival",
//        "Preparing your order",
//        "UPCOMING",
//        "PAST ORDERS",
//        "VIEW BASKET",
//        "Special instructions",
//        "PROMO CODE",
//        "OK",
//        "SOLD OUT",
//        "RESET",
//        "We are having trouble fetching the menu. Please try again.",
//        "Favourite Store",
//        "New Store",
//        "Under Store",
//        "Now use",
//        "Language",
//        "Choose",
//        "First",
//        "Last",
//        "Error",
//        "Kindly enable Camera access by clicking settings for upload profile picture",
//        "Driver",
//        "Call",
//        "Message",
//        "Contact",
//        "Please Save Your Location",
//        "Please try again.",
//        "Setup cancelled try again",
//        "hour",
//        "hours",
//        "Order Placed at
//        "Order Scheduled at
//        "Currency",
//        "REGISTER",
//        "Or Connect with Social account",
//        "Client not initialized",
//        "Cancelled",
//        "Please select a payment option",
//        "English",
//        "Delivery",
//        "Take Away",
//        "Both",
//        "Add Tips",
//        "Edit Tips",
//        "Choose an account",
//        "Signin with Facebook",
//        "Signin with Google",
//        "Invalid Code",
//        "The Delivery Type doesn't support for this store.",
//        "SET TIP",
//        "Confirming order with store",
//        "Order Cancelled",
//        "Order Declined",
//        "Order Delivered",
//        "takeaway",
//        "Opens at",
//        "Promo Removed Successfully",
//        "LOG IN WITH YOUR",
//        "PASSWORD",
//        "Forgot Password?",
//        "LAST NAME",
//        "EMAIL",
//        "Mobile",
//        "Already Have an Account?",
//        "Please Enter a valid Mobile number",
//        "By clicking \"REGISTER,\" I confirm that I have read and agreed to the",
//        "Account Information",
//        "Please enter a valid email",
//        "Please enter minimum 6 characters",
//        "Please enter the First name",
//        "Please enter your last name",
//        "Sign in with Apple",
//        "Orders",
//        "Profile",
//        "Terms And Conditions",
//        "Payment options",
//        "Please check your Internet Connection",
//        "Select Currency",
//        "Enter the 4-digit code sent to you at",
//        "You can only order items from one store at a time",
//        "Clear your cart if you'd still like to order this item ikkkk",
//        "Resend Code",
//        "Confirm Your Password",
//        "Retry",
//        "Password Mismatch",
//        "InValid Password",
//        "OTP Empty",
//        "Are you sure you want to sign out?",
//        "Special discount for you only on GoferDeliveryAll",
//        "Help",
//        "Deliver with GoferDeliveryAll",
//        "About",
//        "Stores",
//        "Account",
//        "Edit",
//        "Account Information",
//        "You don't have any Favourites yet",
//        "Recently Added",
//        "Remove Selected",
//        "Use wallet",
//        "Use cash to pay for orders.You will see the total amount due when you place your order,and exact change is appreciated",
//        "Under 20 Minutes",
//        "New To ",
//        "See All Stores",
//        "Add a note to store",
//        "Your Order",
//        "People who ordered this item also ordered",
//        "Tax",
//        "Total",
//        "Search for Store,Catogery or item",
//        "Schedule a date",
//        "Login With",
//        "Pick",
//        "up to",
//        "Required",
//        "to",
//        "TIPS AMOUNT UPDATED SUCCESSFULLY",
//        "Change promo code",
//        "Select Payment Method",
//        "Support",
//        "Not a valid data",
//        "Remove Tips",
//        "Please enter amount greater than zero",
//        "Continue",
//        "Clear cart",
//        "See More",
//        "Skip",
//        "Deliver to you,12,Louise",
//        "Call Me",
//        "USD",
//        "View Offers",
//        "Offers",
//        "Select a promo code",
//        "GoferDeliveryAll"
        self.submittedSuccessfully = ""
        self.idProofVerified = ""
        self.status = ""
        self.pleaseMakeSure = ""
        self.expiryDate = ""
        self.idProofRejected = ""
        self.storeDescription = ""
        self.deliveryType = "Delivery Type"
        self.itemOutOfStock = ""
        self.trackYourOrder = ""
        self.cusines = "cusines".capitalized
        self.orderDetails = ""
        self.confirmOrder = ""
        self.confirmOrderWithStore = ""
        self.getStartedWith = "Get started with".capitalized
        self.enterMobileNumber = "Enter Mobile Number".capitalized
        self.skipForNow = "Skip For Now".capitalized
        self.enterYourMobileNumber = "enter Your Mobile Number".capitalized
        self.theMobileNumberYouEnteredIsInvalid = "the Mobile Number You Entered Is Invalid".capitalized
        self.next = "Next".capitalized
        self.updateYourPhoneNumber = "update Your Phone Number".capitalized
        self.resetPassword = "reset Password".capitalized
        self.updatePhoneNumber = "update Phone Number".capitalized
        self.alreadyYouHaveAnAccountpleaseLogin = "already You Have An Account please Login".capitalized
        self.enterTheFourDigitCodeSentToYouAt = "enter The Four Digit Code Sent To You At".capitalized
        self.resendCodeIn = "resend Code In".capitalized
        self.iDidnTReceiveACode = "i Didn't Receive A Code".capitalized
        self.didYouEnterTheCorrectMobileNumber = "did You Enter The Correct Mobile Number".capitalized
        self.resendTo = "resend To".capitalized
        self.pleaseEnterOtp = "please Enter Otp".capitalized
        self.yourOtpIsNotMatchedPleaseTryAgain = "your Otp Is Not Matched Please Try Again".capitalized
        self.yourOtpIsMatched = "your Otp Is Matched".capitalized
        self.cancel = "cancel".capitalized
        self.resendCodeViaSms = "resend Code Via Sms".capitalized
        self.howWouldYouLikeToReceiveYourCode = "how Would You Like To Receive Your Code".capitalized
        self.whatsYourEmailAddress = "whats Your Email Address".capitalized
        self.nameexamplecom = "name@gmail.com".capitalized
        self.createYourAccountPassword = "create Your Account Password".capitalized
        self.minimum6Characters = "minimum 6 Characters".capitalized
        self.whatsYourName = "whats Your Name".capitalized
        self.byContinuingYouAgreeToThe = "by Continuing You Agree To The".capitalized
        self.termsOfUse = "terms Of Use".capitalized
        self.privacyPolicy = "privacy Policy".capitalized
        self.updateYourFirstName = "update Your First Name".capitalized
        self.firstName = "first Name".capitalized
        self.updateFirstName = "update First Name".capitalized
        self.updateYourSurname = "update Your Surname".capitalized
        self.surname = "surname".capitalized
        self.updateSurname = "update Surname".capitalized
        self.updateYourEmailAddress = "update Your Email Address".capitalized
        self.updateEmailAddress = "update Your Email Address".capitalized
        self.welcomeBack = "welcome Back".capitalized
        self.enterYourPasswordToContinue = "enter Your Password To Continue".capitalized
        self.enterYourPassword = "enter Your Password".capitalized
        self.login = "login".capitalized
        self.save = "save".capitalized
        self.theEmailYouEnteredIsInvalid = "the Email You Entered Is Invalid".capitalized
        self.passwordsMustBeAtLeast6Characters = "passwords Must Be At Least 6 Characters".capitalized
        self.passwordCredentialsIsNotMatchpleaseTryAgain = "password Credentials Is Not Match please Try Again".capitalized
        self.iForgotMyPassword = "i Forgot My Password".capitalized
        self.currentLocation = "current Location".capitalized
        self.gettingAddress = "getting Address".capitalized
        self.failedToGettingYourCurrentAddresss = "failed To Getting Your Current Addresss".capitalized
        self.deliveryDetails = "delivery Details".capitalized
        self.needAuthorization = "need Authorization".capitalized
        self.pleaseEnableLocationServicesToUseYourCurrentLocation = "please Enable Location Services To Use Your Current Location".capitalized
        self.settings = "settings".capitalized
        self.done = "done".capitalized
        self.asap = "As Soon As possible".capitalized
        self.meetAtVehicle = "meet At Vehicle".capitalized
        self.doorToDelivery = "door To Delivery".capitalized
        self.deliverToDoor = "deliver To Door".capitalized
        self.when = "when".capitalized
        self.asSoonAsPossible = "as Soon As Possible".capitalized
        self.scheduleAnOrder = "schedule An Order".capitalized
        self.enterANewAddress = "enter A New Address".capitalized
        self.deliveryOptions = "delivery Options".capitalized
        self.deliveryToDoor = "deliver To Door".capitalized
        self.aptsuitefloor = "apt suite floor".capitalized
        self.businessName = "business Name".capitalized
        self.pickUpOutside = "pickUp Outside".capitalized
        self.addDeliveryNote = "add Deliver Note".capitalized
        self.removeSavedAddress = "remove Saved Address".capitalized
        self.removeThisLocation = "remove This Location".capitalized
        self.yes = "yes".capitalized
        self.no = "no".capitalized
        self.unableToDeliverItems = "unable To Deliver Items".capitalized
        self.theItemsInYourCartCanTBeDeliveredToYourNewAddress = "the Items In Your Cart CanT Be Delivered To Your New address".capitalized
        self.clearCart = "clear Cart".capitalized
        self.tooFarAway = "too Far Away".capitalized
        self.close = "close".capitalized
        self.viewSimilar = "view Similar".capitalized
        self.finished = "finished".capitalized
        self.continueWithYourPreviousOrder = "continue With Your Previous Order".capitalized
        self.youStillHaveItemsInYourBasketFrom = "you Still Have Items In Your Basket From".capitalized
        self.continues = "continues".capitalized
        self.scheduleDeliveryTime = "schedule Delivery Time".capitalized
        self.setDeliveryTime = "set Delivery Time".capitalized
        self.orderReceipt = "order Receipt".capitalized
        self.today = "today".capitalized
        self.tommorow = "tommorow".capitalized
        self.enterYourNote = "enter Your Note".capitalized
        self.totalAmountApi = "total Amount Api".capitalized
        self.totalApi = "total Api".capitalized
        self.walletAmountApi = "wallet Amount Api".capitalized
        self.promoAmount = "promo Amount".capitalized
        self.penalty = "penalty".capitalized
        self.selectReason = "select Reason".capitalized
        self.otherReasons = "other Reasons".capitalized
        self.cancelOrder = "cancel Order".capitalized
        self.browseOrSearch = "browse Or Search".capitalized
        self.seeAllRestaurants = "see All Restaurants".capitalized
        self.closed = "closed".capitalized
        self.currentlyUnavailable = "currently Unavailable".capitalized
        self.underStoreApi = "under Store Api".capitalized
        self.under = "under".capitalized
        self.minutes = "minutes".capitalized
        self.moreRestaurant = "more Restaurant".capitalized
        self.noMatches = "no Matches".capitalized
        self.tryBroadeningYourSearch = "try Broadening Your Search".capitalized
        self.sort = "sort".capitalized
        self.price = "price".capitalized
        self.dietary = "dietary".capitalized
        self.filter = "filter".capitalized
        self.priceRange = "price Range".capitalized
        self.changeMenu = "change Menu".capitalized
        self.vegetarian = "vegetarian".capitalized
        self.viewInfo = "view Info".capitalized
        self.locationAndHours = "location And Hours".capitalized
        self.info = "info".capitalized
        self.leaveANoteForTheStore = "leave A Note For The Store".capitalized
        self.removeItemFromCart = "remove Item From Cart".capitalized
        self.add1ToBasket = "add 1 To Basket".capitalized
        self.update = "update".capitalized
        self.toBasket = " to Basket".capitalized
        self.add = "add".capitalized
        self.yourCartAlreadyContainsAnItemFrom = "your Cart Already Contains An Item From".capitalized
        self.wouldYouLikeToClearTheCartAndAddThisItemFrom = "would You Like To Clear The Cart And Add This Item From".capitalized
        self.instead = "instead".capitalized
        self.startNewBasket = "start New Basket".capitalized
        self.newBasket = "new Basket".capitalized
        self.placeOrder = "place Order".capitalized
        self.yourBasket = "your Basket".capitalized
        self.addANote = "add A Note".capitalized
        self.beginCheckout = "begin Checkout".capitalized
        self.thereIsnTAnythingInYourBasket = "there isn't Anything In Your Basket".capitalized
        self.keepBrowsing = "keep Browsing".capitalized
        self.subtotal = "subtotal".capitalized
        self.deliveryFee = "delivery Fee".capitalized
        self.pleaseSelectAnotherItem = "please Select Another Item".capitalized
        self.anItemYouSelected = "an Item You Selected".capitalized
        self.isNoLongerAvailablePleaseTrySomethingEquallyDelicious = "is No Longer Available Please Try Something Equally Delicious".capitalized
        self.browse = "browse".capitalized
        self.deliveringToYourDoor = "delivering To Your Door".capitalized
        self.addADeliveryNote = "add A Delivery Note".capitalized
        self.store = "store".capitalized
        self.addPromoCode = "add Promo Code".capitalized
        self.cash = "cash".capitalized
        self.apple_pay = "Apple Pay".capitalized
        self.createAnAccountOrSignInToAddAPromoCode = "create An Account Or Sign In To Add A Promo Code".capitalized
        self.ifYouHaveAn = "if You Have An".capitalized
        self.promoCodeEnterItAndSaveOnYourOrder = "promo Code Enter It And Save On Your Order".capitalized
        self.enterPromoCode = "enter Promo Code".capitalized
        self.apply = "apply".capitalized
        self.promotions = "promotions".capitalized
        self.freeUpto = "free Upto".capitalized
        self.on = "on".capitalized
        self.expiredOn = "expired On".capitalized
        self.off = "off".capitalized
        self.search = "search".capitalized
        self.restaurantOrDishName = "restaurant Or Dish Name".capitalized
        self.topCategories = "top Categories".capitalized
        self.moreCategories = "more Categories".capitalized
        self.addPayment = "add Payment".capitalized
        self.addCreditOrDebitCard = "add Credit Or Debit Card".capitalized
        self.wallet = "wallet".capitalized
        self.youDonTHaveAnyFavouritesYet = "you Don't Have Any Favourites Yet".capitalized
        self.remove = "remove".capitalized
        self.yourFavourites = "your Favourites".capitalized
        self.notes = "notes".capitalized
        self.noOrdersYet = "no Orders Yet".capitalized
        self.appliedPenalty = "applied Penalty".capitalized
        self.viewMenu = "view Menu".capitalized
        self.rateOrder = "rate Order".capitalized
        self.viewReceipt = "view Receipt".capitalized
        self.editAccount = "edit Account".capitalized
        self.selectAPhoto = "select A Photo".capitalized
        self.takePhoto = "take Photo".capitalized
        self.chooseFromLibrary = "choose From Library".capitalized
        self.home = "home".capitalized
        self.work = "work".capitalized
        self.addHome = "add Home".capitalized
        self.addWork = "add Work".capitalized
        self.signOut = "sign Out".capitalized
        self.savedPlaces = "saved Places".capitalized
        self.enterAmount = "enter Amount".capitalized
        self.addCard = "add Card".capitalized
        self.change = "change".capitalized
        self.yourWalletAmountIs = "your Wallet Amount Is".capitalized
        self.addAmount = "add Amount".capitalized
        self.pleaseEnterTheCardDetails = "please Enter The Card Details".capitalized
        self.noResultsFound = "no Results Found".capitalized
        self.recommended = "recommended".capitalized
        self.mostPopular = "most Popular".capitalized
        self.rating = "rating".capitalized
        self.deliveryTime = "delivery Time".capitalized
        self.allRestaurants = "all Restaurants".capitalized
        self.restaurants = "restaurants".capitalized
        self.weDidnTFindAMatchFor = "we Didn't Find A Match For".capitalized
        self.trySearchingForSomethingElseInstead = "try Searching For Something Else Instead".capitalized
        self.payment = "payment".capitalized
        self.termsAndCondition = "terms And Condition".capitalized
        self.guest = "guest".capitalized
        self.submit = "submit".capitalized
        self.rateYourOrder = "rate Your Order".capitalized
        self.orderId = "order Id".capitalized
        self.howWasIt = "how Was It".capitalized
        self.howWasTheDelivery = "how Was The Delivery".capitalized
        self.ohGreat = "oh Great".capitalized
        self.ohNoWhatWentWrong = "oh No What Went Wrong".capitalized
        self.addAComment = "add A Comment".capitalized
        self.pleaseGiveFeedback = "please Give Feedback".capitalized
        self.noUpcomingOrders = "no Upcoming Orders".capitalized
        self.estimationArrival = "estimation Arrival".capitalized
        self.track = "track".capitalized
        self.yourOrderIsPreparing = "your Order Is Preparing".capitalized
        self.estimatedArrival = "estimated Arrival".capitalized
        self.preparingYourOrder = "preparing Your Order".capitalized
        self.upcoming = "upcoming".capitalized
        self.pastOrders = "past Orders".capitalized
        self.viewBasket = "view Basket".capitalized
        self.specialInstructions = "special Instructions".capitalized
        self.promoCode = "promo Code".capitalized
        self.ok = "ok".capitalized
        self.soldOut = "sold Out".capitalized
        self.reset = "reset".capitalized
        self.weAreHavingTroubleFetchingTheMenuPleaseTryAgain = "we Are Having Trouble Fetching The Menu Please Try Again".capitalized
        self.favouriteRestaurant = "favourite Restaurant".capitalized
        self.popularRestaurant = "popular Restaurant".capitalized
        self.newRestaurant = "new Restaurant".capitalized
        self.underRestaurant = "under Restaurant".capitalized
        self.nowUse = "now Use".capitalized
        self.language = "language".capitalized
        self.choose = "choose".capitalized
        self.first = "first".capitalized
        self.last = "last".capitalized
        self.error = "error".capitalized
        self.kindlyEnableCameraAccessByClickingSettingsForUploadProfilePicture = "kindly Enable Camera Access By Clicking Settings For Upload Profile Picture".capitalized
        self.driver = "driver".capitalized
        self.call = "call".capitalized
        self.message = "message".capitalized
        self.contact = "contact".capitalized
        self.pleaseSaveYourLocation = "please Save Your Location".capitalized
        self.pleaseTryAgain = "please Try Again".capitalized
        self.setupCancelledTryAgain = "setup Cancelled Try Again".capitalized
        self.hour = "hour".capitalized
        self.hours = "hours".capitalized
        self.orderPlacedAt = "order Placed At".capitalized
        self.orderScheduledAt = "order Scheduled At".capitalized
        self.currency = "currency".capitalized
        self.register = "register".capitalized
        self.orConnectWithSocialAccount = "or Connect With Social Account".capitalized
        self.loginWith = "login With".capitalized
        self.clientNotInitialized = "client Not Initialized".capitalized
        self.cancelled = "cancelled".capitalized
        self.pleaseSelectAPaymentOption = "please Select A Payment Option".capitalized
        self.english = "english".capitalized
        self.delivery = "delivery".capitalized
        self.takeAway = "take Away".capitalized
        self.both = "both".capitalized
        self.addTips = "add Tips".capitalized
        self.editTips = "edit Tips".capitalized
        self.chooseAnAccount = "choose An Account".capitalized
        self.signinWithFacebook = "signin With Facebook".capitalized
        self.signinWithGoogle = "signin With Google".capitalized
        self.invalidCode = "invalid Code".capitalized
        self.theDeliveryTypeDoesnTSupportForThisStore = "the Delivery Type Doesn't Support For This Store".capitalized
        self.setTip = "set Tip".capitalized
        self.confirmingOrderWithStore = "confirming Order With Store".capitalized
        self.orderCancelled = "order Cancelled".capitalized
        self.orderDeclined = "order Declined".capitalized
        self.orderDelivered = "order Delivered".capitalized
        self.takeaway = "takeaway".capitalized
        self.opensAt = "opens At".capitalized
        self.promoRemovedSuccessfully = "promo Removed Successfully".capitalized
        self.logInText = "logIn".capitalized
        self.password = "password".capitalized
        self.forgotPassword = "forgot Password".capitalized
        self.lastName = "last Name".capitalized
        self.email = "email".capitalized
        self.mobile = "mobile".capitalized
        self.alreadyHaveAnAccount = "already Have An Account".capitalized
        self.validMobileNumber = "enter valid Mobile Number".capitalized
        self.siginTerms1 = "sigin Terms 1".capitalized
        self.siginTerms2 = "sigin Terms 2".capitalized
        self.errorMsgEmail = "Enter Email".capitalized
        self.errorMsgPassword = "Enter Password".capitalized
        self.errorMsgFirstname = "Enter Firsttname".capitalized
        self.errorMsgLastname = "Enter Lastname".capitalized
        self.signApple = "signin Apple".capitalized
        self.orders = "orders".capitalized
        self.profile = "profile".capitalized
        self.termsAndConditions = "terms And Conditions".capitalized
        self.paymentOption = "payment Option".capitalized
        self.paymentMethods = "payment Methods".capitalized
        self.networkFailure = "network Failure".capitalized
        self.selectcurrency = "select currency".capitalized
        self.enterThe4Digit = "enter The Four Digit Code Sent To You At".capitalized
        self.clearCartTitle = "clear Cart Title".capitalized
        self.clearCartMsg = "clear Cart Msg".capitalized
        self.resendCode = "resend Code".capitalized
        self.confirmYourPassword = "confirm Your Password".capitalized
        self.retry = "retry".capitalized
        self.PasswordMismatch = "Password Mismatch".capitalized
        self.InValidPassword = "In Valid Password".capitalized
        self.otpEmpty = "enter The Four Digit Code Sent To You At".capitalized
        self.signoutMsg = "Are You Sure You Want to logout".capitalized
        self.specialDiscount = "special Discount ".capitalized
        self.help = "help".capitalized
        self.deliverWithGofer = "deliver With Gofer".capitalized
        self.about = "about".capitalized
        self.searchRestaurant = "search Restaurant".capitalized
        self.account = "account".capitalized
        self.edit = "edit".capitalized
        self.accountInformation = "account Information".capitalized
        self.youHaveNoFavourtiesList = "you Have No Favourties List".capitalized
        self.recentlyAdded = "recently Added".capitalized
        self.removeSelected = "remove Selected".capitalized
        self.useWallet = "use Wallet".capitalized
        self.descriptCash = "descript Cash".capitalized
        self.under20Minutes = "under 20 Minutes".capitalized
        self.newToGoferEats = "new To Gofer Eats".capitalized
        self.popularNearYou = "popular Near You".capitalized
        self.seeMoreRestaurants = "see More Restaurants".capitalized
        self.addANoteExtraSauceNoOnionsEtc = "add A Note Extra Sauce No Onions Etc".capitalized
        self.yourOrder = "your Order".capitalized
        self.peopleWhoOrderedThisItemAlsoOrdered = "people Who Ordered This Item Also Ordered".capitalized
        self.tax = "tax".capitalized
        self.total = "total".capitalized
        self.searchForRestaurantOrDish = "search For Restaurant Or Dish".capitalized
        self.vegan = "vegan".capitalized
        self.mins = "mins".capitalized
        self.scheduleDate = "schedule Date".capitalized
        self.setTime = "set Time".capitalized
        self.otpMismatch = "otp Mismatch".capitalized
        self.enablePermission = "enable Permission".capitalized
        self.restaurant = "restaurant".capitalized
        self.promoApplied = "promo Applied".capitalized
        self.nodatafound = "no data found".capitalized
        self.noUpcomingOrder = "no Upcoming Order".capitalized
        self.rate = "rate".capitalized
        self.navigate = "navigate".capitalized
        self.pleaseEnablePermissions = "please Enable Permissions".capitalized
        self.pleaseEnableLocation = "please Enable Location".capitalized
        self.discount = "discount".capitalized
        self.noItemCart = "no Item Cart".capitalized
        self.addMoney = "add Money".capitalized
        self.enterWalletAmount = "enter Wallet Amount".capitalized
        self.walletAmount = "wallet Amount".capitalized
        self.checkOut = "checkOut".capitalized
        self.history = "history".capitalized
        self.FoodStatusDoor = "Food Status Door".capitalized
        self.totalAmount = "total Amount".capitalized
        self.orderIdSymbol = "order Id Symbol".capitalized
        self.editTheDeliveryNote = "edit The Delivery Note".capitalized
        self.asapAsSoonAsPossible = "asap As Soon As Possible".capitalized
        self.deliveredToYou = "delivered To You".capitalized
        self.changePromoCode = "change Promo Code".capitalized
        self.minNeta = "min Neta".capitalized
        self.locationError = "location Error".capitalized
        self.clearandchange = "clearand change".capitalized
        self.locationError1 = "Failed to Locate".capitalized
        self.scheduleOrder = "schedule Order".capitalized
        self.continueWithOrder = "continue With Order".capitalized
        self.hintApartment = "Appartemnt 15c".capitalized
        self.removeItemFromBasket = "remove Item From Basket".capitalized
        self.ReadyToMeet = "Ready To Meet".capitalized
        self.outside = "outside".capitalized
        self.title1 = "title 1".capitalized
        self.msg1 = "msg".capitalized
        self.msgfirsthalf = "msg first half".capitalized
        self.msg2half = "msg 2 half".capitalized
        self.removeMenus = "remove Menus".capitalized
        self.removeMenu = "remove Menu".capitalized
        self.clearAllBasket = "clear All Basket".capitalized
        self.gettingOrderDetails = "getting Order Details ".capitalized
        self.gettingRestaurants = "getting Restaurants".capitalized
        self.exit = "exit".capitalized
        self.whatCouldBetter = "what Could Better".capitalized
        self.selectLang = "select Language".capitalized
        self.loginError1 = "login Error 1".capitalized
        self.loginError2 = "login Error 2".capitalized
        self.loginError3 = "login Error 3".capitalized
        self.changeLanguage = "change Language".capitalized
        self.changeCurrency = "change Currency".capitalized
        self.deliveringTo = "delivering To".capitalized
        self.loading = "loading".capitalized
        self.profileUpload = "profile Upload".capitalized
        self.imageUpload = "image Upload".capitalized
        self.chooseGallery = "choose Gallery".capitalized
        self.addPhoto = "add Photo".capitalized
        self.offOn = "off on".capitalized
        self.offon = "off on".capitalized
        self.offPer = "off Per".capitalized
        self.mobileAlreadyEntered = "mobile Already Entered".capitalized
        self.successMobileNumber = "success Mobile Number".capitalized
        self.noLocation = "no Location".capitalized
        self.alert = "alert".capitalized
        self.locationRemoved = "location Removed".capitalized
        self.enterLocation = "enter Locationt".capitalized
        self.required = "required".capitalized
        self.requiredChooseUpto = "required Choose Upto".capitalized
        self.requiredChoose = "required Choose".capitalized
        self.to = "To".capitalized
        self.chooseUpto = "choose Upto".capitalized
        self.chooseTo = "choose To".capitalized
        self.onlinepayment = "online payment".capitalized
        self.pay = "pay".capitalized
        self.paymentcompleted = "payment completed".capitalized
        self.seeMore = "see More".capitalized
        self.stripeError1 = "stripe Payment Failed".capitalized
        self.stripeError2 = "stripe Payment Failed".capitalized
        self.paymentFailed = "payment Failed".capitalized
        self.addTipAmt = "add Tip Amt".capitalized
        self.yourTripAmoutWas = "your Trip Amout Was".capitalized
        self.enterTip = "enter Tip".capitalized
        self.tips = "tips".capitalized
        self.errorTipsAmt = "Please Enter Tips".capitalized
        self.chooseMap = "choose Map".capitalized
        self.googleMap = "google Map".capitalized
        self.wazeMap = "waze Map".capitalized
        self.googleMapNotFoundInDevice = "google Map Not Found In Device".capitalized
        self.wazeGoogleMapNotFoundInDevice = "waze Google Map Not Found In Device".capitalized
        self.paypal = "paypal".capitalized
        self.payForOrdersWithCash = "pay For Orders With Cash".capitalized
        self.menu = "menu".capitalized
        self.facebook = "facebook".capitalized
        self.google = "google".capitalized
        self.bookingFee = "booking Fee".capitalized
        self.pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem = "please Install Waze Maps App Then Only You Get The Direction For This Item".capitalized
        self.seeAll = "see All".capitalized
        self.pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem = "please Install Google Maps App Then Only You Get The Direction For This Item".capitalized
        self.new = "New".capitalized
        self.tappedOn = "tapped On".capitalized
        self.userTappedOnConditionText = "user Tapped On Condition Text".capitalized
        self.iConfirmThatIHaveReadAndAgreedToThe = "i Confirm That I Have Read And Agreed To The".capitalized
        self.selectPaymentMethod = "select Payment Method".capitalized
        self.hereYouCanChangeYourMap = "here You Can Change Your Map".capitalized
        self.byClickingBelowActions = "by Clicking Below Actions".capitalized
        self.doYouWantToAccessDirection = "do You Want To Access Direction".capitalized
        self.or = "or".capitalized
        self.name = "name".capitalized
        self.all = "all".capitalized
        self.s = "s".capitalized
        self.and = "and".capitalized
        self.layoutDirection = "layout Direction".capitalized
        self.layoutDirectionRl = "layout Direction Rl".capitalized
        self.loginWithApp = "login With App".capitalized
        self.pick = "pick".capitalized
        self.upTo = "upTo".capitalized
        self.tipsAmountUpdatedSuccessfully = "tips Amount Updated Successfully".capitalized
        self.support = "support".capitalized
        self.appName = "Gofer Delivery All".capitalized
        self.submitDocToVerify18Plus = "please_submit_your_document_to_verify_you_are_18"
        self.tapToAdd = "taptoadd"
        self.eighteenPlusVerification = "_18_verification"
        self.waitingForAdmin = "waiting_for_admin_approval"
        self.verification = "verfication"
        self.plsUploadIDProof = "upload_image"
        
        self.contactLessDelivery = "contactless_delivery"
        self.contactLessDeliveryInfo = "contactless_delivery_info"
        self.offers = "offers"
        self.viewOffers = "view_offers"
        self.receiptUpload = "receipt_upload"
        self.receiptImage = "receipt_image"
        self.choosePayment = "choose_payment"
        self.orderImg = "order_images"
        self.view = "view"
        self.yourReceipt = "your_receipt"
        self.followBestSafetyStds = "follows_best_safety_standards"
        self.packageDeliveryImage = "package_delivered_image"
        self.followsBestSafetyStandard = ""
        self.pleaseUploadReceiptImageOfYourOrder = ""
        self.pleaseEnterTipsAmount = ""
        self.chooseAnotherPayment = ""
        self.followWhoSafetyPractices = ""
        self.nonVegetarian = "non_vegetarian".capitalized
        self.estimatedPickup = ""
        self.orderPlacedSuccessfully = ""
        self.allStores = ""
        self.expiresOn = "Expires on"
    }
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderDetails = container.safeDecodeValue(forKey: .orderDetails)
        self.confirmOrder = container.safeDecodeValue(forKey: .confirmOrder)
        self.confirmOrderWithStore = container.safeDecodeValue(forKey: .confirmOrderWithStore)
        self.getStartedWith = container.safeDecodeValue(forKey: .getStartedWith)
        self.enterMobileNumber = container.safeDecodeValue(forKey: .enterMobileNumber)
        self.skipForNow = container.safeDecodeValue(forKey: .skipForNow)
        self.enterYourMobileNumber = container.safeDecodeValue(forKey: .enterYourMobileNumber)
        self.theMobileNumberYouEnteredIsInvalid = container.safeDecodeValue(forKey: .theMobileNumberYouEnteredIsInvalid)
        self.next = container.safeDecodeValue(forKey: .next)
        self.updateYourPhoneNumber = container.safeDecodeValue(forKey: .updateYourPhoneNumber)
        self.resetPassword = container.safeDecodeValue(forKey: .resetPassword)
        self.updatePhoneNumber = container.safeDecodeValue(forKey: .updatePhoneNumber)
        self.alreadyYouHaveAnAccountpleaseLogin = container.safeDecodeValue(forKey: .alreadyYouHaveAnAccountpleaseLogin)
        self.enterTheFourDigitCodeSentToYouAt = container.safeDecodeValue(forKey: .enterTheFourDigitCodeSentToYouAt)
        self.resendCodeIn = container.safeDecodeValue(forKey: .resendCodeIn)
        self.iDidnTReceiveACode = container.safeDecodeValue(forKey: .iDidnTReceiveACode)
        self.didYouEnterTheCorrectMobileNumber = container.safeDecodeValue(forKey: .didYouEnterTheCorrectMobileNumber)
        self.resendTo = container.safeDecodeValue(forKey: .resendTo)
        self.pleaseEnterOtp = container.safeDecodeValue(forKey: .pleaseEnterOtp)
        self.yourOtpIsNotMatchedPleaseTryAgain = container.safeDecodeValue(forKey: .yourOtpIsNotMatchedPleaseTryAgain)
        self.yourOtpIsMatched = container.safeDecodeValue(forKey: .yourOtpIsMatched)
        self.cancel = container.safeDecodeValue(forKey: .cancel)
        self.resendCodeViaSms = container.safeDecodeValue(forKey: .resendCodeViaSms)
        self.howWouldYouLikeToReceiveYourCode = container.safeDecodeValue(forKey: .howWouldYouLikeToReceiveYourCode)
        self.whatsYourEmailAddress = container.safeDecodeValue(forKey: .whatsYourEmailAddress)
        self.nameexamplecom = container.safeDecodeValue(forKey: .nameexamplecom)
        self.createYourAccountPassword = container.safeDecodeValue(forKey: .createYourAccountPassword)
        self.minimum6Characters = container.safeDecodeValue(forKey: .minimum6Characters)
        self.whatsYourName = container.safeDecodeValue(forKey: .whatsYourName)
        self.byContinuingYouAgreeToThe = container.safeDecodeValue(forKey: .byContinuingYouAgreeToThe)
        self.termsOfUse = container.safeDecodeValue(forKey: .termsOfUse)
        self.privacyPolicy = container.safeDecodeValue(forKey: .privacyPolicy)
        self.updateYourFirstName = container.safeDecodeValue(forKey: .updateYourFirstName)
        self.firstName = container.safeDecodeValue(forKey: .firstName)
        self.updateFirstName = container.safeDecodeValue(forKey: .updateFirstName)
        self.updateYourSurname = container.safeDecodeValue(forKey: .updateYourSurname)
        self.surname = container.safeDecodeValue(forKey: .surname)
        self.updateSurname = container.safeDecodeValue(forKey: .updateSurname)
        self.updateYourEmailAddress = container.safeDecodeValue(forKey: .updateYourEmailAddress)
        self.updateEmailAddress = container.safeDecodeValue(forKey: .updateEmailAddress)
        self.welcomeBack = container.safeDecodeValue(forKey: .welcomeBack)
        self.enterYourPasswordToContinue = container.safeDecodeValue(forKey: .enterYourPasswordToContinue)
        self.enterYourPassword = container.safeDecodeValue(forKey: .enterYourPassword)
        self.login = container.safeDecodeValue(forKey: .login)
        self.save = container.safeDecodeValue(forKey: .save)
        self.theEmailYouEnteredIsInvalid = container.safeDecodeValue(forKey: .theEmailYouEnteredIsInvalid)
        self.passwordsMustBeAtLeast6Characters = container.safeDecodeValue(forKey: .passwordsMustBeAtLeast6Characters)
        self.passwordCredentialsIsNotMatchpleaseTryAgain = container.safeDecodeValue(forKey: .passwordCredentialsIsNotMatchpleaseTryAgain)
        self.iForgotMyPassword = container.safeDecodeValue(forKey: .iForgotMyPassword)
        self.currentLocation = container.safeDecodeValue(forKey: .currentLocation)
        self.gettingAddress = container.safeDecodeValue(forKey: .gettingAddress)
        self.failedToGettingYourCurrentAddresss = container.safeDecodeValue(forKey: .failedToGettingYourCurrentAddresss)
        self.deliveryDetails = container.safeDecodeValue(forKey: .deliveryDetails)
        self.needAuthorization = container.safeDecodeValue(forKey: .needAuthorization)
        self.pleaseEnableLocationServicesToUseYourCurrentLocation = container.safeDecodeValue(forKey: .pleaseEnableLocationServicesToUseYourCurrentLocation)
        self.settings = container.safeDecodeValue(forKey: .settings)
        self.done = container.safeDecodeValue(forKey: .done)
        self.asap = container.safeDecodeValue(forKey: .asap)
        self.meetAtVehicle = container.safeDecodeValue(forKey: .meetAtVehicle)
        self.doorToDelivery = container.safeDecodeValue(forKey: .doorToDelivery)
        self.deliverToDoor = container.safeDecodeValue(forKey: .deliverToDoor)
        self.when = container.safeDecodeValue(forKey: .when)
        self.asSoonAsPossible = container.safeDecodeValue(forKey: .asSoonAsPossible)
        self.scheduleAnOrder = container.safeDecodeValue(forKey: .scheduleAnOrder)
        self.enterANewAddress = container.safeDecodeValue(forKey: .enterANewAddress)
        self.deliveryOptions = container.safeDecodeValue(forKey: .deliveryOptions)
        self.deliveryToDoor = container.safeDecodeValue(forKey: .deliveryToDoor)
        self.aptsuitefloor = container.safeDecodeValue(forKey: .aptsuitefloor)
        self.businessName = container.safeDecodeValue(forKey: .businessName)
        self.pickUpOutside = container.safeDecodeValue(forKey: .pickUpOutside)
        self.addDeliveryNote = container.safeDecodeValue(forKey: .addDeliveryNote)
        self.removeSavedAddress = container.safeDecodeValue(forKey: .removeSavedAddress)
        self.removeThisLocation = container.safeDecodeValue(forKey: .removeThisLocation)
        self.yes = container.safeDecodeValue(forKey: .yes)
        self.no = container.safeDecodeValue(forKey: .no)
        self.unableToDeliverItems = container.safeDecodeValue(forKey: .unableToDeliverItems)
        self.theItemsInYourCartCanTBeDeliveredToYourNewAddress = container.safeDecodeValue(forKey: .theItemsInYourCartCanTBeDeliveredToYourNewAddress)
        self.clearCart = container.safeDecodeValue(forKey: .clearCart)
        self.tooFarAway = container.safeDecodeValue(forKey: .tooFarAway)
        self.close = container.safeDecodeValue(forKey: .close)
        self.viewSimilar = container.safeDecodeValue(forKey: .viewSimilar)
        self.finished = container.safeDecodeValue(forKey: .finished)
        self.continueWithYourPreviousOrder = container.safeDecodeValue(forKey: .continueWithYourPreviousOrder)
        self.youStillHaveItemsInYourBasketFrom = container.safeDecodeValue(forKey: .youStillHaveItemsInYourBasketFrom)
        self.continues = container.safeDecodeValue(forKey: .continues)
        self.scheduleDeliveryTime = container.safeDecodeValue(forKey: .scheduleDeliveryTime)
        self.setDeliveryTime = container.safeDecodeValue(forKey: .setDeliveryTime)
        self.orderReceipt = container.safeDecodeValue(forKey: .orderReceipt)
        self.today = container.safeDecodeValue(forKey: .today)
        self.tommorow = container.safeDecodeValue(forKey: .tommorow)
        self.enterYourNote = container.safeDecodeValue(forKey: .enterYourNote)
        self.totalAmountApi = container.safeDecodeValue(forKey: .totalAmountApi)
        self.totalApi = container.safeDecodeValue(forKey: .totalApi)
        self.walletAmountApi = container.safeDecodeValue(forKey: .walletAmountApi)
        self.promoAmount = container.safeDecodeValue(forKey: .promoAmount)
        self.penalty = container.safeDecodeValue(forKey: .penalty)
        self.selectReason = container.safeDecodeValue(forKey: .selectReason)
        self.otherReasons = container.safeDecodeValue(forKey: .otherReasons)
        self.cancelOrder = container.safeDecodeValue(forKey: .cancelOrder)
        self.browseOrSearch = container.safeDecodeValue(forKey: .browseOrSearch)
        self.seeAllRestaurants = container.safeDecodeValue(forKey: .seeAllRestaurants)
        self.closed = container.safeDecodeValue(forKey: .closed)
        self.currentlyUnavailable = container.safeDecodeValue(forKey: .currentlyUnavailable)
        self.underStoreApi = container.safeDecodeValue(forKey: .underStoreApi)
        self.under = container.safeDecodeValue(forKey: .under)
        self.minutes = container.safeDecodeValue(forKey: .minutes)
        self.moreRestaurant = container.safeDecodeValue(forKey: .moreRestaurant)
        self.noMatches = container.safeDecodeValue(forKey: .noMatches)
        self.tryBroadeningYourSearch = container.safeDecodeValue(forKey: .tryBroadeningYourSearch)
        self.sort = container.safeDecodeValue(forKey: .sort)
        self.price = container.safeDecodeValue(forKey: .price)
        self.dietary = container.safeDecodeValue(forKey: .dietary)
        self.filter = container.safeDecodeValue(forKey: .filter)
        self.priceRange = container.safeDecodeValue(forKey: .priceRange)
        self.changeMenu = container.safeDecodeValue(forKey: .changeMenu)
        self.vegetarian = container.safeDecodeValue(forKey: .vegetarian)
        self.viewInfo = container.safeDecodeValue(forKey: .viewInfo)
        self.locationAndHours = container.safeDecodeValue(forKey: .locationAndHours)
        self.info = container.safeDecodeValue(forKey: .info)
        self.leaveANoteForTheStore = container.safeDecodeValue(forKey: .leaveANoteForTheStore)
        self.removeItemFromCart = container.safeDecodeValue(forKey: .removeItemFromCart)
        self.add1ToBasket = container.safeDecodeValue(forKey: .add1ToBasket)
        self.update = container.safeDecodeValue(forKey: .update)
        self.toBasket = container.safeDecodeValue(forKey: .toBasket)
        self.add = container.safeDecodeValue(forKey: .add)
        self.yourCartAlreadyContainsAnItemFrom = container.safeDecodeValue(forKey: .yourCartAlreadyContainsAnItemFrom)
        self.wouldYouLikeToClearTheCartAndAddThisItemFrom = container.safeDecodeValue(forKey: .wouldYouLikeToClearTheCartAndAddThisItemFrom)
        self.instead = container.safeDecodeValue(forKey: .instead)
        self.startNewBasket = container.safeDecodeValue(forKey: .startNewBasket)
        self.newBasket = container.safeDecodeValue(forKey: .newBasket)
        self.placeOrder = container.safeDecodeValue(forKey: .placeOrder)
        self.yourBasket = container.safeDecodeValue(forKey: .yourBasket)
        self.addANote = container.safeDecodeValue(forKey: .addANote)
        self.beginCheckout = container.safeDecodeValue(forKey: .beginCheckout)
        self.thereIsnTAnythingInYourBasket = container.safeDecodeValue(forKey: .thereIsnTAnythingInYourBasket)
        self.keepBrowsing = container.safeDecodeValue(forKey: .keepBrowsing)
        self.subtotal = container.safeDecodeValue(forKey: .subtotal)
        self.deliveryFee = container.safeDecodeValue(forKey: .deliveryFee)
        self.pleaseSelectAnotherItem = container.safeDecodeValue(forKey: .pleaseSelectAnotherItem)
        self.anItemYouSelected = container.safeDecodeValue(forKey: .anItemYouSelected)
        self.isNoLongerAvailablePleaseTrySomethingEquallyDelicious = container.safeDecodeValue(forKey: .isNoLongerAvailablePleaseTrySomethingEquallyDelicious)
        self.browse = container.safeDecodeValue(forKey: .browse)
        self.deliveringToYourDoor = container.safeDecodeValue(forKey: .deliveringToYourDoor)
        self.addADeliveryNote = container.safeDecodeValue(forKey: .addADeliveryNote)
        self.store = container.safeDecodeValue(forKey: .store)
        self.addPromoCode = container.safeDecodeValue(forKey: .addPromoCode)
        self.cash = container.safeDecodeValue(forKey: .cash)
        self.apple_pay = container.safeDecodeValue(forKey: .apple_pay)
        self.createAnAccountOrSignInToAddAPromoCode = container.safeDecodeValue(forKey: .createAnAccountOrSignInToAddAPromoCode)
        self.ifYouHaveAn = container.safeDecodeValue(forKey: .ifYouHaveAn)
        self.promoCodeEnterItAndSaveOnYourOrder = container.safeDecodeValue(forKey: .promoCodeEnterItAndSaveOnYourOrder)
        self.enterPromoCode = container.safeDecodeValue(forKey: .enterPromoCode)
        self.apply = container.safeDecodeValue(forKey: .apply)
        self.promotions = container.safeDecodeValue(forKey: .promotions)
        self.freeUpto = container.safeDecodeValue(forKey: .freeUpto)
        self.on = container.safeDecodeValue(forKey: .on)
        self.expiredOn = container.safeDecodeValue(forKey: .expiredOn)
        self.off = container.safeDecodeValue(forKey: .off)
        self.search = container.safeDecodeValue(forKey: .search)
        self.restaurantOrDishName = container.safeDecodeValue(forKey: .restaurantOrDishName)
        self.topCategories = container.safeDecodeValue(forKey: .topCategories)
        self.moreCategories = container.safeDecodeValue(forKey: .moreCategories)
        self.addPayment = container.safeDecodeValue(forKey: .addPayment)
        self.addCreditOrDebitCard = container.safeDecodeValue(forKey: .addCreditOrDebitCard)
        self.wallet = container.safeDecodeValue(forKey: .wallet)
        self.youDonTHaveAnyFavouritesYet = container.safeDecodeValue(forKey: .youDonTHaveAnyFavouritesYet)
        self.remove = container.safeDecodeValue(forKey: .remove)
        self.yourFavourites = container.safeDecodeValue(forKey: .yourFavourites)
        self.notes = container.safeDecodeValue(forKey: .notes)
        self.noOrdersYet = container.safeDecodeValue(forKey: .noOrdersYet)
        self.appliedPenalty = container.safeDecodeValue(forKey: .appliedPenalty)
        self.viewMenu = container.safeDecodeValue(forKey: .viewMenu)
        self.rateOrder = container.safeDecodeValue(forKey: .rateOrder)
        self.viewReceipt = container.safeDecodeValue(forKey: .viewReceipt)
        self.editAccount = container.safeDecodeValue(forKey: .editAccount)
        self.selectAPhoto = container.safeDecodeValue(forKey: .selectAPhoto)
        self.takePhoto = container.safeDecodeValue(forKey: .takePhoto)
        self.chooseFromLibrary = container.safeDecodeValue(forKey: .chooseFromLibrary)
        self.home = container.safeDecodeValue(forKey: .home)
        self.work = container.safeDecodeValue(forKey: .work)
        self.addHome = container.safeDecodeValue(forKey: .addHome)
        self.addWork = container.safeDecodeValue(forKey: .addWork)
        self.signOut = container.safeDecodeValue(forKey: .signOut)
        self.savedPlaces = container.safeDecodeValue(forKey: .savedPlaces)
        self.enterAmount = container.safeDecodeValue(forKey: .enterAmount)
        self.addCard = container.safeDecodeValue(forKey: .addCard)
        self.change = container.safeDecodeValue(forKey: .change)
        self.yourWalletAmountIs = container.safeDecodeValue(forKey: .yourWalletAmountIs)
        self.addAmount = container.safeDecodeValue(forKey: .addAmount)
        self.pleaseEnterTheCardDetails = container.safeDecodeValue(forKey: .pleaseEnterTheCardDetails)
        self.noResultsFound = container.safeDecodeValue(forKey: .noResultsFound)
        self.recommended = container.safeDecodeValue(forKey: .recommended)
        self.mostPopular = container.safeDecodeValue(forKey: .mostPopular)
        self.rating = container.safeDecodeValue(forKey: .rating)
        self.deliveryTime = container.safeDecodeValue(forKey: .deliveryTime)
        self.allRestaurants = container.safeDecodeValue(forKey: .allRestaurants)
        self.restaurants = container.safeDecodeValue(forKey: .restaurants)
        self.weDidnTFindAMatchFor = container.safeDecodeValue(forKey: .weDidnTFindAMatchFor)
        self.trySearchingForSomethingElseInstead = container.safeDecodeValue(forKey: .trySearchingForSomethingElseInstead)
        self.payment = container.safeDecodeValue(forKey: .payment)
        self.termsAndCondition = container.safeDecodeValue(forKey: .termsAndCondition)
        self.guest = container.safeDecodeValue(forKey: .guest)
        self.submit = container.safeDecodeValue(forKey: .submit)
        self.rateYourOrder = container.safeDecodeValue(forKey: .rateYourOrder)
        self.orderId = container.safeDecodeValue(forKey: .orderId)
        self.howWasIt = container.safeDecodeValue(forKey: .howWasIt)
        self.howWasTheDelivery = container.safeDecodeValue(forKey: .howWasTheDelivery)
        self.ohGreat = container.safeDecodeValue(forKey: .ohGreat)
        self.ohNoWhatWentWrong = container.safeDecodeValue(forKey: .ohNoWhatWentWrong)
        self.addAComment = container.safeDecodeValue(forKey: .addAComment)
        self.pleaseGiveFeedback = container.safeDecodeValue(forKey: .pleaseGiveFeedback)
        self.noUpcomingOrders = container.safeDecodeValue(forKey: .noUpcomingOrders)
        self.estimationArrival = container.safeDecodeValue(forKey: .estimationArrival)
        self.track = container.safeDecodeValue(forKey: .track)
        self.yourOrderIsPreparing = container.safeDecodeValue(forKey: .yourOrderIsPreparing)
        self.estimatedArrival = container.safeDecodeValue(forKey: .estimatedArrival)
        self.preparingYourOrder = container.safeDecodeValue(forKey: .preparingYourOrder)
        self.upcoming = container.safeDecodeValue(forKey: .upcoming)
        self.pastOrders = container.safeDecodeValue(forKey: .pastOrders)
        self.viewBasket = container.safeDecodeValue(forKey: .viewBasket)
        self.specialInstructions = container.safeDecodeValue(forKey: .specialInstructions)
        self.promoCode = container.safeDecodeValue(forKey: .promoCode)
        self.ok = container.safeDecodeValue(forKey: .ok)
        self.soldOut = container.safeDecodeValue(forKey: .soldOut)
        self.reset = container.safeDecodeValue(forKey: .reset)
        self.weAreHavingTroubleFetchingTheMenuPleaseTryAgain = container.safeDecodeValue(forKey: .weAreHavingTroubleFetchingTheMenuPleaseTryAgain)
        self.favouriteRestaurant = container.safeDecodeValue(forKey: .favouriteRestaurant)
        self.popularRestaurant = container.safeDecodeValue(forKey: .popularRestaurant)
        self.newRestaurant = container.safeDecodeValue(forKey: .newRestaurant)
        self.underRestaurant = container.safeDecodeValue(forKey: .underRestaurant)
        self.nowUse = container.safeDecodeValue(forKey: .nowUse)
        self.language = container.safeDecodeValue(forKey: .language)
        self.choose = container.safeDecodeValue(forKey: .choose)
        self.first = container.safeDecodeValue(forKey: .first)
        self.last = container.safeDecodeValue(forKey: .last)
        self.error = container.safeDecodeValue(forKey: .error)
        self.kindlyEnableCameraAccessByClickingSettingsForUploadProfilePicture = container.safeDecodeValue(forKey: .kindlyEnableCameraAccessByClickingSettingsForUploadProfilePicture)
        self.driver = container.safeDecodeValue(forKey: .driver)
        self.call = container.safeDecodeValue(forKey: .call)
        self.message = container.safeDecodeValue(forKey: .message)
        self.contact = container.safeDecodeValue(forKey: .contact)
        self.pleaseSaveYourLocation = container.safeDecodeValue(forKey: .pleaseSaveYourLocation)
        self.pleaseTryAgain = container.safeDecodeValue(forKey: .pleaseTryAgain)
        self.setupCancelledTryAgain = container.safeDecodeValue(forKey: .setupCancelledTryAgain)
        self.hour = container.safeDecodeValue(forKey: .hour)
        self.hours = container.safeDecodeValue(forKey: .hours)
        self.orderPlacedAt = container.safeDecodeValue(forKey: .orderPlacedAt)
        self.orderScheduledAt = container.safeDecodeValue(forKey: .orderScheduledAt)
        self.currency = container.safeDecodeValue(forKey: .currency)
        self.register = container.safeDecodeValue(forKey: .register)
        self.orConnectWithSocialAccount = container.safeDecodeValue(forKey: .orConnectWithSocialAccount)
        self.loginWith = container.safeDecodeValue(forKey: .loginWith)
        self.clientNotInitialized = container.safeDecodeValue(forKey: .clientNotInitialized)
        self.cancelled = container.safeDecodeValue(forKey: .cancelled)
        self.pleaseSelectAPaymentOption = container.safeDecodeValue(forKey: .pleaseSelectAPaymentOption)
        self.english = container.safeDecodeValue(forKey: .english)
        self.delivery = container.safeDecodeValue(forKey: .delivery)
        self.takeAway = container.safeDecodeValue(forKey: .takeAway)
        self.both = container.safeDecodeValue(forKey: .both)
        self.addTips = container.safeDecodeValue(forKey: .addTips)
        self.editTips = container.safeDecodeValue(forKey: .editTips)
        self.chooseAnAccount = container.safeDecodeValue(forKey: .chooseAnAccount)
        self.signinWithFacebook = container.safeDecodeValue(forKey: .signinWithFacebook)
        self.signinWithGoogle = container.safeDecodeValue(forKey: .signinWithGoogle)
        self.invalidCode = container.safeDecodeValue(forKey: .invalidCode)
        self.theDeliveryTypeDoesnTSupportForThisStore = container.safeDecodeValue(forKey: .theDeliveryTypeDoesnTSupportForThisStore)
        self.setTip = container.safeDecodeValue(forKey: .setTip)
        self.confirmingOrderWithStore = container.safeDecodeValue(forKey: .confirmingOrderWithStore)
        self.orderCancelled = container.safeDecodeValue(forKey: .orderCancelled)
        self.orderDeclined = container.safeDecodeValue(forKey: .orderDeclined)
        self.orderDelivered = container.safeDecodeValue(forKey: .orderDelivered)
        self.takeaway = container.safeDecodeValue(forKey: .takeaway)
        self.opensAt = container.safeDecodeValue(forKey: .opensAt)
        self.promoRemovedSuccessfully = container.safeDecodeValue(forKey: .promoRemovedSuccessfully)

        self.logInText = container.safeDecodeValue(forKey: .logInText)
        self.password = container.safeDecodeValue(forKey: .password)
        self.forgotPassword = container.safeDecodeValue(forKey: .forgotPassword)
        self.lastName = container.safeDecodeValue(forKey: .lastName)
        self.email = container.safeDecodeValue(forKey: .email)
        self.mobile = container.safeDecodeValue(forKey: .mobile)
        self.alreadyHaveAnAccount = container.safeDecodeValue(forKey: .alreadyHaveAnAccount)
        self.validMobileNumber = container.safeDecodeValue(forKey: .validMobileNumber)
        self.siginTerms1 = container.safeDecodeValue(forKey: .siginTerms1)
        self.siginTerms2 = container.safeDecodeValue(forKey: .siginTerms2)
        self.errorMsgEmail = container.safeDecodeValue(forKey: .errorMsgEmail)
        self.errorMsgPassword = container.safeDecodeValue(forKey: .errorMsgPassword)
        self.errorMsgFirstname = container.safeDecodeValue(forKey: .errorMsgFirstname)
        self.errorMsgLastname = container.safeDecodeValue(forKey: .errorMsgLastname)
        self.signApple = container.safeDecodeValue(forKey: .signApple)
        self.orders = container.safeDecodeValue(forKey: .orders)
        self.profile = container.safeDecodeValue(forKey: .profile)
        self.termsAndConditions = container.safeDecodeValue(forKey: .termsAndConditions)
        self.paymentOption = container.safeDecodeValue(forKey: .paymentOption)
        self.paymentMethods = container.safeDecodeValue(forKey: .paymentMethods)
        self.networkFailure = container.safeDecodeValue(forKey: .networkFailure)
        self.selectcurrency = container.safeDecodeValue(forKey: .selectcurrency)
        self.enterThe4Digit = container.safeDecodeValue(forKey: .enterThe4Digit)
        self.clearCartTitle = container.safeDecodeValue(forKey: .clearCartTitle)
        self.clearCartMsg = container.safeDecodeValue(forKey: .clearCartMsg)
        self.resendCode = container.safeDecodeValue(forKey: .resendCode)
        self.confirmYourPassword = container.safeDecodeValue(forKey: .confirmYourPassword)
        self.retry = container.safeDecodeValue(forKey: .retry)
        self.PasswordMismatch = container.safeDecodeValue(forKey: .PasswordMismatch)
        self.InValidPassword = container.safeDecodeValue(forKey: .InValidPassword)
        self.otpEmpty = container.safeDecodeValue(forKey: .otpEmpty)
        self.signoutMsg = container.safeDecodeValue(forKey: .signoutMsg)
        self.specialDiscount = container.safeDecodeValue(forKey: .specialDiscount)
        self.help = container.safeDecodeValue(forKey: .help)
        self.deliverWithGofer = container.safeDecodeValue(forKey: .deliverWithGofer)
        self.about = container.safeDecodeValue(forKey: .about)
        self.searchRestaurant = container.safeDecodeValue(forKey: .searchRestaurant)
        self.account = container.safeDecodeValue(forKey: .account)
        self.edit = container.safeDecodeValue(forKey: .edit)
        self.accountInformation = container.safeDecodeValue(forKey: .accountInformation)
        self.youHaveNoFavourtiesList = container.safeDecodeValue(forKey: .youHaveNoFavourtiesList)
        self.recentlyAdded = container.safeDecodeValue(forKey: .recentlyAdded)
        self.removeSelected = container.safeDecodeValue(forKey: .removeSelected)
        self.useWallet = container.safeDecodeValue(forKey: .useWallet)
        self.descriptCash = container.safeDecodeValue(forKey: .descriptCash)
        self.under20Minutes = container.safeDecodeValue(forKey: .under20Minutes)
        self.newToGoferEats = container.safeDecodeValue(forKey: .newToGoferEats)
        self.popularNearYou = container.safeDecodeValue(forKey: .popularNearYou)
        self.seeMoreRestaurants = container.safeDecodeValue(forKey: .seeMoreRestaurants)
        self.addANoteExtraSauceNoOnionsEtc = container.safeDecodeValue(forKey: .addANoteExtraSauceNoOnionsEtc)
        self.yourOrder = container.safeDecodeValue(forKey: .yourOrder)
        self.peopleWhoOrderedThisItemAlsoOrdered = container.safeDecodeValue(forKey: .peopleWhoOrderedThisItemAlsoOrdered)
        self.tax = container.safeDecodeValue(forKey: .tax)
        self.total = container.safeDecodeValue(forKey: .total)
        self.searchForRestaurantOrDish = container.safeDecodeValue(forKey: .searchForRestaurantOrDish)
        self.vegan = container.safeDecodeValue(forKey: .vegan)
        self.mins = container.safeDecodeValue(forKey: .mins)
        self.scheduleDate = container.safeDecodeValue(forKey: .scheduleDate)
        self.setTime = container.safeDecodeValue(forKey: .setTime)
        self.otpMismatch = container.safeDecodeValue(forKey: .otpMismatch)
        self.enablePermission = container.safeDecodeValue(forKey: .enablePermission)
        self.restaurant = container.safeDecodeValue(forKey: .restaurant)
        self.promoApplied = container.safeDecodeValue(forKey: .promoApplied)
        self.nodatafound = container.safeDecodeValue(forKey: .nodatafound)
        self.noUpcomingOrder = container.safeDecodeValue(forKey: .noUpcomingOrder)
        self.rate = container.safeDecodeValue(forKey: .rate)
        self.navigate = container.safeDecodeValue(forKey: .navigate)
        self.pleaseEnablePermissions = container.safeDecodeValue(forKey: .pleaseEnablePermissions)
        self.pleaseEnableLocation = container.safeDecodeValue(forKey: .pleaseEnableLocation)
        self.discount = container.safeDecodeValue(forKey: .discount)
        self.noItemCart = container.safeDecodeValue(forKey: .noItemCart)
        self.addMoney = container.safeDecodeValue(forKey: .addMoney)
        self.enterWalletAmount = container.safeDecodeValue(forKey: .enterWalletAmount)
        self.walletAmount = container.safeDecodeValue(forKey: .walletAmount)
        self.checkOut = container.safeDecodeValue(forKey: .checkOut)
        self.history = container.safeDecodeValue(forKey: .history)
        self.FoodStatusDoor = container.safeDecodeValue(forKey: .FoodStatusDoor)
        self.totalAmount = container.safeDecodeValue(forKey: .totalAmount)
        self.orderIdSymbol = container.safeDecodeValue(forKey: .orderIdSymbol)
        self.editTheDeliveryNote = container.safeDecodeValue(forKey: .editTheDeliveryNote)
        self.asapAsSoonAsPossible = container.safeDecodeValue(forKey: .asapAsSoonAsPossible)
        self.deliveredToYou = container.safeDecodeValue(forKey: .deliveredToYou)
        self.changePromoCode = container.safeDecodeValue(forKey: .changePromoCode)
        self.minNeta = container.safeDecodeValue(forKey: .minNeta)
        self.locationError = container.safeDecodeValue(forKey: .locationError)
        self.clearandchange = container.safeDecodeValue(forKey: .clearandchange)
        self.locationError1 = container.safeDecodeValue(forKey: .locationError1)
        self.scheduleOrder = container.safeDecodeValue(forKey: .scheduleOrder)
        self.continueWithOrder = container.safeDecodeValue(forKey: .continueWithOrder)
        self.hintApartment = container.safeDecodeValue(forKey: .hintApartment)
        self.removeItemFromBasket = container.safeDecodeValue(forKey: .removeItemFromBasket)
        self.ReadyToMeet = container.safeDecodeValue(forKey: .ReadyToMeet)
        self.outside = container.safeDecodeValue(forKey: .outside)
        self.title1 = container.safeDecodeValue(forKey: .title1)
        self.msg1 = container.safeDecodeValue(forKey: .msg1)
        self.msgfirsthalf = container.safeDecodeValue(forKey: .msgfirsthalf)
        self.msg2half = container.safeDecodeValue(forKey: .msg2half)
        self.removeMenus = container.safeDecodeValue(forKey: .removeMenus)
        self.removeMenu = container.safeDecodeValue(forKey: .removeMenu)
        self.clearAllBasket = container.safeDecodeValue(forKey: .clearAllBasket)
        self.gettingOrderDetails = container.safeDecodeValue(forKey: .gettingOrderDetails)
        self.gettingRestaurants = container.safeDecodeValue(forKey: .gettingRestaurants)
        self.exit = container.safeDecodeValue(forKey: .exit)
        self.whatCouldBetter = container.safeDecodeValue(forKey: .whatCouldBetter)
        self.selectLang = container.safeDecodeValue(forKey: .selectLang)
        self.loginError1 = container.safeDecodeValue(forKey: .loginError1)
        self.loginError2 = container.safeDecodeValue(forKey: .loginError2)
        self.loginError3 = container.safeDecodeValue(forKey: .loginError3)
        self.changeLanguage = container.safeDecodeValue(forKey: .changeLanguage)
        self.changeCurrency = container.safeDecodeValue(forKey: .changeCurrency)
        self.deliveringTo = container.safeDecodeValue(forKey: .deliveringTo)
        self.loading = container.safeDecodeValue(forKey: .loading)
        self.profileUpload = container.safeDecodeValue(forKey: .profileUpload)
        self.imageUpload = container.safeDecodeValue(forKey: .imageUpload)
        self.chooseGallery = container.safeDecodeValue(forKey: .chooseGallery)
        self.addPhoto = container.safeDecodeValue(forKey: .addPhoto)
        self.offOn = container.safeDecodeValue(forKey: .offOn)
        self.offon = container.safeDecodeValue(forKey: .offon)
        self.offPer = container.safeDecodeValue(forKey: .offPer)
        self.mobileAlreadyEntered = container.safeDecodeValue(forKey: .mobileAlreadyEntered)
        self.successMobileNumber = container.safeDecodeValue(forKey: .successMobileNumber)
        self.noLocation = container.safeDecodeValue(forKey: .noLocation)
        self.alert = container.safeDecodeValue(forKey: .alert)
        self.locationRemoved = container.safeDecodeValue(forKey: .locationRemoved)
        self.enterLocation = container.safeDecodeValue(forKey: .enterLocation)
        self.required = container.safeDecodeValue(forKey: .required)
        self.requiredChooseUpto = container.safeDecodeValue(forKey: .requiredChooseUpto)
        self.requiredChoose = container.safeDecodeValue(forKey: .requiredChoose)
        self.to = container.safeDecodeValue(forKey: .to)
        self.chooseUpto = container.safeDecodeValue(forKey: .chooseUpto)
        self.chooseTo = container.safeDecodeValue(forKey: .chooseTo)
        self.onlinepayment = container.safeDecodeValue(forKey: .onlinepayment)
        self.pay = container.safeDecodeValue(forKey: .pay)
        self.paymentcompleted = container.safeDecodeValue(forKey: .paymentcompleted)
        self.seeMore = container.safeDecodeValue(forKey: .seeMore)
        self.stripeError1 = container.safeDecodeValue(forKey: .stripeError1)
        self.stripeError2 = container.safeDecodeValue(forKey: .stripeError2)
        self.paymentFailed = container.safeDecodeValue(forKey: .paymentFailed)
        self.addTipAmt = container.safeDecodeValue(forKey: .addTipAmt)
        self.yourTripAmoutWas = container.safeDecodeValue(forKey: .yourTripAmoutWas)
        self.enterTip = container.safeDecodeValue(forKey: .enterTip)
        self.tips = container.safeDecodeValue(forKey: .tips)
        self.errorTipsAmt = container.safeDecodeValue(forKey: .errorTipsAmt)
        self.chooseMap = container.safeDecodeValue(forKey: .chooseMap)
        self.googleMap = container.safeDecodeValue(forKey: .googleMap)
        self.wazeMap = container.safeDecodeValue(forKey: .wazeMap)
        self.googleMapNotFoundInDevice = container.safeDecodeValue(forKey: .googleMapNotFoundInDevice)
        self.wazeGoogleMapNotFoundInDevice = container.safeDecodeValue(forKey: .wazeGoogleMapNotFoundInDevice)
        self.paypal = container.safeDecodeValue(forKey: .paypal)
        self.payForOrdersWithCash = container.safeDecodeValue(forKey: .payForOrdersWithCash)
        self.menu = container.safeDecodeValue(forKey: .menu)
        self.facebook = container.safeDecodeValue(forKey: .facebook)
        self.google = container.safeDecodeValue(forKey: .google)
        self.bookingFee = container.safeDecodeValue(forKey: .bookingFee)
        self.pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem = container.safeDecodeValue(forKey: .pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem)
        self.seeAll = container.safeDecodeValue(forKey: .seeAll)
        self.pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem = container.safeDecodeValue(forKey: .pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem)
        self.new = container.safeDecodeValue(forKey: .new)
        self.tappedOn = container.safeDecodeValue(forKey: .tappedOn)
        self.userTappedOnConditionText = container.safeDecodeValue(forKey: .userTappedOnConditionText)
        self.iConfirmThatIHaveReadAndAgreedToThe  = container.safeDecodeValue(forKey: .iConfirmThatIHaveReadAndAgreedToThe )
        self.selectPaymentMethod = container.safeDecodeValue(forKey: .selectPaymentMethod)
        self.hereYouCanChangeYourMap = container.safeDecodeValue(forKey: .hereYouCanChangeYourMap)
        self.byClickingBelowActions = container.safeDecodeValue(forKey: .byClickingBelowActions)
        self.doYouWantToAccessDirection = container.safeDecodeValue(forKey: .doYouWantToAccessDirection)
        self.or = container.safeDecodeValue(forKey: .or)
        self.name = container.safeDecodeValue(forKey: .name)
        self.all = container.safeDecodeValue(forKey: .all)
        self.s = container.safeDecodeValue(forKey: .s)
        self.and = container.safeDecodeValue(forKey: .and)
        self.layoutDirection = container.safeDecodeValue(forKey: .layoutDirection)
        self.layoutDirectionRl = container.safeDecodeValue(forKey: .layoutDirectionRl)
        self.loginWithApp = container.safeDecodeValue(forKey: .loginWithApp)
        self.pick = container.safeDecodeValue(forKey: .pick)
        self.upTo = container.safeDecodeValue(forKey: .upTo)
        self.tipsAmountUpdatedSuccessfully = container.safeDecodeValue(forKey: .tipsAmountUpdatedSuccessfully)
        self.support = container.safeDecodeValue(forKey: .support)
        self.appName = container.safeDecodeValue(forKey: .appName)
        self.submitDocToVerify18Plus = container.safeDecodeValue(forKey: .submitDocToVerify18Plus)
        self.tapToAdd = container.safeDecodeValue(forKey: .tapToAdd)
        self.eighteenPlusVerification = container.safeDecodeValue(forKey: .eighteenPlusVerification)
        self.waitingForAdmin = container.safeDecodeValue(forKey: .waitingForAdmin)
        self.verification = container.safeDecodeValue(forKey: .verification)
        self.plsUploadIDProof = container.safeDecodeValue(forKey: .plsUploadIDProof)
        
        self.contactLessDelivery = container.safeDecodeValue(forKey: .contactLessDelivery)
        self.contactLessDeliveryInfo = container.safeDecodeValue(forKey: .contactLessDeliveryInfo)
        self.offers = container.safeDecodeValue(forKey: .offers)
        self.viewOffers = container.safeDecodeValue(forKey: .viewOffers)
        self.receiptUpload = container.safeDecodeValue(forKey: .receiptUpload)
        self.receiptImage = container.safeDecodeValue(forKey: .receiptImage)
        self.choosePayment = container.safeDecodeValue(forKey: .choosePayment)
        self.view = container.safeDecodeValue(forKey: .view)
        self.yourReceipt = container.safeDecodeValue(forKey: .yourReceipt)
        self.followBestSafetyStds = container.safeDecodeValue(forKey: .followBestSafetyStds)
        self.orderImg = container.safeDecodeValue(forKey: .orderImg)
        self.packageDeliveryImage = container.safeDecodeValue(forKey: .packageDeliveryImage)
        self.followsBestSafetyStandard = container.safeDecodeValue(forKey: .followsBestSafetyStandard)
        self.pleaseUploadReceiptImageOfYourOrder = container.safeDecodeValue(forKey: .pleaseUploadReceiptImageOfYourOrder)
        self.pleaseEnterTipsAmount = container.safeDecodeValue(forKey: .pleaseEnterTipsAmount)
        self.chooseAnotherPayment = container.safeDecodeValue(forKey: .chooseAnotherPayment)
        self.followWhoSafetyPractices = container.safeDecodeValue(forKey: .followWhoSafetyPractices)
        self.nonVegetarian = container.safeDecodeValue(forKey: .nonVegetarian)
        self.cusines = container.safeDecodeValue(forKey: .cusines)
        self.trackYourOrder = container.safeDecodeValue(forKey: .trackYourOrder)
        self.itemOutOfStock = container.safeDecodeValue(forKey: .itemOutOfStock)
        self.estimatedPickup = container.safeDecodeValue(forKey: .estimatedPickup)
        self.deliveryType = container.safeDecodeValue(forKey: .deliveryType)
        self.storeDescription = container.safeDecodeValue(forKey: .storeDescription)
        self.expiryDate = container.safeDecodeValue(forKey: .expiryDate)
        self.pleaseMakeSure = container.safeDecodeValue(forKey: .pleaseMakeSure)
        self.idProofRejected = container.safeDecodeValue(forKey: .idProofRejected)
        self.status = container.safeDecodeValue(forKey: .status)
        self.idProofVerified = container.safeDecodeValue(forKey: .idProofVerified)
        self.submittedSuccessfully = container.safeDecodeValue(forKey: .submittedSuccessfully)
        self.orderPlacedSuccessfully = container.safeDecodeValue(forKey: .orderPlacedSuccessfully)
        self.allStores = container.safeDecodeValue(forKey: .allStores)
        self.expiresOn = container.safeDecodeValue(forKey: .expiresOn)
    }
}
