//
//  TripHistoryVC.swift
//  GoferDriver
//
//  Created by trioangle on 14/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire

extension UILabel {

    func startBlink() {
        UIView.animate(withDuration: 0.8,
              delay:0.0,
              options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
              animations: { self.alpha = 0 },
              completion: nil)
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
class HandyTripHistoryVC: BaseViewController {

    var newTap : Tabs = .pending
    var viewModel = HandyJobHistoryVM()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var isNeedRootVC : Bool = false
    
    @IBOutlet var tripHistoryView: HandyTripHistoryView!
    
    var completedJobHistoryModel: GoferDataModel?
    var pendingJobHistoryModel: GoferDataModel?
    
    
    //MARK:- Refreshers
    lazy var pendingRefresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    lazy var completedRefresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    //MARK:- loaders
    lazy var pendingLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    lazy var completedLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    //MARK:- indexed
    var currentCompletedTripPageIndex = 1{
        didSet{
            debug(print:currentCompletedTripPageIndex.description)
        }
    }
    var totalCompletedTripPages = 1{
        didSet{
            debug(print: totalPendingTripPages.description)
        }
    }
    var currentPendingTripPageIndex = 1{
        didSet{
            debug(print:currentPendingTripPageIndex.description)
        }
    }
    var totalPendingTripPages = 1{
        didSet{
            debug(print:totalPendingTripPages.description)
        }
    }
    var showScheduledTripsOnStart = false
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()         // access the features of the main view did load
        self.deinitObservers()      // removing the observers
        self.initObservers()        // initalizing the observers
    }
/* remove the Observers from before use
     -: observers Names: * pendingTripHistory
                         * completedTripHistory
*/
    
    func deinitObservers() {
        NotificationEnum.completedTripHistory.removeObserver(self)  // remove completed history observer
        NotificationEnum.pendingTripHistory.removeObserver(self)    // remove pending history observer
    }
    
    
/* initialzing the Observers
     -: observers Names: * pendingTripHistory
                         * completedTripHistory
*/
    
    func initObservers() {
        NotificationEnum.completedTripHistory.addObserver(self, selector: #selector(self.completedJobHistoryRefresh))  // initialize completed history observer
        NotificationEnum.pendingTripHistory.addObserver(self, selector: #selector(self.pendingJobHistoryRefresh))    // initialize pending history observer
    }
    
/*
     Refresh The Pending history Using Observer
     - : Observer Name :: pendingTripHistory
*/
    
    @objc
    func pendingJobHistoryRefresh() {
        self.pendingJobHistoryModel = nil
        self.tripHistoryView.pendingTable.reloadData()    // Reload The tableview to Take a Effect of empty table
        self.fetchPendingTripsData(NeedCache: false)  // fetch the new data,Fill in tableview and refresh the tableview
    }
    
/*
     Refresh The Pending history Using Observer
     - : Observer Name :: completedTripHistory
*/
    
    @objc
    func completedJobHistoryRefresh() {
        self.completedJobHistoryModel = nil
        self.tripHistoryView.completedTable.reloadData()    // Reload The tableview to Take a Effect of empty table
        self.fetchCompletedTripsData(NeedCache: false)  // fetch the new data,Fill in tableview and refresh the tableview
    }
    
    
//    @objc func completedTripHistoryData() {
//        self.completedJobHistoryModel = nil
//        self.pendingJobHistoryModel = nil
//        self.tripHistoryView.pendingTable.reloadData()
//        self.tripHistoryView.completedTable.reloadData()
//        self.fetchPendingTripsData()
//        self.fetchCompletedTripsData()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func acceptedJobs(requestID: Int) {
        
    }
    
    //MARK:- UDF
    func fetchCompletedTripsData(NeedCache: Bool){
        // Handy Splitup Start
        if AppWebConstants.businessType == .DeliveryAll {
           
        } else {
            // Handy Splitup End
            self.viewModel.wsToGetCompletedJobs(needCache: NeedCache,
                                                completedJobHistoryModel: self.completedJobHistoryModel) { (result) in
                switch result {
                case.success(let data):
                    if data.statusCode == "1" {
                        self.completedJobHistoryModel = data
                        if self.completedRefresher.isRefreshing{
                            self.tripHistoryView.completedTable.reloadData()
                            self.completedRefresher.endRefreshing()
                        }
                        self.currentCompletedTripPageIndex = data.currentPage
                        self.totalCompletedTripPages = data.totalPages
                        self.completedLoader.stopAnimating()
                        self.tripHistoryView.updateCurrentTab()
                        self.tripHistoryView.completedTable.reloadData()
                        self.tripHistoryView.pendingTable.reloadData()
                        self.tripHistoryView.isCompletedAPICurrentlyHitting = (data.totalPages - data.currentPage) != 0
                    } else {
                        self.completedRefresher.endRefreshing()
                        self.completedLoader.stopAnimating()
                        self.tripHistoryView.completedTable.reloadData()
                    }
                case .failure( _):
                    self.completedRefresher.endRefreshing()
                    self.completedLoader.stopAnimating()
                    self.tripHistoryView.completedTable.reloadData()
                }
            }
          
            if !self.completedRefresher.isRefreshing {
                self.completedLoader.startAnimating()
            }
            // Handy Splitup Start
        }
        // Handy Splitup End
    }
    func fetchPendingTripsData(NeedCache: Bool){
        // Handy Splitup Start
        if AppWebConstants.businessType == .DeliveryAll {
        } else {
            // Handy Splitup End
            self.viewModel.wsToGetPendingJobs(needCache: NeedCache,
                                              pendingJobHistoryModel: self.pendingJobHistoryModel) { (result) in
                switch result {
                case .success(let data) :
                    if data.statusCode == "1" {
                    self.pendingJobHistoryModel = data
                    if self.pendingRefresher.isRefreshing{
                        self.tripHistoryView.pendingTable.reloadData()
                        self.pendingRefresher.endRefreshing()
                    }
                                      
                    self.currentPendingTripPageIndex = data.currentPage
                    self.totalPendingTripPages = data.totalPages
                    self.pendingLoader.stopAnimating()
                    self.tripHistoryView.updateCurrentTab()
                    self.tripHistoryView.pendingTable.reloadData()
                    self.tripHistoryView.completedTable.reloadData()
                    self.tripHistoryView.updateCurrentTab()
                    self.tripHistoryView.isPendingAPICurrentlyHitting = (data.totalPages - data.currentPage) != 0
                    } else {
                        self.pendingRefresher.endRefreshing()
                        self.pendingLoader.stopAnimating()
                        self.tripHistoryView.pendingTable.reloadData()
                    }
                case .failure( _):
                    self.pendingRefresher.endRefreshing()
                    self.pendingLoader.stopAnimating()
                    self.tripHistoryView.pendingTable.reloadData()
                }
            }
           
            if !self.pendingRefresher.isRefreshing{
                self.pendingLoader.startAnimating()
            }
            // Handy Splitup Start
        }
        // Handy Splitup End
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.newTap == self.tripHistoryView.oldTap {
            self.tripHistoryView.currentTab = self.tripHistoryView.oldTap
        } else {
            self.tripHistoryView.currentTab = self.newTap
        }
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    //MARK:- initWithStory
    class func initWithStory() -> HandyTripHistoryVC{
        let view :HandyTripHistoryVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    
    // Gofer Splitup Start
    
    func goToRatingVC(withTrip data : HandyJobDetailModel){
//        let propertyView = self.storyboard?.instantiateViewController(withIdentifier: "RateYourRideVC") as! RateYourRideVC
//        propertyView.tripDetailData = data
//        propertyView.isFromTripPage = true
//        self.navigationController?.pushViewController(propertyView, animated: true)
    }
    // Gofer Splitup end
    func getRefreshController() -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: LangCommon.pullToRefresh)
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }
    
    @objc func onRefresh(_ sender : UIRefreshControl){
        
        if sender == self.pendingRefresher{
            self.pendingJobHistoryModel = nil
            self.fetchPendingTripsData(NeedCache: false)
        }else{
            self.completedJobHistoryModel = nil
            self.fetchCompletedTripsData(NeedCache: false)
        }
    }
    
    func getBottomLoader() -> UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    //MARK:- navigate
    func navigateIncompleteJob(_ job : HandyJobDetailModel){
        AppRouter(self).routeInCompleteTrips(job)
    }
    // Delivery Splitup Start
    func navigateGoferIncompleteJob(_ job : DataModel){
        AppRouter(self).routeGoferInCompleteTrips(job.jobID, job.status)
    }
    // Delivery Splitup End

    func navigateIncompleteJob(with JobID : String) {
        
    }
    
    func navigateToreceiptPopup(){
        
    }
    
    func navigateToCancelTrip(forJob job : DataModel){
        let cancelRiderVC = CancelRideVC.initWithStory()
        cancelRiderVC.strTripId = job.jobID.description
        cancelRiderVC.isFromHistory = true
        self.navigationController?.pushViewController(cancelRiderVC, animated: false)
    }
}






extension HandyTripHistoryVC : UpdateContentProtocol{
    func updateContent() {
        self.tripHistoryView.pendingTable.reloadData()
        self.tripHistoryView.completedTable.reloadData()
        self.fetchPendingTripsData(NeedCache: false)
        self.fetchCompletedTripsData(NeedCache: false)
    }
    
    
}

