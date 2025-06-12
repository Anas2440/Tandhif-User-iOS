//
//  CallerDetailModel.swift
//  Goferjek
//
//  Created by Trioangle on 29/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

// MARK: - CallerDetailModel
class CallerDetailModel: Codable {
    let statusCode, statusMessage, firstName, lastName: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"
    }

    init(statusCode: String, statusMessage: String, firstName: String, lastName: String, profileImage: String) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.firstName = container.safeDecodeValue(forKey: .firstName)
        self.lastName = container.safeDecodeValue(forKey: .lastName)
        self.profileImage = container.safeDecodeValue(forKey: .profileImage)
    }
}
