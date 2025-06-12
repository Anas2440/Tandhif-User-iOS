//
//  HandyJobHistoryVM.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//


import UIKit

class HandyJobHistoryVM: BaseViewModel {
    
  
    func wsToGetPendingJobs(needCache: Bool,
                            pendingJobHistoryModel :GoferDataModel?,
                            _ completionHandler : @escaping (Result<GoferDataModel,Error>) -> Void) {
        var parms = JSON()
        parms["currency_code"] = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        if let pending = pendingJobHistoryModel{
            parms["page"] = pending.currentPage + 1
        }else{
            parms["page"] = 1
        }
        if needCache {
            parms["cache"] = 1
        }
        // Handy Splitup Start
        parms["business_id"] = AppWebConstants.businessType.rawValue
        // Handy Splitup End
        //Shared.instance.showLoaderInWindow()
        self.connectionHandler?.getRequest(for: .getPastJobs,
                                              params: parms)
            .responseDecode(to: GoferDataModel.self, { (response) in
                Shared.instance.removeLoaderInWindow()
                if let existingItems = pendingJobHistoryModel {
                    if response.currentPage > 1 {
                        existingItems.updateWithNewData(response)
                        completionHandler(.success(existingItems))
                    } else if response.currentPage == 0 {
                        completionHandler(.success(existingItems))
                    } else{
                        existingItems.data.removeAll()
                        existingItems.updateWithNewData(response)
                        completionHandler(.success(existingItems))
                    }
                } else {
                    completionHandler(.success(response))
                }
            })
            .responseFailure { (error) in
                Shared.instance.removeLoaderInWindow()
                completionHandler(.failure(CommonError.failure(error)))
            }
    }
    
    func wsToGetCompletedJobs(needCache: Bool,
                              completedJobHistoryModel :GoferDataModel?,
                              _  completionHandler : @escaping (Result<GoferDataModel,Error>) -> Void) {
        var parms = JSON()
        parms["currency_code"] = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        if let completed = completedJobHistoryModel{
            parms["page"] = completed.currentPage + 1
        }else{
            parms["page"] = 1
        }
        if needCache {
            parms["cache"] = 1
        }
        // Handy Splitup Start
        parms["business_id"] = AppWebConstants.businessType.rawValue
        // Handy Splitup End
        //Shared.instance.showLoaderInWindow()
        self.connectionHandler?.getRequest(for: .getUpCommingJobs,
                                              params: parms)
            .responseDecode(to: GoferDataModel.self, { (response) in
                if let existingItems = completedJobHistoryModel{
                    print("Array data: -> ",response.data)
                    if response.currentPage > 1 {
                        
                        existingItems.updateWithNewData(response)
                        completionHandler(.success(existingItems))
                        
                    }else if response.currentPage == 0 {
                        completionHandler(.success(existingItems))
                    }
                    else{
                        
                        existingItems.data.removeAll()
                        existingItems.updateWithNewData(response)
                        completionHandler(.success(existingItems))
                    }
                }else{
                    completionHandler(.success(response))
                }                     })
            .responseFailure { (error) in
                Shared.instance.removeLoaderInWindow()
                completionHandler(.failure(CommonError.failure(error)))
            }
    }
}
