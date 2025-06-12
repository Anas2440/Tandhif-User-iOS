//
//  HandyPaymentVC.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire
import PaymentHelper
import StripeApplePay
import PassKit

class HandyPaymentVC: BaseViewController, ApplePayContextDelegate {
    
   
    @IBOutlet weak var ratingBottomConstraint: NSLayoutConstraint!
    @IBOutlet var handyPaymentView: HandyPaymentView!
    var jobViewModel : CommonViewModel!
    var jobModel :  HandyJobDetailModel!
    var jobID : Int!
    var jobModelGofer :  HandyJobDetailModel!
    var promoID : Int?
    var promoCode : String?


    var clienttSecretForApplePay: String?
    var paymentButtonStatus : BtnPymtStatus?
    var brainTree : BrainTreeProtocol?
    private var isJobCompleted : Bool = false
    //    var paypalHandler : PayPalHandler?
    var stripeHandler : StripeHandler?
    override var stopSwipeExitFromThisScreen: Bool?{
        return !self.isJobCompleted
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isJobCompleted {
            self.wsToGetJobDetail()
        }else{
            self.wsToGetInvoice(withTips: self.handyPaymentView.givenTipsAmount, withpromoid: self.promoID) //Check gofer
        }
//        self.handyPaymentView.initPromo()
        Shared.instance.isBackFromPayment = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    @objc func updatePayment(_ notification: NSNotification) {
        if let _ = notification.userInfo?["status"] as? String,let tripId = notification.userInfo?["tripId"] as? String ,
           let providerName = notification.userInfo?["name"] as? String,
           let provderImage = notification.userInfo?["image"] as? String{
                // do something with your image
            
            self.presentAlertWithTitle(title: appName,
                                       message: "\(LangCommon.paymentCompletedFor) #\(self.jobViewModel.getJobID)",
                                       options: LangCommon.ok,
                                       completion: {_ in
                self.navigateToRating(jobId: tripId,
                                      providerName: providerName,
                                      providerImage: provderImage)
            })
        }
    }
   
    //MAR:- initializers
    func initNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .HandyCashCollectedByProvider,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.navigateToRatingWithModel(_:)),
                                               name: .HandyCashCollectedByProvider,
                                               object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "TripApi"),
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updatePayment(_:)),
                                               name: NSNotification.Name(rawValue: "TripApi"),
                                               object: nil)
    }
    
    class func initWithStory(job : HandyJobDetailModel?,
                             jobID: Int,
                             jobStatus : HandyJobStatus, promoId:Int = 0) -> HandyPaymentVC {
        let view : HandyPaymentVC = UIStoryboard.gojekCommon.instantiateViewController()
        if let job = job {
            view.jobViewModel = CommonViewModel(forJob: job)
            view.jobID = job.users.jobID
            view.isJobCompleted = job.users.jobStatus > .payment
        } else {
            view.jobViewModel = CommonViewModel(forJob: jobID)
            view.jobID = jobID
            view.isJobCompleted = jobStatus > .payment
        }
        if promoId != 0{
        view.promoID = promoId
        }
        return view
    }
    
 
    
    func wsToGetJobDetail(){
        self.jobViewModel.wsToGetJobDetail(showLoader: true) { (result) in
            switch result {
            case .success(let jobDetailModel):
                let job = jobDetailModel
                self.handyPaymentView.setContent(fromJob: job)
                self.jobModel = job
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func wsToGetInvoice(withTips tipsAmount:Double?, withpromoid promoId:Int?) {// = nil
        self.jobViewModel.getInvoiceDetails(tipsAmount: tipsAmount, promoId: promoId, completionHandler:  { (result) in
            switch result {
            case .success(let jobDetailModel):
                let job = jobDetailModel
                self.handyPaymentView.setContent(fromJob: job)
                self.jobModel = job
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        })
    }
    
    
    func getInvoiceGofer(){
        
        AF.request("https://gofer.trioangle.com/api/get_invoice?device_id=94c8a93426e12a874c8e9355da737a15db2f4a1da0d9c38de7340e8f66812b34&device_type=1&language=en&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvZ29mZXJqZWsudHJpb2FuZ2xlZGVtby5jb21cL2FwaVwvbG9naW4iLCJpYXQiOjE2MzQ3MTAzNTEsImV4cCI6MTYzNzMzODM1MSwibmJmIjoxNjM0NzEwMzUxLCJqdGkiOiIyNkkzdFhYUUw0RFl6QkhyIiwic3ViIjoxMDE3NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.RxFxX4DMpBXsUD-1sBIZEmVXluprcncavOFGiKUZkFE&trip_id=169&user_type=driver",
                   method: .get,
                   parameters: nil)
            .responseJSON{ responseJSON in
                switch responseJSON.result {
                case .success(let value):
                    let data = value as! JSON
                        print(data,"response of json")
                    let json = data.array("invoice").compactMap({Invoice($0)})
                    self.jobModelGofer.users.invoice = json
                    self.handyPaymentView.setContent(fromJob: self.jobModelGofer)
                    self.handyPaymentView.paymentTable.reloadData()
                case .failure(let error):
                    print(error)
                }
          }
    }
    
    func wsToMakeAfterpayment(usingPayKey payKey : String?){
        
        self.jobViewModel.makePayment(payKey: payKey) { (result) in
            switch result{
            case .success(_):
                
                if let providerName = self.jobViewModel.jobDetailModel?.providerName,
                   let providerImage = self.jobViewModel.jobDetailModel?.providerImage {
                    let jobID = self.jobViewModel.getJobID
                    self.presentAlertWithTitle(title: appName,
                                               message: "\(LangCommon.paymentCompletedFor) #\(self.jobViewModel.getJobID)",
                        options: LangCommon.ok,
                        completion: {_ in
                            self.navigateToRating(jobId: jobID.description,
                                                  providerName: providerName,
                                                  providerImage: providerImage)
                    })
                }
                
            case .failure(let error):
                self.presentAlertWithTitle(title: appName,
                                           message: error.localizedDescription,
                                           options: LangCommon.ok) { _ in}
            }
        }
    }
    func wsToCurrencyConversion(){
        self.jobViewModel.wsMethodConvetCurrency { (conversionResponse) in
            switch conversionResponse{
                case .success(let conversion):
                    self.clienttSecretForApplePay = conversion.brainTreeClientID
                    self.handleCurrencyConversion(response: conversion.amount,
                                                  currency: conversion.currency,
                                                  key: conversion.brainTreeClientID)
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    
                        //                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
    }
    //MARK:- navigate
    
    func navigateToChangePayment(){
        let tripView = SelectPaymentMethodVC.initWithStory(showingPaymentMethods: true,
                                                           wallet: true,
                                                           promotions: false)
          tripView.paymentSelectionDelegate = self as paymentMethodSelection
        tripView.isFromPaymentPage = self.handyPaymentView.priceTypeLbl.isHidden 
          self.navigationController?.pushViewController(tripView, animated: true)
    }
    //MARK:- Payments
    func handlePayment(){
        guard let state = self.paymentButtonStatus else{return}
        if state == .proceed{
            if Shared.instance.isWebPayment{
//                self.wsMethodWebPaymentAmount(using: nil)
                self.wsToMakeAfterpayment(usingPayKey: nil)
            }else{
                self.handyPaymentView.makePaymentBtn.isHidden = true
                self.wsToMakeAfterpayment(usingPayKey: nil)

            }
        }else{
            if Shared.instance.isWebPayment{
                self.wsMethodWebPaymentAmount(using: nil)
            }else{
                if PaymentOptions.default == .stripe{
                    self.wsToMakeAfterpayment(usingPayKey: nil)
                }
                    //                else if Pay{
                    //                    self.
                    //                }
                else{
                    self.wsToCurrencyConversion()
                }
            }
        }
    }
    
    func wsMethodWebPaymentAmount(using payKey : String?){
       
        var params : [String : Any] = [
            "job_id":self.jobViewModel.getJobID,
            "amount":self.jobViewModel.jobDetailModel?.getPayableAmount.description ?? "0.0",
                                        "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"
        ]
        if let key = payKey{
            params["pay_key"] = key
        }
        let preference = UserDefaults.standard
        let paymentType =  PaymentOptions.default?.paramValue.lowercased() ?? "cash"
        let token = preference.string(forKey: USER_ACCESS_TOKEN)!
        var mode = ""
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            mode = isDarkStyle ? "dark" : "light"
        } else {
            // Fallback on earlier versions
            mode = "light"
        }
        let UrlString = "\(APIUrl + APIEnums.webPayment.rawValue)?amount=\(self.jobViewModel.jobDetailModel?.getPayableAmount.description ?? "0.0")&payment_type=\(paymentType)&token=\(token)&job_id=\(self.jobViewModel.getJobID)&pay_for=job&mode=\(mode)"
        let webVC = LoadWebKitView.initWithStory()
        webVC.strWebUrl = UrlString
        webVC.isFromTrip = true
        self.navigationController?.pushViewController(webVC, animated: true)

    }
    
//    //Mark:- Rating Update
//    func goferRatingUpdate(ratingValue: String, jobId: String, RatingComments: String){
//        AF.request("https://gofer.trioangle.com/api/trip_rating?device_id=94c8a93426e12a874c8e9355da737a15db2f4a1da0d9c38de7340e8f66812b34&device_type=1&language=en&rating=\(ratingValue)&rating_comments=\(RatingComments)&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvZ29mZXJqZWsudHJpb2FuZ2xlZGVtby5jb21cL2FwaVwvbG9naW4iLCJpYXQiOjE2MzQ4ODM0NzgsImV4cCI6MTYzNzUxMTQ3OCwibmJmIjoxNjM0ODgzNDc4LCJqdGkiOiJVbXVna3N5WkJIQnNGNzhkIiwic3ViIjoxMDE3NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9Bu__ZL9q4wXhgPHV1QE326GmyyEr-IrLdb62yajcas&trip_id=\(jobId)&user_type=user",
//                   method: .get,
//                   parameters: nil)
//            .responseJSON{ responseJSON in
//                switch responseJSON.result {
//                case .success(let value):
//                    self.handyPaymentView.feedBackTextView.isEditable = false
//                    self.handyPaymentView.feedBackTextView.isSelectable = false
//                    NotificationEnum.pendingTripHistory.postNotification()
//                case .failure(let error):
//                    print(error)
//                }
//          }
//
//    }
//
    func handleRating(userFeedback:String, userRating:Int){
        var params = JSON()
        params["job_id"] = self.jobViewModel.getJobID
        params["rating"] = userRating
        params["rating_comments"] = userFeedback
        self.jobViewModel.wsToUpdateUserRating(param: params) { (result) in
            switch result {
            case .success(let model):
                if model.isSuccess {
                    self.handyPaymentView.feedBackTextView.isEditable = false
                    self.handyPaymentView.feedBackTextView.isSelectable = false
                    NotificationEnum.pendingTripHistory.postNotification()
                    NotificationEnum.completedTripHistory.postNotification()
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.presentAlertWithTitle(title: appName,
                                               message: model.statusMessage,
                    options: LangCommon.ok,
                    completion: {_ in})
                }
                
            case .failure(let error):
                self.presentAlertWithTitle(title: appName,
                message: error.localizedDescription,
                options: LangCommon.ok,
                completion: {_ in})
            }
        }
    }
    
    func handleCurrencyConversion(response amount: Double,currency : String?, key : String ){
        switch PaymentOptions.default {
            case .brainTree:
                self.authenticateBrainTreePayment(for: amount, using: key)
            case .paypal:
                    //            self.paypalHandler?.makePaypal(payentOf: amount,
                    //                                           currency: currency ?? "USD",
                    //                                           for: .wallet)
                self.authenticatePaypalPayment(for: amount, currency: currency ?? "USD",using: key)
            case .apple_pay:
                self.authenticateApplePayment(for: amount, currency: currency ?? "USD", using: key)
            default:
                break
        }
    }
    @objc
    func navigateToRating(jobId: String,
                          providerName:String,
                          providerImage:String){
//        guard let job = self.jobViewModel.jobDetailModel else{return}
        if let vc = self.navigationController?.viewControllers.last ,
           vc.isKind(of: RateYourRideVC.self) {
            guard (vc as! RateYourRideVC).jobId != jobId.description else { return }
        }
        self.navigationController?.pushViewController(RateYourRideVC.initWithStory(jobId: jobId,userName: providerName,userImage: providerImage), animated: true)
    }
    
    @objc func navigateToRatingWithModel(_ notification: NSNotification){
        if let window = UIApplication.shared.delegate?.window {
            if let view = window?.subviews.last {
                if view.isKind(of: DeletePHIAlertview.self) {
                    print("We Found Some Culprits")
                } else {
                    print("He Got away")
                }
            }
        }
        
      
        if self.presentedViewController is MorePopOverVC{
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
        self.commonAlert.setupAlert(alert: appName, alertDescription: notification.userInfo?["status"] as? String, okAction: LangCommon.ok.capitalized, cancelAction: nil, userImage: nil)
        self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                if let _ = notification.userInfo?["status"] as? String,let tripId = notification.userInfo?["job_id"] as? String ,
                   let providerName = notification.userInfo?["provider_name"] as? String,
                   let provderImage = notification.userInfo?["provider_thumb_image"] as? String {
                    if let vc = self.navigationController?.viewControllers.last ,
                       vc.isKind(of: RateYourRideVC.self) {
                        guard (vc as! RateYourRideVC).jobId != tripId else { return }
                    }
                    self.navigationController?.pushViewController(RateYourRideVC.initWithStory(jobId: tripId,
                                                                                               userName: providerName,
                                                                                               userImage: provderImage),
                                                                  animated: true)
                }

           
        }
    }
    
//    @objc
//    func navigateToRatingWithModel(_ notification: NSNotification){
////        guard let job = self.jobViewModel.jobDetailModel else{return}
//
//
//
//
//        if let _ = notification.userInfo?["status"] as? String,let tripId = notification.userInfo?["job_id"] as? String ,
//           let providerName = notification.userInfo?["provider_name"] as? String,
//           let provderImage = notification.userInfo?["provider_thumb_image"] as? String {
//            if let vc = self.navigationController?.viewControllers.last ,
//               vc.isKind(of: RateYourRideVC.self) {
//                guard (vc as! RateYourRideVC).jobId != tripId else { return }
//            }
//            self.navigationController?.pushViewController(RateYourRideVC.initWithStory(jobId: tripId,
//                                                                                       userName: providerName,
//                                                                                       userImage: provderImage),
//                                                          animated: true)
//
//        }
//    }
    //MARK:- authenticateBrainTreePayment
    func authenticateBrainTreePayment(for amount : Double,using clientId : String){
           self.brainTree = BrainTreeHandler.default
           self.brainTree?.initalizeClient(with: clientId)
           self.view.isUserInteractionEnabled = false
           self.brainTree?.authenticatePaymentUsing(self,
                                                    email : UserDefaults.value(for: .user_email_id) ?? "test@email.com",
                                                    givenName :  UserDefaults.value(for: .first_name) ?? "Albin",
                                                    surname :  UserDefaults.value(for: .last_name) ?? "MrngStar",
                                                    phoneNumber :  UserDefaults.value(for: .phonenumber) ?? "123456",
                                                    for: amount) { (result) in
               self.view.isUserInteractionEnabled = true
               switch result{
               case .success(let token):
                self.wsToMakeAfterpayment(usingPayKey: token.nonce)
               case .failure(let error):
                self.presentAlertWithTitle(title: appName,
                                           message: error.localizedDescription,
                                           options: LangCommon.ok,
                                           completion: {_ in})
               }
           }
       }
       //MARK:- authenticatePaypalPayment
    func authenticatePaypalPayment(for amount : Double,currency: String,using clientId : String){
           self.brainTree = BrainTreeHandler.default
           self.brainTree?.initalizeClient(with: clientId)
           self.view.isUserInteractionEnabled = false
        self.brainTree?.authenticatePaypalUsing(self,for: amount, currency: currency) { (result) in
               self.view.isUserInteractionEnabled = true
               switch result{
               case .success(let token):
               self.wsToMakeAfterpayment(usingPayKey: token.nonce)
               case .failure(let error):
                if error.localizedDescription != "" {
                    self.presentAlertWithTitle(title: appName,
                                               message: error.localizedDescription,
                                               options: LangCommon.ok,
                                               completion: {_ in})
                }
                
               }
           }
       }
    
    func authenticateApplePayment(for amount: Double, currency: String,using clientId: String) {
        let merchantIdentifier = "com.tandhif.user"
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: currency)
        
            // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "iHats, Inc", amount: NSDecimalNumber(value: amount))
        ]
        
            // Initialize an STPApplePayContext instance
        if StripeAPI.deviceSupportsApplePay() {
            if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
                applePayContext.presentApplePay()
            }
        } else {
            self.showPopOver(withComment: "Apple Pay is not available on this device.", on: self.handyPaymentView)
            print("Apple Pay is not available on this device.")
            // Show an alert to inform the user
        }
    }
}

// Deliery Splitup Start
extension HandyPaymentVC : NavigateGalleryItemProtocol{
    func navigateToGalleryDetail(image: UIImage?, from frame: CGRect, with snaps: [String], selectedIndex: IndexPath) {
        let actualFrame = self.handyPaymentView.paymentTable.convert(frame, to: self.view)
         let vc = HandyGalleryDetailVC.initWithStory(fromFrame: actualFrame,
                                                     image : image,
                                                     withItem: snaps,
                                                    selectedIndex: selectedIndex)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
  
    
}
// Deliery Splitup End
extension HandyPaymentVC : paymentMethodSelection{
    func reloadWallet() {
        
    }
    func selectedPayment(method: PaymentOptions) {
        
    }
    
    func updateContent() {
        
    }
}

//delegate for apple pay
extension HandyPaymentVC {
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        if let clientSecret = clienttSecretForApplePay {
            completion(clientSecret, nil) // No error
        } else {
            completion(nil, NSError(domain: "ApplePay", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve client secret"]))
        }
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPApplePayContext.PaymentStatus, error: Error?) {
        switch status {
        case .success:
            print("Apple Pay transaction successful!")
            // Show a success message or navigate to another screen
            // Call your API with the payment token (client secret)
                if let clientSecret = self.clienttSecretForApplePay {
                    self.wsToMakeAfterpayment(usingPayKey: clientSecret)
                }
        case .error:
            print("Error occurred: \(error?.localizedDescription ?? "Unknown error")")
            // Display an error message to the user
                if let error = error {
                    self.presentAlertWithTitle(title: appName,
                                               message: error.localizedDescription,
                                               options: LangCommon.ok,
                                               completion: { _ in })
                }
        case .userCancellation:
            print("User canceled the payment")
            // Optionally handle user cancellation
        @unknown default:
            fatalError("Unhandled Apple Pay case")
        }
    }
}
