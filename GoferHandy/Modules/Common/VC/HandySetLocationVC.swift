//
//  HandySetLocationVC.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import CoreLocation
protocol HandySetLocationDelegate {
    func handySetLocation(didSetLocation location: MyLocationModel)
    func handySetLocationDidCancel()
}
class HandySetLocationVC: BaseViewController {
    
    @IBOutlet weak var setLocationView : HandySetLocationView!
    
    //Delivery Splitup Start
    var bookingViewModel : HandyJobBookingVM!
    //Delivery Splitup End
    var accountViewModel : AccountViewModel?
    var addressLocation:String?
    var addLocationFor : UserLocationType? = nil
    var setLocationDelegate : HandySetLocationDelegate?
    var shouldShowChangeBookingTypeView = false
    var needUpdate : Bool!
    var isFromHome:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Delivery Splitup Start
        self.setLocationView.setBookingTypeData()
        //Delivery Splitup End
    }
    
    deinit {
        print("ðDeinited\(Self.reuseIdentifier)")
    }
    
    //MARK:- intiWithStory
    class func initWithStory(using acocuntVM : AccountViewModel,
                             with delegate: HandySetLocationDelegate,
                             showBookingType : Bool,
                             needUpdate: Bool = true) -> HandySetLocationVC{
        let view : HandySetLocationVC =  UIStoryboard.gojekCommon.instantiateViewController()
        //Delivery Splitup Start
        view.bookingViewModel = HandyJobBookingVM()
        //view.modalPresentationStyle = .overCurrentContext
        //Delivery Splitup End
        view.accountViewModel = acocuntVM
        view.setLocationDelegate = delegate
        view.shouldShowChangeBookingTypeView = showBookingType
        view.needUpdate = needUpdate
        return view
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setLocationView.ThemeChange()
    }
    //MARK:- UDF
    func fethcUserLocationAndSet(){
        self.accountViewModel?.getCurrentLocation { (newLocation) in
            newLocation.getAddress { (address) in
                print("åååAddress:\(String(describing: address))")
                self.didPickALocation(newLocation)
            }
        }
    }
    func didPickALocation(_ location : MyLocationModel) {
        if self.needUpdate {
            self.updateLocation(param: ["current_latitude": location.coordinate.latitude,
                                        "current_longitude":location.coordinate.longitude,
                                        "address": location.getAddress() ?? ""])
            Global_UserProfile.address = location.getAddress() ?? ""
            Global_UserProfile.currentLatitude = location.coordinate.latitude.description
            Global_UserProfile.currentLongitude = location.coordinate.longitude.description
        }
        if self.isPresented(){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        self.setLocationDelegate?.handySetLocation(didSetLocation: location)
    }
    
    //----------------------------
    // MARK: - navigations
    //----------------------------
    
    func navigateToAddLocation(for location : UserLocationType) {
        let locationView = AddLocationVC.initWithStory(self)
        locationView.forLocation = location
        self.addLocationFor = location
        if self.isPresented(){
            self.presentInFullScreen(locationView, animated: true, completion: nil)
        }else{
            self.navigationController?.pushViewController(locationView,
                                                          animated: true)
        }
        
    }
    //Delivery Splitup Start
    func navicateToBooking() {
        let calenderVC = HandyCalendarVC.initWithStory(for: nil,
                                                          with: bookingViewModel)
        if self.isPresented(){
            self.presentInFullScreen(calenderVC, animated: true, completion: nil)
        }else{
            self.navigationController?.pushViewController(calenderVC,
                                                          animated: true)
        }
    }
    //Delivery Splitup End
    
    func updateLocation(param: JSON) {
        self.accountViewModel?.wsToUpdateLocation(param: param) { result in
            switch result {
            case .success(let response):
                print(response)
//                AppDelegate.shared.createToastMessage(response.status_message)
            case .failure(let error):
//                AppDelegate.shared.createToastMessage(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
}




//MARK:- addLocationDelegate
extension HandySetLocationVC :addLocationDelegate {
    func onLocationAdded(latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationName: String) {
        guard  let loc = self.addLocationFor else {
            return
        }
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: "access_token")
        dicts["latitude"] = String(format:"%f",latitude)
        dicts["longitude"] = String(format:"%f",longitude)
        
        if loc == .Home{
            dicts["home"] = locationName
        } else{
            dicts["work"] = locationName
        }
        
        
        self.accountViewModel?
            .updateHomeWorkLocation(dicts,
                                    latitude: latitude, longitude: longitude,
                                    locationName: locationName,
                                    result: { (success) in
                guard success else{
                    return
                }
                if loc == .Home
                {
                    Constants().STOREVALUE(value: locationName, keyname: "home_loc")
                    Constants().STOREVALUE(value: String(format:"%f",latitude), keyname: "home_latitude")
                    Constants().STOREVALUE(value: String(format:"%f",longitude), keyname: "home_longitude")
                }
                else
                {
                    Constants().STOREVALUE(value: locationName, keyname: "work_loc")
                    Constants().STOREVALUE(value: String(format:"%f",latitude), keyname: "work_latitude")
                    Constants().STOREVALUE(value: String(format:"%f",longitude), keyname: "work_longitude")
                }
                self.setLocationView.setWorkHomeLocations()
            })
    }
    func getLocationCoordinates(withReferenceID referenceID: String,address : String)
    {
        var dicts = [AnyHashable: Any]()
        
        dicts["token"]   = Constants().GETVALUE(keyname: "access_token")
        let paramsComponent: String = "\("https://maps.googleapis.com/maps/api/place/details/json"/*GOOGLE_MAP_DETAILS_URL*/)?key=\(GooglePlacesApiKey)&reference=\(referenceID)&sensor=\("true")"
        WebServiceHandler.sharedInstance.getThridPartyWebService(wsMethod: paramsComponent, paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
            let gModel =  GoogleLocationModel.generateModel(from: responseDict)
            
            if gModel.status_code == "1"
            {
                let dictsTempsss = gModel.dictTemp["result"/*RESPONSE_KEY_RESULT*/] as! NSDictionary
                self.googleData(didLoadPlaceDetails: dictsTempsss,address: address)
                
            }else {
                
            }
        }
        
    }
    
    func googleData(didLoadPlaceDetails placeDetails: NSDictionary,address : String) {
        self.searchDidComplete(withPlaceDetails: placeDetails,address: address)
    }
    
    
    func searchDidComplete(withPlaceDetails placeDetails: NSDictionary,address : String)
    {
        let placeGeometry =  (placeDetails["geometry"/*RESPONSE_KEY_GEOMETRY*/]) as? NSDictionary
        let locationDetails  = (placeGeometry?["location"/*RESPONSE_KEY_LOCATION*/]) as? NSDictionary
        let lat = (locationDetails?["lat"/*RESPONSE_KEY_LATITUDE*/] as? Double)
        let lng = (locationDetails?["lng"/*RESPONSE_KEY_LONGITUDE*/] as? Double)
        
        
        let longitude :CLLocationDegrees = Double(String(format: "%2f", lng!))!
        let latitude :CLLocationDegrees = Double(String(format: "%2f", lat!))!
        
        self.didPickALocation(MyLocationModel(address: address,
                                              location: CLLocation(
                                                latitude: latitude,
                                                longitude: longitude)))
    }
    
}
