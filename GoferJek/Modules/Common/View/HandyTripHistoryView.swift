//
//  TripHistoryView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 09/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
enum Tabs{
    ///past
    case pending
    ///upcomming
    case completed
}

class HandyTripHistoryView: BaseView {
    
  
    //MARK:- Variabels
    var oldTap : Tabs = .pending
// Gofer Splitup Start
    var SelectedItemName : String = "Handy"
    // Gofer Splitup end
    var viewController: HandyTripHistoryVC!
    var selectedTrip : DataModel?
    var selectedGoferTrip: DataModel?

    //MARK:- Outlets
    @IBOutlet weak var navView : HeaderView!
    @IBOutlet weak var pageTitleLbl : SecondaryHeaderLabel!
    
    
    @IBOutlet weak var segmentedControl: CommonSegmentControl!
    
    @IBOutlet weak var pendingTitleBtn : UIButton!
    @IBOutlet weak var completedTitleBtn : UIButton!
    @IBOutlet weak var sliderView : UIView!
    
    @IBOutlet weak var parentScrollView : UIScrollView!
    @IBOutlet weak var stackScrollChild : UIStackView!
    @IBOutlet weak var viewScrollChild : UIView!
    @IBOutlet weak var pendingTable : CommonTableView!
    @IBOutlet weak var completedTable : CommonTableView!
    @IBOutlet weak var sliderBGView: SecondaryView!
    @IBOutlet weak var pendingHolderView: TopCurvedView!
    @IBOutlet weak var completedHolderView: TopCurvedView!
    @IBOutlet weak var completedCurveHolderView: SecondaryView!
    @IBOutlet weak var pendingCurveHolderView: SecondaryView!
    @IBOutlet weak var shortBtn: SecondaryTintButton!
    
    // Gofer Splitup Start
    // Handy Splitup Start
    var orginalBusinessType : BusinessType!
    // Handy Splitup End
    
    //MARK:- Variabels
    //var oldTap : Tabs = .pending
    // Gofer Splitup end
    
    var isCompletedAPICurrentlyHitting : Bool = true
    var isPendingAPICurrentlyHitting : Bool = true
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.navView.customColorsUpdate()
        self.pageTitleLbl.customColorsUpdate()
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.sliderBGView.customColorsUpdate()
        self.segmentedControl.customColorsUpdate()
        self.segmentedControl.selectedSegmentTintColor = .clear
        self.segmentedControl.backgroundColor = .clear
        self.sliderView.backgroundColor = .PrimaryColor
        self.pendingTable.customColorsUpdate()
        self.pendingTable.reloadData()
        self.completedTable.customColorsUpdate()
        self.completedTable.reloadData()
        self.pendingHolderView.customColorsUpdate()
        self.completedHolderView.customColorsUpdate()
        self.completedCurveHolderView.customColorsUpdate()
        self.pendingCurveHolderView.customColorsUpdate()
        self.pendingTitleBtn.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.completedTitleBtn.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.pendingTitleBtn.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.completedTitleBtn.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.pendingTitleBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.completedTitleBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.shortBtn.customColorsUpdate()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
    // Gofer Splitup Start
        if self.viewController.isNeedRootVC {
            // Handy Splitup Start
            AppWebConstants.businessType = self.orginalBusinessType
            // Handy Splitup End
            self.viewController.setRootVC()
        } else {
        // Gofer Splitup end
            self.viewController.exitScreen(animated: true)
            // Gofer Splitup Start
        }
        // Gofer Splitup end

    }
    //MARK:- Getter setters
    var currentTab : Tabs = .pending{
        didSet{
            let isPending = currentTab == .pending
            
            UIView.animate(withDuration: 0.3, animations: {
                self.pendingTitleBtn.alpha = isPending ? 1 : 0.5
                self.completedTitleBtn.alpha = !isPending ? 1 : 0.5
                if isRTLLanguage{
                    self.parentScrollView.contentOffset = isPending
                        ? CGPoint(x: self.pendingCurveHolderView.frame.minX,
                                  y: 0)
                        : CGPoint.zero
                    self.sliderView.transform = isPending
                        ? .identity
                        : CGAffineTransform(translationX: -self.pendingTitleBtn.frame.width,
                                            y: 0)
                    if(isPending){
                        self.segmentedControl.selectedSegmentIndex = 0
                        self.viewController.newTap = .pending
                    }else{
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.viewController.newTap = .completed
                    }
                    
                }else{
                    self.parentScrollView.contentOffset = isPending
                        ? CGPoint.zero
                        : CGPoint(x: self.completedCurveHolderView.frame.minX,
                                  y: 0)
                    self.sliderView.transform = isPending
                        ? .identity
                        : CGAffineTransform(translationX: self.pendingTitleBtn.frame.width,
                                            y: 0)
                    if(isPending){
                        self.segmentedControl.selectedSegmentIndex = 0
                        self.viewController.newTap = .pending
                    }else{
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.viewController.newTap = .completed
                    }
                    
                }
                
                
            }){ completed in
                if completed{
                    isPending
                        ? self.pendingTable.reloadData()
                        : self.completedTable.reloadData()
                }
            }
        }
    }
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? HandyTripHistoryVC
        self.initView()
        self.initLanguage()
        self.viewController.fetchPendingTripsData(NeedCache: true)
        self.viewController.fetchCompletedTripsData(NeedCache: true)
        // Do any additional setup after loading the view.
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.SecondaryTextColor], for: .selected)
        self.darkModeChange()
    }
    
    override
    func didDisappear(baseVC: BaseViewController) {
        super.didDisappear(baseVC: baseVC)
        // Gofer Splitup Start
//        AppWebConstants.businessType = self.orginalBusinessType
// Gofer Splitup end
    }
    //MAKR:- initializers
    func initView(){
        self.parentScrollView.delegate = self
        self.pageTitleLbl.text = LangCommon.yourBooking.capitalized
        //            self.pendingTitleBtn.setTitle(LangCommon.pending.capitalized, for: .normal)
        //            self.completedTitleBtn.setTitle(LangCommon.completed.capitalized, for: .normal)
        self.segmentedControl.setTitle(LangCommon.past.capitalized, forSegmentAt: 0)
        self.segmentedControl.setTitle(LangCommon.upComming.capitalized, forSegmentAt: 1)
        
        //self.pendingTable.register(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: "OrderTVH")
        //self.completedTable.register(UINib(nibName: "OrderTVH", bundle: nil), forCellReuseIdentifier: "orderTVH")
        self.completedTable.register(PastTVC.getNib(), forCellReuseIdentifier: "PastTVC")
        self.pendingTable.register(PastTVC.getNib(), forCellReuseIdentifier: "PastTVC")
        self.pendingTable.registerNib(forCell: PendingTripTVC.self)
        self.pendingTable.register(ManualTripTVC.getNib(), forCellReuseIdentifier: "ManualTripTVC")
        self.pendingTable.register(NormalTripTVC.getNib(), forCellReuseIdentifier: "NormalTripTVC")
        self.completedTable.register(NormalTripTVC.getNib(), forCellReuseIdentifier: "NormalTripTVC")
        self.completedTable.registerNib(forCell: PendingTripTVC.self)
        //Delivery Splitup End
        
        self.pendingTable.delegate = self
        self.pendingTable.dataSource = self
        self.pendingTable.prefetchDataSource = self
       
        self.completedTable.delegate = self
        self.completedTable.dataSource = self
        self.completedTable.prefetchDataSource = self
        self.updateCurrentTab()
        //Refresh contoller
        if #available(iOS 10.0, *) {
            self.pendingTable.refreshControl = self.viewController.pendingRefresher
            self.completedTable.refreshControl = self.viewController.completedRefresher
        } else {
            self.pendingTable.addSubview(self.viewController.pendingRefresher)
            self.completedTable.addSubview(self.viewController.completedRefresher)
        }
        //BottomLoader
        self.pendingTable.tableFooterView = self.viewController.pendingLoader
        self.completedTable.tableFooterView = self.viewController.completedLoader
        
        self.shortBtn.setTitle("", for: .normal)
        self.shortBtn.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.shortBtn.isHidden = isSingleApplication
        // Gofer Splitup Start
        self.orginalBusinessType = AppWebConstants.businessType
        // Gofer Splitup end
        // Handy Splitup Start
        self.orginalBusinessType = AppWebConstants.businessType
        // Handy Splitup End
    }
    
    override func willDisappear(baseVC: BaseViewController) {
        super.willDisappear(baseVC: baseVC)
        // Gofer Splitup Start
       // AppWebConstants.businessType = self.orginalBusinessType
// Gofer Splitup end
    }
    @IBAction func customBack(_ sender:Any){
    // Gofer Splitup Start
        //self.viewController.setRootVC()
        // Handy Splitup Start
        AppWebConstants.businessType = self.orginalBusinessType
        // Gofer Splitup end
        // Handy Splitup End
        appDelegate.onSetRootViewController(viewCtrl: self.viewController)
    }
    @IBAction func shortBtnClicked(_ sender: Any) {
    // Gofer Splitup Start
        self.openPopUp()
        // Gofer Splitup end
    }
    // Gofer Splitup Start
    func openPopUp() {
        
    }
    // Gofer Splitup end
    func updateCurrentTab(){
        self.currentTab = self.viewController.newTap
    }
    
    func initLanguage(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            if isRTLLanguage {
                if self.viewController.showScheduledTripsOnStart{
                    self.viewController.showScheduledTripsOnStart = false
                }else{
                    self.currentTab = self.viewController.newTap
                }
            }else{
                if self.viewController.showScheduledTripsOnStart {
                    self.viewController.showScheduledTripsOnStart = false
                    self.currentTab = .completed
                }
            }
        }
        self.pendingTitleBtn.setTitle(LangCommon.past, for: .normal)
        
        self.completedTitleBtn.setTitle(LangCommon.upComming, for: .normal)
        
    }
    
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.currentTab = .pending
        case 1:
            self.currentTab = .completed
        default:
            break
        }
    }
    
    @IBAction func switchTabAction(_ sender : UIButton?){
        if self.currentTab == .completed {
            self.currentTab = .pending
            
        }else{
            self.currentTab = .completed
            
        }
    }
    
    func paginationUpdateInPendingCompleted() {
        // Based On the Current Tab Find The last cell id and Check with our model Last id
        // If it matches hit the api only ones
        
        if self.currentTab == .completed {
            let cell = completedTable.visibleCells.last
            // Gofer Splitup Start
            // Handy Splitup Start
            switch AppWebConstants.businessType {
            default:
                // Handy Splitup End
                if cell?.accessibilityHint == self.viewController.completedJobHistoryModel?.data.last?.jobID.description && isCompletedAPICurrentlyHitting{
                    self.viewController.fetchCompletedTripsData(NeedCache: false)
                    self.isCompletedAPICurrentlyHitting = !self.isCompletedAPICurrentlyHitting
                    print("å:: This is Last For Completed")
                } else {
                    print("å:: Already Hitted Api Completed or Not The Last One")
                }
                // Gofer Splitup end
            }
        } else {
            
            let cell = pendingTable.visibleCells.last
            switch AppWebConstants.businessType {
            default:
                // Handy Splitup End
                if  cell?.accessibilityHint == self.viewController.pendingJobHistoryModel?.data.last?.jobID.description && isPendingAPICurrentlyHitting {
                    self.viewController.fetchPendingTripsData(NeedCache: false)
                    self.isPendingAPICurrentlyHitting = !self.isPendingAPICurrentlyHitting
                    print("å:: This is Last For Pending")
                } else {
                    print("å:: Already Hitted Api Pending or Not The Last One")
                }
            }
        }
       
    }
    
}

//MARK:- ScrollView Delegate
extension HandyTripHistoryView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.paginationUpdateInPendingCompleted()
        guard scrollView == self.parentScrollView else{return}
        if isRTLLanguage{
            self.sliderView
                .transform = CGAffineTransform(translationX: (scrollView
                    .contentOffset.x / 2) - self.sliderView.frame.width ,
                                               y: 0)
        }else{
            self.sliderView
                .transform = CGAffineTransform(translationX: scrollView
                    .contentOffset.x / 2,
                                               y: 0)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.parentScrollView else{return}
        let currentX = scrollView.contentOffset.x
        let maxX = self.frame.width
        
        if isRTLLanguage{
            self.currentTab = currentX >= maxX ? .pending : .completed
        }else{
            self.currentTab = currentX >= maxX ? .completed : .pending
        }
    }
}

extension HandyTripHistoryView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            let count : Int
            if tableView == self.pendingTable {
                // Gofer Splitup Start

                // Handy Splitup Start
                switch AppWebConstants.businessType {
                default:
                    count = self.viewController.pendingJobHistoryModel?.data.count ?? 0
                }
                let pendingDataIsFetching = self.viewController.pendingLoader.isAnimating || self.viewController.pendingRefresher.isRefreshing
                if count == 0 &&
                    !pendingDataIsFetching {
                    let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.pendingTable.bounds.size.width, height: self.pendingTable.bounds.size.height))
                    noDataLabel.text = LangCommon.noDataFound
                    noDataLabel.font = AppTheme.Fontmedium(size: 15).font
                    noDataLabel.textColor = .ThemeTextColor
                    noDataLabel.textAlignment = NSTextAlignment.center
                    self.pendingTable.backgroundView = noDataLabel
                }else{
                    self.pendingTable.backgroundView = nil
                }
            } else {
                switch AppWebConstants.businessType {
                default:
                    count = self.viewController.completedJobHistoryModel?.data.count ?? 0
                }
                let completedDataIsFetching = self.viewController.completedLoader.isAnimating || self.viewController.completedRefresher.isRefreshing
                if count == 0 && !completedDataIsFetching{
                    let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.completedTable.bounds.size.width, height: self.completedTable.bounds.size.height))
                    noDataLabel.text = LangCommon.noDataFound
                    noDataLabel.font = AppTheme.Fontmedium(size: 15).font
                    noDataLabel.textColor = .ThemeTextColor
                    noDataLabel.textAlignment = NSTextAlignment.center
                    self.completedTable.backgroundView = noDataLabel
                }else{
                    self.completedTable.backgroundView = nil
                }
            }
            
            return count
        
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  tableView {
        case self.pendingTable:
            switch AppWebConstants.businessType {
            case .Services:
                guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                let cell :PastTVC = tableView.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.accessibilityHint = trip.jobID.description
                cell.jobDateTime.text = trip.scheduleDisplayDate
                cell.jobId.text = "\(LangCommon.number)#" + trip.jobID.description
                cell.jobLocation.text = trip.pickup
                cell.jobLocationText.text = LangCommon.jobLocation
                if trip.priceType == .distance{
                    cell.dropLocation.text = trip.drop
                    cell.dropLocationText.text = LangCommon.destinationLocation
                    cell.hideDropLocation(isShow: true)
                }else{
                    cell.dropLocation.text = ""
                    cell.dropLocationText.text = ""
                    cell.dropImg.isHidden = true
                    cell.hideDropLocation(isShow: false)
                }
                if trip.status == .pending {
                    cell.showEditTime()
                } else {
                    cell.hideEditTime()
                }
                if trip.status.isTripStarted {
                    cell.hideBottom()
                }
                cell.jobStatusTitleLbl.setTextAlignment()
                cell.ThemeChange()
                let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
                AttributedString.setFont(textToFind: trip.status.localizedString,
                                         weight: .bold,
                                         fontSize: 12)
                switch trip.status {
                case .cancelled:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.cancelled.color)
                case .completed:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.completed.color)
                default:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.Pending.color)
                }
                cell.jobStatusTitleLbl.attributedText = AttributedString
                cell.jobId.setTextAlignment()
                cell.jobDateTime.textAlignment = isRTLLanguage ? .left : .right
                return cell
            default:
                return UITableViewCell()
            }
            // Gofer Splitup end
        case self.completedTable:
        // Gofer Splitup Start
            let cell :PastTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            // Handy Splitup Start
            switch AppWebConstants.businessType {
            case .Services:
                // Handy Splitup End
                guard let job = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.jobStatusTitleLbl.textAlignment = isRTLLanguage ? .right : .left
                if job.status == .pending {
                    cell.showEditTime()
                } else {
                    cell.hideEditTime()
                }
                cell.editTimeBtn.setTitle(LangCommon.editTime, for: .normal)
                cell.editTimeBtn.addAction(for: .tap) {
                    // Handy Splitup Start
                    switch job.businessID{
                        // Delivery Splitup Start
                    case .Services:
                        // Handy Splitup End
                        let bookingVM = HandyJobBookingVM()
                        let providerId = job.providerID
                        let jobId = job.jobID
                        let jobReqID = job.requestID
                        // Sample Time (Wed May 05 2021 at 02:00 am)
                        let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + job.status.localizedString)
                        AttributedString.setFont(textToFind: job.status.localizedString,
                                                 weight: .bold,
                                                 fontSize: 12)
                        AttributedString.setColorForText(textToFind: job.status.localizedString, withColor: JobStatusTheme.Pending.color)
                        cell.jobStatusTitleLbl.attributedText = AttributedString
                        var selectedDate : Date?
                        let formatter: DateFormatter = DateFormatter()
                        formatter.dateFormat = "EEE MMM dd yyyy 'at' h:mm a"
                        formatter.timeZone = TimeZone(identifier: "UTC")
                        if let formatedDate = formatter.date(from: job.scheduleDisplayDate) {
                            selectedDate = formatedDate
                        }
                        let calenderVC = HandyCalendarVC.initWithStory(for: nil,
                                                                          providerID: providerId,
                                                                          jobID: jobId,
                                                                          jobReqID: jobReqID,
                                                                          jobDate: selectedDate,
                                                                          with: bookingVM)
                        calenderVC.isForEditTime = true
                        self.viewController.navigationController?.pushViewController(calenderVC, animated: true)
                    default:
                        break
                    }
                    // Handy Splitup End
                    
                }
                
                if job.status.isTripStarted {
                    cell.hideBottom()
                } else if job.status == .scheduled || job.status == .beginJob || job.status == .pending {
                    cell.showBottom()
                }
                cell.ThemeChange()
                let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + job.status.localizedString)
                AttributedString.setFont(textToFind: job.status.localizedString,
                                         weight: .bold,
                                         fontSize: 12)
                AttributedString.setColorForText(textToFind: job.status.localizedString, withColor: JobStatusTheme.Pending.color)
                cell.jobStatusTitleLbl.attributedText = AttributedString
                cell.jobDateTime.text = job.scheduleDisplayDate
                cell.jobId.text = "\(LangCommon.number)#" + job.jobID.description
                cell.accessibilityHint = job.jobID.description
                cell.jobLocation.text = job.pickup
                cell.jobLocationText.text = LangCommon.jobLocation
                if job.priceType == .distance{
                    cell.dropLocation.text = job.drop
                    cell.dropLocationText.text = LangCommon.destinationLocation
                    cell.hideDropLocation(isShow: true)
                }else{
                    cell.dropLocation.text = ""
                    cell.dropLocationText.text = ""
                    cell.dropImg.isHidden = true
                    cell.hideDropLocation(isShow: false)
                }
                cell.cancelBooking.setTitle(LangHandy.cancelBooking, for: .normal)
                cell.cancelBooking.addAction(for: .tap) {
                    self.viewController.navigateToCancelTrip(forJob: job)
                }
                cell.jobId.setTextAlignment()
                cell.jobDateTime.setTextAlignment(aligned: .right)
                return cell
            default:
                return UITableViewCell()
            }
            
            
            /*if tableView == self.leftTable{
             guard let completed = self.leftTrips.value(atSafeIndex: indexPath.row) else {return cell}
             trip = completed
             }else{
             guard let upComming = self.rightTrips.value(atSafeIndex: indexPath.row) else {return cell}
             trip = upComming
             }
             cell.populateView(withTrip: trip)
             if trip.status.lowercased().contains("rat"){
             self.ratingAction(forTrip: trip, in: cell.statusBtn)
             }else{
             cell.statusBtn.addAction(for: .tap) {}
             }*/
            // Gofer Splitup end
        default:
            return UITableViewCell()
        }
    }
    
    
  

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trip : DataModel?
        if tableView == self.pendingTable {
            trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row)
            self.oldTap = self.currentTab
        } else {
            trip = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row)
            self.oldTap = self.currentTab
        }
        guard  let tripData = trip else {
            return
        }
//        self.viewController.navigateIncompleteJob(tripData)
            self.viewController.navigateGoferIncompleteJob(tripData)
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func onTappedAcceptJob(_ sender:UIButton) {
        //        if let cell = sender.getCurrentCell(cellType: PendingTripTVC.self), let indexPath = self.pendingTable.indexPath(for: cell) {
        //            if let model = self.pendingTrips[indexPath.row].getCurrentTrip() {
        //
        //            }
        //        }
    }
    
    
    
    @objc func onTappedViewRequestedService(_ sender:UIButton) {
        
    }
    
}

extension HandyTripHistoryView : UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        let upCommingRows = indexPaths.compactMap({$0.row})
//        switch tableView {
//        case self.pendingTable:
//            if upCommingRows.contains((self.viewController.pendingJobHistoryModel?.data.count ?? 0) - 1)
//                && self.viewController.currentPendingTripPageIndex != self.viewController.totalPendingTripPages{
//                print("å: Pending \(self.viewController.currentPendingTripPageIndex) : \(self.viewController.totalPendingTripPages)")
//                self.viewController.fetchPendingTripsData()
//            }
//        case self.completedTable:
//            if upCommingRows.contains((self.viewController.completedJobHistoryModel?.data.count ?? 0) - 1)
//                && self.viewController.currentCompletedTripPageIndex != self.viewController.totalCompletedTripPages{
//                print("å: Completed \(self.viewController.currentCompletedTripPageIndex) : \(self.viewController.totalCompletedTripPages)")
//                self.viewController.fetchCompletedTripsData()
//            }
//        default:
//            break
//        }
    }
}

extension HandyTripHistoryView {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
     
        
    }
}

extension HandyTripHistoryView : CustomBottomSheetDelegate {
    func TappedAction(indexPath: Int,
                      SelectedItemName: String) {
        // Handy Splitup Start
        // Delivery Splitup Start
        print("__________Selected Item: \(indexPath) : \(SelectedItemName)")
        guard let selected = AppWebConstants.availableBusinessType.filter({$0.name == SelectedItemName}).first else { return }
        AppWebConstants.businessType = selected.busineesType
        NotificationEnum.completedTripHistory.postNotification()
        NotificationEnum.pendingTripHistory.postNotification()
        self.SelectedItemName = SelectedItemName
        // Delivery Splitup End
        // Handy Splitup End
    }
    func ActionSheetCanceled() {
        print("__________Sheet Cancelled")
    }
}
// Gofer Splitup end


