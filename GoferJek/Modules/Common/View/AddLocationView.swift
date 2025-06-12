//
//  AddLocationView.swift
//  GoferHandy
//
//  Created by trioangle on 02/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit


class AddLocationView: BaseView {

    //----------------------------------
    //MARK: - Outlets
    //----------------------------------
    
    @IBOutlet weak var pinLocationImage: UIImageView!
    @IBOutlet weak var titleLabel: SecondaryHeaderLabel!
    @IBOutlet weak var doneView: TopCurvedView!
    @IBOutlet weak var outerView: TopCurvedView!
    @IBOutlet weak var viewTopHolder: SecondaryView!
    @IBOutlet weak var tblLocations: CommonTableView!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var btnDone: PrimaryButton!
    @IBOutlet weak var locationSearchBar: commonTextField!
    @IBOutlet weak var searchBGView: SecondaryView!
    @IBOutlet weak var searchIV: SecondaryTintImageView!
    
    //----------------------------------
    //MARK: - Local Variables
    //----------------------------------
    
    var addLocationVC : AddLocationVC!
    var dataLoader: GooglePlacesDataLoader?
    var locationManager: CLLocationManager!
    var pickUpLatitude: CLLocationDegrees = 0.0
    var pickUpLongitude: CLLocationDegrees = 0.0
    var currentLocation: CLLocation!
    var selectedLocation: LocationModel!
    var isReadyToDrag: Bool = false
    var isKeyBoardShown: Bool = false
    var last_loc : CLLocation?
    var firstlocation = ""
    var map_view_is_idle = true
    var strCurrentLocName = ""
    var autocompletePredictions = [Any]()
    var simval = ""
    var hitCount = 0
    var searchCountdownTimer: Timer?
    let userDefaults = UserDefaults.standard
    let arrMenus: [String] = [LangCommon.setPin]
    let arrImgs: [String] = ["map location"]
    var isCurrentLocationGot: Bool = false
    var isCurrentLocationSet : Bool = false
    var selectedCell : CellLocations!
    var locationAnnotation: MKAnnotation?
    var animateView = UIView()
    
    //--------------------------------------------------------------------
    //MARK: - ViewController Override Function
    //--------------------------------------------------------------------
    var usingPinToGetLocation : Bool = false {
        didSet{
            if self.usingPinToGetLocation{
                self.btnDone.isHidden = false
                self.doneView.isHidden = false
                self.pinLocationImage.isHidden = false
            }else{
                self.btnDone.isHidden = true
                self.doneView.isHidden = true
                self.pinLocationImage.isHidden = true
            }
            self.tblLocations.reloadData()
        }
    }

    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.addLocationVC = baseVC as? AddLocationVC
        self.initView()
        self.initLanguage()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.viewTopHolder.customColorsUpdate()
        self.locationSearchBar.customColorsUpdate()
        self.searchIV.customColorsUpdate()
        self.searchBGView.customColorsUpdate()
        self.tblLocations.customColorsUpdate()
        self.titleLabel.customColorsUpdate()
        self.outerView.customColorsUpdate()
        self.doneView.customColorsUpdate()
        self.onChangeMapStyle()
        self.tblLocations.reloadData()
    }
    
    override
    func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.addLocationVC.navigationController?.isNavigationBarHidden = true
    }
    
    override
    func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
    }
    
    
    
    //----------------------------------
    //MARK:- initilaizers
    //----------------------------------
    
    func initView() {
        self.initGooglePlaceSearch()
        self.onChangeMapStyle()
        self.updateCurrentLocation()
        self.locationSearchBar.setTextAlignment()
        self.googleMapView.delegate = self
        self.pinLocationImage.center = self.googleMapView.center
        self.bringSubviewToFront(viewTopHolder)
        self.outerView.isHidden = false
        self.tblLocations.isHidden = false
        self.googleMapView.setSpecificCornersForTop(cornerRadius: 40)
        self.searchBGView.cornerRadius = 10
        self.searchBGView.elevate(2)
//        txtPickUpLoc.placeholder = self.addLocationVC.forLocation == .Home ? "Enter Home" :  "Enter Work"

//        var topFrame = viewTopHolder.frame
//        topFrame = CGRect(x: 0, y: 0, width: topFrame.width, height: topFrame.height)
//        if self.addLocationVC.checkDevice() {
//            topFrame = CGRect(x: 0,
//                              y: 13,
//                              width: topFrame.width,
//                              height: topFrame.height)
//        }
//        self.viewTopHolder.frame = topFrame
//        self.addSubview(self.viewTopHolder)
//        self.bringSubviewToFront(self.viewTopHolder)
//        var frame = self.tblLocations.frame
//        frame = CGRect(x: 0,
//                       y: self.viewTopHolder.frame.height+3,
//                       width: self.frame.width,
//                       height: self.frame.height - self.viewTopHolder.frame.height)
//        self.tblLocations.frame = frame
//        self.bringSubviewToFront(self.viewTopHolder)
        self.locationSearchBar.placeholder = self.addLocationVC.forLocation == .Home ? LangCommon.enterHome :  LangCommon.enterWork
        self.locationSearchBar.delegate = self
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.onReadyToSearchMap), userInfo: nil, repeats: false)
        self.locationSearchBar.setTextAlignment()
        self.setDesign()
        self.pinLocationImage.isHidden = true
        self.btnDone.isHidden = true
        self.doneView.isHidden = true

        self.usingPinToGetLocation = true
        self.initial(ishide: true)
    }
    func initial(ishide: Bool){
        self.googleMapView.isHidden = ishide
        self.tblLocations.isHidden = !ishide
        self.pinLocationImage.isHidden = ishide
        self.btnDone.isHidden = ishide
        self.doneView.isHidden = ishide


    }
    func setDesign() {
        self.titleLabel.text = self.addLocationVC.forLocation == .Home ? LangCommon.enterHome : LangCommon.enterWork
//        self.outerView.elevate(4)
//        self.btnDone.cornerRadius = 15
//        self.btnDone.backgroundColor = .ThemeYellow

    }
    func initLanguage() {
        self.btnDone.setTitle(LangCommon.done,
                              for: .normal)
    }
    
    func initGooglePlaceSearch() {
        let longitude = userDefaults.value(forKey: USER_LONGITUDE) as? String
        let latitude = userDefaults.value(forKey: USER_LATITUDE) as? String
        if ((longitude != nil && longitude != "") && (latitude != nil && latitude != "")) {
            let longitude1 :CLLocationDegrees = Double(longitude!)!
            let latitude1 :CLLocationDegrees = Double(latitude!)!
            let location = CLLocation(latitude: latitude1, longitude: longitude1)
            pickUpLatitude = latitude1
            pickUpLongitude = longitude1
            self.currentLocation = location
        }
        dataLoader = GooglePlacesDataLoader.init(delegate: self)
        selectedLocation = LocationModel()
    }
    
    //----------------------------------
    //MARK:- Actions
    //----------------------------------
    
    @IBAction func onDummyViewTapped() {
        self.simval = "1"
        self.searchMapCountdownTimerFired()
        btnDone.backgroundColor = .TertiaryColor
        btnDone.isUserInteractionEnabled = false
//        googleMapView.frame = CGRect(x: 0,
//                                     y:viewTopHolder.frame.size.height,
//                                     width: self.frame.size.width ,
//                                     height: self.frame.size.height - viewTopHolder.frame.size.height)
    }
    
    @IBAction func onDummyPickupTapped() {
//        self.configurator.hide(animated: true)
    }
    
    //---------------------------------------------
    // MARK: Navigating to Side Menu View
    //---------------------------------------------
    
    @IBAction func onSearchTapped(_ sender:UIButton!) {
    }
    
    //---------------------------------------------
    // MARK: Navigating to Side Menu View
    //---------------------------------------------
    
    @IBAction func onProfileTapped(_ sender:UIButton!) {
        let propertyView = ViewProfileVC.initWithStory(accountVM: AccountViewModel())
        self.addLocationVC.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    @IBAction func onDoneTapped(_ sender: UIButton!) {
        self.addLocationVC.gotoCarAvailblePage(latitude: self.pickUpLatitude, longitude: self.pickUpLongitude, LocationName: self.locationSearchBar.text! ==  LangCommon.enterUrLocation ? self.strCurrentLocName : self.locationSearchBar.text!)
    }
    
    //---------------------------------------------
    // MARK: - Local Functions
    //---------------------------------------------
    
    @objc
    func onReadyToSearchMap() {
        //isReadyToDrag = true
    }
    
    //---------------------------------------------
    //MARK: - Change Map Style
    //---------------------------------------------
    
    func onChangeMapStyle() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate at zoom level 6.
        // googleMapView.setMinZoom(15.0, maxZoom: 55.0)
        let camera = GMSCameraPosition.camera(withLatitude: 9.917703, longitude: 78.138299, zoom: 4.0)
        GMSMapView.map(withFrame: googleMapView.frame, camera: camera)
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ? "map_style_dark" : "mapStyleChanged", withExtension: "json") {
                googleMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
            }
        } catch {
        }
    }
    
    func searchMapCountdownTimerFired() {
        self.gettingLocationName(lat: pickUpLatitude, long: pickUpLongitude, isFromCurrentLocation: false)
    }
    
    func onShowKeyboard() {
        guard !self.isReadyToDrag else {return}
        locationSearchBar.becomeFirstResponder()
        isKeyBoardShown = true
    }
}

//----------------------------------
//MARK: - UISearchBarDelegate
//----------------------------------

extension AddLocationView : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count)! > 0 {
            self.animateView.isHidden = false
            self.startCountdownTimer(forSearch: searchText)
        } else {
            self.autocompletePredictions = [Any]()
            self.tblLocations.reloadData()
        }
        self.darkModeChange()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == self.locationSearchBar {
            if self.locationSearchBar.text == LangCommon.currentLocation {
                self.locationSearchBar.text = ""
            }
        } else {
            if self.locationSearchBar.text?.count == 0 {
                self.locationSearchBar.text = LangCommon.currentLocation
            }
        }
        usingPinToGetLocation = false
        self.initial(ishide: true)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if searchBar.text?.count == 1 && text == "" {
            self.autocompletePredictions.removeAll()
            self.tblLocations.reloadData()
            return true
        }
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        }
        else if (text == "\n") {
            searchBar.resignFirstResponder()
            return false
        }
        return true
    }
}

//----------------------------------
//MARK: - Location Manager Delegate
//----------------------------------

extension AddLocationView : CLLocationManagerDelegate {
    //MARK: - **** LOCATION MANAGER DELEGATE METHODS ****
    func updateCurrentLocation() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    locationManager.requestWhenInUseAuthorization()
                    break
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.requestAlwaysAuthorization()
                @unknown default:
                    print("undetermined")
                }
            } else {
            }
            locationManager.delegate = self
            
        }
        
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        
        locationManager.startUpdatingLocation()
    }
    func gettingLocationName(lat: CLLocationDegrees, long: CLLocationDegrees, isFromCurrentLocation: Bool) {
        
        var location = CLLocation(latitude: lat, longitude: long)
        if (lat == 0.0 && long == 0.0) || self.last_loc == location{
            self.map_view_is_idle = false
            let center = self.googleMapView.center
            let center_coords =  self.googleMapView.projection.coordinate(for: center)
            location = CLLocation(latitude: center_coords.latitude, longitude: center_coords.longitude)
            
        }
        self.last_loc = location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if placemarks == nil
            {
                self.btnDone.backgroundColor = .PrimaryColor
                self.btnDone.isUserInteractionEnabled = true
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])
                if pm != nil
                {
                    let strLoc = self.stringPlaceMark(placemark: pm!)
                    if strLoc.count>0
                    {
                        if isFromCurrentLocation
                        {
                            self.strCurrentLocName = strLoc
                             print("strLochome \(strLoc)")
                            self.locationSearchBar.text = ""
                            if(self.locationSearchBar.placeholder == LangCommon.enterHome){
                                
                                self.locationSearchBar.text = ""
                                self.firstlocation = self.strCurrentLocName
                                
                                if(self.simval == "1"){
                                    self.locationSearchBar.text = strLoc
                                    self.btnDone.backgroundColor = .PrimaryColor
                                    self.btnDone.isUserInteractionEnabled = true
                                }
                            }
                            else if(self.locationSearchBar.placeholder == LangCommon.enterWork){
                                
                                self.locationSearchBar.text = ""
                                self.firstlocation = self.strCurrentLocName
                                
                                if(self.simval == "1"){
                                    self.locationSearchBar.text = strLoc
                                    self.btnDone.backgroundColor = .PrimaryColor
                                    self.btnDone.isUserInteractionEnabled = true
                                }
                            }
                        }
                        else
                        {
                            self.btnDone.backgroundColor = .PrimaryColor
                            self.btnDone.isUserInteractionEnabled = true
                            
                            self.locationSearchBar.text = strLoc
                        }
                    }
                }
                else{
                    
                    if(self.locationSearchBar.placeholder == LangCommon.enterHome){
                        
                        self.locationSearchBar.text = ""
                        
                        if(self.simval == "1"){
                            self.locationSearchBar.text = self.firstlocation
                            self.btnDone.backgroundColor = .PrimaryColor
                            self.btnDone.isUserInteractionEnabled = true
                        }
                    }
                    else if(self.locationSearchBar.placeholder == LangCommon.enterWork){
                        
                        self.locationSearchBar.text = ""
                        if(self.simval == "1"){
                            
                            self.locationSearchBar.text = self.firstlocation
                            self.btnDone.backgroundColor = .TertiaryColor
                            self.btnDone.isUserInteractionEnabled = true
                            
                        }
                    }
                    
                }
            }
        })
    }
    
    func stringPlaceMark(placemark: CLPlacemark) -> String {
        var string = String()
        if (placemark.thoroughfare != nil) {
            string += placemark.thoroughfare!
        }else if let subLocality = placemark.subLocality{
            string += subLocality
        }
        if (placemark.locality != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            string += placemark.locality!
        }
        if (placemark.administrativeArea != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            string += placemark.administrativeArea!
        }
        if (placemark.country != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            string += placemark.country!
        }
        return string
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        //If map is being used
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16.5, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        Constants().STOREVALUE(value: String(format: "%f", coord.longitude) as String, keyname: USER_LONGITUDE)
        Constants().STOREVALUE(value: String(format: "%f", coord.latitude) as String, keyname: USER_LATITUDE)
        locationManager.stopUpdatingLocation()
        if (!isCurrentLocationGot) {
            isCurrentLocationGot = true
            self.gettingLocationName(lat: coord.latitude, long: coord.longitude, isFromCurrentLocation: true)
        }
        self.setCurrentLocation(latitude: coord.latitude, longitude: coord.longitude)
    }
    // MARK: CALLING API FOR CREATE FB OR GOOGLE ACC
    func setCurrentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if isCurrentLocationSet {
            return
        }
        isCurrentLocationSet = true
        CATransaction.begin()
        CATransaction.setValue(1.5, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.5)
        GMSMapView.map(withFrame: googleMapView.frame, camera: camera)
        googleMapView.camera = camera
        googleMapView.isMyLocationEnabled = true
        CATransaction.commit()
    }
    
}



//----------------------------------------
//MARK: - Text Field Delegate
//----------------------------------------

extension AddLocationView : UITextFieldDelegate {
    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField) {
        if (textField.text?.count)! > 0 {
            self.animateView.isHidden = false
            self.startCountdownTimer(forSearch: textField.text!)
        } else {
            self.autocompletePredictions = [Any]()
            self.tblLocations.reloadData()
        }
        self.darkModeChange()
    }
    
    func startCountdownTimer(forSearch searchString: String) {
        //stop the current countdown
        let fireDate : Date
        if self.searchCountdownTimer == nil || !self.searchCountdownTimer!.isValid{
            fireDate = Date(timeIntervalSinceNow: 1.0)
        }else{
            fireDate = Date(timeIntervalSinceNow: 1.35)
        }
        self.searchCountdownTimer?.invalidate()
    
        //cancel all pending requests
        self.dataLoader?.cancelAllRequests()
        // add search data to the userinfo dictionary so it can be retrieved when the timer fires
        let info: [AnyHashable: Any] = [
            "searchString" : searchString,
        ]
        
        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.startAutoComplete), userInfo: info, repeats: false)
        
        RunLoop.main.add(self.searchCountdownTimer!, forMode: RunLoop.Mode.default)
        
    }
    @objc
    func startAutoComplete(_ countdownTimer: Timer) {
        let searchString = countdownTimer.userInfo as! NSDictionary
        let newsearchString: String? = searchString["searchString"] as? String
        guard let newSearch = newsearchString,
            !newSearch.isEmpty else {return}
        guard (self.locationSearchBar.text?.count ?? -1) == newSearch.count else{
            self.autocompletePredictions = [Any]()
            tblLocations.reloadData()
            return
        }
        self.hitCount += 1
        print("∂HitCount : \(self.hitCount)")
        self.dataLoader?.sendAutocompleteRequest(withSearch: newSearch, andLocation: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 1 && string == "" {
            self.autocompletePredictions.removeAll()
            self.tblLocations.reloadData()
            return true
        }
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.locationSearchBar {
            if self.locationSearchBar.text == LangCommon.currentLocation {
                self.locationSearchBar.text = ""
            }
        } else {
            if self.locationSearchBar.text?.count == 0 {
                self.locationSearchBar.text = LangCommon.currentLocation
            }
        }
        usingPinToGetLocation = false
        self.initial(ishide: true)
    }
}

//----------------------------------------
//MARK: - GOOGLE MAP DELEGATE METHOD
//----------------------------------------

extension AddLocationView : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard !self.map_view_is_idle else{return}//Return if already in idle state
        self.map_view_is_idle = true
        defer {
            if isReadyToDrag{
                self.searchMapCountdownTimerFired()
            }
        }
        if(mapView.camera.zoom > 5) {
            //do your code here
        }
        self.pickUpLatitude = position.target.latitude
        self.pickUpLongitude = position.target.longitude
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.map_view_is_idle = false
        return
    }
}

//-------------------------------------------
//MARK: - Google Places Data Loader Delegate
//-------------------------------------------

extension AddLocationView : GooglePlacesDataLoaderDelegate {
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, didLoadAutocompletePredictions predictions: [Any]!) {
        self.autocompletePredictions = predictions
        self.tblLocations.reloadData()
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, didLoadPlaceDetails placeDetails: [AnyHashable : Any]!, withAttributions htmlAttributions: String!) {
        self.searchDidComplete(withPlaceDetails: placeDetails, andAttributions: htmlAttributions)
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, autocompletePredictionsDidFailToLoad error: Error!) {
        print(error?.localizedDescription as Any)
        self.autocompletePredictions.removeAll()
        self.tblLocations.reloadData()
        self.addLocationVC.presentAlertWithTitle(
            title: error?.localizedDescription ?? LangCommon.noLocationFound,
            message: "",
            options: LangCommon.ok
        ) { (number) in
            switch number {
            case 1: break
            default:
                break
            }
        }
        self.animateView.isHidden = true
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader!, placeDetailsDidFailToLoad error: Error!) {
        print(error?.localizedDescription as Any)
    }
    
    //---------------------------------------------------
    // MARK: - **** Get Current Location Name ****
    //---------------------------------------------------
    
    
    func searchDidComplete(withPlaceDetails placeDetails: [AnyHashable: Any], andAttributions htmlAttributions: String) {
        locationAnnotation = PlaceDetailsAnnotation(placeDetails: placeDetails)
        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)
        
        self.selectedLocation.longitude = String(format: "%2f", (self.locationAnnotation?.coordinate.longitude)!)
        self.selectedLocation.latitude = String(format: "%2f", (self.locationAnnotation?.coordinate.latitude)!)
        self.selectedLocation.currentLocation = CLLocation(latitude: (self.locationAnnotation?.coordinate.latitude)!, longitude: (self.locationAnnotation?.coordinate.longitude)!)
    }
    
    func searchDidComplete(withCurrentLocationSelected currentLocation: CLLocation) {
            self.locationAnnotation = CurrentLocationAnnotation(location: currentLocation)
            self.selectedLocation.longitude = String(format: "%2f", currentLocation.coordinate.longitude)
            self.selectedLocation.latitude = String(format: "%2f", currentLocation.coordinate.latitude)
            self.selectedLocation.currentLocation = currentLocation
    }
}

//---------------------------------------------------
// MARK: - **** UITable View Data Source ****
//---------------------------------------------------

extension AddLocationView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.autocompletePredictions.count == 0 {
            return 60
        } else {
            return 85
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         self.animateView.isHidden = true
        return (self.autocompletePredictions.count == 0) ? arrMenus.count : self.autocompletePredictions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.isReadyToDrag = false
        if self.autocompletePredictions.count == 0 {
            let cell:CellItems = self.tblLocations.dequeueReusableCell(withIdentifier: "CellItems") as! CellItems
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.lblName?.text = self.arrMenus[indexPath.row]
            cell.lblIconName?.image = UIImage(named: arrImgs[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.outerView.backgroundColor = .clear
            cell.ThemeChange()
            return cell
        } else {
            let adict: [AnyHashable: Any] = self.locationDescription(at: indexPath.row)
            let titleString: String? = (adict[RESPONSE_KEY_DESCRIPTION] as? String)
            let addresArray  = titleString?.components(separatedBy: ",")
            let finalTitle: String? = ((addresArray?.count)! > 0) ? addresArray?[0] : ""
            var finalSubTitle: String = ""
            let count = (addresArray?.count)! as Int
            for i in 1 ..< count {
                finalSubTitle = finalSubTitle + (addresArray?[i])!
                if i < (addresArray?.count)! - 1 {
                    if i == 1 {
                        finalSubTitle = finalSubTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                    finalSubTitle = finalSubTitle + ","
                }
            }
            let cell:CellLocations = tblLocations.dequeueReusableCell(withIdentifier: "CellLocations") as! CellLocations
            cell.lblTitle?.text = finalTitle
            let trimmedString = finalSubTitle.trimmingCharacters(in: .whitespaces)
            cell.lblSubTitle?.text = trimmedString
            cell.ThemeChange()
            if autocompletePredictions.count > 1 {
                if indexPath.row == 0 {
                    cell.outerView.setSpecificCornersForTop(cornerRadius: 25)
                }else if indexPath.row == autocompletePredictions.count - 1 {
                    cell.outerView.setSpecificCornersForBottom(cornerRadius: 25)
                }
                else{
                    cell.outerView.cornerRadius = 0
                }
            }else{
                cell.outerView.cornerRadius = 10
            }
          
            cell.outerView.backgroundColor =  UIColor.TertiaryColor.withAlphaComponent(0.3)
            return cell
        }
    }
    
    internal func locationDescription(at index: Int) -> [AnyHashable: Any] {
        let jsonData: [AnyHashable: Any] = self.autocompletePredictions[index] as! [AnyHashable : Any]
        return jsonData
    }
}

//---------------------------------------------------
// MARK: - **** UITable View Delegate ****
//---------------------------------------------------
extension UIView{
    func setSpecificCornersForTop(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively

    }
    func setSpecificCornersForBottom(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
extension AddLocationView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.autocompletePredictions.count == 0 {
            if self.currentLocation != nil{
                self.selectedLocation.longitude = String(format: "%2f", self.currentLocation.coordinate.longitude)
                self.selectedLocation.latitude = String(format: "%2f", self.currentLocation.coordinate.latitude)
            } else {
                selectedLocation.searchedAddress = ""
                self.selectedLocation.longitude = ""
                self.selectedLocation.latitude = ""
            }
            if indexPath.row == 0 {
//                guard self.locationManager != nil,
//                    LocationManager.instance.isAuthorized else {return}
                self.initial(ishide: false)
                self.onDummyViewTapped()
                self.isReadyToDrag = true
                self.locationSearchBar.resignFirstResponder()
                self.simval = "1"
            }
        } else {
            self.selectedCell = tableView.cellForRow(at: indexPath) as? CellLocations
            let adict = self.locationDescription(at: indexPath.row) as NSDictionary
            let title  = adict[RESPONSE_KEY_DESCRIPTION] as? String
            let addresArray  = title?.components(separatedBy: ",")
            let finalTitle: String? = ((addresArray?.count)! > 0) ? addresArray?[0] : ""
            var finalSubTitle: String = ""
            let count = (addresArray?.count)! as Int
            for i in 1 ..< count {
                finalSubTitle = finalSubTitle + (addresArray?[i])!
                if i < (addresArray?.count)! - 1 {
                    if i == 1 {
                        finalSubTitle = finalSubTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                    finalSubTitle = finalSubTitle + ","
                }
            }
            let trimmedString = finalSubTitle.trimmingCharacters(in: .whitespaces)
            self.locationSearchBar.text = String(format:"%@ %@",finalTitle!,trimmedString)
            if locationSearchBar.text?.count == 0 {
//                self.configurator.show(animated: true)
                self.outerView.isHidden = false
                self.tblLocations.isHidden = false
            }
            let selPrediction = self.autocompletePredictions[indexPath.row] as! NSDictionary
            let referenceID: String? = (selPrediction[RESPONSE_KEY_REFERENCE] as? String)
            self.dataLoader?.cancelAllRequests()
            self.addLocationVC.getLocationCoordinates(withReferenceID: referenceID!)
        }
    }
    
    func googleData(didLoadPlaceDetails placeDetails: NSDictionary) {
        self.searchDidComplete(withPlaceDetails: placeDetails)
    }
    
    func searchDidComplete(withPlaceDetails placeDetails: NSDictionary) {
        let placeGeometry =  (placeDetails[RESPONSE_KEY_GEOMETRY]) as? NSDictionary
        let locationDetails  = (placeGeometry?[RESPONSE_KEY_LOCATION]) as? NSDictionary
        let lat = (locationDetails?[RESPONSE_KEY_LATITUDE] as? Double)
        let lng = (locationDetails?[RESPONSE_KEY_LONGITUDE] as? Double)
        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)
        let longitude :CLLocationDegrees = Double(String(format: "%2f", lng!))!
        let latitude :CLLocationDegrees = Double(String(format: "%2f", lat!))!
        self.pickUpLatitude = latitude
        self.pickUpLongitude = longitude
        self.gotoMainMapView()
    }
    func gotoMainMapView() {
        self.autocompletePredictions = [Any]()
        tblLocations.reloadData()
        if (locationSearchBar.text?.count)! > 0 {
            self.addLocationVC.gotoCarAvailblePage(latitude: self.pickUpLatitude, longitude: self.pickUpLongitude, LocationName: self.locationSearchBar.text! ==  LangCommon.enterUrLocation ? self.strCurrentLocName : self.locationSearchBar.text!)
        }
    }
}

class CellItems: UITableViewCell {
    @IBOutlet weak var outerView: TeritaryView!
    @IBOutlet var lblName: SecondaryRegularLabel?
    @IBOutlet weak var lblIconName: SecondaryTintImageView!
    
    func ThemeChange() {
        self.lblIconName.image?.withRenderingMode(.alwaysTemplate)
        self.lblName?.customColorsUpdate()
        self.lblIconName.customColorsUpdate()
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
}

class CellLocations: UITableViewCell {
    
    @IBOutlet weak var outerView: TeritaryView!
    @IBOutlet var lblTitle: SecondaryRegularLabel?
    @IBOutlet var lblSubTitle: InactiveRegularLabel?
    @IBOutlet weak var lblIcon: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if self.lblIcon != nil{
            self.ThemeChange()
            self.lblIcon.text = "t"
        }
    }
    
    func ThemeChange() {
        self.lblTitle?.customColorsUpdate()
        self.lblSubTitle?.customColorsUpdate()
        self.contentView.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground : .SecondaryColor
    }
    
}
