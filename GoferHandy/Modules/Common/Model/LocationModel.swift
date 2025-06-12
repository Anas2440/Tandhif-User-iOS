//
//  LocationModel.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import GoogleMaps

class MyLocationModel : CLLocation {
    private var address : String?
    
    init(address : String? = nil,
         location : CLLocation) {
        self.address = address
        super.init(coordinate: location.coordinate,
                   altitude: location.altitude,
                   horizontalAccuracy: location.horizontalAccuracy,
                   verticalAccuracy: location.verticalAccuracy,
                   timestamp: Date())
    }
    override init(){
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getAddress() -> String?{
        return self.address
    }
    func getAddress(_ address : @escaping Closure<String?>){
        if let _address = self.address {
            address(_address)
        } else {
            let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
            aGMSGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(self.coordinate.latitude,
                                                                             self.coordinate.longitude)) { (response, error) in
                if error == nil && response != nil {
                    let gmsAddress: GMSAddress = response?.firstResult() ?? GMSAddress()
                    print("\ncoordinate.latitude=\(gmsAddress.coordinate.latitude)")
                    print("coordinate.longitude=\(gmsAddress.coordinate.longitude)")
                    print("thoroughfare=\(String(describing: gmsAddress.thoroughfare))")
                    print("locality=\(String(describing: gmsAddress.locality))")
                    print("subLocality=\(String(describing: gmsAddress.subLocality))")
                    print("administrativeArea=\(String(describing: gmsAddress.administrativeArea))")
                    print("postalCode=\(String(describing: gmsAddress.postalCode))")
                    print("country=\(String(describing: gmsAddress.country))")
                    print("lines=\(String(describing: gmsAddress.lines))")
                    self.address = gmsAddress.lines?.last
                    address(gmsAddress.lines?.last)
                } else {
                    address(nil)
                }
            }
        }
    }
}
