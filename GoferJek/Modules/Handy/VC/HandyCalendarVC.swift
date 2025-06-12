//
//  HandyCalendarVC.swift
//  GoferHandy
//
//  Created by trioangle on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyCalendarVC: BaseViewController {

    @IBOutlet weak var calendarView : HandyCalendarView!
    
    var selectedServices : String = ""
    var isForEditTime : Bool = false
    var provider : Provider?
    var providerId : Int?
    var jobID : Int?
    var jobReqID : Int?
    var jobDate : Date?
    var bookingViewModel : HandyJobBookingVM!
    var weekDataSource : WeekDataSource = [:]
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wsToGetAvailablity()
        // Do any additional setup after loading the view.
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //MARK:- intiWithStory
    class func initWithStory(for provider :Provider?,
                             providerID : Int? = nil,
                             jobID : Int? = nil,
                             jobReqID : Int? = nil,
                             jobDate : Date? = nil,
                             with bookingVM : HandyJobBookingVM) -> HandyCalendarVC{
        let view : HandyCalendarVC =  UIStoryboard.gojekHandyUnique.instantiateViewController()
        view.provider = provider
        view.jobID = jobID
        view.jobReqID = jobReqID
        view.providerId = providerID
        view.jobDate = jobDate
        view.bookingViewModel = bookingVM
        return view
    }
    func getPreviousMonthDates() -> [Date]{
        return self.bookingViewModel.getPrevMonthDataSource()
    }
    func getNexMonthDates() -> [Date]{
        return self.bookingViewModel.getNextMonthDataSource()
    }
    func getCurrentMonthDates() -> [Date]{
        return self.bookingViewModel.getOneYearsDataSource()//getCurrentMonthDataSource()
        
    }
    func wsToGetAvailablity(){
        var providerIDPresented : Bool = false
        if let _ = providerId {
            providerIDPresented = true
        }
        self.bookingViewModel.wsToGetAvailablity(for: self.provider,providerId: providerIDPresented ? providerId : nil){ response in
            switch response{
            case .success(let result):
                self.weekDataSource = result.availableTimes.dataSource
                self.calendarView.hourlyTableView.reloadData()
                self.calendarView.goToLastPosition()
            case .failure(let error):
                AppUtilities()
                    .customCommonAlertView(titleString: appName,
                                           messageString: error.localizedDescription)
            }
        }
    }
    //MARK:- navigate
  
    func donePicking(date : String,time : DayElement){
        Shared.instance.currentBookingType = .bookLater(date: date, time: time)
        self.exitScreen(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func editJobTimeUpdate(date : String,
                           time : DayElement,
                           jobID : Int,
                           jobReqID : Int) {
        let support = UberSupport()
        support.showProgressInWindow(showAnimation: true)
        Shared.instance.currentBookingType = .bookLater(date: date, time: time)
        guard let providerId = providerId else { return }
        self.bookingViewModel.wsToBook(provider: nil,
                                       atUserLocation: false,
                                       providerId: providerId,
                                       jobReqID: jobReqID) { (result) in
            switch result {
            case .success( let json):
                
                if json.isSuccess {
                    let support = UberSupport()
                    support.removeProgressInWindow()
                    self.commonAlert.setupAlert(alert: LangCommon.successFullyUpdated,
                                                okAction: LangCommon.ok)
                    self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                        self.exitScreen(animated: true) {
                            Shared.instance.currentBookingType = .bookNow
                            NotificationEnum.completedTripHistory.postNotification()
                        }
                    }
                } else {
                    let support = UberSupport()
                    support.removeProgressInWindow()
                    print("ååååå : Something Went Wrong")
                }
            case .failure(_):
                let support = UberSupport()
                support.removeProgressInWindow()
                print("ååå : Error \(self.nibName ?? "")")
            }
        }
    }
}
