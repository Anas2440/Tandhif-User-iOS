//
//  ProviderAPIResponse.swift
//  GoferHandy
//
//  Created by Anas  on 19/05/25.
//


import Foundation
import CoreLocation

// MARK: - Root Response
class ProviderAPIResponse: Decodable {
    let statusCode: String
    let statusMessage: String
    let promoDetails: [String]
    let providerDetails: Provider

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case promoDetails = "promo_details"
        case providerDetails = "provider_details"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.promoDetails = try container.decodeIfPresent([String].self, forKey: .promoDetails) ?? []
        self.providerDetails = try container.decode(Provider.self, forKey: .providerDetails)
    }
}

// MARK: - ProviderDetails
class ProviderDetails: Decodable {
    let providerID: Int
    let name: String
    let serviceDescription: String
    let profilePicture: String?
    let rating: Double
    let ratingCount: Int
    let gallery: [GalleryImage]
    let galleryCount: Int
    let galleryTotalPage: Int
    let userRating: [Review]
    let userRatingTotalPage: Int
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case providerID = "provider_id"
        case name
        case serviceDescription = "service_description"
        case profilePicture = "profile_picture"
        case rating
        case ratingCount = "rating_count"
        case gallery
        case galleryCount = "gallery_count"
        case galleryTotalPage = "gallery_total_page"
        case userRating = "user_rating"
        case userRatingTotalPage = "user_rating_total_page"
        case categories
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerID = container.safeDecodeValue(forKey: .providerID)
        self.name = container.safeDecodeValue(forKey: .name)
        self.serviceDescription = container.safeDecodeValue(forKey: .serviceDescription)
        self.profilePicture = try? container.decodeIfPresent(String.self, forKey: .profilePicture)
        self.rating = container.safeDecodeValue(forKey: .rating)
        self.ratingCount = container.safeDecodeValue(forKey: .ratingCount)
        self.gallery = try container.decodeIfPresent([GalleryImage].self, forKey: .gallery) ?? []
        self.galleryCount = container.safeDecodeValue(forKey: .galleryCount)
        self.galleryTotalPage = container.safeDecodeValue(forKey: .galleryTotalPage)
        self.userRating = try container.decodeIfPresent([Review].self, forKey: .userRating) ?? []
        self.userRatingTotalPage = container.safeDecodeValue(forKey: .userRatingTotalPage)
        self.categories = try container.decodeIfPresent([Category].self, forKey: .categories) ?? []
    }
}

// MARK: - Category
//class Category: Decodable {
//    let categoryID: Int
//    let categoryName: String
//    let items: [ServiceItem]
//    let currentPage: Int
//    let totalItemPage: Int
//
//    enum CodingKeys: String, CodingKey {
//        case categoryID = "category_id"
//        case categoryName = "category_name"
//        case items
//        case currentPage = "current_page"
//        case totalItemPage = "total_item_page"
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.categoryID = container.safeDecodeValue(forKey: .categoryID)
//        self.categoryName = container.safeDecodeValue(forKey: .categoryName)
//        self.items = try container.decodeIfPresent([ServiceItem].self, forKey: .items) ?? []
//        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
//        self.totalItemPage = container.safeDecodeValue(forKey: .totalItemPage)
//    }
//}

// MARK: - ServiceItem
//class ServiceItem: Decodable {
//    let itemID: Int
//    let itemName: String
//    let itemDescription: String
//    let fereID: Int
//    let priceType: Int
//    let baseFare: String
//    let maxQuantity: String
//    let minimumHours: String
//    let perMins: String
//    let minimumFare: String
//    let perKilometer: String
//    let currencySymbol: String
//    let currencyCode: String
//
//    enum CodingKeys: String, CodingKey {
//        case itemID = "item_id"
//        case itemName = "item_name"
//        case itemDescription = "item_description"
//        case fereID = "fere_id"
//        case priceType = "price_type"
//        case baseFare = "base_fare"
//        case maxQuantity = "max_quantity"
//        case minimumHours = "minimum_hours"
//        case perMins = "per_mins"
//        case minimumFare = "minimum_fare"
//        case perKilometer = "per_kilometer"
//        case currencySymbol = "currency_symbol"
//        case currencyCode = "currency_code"
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.itemID = container.safeDecodeValue(forKey: .itemID)
//        self.itemName = container.safeDecodeValue(forKey: .itemName)
//        self.itemDescription = container.safeDecodeValue(forKey: .itemDescription)
//        self.fereID = container.safeDecodeValue(forKey: .fereID)
//        self.priceType = container.safeDecodeValue(forKey: .priceType)
//        self.baseFare = container.safeDecodeValue(forKey: .baseFare)
//        self.maxQuantity = container.safeDecodeValue(forKey: .maxQuantity)
//        self.minimumHours = container.safeDecodeValue(forKey: .minimumHours)
//        self.perMins = container.safeDecodeValue(forKey: .perMins)
//        self.minimumFare = container.safeDecodeValue(forKey: .minimumFare)
//        self.perKilometer = container.safeDecodeValue(forKey: .perKilometer)
//        self.currencySymbol = container.safeDecodeValue(forKey: .currencySymbol)
//        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
//    }
//}

// MARK: - GalleryImage
//class GalleryImage: Decodable {
//    let image: String?
//
//    enum CodingKeys: String, CodingKey {
//        case image
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.image = try? container.decodeIfPresent(String.self, forKey: .image)
//    }
//}

// MARK: - Review
//class Review: Decodable {
//    let userID: Int
//    let userName: String
//    let userImage: String
//    let rating: Double
//    let comments: String
//
//    enum CodingKeys: String, CodingKey {
//        case userID = "user_id"
//        case userName = "user_name"
//        case userImage = "user_image"
//        case rating
//        case comments
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.userID = container.safeDecodeValue(forKey: .userID)
//        self.userName = container.safeDecodeValue(forKey: .userName)
//        self.userImage = container.safeDecodeValue(forKey: .userImage)
//        self.rating = container.safeDecodeValue(forKey: .rating)
//        self.comments = container.safeDecodeValue(forKey: .comments)
//    }
//}
