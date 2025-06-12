//
//  BaseViewModel.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


class BaseViewModel : NSObject{
    lazy var connectionHandler : ConnectionHandler? = {
        return ConnectionHandler()
    }()
    
    override init() {
        super.init()
    }
    
    func wsToGetCommonData(_ result : @escaping Closure<Result<CommonDataModel,Error>>){
        self.connectionHandler?
            .getRequest(for: .getEssetntials, params: [:])
            .responseDecode(to: CommonDataModel.self, { response in
                if response.statusCode == "1" {
                    self.connectionHandler?.handleEssentials(response)
                    result(.success(response))
                } else {
                    result(.failure(CommonError.failure(response.statusMessage)))
                }
            })
            .responseFailure({ (error) in
                result(.failure(CommonError.failure(error)))
            })
    }
    fileprivate var locationHandler : LocationHandlerProtocol?
    func getCurrentLocation(_ fetchedLocation : @escaping Closure<MyLocationModel>){
        self.locationHandler = LocationHandler.default()
        if let lastLoc = self.locationHandler?.lastKnownLocation,
            lastLoc.timestamp.timeIntervalSince(Date()) < 1200{
                fetchedLocation(MyLocationModel(location: lastLoc))
                self.locationHandler?.startListening(toLocationChanges: false)
                self.locationHandler?.removeObserver(in: self)
            return
        }
            
        self.locationHandler?.addObserver(in: self) { (location) in
            fetchedLocation(MyLocationModel(location: location))
            self.locationHandler?.startListening(toLocationChanges: false)
            self.locationHandler?.removeObserver(in: self)
        }
        self.locationHandler?.startListening(toLocationChanges: true)
        
    }
    
}
