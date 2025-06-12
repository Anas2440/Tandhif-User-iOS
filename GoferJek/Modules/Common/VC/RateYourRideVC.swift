//
//  RateYourRideVC.swift
//  GoferHandy
//
//  Created by trioangle on 21/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

import UIKit

class RateYourRideVC: BaseViewController {
    
    //----------------------------------------------------
    // MARK: - outlets
    //----------------------------------------------------
    
    @IBOutlet var rateYourRideView : RateYourRideView!
    
    //----------------------------------------------------
    // MARK: - Local Variable
    //----------------------------------------------------
    
    var userName : String?
    var userImage_thumb : String?
    var isFromRoutePage : Bool = false
    var isFromTripPage : Bool = false
    var jobId : String  = ""
    
    //----------------------------------------------------
    // MARK: - ViewController Methods
    //----------------------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.getJobDetails()
    }
    
    override
    func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override
    var stopSwipeExitFromThisScreen: Bool?{
        return true
    }
    
    //----------------------------------------------------
    //MARK: - API CALL -> SUBMIT RATING
    //----------------------------------------------------
    
    func getJobDetails() {
        if !jobId.isEmpty {
            let params = ["job_id":self.jobId]
            ConnectionHandler.shared
                .getRequest(
                    for: .getJobDetail,
                    params: params).responseJSON { (json) in
                        if json.status_code != 0 {
                            print(json.status_message)
                        } else {
                            print(json.status_message)
                        }
                    }.responseFailure { (error) in
                        print("Error : \(error)")
                    }
        }
    }
    
    func updateRatingToApi(comment: String,rating: Int) {
        let paramDict : JSON =  ["job_id" : (self.jobId ).description,
                                 "rating" : String(format: "%d", rating),
                                 "rating_comments" : comment,
                                 "user_type" : "User"]
        ConnectionHandler.shared
            .getRequest(
                for: .jobRating,
                params: paramDict)
            .responseJSON { (json) in
                if json.status_code == 1 {
                    self.setRootVC()
                } else if json.status_code == 2 {
                    AppDelegate.shared.makeSplashView(isFirstTime: true)
                    AppDelegate.shared.createToastMessage(json.status_message)
                    self.rateYourRideView.onBackTapped(nil)
                } else {
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            }.responseFailure { (error) in
//                AppDelegate.shared.createToastMessage(error)
            }
    }
    
    //----------------------------------------------------
    //MARK:- initWithStory
    //----------------------------------------------------
    
    class func initWithStory(jobId: String ,
                             userName:String? = nil,
                             userImage:String? = nil) -> RateYourRideVC {
        let view : RateYourRideVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.jobId = jobId
        view.userName = userName
        view.userImage_thumb = userImage
        return view
    }
    
    
}


