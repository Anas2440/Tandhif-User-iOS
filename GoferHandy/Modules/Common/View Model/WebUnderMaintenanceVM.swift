//
//  WebUnderMaintenanceVM.swift
//  GoferHandy
//
//  Created by trioangle on 03/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
class WebUnderMaintenanceVM: BaseViewModel {
    func getStart(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler?.getRequest(for: .language_content, params: param).responseJSON({ (json) in
            if json.isSuccess {
                result(.success(json))
            } else {
                result(.failure(CommonError.failure(json.status_message)))
            }
        }).responseFailure({ (error) in
            result(.failure(CommonError.failure(error)))
        })
    }
}
