//
//  ServiceResponseModel.swift
//  GoferHandy
//
//  Created by Trioangle on 08/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

// MARK: - ServiceResponse
class ServiceResponse: Codable {
    let statusCode: String
    let statusMessage: String
    let services: [Service]
    let previousBooked: [Service] // <-- 1. ADD THIS PROPERTY

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case services
        case previousBooked = "previous_booked" // <-- 2. ADD THIS CODING KEY
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        
        let services = try container.decodeIfPresent([Service].self, forKey: .services)
        self.services = services ?? []
        
        // --- 3. ADD THIS DECODING LOGIC ---
        let previousBookedServices = try container.decodeIfPresent([Service].self, forKey: .previousBooked)
        self.previousBooked = previousBookedServices ?? []
        // --- END OF ADDED BLOCK ---
    }
}

// MARK: - Service
class Service: Codable, Equatable {
    static func == (lhs: Service, rhs: Service) -> Bool {
        lhs.serviceID == rhs.serviceID &&
        lhs.serviceName == rhs.serviceName &&
        lhs.businessType == rhs.businessType &&
        lhs.imageIcon == rhs.imageIcon &&
        lhs.bannerImage == rhs.bannerImage &&
        lhs.categories == rhs.categories
    }
    
    let serviceID: Int
    let serviceName, businessType: String
    let imageIcon, bannerImage: String
    let currentPage, totalPages : Int
    var categories: [Category]
    let serviceDescription : String

    enum CodingKeys: String, CodingKey {
        case serviceID = "service_id"
        case serviceName = "service_name"
        case businessType = "business_type"
        case imageIcon = "image_icon"
        case bannerImage = "banner_image"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case categories = "service_category_list"
        case serviceDescription = "service_description"
    }

    required init(from decoder : Decoder)  throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.serviceID = container.safeDecodeValue(forKey: .serviceID)
        self.serviceName = container.safeDecodeValue(forKey: .serviceName)
        self.businessType = container.safeDecodeValue(forKey: .businessType)
        self.imageIcon = container.safeDecodeValue(forKey: .imageIcon)
        self.bannerImage = container.safeDecodeValue(forKey: .bannerImage)
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        let categories = try container.decodeIfPresent([Category].self, forKey: .categories)
        self.categories = categories ?? []
        self.serviceDescription = container.safeDecodeValue(forKey: .serviceDescription)
    }
 
}

// MARK: - Category
class Category: Codable , Equatable{
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.categoryID == rhs.categoryID &&
        lhs.categoryName == rhs.categoryName &&
        lhs.categoryImage == rhs.categoryImage &&
        lhs.serviceItems == rhs.serviceItems 
    }
    
    let categoryID: Int
    let categoryName: String
    let categoryImage : String
    var serviceItems : [ServiceItem]
    var currentPage : Int = 1
    var isViewMoreNeedToShow : Bool = false
    let totalItemPage : Int
    var isSelected = false
   
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case categoryName = "category_name"
        case categoryImage = "image"
        case serviceItems = "items"
        case currentPage = "current_page"
        case totalItemPage = "total_item_page"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categoryID = container.safeDecodeValue(forKey: .categoryID)
        self.categoryName = container.safeDecodeValue(forKey: .categoryName)
        self.categoryImage = container.safeDecodeValue(forKey: .categoryImage)
        self.totalItemPage = container.safeDecodeValue(forKey: .totalItemPage)
         let serviceItems = try container.decodeIfPresent([ServiceItem].self, forKey: .serviceItems)
        self.serviceItems = serviceItems ?? []
        self.isViewMoreNeedToShow = ((self.totalItemPage - self.currentPage) != 0) && ((self.totalItemPage - self.currentPage) > 0)
    }

}


//class ServicesItem: Codable {
//    let itemName: String
//    let itemDescription: String
//    let location, priceType, baseFare: String
//    let minimumHours, minimumFare, perMins, perKilometer: Int
//    let currencySymbol, currencyCode: String
//
//    enum CodingKeys: String, CodingKey {
//        case itemName
//        case itemDescription = "item_description"
//        case location
//        case priceType = "price_type"
//        case baseFare = "base_fare"
//        case minimumHours = "minimum_hours"
//        case minimumFare = "minimum_fare"
//        case perMins = "per_mins"
//        case perKilometer = "per_kilometer"
//        case currencySymbol = "currency_symbol"
//        case currencyCode = "currency_code"
//    }
//
//    required init(from decoder : Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.itemName = container.safeDecodeValue(forKey: .itemName)
//        self.itemDescription = container.safeDecodeValue(forKey: .itemDescription)
//        self.location = container.safeDecodeValue(forKey: .location)
//
//         self.priceType = container.safeDecodeValue(forKey: .priceType)
//         self.baseFare = container.safeDecodeValue(forKey: .baseFare)
//         self.minimumHours = container.safeDecodeValue(forKey: .minimumHours)
//         self.minimumFare = container.safeDecodeValue(forKey: .minimumFare)
//         self.perMins = container.safeDecodeValue(forKey: .perMins)
//         self.perKilometer = container.safeDecodeValue(forKey: .perKilometer)
//         self.currencySymbol = container.safeDecodeValue(forKey: .currencySymbol)
//        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
//    }
//}

