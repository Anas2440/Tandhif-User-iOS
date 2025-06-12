//
//  Language.swift
//  GoferHandy
//
//  Created by trioangle on 29/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation


// MARK: - LanguageContentModel
class GDALanguageContentModel: Codable {
    let statusCode,statusMessage,defaultLanguage,currentLanguage : String
    let language: [GDALanguage]
    let goferDeliveryAll: GoferDeliveryAllLang
    let goferDeliveryAllOrder : GoferDeliveryAllOrder
    let goferDeliveryAllRegister : register
    enum CodingKeys : String,CodingKey {
        case statusCode = "status_code", statusMessage = "status_message", defaultLanguage = "default_language", currentLanguage = "current_language"
             case language, goferDeliveryAll = "goferdeliveryall",goferDeliveryAllOrder = "orders",goferDeliveryAllRegister = "register"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           self.statusCode = container.safeDecodeValue(forKey: .statusCode)
            self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
            self.defaultLanguage = container.safeDecodeValue(forKey: .defaultLanguage)
            self.currentLanguage = container.safeDecodeValue(forKey: .currentLanguage)
            
            
            let langs = try container.decodeIfPresent([GDALanguage].self, forKey: .language)
            self.language = langs ?? []
            
        let _goferdeliveryall = try container.decode(GoferDeliveryAllLang.self, forKey: .goferDeliveryAll)
            self.goferDeliveryAll = _goferdeliveryall
        
        let _goferdeliveryallOrder = try container.decode(GoferDeliveryAllOrder.self, forKey: .goferDeliveryAllOrder)
            self.goferDeliveryAllOrder = _goferdeliveryallOrder
        
        let _goferdeliveryallRegister = try container.decode(register.self, forKey: .goferDeliveryAllRegister)
            self.goferDeliveryAllRegister = _goferdeliveryallRegister
        
    }
    
    //MARK:- UDF


    func currentLangage() -> GDALanguage?{
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

// MARK: - GoferDeliveryAll
class GoferDeliveryAllLang: Codable {
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
    
    enum CodingKeys : String,CodingKey {
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
        case thereIsnTAnythingInYourBasket = "there_isn't_anything_in_your_basket"
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
        case rateYourOrder = "rate_your_order!"
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
    }
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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


    }
}


class GoferDeliveryAllOrder: Codable {
   
    let mins : String

    
    enum CodingKeys : String,CodingKey {
        case mins = "mins"
        
    }
    init(){
        self.mins = ""
    }
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mins = container.safeDecodeValue(forKey: .mins)
       


    }
}

class register: Codable {
   
    let fieldIsRequired : String
    

    
    enum CodingKeys : String,CodingKey {
        case fieldIsRequired = "field_is_required"
        
        
    }
    init(){
        self.fieldIsRequired = ""
    }
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fieldIsRequired = container.safeDecodeValue(forKey: .fieldIsRequired)
       


    }
}



// MARK: - Language
class GDALanguage: Codable {
    let key ,lang : String
    let isRTL: Bool
    
    enum CodingKeys : String,CodingKey {
        case key, lang = "Lang", isRTL = "is_rtl"
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
        UIView.appearance().semanticContentAttribute = Languages.RTL.instance
        UserDefaults.standard.set(self.key, forKey:  "lang")
        UserDefaults.standard.set([self.key], forKey: "AppleLanguages")
        Bundle.setLanguage(self.key)
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
     "apple_pay": "Apple Pay",
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



enum Languages:String {
    case LTR
    case RTL
    var instance:UISemanticContentAttribute {
        switch self {
        case .RTL:
            //Locale.current.languageCode
            var str = String()
            if let language : String = UserDefaults.value(for: .default_language_option){
                 str = language

            }
           
            if str == "ar" {
                print(str)
                return  .forceRightToLeft
            }
            return .forceLeftToRight
        default:
            return .forceLeftToRight
        }
    }
    var get:Bool {
        switch self {
        case .RTL:
            return true
        default:
            return false
        }
    }
    
}


extension String{
    var localize : String{
        return NSLocalizedString(self, comment: "")
    }
}
