//
//  CLLocation+Extension.swift
//  Gofer
//
//  Created by trioangle on 27/01/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D{
    var location : CLLocation{
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
extension CLLocation{
    var strCoords : String{
        return "\(self.coordinate.latitude),\(self.coordinate.longitude)"
    }
}

extension CLPlacemark {

    var compactAddress: String? {
        if let name = name {
            var result = name

            if let street = subLocality {
                
                if result == street {
                    result += ""
                }else{
                    result += ", \(street)"
                }
                
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}
extension CLLocation{
    //MARK:::::::::::::::::::CLLocationValidator:::::::::::::::::::::::::::::::::
    var isValid : Bool{
//        let age = -self.timestamp.timeIntervalSinceNow
//        
//        if age > 10{//"Locaiton is old."
//            return false
//        }
//        
//        if self.horizontalAccuracy < 0{//"Latitidue and longitude values are invalid."
//            return false
//        }
//        
//        if self.horizontalAccuracy > 100{//"Accuracy is too low."
//            return false
//        }
//        
        //"Location quality is good enough."
        return true
        
    }
}
