//
//  DriverLiveTracker.swift
//  Gofer
//
//  Created by trioangle on 08/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import Alamofire
import Firebase
import GeoFire
import ARCarMovement
import Lottie

class DriverLiveTrackingManager : NSObject {
    
    func onAPIComplete(_ response: ResponseEnum, for API: APIEnums) {
        switch response {
        case .liveCars(let cars):
            self.updateMap(with: cars)
        default:
            break
        }
    }
    
    
    
    fileprivate let gMap : GMSMapView
    fileprivate var locationManager : CLLocationManager
    fileprivate var viewController : UIViewController
    fileprivate var timer : Timer?
    fileprivate var currentLocation : CLLocation?
    fileprivate var liveCarMarker = [GMSMarker]()
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    var focusLocation : CLLocation? = nil
    var filteredDrivers : [String]? = nil
    fileprivate var availableRideCars = [LiveCar]()
  
    fileprivate var carMoveMent: ARCarMovement
    init(_ map : GMSMapView,viewController : UIViewController,focusLocation : CLLocation? = nil) {
        self.gMap = map
        self.viewController = viewController
        self.focusLocation = focusLocation
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        carMoveMent = ARCarMovement()
        
        geoFireRef = Database.database().reference().child(firebaseEnvironment.rawValue).child("GeoFire")
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        super.init()
        self.initLocaitonManger()
        carMoveMent.delegate = self
        
        
    }
    func startUpdating(withFilter locationKeys : [String]? = nil){
        self.resetMaps()
        self.filteredDrivers = locationKeys
        
        if let foucsedLoc = self.focusLocation{
            self.listenFromFirebase(from: foucsedLoc , inRadius: Double(Shared.instance.driverRadiusKM))
        }else{
        
            self.initLocaitonManger()
            if let loc = self.currentLocation{
                self.listenFromFirebase(from: loc, inRadius: Double(Shared.instance.driverRadiusKM))
            }
        }
        
        
    }
    func stopUpdating(){
        self.resetMaps()
        self.timer?.invalidate()
        self.timer = nil
        self.locationManager.stopUpdatingLocation()
    }
   
    fileprivate func initLocaitonManger(){
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                case .restricted, .denied:
                    self.forceEnablePermission()
                case .authorizedAlways, .authorizedWhenInUse:
                    
                    self.locationManager.startUpdatingLocation()
                case .notDetermined:
                    fallthrough
                @unknown default:
                    locationManager.requestWhenInUseAuthorization()
            }
        } else {
            self.forceEnablePermission()
        }
        
        locationManager.delegate = self
    }
    fileprivate func forceEnablePermission(){
        let permission = PermissionManager(self.viewController,LocationConfig())
        guard permission.isEnabled else{
            permission.forceEnableService()
            return
        }
    }
    fileprivate func updateMap(with cars : [LiveCar]){

        self.resetMaps()
        var newData = Set<LiveCar>()
        cars.forEach({newData.insert($0)})
        var oldData = Set<LiveCar>()
        self.availableRideCars.forEach({oldData.insert($0)})
        
        let existingCars = Array(newData.intersection(oldData))
        let newCars = Array(newData.subtracting(oldData))
        let removedCars = Array(oldData.subtracting(newData))
        
        for newCar in newCars{
            let tempMarker = self.getMarker(newCar)
            tempMarker.map = self.gMap
            newCar.marker = tempMarker
            
        }
        for existingCar in existingCars{
            if let index = self.availableRideCars.find(includedElement: {$0 == existingCar}),
                let availExistinCar = self.availableRideCars.value(atSafe: index){
                let marker : GMSMarker
                if let alreadySettedMarker = availExistinCar.marker{
                    marker = alreadySettedMarker
                }else{
                    let tempMarker = self.getMarker(existingCar)
                    tempMarker.map = self.gMap
                    marker = tempMarker
                }
                
                self.carMoveMent.arCarMovement(marker: marker, oldCoordinate: availExistinCar.location.coordinate, newCoordinate: existingCar.location.coordinate, mapView: self.gMap, bearing: 0.0)

                existingCar.marker = marker
            }
        }
        for removedCar in removedCars{
            removedCar.marker?.map = nil
            removedCar.marker = nil
        }
        
        self.availableRideCars = newCars + existingCars
    }
    func getMarker(_ car : LiveCar)-> GMSMarker{
        let tempMarker = GMSMarker()
        
        tempMarker.position = car.location.coordinate
        switch car.vehicleID{
        case 1:
            if AppWebConstants.businessType == .Ride{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
            imageView.image = UIImage(named: "top view")
            tempMarker.iconView = imageView
            }else{
            tempMarker.icon = UIImage(named: "delivery_map_icon")
            }
        case 2:
            if AppWebConstants.businessType == .Ride{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.image = UIImage(named: "topView2")
            tempMarker.iconView = imageView
            }else{
            tempMarker.icon = UIImage(named: "live_car_x")
            }
        default:
            if AppWebConstants.businessType == .Ride{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.image = UIImage(named: "topView3")
            tempMarker.iconView = imageView
            }else{
            tempMarker.icon = UIImage(named: "live_car_xl")
            }
        }
        
        return tempMarker
    }
}
extension DriverLiveTrackingManager : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        self.currentLocation = locations.last
        if  self.availableRideCars.isEmpty {
            if let loc = self.currentLocation{
                self.listenFromFirebase(from: loc, inRadius: Double(Shared.instance.driverRadiusKM))
                manager.stopUpdatingLocation()
            }
        }
    }
    func resetMaps(){
        self.availableRideCars.forEach({
            $0.marker?.map = nil
            $0.marker = nil
        })
        self.availableRideCars.removeAll()
        self.liveCarMarker.forEach { (marer) in
            marer.map = nil
        }
        self.liveCarMarker.removeAll()
//        self.gMap.clear()
    }
    
}
extension DriverLiveTrackingManager : ARCarMovementDelegate{
    func arCarMovementMoved(_ marker: GMSMarker) {
        
    }
    
    func listenFromFirebase(from riderLocattion : CLLocation, inRadius radius : Double){
        
//        myQuery?.removeAllObservers()
        myQuery = geoFire?.query(at: riderLocattion, withRadius: radius)
        
        _  = myQuery?.observe(.keyEntered, with: { (key, location) in
            if let availableFilterKeys = self.filteredDrivers,//has filter
            !availableFilterKeys.contains(key){//car not in filter
                return// stop
            }
            if !self.liveCarMarker.compactMap({$0.accessibilityHint}).contains(key){
                let tempMarker = GMSMarker()
                
                tempMarker.position = location.coordinate
                tempMarker.isFlat = true
                //tempMarker.title = key
                tempMarker.accessibilityHint = key
                
                if key.contains("1_"){
                    if AppWebConstants.businessType == .Ride{
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
                        imageView.image = UIImage(named: "top view")
                        tempMarker.iconView = imageView
                    }else{
                        tempMarker.icon = UIImage(named: "delivery_map_icon")
                    }
                }else if key.contains("2_"){
                    if AppWebConstants.businessType == .Ride{
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        imageView.image = UIImage(named: "topView2")
                        tempMarker.iconView = imageView
                    }else{
                        tempMarker.icon = UIImage(named: "live_car_x")
                    }
                }else if key.contains("3_"){
                    if AppWebConstants.businessType == .Ride{
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        imageView.image = UIImage(named: "topView3")
                        tempMarker.iconView = imageView
                    }else{
                        tempMarker.icon = UIImage(named: "live_car_xl")
                    }
                }else{
                    if AppWebConstants.businessType == .Ride{
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
                        imageView.image = UIImage(named: "top view")
                        tempMarker.iconView = imageView
                    }else{
                        tempMarker.icon = UIImage(named: "delivery_map_icon")
                    }
                }
                tempMarker.map = self.gMap
                
                self.liveCarMarker.append(tempMarker)
            }
        })
        myQuery?.observe(.keyMoved, with: { (key, location) in
            
            if let marker = self.liveCarMarker.filter({$0.accessibilityHint == key}).first,
                marker.position.location.distance(from: location) > 25{
                self.carMoveMent.arCarMovement(marker: marker, oldCoordinate: marker.position, newCoordinate: location.coordinate, mapView: self.gMap, bearing: 0.0)

            }
        })
        myQuery?.observe(.keyExited, with: { (key, location) in
            
            
            print("KEY:\(String(describing: key)) and location:\(String(describing: location))")
            
            
            
            if key != Constants().GETVALUE(keyname: USER_ID)
            {
                let ref = Database.database().reference().child("GeoFire").child(key)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let id = snapshot.key
                    for markerValue in self.liveCarMarker{
                        if markerValue.accessibilityHint == String(describing: id) {
                            markerValue.map = self.gMap
                            markerValue.map = nil
                            
                        }
                    }
                    
                    
                    
                })
            }
            else
            {
                DispatchQueue.main.async {
                }
            }
        })
        
    }
}
