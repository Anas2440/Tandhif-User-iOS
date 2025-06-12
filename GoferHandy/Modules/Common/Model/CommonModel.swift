//
//  CommonModel.swift
//  Goferjek
//
//  Created by Trioangle on 29/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

class CommonModel : Codable {
    let statusCode, statusMessage: String
    var isSuccess : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
    init(statusCode: String, statusMessage: String) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.isSuccess = self.statusCode != "0"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.isSuccess = self.statusCode != "0"
    }
}
