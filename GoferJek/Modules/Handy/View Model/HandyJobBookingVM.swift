//
//  HandyBookingVM.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


class HandyJobBookingVM : BaseViewModel{
    var isFirstTimeLoading : Bool = false
    override init() {
        super.init()
    }
    //MARK:- CalendarVC
    private var dates : [Date] = []
    
    func getCurrentMonthDataSource() -> [Date]{
        let today = Date()
        let datesOfThisMonth = today.getDatesForMonth()
        self.dates = datesOfThisMonth.filter({$0 >= today})
        return self.dates
    }
    ///returning nearly 4 months data alone
    func getOneYearsDataSource() -> [Date]{
        
        return Date.get30Dates()
//        var yearDates = [Date]()
//        let currentMonth = self.getCurrentMonthDataSource()
//        yearDates.append(contentsOf: currentMonth)
//
//        for _ in 0..<2{
//            let nextMonth = self.getNextMonthDataSource()
//            yearDates.append(contentsOf: nextMonth)
//        }
//        return yearDates
    }
//    var currentPage = 1
    
    func getService(currentPage: Int,params: JSON,_ result : @escaping Closure<Result<Service,Error>>) {
        
        var param:JSON
            param = params
            param["page"] = currentPage
       
        
        
        self.connectionHandler?
            .getRequest(for: .getServiceCategory,
                        params: param)
            
            .responseDecode(to: Service.self,
                            { (response) in
                                result(.success(response))
                            })
            .responseFailure({ (error) in
                                result(.failure(CommonError.failure(error)))
                            })
        
    }
    
    var userRatingPageCount = 2
    var userGalleryPageCount = 2
    var userServicePageCount = 2
    func getMoreDetails(userServicePageCount: Int,param :JSON,type: ProfileCategories,_ result : @escaping Closure<Result<Provider,Error>>) {
        
        var params:JSON
            params = param
        switch type {
        case .services:
            params["page"] = userServicePageCount
        case .gallery:
            params["page"] = userServicePageCount
        case .ratings:
            params["page"] = userServicePageCount
        }
            
       
        self.connectionHandler?
            .getRequest(for: .details,
                        params: params)
            .responseDecode(to: Provider.self,
                            { (response) in
                                switch type {
                                case .services:
                                    if response.currentPage == response.totalItemPage {
                                        self.userServicePageCount = response.currentPage + 1
                                    } else {
                                        self.userServicePageCount += 1
                                    }
                                case .gallery:
                                    response.galleryCurrentPage = self.userGalleryPageCount
                                    if response.galleryTotalPage == self.userGalleryPageCount{
                                        self.userGalleryPageCount = response.currentPage + 1
                                    } else {
                                        self.userGalleryPageCount += 1
                                    }
                                case .ratings:
                                    response.userRatingCurrentPage = self.userRatingPageCount
                                    if response.userRatingTotalPage == self.userRatingPageCount {
                                        self.userRatingPageCount = response.userRatingTotalPage + 1
                                    } else {
                                        self.userRatingPageCount += 1
                                    }
                                }
                                result(.success(response))
                                Shared.instance.removeLoaderInWindow()
                            }).responseFailure({ (error) in
                                self.userRatingPageCount = 2
                                Shared.instance.removeLoaderInWindow()
                                result(.failure(CommonError.failure(error)))
                            })
    }
    
    func getNextMonthDataSource() -> [Date]{
        
        let today = Date()
        let currentMonthDate = self.dates.last ?? Date()
        let nexMonth = Date(timeInterval: 86400 * 2, since: currentMonthDate)
        let datesOfTheMonth = nexMonth.getDatesForMonth()
        self.dates = datesOfTheMonth.filter({$0 >= today})
        return self.dates
    }
    func getPrevMonthDataSource() -> [Date]{
        
        let today = Date()
        let currentMonthDate = self.dates.first ?? Date()
        let prevMonth = Date(timeInterval: 86400 * -2, since: currentMonthDate)
        let datesOfTheMonth = (prevMonth).getDatesForMonth()
        self.dates = datesOfTheMonth.filter({$0 >= today})
        return self.dates
    }
    func wsToGetAvailablity(for provider : Provider?,providerId : Int? = nil,
                            _ result : @escaping Closure<Result<AvailabilityModel,Error>>){
        var params = JSON()
        if let providerID = provider?.providerID{
            params["provider_id"] = providerID
        }
        if let providerID = providerId {
            params["provider_id"] = providerID
        }
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?
            .getRequest(for: .providersAvailability,
                        params: params)
            .responseDecode(to: AvailabilityModel.self,
                            { (response) in
                                Shared.instance.removeLoaderInWindow()
                                result(.success(response))
            }).responseFailure({ (error) in
                Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
    
    //MARK:- SearchLocationVC
    

    func wsToUpdatePersonalLocation(latitude: CLLocationDegrees,
                                    longitude: CLLocationDegrees,
                                    locationName: String,
                                    locationType : UserLocationType){
        var params = JSON()
        params["latitude"] = String(format:"%f",latitude)
        params["longitude"] = String(format:"%f",longitude)
        
        if locationType == .Home{
            params["home"] = locationName
        }  else {
            params["work"] = locationName
        }
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.connectionHandler?
            .getRequest(for: .updateRiderLocation,
                        params: params)
            .responseJSON({ (json) in
                if json.isSuccess{
                    //                    self.setLocationName(latitude: latitude, longitude: longitude, locationName: locationName)
                    //                    self.tblLocations.reloadData()
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
//                AppDelegate.shared.createToastMessage(error)
            })
        
    }
    func wsToGetServiceListDetails(param : JSON,_ result : @escaping Closure<Result<ServiceResponse,Error>>) {
        if !isFirstTimeLoading {
            Shared.instance.showLoaderInWindow()
        }
        self.connectionHandler?
            .getRequest(for: .getServices,
                        params: param)
            .responseDecode(to: ServiceResponse.self,
                            { (response) in
                                if !self.isFirstTimeLoading {
                                    Shared.instance.removeLoaderInWindow()
                                    self.isFirstTimeLoading = true
                                }
                            
                                
                                result(.success(response))
            }).responseFailure({ (error) in
                if !self.isFirstTimeLoading {
                    Shared.instance.removeLoaderInWindow()
                    self.isFirstTimeLoading = false
                }
                result(.failure(CommonError.failure(error)))
            })
        
    }
    
//    var providerCurrentPage = 1
    func wsToGetProviderListDetails(for service : Service,providerCurrentPage : Int,
                                    _ result : @escaping Closure<Result<ProvidersListResponse,Error>>) {
        
//        if isReset {
//            self.providerCurrentPage = 1
//        }
        
        var params : JSON = [
            "page" : providerCurrentPage,
            "service_id" : service.serviceID,
            "category_id" : service.categories.filter({$0.isSelected}).compactMap({$0.categoryID.description}).joined(separator: ",")
        ]
        for item in Shared.instance.currentBookingType.getParams{
            params[item.key] = item.value
        }
        self.connectionHandler?
            .getRequest(for: .getProvidersList,
                        params: params)
            .responseDecode(to: ProvidersListResponse.self,
                            { (response) in
                                result(.success(response))
            }).responseFailure({ (error) in
                result(.failure(CommonError.failure(error)))
            })
        
    }
    
    //MARK: -- get filtered algorithm wise provider list
    func GetFilteredProvidersList(for services : [SelectedService],
                                  with location : CLLocation? = nil,
                                    _ result : @escaping Closure<Result<ProvidersListResponse,Error>>) {
        var cat_ids: [Int] = []
        services.forEach({ service in
            let catIds = service.selectedCategories.map { $0.categoryID }
            cat_ids.append(contentsOf: catIds)
        })
        
        var params : JSON = [
            "category_id" : cat_ids.compactMap({$0.description})
        ]
        guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else {return}
        params["latitude"] = String(format:"%f",latitude)
        params["longitude"] = String(format:"%f",longitude)
        
        self.connectionHandler?
            .getRequest(for: .getSelectedService,
                        params: params)
            .responseDecode(to: ProvidersListResponse.self,
                            { (response) in
                                result(.success(response))
            }).responseFailure({ (error) in
                result(.failure(CommonError.failure(error)))
            })
        
    }
    
    //MARK:- Provider detail
    func wsToGetProviderDetail(for service : Service? = nil,
                               using provider : Provider,
                               with cat_ids: [Int]? = nil,
                               _ result : @escaping Closure<Result<ProviderResponse,Error>>){
        
        // For Resetting Purpose
        self.userRatingPageCount = 2
        self.userGalleryPageCount = 2
        self.userServicePageCount = 2
        let cat_ids = cat_ids?.map({$0.description}).joined(separator: ",")
        print(cat_ids ?? "")
        let params : JSON = [
            "provider_id" : provider.providerID,
            "category_id" : cat_ids ?? ""//service.categories.filter({$0.isSelected}).compactMap({$0.categoryID.description}).joined(separator: ",")
        ]
             Shared.instance.showLoaderInWindow()
             self.connectionHandler?
                 .getRequest(for: .getProviderDetail,
                             params: params)
                 .responseDecode(to: ProviderResponse.self,
                                 { (response) in
                                 Shared.instance.removeLoaderInWindow()
                                     result(.success(response))
                 }).responseFailure({ (error) in
                 Shared.instance.removeLoaderInWindow()
                     result(.failure(CommonError.failure(error)))
                 })
    }
    //MARK:- Provider detail
    func wsToBook(provider : Provider?,
                  atUserLocation : Bool,
                  providerId : Int = 0,
                  jobReqID : Int = 0,promoId : Int = 0,
                  _ result : @escaping Closure<Result<JSON,Error>>){
        var params = JSON()
        if let provider = provider {
            params  = [
                "provider_id" : provider.providerID,
                "job_at_user" : atUserLocation ? "true" : "false",
                "payment_method" : (PaymentOptions.default ?? .cash ).paramValue,
                "services" : "[\(provider.bookedItems.compactMap({$0.param}).joined(separator: ","))]"
            ]
        } else {
            params  = [
                "provider_id" : providerId,
                "request_id" : jobReqID
            ]
        }
        for item in Shared.instance.currentBookingType.getParams{
            params[item.key] = item.value
        }
        
        if let promoId:Int = promoId == 0 ? UserDefaults.value(for: .promo_id): promoId,
           promoId != 0 {
            params["promo_id"] = promoId
        } else {
            params["promo_id"] = 0
        }
        params["is_wallet"] = Constants().GETVALUE(keyname: USER_SELECT_WALLET)
        
        self.connectionHandler?
            .getRequest(for: .bookJob,
                        params: params)
            .responseJSON({ (json) in
                result(.success(json))
            })
            .responseFailure({ (error) in
                result(.failure(CommonError.failure(error)))
            })
    }
    func wsTocancelJobRequest(_ request : Int,type: Int,completionHandler : @escaping (Result<Bool,Error>) -> Void)
    {
        let params = [
            "group_id":request,
            "type":type
        ]
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?.getRequest(for: APIEnums.cancelJobRequest, params: params)
            .responseJSON({ (json) in
                Shared.instance.removeLoaderInWindow()
                if json.isSuccess{
                    completionHandler(.success(true))
                }else{
                    completionHandler(.failure(CommonError.failure(json.status_message)))
                    
                }
            })
            .responseFailure { (error) in
                Shared.instance.removeLoaderInWindow()
                print(error)
                completionHandler(.failure(CommonError.failure(error)))
        }
        
    }
    
    func getHomeScreenJobProgress( _ result : @escaping Closure<Result<JSON,Error>>) {
        let params = JSON()
        
        self.connectionHandler?
            .getRequest(for: .getHomeScreenJob,
                        params: params)
            .responseJSON({ (json) in
                result(.success(json))
            })
            .responseFailure({ (error) in
                result(.failure(CommonError.failure(error)))
            })
    }
}
