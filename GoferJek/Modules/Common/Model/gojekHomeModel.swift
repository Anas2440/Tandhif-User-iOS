//
//  gojekHomeModel.swift
//  GoferHandy
//
//  Created by Trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

//------------------------------------
// MARK: - GojeckServiceHome
//------------------------------------

class GojeckServiceHome : Codable {
    let statusCode, statusMessage: String
    let service: [GojekService]
    let banner: [GojekBanner]
    let address: String
    let latitude : String
    let longitude : String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case service, banner
        case address
        case latitude = "lat"
        case longitude = "lng"
    }

    init(statusCode: String,
         statusMessage: String,
         service: [GojekService],
         banner: [GojekBanner],
         address: String,
         latitude : String,
         longitude : String) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.service = service
        self.banner = banner
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        let service = try container.decodeIfPresent([GojekService].self, forKey: .service)
        self.service = service ?? []
        let banner = try container.decodeIfPresent([GojekBanner].self, forKey: .banner)
        self.banner = banner ?? []
        self.address = container.safeDecodeValue(forKey: .address)
        self.latitude = container.safeDecodeValue(forKey: .latitude)
        self.longitude = container.safeDecodeValue(forKey: .longitude)
    }
}

//------------------------------------
// MARK: - Banner
//------------------------------------

class GojekBanner: Codable {
    let title, bannerDescription: String
    let image: String
    let serviceID: Int
    let categoryID : Int
    let is18PlusReq : Bool
    let isReciptReq : Bool
    let backgroundColorCode, textColorCode: String
    let isSingleSubService : Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case bannerDescription = "description"
        case image
        case serviceID = "service_id"
        case backgroundColorCode = "background_color_code"
        case textColorCode = "text_color_code"
        case categoryID = "category_id"
        case is18PlusReq = "is_18_plus_req"
        case isReciptReq = "receipt_image_req"
        case isSingleSubService = "single_sub_service"
    }
    
    init(title: String,
         bannerDescription: String,
         image: String,
         serviceID: Int,
         backgroundColorCode: String,
         textColorCode: String) {
        self.title = title
        self.bannerDescription = bannerDescription
        self.image = image
        self.serviceID = serviceID
        self.backgroundColorCode = backgroundColorCode
        self.textColorCode = textColorCode
        self.categoryID = 1
        self.is18PlusReq = false
        self.isReciptReq = false
        self.isSingleSubService = false
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = container.safeDecodeValue(forKey: .title)
        self.bannerDescription = container.safeDecodeValue(forKey: .bannerDescription)
        self.image = container.safeDecodeValue(forKey: .image)
        self.serviceID  = container.safeDecodeValue(forKey: .serviceID)
        self.backgroundColorCode = container.safeDecodeValue(forKey: .backgroundColorCode)
        self.textColorCode = container.safeDecodeValue(forKey: .textColorCode)
        self.categoryID = container.safeDecodeValue(forKey: .categoryID)
        self.is18PlusReq = container.safeDecodeValue(forKey: .is18PlusReq)
        self.isReciptReq = container.safeDecodeValue(forKey: .isReciptReq)
        self.isSingleSubService = container.safeDecodeValue(forKey: .isSingleSubService)
    }
}

//------------------------------------
// MARK: - Service
//------------------------------------

class GojekService: Codable {
    let id : Int
    let name: String
    let serviceDescription: String
    let image: String
    let icon : String
    let isAvailable : Bool
    let locationError : String
    var busineesType : BusinessType
    let categoryID : Int
    let is18PlusReq : Bool
    let isReciptReq : Bool
    let isSingleSubService : Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case serviceDescription = "description"
        case image
        case id = "service_id"
        case icon
        case isAvailable = "is_available"
        case locationError = "location_error"
        case categoryID = "category_id"
        case is18PlusReq = "is_18_plus_req"
        case isReciptReq = "receipt_image_req"
        case isSingleSubService = "single_sub_service"
    }
    
    init(name: String,
         serviceDescription: String,
         image: String,
         icon : String,
         id : Int,
         isAvailable : Bool,
         locationError : String,
         busineesType: BusinessType) {
        self.name = name
        self.serviceDescription = serviceDescription
        self.image = image
        self.icon = icon
        self.id = id
        self.locationError = locationError
        self.isAvailable = isAvailable
        self.busineesType = busineesType
        self.categoryID = 0
        self.is18PlusReq = false
        self.isReciptReq = false
        self.isSingleSubService = false
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.serviceDescription = container.safeDecodeValue(forKey: .serviceDescription)
        self.icon  = container.safeDecodeValue(forKey: .icon)
        self.image = container.safeDecodeValue(forKey: .image)
        self.name = container.safeDecodeValue(forKey: .name)
        self.locationError = container.safeDecodeValue(forKey: .locationError)
        self.isAvailable = container.safeDecodeValue(forKey: .isAvailable)
        self.busineesType = BusinessType.init(rawValue: self.id) ?? .Gojek
        self.categoryID = container.safeDecodeValue(forKey: .categoryID)
        self.is18PlusReq = container.safeDecodeValue(forKey: .is18PlusReq)
        self.isReciptReq = container.safeDecodeValue(forKey: .isReciptReq)
        self.isSingleSubService = container.safeDecodeValue(forKey: .isSingleSubService)
    }
}
