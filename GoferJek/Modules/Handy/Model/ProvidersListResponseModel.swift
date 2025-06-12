//
//  ProvidersListResponseModel.swift
//  GoferHandy
//
//  Created by trioangle on 09/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

// MARK: - ProvidersListResponse
class ProvidersListResponse: Codable {
    let statusCode: String
    let currentPage : Int
    let totalPages : Int
    let providers: [Provider]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case providers
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
        let providers = try container.decodeIfPresent([Provider].self, forKey: .providers)
        self.providers = providers ?? []
    }

    
}
class ProviderResponse: Codable {
    let statusCode: String
    let userLocationName : String
    let userLatitude, userLongitude : Double
    let provider: Provider

    var userLocation : CLLocation{
        return .init(latitude: self.userLatitude,
                     longitude: self.userLongitude)
    }
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case provider = "provider_details"
        case userLocationName = "user_location"
        case userLatitude = "user_latitude"
        case userLongitude = "user_longitude"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        
        
        self.provider = try container.decode(Provider.self, forKey: .provider)
        self.userLocationName = container.safeDecodeValue(forKey: .userLocationName)
        self.userLatitude = container.safeDecodeValue(forKey: .userLatitude)
        self.userLongitude = container.safeDecodeValue(forKey: .userLongitude)
    }

    
}
// MARK: - Provider
class Provider: Codable {
    let providerID: Int
    let ratingCount: Int
    let providerLocation : String
    let firstName, lastName, email, mobileNo, profilePicture,serviceDescription: String
    let serviceAtMylocation: Bool
    let rating,latitude,longitude,distance : Double
    let name : String
    var gallery : [GalleryImage]
    
    let userRatingTotalPage : Int
    let galleryCount : Int
    let galleryTotalPage : Int
    var reviews: [Review]
    var categories: [Category]
    let totalItemPage : Int
    let currentPage : Int
    var location : CLLocation{
        return .init(latitude: self.latitude, longitude: self.longitude)
    }
    var galleryCurrentPage : Int = 1
    var userRatingCurrentPage : Int = 1
    //MARK:- Getters
    var bookedItems : [ServiceItem]{
        let itemsArray = self.categories.filter { (category) -> Bool in
            return category.serviceItems.anySatisfy({$0.isSelected})
        }.compactMap({$0.serviceItems.filter({$0.isSelected})})
        var singleArray = [ServiceItem]()
        for items in itemsArray{
            singleArray.append(contentsOf: items)
        }
        return singleArray
    }
    var fullName : String{
        return self.firstName + " " + self.lastName
    }
    var cartTotalPrice:Double {
        return self.bookedItems.map({$0.calculatedAmount}).reduce(0, +)
    }
    
    var cartTotalItemCount: Int {
        return self.bookedItems.map({$0.selectedQuantity}).reduce(0, +)
    }
     var integerValue : Int = {
        return 5 + 6
    }()
    var intValue = 11
    enum CodingKeys: String, CodingKey {
        case providerID = "provider_id"
        case name
        case totalItemPage = "total_item_page"
        case userRatingCurrentPage
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case ratingCount = "rating_count"
        case mobileNo = "mobile_no"
        case currentPage = "current_page"
        case serviceAtMylocation = "service_at_mylocation"
        case rating, gallery, latitude, longitude, distance//services,
        case reviews = "user_rating"
        case galleryCount = "gallery_count"
        case galleryTotalPage = "gallery_total_page"
        case userRatingTotalPage = "user_rating_total_page"
        case categories
        case profilePicture = "profile_picture"
        case serviceDescription = "service_description"
        case providerLocation = "provider_location"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerID = container.safeDecodeValue(forKey: .providerID)
        self.firstName = container.safeDecodeValue(forKey: .firstName)
        self.lastName = container.safeDecodeValue(forKey: .lastName)
        self.providerLocation = container.safeDecodeValue(forKey: .providerLocation)
        self.email = container.safeDecodeValue(forKey: .email)
        self.mobileNo = container.safeDecodeValue(forKey: .mobileNo)
        self.serviceAtMylocation = container.safeDecodeValue(forKey: .serviceAtMylocation)
        self.rating = container.safeDecodeValue(forKey: .rating)
        self.profilePicture = container.safeDecodeValue(forKey: .profilePicture)
        self.latitude = container.safeDecodeValue(forKey: .latitude)
        self.longitude = container.safeDecodeValue(forKey: .longitude)
        self.distance = container.safeDecodeValue(forKey: .distance)
        self.serviceDescription = container.safeDecodeValue(forKey: .serviceDescription)
        self.name = container.safeDecodeValue(forKey: .name)
        self.galleryCount = container.safeDecodeValue(forKey: .galleryCount)
        self.galleryTotalPage = container.safeDecodeValue(forKey: .galleryTotalPage)
        self.userRatingCurrentPage = container.safeDecodeValue(forKey: .userRatingCurrentPage)
        self.userRatingTotalPage = container.safeDecodeValue(forKey: .userRatingTotalPage)
        let gallery = try container.decodeIfPresent([GalleryImage].self, forKey: .gallery)
        self.gallery = gallery ?? []
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
        let reviews = try container.decodeIfPresent([Review].self, forKey: .reviews)
        self.reviews = reviews ?? []
        
        let categories = try container.decodeIfPresent([Category].self, forKey: .categories)
        self.categories = categories ?? []
        self.totalItemPage = container.safeDecodeValue(forKey: .totalItemPage)
        self.ratingCount = container.safeDecodeValue(forKey: .ratingCount)
        //        let services = try container.decodeIfPresent([Service].self, forKey: .services)
        //        self.services = services ?? []
    }
    
}
extension Provider : Equatable{
    static func == (lhs: Provider, rhs: Provider) -> Bool {
        return lhs.providerID == rhs.providerID
    }
    
    
}
// MARK: - ReviewModel
class Review : Codable{
    let userID: Int
    let comments: String
    let rating: Double
    let userName, userImage : String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case rating
        case comments
        case userName = "user_name"
        case userImage = "user_image"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = container.safeDecodeValue(forKey: .userID)
        self.comments = container.safeDecodeValue(forKey: .comments)
        self.rating = container.safeDecodeValue(forKey: .rating)
        self.userName = container.safeDecodeValue(forKey: .userName)
        self.userImage = container.safeDecodeValue(forKey: .userImage)
    }
}
// MARK: - GalleryImage
class GalleryImage : Codable{
    let image : String
    
    enum CodingKeys: String, CodingKey {
        case image
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = container.safeDecodeValue(forKey: .image)
    }
}

//class ProviderMoreDetail : Codable {
//    let statusCode : String
//    let statusMessage : String
//    let currentPage : Int
//    let gallery : [GalleryImage]
//    let galleryCount : Int
//    let galleryTotalpage : Int
//    let userRatings : [Review]
//    let userRatingTotalPage : Int
//    enum CodingKeys: String, CodingKey {
//        case statusCode = "status_code"
//        case statusMessage = "status_message"
//        case currentPage = "current_page"
//        case userRatings = "user_rating"
//        case userRatingTotalPage = "user_rating_total_page"
//        case gallery
//        case galleryCount = "gallery_count"
//        case galleryTotalCount = "gallery_total_count"
//
//    }
//    required init(from decoder : Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
//        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
//        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
//        let reviews = try container.decodeIfPresent([Review].self, forKey: .userRatings)
//        self.userRatings = reviews ?? []
//        self.userRatingTotalPage = container.safeDecodeValue(forKey: .userRatingTotalPage)
//        self.galleryCount = container.safeDecodeValue(forKey: .galleryCount)
//        self.galleryTotalpage = container.safeDecodeValue(forKey: .galleryTotalCount)
//        let gallery = try container.decodeIfPresent([GalleryImage].self, forKey: .gallery)
//        self.gallery = gallery ?? []
//    }
//}

// MARK: - ServiceItem
class ServiceItem: Codable,Equatable {
    static func == (lhs: ServiceItem, rhs: ServiceItem) -> Bool {
            lhs.itemName == rhs.itemName &&
            lhs.itemID == rhs.itemID &&
            lhs.itemDescription == rhs.itemDescription &&
            lhs.location == rhs.location &&
            lhs.priceType == rhs.priceType &&
            lhs.baseFare == rhs.baseFare &&
            lhs.minimumFare == rhs.minimumFare &&
            lhs.minimumHours == rhs.minimumHours &&
            lhs.perMins == rhs.perMins &&
            lhs.perKilometer == rhs.perKilometer &&
            lhs.currencySymbol == rhs.currencySymbol &&
            lhs.currencyCode == rhs.currencyCode &&
            lhs.maximumQuantity == rhs.maximumQuantity &&
            lhs.color == rhs.color
    }
    
    
    let itemName: String
    let itemID: Int
    let itemDescription: String?
    let location: Location
    let priceType: PriceType
    let baseFare, minimumFare: Double
    let minimumHours:  Int
    let perMins, perKilometer: Double
    let currencySymbol: String
    let currencyCode: String
    let maximumQuantity:Int
    var color: UIColor
    //MARK:- Getters
    var isSelected : Bool{
        get{return self.selectedQuantity != 0}
        set{
            if newValue{
                self.selectedQuantity = self.selectedQuantity == 0 ? 1 : self.selectedQuantity
            }else{
                self.selectedQuantity = 0
            }
        }
    }
    var param : String{
        let description = self.specialServiceDescription
        let quantity = self.selectedQuantity
        let id = self.itemID
        return "{\"instruction\":\"\(description)\",\"quantity\":\"\(quantity)\",\"service_type_id\":\"\(id)\"}"
        
    }
    var selectedQuantity = 0
    var specialServiceDescription = String()
    var isCustomItem = false
    var calculatedAmount : Double{
        guard !self.isCustomItem else{
            return self.baseFare
        }
        var totalPrice = Double()
        
        
        switch self.priceType {
            
        case .fixed:
            totalPrice = self.baseFare  * Double(selectedQuantity)
        case .hourly:
            totalPrice = (Double(self.minimumHours) * self.baseFare )
        case .distance:
//            totalPrice = Double(self.perKilometer) + Double(self.perMins) +  baseFare
            if baseFare > minimumFare{
                totalPrice = baseFare

            }else{
                totalPrice = minimumFare
            }

        case .none:
            totalPrice = 0.0
        }
        if totalPrice < 0{
            return 0.0
        }else{
            return totalPrice
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case itemName = "item_name"
        case itemID = "item_id"
        case itemDescription = "item_description"
        case location
        case priceType = "price_type"
        case baseFare = "base_fare"
        case minimumHours = "minimum_hours"
        case minimumFare = "minimum_fare"
        case perMins = "per_mins"
        case perKilometer = "per_kilometer"
        case currencySymbol = "currency_symbol"
        case currencyCode = "currency_code"
        case maximumQuantity = "max_quantity"
    }
    init(customWithName name : String,amount : Double,priceType: PriceType,color: UIColor){
        self.itemName = name
        self.baseFare = amount
        self.isCustomItem = true
        
        
        self.itemDescription = ""
        self.location = Location.all
        self.priceType = priceType
        self.minimumHours = 0
        self.minimumFare = 0
        self.perMins = 0
        self.perKilometer = 0
        self.currencySymbol = ""
        self.currencyCode = ""
        self.maximumQuantity = 0
        self.itemID = 0
        self.selectedQuantity = 0
        self.color = color
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemName = container.safeDecodeValue(forKey: .itemName)
        self.itemDescription = container.safeDecodeValue(forKey: .itemDescription)
        let location = try container.decodeIfPresent(Location.self, forKey: .location)
        let price = try container.decodeIfPresent(PriceType.self, forKey: .priceType)
        self.location = location ?? Location.all
        
        self.priceType = price ?? PriceType.hourly
        self.baseFare = container.safeDecodeValue(forKey: .baseFare)
        self.minimumHours = container.safeDecodeValue(forKey: .minimumHours)
        self.minimumFare = container.safeDecodeValue(forKey: .minimumFare)
        self.perMins = container.safeDecodeValue(forKey: .perMins)
        self.perKilometer = container.safeDecodeValue(forKey: .perKilometer)
        self.currencySymbol = container.safeDecodeValue(forKey: .currencySymbol)
        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
        // MARK: As of now done with constantly
        self.maximumQuantity = container.safeDecodeValue(forKey: .maximumQuantity)
        self.itemID = container.safeDecodeValue(forKey: .itemID)
        self.color = .black
    }
    init(copyFrom data : ServiceItem){
        self.itemName = data.itemName
        self.itemDescription = data.itemDescription
        self.location = data.location
        self.specialServiceDescription = data.specialServiceDescription
        
        self.priceType = data.priceType
        self.baseFare = data.baseFare
        self.minimumHours = data.minimumHours
        self.minimumFare = data.minimumFare
        self.perMins = data.perMins
        self.perKilometer = data.perKilometer
        self.currencySymbol = data.currencySymbol
        self.currencyCode = data.currencyCode
        self.maximumQuantity = data.maximumQuantity
        self.itemID = data.itemID
        self.selectedQuantity = data.selectedQuantity
        self.color = .black
    }
    func update(from data : ServiceItem){
        self.selectedQuantity = data.selectedQuantity
        self.specialServiceDescription = data.specialServiceDescription
    }
    
}



enum Location: String, Codable {
    case all = "All"
    
}

