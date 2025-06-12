//
//  CommonViewModel.swift
//  Goferjek
//
//  Created by Trioangle on 06/10/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

typealias CurrencyConversion = (amount : Double,brainTreeClientID : String,currency : String?)

class CommonViewModel : BaseViewModel {
    
    private let jobID : Int!
    var jobDetailModel : HandyJobDetailModel?
    var fireBaseReference : DatabaseReference!
    var getJobID : Int {
        return self.jobID ?? jobDetailModel?.users.jobID ?? 0
    }
    
    init(forJob jobID : Int!){
        self.jobID = jobID
        super.init()
        if let _jobID = jobID {
            UserDefaults.set(_jobID,
                             for: .current_job_id)
            self.fireBaseReference = Database.database().reference()
                .child(firebaseEnvironment.rawValue)
                .child(FireBaseNodeKey.trip.rawValue)
                .child(self.getJobID.description)
        }
    }
   
    convenience init(forJob job : HandyJobDetailModel){
        self.init(forJob : job.users.jobID)
        self.jobDetailModel = job
    }
    convenience override init(){
        self.init(forJob : nil)
    }
    
    //MARK:- class instances
    class func getIncompleteTrip(_ result : @escaping Closure<Result<HandyJobDetailModel,Error>>){
        let vm = CommonViewModel.init()
        vm.wsToGetJobDetail(showLoader: false, result)
    }
    
    //MARK:- wsto get data
    func wsToGetJobDetail(reqID : Int? = nil,
                          showLoader:Bool,
                          _ result : @escaping Closure<Result<HandyJobDetailModel,Error>>) {
        var params = JSON()
        if let job = self.jobID{
            params = ["job_id":job]
        }
        if let reqID = reqID {
            params = ["request_id":reqID]
        }
        // Handy Splitup Start
        params["business_id"] = AppWebConstants.businessType.rawValue
        // Handy Splitup End
        if showLoader {
            Shared.instance.showLoaderInWindow()
        }
        self.connectionHandler?
            .getRequest(for: .getJobDetail,
                           params: params)
            .responseDecode(to: HandyJobDetailModel.self, { response in
                if response.statusCode != "0" {
                    self.jobDetailModel = response
                    result(.success(response))
                } else {
                    result(.failure(CommonError.failure(response.statusMessage)))
                }
                Shared.instance.removeLoaderInWindow()
            })
            .responseFailure({ (error) in
                print(error.localizedLowercase)
                Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
    
    func getInvoiceDetails(tipsAmount:Double? = nil,promoId:Int? = nil,
                           completionHandler : @escaping Closure<Result<HandyJobDetailModel,Error>>) {
        var walletSelected = Constants().GETVALUE(keyname: "selectwallet")
        let walletAmount = UserDefaults.value(for: .wallet_amount) ?? ""
        if walletSelected.isEmpty {walletSelected = "No"}
        
        if walletAmount.toDouble().isZero {
            walletSelected = "No"
        }
        var params = [
            "job_id": self.getJobID,
            "payment_mode": PaymentOptions.default?.paramValue.lowercased() ?? "cash",
            "is_wallet" : walletSelected
            ] as JSON
        if let amount = tipsAmount {
            params["tips"] = amount
        }
            //let promo:Int = UserDefaults.value(for: .promo_id),
        if promoId != 0 {
            params["promo_id"] = promoId
        }else{
            params["promo_id"] = 0
        }
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?.getRequest(for: .getInvoice,
                                              params: params)
            .responseDecode(to: HandyJobDetailModel.self, { (response) in
                self.jobDetailModel = response
                Shared.instance.removeLoaderInWindow()
                completionHandler(.success(response))
            })
            .responseFailure { (error) in
                Shared.instance.removeLoaderInWindow()
                completionHandler(.failure(CommonError.failure(error)))
            }
    }
    func makePayment(payKey : String?,
                     _ result : @escaping Closure<Result<Bool,Error>>){
        var params = [
            "job_id": self.getJobID,
            "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"
        ] as JSON
        if let key = payKey{
            params["pay_key"] = key
        }
        
        
        params["amount"] = self.jobDetailModel?.getPayableAmount.description ?? "0.0"
        
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?
            .getRequest(for: .afterPayment,
                           params: params)
            .responseDecode(to: CommonModel.self, { response in
                Shared.instance.removeLoaderInWindow()
                if response.isSuccess {
                    FireBaseNodeKey.trip.getReference(for: "\(self.getJobID)").removeValue()
                    result(.success(true))
                } else {
                    result(.failure(CommonError.failure(response.statusMessage)))
                }
            })
            .responseFailure({ (error) in
                Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
    
    func wsMethodConvetCurrency(_ result : @escaping Closure<Result<CurrencyConversion,Error>>){
        guard let model = self.jobDetailModel else{return}
        
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?
            .getRequest(for: .currencyConversion,
                           params:  ["amount": model.getPayableAmount,
                                     "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"])
            .responseJSON({ (response) in
                Shared.instance.removeLoaderInWindow()
                if response.isSuccess{
                    let amount = response.double("amount")
                    let brainTreeClientID = response.string("braintree_clientToken")
                    let currency = response.string("currency_code")
                    result(.success(CurrencyConversion(amount : amount,
                                                       brainTreeClientID : brainTreeClientID,
                                                       currency : currency)))
                }else{
                    result(.failure(CommonError.failure(response.status_message)))
                }
            }).responseFailure({ (error) in
                Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
    
    func wsToUpdateUserRating(param:JSON,
                              _ result : @escaping Closure<Result<CommonModel,Error>>) {
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?.getRequest(for: .jobRating,
                                              params: param)
            .responseDecode(to: CommonModel.self, { response in
                Shared.instance.removeLoaderInWindow()
                result(.success(response))
            })
            .responseFailure({ (error) in
                Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
}
