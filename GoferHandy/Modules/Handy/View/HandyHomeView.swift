//
//  HandyHomeView.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps
import GooglePlaces
import CoreLocation

var selectedServicesCart = [SelectedService]()

enum HomeScreenState : CaseIterable {
    
    case showall
    case hide
    
    var displayText : String {
        switch self {
        case .showall:
            return LangCommon.showAll.isEmpty ? "Show All" : LangCommon.showAll.capitalized
        case .hide:
            return LangCommon.hide.isEmpty ? "Hide" : LangCommon.hide.capitalized
        }
    }
}


class HandyHomeView: BaseView {
    
    var handyHomeVC : HandyHomeVC!
    
    var services : [Service] = []
    
    var currentState : HomeScreenState = .showall
    
    var isFilterAvailable : Bool = false
    
    var isShowUserLoc : Bool = true
    // Filtering the Words From the Whole Collection of Service and Stored in relatedWords Variable
    
    var isUserInteractingWithMap = false
    
    var relatedWords: [Service] {
        get {
            var tempWords = [Service]()
            for count in 0..<services.count {
                // Finding the related words in service
                let serviceName = services[count].serviceName
                
                if let text = serviceSearchView.text?.lowercased().replacingOccurrences(of: " ", with: "") ,serviceName.lowercased().replacingOccurrences(of: " ", with: "").contains(text) && serviceSearchView.text != "" {
                    print("------> Entered Text: \(text)")
                    print("------> Text From Service: \(serviceName.lowercased().replacingOccurrences(of: " ", with: "")) ")
                    //Adding the temp words and sent to relatedWords
                    tempWords.append(services[count])
                } else {
                    
                }
            }
            if tempWords.count > 0 {
                return tempWords
            } else {
                if isFilterAvailable {
                    return tempWords
                } else {
                    return services
                }
            }
        }
    }
    
    var job_id : Int = 0
    var orderProgressViewIsHiddenDefault = true
    
    //MARK:- Outlets
    @IBOutlet weak var servicesCollection :UICollectionView!
    @IBOutlet weak var booklaterIndicaterIV: UIImageView!
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var topCurvedView : TopCurvedView!
    @IBOutlet weak var youAreInLbl : SecondaryRegularLabel!
    @IBOutlet weak var locationLbl : SecondaryHeaderLabel!
    @IBOutlet weak var serviceSearchView : commonTextField!
    @IBOutlet weak var searchIV: SecondaryTintImageView!
    @IBOutlet weak var addressDropDownIV : PrimaryImageView!
    @IBOutlet weak var serviceBarView: SecondaryView!
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var heightConstaint: NSLayoutConstraint!
    @IBOutlet weak var bookingDateAndTimeLbl: SecondaryRegularLabel!
    @IBOutlet weak var bookNowOrBookLaterBtn: UIButton!
    
    @IBOutlet weak var bookLaterBGView: SecondaryView!
    @IBOutlet weak var bookLaterBGViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noServiceFoundLbl: SecondaryLargeLabel!
    @IBOutlet weak var bookWashPostion : UIStackView!
    @IBOutlet weak var chooseStack : UIStackView!
    @IBOutlet weak var mapHolderView: UIView!
    @IBOutlet weak var chooseYourWashLbl: InactiveRegularLabel!
    @IBOutlet weak var showAllBtn: TransperentButton!
    @IBOutlet weak var doneBtn: PrimaryButton!
    @IBOutlet weak var pinIV: UIImageView!
    @IBOutlet weak var bookAWassLbl: InactiveRegularLabel!
    
    @IBOutlet weak var orderProgressView: UIView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderDetail: UILabel!
    @IBOutlet weak var imgOrderProgressDriver: UIImageView!
    
    //MARK: --- button for selectedService
    @IBOutlet weak var btnSelectedServices: UIButton!
    
    var map : GMSMapView?
    private var addressDetails : MyLocationModel? {
        didSet {
            addressDetails?.getAddress({[weak self] address in
                if let addres = address {
                    if addres.isEmpty {
                        self?.setUserLocation()
                    } else {
                        self?.locationLbl.text = addres
                    }
                } else {
                    self?.setUserLocation()
                }
            })
        }
    }
    func setUserLocation() {
        self.profileLocation.getAddress({[weak self] address in
            self?.locationLbl.text = address
        })
        self.resetMapLocation(location: profileLocation)
    }
    
    private var previousLocation : CLLocation?
    var profileLocation : MyLocationModel! {
        didSet {
            setUserLocation()
        }
    }
    var userLocation : CLLocation? {
        didSet {
            addressDetails = MyLocationModel(
                address: nil,
                location: CLLocation(latitude: userLocation?.coordinate.latitude ?? 0.0,
                                     longitude: userLocation?.coordinate.longitude ?? 0.0))
            if let userLocation = userLocation,
               let previousLocation = previousLocation {
                if userLocation != previousLocation {
                    resetMapLocation(location: userLocation)
                }
            } else {
                resetMapLocation(location: profileLocation)
            }
            previousLocation = userLocation
        }
    }
    var userZoom : Float = 16.5 {
        didSet { print("Zoom Modified") }
    }
    
    var selectedServiceName : String = ""
    var isLoading : Bool = true
    var height : NSLayoutConstraint!
    @IBAction func showAllBtnClicked(_ sender: Any) {
        // 1. Toggle the state
        self.currentState = (self.currentState == .showall) ? .hide : .showall
        self.showAllBtn.setTitle(self.currentState.displayText, for: .normal)

        // 2. Prepare the new layout style for the collection view's content
        let newLayout = self.createLayoutForCurrentState()

        // 3. Animate all visual changes together in one coordinated block
        UIView.animate(withDuration: 0.4, animations: {
            // A) Animate the hiding/showing of the map and other views
            self.mapHolderView.superview?.isHidden = (self.currentState == .hide)
            self.bookWashPostion.isHidden = (self.currentState == .hide)
            
            // B) Tell the collection view to animate its cells to the new layout
            self.servicesCollection.setCollectionViewLayout(newLayout, animated: false) // The parent UIView block handles the animation timing.

        }) { (finished) in
            // 4. IMPORTANT: Reload data only AFTER the animation is 100% complete.
            // This is the final step that prevents all conflicts.
            if finished {
                self.servicesCollection.reloadData()
            }
        }
    }
    
    func resetMapLocation(location: CLLocation?) {
        guard let map = map,
              let location = location else { print("Map or Location not Correct") ; return }
        let camera = GMSCameraPosition(target: location.coordinate,
                                       zoom: isShowUserLoc ? userZoom : map.camera.zoom)
        map.animate(to: camera)
    }
    
    func addMap() {
        let mapView = GMSMapView()
        self.mapHolderView.addSubview(mapView)
        self.mapHolderView.sendSubviewToBack(mapView)
        self.onChangeMapStyle(map: mapView)
        mapView.anchor(toView: self.mapHolderView, leading: 0, trailing: 0, top: 0, bottom: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            mapView.cornerRadius = 15
            self?.mapHolderView.cornerRadius = 15
            self?.mapHolderView.elevate(2)
        }
        mapView.delegate = self
        self.map = mapView
    }
    
    func removeMap() {
        DispatchQueue.main.async { [weak self] in
            self?.map?.removeFromSuperview()
            self?.map = nil
        }
    }
    
    func onChangeMapStyle(map: GMSMapView) {
        // Delay the entire operation to the next run loop cycle.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            map.clear() // Still a good idea to clear.

            do {
                let resourceName = self.isDarkStyle ? "map_style_dark" : "mapStyleChanged"
                if let styleURL = Bundle.main.url(forResource: resourceName, withExtension: "json") {
                    map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    print("Style File Not Found: \(resourceName).json")
                }
            } catch {
                print("Can't Open or Apply Style File: \(error)")
            }

            // Re-add your markers here.
            // self.addMarkersToMap()
        }
    }
    
    // Rename this function to reflect its new purpose
    func loadInitialMapStyle(map: GMSMapView) {
        do {
            // ALWAYS load the light style ("mapStyleChanged.json") for stability.
            // DO NOT check for isDarkStyle here.map_style_dark
            if let styleURL = Bundle.main.url(forResource: "mapStyleChanged", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Stable map style file not found.")
            }
        } catch {
            print("Can't open or apply stable map style: \(error.localizedDescription)")
        }
    }
    

    
    func designUpdate() {
//        if let heightCons = self.heightConstaint { heightCons.isActive = false }
        self.servicesCollection.alwaysBounceVertical = self.currentState == .hide
        self.servicesCollection.alwaysBounceHorizontal = self.currentState == .showall
//        if self.currentState == .hide {
//            self.height.isActive = false
//        } else {
////            self.height = self.servicesCollection.heightAnchor.constraint(equalToConstant: self.frame.height * 0.2)
//            self.height.isActive = true
//        }
        self.mapHolderView.superview?.isHidden = self.currentState == .hide
        self.bookWashPostion.isHidden = self.currentState == .hide
        let size = self.servicesCollection.frame.width * 0.25
        let cellSize = CGSize(width: size, height: size * 1.4)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = self.currentState == .showall ? .horizontal : .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 1.0
        self.servicesCollection.setCollectionViewLayout(layout, animated: true)
        self.servicesCollection.setNeedsLayout()
        self.servicesCollection.layoutIfNeeded()
        DispatchQueue.main.async {
            self.servicesCollection.reloadData()
        }
    }
    
    private func createLayoutForCurrentState() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = (self.currentState == .showall) ? .horizontal : .vertical
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 1.0
        // The delegate method `sizeForItemAt` will provide the actual cell sizes.
        return layout
    }
    
    @IBAction func doneBtnclicked(_ sender: Any) {
        guard let location = addressDetails else { return }
        location.getAddress { address in
            if let address = address {
                self.handyHomeVC.updateLocation(
                    param: ["current_latitude": location.coordinate.latitude,
                            "current_longitude":location.coordinate.longitude,
                            "address": address])
                Global_UserProfile.address = address
                Global_UserProfile.currentLatitude = location.coordinate.latitude.description
                Global_UserProfile.currentLongitude = location.coordinate.longitude.description
            }
        }
    }
    
    @IBAction func orderProgressViewAction(_ sender: UIButton) {
        switch AppWebConstants.businessType {
        case .Services:
            // Handy Splitup End
                if let vc = self.handyHomeVC.navigationController?.viewControllers.last ,
               vc.isKind(of: HandyRouteVC.self) {
                guard (vc as! HandyRouteVC).jobID != job_id else { return }
            }
            let vc = HandyRouteVC.initWithStory(forJobID: job_id)
                self.handyHomeVC.navigationController?.pushViewController(vc, animated: true)
            // Handy Splitup Start
        default:
            print("Hello")
        }
    }
    
    @IBAction func btnSelectedServicesClk(_ sender: UIButton) {
        var count = 0
        selectedServicesCart.forEach({ service in
            count += service.selectedCategories.count
        })
        if count != 0 {
            self.handyHomeVC.navigateToSelectedServiceListVC()
        }
    }
    
    //MARK:- Actions
    @IBAction
    func menuAction(_ sender : UIButton){
        self.handyHomeVC.showMenuScreen()
    }
    
    //MAKR:- Life Cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.handyHomeVC = baseVC as? HandyHomeVC
        self.initView()
        self.initLanguage()
        self.initGesture()
        self.designUpdate()
    }
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.addMap()
        self.isShowUserLoc = true
        self.handyHomeVC.handleSelectedServices()
    }
    
    override func willDisappear(baseVC: BaseViewController) {
        super.willDisappear(baseVC: baseVC)
        self.removeMap()
    }
    
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    
    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
    }
    //MARK:- initializers
    
    func refreshThemeColor() {
        self.reloadInputViews()
        self.darkModeChange()
        self.menuBtn.imageEdgeInsets = UIEdgeInsets(top: 8,
                                                    left: 5,
                                                    bottom: 8,
                                                    right: 5)
        self.menuBtn.cornerRadius =  12
        self.menuBtn.tintColor = .PrimaryTextColor
        self.menuBtn.backgroundColor = .PrimaryColor
        self.topCurvedView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.youAreInLbl.customColorsUpdate()
        self.locationLbl.customColorsUpdate()
        self.serviceSearchView.setTextAlignment()
        self.serviceBarView.customColorsUpdate()
        self.searchIV.customColorsUpdate()
        self.addressDropDownIV.customColorsUpdate()
        self.serviceSearchView.customColorsUpdate()
        self.servicesCollection.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.serviceSearchView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.bookLaterBGView.customColorsUpdate()
        self.booklaterIndicaterIV.backgroundColor = .PrimaryColor
        self.servicesCollection.reloadData()
//        if let map = map { self.onChangeMapStyle(map: map) }
        self.doneBtn.customColorsUpdate()
    }
    
    func initView(){
        self.bookLaterBGView.isHidden = true
        self.bookLaterBGViewHeight.constant = 0
        self.servicesCollection.delegate = self
        self.servicesCollection.dataSource = self
        self.serviceSearchView.delegate = self
        self.serviceSearchView.addTarget(self,
                                         action: #selector(textChange(_:)),
                                         for: .editingChanged)
        self.serviceBarView.cornerRadius = 10
        self.serviceBarView.elevate(2)
//        self.servicesCollection.register(UINib(nibName: "HomeServicesHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"HomeServicesHeader")
        self.servicesCollection.register(UINib(nibName: "HandyHomeServiceCVC",
                                               bundle: nil),
                                         forCellWithReuseIdentifier: "HandyHomeServiceCVC")
        self.bookNowOrBookLaterBtn.isHidden = true
        self.serviceSearchView.placeholder = LangHandy.searchServices
        self.bookNowOrBookLaterBtn.setTitle(" \(LangHandy.bookLater) ", for: .normal)
        self.bookNowOrBookLaterBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.bookingDateAndTimeLbl.adjustsFontSizeToFitWidth = true
        self.refreshThemeColor()
        self.setRefresher()
        guard let vc = self.handyHomeVC else { return }
        self.serviceBarView.isHidden = vc.isSingleCategory || vc.selectCatagoryID != nil
    }
    
    func setRefresher() {
        if #available(iOS 10.0, *) {
            self.servicesCollection.refreshControl = self.handyHomeVC.Refresher
        } else {
            self.servicesCollection.addSubview(self.handyHomeVC.Refresher)
        }
        
    }
   
    func initLanguage() {
        self.youAreInLbl.text = LangCommon.youAreIn.capitalized
        self.chooseYourWashLbl.text = LangCommon.choostYourWash.isEmpty ? "Choose Your Wash" : LangCommon.choostYourWash
        self.showAllBtn.setTitle(self.currentState.displayText, for: .normal)
        self.bookAWassLbl.text = LangCommon.bookAWashAtPosition.isEmpty ? "Book a Wash at Position" : LangCommon.bookAWashAtPosition
        self.doneBtn.setTitle(LangCommon.done.capitalized, for: .normal)
    }
    
    func initGesture() {
        self.locationLbl.addAction(for: .tap) {
            [weak self] in
            self?.handyHomeVC.navigateToSetLocation()
        }
        self.addressDropDownIV.addAction(for: .tap) {
            [weak self] in
            self?.handyHomeVC.navigateToSetLocation()
        }
    }
    
  // Test Comment
    //MARK:- UDF
    func userLocationCheck(from profile : UserProfileDataModel) {
        self.profileLocation = profile.myCurrentLocation
        self.resetMapLocation(location: self.profileLocation)
        self.isShowUserLoc = false
        // User Loacation Check From API Call
        if profile.userLocaitonIsAvailable {
            self.locationLbl.text = profile.address
            self.handyHomeVC.wsToGetServices(isCacheNeeded: self.handyHomeVC.selectCatagoryID == nil)
        } else {
            self.locationLbl.text = LangCommon.gettingLocation
            // If User Locaction is Not Presented in API,Show an Alert to Remind the User to Set Location
            self.handyHomeVC.commonAlert.setupAlert(alert: LangCommon.appName,
                                                    alertDescription: LangCommon.locationPermissionDescription
                                                        + " "
                                                        + LangCommon.appName
                                                        + " "
                                                        + LangCommon.toAccessLocation,
                                                    okAction: LangCommon.ok.capitalized,
                                                    cancelAction: LangCommon.cancel.capitalized,
                                                    userImage: nil)
            self.handyHomeVC.commonAlert.addAdditionalCancelAction {
                print("Cancel Clicked Without")
            }
            self.handyHomeVC.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                print("Ok is Clicked")
                self.handyHomeVC.navigateToSetLocation()
            }
            
        }
        self.addressDropDownIV.isHidden = self.locationLbl.text?.isEmpty ?? true
    }
    
    func setBookLaterTiming() {
        
        switch Shared.instance.currentBookingType {
        case .bookNow:
            self.bookLaterBGView.isHidden = true
            self.bookLaterBGViewHeight.constant = 0
        case .bookLater(date: let date, time: let time):
            self.bookLaterBGView.isHidden = false
            self.bookLaterBGViewHeight.constant = 50
            self.bookingDateAndTimeLbl.font = self.bookingDateAndTimeLbl.font.withSize(14)
            self.bookingDateAndTimeLbl.text = date + " , " + time.value
            
        }
        
    }
    
    func updateProgressView(isHidden: Bool,status: String? = "",orderDetail: String? = "",image: String? = "",id: Int? = 0) {
        orderProgressViewIsHiddenDefault = isHidden
        orderProgressView.isHidden = isHidden
        lblOrderStatus.text = status
        lblOrderDetail.text = orderDetail
        imgOrderProgressDriver.sd_setImage(with: URL(string: image!), completed: nil)
        job_id = id!
    }
    
    @IBAction func bookNowOrBookLaterBtnPressed(_ sender: Any) {
        
        print("--------> Book Later Button Pressed")
        self.handyHomeVC.navigationToBooking()
    }
}

extension HandyHomeView : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.relatedWords.count
        let isNodataNeed = count == 0 && !self.handyHomeVC.Refresher.isRefreshing && self.noServiceFoundLbl.isHidden
        self.chooseStack.isHidden = !self.noServiceFoundLbl.isHidden || count == 0
        if isNodataNeed && (isFilterAvailable || !self.isLoading)  {
            let placeholderLbl = PrimaryColoredHeaderLabel()
            placeholderLbl.textAlignment = .center
            placeholderLbl.text = LangCommon.noDataFound
            placeholderLbl.customColorsUpdate()
            collectionView.backgroundView = placeholderLbl
        } else {
            collectionView.backgroundView = nil
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HandyHomeServiceCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "HandyHomeServiceCVC", for: indexPath) as! HandyHomeServiceCVC
        guard let item = relatedWords.value(atSafe: indexPath.row) else{return cell}
        cell.serviceIV.sd_setImage(with: URL(string: item.imageIcon), completed: nil)
        cell.serviceNameLbl.text = item.serviceName
        cell.serviceIV.contentMode = .scaleAspectFill
        cell.themeChange()
        return cell
    }
    
}

extension HandyHomeView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let service = self.relatedWords.value(atSafe: indexPath.item) else {return}
        self.endEditing(true)
        self.selectedServiceName = service.serviceName
        self.handyHomeVC.navigateToServiceListVC(using: service)
    }
}

extension HandyHomeView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            // Provide a fallback size if something is wrong.
            return CGSize(width: 80, height: 112)
        }
        
        // --- The Definitive Fix ---
        
        // 1. Define how many items you want in a single row.
        let itemsPerRow: CGFloat = 4
        
        // 2. Get the spacing from the layout object itself.
        let spacing = layout.minimumInteritemSpacing
        
        // 3. Calculate the total width that will be used by the spaces.
        //    (For 4 items, there are 3 spaces in between).
        let totalSpacing = spacing * (itemsPerRow - 1)
        
        // 4. Calculate the width that is actually available for the cells.
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        // 5. Calculate the width for one cell.
        //    Using floor() prevents tiny sub-pixel rounding errors that can also break the layout.
        let cellWidth = floor(availableWidth / itemsPerRow)
        
        // 6. Return the final, correct size.
        return CGSize(width: cellWidth, height: cellWidth * 1.4)
    }
}

extension HandyHomeView : UITextFieldDelegate {
    
    @objc
    func textChange(_ sender: UITextField) {
        self.isFilterAvailable = !(sender.text?.count == 0)
        self.servicesCollection.reloadData()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.servicesCollection.reloadData()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.servicesCollection.reloadData()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HandyHomeView : SingleServiceDelegate {
    func startBtnCliked(service: Service) {
        self.selectedServiceName = service.serviceName
        self.handyHomeVC.navigateToServiceListVC(using: service)
    }
}

extension HandyHomeView : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isShowUserLoc { return }
        guard let _ = userLocation,
        let previousLocation = previousLocation else {
            self.userLocation = CLLocation(latitude: position.target.latitude,
                                           longitude: position.target.longitude)
            return
        }
        if previousLocation != CLLocation(latitude: position.target.latitude,
                                          longitude: position.target.longitude) {
            self.userLocation = CLLocation(latitude: position.target.latitude,
                                           longitude: position.target.longitude)
        }
    }
    
    /*func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            isUserInteractingWithMap = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isUserInteractingWithMap {
            isUserInteractingWithMap = false
            //if isShowUserLoc { return }
            guard let _ = userLocation,
            let previousLocation = previousLocation else {
                self.userLocation = CLLocation(latitude: position.target.latitude,
                                               longitude: position.target.longitude)
                return
            }
            if previousLocation != CLLocation(latitude: position.target.latitude,
                                              longitude: position.target.longitude) {
                self.userLocation = CLLocation(latitude: position.target.latitude,
                                               longitude: position.target.longitude)
            }
        }
    }*/
}

struct SelectedService {
    var service_id: Int
    var service_name: String
    var service_image: String
    var selectedCategories: [Category]
}
