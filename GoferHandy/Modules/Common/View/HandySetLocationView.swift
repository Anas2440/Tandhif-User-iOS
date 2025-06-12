//
//  HandySetLocationView.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps

class HandySetLocationView: BaseView {
    
    
    // ---------------------------------
    //MARK:- Outlets
    // ---------------------------------
    @IBOutlet weak var locationTableView : CommonTableView!
    @IBOutlet weak var headerView : HeaderView!
//    @IBOutlet weak var closeBtn : CustomBackBtn!
    @IBOutlet weak var locationSearchBar : commonTextField!
    @IBOutlet weak var locationOptionHolderView : UIView!
    @IBOutlet weak var locationOptionStack : UIStackView!
    @IBOutlet weak var homeLocationView: UIStackView!
    @IBOutlet weak var homeTitleLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var homeValueLbl : SecondaryRegularLabel!
    @IBOutlet weak var workLocationView : UIStackView!
    @IBOutlet weak var workTitleLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var workValueLbl : SecondaryRegularLabel!
    @IBOutlet weak var userMyLocationView : UIStackView!
    @IBOutlet weak var setPinView : UIStackView!
    @IBOutlet weak var iwantMyLocationPinIV : SecondaryTintImageView!
    @IBOutlet weak var setLocationOnMapPinIV : SecondaryTintImageView!
    @IBOutlet weak var pinLocationIV : UIImageView!
    @IBOutlet weak var donePickingLocaitonBtn : PrimaryButton!
    @IBOutlet weak var setLocationTopBGView : UIStackView!
    @IBOutlet weak var bookLaterBGView : UIStackView!
    @IBOutlet weak var homeValueLblView : UIView!
    @IBOutlet weak var workValueLblView : UIView!
    @IBOutlet weak var addHomeViewArrowIV : SecondaryTintImageView!
    @IBOutlet weak var addWorkViewArrowIV : SecondaryTintImageView!
    @IBOutlet weak var iWantMyLocationViewArrowIV : SecondaryTintImageView!
    @IBOutlet weak var setLocationOnMapViewArrowIV : SecondaryTintImageView!
    @IBOutlet weak var bookLaterIndicatorIV : SecondaryTintImageView!
    @IBOutlet weak var bookBtn : PrimaryButton!
    @IBOutlet weak var bookLaterBtn : PrimaryButton!
    @IBOutlet weak var bookingDateAndTimeLbl : SecondaryRegularLabel!
    @IBOutlet weak var bookLaterDummyBtn : PrimaryButton!
    @IBOutlet weak var setMyCurrentLocationLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var setMyLocationOnMapLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var homeLocationIcon : SecondaryTintImageView!
    @IBOutlet weak var workLocationIcon : SecondaryTintImageView!
    @IBOutlet weak var curvedContentHolderView: TopCurvedView!
    @IBOutlet weak var contentHolderView: SecondaryView!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var pageTitleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var searchBGView: SecondaryView!
    @IBOutlet weak var searchIV: SecondaryTintImageView!
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    var setLocationVC :  HandySetLocationVC!
    var searchPredictions : [Prediction] = []
    var googlePlaceSearchHandler : GoogleAutoCompleteHandler?
    var map_view_is_idle = true
    var currentLocation : CLLocationCoordinate2D!
    var usingPinToGetLocation : Bool = false {
        didSet {
            self.idleLocation = nil
            if self.usingPinToGetLocation {
                self.setLocationTopBGView.isHidden = true
                self.pinLocationIV.isHidden = false
                self.bottomView.isHidden = false
                self.donePickingLocaitonBtn.isHidden = false
                self.setPinView.isHidden = true
                self.endEditing(true)
            } else {
                self.setLocationTopBGView.isHidden = !self.setLocationVC.shouldShowChangeBookingTypeView
                self.pinLocationIV.isHidden = true
                self.bottomView.isHidden = true
                self.donePickingLocaitonBtn.isHidden = true
                self.setPinView.isHidden = false
                
            }
            self.locationTableView.reloadData()
        }
    }
    var mapView : GMSMapView {
        let map = GMSMapView(frame: self.curvedContentHolderView.bounds)
        map.delegate = self
        map.isMyLocationEnabled = true
        map.settings.myLocationButton  = true
        map.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setLocationVC.accountViewModel?.getCurrentLocation { (newLocation) in
                self.currentLocation = newLocation.coordinate
                self.setLocation()
            }
        }
        map.cornerRadius = 40
        map.clipsToBounds = true
        return map
        
    }
    var idleLocation : MyLocationModel?{
        didSet{
            self.donePickingLocaitonBtn.setMainActive(false)
            idleLocation?.getAddress { (address) in
                self.locationSearchBar.text = address
                self.donePickingLocaitonBtn.setMainActive(true)
            }
        }
    }
    
    //------------------------------------
    // MARK: - Actions
    //------------------------------------
    
    @IBAction
    func donePinningAction(_ sender : UIButton){
        guard let location = idleLocation else{return}
        location.getAddress { (_) in
            self.usingPinToGetLocation = false
            self.setLocationVC.didPickALocation(location)
        }
    }
    
    @IBAction
    func bookBtnClicked(_ sender : UIButton) {
        // Delivery Splitup Start
        print("--------> Book Button Clicked")
        print("------>\(JobBookingType.bookNow.getParams)")
        Shared.instance.currentBookingType = .bookNow
        self.setBookingTypeData()
        // Delivery Splitup End
    }
    
    @IBAction
    func bookLaterBtnClicked(_ sender : UIButton) {
        print("--------> Book Later Button Clicked")
        // Delivery Splitup Start
        self.setLocationVC.navicateToBooking()
        self.setBookingTypeData()
        // Delivery Splitup End
    }
    
    @IBAction
    override func backAction(_ sender : UIButton) {
        super.backAction(sender)
    }
    
    //---------------------------------
    // MARK: - life cycle
    //---------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.setLocationVC = baseVC as? HandySetLocationVC
        
        if isProfileValueAvailable {
            self.googlePlaceSearchHandler =
                GoogleAutoCompleteHandler(searchTextField: self.locationSearchBar,
                                          delegate: self,
                                          userCurrentLatLng: (Global_UserProfile.currentCLLocation.coordinate.latitude,
                                                              Global_UserProfile.currentCLLocation.coordinate.longitude))
        } else {
            self.setLocationVC.accountViewModel?.getCurrentLocation({ model in
                self.googlePlaceSearchHandler =
                GoogleAutoCompleteHandler(searchTextField: self.locationSearchBar,
                                          delegate: self,
                                          userCurrentLatLng: (model.coordinate.latitude,
                                                              model.coordinate.longitude))
            })
        }
        
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.setWorkHomeLocations()
        self.locationTableView.reloadData()
        self.ThemeChange()
    }
    
    override
    func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        // Delivery Splitup Start
        self.setBookingTypeData()
        // Delivery Splitup End
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.ThemeChange()
        }
    }
    
    func ThemeChange() {
        self.darkModeChange()
        self.pageTitleLbl.customColorsUpdate()
        self.homeLocationIcon.customColorsUpdate()
        self.workLocationIcon.customColorsUpdate()
        self.addHomeViewArrowIV.customColorsUpdate()
        self.addWorkViewArrowIV.customColorsUpdate()
        self.iwantMyLocationPinIV.customColorsUpdate()
        self.setLocationOnMapPinIV.customColorsUpdate()
        self.iWantMyLocationViewArrowIV.customColorsUpdate()
        self.setLocationOnMapViewArrowIV.customColorsUpdate()
        self.homeTitleLbl.customColorsUpdate()
        self.homeValueLbl.customColorsUpdate()
        self.workTitleLbl.customColorsUpdate()
        self.workValueLbl.customColorsUpdate()
        self.bookingDateAndTimeLbl.customColorsUpdate()
        self.setMyCurrentLocationLbl.customColorsUpdate()
        self.setMyLocationOnMapLbl.customColorsUpdate()
        self.searchIV.customColorsUpdate()
        self.searchBGView.customColorsUpdate()
        self.locationOptionStack.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.locationTableView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.curvedContentHolderView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.locationSearchBar.customColorsUpdate()
        self.setLocation()
        self.locationTableView.reloadData()
    }
    
    //---------------------------------
    // MARK: - initializers
    //---------------------------------
    
    func userLocationCheck(from profile : ProfileModel) {
        if profile.userLocaitonIsAvailable {
            //            self.locationLbl.text = profile.currentAddress
        } else {
            //            //TRVicky
            //            self.setLocationVC.commonAlert.setupAlert(alert: appName,alertDescription: LangCommon.pleaseSetLocation,  okAction: LangCommon.ok)
            //
        }
    }
    
    //---------------------------------------------
    // MARK: - Change Map Style
    //---------------------------------------------
    
    func onChangeMapStyle(map: GMSMapView) {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate at zoom level 6.
        // googleMapView.setMinZoom(15.0, maxZoom: 55.0)
        let camera = GMSCameraPosition.camera(withLatitude: 9.917703, longitude: 78.138299, zoom: 4.0)
        GMSMapView.map(withFrame: map.frame, camera: camera)
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ? "map_style_dark" : "mapStyleChanged", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
            }
        } catch {
        }
    }
    
    func initView() {
        self.locationTableView.clipsToBounds = true
        self.locationTableView.cornerRadius = 15
        self.bookBtn.cornerRadius = 10
        self.bookLaterBtn.cornerRadius = 10
        self.searchBGView.cornerRadius = 10
        self.searchBGView.elevate(2)
        self.bottomView.isHidden = true
        [self.homeTitleLbl,
         self.homeValueLbl,
         self.workTitleLbl,
         self.workValueLbl,
         self.setMyCurrentLocationLbl,
         self,setMyLocationOnMapLbl].forEach({labels in (labels as? UILabel)?.setTextAlignment()})
        self.locationSearchBar.setTextAlignment()
        self.homeLocationView.border(width: 1,
                                     color: UIColor.TertiaryColor.withAlphaComponent(0.1))
        self.workLocationView.border(width: 1,
                                     color: UIColor.TertiaryColor.withAlphaComponent(0.1))
        self.userMyLocationView.border(width: 1,
                                       color: UIColor.TertiaryColor.withAlphaComponent(0.1))
        self.setPinView.border(width: 1,
                               color: UIColor.TertiaryColor.withAlphaComponent(0.1))
        self.bookLaterBtn.backgroundColor = .TertiaryColor
        self.bookLaterBtn.setTitleColor(.black, for: .normal)
        self.donePickingLocaitonBtn.setTitle(LangCommon.done, for: .normal)
        self.homeLocationIcon.image = UIImage(named: "home_location")?.withRenderingMode(.alwaysTemplate)
        self.workLocationIcon.image = UIImage(named: "work_location")?.withRenderingMode(.alwaysTemplate)
        self.locationSearchBar.placeholder = LangCommon.searchLocation
        self.bookLaterDummyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.bookLaterDummyBtn.isHidden = true
        self.bookingDateAndTimeLbl.adjustsFontSizeToFitWidth = true
        self.pinLocationIV.isHidden = true
        self.donePickingLocaitonBtn.isHidden = true
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
        self.setLocationTopBGView.isHidden = !self.setLocationVC.shouldShowChangeBookingTypeView
    }
    
    func addMapView() {
        self.curvedContentHolderView.subviews.forEach { (view) in
            if (view.isKind(of: GMSMapView.self)) {
                return
            }
        }
        self.curvedContentHolderView.addSubview(self.mapView)
        self.curvedContentHolderView.bringSubviewToFront(self.mapView)
        self.curvedContentHolderView.bringSubviewToFront(self.pinLocationIV)
        self.curvedContentHolderView.bringSubviewToFront(self.searchBGView)
        self.curvedContentHolderView.bringSubviewToFront(self.bottomView)
        self.setLocation()
    }
    
    func setLocation() {
        guard let location = self.currentLocation else { return }
        self.curvedContentHolderView.subviews.forEach { (view) in
            if view.isKind(of: GMSMapView.self) {
                (view as? GMSMapView)?.animate(toLocation: location)
                (view as? GMSMapView)?.animate(toZoom: 14)
                self.onChangeMapStyle(map: (view as! GMSMapView))
            }
        }
    }
    
    func removeMapView() {
        self.curvedContentHolderView.subviews.forEach { (view) in
            DispatchQueue.main.async {
                if (view.isKind(of: GMSMapView.self)) {
                    view.removeFromSuperview()
                }
            }
        }
        self.curvedContentHolderView.bringSubviewToFront(self.locationTableView)
    }
    
    func initLanguage() {
//        let title = LangHandy.setLocation.isEmpty ? LangHandy.setLocation : "Set Location"
        let title = LangCommon.setLocation
        self.pageTitleLbl.text = title
        if isRTLLanguage {
            self.addHomeViewArrowIV.transform = CGAffineTransform(rotationAngle: .pi)
            self.addWorkViewArrowIV.transform = CGAffineTransform(rotationAngle: .pi)
            self.iWantMyLocationViewArrowIV.transform = CGAffineTransform(rotationAngle: .pi)
            self.setLocationOnMapViewArrowIV.transform = CGAffineTransform(rotationAngle: .pi)
        } else {
            self.addHomeViewArrowIV.transform = .identity
            self.addWorkViewArrowIV.transform = .identity
            self.iWantMyLocationViewArrowIV.transform = .identity
            self.setLocationOnMapViewArrowIV.transform = .identity
        }
        self.bookBtn.setTitle(LangHandy.bookNow, for: .normal)
        self.bookLaterBtn.setTitle(LangHandy.bookLater, for: .normal)
        self.bookLaterDummyBtn.setTitle(" \(LangHandy.bookLater) ", for: .normal)
        self.setMyCurrentLocationLbl.text = LangCommon.currentLocation
        self.setMyLocationOnMapLbl.text = LangCommon.setLocationOnMap
    }
    
    func initGestures(){
        self.homeLocationView.addAction(for: .tap) { [weak self] in
            if userDefaults.string(forKey: "user_id") == "10086" {
                self?.setLocationVC.presentAlertWithTitle(title: appName, message: LangCommon.loginToContinue, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                    (optionss) in
                    switch optionss {
                        case 0:
                            self?.setLocationVC.sharedAppdelegate.showAuthenticationScreen()
                        case 1:
                            self?.setLocationVC.dismiss(animated: true)
                                //self.menuVC.dismiss(animated: false, completion: nil)
                        default:
                            break
                    }
                })
            } else {
                self?.usingPinToGetLocation = false
                let home = Constants().GETVALUE(keyname: "home_loc")
                if home.isEmpty{
                    self?.setLocationVC.navigateToAddLocation(for: .Home)
                } else {
                    let lat = Double(Constants().GETVALUE(keyname: "home_latitude")) ?? .zero
                    let lng = Double(Constants().GETVALUE(keyname: "home_longitude")) ?? .zero
                    let loc = MyLocationModel(address: home,
                                              location: CLLocation(
                                                latitude: lat,
                                                longitude: lng))
                    self?.setLocationVC.didPickALocation(loc)
                }
            }
        }
        self.workLocationView.addAction(for: .tap) { [weak self] in
            if userDefaults.string(forKey: "user_id") == "10086" {
                self?.setLocationVC.presentAlertWithTitle(title: appName, message: LangCommon.loginToContinue, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                    (optionss) in
                    switch optionss {
                        case 0:
                            self?.setLocationVC.sharedAppdelegate.showAuthenticationScreen()
                        case 1:
                            self?.setLocationVC.dismiss(animated: true)
                                //self.menuVC.dismiss(animated: false, completion: nil)
                        default:
                            break
                    }
                })
            } else {
                self?.usingPinToGetLocation = false
                let work = Constants().GETVALUE(keyname: "work_loc")
                if work.isEmpty {
                    self?.setLocationVC.navigateToAddLocation(for: .Work)
                } else {
                    let lat = Double(Constants().GETVALUE(keyname: "work_latitude")) ?? .zero
                    let lng = Double(Constants().GETVALUE(keyname: "work_longitude")) ?? .zero
                    let loc = MyLocationModel(address: work,
                                              location: CLLocation(
                                                latitude: lat,
                                                longitude: lng))
                    self?.setLocationVC.didPickALocation( loc)
                }
            }
        }
        self.userMyLocationView.addAction(for: .tap) { [weak self] in
            self?.usingPinToGetLocation = false
            self?.setLocationVC.fethcUserLocationAndSet()
        }
        self.setPinView.addAction(for: .tap) { [weak self] in
            self?.usingPinToGetLocation = false
            self?.usingPinToGetLocation = true
        }
    }
    
    
    // Delivery Splitup Start
    func setBookingTypeData() {
        switch Shared.instance.currentBookingType {
        case .bookNow:
            self.bookLaterBGView.isHidden = true
            self.bookBtn.backgroundColor = .PrimaryColor
            self.bookBtn.setTitleColor(.PrimaryTextColor, for: .normal)
            self.bookLaterBtn.backgroundColor = .TertiaryColor
            self.bookLaterBtn.setTitleColor(.PrimaryTextColor, for: .normal)
        case .bookLater(date: let date, time: let time):
            self.bookLaterBGView.isHidden = false
            self.bookingDateAndTimeLbl.text = date + " , " + time.value
            self.bookBtn.backgroundColor = .TertiaryColor
            self.bookBtn.setTitleColor(.PrimaryTextColor, for: .normal)
            self.bookLaterBtn.backgroundColor = .PrimaryColor
            self.bookLaterBtn.setTitleColor(.PrimaryTextColor, for: .normal)
        }
        
        DispatchQueue.main.async {
            self.locationTableView.reloadData()
        }
    }
    // Delivery Splitup End
    
    
    //MARK:- UDF
    func fetchLocationFromPinAndSet(){
        self.searchPredictions.removeAll()
        self.usingPinToGetLocation = true
    }
    func setWorkHomeLocations(){
        let work = Constants().GETVALUE(keyname: "work_loc")
        let home = Constants().GETVALUE(keyname: "home_loc")
        if work.isEmpty {
            self.workTitleLbl.text = LangCommon.addWork.capitalized
            self.workValueLbl.text = nil
            self.workValueLblView.isHidden = true
        } else {
            self.workTitleLbl.text = LangCommon.work.capitalized
            self.workValueLbl.text = work
            self.workValueLblView.isHidden = false
        }
        if home.isEmpty {
            self.homeTitleLbl.text = LangCommon.addHome.capitalized
            self.homeValueLbl.text = nil
            self.homeValueLblView.isHidden = true
        } else {
            self.homeTitleLbl.text = LangCommon.home.capitalized
            self.homeValueLbl.text = home
            self.homeValueLblView.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.locationOptionHolderView.layoutIfNeeded()
            self.locationOptionHolderView.reloadInputViews()
            self.locationTableView.reloadData()
            self.layoutIfNeeded()
            self.reloadInputViews()
        }
    }
}

//--------------------------------------
//MARK:- UITableViewDataSource
//--------------------------------------

extension HandySetLocationView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.usingPinToGetLocation {
            self.removeMapView()
            self.addMapView()
            return 0
        } else {
            self.removeMapView()
        }
        
        return self.searchPredictions.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if self.searchPredictions.isNotEmpty || self.usingPinToGetLocation {
            return 0
        }
//        if self.usingPinToGetLocation {
//            return 180
//        }
        return 350 - (self.setLocationVC.shouldShowChangeBookingTypeView ? 0 : 80) - (self.bookLaterBGView.isHidden ? 30 : 0)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if  self.searchPredictions.isNotEmpty{//self.usingPinToGetLocation ||
            return nil
        }
        return locationOptionHolderView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandySearchLocationTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let prediction = self.searchPredictions.value(atSafe: indexPath.row) else{return cell}
        cell.lblTitle.text = prediction.structuredFormatting.mainText
        cell.lblSubTitle.text = prediction.structuredFormatting.secondaryText
        cell.ThemeUpdate()
        if searchPredictions.count > 1 {
            if indexPath.row == 0 {
                cell.outerView.setSpecificCornersForTop(cornerRadius: 25)
            }else if indexPath.row == searchPredictions.count - 1 {
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

//--------------------------------------
//MARK:- UITableViewDelegate
//--------------------------------------

extension HandySetLocationView : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let prediction = self.searchPredictions.value(atSafe: indexPath.row) else{return }
        
        self.setLocationVC.getLocationCoordinates(withReferenceID: prediction.reference,
                                                  address: prediction.structuredFormatting.mainText + "," + prediction.structuredFormatting.secondaryText )
    }
}

//--------------------------------------
//MARK:- GoogleAutoCompleteDelegate
//--------------------------------------

extension HandySetLocationView : GoogleAutoCompleteDelegate {
    func googleAutoComplete(failedWithError error: String) {
        self.usingPinToGetLocation = false
        debug(print: error)
        AppUtilities().customCommonAlertView(titleString: appName,
                                             messageString: error)
    }
    
    func googleAutoComplete(predictionsFetched predictions: [Prediction]) {
        self.usingPinToGetLocation = false
        self.searchPredictions = predictions
        if let text = locationSearchBar.text,
           text.isEmpty {
            self.usingPinToGetLocation = false
            self.searchPredictions.removeAll()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.ThemeChange()
        }
        self.locationTableView.reloadData()
    }
    func googleAutoComplete(didBeginEditing searchBar: UISearchBar) {
        self.usingPinToGetLocation = false
        searchBar.text = nil
    }
    
    func googleAutoComplete(didBeginEditing searchBar: UITextField) {
        self.usingPinToGetLocation = false
        searchBar.text = nil
    }
}

//--------------------------------------
//MARK:- GMSMapViewDelegate
//--------------------------------------

extension HandySetLocationView : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard !self.map_view_is_idle else{return}//Return if already in idle state
        self.map_view_is_idle = true
        self.idleLocation = .init(location: CLLocation(latitude: position.target.latitude,
                                                       longitude: position.target.longitude))
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.map_view_is_idle = false
        return
    }
}


