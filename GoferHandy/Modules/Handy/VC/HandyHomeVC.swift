//
//  HandyHomeVC.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class HandyHomeVC: BaseViewController {
    
    @IBOutlet weak var handyHomeView : HandyHomeView!
    
    var handyBookingVM : HandyJobBookingVM?
    var accountVM : AccountViewModel?
    var services : [Service] = []
    var isSingleCategory = false
    var reference : DatabaseReference?
    var selectCatagoryID : Int?
    var firebaseAuth : Bool = UserDefaults.standard.bool(forKey: "firebase_auth")
    var isSericeAPIInProgress : Bool = true
    var existingServices = [Service]()
    
    lazy var Refresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    
    func getRefreshController() -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: LangCommon.pullToRefresh)
        refresher.addTarget(self,
                            action: #selector(self.onRefresh(_:)),
                            for: .valueChanged)
        return refresher
    }
    
    @objc
    func onRefresh(_ sender : UIRefreshControl){
        self.services.removeAll()
        existingServices = self.handyHomeView.services
        self.handyHomeView.services.removeAll()
        self.handyHomeView.isLoading = true
        self.handyHomeView.servicesCollection.reloadData()
        self.wsToGetServices(isCacheNeeded: false)
    }
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        print("ðððð1")
        
        DispatchQueue.main.async {
            self.deinitNotification()
            self.initNotifications()
        }
        
        if isSingleApplication {
            self.wsToGetEssentialData()
            DispatchQueue.main.async { self.wsToGetUserData() }
        } else {
            if isProfileValueAvailable {
                self.handyHomeView.userLocationCheck(from: Global_UserProfile)
            } else {
                DispatchQueue.main.async { self.wsToGetUserData() }
            }
        }
    }
    
    func updateLocation(param: JSON) {
        self.accountVM?.wsToUpdateLocation(param: param) { result in
            switch result {
                case .success(let response):
                    print(response)
                    if response.status_code == 1 {
                        self.wsToGetServices(isCacheNeeded: false)
                    } else {
                        print("Error \(response.status_message)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isSericeAPIInProgress {
            if isProfileValueAvailable {
                self.handyHomeView.userLocationCheck(from: Global_UserProfile)
            } else {
                DispatchQueue.main.async { self.wsToGetUserData() }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if Shared.instance.resumeTripHitCount == 0 {
                Shared.instance.resumeTripHitCount += 1
                self.wsToGetIncompleteData()
            }
            self.handyHomeView.setBookLaterTiming()
        }
        self.handleJobProgress()
    }
    
        //MARK:- notifications
    func initNotifications(){
        
        let observerForHandyShowAlertForJobStatusChange  = NotificationCenter.default.addObserver(forName: .HandyShowAlertForJobStatusChange, object: nil, queue: nil) { (notification) in
            self.showAlertFrom(notification)
        }
        
        Shared.instance.notifObservers.append(observerForHandyShowAlertForJobStatusChange)
        
        
        
            //            NotificationCenter.default.addObserver(
            //            self,
            //            selector: #selector(self.showAlertFrom(_:)),
            //            name: .HandyShowAlertForJobStatusChange,
            //            object: nil
            //        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.themeRefresh(_:)),
            name: .ThemeRefresher,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.jobAccepterbyProvider(_:)),
            name: .HandyJobRequestAccepted,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.moveToJobHistory(_:)),
            name: .HandyMoveToJobHistory,
            object: nil
        )
    }
    func deinitNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyShowAlertForJobStatusChange,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyJobRequestAccepted,
            object: nil
        )
            //        NotificationCenter.default.removeObserver(
            //            self,
            //            name: .DeliveryRequestAccepted,
            //            object: nil
            //        )
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyMoveToJobHistory,
            object: nil
        )
    }
    @objc
    func showAlertFrom(_ notification : Notification){
        
        if let window = UIApplication.shared.delegate?.window {
            if let view = window?.subviews.last {
                if view.isKind(of: DeletePHIAlertview.self) {
                    print("We Found Some Culprits")
                } else {
                    print("He Got away")
                }
            }
        }
        
        guard let status = notification.object as? String,
              let reason = notification.userInfo?["reason"] as? NotificationTypeEnum else{
            return
        }
        if self.presentedViewController is MorePopOverVC{
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        self.commonAlert.setupAlert(alert: appName, alertDescription: status, okAction: LangCommon.ok.capitalized, cancelAction: nil, userImage: nil)
        self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            switch reason {
                case .cancel_Job:
                    if let topViewController = self.navigationController?.topViewController {
                        if topViewController.isKind(of: HandyRouteVC.self) {
                            topViewController.navigationController?.popViewController(animated: true)
                        }
                    }
                case .EndTrip:
                    break
                default:
                    break
                    
                    
            }
        }
            // Reason For Commenting Can't Work with a options and Producing Multiple Popup
            // Commented By Karuppasamy
            //        self.presentAlertWithTitle(
            //            title: appName,
            //            message: status,
            //            options: self.handyHomeView.LangCommon.ok.capitalized,
            //            completion: {options in
            //                switch options {
            //                case 0:
            //                    if notification.object.debugDescription == "Job Cancelled by Provider" {
            //                        if let topViewController = self.navigationController?.topViewController {
            //                            if topViewController.isKind(of: HandyRouteVC.self) {
            //                                topViewController.navigationController?.popViewController(animated: true)
            //                            }
            //                        }
            //                    }
            //                default:
            //                    break
            //                }
            //            })
        
    }
    @objc
    func themeRefresh(_ notification : Notification) {
        self.handyHomeView.refreshThemeColor()
    }
    @objc
    func jobAccepterbyProvider(_ notification : Notification){
        guard let jobID = notification.object as? Int else { return }
        if let vc = self.navigationController?.viewControllers.last {
            if let presentedVC = vc.presentedViewController { presentedVC.dismiss(animated: false, completion: nil) }
            if vc.isKind(of: HandyRouteVC.self) { guard (vc as! HandyRouteVC).jobID != jobID else { return } }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                //            self.navigationController?.pushViewController(
                //                HandyRouteVC.initWithStory(forJobID: jobID),
                //                animated: true)
        })
    }
    
    @objc
    func moveToJobHistory(_ notification : Notification) {
        self.navigationController?.viewControllers.last?.presentedViewController?.dismiss(animated: false, completion: nil)
        if let vc = self.navigationController?.viewControllers.last ,
           vc.isKind(of: HandyTripHistoryVC.self) {
            (vc as! HandyTripHistoryVC).showScheduledTripsOnStart = true
            return
        }
            //        self.navigationController?.popToViewController(self, animated: false)
        let vc = HandyTripHistoryVC
            .initWithStory()
        vc.showScheduledTripsOnStart = true
        self.navigationController?.pushViewController(vc,
                                                      animated: true
        )
    }
        //MARK:- intiWithStory
    class func initWithStory(categoryID: Int? = nil) -> HandyHomeVC{
        let view : HandyHomeVC = UIStoryboard.gojekHandyBooking.instantiateViewController()
        view.handyBookingVM = HandyJobBookingVM()
        view.accountVM = AccountViewModel()
        view.selectCatagoryID = categoryID
        return view
    }
    
    
    func navigationToBooking() {
        let calenderVC = HandyCalendarVC.initWithStory(for: nil, with: handyBookingVM!)
        self.navigationController?.pushViewController(calenderVC, animated: true)
    }
    
    func navigateToServiceListVC(using service: Service){
            //        service.categories.forEach({$0.isSelected = false})
        let serviceListVC = HandyServiceListVC
            .initWithStory(for: service,
                           usingBookingVM: self.handyBookingVM!,
                           andAccount: accountVM!,
                           serviceName: self.handyHomeView.selectedServiceName)
        serviceListVC.popHandler = {
            serviceListVC.popHandler = nil
            self.handyHomeView.services.first(where: {$0 == service})?.categories = serviceListVC.service.categories
            self.handleSelectedServices()
        }
        self.navigationController?
            .pushViewController(serviceListVC,
                                animated: true)
    }
    
    func navigateToSelectedServiceListVC() {
        let vc = UIStoryboard(name: "GoJek_HandyBooking", bundle: nil).instantiateViewController(withIdentifier: "HandySelectedServiceListVC") as! HandySelectedServiceListVC
        vc.bookingVM = self.handyBookingVM
        vc.accountVM = self.accountVM
        vc.location = self.handyHomeView.userLocation
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navicateToSetupUserLocation() {
        self.navigationController?.pushViewController(HandySetLocationVC.initWithStory(using: self.accountVM!, with: self, showBookingType: true), animated: true)
    }
    
    
    
    func navigateToSetLocation(){
        if let topViewController = navigationController?.topViewController {
            if !topViewController.isKind(of: HandySetLocationVC.self) {
                self.navigationController?
                    .pushViewController(HandySetLocationVC
                        .initWithStory(using: self.accountVM!,
                                       with: self, showBookingType: true),
                                        animated: true)
            } else {
                print("You are Already in Set Location Page")
            }
        }
        
    }
    func showMenuScreen(){
        self.view.endEditing(true)
        let menuVc = MenuVC.initWithStory(self,
                                          accountViewModel: self.accountVM!)
        menuVc.modalPresentationStyle = .overCurrentContext
        self.present(menuVc, animated: false, completion: nil)
        return
    }
        //MARK:- UDF
    
    func checkForCurrentLocation(using model : ProfileModel){
        guard model.currentAddress.isEmpty else{
            self.wsToGetServices(isCacheNeeded: self.selectCatagoryID == nil)
            return
        }
        self.handyBookingVM?.getCurrentLocation({ (location) in
            self.wsToUpdate(userLocation: location)
        })
    }
        //MARK:- ws
    func wsToGetServices(isCacheNeeded: Bool) {
        Shared.instance.showLoaderInWindow()
        let param: JSON = isCacheNeeded ? ["cache": 1] : [:]
        self.handyHomeView.noServiceFoundLbl.adjustsFontSizeToFitWidth = true
        self.handyHomeView.noServiceFoundLbl.isHidden = true
//        self.handyHomeView.chooseStack.isHidden = false

        self.handyBookingVM?.wsToGetServiceListDetails(param: param, { [weak self] (result) in
            DispatchQueue.main.async {
                guard let self = self else { return }

                Shared.instance.removeLoaderInWindow()
                self.Refresher.endRefreshing()
                self.isSericeAPIInProgress = false
                self.handyHomeView.isLoading = false

                switch result {
                case .success(let response):
                    // ====================== MODIFIED LOGIC: START ======================
                    
                    // 1. Handle "Previously Booked" services.
                    // NOTE: Add corresponding properties and UI elements to your view.
                    self.handyHomeView.previousBookedServices = response.previousBooked
                    self.handyHomeView.previousBookedSectionView.isHidden = response.previousBooked.isEmpty
                    self.handyHomeView.previousBookedCollectionView.reloadData()
                    
                    // 2. Handle "All Services" (existing logic is preserved).
                    if !response.services.isEmpty {
                        let oldSelections = selectedServicesCart
                        selectedServicesCart.removeAll()
                        for service in response.services {
                            let new_service = SelectedService(service_id: service.serviceID,
                                                              service_name: service.serviceName,
                                                              service_image: service.imageIcon,
                                                              selectedCategories: [])
                            selectedServicesCart.append(new_service)
                        }
                        
                        for i in 0..<selectedServicesCart.count {
                            let newServiceId = selectedServicesCart[i].service_id
                            if let oldMatchingService = oldSelections.first(where: { $0.service_id == newServiceId }) {
                                selectedServicesCart[i].selectedCategories = oldMatchingService.selectedCategories
                            }
                        }
                        
                        self.handyHomeView.services = response.services
                        self.isSingleCategory = response.services.count == 1
                        self.handleSelectedServices()
                        
                        self.handyHomeView.servicesCollection.isHidden = false
                        self.handyHomeView.noServiceFoundLbl.isHidden = true
//                        self.handyHomeView.chooseStack.isHidden = false
                        
                    } else {
                        // Handle case where no services are found.
                        self.handyHomeView.services.removeAll()
                        self.handyHomeView.servicesCollection.isHidden = true
                        self.handyHomeView.noServiceFoundLbl.isHidden = false
//                        self.handyHomeView.chooseStack.isHidden = true
                        self.handyHomeView.noServiceFoundLbl.text = response.statusMessage
                    }
                    
                    // 3. Reload the main services collection view.
                    self.handyHomeView.servicesCollection.reloadData()

                case .failure(let error):
                    // On failure, clear all data and hide all sections.
                    print(error.localizedDescription)
                    self.handyHomeView.services.removeAll()
                    self.handyHomeView.previousBookedServices.removeAll() // <-- Clear this too
                    
                    self.handyHomeView.previousBookedSectionView.isHidden = true // <-- Hide section
                    
                    self.handyHomeView.noServiceFoundLbl.text = "Error loading services."
                    self.handyHomeView.noServiceFoundLbl.isHidden = false
                    
                    self.handyHomeView.servicesCollection.reloadData()
                    self.handyHomeView.previousBookedCollectionView.reloadData() // <-- Reload this too
                }
                // ====================== MODIFIED LOGIC: END ======================
            }
        })
    }
    func callTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.wsToGetServices(isCacheNeeded: self.selectCatagoryID == nil)
        }
    }
    func wsToGetUserData() {
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: "user_currency_org")
        let userCurrencySym = Constants().GETVALUE(keyname: "user_currency_symbol_org")
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym
        getGloblalUserDetail(params: param) { result in
            switch result {
                case .success(let profile):
                    self.handyHomeView.userLocationCheck(from: profile)
                case .failure(let error):
                    debug(print: error)
            }
        }
            //        self.accountVM?.getUserProfile(userProfile: { (result) in
            //            switch result{
            //            case .success(let profile):
            //                dump(profile)
            ////                self.checkForCurrentLocation(using: profile)
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //                    self.handyHomeView.userLocationCheck(from: profile)
            //                }
            //            case .failure(let error):
            //                print(error.localizedDescription)
            //            }
            //        })
    }
    func wsToGetWallet(){
        self.accountVM?.getPaymentList({ (_) in
            
        })
    }
    func wsToUpdate(userLocation : MyLocationModel){
        self.accountVM?
            .updateCurrentLocation(userLocation,
                                   result: { (updated) in
                guard updated else{ return }
                Global_UserProfile.address = userLocation.getAddress() ?? ""
                Global_UserProfile.currentLatitude = userLocation.coordinate.latitude.description
                Global_UserProfile.currentLongitude = userLocation.coordinate.longitude.description
                self.handyHomeView.userLocationCheck(from: Global_UserProfile)
                self.wsToGetServices(isCacheNeeded: false)
            })
    }
    func wsToGetEssentialData(){
        self.accountVM?.wsToGetCommonData({ (result) in
            switch result{
                case .success(_):
                    self.firebaseAuthentication()
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    
                        //                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        })
        
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.handyHomeView.refreshThemeColor()
    }
    func firebaseAuthentication() {
        let firebaseToken = UserDefaults.standard.value(forKey: "firebase_token") as? String ?? ""
            //        if !firebaseAuth{
        Auth.auth().signIn(withCustomToken: firebaseToken) { (user, error) in
            
            if (error != nil) {
                UserDefaults.standard.setValue(false, forKey: "firebase_auth")
            }else{
                if Shared.instance.permissionDenied {
                    AppDelegate.shared.pushManager.startObservingUser()
                }
                UserDefaults.standard.setValue(true, forKey: "firebase_auth")
            }
        }
            //        }
    }
    func wsToGetIncompleteData(){
        HandyJobServiceVM.getIncompleteTrip { (result) in
            switch result{
                case .success(let detailModel):
                    if detailModel.statusCode != "0" {
                            //                    AppRouter(self).routeInCompleteTrips(detailModel)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
        //getJobProgress
    func handleJobProgress() {
        self.handyBookingVM?.getHomeScreenJobProgress{ result in
            switch result {
                case .success(let json):
                    print(json)
                    var status = json["status_code"] as? String
                    if status == "1" {
                        guard let job_progress = json["users"] as? NSDictionary else {return}
                        if let job_id = job_progress.value(forKey: "job_id") as? Int, let status = job_progress.value(forKey: "job_status_msg") as? String, let time = job_progress.value(forKey: "time") as? String, let provImage = job_progress.value(forKey: "provimage") as? String, let provName = job_progress.value(forKey: "provname") as? String {
                            self.handyHomeView.updateProgressView(isHidden: false, status: status, orderDetail: "\(provName), \(time)", image: provImage, id: job_id)
                        }
                    } else {
                        self.handyHomeView.updateProgressView(isHidden: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription,"error----")
                    self.showPopOver(withComment: error.localizedDescription, on: self.handyHomeView)
                    self.handyHomeView.updateProgressView(isHidden: true)
            }
        }
    }
    
    func handleSelectedServices() {
        var count = 0
        selectedServicesCart.forEach({ service in
            count += service.selectedCategories.count
        })
        self.handyHomeView.btnSelectedServices.superview?.isHidden = count == 0
        self.handyHomeView.lblSelectedServicesCnt.text = count.description
//        self.handyHomeView.btnSelectedServices.setTitle("Selected Services \(count == 0 ? "" : "\(count)")", for: .normal)
    }
}
//MARK:- HandySetLocationDelegate
extension HandyHomeVC : HandySetLocationDelegate{
    func handySetLocation(didSetLocation location: MyLocationModel) {
        self.wsToUpdate(userLocation: location)
        
    }
    
    func handySetLocationDidCancel() {
        print("")
    }
    
    
}
//MARK:- MenuResponseProtocol
extension HandyHomeVC : MenuResponseProtocol{
    
}
