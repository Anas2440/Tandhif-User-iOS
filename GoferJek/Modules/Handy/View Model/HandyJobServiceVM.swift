//
//  HandyJobServiceVM.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CoreLocation
import UIKit
import GoogleMaps

class HandyJobServiceVM : BaseViewModel {
    private let jobID : Int!
    var jobDetailModel : HandyJobDetailModel?
    
    var getJobID : Int{
        return self.jobID ?? jobDetailModel?.users.jobID ?? 0
    }
    
    //MARK:- LiveTrackingVariables
    var liveTrackingInitialized = false
    var fireBaseReference : DatabaseReference!
    var gmsMapView : GMSMapView?
    var userMarker : GMSMarker?
    var providerMarker : GMSMarker?
    var trackingPath : GMSPath?
    var tripPolyline = GMSPolyline()
    var lastDirectionAPIHitStamp : Date?
    var iCanHitDirectionAPI = false
    var focusedTraveller = false
    fileprivate let cameraDefaultZoom : Float = 16.5
    fileprivate var lastTravalLocation : CLLocationCoordinate2D?
    //MARK:- initializers
    init(forJob jobID : Int!){
        self.jobID = jobID
        super.init()
        if let _jobID = jobID{
            UserDefaults.set(_jobID, for: .current_job_id)
            self.fireBaseReference = Database.database().reference()
                .child(firebaseEnvironment.rawValue)
                .child(FireBaseNodeKey.trip.rawValue)
                .child(self.getJobID.description)
        }
    }
    convenience init(forJob job : HandyJobDetailModel){
        self.init(forJob : job.users.jobID)
        self.jobDetailModel = job
    }
    fileprivate convenience override init(){
        self.init(forJob : nil)
    }
    
    //MARK:- UDFS
    fileprivate var locationHandler : LocationHandlerProtocol?
    func getCurrentLocation(justForOnce : Bool = true,_ fetchedLocation : @escaping Closure<MyLocationModel>){
        self.locationHandler = LocationHandler.default()
        if let lastLoc = self.locationHandler?.lastKnownLocation,
            lastLoc.timestamp.timeIntervalSince(Date()) < 1200{
            fetchedLocation(MyLocationModel(location: lastLoc))
            if justForOnce{
                self.locationHandler?.startListening(toLocationChanges: false)
                self.locationHandler?.removeObserver(in: self)
            }
            return
        }
        
        self.locationHandler?.addObserver(in: self) { (location) in
            fetchedLocation(MyLocationModel(location: location))
            if justForOnce{
                self.locationHandler?.startListening(toLocationChanges: false)
                self.locationHandler?.removeObserver(in: self)
            }
        }
        self.locationHandler?.startListening(toLocationChanges: true)
        
    }
    
    
    func updateEnablePermissionPopup() {
        self.locationHandler?.startListening(toLocationChanges: true)
    }
    
    //MARK:- wsto get data
    func wsToGetJobDetail(reqID : Int? = nil,showLoader:Bool,_ result : @escaping Closure<Result<HandyJobDetailModel,Error>>){
        var params = JSON()
        if let job = self.jobID{
            params = ["job_id":job]
        }
        if let reqID = reqID {
            params = ["request_id":reqID]
        }
        // Handy Splitup Start
        params["business_id"] = AppWebConstants.businessType.rawValue
        // Handy Splitup End
        if showLoader {
            Shared.instance.showLoaderInWindow()
        }
        self.connectionHandler?
            .getRequest(for: .getJobDetail,
                        params: params)
            .responseDecode(to: HandyJobDetailModel.self, { (response) in
                Shared.instance.removeLoaderInWindow()
                self.jobDetailModel = response
                result(.success(response))
            }).responseJSON({ (json) in
                print(json,"response -------")
                if json.string("status_code") == "0" {
                    Shared.instance.removeLoaderInWindow()
                }
            })
            .responseFailure({ (error) in
                print(error.localizedLowercase)
                Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
    //MARK:- payment
    //MARK:- set refresh payment status in firebase
    func setRefreshPayment(){
        
        var node = [String:Any]()
        let value = PaymentOptions.default ?? .cash
        
        let walletSelected = Constants().GETVALUE(keyname: USER_SELECT_WALLET) == "Yes"
        let promoApplied =  Constants().GETVALUE(keyname: USER_PROMO_CODE) != "0" &&
            Constants().GETVALUE(keyname: USER_PROMO_CODE) != ""
        
        
        node[FireBaseNodeKey.refresh_payment.rawValue] = value.with(wallet: walletSelected,
                                                                    promo: promoApplied)
        //         FireBaseNodeKey.trip
        //            .ref(forID: self.getJobID.description).setValue(node)
    }
    func getInvoiceDetails(tipsAmount:Double? = nil,completionHandler : @escaping Closure<Result<HandyJobDetailModel,Error>>) {
        var walletSelected = Constants().GETVALUE(keyname: USER_SELECT_WALLET)
        let walletAmount = UserDefaults.value(for: .wallet_amount) ?? ""
        if walletSelected.isEmpty {walletSelected = "No"}
        
        if walletAmount.toDouble().isZero {
            walletSelected = "No"
        }
        var params = [
            "job_id": self.getJobID,
            "payment_mode": PaymentOptions.default?.paramValue.lowercased() ?? "cash",
            "is_wallet" : walletSelected
            ] as JSON
        if let amount = tipsAmount {
            params["tips"] = amount
        }
        if let promo:Int = UserDefaults.value(for: .promo_id),
           promo != 0 {
            params["promo_id"] = promo
        } else {
            params["promo_id"] = 0
        }
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?.getRequest(for: .getInvoice, params: params).responseDecode(to: HandyJobDetailModel.self, { (response) in
            self.jobDetailModel = response
            Shared.instance.removeLoaderInWindow()
            completionHandler(.success(response))
        })
            .responseFailure { (error) in
            Shared.instance.removeLoaderInWindow()
                completionHandler(.failure(CommonError.failure(error)))
        }
    }
    func makePayment(payKey : String?,_ result : @escaping Closure<Result<Bool,Error>>){
        var params = [
            "job_id": self.getJobID,
            "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"
            ] as JSON
        if let key = payKey{
            params["pay_key"] = key
        }
        
        
        params["amount"] = self.jobDetailModel?.getPayableAmount.description ?? "0.0"
        
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?
            .getRequest(for: .afterPayment,
                        params: params)
            .responseJSON({ (json) in
            Shared.instance.removeLoaderInWindow()
                if json.isSuccess{
                    FireBaseNodeKey.trip.getReference(for: "\(self.getJobID)").removeValue()
                    result(.success(true))
                }else{
                    
                    result(.failure(CommonError.failure(json.status_message)))
                }
            }).responseFailure({ (error) in
            Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
    }
    func wsMethodConvetCurrency(_ result : @escaping Closure<Result<CurrencyConversion,Error>>){
        guard let model = self.jobDetailModel else{return}
        
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?
            .getRequest(for: .currencyConversion,
                        params:  ["amount": model.getPayableAmount,
                                  "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"])
            .responseJSON({ (response ) in
            Shared.instance.removeLoaderInWindow()
                if response.isSuccess{
                    let amount = response.double("amount")
                    let brainTreeClientID = response.string("braintree_clientToken")
                    let currency = response.string("currency_code")
                    result(.success(CurrencyConversion(amount : amount,brainTreeClientID : brainTreeClientID,currency : currency)))
                }else{
                    result(.failure(CommonError.failure(response.status_message)))
                }
            }).responseFailure({ (error) in
            Shared.instance.removeLoaderInWindow()
                result(.failure(CommonError.failure(error)))
            })
        
    }
    //MARK:- ThirdParty API Calls
    func wsToGoogleDirection(providerLatitude: Double,providerLongitude : Double,
                             userLatitude : Double,userLongitude :  Double){
        
        let timeDifference = Date().timeIntervalSince(self.lastDirectionAPIHitStamp ?? Date())
        
        guard self.lastDirectionAPIHitStamp == nil || timeDifference > 15 else{return}
        self.lastDirectionAPIHitStamp = Date()
        self.connectionHandler?
            .getRequest(forAPI: "https://maps.googleapis.com/maps/api/directions/json",
                        params: [
                            "origin" : "\(providerLatitude),\(providerLongitude)",
                            "destination" :"\(userLatitude),\(userLongitude)",
                            "mode" : "driving",
                            "units" : "metric",
                            "sensor" : "true",
                            "key" : GooglePlacesApiKey//"\(UserDefaults.value(for: .google_api_key) ?? "")"
                        ], CacheAttribute: .none).responseDecode(to: GoogleGeocode.self, { [weak self] (googleGecode) in
                guard let welf = self,
                    let route = googleGecode.routes.first,
                    let _ = route.legs.first else{return}
                welf.updatePathToFirebase(route.overviewPolyline.points)
            })
            .responseJSON({ (json) in
                debugPrint(json.description)
            })
            .responseFailure({ (error) in
                debug(print: error)
            })
        
        
    }
    //MARK:- class instances
    class func getIncompleteTrip(_ result : @escaping Closure<Result<HandyJobDetailModel,Error>>){
        let vm = HandyJobServiceVM.init()
        vm.wsToGetJobDetail(showLoader: false, result)
    }
    
    func wsToUpdateUserRating(param:JSON, _ result : @escaping Closure<Result<JSON,Error>>) {
        
        Shared.instance.showLoaderInWindow()
        self.connectionHandler?.getRequest(for: .jobRating, params: param).responseJSON({ (response) in
        Shared.instance.removeLoaderInWindow()
            result(.success(response))
        }).responseFailure({ (error) in
        Shared.instance.removeLoaderInWindow()
            result(.failure(CommonError.failure(error)))
        })
    }
}
//MARK:- LiveTracking
extension HandyJobServiceVM{
    func initiateLiveTracking(usignMapView mapView:GMSMapView){
        guard let detailModel = self.jobDetailModel else{
            fatalError("Job Detail Model required")
        }
        guard !self.liveTrackingInitialized else{
            print("Live tracking already runninng")
            return
        }
        self.gmsMapView = mapView
        self.gmsMapView?.delegate = self
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        guard let tripReference = self.fireBaseReference else{return}
        tripReference.removeAllObservers()
        self.observeLocation(fromReference: tripReference.child("User"),
                             usingMarker: self.getMarkerForUser())
        
        self.observeLocation(fromReference: tripReference.child("Provider"),
                             usingMarker: self.getMarkerForProvider())
        self.observePath(fromReference: tripReference.child("path"))
        
        
        
        ///live tracking and path logics
        
        let amITheTraveller = detailModel.amITheTraveller
        if amITheTraveller {
            self.getCurrentLocation(
                justForOnce: false
            ) { (location) in
                self.updateLocationToFirebase(location)
                
                
            }
        }else{
            self.updateLocationToFirebase(detailModel.targetJobLocation)
        }
        self.liveTrackingInitialized = true
    }
    func getMarkerForUser() -> GMSMarker{
        let marker = GMSMarker()
        guard let jobDetail = self.jobDetailModel else{return marker}
//        let view = ProviderMarkerView
//            .getView(withUserImage: jobDetail.users.image,
//                     using: CGRect(x: 0,
//                                   y: 0,
//                                   width: 55,
//                                   height: 70))
//
//        marker.iconView = view
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        imageView.image = UIImage(named: imageView.isDarkStyle ? "box_light" : "box")
        marker.iconView = imageView
        if let job = jobDetailModel,
           job.users.priceType == .distance && !job.amITheTraveller{
            marker.map = nil
        }else{
            marker.map = self.gmsMapView
        }
        self.userMarker = marker
        marker.iconView?.layoutIfNeeded()
        return marker
    }

    func getMarkerForProvider() -> GMSMarker{
        let marker = GMSMarker()
        guard let jobDetail = self.jobDetailModel else{return marker}
//        let view = ProviderMarkerView
//            .getView(withUserImage: jobDetail.providerImage,
//                     using: CGRect(x: 0,
//                                   y: 0,
//                                   width: 55,
//                                   height: 70))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = UIImage(named: "live_car_xprimary")
        marker.iconView = imageView
        if let job = jobDetailModel,
           job.users.priceType == .distance && job.amITheTraveller{
            marker.map = nil
        }else{
            marker.map = self.gmsMapView
        }
        marker.position  =  jobDetail.targetJobLocation.coordinate
        marker.iconView?.layoutIfNeeded()
        self.providerMarker = marker
        return marker
    }
    //MARK:- Firebase Observers
    func observeLocation(fromReference reference : DatabaseReference,
                         usingMarker marker: GMSMarker?){
        
        let amITheTraveller = self.jobDetailModel?.amITheTraveller ?? false
        print("amITheTraveller : \(amITheTraveller)")
        reference.observe(.value) { (snapShot) in
            guard snapShot.exists(),
                let json = snapShot.value as? JSON else{return}
            let location = CLLocation(latitude: json.double("lat"),
                                      longitude: json.double("lng"))
            self.lastTravalLocation = marker?.position
            marker?.position = location.coordinate
            marker?.iconView?.layoutIfNeeded()
            self.validateMapMarkers()
            //Camera focus
            let isMyMarker = marker == self.userMarker
            if (amITheTraveller && isMyMarker) || (!amITheTraveller && !isMyMarker) {
                let updatedCamera = GMSCameraUpdate.setTarget(location.coordinate)
                self.gmsMapView?.animate(with: updatedCamera)
                if !self.focusedTraveller{
                    self.gmsMapView?.animate(toZoom: self.cameraDefaultZoom)
                    self.gmsMapView?.animate(toBearing: 0)
                    self.focusedTraveller = true
                }
            }
            //polyline
            guard self.jobDetailModel?.canShowPolyline ?? false else{
                self.tripPolyline.map = nil
                return
            }
            if let gPath = self.trackingPath,
                (!amITheTraveller || self.isOnPath(gPath)){//only traveller will check is he is on path
                self.drawRoute(for: gPath)
                
            }else if amITheTraveller || self.iCanHitDirectionAPI{
                guard let user = self.userMarker?.position,
                    let provider = self.providerMarker?.position else{
                        return
                }
                self.wsToGoogleDirection(
                    providerLatitude: provider.latitude,
                    providerLongitude: provider.longitude,
                    userLatitude: user.latitude,
                    userLongitude: user.longitude)
            }
        }
        
    }
    func observePath(fromReference reference: DatabaseReference){
        reference.observe(.value) { (snapShot) in
            guard snapShot.exists() else{
                return
            }
            let gPAthString = snapShot.value as? String  ?? ""
            self.iCanHitDirectionAPI = gPAthString == "0" || gPAthString.isEmpty
            if let gPath = GMSPath(fromEncodedPath: gPAthString){
                self.trackingPath = gPath
                self.drawRoute(for: gPath)
            }
            guard self.jobDetailModel?.canShowPolyline ?? false else{
                self.tripPolyline.map = nil
                return
            }
        }
        
    }
    func validateMapMarkers(){
        guard let job = self.jobDetailModel else{return}
        let coordinate : CLLocationCoordinate2D?
        if job.users.priceType == .distance,
           job.users.jobStatus.isTripStarted{
            if job.amITheTraveller{
                self.providerMarker?.map = nil
                coordinate = self.userMarker?.position
            }else{
                self.userMarker?.map = nil
                coordinate = self.providerMarker?.position
            }
        }else{
            if job.amITheTraveller{
                coordinate = self.userMarker?.position
            }else{
                coordinate = self.providerMarker?.position
            }
        }
        if !job.canShowPolyline{
            
            self.tripPolyline.map = nil
        }
        if let _coordinate = coordinate{
            let rotation = self.calculateBearing(oldCoOrdinate: self.lastTravalLocation ?? _coordinate,
                                                 newCoOrdinate: _coordinate)
            UIView.animate(withDuration: 0.5) {
                if job.users.priceType == .distance,
                   job.users.jobStatus.isTripStarted{
                    if job.amITheTraveller{
                        self.userMarker?.rotation = rotation
                    } else {
                        self.providerMarker?.rotation = rotation
                    }
                } else {
                    if job.amITheTraveller{
                        self.userMarker?.rotation = rotation
                    } else {
                        self.providerMarker?.rotation = rotation
                    }
                    self.userMarker?.map = self.gmsMapView
                    self.providerMarker?.map = self.gmsMapView
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let camera = GMSCameraPosition(target: _coordinate,
                                               zoom: self.gmsMapView?.camera.zoom ?? 14,
                                               bearing: 0,
                                               viewingAngle: 0)
                self.gmsMapView?.moveCamera(GMSCameraUpdate.setCamera(camera))
                self.gmsMapView?.animate(to: camera)
            }
        }
    }
    //MARK:- firebase Updaters
    func updateLocationToFirebase(_ location : CLLocation){
        let userRefrence = self.fireBaseReference.child("User")
        let json = [
            "lat" : location.coordinate.latitude,
            "lng" : location.coordinate.longitude
        ]
        userRefrence.setValue(json)
    }
    
    func updatePathToFirebase(  _ string : String){
        let pathReference = self.fireBaseReference.child("path")
        pathReference.setValue(string)
    }
    //MARK:- path validation and writing
    func isOnPath(_ path : GMSPath)-> Bool{
        guard let user = self.userMarker?.position,
            let provider = self.providerMarker?.position else{
                return true
        }
        guard let path = self.trackingPath,path.count() > 0 else{return false}
        var providerStartPos : UInt? = nil
        var userEndPos : UInt? = nil
        for index in 0..<path.count(){
            
            let point = path.coordinate(at: index).location
            if point.distance(from: provider.location) < 75{
                providerStartPos = index
            }
            
            if point.distance(from: user.location) < 75{
                userEndPos = index
            }
            if providerStartPos != nil, userEndPos != nil{
                return true
            }
        }
        return false
    }
    
    func drawRoute(for path : GMSPath){
        guard let user = self.userMarker?.position,
            let provider = self.providerMarker?.position else{
                return
        }
        let drawingPath = GMSMutablePath()
        
        var providerStartdPos : UInt? = nil
        var userEndPos : UInt? = nil
        ///Start adding point on first sight of provider
        var startAddingPath : Bool = false
        ///Stop adding point on close sight of user
        var stopAddingPath : Bool = false
        for index in 0..<path.count(){
            
            ///*****************************************************
            let point = path.coordinate(at: index).location
            //Provider Start Position
            let newProviderDistance = point.distance(from: provider.location)
            if newProviderDistance < 75{
                if providerStartdPos == nil{
                    providerStartdPos = index
                }
                if UInt(newProviderDistance) > providerStartdPos!{
                    startAddingPath = true
                }
                providerStartdPos = index
            }
            
            ///*****************************************************
            
            let newUserDistance = point.distance(from: user.location)
            //USer End Position
            if newUserDistance < 75{
                if userEndPos == nil{
                    userEndPos = index
                }
                if UInt(newUserDistance) > userEndPos!{
                    stopAddingPath = true
                }
                userEndPos = index
            }
            ///*****************************************************
            if startAddingPath{
                drawingPath.add(path.coordinate(at: index))
            }
            if stopAddingPath{
                drawingPath.add(path.coordinate(at: index))
                break
            }
        }
        
        self.tripPolyline.path = drawingPath
        self.tripPolyline.strokeColor = UIColor.PrimaryColor
        self.tripPolyline.strokeWidth = 3.0
        self.tripPolyline.map = self.gmsMapView
    }
    
    func calculateBearing(oldCoOrdinate : CLLocationCoordinate2D,
                          newCoOrdinate : CLLocationCoordinate2D) -> Double {
        let fromLat = degToRad(value: oldCoOrdinate.latitude)
        let fromlong = degToRad(value: oldCoOrdinate.longitude)
        let toLat = degToRad(value: newCoOrdinate.latitude)
        let toLong = degToRad(value: newCoOrdinate.longitude)
        let result = radToDeg(value: atan2(sin(toLong-fromlong)*cos(toLat), cos(fromLat)*sin(toLat)-sin(fromLat)*cos(toLat)*cos(toLong-fromlong)))
        return result >= 0 ? result : 360 + result
    }
    
    func degToRad(value: Double) -> Double {
        return (Double.pi * value) / 180.0
    }
    
    func radToDeg(value: Double) -> Double {
        return (180 * value) / Double.pi
    }
}
//MARK:- GMSMapViewDelegate
extension HandyJobServiceVM : GMSMapViewDelegate{
    
}
