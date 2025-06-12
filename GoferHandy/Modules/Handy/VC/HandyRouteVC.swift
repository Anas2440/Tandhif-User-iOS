//
//  HandyRouteVC.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import CoreLocation

class HandyRouteVC: BaseViewController {
    
    @IBOutlet var enRouteView: HandyRouteView!
    
    var jobViewModel : HandyJobServiceVM!
    var jobID : Int!
    let infoWindow : MorePopOverVC = UIStoryboard.gojekCommon.instantiateViewController()
    var jobDetailModel : HandyJobDetailModel?{
        didSet{
            if let _jobDetail = self.jobDetailModel{self.enRouteView.populateView(with: _jobDetail)}
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.jobViewModel.updateEnablePermissionPopup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNotificationObservers()
       // self.cornerRadiusWithShadow(view: self.enRouteView.jobProgressView)
        self.wsToGetJobDetail()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK:- initNotificationObservers
    func initNotificationObservers(){
        
        //Remove exisiting observers
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyProviderArrived,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyProviderBegunJob,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyProviderEndedJob,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyJobCancelledByProvider,
            object: nil
        )
        //Add new observers
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.tripNotificationReceived(_:)),
            name: .HandyProviderArrived,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.tripNotificationReceived(_:)),
            name: .HandyProviderBegunJob,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.tripNotificationReceived(_:)),
            name: .HandyProviderEndedJob,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.tripNotificationReceived(_:)),
            name: .HandyJobCancelledByProvider,
            object: nil
        )
    }
  
    //MARK:- initWith Story
    class func initWithStory(forJobID jobID : Int) -> HandyRouteVC {
        let vc : HandyRouteVC = UIStoryboard.gojekHandyBooking.instantiateViewController()
        vc.jobViewModel = HandyJobServiceVM(forJob: jobID)
        vc.jobID = jobID
        return vc
    }
    class func initWithStory(forJob job : HandyJobDetailModel) -> HandyRouteVC {
          let vc : HandyRouteVC = UIStoryboard.gojekHandyBooking.instantiateViewController()
          vc.jobViewModel = HandyJobServiceVM(forJob: job)
          vc.jobID = job.users.jobID
          return vc
      }
    //MAKR:- udf
    func cornerRadiusWithShadow(view: UIView){
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true;
        view.backgroundColor = view.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        view.layer.shadowColor = view.isDarkStyle ? UIColor.DarkModeBorderColor.cgColor : UIColor.TertiaryColor.withAlphaComponent(0.5).cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 6.0
        view.layer.masksToBounds = false
        
    }
    //MARK:- UDF
    func getMenuOptions() -> [MoreOptions]{
        var options  = [MoreOptions]()
        guard let jobModel = jobDetailModel else {
            return options
        }
        options.append(.Call)
        options.append(.Message)
        if self.enRouteView.currentlyViewing == .list{
            if jobModel.canShowLiveTrackingMap{
                options.append(.LiveTrack)
            }
        }else{
            options.append(.JobProgress)
        }
        options.append(.RequestedService)
        if jobModel.users.jobStatus.isTripStarted  {
            options.append(.SOS)
        }else{
            options.append(.Cancel_Booking)
            if jobModel.amITheTraveller {
                options.append(.ThirdPartyNavigation)
            }
        }
        
        return options
        
    }
    
    //MARK:- WebService
    func wsToGetJobDetail(reqID : Int? = nil){
        self.jobViewModel.wsToGetJobDetail(reqID:reqID,showLoader: true) { (result) in
            switch result{
                case .success( let data) :
                    self.jobDetailModel = data
                    self.jobViewModel.initiateLiveTracking(usignMapView: self.enRouteView.gmsMapView)
                    self.jobViewModel.validateMapMarkers()
                    if self.jobDetailModel?.users.jobStatus.localizedString == "Payment" {
                        self.navigateToPaymentVC()
                    }
                case .failure( _) : break
            }
        }
    }

    //MARK:- observers
    @objc
    func tripNotificationReceived(_ sender : Notification){
        switch sender.name {
        case .HandyProviderArrived:
            fallthrough
        case .HandyProviderBegunJob:
            self.wsToGetJobDetail()

        case .HandyProviderEndedJob:
            self.commonAlert.setupAlert(alert: appName,
                                        alertDescription: sender.userInfo?["job_progress_status"] as? String,
                                        okAction: LangCommon.ok.capitalized,
                                        cancelAction: nil,
                                        userImage: nil)
            self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                self.navigateToPaymentVC()
            }
//            self.navigateToPaymentVC()
        case .HandyJobCancelledByProvider:
            self.infoWindow.dismiss(animated: true, completion: {
                print("------------------> Pop Over View Closed")
                self.exitScreen(animated: true)
            })
            print("------------------> Job Cancelled By Provider")
        default:
            self.wsToGetJobDetail()
        }
    }
    //MARK:- navigations
    func showPopOver(sender : UIButton){
        let buttonFrame = sender.frame
        let infoWindow : MorePopOverVC = UIStoryboard.gojekCommon.instantiateViewController()
        let items = self.getMenuOptions()
        infoWindow.preferredContentSize = CGSize(width: 200, height: items.count * 45)
        
        infoWindow.modalPresentationStyle = .popover
        infoWindow.datas = items
        infoWindow.delegate = self
        infoWindow.view.backgroundColor = .PrimaryColor
        let popover: UIPopoverPresentationController = infoWindow.popoverPresentationController!
        popover.delegate = self
        popover.sourceView = self.enRouteView
        popover.sourceRect = buttonFrame
        popover.backgroundColor = .PrimaryColor
        popover.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(infoWindow, animated: true, completion: nil)
    }
    func onCallAction(){
        guard let jobDetail = self.jobDetailModel else{
            self.wsToGetJobDetail()
            return
        }
        if jobDetail.users.bookingType != BookingEnum.manualBooking{
            do{
                try CallManager.instance.callUser(withID: jobDetail.providerID.description)
            }catch let error{
                debug(print: error.localizedDescription)
            }
        }else{
            if let phoneCallURL:NSURL = NSURL(string:"tel://\(jobDetail.mobileNumber )") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL as URL)) {
                    //                    application.openURL(phoneCallURL as URL);
                    application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    func navigateToCancelJob(){
        guard let job = self.jobDetailModel else{self.wsToGetJobDetail() ;return}
        let cancelRiderVC = CancelRideVC.initWithStory()
        cancelRiderVC.strTripId = job.users.jobID.description
        self.navigationController?.pushViewController(cancelRiderVC, animated: false)
    }
    
    func navigateToBookedServices(){
        
        guard let job = self.jobDetailModel else{self.wsToGetJobDetail() ;return}
        let cancelRiderVC = HandyBookedServicesVC.initWithStory(reqID:job.users.requestID.description,forJob: job)
        self.navigationController?.pushViewController(cancelRiderVC, animated: false)
    }
    func navigateToChatScreen(){
        guard let job = self.jobDetailModel else{self.wsToGetJobDetail() ;return}
        let chatVC = ChatVC.initWithStory(
            withTripId: job.users.jobID.description,
            driverRating: job.providerRating,
            driver_id: job.providerID,
            imageURL: job.providerImage,
            name: job.providerName, typeCon: .u2d
            )
        self.navigationController?
            .pushViewController(chatVC,
                                animated: true)
    }
    func navigateToPaymentVC(){
        guard let job = self.jobDetailModel else{return}
        if let vc = self.navigationController?.viewControllers.last ,
           vc.isKind(of: HandyPaymentVC.self) {
            guard (vc as! HandyPaymentVC).jobID != job.users.jobID else { return }
        }
        print(job.users.jobStatus.localizedString,"status of job for payment")
        self.navigationController?
            .pushViewController(HandyPaymentVC.initWithStory(job: job,
                                                             jobID: job.users.jobID,
                                                             jobStatus: job.users.jobStatus, promoId: job.users.promoId),
                                animated: true)
    }
    func showAlertForThirdPartyNavigation(fromUserLocation : CLLocation){
        guard let data = self.jobDetailModel else{return}
        let pickupCoordinate = fromUserLocation.coordinate
        let dropCoordinate = data.targetJobLocation.coordinate
        
        
        
        let actionSheetController = UIAlertController(
            title: LangCommon.hereYouCanChangeYourMap,
            message: LangCommon.byClicking,
            preferredStyle: .actionSheet)
        actionSheetController
            .addColorInTitleAndMessage(titleColor: UIColor.PrimaryColor,
                                       messageColor: UIColor.PrimaryColor,
                                       titleFontSize: 15,
                                       messageFontSize: 13)
        let googleMapAction = UIAlertAction(title: LangCommon.googleMap,
                                            style: .default) { (action) in
            self.showThirdPartyNavigation(for: ThirdPartyNavigation.google(pickup: pickupCoordinate,
                                                       drop: dropCoordinate))
        }
        googleMapAction.setValue(UIColor.PrimaryColor,
                                 forKey: "TitleTextColor")
        let wazeMapAction = UIAlertAction(title: LangCommon.wazeMap,
                                          style: .default) { (action) in
            self.showThirdPartyNavigation(for: ThirdPartyNavigation.waze(pickup: pickupCoordinate,
                                                     drop: dropCoordinate))
        }
        wazeMapAction.setValue(UIColor.PrimaryColor,
                               forKey: "TitleTextColor")
      let cancelAction: UIAlertAction = UIAlertAction(title: LangCommon.cancel.lowercased().capitalized,
                                                      style: .cancel) { action -> Void in }
        actionSheetController.addAction(googleMapAction)
        actionSheetController.addAction(wazeMapAction)
        actionSheetController.addAction(cancelAction)
        self.presentingViewController?.dismiss(animated: true,
                                               completion: nil)
        self.present(actionSheetController,
                     animated: false,
                     completion: nil)
    }
      //MARK:- showThirdPartyNavigation
      func showThirdPartyNavigation(for party : ThirdPartyNavigation) {
          if party.isApplicationAvailable{
              party.openThirdPartyDirection()
          }else{
              self.commonAlert.setupAlert(alert: LangCommon.doYouWantToAccessdirection,
                                          alertDescription: party.getDownloadPermissionText,
                                          okAction: LangCommon.ok.uppercased(),
                                          cancelAction: LangCommon.cancel)
              self.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                  party.openAppStorePage()
              }
          }
      }
    func navigateToSOS(){
        
        let sosVC = SOSViewController.initWithStory()
        self.presentInFullScreen(sosVC, animated: true, completion: nil)
    }
    
}


//MARK:- UIPopoverPresentationControllerDelegate
extension HandyRouteVC : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
     
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
     
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return true
    }
}

//MARK:- PopOverProtocol
extension HandyRouteVC : MorePopOverProtocol{
    func morepopOverSelection(diSelect data: MoreOptions) {
                 print(data)
         switch data {
         case .LiveTrack:

            guard let detial = self.jobViewModel.jobDetailModel else{
                return
            }
            self.enRouteView.setCurrentViewing(to: .map, jobDetail: detial)
         case .JobProgress:

            guard let detial = self.jobViewModel.jobDetailModel else{
                return
            }
            self.enRouteView.setCurrentViewing(to: .list, jobDetail: detial)
         case .Message:
            self.navigateToChatScreen()
         case .Call:
            self.onCallAction()
         case .Cancel_Booking:
            self.navigateToCancelJob()
         case .ThirdPartyNavigation:
            self.jobViewModel.getCurrentLocation { (location) in
                self.showAlertForThirdPartyNavigation(fromUserLocation: location)
            }
         case .SOS:
            self.navigateToSOS()
         case .RequestedService:
            self.navigateToBookedServices()
         case .ViewRecipients:
            self.navigateToBookedServices()
        }
        
    }
    
    func morepopOverSelectionCancelled() {
        
    }
    

   
    
    
}
