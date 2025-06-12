////
////  LangProtocal.swift
//// Gofer
////
////  Created by Trioangle on 29/07/19.
////  Copyright Â© 2019 Trioangle Technologies. All rights reserved.
////
//
import Foundation
import UIKit

protocol LanguageProtocol{
    // SEARCH CAR VC
    var requesting : String {get set}
    var searchLocation : String {get set}
    var selectPaymentMode : String {get set}
    var fareEstimation : String {get set}
    var rateYourJob : String {get set}
    var of : String {get set}
    var areYouSure : String {get set}
    var maxChar : String {get set}
    var or : String {get set}
    var getMovingWith : String {get set}
    var tryAgain : String {get set}
    var getMoveGofer : String {get set}
    var signIn : String {get set}
    var register : String {get set}
    var connectSocialAcc : String {get set}
    var password : String {get set}
    var forgotPassword : String {get set}
    var enterPassword : String {get set}
    var credentialdon_tRight : String {get set}
    var login : String {get set}
    var mobileVerify : String {get set}
    var enterMobileno : String {get set}
    var enterOtp : String {get set}
    var sentCodeMob : String {get set}
    var didntRecOtp : String {get set}
    var resendOtp : String {get set}
    var otpSendAgain : String {get set}
    var termsCondition : String {get set}
    var addHome : String {get set}
    var addWork : String {get set}
    var favorites : String {get set}
    var currency : String {get set}
    var home : String {get set}
    var work : String {get set}
    var message : String {get set}
    var ok : String {get set}
    var signOut : String {get set}
    var settings : String {get set}
    var regInformation : String {get set}
    var agreeTcPolicy : String {get set}
    var privacyPolicy : String {get set}
    var confirmInfo : String {get set}
    var firstName : String {get set}
    var lastName : String {get set}
    var mobileNo : String {get set}
    var refCode : String {get set}
    var cancelAccCreation : String {get set}
    var rUSureToLogOut: String {get set}
    var infoNotSaved : String {get set}
    var confirm : String {get set}
    var cancel : String {get set}
    var enPushNotifyLogin : String {get set}
    var chooseAcc : String {get set}
    var faceBook : String {get set}
    var google : String {get set}
    var resetPassword : String {get set}
    var close : String {get set}
    var confirmPassword : String {get set}
    var continueSendAlert : String {get set}
    var continue_ : String{get set}
    var sendingAlert : String {get set}
    var alertSent : String {get set}
    var useEmergency : String {get set}
    var AlertEmergencyContact : String {get set}
    var goferCollectLocData : String {get set}
    var likeToResetPass : String {get set}
    var email : String {get set}
    var mobile : String {get set}
    var contacting : String {get set}
    var nearYou : String {get set}
    var promoApplied : String {get set}
    var cash : String {get set}
    var apple_pay : String {get set}
    var paypal : String {get set}
    var card : String {get set}
    var onlinePay : String {get set}
    var noCarAvailable : String {get set}
    var request : String {get set}
    var noCabsAvail : String {get set}

    var change : String {get set}
    var gettingCabs : String {get set}
    var setUrPickUp : String {get set}
    var setPicktUpTime : String {get set}
    var upComingRide : String {get set}
    var sheduleUrRide : String {get set}
    var currentFareEstimate : String {get set}
    var actualString : String {get set}
    var doesNotGuaranteeStr : String {get set}
    var peakTimePricing : String {get set}
    var demandIsOff : String {get set}
    var normalFare : String {get set}
    var minFare : String {get set}
    var minLeft : String {get set}
    var minKm : String {get set}
    var acceptHigherFare : String {get set}
    var tryLater : String {get set}
    var affordableEveryRide : String {get set}
    var fare : String {get set}
    var capacity : String {get set}
    var descriptionFareEstimation : String {get set}
    var done : String {get set}
    var fareBreakDown : String {get set}
    var descriptionPriceBreak : String {get set}
    var baseFare : String {get set}
    var perMin : String {get set}
    var perKm : String {get set}
    var currentLocation : String {get set}
    var samePickupDrop : String {get set}
    var noLocationFound : String {get set}
    var whereTo : String {get set}

    var setPin : String {get set}

    var enterUrLocation : String {get set}
    var enterHome : String {get set}
    var enterWork : String {get set}
    var travelSafer : String {get set}
    var alertUrDears : String {get set}
    var youCanAddC : String {get set}
    var removeContact : String {get set}
    var addContacts : String {get set}
    var emergencyContacts : String {get set}
    var delete : String {get set}
    var contactAlreadyAdded : String {get set}
    var schedule : String {get set}
    var makeTravelSafe : String {get set}
    var alertYourDear : String {get set}
    var add5Contacts : String {get set}
    var removeContactAddone : String {get set}

    var off : String {get set}
    var freeTripUpto : String {get set}
    var from : String {get set}
    var promotions : String {get set}
    var paymentMethod : String {get set}
    var useWallet : String {get set}
    var wallet : String {get set}
    var addPromoGiftCode : String {get set}
    var enterPromoCode : String {get set}
    var addCreditDebit : String {get set}
    var changeCreditDebit : String {get set}
    var payment : String {get set}
    var pay : String {get set}
    var waitDriverConfirm : String {get set}
    var quantity : String {get set}
    var proceed : String {get set}
    var continueRequest : String {get set}
    var success : String {get set}
    var paymentPaidSuccess : String {get set}
    var orderFailed : String {get set}
    var yourOrderfailed : String {get set}
    var orderCancelled : String {get set}
    var yourOrderCancelled : String {get set}
    var cancelled : String {get set}
    var failed : String {get set}
    var paymentDetails : String {get set}
    var totalFare : String {get set}
    var addPayment : String {get set}
    var addMoneytoWallet : String {get set}
    var addAmount : String {get set}
    var enterAmount : String {get set}
    var walletAmountIs : String {get set}
    var amountFldReq : String {get set}
    var driver : String {get set}
    var typeMessage : String {get set}
    var noMsgYet : String {get set}
    var getUpto : String {get set}
    var everyFriendRides : String {get set}
    var signUpandGetPaid : String {get set}
    var referral : String {get set}
    var YourReferralCode : String {get set}
    var shareMyCode : String {get set}
    var refCopytoClip : String {get set}
    var referralCodeCopied : String {get set}
    var useMyReferral : String {get set}
    var startJourneyonGofer : String {get set}
    var noRefYet : String {get set}
    var friendsInComplete : String {get set}
    var friendsCompleted : String {get set}
    var earned : String {get set}
    var refExpired : String {get set}
    var rateYourRide : String {get set}
    var smoothOrSloppy : String {get set}
    var writeYourComment : String {get set}
    var tip : String {get set}
    var submit : String {get set}
    var set : String {get set}
    var add : String {get set}
    var enterTipAmount : String {get set}
    var yourTrips : String {get set}
    var removeItem : String {get set}
    var job : String {get set}
    var past : String {get set}
    var upComming : String {get set}
    var youHaveNoTrips : String {get set}
    var pullToRefresh : String {get set}
    var ID : String {get set}
    var trip : String {get set}
    var tripDetails : String {get set}
    var cancelYourRide : String {get set}
    var cancelReason : String {get set}
    var cancelTrip : String {get set}
    var contacts : String {get set}
    var call : String {get set}
    var contact : String {get set}
    var enRoute : String {get set}
    var mins : String {get set}
    var yourCurrentTrip : String {get set}
    var restaurantDelights : String {get set}
    var uberToWangs : String {get set}
    var sorryNoRides : String {get set}
    var contactAdmin : String {get set}
    var addHomeLoc : String {get set}
    var addWorkLoc : String {get set}
    var save : String {get set}
    var selectPhoto : String {get set}
    var takePhoto : String {get set}
    var chooseLib : String {get set}
    var driveWithGofer : String {get set}
    var help : String {get set}
    var selectCntry : String {get set}
    
    var uploadFailed : String {get set}
    var enterValidEmailId : String {get set}
    var enterFirstName : String {get set}
    var enterlastName : String {get set}
    var enterEmailId : String {get set}
    

    var passwordMismatch : String {get set}
    var newVersAvail : String {get set}
    var updateOurApp : String {get set}
    var visitAppStore : String {get set}
    
    //DriverProfileVc
    var minutesToArrive : String {get set}
    var noContactFound : String {get set}
    var dial : String {get set}
    var no : String {get set}
    var yes : String {get set}
    var yourTripWith : String {get set}
    var addTip : String {get set}
    var setTip : String {get set}
    var toDriver : String {get set}
    var pleaseEnterValidAmount : String {get set}
    var pleaseGiveRating : String {get set}
    var driveWith : String {get set}
    var minArrivalTillStart : String {get set}
    var minWaitingApplied : String {get set}
    var internalServerError : String {get set}
    var myTrips : String {get set}
    var manualBooking : String {get set}
    var tripID : String {get set}
    var dayLeft : String {get set}
    var trips : String {get set}
    var skip : String {get set}
    var rider : String {get set}
    var user : String {get set}
    var answer : String {get set}
    var incomingCall : String {get set}
    var completedStatus : String {get set}
    var endTripStatus : String {get set}
    var beginTripStatus : String {get set}
    var cancelledStatus : String {get set}
    var reqStatus : String {get set}
    var pendingStatus : String {get set}
    var sheduledStatus : String {get set}
    var paymentStatus : String {get set}
    var editTime : String {get set}
    var cancelRide : String {get set}
   var selectCountry : String {get set}
   var search : String {get set}
    var pending : String {get set}
    var completed : String {get set}

    //MARK:- ErrorLocalizedDesc
    var clientNotInitialized : String {get set}
    var jsonSerialaizationFailed : String {get set}
    var noInternetConnection : String {get set}
    
    //MARK:- En Route / DriverProfile
    var toReach : String {get set}
    var toArrive : String {get set}
    
    var totryAgain : String {get set}
    //MARK:- Socail login vc
    var signInWith : String {get set}
    var userCancelledAuthentication : String {get set}
    var authenticationCancelled : String {get set}
    
    //MARK:- Call
    var connecting : String {get set}
    var ringing : String {get set}
    var callEnded : String {get set}
    
    //MARK:- Langugage reopens
       var placehodlerMail : String {get set}
       var enterValidOTP : String {get set}
       var locationService : String {get set}
          var tracking : String {get set}
          var camera : String {get set}
          var photoLibrary : String {get set}
          var service : String {get set}
          var app : String {get set}
          var pleaseEnable : String {get set}
          var requires : String {get set}
          var _for : String {get set}
          var functionality : String {get set}
    
    
       var requestStatus : String {get set}
       var ratingStatus : String {get set}
       var scheduledStatus : String {get set}
    var microphoneSerivce : String {get set}
    var inAppCall : String {get set}
    
    var choose : String {get set}
    var choosePaymentMethod: String {get set}
    
    var min : String {get set}
    var hr : String {get set}
    var hrs : String {get set}
    var language : String {get set}
    var selectLanguage : String {get set}
    var editAccount : String {get set}
    
    
    
    var enterValidData : String {get set}
    var confirmContact : String {get set}
    var pleaseSelectOption : String {get set}
    
    var howManySeats : String {get set}
    var thisFareMayVary : String {get set}
    var confirmSeats : String {get set}
    var pool : String {get set}
    var rejected : String {get set}
    var driverBusy : String {get set}
    
    //MARK:- HANDY
    //MARK:-
    
    var pleaseEnablePushNotification : String {get set}
    var address : String {get set}
    var error : String {get set}
    var deviceHasNoCamera : String {get set}
    var warning : String {get set}
    var pleaseGivePermission : String {get set}
    var phoneNumber : String {get set}
    var addressLineFirst : String {get set}
    var addressLineSecond : String {get set}
    var city : String {get set}
    var postalCode : String {get set}
    var state : String {get set}
    var manageServices: String {get set}
    var manageHome: String {get set}
    var addItem : String {get set}
    var loginText : String {get set}
     var appName : String {get set }
     var welcomeText : String {get set }
     var welcomeLoginText : String {get set }
    var yourJob : String {get set}
    var tapToChange : String {get set}
    var dontHaveAcc : String {get set}
    var alreadyHaveAcc : String {get set}
    var tocText : String {get set}
    var logout : String {get set}
    
    var termsConditions : String {get set}
    var smsMobileVerify : String {get set}
    var didntReceiveOtp : String {get set}
    var otpAgain : String {get set}
    
    var credentialsDontLook : String {get set}
  // MARK:- Edit Profile VC
  var enterYourFirstName : String {get set}
  var enterYourLastName : String {get set}
  var enterYourPhoneNumber : String {get set}
  var enterYourEmail : String {get set}
  var enterYourPassword : String {get set}
  
  
  // MARK:- View Profile View
  
  var country : String {get set}
  var myProfile : String {get set}
  var editProfile : String {get set}
  var updateInfo : String {get set}
  var changePassword : String {get set}
    
    
    //MARK:- Booking
    var added : String {get set}
    var next  : String {get set}
    var enterLocation : String {get set}
    var youAreIn : String {get set}
    var serviceAtMe : String {get set}
    var setOnMap : String {get set}
    var pleaseSetLocation : String {get set}
    var yourBooking : String {get set}
    var onGoingJobs : String {get set}
    
  // MARK:- Change Password VC
  
  var successFullyUpdated : String {get set}
  var enterYourOldPassword : String {get set}
  var enterYourNewPassword : String {get set}
  var enterYourConformPassword : String {get set}
  
  // MARK:-
  
  var pleaseAddThemToYourEmergencyContact : String {get set}
  //MARK:- providers List
    var kilometerAway : String {get set}
    var sortDistance : String {get set}
    var sortName : String {get set}
    var sorting : String {get set}
    var lessThanAKM : String {get set}
  
  //MARK:- Handy Home VC
  
  var searchServices : String {get set}
  var book : String {get set}
  var bookNow : String {get set}
  var bookLater : String {get set}
  
  
  var categoryName : String {get set}
  var name : String {get set}
  var noProviderFound : String {get set}
  var itemsInYourCartWillBeDiscarded : String {get set}
  var youCanOnlyOneItemForThisServiceType : String {get set}
  var noReviewsYet : String {get set}
  var theProviderHasNoImages : String {get set}
  var removeFromCart : String {get set}
  var editCart : String {get set}
  var addCart : String {get set}
  var addSpecialInfoBelow : String {get set}
  var serviceCharge : String {get set}
  var serviceChargePerHour : String {get set}
  var estimatedCharge : String {get set}
  var minimumHour : String {get set}
  var paymentOption : String {get set}
  var selectBookingLocation : String {get set}
  var atUserLocation : String {get set}
  var atProviderLocation : String {get set}
  var providerArrived : String {get set}
  
  var calendar : String {get set}
  var bookingDetails : String {get set}
  var checkOut : String {get set}
  var remove : String {get set}
  var estimatedFee : String {get set}
  var cart : String {get set}
  
  var paymentSummary : String {get set}
  var jobRequestDate : String {get set}
  var discountApplied : String {get set}
  var providerFeedback : String {get set}
  var howWasTheJobDone : String {get set}
  var map : String {get set}
  var list : String {get set}
  var aToZ : String {get set}
  
  var moreInfo : String {get set}
  var iWantServiceAtMyCurrentLocation : String {get set}
  var setLocationOnMap : String {get set}
  
  var noServiceFound : String {get set}

  
  var review : String {get set}
  var gallery : String {get set}

  var viewMore : String {get set}
  var viewLess : String {get set}
    //MARK:- enroute
    
    var hereYouCanChangeYourMap : String {get set}
    var byClicking : String {get set}
    var googleMap : String {get set}
    var wazeMap : String {get set}
    var doYouWant : String {get set}
    var pleaseInstallGoogleMapsApp : String {get set}
    var doYouWantToAccessdirection : String {get set}
    var pleaseInstallWazeMapsApp : String {get set}
    
  //MARK:- Handy Payment 
    var jobLocation : String {get set}
    var destinationLocation : String {get set}
    var thanksForProvidingThisService : String {get set}
    var jobID : String {get set}
    var beforeService : String {get set}
    var afterService : String {get set}
    var fareDetails : String {get set}
    var paymentCompletedFor : String {get set}
      
    // MARK:- Trip History
    var number : String {get set}
    var yourJobs : String {get set}
    var jobDetails : String {get set}
  // MARK:- Handy Route
  
    var liveTrack : String {get set}
    var jobProgress : String {get set}
    var navigate : String {get set}
    var requestedService : String {get set}
    var cancelBooking : String {get set}
    var liveTracking : String {get set}
    
    
    var agreeTermsAndPrivacyPolicyContent : String {get set}
  
    
    //MARK:- Cancel Job
    var noUpCommingJobs : String {get set}
    var noJobs : String {get set}
    var cancelJob : String {get set}
    var cancelYourJob : String {get set}
    
    //MARK:- Status Alerts
    var manuallyBookedAlert : String {get set}
    var manuallyBookedReminderAlert : String {get set}
    var manualBookiingCancelledAlert : String {get set}
    var manualBookingInfoAlert : String {get set}
    var scheduledAlert : String {get set}
    var requestAlert : String {get set}
    var beginJobAlert : String {get set}
    var endJobAlert : String {get set}
    var pendingAlert : String {get set}
    var cancelledAlert : String {get set}
    var completedAlert : String {get set}
    var ratingAlert : String {get set}
    var paymentAlert : String {get set}
    var editItem : String {get set}
    var noDataFound : String {get set}
    var passwordValidationMsg : String {get set}
    var specialInstruction : String {get set}
    
    var provideFeedback : String {get set}
    var howWasYourJob : String {get set}

    var bookingRequested : String {get set}
    var viewOnGoingJob : String {get set}
    var freeJobUpto : String {get set}
    func isRTLLanguage() -> Bool
    var makeTravelSafer : String {get set}
    var sendAlert : String {get set}
    var addThem : String {get set}
    var sec : String {get set}

    var paymentType : String {get set}
    var priceType : String {get set}
    var services : String {get set}
    var yourInviteCode : String {get set}
    var forEveryFriendJobs : String {get set}
    
    var areYouSureYouWantToExit : String {get set}
    var makeJobSafe : String {get set}
    var ensureSaferJob : String {get set}
    var balance : String {get set}
    var provideYourFeedback : String {get set}
}

protocol HandyLanguageProtocol : LanguageProtocol {
}
extension LanguageProtocol{
    func getBackBtnText() -> String{
        return self.isRTLLanguage() ? "I" : "e"
    }
    func semantic() -> UISemanticContentAttribute{
        return self.isRTLLanguage() ? .forceRightToLeft : .forceLeftToRight
    }
    //MARK:- get display semantice
    var getSemantic:UISemanticContentAttribute {
        
        return self.isRTLLanguage() ? .forceRightToLeft : .forceLeftToRight
        
    }
    //MARK:- for Text Alignment
    
    func getTextAlignment(align : NSTextAlignment) -> NSTextAlignment{
        guard self.getSemantic == .forceRightToLeft else {
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
