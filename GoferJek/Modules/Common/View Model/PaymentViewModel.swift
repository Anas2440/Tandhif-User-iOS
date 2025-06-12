//
//  PaymentViewModel.swift
//  GoferHandy
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation



class PaymentViewModel: BaseViewModel {
    
    override init() {
        super.init()
    }
    
    
    //MARK: Add Card Details

    func addStripeCardAPI(params: JSON,
                          cardDetails : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler?
            .getRequest(for: .addStripeCard,
                           params: params)
            .responseJSON({ (response) in
                cardDetails(.success(response))
            })
            .responseFailure({ (error) in
                cardDetails(.failure(CommonError.failure(error)))
            })
    }
    
    
    //MARK: Get Card Details

    func getStripeCardAPI(cardDetails : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler?
            .getRequest(for: .getStripeCard,
                           params: [:])
            .responseJSON({ (response) in
                cardDetails(.success(response))
            })
            .responseFailure({ (error) in
                cardDetails(.failure(CommonError.failure(error)))
            })
    }
    
    //MARK: Promotions VC
    
    func getPromoDetails(_ promoDetails :@escaping Closure<Result<PromoContainerModel,Error>>) {
        // Handy Splitup Start
        let param : JSON = ["business_id" : AppWebConstants.businessType.rawValue] // [:]
        // Handy Splitup End
        Shared.instance.showLoaderInWindow()
           self.connectionHandler?
            .getRequest(for: .getPromoDetails,
                        params: param)
               .responseDecode(
                   to: PromoContainerModel.self,
                   { (container) in
                    if let code: String = UserDefaults.value(for: .promo_applied_code),
                       container.promos.isEmpty || container.promos.filter({$0.code == code}).isEmpty {
                        UserDefaults.set(0, for: .promo_id)
                    }
                   Shared.instance.removeLoaderInWindow()
                    promoDetails(.success(container))
               }).responseFailure({ (error) in
               Shared.instance.removeLoaderInWindow()
                promoDetails(.failure(CommonError.failure(error)))
               })
    }
    
}
