//
//  LocationManager.swift
//  Gofer
//
//  Created by trioangle on 22/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager : CLLocationManager{
    override init() {
        super.init()
    }
    static let instance = LocationManager()
    
    var isAuthorized : Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }
}
