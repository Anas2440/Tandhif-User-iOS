//
//  LiveCar.swift
//  Gofer
//
//  Created by trioangle on 08/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import GoogleMaps

class LiveCar : Hashable {
    
    var hashValue : Int{return self.driverID}
    var lat : Double
    var lng : Double
    
    let vehicleType : String
    let vehicleID : Int
    
    let driverID : Int
    
    var location : CLLocation{
        get{return CLLocation(latitude: self.lat, longitude: self.lng)}
        set{
            self.lat = newValue.coordinate.latitude
            self.lng = newValue.coordinate.longitude
        }
    }
    
    var marker : GMSMarker?
    init(_ json : JSON){
        self.lat = json.double("latitude")
        self.lng = json.double("longitude")
        
        self.vehicleType = json.string("vehicle_type")
        self.vehicleID = json.int("vehicle_id")
        
        self.driverID = json.int("driver_id")
    }
    func update(_ newLocation : CLLocation){
        self.location = newLocation
    }
}
extension LiveCar : Equatable{
    static func == (lhs: LiveCar, rhs: LiveCar) -> Bool {
        return lhs.driverID == rhs.driverID
    }
    
}
